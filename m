Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBC9FC433FE
	for <linux-trace-devel@archiver.kernel.org>; Sun,  7 Nov 2021 18:18:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9746361352
	for <linux-trace-devel@archiver.kernel.org>; Sun,  7 Nov 2021 18:18:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236065AbhKGSVh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 7 Nov 2021 13:21:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:59642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235313AbhKGSVh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 7 Nov 2021 13:21:37 -0500
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7576161284;
        Sun,  7 Nov 2021 18:18:53 +0000 (UTC)
Date:   Sun, 7 Nov 2021 13:18:50 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     mhiramat@kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 02/10] user_events: Add minimal support for
 trace_event into ftrace
Message-ID: <20211107131850.19021b4e@rorschach.local.home>
In-Reply-To: <20211104170433.2206-3-beaub@linux.microsoft.com>
References: <20211104170433.2206-1-beaub@linux.microsoft.com>
        <20211104170433.2206-3-beaub@linux.microsoft.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu,  4 Nov 2021 10:04:25 -0700
Beau Belgrave <beaub@linux.microsoft.com> wrote:
> index 000000000000..a68017ad7fdd
> --- /dev/null
> +++ b/kernel/trace/trace_events_user.c
> @@ -0,0 +1,1140 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2021, Microsoft Corporation.
> + *
> + * Authors:
> + *   Beau Belgrave <beaub@linux.microsoft.com>
> + */
> +
> +#include <linux/bitmap.h>
> +#include <linux/cdev.h>
> +#include <linux/hashtable.h>
> +#include <linux/list.h>
> +#include <linux/io.h>
> +#include <linux/uio.h>
> +#include <linux/ioctl.h>
> +#include <linux/jhash.h>
> +#include <linux/trace_events.h>
> +#include <linux/tracefs.h>
> +#include <linux/types.h>
> +#include <linux/uaccess.h>
> +#include <uapi/linux/user_events.h>
> +#include "trace.h"
> +#include "trace_dynevent.h"
> +
> +#define USER_EVENTS_PREFIX_LEN (sizeof(USER_EVENTS_PREFIX)-1)
> +
> +#define FIELD_DEPTH_TYPE 0
> +#define FIELD_DEPTH_NAME 1
> +#define FIELD_DEPTH_SIZE 2
> +
> +/*
> + * Limits how many trace_event calls user processes can create:
> + * Must be multiple of PAGE_SIZE.
> + */
> +#define MAX_PAGES 1
> +#define MAX_EVENTS (MAX_PAGES * PAGE_SIZE)
> +
> +/* Limit how long of an event name plus args within the subsystem. */
> +#define MAX_EVENT_DESC 512
> +#define EVENT_NAME(user_event) ((user_event)->tracepoint.name)
> +
> +static char *register_page_data;
> +
> +static DEFINE_MUTEX(reg_mutex);
> +static DEFINE_HASHTABLE(register_table, 4);
> +static DECLARE_BITMAP(page_bitmap, MAX_EVENTS);
> +
> +struct user_event {
> +	struct tracepoint tracepoint;
> +	struct trace_event_call call;
> +	struct trace_event_class class;
> +	struct dyn_event devent;
> +	struct hlist_node node;
> +	struct list_head fields;
> +	atomic_t refcnt;
> +	int index;
> +	int flags;
> +};
> +
> +struct user_event_refs {
> +	struct rcu_head rcu;
> +	int count;
> +	struct user_event *events[];
> +};
> +
> +typedef void (*user_event_func_t) (struct user_event *user,
> +				   void *data, u32 datalen,
> +				   void *tpdata);
> +
> +static int user_event_parse(char *name, char *args, char *flags,
> +			    struct user_event **newuser);
> +
> +static u32 user_event_key(char *name)
> +{
> +	return jhash(name, strlen(name), 0);
> +}
> +
> +static struct list_head *user_event_get_fields(struct trace_event_call *call)
> +{
> +	struct user_event *user = (struct user_event *)call->data;
> +
> +	return &user->fields;
> +}
> +
> +/*
> + * Parses a register command for user_events
> + * Format: event_name[:FLAG1[,FLAG2...]] [field1[;field2...]]
> + *
> + * Example event named test with a 20 char msg field with a unsigned int after:
> + * test char[20] msg;unsigned int id
> + *
> + * NOTE: Offsets are from the user data perspective, they are not from the
> + * trace_entry/buffer perspective. We automatically add the common properties
> + * sizes to the offset for the user.
> + */
> +static int user_event_parse_cmd(char *raw_command, struct user_event **newuser)
> +{
> +	char *name = raw_command;
> +	char *args = strpbrk(name, " ");
> +	char *flags;
> +
> +	if (args)
> +		*args++ = 0;
> +
> +	flags = strpbrk(name, ":");
> +
> +	if (flags)
> +		*flags++ = 0;
> +
> +	return user_event_parse(name, args, flags, newuser);
> +}
> +
> +static int user_field_array_size(const char *type)
> +{
> +	const char *start = strchr(type, '[');
> +	int size = 0;
> +
> +	if (start == NULL)
> +		return -EINVAL;
> +
> +	start++;
> +
> +	while (*start >= '0' && *start <= '9')

The kernel has include/linux/ctype.h

	while (isdigit(*start))

> +		size = (size * 10) + (*start++ - '0');

So you only allow decimal digits? No hex?

Also, is there anything to check if the size overflows?

I'm assuming that other patches will add checking if the size is
greater than some amount?

> +
> +	if (*start != ']')
> +		return -EINVAL;
> +
> +	return size;
> +}
> +
> +static int user_field_size(const char *type)
> +{
> +	/* long is not allowed from a user, since it's ambigious in size */
> +	if (strcmp(type, "s64") == 0)
> +		return sizeof(s64);
> +	if (strcmp(type, "u64") == 0)
> +		return sizeof(u64);
> +	if (strcmp(type, "s32") == 0)
> +		return sizeof(s32);
> +	if (strcmp(type, "u32") == 0)
> +		return sizeof(u32);
> +	if (strcmp(type, "int") == 0)
> +		return sizeof(int);
> +	if (strcmp(type, "unsigned int") == 0)
> +		return sizeof(unsigned int);
> +	if (strcmp(type, "s16") == 0)
> +		return sizeof(s16);
> +	if (strcmp(type, "u16") == 0)
> +		return sizeof(u16);
> +	if (strcmp(type, "short") == 0)
> +		return sizeof(short);
> +	if (strcmp(type, "unsigned short") == 0)
> +		return sizeof(unsigned short);
> +	if (strcmp(type, "s8") == 0)
> +		return sizeof(s8);
> +	if (strcmp(type, "u8") == 0)
> +		return sizeof(u8);
> +	if (strcmp(type, "char") == 0)
> +		return sizeof(char);
> +	if (strcmp(type, "unsigned char") == 0)
> +		return sizeof(unsigned char);
> +	if (strstr(type, "char[") == type)
> +		return user_field_array_size(type);
> +	if (strstr(type, "unsigned char[") == type)
> +		return user_field_array_size(type);
> +	if (strstr(type, "__data_loc ") == type)
> +		return sizeof(u32);
> +	if (strstr(type, "__rel_loc ") == type)
> +		return sizeof(u32);
> +
> +	/* Uknown basic type, error */
> +	return -EINVAL;
> +}
> +
> +static void user_event_destroy_fields(struct user_event *user)
> +{
> +	struct ftrace_event_field *field, *next;
> +	struct list_head *head = &user->fields;
> +
> +	list_for_each_entry_safe(field, next, head, link) {
> +		list_del(&field->link);
> +		kfree(field);
> +	}
> +}
> +
> +static int user_event_add_field(struct user_event *user, const char *type,
> +				const char *name, int offset, int size,
> +				int is_signed, int filter_type)
> +{
> +	struct ftrace_event_field *field;
> +
> +	field = kmalloc(sizeof(*field), GFP_KERNEL);
> +
> +	if (!field)
> +		return -ENOMEM;
> +
> +	field->type = type;
> +	field->name = name;
> +	field->offset = offset;
> +	field->size = size;
> +	field->is_signed = is_signed;
> +	field->filter_type = filter_type;
> +
> +	list_add(&field->link, &user->fields);
> +
> +	return 0;
> +}
> +
> +/*
> + * Parses the values of a field within the description
> + * Format: type name [size]
> + */
> +static int user_event_parse_field(char *field, struct user_event *user,
> +				  u32 *offset)
> +{
> +	char *part, *type, *name;
> +	u32 depth = 0, saved_offset = *offset;
> +	int size = -EINVAL;
> +	bool is_struct = false;
> +
> +	field = skip_spaces(field);
> +
> +	if (*field == 0)
> +		return 0;
> +
> +	/* Handle types that have a space within */
> +	if (strstr(field, "unsigned ") == field) {

These should use str_has_prefix(field, "unsigned ") etc.

It also returns the length of the prefix so you don't need to add
sizeof() of the string you checked for.


> +		type = field;
> +		field = strpbrk(field + sizeof("unsigned"), " ");
> +		goto skip_next;
> +	} else if (strstr(field, "struct ") == field) {
> +		type = field;
> +		field = strpbrk(field + sizeof("struct"), " ");
> +		is_struct = true;
> +		goto skip_next;
> +	} else if (strstr(field, "__data_loc unsigned ") == field) {
> +		type = field;
> +		field = strpbrk(field + sizeof("__data_loc unsigned"), " ");
> +		goto skip_next;
> +	} else if (strstr(field, "__data_loc ") == field) {
> +		type = field;
> +		field = strpbrk(field + sizeof("__data_loc"), " ");
> +		goto skip_next;
> +	} else if (strstr(field, "__rel_loc unsigned ") == field) {
> +		type = field;
> +		field = strpbrk(field + sizeof("__rel_loc unsigned"), " ");
> +		goto skip_next;
> +	} else if (strstr(field, "__rel_loc ") == field) {
> +		type = field;
> +		field = strpbrk(field + sizeof("__rel_loc"), " ");
> +		goto skip_next;
> +	}
> +	goto parse;
> +skip_next:
> +	if (field == NULL)
> +		return -EINVAL;
> +
> +	*field++ = 0;
> +	depth++;
> +parse:
> +	while ((part = strsep(&field, " ")) != NULL) {
> +		switch (depth++) {
> +		case FIELD_DEPTH_TYPE:
> +			type = part;
> +			break;
> +		case FIELD_DEPTH_NAME:
> +			name = part;
> +			break;
> +		case FIELD_DEPTH_SIZE:
> +			if (!is_struct)
> +				return -EINVAL;
> +
> +			if (kstrtou32(part, 10, &size))
> +				return -EINVAL;
> +			break;
> +		default:
> +			return -EINVAL;
> +		}
> +	}
> +
> +	if (depth < FIELD_DEPTH_SIZE)
> +		return -EINVAL;
> +
> +	if (depth == FIELD_DEPTH_SIZE)
> +		size = user_field_size(type);
> +
> +	if (size == 0)
> +		return -EINVAL;
> +
> +	if (size < 0)
> +		return size;
> +
> +	*offset = saved_offset + size;
> +
> +	return user_event_add_field(user, type, name, saved_offset, size,
> +				    type[0] != 'u', FILTER_OTHER);
> +}
> +
> +static void user_event_parse_flags(struct user_event *user, char *flags)
> +{
> +	char *flag;
> +
> +	if (flags == NULL)
> +		return;
> +
> +	while ((flag = strsep(&flags, ",")) != NULL) {
> +		if (strcmp(flag, "BPF_ITER") == 0)
> +			user->flags |= FLAG_BPF_ITER;
> +	}
> +}
> +
> +static int user_event_parse_fields(struct user_event *user, char *args)
> +{
> +	char *field;
> +	u32 offset = sizeof(struct trace_entry);
> +	int ret = -EINVAL;
> +
> +	if (args == NULL)
> +		return 0;
> +
> +	while ((field = strsep(&args, ";")) != NULL) {
> +		ret = user_event_parse_field(field, user, &offset);
> +
> +		if (ret)
> +			break;
> +	}
> +
> +	return ret;
> +}
> +
> +static struct trace_event_fields user_event_fields_array[] = {
> +	{}
> +};

Isn't the above just a fancy way of writing:

static struct trace_event_fields user_event_fields_array[1];

?

> +
> +static enum print_line_t user_event_print_trace(struct trace_iterator *iter,
> +						int flags,
> +						struct trace_event *event)
> +{
> +	/* Unsafe to try to decode user provided print_fmt, use hex */
> +	trace_print_hex_dump_seq(&iter->seq, "", DUMP_PREFIX_OFFSET, 16,
> +				 1, iter->ent, iter->ent_size, true);

Hmm, I need to look at this when I have time to apply the patches. (On
weekends, I only look at the patches) I'm adding this to remind me to
relook at this. ;-)

> +
> +	return trace_handle_return(&iter->seq);
> +}
> +
> +static struct trace_event_functions user_event_funcs = {
> +	.trace = user_event_print_trace,
> +};
> +
> +static int destroy_user_event(struct user_event *user)
> +{
> +	int ret = 0;
> +
> +	/* Must destroy fields before call removal */
> +	user_event_destroy_fields(user);
> +
> +	ret = trace_remove_event_call(&user->call);
> +
> +	if (ret)
> +		return ret;
> +
> +	dyn_event_remove(&user->devent);
> +
> +	register_page_data[user->index] = 0;
> +	clear_bit(user->index, page_bitmap);
> +	hash_del(&user->node);
> +
> +	kfree(EVENT_NAME(user));
> +	kfree(user);
> +
> +	return ret;
> +}
> +
> +static struct user_event *find_user_event(char *name, u32 *outkey)
> +{
> +	struct user_event *user;
> +	u32 key = user_event_key(name);
> +
> +	*outkey = key;
> +
> +	hash_for_each_possible(register_table, user, node, key)
> +		if (!strcmp(EVENT_NAME(user), name))
> +			return user;
> +
> +	return NULL;
> +}
> +
> +/*
> + * Writes the user supplied payload out to a trace file.
> + */
> +static void user_event_ftrace(struct user_event *user, void *data, u32 datalen,
> +			      void *tpdata)
> +{
> +	struct trace_event_file *file;
> +	struct trace_entry *entry;
> +	struct trace_event_buffer event_buffer;
> +
> +	file = (struct trace_event_file *)tpdata;
> +
> +	if (!file ||
> +	    !(file->flags & EVENT_FILE_FL_ENABLED) ||
> +	    trace_trigger_soft_disabled(file))
> +		return;
> +
> +	entry = trace_event_buffer_reserve(&event_buffer, file,
> +					   sizeof(*entry) + datalen);
> +
> +	if (unlikely(!entry))
> +		return;
> +

Might want to add a comment here that the trace_event_buffer_reserve()
will fill in the struct trace_entry, which explains the "entry+1" below.

I also need to add comments to trace_event_buffer_reserve() that it does so :-p

> +	memcpy(entry + 1, data, datalen);
> +
> +	trace_event_buffer_commit(&event_buffer);
> +}
> +
> +/*
> + * Update the register page that is shared between user processes.
> + */
> +static void update_reg_page_for(struct user_event *user)
> +{
> +	struct tracepoint *tp = &user->tracepoint;
> +	char status = 0;
> +
> +	if (atomic_read(&tp->key.enabled) > 0) {
> +		struct tracepoint_func *probe_func_ptr;
> +		user_event_func_t probe_func;
> +
> +		rcu_read_lock_sched();
> +
> +		probe_func_ptr = rcu_dereference_sched(tp->funcs);
> +
> +		if (probe_func_ptr) {
> +			do {
> +				probe_func = probe_func_ptr->func;
> +
> +				if (probe_func == user_event_ftrace)
> +					status |= EVENT_STATUS_FTRACE;
> +				else
> +					status |= EVENT_STATUS_OTHER;
> +			} while ((++probe_func_ptr)->func);
> +		}
> +
> +		rcu_read_unlock_sched();
> +	}
> +
> +	register_page_data[user->index] = status;

Should there be some kind of memory barriers here? That is, isn't this
the page that user space sees? The user space code should probably have
some kind of read memory barrier as well.

> +}
> +
> +/*
> + * Register callback for our events from tracing sub-systems.
> + */
> +static int user_event_reg(struct trace_event_call *call,
> +			  enum trace_reg type,
> +			  void *data)
> +{
> +	struct user_event *user = (struct user_event *)call->data;
> +	int ret = 0;
> +
> +	if (!user)
> +		return -ENOENT;
> +
> +	switch (type) {
> +	case TRACE_REG_REGISTER:
> +		ret = tracepoint_probe_register(call->tp,
> +						call->class->probe,
> +						data);
> +		if (!ret)
> +			goto inc;
> +		break;
> +
> +	case TRACE_REG_UNREGISTER:
> +		tracepoint_probe_unregister(call->tp,
> +					    call->class->probe,
> +					    data);
> +		goto dec;
> +
> +#ifdef CONFIG_PERF_EVENTS
> +	case TRACE_REG_PERF_REGISTER:
> +	case TRACE_REG_PERF_UNREGISTER:
> +	case TRACE_REG_PERF_OPEN:
> +	case TRACE_REG_PERF_CLOSE:
> +	case TRACE_REG_PERF_ADD:
> +	case TRACE_REG_PERF_DEL:
> +		break;
> +#endif
> +	}
> +
> +	return ret;
> +inc:
> +	atomic_inc(&user->refcnt);
> +	update_reg_page_for(user);
> +	return 0;
> +dec:
> +	update_reg_page_for(user);
> +	atomic_dec(&user->refcnt);
> +	return 0;
> +}
> +
> +static int user_event_create(const char *raw_command)
> +{
> +	struct user_event *user;
> +	char *name;
> +	int ret;
> +
> +	if (strstr(raw_command, USER_EVENTS_PREFIX) != raw_command)
> +		return -ECANCELED;
> +
> +	raw_command += USER_EVENTS_PREFIX_LEN;
> +	raw_command = skip_spaces(raw_command);
> +
> +	name = kstrdup(raw_command, GFP_KERNEL);

name is allocated here, it really needs to be freed in this function as
well. I see that user_event_parse() will free it, but that is extremely
error prone to have a dependency like that. If name needs to be saved
by user_event_parse_cmd() then that should be shown in the return value
of that function. And if it fails the freeing of name should be in this
function. Also, if it is saved, then there should be a comment in this
function stating that.

> +
> +	if (!name)
> +		return -ENOMEM;
> +
> +	mutex_lock(&reg_mutex);
> +	ret = user_event_parse_cmd(name, &user);
> +	mutex_unlock(&reg_mutex);
> +
> +	return ret;
> +}
> +
> +static int user_event_show(struct seq_file *m, struct dyn_event *ev)
> +{
> +	struct user_event *user = container_of(ev, struct user_event, devent);
> +	struct ftrace_event_field *field, *next;
> +	struct list_head *head;
> +	int depth = 0;
> +
> +	seq_printf(m, "%s%s", USER_EVENTS_PREFIX, EVENT_NAME(user));
> +
> +	head = trace_get_fields(&user->call);
> +
> +	list_for_each_entry_safe_reverse(field, next, head, link) {
> +		if (depth == 0)
> +			seq_puts(m, " ");
> +		else
> +			seq_puts(m, "; ");
> +		seq_printf(m, "%s %s", field->type, field->name);
> +		depth++;
> +	}
> +
> +	seq_puts(m, "\n");
> +
> +	return 0;
> +}
> +
> +static bool user_event_is_busy(struct dyn_event *ev)
> +{
> +	struct user_event *user = container_of(ev, struct user_event, devent);
> +
> +	return atomic_read(&user->refcnt) != 0;
> +}
> +
> +static int user_event_free(struct dyn_event *ev)
> +{
> +	struct user_event *user = container_of(ev, struct user_event, devent);
> +

Shouldn't this check if the event is busy first?

> +	return destroy_user_event(user);
> +}
> +
> +static bool user_event_match(const char *system, const char *event,
> +			     int argc, const char **argv, struct dyn_event *ev)
> +{
> +	struct user_event *user = container_of(ev, struct user_event, devent);
> +
> +	return strcmp(EVENT_NAME(user), event) == 0 &&
> +		(!system || strcmp(system, USER_EVENTS_SYSTEM) == 0);
> +}
> +
> +static struct dyn_event_operations user_event_dops = {
> +	.create = user_event_create,
> +	.show = user_event_show,
> +	.is_busy = user_event_is_busy,
> +	.free = user_event_free,
> +	.match = user_event_match,
> +};
> +
> +static int user_event_trace_register(struct user_event *user)
> +{
> +	int ret;
> +
> +	ret = register_trace_event(&user->call.event);
> +
> +	if (!ret)
> +		return -ENODEV;
> +
> +	ret = trace_add_event_call(&user->call);
> +
> +	if (ret)
> +		unregister_trace_event(&user->call.event);
> +
> +	return ret;
> +}
> +
> +/*
> + * Parses the event name, arguments and flags then registers if successful.
> + */
> +static int user_event_parse(char *name, char *args, char *flags,
> +			    struct user_event **newuser)
> +{
> +	int ret;
> +	int index;
> +	u32 key;
> +	struct user_event *user = find_user_event(name, &key);
> +
> +	if (user) {
> +		*newuser = user;
> +		ret = 0;
> +		goto put_name;
> +	}
> +
> +	index = find_first_zero_bit(page_bitmap, MAX_EVENTS);
> +
> +	if (index == MAX_EVENTS) {
> +		ret = -EMFILE;
> +		goto put_name;
> +	}
> +
> +	user = kzalloc(sizeof(*user), GFP_KERNEL);
> +
> +	if (!user) {
> +		ret = -ENOMEM;
> +		goto put_name;
> +	}
> +
> +	INIT_LIST_HEAD(&user->class.fields);
> +	INIT_LIST_HEAD(&user->fields);
> +
> +	user->tracepoint.name = name;
> +
> +	user_event_parse_flags(user, flags);
> +
> +	ret = user_event_parse_fields(user, args);
> +
> +	if (ret)
> +		goto put_user;
> +
> +	/* Minimal print format */
> +	user->call.print_fmt = "\"\"";
> +
> +	user->call.data = user;
> +	user->call.class = &user->class;
> +	user->call.name = name;
> +	user->call.flags = TRACE_EVENT_FL_TRACEPOINT;
> +	user->call.tp = &user->tracepoint;
> +	user->call.event.funcs = &user_event_funcs;
> +
> +	user->class.system = USER_EVENTS_SYSTEM;
> +	user->class.fields_array = user_event_fields_array;
> +	user->class.get_fields = user_event_get_fields;
> +	user->class.reg = user_event_reg;
> +	user->class.probe = user_event_ftrace;
> +
> +	mutex_lock(&event_mutex);
> +	ret = user_event_trace_register(user);
> +	mutex_unlock(&event_mutex);
> +
> +	if (ret)
> +		goto put_user;
> +
> +	user->index = index;
> +	dyn_event_init(&user->devent, &user_event_dops);
> +	dyn_event_add(&user->devent);
> +	set_bit(user->index, page_bitmap);
> +	hash_add(register_table, &user->node, key);
> +
> +	*newuser = user;
> +	return 0;
> +put_user:
> +	user_event_destroy_fields(user);
> +	kfree(user);
> +put_name:
> +	kfree(name);
> +	return ret;
> +}
> +
> +/*
> + * Deletes a previously created event if it is no longer being used.
> + */
> +static int delete_user_event(char *name)
> +{
> +	u32 key;
> +	int ret;
> +	struct user_event *user = find_user_event(name, &key);
> +
> +	if (!user)
> +		return -ENOENT;
> +
> +	if (atomic_read(&user->refcnt) != 0)
> +		return -EBUSY;
> +
> +	mutex_lock(&event_mutex);
> +	ret = destroy_user_event(user);
> +	mutex_unlock(&event_mutex);
> +
> +	return ret;
> +}
> +
> +/*
> + * Validates the user payload and writes via iterator.
> + */
> +static ssize_t user_events_write_core(struct file *file, struct iov_iter *i)
> +{
> +	struct user_event_refs *refs;
> +	struct user_event *user = NULL;
> +	struct tracepoint *tp;
> +	ssize_t ret = i->count;
> +	int idx;
> +
> +	if (unlikely(copy_from_iter(&idx, sizeof(idx), i) != sizeof(idx)))
> +		return -EFAULT;
> +
> +	rcu_read_lock_sched();
> +
> +	refs = rcu_dereference_sched(file->private_data);
> +
> +	if (likely(refs && idx < refs->count))
> +		user = refs->events[idx];
> +
> +	rcu_read_unlock_sched();
> +
> +	if (unlikely(user == NULL))
> +		return -ENOENT;
> +
> +	tp = &user->tracepoint;

What protects user here? You released the rcu lock.

> +
> +	if (likely(atomic_read(&tp->key.enabled) > 0)) {
> +		struct tracepoint_func *probe_func_ptr;
> +		user_event_func_t probe_func;
> +		void *tpdata;
> +		void *kdata;
> +		u32 datalen;
> +
> +		kdata = kmalloc(i->count, GFP_KERNEL);

The allocation would need to be done first, before grabbing the rcu
lock, and all this would need to be done within the rcu lock, because
"tp" may not even exist anymore.

> +
> +		if (unlikely(!kdata))
> +			return -ENOMEM;
> +
> +		datalen = copy_from_iter(kdata, i->count, i);
> +
> +		rcu_read_lock_sched();
> +
> +		probe_func_ptr = rcu_dereference_sched(tp->funcs);
> +
> +		if (probe_func_ptr) {
> +			do {
> +				probe_func = probe_func_ptr->func;
> +				tpdata = probe_func_ptr->data;
> +				probe_func(user, kdata, datalen, tpdata);
> +			} while ((++probe_func_ptr)->func);
> +		}
> +
> +		rcu_read_unlock_sched();
> +
> +		kfree(kdata);
> +	}
> +
> +	return ret;
> +}
> +
> +static ssize_t user_events_write(struct file *file, const char __user *ubuf,
> +				 size_t count, loff_t *ppos)
> +{
> +	struct iovec iov;
> +	struct iov_iter i;
> +
> +	if (unlikely(*ppos != 0))
> +		return -EFAULT;
> +
> +	if (unlikely(import_single_range(READ, (char *)ubuf, count, &iov, &i)))
> +		return -EFAULT;
> +
> +	return user_events_write_core(file, &i);
> +}
> +
> +static ssize_t user_events_write_iter(struct kiocb *kp, struct iov_iter *i)
> +{
> +	return user_events_write_core(kp->ki_filp, i);
> +}
> +
> +static int user_events_ref_add(struct file *file, struct user_event *user)
> +{
> +	struct user_event_refs *refs, *new_refs;
> +	int i, size, count = 0;
> +
> +	rcu_read_lock_sched();

rcu lock is not needed, but you may want to use:

  rcu_dereference_protected()

and list the lock that protects the modifications here.

> +	refs = rcu_dereference_sched(file->private_data);
> +	rcu_read_unlock_sched();
> +
> +	if (refs) {
> +		count = refs->count;
> +
> +		for (i = 0; i < count; ++i)
> +			if (refs->events[i] == user)
> +				return i;
> +	}
> +
> +	size = sizeof(*refs) + (sizeof(struct user_event *) * (count + 1));
> +
> +	new_refs = kzalloc(size, GFP_KERNEL);
> +
> +	if (!new_refs)
> +		return -ENOMEM;
> +
> +	new_refs->count = count + 1;
> +
> +	for (i = 0; i < count; ++i)
> +		new_refs->events[i] = refs->events[i];
> +
> +	new_refs->events[i] = user;
> +
> +	atomic_inc(&user->refcnt);
> +
> +	rcu_assign_pointer(file->private_data, new_refs);
> +
> +	if (refs)
> +		kfree_rcu(refs, rcu);
> +
> +	return i;
> +}

I just skimmed the rest, and didn't see anything that stuck out.

But maybe I'll get time to look deeper at it later.

-- Steve

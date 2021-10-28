Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D2B1C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Oct 2021 21:41:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3591B610CA
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Oct 2021 21:41:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbhJ1Vno (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Oct 2021 17:43:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:57670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231206AbhJ1Vnn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Oct 2021 17:43:43 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDA6160F9C;
        Thu, 28 Oct 2021 21:41:15 +0000 (UTC)
Date:   Thu, 28 Oct 2021 17:41:13 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 01/12] libtracefs: Add new internal APIs for dynamic
 events
Message-ID: <20211028174113.134ae7ce@gandalf.local.home>
In-Reply-To: <20211028120907.101847-2-tz.stoyanov@gmail.com>
References: <20211028120907.101847-1-tz.stoyanov@gmail.com>
 <20211028120907.101847-2-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 28 Oct 2021 15:08:56 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Ftrace supports dynamic events, created by the user - kprobes, uprobes,
> eprobes and synthetic events. There are two interfaces for managing
> these events - new common "dynamic_events" file and event specific
> "kprobe_events", "uprobe_events", "synthetic_events" files. The
> configuration syntax for all dynamic events is almost the same.
> To simplify support of dynamic events in thw tracefs library, a new
> internal helper layer is implemented. It handles both configuration
> interfaces - the common "dynamic_events" file is preferred, if
> available. On the old kernels, where this file is missing, the event
> specific files are used. The new helper layer can be used to create,
> delete and get ftrace dynamic events form any type. Most of the APIs
> are internal, not exposed to the library users. Only one API is exposed
> publicly:
>  tracefs_dynevent_list_free()
> This new logic is designed to be used internally within the library,
> from the APIs that implement kprobes, uprobes, eprobes and synthetic
> events support.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  include/tracefs-local.h |  34 +++
>  include/tracefs.h       |   3 +
>  src/Makefile            |   1 +
>  src/tracefs-dynevents.c | 463 ++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 501 insertions(+)
>  create mode 100644 src/tracefs-dynevents.c
> 
> diff --git a/include/tracefs-local.h b/include/tracefs-local.h
> index 684eccf..f15896f 100644
> --- a/include/tracefs-local.h
> +++ b/include/tracefs-local.h
> @@ -94,4 +94,38 @@ int synth_add_start_field(struct tracefs_synth *synth,
>  			  const char *start_field,
>  			  const char *name,
>  			  enum tracefs_hist_key_type type);
> +
> +/* Internal interface for ftrace dynamic events */
> +#define DYNEVENT_ADD_BIT(M, B)		((M) |= (1ULL<<(B)))
> +#define DYNEVENT_CHECK_BIT(M, B)	((M)&(1ULL<<(B)))

The above macros are generic enough that they don't need DYNEVENT in the
name. Just call them:

#define SET_BIT(M, B)		do { (M) |= (1ULL << (B)); } while (0)
#define TEST_BIT(M, B)		((M) & (1ULL << (B)))

And might as well add for completeness:

#define CLEAR_BIT(M,B)		do { (M) &= (1ULL << (B)); } while (0)

It is common to use the terminology of "set,clear,test" for bitmasks. Also,
it is best to add the "do { } while (0)" notation for code, as that helps
with some side effects macros can have.


> +
> +enum trace_dynevent_type {
> +	TRACE_DYNEVENT_KPROBE = 0,

No real need for the "= 0" but I'm OK if you want to leave it in. That's
because the C standard states that the first enum is zero.

> +	TRACE_DYNEVENT_KRETPROBE,
> +	TRACE_DYNEVENT_UPROBE,
> +	TRACE_DYNEVENT_URETPROBE,
> +	TRACE_DYNEVENT_EPROBE,
> +	TRACE_DYNEVENT_SYNTH,
> +	TRACE_DYNEVENT_MAX,
> +};
> +
> +struct tracefs_dynevent {
> +	char *trace_file;
> +	char *prefix;
> +	char *system;
> +	char *event;
> +	char *address;
> +	char *format;
> +	enum trace_dynevent_type type;
> +};
> +
> +struct tracefs_dynevent *
> +dynevent_alloc(enum trace_dynevent_type type, const char *system,
> +	       const char *event, const char *address, const char *format);
> +void dynevent_free(struct tracefs_dynevent *devent);
> +int dynevent_create(struct tracefs_dynevent *devent);
> +int dynevent_destroy(struct tracefs_dynevent *devent);
> +int dynevent_get_all(unsigned long type_mask, const char *system,
> +		     struct tracefs_dynevent ***ret_events);

I usually prefer to have a list returned, and NULL on error, instead of
passing it in by reference. The "***" gets a bit out of hand.


> +
>  #endif /* _TRACE_FS_LOCAL_H */
> diff --git a/include/tracefs.h b/include/tracefs.h
> index a2cda30..4020551 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -238,6 +238,9 @@ ssize_t tracefs_trace_pipe_stream(int fd, struct tracefs_instance *instance, int
>  ssize_t tracefs_trace_pipe_print(struct tracefs_instance *instance, int flags);
>  void tracefs_trace_pipe_stop(struct tracefs_instance *instance);
>  
> +struct tracefs_dynevent;
> +void tracefs_dynevent_list_free(struct tracefs_dynevent ***events);

Why are you passing in the address?

Just use: struct tracefs_dynevent **events

If it is to be consistent with the get_all() then that's another reason to
not pass it in as a parameter. That would be like:

 int malloc(int size, void **m);

and

  void free(void **m)


> +
>  enum tracefs_kprobe_type {
>  	TRACEFS_ALL_KPROBES,
>  	TRACEFS_KPROBE,
> diff --git a/src/Makefile b/src/Makefile
> index 4e38d98..99cd7da 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -11,6 +11,7 @@ OBJS += tracefs-marker.o
>  OBJS += tracefs-kprobes.o
>  OBJS += tracefs-hist.o
>  OBJS += tracefs-filter.o
> +OBJS += tracefs-dynevents.o
>  
>  # Order matters for the the three below
>  OBJS += sqlhist-lex.o
> diff --git a/src/tracefs-dynevents.c b/src/tracefs-dynevents.c
> new file mode 100644
> index 0000000..68ee95a
> --- /dev/null
> +++ b/src/tracefs-dynevents.c
> @@ -0,0 +1,463 @@
> +// SPDX-License-Identifier: LGPL-2.1
> +/*
> + * Copyright (C) 2021 VMware Inc, Steven Rostedt <rostedt@goodmis.org>
> + *
> + * Updates:
> + * Copyright (C) 2021, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
> + *
> + */
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <dirent.h>
> +#include <unistd.h>
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <limits.h>
> +
> +#include "tracefs.h"
> +#include "tracefs-local.h"
> +
> +#define DYNEVENTS_EVENTS "dynamic_events"
> +#define KPROBE_EVENTS "kprobe_events"
> +#define UPROBE_EVENTS "uprobe_events"
> +#define SYNTH_EVENTS "synthetic_events"
> +#define DYNEVENTS_DEFAULT_GROUP "dynamic"
> +#define RETPROBE_DEFAUL_PREFIX	"r:"
> +
> +struct dyn_events_desc;
> +static int dyn_generic_parse(struct dyn_events_desc *,
> +			     const char *, char *, struct tracefs_dynevent **);
> +static int dyn_synth_parse(struct dyn_events_desc *,
> +			   const char *, char *, struct tracefs_dynevent **);
> +static int dyn_generic_del(struct dyn_events_desc *, struct tracefs_dynevent *);
> +static int dyn_synth_del(struct dyn_events_desc *, struct tracefs_dynevent *);
> +
> +struct dyn_events_desc {
> +	enum trace_dynevent_type type;
> +	const char *file;
> +	const char *prefix;
> +	int (*dyn_events_del)(struct dyn_events_desc *desc, struct tracefs_dynevent *dyn);
> +	int (*dyn_events_parse)(struct dyn_events_desc *desc, const char *group,
> +				char *line, struct tracefs_dynevent **ret_dyn);
> +} dynevents[TRACE_DYNEVENT_MAX] = {

You don't need the TRACE_DYNEVENT_MAX. Just have:

 } dynevents[] = {

And the compiler will fill in the rest.

We could add somewhere in the code:

	BUILD_BUG_ON(ARRAY_SIZE(dynevents) != TRACE_DYNEVENT_MAX);

to make sure all are accounted for.

> +	{TRACE_DYNEVENT_KPROBE, NULL, "p:", dyn_generic_del, dyn_generic_parse},
> +	{TRACE_DYNEVENT_KRETPROBE, NULL, "r", dyn_generic_del, dyn_generic_parse},
> +	{TRACE_DYNEVENT_UPROBE, NULL, "p:", dyn_generic_del, dyn_generic_parse},
> +	{TRACE_DYNEVENT_URETPROBE, NULL, "r", dyn_generic_del, dyn_generic_parse},
> +	{TRACE_DYNEVENT_EPROBE, NULL, "e:", dyn_generic_del, dyn_generic_parse},
> +	{TRACE_DYNEVENT_SYNTH, NULL, "s:", dyn_synth_del, dyn_synth_parse},
> +};
> +
> +int dyn_generic_del(struct dyn_events_desc *desc, struct tracefs_dynevent *dyn)
> +{
> +	char *str;
> +	int ret;
> +
> +	if (dyn->system)
> +		ret = asprintf(&str, "-:%s/%s", dyn->system, dyn->event);
> +	else
> +		ret = asprintf(&str, "-:%s", dyn->event);
> +
> +	if (ret < 0)
> +		return -1;
> +
> +	ret = tracefs_instance_file_append(NULL, desc->file, str);
> +	free(str);
> +
> +	return ret < 0 ? ret : 0;
> +}
> +
> +__hidden void dynevent_free(struct tracefs_dynevent *devent)
> +{
> +	if (!devent)
> +		return;
> +	free(devent->system);
> +	free(devent->event);
> +	free(devent->address);
> +	free(devent->format);
> +	free(devent->prefix);
> +	free(devent->trace_file);
> +	free(devent);
> +}
> +
> +static int dyn_generic_parse(struct dyn_events_desc *desc, const char *group,
> +			     char *line, struct tracefs_dynevent **ret_dyn)

Again, I prefer to have the pointer returned, and not assigned as a
parameter. All this returns is 0 on success or -1 on failure. That doesn't
give us anything more than having ret_dyn allocated or not. (return NULL or
non-NULL).

> +{
> +	struct tracefs_dynevent *dyn;
> +	char *address;
> +	char *system;
> +	char *format;
> +	char *event;
> +
> +	if (strncmp(line, desc->prefix, strlen(desc->prefix)))
> +		return -1;
> +
> +	system = strchr(line, ':');
> +	if (!system)
> +		return -1;
> +	event = strchr(line, '/');
> +	if (!event)
> +		return -1;
> +	address = strchr(line, ' ');
> +	if (!address)
> +		return -1;
> +	format = strchr(address+1, ' ');
> +
> +	*address = '\0';
> +	*event = '\0';


The above should use strtok_r.

	char *probe;
	char *sav;

	probe = strtok_r(line, ":", &sav);
	system = strtok_r(NULL, "/", &sav);
	event = strtok_r(NULL, " ", &sav);
	address = strtok_r(NULL, " ", &sav);
	format = strtok_r(NULL, "\n", &sav);




> +
> +	/* KPROBEs and UPROBEs share the same prefix, check the format */
> +	if (desc->type == TRACE_DYNEVENT_UPROBE || desc->type == TRACE_DYNEVENT_URETPROBE) {
> +		if (!strchr(format, '/'))
> +			return -1;
> +	}
> +	if (group && strcmp(group, system+1) != 0)

No need for +1.

> +		return -1;
> +
> +	if (!ret_dyn)
> +		return 0;
> +
> +	dyn = calloc(1, sizeof(*dyn));
> +	if (!dyn)
> +		return -1;

add space here. All error checks should have a blank line after them.

> +	dyn->type = desc->type;
> +	dyn->trace_file = strdup(desc->file);
> +	if (!dyn->trace_file)
> +		goto error;

> +	dyn->system = strdup(system+1);
> +	if (!dyn->system)
> +		goto error;

> +	*(system+1) = '\0';
> +	/* Prefix of KRETPROBE can contain MAXACTIVE integer */
> +	dyn->prefix = strdup(line);
> +	if (!dyn->prefix)
> +		goto error;

> +	dyn->event = strdup(event+1);
> +	if (!dyn->event)
> +		goto error;

> +	if (desc->type == TRACE_DYNEVENT_SYNTH) {
> +		/* Synthetic events have no address */
> +		dyn->format = strdup(address+1);
> +		if (!dyn->format)
> +			goto error;
> +	} else {
> +		if (format)
> +			*format = '\0';
> +		dyn->address = strdup(address+1);
> +		if (!dyn->address)
> +			goto error;
> +		if (format) {
> +			dyn->format = strdup(format+1);
> +			if (!dyn->format)
> +				goto error;
> +		}

If strtok_r wasn't used, there's no reason to do all these "+1", you could
have just done:

	system++;
	event++;
	address++;
	format++;

It would have made it much cleaner.

> +	}
> +	*ret_dyn = dyn;
> +	return 0;
> +error:
> +	dynevent_free(dyn);
> +	return -1;
> +}
> +
> +int dyn_synth_del(struct dyn_events_desc *desc, struct tracefs_dynevent *dyn)
> +{
> +	char *str;
> +	int ret;
> +
> +	if (strcmp(desc->file, DYNEVENTS_EVENTS))
> +		return dyn_generic_del(desc, dyn);
> +
> +	ret = asprintf(&str, "!%s", dyn->event);
> +	if (ret < 0)
> +		return -1;
> +
> +	ret = tracefs_instance_file_append(NULL, desc->file, str);
> +	free(str);
> +
> +	return ret < 0 ? ret : 0;
> +}
> +
> +static int dyn_synth_parse(struct dyn_events_desc *desc, const char *group,
> +			   char *line, struct tracefs_dynevent **ret_dyn)
> +{
> +	struct tracefs_dynevent *dyn;
> +	char *format;
> +
> +	if (strcmp(desc->file, DYNEVENTS_EVENTS))
> +		return dyn_generic_parse(desc, group, line, ret_dyn);
> +
> +	/* synthetic_events file has slightly different syntax */
> +	format = strchr(line, ' ');
> +	if (!format)
> +		return -1;
> +	if (!ret_dyn)
> +		return 0;
> +
> +	*format = '\0';

strtok_r is your friend.

> +	dyn = calloc(1, sizeof(*dyn));
> +	if (!dyn)
> +		return -1;
> +	dyn->type = desc->type;
> +	dyn->trace_file = strdup(desc->file);
> +	if (!dyn->trace_file)
> +		goto error;
> +
> +	dyn->event = strdup(line);
> +	if (!dyn->event)
> +		goto error;
> +	dyn->format = strdup(format+1);
> +	if (!dyn->format)
> +		goto error;
> +
> +	*ret_dyn = dyn;
> +	return 0;
> +error:
> +	dynevent_free(dyn);
> +	return -1;
> +}
> +
> +static struct dyn_events_desc *get_devent_desc(enum trace_dynevent_type type)
> +{
> +	static bool init;
> +	int i;
> +
> +	if (init)
> +		goto out;
> +
> +	init = true;
> +	/* Use  ftrace dynamic_events, if available */
> +	if (tracefs_file_exists(NULL, DYNEVENTS_EVENTS)) {
> +		for (i = 0; i < TRACE_DYNEVENT_MAX; i++)
> +			dynevents[i].file = DYNEVENTS_EVENTS;
> +		goto out;
> +	}
> +
> +	if (tracefs_file_exists(NULL, KPROBE_EVENTS)) {
> +		dynevents[TRACE_DYNEVENT_KPROBE].file = KPROBE_EVENTS;
> +		dynevents[TRACE_DYNEVENT_KRETPROBE].file = KPROBE_EVENTS;
> +	}
> +	if (tracefs_file_exists(NULL, UPROBE_EVENTS)) {
> +		dynevents[TRACE_DYNEVENT_UPROBE].file = UPROBE_EVENTS;
> +		dynevents[TRACE_DYNEVENT_URETPROBE].file = UPROBE_EVENTS;
> +	}
> +	if (tracefs_file_exists(NULL, SYNTH_EVENTS)) {
> +		dynevents[TRACE_DYNEVENT_SYNTH].file = SYNTH_EVENTS;
> +		dynevents[TRACE_DYNEVENT_SYNTH].prefix = "";
> +	}
> +
> +out:
> +	return &dynevents[type];

I would break up the above into two functions.

static void init_devent_desc(void)
{
	int i;

	/* Use  ftrace dynamic_events, if available */
	if (tracefs_file_exists(NULL, DYNEVENTS_EVENTS)) {
		for (i = 0; i < TRACE_DYNEVENT_MAX; i++)
			dynevents[i].file = DYNEVENTS_EVENTS;
		goto out;
	}

	if (tracefs_file_exists(NULL, KPROBE_EVENTS)) {
		dynevents[TRACE_DYNEVENT_KPROBE].file = KPROBE_EVENTS;
		dynevents[TRACE_DYNEVENT_KRETPROBE].file = KPROBE_EVENTS;
	}
	if (tracefs_file_exists(NULL, UPROBE_EVENTS)) {
		dynevents[TRACE_DYNEVENT_UPROBE].file = UPROBE_EVENTS;
		dynevents[TRACE_DYNEVENT_URETPROBE].file = UPROBE_EVENTS;
	}
	if (tracefs_file_exists(NULL, SYNTH_EVENTS)) {
		dynevents[TRACE_DYNEVENT_SYNTH].file = SYNTH_EVENTS;
		dynevents[TRACE_DYNEVENT_SYNTH].prefix = "";
	}
}


static struct dyn_events_desc *get_devent_desc(enum trace_dynevent_type type)
{
	static bool init;

	if (!init) {
		init_devent_desc();
		init = true;
	}
	return &dynevents[type];
}



> +}
> +
> +__hidden struct tracefs_dynevent *
> +dynevent_alloc(enum trace_dynevent_type type, const char *system,
> +	       const char *event, const char *address, const char *format)
> +{
> +	struct tracefs_dynevent *devent;
> +	struct dyn_events_desc *desc;
> +
> +	if (!event) {
> +		errno = EINVAL;
> +		return NULL;
> +	}
> +
> +	desc = get_devent_desc(type);
> +	if (!desc || !desc->file) {
> +		errno = ENOTSUP;
> +		return NULL;
> +	}
> +
> +	devent = calloc(1, sizeof(*devent));
> +	if (!devent)
> +		return NULL;
> +
> +	devent->type = type;
> +	devent->trace_file = strdup(desc->file);
> +	if (!devent->trace_file)
> +		goto err;
> +	if (!system)
> +		system = DYNEVENTS_DEFAULT_GROUP;
> +	devent->system = strdup(system);
> +	if (!devent->system)
> +		goto err;
> +	devent->event = strdup(event);
> +	if (!devent->event)
> +		goto err;
> +	if (type == TRACE_DYNEVENT_KRETPROBE || type == TRACE_DYNEVENT_URETPROBE)
> +		devent->prefix = strdup(RETPROBE_DEFAUL_PREFIX);
> +	else
> +		devent->prefix = strdup(desc->prefix);
> +
> +	if (!devent->prefix)
> +		goto err;
> +	if (address) {
> +		devent->address = strdup(address);
> +		if (!devent->address)
> +			goto err;
> +	}
> +	if (format) {
> +		devent->format = strdup(format);
> +		if (!devent->format)
> +			goto err;
> +	}
> +
> +	return devent;
> +err:
> +	dynevent_free(devent);
> +	return NULL;
> +}
> +
> +__hidden int dynevent_create(struct tracefs_dynevent *devent)
> +{
> +	char *str;
> +	int ret;
> +
> +	if (!devent)
> +		return -1;

Again, space after error paths.

> +	if (devent->system && devent->system[0])
> +		ret = asprintf(&str, "%s%s/%s %s %s\n",
> +				devent->prefix, devent->system, devent->event,
> +				devent->address?devent->address:"",

Add spaces around "?" and ":" and for the ones below.

> +				devent->format?devent->format:"");
> +	else
> +		ret = asprintf(&str, "%s%s %s %s\n",
> +				devent->prefix, devent->event,
> +				devent->address?devent->address:"",
> +				devent->format?devent->format:"");
> +	if (ret < 0)
> +		return -1;

> +	ret = tracefs_instance_file_append(NULL, devent->trace_file, str);
> +	free(str);
> +
> +	return ret < 0 ? ret : 0;
> +}
> +
> +__hidden int dynevent_destroy(struct tracefs_dynevent *devent)
> +{
> +	struct dyn_events_desc *desc;
> +
> +	if (!devent)
> +		return -1;

space.

> +	desc = get_devent_desc(devent->type);
> +	if (!desc)
> +		return -1;

space.

> +	return desc->dyn_events_del(desc, devent);
> +}
> +
> +static int get_all_type(enum trace_dynevent_type type, const char *system,
> +			struct tracefs_dynevent ***ret_all)
> +{
> +	struct dyn_events_desc *desc;
> +	struct tracefs_dynevent *devent, **tmp, **all = NULL;
> +	char *content;
> +	int count = 0;
> +	char *line;
> +	char *next;
> +	int ret;
> +
> +	desc = get_devent_desc(type);
> +	if (!desc)
> +		return -1;
> +
> +	content = tracefs_instance_file_read(NULL, desc->file, NULL);
> +	if (!content)
> +		return -1;

space.

> +	line = content;
> +	do {
> +		next = strchr(line, '\n');
> +		if (next)
> +			*next = '\0';
> +		ret = desc->dyn_events_parse(desc, system, line, ret_all ? &devent : NULL);

So if ret_all is NULL, then we allocate a bunch of devent and lose them?

> +		if (!ret) {
> +			if (ret_all) {
> +				tmp = realloc(all, (count+1)*sizeof(struct tracefs_dynevent *));
> +				if (!tmp)
> +					goto error;
> +				all = tmp;
> +				all[count] = devent;
> +			}
> +			count++;
> +		}
> +		line = next + 1;
> +	} while (next);
> +
> +	free(content);
> +	if (ret_all)
> +		*ret_all = all;

We really should just return all, and if we want a count, we can pass a
pointer to an integer, and put the count in there. Not the other way around.

> +	return count;
> +
> +error:
> +	free(content);
> +	free(all);
> +	return -1;
> +}
> +
> +/**
> + * tracefs_dynevent_list_free - Deletes an array of pointers to dynamic event contexts
> + * @events: An array of pointers to dynamic event contexts. The last element of the array
> + *	    must be a NULL pointer.
> + */
> +void tracefs_dynevent_list_free(struct tracefs_dynevent ***events)

Again, just pass in ** not ***.

> +{
> +	struct tracefs_dynevent **devent;
> +	int i = 0;
> +
> +	if (!events || !(*events))
> +		return;
> +
> +	devent = *events;
> +	while (devent[i])
> +		dynevent_free(devent[i++]);
> +
> +	free(*events);
> +}
> +
> +__hidden int dynevent_get_all(unsigned long type_mask, const char *system,
> +			      struct tracefs_dynevent ***ret_events)
> +{
> +	struct tracefs_dynevent **events, **tmp, **all_events = NULL;
> +	int count, all = 0;
> +	int i;
> +
> +	for (i = 0; i < TRACE_DYNEVENT_MAX; i++) {
> +		if (!DYNEVENT_CHECK_BIT(type_mask, i))
> +			continue;

space.

> +		count = get_all_type(i, system, ret_events ? &events : NULL);
> +		if (count > 0) {
> +			if (ret_events) {
> +				tmp = realloc(all_events,
> +					     (all + count)*sizeof(struct tracefs_dynevent *));
> +				if (!tmp)
> +					goto error;
> +				all_events = tmp;
> +				memcpy(all_events + all, events,
> +				       count*sizeof(struct tracefs_dynevent *));
> +			}
> +			all += count;
> +		}
> +
> +	}
> +
> +	if (ret_events) {
> +		/* Add a NULL pointer at the end */
> +		if (all > 0) {
> +			tmp = realloc(all_events,
> +				     (all + 1)*sizeof(struct tracefs_dynevent *));
> +			if (!tmp)
> +				goto error;
> +			all_events = tmp;
> +			all_events[all] = NULL;
> +		}
> +		*ret_events = all_events;
> +	}
> +
> +	return all;
> +
> +error:
> +	if (all_events) {
> +		for (i = 0; i < all; i++)
> +			free(all_events[i]);
> +		free(all_events);
> +	}
> +	return -1;
> +}


-- Steve

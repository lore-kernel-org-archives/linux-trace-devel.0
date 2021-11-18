Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5021DC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Nov 2021 02:50:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E1D961AF7
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Nov 2021 02:50:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241933AbhKRCxK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Nov 2021 21:53:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:50266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237730AbhKRCxK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Nov 2021 21:53:10 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C43861AF7;
        Thu, 18 Nov 2021 02:50:10 +0000 (UTC)
Date:   Wed, 17 Nov 2021 21:50:08 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     mhiramat@kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 02/12] user_events: Add minimal support for
 trace_event into ftrace
Message-ID: <20211117215008.79f1d6a1@gandalf.local.home>
In-Reply-To: <20211116005047.1808-3-beaub@linux.microsoft.com>
References: <20211116005047.1808-1-beaub@linux.microsoft.com>
        <20211116005047.1808-3-beaub@linux.microsoft.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 15 Nov 2021 16:50:37 -0800
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> diff --git a/kernel/trace/trace_events_user.c b/kernel/trace/trace_events_user.c
> new file mode 100644
> index 000000000000..80d1ce21d713
> --- /dev/null
> +++ b/kernel/trace/trace_events_user.c
> @@ -0,0 +1,1159 @@
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
> +#define MAX_FIELD_ARRAY_SIZE (2 * PAGE_SIZE)

You really want to allow field sizes to be larger than a page?

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

[..]

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

Still need a comment here that states:

	/*
	 * The refs->events array is protected by RCU, and new items may be
	 * added. But the user retrieved from indexing into the events array
	 * shall be immutable while the file is opened.
	 */

Or something like that, because once again, I had to figure out how this
all worked. It's not obvious.

> +	if (likely(refs && idx < refs->count))
> +		user = refs->events[idx];
> +
> +	rcu_read_unlock_sched();
> +
> +	if (unlikely(user == NULL))
> +		return -ENOENT;
> +
> +	tp = &user->tracepoint;
> +

Probably also should have a comment here that states that this is racy, but
we don't care. That is, the enabled can be less than 1 after the if
statement, but that means it was just disabled and it's OK if a few events
slip in after it is.

> +	if (likely(atomic_read(&tp->key.enabled) > 0)) {
> +		struct tracepoint_func *probe_func_ptr;
> +		user_event_func_t probe_func;
> +		void *tpdata;
> +		void *kdata;
> +		u32 datalen;
> +
> +		kdata = kmalloc(i->count, GFP_KERNEL);
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
> +	refs = rcu_dereference_protected(file->private_data,
> +					 lockdep_is_held(&reg_mutex));
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

Use:

	size = struct_size(refs, events, count + 1);


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
> +
> +static long user_reg_get(struct user_reg __user *ureg, struct user_reg *kreg)
> +{
> +	u32 size;
> +	long ret;
> +
> +	ret = get_user(size, &ureg->size);
> +
> +	if (ret)
> +		return ret;
> +
> +	if (size > PAGE_SIZE)
> +		return -E2BIG;
> +
> +	return copy_struct_from_user(kreg, sizeof(*kreg), ureg, size);
> +}
> +
> +/*
> + * Registers a user_event on behalf of a user process.
> + */
> +static long user_events_ioctl_reg(struct file *file, unsigned long uarg)
> +{
> +	struct user_reg __user *ureg = (struct user_reg __user *)uarg;
> +	struct user_reg reg;
> +	struct user_event *user;
> +	char *name;
> +	long ret;
> +
> +	ret = user_reg_get(ureg, &reg);
> +
> +	if (ret)
> +		return ret;
> +
> +	name = strndup_user((const char __user *)(uintptr_t)reg.name_args,
> +			    MAX_EVENT_DESC);
> +
> +	if (IS_ERR(name)) {
> +		ret = PTR_ERR(name);
> +		return ret;
> +	}
> +
> +	ret = user_event_parse_cmd(name, &user);
> +
> +	if (ret) {
> +		kfree(name);
> +		return ret;
> +	}
> +
> +	ret = user_events_ref_add(file, user);
> +
> +	/* Positive number is index and valid */
> +	if (ret < 0)
> +		return ret;
> +
> +	put_user((u32)ret, &ureg->write_index);
> +	put_user(user->index, &ureg->status_index);
> +
> +	return 0;
> +}
> +
> +/*
> + * Deletes a user_event on behalf of a user process.
> + */
> +static long user_events_ioctl_del(struct file *file, unsigned long uarg)
> +{
> +	void __user *ubuf = (void __user *)uarg;
> +	char *name;
> +	long ret;
> +
> +	name = strndup_user(ubuf, MAX_EVENT_DESC);
> +
> +	if (IS_ERR(name))
> +		return PTR_ERR(name);
> +
> +	ret = delete_user_event(name);
> +
> +	kfree(name);
> +
> +	return ret;
> +}
> +
> +/*
> + * Handles the ioctl from user mode to register or alter operations.
> + */
> +static long user_events_ioctl(struct file *file, unsigned int cmd,
> +			      unsigned long uarg)
> +{
> +	long ret = -ENOTTY;
> +
> +	switch (cmd) {
> +	case DIAG_IOCSREG:
> +		mutex_lock(&reg_mutex);
> +		ret = user_events_ioctl_reg(file, uarg);
> +		mutex_unlock(&reg_mutex);
> +		break;
> +
> +	case DIAG_IOCSDEL:
> +		mutex_lock(&reg_mutex);
> +		ret = user_events_ioctl_del(file, uarg);
> +		mutex_unlock(&reg_mutex);
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +/*
> + * Handles the final close of the file from user mode.
> + */
> +static int user_events_release(struct inode *node, struct file *file)
> +{
> +	struct user_event_refs *refs;
> +	struct user_event *user;
> +	int i;
> +
> +	rcu_read_lock_sched();
> +	refs = rcu_dereference_sched(file->private_data);
> +	rcu_read_unlock_sched();

This looks totally wrong. What is RCU protecting here?

> +
> +	if (!refs)
> +		goto out;
> +

How can't refs->events not change here?

Shouldn't reg_mutex be held throughout this function?

> +	for (i = 0; i < refs->count; ++i) {
> +		user = refs->events[i];
> +
> +		if (user)
> +			atomic_dec(&user->refcnt);
> +	}
> +
> +	kfree_rcu(refs, rcu);
> +out:
> +	return 0;
> +}
> +

-- Steve


Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0657C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Nov 2021 20:01:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAE9B61ACE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Nov 2021 20:01:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbhKRUEL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 18 Nov 2021 15:04:11 -0500
Received: from linux.microsoft.com ([13.77.154.182]:50200 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbhKRUEL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 Nov 2021 15:04:11 -0500
Received: from kbox (c-73-140-2-214.hsd1.wa.comcast.net [73.140.2.214])
        by linux.microsoft.com (Postfix) with ESMTPSA id B615520C7066;
        Thu, 18 Nov 2021 12:01:10 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B615520C7066
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1637265670;
        bh=1ViP9QXlC0kaL3ucE5/bw1SY5wxvw0vtFAIEOfu4h1w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GHpUqWQKk3iiSEqZ8Dnn4+WDRAmCgSWcDQaWnPajK0boxhi1iy78GEJO0y8Ilg0Cv
         8ZAo2St14p7ImxhZ6Wjxs5GAlYAXFEHQxUVRpmUDnzQaFQLdmm1gTU6p2AVVeISm8D
         ybED/CtyJyhQGgB01PMmM+1Du8XAzF6Le6Oo9g3I=
Date:   Thu, 18 Nov 2021 12:01:09 -0800
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     mhiramat@kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 02/12] user_events: Add minimal support for
 trace_event into ftrace
Message-ID: <20211118200109.GB1895@kbox>
References: <20211116005047.1808-1-beaub@linux.microsoft.com>
 <20211116005047.1808-3-beaub@linux.microsoft.com>
 <20211117215008.79f1d6a1@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117215008.79f1d6a1@gandalf.local.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Nov 17, 2021 at 09:50:08PM -0500, Steven Rostedt wrote:
> On Mon, 15 Nov 2021 16:50:37 -0800
> Beau Belgrave <beaub@linux.microsoft.com> wrote:
> 
> > diff --git a/kernel/trace/trace_events_user.c b/kernel/trace/trace_events_user.c
> > new file mode 100644
> > index 000000000000..80d1ce21d713
> > --- /dev/null
> > +++ b/kernel/trace/trace_events_user.c
> > @@ -0,0 +1,1159 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * Copyright (c) 2021, Microsoft Corporation.
> > + *
> > + * Authors:
> > + *   Beau Belgrave <beaub@linux.microsoft.com>
> > + */
> > +
> > +#include <linux/bitmap.h>
> > +#include <linux/cdev.h>
> > +#include <linux/hashtable.h>
> > +#include <linux/list.h>
> > +#include <linux/io.h>
> > +#include <linux/uio.h>
> > +#include <linux/ioctl.h>
> > +#include <linux/jhash.h>
> > +#include <linux/trace_events.h>
> > +#include <linux/tracefs.h>
> > +#include <linux/types.h>
> > +#include <linux/uaccess.h>
> > +#include <uapi/linux/user_events.h>
> > +#include "trace.h"
> > +#include "trace_dynevent.h"
> > +
> > +#define USER_EVENTS_PREFIX_LEN (sizeof(USER_EVENTS_PREFIX)-1)
> > +
> > +#define FIELD_DEPTH_TYPE 0
> > +#define FIELD_DEPTH_NAME 1
> > +#define FIELD_DEPTH_SIZE 2
> > +
> > +/*
> > + * Limits how many trace_event calls user processes can create:
> > + * Must be multiple of PAGE_SIZE.
> > + */
> > +#define MAX_PAGES 1
> > +#define MAX_EVENTS (MAX_PAGES * PAGE_SIZE)
> > +
> > +/* Limit how long of an event name plus args within the subsystem. */
> > +#define MAX_EVENT_DESC 512
> > +#define EVENT_NAME(user_event) ((user_event)->tracepoint.name)
> > +#define MAX_FIELD_ARRAY_SIZE (2 * PAGE_SIZE)
> 
> You really want to allow field sizes to be larger than a page?
> 

I picked this based on your previous comments that it's likely a bug if
something gets quite large. I'm happy with any upper limit, we will be
using __rel_loc now that it's available for our large data.

Would you prefer this to be maybe like 1024 or 2048? I don't know if
some user scenario will require a large field or what is a realistic
upper bound for those scenarios. So no hard data to base this off of
from my side.

> > +
> > +static char *register_page_data;
> > +
> > +static DEFINE_MUTEX(reg_mutex);
> > +static DEFINE_HASHTABLE(register_table, 4);
> > +static DECLARE_BITMAP(page_bitmap, MAX_EVENTS);
> > +
> > +struct user_event {
> > +	struct tracepoint tracepoint;
> > +	struct trace_event_call call;
> > +	struct trace_event_class class;
> > +	struct dyn_event devent;
> > +	struct hlist_node node;
> > +	struct list_head fields;
> > +	atomic_t refcnt;
> > +	int index;
> > +	int flags;
> > +};
> > +
> > +struct user_event_refs {
> > +	struct rcu_head rcu;
> > +	int count;
> > +	struct user_event *events[];
> > +};
> > +
> > +typedef void (*user_event_func_t) (struct user_event *user,
> > +				   void *data, u32 datalen,
> > +				   void *tpdata);
> > +
> > +static int user_event_parse(char *name, char *args, char *flags,
> > +			    struct user_event **newuser);
> > +
> 
> [..]
> 
> > +
> > +/*
> > + * Validates the user payload and writes via iterator.
> > + */
> > +static ssize_t user_events_write_core(struct file *file, struct iov_iter *i)
> > +{
> > +	struct user_event_refs *refs;
> > +	struct user_event *user = NULL;
> > +	struct tracepoint *tp;
> > +	ssize_t ret = i->count;
> > +	int idx;
> > +
> > +	if (unlikely(copy_from_iter(&idx, sizeof(idx), i) != sizeof(idx)))
> > +		return -EFAULT;
> > +
> > +	rcu_read_lock_sched();
> > +
> > +	refs = rcu_dereference_sched(file->private_data);
> > +
> 
> Still need a comment here that states:
> 
> 	/*
> 	 * The refs->events array is protected by RCU, and new items may be
> 	 * added. But the user retrieved from indexing into the events array
> 	 * shall be immutable while the file is opened.
> 	 */
> 
> Or something like that, because once again, I had to figure out how this
> all worked. It's not obvious.
> 

Sorry about that, I'll ensure to add it.

> > +	if (likely(refs && idx < refs->count))
> > +		user = refs->events[idx];
> > +
> > +	rcu_read_unlock_sched();
> > +
> > +	if (unlikely(user == NULL))
> > +		return -ENOENT;
> > +
> > +	tp = &user->tracepoint;
> > +
> 
> Probably also should have a comment here that states that this is racy, but
> we don't care. That is, the enabled can be less than 1 after the if
> statement, but that means it was just disabled and it's OK if a few events
> slip in after it is.
> 

Got it will do.

> > +	if (likely(atomic_read(&tp->key.enabled) > 0)) {
> > +		struct tracepoint_func *probe_func_ptr;
> > +		user_event_func_t probe_func;
> > +		void *tpdata;
> > +		void *kdata;
> > +		u32 datalen;
> > +
> > +		kdata = kmalloc(i->count, GFP_KERNEL);
> > +
> > +		if (unlikely(!kdata))
> > +			return -ENOMEM;
> > +
> > +		datalen = copy_from_iter(kdata, i->count, i);
> > +
> > +		rcu_read_lock_sched();
> > +
> > +		probe_func_ptr = rcu_dereference_sched(tp->funcs);
> > +
> > +		if (probe_func_ptr) {
> > +			do {
> > +				probe_func = probe_func_ptr->func;
> > +				tpdata = probe_func_ptr->data;
> > +				probe_func(user, kdata, datalen, tpdata);
> > +			} while ((++probe_func_ptr)->func);
> > +		}
> > +
> > +		rcu_read_unlock_sched();
> > +
> > +		kfree(kdata);
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +static ssize_t user_events_write(struct file *file, const char __user *ubuf,
> > +				 size_t count, loff_t *ppos)
> > +{
> > +	struct iovec iov;
> > +	struct iov_iter i;
> > +
> > +	if (unlikely(*ppos != 0))
> > +		return -EFAULT;
> > +
> > +	if (unlikely(import_single_range(READ, (char *)ubuf, count, &iov, &i)))
> > +		return -EFAULT;
> > +
> > +	return user_events_write_core(file, &i);
> > +}
> > +
> > +static ssize_t user_events_write_iter(struct kiocb *kp, struct iov_iter *i)
> > +{
> > +	return user_events_write_core(kp->ki_filp, i);
> > +}
> > +
> > +static int user_events_ref_add(struct file *file, struct user_event *user)
> > +{
> > +	struct user_event_refs *refs, *new_refs;
> > +	int i, size, count = 0;
> > +
> > +	refs = rcu_dereference_protected(file->private_data,
> > +					 lockdep_is_held(&reg_mutex));
> > +
> > +	if (refs) {
> > +		count = refs->count;
> > +
> > +		for (i = 0; i < count; ++i)
> > +			if (refs->events[i] == user)
> > +				return i;
> > +	}
> > +
> 
> 
> > +	size = sizeof(*refs) + (sizeof(struct user_event *) * (count + 1));
> 
> Use:
> 
> 	size = struct_size(refs, events, count + 1);
> 
> 

Will do.

> > + * Handles the final close of the file from user mode.
> > + */
> > +static int user_events_release(struct inode *node, struct file *file)
> > +{
> > +	struct user_event_refs *refs;
> > +	struct user_event *user;
> > +	int i;
> > +
> > +	rcu_read_lock_sched();
> > +	refs = rcu_dereference_sched(file->private_data);
> > +	rcu_read_unlock_sched();
> 
> This looks totally wrong. What is RCU protecting here?
> 

There seems to be a timing window where refs gets changed on one core
and release happens immediately on another. The release seems to be able
to read an old version of that value unless some barrier is imposed.

I've kept with rcu_read_lock_sched() vs READ_ONCE here to try to make
that clear.

Do you agree that the timing window is possible?

> > +
> > +	if (!refs)
> > +		goto out;
> > +
> 
> How can't refs->events not change here?
> 
> Shouldn't reg_mutex be held throughout this function?
> 

refs lifetime is limited to file lifetime. When release is called no
other reference to the file exists.

So the events array cannot be change since it's isolated to that single
file instance (it's not shared).

refs->events is the local array so when user mode writes to an event it
uses the index of the events in the first 4 bytes.

The underlying event within the refs->events cannot close down since
it's ref counted, which happens below as quoted.

The comment you want me to add higher up in the thread will likely help
bring clarity here. Perhaps I'll add another comment at this level as
well.

> > +	for (i = 0; i < refs->count; ++i) {
> > +		user = refs->events[i];
> > +
> > +		if (user)
> > +			atomic_dec(&user->refcnt);
> > +	}
> > +
> > +	kfree_rcu(refs, rcu);
> > +out:
> > +	return 0;
> > +}
> > +
> 
> -- Steve

Thanks,
-Beau

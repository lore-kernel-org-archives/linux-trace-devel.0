Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BD1CC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Oct 2021 22:42:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 022786054E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Oct 2021 22:42:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234042AbhJVWo0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Oct 2021 18:44:26 -0400
Received: from linux.microsoft.com ([13.77.154.182]:59938 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234449AbhJVWoZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Oct 2021 18:44:25 -0400
Received: from kbox (unknown [24.17.193.74])
        by linux.microsoft.com (Postfix) with ESMTPSA id 7E78920B7179;
        Fri, 22 Oct 2021 15:42:07 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7E78920B7179
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1634942527;
        bh=9nJ1KtAfFInNgzcdRcyzPjn02eIJapmlH5kWIBzCcEI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qCKoGyGuWgfv4S3AP7e1/IeT7Lq0Jjwad9NLR4GyNd3ZUCOrp3BOMREM9gmJ/rej3
         KgMeaaSKkjPa0GD+AJmLlRhqO8/UkYLnIbmvInUSnWYQVdrVTT0dHkJT/0fioyUWIc
         zCEfQFHkNUAehg4a/P7kuJhYCvhbPZ65PIbwhHCo=
Date:   Fri, 22 Oct 2021 15:42:02 -0700
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] user_events: Enable user processes to create and
 write to trace events
Message-ID: <20211022224202.GA27683@kbox>
References: <20211018230957.3032-1-beaub@linux.microsoft.com>
 <20211022223811.d0b5f03a7eee147c619d0202@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211022223811.d0b5f03a7eee147c619d0202@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Oct 22, 2021 at 10:38:11PM +0900, Masami Hiramatsu wrote:
> On Mon, 18 Oct 2021 16:09:57 -0700
> Beau Belgrave <beaub@linux.microsoft.com> wrote:
> > of the ioctl indicates the byte in the mmap to use for status and the index
> > to use for writing. Both are 16-bits in size and are accessible via the
> > INDEX_STATUS and INDEX_WRITE macros within user_events.h.
> 
> Hmm, if we uses the ioctl(), the return value must be int because it can
> return -1 and kernel return value is stored into the errno if there is
> any error. I think you can introduce a data structure to return the
> id and offset. (Or make id 15-bits :))  
> 
Yeah, I think I will introduce a struct to aid with this and some others
things like flags / print_fmt being specified (See below for those).

> > int data_fd = open("user_events_data", O_RDWR);
> > long result = ioctl(data_fd, DIAG_IOCSREG, "test");
> > int status_id = INDEX_STATUS(result);
> > int write_id = INDEX_WRITE(result);
> > 
> > struct iovec io[2];
> > io[0].iov_base = &write_id;
> > io[0].iov_len = sizeof(write_id);
> > io[1].iov_base = payload;
> > io[1].iov_len = sizeof(payload);
> > 
> > if (page_data[status_id])
> > 	writev(data_fd, io, 2);
> 
> OK, so you switch to the 1:n model. Using writev() is a good idea.
> (BTW, what happen if I use write()?)
> 
The first 4 bytes are used regardless if writev() or write() is used.
Both turn into an iterator to make the code simpler instead of handling
each case differently.

> > 
> > Users can describe the trace event format via the following format:
> > 	name [field1;field2]
> 
> Does this mean it always need 2 fields?
> 
No, they need 0-N fields, perhaps I should leave off the second field in
the description.

> > 
> > Each field has the following format:
> > 	type name size
> 
> Why do you need the "size"? Since "type" must have the size information,
> it is not needed. (or, user can define 1 byte "int" type...)
> 
The idea is to allow user mode processes to describe their own data
types if required. For that we need offset or size to be passed. If we
require all user mode to only describe in types the kernel understands
then I can remove the size field.

> > 
> > Example for char array with a size of 20 named msg:
> > 	echo 'u:detailed char[20] msg 20' >> dynamic_events
> > 	cat dynamic_events
> > 	u:detailed char[20] msg
> > 
> > Data offsets are based on the data written out via write() and will be
> > updated to reflect the correct offset in the trace_event fields. __data_loc
> > types must be aware of the size of trace_entry/common properties to ensure
> > proper decoding.
> 
> As I said that the you have to add __rel_loc type (yes, you can do it)
> so that the user don't need to consider the data location. That new type
> decodeer code may need to be implemented afterwards in user-space tools
> but anyway, that can be postponed.
> 
Got it, does that mean I should just reference it here as a new type?
I'm not sure what it means to add __rel_loc type since it appears anyone
can pass any type down to trace_event and it will accept it.

> > ---
> >  include/uapi/linux/user_events.h |   57 ++
> >  kernel/trace/Kconfig             |   15 +
> >  kernel/trace/Makefile            |    1 +
> >  kernel/trace/trace_events_user.c | 1040 ++++++++++++++++++++++++++++++
> >  4 files changed, 1113 insertions(+)
> >  create mode 100644 include/uapi/linux/user_events.h
> >  create mode 100644 kernel/trace/trace_events_user.c
> 
> BTW, if you can split this patch into several patches, it is easier to us
> to review it. E.g. basic support for ftrace, add perf support, add bpf support,
> documentation, optimize performance etc.
> 
Sorry, are you asking for several isolated patches? Or a single patch
with multiple commits to the same file?

Typically after addition I am running a set of tests and benchmarks
against the code, so having full functioning code is required to ensure
I haven't broken anything.

We are actively using these patches for various projects, which require
ftrace, perf and eBPF to be functional.

> > +
> > +/*
> > + * Parses the values of a field within the description
> > + * Format: type name size [future]
> > + */
> 
> As I said that the size is non-sense. And this should finally unified
> with synthetic event field definition. 
> 
I have this for custom user types the kernel may not know the size of.
Another reason is 32-bit process on a 64-bit kernel. The size will always be
the kernel size of that type.

If we don't care about either, then I can remove this. For custom types
we are fine with using __rel_loc instead.

> > +static int user_event_parse_field(char *field, struct user_event *user,
> > +				  u32 *offset)
> > +{
> > +	char *part, *type, *name;
> > +	u32 size = 0, depth = 0, saved_offset = *offset;
> > +
> > +	field = skip_spaces(field);
> > +
> > +	if (strstr(field, "unsigned ") == field) {
> > +		type = field;
> > +		field = strpbrk(field + sizeof("unsigned"), " ");
> > +
> > +		if (field == NULL)
> > +			return -EINVAL;
> > +
> > +		*field++ = 0;
> > +		depth++;
> > +	} else if (strstr(field, "print_fmt ") == field) {
> > +		user->call.print_fmt = field + sizeof("print_fmt");
> > +		return 0;
> 
> What is this ?
> 
We have several events that describe the print format to use instead of
using the default, like we allow in the kernel. This is currently how it
is passed, it could be described in the new struct to the reg ioctl
instead.

> > +	} else if (strstr(field, "flag ") == field) {
> > +		field += sizeof("flag");
> > +
> > +		if (!strcmp(field, "bpf_iter"))
> > +			user->flags |= FLAG_BPF_ITER;
> > +
> 
> What is this flag?
> 
We want to enable certain sensitive events the ability to mark that
there should never be a buffer copy. When FLAG_BPF_ITER is used the raw
iovecs are exposed out to eBPF instead of any sort of copy to reduce
latency. We run user_events in some highly performant code and want to
monitor things with the least amount of overhead possible.

> > +	name = kstrdup(raw_command, GFP_KERNEL);
> > +
> > +	if (!name)
> > +		return -ENOMEM;
> > +
> > +	mutex_lock(&event_mutex);
> > +	ret = user_event_parse_cmd(name, &user);
> 
> I recommend you to split "parse" and "register" function, and
> locks event_mutex only in the "register" function, since parsing
> doesn't need to hold other events.
> 
Sure

> > +static bool user_event_match(const char *system, const char *event,
> > +			     int argc, const char **argv, struct dyn_event *ev)
> > +{
> > +	struct user_event *user = container_of(ev, struct user_event, devent);
> > +
> > +	return strcmp(EVENT_NAME(user), event) == 0 &&
> > +		(!system || strcmp(system, USER_EVENTS_SYSTEM) == 0);
> 
> For the minimal implementation, this is OK.
> 
> Note that it is better to check the rest of arguments with the event
> parameters. E.g. if you have "myuevent int var", user cant try to remove
> "-:myuevent char var".
> 
Ok, the reason we do this is because the events are going to be
versioned. They might change their arguments and having a way to clear
without knowing the exact arguments is not a bad thing in our cases.

No one can remove an event while it's being used and the name cannot
conflict since all user events go to the user_events sub-system and
cannot be overriden.

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
> > +	preempt_disable();
> 
> Why do you disable preemption here?
> 
My understanding was that preemption is to be disabled when using rcu
protected by sched, which tracepoints and the refs are. We also want the
correct processor to log the event (as near as we can).

Did I misunderstand rcu_dereference_sched_check()? I may be off in the
weeds.

I also ran with CONFIG_PROVE_RCU and didn't see anything show up in
dmesg.

> > +
> > +	if (unlikely(!(cpu_online(raw_smp_processor_id()))))
> > +		goto out;
> 
> This seems meaningless because this function is called in the
> user process context. If the cpu is going to offline, the process
> itself will be migrated before reaching here.
> 
Sure, everywhere else had this and wasn't sure if this was possible to
happen or not. I'll remove it.

> > +
> > +	if (unlikely(copy_from_iter(&idx, sizeof(idx), i) != sizeof(idx))) {
> > +		ret = -EFAULT;
> > +		goto out;
> > +	}
> 
> Isn't this copy_from_iter() sleepable function?
> 
Yes, if we need to fault in data we want the data to come in. This is in
the user process context of write() and writev() which I believe is the
expected target for copy_from_iter().

During the probe copies we are not holding a lock or have interrupts
disabled, under what circumstances would a page fault cause an issue in
these paths? What is recommended here if we want to have page faults be
allowed (Hoping they are rare)?

> > +				/*
> > +				 * Probes advance the iterator so we
> > +				 * need to have a copy for each probe.
> > +				 */
> > +				copy = *i;
> > +
> > +				probe_func = probe_func_ptr->func;
> > +				tpdata = probe_func_ptr->data;
> > +				probe_func(user, &copy, tpdata);
> 
> You seems to try to copy in from user space in each probe func, but
> please copy it here to the temporary buffer and pass it to the
> each probe function. Such performacne optimization can postpone.
> Start with simple implementation.
> 
Yes, this avoids double copying of the data in the normal paths. Moving
to a temp buffer only really changes 1 line in the probe functions
(copy_from_iter to copy_from_user).

If I were to create a temp buffer for simplicity I guess I would have to
kmalloc on each call or move to a per-cpu buffer or use stack memory and
limit how much data can be copied.

These would likely add more lines than they remove from the code.

> > +	refs = rcu_dereference_sched(file->private_data);
> > +
> > +	if (refs) {
> > +		count = refs->count;
> > +
> > +		for (i = 0; i < count; ++i)
> > +			if (refs->events[i] == user)
> > +				return i;
> > +	}
> > +
> > +	size = sizeof(*refs) + (sizeof(struct user_event *) * (count + 1));
> > +
> > +	new_refs = kzalloc(size, GFP_KERNEL);
> > +
> > +	if (!new_refs)
> > +		return -ENOMEM;
> > +
> > +	new_refs->count = count + 1;
> > +
> > +	for (i = 0; i < count; ++i)
> > +		new_refs->events[i] = refs->events[i];
> > +
> > +	new_refs->events[i] = user;
> > +
> > +	atomic_inc(&user->refs);
> > +
> > +	rcu_assign_pointer(file->private_data, new_refs);
> > +
> > +	if (refs)
> > +		kfree_rcu(refs, rcu);
> 
> It seems you introduced non-needed complexity with the events lists.
> Why not just adding new events on the current refs?
> Please make this simple at the first step. Forget about performance,
> but just start with simple code.
> 
Callers are free to call the reg ioctl while a write is occurring on the
same file. This can cause the kernel to access garbage. Either RCU or
locking is required in these paths or the ABI needs a way to lock the
file into a mode where no more events can be added (IE: Change to write
mode).

We want RCU because we have places where multiple processors will be
emitting data out to the same file. We don't want the data/cache
contention across processors to slow things down, which we have seen in
other telemetry data.

> > +	case DIAG_IOCSREG:
> > +		/* Register/lookup on behalf of user process */
> > +		name = strndup_user(ubuf, MAX_EVENT_DESC);
> > +
> > +		if (IS_ERR(name)) {
> > +			ret = PTR_ERR(name);
> > +			goto out;
> > +		}
> > +
> > +		mutex_lock(&event_mutex);
> > +
> > +		ret = user_event_parse_cmd(name, &user);
> > +
> > +		if (ret < 0)
> > +			goto reg_out;
> > +
> > +		preempt_disable();
> 
> Why do you need to disable preemption here? It is enough to
> use a mutex.
> 
Because user_events_ref_add use rcu protected by sched. It appears that
preemption is supposed to be disabled when using that from my read of
the code. Is this not correct or not required?

> > +/*
> > + * Handles the final close of the file from user mode.
> > + */
> > +static int user_events_release(struct inode *node, struct file *file)
> > +{
> > +	struct user_event_refs *refs;
> > +	struct user_event *user;
> > +	int i;
> > +
> > +	preempt_disable();
> 
> I'm not sure why do you stick on using the RCU here.
> Since the user-events are only used in the user-context,
> which is not a critical section.
> For example, if you use kprobes, it may be called from anywhere
> in the kernel including critical section, and the handler will
> run in the interrupt handler. Thus I should use RCU. But here,
> the user events are written by syscalls, no critical section
> at all...
> 
> Can you try to remove RCU from this code?
> 
If you are talking about this specific call site (user_events_release)
then yeah I believe I can remove it. If you talking in general, we use
RCU to protect against some scenarios where events are getting
registered while previous events are getting written out.

We chose RCU over readwrite locking due to potential for shared cache
contention related slowdowns.

> Thank you,
> -- 
> Masami Hiramatsu <mhiramat@kernel.org>
Thank you for taking the time to review, appreciate it!

Thanks,
-Beau

Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59A8BC433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  6 Oct 2021 16:54:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E81D61130
	for <linux-trace-devel@archiver.kernel.org>; Wed,  6 Oct 2021 16:54:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbhJFQ4f convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 6 Oct 2021 12:56:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:52218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229835AbhJFQ4f (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 6 Oct 2021 12:56:35 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A94926103E;
        Wed,  6 Oct 2021 16:54:42 +0000 (UTC)
Date:   Wed, 6 Oct 2021 12:54:41 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     mhiramat@kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] user_events: Enable user processes to create and write
 to trace events
Message-ID: <20211006125441.24982dd3@gandalf.local.home>
In-Reply-To: <20211005224428.2551-1-beaub@linux.microsoft.com>
References: <20211005224428.2551-1-beaub@linux.microsoft.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue,  5 Oct 2021 15:44:28 -0700
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> User mode processes that wish to use trace events to get data into
> ftrace, perf, eBPF, etc are limited to uprobes today. The user events
> features enables an ABI for user mode processes to create and write to
> trace events that are isolated from kernel level trace events. This
> enables a faster path for tracing from user mode data as well as opens
> managed code to participate in trace events, where stub locations are
> dynamic.
> 
> User processes often want to trace only when it's useful. To enable this
> a set of pages are mapped into the user process space that indicate the
> current state of the user events that have been registered. User
> processes can check if their event is hooked to a trace/probe, and if it
> is, emit the event data out via the write() syscall.
> 
> Two files are added to tracefs to accomplish this:
> user_events_mmap - This file is mmap'd into participating user mode
> processes to indicate event status.
> 
> user_events_data - This file is opened and register/delete ioctl's are
> issued to create/open/delete trace events that can be used for tracing.
> 
> The typical scenario is on process start to mmap user_events_mmap. Processes
> then register the events they plan to use via the REG ioctl. The return value
> of the ioctl indicates the byte in the mmap to use for status. The file that
> was used for the ioctl is now accepting data via write() to emit out into the
> trace event.
> 
> Psuedo code example of typical usage:
> page_fd = open("user_events_mmap", O_RDWR);
> page_data = mmap(NULL, PAGE_SIZE, PROT_READ, MAP_SHARED, page_fd, 0);
> 
> data_fd = open("user_events_data", O_RDWR);
> data_id = ioctl(data_fd, DIAG_IOCSREG, "test");
> 
> if (page_data[data_id]) write(data_fd, &payload, sizeof(payload));

What is the type of "page_data". I'd like to test it before accepting it.

From playing around, I see that page_data is of type char *.


> 
> User events are also exposed via the dynamic_events tracefs file for
> both create, delete and current status.
> 
> Simple example to register a user event via dynamic_events and get status:
>         echo ue:test >> dynamic_events
>         cat dynamic_events
>         ue:test
> 
> If an event is hooked to a probe, the probe hooked shows up:
>         echo 1 > events/user_events/test/enable
>         cat dynamic_events
>         ue:test (Used by ftrace)
> 
> Users can describe the trace event format via the following format:
>         name[;field1;field2]
> 
> Each field has the following format:
>         type\tname\tsize\toffset

BTW, the format should follow the way other probes are created. That is,
having a space between the name and field, and not a semicolon.

> 
> Example for char array with a size of 20 named msg:
>         echo -e 'ue:detailed;char[]\tmsg\t20\t0' >> dynamic_events
>         cat dynamic_events
>         ue:detailed;char[] msg
> 
> Data offsets are based on the data written out via write() and will be
> updated to reflect the correct offset in the trace_event fields. __data_loc
> types must be aware of the size of trace_entry/common properties to ensure
> proper decoding. An ioctl is provided that enables user mode processes that
> only have access to user_events_data that returns the correct offset to use
> within the data payload (nothing needs to be done on registration).
> 
> The above format is valid for both the ioctl and the dynamic_events file.
> 
> Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
> ---
>  kernel/trace/Kconfig             |  15 +
>  kernel/trace/Makefile            |   1 +
>  kernel/trace/trace_events_user.c | 845 +++++++++++++++++++++++++++++++
>  3 files changed, 861 insertions(+)
>  create mode 100644 kernel/trace/trace_events_user.c
> 
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index 3ee23f4d437f..deaaad421be4 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -725,6 +725,21 @@ config SYNTH_EVENTS
>  
>  	  If in doubt, say N.
>  
> +config USER_EVENTS
> +	bool "User trace events"
> +	select TRACING
> +	select DYNAMIC_EVENTS
> +	default n
> +	help
> +	  User trace events are user-defined trace events that
> +	  can be used like an existing kernel trace event.  User trace
> +	  events are generated by writing to a tracefs file.  User
> +	  processes can determine if their tracing events should be
> +	  generated by memory mapping a tracefs file and checking for
> +	  an associated byte being non-zero.
> +
> +	  If in doubt, say N.
> +
>  config HIST_TRIGGERS
>  	bool "Histogram triggers"
>  	depends on ARCH_HAVE_NMI_SAFE_CMPXCHG
> diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
> index b1c47ccf4f73..a653b255e89c 100644
> --- a/kernel/trace/Makefile
> +++ b/kernel/trace/Makefile
> @@ -80,6 +80,7 @@ obj-$(CONFIG_EVENT_TRACING) += trace_events_trigger.o
>  obj-$(CONFIG_TRACE_EVENT_INJECT) += trace_events_inject.o
>  obj-$(CONFIG_SYNTH_EVENTS) += trace_events_synth.o
>  obj-$(CONFIG_HIST_TRIGGERS) += trace_events_hist.o
> +obj-$(CONFIG_USER_EVENTS) += trace_events_user.o
>  obj-$(CONFIG_BPF_EVENTS) += bpf_trace.o
>  obj-$(CONFIG_KPROBE_EVENTS) += trace_kprobe.o
>  obj-$(CONFIG_TRACEPOINTS) += error_report-traces.o
> diff --git a/kernel/trace/trace_events_user.c b/kernel/trace/trace_events_user.c
> new file mode 100644
> index 000000000000..9afa72b55fa8
> --- /dev/null
> +++ b/kernel/trace/trace_events_user.c
> @@ -0,0 +1,845 @@
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
> +#include <linux/io.h>
> +#include <linux/ioctl.h>
> +#include <linux/jhash.h>
> +#include <linux/trace_events.h>
> +#include <linux/tracefs.h>
> +#include <linux/types.h>
> +#include <linux/uaccess.h>
> +#include "trace.h"
> +#include "trace_dynevent.h"
> +
> +#define USER_EVENTS_SYSTEM "user_events"
> +#define USER_EVENTS_PREFIX "ue:"
> +#define USER_EVENTS_PREFIX_LEN (sizeof(USER_EVENTS_PREFIX)-1)
> +
> +/* Bits 0-6 are for known probe types, Bit 7 is for unknown probes */
> +#define EVENT_BIT_FTRACE 0
> +#define EVENT_BIT_PERF 1
> +#define EVENT_BIT_OTHER 7
> +
> +#define EVENT_STATUS_FTRACE (1 << EVENT_BIT_FTRACE)
> +#define EVENT_STATUS_PERF (1 << EVENT_BIT_PERF)
> +#define EVENT_STATUS_OTHER (1 << EVENT_BIT_OTHER)
> +
> +#define FIELD_DEPTH_TYPE 0
> +#define FIELD_DEPTH_NAME 1
> +#define FIELD_DEPTH_SIZE 2
> +#define FIELD_DEPTH_OFFSET 3
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
> +#define DIAG_IOC_MAGIC '*'
> +#define DIAG_IOCSREG _IOW(DIAG_IOC_MAGIC, 0, char*)
> +#define DIAG_IOCSDEL _IOW(DIAG_IOC_MAGIC, 1, char*)
> +#define DIAG_IOCQLOCOFFSET _IO(DIAG_IOC_MAGIC, 2)

These obviously will need to go into a user abi header file.

> +
> +static char *register_page_data;
> +
> +static DEFINE_HASHTABLE(register_table, 4);
> +static DECLARE_BITMAP(page_bitmap, MAX_EVENTS);
> +
> +struct user_event {
> +	struct tracepoint tracepoint;
> +	struct trace_event_call call;
> +	struct trace_event_class class;
> +	struct dyn_event devent;
> +	struct hlist_node node;
> +	atomic_t refs;
> +	int index;
> +	char *args;
> +};
> +
> +#ifdef CONFIG_PERF_EVENTS
> +struct user_bpf_context {
> +	int udatalen;
> +	const char __user *udata;
> +};
> +#endif
> +
> +typedef void (*user_event_func_t) (struct user_event *user,
> +				   const char __user *udata,
> +				   size_t udatalen, void *tpdata);
> +
> +static int register_user_event(char *name, char *args,
> +			       struct user_event **newuser);
> +

[..]

> +static int __init trace_events_user_init(void)
> +{
> +	int ret;
> +
> +	/* Zero all bits beside 0 (which is reserved for failures) */
> +	bitmap_zero(page_bitmap, MAX_EVENTS);
> +	set_bit(0, page_bitmap);
> +
> +	register_page_data = kmalloc(MAX_EVENTS, GFP_KERNEL);

You want "kzalloc" here. Because when I read the map without adding
anything, I get:

   printf("%lx\n", *(unsigned long *)page_data);

Produces:

   ffffffff9065004e

But if I convert it to kzalloc() it gives me:

   0

Thus, you are exposing stale memory. If you want to expose this to
non-admin users, this is a major security leak.

-- Steve

> +
> +	if (!register_page_data)
> +		return -ENOMEM;
> +
> +	set_page_reservations(true);
> +
> +	ret = create_user_tracefs();
> +
> +	if (ret) {
> +		pr_warn("user_events could not register with tracefs\n");
> +		set_page_reservations(false);
> +		kfree(register_page_data);
> +		return ret;
> +	}
> +
> +	if (dyn_event_register(&user_event_dops))
> +		pr_warn("user_events could not register with dyn_events\n");
> +
> +	return 0;
> +}
> +
> +fs_initcall(trace_events_user_init);


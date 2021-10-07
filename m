Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA87AC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Oct 2021 14:17:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C69E261108
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Oct 2021 14:17:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242005AbhJGOTe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Oct 2021 10:19:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241774AbhJGOTe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Oct 2021 10:19:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15831610E6;
        Thu,  7 Oct 2021 14:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633616260;
        bh=HhRjJrw3Ksb9DfjgDbWP04ifVvu3DrunOrRolH4BuLU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cajSqv0IA40JjImpWjnGmYB9zwsS03MYmWWcnS3w0azuHXh9o93Sa7PGNvXUTgOjF
         q/dGKZyWiaXI0E/BlY7ZdkCqsvw0SbeeZjrvyNtQsDRqbBJSu1R6So5Tf1Fea99+lb
         o7OFmz3HpbLwvQaatuCvIsWAqMnSMVsmA6AKZ3fSp8a1Jyk6W/Ohk5FQrG+5ecCwSJ
         XeIpJ2Qn6JlCnWKE2oKhUkKdXYP2jqp+S6v4tDsfYNHh8fmEJARvuPbFprtxoYzrEg
         8YnjJkjxdIOfLw5H/zL1pFwDNw+23AadPw0eag1H2MpBda3grLY83X2V0KytIb0/CL
         PM6AmedZhfxjQ==
Date:   Thu, 7 Oct 2021 23:17:38 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] user_events: Enable user processes to create and write
 to trace events
Message-Id: <20211007231738.0626e348322dc09e7ebbf1d6@kernel.org>
In-Reply-To: <20211006175611.GA2995@kbox>
References: <20211005224428.2551-1-beaub@linux.microsoft.com>
        <20211007012827.99cd5795140cbb0c932e1b5a@kernel.org>
        <20211006175611.GA2995@kbox>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Beau,

On Wed, 6 Oct 2021 10:56:11 -0700
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> On Thu, Oct 07, 2021 at 01:28:27AM +0900, Masami Hiramatsu wrote:
> > > User processes often want to trace only when it's useful. To enable this
> > > a set of pages are mapped into the user process space that indicate the
> > > current state of the user events that have been registered. User
> > > processes can check if their event is hooked to a trace/probe, and if it
> > > is, emit the event data out via the write() syscall.
> > > 
> > > Two files are added to tracefs to accomplish this:
> > > user_events_mmap - This file is mmap'd into participating user mode
> > > processes to indicate event status.
> > 
> > It seems like the "method" is used for the file name of user_events_mmap,
> > instead of what is the purpose of the file.
> > What about "user_events_status" and show the informations (which program
> > made events and what tracer is using the events) when you read the file?
> > And when you mmap it, or when you ioctl to get mmapable fd, your program
> > can directly monitor the flags.
> > 
> This sounds good to me.
> 
> > > Psuedo code example of typical usage:
> > > page_fd = open("user_events_mmap", O_RDWR);
> > > page_data = mmap(NULL, PAGE_SIZE, PROT_READ, MAP_SHARED, page_fd, 0);
> > > 
> > > data_fd = open("user_events_data", O_RDWR);
> > > data_id = ioctl(data_fd, DIAG_IOCSREG, "test");
> > 
> > Hmm, if the data_id is same as the ID in events/*/*/format, it will
> > be queried by libtraceevent or libftrace, isn't it?
> > And also, if you can define the user-event via dynamic_event interface,
> > it should be used instead of using ioctl on data channel.
> > 
> These will not be the same ID. The data_id will be the offset within a
> page to check for status. We don't want to give user mode processes
> access to the entire tracefs, so we are isolating to a few files that
> will get wider access.

OK, but how to query the id of the event which has been made
from writing dynamic_events file? (maybe query from name by
ioctl?)

> > Oh, I thought that the each user events should not be accessible from other
> > processes. And I got the reason, if you run different processes (instances)
> > at the same time, those may need to share same events.
> > 
> > In summary, I would like to suggest following interface to split
> > the control, monitor and data channels.
> > 
> > - dynamic_events : Add new 'u' command but derived from synth event (or share the parser)
> > - user_event_status : monitor status by mmap, and showing human-readable status by read.
> >                       query offset by ioctl.
> Agree with the above, cool idea.
> 
> > - user_event_data : just write data (binary packet).
> > 
> We still require the ioctl to register and cannot bet solely on
> dynamic_events. We want a fast way to register events on process startup
> and get the data_id back as fast as possible.

What about using ioctl on 'user_event_status' file?
But in this case, the name is not showing the function.

Then, what about renaming it as simply 'user_events'? :)
This file will show the current user events as similar to synth_events,
in addition, it will show the current status in "# comment".

$ echo "user1 u32 arg1; u64 arg2" > user_events
$ cat user_events
user1 u32 arg1; u64 arg2
$ echo 1 > events/user_events/user1/enable
$ cat user_events
user1 u32 arg1; u64 arg2 # Used by ftrace

In addition, 
- user-process can do ioctl() to query offset instead of id from name.
- user-process can do mmap() the file to monitor the status.

> The other thing is we need ref counting to know if the event is busy.
> Having the ID in the packet avoids having a fd per-event, but it also
> makes ref counting process lifetime of each event quite hard.

Hmm, I don't think so. You can use an array of the pointer to
events on the private data of the struct file.
When you add (or start using) an event (this is identified by ioctl),
you can increment the event refcount and add it to the array.
When the file is closed (in exiting process), it will loop on the
array and decrement the refcount for each event.
Then, after all tracers disabled the event, ftrace can remove the
event in background (unless it is defined through 'dynamic_events' or
'user_events').

> > User written binary packet will be based on the event format, for example,
> > 
> > echo "u:foo u64 mydata; char[] msg"
> > 
> > /sys/kernel/debug/tracing # cat events/user_events/foo/format 
> > name: foo
> > ID: 1234
> > format:
> > 	field:unsigned short common_type;	offset:0;	size:2;	signed:0;
> > 	field:unsigned char common_flags;	offset:2;	size:1;	signed:0;
> > 	field:unsigned char common_preempt_count;	offset:3;	size:1;	signed:0;
> > 	field:int common_pid;	offset:4;	size:4;	signed:1;
> > 
> > 	field:u64 mydata;	offset:8;	size:8;	signed:0;
> > 	field:__data_loc char[] msg;	offset:16;	size:4;	signed:1;
> > 
> > Then, the binary should be formatted as;
> > 
> > [u32 ID][u64 mydata][u16 msg-len][u16 msg-offs][msg-data]
> > 
> > Then user will generate a packet like;
> > 
> > [1234][0xdeadbeef][12][16]["Hello world"]
> > 
> > And write it to the user_event_data file.
> > 
> > Kernel will verify len and offs if there is a dynamic array (string),
> > and record common fields, update msg-offs (because it will be shift the
> > size of common fields) and record user-data.
> > 
> We want to avoid the kernel component touching any of the user data. For
> example eBPF programs will parse the data directly from definitions
> provided by the user. If the kernel side changed what the user expected
> from their side the eBPF program would fail to decode.

Sorry, that's not doable unless we introduce a new __rel_loc__ attribute
to the ftrace (and libtraceevent). With that, the dynamic data 
(like string) offset can be written as the offset from itself.

> > [1234][0xdeadbeef][12][0]["Hello world"]

Anyway, as far as you are using trace event the data format itself is
the contract between kernel and user, because *kernel* also has to 
decode it (e.g. user will read the 'trace' file.) and other tools
like perf has to decode it too.

The kernel will not modify the data (again with __rel_loc__ attr) but
it will add the common_* field and event ID as a header to its buffer
when record it.

> We also want
> predicate filtering to work as cheap as possible. I would really like to
> keep offset manipulation entirely in the user space to avoid confusion
> across the various tracing mechanisms and avoid probing the user data
> upon each call (eBPF programs only selectively probe in data).

OK, so let's add __rel_loc__ attribute. The rel_loc type will be

struct rel_loc {
	uint16_t len;	/* The data size (including '\0' if string )*/
	uint16_t offs;	/* The offset of actual data from this field */
} __packed;

Hmm, btw, this will be good for probe events... I don't need to pass
the base address with this attribute.

> 
> > I also think we need a user-mode library for the above interface
> > so that user can easily bind to each application and language.
> I have a few colleagues testing some ideas out about this. Should I have
> them reach out to you for ideas or collaboration?

Yeah, we always collaborate on LKML and other MLs :)

Thank you,

> 
> Thanks,
> -Beau


-- 
Masami Hiramatsu <mhiramat@kernel.org>

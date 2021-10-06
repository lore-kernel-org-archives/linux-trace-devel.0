Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3FFCC433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed,  6 Oct 2021 17:56:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE3EB61183
	for <linux-trace-devel@archiver.kernel.org>; Wed,  6 Oct 2021 17:56:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbhJFR6I (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 6 Oct 2021 13:58:08 -0400
Received: from linux.microsoft.com ([13.77.154.182]:41218 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbhJFR6I (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 6 Oct 2021 13:58:08 -0400
Received: from kbox (unknown [24.17.193.74])
        by linux.microsoft.com (Postfix) with ESMTPSA id C1D3420B85E6;
        Wed,  6 Oct 2021 10:56:15 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C1D3420B85E6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1633542975;
        bh=zlh40GCu3pIKcKZPC8C82499m/D10vUebIvmddR7Y0I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sNlaVDy6wiBRNlnvvvxeG/1KoSxqeRLnvsR3n8Beul9Ggm8sIXQqq+nLAALPVCbjp
         D9UlqR6dyBVxK1KqB0PZUXJHEHq49MgLVoyywEdve8XZ0b95cTePrinYJHjyTQDzh/
         leydz+GbPJ1EwREPmusya66Rtt+Bzvn8P6Jj7TCA=
Date:   Wed, 6 Oct 2021 10:56:11 -0700
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] user_events: Enable user processes to create and write
 to trace events
Message-ID: <20211006175611.GA2995@kbox>
References: <20211005224428.2551-1-beaub@linux.microsoft.com>
 <20211007012827.99cd5795140cbb0c932e1b5a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007012827.99cd5795140cbb0c932e1b5a@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Oct 07, 2021 at 01:28:27AM +0900, Masami Hiramatsu wrote:
> > User processes often want to trace only when it's useful. To enable this
> > a set of pages are mapped into the user process space that indicate the
> > current state of the user events that have been registered. User
> > processes can check if their event is hooked to a trace/probe, and if it
> > is, emit the event data out via the write() syscall.
> > 
> > Two files are added to tracefs to accomplish this:
> > user_events_mmap - This file is mmap'd into participating user mode
> > processes to indicate event status.
> 
> It seems like the "method" is used for the file name of user_events_mmap,
> instead of what is the purpose of the file.
> What about "user_events_status" and show the informations (which program
> made events and what tracer is using the events) when you read the file?
> And when you mmap it, or when you ioctl to get mmapable fd, your program
> can directly monitor the flags.
> 
This sounds good to me.

> > Psuedo code example of typical usage:
> > page_fd = open("user_events_mmap", O_RDWR);
> > page_data = mmap(NULL, PAGE_SIZE, PROT_READ, MAP_SHARED, page_fd, 0);
> > 
> > data_fd = open("user_events_data", O_RDWR);
> > data_id = ioctl(data_fd, DIAG_IOCSREG, "test");
> 
> Hmm, if the data_id is same as the ID in events/*/*/format, it will
> be queried by libtraceevent or libftrace, isn't it?
> And also, if you can define the user-event via dynamic_event interface,
> it should be used instead of using ioctl on data channel.
> 
These will not be the same ID. The data_id will be the offset within a
page to check for status. We don't want to give user mode processes
access to the entire tracefs, so we are isolating to a few files that
will get wider access.

> Oh, I thought that the each user events should not be accessible from other
> processes. And I got the reason, if you run different processes (instances)
> at the same time, those may need to share same events.
> 
> In summary, I would like to suggest following interface to split
> the control, monitor and data channels.
> 
> - dynamic_events : Add new 'u' command but derived from synth event (or share the parser)
> - user_event_status : monitor status by mmap, and showing human-readable status by read.
>                       query offset by ioctl.
Agree with the above, cool idea.

> - user_event_data : just write data (binary packet).
> 
We still require the ioctl to register and cannot bet solely on
dynamic_events. We want a fast way to register events on process startup
and get the data_id back as fast as possible.

The other thing is we need ref counting to know if the event is busy.
Having the ID in the packet avoids having a fd per-event, but it also
makes ref counting process lifetime of each event quite hard.

> User written binary packet will be based on the event format, for example,
> 
> echo "u:foo u64 mydata; char[] msg"
> 
> /sys/kernel/debug/tracing # cat events/user_events/foo/format 
> name: foo
> ID: 1234
> format:
> 	field:unsigned short common_type;	offset:0;	size:2;	signed:0;
> 	field:unsigned char common_flags;	offset:2;	size:1;	signed:0;
> 	field:unsigned char common_preempt_count;	offset:3;	size:1;	signed:0;
> 	field:int common_pid;	offset:4;	size:4;	signed:1;
> 
> 	field:u64 mydata;	offset:8;	size:8;	signed:0;
> 	field:__data_loc char[] msg;	offset:16;	size:4;	signed:1;
> 
> Then, the binary should be formatted as;
> 
> [u32 ID][u64 mydata][u16 msg-len][u16 msg-offs][msg-data]
> 
> Then user will generate a packet like;
> 
> [1234][0xdeadbeef][12][16]["Hello world"]
> 
> And write it to the user_event_data file.
> 
> Kernel will verify len and offs if there is a dynamic array (string),
> and record common fields, update msg-offs (because it will be shift the
> size of common fields) and record user-data.
> 
We want to avoid the kernel component touching any of the user data. For
example eBPF programs will parse the data directly from definitions
provided by the user. If the kernel side changed what the user expected
from their side the eBPF program would fail to decode. We also want
predicate filtering to work as cheap as possible. I would really like to
keep offset manipulation entirely in the user space to avoid confusion
across the various tracing mechanisms and avoid probing the user data
upon each call (eBPF programs only selectively probe in data).

> I also think we need a user-mode library for the above interface
> so that user can easily bind to each application and language.
I have a few colleagues testing some ideas out about this. Should I have
them reach out to you for ideas or collaboration?

Thanks,
-Beau

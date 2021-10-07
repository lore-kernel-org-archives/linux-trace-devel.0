Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 524BBC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Oct 2021 16:22:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 385AB6120D
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Oct 2021 16:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242132AbhJGQYD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Oct 2021 12:24:03 -0400
Received: from linux.microsoft.com ([13.77.154.182]:38676 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241846AbhJGQYC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Oct 2021 12:24:02 -0400
Received: from kbox (unknown [24.17.193.74])
        by linux.microsoft.com (Postfix) with ESMTPSA id C7BE320B85E6;
        Thu,  7 Oct 2021 09:22:08 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C7BE320B85E6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1633623728;
        bh=CDSRIVDFRpqoWw/RlGyx+QItO09Jv8mLMfFRIxA6vh0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HwPBp2llXPgVHLw2YD6CayYj6eROCgYGzd2LNTAjIsrYfXDBtW7FaL8zzoPKp11Ki
         4ceEmeFlOHHSa7XspYcWeb/Bff3R8eXtub4ngQ51YWqNxRX3gExmKL5SyKvbxpkrl8
         LO/MYKFoYJr5sSaL5kV12fN7R4SkknRJqxfWtgXg=
Date:   Thu, 7 Oct 2021 09:22:04 -0700
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] user_events: Enable user processes to create and write
 to trace events
Message-ID: <20211007162204.GA30947@kbox>
References: <20211005224428.2551-1-beaub@linux.microsoft.com>
 <20211007012827.99cd5795140cbb0c932e1b5a@kernel.org>
 <20211006175611.GA2995@kbox>
 <20211007231738.0626e348322dc09e7ebbf1d6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007231738.0626e348322dc09e7ebbf1d6@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Oct 07, 2021 at 11:17:38PM +0900, Masami Hiramatsu wrote:
> > > > Psuedo code example of typical usage:
> > > > page_fd = open("user_events_mmap", O_RDWR);
> > > > page_data = mmap(NULL, PAGE_SIZE, PROT_READ, MAP_SHARED, page_fd, 0);
> > > > 
> > > > data_fd = open("user_events_data", O_RDWR);
> > > > data_id = ioctl(data_fd, DIAG_IOCSREG, "test");
> > > 
> > > Hmm, if the data_id is same as the ID in events/*/*/format, it will
> > > be queried by libtraceevent or libftrace, isn't it?
> > > And also, if you can define the user-event via dynamic_event interface,
> > > it should be used instead of using ioctl on data channel.
> > > 
> > These will not be the same ID. The data_id will be the offset within a
> > page to check for status. We don't want to give user mode processes
> > access to the entire tracefs, so we are isolating to a few files that
> > will get wider access.
> 
> OK, but how to query the id of the event which has been made
> from writing dynamic_events file? (maybe query from name by
> ioctl?)
> 
Yes, you can either do ioctl or with the v2 patch you can now just cat
user_events_status as you indicated previously to do :)

> > We still require the ioctl to register and cannot bet solely on
> > dynamic_events. We want a fast way to register events on process startup
> > and get the data_id back as fast as possible.
> 
> What about using ioctl on 'user_event_status' file?
> But in this case, the name is not showing the function.
> 
> Then, what about renaming it as simply 'user_events'? :)
> This file will show the current user events as similar to synth_events,
> in addition, it will show the current status in "# comment".
> 
> $ echo "user1 u32 arg1; u64 arg2" > user_events
> $ cat user_events
> user1 u32 arg1; u64 arg2
> $ echo 1 > events/user_events/user1/enable
> $ cat user_events
> user1 u32 arg1; u64 arg2 # Used by ftrace
> 
> In addition, 
> - user-process can do ioctl() to query offset instead of id from name.
> - user-process can do mmap() the file to monitor the status.
> 
Please see v2 patch, I do this pattern except it's '(Used by ftrace)'
instead of '# Used by ftrace'.

Format is id:name status

> > The other thing is we need ref counting to know if the event is busy.
> > Having the ID in the packet avoids having a fd per-event, but it also
> > makes ref counting process lifetime of each event quite hard.
> 
> Hmm, I don't think so. You can use an array of the pointer to
> events on the private data of the struct file.
> When you add (or start using) an event (this is identified by ioctl),
> you can increment the event refcount and add it to the array.
> When the file is closed (in exiting process), it will loop on the
> array and decrement the refcount for each event.
> Then, after all tracers disabled the event, ftrace can remove the
> event in background (unless it is defined through 'dynamic_events' or
> 'user_events').
> 
Yes, I didn't say it's impossible :) It's quite hard and takes a lot
more management. I don't see a clear benefit to that approach, why is it
better than an fd lifetime? Not trying to be difficult, just trying to
be pragmatic about what approach is best.

> > We want to avoid the kernel component touching any of the user data. For
> > example eBPF programs will parse the data directly from definitions
> > provided by the user. If the kernel side changed what the user expected
> > from their side the eBPF program would fail to decode.
> 
> Sorry, that's not doable unless we introduce a new __rel_loc__ attribute
> to the ftrace (and libtraceevent). With that, the dynamic data 
> (like string) offset can be written as the offset from itself.
> 
With this patch I have no problem getting hist, trigger and filter to
work since the user is providing all correct offsets. Can you help me
understand why this won't work? (It appears to work well without the
kernel modifying user provided memory).

> > > [1234][0xdeadbeef][12][0]["Hello world"]
> 
> Anyway, as far as you are using trace event the data format itself is
> the contract between kernel and user, because *kernel* also has to 
> decode it (e.g. user will read the 'trace' file.) and other tools
> like perf has to decode it too.
> 
> The kernel will not modify the data (again with __rel_loc__ attr) but
> it will add the common_* field and event ID as a header to its buffer
> when record it.
> 
Adding the common fields is fine, and works well with the current patch.
I've been able to decode in ftrace, perf and eBPF without any issues for
common types. __data_loc needs user mode cooperation, but no other type
does. I've also tested hist, filter and trigger and all appear to work
as I understand them to.

> > We also want
> > predicate filtering to work as cheap as possible. I would really like to
> > keep offset manipulation entirely in the user space to avoid confusion
> > across the various tracing mechanisms and avoid probing the user data
> > upon each call (eBPF programs only selectively probe in data).
> 
> OK, so let's add __rel_loc__ attribute. The rel_loc type will be
> 
> struct rel_loc {
> 	uint16_t len;	/* The data size (including '\0' if string )*/
> 	uint16_t offs;	/* The offset of actual data from this field */
> } __packed;
> 
> Hmm, btw, this will be good for probe events... I don't need to pass
> the base address with this attribute.
> 
What's the difference between __rel_loc__ and __data_loc? Seems like
instead of just offset it's length + offset?

Thanks,
-Beau

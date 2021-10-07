Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C695C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Oct 2021 23:12:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42F4061212
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Oct 2021 23:12:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233176AbhJGXOq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Oct 2021 19:14:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233133AbhJGXOq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Oct 2021 19:14:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7357B6120C;
        Thu,  7 Oct 2021 23:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633648372;
        bh=j2ijrstg5AFmgFINghb4xqC10GPekXB1+ETRU2aORfU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y1LsFf7NkMhIlbP4SR/AFY4f6DdGQ46x2ZP6w29wHpofZ6pIvJsa/zSXoR9+A1QCQ
         JnPplAGfQZ2tjxBI9Z2FeeELrQUKOsP8AeCYtexXyY2visqoDFG1aDlsWg1ceF9dRv
         EuT1EWBuS9ZXYWrc5jADnJ2CEhBCmWSHZwNs0pT+Ygotqz4L6+7hFJ2jdCBoaYblQe
         z54vl5qyoNu2a+En08IRNVI8d5DTCyQ9dEbEGDe5UQqr0aZriOfLY7RI9aL3CcLhwp
         Ekktsjgv5ZWK9uEFIFe9lYxP4oilnm6c5QXyNMWPONAqTgW+suDdKYPx6cPaSj0E3D
         v8aS4Vk8a/7Mg==
Date:   Fri, 8 Oct 2021 08:12:49 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] user_events: Enable user processes to create and write
 to trace events
Message-Id: <20211008081249.8fbacc4f5d9fa7cf2e488d21@kernel.org>
In-Reply-To: <20211007162204.GA30947@kbox>
References: <20211005224428.2551-1-beaub@linux.microsoft.com>
        <20211007012827.99cd5795140cbb0c932e1b5a@kernel.org>
        <20211006175611.GA2995@kbox>
        <20211007231738.0626e348322dc09e7ebbf1d6@kernel.org>
        <20211007162204.GA30947@kbox>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 7 Oct 2021 09:22:04 -0700
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> On Thu, Oct 07, 2021 at 11:17:38PM +0900, Masami Hiramatsu wrote:
> > > > > Psuedo code example of typical usage:
> > > > > page_fd = open("user_events_mmap", O_RDWR);
> > > > > page_data = mmap(NULL, PAGE_SIZE, PROT_READ, MAP_SHARED, page_fd, 0);
> > > > > 
> > > > > data_fd = open("user_events_data", O_RDWR);
> > > > > data_id = ioctl(data_fd, DIAG_IOCSREG, "test");
> > > > 
> > > > Hmm, if the data_id is same as the ID in events/*/*/format, it will
> > > > be queried by libtraceevent or libftrace, isn't it?
> > > > And also, if you can define the user-event via dynamic_event interface,
> > > > it should be used instead of using ioctl on data channel.
> > > > 
> > > These will not be the same ID. The data_id will be the offset within a
> > > page to check for status. We don't want to give user mode processes
> > > access to the entire tracefs, so we are isolating to a few files that
> > > will get wider access.
> > 
> > OK, but how to query the id of the event which has been made
> > from writing dynamic_events file? (maybe query from name by
> > ioctl?)
> > 
> Yes, you can either do ioctl or with the v2 patch you can now just cat
> user_events_status as you indicated previously to do :)

OK, let me check the v2.

> 
> > > We still require the ioctl to register and cannot bet solely on
> > > dynamic_events. We want a fast way to register events on process startup
> > > and get the data_id back as fast as possible.
> > 
> > What about using ioctl on 'user_event_status' file?
> > But in this case, the name is not showing the function.
> > 
> > Then, what about renaming it as simply 'user_events'? :)
> > This file will show the current user events as similar to synth_events,
> > in addition, it will show the current status in "# comment".
> > 
> > $ echo "user1 u32 arg1; u64 arg2" > user_events
> > $ cat user_events
> > user1 u32 arg1; u64 arg2
> > $ echo 1 > events/user_events/user1/enable
> > $ cat user_events
> > user1 u32 arg1; u64 arg2 # Used by ftrace
> > 
> > In addition, 
> > - user-process can do ioctl() to query offset instead of id from name.
> > - user-process can do mmap() the file to monitor the status.
> > 
> Please see v2 patch, I do this pattern except it's '(Used by ftrace)'
> instead of '# Used by ftrace'.
> 
> Format is id:name status

Hm, why I suggested to use "# status" is that the comment will be
removed when writing it. So you can do

cat user_events > ~/saved_events
(reboot)
cat ~/saved_events > user_events

to restore events :)

> 
> > > The other thing is we need ref counting to know if the event is busy.
> > > Having the ID in the packet avoids having a fd per-event, but it also
> > > makes ref counting process lifetime of each event quite hard.
> > 
> > Hmm, I don't think so. You can use an array of the pointer to
> > events on the private data of the struct file.
> > When you add (or start using) an event (this is identified by ioctl),
> > you can increment the event refcount and add it to the array.
> > When the file is closed (in exiting process), it will loop on the
> > array and decrement the refcount for each event.
> > Then, after all tracers disabled the event, ftrace can remove the
> > event in background (unless it is defined through 'dynamic_events' or
> > 'user_events').
> > 
> Yes, I didn't say it's impossible :) It's quite hard and takes a lot
> more management. I don't see a clear benefit to that approach, why is it
> better than an fd lifetime? Not trying to be difficult, just trying to
> be pragmatic about what approach is best.

I'm not sure this point, you mean 1 fd == 1 event model?

> > > We want to avoid the kernel component touching any of the user data. For
> > > example eBPF programs will parse the data directly from definitions
> > > provided by the user. If the kernel side changed what the user expected
> > > from their side the eBPF program would fail to decode.
> > 
> > Sorry, that's not doable unless we introduce a new __rel_loc__ attribute
> > to the ftrace (and libtraceevent). With that, the dynamic data 
> > (like string) offset can be written as the offset from itself.
> > 
> With this patch I have no problem getting hist, trigger and filter to
> work since the user is providing all correct offsets. Can you help me
> understand why this won't work? (It appears to work well without the
> kernel modifying user provided memory).

OK, let me check it.

> 
> > > > [1234][0xdeadbeef][12][0]["Hello world"]
> > 
> > Anyway, as far as you are using trace event the data format itself is
> > the contract between kernel and user, because *kernel* also has to 
> > decode it (e.g. user will read the 'trace' file.) and other tools
> > like perf has to decode it too.
> > 
> > The kernel will not modify the data (again with __rel_loc__ attr) but
> > it will add the common_* field and event ID as a header to its buffer
> > when record it.
> > 
> Adding the common fields is fine, and works well with the current patch.
> I've been able to decode in ftrace, perf and eBPF without any issues for
> common types. __data_loc needs user mode cooperation, but no other type
> does. I've also tested hist, filter and trigger and all appear to work
> as I understand them to.

__data_loc has the data offset field, which is the offset from the
entry of the recorded event on the ring buffer. Since there are
common fields, the offset is not the offset from user given buffer.
So it must be changed by kernel.
(Note that common fields expected to exist in all events, so that
user scripts can process the fields commonly)

> 
> > > We also want
> > > predicate filtering to work as cheap as possible. I would really like to
> > > keep offset manipulation entirely in the user space to avoid confusion
> > > across the various tracing mechanisms and avoid probing the user data
> > > upon each call (eBPF programs only selectively probe in data).
> > 
> > OK, so let's add __rel_loc__ attribute. The rel_loc type will be
> > 
> > struct rel_loc {
> > 	uint16_t len;	/* The data size (including '\0' if string )*/
> > 	uint16_t offs;	/* The offset of actual data from this field */
> > } __packed;
> > 
> > Hmm, btw, this will be good for probe events... I don't need to pass
> > the base address with this attribute.
> > 
> What's the difference between __rel_loc__ and __data_loc? Seems like
> instead of just offset it's length + offset?

In my idea, rel_loc is similar to the data_loc. It has the offset, but
the offset is the data offset from the rel_loc, not from the entry of
the recorded data. So kernel doesn't need to adjust it.

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>

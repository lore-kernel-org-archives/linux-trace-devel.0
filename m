Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 225C7C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 00:05:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0870361073
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 00:05:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232682AbhJHAHj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Oct 2021 20:07:39 -0400
Received: from linux.microsoft.com ([13.77.154.182]:58452 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbhJHAHj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Oct 2021 20:07:39 -0400
Received: from kbox (unknown [24.17.193.74])
        by linux.microsoft.com (Postfix) with ESMTPSA id B3F4120B8008;
        Thu,  7 Oct 2021 17:05:44 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B3F4120B8008
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1633651544;
        bh=RmI9Lx22hJ2UVt+L74c3JdmPt+EdeZuq3lpibVLBeaY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I4Sh7OBDXSJGGgoTnXq5wc3XMwByKT5uBNThYv46TDiiw9/tWia4wZgWClcf3eevU
         at6F7vyr4SamuXh/fpMnyECKM/rVRTwxOKeaoS6SiVLkqxj4VkCK1PBMfbgyd94uwx
         /SDWHzDTRP/lpDk2jST95DFp+n3FvF5aQ98EI8F4=
Date:   Thu, 7 Oct 2021 17:05:40 -0700
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] user_events: Enable user processes to create and write
 to trace events
Message-ID: <20211008000540.GA31220@kbox>
References: <20211005224428.2551-1-beaub@linux.microsoft.com>
 <20211007012827.99cd5795140cbb0c932e1b5a@kernel.org>
 <20211006175611.GA2995@kbox>
 <20211007231738.0626e348322dc09e7ebbf1d6@kernel.org>
 <20211007162204.GA30947@kbox>
 <20211008081249.8fbacc4f5d9fa7cf2e488d21@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211008081249.8fbacc4f5d9fa7cf2e488d21@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Oct 08, 2021 at 08:12:49AM +0900, Masami Hiramatsu wrote:
> > Please see v2 patch, I do this pattern except it's '(Used by ftrace)'
> > instead of '# Used by ftrace'.
> > 
> > Format is id:name status
> 
> Hm, why I suggested to use "# status" is that the comment will be
> removed when writing it. So you can do
> 
> cat user_events > ~/saved_events
> (reboot)
> cat ~/saved_events > user_events
> 
> to restore events :)
> 
Nice, good idea.

> > 
> > > > The other thing is we need ref counting to know if the event is busy.
> > > > Having the ID in the packet avoids having a fd per-event, but it also
> > > > makes ref counting process lifetime of each event quite hard.
> > > 
> > > Hmm, I don't think so. You can use an array of the pointer to
> > > events on the private data of the struct file.
> > > When you add (or start using) an event (this is identified by ioctl),
> > > you can increment the event refcount and add it to the array.
> > > When the file is closed (in exiting process), it will loop on the
> > > array and decrement the refcount for each event.
> > > Then, after all tracers disabled the event, ftrace can remove the
> > > event in background (unless it is defined through 'dynamic_events' or
> > > 'user_events').
> > > 
> > Yes, I didn't say it's impossible :) It's quite hard and takes a lot
> > more management. I don't see a clear benefit to that approach, why is it
> > better than an fd lifetime? Not trying to be difficult, just trying to
> > be pragmatic about what approach is best.
> 
> I'm not sure this point, you mean 1 fd == 1 event model?
> 
Yeah, I like the idea of not having an fd per event. I want to make
sure the complexity is worth it. Is the overhead of an FD per event in
user space too much? What happens to the first 4 bytes (ID)? Does it not
show up in the buffer? This would be fine as long as the rel_loc idea
gets into ftrace, etc.

This would require a global array as well as a local per-FD array. I'm
wondering if the per-FD array becoming large mitigates the gain by
simply having an FD per-event.

> > > > We also want
> > > > predicate filtering to work as cheap as possible. I would really like to
> > > > keep offset manipulation entirely in the user space to avoid confusion
> > > > across the various tracing mechanisms and avoid probing the user data
> > > > upon each call (eBPF programs only selectively probe in data).
> > > 
> > > OK, so let's add __rel_loc__ attribute. The rel_loc type will be
> > > 
> > > struct rel_loc {
> > > 	uint16_t len;	/* The data size (including '\0' if string )*/
> > > 	uint16_t offs;	/* The offset of actual data from this field */
> > > } __packed;
> > > 
> > > Hmm, btw, this will be good for probe events... I don't need to pass
> > > the base address with this attribute.
> > > 
> > What's the difference between __rel_loc__ and __data_loc? Seems like
> > instead of just offset it's length + offset?
> 
> In my idea, rel_loc is similar to the data_loc. It has the offset, but
> the offset is the data offset from the rel_loc, not from the entry of
> the recorded data. So kernel doesn't need to adjust it.
> 
Got it, makes sense and would eliminate the need for the IOCTL for
offsets. I like it.

Thanks,
-Beau
> Thank you,
> 
> -- 
> Masami Hiramatsu <mhiramat@kernel.org>

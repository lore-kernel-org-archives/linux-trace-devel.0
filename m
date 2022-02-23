Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92543C433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Feb 2022 17:25:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239459AbiBWR0A (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Feb 2022 12:26:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242746AbiBWRZ7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Feb 2022 12:25:59 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CD14D5370A
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Feb 2022 09:25:31 -0800 (PST)
Received: from kbox (c-73-140-2-214.hsd1.wa.comcast.net [73.140.2.214])
        by linux.microsoft.com (Postfix) with ESMTPSA id 842F620C31B2;
        Wed, 23 Feb 2022 09:25:31 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 842F620C31B2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1645637131;
        bh=xvhRs9xQJDRmXSKcAjF+wdAXsxhlCc4PS5kelJrfJHg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KrUld6ZInZCE6158hiueA+BnNyYsD3bWeC6xqxd6gjqJaN4yNb+wagyJdpwpcNQxr
         BTsLCa+xM+UH+bPav1aVGjyd76wYG7FAuxCOzc0WmiBtMcgyFeYm/RO4dyvVhBlZTU
         ALKFT6CG0ojU89UNBHYYW6b7c9QK7idJE9PYek5Q=
Date:   Wed, 23 Feb 2022 09:25:25 -0800
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] libtracefs: Add unit tests for user_events
Message-ID: <20220223172525.GA1792@kbox>
References: <20220222232316.14640-1-beaub@linux.microsoft.com>
 <20220222232316.14640-4-beaub@linux.microsoft.com>
 <20220223101715.1009bd6f@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220223101715.1009bd6f@gandalf.local.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Feb 23, 2022 at 10:17:15AM -0500, Steven Rostedt wrote:
> On Tue, 22 Feb 2022 15:23:16 -0800
> Beau Belgrave <beaub@linux.microsoft.com> wrote:
> 
> > Adds unit tests for user_events when available. Ensures APIs are working
> > correctly and appropriate errors are being returned.
> > 
> > Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
> > ---
> >  utest/tracefs-utest.c | 233 ++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 233 insertions(+)
> > 
> 
> OK, so I couldn't get the selftest working because I didn't have
> user_events.h. I then worked to get that, but the selftest still failed
> with:
> 

The suspense is killing me, what did it fail with? :) (Guessing you saw
the fprintf message when I simulate a failure).

> After thinking about this a bit, I've decided that I'll release 1.3 without
> this patch series.
> 

No worries.

> The reason being, I want 1.3 to get into distros ASAP. As adding this patch
> series will put a dependency on user_events.h (yes it builds without it,
> but distros want everything that it can build applied), then that puts a
> dependency on 1.3 to having user_events.h available, which may be a while
> as it has to get into 5.18, and then slowly move to the distro kernels.
> 

Understood.

> If distros did build it without user_events.h and then later on with
> user_evnets.h then we have two versions of 1.3 where one supports
> user_events and one does not. And you can not use versioning to determine
> if your application will link to the library or not.
> 
> With all this in mind, I've decided to hold off this to libtracefs 1.4, and
> when user_events is solidly in the kernel.
> 
> But I'm very excited to have this work in both the kernel and libtracefs. I
> just want it properly done though.
> 

Yeah, do you want me to send out a v3 with some of the fixes? Or have
you put this into a branch somewhere already (I saw your other patch on
top of this one). I fixed some style nits that were bugging me, as they
didn't align to the kernel style.

Thanks,
-Beau

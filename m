Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8535C4332F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 20 Dec 2022 21:00:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234346AbiLTVAJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 20 Dec 2022 16:00:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234282AbiLTVAI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 20 Dec 2022 16:00:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00D425592
        for <linux-trace-devel@vger.kernel.org>; Tue, 20 Dec 2022 13:00:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF6B1B8169F
        for <linux-trace-devel@vger.kernel.org>; Tue, 20 Dec 2022 21:00:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2730EC433D2;
        Tue, 20 Dec 2022 21:00:04 +0000 (UTC)
Date:   Tue, 20 Dec 2022 16:00:02 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Mike Frysinger <vapier@google.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Ross Zwisler <zwisler@google.com>
Subject: Re: [PATCH] libtraceevent: Have 32 bit compile with
 -D_FILE_OFFSET_BITS=64
Message-ID: <20221220160002.1a34d937@gandalf.local.home>
In-Reply-To: <CAAbOScnLETawvZYhZnhVMP_rs6tYEty1-LcWGD9JcQX5tbQW5A@mail.gmail.com>
References: <20221219173414.032e2124@gandalf.local.home>
        <CAAbOScnLETawvZYhZnhVMP_rs6tYEty1-LcWGD9JcQX5tbQW5A@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 20 Dec 2022 14:36:11 -0500
Mike Frysinger <vapier@google.com> wrote:

> On Mon, Dec 19, 2022 at 5:34 PM Steven Rostedt wrote:
> > +# Make sure 32 bit on 64 bit doesn't have stat() bugs.  
> 
> i don't know what you're trying to say with "32 bit on 64 bit".  you
> mean a 32 bit binary (which ABI?) with a 64 bit kernel ?  or something
> else ?
> 
> the problem is entirely with using 32 bit filesystem interfaces.
> there are no other runtime requirements, either in the userland or
> kernel land.  filesystems moved to 64 bit fields in a number of places
> long ago regardless of the userland or kernel ABIs.
> 
> saying "32 bit" or "64 bit" is imprecise.  is x86_64's x32 & aarch64's
> ilp32 ABI "32 bit" ?  or is it "64 bit" ?  what about Window's x64
> (LLP64) ?
> https://en.wikipedia.org/wiki/64-bit_computing#64-bit_data_models
> https://unix.org/version2/whatsnew/lp64_wp.html
> 
> usually it's better to specify ABI names and/or specific types so
> people know what you're trying to cater to.

You are technically correct. Practically speaking, 32 bit architectures are
now mostly for niche devices that are most likely never going to see this
issue. My main fear was for 32 bit applications running on 64 bit kernels
where this is much more likely to be an issue. But I agree, I shouldn't
have made it sound like that's the only place it is an issue.

> 
> > +ifeq ($(shell echo '' | $(CPP) -dM - | grep __SIZEOF_LONG__ | cut -d' ' -f3),4)
> > +       CFLAGS += -D_FILE_OFFSET_BITS=64
> > +endif  
> 
> why do you need to sniff the size of long ?  -D_FILE_OFFSET_BITS=64
> should work fine regardless of the target ABI.
> 
> especially because you're assuming sizeof(long) == sizeof(off_t) which
> is not guaranteed anywhere.  on newer ABIs, like x32, sizeof(off_t) is
> always 64-bit while sizeof(long) is 32-bit.  i don't know if there's a
> sizeof(long) == 8 & sizeof(off_t) == 4 ABI, but i wouldn't be
> surprised if it showed up.  mips o64 or something wonky.
> 
> afaik, the exact output of the preprocessor isn't specified by a
> standard, and it has changed subtly in the past.  so i wouldn't rely
> on it in general.  something like `echo __SIZEOF_LONG__ | $(CPP) -E -P
> - | tail -n1` would be a lot more reliable -- you aren't sniffing
> preprocessor internals, you're actually preprocessing something.
> 
> POSIX does provide (optional) defines to try and sniff off_t sizes too:
> https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/unistd.h.html
> 
> but i think the takeaway is that this is all not worth the effort, and
> defining _FILE_OFFSET_BITS=64 all the time is way easier.
> -mike

Sure. I have no problem doing it for all archs.

BTW, the only issue that will happen if stat fails, is that a feature will
be disabled.

-- Steve


Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4C9AC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Apr 2022 15:04:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbiDDPG0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 11:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238295AbiDDPGZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 11:06:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 579371B790
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Apr 2022 08:04:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08E1AB81807
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Apr 2022 15:04:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BCF2C340EE;
        Mon,  4 Apr 2022 15:04:25 +0000 (UTC)
Date:   Mon, 4 Apr 2022 11:04:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Joel Fernandes <joel@joelfernandes.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        rostedt@google.com, Vineeth Pillai <vineethrp@google.com>
Subject: Re: [PATCH] trace-cmd: Try alternate path for message cache
Message-ID: <20220404110424.78f14d9e@gandalf.local.home>
In-Reply-To: <CAPpZLN71si6G5=O=sM5suNp+NtXYz=0U+=3O2XCCWmqhp8M-Tg@mail.gmail.com>
References: <20220329191801.429691-1-joel@joelfernandes.org>
        <20220401153737.7c444426@gandalf.local.home>
        <CAEXW_YQxPgaKOMhDy8kVdaT9esvY8ctP1Mfw3RZXwkJkTYhh0w@mail.gmail.com>
        <20220401190629.32564bd2@gandalf.local.home>
        <Ykm1jBpdD0+NjsTW@google.com>
        <CAPpZLN44k=2j7AsrNz72_74JkXQZvJH2sh61o2-ZRib=b4nyKA@mail.gmail.com>
        <CAPpZLN7LXehf7==O6bi2CDfs0HvAexAvQ1qv92MT5DYVgW7iGQ@mail.gmail.com>
        <CAEXW_YSUTdtELA+ZVmUsybuSMuZ0OAQy4d6834soj3a-R40v1Q@mail.gmail.com>
        <CAPpZLN5MHicswQqgH6vKYOCwPczNTyz2OcMf5CG4CKV6y8Q2jw@mail.gmail.com>
        <20220404103525.1ec0b246@gandalf.local.home>
        <CAPpZLN71si6G5=O=sM5suNp+NtXYz=0U+=3O2XCCWmqhp8M-Tg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 4 Apr 2022 17:48:24 +0300
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> On Mon, Apr 4, 2022 at 5:35 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Mon, 4 Apr 2022 16:48:11 +0300
> > Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:
> >  
> > > > > > Hi  Joel,
> > > > > > That cache file is used for constructing the trace meta-data on the
> > > > > > guest, before sending it to the host. Usually it is compressed, but it
> > > > > > could be uncompressed in some cases (depending on the configuration) -
> > > > > > and in that case it can grow up to a few megabytes. Using memfd is ok
> > > > > > in most cases, but I'm wondering in the worst case - these few
> > > > > > megabytes could be a problem, especially if the guest runs with a
> > > > > > minimum amount of memory.
> > > > > >  
> > > > >
> > > > > Can you check that file size on your Android setup with that command,
> > > > > it will force to not use compression on the guest trace file:
> > > > >    trace-cmd <host trace options> -A <guest> <guest trace options>
> > > > > --file-version 7 --compression none  
> > > >
> > > > The file grows to 5.3MB with this. Is this really the common case
> > > > though? If not, I would still prefer memfd tbh. Is that Ok with you?  
> >
> > This is meta data right? Which means everything in here is in kernel memory
> > anyway. kallsyms, events, etc. I do not believe that this will be an issue
> > even uncompressed.
> >
> >  
> > > >  
> > >
> > > There are two cases that could hit this:
> > >  1. Using a " --compression none" flag on the guest file. We could
> > > disable that flag and force trace file v7 always to use compression. I
> > > cannot imagine a use case for uncompressed trace file, maybe only for
> > > debug purposes ?  
> >
> > Please no. I do have some machines that do not have zlib installed. I do
> > not want to make it a requirement to have zlib for this use case. If we do
> > not have memory, we could fall back to mktemp.  
> 
> Hi Steven,
> I'm wondering how you run the latest trace-cmd on those machines ? As
> these libraries are checked at compile time, this is a compile time
> dependency - so the trace-cmd compiled with zlib support should not be

It was compiled on the machine it ran on. I have to find which machine it
was. I believe it was one of the gentoo or arch VMs that have very little
installed. Bare minimum (you have to compile everything that is on it). But
the trace-cmd I built did not have any compression support, which put it to
--compression none by default. Without any compression libraries, it can
still build.

> able to run there ? That's why I think   " --compression none" could
> be used only for debugging.
> We could implement loading compression libraries dynamically to avoid
> these compile time dependencyies, or add a compile flag to disable
> compression support ?

That is not needed. Do we really need to have compression always?

-- Steve

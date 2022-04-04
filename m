Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30D18C433FE
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Apr 2022 14:35:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358604AbiDDOh3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 10:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377588AbiDDOh0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 10:37:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1873AA44
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Apr 2022 07:35:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08EB1B817D3
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Apr 2022 14:35:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A7E7C2BBE4;
        Mon,  4 Apr 2022 14:35:27 +0000 (UTC)
Date:   Mon, 4 Apr 2022 10:35:25 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Joel Fernandes <joel@joelfernandes.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        rostedt@google.com, Vineeth Pillai <vineethrp@google.com>
Subject: Re: [PATCH] trace-cmd: Try alternate path for message cache
Message-ID: <20220404103525.1ec0b246@gandalf.local.home>
In-Reply-To: <CAPpZLN5MHicswQqgH6vKYOCwPczNTyz2OcMf5CG4CKV6y8Q2jw@mail.gmail.com>
References: <20220329191801.429691-1-joel@joelfernandes.org>
        <20220401153737.7c444426@gandalf.local.home>
        <CAEXW_YQxPgaKOMhDy8kVdaT9esvY8ctP1Mfw3RZXwkJkTYhh0w@mail.gmail.com>
        <20220401190629.32564bd2@gandalf.local.home>
        <Ykm1jBpdD0+NjsTW@google.com>
        <CAPpZLN44k=2j7AsrNz72_74JkXQZvJH2sh61o2-ZRib=b4nyKA@mail.gmail.com>
        <CAPpZLN7LXehf7==O6bi2CDfs0HvAexAvQ1qv92MT5DYVgW7iGQ@mail.gmail.com>
        <CAEXW_YSUTdtELA+ZVmUsybuSMuZ0OAQy4d6834soj3a-R40v1Q@mail.gmail.com>
        <CAPpZLN5MHicswQqgH6vKYOCwPczNTyz2OcMf5CG4CKV6y8Q2jw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 4 Apr 2022 16:48:11 +0300
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> > > > Hi  Joel,
> > > > That cache file is used for constructing the trace meta-data on the
> > > > guest, before sending it to the host. Usually it is compressed, but it
> > > > could be uncompressed in some cases (depending on the configuration) -
> > > > and in that case it can grow up to a few megabytes. Using memfd is ok
> > > > in most cases, but I'm wondering in the worst case - these few
> > > > megabytes could be a problem, especially if the guest runs with a
> > > > minimum amount of memory.
> > > >  
> > >
> > > Can you check that file size on your Android setup with that command,
> > > it will force to not use compression on the guest trace file:
> > >    trace-cmd <host trace options> -A <guest> <guest trace options>
> > > --file-version 7 --compression none  
> >
> > The file grows to 5.3MB with this. Is this really the common case
> > though? If not, I would still prefer memfd tbh. Is that Ok with you?

This is meta data right? Which means everything in here is in kernel memory
anyway. kallsyms, events, etc. I do not believe that this will be an issue
even uncompressed.


> >  
> 
> There are two cases that could hit this:
>  1. Using a " --compression none" flag on the guest file. We could
> disable that flag and force trace file v7 always to use compression. I
> cannot imagine a use case for uncompressed trace file, maybe only for
> debug purposes ?

Please no. I do have some machines that do not have zlib installed. I do
not want to make it a requirement to have zlib for this use case. If we do
not have memory, we could fall back to mktemp.

>  2. If, for some reason, there are no supported compression libraries
> on the guest. Trace-cmd supports libz and libzstd, I believe both are
> widely available. Theoretically it could be possible to have some
> minimalistic VM image without any of these libraries.

Not theoretical ;-)

> What are the advantages of using memfd instead of temp file, is it
> only for performance ? Usually collecting trace metadata is not
> performance critical, as it is done before starting the trace.
> I think that the best solution is to use memfd in case the guest file
> is compressed and switch back to a temp file in case of a
> not-compressed file.

Yeah, we could use memfd if compressed and temp if not. Luckily, this isn't
something exposed across the API so we should be able to experiment with
various implementations, and if people complain about one (like Joel did
for Android), we can try something else.

-- Steve

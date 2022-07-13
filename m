Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64246C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Jul 2022 20:32:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbiGMUcF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Jul 2022 16:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiGMUcE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Jul 2022 16:32:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62DC32B25E;
        Wed, 13 Jul 2022 13:32:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA66761E46;
        Wed, 13 Jul 2022 20:32:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB074C34114;
        Wed, 13 Jul 2022 20:32:01 +0000 (UTC)
Date:   Wed, 13 Jul 2022 16:32:00 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sedat Dilek <sedat.dilek@gmail.com>
Cc:     Daniel Bristot de Oliveira <bristot@kernel.org>,
        linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] rtla: Fix Makefile when called from -C tools/
Message-ID: <20220713163200.1fdf505a@gandalf.local.home>
In-Reply-To: <CA+icZUUKiODjF0gZ1MaHPgVZS8zKEweR-1NkjHcegsLoRNUQ9w@mail.gmail.com>
References: <9154d66961804027b1bdc26f1ff08012bb7f9df8.1657269675.git.bristot@kernel.org>
        <CA+icZUUKiODjF0gZ1MaHPgVZS8zKEweR-1NkjHcegsLoRNUQ9w@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sun, 10 Jul 2022 10:40:47 +0200
Sedat Dilek <sedat.dilek@gmail.com> wrote:

> On Fri, Jul 8, 2022 at 2:17 PM Daniel Bristot de Oliveira
> <bristot@kernel.org> wrote:
> >
> > Sedat Dilek reported an error on rtla Makefile when running:
> >  
> 
> Hi Daniel,
> 
> Thanks for the patch.
> 
> >     $ make -C tools/  
> 
> No, that was with...
> 
> $ make -C tools/ clean
> 
> >     [...]
> >     make[2]: Entering directory
> >     '/home/dileks/src/linux-kernel/git/tools/tracing/rtla'
> >     [...]
> >     '/home/dileks/src/linux-kernel/git/Documentation/tools/rtla'
> >     /bin/sh: 1: test: rtla-make[2]:: unexpected operator    <------ The problem
> >     rm: cannot remove '/home/dileks/src/linux-kernel/git': Is a directory
> >     make[2]: *** [Makefile:120: clean] Error 1
> >     make[2]: Leaving directory
> >
> > This occurred because the rtla calls kernel's Makefile to get the
> > version in silence mode, e.g.,
> >
> >     $ make -sC ../../.. kernelversion
> >     5.19.0-rc4
> >
> > But the -s is being ignored when rtla's makefile is called from indirectly,
> > so the output looks like:
> >
> >     $ make -C ../../.. kernelversion
> >     make: Entering directory '/root/linux'
> >     5.19.0-rc4
> >     make: Leaving directory '/root/linux'
> >
> > 'grep -v make' to avoid this problem, e.g.,
> >  
> 
> Missing word at the beginning soething like:
> 
> Use 'grep -v make' to avoid this problem ...
> 
> >     $ make -C ../../.. kernelversion | grep -v make
> >     5.19.0-rc4
> >  
> 
> Shouldn't that be:
> 
> $ make -sC ... (missing "s")


Hi Daniel,

Any response to Sedat's comments? I'm holding off sending the rtla branch
to Linus waiting for an update to this patch.

-- Steve

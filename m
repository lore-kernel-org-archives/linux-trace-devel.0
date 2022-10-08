Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C848DC433FE
	for <linux-trace-devel@archiver.kernel.org>; Sat,  8 Oct 2022 12:50:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiJHMuM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 8 Oct 2022 08:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiJHMuL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 8 Oct 2022 08:50:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A9BC252AC
        for <linux-trace-devel@vger.kernel.org>; Sat,  8 Oct 2022 05:50:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 573F2B80943
        for <linux-trace-devel@vger.kernel.org>; Sat,  8 Oct 2022 12:50:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B292C433D6;
        Sat,  8 Oct 2022 12:50:06 +0000 (UTC)
Date:   Sat, 8 Oct 2022 08:50:06 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     lijiazi <jqqlijiazi@gmail.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        "Jiazi.Li" <jiazi.li@transsion.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] ring-buffer: Add barrire in rb_move_tail
Message-ID: <20221008085006.01f73f0a@rorschach.local.home>
In-Reply-To: <20221008012128.GA6772@Jiazi.Li>
References: <20220902085641.32ba1651@gandalf.local.home>
        <20220905030209.GA5577@Jiazi.Li>
        <20220906122542.1bab4663@gandalf.local.home>
        <20220907081358.GB24124@Jiazi.Li>
        <20220915081414.GA12602@Jiazi.Li>
        <20220928105443.1e7e4555@gandalf.local.home>
        <20220928105935.578b72b6@gandalf.local.home>
        <20220928162908.07b12250@gandalf.local.home>
        <20220929091201.GA21685@Jiazi.Li>
        <20220930174934.7c5ec85f@gandalf.local.home>
        <20221008012128.GA6772@Jiazi.Li>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, 8 Oct 2022 09:21:29 +0800
lijiazi <jqqlijiazi@gmail.com> wrote:

> On Fri, Sep 30, 2022 at 05:49:34PM -0400, Steven Rostedt wrote:
> > On Thu, 29 Sep 2022 17:12:01 +0800
> > lijiazi <jqqlijiazi@gmail.com> wrote:
> >   
> > > > Actually, that failed my testing (for other reasons), can you try this one?
> > > >     
> > > Sure, thank you.  
> > 
> > Have you had a chance to test this yet?
> > 
> > The merge window is about to open, and I have it already tested through all
> > my tests. But I want to hold off pushing it to next until I have a
> > tested-by from you.
> > 
> > Thanks!
> > 
> > -- Steve  
> Sorry for the late reply, I just finished my National Day holiday.
> Up to now, the crash issue has not been reproduced with this patch.
> Thanks!

No problem. Thanks for testing it. And thank you even more for
reporting it. This was a real bug that's been around pretty much from
the beginning and nobody (at least I know of) reported it.

-- Steve

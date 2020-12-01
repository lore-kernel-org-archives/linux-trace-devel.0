Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 046E6C64E7A
	for <linux-trace-devel@archiver.kernel.org>; Tue,  1 Dec 2020 21:36:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B7842086A
	for <linux-trace-devel@archiver.kernel.org>; Tue,  1 Dec 2020 21:36:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbgLAVgM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 1 Dec 2020 16:36:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:50442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727686AbgLAVgM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 1 Dec 2020 16:36:12 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A8BD2085B;
        Tue,  1 Dec 2020 21:35:31 +0000 (UTC)
Date:   Tue, 1 Dec 2020 16:35:29 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Beniamin Sandu <beniaminsandu@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2] trace-cmd: make it build against musl C library
Message-ID: <20201201163529.2e4ad0d2@gandalf.local.home>
In-Reply-To: <CAPpZLN50X6=8nz3U2M6mk+KqDfxcwdr86d-6bHuV_rkphc1Xhw@mail.gmail.com>
References: <20201130122755.31000-1-beniaminsandu@gmail.com>
        <CAPpZLN50X6=8nz3U2M6mk+KqDfxcwdr86d-6bHuV_rkphc1Xhw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 30 Nov 2020 18:24:05 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> On Mon, Nov 30, 2020 at 2:31 PM Beniamin Sandu <beniaminsandu@gmail.com> wrote:
> >
> > * add some missing headers and macros
> > * set pthread affinity using pthread_setaffinity_np after creating the thread
> > instead of pthread_attr_setaffinity_np (which seems to not be implemented
> > in musl)
> >
> > Tested using https://musl.cc/x86_64-linux-musl-native.tgz
> >
> > Signed-off-by: Beniamin Sandu <beniaminsandu@gmail.com>  
> 
> Thanks Beniamin!
> There is one minor coding style error, as we are using the kernel's
> coding style.
> No need to send another version, we will fix it when pulling the patch.
> Also, note that we are moving the libtracefs in its own repo:
>   https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
> I'm going to port the libtracefs part of your patch to that repo too.
> 
> Reviewed-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> 

I applied this. Thanks Beniamin and Tzvetomir!

-- Steve

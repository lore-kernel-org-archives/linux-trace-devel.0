Return-Path: <SRS0=h6jj=SV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA6B1C282DA
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 18:19:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A827A222AD
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 18:19:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbfDSSTP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Apr 2019 14:19:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726587AbfDSSTO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Apr 2019 14:19:14 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E27D7222D2;
        Fri, 19 Apr 2019 17:59:16 +0000 (UTC)
Date:   Fri, 19 Apr 2019 13:59:15 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <slavomir.kaslev@gmail.com>
Cc:     Yordan Karadzhov <ykaradzhov@vmware.com>,
        linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: Re: [PATCH v2 4/8] kernel-shark: Add logic for the plugins search
 path
Message-ID: <20190419135915.4b807eb0@gandalf.local.home>
In-Reply-To: <CAE0o1NvY=KHwDQXLB0YCPtUAc8UxzgKvsj4g89j1iv64zvfYKg@mail.gmail.com>
References: <20190418152146.27232-1-ykaradzhov@vmware.com>
        <20190418152146.27232-5-ykaradzhov@vmware.com>
        <CAE0o1NvY=KHwDQXLB0YCPtUAc8UxzgKvsj4g89j1iv64zvfYKg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 19 Apr 2019 10:43:17 +0300
Slavomir Kaslev <slavomir.kaslev@gmail.com> wrote:

> > diff --git a/kernel-shark/src/KsUtils.cpp b/kernel-shark/src/KsUtils.cpp
> > index 6af0c66..b05c0dc 100644
> > --- a/kernel-shark/src/KsUtils.cpp
> > +++ b/kernel-shark/src/KsUtils.cpp
> > @@ -423,13 +423,12 @@ void KsPluginManager::_parsePluginList()
> >   */
> >  void KsPluginManager::registerFromList(kshark_context *kshark_ctx)
> >  {
> > -       auto lamRegBuiltIn = [&kshark_ctx](const QString &plugin)
> > +       auto lamRegBuiltIn = [&kshark_ctx, this](const QString &plugin)  
> 
> Prefixing lambda function names with 'lam' is an interesting modern
> form of Hungarian notation[1]. It's not useful for the reader or the
> compiler and it doesn't make a great style. No need to change this
> patch but having a clean up patch that does a bulk rename would be
> nice.

I don't know. Having them labeled does make it easy to know that they
are lambda functions when used later.

-- Steve

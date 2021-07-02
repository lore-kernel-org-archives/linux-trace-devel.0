Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2E34C11F68
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 11:36:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B529C61425
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 11:36:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbhGBLik (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 2 Jul 2021 07:38:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229807AbhGBLik (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Jul 2021 07:38:40 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6C7B61402;
        Fri,  2 Jul 2021 11:36:07 +0000 (UTC)
Date:   Fri, 2 Jul 2021 07:36:06 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtracefs: Fix tracefs_event_enable/disable() to not
 have open regex
Message-ID: <20210702073606.3aea4632@rorschach.local.home>
In-Reply-To: <48ad3a02-f4bf-1579-df6a-f4dc206a7e4e@gmail.com>
References: <20210629164046.48f8b323@oasis.local.home>
        <48ad3a02-f4bf-1579-df6a-f4dc206a7e4e@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 2 Jul 2021 14:17:52 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> > @@ -847,12 +867,13 @@ static int event_enable_disable(struct tracefs_instance *instance,
> >   		goto out_free;
> >   
> >   	if (system) {
> > +		ret = make_regex(&system_re, system);
> >   		ret = regcomp(&system_re, system, REG_ICASE|REG_NOSUB);  
> 
> I think we forgot to remove the line above.

Yes I did, good catch.

-- Steve

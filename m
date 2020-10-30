Return-Path: <SRS0=nD6j=EF=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79FEEC2D0A3
	for <linux-trace-devel@archiver.kernel.org>; Fri, 30 Oct 2020 01:57:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2141E20738
	for <linux-trace-devel@archiver.kernel.org>; Fri, 30 Oct 2020 01:57:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725797AbgJ3B5h (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Oct 2020 21:57:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:59396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbgJ3B5h (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Oct 2020 21:57:37 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8A45206DB;
        Fri, 30 Oct 2020 01:57:36 +0000 (UTC)
Date:   Thu, 29 Oct 2020 21:57:34 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 07/20] kernel-shark: Add basic methods for Data
 streams
Message-ID: <20201029215734.2531c5af@oasis.local.home>
In-Reply-To: <b24331bb-a8e3-5347-62e5-ed9b630c0601@gmail.com>
References: <20201012133523.469040-1-y.karadz@gmail.com>
        <20201012133523.469040-8-y.karadz@gmail.com>
        <20201012201847.1218c974@oasis.local.home>
        <d67dd724-abe1-3696-29f7-75358f98df87@gmail.com>
        <20201029100421.33720af1@gandalf.local.home>
        <b24331bb-a8e3-5347-62e5-ed9b630c0601@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 29 Oct 2020 16:49:03 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> Maybe I don't understand your idea very well, but I think what you 
> suggest has very different behavior. What I want is the implementation 
> of the interface to stay in the same header file (libkshark.h). In the 
> future we can add more interfaces but this will be again in the same 
> header (libkshark.h).

Maybe I got confused ;-)

Is there going to be different interface structures? Why the "void *"
and not just supply a "struct kshark_data_stream *"?

That way at least you have some kind of type checking when tasks move
things around. I try to avoid using "void *" because it can easily be
the source of unwanted bugs, due to the lack of type checking.

-- Steve

Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 768CCC6379D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Nov 2020 16:39:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2785522264
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Nov 2020 16:39:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728766AbgKSQi6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Nov 2020 11:38:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:50864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727832AbgKSQi5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Nov 2020 11:38:57 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EA7C2220B;
        Thu, 19 Nov 2020 16:38:56 +0000 (UTC)
Date:   Thu, 19 Nov 2020 11:38:55 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 06/20] kernel-shark: Add basic methods for Data
 streams
Message-ID: <20201119113855.6d0df6a6@gandalf.local.home>
In-Reply-To: <3ea5483a-9cb7-cbf0-e3ab-0b354228a387@gmail.com>
References: <20201118145003.156542-1-y.karadz@gmail.com>
        <20201118145003.156542-7-y.karadz@gmail.com>
        <20201118171314.16662a9f@oasis.local.home>
        <3ea5483a-9cb7-cbf0-e3ab-0b354228a387@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 19 Nov 2020 18:01:30 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> Hi Steven,
> 
> I have no strong preference about having or not having this extra space.
> For me, having the space makes the C-like casting look more similar to a 
> new declaration on contrary to the C++-like casting that will be 
> something like this
> 
> 	unsigned long i(340);
> 	char c = char(i);
> 
> and looks more like a constructor call.
> Of course C++ will not let you cast number to pointer this way.

As long as you are consistent, but I'm just letting you know the
appropriate style for the Linux kernel, which is no space:

	type x = (type)y;

But again, this is really up to you, but just be aware if you submit to the
kernel, the above is the expected style.

-- Steve

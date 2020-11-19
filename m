Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E411FC388F9
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Nov 2020 20:44:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99D142225B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Nov 2020 20:44:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbgKSUnm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Nov 2020 15:43:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:53810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725843AbgKSUnm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Nov 2020 15:43:42 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2309A2158C;
        Thu, 19 Nov 2020 20:43:41 +0000 (UTC)
Date:   Thu, 19 Nov 2020 15:43:39 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 14/20] kernel-shark: Provide merging of multiple data
 streams
Message-ID: <20201119154339.78938435@gandalf.local.home>
In-Reply-To: <5ed5fd96-4c8b-7fe8-56d4-47f09df9dce5@gmail.com>
References: <20201118145003.156542-1-y.karadz@gmail.com>
        <20201118145003.156542-15-y.karadz@gmail.com>
        <20201118210025.0bc6326b@oasis.local.home>
        <83fe0b27-f5cb-a1cf-6afd-bf48cd2f61bc@gmail.com>
        <20201119114337.01d5657a@gandalf.local.home>
        <5ed5fd96-4c8b-7fe8-56d4-47f09df9dce5@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 19 Nov 2020 19:48:29 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> If you want to open a second file, just replace 
> kshark_tep_init_all_buffers() with another call of kshark_open().

This is fine, I just used a trace.dat with multiple buffers.

> 
> I will wait to see if you will find more problems before sending v5.

No need to wait, you are good to go.

-- Steve

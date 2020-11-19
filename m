Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A38A0C63697
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Nov 2020 16:43:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5527A2222A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Nov 2020 16:43:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728262AbgKSQnk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Nov 2020 11:43:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:54052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728202AbgKSQnk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Nov 2020 11:43:40 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5516422227;
        Thu, 19 Nov 2020 16:43:39 +0000 (UTC)
Date:   Thu, 19 Nov 2020 11:43:37 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 14/20] kernel-shark: Provide merging of multiple data
 streams
Message-ID: <20201119114337.01d5657a@gandalf.local.home>
In-Reply-To: <83fe0b27-f5cb-a1cf-6afd-bf48cd2f61bc@gmail.com>
References: <20201118145003.156542-1-y.karadz@gmail.com>
        <20201118145003.156542-15-y.karadz@gmail.com>
        <20201118210025.0bc6326b@oasis.local.home>
        <83fe0b27-f5cb-a1cf-6afd-bf48cd2f61bc@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 19 Nov 2020 18:14:36 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> >   
> >> +
> >> +	if (sd < 0) {
> >> +		kshark_free(kshark_ctx);
> >> +		return 1;
> >> +	}
> >> +
> >> +	/* Initialize data streams for all buffers in this file. */
> >> +	kshark_tep_init_all_buffers(kshark_ctx, sd);  
> 
> And here is the place where it opens in separate streams the other 
> buffers that are in the same file.
> 

Ah so it requires that the file have buffers recorded. OK, I'll try it out.

-- Steve



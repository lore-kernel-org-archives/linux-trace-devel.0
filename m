Return-Path: <SRS0=fydL=DO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86CC0C4363C
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Oct 2020 20:12:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4231820872
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Oct 2020 20:12:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbgJGUM3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Oct 2020 16:12:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:44174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727657AbgJGUM2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Oct 2020 16:12:28 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FF6220679;
        Wed,  7 Oct 2020 20:12:28 +0000 (UTC)
Date:   Wed, 7 Oct 2020 16:12:26 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 08/15] kernel-shark: Integrate the stream definitions
 with the C API
Message-ID: <20201007161226.6e1da22e@gandalf.local.home>
In-Reply-To: <20200929134123.178688-9-y.karadz@gmail.com>
References: <20200929134123.178688-1-y.karadz@gmail.com>
        <20200929134123.178688-9-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


I didn't apply the first patch, and nothing broke up until this patch.

On Tue, 29 Sep 2020 16:41:16 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> Unfortunately this integration can only happen in a single change,
> which results into one huge patch, that may be hard to review. In
> this patch we modify the API itself plus the two most basic examples
> demonstrating how to use it. The most noticeable change that this
> new version of the API brings is that the processing of the
> trace-cmd/Ftrace data is wrapped inside the dedicated implementation
> of the Data stream interface and no trace-cmd definitions are leaking
> outside of src/libkshark-tepdata.c.

I find it hard to believe that we can't break this up more.

Can you tell me what the old API did and what the new API does. I can
probably help out in taking steps to go from one to the other. But I don't
understand what exactly is changing without spending several days staring
at this code.

-- Steve


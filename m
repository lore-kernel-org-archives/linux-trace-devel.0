Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B239AC433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 18:25:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74D456147E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 18:25:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232670AbhEJS0s (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 10 May 2021 14:26:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:50434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231577AbhEJS0p (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 10 May 2021 14:26:45 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 744416147E;
        Mon, 10 May 2021 18:25:39 +0000 (UTC)
Date:   Mon, 10 May 2021 14:25:37 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 3/9] kernel-shark: Fix KS_DEFINE_PLUGIN_CONTEXT macro
Message-ID: <20210510142537.2628c47b@gandalf.local.home>
In-Reply-To: <6c352db2-1f2a-4442-1832-1810d4d6a1a2@gmail.com>
References: <20210428134730.187533-1-y.karadz@gmail.com>
        <20210428134730.187533-4-y.karadz@gmail.com>
        <20210506141151.2f31f263@gandalf.local.home>
        <6c352db2-1f2a-4442-1832-1810d4d6a1a2@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 10 May 2021 14:53:08 +0300
Yordan Karadzhov <y.karadz@gmail.com> wrote:

> > Can you show me how you see this error, because this solution does not make
> > any sense.  
> 
> The problem is that some plugins can build from multiple source files. 
> For example in the case when part of the plugin is written in C and 
> another part in C++. In those cases we cannot have the functions being 
> static.

So it's because its a mixture of C and C++ code? And you can't make them
static?

So this isn't a name resolution issue, it's a C to C++ issue where static
doesn't work? If that is the case then the change log is misleading.

-- Steve

Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 480A3C433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Jan 2021 22:46:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE2B764DED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Jan 2021 22:46:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbhA1Wpw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Jan 2021 17:45:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:44512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229757AbhA1WpZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Jan 2021 17:45:25 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EE6164DDE;
        Thu, 28 Jan 2021 22:44:44 +0000 (UTC)
Date:   Thu, 28 Jan 2021 17:44:42 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v26 11/15] trace-cmd: Define a macro for packed
 structures
Message-ID: <20210128174442.43658fc7@oasis.local.home>
In-Reply-To: <20210121074456.157658-12-tz.stoyanov@gmail.com>
References: <20210121074456.157658-1-tz.stoyanov@gmail.com>
        <20210121074456.157658-12-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 21 Jan 2021 09:44:52 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Defined a new macro
>  #define __packed __attribute__((packed))
> used for packing the structures, to make the code look cleaner.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> 

Hi Tzvetomir,

I applied patches 1-9 and this one.

You can rebase on top of mainline for the rest of the patches. Since I
skipped patch 10, and this patch modified it, you may need to make that
modification part of that patch.

Thanks!

-- Steve

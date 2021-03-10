Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70704C433DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Mar 2021 21:49:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4325D64FAB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Mar 2021 21:49:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbhCJVtQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Mar 2021 16:49:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:43938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232153AbhCJVsq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Mar 2021 16:48:46 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACB4664E27;
        Wed, 10 Mar 2021 21:48:41 +0000 (UTC)
Date:   Wed, 10 Mar 2021 16:48:39 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     y.karadz@gmail.com, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] kernel-shark v2: Change the logic for opening trace-cmd
 files
Message-ID: <20210310164839.475d10be@gandalf.local.home>
In-Reply-To: <20210310121135.1620453-1-tz.stoyanov@gmail.com>
References: <20210310121135.1620453-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 10 Mar 2021 14:11:35 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> From: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
> 
> The logic for opening a trace file by trace-cmd library has changed.
> Any timestamp corrections, found in the trace file metadata are applied
> automatically. The old APIs, used by KernelShark for pairing trace files
> from the same host-guest traceing session and adjusting timestamps are

 s/traceing/tracing/

> now obsolete and should not be used.
> 
> Signed-off-by: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>

The from and SOB should be Tzvetomir Stoyanov (VMware), unless you changed
your middle name to (VMware) ;-)

As for the rest of the patch.

Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

-- Steve

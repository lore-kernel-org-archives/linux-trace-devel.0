Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B5FDC43460
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 15:52:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7270060FDA
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 15:52:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243363AbhEQPxv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 May 2021 11:53:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:48360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243912AbhEQPvr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 May 2021 11:51:47 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EE7C60FE6;
        Mon, 17 May 2021 15:32:31 +0000 (UTC)
Date:   Mon, 17 May 2021 11:32:29 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sameeruddin shaik <sameeross1994@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com
Subject: Re: [PATCH] libtracefs: Add support for setting tracers
Message-ID: <20210517113229.16fe1f0a@gandalf.local.home>
In-Reply-To: <1621351602-3703-1-git-send-email-sameeross1994@gmail.com>
References: <1621351602-3703-1-git-send-email-sameeross1994@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 18 May 2021 20:56:42 +0530
Sameeruddin shaik <sameeross1994@gmail.com> wrote:

> tracefs_tracer_set - set the tracer
> tracefs_tracer_clear - clear the tracer
> 
> Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Sameeruddin shaik <sameeross1994@gmail.com>
> 
> 

Thanks Sameer,


The subject still needs to include the version:

"[PATCH v3] libtracefs: Add support for setting tracers"

You don't need to send another version just to fix this. But next time,
please label the versions of any patch that is replacing another patch.

I'm going on PTO tomorrow for almost two weeks, and will not be able to
process this till I get back. I probably wont be able to take this until
June.

-- Steve

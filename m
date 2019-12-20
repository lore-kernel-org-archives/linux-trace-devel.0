Return-Path: <SRS0=9eMf=2K=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71177C43603
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Dec 2019 04:21:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 512A3206EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Dec 2019 04:21:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfLTEVe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Dec 2019 23:21:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:45102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726986AbfLTEVd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Dec 2019 23:21:33 -0500
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 346FE206EF;
        Fri, 20 Dec 2019 04:21:33 +0000 (UTC)
Date:   Thu, 19 Dec 2019 23:21:31 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 3/6] trace-cmd: New libtracefs API tracefs_write_file()
Message-ID: <20191219232131.0a6538a7@rorschach.local.home>
In-Reply-To: <20191219113502.28964-4-tz.stoyanov@gmail.com>
References: <20191219113502.28964-1-tz.stoyanov@gmail.com>
        <20191219113502.28964-4-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.4git76 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 19 Dec 2019 13:34:59 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Moved write_file() static function from trace-record.c to
> libtracefs API. The new API will be useful in future libtracefs
> extension.
> All die() calls in its implementation are replaced with warning().
> A check is added to all current callers of tracefs_write_file(),
> in case of a error die() is called, to keep the existing behavior.

I'm curious to why this is being made as a library function, as its
really just a helper function. Not sure it needs to be part of a
library. It doesn't seem to be anything specific to tracefs. Or am I
missing something?

-- Steve


> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  include/tracefs/tracefs.h   |  2 ++
>  lib/tracefs/tracefs-utils.c | 41 ++++++++++++++++++++++++++++++++
>  tracecmd/trace-record.c     | 47 ++++++++++++-------------------------
>  3 files changed, 58 insertions(+), 32 deletions(-)
> 

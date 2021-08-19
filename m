Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10250C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 18:08:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAB1A610A1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 18:08:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234126AbhHSSJY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Aug 2021 14:09:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:53678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229465AbhHSSJY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Aug 2021 14:09:24 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B51A60F5E;
        Thu, 19 Aug 2021 18:08:47 +0000 (UTC)
Date:   Thu, 19 Aug 2021 14:08:40 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 38/87] trace-cmd library: Fix possible memory leak in
 read_ftrace_files()
Message-ID: <20210819140840.16f4bf1d@oasis.local.home>
In-Reply-To: <20210729050959.12263-39-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
        <20210729050959.12263-39-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 29 Jul 2021 08:09:10 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Some error paths in read_ftrace_files() may lead to a memory leak.
> Improved the error handling of this internal function to avoid it.
> 
>

In fact, all theses memory leak fixes should not even be part of this
patch set, and should be its own patchset to fix the current code.

If any of these is fixing code in this patch set, then simply fix the
patch it fixes.

-- Steve

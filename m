Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ED48C4338F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Aug 2021 00:17:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 240A761037
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Aug 2021 00:17:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234679AbhHDARc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Aug 2021 20:17:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:49016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234555AbhHDARb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Aug 2021 20:17:31 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC4DA60EBC;
        Wed,  4 Aug 2021 00:17:19 +0000 (UTC)
Date:   Tue, 3 Aug 2021 20:17:18 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [RFC PATCH] udiag - User mode to trace_event (ftrace, perf,
 eBPF) ABI
Message-ID: <20210803201718.5d289c4c@rorschach.local.home>
In-Reply-To: <20210803225200.GA2792@kbox>
References: <20210727193535.10326-1-beaub@linux.microsoft.com>
        <20210803171743.36115d4c@oasis.local.home>
        <20210803225200.GA2792@kbox>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 3 Aug 2021 15:52:00 -0700
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> For clarity, would you like a resend with the user mode code in the
> description or would you like an in-thread example?

In thread example is fine. I'd just like to understand what exactly you
plan on doing with it.

-- Steve

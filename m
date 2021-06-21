Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DE07C4743C
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Jun 2021 22:36:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38A8C6124B
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Jun 2021 22:36:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbhFUWin (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Jun 2021 18:38:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:53520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231669AbhFUWin (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Jun 2021 18:38:43 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B7186113E;
        Mon, 21 Jun 2021 22:36:28 +0000 (UTC)
Date:   Mon, 21 Jun 2021 18:36:26 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v6 03/45] trace-cmd: Check if file version is supported
Message-ID: <20210621183626.37f63b2f@gandalf.local.home>
In-Reply-To: <20210621182746.58f2f175@gandalf.local.home>
References: <20210614075029.598048-1-tz.stoyanov@gmail.com>
        <20210614075029.598048-4-tz.stoyanov@gmail.com>
        <20210621182746.58f2f175@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 21 Jun 2021 18:27:46 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> After applying this patch, I get:
> 
> $ ./tracecmd/trace-cmd report 
>   error reading header for trace.dat

Never mind, I tested on a leftover trace.dat that had version 7 already set!
So the patch did work :-)

-- Steve

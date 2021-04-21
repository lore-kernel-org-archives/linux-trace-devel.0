Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34384C433ED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Apr 2021 15:01:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E920161426
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Apr 2021 15:01:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240301AbhDUPCF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 21 Apr 2021 11:02:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:42344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240091AbhDUPCE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Apr 2021 11:02:04 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 397A46144B;
        Wed, 21 Apr 2021 15:01:31 +0000 (UTC)
Date:   Wed, 21 Apr 2021 11:01:29 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 0/4] Various minor modifications and fixes toward KS 2.0
Message-ID: <20210421110129.7c6c45ff@gandalf.local.home>
In-Reply-To: <20210421145140.95517-1-y.karadz@gmail.com>
References: <20210421145140.95517-1-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 21 Apr 2021 17:51:36 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> Yordan Karadzhov (VMware) (4):
>   kernel-shark: Fix warnings from deprecated Qt APIs
>   kernel-shark: Polish the README file
>   kernel-shark: Exclude libkshark-plot from libkshark-devel
>   kernel-shark: Integrate install_libkshark-devel.sh
> 
>  README                           | 42 ++++++++++++++++++++------------
>  build/install_libkshark-devel.sh |  6 ++++-
>  src/CMakeLists.txt               | 13 ++--------
>  src/KsTraceGraph.cpp             |  9 +++++--
>  src/KsWidgetsLib.cpp             | 14 +++++------
>  5 files changed, 48 insertions(+), 36 deletions(-)
> 

All look reasonable to me.

Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

Thanks Yordan!

-- Steve

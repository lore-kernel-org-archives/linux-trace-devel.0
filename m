Return-Path: <SRS0=o8EP=YD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3772FC4360C
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Oct 2019 22:02:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F22E218AC
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Oct 2019 22:02:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbfJJWCH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Oct 2019 18:02:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:42656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726983AbfJJWCH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Oct 2019 18:02:07 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7AD120B7C;
        Thu, 10 Oct 2019 22:02:06 +0000 (UTC)
Date:   Thu, 10 Oct 2019 18:02:05 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Mikhail Rudenko <mike.rudenko@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Steven Rostedt <srostedt@redhat.com>,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: Re: [PATCH 0/4] Fix KernelShark appearance on dark color schemes
Message-ID: <20191010180205.06aab874@gandalf.local.home>
In-Reply-To: <20191010212429.469155-1-mike.rudenko@gmail.com>
References: <20191010212429.469155-1-mike.rudenko@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 11 Oct 2019 00:24:25 +0300
Mikhail Rudenko <mike.rudenko@gmail.com> wrote:

> Currently a few widgets in Kernel Shark UI use custom stylesheets,
> unconditionally setting their background or text color (but not both!)
> to hard-coded values. This has a side effect of widget text being
> poorly readable on some color schemes (e.g. Breeze Dark, and dark
> schemes in general). This patch series tries to address this issue.
> 
> The first three patches are trivial: they ensure that whenever the
> background color of a widget is set to white via stylesheet, its text
> color is set to black.
> 
> The fourth one changes "inactive" marker selection button style to
> system default, making it look clickable on all color schemes.
> 
> Mikhail Rudenko (4):
>   kernel-shark: Set text color to black in KsDualMarker's QLabels
>   kernel-shark: Set text color to black in pointer position QLabel
>   kernel-shark: Set text color to black in KsTraceGraph's axes labels
>   kernel-shark: Change KsDualMarker's inactive button style to default
> 
>  kernel-shark/src/KsDualMarker.cpp | 11 ++---------
>  kernel-shark/src/KsTraceGraph.cpp |  6 ++++--
>  2 files changed, 6 insertions(+), 11 deletions(-)


Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

Yordan,

If you are fine with these patches, could you pull them in and push
them to the repo?

-- Steve


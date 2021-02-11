Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 828D0C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 15:29:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EFBF64E8A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 15:29:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhBKP3Y (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Feb 2021 10:29:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:48902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229992AbhBKPEf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Feb 2021 10:04:35 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 059D561490;
        Thu, 11 Feb 2021 15:02:59 +0000 (UTC)
Date:   Thu, 11 Feb 2021 10:02:58 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 00/27] Complete the KernelShark v2 transformation
Message-ID: <20210211100258.024d0705@gandalf.local.home>
In-Reply-To: <20210211103205.418588-1-y.karadz@gmail.com>
References: <20210211103205.418588-1-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 11 Feb 2021 12:31:38 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> With this patch-set we complete the destructive part of the transformation
> of KernelShark towards v2 and the GUI is finally fully functional again.
> 
> v2 changes:
>   * Fixing the bug in patch
>     "kernel-shark: Update KsDualMarker and KsGLWidget",
>     causing the error "Unable to find FreeSans font".
> 
>   * New patches:
>     - kernel-shark: Search for font with Cmake at pre-build
>     - kernel-shark: Add pkg-config configuration for libkshark
>     - kernel-shark: Install libkshark-tepdata.h
> 
> 
> Yordan Karadzhov (VMware) (27):
>   kernel-shark: Add get_stream_object()
>   kernel-shark: Do proper reset in kshark_close_all()
>   kernel-shark: Restore the counting of event handlers
>   kernel-shark: Fix a misleading comment
>   kernel-shark: Count the number of readout interfaces
>   kernel-shark: Update KsUtils
>   kernel-shark: Update KsModels and KsSearchFSM
>   kernel-shark: Add trace data files for CI testing
>   kernel-shark: Add plugin tests
>   kernel-shark: Add model tests
>   kernel-shark: Update KsWidgetsLib
>   kernel-shark: Add combo point to Mark
>   kernel-shark: Add new methods to KsPlot::Mark
>   kernel-shark: Update the plotting example
>   kernel-shark: Search for font with Cmake at pre-build
>   kernel-shark: Update KsDualMarker and KsGLWidget
>   kernel-shark: Update KsTraceGraph and KsQuickContextMenu
>   kernel-shark: Update KsTraceViewer
>   kernel-shark: Update KsAdvFilteringDialog
>   kernel-shark: Update KsCaptureDialog
>   kernel-shark: Update KsSession
>   kernel-shark: Update MissedEvents plugin
>   kernel-shark: Update KsMainWindow and kernelshark.cpp
>   kernel-shark: Clickable sched_event plugin shapes
>   kernel-shark: Show Task plots from command lime
>   kernel-shark: Add pkg-config configuration for libkshark
>   kernel-shark: Install libkshark-tepdata.h
> 
> 

Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

-- Steve

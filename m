Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFD6FC433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu,  6 May 2021 18:26:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEA3E60FE3
	for <linux-trace-devel@archiver.kernel.org>; Thu,  6 May 2021 18:26:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbhEFS13 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 6 May 2021 14:27:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231839AbhEFS1X (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 6 May 2021 14:27:23 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1894260FE3;
        Thu,  6 May 2021 18:26:25 +0000 (UTC)
Date:   Thu, 6 May 2021 14:26:23 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] (Not so) Minor fixes toward KS 2.0
Message-ID: <20210506142623.69e7cbd6@gandalf.local.home>
In-Reply-To: <20210428134730.187533-1-y.karadz@gmail.com>
References: <20210428134730.187533-1-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 28 Apr 2021 16:47:21 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> Yordan Karadzhov (VMware) (9):
>   kernel-shark: Fix the build for 32b systems
>   kernel-shark: Add "cron" job to workflows
>   kernel-shark: Fix KS_DEFINE_PLUGIN_CONTEXT macro
>   kernel-shark: Add cleanup of all plugin contexts
>   kernel-shark: Fix memory leak in "sched events" plugin.
>   kernel-shark: Disable the pop-up offset dialog
>   kernel-shark: Remove kvm_combo from the list of default plugins
>   kernel-shark: Remove debugging print out from plugins
>   kernel-shark: Hide all plugin internals
> 

Besides my comment about patch 3, the rest of the patches look fine.

Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

(For all except for patch 3: "kernel-shark: Fix KS_DEFINE_PLUGIN_CONTEXT
macro")

-- Steve

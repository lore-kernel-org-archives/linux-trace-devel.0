Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26496C433DB
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Jan 2021 00:28:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E47C82255F
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Jan 2021 00:28:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbhAEA2Z (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Jan 2021 19:28:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:34004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726260AbhAEA2Z (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Jan 2021 19:28:25 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D66C02255F;
        Tue,  5 Jan 2021 00:27:44 +0000 (UTC)
Date:   Mon, 4 Jan 2021 19:27:43 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v8 00/44] Start KernelShark v2 transformation
Message-ID: <20210104192743.713b446d@gandalf.local.home>
In-Reply-To: <20210104174724.70404-1-y.karadz@gmail.com>
References: <20210104174724.70404-1-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon,  4 Jan 2021 19:46:40 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> In this patch-set we are starting the introduction of the changes
> in the C API of libkshark. The goal of this transformation is to
> turn KernelShark into a general purpose toolkit for analysis of
> tracing data that is no longer strongly coupled to the Ftrace/trace-cmd
> data format. At the end of the transformation KernelShark will be able
> to merge and simultaneously visualize data from different tracers,
> recorded in different data formats. It will also significantly extend
> the possibilities for user customization.
> 
> This  patch-set transforms the way KernelShark processes the raw tracing
> data. Later, in a consecutive patch-sets we will introduce the changes
> in the visualization instruments and in the KernelShark GUI itself.
> 

Hi Yordan,

I don't think you noticed that I applied your last series, with tweaks
(commenting in the change log what I tweaked).

Can you rebase this series against mainline?

  git://git.kernel.org/pub/scm/utils/trace-cmd/kernel-shark.git

Thanks!

-- Steve

Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CE7DC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Dec 2021 03:03:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbhLPDDc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 15 Dec 2021 22:03:32 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54484 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbhLPDDb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 15 Dec 2021 22:03:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D01BCB82285
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Dec 2021 03:03:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A7A7C36AE0;
        Thu, 16 Dec 2021 03:03:29 +0000 (UTC)
Date:   Wed, 15 Dec 2021 22:03:27 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Hongzhan Chen <hongzhan.chen@intel.com>
Cc:     linux-trace-devel@vger.kernel.org, jan.kiszka@siemens.com,
        Yordan Karadzhov <y.karadz@gmail.com>
Subject: Re: [RFC PATCH 0/1] kernel-shark: Add plugin for handling Xenomai
 cobalt_context_switch.
Message-ID: <20211215220327.0daae29e@gandalf.local.home>
In-Reply-To: <20211216021649.7273-1-hongzhan.chen@intel.com>
References: <20211216021649.7273-1-hongzhan.chen@intel.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 15 Dec 2021 21:16:48 -0500
Hongzhan Chen <hongzhan.chen@intel.com> wrote:

> I do not know if this patch can be accepted in upstream from function's
> view because it is xenomai related which still be different from
> pure kernel-shark for pure linux. But it is still independent plugin
> which would not influence other kernel-shark's functions and the plugin
> would not take effect if there is no cobalt_switch_context event found
> in trace data.

We are perfectly happy to accept plugins for various OSs, not just pure
Linux :-)

Welcome to the KernelShark Community.

Note, Yordan is now the maintainer of KernelShark so I'll let him review
the patches.

Thanks!

-- Steve

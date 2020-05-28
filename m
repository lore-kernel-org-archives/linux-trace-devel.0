Return-Path: <SRS0=Poap=7K=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DEA2C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 May 2020 12:29:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F4E320888
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 May 2020 12:29:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389751AbgE1M3B (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 May 2020 08:29:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:41916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389675AbgE1M27 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 May 2020 08:28:59 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 378B020888;
        Thu, 28 May 2020 12:28:59 +0000 (UTC)
Date:   Thu, 28 May 2020 08:28:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] kernel-shark: Do not change the PLUGIN_UNTOUCHED bit
 flag when filtering
Message-ID: <20200528082857.7672f263@gandalf.local.home>
In-Reply-To: <20200528111917.339007-1-y.karadz@gmail.com>
References: <20200528111917.339007-1-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 28 May 2020 14:19:17 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> The "visible" field of the entry has one special bit flag, that helps
> the GUI to display the original tracing data (as recorded) regardless
> of the possible modifications made by the plugins. This bit flag must
> be preserved when applying or removing filters.
> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  kernel-shark/src/libkshark.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel-shark/src/libkshark.c b/kernel-shark/src/libkshark.c
> index 0905359..52aacd3 100644
> --- a/kernel-shark/src/libkshark.c
> +++ b/kernel-shark/src/libkshark.c
> @@ -489,6 +489,11 @@ static inline void unset_event_filter_flag(struct kshark_context *kshark_ctx,
>  	e->visible &= ~event_mask;
>  }
>  
> +static void set_all_visible(uint16_t *v) {
> +	/*  Keep the original value of the PLUGIN_UNTOUCHED bit flag. */
> +	*v |= 0xFF & ~KS_PLUGIN_UNTOUCHED_MASK;

This patch is fine as is, but we really should add a KS_PLUGIN_MASK that
encompasses all bits, and replace the 0xFF with that.

-- Steve


> +}
> +
> 

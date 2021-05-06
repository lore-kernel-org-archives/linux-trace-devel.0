Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4781C433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu,  6 May 2021 18:25:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D3F061157
	for <linux-trace-devel@archiver.kernel.org>; Thu,  6 May 2021 18:25:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233273AbhEFS0V (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 6 May 2021 14:26:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:39082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231839AbhEFS0U (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 6 May 2021 14:26:20 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87A9361154;
        Thu,  6 May 2021 18:25:21 +0000 (UTC)
Date:   Thu, 6 May 2021 14:25:20 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 7/9] kernel-shark: Remove kvm_combo from the list of
 default plugins
Message-ID: <20210506142520.2f4eabe2@gandalf.local.home>
In-Reply-To: <20210428134730.187533-8-y.karadz@gmail.com>
References: <20210428134730.187533-1-y.karadz@gmail.com>
        <20210428134730.187533-8-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 28 Apr 2021 16:47:28 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> The "kvm_combo" plugin is still under tests and is yet to be added to
> KernelShark. For the moment we remove it from the list of default
> plugins for "tep" data, so that no warning message is being printed.

I'm looking forward to where we can put this back to the default.

Which reminds me. I see the other two plugins you posted patches for,
have you posted the KVM combo one yet?

-- Steve

> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  src/libkshark-tepdata.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
> index bc5babb..f7cd083 100644
> --- a/src/libkshark-tepdata.c
> +++ b/src/libkshark-tepdata.c
> @@ -1210,7 +1210,6 @@ static void kshark_tep_init_methods(struct kshark_generic_stream_interface *inte
>  const char *tep_plugin_names[] = {
>  	"sched_events",
>  	"missed_events",
> -	"kvm_combo",
>  };
>  
>  /**


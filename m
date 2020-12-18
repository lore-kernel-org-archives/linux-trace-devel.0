Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB7BAC4361B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Dec 2020 19:24:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AED623B84
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Dec 2020 19:24:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731505AbgLRTYz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 18 Dec 2020 14:24:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:37896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730082AbgLRTYz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 18 Dec 2020 14:24:55 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C1FA23B85;
        Fri, 18 Dec 2020 19:24:14 +0000 (UTC)
Date:   Fri, 18 Dec 2020 14:24:13 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/9] libtracefs: Remove doc_gui targets
Message-ID: <20201218142413.4d8182cc@gandalf.local.home>
In-Reply-To: <20201217094626.1402191-2-tz.stoyanov@gmail.com>
References: <20201217094626.1402191-1-tz.stoyanov@gmail.com>
        <20201217094626.1402191-2-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 17 Dec 2020 11:46:18 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> There is no gui in libtracefs, removed forgotten targets for building
> gui documentation.
> 

I already applied a similar patch. No need for this one.

-- Steve

> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  Makefile | 9 ---------
>  1 file changed, 9 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index a7d5808..7460d4d 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -255,19 +255,10 @@ install_pkgconfig: $(PKG_CONFIG_FILE)
>  
>  doc:
>  	$(MAKE) -C $(src)/Documentation all
> -doc_gui:
> -	$(MAKE) -C $(kshark-dir)/Documentation all
> -
> -
>  doc_clean:
>  	$(MAKE) -C $(src)/Documentation clean
> -doc_gui_clean:
> -	$(MAKE) -C $(kshark-dir)/Documentation clean
> -
>  install_doc:
>  	$(MAKE) -C $(src)/Documentation install
> -install_doc_gui:
> -	$(MAKE) -C $(kshark-dir)/Documentation install
>  
>  define build_uninstall_script
>  	$(Q)mkdir $(BUILD_OUTPUT)/tmp_build


Return-Path: <SRS0=DxZ9=RI=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C62BDC43381
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Mar 2019 15:54:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CF4920657
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Mar 2019 15:54:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbfCEPyg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 5 Mar 2019 10:54:36 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:56241 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727312AbfCEPyg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 5 Mar 2019 10:54:36 -0500
Received: by mail-wm1-f65.google.com with SMTP id q187so3072279wme.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 05 Mar 2019 07:54:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=drwWnHpLK+gk/AjD00JkLe6k6eKsX+EwlKneRz0Ghqk=;
        b=SdAivL3Vulx7di20twQaq+Z74vhd3/3xl1gYxyr/IUE5OCP0TsGOEjMe6abz0PxaU2
         oUsZkUD7x0HeStDIz0pVq2X3DoVYSF/1Opo/FWmiNcjcL/X9sJH/LM2lVwfRmH0/e8am
         sBEurumStIDM/WB1ZP+8cx1oEpeQd2LMjYCoWNht9IyX28JGioA+Y4PWNHILc+bV5lUS
         jOxVoiXycCiczFxwtZ1v1jrt9PyErTOL000eipXfuwhMTU5heNV0+TAvekl670FTIUUd
         REZMOos35TDxTwL6b9MbrfJ8By/SGtb87Z6JaIt8g2oAC0vAgldjTDN1gJMIjiStZIAN
         OdiQ==
X-Gm-Message-State: APjAAAXPW7i1+DH9DSbu4KxvLXe5ObspBwV5LkxahAiSYu/tifm/bCyA
        lVr/bv7LUUKB1umr3whVlQ==
X-Google-Smtp-Source: APXvYqwpTzXUy6383D99KLYPMezox8h0BNZtMaySSvqc4kmQ7nzUeSnZzniXNyc1gIbd2eTRC8X8MQ==
X-Received: by 2002:a1c:7610:: with SMTP id r16mr3139467wmc.139.1551801274004;
        Tue, 05 Mar 2019 07:54:34 -0800 (PST)
Received: from box ([146.247.46.6])
        by smtp.gmail.com with ESMTPSA id n189sm11216357wmb.28.2019.03.05.07.54.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 05 Mar 2019 07:54:33 -0800 (PST)
Date:   Tue, 5 Mar 2019 17:54:26 +0200
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/3] kernel-shark: Define free_contex function for the
 sched_events plugin
Message-ID: <20190305155425.GA19674@box>
References: <20190305143924.11056-1-ykaradzhov@vmware.com>
 <20190305143924.11056-2-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190305143924.11056-2-ykaradzhov@vmware.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Mar 05, 2019 at 04:39:22PM +0200, Yordan Karadzhov wrote:
> This static helper function makes the code of the plugin cleaner and
> easier to read.
> 
> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> ---
>  kernel-shark/src/plugins/sched_events.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel-shark/src/plugins/sched_events.c b/kernel-shark/src/plugins/sched_events.c
> index 68734d4..0d6de2d 100644
> --- a/kernel-shark/src/plugins/sched_events.c
> +++ b/kernel-shark/src/plugins/sched_events.c
> @@ -39,6 +39,17 @@ static bool define_wakeup_event(struct tep_handle *tep, const char *wakeup_name,
>  	return true;
>  }
>  
> +static void plugin_free_context(struct plugin_sched_context *plugin_ctx)
> +{
> +	if (!plugin_ctx)
> +		return;
> +
> +	tracecmd_filter_id_hash_free(plugin_ctx->second_pass_hash);
> +	kshark_free_collection_list(plugin_ctx->collections);
> +
> +	free(plugin_ctx);
> +}
> +
>  static bool plugin_sched_init_context(struct kshark_context *kshark_ctx)
>  {
>  	struct plugin_sched_context *plugin_ctx;
> @@ -339,10 +350,7 @@ static int plugin_sched_close(struct kshark_context *kshark_ctx)
>  					plugin_sched_action,
>  					plugin_draw);
>  
> -	tracecmd_filter_id_hash_free(plugin_ctx->second_pass_hash);
> -
> -	kshark_free_collection_list(plugin_ctx->collections);
> -	free(plugin_ctx);
> +	plugin_free_context(plugin_ctx);
>  	plugin_sched_context_handler = NULL;
>  
>  	return 1;

Nit: there's a typo in the commit message

>    kernel-shark: Define free_contex function for the sched_events plugin
                                     ^
:s/free_contex/plugin_free_context/g ?

Other than that it looks good to me.

Reviewed-by: Slavomir Kaslev <kaslevs@vmware.com>

Cheers,

-- Slavi

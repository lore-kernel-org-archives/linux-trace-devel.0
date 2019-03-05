Return-Path: <SRS0=DxZ9=RI=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C837C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Mar 2019 15:56:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3694420657
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Mar 2019 15:56:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfCEP4d (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 5 Mar 2019 10:56:33 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39572 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbfCEP4c (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 5 Mar 2019 10:56:32 -0500
Received: by mail-wm1-f67.google.com with SMTP id z84so3052545wmg.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 05 Mar 2019 07:56:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3ajx97qMKWbyRyfiWebkHtLDbQewI4CpGTMImVa2ROs=;
        b=MVOZMV+weDKj699HxzRWsTobRDnx2WOY4aU9VFLEMpOS3mLxxRVyeYigflwiE2H6Ue
         N321tKjBE4VjbC1+IAcXkfjQgOSGBmXXyLpVI1cySxsuLblbTsvnNvONCLK3rRkNCBMJ
         lWGXIIog175jk8r1uciI4eRZ1NCaSfiMwGlFcm0Ivw6z8gNr6t5fs++anmCnzGhi2N8i
         7WHeYjKy7xP5pE4F3mzOwEccLIhKwDjyVGzbPfqdW1x3pfbLgIR36L/vZE24GArZMzuT
         W9JEkKD9mUEkq8w0mU9lQCutot41ILBtD/zsV8SVrZ1RN93BsW4idMNNtuQopKMBBqZi
         M5+g==
X-Gm-Message-State: APjAAAU7jUwQC9LXye0xQCyqHqYb3YkCeXO9dx8q57NZk7yALZXnzWsU
        4WJ8m+FD94T+SPALosHu544b3Dc=
X-Google-Smtp-Source: APXvYqwxe8/ri+tO2+6KLjWCHae7EG05woOWj6UfY8XszBjg6Vnr6PtDaw2QRC4T/nocxwVMBjLxLw==
X-Received: by 2002:a1c:6c0c:: with SMTP id h12mr3284112wmc.35.1551801390971;
        Tue, 05 Mar 2019 07:56:30 -0800 (PST)
Received: from box ([146.247.46.6])
        by smtp.gmail.com with ESMTPSA id g15sm13165507wmg.16.2019.03.05.07.56.30
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 05 Mar 2019 07:56:30 -0800 (PST)
Date:   Tue, 5 Mar 2019 17:56:28 +0200
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/3] kernel-shark: Fix a memory leak in the sched_events
 plugin
Message-ID: <20190305155627.GB19674@box>
References: <20190305143924.11056-1-ykaradzhov@vmware.com>
 <20190305143924.11056-3-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190305143924.11056-3-ykaradzhov@vmware.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Mar 05, 2019 at 04:39:23PM +0200, Yordan Karadzhov wrote:
> When the sched_events plugin fails to initialize not all the
> memory allocated for the context of the plugin is freed properly.
> The problem gets fixed by using the free_context helper function
> defined in the previous patch.
> 
> Fixes: 4f392730e ("kernel-shark-qt: Make Sched event plugin use ...")
> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> ---
>  kernel-shark/src/plugins/sched_events.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel-shark/src/plugins/sched_events.c b/kernel-shark/src/plugins/sched_events.c
> index 0d6de2d..fe13e6a 100644
> --- a/kernel-shark/src/plugins/sched_events.c
> +++ b/kernel-shark/src/plugins/sched_events.c
> @@ -74,8 +74,12 @@ static bool plugin_sched_init_context(struct kshark_context *kshark_ctx)
>  
>  	event = tep_find_event_by_name(plugin_ctx->pevent,
>  				       "sched", "sched_switch");
> -	if (!event)
> +	if (!event) {
> +		plugin_free_context(plugin_ctx);
> +		plugin_sched_context_handler = NULL;
> +

Nit: drop the above empty line?

>  		return false;
> +	}
>  
>  	plugin_ctx->sched_switch_event = event;
>  	plugin_ctx->sched_switch_next_field =
> @@ -320,11 +324,8 @@ static int plugin_sched_init(struct kshark_context *kshark_ctx)
>  {
>  	struct plugin_sched_context *plugin_ctx;
>  
> -	if (!plugin_sched_init_context(kshark_ctx)) {
> -		free(plugin_sched_context_handler);
> -		plugin_sched_context_handler = NULL;
> +	if (!plugin_sched_init_context(kshark_ctx))
>  		return 0;
> -	}
>  
>  	plugin_ctx = plugin_sched_context_handler;

Looks good to me.

Reviewed-by: Slavomir Kaslev <kaslevs@vmware.com>

-- Slavi

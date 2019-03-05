Return-Path: <SRS0=DxZ9=RI=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA350C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Mar 2019 15:58:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9502120842
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Mar 2019 15:58:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728241AbfCEP6A (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 5 Mar 2019 10:58:00 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34755 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726190AbfCEP6A (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 5 Mar 2019 10:58:00 -0500
Received: by mail-wr1-f65.google.com with SMTP id f14so10048494wrg.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 05 Mar 2019 07:57:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=24fl7KF3mAiZmHvIKo9CWJgU4fTY/zMQfvGw1uYymAc=;
        b=Z2JTT6LJsSD6ejbnRfAfo7w5KhRUq34giveAekC2koa6NW8Qdx26kPJIAlszrVjcZt
         cuSMo6mal8SIIlmOpbXBEFwB3HqI5W1P0DAPeereTIQquxt0Vro/6nAfQvDwhPn4HfBn
         H3q9nOZzVkBt72wAi1S5BYWWUD81xLg7b6o+pz4QPcraz4AKRkHh3WeX8ld9xAK1WpvV
         crGhvZCpkrg8cst/lpjC4nyMX/5I2iUeWfFaezYplFMWGEIuUfW+6TfqNpfDUajpnt6Q
         vcnyNZA2szON+jsLmcVF+vLSyGrHukc8g5hvlji0lIr9Y+bpH/qeHyMD0Byj4del6c/g
         rK7g==
X-Gm-Message-State: APjAAAX+cLOfp3yB1AoP65kkyQ9gxdTvweqBG8f7Xp4gAtF2qrdqEgjh
        vw+cuVgL/dCyzsLtEk8oAw==
X-Google-Smtp-Source: APXvYqzrt+JN3YBut4D6wxxvwbNtHnLp5BjUSFxTb8oJzh3o2PA0Od3EsQ4NZHIZpMsFHuhkYyXgRQ==
X-Received: by 2002:adf:b7c1:: with SMTP id t1mr3215381wre.248.1551801478287;
        Tue, 05 Mar 2019 07:57:58 -0800 (PST)
Received: from box ([146.247.46.6])
        by smtp.gmail.com with ESMTPSA id e7sm14582718wrw.35.2019.03.05.07.57.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 05 Mar 2019 07:57:57 -0800 (PST)
Date:   Tue, 5 Mar 2019 17:57:55 +0200
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 3/3] kernel-shark: sched_events plugin init with
 sched_switch events only
Message-ID: <20190305155754.GC19674@box>
References: <20190305143924.11056-1-ykaradzhov@vmware.com>
 <20190305143924.11056-4-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190305143924.11056-4-ykaradzhov@vmware.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Mar 05, 2019 at 04:39:24PM +0200, Yordan Karadzhov wrote:
> The sched_events plugin should not be totally disabled when the
> wakeup events are missing. The initialization of the plugin must
> fail only if the trace.dat file contains no sched_switch events.
> 
> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> ---
>  kernel-shark/src/plugins/sched_events.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/kernel-shark/src/plugins/sched_events.c b/kernel-shark/src/plugins/sched_events.c
> index fe13e6a..c52fb29 100644
> --- a/kernel-shark/src/plugins/sched_events.c
> +++ b/kernel-shark/src/plugins/sched_events.c
> @@ -104,9 +104,6 @@ static bool plugin_sched_init_context(struct kshark_context *kshark_ctx)
>  					   &plugin_ctx->sched_waking_event,
>  					   &plugin_ctx->sched_waking_pid_field);
>  
> -	if (!wakeup_found)
> -		return false;
> -
>  	plugin_ctx->second_pass_hash = tracecmd_filter_id_hash_alloc();
>  
>  	return true;

Looks good to me.

Reviewed-by: Slavomir Kaslev <kaslevs@vmware.com>

Thank you,

-- Slavi

Return-Path: <SRS0=6fae=VP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E952C76191
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Jul 2019 06:36:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA55320880
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Jul 2019 06:36:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MiQVmLeL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbfGRGgX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 18 Jul 2019 02:36:23 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36383 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726376AbfGRGgX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 Jul 2019 02:36:23 -0400
Received: by mail-wr1-f66.google.com with SMTP id n4so27351831wrs.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Jul 2019 23:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NlhylnKDRhfbhiEUyDv4ZSjw/9vD0AI50DL2o0G1CS4=;
        b=MiQVmLeLz/TkM4uELn/p7+O0N76tAxonR9+ZEwbCFfHa8A+eHzlKqDh36/bwnFbJ+O
         Sfec/7jAH9hc74zQ2f+gaon2E4Pf75ilXqnG7YCHun3pvjdOCMYNMF4Lmgf6KnP44rKG
         ZFcrVYK5+hqQ9QqHqsvXaEZEirUVnfdxcprfRrlv/thswfhKM9nmWuANgn6RE+pUMi+Z
         gxSGroaHkjZS0rVNtOi3T/MPzrYke0zX4ONLsUo+vRd70gO9eV2L3j9MCePe/OCeQDcZ
         /JPRIgRqZxv6cW+PqjvrowUlL5LfZsBnRaRvNdl/flsGye9sq0s8/2ue2dc3qj1UqPLw
         z8MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NlhylnKDRhfbhiEUyDv4ZSjw/9vD0AI50DL2o0G1CS4=;
        b=hUDIoAKzlWb3ipRdS4dmeIHcxN2I6fpk0EK8TxZ1tZ3sF9c5lgP7zkzzr9brg3ivZT
         hjwbR/w8X6F3U38mQAdKj+cqdjkldZPgGjH2IKjXbjlcEHHu2gcF8uLM3eyL/FMaUGwR
         9jWyjTSQx+Yr5k1cIBqm7kuSRs0IRxfxb948McUfu+b/Bg9v/s8lg3FYNip9UpYk2cQT
         tAnlayyAUO0kE3HffHr9m1XEwPeH15OovIdOQJ7EaNbVyq8AfUaxW2sS6UtuKNo5fn8E
         bUn8esEJ9vNOWUIinLS3v8mo6k91EFCG98piBdP/zGfB/XOsG0OrnnxDevzxNUKaeTkv
         Pbcw==
X-Gm-Message-State: APjAAAUAeE2qYAA9uKZ2qNRB84AfNrjQxK6TyuXYZ3OMlSfSLKShpYHD
        aIrCTIRSf44o+hsptkflbOqHuO1JiHM=
X-Google-Smtp-Source: APXvYqyyT9AZ9rOl1btRpuZzZYANeyfMndaH+6cOxacjaSYkHPx0hEI6B2ug3SPrF8pQfMJmOc6MgA==
X-Received: by 2002:adf:f050:: with SMTP id t16mr44562810wro.99.1563431780828;
        Wed, 17 Jul 2019 23:36:20 -0700 (PDT)
Received: from [10.27.112.183] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t24sm24349450wmj.14.2019.07.17.23.36.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Jul 2019 23:36:20 -0700 (PDT)
Subject: Re: [PATCH 1/2] kernel-shark: Initialize the data-related fields of
 the model
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20190717085306.12393-1-y.karadz@gmail.com>
 <20190717085306.12393-2-y.karadz@gmail.com>
 <20190717083709.4a56867c@gandalf.local.home>
 <3117115a-5468-1b26-9a89-d871f43a1289@gmail.com>
 <20190717092818.34329697@gandalf.local.home>
 <00e8b2e5-2112-0681-7cbb-a3919ddd63c8@gmail.com>
 <20190717152646.0798bdc7@gandalf.local.home>
 <20190717152744.50b450cf@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <72ea5426-ea9e-7c18-e540-504638b0a562@gmail.com>
Date:   Thu, 18 Jul 2019 09:36:18 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190717152744.50b450cf@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 17.07.19 г. 22:27 ч., Steven Rostedt wrote:
> 
> And here's the version that claws-mail didn't line wrap :-p
> 
> -- Steve
> 
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> Subject: [PATCH] kernel-shark: Initialize all fields of struct kshark_trace_histo
> 
> The function ksmodel_init() is to initialize the kshark_trace_histo
> structure to zero. Currently it does it via each field. It is safer to use
> memset() that will guarantee that the entire structure is set to zeros or
> NULLs if new fields are added. This is required because there's places in
> the code that check if a field is NULL or zero to determine if it should be
> set or not.
> 
> Link: http://lkml.kernel.org/r/20190717085306.12393-2-y.karadz@gmail.com
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204195
> 
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>   kernel-shark/src/libkshark-model.c | 8 +-------
>   1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/kernel-shark/src/libkshark-model.c b/kernel-shark/src/libkshark-model.c
> index 18f9c691..6c54e1e1 100644
> --- a/kernel-shark/src/libkshark-model.c
> +++ b/kernel-shark/src/libkshark-model.c
> @@ -36,13 +36,7 @@ void ksmodel_init(struct kshark_trace_histo *histo)
>   	 * Initialize an empty histo. The histo will have no bins and will
>   	 * contain no data.
>   	 */
> -	histo->bin_size = 0;
> -	histo->min = 0;
> -	histo->max = 0;
> -	histo->n_bins = 0;
> -
> -	histo->bin_count = NULL;
> -	histo->map = NULL;
> +	memset(histo, 0, sizeof(*histo));
>   }
>   
>   /**
> 

Thanks!
Yordan

Reviewed-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>


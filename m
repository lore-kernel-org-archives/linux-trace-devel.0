Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 111A7C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 Jan 2022 12:31:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245482AbiAJMbP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 10 Jan 2022 07:31:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245509AbiAJMa6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 10 Jan 2022 07:30:58 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DDE2C061751
        for <linux-trace-devel@vger.kernel.org>; Mon, 10 Jan 2022 04:30:58 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id m21so53134582edc.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 10 Jan 2022 04:30:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=jUP87Xlk8TwwxMg9X2tilNV+0kFUJ2mODY3C22S174Q=;
        b=VxQH66yXw7Pnb63eWfaJuvR+6l78OK8MavXxKngdjV3PDpjYuGV72v2pA3AeonsCIE
         Yiqw3tI/4UtoCjdUIyIVn4MHavNINlUMLqiSKmSsJpX4ktjBZZ2UI1z2ysVircR7bm0K
         LjQ+kCakvqw2J8xsJSHre/WGF+7oYL8CNEsIJZTuS/CynJsheVw+ETCSWj0mj86aWQwu
         OAEB1lY8skKMbYN37n3Ndb4W6CclycelIg1xkZT65g9Ub0xGLNU9JOo2K4yQP7eFOfob
         cdlKsLQXgb62HsLcHz21iWTQBjnXl3HpdtFsbKQLVMsAyVtJTPcWEHVbm22ZrBuwqMAF
         RJTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jUP87Xlk8TwwxMg9X2tilNV+0kFUJ2mODY3C22S174Q=;
        b=C/U8twL7Mwztziq/pdO79dIjJYEyvb7C+k3MTF1fSwdZLPWgadXSQFuaaetLExdO2R
         bE96VS3Zc8neLWncukUxOqcClHLzg2/PLtCDOqznKnSaP6k/Y6rfyPYo+JluAl3lGhzm
         MCugQcVgSS/WYronlKUB3VomK/VzmYSAM316ngquch0bjbWT+qivsiBKb0EHT8UZwDeN
         I9XKFKgl0sNPqFaRRwKV46ZJaDE07VWWS+MqreOQcqD5dT+ayc/wL5Tlqw1KeuinE14g
         TZhrpm7TmJXuV6dqdu/RHzPusgUnZ3SO2c7U5kf1IrTcptRP+hzvklzgtu8wBvq8JgGU
         Z6OQ==
X-Gm-Message-State: AOAM530Di8eVwxHm3y9swh3yeq6q1RSpVNsJaddrH5UjRlznEBsdEHUq
        U22tEOaQXGnZuQaFbR6XSF91TmgKgho=
X-Google-Smtp-Source: ABdhPJyk/aNbbq/CG3c6/66BnZNpxOII7ZZ7SA/WmRSDPJ9F8Zh7qE+H9Icec0cHl4ZUD5+PkFl8+w==
X-Received: by 2002:a05:6402:f16:: with SMTP id i22mr1139476eda.165.1641817856775;
        Mon, 10 Jan 2022 04:30:56 -0800 (PST)
Received: from [192.168.1.9] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id go6sm2312044ejc.31.2022.01.10.04.30.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jan 2022 04:30:56 -0800 (PST)
Message-ID: <94a25e48-424b-81ac-5ad5-92ec4e7468d9@gmail.com>
Date:   Mon, 10 Jan 2022 14:30:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH V4 1/3] kernel-shark: fix typo in sched_events.h
Content-Language: en-US
To:     Hongzhan Chen <hongzhan.chen@intel.com>,
        linux-trace-devel@vger.kernel.org
References: <20220110042518.9376-1-hongzhan.chen@intel.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20220110042518.9376-1-hongzhan.chen@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 10.01.22 г. 6:25 ч., Hongzhan Chen wrote:
> fix typo in sched plugin and make it easier to read.
> 
> Signed-off-by: Hongzhan Chen <hongzhan.chen@intel.com>
> 
> diff --git a/src/plugins/sched_events.h b/src/plugins/sched_events.h
> index 2c540fd..a2ba4b4 100644
> --- a/src/plugins/sched_events.h
> +++ b/src/plugins/sched_events.h
> @@ -9,8 +9,8 @@
>    *  @brief   Plugin for Sched events.
>    */
>   
> -#ifndef _KS_PLUGIN_SHED_H
> -#define _KS_PLUGIN_SHED_H
> +#ifndef _KS_PLUGIN_SCHED_H
> +#define _KS_PLUGIN_SCHED_H
>   
>   // KernelShark
>   #include "libkshark.h"
> 

I applied this one.

Thanks,
Yordan

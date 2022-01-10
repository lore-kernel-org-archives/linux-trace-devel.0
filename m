Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E9E0C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 Jan 2022 13:21:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbiAJNVK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 10 Jan 2022 08:21:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbiAJNVJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 10 Jan 2022 08:21:09 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B537C06173F
        for <linux-trace-devel@vger.kernel.org>; Mon, 10 Jan 2022 05:21:09 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id u25so53536149edf.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 10 Jan 2022 05:21:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=yseOE7B4m3EzyNxovX4lB07NiZskpuh8F0w6PPEpgYw=;
        b=gzvTW9aYHBUs6iym5bqbs3jc/eDf3XxC5exgAzpUvWJMN4HgfG+S3kiW0/YiLpOYrY
         AWEi50dLeMHeXQQSmzZDOczvPPydtYmg2asrvqox1JBZHPvyVZY5iP8sywOy9EkpjmJN
         Qr9wujkNQnq/kX+uRbaRLX2UBsYEA5JauF7thRQ7u0yRsQKufvCTNiSnfjVGeYipanKw
         hQPcXJOF9nk79/lJq2BnIvOmDnV8YWF/pTr9J/Kq6Ov0LwGv2PMoMdjXFpaUMlsLO9/+
         /z3NdVPQ6KXxqKnSGxKmc+ItDy6HSzeqI+8D9kxRVaYzBXjH8zJlLdFPapvFq3vSUEuh
         KjBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yseOE7B4m3EzyNxovX4lB07NiZskpuh8F0w6PPEpgYw=;
        b=xO6pagf4sF+DCahDbytr+E7ezTZ+dqqLxERJd3dW+/fvRj0ASNaorHUoSDvWATeLiK
         yqn5VB4+VNYkzm2BSrLtME6Uo2vdJa7Qrm74z8Z64hJ6Rp/v9gFHqBy+WpgbGW0ZNt3Y
         DkEpLYCh+/aR9UCrFb5O1InUyPTFV6rTTe5GTGNdbKFcyTjn8yJcLhYEy1V9sFQ2siCe
         tlqGSAGDt95kXF/ANFKGlWJwW9TFz7VjqCEt8MALkQZ4Pu40Nqw3aHpHh0M7VyTBA+e8
         YMBKL2Sm4Nx4WDjE++u0EQX7xwMVL54yevDDZHQrcuHjaM/8tHbV1sZDXxQkvHNszyI5
         +O0g==
X-Gm-Message-State: AOAM533GyRRFe+uMG4S9IZWVzIiWyTWsstbWd4jHnB5oMT2CNLZYa/5X
        nQwkk1U2yApeexIH0hPR0lDyyLxnZ9Q=
X-Google-Smtp-Source: ABdhPJzNmU86QeGg/UpJNnWZ9GVKbzhj3JYX8orZy3NmOrYlGf/3b76rqgwLdgifRd+T1av6Veivmg==
X-Received: by 2002:a17:906:f256:: with SMTP id gy22mr14171203ejb.670.1641820867775;
        Mon, 10 Jan 2022 05:21:07 -0800 (PST)
Received: from [192.168.1.9] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id x20sm3535428edd.28.2022.01.10.05.21.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jan 2022 05:21:07 -0800 (PST)
Message-ID: <630880f4-7056-84a4-66ad-17198fcd5400@gmail.com>
Date:   Mon, 10 Jan 2022 15:21:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH V4 3/3] kernel-shark: Add plugin for handling Xenomai
 cobalt_context_switch
Content-Language: en-US
To:     Hongzhan Chen <hongzhan.chen@intel.com>,
        linux-trace-devel@vger.kernel.org
References: <20220110042518.9376-1-hongzhan.chen@intel.com>
 <20220110042518.9376-3-hongzhan.chen@intel.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20220110042518.9376-3-hongzhan.chen@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 10.01.22 г. 6:25 ч., Hongzhan Chen wrote:
> +	eventFieldIntervalPlot(argvCpp,
> +			       plugin_ctx->cs_data, checkFieldCS,
> +			       plugin_ctx->cs_data, checkEntryPid,
> +			       makeLatencyBox<XenomaiSwitchBox>,
> +			       {0, 0, KS_COBALT_BLUE}, // Cobalt Blue
> +			       -1);         // Default size

Hi Hongzhan,

I meant something different with my comment about 'cobalt blue'. Here you define the color with RGB coordinates (0, 0, 
255). This means 255 on the blue axis and zeros on the red and green. This is what I meant by 'just blue'. The RGB 
coordinates of the 'cobalt blue' color are (0, 71, 171). This means it is some mixture between green and blue.

Cheers,
Yordan

Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A0FDC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Mar 2022 14:59:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238570AbiCNPAa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Mar 2022 11:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240477AbiCNPA3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Mar 2022 11:00:29 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C80C3FBD7
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Mar 2022 07:59:19 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id dr20so34012283ejc.6
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Mar 2022 07:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=ANWUORlrjZDR6YDF3DP6QZujY+iXGaOq38VfGTIppag=;
        b=buUK3OB4hIXHGG8EC1eTvMq8rdk+lZ4RvCDl6YGgvsBQJ4ia2HQ3MsacOqJo6g505b
         BXJZBTNoNe4x5LNpBGBwgJz+qUOaXLfIyNiOh16B0m1wOd95YaK+pSO+6zC7ZgMFWUeK
         /Vss6M7jStplsks56K9K0wT+Z5Lfx5VtGN3uol0LiN7ZfeVeI9Hm/ioi9Iv4kZw5j7F6
         /rkJQFwrD0JC/0WGcQCBYLGWJYjX5dV5DCtPEPbQL+BVEdG52jV5jEtubFS9qDPWaHZ0
         a4FnBE7N+2uH6540o3vjykE0LXGpqm0ZDdn8kcEn6IsVabgUD5cjQwcMlme3LcpFdBBC
         rvCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ANWUORlrjZDR6YDF3DP6QZujY+iXGaOq38VfGTIppag=;
        b=VRP62R94amaT4rjiq7yJOp5hcThvFU+Ve2cVvqhqBSvxhPzoC5ihROKhWcxaj3aA6C
         6hV6PuyblNHZwnYKrPkPdBkNk2okjAC4z8I5dZeyX/CKj+TqvwjPVXUE1nR4B+AFqB3a
         5sNI8ElEIpZ8WbrlJDC3a8gBJ4QcU2GUvA1g6cz1mYwNTdFn9BmV6h5P2FwjYIktExZr
         PAClFfT6u5fVj95plHfbMNV1f5b+eW4rIiRnQhwIZcf3T/B6cLx0L8BxjHdB4EBBnsfS
         o/e2ts0PTZoQlYjLAJWolANQLhHPkDoBP9yFM1XKtUMiB2VVu9TTl7F3lCaSAjbxhMM1
         NDBg==
X-Gm-Message-State: AOAM530ny284vubb8xhOPAjizGkVGYZiHojF/8RwJgHDBKP3xnM1Fv3c
        7AZY8GPIQqFcHQUicmWAQuw33QcA/p8=
X-Google-Smtp-Source: ABdhPJzUFV/lhtxM4t9Yki5qo8VFqy7PPeEg2oZul75F4xk66IItH5wDlmBMEVNVifrUBRKhvOXuGA==
X-Received: by 2002:a17:907:c0c:b0:6d1:8c46:6415 with SMTP id ga12-20020a1709070c0c00b006d18c466415mr19266965ejc.326.1647269954745;
        Mon, 14 Mar 2022 07:59:14 -0700 (PDT)
Received: from [192.168.1.10] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id r29-20020a50c01d000000b00415fb0dc793sm8102591edb.47.2022.03.14.07.59.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Mar 2022 07:59:14 -0700 (PDT)
Message-ID: <7aeb8865-3f66-3938-14a6-48b3147455ec@gmail.com>
Date:   Mon, 14 Mar 2022 16:59:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 0/2] trace-cmd library: Fix sparse cpu_data
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
References: <20220312234032.127108-1-rostedt@goodmis.org>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20220312234032.127108-1-rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steven,
Is this fixing the issue with kernelshark crashing when trying to open the new format?
thanks,
Yordan


On 13.03.22 г. 1:40 ч., Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> I have a new box that has 128 logical CPUs, and when I do trace-cmd record, as
> most of my CPUs are idle, they are not recorded into the CPU file.
> 
> I had a test run that only had 35 of the 128 CPUs have data, and trace-cmd
> created a 35 cpu_data array to hold this information. But when I tried to load
> this into KernelShark, it crashed.
> 
> It crashed because it uses the CPU number to retrieve information. Thus, when
> it asked for CPU 45 and the internal trace-cmd library only had 35 cpu_data
> items, it overlooked the array.
> 
> Make the array non sparse. That is, if there's only one CPU in the file, and
> it's CPU 100, make an array of 101 (including CPU 0) where all the CPUs with
> no data just have a cpu_data filled with zeros.
> 
> Also, fix tracecmd_read_cpu_first() return NULL if the CPU passed to it is
> greater than the number of items in the cpu_data array. This is because it
> would ask for cpu 64 but the last CPU with data in it was CPU 63, and
> trace-cmd library only made an array of 64 (0-63) items.
> 
> Steven Rostedt (Google) (2):
>    trace-cmd library: Make cpu_data[] match the cpus
>    trace-cmd library: Do not read CPU greater than CPUs registered
> 
>   lib/trace-cmd/trace-input.c | 54 ++++++++++++++++++++++++++++++-------
>   1 file changed, 45 insertions(+), 9 deletions(-)
> 

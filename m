Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CECACC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Jan 2022 10:55:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239738AbiA0Kzk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 27 Jan 2022 05:55:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239730AbiA0Kzk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 27 Jan 2022 05:55:40 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC6D3C061714
        for <linux-trace-devel@vger.kernel.org>; Thu, 27 Jan 2022 02:55:39 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id s5so4977296ejx.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 27 Jan 2022 02:55:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=G2H00pgIiXm42rI345MhgKgU2iL1nv+B9WRnc5b0bpc=;
        b=E7Dz5TAhr4AIwisiLDZl4QiSXPsPfHD7NzXopfX9VoHmR8GkPDMXEO3sJzvGM40jvc
         YqodFSlv0eUiV5hSwtwPcM/v4qn+QSU73rtDp0cw5pC+HvAhuGUR6fwbQPmoJW57pinq
         ZFJktFRTWGpZTsLvevQPMvTYNhnsOaYCwPOcRcn2VeF4FN7sQjLKAYM/icrN/7kFhhUV
         AmsezPvvxO63uk6IK8hU4kYm2bXxvsAPupITHzbK/UZyxJF4EVacUfqpDwIGpehTY097
         5UfEEn86A7N+lFPffQBzfVhmkt3aWW1TRbx1UBEghNdivHa8LckV1e7awzkmTnESz0vz
         qhbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=G2H00pgIiXm42rI345MhgKgU2iL1nv+B9WRnc5b0bpc=;
        b=wdayKoxOOoZgfX+zLHyyRyv0O5k39y6Uv5eExodvTRKoKLyh2+XSNuz5fKlzByeEEv
         W6Wc84F8XwKDWC+mll468Ek8PKWS6NXjCj6EXSpSjjbLHxxvIGFGA5UnmkFzv1mIvM31
         YcGWx7mSSiwzO/0xA16GVdKqb+GV0Co7a093H/iaCgLvoPXY3aMA3W69yo9MOnygfooh
         /FYpheda8CG13SGFRrvHQEUfs3MkIMdDh5mjv92GfO7VUU2DwURD963gcIMk+tJd8kWM
         MCj9eGaLBuuhJi+Qt0ik05IVc+8BP1KPTu6ULSKvCYYvZJfUs381nV2LbmvYk/57NV6O
         rafw==
X-Gm-Message-State: AOAM532T1UPg2Uexv586c3eOJcDSQewMo97CyMtFR8+ROvh3o1BnzUrX
        DGG4pfG004TAWJoD3N9975PIKuRk6fc=
X-Google-Smtp-Source: ABdhPJx3M/tCE0saaHOugCFFo3xh1A531fvgjsXO77WYzIqMs8h2GZ2WdUUKS3iSQXonyT+urq8dLw==
X-Received: by 2002:a17:906:2287:: with SMTP id p7mr2595815eja.239.1643280938479;
        Thu, 27 Jan 2022 02:55:38 -0800 (PST)
Received: from [192.168.1.9] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id f26sm11023461eds.69.2022.01.27.02.55.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jan 2022 02:55:38 -0800 (PST)
Message-ID: <406f05fb-c462-d930-b71e-35d5c77ebe32@gmail.com>
Date:   Thu, 27 Jan 2022 12:55:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH] trace-cruncher: Update CONTRIBUTING doc with tests
Content-Language: en-US
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
References: <20220127061653.23426-1-tz.stoyanov@gmail.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20220127061653.23426-1-tz.stoyanov@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 27.01.22 г. 8:16 ч., Tzvetomir Stoyanov (VMware) wrote:
> All trace-cruncher code should be covered by the unit tests. Added
> instructions how to run the tests in CONTRIBUTING document.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>   CONTRIBUTING.md | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/CONTRIBUTING.md b/CONTRIBUTING.md
> index 1f73807..7f6c5af 100644
> --- a/CONTRIBUTING.md
> +++ b/CONTRIBUTING.md
> @@ -20,6 +20,11 @@ The preferred coding style for the project is the [Linux kernel coding style](ht
>   The project follows the conventions for [submitting patches](https://www.kernel.org/doc/html/v5.4/process/submitting-patches.html)
>   as described by the Linux kernel.
>   
> +### Tests
> +
> +Make sure that all your changes are covered by the tests. Before submitting your patch, make sure everything works at 100% running the tests in **tracecruncher/tests**. As trace-cruncher interacts with the Linux kernel tracing infrastructure, the tests must be run with root privileges:

Thanks a lot for spotting this insufficiency in the documentation. However let's make it even better.
First of all, we need to add an empty line here in order to have the command showing up on a new line on github.

And second, note that if you run this in the trunck of the repository this is not going to work. First you have to do
cd tracecruncher/tests

Also it is good to mention that before testing your modifications you have to make sure the modified module is 
installed. (sudo make install)

Thanks!
Yordan


> +`sudo python3 -m unittest discover .`
> +
>   ## Reporting Bugs and Creating Issues
>   For bug reports and issues, please file it [bugzilla](https://bugzilla.kernel.org/buglist.cgi?component=Trace-cmd%2FKernelshark&product=Tools&resolution=---)
>   
> 

Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF000C43334
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 Jun 2022 16:43:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347511AbiFOQne (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 15 Jun 2022 12:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348484AbiFOQmw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 15 Jun 2022 12:42:52 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D7A7DFAF
        for <linux-trace-devel@vger.kernel.org>; Wed, 15 Jun 2022 09:42:50 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id 25so16984125edw.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 15 Jun 2022 09:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=WaufT6NhOGkOUUiHssQ7I7VV3lFRlfxRg2L0WUCjh6k=;
        b=noYbM5q4p6VBrupENwOLyhpsYyB7+ZaMlA2QaWLte+hieiBAzBmoAsRT3Zw8pULwSe
         D0ogAOnfPdMVo65VcKX+RzMUXLwA2bvlwVo6lG26+lV0a4Di6EU8EeZ/7yZwiqyrhlx6
         rQULPeGQO70TeOf6IBjMPFS/Ac90ivvO5OmAiQQ4Fp7hN/F8iCD0xFsJPnG9xehdpy2V
         2eCkR4jTPu1tAE9OxfCJ0o1h6PDIJyBS909e/zSpeTTy6PQ108B4CcW47y0e/fcxmTla
         eUxdQES0Ht+zlNihLLBLQN93sCCwmLO/qCygXwkjNL/HR4K4S0m6/RRU0FQXHxmhQt2g
         0iHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WaufT6NhOGkOUUiHssQ7I7VV3lFRlfxRg2L0WUCjh6k=;
        b=xbUAJVHZ2GF0vMhUOBhiTCcUiGCt+CoQlsIVYefGJFFPBOlWMIq+e4FAgmpSZMTqTY
         ga2/I5uiqRm2N3inXoRNkDQzc+nZ/Ov/9RNugavcpDpUOGUICwpHlsLMZuQ6YhKQ6dHi
         A16P821S+1L47P5IV6W5ETHVs4hdYFimG0cSVx0+jZOdpcgX91gF4rFPSnuX0CXPy4hg
         q51SEVFb1ByQD4YR1AXn3g1xtuj8e9Zwzc3eyhtief3Oecn24Ije/PfqJusOJfaVDGW/
         Lb5eUgHw3WaRx6F2YviKCEscP5bab+pLG43YzR+kyRCmHZX9I6BpuqHL4GWQS5qgEEPb
         oS8Q==
X-Gm-Message-State: AJIora9ELoMzvuuprFEwXUl+XjbK5DNhykW0CxALcmeHHS6LsGsp2fIW
        +7okfK30ZeAF1nwiyDZfrq66n6NcVbE=
X-Google-Smtp-Source: AGRyM1ucdWbHOkBIkh7FKYP9ckrG5P35a8DsciaxVOMmxMY2qTZi108fXruCvhGMYSoCcdZvkMk9Jg==
X-Received: by 2002:a05:6402:27cf:b0:431:54d9:28ed with SMTP id c15-20020a05640227cf00b0043154d928edmr767059ede.81.1655311368747;
        Wed, 15 Jun 2022 09:42:48 -0700 (PDT)
Received: from [10.107.150.145] (78-154-14-90.ip.btc-net.bg. [78.154.14.90])
        by smtp.gmail.com with ESMTPSA id fe6-20020a1709072a4600b00704a5c530ccsm6467968ejc.162.2022.06.15.09.42.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jun 2022 09:42:48 -0700 (PDT)
Message-ID: <4f98c00b-ace7-3992-c251-1559153eec54@gmail.com>
Date:   Wed, 15 Jun 2022 19:42:47 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] trace-cruncher: Enable Github development flow
Content-Language: en-US
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        linux-trace-devel@vger.kernel.org
References: <20220615151558.226641-1-tz.stoyanov@gmail.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20220615151558.226641-1-tz.stoyanov@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Looks good to me.

Acked-by: Yordan Karadzhov <y.karadz@gmail.com>

On 6/15/22 18:15, Tzvetomir Stoyanov (VMware) wrote:
> Github development flow is more popular among python developers. The
> CONTRIBUTING file is updated to enable both mailing list based (current
> one) and PR based (github) development flows. The main motivation for
> this change in to attract more contributors.
>
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>   CONTRIBUTING.md | 26 +++++++++++++++-----------
>   1 file changed, 15 insertions(+), 11 deletions(-)
>
> diff --git a/CONTRIBUTING.md b/CONTRIBUTING.md
> index 865fcc8..c22780b 100644
> --- a/CONTRIBUTING.md
> +++ b/CONTRIBUTING.md
> @@ -5,21 +5,25 @@
>   The trace-cruncher project team welcomes contributions from the community. All contributions to this repository must be
>   signed. Your signature certifies that you wrote the patch or have the right to pass it on as an open-source patch.
>   
> -The development process of trace-cruncher is strongly coupled to the development of the Linux kernel tracing libraries [libtraceevent](https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git), [libtracefs](https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/) and [KernelShark](https://git.kernel.org/pub/scm/utils/trace-cmd/kernel-shark.git/). Because of this reason we adopt and follow the development workflow established by those projects.
> +### Submitting patches
>   
> -For contributions to development, please send patches to: linux-trace-devel@vger.kernel.org
> +Patches can be submitted by either:
> + 1. Using the regular [Github Flow](https://docs.github.com/en/get-started/quickstart/github-flow):
> +    - The main branch is **tracecruncher**.
> +    - Any changes must be on a feature branch or on a fork.
> +    - Tests must pass before merging, and the pull request must be [reviewed](https://docs.github.com/en/github/collaborating-with-pull-requests/reviewing-changes-in-pull-requests) and approved.
> +    - Break the complex Pull Requests into small self-contained patches.
>   
> -[Subscribe](http://vger.kernel.org/vger-lists.html#linux-trace-devel) / [Archives](https://lore.kernel.org/linux-trace-devel/)
> + 2. Using the [Linux kernel](https://www.kernel.org/doc/html/v5.4/process/submitting-patches.html) development workflow:
> +    - Add prefix "trace-cruncher:" to the patch subject.
> +    - Break the changes into small self-contained patches and group them in a patch set.
> +    - Send patches to linux-trace-devel@vger.kernel.org
> +    - [Subscribe](http://vger.kernel.org/vger-lists.html#linux-trace-devel) / [Archives](https://lore.kernel.org/linux-trace-devel/)
>   
>   ### Code Style
>   
>   The preferred coding style for the project is the [Linux kernel coding style](https://www.kernel.org/doc/html/v4.10/process/coding-style.html#linux-kernel-coding-style)
>   
> -### Formatting Commit Messages
> -
> -The project follows the conventions for [submitting patches](https://www.kernel.org/doc/html/v5.4/process/submitting-patches.html)
> -as described by the Linux kernel.
> -
>   ### Tests
>   
>   Make sure that all your changes are covered by the tests. Before submitting your patch, check if everything works at 100% by running the tests in **tracecruncher/tests**. Compile your changes and install trace-cruncher (`sudo make install`), to make sure that your code is used in the tests. As trace-cruncher interacts with the Linux kernel tracing infrastructure, the tests must be run with root privileges:
> @@ -30,6 +34,6 @@ sudo python3 -m unittest discover .
>   ```
>   
>   ## Reporting Bugs and Creating Issues
> -For bug reports and issues, please file it [bugzilla](https://bugzilla.kernel.org/buglist.cgi?component=Trace-cmd%2FKernelshark&product=Tools&resolution=---)
> -
> -When opening a new issue, try to roughly follow the commit message format conventions above.
> +Bug reports and issues can be submitted by either:
> +1. Create a [Github issue](https://docs.github.com/es/issues/tracking-your-work-with-issues/creating-an-issue) in [trace-cruncher](https://github.com/vmware/trace-cruncher).
> +2. Report them in [bugzilla](https://bugzilla.kernel.org/buglist.cgi?component=Trace-cmd%2FKernelshark&product=Tools&resolution=---), **Tools and utilities** category, **Trace-cmd and kernelshark** component.

Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4497FC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Jan 2022 10:45:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232967AbiA0Kps (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 27 Jan 2022 05:45:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiA0Kps (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 27 Jan 2022 05:45:48 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ABF1C061714
        for <linux-trace-devel@vger.kernel.org>; Thu, 27 Jan 2022 02:45:48 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id s5so4921146ejx.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 27 Jan 2022 02:45:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0fwG5AOk4Ol+eb9dCvmtdojQ6MvE/Bbd3T68kX/sOoA=;
        b=MzdOidXA7dRgYDeLJ8YJOOtoelvL8XQU6KP8Ott+Ji9nJs7hdtf34iRQIxBy51KocG
         +Jgkdkrgf2lZfowRsp8DKxV2Rz/E3Mz0s4bbMKw0U9YfikuljGZdE9fpIN3HlAWYyErv
         MbIhFHwet/jlQUZXQj3L6JVwB8InBEBhTqnHly4hCf/RtA4uGRnRTQlm3ZNfFufhBxvn
         xukh1LJL56qeGKx/UJZr3LXG4QvzD/2vW7bIp4j1q2/R52k/cRDP1awQp2h9MW5diZA2
         TiyBkq3gJOyJk77YHkNmaTz3tgtS+H6sNvV4h9VqYGyFVdGZpWgGorina1/13AOEtx5a
         KVoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0fwG5AOk4Ol+eb9dCvmtdojQ6MvE/Bbd3T68kX/sOoA=;
        b=mh03xu3wX7/ndanXfzQhT8CP/Lq1r/LbcjrjtEjuq8PeyGu/jFuU8u8BYPxqcxEsQW
         m6exDSlmTSf4LlTgEYOkxQwadazrF1waOBtjdSIH4ZOePJBqkYEAXLMMsHKfE5CfUrS6
         fwn6BqC7G7tcRfbkBbzkwWkR2u2Dm6I3nNn7AJ8qOzJErrWtvTjZ70Hm+NnTqEopcQaB
         quBQ8ogGklU6BIHlExiTmhY4zz/h+cqOc8bUtWlzuPNz4D7syBSwapW0oBmr9fEJjWbb
         4TLEneUjDPPPjVa+kUR4dZf8epjE3E1R/pak0ZnHmxeUZEit+481rl0dgj1YPDBiTA+y
         55zw==
X-Gm-Message-State: AOAM532x4l1HOI9eLqwGDLOFul32JNwElKptH+rS/Lt2YB/psUPNm8LU
        7ZlSNuwhojPYAmM8xIOUFPa6Nw4K6p0=
X-Google-Smtp-Source: ABdhPJw7STzwLu/YJaMkHYfAa1LMor3oR7HzbJo92hKwmCg2eU1GZxQmyb4dsgUENT+U7YbpVAMfCA==
X-Received: by 2002:a17:906:7621:: with SMTP id c1mr2373866ejn.601.1643280346630;
        Thu, 27 Jan 2022 02:45:46 -0800 (PST)
Received: from [192.168.1.9] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id ee26sm8941182edb.53.2022.01.27.02.45.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jan 2022 02:45:46 -0800 (PST)
Message-ID: <836d032a-ed8b-56d6-5c2c-0b36143f6f63@gmail.com>
Date:   Thu, 27 Jan 2022 12:45:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v3 0/3] trace-cruncher: Add support for event probes
Content-Language: en-US
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
References: <20220127070111.27529-1-tz.stoyanov@gmail.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20220127070111.27529-1-tz.stoyanov@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Ceco,

I am applying this patch-set. Thanks a lot!

However, there is more work to do. Now, when we have the low-level API for eprobes, it is time to think for adding also 
some high-level APIs. You can have a look in:
tracecruncher/ft_utils.py

and get some ideas from the classes 'kprobe' and 'kretval_probe'

cheers,
Yordan


On 27.01.22 г. 9:01 ч., Tzvetomir Stoyanov (VMware) wrote:
> Event probe (eprobe) is a new type of ftrace dynamic events, introduced
> in the Linux kernel 5.15 version. It is useful to have support for them
> in trace-cruncher, as it allows more flexibility when printing event's
> data.
> 
> v3 changes:
>   - Added eporbe example.
> v2 changes:
>   - Rebase.
>   - Moved unit test in a separate patch.
>   - Added a check in the unit test if the kernel supports eprobes.
>   - Renamed the API from PyFtrace_register_eprobe() to PyFtrace_eprobe(), for
>     consistency with the other dynamic events APIs.
> 
> Tzvetomir Stoyanov (VMware) (3):
>    trace-cruncher: Add support for event probes
>    trace-cruncher: Unit test for event probes API
>    trace-cruncher: Example for event probes API
> 
>   examples/eprobe.py                            | 29 +++++++++++
>   src/ftracepy-utils.c                          | 32 ++++++++++++
>   src/ftracepy-utils.h                          |  2 +
>   src/ftracepy.c                                |  5 ++
>   .../tests/1_unit/test_01_ftracepy_unit.py     | 50 +++++++++++++++++++
>   5 files changed, 118 insertions(+)
>   create mode 100755 examples/eprobe.py
> 

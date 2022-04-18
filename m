Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 976EDC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Apr 2022 11:54:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237922AbiDRL45 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 18 Apr 2022 07:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbiDRL44 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 18 Apr 2022 07:56:56 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8276301
        for <linux-trace-devel@vger.kernel.org>; Mon, 18 Apr 2022 04:54:17 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 11so12169959edw.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 18 Apr 2022 04:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Igr9/UONrCQ/z0xUVHTiY2B+klFYnEC+3ZbBRj7Z5o8=;
        b=qgKoKmsIzDf5ABF2NdM6whdfpjV3wteD1ApS2LvbS3cp/emw7Un0Cfs0S4Ec2ojyGI
         R8/N9XmYHUfbQlOMd1yT7ZnXRcRVl1zqXqARAePTLs1bFO520G0/7ppeXkowF63kbaDp
         DKfvYf7Ts8kbWr8n76X3rsKWLikdkfgw+LSXjwhtKr8Z2cAd+tUWg0ei3ZFHGtj9kTny
         RlhmyUPzQWN4OhOroGCpK5xndssSkGh+NMvLpHbc+Lxoim41xUZDywxnR0dZ6SFEBXAb
         xPl9EQikN0krBgBpTJKPpfiekc3ZGAHLL8hvsY5jIiBlv2obt/1ItjDZCRk67ysaNvIl
         eYiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Igr9/UONrCQ/z0xUVHTiY2B+klFYnEC+3ZbBRj7Z5o8=;
        b=RJRWd7f2T3+ot4MZrSV9fAgFHEyuRWTOwDfkHjvXMrZqLkfyM1gVjb2d7lo4xAcohU
         oQn+MPZOel2B9jHaqT7Q5c0twqwicFkd0b3736zXv59akBRP7QBV7QnnPpyLAjbaPLxw
         gDyUauHKnRfRe6J53XAV+vaPjVMIHOXrXmzVZdAPm/dTOrK6WDb/iqb9FXg7J/3wO0hA
         6IE/LZpZcT4K3kuYBDICe4Sk1gw6vbsAnQU8jgywWhxvzV+wfYJ6RiPCHp4LXhvUQCx2
         JvC+IPKEVE7i3YBhbjMFwzDwA/HGH+xOj425sN2C2Wfqk1MAi+W7ByECsPCQdULHAI/l
         KfFQ==
X-Gm-Message-State: AOAM531EQ9/AWKKNjJ5kTz0c+N2uBZhmeIACs3u06HYmEsLOnWCSNus5
        MshCLYXQ/JYXkNTTe6SvzeQ=
X-Google-Smtp-Source: ABdhPJxIog8Wtb4NfzU+6D/j5M79x84v3EyzvTF9pC0xw3CORxVYMLVvcjPcBVocZnqWnCIm0YLkoA==
X-Received: by 2002:a05:6402:42c9:b0:423:e275:28d9 with SMTP id i9-20020a05640242c900b00423e27528d9mr6139226edc.176.1650282855760;
        Mon, 18 Apr 2022 04:54:15 -0700 (PDT)
Received: from [10.107.106.54] (78-154-13-168.ip.btc-net.bg. [78.154.13.168])
        by smtp.gmail.com with ESMTPSA id a23-20020a170906369700b006e8973a14dbsm4549620ejc.79.2022.04.18.04.54.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Apr 2022 04:54:15 -0700 (PDT)
Message-ID: <34da91e1-27ce-1e99-ec08-63abf62a49b0@gmail.com>
Date:   Mon, 18 Apr 2022 14:54:14 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v2 4/4] trace-cruncher: Example script for uprobes
 high level API
Content-Language: en-US
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
References: <20220415041012.36151-1-tz.stoyanov@gmail.com>
 <20220415041012.36151-5-tz.stoyanov@gmail.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20220415041012.36151-5-tz.stoyanov@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 15.04.22 г. 7:10 ч., Tzvetomir Stoyanov (VMware) wrote:
> Proposed example illustrates how to use uprobes high level API to trace
> all functions for user program. It can be attached to already running
> program, or run the program and trace its execution.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>   examples/user_trace.py | 43 ++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 43 insertions(+)
>   create mode 100755 examples/user_trace.py
> 
> diff --git a/examples/user_trace.py b/examples/user_trace.py
> new file mode 100755
> index 0000000..640ace8
> --- /dev/null
> +++ b/examples/user_trace.py
> @@ -0,0 +1,43 @@
> +#!/usr/bin/env python3
> +
> +"""
> +SPDX-License-Identifier: CC-BY-4.0
> +
> +Copyright 2022 VMware Inc, Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> +"""
> +
> +import sys
> +import shutil
> +
> +import tracecruncher.ftracepy as ft
> +
> +if __name__ == "__main__":
> +    if len(sys.argv) < 2:
> +        print('Usage: ', sys.argv[0], ' [PROCESS]')
         print('Usage: ', sys.argv[0], ' [PROCESS or PID]')
> +        sys.exit(1)
> +
> +    # Create new Ftrace instance to work in. The tracing in this new instance
> +    # is not going to be enabled yet.
> +    inst = ft.create_instance(tracing_on=False)
> +
> +    # Create a user tracing context for given process, exclude the libraries
> +    if sys.argv[1].isdigit():
> +        utrace = ft.user_trace(pid=int(sys.argv[1]), follow_libs=False)
> +    else:
> +        file = shutil.which(sys.argv[1])
> +        if file is None:
> +            print('Cannot find ', sys.argv[1], ' in the system')
> +            sys.exit(1)
> +        utrace = ft.user_trace(name=file, argv=sys.argv[1:], follow_libs=False)
> +
> +    # Trace execution of all available functions in the given process
> +    utrace.add_function(fname = "*")
No need for spaces around '='.

> +
> +    # Add trace points on functions return as well
> +    utrace.add_ret_function(fname = "*")
Same here

> +
> +    # Start tracing in an instance
> +    utrace.enable(instance = inst, wait=False)
and here.
> +
> +    # Read the trace buffer during the trace until ctrl-c is pressed
> +    ft.read_trace(instance=inst)
> \ No newline at end of file
Add new line at the end.

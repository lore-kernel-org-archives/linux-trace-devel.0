Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A252EC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Mar 2022 09:52:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiCRJxi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 18 Mar 2022 05:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiCRJxh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 18 Mar 2022 05:53:37 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 924241788D2;
        Fri, 18 Mar 2022 02:52:19 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id d10so15908084eje.10;
        Fri, 18 Mar 2022 02:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=zWNux0d8POfNG97Taca8iGl1l4uzk03jUQlRNyo67CQ=;
        b=b1LNRPwESqyEf0eMzmy3b3ykVpnpQJdetegCKLWV4vKQuZ/X9rJTS5AkiwD1Mjk9WM
         2xZxqdZFTA4pMm/D85q2P+78buIUpBPUsGhmLBeSBelnuXTglcm8GWA7P5B15ZN2ZnO+
         jSa3BeKFw6qbO+P0iLFW+L4hf4HzbTX+VlIg7q2pm+gVm+aSC3VAos7reLFJNcp09li1
         TDeLVThzTbjabm91NjRdlTbyE7shALYQLa8aA3MlbE8HmU5kVsb45cjYZDO/48lkTnNq
         NXz6McFBVLuPZCB69Eynt7OgZZ6pmdgiH2NoG3MyX9Rn2GJIxfDSblrsISr9alrdlirT
         M+NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zWNux0d8POfNG97Taca8iGl1l4uzk03jUQlRNyo67CQ=;
        b=BaQnVcmVGIkHphvMRgtlGrg8jMsCQmVXYNVtWpa0oeZyMLRYYPUKD1wpVvfTpMDgbq
         TLE7J/WVrMAf6810lZU3ZKx0Yf89hkoOlMVi6xWkvi8ZfWST4T846UEcCJUQM0vStr6V
         jfZF1ufP76UNF9jFuV1wWpAdFxjD0BLkxuN3iIRbp++IYWvGucYBtK/WwwQlPMNLvFyc
         o43eQCmElud8YgzkUbOPdbly4+k2e/wL0TQW/EfduF8kQxKG4k0CSgEzVrMbislCVnou
         BCP0v9C+QAC1zUW043A0Agk0zrG1PWBLSD/u7gESE1IIQp1lqLZosZyU9f3hCwhdKaCG
         9k5Q==
X-Gm-Message-State: AOAM531wVuZMSXISJIxLRREXi5JGvDM2bde2njJnLq2fTo+vTi/LmXSp
        sbNYT4i/aZ57AJsFQXfnQxY=
X-Google-Smtp-Source: ABdhPJyXtWQnFcw50h3pDI3HF2vvgYkKWIL9vGM7MByOChHkFHfrSRGSAReUuM/+M9LyMYZon4/nJA==
X-Received: by 2002:a17:906:f857:b0:6df:ae2d:73a0 with SMTP id ks23-20020a170906f85700b006dfae2d73a0mr3827763ejb.614.1647597137954;
        Fri, 18 Mar 2022 02:52:17 -0700 (PDT)
Received: from [192.168.1.10] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id d23-20020aa7d5d7000000b00418f7b2f1dbsm2402319eds.71.2022.03.18.02.52.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Mar 2022 02:52:17 -0700 (PDT)
Message-ID: <eae0e1d8-ef40-b2eb-b08a-e233a4183373@gmail.com>
Date:   Fri, 18 Mar 2022 11:52:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH 3/3] trace-cruncher: perf example
Content-Language: en-US
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        acme@kernel.org, olsajiri@gmail.com, irogers@google.com
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org,
        linux-perf-users@vger.kernel.org
References: <20220224163711.185308-1-tz.stoyanov@gmail.com>
 <20220224163711.185308-4-tz.stoyanov@gmail.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20220224163711.185308-4-tz.stoyanov@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Ceco,

Thanks a lot!

I really like the idea of have a perf sub-module in trace-cruncher and I think your RFC patch-set is a great starting point.

Let's start with some discussion of the structure of the APIs that this module has to contain. See my comment bellow.

On 24.02.22 г. 18:37 ч., Tzvetomir Stoyanov (VMware) wrote:
> Example python program for using trace-cruncher to collect performance
> statistics of a given process.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>   examples/perf_sampling.py | 51 +++++++++++++++++++++++++++++++++++++++
>   1 file changed, 51 insertions(+)
>   create mode 100755 examples/perf_sampling.py
> 
> diff --git a/examples/perf_sampling.py b/examples/perf_sampling.py
> new file mode 100755
> index 0000000..1b57f39
> --- /dev/null
> +++ b/examples/perf_sampling.py
> @@ -0,0 +1,51 @@
> +#!/usr/bin/env python3
> +
> +"""
> +SPDX-License-Identifier: CC-BY-4.0
> +
> +Copyright 2022 VMware Inc, Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> +"""
> +
> +import sys
> +import time
> +import signal
> +
> +import tracecruncher.perfpy as perf
> +
> +def SortKey(sample):
> +    return sample.time()
> +
> +def perf_stop(sig, frame):
> +    # Stop collection of performance traces
> +    p.stop()
> +
> +if __name__ == "__main__":
> +    if len(sys.argv) < 2:
> +        print('Usage: ', sys.argv[0], ' [PROCESS]')
> +        sys.exit(1)
> +
> +    # Create perf sample object for the given process
> +    p = perf.sample(pid=int(sys.argv[1]), freq=99)

If you initiate the sampling using the PID of the process, you are limited to tracing only processes that are already 
running. Hence, there will be no way to trace the very beginning of the process you are interested in. Let's keep the 
current way of initializing (via PID), but make it optional and have a second option that will be to provide a process 
name and arguments to be started internally (using fork–>exec).

Also we need a better name for this API. Something that is more coherent with the naming of the equivalent ftracepy APIs.

> +    signal.signal(signal.SIGINT, perf_stop)

I would prefer to have the signal handling done internally inside the C code and do not bother the Python user with this.

> +    print('Start collecting performance data, press ctrl+c  to stop')
> +    # Start collecting performance traces
> +    p.start()

I wonder what is the reason for having the constructor of the perf instance above and 'start()' as separate APIs? Do you 
have in mind some use case in which we have to create the instance, do something important and only then start()?

Also in the current implementation, the only way to stop the sampling is 'ctrl+c'. You have the 'stop()' API but the 
user has no way of really calling it, since the execution is blocked inside 'start()' which will never return if the 
sampling is running.

But if the sampling runs on its own (started using fork->exec) then the stop() API will be indeed useful. Note that in 
this case you will have to also provide 'destroy' method for the 'perf' object, because we have to guaranty that the 
sampling will stop when the execution of the user script exits.

cheers,
Yordan

> +    # wait for ctrl+c
> +    signal.pause()
> +    # Get collected samples
> +    samples = p.get_samples()
> +    # Sort the list based on the timestamp
> +    samples.sort(key=SortKey)
> +    time = 0
> +    ip_count = 0
> +    for s in samples:
> +        # Print PID, TID, time and trace depth of each sample
> +        if time == 0:
> +            time = s.time()
> +        print("{0} {1} ({2}), +{3}:".format(s.ip(), s.tid(), s.tid_comm(), s.time() - time))
> +        ips = s.stack()
> +        ip_count += len(ips)
> +        for ip in reversed(ips):
> +            # Print stack trace of the sample
> +            print("\t{0}".format(ip))
> +    print("\nCollected {0} samples, {1} ip traces".format(len(samples), ip_count))
> \ No newline at end of file

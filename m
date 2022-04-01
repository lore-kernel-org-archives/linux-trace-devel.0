Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E4CEC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Apr 2022 09:41:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245027AbiDAJn3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 1 Apr 2022 05:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244801AbiDAJn2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 1 Apr 2022 05:43:28 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 958DE66F86
        for <linux-trace-devel@vger.kernel.org>; Fri,  1 Apr 2022 02:41:39 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id j18so3391599wrd.6
        for <linux-trace-devel@vger.kernel.org>; Fri, 01 Apr 2022 02:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=5ISI3P2qcR/OBkZB0owxHZHUwQSw9APEatqon7pWFfo=;
        b=UYQCmaXOIg/DwRNDdwNov2Ss6fhjTEncQ8gogzqhgqJV6gMGn/vVJVdNas3IbZ032D
         6pxBrhZZQBiRvm1YiyzQnpALw55HpghqXBrAFo6WGWxMZ/MMox9O5MOMq5Y6RTRY43WE
         b3izAzSs4/Na5Q9YJU2FS6Yk8tIFHx1y2zHcv3dWvs7ynsJZ5h6dN5kxNQI9NhTxg4cO
         FD5jtV8XnFGSsL4G6UBgBUULi2ZaPpsdQv0DjvnS+lSNuV0DX9zueRETKfxONUENdamq
         9GAjk4jtc5iu2FjmsC685u4Zcbkpt62YxTSExatSRbYQZ8ZT6zHgAj5cYdYO6wyvNlzS
         xQIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5ISI3P2qcR/OBkZB0owxHZHUwQSw9APEatqon7pWFfo=;
        b=CvlKc6Bc3lUGI0YOoLYNNS7sIi584eGdIq8YAWRUE3Gi5MQvZM6Ya5XDkcjbBC3VaL
         v+dGxY1qw0Km1sWb97DZIDNRRyoNBKwpkxJ8grCa17CE6D0zEdiwc6rkYQKmTSIGTYuP
         t2LOqByaMBIyxJeI/8+1Zt7H0oaRgp1TOQPFr3Y4NQtEhPN7NQ7jiwae3nzwLm02y5gP
         +cM2YUmQyoUNrTWRtvSPHwMVgYgHFqPEtmBB66YHldyCRIqGVcf1GdDGJ7c8xUldtwfi
         yKUn11wRqkWEI0xBaq3rkBncwvOKTnbF3cTpdFQZhfZAjQlgvm1o2CzegwtAB36mQ1jd
         Xf0Q==
X-Gm-Message-State: AOAM530LmW+89FiEUu3Lig+FYQLOurfVzMDPrRtf5DhXHId4vE6S6mNN
        qM92rXhRloRraTwAUgpMND4=
X-Google-Smtp-Source: ABdhPJzSlbVz5Bk+gy/E4PUCHZHuOjcF5Xc4HSA7xF4mh6lmCsbftFayF6j3nBZ2V58C9wsTPFZGNg==
X-Received: by 2002:a5d:64eb:0:b0:205:d418:4798 with SMTP id g11-20020a5d64eb000000b00205d4184798mr7167745wri.11.1648806098139;
        Fri, 01 Apr 2022 02:41:38 -0700 (PDT)
Received: from [10.107.106.54] (78-154-13-168.ip.btc-net.bg. [78.154.13.168])
        by smtp.gmail.com with ESMTPSA id f13-20020a05600c4e8d00b0038c949ef0d5sm1621819wmq.8.2022.04.01.02.41.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Apr 2022 02:41:37 -0700 (PDT)
Message-ID: <779a7856-5271-5ad5-4341-9ac374bd827a@gmail.com>
Date:   Fri, 1 Apr 2022 12:41:36 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH 4/4] trace-cruncher: Example script for uprobes high
 level API
Content-Language: en-US
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
References: <20220331095533.75289-1-tz.stoyanov@gmail.com>
 <20220331095533.75289-5-tz.stoyanov@gmail.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20220331095533.75289-5-tz.stoyanov@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 31.03.22 г. 12:55 ч., Tzvetomir Stoyanov (VMware) wrote:
> Proposed example illustrates how to use uprobes high level API to trace
> all functions for user program. It can be attached to already running
> program, or run the program and trace its execution.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>   examples/user_trace.py | 41 +++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 41 insertions(+)
>   create mode 100755 examples/user_trace.py
> 
> diff --git a/examples/user_trace.py b/examples/user_trace.py
> new file mode 100755
> index 0000000..0d3adcd
> --- /dev/null
> +++ b/examples/user_trace.py
> @@ -0,0 +1,41 @@
> +#!/usr/bin/env python3
> +
> +"""
> +SPDX-License-Identifier: CC-BY-4.0
> +
> +Copyright 2022 VMware Inc, Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> +"""
> +
> +import sys
> +
> +import tracecruncher.ftracepy as ft
> +
> +if __name__ == "__main__":
> +    if len(sys.argv) < 2:
> +        print('Usage: ', sys.argv[0], ' [PROCESS]')
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
> +        utrace = ft.user_trace(name=sys.argv[1], follow_libs=False)
> +
> +    # Trace execution of all available functions in the given process
> +    utrace.add_function(fname = "*")
> +
> +    # Add trace points on functions return as well
> +    utrace.add_ret_function(fname = "*")
> +
> +    # Start tracing in an instance
> +    utrace.start(instance = inst)
> +
> +    # Read the trace buffer during the trace until ctrl-c is pressed
> +    ft.read_trace(instance=inst)
> +
> +    # Disable the tracing
> +    utrace.stop(instance = inst)

The "stop" must be performed by the 'destroy' method of utrace object.
And 'destroy' must be called automatically at exit.

Thanks!
Yordan

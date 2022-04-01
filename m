Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB88EC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Apr 2022 09:43:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244595AbiDAJp0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 1 Apr 2022 05:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242229AbiDAJpX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 1 Apr 2022 05:45:23 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E2211BCD7
        for <linux-trace-devel@vger.kernel.org>; Fri,  1 Apr 2022 02:43:30 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id l7-20020a05600c1d0700b0038c99618859so3160282wms.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 01 Apr 2022 02:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=IkMUFsFtk4xBzaPkQUHGCesRkQpHuVtpHzApcOh5lsI=;
        b=jP2m1tSOo8MorkBu+nDi9SRQj6k20o86W6eIHIGZWY2KkSdl1jR3LV1eZdnoLTCS6S
         6IVuj6+Z8u7Nvu7XkwLplJ7YiyWtKEZOW2+ie7sri3YtV8wqPR5GsAs/tvPKn/0V9eL7
         16bJyot+BlI/tp4bQ34Z6kzSspBXNj5OLSRIm19QVPKAk5+KYDJFyC9APBQ0Tg70W+yH
         2HA8196qEC+39gDO4p5wI4NnOEHLACYwtnTkg0VAXoe5I/rjl2Q6sXVqjwtQ4mGmIL/U
         vCSIovnNWg9I8DQpbgQGml0d/CtfbbVsF7g8ooyr6BvI49WQWVMNDiX8mE8Ab26XXoWP
         VWvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=IkMUFsFtk4xBzaPkQUHGCesRkQpHuVtpHzApcOh5lsI=;
        b=Kulb6Ekm+D9YtKYcAmXaTsEnKX2TfjaZuRZcJ9849Sja5X7rIBk1BmxV928MX/Vm99
         wkRm7qkFXCRfuVByBwTBNnJM/WMUcMDh7AWEZf9HWfi3hoghx6XXd5QJb6bQKw/33XY/
         FVXuC5YzI7ukqL7P2n6JwSRzRONvmBByS0f+tHYtBNYr+D/tYH29hNpvXah6zH0rq1u6
         BJ5xYVS8pOQKSkGD9caRHOsGod4BQKGZhEZndjuMDx2iQWo/nljoW0YrkHyqYUQ6hZs1
         PGSrFPOURfsh345OtQcftF0ct8c4Q962tfBDpIfiArh/QWS81JE38QmT4EvHyzyVPLvX
         ZZdQ==
X-Gm-Message-State: AOAM530eZKfXPbvFiAcPBlr4DqMi8f36yjf0hiIYlHnGSqSwTJk44gu+
        U5WjQrysA6ZFLNTNq9nT63c=
X-Google-Smtp-Source: ABdhPJxOypEm0SydvMybYtFnUoylWAYmi8C/8YY6ymkBYoZO+CIQIDkNXhAXmyxgfyoWy33/Uh6itg==
X-Received: by 2002:a05:600c:204:b0:38d:bad:7552 with SMTP id 4-20020a05600c020400b0038d0bad7552mr8087535wmi.133.1648806209537;
        Fri, 01 Apr 2022 02:43:29 -0700 (PDT)
Received: from [10.107.106.54] (78-154-13-168.ip.btc-net.bg. [78.154.13.168])
        by smtp.gmail.com with ESMTPSA id 7-20020a05600c028700b0038cc9bfe6a4sm1363135wmk.37.2022.04.01.02.43.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Apr 2022 02:43:29 -0700 (PDT)
Message-ID: <1d5ebae8-6040-7b04-7212-6a1e74d49665@gmail.com>
Date:   Fri, 1 Apr 2022 12:43:28 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH 4/4] trace-cruncher: Example script for uprobes high
 level API
Content-Language: en-US
From:   Yordan Karadzhov <y.karadz@gmail.com>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
References: <20220331095533.75289-1-tz.stoyanov@gmail.com>
 <20220331095533.75289-5-tz.stoyanov@gmail.com>
 <779a7856-5271-5ad5-4341-9ac374bd827a@gmail.com>
In-Reply-To: <779a7856-5271-5ad5-4341-9ac374bd827a@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

I am now starting to review patch 1. This will most probably take some time.
Y.

On 1.04.22 г. 12:41 ч., Yordan Karadzhov wrote:
> 
> 
> On 31.03.22 г. 12:55 ч., Tzvetomir Stoyanov (VMware) wrote:
>> Proposed example illustrates how to use uprobes high level API to trace
>> all functions for user program. It can be attached to already running
>> program, or run the program and trace its execution.
>>
>> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
>> ---
>>   examples/user_trace.py | 41 +++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 41 insertions(+)
>>   create mode 100755 examples/user_trace.py
>>
>> diff --git a/examples/user_trace.py b/examples/user_trace.py
>> new file mode 100755
>> index 0000000..0d3adcd
>> --- /dev/null
>> +++ b/examples/user_trace.py
>> @@ -0,0 +1,41 @@
>> +#!/usr/bin/env python3
>> +
>> +"""
>> +SPDX-License-Identifier: CC-BY-4.0
>> +
>> +Copyright 2022 VMware Inc, Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
>> +"""
>> +
>> +import sys
>> +
>> +import tracecruncher.ftracepy as ft
>> +
>> +if __name__ == "__main__":
>> +    if len(sys.argv) < 2:
>> +        print('Usage: ', sys.argv[0], ' [PROCESS]')
>> +        sys.exit(1)
>> +
>> +    # Create new Ftrace instance to work in. The tracing in this new instance
>> +    # is not going to be enabled yet.
>> +    inst = ft.create_instance(tracing_on=False)
>> +
>> +    # Create a user tracing context for given process, exclude the libraries
>> +    if sys.argv[1].isdigit():
>> +        utrace = ft.user_trace(pid=int(sys.argv[1]), follow_libs=False)
>> +    else:
>> +        utrace = ft.user_trace(name=sys.argv[1], follow_libs=False)
>> +
>> +    # Trace execution of all available functions in the given process
>> +    utrace.add_function(fname = "*")
>> +
>> +    # Add trace points on functions return as well
>> +    utrace.add_ret_function(fname = "*")
>> +
>> +    # Start tracing in an instance
>> +    utrace.start(instance = inst)
>> +
>> +    # Read the trace buffer during the trace until ctrl-c is pressed
>> +    ft.read_trace(instance=inst)
>> +
>> +    # Disable the tracing
>> +    utrace.stop(instance = inst)
> 
> The "stop" must be performed by the 'destroy' method of utrace object.
> And 'destroy' must be called automatically at exit.
> 
> Thanks!
> Yordan

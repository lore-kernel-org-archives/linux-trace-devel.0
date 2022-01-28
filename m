Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDE3FC433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 28 Jan 2022 09:26:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243611AbiA1J0L (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 28 Jan 2022 04:26:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237840AbiA1J0J (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 28 Jan 2022 04:26:09 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C5A8C061714
        for <linux-trace-devel@vger.kernel.org>; Fri, 28 Jan 2022 01:26:09 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id l25so9589742wrb.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 28 Jan 2022 01:26:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=22NynwXENk4rQVMYVGxdYwjLOgmgkcjW9VOkFztKQg4=;
        b=OpA/TZP98Y+8vKWlN7fnWwxUmgUlH8Zxg+lTQtUzx92+yBo9+0nCeMJwHmQv8RWFiW
         lipc5jqWKvQ5ZHlLwjbRkwJr1XJSanWWX6Q03YGfA6n9Wo4pDwg1USrEF5Lna8juKoKx
         4JWN3CP0oEqWBaHWTQD+ioZsSH8TdiAoCTO2jjnsNSezhzcpKCDaAvhbwYSPD/8UNtjQ
         9E60KuJJD4/3uSNFHG+YplG6lbkeVh2XQypgqXSJ7GtwJl+9+oZ5mKMQOpUbkSIAxls7
         pQSmY9J9hVN40qdTIrgXdoXSHBUqzRfmc2XAHnm+4iPbA41f3StxpviRlAGyXrPihLgv
         1I1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=22NynwXENk4rQVMYVGxdYwjLOgmgkcjW9VOkFztKQg4=;
        b=vT7lYiV2GjRUvdeVSf+RmCk9+WnHxcWy5EYOg3TOPN3cy7OPJPWfJ8/vtYJTPXH/aC
         su2/7mMrbmxFo1F7uaT28FPVONTzpDfj6V7q5MNElsQGbs4IeRTaSHDfeUVbqDsjC5tn
         QKGtUbFbzZpXLBBapJa5jZJKIJgMWer/wa/fFpHlcepSGZ1b0Mbx+MPZge98ORAl/X45
         cddhn0ldkzUTC67iVlHH/q0BP81YIMMxIVEBKJR7AJS5FDFXw2dFSQV6+BNyT/W+DFxn
         TyK7d9NiAvVdpByA0US4S9F7WpNrXRtNfX1bOJAR1PxmctCCvHodcNef7btyd17wGL3w
         FxWw==
X-Gm-Message-State: AOAM532/kPe0aJSIrEpK19+l7tLRbOMYM2oiLSs4N7v/B5aYbd69yR8w
        haNIiucnouELneuVq25BWCY=
X-Google-Smtp-Source: ABdhPJx8hvG3EMSU5tsE7jU+UnO2jAZrjyNFPZ8LPfQEsCrkz+Dof4TEy6IWtqS6clu5qNSqlVReEA==
X-Received: by 2002:a5d:6f13:: with SMTP id ay19mr6432159wrb.142.1643361967923;
        Fri, 28 Jan 2022 01:26:07 -0800 (PST)
Received: from [192.168.1.9] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id i9sm5104770wry.32.2022.01.28.01.26.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Jan 2022 01:26:07 -0800 (PST)
Message-ID: <082911df-b218-94f7-8d56-e09faec122b2@gmail.com>
Date:   Fri, 28 Jan 2022 11:26:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH] trace-cruncher: Update CONTRIBUTING doc with tests
Content-Language: en-US
From:   Yordan Karadzhov <y.karadz@gmail.com>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
References: <20220127061653.23426-1-tz.stoyanov@gmail.com>
 <406f05fb-c462-d930-b71e-35d5c77ebe32@gmail.com>
In-Reply-To: <406f05fb-c462-d930-b71e-35d5c77ebe32@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Applied.

Thanks Ceco!
Yordan


On 27.01.22 г. 12:55 ч., Yordan Karadzhov wrote:
> 
> 
> On 27.01.22 г. 8:16 ч., Tzvetomir Stoyanov (VMware) wrote:
>> All trace-cruncher code should be covered by the unit tests. Added
>> instructions how to run the tests in CONTRIBUTING document.
>>
>> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
>> ---
>>   CONTRIBUTING.md | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/CONTRIBUTING.md b/CONTRIBUTING.md
>> index 1f73807..7f6c5af 100644
>> --- a/CONTRIBUTING.md
>> +++ b/CONTRIBUTING.md
>> @@ -20,6 +20,11 @@ The preferred coding style for the project is the [Linux kernel coding style](ht
>>   The project follows the conventions for [submitting 
>> patches](https://www.kernel.org/doc/html/v5.4/process/submitting-patches.html)
>>   as described by the Linux kernel.
>> +### Tests
>> +
>> +Make sure that all your changes are covered by the tests. Before submitting your patch, make sure everything works at 
>> 100% running the tests in **tracecruncher/tests**. As trace-cruncher interacts with the Linux kernel tracing 
>> infrastructure, the tests must be run with root privileges:
> 
> Thanks a lot for spotting this insufficiency in the documentation. However let's make it even better.
> First of all, we need to add an empty line here in order to have the command showing up on a new line on github.
> 
> And second, note that if you run this in the trunck of the repository this is not going to work. First you have to do
> cd tracecruncher/tests
> 
> Also it is good to mention that before testing your modifications you have to make sure the modified module is 
> installed. (sudo make install)
> 
> Thanks!
> Yordan
> 
> 
>> +`sudo python3 -m unittest discover .`
>> +
>>   ## Reporting Bugs and Creating Issues
>>   For bug reports and issues, please file it 
>> [bugzilla](https://bugzilla.kernel.org/buglist.cgi?component=Trace-cmd%2FKernelshark&product=Tools&resolution=---)
>>

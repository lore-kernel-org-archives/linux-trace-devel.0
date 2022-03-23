Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91D4FC433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Mar 2022 07:37:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242281AbiCWHig (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Mar 2022 03:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242283AbiCWHif (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Mar 2022 03:38:35 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE6D74630
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Mar 2022 00:37:06 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id b19so784887wrh.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Mar 2022 00:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=IiMBdv1GMv0IvVvJKi/MrHO20EuC4pB849ltaYJDK+k=;
        b=OAbr+tP4CR/z3A9EA4arW3Xf2i8fMGv6rKLgVc2TYusmmEbsRcNOAM4yd8o95F7VmX
         Cvkz6TiCZca4iySYVyVcfs5bI96Op1cXmym8Drr1WcieRzreBD0rGpu9fexzqVdFrX4V
         l8tRuIRRghO4j3hUl1+1MpcAk5ADFav1OxzZkP2BTQXCwJxh2yHxvF/EZ0naV6zRbMuA
         JhyG8S0ysdZ42+q36cZuPlyEPl61pSi7I8m4IBlhpl/DLBrMmzwgz+j/r/XDGBjpo6L4
         GD0zMR+WuXzuIw+JEwKBSEWZRF8C8Q1UQ/Z8Ga91FIeb08VAFNhO2zlHUSt3fRP3Tpbb
         tQRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IiMBdv1GMv0IvVvJKi/MrHO20EuC4pB849ltaYJDK+k=;
        b=uRjUexLO+rD4EKKjwD/1hGEBboIwYRl1mbR2fSClg+Nz/0ltASqBNcnfh2ALwmMLLN
         RVgdeZnP8a2McsqheTZDu4xel6t/aqTCi5oPVy9p6sXwi7xUq2zKFxLPBArBAtfvymkG
         EkDV6Q+9GYr/vEyHKpZSrph3wuAnxKkW+MEs4hE0NNNX8cVXJXneRU2WQSwzUMSzd+AZ
         uVjtFEplw88KbRy2P33BfGGgvAQXJe99kRcVEAiMUpU4SrJNUdAoNS8hO4IKIF0QpTUw
         b3lxl5NCAZsskhHdRaBhhLbhDHSPKOFqaJaj/HfGaKAvhfXxZtJUjHtnqg5oNJ2UcV5l
         5uiA==
X-Gm-Message-State: AOAM532vqp6AaTXMn0eGqTXgT1j9b7nF0ST1nhfuFElIVSN44IiEWR3H
        02gH+Qpk7GNb8L8/MEdCgd4Y5bClpd8=
X-Google-Smtp-Source: ABdhPJxNebgM1TkbBqfxqxSmY7Mc/AQVTyo+ZqZMXSDaPjNDihTOU/AkDTL7YZqVNGpfrsSwt+5VaA==
X-Received: by 2002:a5d:6d83:0:b0:204:107d:ffe2 with SMTP id l3-20020a5d6d83000000b00204107dffe2mr11740941wrs.413.1648021024917;
        Wed, 23 Mar 2022 00:37:04 -0700 (PDT)
Received: from [10.107.106.54] (78-154-13-168.ip.btc-net.bg. [78.154.13.168])
        by smtp.gmail.com with ESMTPSA id c24-20020a7bc018000000b0038a18068cf5sm3294449wmb.15.2022.03.23.00.37.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Mar 2022 00:37:04 -0700 (PDT)
Message-ID: <d18dda1e-8578-1511-144e-df8885f1d8fe@gmail.com>
Date:   Wed, 23 Mar 2022 09:37:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] kernelshark: Set QApplication::desktopFileName
Content-Language: en-US
To:     Nicolas Fella <nicolas.fella@gmx.de>,
        linux-trace-devel@vger.kernel.org
References: <20220321225330.825082-1-nicolas.fella@gmx.de>
 <113dd55a-1324-c3a7-7663-2e206e069a38@gmail.com>
 <4ea9e4a6-c15f-5c5c-a36e-2ed80c1ee0da@gmx.de>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <4ea9e4a6-c15f-5c5c-a36e-2ed80c1ee0da@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 22.03.22 г. 13:53 ч., Nicolas Fella wrote:
> On 3/22/22 12:32, Yordan Karadzhov wrote:
>>
>>
>> On 22.03.22 г. 0:53 ч., Nicolas Fella wrote:
>>> This is needed for properly associating the window with the desktop
>>> file.
>>>
>>> This is needed for e.g. showing the correct icon in desktop
>>> environments.
>>>
>>> Signed-off-by: Nicolas Fella <nicolas.fella@gmx.de>
>>> ---
>>>   src/kernelshark.cpp | 1 +
>>>   1 file changed, 1 insertion(+)
>>>
>>> diff --git a/src/kernelshark.cpp b/src/kernelshark.cpp
>>> index 92bc1f1..c373f54 100644
>>> --- a/src/kernelshark.cpp
>>> +++ b/src/kernelshark.cpp
>>> @@ -56,6 +56,7 @@ int main(int argc, char **argv)
>>>       int c;
>>>
>>>       QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
>>> +    QApplication::setDesktopFileName("kernelshark");
>>
>> Hi Nicolas,
>>
>> Looking into the Qt documentation, it seems to me that the argument
>> must be the desktop file name without the full path. And the name of
>> the file is 'kernelshark.desktop'.
> 
> Hi,
> 
> the .desktop extension is implicit/not needed here. The documentation
> says "the _base_ name of the desktop entry for this application"
> (emphasis is mine).
> 

Hi Nicolas,
Thanks a lot for clarifying this!

I will take the patch, but I want to ask you to do one minor improvement first. I do not like that the name of the 
desktop file is hard-coded. It will be better if we can get it directly from the CMAKE build. You will have to add a 
#cmakedefine for KS_APP_NAME in  build/deff.h.cmake and then used this when calling setDesktopFileName().

cheers,
Yordan


> Cheers
> 
> Nicolas
> 
>>
>> Thanks!
>> Yordan
>>
>>>       QApplication a(argc, argv);
>>>
>>>       KsMainWindow ks;
>>> -- 
>>> 2.35.1
>>>

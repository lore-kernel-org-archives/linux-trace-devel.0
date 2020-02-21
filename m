Return-Path: <SRS0=rBiU=4J=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB553C35646
	for <linux-trace-devel@archiver.kernel.org>; Fri, 21 Feb 2020 11:57:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF4C92071E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 21 Feb 2020 11:57:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="COF0YBVW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728402AbgBUL5B (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 21 Feb 2020 06:57:01 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41342 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728306AbgBUL5A (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 21 Feb 2020 06:57:00 -0500
Received: by mail-pg1-f193.google.com with SMTP id 70so866652pgf.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 21 Feb 2020 03:56:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gYb6Jf04b9Y5wD9QeRe3FelAsAsSadPqemi8N6UFwYc=;
        b=COF0YBVWRySl1s0wE6GrqR5uQFPiuzfA5WkzES52Oxme90GyYGkp9jnxfZ47j0b4JU
         9NrFfQJ8YHIbLS0t5bEmMXmHETULsG5rh0Jx7Be9JrniIBzDSPRb4R7CLlXBZ4ZaXiit
         SBR5VVkMkfpWXoz7U/dh6SvoUZs2f67VB3OCDEz66Qcw3etVcPyKN4Q4E8JyvyHc+otx
         fUL3UEIh+MDyxd+vfyOBUk+ZKc7XJUE/oiFNnRcgJPYNQOuDUF8ztGPKUYNTUfVOyz0q
         a7Gx/uKS74zlkvePTeEfQ5KsjxadbYrX/ExCtSJuG5RERCEyvef1Hk5c/ldrcj+Ic5I5
         +ZPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gYb6Jf04b9Y5wD9QeRe3FelAsAsSadPqemi8N6UFwYc=;
        b=Q6DjVnetoBHDzd78TW75Sd8+O5/74IS54tsrbmAU3mNYqY21hsTlYdfA/oeMoffyKP
         DXv7vMU+eCM4bgoFVDD4X6NfUr5gd4Ycsr0/r+StCkrWeGGIl4Ti6hTcD5Fh0U7aaSfr
         375TSCiE9DoW73EhKuH9lRV0QGLokOEM7mGgbsPu4Cv7N/U2HWVE8wIb6F+92+2/67at
         04BRr4TsTdogZX+ET9Bi1NftSVIqDChZL8gXyoMPkUoiFxnUFRYS6H+PNqE9qgKD3GpZ
         eD8IEcIh+VaTXBdPq7451mFBUC5QvF59oh65nSq3BtH1Pxx/Hpe6BkJbTBQH5rSLLLwS
         XumA==
X-Gm-Message-State: APjAAAV6l8hEJJKLF8hcLP6B7wCEuuuidOQrce0kXoeIHd9837FeYuVL
        GueFJdzkV7okT/nevj61WxSR22ehdE8=
X-Google-Smtp-Source: APXvYqy9ckvsFqRRHnVgEfOPuUHRdOUX1LWfIQYGUB30VCtMinbPEk5OAQI224dER8l0avXt4851qg==
X-Received: by 2002:a62:fb07:: with SMTP id x7mr37425398pfm.125.1582286219214;
        Fri, 21 Feb 2020 03:56:59 -0800 (PST)
Received: from i7.zsun.org ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d15sm2343963pgn.6.2020.02.21.03.56.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 03:56:58 -0800 (PST)
Subject: Re: [PATCH 1/2] KernelShark: Inherit libdir from Makefile
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     tz.stoyanov@gmail.com, rostedt@goodmis.org,
        linux-trace-devel@vger.kernel.org
References: <20200209034226.287464-1-sztsian@gmail.com>
 <20200209034226.287464-2-sztsian@gmail.com>
 <a775d872-a67e-af1a-d0fc-6c6365171c75@gmail.com>
 <6aa37828-8122-3eb6-031d-f72167951f1c@gmail.com>
 <79cdd43b-263a-e0c7-622b-b878526b5686@gmail.com>
 <e27a35fa-74e8-63cf-78c7-260abaf10e47@gmail.com>
From:   Zamir SUN <sztsian@gmail.com>
Message-ID: <81403ffe-7c5e-6a5f-a7ef-63a4f03f9cf9@gmail.com>
Date:   Fri, 21 Feb 2020 19:56:48 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <e27a35fa-74e8-63cf-78c7-260abaf10e47@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 2/21/20 6:46 PM, Yordan Karadzhov (VMware) wrote:
> 
> 
> On 17.02.20 г. 16:11 ч., Yordan Karadzhov (VMware) wrote:
>>>>> include(${KS_DIR}/build/FindTraceCmd.cmake)
>>>>>   include(${KS_DIR}/build/FindJSONC.cmake)
>>>>> @@ -34,8 +38,8 @@ if (Qt5Widgets_FOUND)
>>>>>   endif (Qt5Widgets_FOUND)
>>>>> -set(LIBRARY_OUTPUT_PATH    "${KS_DIR}/lib")
>>>>> -set(EXECUTABLE_OUTPUT_PATH "${KS_DIR}/bin")
>>>>> +set(LIBRARY_OUTPUT_PATH    "${KS_DIR}/${_LIBDIR}")
>>>>> +set(EXECUTABLE_OUTPUT_PATH "${KS_DIR}/${_INSTALL_PREFIX}/bin")
>>>>
>>>> Not sure what is your idea here, but this looks wrong to me. When 
>>>> you are building from source (just typing "make") you don't expect 
>>>> the object files and the executables to be placed outside the trunk 
>>>> of the repository(${KS_DIR}). Do not confuse building the source 
>>>> with installing (when typing "make install").
>>>
>>> In the beginning this was meant to make sure the debuginfo package is 
>>> generated within corresponding lib64 directory. However I just 
>>> compiled again and find it's not needed now.
>>>
>>>>
>>>>>   set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -Wall -pthread -fPIC")
>>>>>   set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -std=c++11 -pthread 
>>>>> -fPIC")
>>>>> @@ -54,14 +58,15 @@ if (NOT CMAKE_CXX_FLAGS_PACKAGE)
>>>>>       set(CMAKE_CXX_FLAGS_PACKAGE "-O3")
>>>>>   endif (NOT CMAKE_CXX_FLAGS_PACKAGE)
>>>>> -set(KS_PLUGIN_INSTALL_PREFIX 
>>>>> ${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/plugins/)
>>>>> +set(KS_PLUGIN_INSTALL_PREFIX ${_LIBDIR}/${KS_APP_NAME}/plugins/)
>>>>>   set(KS_ICON        KS_icon_shark.svg)
>>>>>   set(KS_ICON_FIN    KS_icon_fin.svg)
>>>>>   set(KS_LOGO        KS_logo_symbol.svg)
>>>>>   set(KS_LOGO_LABEL  KS_logo_horizontal.svg)
>>>>> -set(CMAKE_INSTALL_RPATH "${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/")
>>>>> +SET(CMAKE_INSTALL_RPATH "${_LIBDIR}/${KS_APP_NAME}/")
>>>>
>>>> Please stick to lower-case characters with all CMake commands.
>>>>
>>>
>>> Ah sorry, this is definitely a typo when converting to capital 
>>> letters in bulks.
>>>
>>> Thanks for the review. As I don't know the background beforehand, if 
>>> you think part of this patch still makes sense, I can make v2 and 
>>> drop the bits you don't need yet.
>>
> 
> Hi Ziqian,
> 
> I had a conversation with Steven about the problem and he suggested 
> another solution how to make sure that the users know the libraries are 
> not ready to be used directly yet. Just send new version of the patch 
> with the small changes I asked for. Do not change the README file. I 
> will implement what Steven suggested on top of your patch.
> 

Hi Yordan,

Sure, I'll re-send with above fixed no later than this weekend.

Thanks for the heads-up.

> Thanks!
> Yordan

-- 
Zamir SUN
Fedora user
GPG : 1D86 6D4A 49CE 4BBD 72CF FCF5 D856 6E11 F2A0 525E

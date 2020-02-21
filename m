Return-Path: <SRS0=rBiU=4J=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B441C35646
	for <linux-trace-devel@archiver.kernel.org>; Fri, 21 Feb 2020 10:46:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B3272073A
	for <linux-trace-devel@archiver.kernel.org>; Fri, 21 Feb 2020 10:46:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SUByo5dr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgBUKqV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 21 Feb 2020 05:46:21 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:41797 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbgBUKqV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 21 Feb 2020 05:46:21 -0500
Received: by mail-lj1-f196.google.com with SMTP id h23so1687288ljc.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 21 Feb 2020 02:46:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=f9A25YcmrU4fEP+Mq4FjN+UWE0BADPhM7wteMf0AxvE=;
        b=SUByo5dr7d88XQjqTcuaFrwf2L3eHhrLL6oE8rS3c+L877QvWYw4mwcjX0tdZdqyf5
         6LkXiF/I3+lYlIHfmF+jk91S61B2Z1w/8g3AI+9W8IEw3loy10obUj7aIb7cFEHwjWA8
         IsZ76PGlzyy8vVjjZMmwbkZ8WgoeGcbiNsqh+7wQ3aueeFUFeQlIoOwkPPVueOzBckwE
         PMf41sPpH9bVSr9V0bHvS5nDST/WmDw5ee+62J6tQy/kghkbRqB5pzXmUjgX6tsGBPhR
         V3Ygoxav1/kqmm4qF8C9vBEM67NWSVhCG85UCnPbFUzbTRrHLNFe+fjf80ji2B4grv8b
         e91Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f9A25YcmrU4fEP+Mq4FjN+UWE0BADPhM7wteMf0AxvE=;
        b=nIE9u87lA+0+K4RIm8cpbIVDcNqWr/Du80tgleGweTcS9hFaC5WbzNzq8YDmWDHFID
         GLHC3ilrgqlETq5YRfT6T3FkyeKvCeHc/ljoS9b6tT4gGvxYFt4oCsg+pDu3YdVSpnhp
         72pPJu0xj49UWCDE+P2hIhhIvVwuFLRsgsUIXtAHAY90LUkUQ0lleXVdagLenfQQCUq7
         8h2N2k6JGD3GwOF52p++LYudg0Z9/SlEQrt5l/HGE+605iF95sQQ8T811ECVvdpCH0lU
         /O8V9m8IbXmMYxtsCg2C5TXqeqsicWXxBfSnL6aBKIR6rNbUaKu3FlUmtkRTzqkHLeS+
         A1gA==
X-Gm-Message-State: APjAAAVPDYFONP1iNs/8VkzztWObi8lJ+4897IxYQbvjdZX4nPTWEaeJ
        fG9d7rGJ112E01iIL2Qyw1TL9zvI
X-Google-Smtp-Source: APXvYqzT0ImG2txXuQ+/7/EofoU8Uw9NC08korFoSZZy4KtUuHO4NvAJX5iiZFjrBwC5KPn3LY0v9w==
X-Received: by 2002:a2e:8591:: with SMTP id b17mr21602980lji.249.1582281977535;
        Fri, 21 Feb 2020 02:46:17 -0800 (PST)
Received: from [10.27.112.58] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id w29sm1590729ljd.99.2020.02.21.02.46.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 02:46:17 -0800 (PST)
Subject: Re: [PATCH 1/2] KernelShark: Inherit libdir from Makefile
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     Zamir SUN <sztsian@gmail.com>
Cc:     tz.stoyanov@gmail.com, rostedt@goodmis.org,
        linux-trace-devel@vger.kernel.org
References: <20200209034226.287464-1-sztsian@gmail.com>
 <20200209034226.287464-2-sztsian@gmail.com>
 <a775d872-a67e-af1a-d0fc-6c6365171c75@gmail.com>
 <6aa37828-8122-3eb6-031d-f72167951f1c@gmail.com>
 <79cdd43b-263a-e0c7-622b-b878526b5686@gmail.com>
Message-ID: <e27a35fa-74e8-63cf-78c7-260abaf10e47@gmail.com>
Date:   Fri, 21 Feb 2020 12:46:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <79cdd43b-263a-e0c7-622b-b878526b5686@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 17.02.20 г. 16:11 ч., Yordan Karadzhov (VMware) wrote:
>>>> include(${KS_DIR}/build/FindTraceCmd.cmake)
>>>>   include(${KS_DIR}/build/FindJSONC.cmake)
>>>> @@ -34,8 +38,8 @@ if (Qt5Widgets_FOUND)
>>>>   endif (Qt5Widgets_FOUND)
>>>> -set(LIBRARY_OUTPUT_PATH    "${KS_DIR}/lib")
>>>> -set(EXECUTABLE_OUTPUT_PATH "${KS_DIR}/bin")
>>>> +set(LIBRARY_OUTPUT_PATH    "${KS_DIR}/${_LIBDIR}")
>>>> +set(EXECUTABLE_OUTPUT_PATH "${KS_DIR}/${_INSTALL_PREFIX}/bin")
>>>
>>> Not sure what is your idea here, but this looks wrong to me. When you 
>>> are building from source (just typing "make") you don't expect the 
>>> object files and the executables to be placed outside the trunk of 
>>> the repository(${KS_DIR}). Do not confuse building the source with 
>>> installing (when typing "make install").
>>
>> In the beginning this was meant to make sure the debuginfo package is 
>> generated within corresponding lib64 directory. However I just 
>> compiled again and find it's not needed now.
>>
>>>
>>>>   set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -Wall -pthread -fPIC")
>>>>   set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -std=c++11 -pthread 
>>>> -fPIC")
>>>> @@ -54,14 +58,15 @@ if (NOT CMAKE_CXX_FLAGS_PACKAGE)
>>>>       set(CMAKE_CXX_FLAGS_PACKAGE "-O3")
>>>>   endif (NOT CMAKE_CXX_FLAGS_PACKAGE)
>>>> -set(KS_PLUGIN_INSTALL_PREFIX 
>>>> ${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/plugins/)
>>>> +set(KS_PLUGIN_INSTALL_PREFIX ${_LIBDIR}/${KS_APP_NAME}/plugins/)
>>>>   set(KS_ICON        KS_icon_shark.svg)
>>>>   set(KS_ICON_FIN    KS_icon_fin.svg)
>>>>   set(KS_LOGO        KS_logo_symbol.svg)
>>>>   set(KS_LOGO_LABEL  KS_logo_horizontal.svg)
>>>> -set(CMAKE_INSTALL_RPATH "${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/")
>>>> +SET(CMAKE_INSTALL_RPATH "${_LIBDIR}/${KS_APP_NAME}/")
>>>
>>> Please stick to lower-case characters with all CMake commands.
>>>
>>
>> Ah sorry, this is definitely a typo when converting to capital letters 
>> in bulks.
>>
>> Thanks for the review. As I don't know the background beforehand, if 
>> you think part of this patch still makes sense, I can make v2 and drop 
>> the bits you don't need yet.
> 

Hi Ziqian,

I had a conversation with Steven about the problem and he suggested 
another solution how to make sure that the users know the libraries are 
not ready to be used directly yet. Just send new version of the patch 
with the small changes I asked for. Do not change the README file. I 
will implement what Steven suggested on top of your patch.

Thanks!
Yordan

Return-Path: <SRS0=t4cO=RO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAAA2C43381
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Mar 2019 17:16:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B8F1205F4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Mar 2019 17:16:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TxB+fNGw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbfCKRQ3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 13:16:29 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44331 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726942AbfCKRQ2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 13:16:28 -0400
Received: by mail-wr1-f65.google.com with SMTP id w2so6010619wrt.11
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Mar 2019 10:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JxvneykPLSLC0iqLF6ccbkxoGg129hBw2xfHj5dK4GQ=;
        b=TxB+fNGwnG3Ksv7a3IhhW/k2mml8ulXP9qBBQcuTTt4SXMWJlyXKD+cXprihge/sW1
         oE6DCHpx2Y8KiPqhQ/Zrb5ehbKpZ/usVJ9A4ZLGjzegkm9CtnoJiVYSu20iTQZJimybK
         jppXNXck+52CYXe0HhVizOoWcm74FQVrMqKIO4FtPNIR1HaZMjdtEETFJnHHUBGUPrJv
         bPkzio0s5eIzLL5FXKwY3v18Q1rdn81RQtyfSA+0iwUc0gbwYzM3hYGlBF5xzshj/xlP
         3HJt+Zw1UJfCTp4xPyZ9tE1iH9gZkm+s6gzqjY/wGXWDNLTn73xY8T9OMGoZJpFMkjFs
         hA1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JxvneykPLSLC0iqLF6ccbkxoGg129hBw2xfHj5dK4GQ=;
        b=VSGIwWXMctv8f8k2TrwQSRE7tBHllJ5Dm86RfYu7KgU0knqi/qPi9rd1WcJJRh28Dd
         2S1jw3kJVqM5nvRyvlsPgCKNTVFBShroj/yA4vI9Zr13rRFcRqMrFRLTW3w3ojoRpXQn
         GkG+7JGsRSwDyMZu4Vy50Xf8genYf7cyPjXDLf0ApRU1dThUb1MP/ToF0jb1riWg9UAA
         YSuI5d3cgjXd/S32u4tgAacHiaimXH8mhwiuv3jXXOdVV2JeF39epn8Q6WsjouDSqanG
         hcKadO0a8KuoMxizd+05vlbGfjpC23RPSHZl2S1vTCuwaM1/NkdM9kQGN4+hURpXECHA
         5bmQ==
X-Gm-Message-State: APjAAAUK1lyhWcH37BCJMvdArQgdkupiDUnNHzL+fjZsJnNzvgOg+zZH
        t3SsRG+LgR+sFkJYRflJxg0=
X-Google-Smtp-Source: APXvYqxf+JWX4SFpw/YhXPMwMk9IKzc5Ebdhe7N8vUV8EkRHtETVULnc61LXGdgGZKNax8HKCDW2RA==
X-Received: by 2002:a5d:570a:: with SMTP id a10mr21274232wrv.85.1552324586722;
        Mon, 11 Mar 2019 10:16:26 -0700 (PDT)
Received: from [192.168.0.106] ([95.87.198.56])
        by smtp.gmail.com with ESMTPSA id d21sm22957254wrc.44.2019.03.11.10.16.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Mar 2019 10:16:26 -0700 (PDT)
Subject: Re: [PATCH 2/3] kernel-shark: Save the configuration information in
 ${HOME}/.kshark
To:     Steven Rostedt <rostedt@goodmis.org>,
        Slavomir Kaslev <slavomir.kaslev@gmail.com>
Cc:     Yordan Karadzhov <ykaradzhov@vmware.com>,
        linux-trace-devel@vger.kernel.org,
        Patrick McLean <chutzpah@gentoo.org>
References: <20190308171512.15372-1-ykaradzhov@vmware.com>
 <20190308171512.15372-3-ykaradzhov@vmware.com>
 <CAE0o1NsO5nqemTQ5v2HR9bixVKeiO9Dc8=D9-w36o7b15O9P=A@mail.gmail.com>
 <20190311113340.67260ae7@oasis.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <9b452003-efb4-0903-fed1-1a4debf84a48@gmail.com>
Date:   Mon, 11 Mar 2019 19:16:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190311113340.67260ae7@oasis.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 11.03.19 г. 17:33 ч., Steven Rostedt wrote:
> On Mon, 11 Mar 2019 14:20:23 +0200
> Slavomir Kaslev <slavomir.kaslev@gmail.com> wrote:
> 
>> On Fri, Mar 8, 2019 at 7:16 PM Yordan Karadzhov <ykaradzhov@vmware.com> wrote:
>>>
>>> By default the "Last session" configuration file will be saved in
>>> ${HOME}/.kshark
>>
>> ${HOME}/.config/foobar seems to be the standard path these days for
>> config files[1]. Wdyt about switching it to ${HOME}/.config/khark?
>>
>> [1] https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
> 
> Yeah, I was talking with Patrick McLean (who is a package maintainer
> for Gentoo) at SCaLE and was saying that we should look at .config. And
> that's the reference he pointed me to as well.
> 
> Note, we may need to use both .config and .cache, as I'm thinking
> that .cache is better for the saving of last session, and .config
> should be the default for user defined sessions (Export Session).
> 

I will rework the patch.
Thanks a lot!
Y.



> -- Steve
> 
> 
>>
>> -- Slavi
>>
>>>
>>> Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
>>> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
>>> ---
>>>   Makefile                    | 2 +-
>>>   kernel-shark/CMakeLists.txt | 5 +++--
>>>   2 files changed, 4 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/Makefile b/Makefile
>>> index b780718..967c364 100644
>>> --- a/Makefile
>>> +++ b/Makefile
>>> @@ -254,7 +254,7 @@ all_cmd: $(CMD_TARGETS)
>>>   CMAKE_COMMAND = /usr/bin/cmake
>>>
>>>   $(kshark-dir)/build/Makefile: $(kshark-dir)/CMakeLists.txt
>>> -       $(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) ..
>>> +       $(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) -DKS_CONF_DIR=$(HOME)/.kshark ..
>>>
>>>   gui: force $(CMD_TARGETS) $(kshark-dir)/build/Makefile
>>>          $(Q)$(MAKE) $(S) -C $(kshark-dir)/build
>>> diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
>>> index 20ced14..3c3beb0 100644
>>> --- a/kernel-shark/CMakeLists.txt
>>> +++ b/kernel-shark/CMakeLists.txt
>>> @@ -14,7 +14,7 @@ set(KS_DIR ${CMAKE_SOURCE_DIR})
>>>
>>>   # Make a directory to hold configuration files. To change this do:
>>>   # cmake .. -DKS_CONF_DIR=/your/preferred/path
>>> -set(KS_CONF_DIR "${KS_DIR}/.ksconf" CACHE STRING "Directory for configuration files.")
>>> +set(KS_CONF_DIR "$ENV{HOME}/.kshark" CACHE STRING "Directory for configuration files.")
>>>   file(MAKE_DIRECTORY ${KS_CONF_DIR})
>>>
>>>   include(${KS_DIR}/build/FindTraceCmd.cmake)
>>> @@ -59,7 +59,8 @@ include_directories(${KS_DIR}/src/
>>>   message("")
>>>   message(STATUS "C flags      : " ${CMAKE_C_FLAGS})
>>>   message(STATUS "CXX flags    : " ${CMAKE_CXX_FLAGS})
>>> -message(STATUS "Linker flags : " ${CMAKE_EXE_LINKER_FLAGS})
>>> +message(STATUS "Linker flags : " ${CMAKE_EXE_LINKER_FLAGS}\n)
>>> +message(STATUS "config. files saved in ${KS_CONF_DIR}")
>>>
>>>   add_subdirectory(${KS_DIR}/src)
>>>   add_subdirectory(${KS_DIR}/examples)
>>> --
>>> 2.19.1
>>>   
>>
>>
> 

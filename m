Return-Path: <SRS0=Uklz=4M=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E75EC35673
	for <linux-trace-devel@archiver.kernel.org>; Mon, 24 Feb 2020 00:06:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBDC32067D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 24 Feb 2020 00:06:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UQ2axCJZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbgBXAG4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 23 Feb 2020 19:06:56 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42440 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727159AbgBXAG4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 23 Feb 2020 19:06:56 -0500
Received: by mail-pf1-f195.google.com with SMTP id 4so4402818pfz.9
        for <linux-trace-devel@vger.kernel.org>; Sun, 23 Feb 2020 16:06:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XoLXdtP6k2MuN0+vxTVbJKf7FVT+lHXld3ZssrW+M2w=;
        b=UQ2axCJZZQS+nfv06tHVOFQnAUufewD9Oofvu4HPw4T11J+zHMEg5yaoLR6y0qUyxX
         deyXfOFFBWzWi1NhiBIWJd5uPoHQ6RGJJPKhYCFO3z3ana0umd5ByyYalQID0Y9nItb1
         7BdW6qxIkesizINalWGQoE8p9VkFgvtuIJZ0TR+81oMRSFBkDKGJhAqfzxxwSZLx5ZyB
         DNjg/cFFa4ixzXA/nKMq0qgcDq5nfOFOiuEdxoAQznnZKRG4KjSRB03dpmIr8cFpWzjz
         Gb10HWn+dAig0XbC+8WRJbbnTLBOMiRGVICxONgQCCOCaORghHQkRcJqoaPq90y15aI5
         rgZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XoLXdtP6k2MuN0+vxTVbJKf7FVT+lHXld3ZssrW+M2w=;
        b=VCR2PcBsDtiTtlcktBE/z1c0ULgtZwlbLBqMvdd9IdCsvhiPpqXqVuGs8I9SqCKY5K
         COV9P8ISkS/BqR05u/Rs3zQnAkCFqUm+WY2WtMSVI6FfpqOa15t0NXN6pX6XdtJBntkW
         SAvHGCFoDKryRmMmEdRlskYpbrj/vJMODo0phaQsvY3MFCpqNuqqPIE7BTJGFuFcTDXX
         eVO4279sg79BCKBenC5VcDxDi5vwbOKt3r1i1HFZjGTUhfgN1Pu9DJWSMs29cZm54VFh
         DdJ5LKHMSMmOft7qW28bZ+vRX9LQ/X98iamHB06fx+swKDCmZJ/BqmlTkAdxeV6tdpLZ
         z6Wg==
X-Gm-Message-State: APjAAAV4zxBEtwmstd4l8BEGecQe2ickJ7xuZOfAOFtWZKQAmHHMnTvi
        icQS157UJkvMKJGxsyys7pDHrPCvSYs=
X-Google-Smtp-Source: APXvYqyqBeFIQTwEiUkkiG+1WZlmobD7is0W20TZRUoQ/Hkwq8C+ckAYm07A7aDAr13s3VFLwEKwZA==
X-Received: by 2002:a63:f962:: with SMTP id q34mr13855648pgk.229.1582502815254;
        Sun, 23 Feb 2020 16:06:55 -0800 (PST)
Received: from i7.zsun.org ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p17sm10190094pfn.31.2020.02.23.16.06.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Feb 2020 16:06:54 -0800 (PST)
Subject: Re: [PATCH v3] KernelShark: Inherit libdir from Makefile
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     y.karadz@gmail.com, linux-trace-devel@vger.kernel.org
References: <20200221135713.323958-1-sztsian@gmail.com>
 <20200221154128.31fb6615@gandalf.local.home>
From:   Zamir SUN <sztsian@gmail.com>
Message-ID: <c843fbdc-cb5f-82c7-1f55-a1c225723672@gmail.com>
Date:   Mon, 24 Feb 2020 08:06:45 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200221154128.31fb6615@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 2/22/20 4:41 AM, Steven Rostedt wrote:
> On Fri, 21 Feb 2020 21:57:13 +0800
> sztsian@gmail.com wrote:
> 
>> From: "Ziqian SUN (Zamir)" <sztsian@gmail.com>
>>
>> The trace-cmd makefile supports install lib into a different name like
>> lib64. Now this patch implemented the same in kernel-shark.
>>
>> Change since v2: Drop the change of LIBRARY_OUTPUT_PATH as well
>>
>> Change since v1: Drop the change of EXECUTABLE_OUTPUT_PATH and fix set
>> command to lower case.
>>
> 
> Hi Ziqian,
> 
> Just FYI. When adding "Changes since", it is common practice to put
> that information below the "---" and above the diffstat. This way it's
> not picked up and added to the git commit log when using scripts to
> commit patches.
> 

Hi Steve,

Thanks for the tip. I'll put it in the right place next time.

> Thanks!
> 
> -- Steve
> 
> 
>> Signed-off-by: Ziqian SUN (Zamir) <sztsian@gmail.com>
>> ---
>>   Makefile                        | 2 +-
>>   kernel-shark/CMakeLists.txt     | 8 ++++++--
>>   kernel-shark/src/CMakeLists.txt | 6 +++---
>>   3 files changed, 10 insertions(+), 6 deletions(-)
>>
>> diff --git a/Makefile b/Makefile
>> index a3facaa..2f9620e 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -297,7 +297,7 @@ CMAKE_COMMAND = /usr/bin/cmake
>>   BUILD_TYPE ?= RelWithDebInfo
>>   
>>   $(kshark-dir)/build/Makefile: $(kshark-dir)/CMakeLists.txt
>> -	$(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) -DCMAKE_BUILD_TYPE=$(BUILD_TYPE) -D_INSTALL_PREFIX=$(prefix) ..
>> +	$(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) -DCMAKE_BUILD_TYPE=$(BUILD_TYPE) -D_INSTALL_PREFIX=$(prefix) -D_LIBDIR=$(libdir) ..
>>   
>>   gui: force $(CMD_TARGETS) $(kshark-dir)/build/Makefile
>>   	$(Q)$(MAKE) $(S) -C $(kshark-dir)/build
>> diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
>> index 8786b83..1c9ac2e 100644
>> --- a/kernel-shark/CMakeLists.txt
>> +++ b/kernel-shark/CMakeLists.txt
>> @@ -17,6 +17,10 @@ if (NOT _INSTALL_PREFIX)
>>       set(_INSTALL_PREFIX "/usr/local")
>>   endif (NOT _INSTALL_PREFIX)
>>   
>> +if (NOT _LIBDIR)
>> +    set(_LIBDIR "${_INSTALL_PREFIX}/lib")
>> +endif (NOT _LIBDIR)
>> +
>>   include(${KS_DIR}/build/FindTraceCmd.cmake)
>>   include(${KS_DIR}/build/FindJSONC.cmake)
>>   
>> @@ -54,14 +58,14 @@ if (NOT CMAKE_CXX_FLAGS_PACKAGE)
>>       set(CMAKE_CXX_FLAGS_PACKAGE "-O3")
>>   endif (NOT CMAKE_CXX_FLAGS_PACKAGE)
>>   
>> -set(KS_PLUGIN_INSTALL_PREFIX ${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/plugins/)
>> +set(KS_PLUGIN_INSTALL_PREFIX ${_LIBDIR}/${KS_APP_NAME}/plugins/)
>>   
>>   set(KS_ICON        KS_icon_shark.svg)
>>   set(KS_ICON_FIN    KS_icon_fin.svg)
>>   set(KS_LOGO        KS_logo_symbol.svg)
>>   set(KS_LOGO_LABEL  KS_logo_horizontal.svg)
>>   
>> -set(CMAKE_INSTALL_RPATH "${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/")
>> +set(CMAKE_INSTALL_RPATH "${_LIBDIR}/${KS_APP_NAME}/")
>>   
>>   if (CMAKE_BUILD_TYPE MATCHES Package)
>>   
>> diff --git a/kernel-shark/src/CMakeLists.txt b/kernel-shark/src/CMakeLists.txt
>> index 33b5db8..9666b18 100644
>> --- a/kernel-shark/src/CMakeLists.txt
>> +++ b/kernel-shark/src/CMakeLists.txt
>> @@ -15,7 +15,7 @@ target_link_libraries(kshark ${TRACEEVENT_LIBRARY}
>>   
>>   set_target_properties(kshark  PROPERTIES SUFFIX	".so.${KS_VERSION_STRING}")
>>   
>> -install(TARGETS kshark LIBRARY DESTINATION ${_INSTALL_PREFIX}/lib/${KS_APP_NAME})
>> +install(TARGETS kshark LIBRARY DESTINATION ${_LIBDIR}/${KS_APP_NAME})
>>   
>>   if (OPENGL_FOUND AND GLUT_FOUND)
>>   
>> @@ -29,7 +29,7 @@ if (OPENGL_FOUND AND GLUT_FOUND)
>>   
>>       set_target_properties(kshark-plot PROPERTIES  SUFFIX ".so.${KS_VERSION_STRING}")
>>   
>> -    install(TARGETS kshark-plot LIBRARY DESTINATION ${_INSTALL_PREFIX}/lib/${KS_APP_NAME})
>> +    install(TARGETS kshark-plot LIBRARY DESTINATION ${_LIBDIR}/${KS_APP_NAME})
>>   
>>   endif (OPENGL_FOUND AND GLUT_FOUND)
>>   
>> @@ -85,7 +85,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
>>   
>>       install(TARGETS ${KS_APP_NAME} kshark-record kshark-gui
>>               RUNTIME DESTINATION ${_INSTALL_PREFIX}/bin/
>> -            LIBRARY DESTINATION ${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/)
>> +            LIBRARY DESTINATION ${_LIBDIR}/${KS_APP_NAME}/)
>>   
>>       install(FILES "${KS_DIR}/${KS_APP_NAME}.desktop"
>>               DESTINATION ${_INSTALL_PREFIX}/share/applications/)
> 

-- 
Zamir SUN
Fedora user
GPG : 1D86 6D4A 49CE 4BBD 72CF FCF5 D856 6E11 F2A0 525E

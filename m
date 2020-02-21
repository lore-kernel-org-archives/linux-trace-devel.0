Return-Path: <SRS0=rBiU=4J=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6781C35646
	for <linux-trace-devel@archiver.kernel.org>; Fri, 21 Feb 2020 13:53:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3DF720578
	for <linux-trace-devel@archiver.kernel.org>; Fri, 21 Feb 2020 13:53:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P3+yJtjj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbgBUNxt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 21 Feb 2020 08:53:49 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35838 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727836AbgBUNxt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 21 Feb 2020 08:53:49 -0500
Received: by mail-pl1-f194.google.com with SMTP id g6so876939plt.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 21 Feb 2020 05:53:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZZE1IQNbcKVBTRQhbj354GWIxQuy/qHYGOm44JB+qPE=;
        b=P3+yJtjjWJuBXcTKJk8J09XSrw+xZaIHV7LWiR3nb6ppEwjF4dXWfxRVw7XcTQ99IV
         GVFJu4Cbkzj3AhczniT9QiDvCF0IOj8nY1MQ24QK5QLfHStGTf52U2I2u4Q5eaN4XzWW
         J2Mf6P8yY6+0awU2cFAIoFt8SuVv1GCTRqvYIBt+QJlRk5C+vljJ9KcPNRpb8xTveO1m
         Rw0CGc+s+Jd98Bla+vNT+V9NHty97/Rx85ISv0IY7tV9Dp8uDoOqJs4CrJcFwcFRO9hZ
         QYtroSSVsO/FCI0qXzEbI2HgbSc+4VQJSpz0S7NoS9Lc8b5uREhL9uzvHmJtnw48LkSH
         8mNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZZE1IQNbcKVBTRQhbj354GWIxQuy/qHYGOm44JB+qPE=;
        b=FapnGakeVmGdTb0CSnVVstokLScdas1csv6UQS1UTFesePDSmrDkKltwbfyCcJoJfR
         HwQjt7g07dYg60B3sApx5LK2j3+2AkG5GHtituTcPpdu8AcNIQnrCfuwHVtGV7Dl70uL
         OTmd89gsWIFxhRObxzXkKycwXkE1v5hjI6y8ipZzCfjbUyKHA4LMqy6cCSscCkl64yec
         RjokXhQsFQWRma9ip+iD3SsoWjw1o8zI13yBRCMEELjPdN3+O6AfBgNx1468kt5Z2h4u
         krUpBJWr4J8O60sNgUHWRXdCYHzMJq/PwQAJ2jHb7FdzK4ekCB+g5V86pn/HWA4us/8B
         deeg==
X-Gm-Message-State: APjAAAU2YEaBjN2fJ5GcD/Exl2l9t9Nrk4vTDWuPWTWI8LPK6JkA8Nge
        rwPZXmzmyCrOHQ2APpqyfUlAa5u93W4=
X-Google-Smtp-Source: APXvYqyeHtYB4T2nCG5M0B6/57v1EFKf8g6awMPCX3cLiD9iDRdvmviEhq9iUs/+b68taKEzWDs8lg==
X-Received: by 2002:a17:902:ab81:: with SMTP id f1mr37477911plr.5.1582293227961;
        Fri, 21 Feb 2020 05:53:47 -0800 (PST)
Received: from i7.zsun.org ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t186sm2670001pgd.26.2020.02.21.05.53.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 05:53:47 -0800 (PST)
Subject: Re: [PATCH v2] KernelShark: Inherit libdir from Makefile
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
References: <20200221124204.318917-1-sztsian@gmail.com>
 <da752703-3a6f-a491-55e2-7fdc7b30c205@gmail.com>
From:   Zamir SUN <sztsian@gmail.com>
Message-ID: <642e07e9-7dca-176e-a225-8d78e283a911@gmail.com>
Date:   Fri, 21 Feb 2020 21:53:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <da752703-3a6f-a491-55e2-7fdc7b30c205@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 2/21/20 9:12 PM, Yordan Karadzhov (VMware) wrote:
> Hi Zamir,
> 
> On 21.02.20 г. 14:42 ч., sztsian@gmail.com wrote:
>> From: "Ziqian SUN (Zamir)" <sztsian@gmail.com>
>>
>> The trace-cmd makefile supports install lib into a different name like
>> lib64. Now this patch implemented the same in kernel-shark.
>>
>> Change since v1: Drop the change of EXECUTABLE_OUTPUT_PATH and fix set
>> command to lower case.
>>
>> Signed-off-by: Ziqian SUN (Zamir) <sztsian@gmail.com>
>> ---
>>   Makefile                        |  2 +-
>>   kernel-shark/CMakeLists.txt     | 11 ++++++++---
>>   kernel-shark/src/CMakeLists.txt |  6 +++---
>>   3 files changed, 12 insertions(+), 7 deletions(-)
>>
>> diff --git a/Makefile b/Makefile
>> index d75f143..1aca807 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -295,7 +295,7 @@ CMAKE_COMMAND = /usr/bin/cmake
>>   BUILD_TYPE ?= RelWithDebInfo
>>   $(kshark-dir)/build/Makefile: $(kshark-dir)/CMakeLists.txt
>> -    $(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) 
>> -DCMAKE_BUILD_TYPE=$(BUILD_TYPE) -D_INSTALL_PREFIX=$(prefix) ..
>> +    $(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) 
>> -DCMAKE_BUILD_TYPE=$(BUILD_TYPE) -D_INSTALL_PREFIX=$(prefix) 
>> -D_LIBDIR=$(libdir) ..
>>   gui: force $(CMD_TARGETS) $(kshark-dir)/build/Makefile
>>       $(Q)$(MAKE) $(S) -C $(kshark-dir)/build
>> diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
>> index 8786b83..c60d29b 100644
>> --- a/kernel-shark/CMakeLists.txt
>> +++ b/kernel-shark/CMakeLists.txt
>> @@ -17,6 +17,10 @@ if (NOT _INSTALL_PREFIX)
>>       set(_INSTALL_PREFIX "/usr/local")
>>   endif (NOT _INSTALL_PREFIX)
>> +if (NOT _LIBDIR)
>> +    set(_LIBDIR "${_INSTALL_PREFIX}/lib")
>> +endif (NOT _LIBDIR)
>> +
>>   include(${KS_DIR}/build/FindTraceCmd.cmake)
>>   include(${KS_DIR}/build/FindJSONC.cmake)
>> @@ -34,7 +38,7 @@ if (Qt5Widgets_FOUND)
>>   endif (Qt5Widgets_FOUND)
>> -set(LIBRARY_OUTPUT_PATH    "${KS_DIR}/lib")
>> +set(LIBRARY_OUTPUT_PATH    "${KS_DIR}/${_LIBDIR}")
> 
> Again, I am not sure what is your idea here.
> As I already mentioned in my previous review, LIBRARY_OUTPUT_PATH (and 
> EXECUTABLE_OUTPUT_PATH) has nothing to do with the installation path of 
> the libraries. See
> https://cmake.org/cmake/help/v3.0/prop_tgt/LIBRARY_OUTPUT_DIRECTORY.html
> 
> This specifies the directory into which library target files are built.
> Not the directory into which the library files will be installed.
> 

Hi Yordan,

I was thinking you only have objections to my modification of the 
EXECUTABLE_OUTPUT_PATH. I just compiled and confirm without this line 
packaging still works as expected. I'll send out the updated one shortly.

Really sorry for make this a bit messy.

> Thanks!
> Yordan
> 
>>   set(EXECUTABLE_OUTPUT_PATH "${KS_DIR}/bin")
>>   set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -Wall -pthread -fPIC")
>> @@ -54,14 +58,15 @@ if (NOT CMAKE_CXX_FLAGS_PACKAGE)
>>       set(CMAKE_CXX_FLAGS_PACKAGE "-O3")
>>   endif (NOT CMAKE_CXX_FLAGS_PACKAGE)
>> -set(KS_PLUGIN_INSTALL_PREFIX 
>> ${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/plugins/)
>> +set(KS_PLUGIN_INSTALL_PREFIX ${_LIBDIR}/${KS_APP_NAME}/plugins/)
>>   set(KS_ICON        KS_icon_shark.svg)
>>   set(KS_ICON_FIN    KS_icon_fin.svg)
>>   set(KS_LOGO        KS_logo_symbol.svg)
>>   set(KS_LOGO_LABEL  KS_logo_horizontal.svg)
>> -set(CMAKE_INSTALL_RPATH "${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/")
>> +set(CMAKE_INSTALL_RPATH "${_LIBDIR}/${KS_APP_NAME}/")
>> +
>>   if (CMAKE_BUILD_TYPE MATCHES Package)
>> diff --git a/kernel-shark/src/CMakeLists.txt 
>> b/kernel-shark/src/CMakeLists.txt
>> index 33b5db8..9666b18 100644
>> --- a/kernel-shark/src/CMakeLists.txt
>> +++ b/kernel-shark/src/CMakeLists.txt
>> @@ -15,7 +15,7 @@ target_link_libraries(kshark ${TRACEEVENT_LIBRARY}
>>   set_target_properties(kshark  PROPERTIES SUFFIX    
>> ".so.${KS_VERSION_STRING}")
>> -install(TARGETS kshark LIBRARY DESTINATION 
>> ${_INSTALL_PREFIX}/lib/${KS_APP_NAME})
>> +install(TARGETS kshark LIBRARY DESTINATION ${_LIBDIR}/${KS_APP_NAME})
>>   if (OPENGL_FOUND AND GLUT_FOUND)
>> @@ -29,7 +29,7 @@ if (OPENGL_FOUND AND GLUT_FOUND)
>>       set_target_properties(kshark-plot PROPERTIES  SUFFIX 
>> ".so.${KS_VERSION_STRING}")
>> -    install(TARGETS kshark-plot LIBRARY DESTINATION 
>> ${_INSTALL_PREFIX}/lib/${KS_APP_NAME})
>> +    install(TARGETS kshark-plot LIBRARY DESTINATION 
>> ${_LIBDIR}/${KS_APP_NAME})
>>   endif (OPENGL_FOUND AND GLUT_FOUND)
>> @@ -85,7 +85,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
>>       install(TARGETS ${KS_APP_NAME} kshark-record kshark-gui
>>               RUNTIME DESTINATION ${_INSTALL_PREFIX}/bin/
>> -            LIBRARY DESTINATION ${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/)
>> +            LIBRARY DESTINATION ${_LIBDIR}/${KS_APP_NAME}/)
>>       install(FILES "${KS_DIR}/${KS_APP_NAME}.desktop"
>>               DESTINATION ${_INSTALL_PREFIX}/share/applications/)
>>

-- 
Zamir SUN
Fedora user
GPG : 1D86 6D4A 49CE 4BBD 72CF FCF5 D856 6E11 F2A0 525E

Return-Path: <SRS0=ULQB=4F=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED575C34021
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 Feb 2020 14:11:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCD9B208C4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 Feb 2020 14:11:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="u1QCgQfQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbgBQOLn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 Feb 2020 09:11:43 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55934 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbgBQOLn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 Feb 2020 09:11:43 -0500
Received: by mail-wm1-f68.google.com with SMTP id q9so17280330wmj.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Feb 2020 06:11:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TYL5Rer0sjo6ePsVQJufVM3ZA2AcdtF370U4tfRd5m4=;
        b=u1QCgQfQUV4kam5HyoF9ZHtE/r8PKbgpXcowuSXz/6WjFKWYFSARPR4gmzuAA1oNl/
         pPKFYKuWgXHn8Ev0eYO+CqlUV7bZKcy+Es09+uqM0HLmMtyB7WqLvhQVGmeoAkpOYcW7
         eBQcKelG1d0D1lCKEcauCDUiVhiF8LSzOUnw6wZngp1IE6usam7Jxs/274IT6VMYE5pf
         feyif/PDzD36f4RIiRVzl17c1ypHkpXyqQ6F77EivNbo7SRZ1T2PRDcGESGc0U4waS8P
         3j1+ystdGFhGg/rUOKHfSIgo4Is1m8u+gV5sKi1evPZqOkvPTOAarP/R5fJQc91DT6LD
         Cufg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TYL5Rer0sjo6ePsVQJufVM3ZA2AcdtF370U4tfRd5m4=;
        b=rHfPmhPP7Uktx/kLa3xr02Oaa4BL1KLFFkt4/bIfXAHdamKEskoXhZhWRDhojuEvBx
         BD9pVe4KTl7W56Ma9D0l7p/nFpwk1KMT7XrUAnrOca9wxmUtOAe6/KoPIL/CEs+o3IL0
         IIKEq7kfIP9yJD0Dd+fjOWwQHOjTM+m6YZYfHk/xSyAFvCbiygdGdKyx8fNRqPHiYpYg
         JJTNIUbFYOsqXWk+ThCkBlCjPlJwKSovu4X6BQC5XmkY1lMlMTBQk28cWWf5cerWLbHA
         TbWnChYcZ1k3LV/wVMu/zPxQB4pDc/U9BI5v5AvKeuWCFVEDGhk3zNEfKJ/EUuard6Rx
         F7ZQ==
X-Gm-Message-State: APjAAAULTHLNflZgXNsS5dXoIfiR0D5Sd8mrTwLnIK2lpaVN44eAtzE3
        k//BCEeVdmjwD/qvFCXHqNeYmz+Z
X-Google-Smtp-Source: APXvYqxZqiYpJZ/DkZ5TGgu3TZ2An2kBW2w0V6uDn264m2wHNVUPj6jEC3fsI7Zq5GWxbKcgnzy+ow==
X-Received: by 2002:a1c:3b0a:: with SMTP id i10mr23666408wma.177.1581948700898;
        Mon, 17 Feb 2020 06:11:40 -0800 (PST)
Received: from [10.27.112.58] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id f65sm745556wmf.29.2020.02.17.06.11.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2020 06:11:40 -0800 (PST)
Subject: Re: [PATCH 1/2] KernelShark: Inherit libdir from Makefile
To:     Zamir SUN <sztsian@gmail.com>
Cc:     tz.stoyanov@gmail.com, rostedt@goodmis.org,
        linux-trace-devel@vger.kernel.org
References: <20200209034226.287464-1-sztsian@gmail.com>
 <20200209034226.287464-2-sztsian@gmail.com>
 <a775d872-a67e-af1a-d0fc-6c6365171c75@gmail.com>
 <6aa37828-8122-3eb6-031d-f72167951f1c@gmail.com>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <79cdd43b-263a-e0c7-622b-b878526b5686@gmail.com>
Date:   Mon, 17 Feb 2020 16:11:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <6aa37828-8122-3eb6-031d-f72167951f1c@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 17.02.20 г. 15:24 ч., Zamir SUN wrote:
> 
> 
> On 2/17/20 7:26 PM, Yordan Karadzhov (VMware) wrote:
>> Hi Ziqian,
>> Thanks a lot for helping us improving the build system!
>> Sorry for the delay of my reply. I was on a ski vacation.
>>
>> Please explain us your motivation for this change. I have one general 
>> objection and couple of comments in the patch itself.
> 
> Hi Yordan,
> 
> To be a little verbose, the background of the whole patchset about 
> trying to fulfill packaging guideline of distribution.
> 
> I am the Fedora packager and recently updated trace-cmd to 2.8.3. Kernel 
> shark lives as a sub package of trace-cmd in Fedora before I start with 
> the packaging. By the time I update trace-cmd, I see some failure 
> because libraries goes to lib directory rather than lib64 on x86_64, 
> while the latter is the expected one for Fedora packages. So I have to 
> come up with some sort of fix to make it happen.
> 
>> First of all, libkshark is not ready to be called officially a 
>> library, because we are still playing with the API. Our plan is to 
>> introduce the library (and its API) with the release of KernelShark 
>> 2.0. Before this, I would prefer all KernelShark libraries to be 
>> installed together with the executable. For me, separating the 
>> libraries and the executable looks like an encouragement for using 
>> directly the libraries, but we do not want to do this yet.
> 
> Sorry for make this confusing. Actually even when I've already make it 
> into lib64, I don't have the motivation to make it a separate library 
> (from packaging point of view). If you think moving these can potential 
> make users think the libraries is ready to use, it might be better for 
> me to carry on the patch within Fedora only just to make this fulfill 
> guidelines.
> 
>> Also please note that we are in the process of splitting the 
>> repository. When released, KernelShark 2.0 will be in a separate repo 
>> and will have its own build system that uses the trace-cmd libraries 
>> as external dependency.
>>
>>  > On 9.02.20 г. 5:42 ч., sztsian@gmail.com wrote:
>>> From: "Ziqian SUN (Zamir)" <sztsian@gmail.com>
>>>
>>> The trace-cmd makefile supports install lib into a different name like
>>> lib64. Now this patch implemented the same in kernel-shark.
>>>
>>> And in order to make debuginfo also lives in the same file structure,
>>> the compiling dir is changed to reflect libdir and prefix as well.
>>>
>>> Signed-off-by: Ziqian SUN (Zamir) <sztsian@gmail.com>
>>> ---
>>>   Makefile                        |  2 +-
>>>   kernel-shark/CMakeLists.txt     | 13 +++++++++----
>>>   kernel-shark/src/CMakeLists.txt |  6 +++---
>>>   3 files changed, 13 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/Makefile b/Makefile
>>> index d75f143..1aca807 100644
>>> --- a/Makefile
>>> +++ b/Makefile
>>> @@ -295,7 +295,7 @@ CMAKE_COMMAND = /usr/bin/cmake
>>>   BUILD_TYPE ?= RelWithDebInfo
>>>   $(kshark-dir)/build/Makefile: $(kshark-dir)/CMakeLists.txt
>>> -    $(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) 
>>> -DCMAKE_BUILD_TYPE=$(BUILD_TYPE) -D_INSTALL_PREFIX=$(prefix) ..
>>> +    $(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) 
>>> -DCMAKE_BUILD_TYPE=$(BUILD_TYPE) -D_INSTALL_PREFIX=$(prefix) 
>>> -D_LIBDIR=$(libdir) ..
>>>   gui: force $(CMD_TARGETS) $(kshark-dir)/build/Makefile
>>>       $(Q)$(MAKE) $(S) -C $(kshark-dir)/build
>>> diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
>>> index 8786b83..6652d08 100644
>>> --- a/kernel-shark/CMakeLists.txt
>>> +++ b/kernel-shark/CMakeLists.txt
>>> @@ -17,6 +17,10 @@ if (NOT _INSTALL_PREFIX)
>>>       set(_INSTALL_PREFIX "/usr/local")
>>>   endif (NOT _INSTALL_PREFIX)
>>> +if (NOT _LIBDIR)
>>> +    set(_LIBDIR "${_INSTALL_PREFIX}/lib")
>>> +endif (NOT _LIBDIR)
>>> +
>>>   include(${KS_DIR}/build/FindTraceCmd.cmake)
>>>   include(${KS_DIR}/build/FindJSONC.cmake)
>>> @@ -34,8 +38,8 @@ if (Qt5Widgets_FOUND)
>>>   endif (Qt5Widgets_FOUND)
>>> -set(LIBRARY_OUTPUT_PATH    "${KS_DIR}/lib")
>>> -set(EXECUTABLE_OUTPUT_PATH "${KS_DIR}/bin")
>>> +set(LIBRARY_OUTPUT_PATH    "${KS_DIR}/${_LIBDIR}")
>>> +set(EXECUTABLE_OUTPUT_PATH "${KS_DIR}/${_INSTALL_PREFIX}/bin")
>>
>> Not sure what is your idea here, but this looks wrong to me. When you 
>> are building from source (just typing "make") you don't expect the 
>> object files and the executables to be placed outside the trunk of the 
>> repository(${KS_DIR}). Do not confuse building the source with 
>> installing (when typing "make install").
> 
> In the beginning this was meant to make sure the debuginfo package is 
> generated within corresponding lib64 directory. However I just compiled 
> again and find it's not needed now.
> 
>>
>>>   set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -Wall -pthread -fPIC")
>>>   set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -std=c++11 -pthread 
>>> -fPIC")
>>> @@ -54,14 +58,15 @@ if (NOT CMAKE_CXX_FLAGS_PACKAGE)
>>>       set(CMAKE_CXX_FLAGS_PACKAGE "-O3")
>>>   endif (NOT CMAKE_CXX_FLAGS_PACKAGE)
>>> -set(KS_PLUGIN_INSTALL_PREFIX 
>>> ${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/plugins/)
>>> +set(KS_PLUGIN_INSTALL_PREFIX ${_LIBDIR}/${KS_APP_NAME}/plugins/)
>>>   set(KS_ICON        KS_icon_shark.svg)
>>>   set(KS_ICON_FIN    KS_icon_fin.svg)
>>>   set(KS_LOGO        KS_logo_symbol.svg)
>>>   set(KS_LOGO_LABEL  KS_logo_horizontal.svg)
>>> -set(CMAKE_INSTALL_RPATH "${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/")
>>> +SET(CMAKE_INSTALL_RPATH "${_LIBDIR}/${KS_APP_NAME}/")
>>
>> Please stick to lower-case characters with all CMake commands.
>>
> 
> Ah sorry, this is definitely a typo when converting to capital letters 
> in bulks.
> 
> Thanks for the review. As I don't know the background beforehand, if you 
> think part of this patch still makes sense, I can make v2 and drop the 
> bits you don't need yet.

Thanks for the clarification. Let's wait a bit to see if someone else is 
going to comment on this. Maybe you can add to the README file some 
explanation for the _LIBDIR Command-Line option, saying that it was 
added only to fulfill the Fedora packaging requirements.

cheers,
Yordan


> 
>> Thanks!
>> Yordan
>>
>>>   if (CMAKE_BUILD_TYPE MATCHES Package)
>>> diff --git a/kernel-shark/src/CMakeLists.txt 
>>> b/kernel-shark/src/CMakeLists.txt
>>> index 33b5db8..9666b18 100644
>>> --- a/kernel-shark/src/CMakeLists.txt
>>> +++ b/kernel-shark/src/CMakeLists.txt
>>> @@ -15,7 +15,7 @@ target_link_libraries(kshark ${TRACEEVENT_LIBRARY}
>>>   set_target_properties(kshark  PROPERTIES SUFFIX 
>>> ".so.${KS_VERSION_STRING}")
>>> -install(TARGETS kshark LIBRARY DESTINATION 
>>> ${_INSTALL_PREFIX}/lib/${KS_APP_NAME})
>>> +install(TARGETS kshark LIBRARY DESTINATION ${_LIBDIR}/${KS_APP_NAME})
>>>   if (OPENGL_FOUND AND GLUT_FOUND)
>>> @@ -29,7 +29,7 @@ if (OPENGL_FOUND AND GLUT_FOUND)
>>>       set_target_properties(kshark-plot PROPERTIES  SUFFIX 
>>> ".so.${KS_VERSION_STRING}")
>>> -    install(TARGETS kshark-plot LIBRARY DESTINATION 
>>> ${_INSTALL_PREFIX}/lib/${KS_APP_NAME})
>>> +    install(TARGETS kshark-plot LIBRARY DESTINATION 
>>> ${_LIBDIR}/${KS_APP_NAME})
>>>   endif (OPENGL_FOUND AND GLUT_FOUND)
>>> @@ -85,7 +85,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
>>>       install(TARGETS ${KS_APP_NAME} kshark-record kshark-gui
>>>               RUNTIME DESTINATION ${_INSTALL_PREFIX}/bin/
>>> -            LIBRARY DESTINATION ${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/)
>>> +            LIBRARY DESTINATION ${_LIBDIR}/${KS_APP_NAME}/)
>>>       install(FILES "${KS_DIR}/${KS_APP_NAME}.desktop"
>>>               DESTINATION ${_INSTALL_PREFIX}/share/applications/)
>>>
> 

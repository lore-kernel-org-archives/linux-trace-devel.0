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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CADFAC35647
	for <linux-trace-devel@archiver.kernel.org>; Fri, 21 Feb 2020 13:12:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97F8C24672
	for <linux-trace-devel@archiver.kernel.org>; Fri, 21 Feb 2020 13:12:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fq+XGJBj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbgBUNM4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 21 Feb 2020 08:12:56 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:33506 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727352AbgBUNM4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 21 Feb 2020 08:12:56 -0500
Received: by mail-lf1-f67.google.com with SMTP id n25so1470887lfl.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 21 Feb 2020 05:12:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pZbBTR7Po2c6EVOofZwIpTZ6IIhAJpGimNG8+xcE4Pk=;
        b=fq+XGJBjudyWoDWs7EE4jhX3oEUreRYBVwKPXnNjbbEu/oMWrtDG6FePLjhiQmGYkU
         IgdPmcLmP5VQ69xiXsd8dKxIXD2Ph5ojhRsPw39l3COwfAleh2TZYsdxEMWeaWH4vxds
         E1+i+O+EM4+TlrgPjxXOR8bV3WIX1JAOf2Ud5V2YL6teagQe7Y2nGWigXixtQRRAbRyy
         ddjhM0pZsumdvjMvOj8ssan8C4Yj3UA5UwQdXr8kACkPn5RY8BhO122mG7YZ8yLML3bR
         fQR0muPcEUumzYTrIgTH7kqz6XvPY8HO17TL9CXcVVpocdS2yv18OBrpDiRGhzhyMjtT
         GGEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pZbBTR7Po2c6EVOofZwIpTZ6IIhAJpGimNG8+xcE4Pk=;
        b=oxqSZI+t/aRYCgs1BevDYl7iUQXugrfOhAl36I0SfBGQmNfYLnfj+WLJV1A2EgX4eD
         3lNqcU8DNpG1bQo5NXMA4OQS+vjJpnRr4nudxjMshM0IqZDfSak+Zr3WTQ0FwnyR9sLm
         jQjArWq2Suj06NE6ktsKJl9MoyGWhykoRsKX6kAmn/t55itM1e4g97qAdmWpdbSR9fWb
         JvwRR68BdeEzQ8ZZhq3rl3b3F1Hn1Fiw5+BdkUbvSqnaFn8c2EhttQQUxgg4viBdwmOX
         +fm+f9nOu+wqsi27Iiy444h3RTFyqG3G1sMffayhpDzfdBNvJmHp/m+TZp4ScUU+8j95
         xwmg==
X-Gm-Message-State: APjAAAWYX+Ll3p24w/hMsrgpKsF8ujVolyn/7PzQ5mRlcUXA8AIKHb12
        z6MIoXicBg7c+65uONCLD3FLLQse
X-Google-Smtp-Source: APXvYqyCv/jedKqA8a1zEQQKAuBCRUy+/fVwp88dvZ1L+RHJGFKRx5bKTF763adDl0f1xHAjh6AgHQ==
X-Received: by 2002:ac2:44a7:: with SMTP id c7mr8742737lfm.32.1582290772582;
        Fri, 21 Feb 2020 05:12:52 -0800 (PST)
Received: from [10.27.112.58] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id y7sm1622385ljy.92.2020.02.21.05.12.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 05:12:51 -0800 (PST)
Subject: Re: [PATCH v2] KernelShark: Inherit libdir from Makefile
To:     sztsian@gmail.com, rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
References: <20200221124204.318917-1-sztsian@gmail.com>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <da752703-3a6f-a491-55e2-7fdc7b30c205@gmail.com>
Date:   Fri, 21 Feb 2020 15:12:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200221124204.318917-1-sztsian@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Zamir,

On 21.02.20 г. 14:42 ч., sztsian@gmail.com wrote:
> From: "Ziqian SUN (Zamir)" <sztsian@gmail.com>
> 
> The trace-cmd makefile supports install lib into a different name like
> lib64. Now this patch implemented the same in kernel-shark.
> 
> Change since v1: Drop the change of EXECUTABLE_OUTPUT_PATH and fix set
> command to lower case.
> 
> Signed-off-by: Ziqian SUN (Zamir) <sztsian@gmail.com>
> ---
>   Makefile                        |  2 +-
>   kernel-shark/CMakeLists.txt     | 11 ++++++++---
>   kernel-shark/src/CMakeLists.txt |  6 +++---
>   3 files changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index d75f143..1aca807 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -295,7 +295,7 @@ CMAKE_COMMAND = /usr/bin/cmake
>   BUILD_TYPE ?= RelWithDebInfo
>   
>   $(kshark-dir)/build/Makefile: $(kshark-dir)/CMakeLists.txt
> -	$(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) -DCMAKE_BUILD_TYPE=$(BUILD_TYPE) -D_INSTALL_PREFIX=$(prefix) ..
> +	$(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) -DCMAKE_BUILD_TYPE=$(BUILD_TYPE) -D_INSTALL_PREFIX=$(prefix) -D_LIBDIR=$(libdir) ..
>   
>   gui: force $(CMD_TARGETS) $(kshark-dir)/build/Makefile
>   	$(Q)$(MAKE) $(S) -C $(kshark-dir)/build
> diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
> index 8786b83..c60d29b 100644
> --- a/kernel-shark/CMakeLists.txt
> +++ b/kernel-shark/CMakeLists.txt
> @@ -17,6 +17,10 @@ if (NOT _INSTALL_PREFIX)
>       set(_INSTALL_PREFIX "/usr/local")
>   endif (NOT _INSTALL_PREFIX)
>   
> +if (NOT _LIBDIR)
> +    set(_LIBDIR "${_INSTALL_PREFIX}/lib")
> +endif (NOT _LIBDIR)
> +
>   include(${KS_DIR}/build/FindTraceCmd.cmake)
>   include(${KS_DIR}/build/FindJSONC.cmake)
>   
> @@ -34,7 +38,7 @@ if (Qt5Widgets_FOUND)
>   
>   endif (Qt5Widgets_FOUND)
>   
> -set(LIBRARY_OUTPUT_PATH    "${KS_DIR}/lib")
> +set(LIBRARY_OUTPUT_PATH    "${KS_DIR}/${_LIBDIR}")

Again, I am not sure what is your idea here.
As I already mentioned in my previous review, LIBRARY_OUTPUT_PATH (and 
EXECUTABLE_OUTPUT_PATH) has nothing to do with the installation path of 
the libraries. See
https://cmake.org/cmake/help/v3.0/prop_tgt/LIBRARY_OUTPUT_DIRECTORY.html

This specifies the directory into which library target files are built.
Not the directory into which the library files will be installed.

Thanks!
Yordan

>   set(EXECUTABLE_OUTPUT_PATH "${KS_DIR}/bin")
>   
>   set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -Wall -pthread -fPIC")
> @@ -54,14 +58,15 @@ if (NOT CMAKE_CXX_FLAGS_PACKAGE)
>       set(CMAKE_CXX_FLAGS_PACKAGE "-O3")
>   endif (NOT CMAKE_CXX_FLAGS_PACKAGE)
>   
> -set(KS_PLUGIN_INSTALL_PREFIX ${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/plugins/)
> +set(KS_PLUGIN_INSTALL_PREFIX ${_LIBDIR}/${KS_APP_NAME}/plugins/)
>   
>   set(KS_ICON        KS_icon_shark.svg)
>   set(KS_ICON_FIN    KS_icon_fin.svg)
>   set(KS_LOGO        KS_logo_symbol.svg)
>   set(KS_LOGO_LABEL  KS_logo_horizontal.svg)
>   
> -set(CMAKE_INSTALL_RPATH "${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/")
> +set(CMAKE_INSTALL_RPATH "${_LIBDIR}/${KS_APP_NAME}/")
> +
>   
>   if (CMAKE_BUILD_TYPE MATCHES Package)
>   
> diff --git a/kernel-shark/src/CMakeLists.txt b/kernel-shark/src/CMakeLists.txt
> index 33b5db8..9666b18 100644
> --- a/kernel-shark/src/CMakeLists.txt
> +++ b/kernel-shark/src/CMakeLists.txt
> @@ -15,7 +15,7 @@ target_link_libraries(kshark ${TRACEEVENT_LIBRARY}
>   
>   set_target_properties(kshark  PROPERTIES SUFFIX	".so.${KS_VERSION_STRING}")
>   
> -install(TARGETS kshark LIBRARY DESTINATION ${_INSTALL_PREFIX}/lib/${KS_APP_NAME})
> +install(TARGETS kshark LIBRARY DESTINATION ${_LIBDIR}/${KS_APP_NAME})
>   
>   if (OPENGL_FOUND AND GLUT_FOUND)
>   
> @@ -29,7 +29,7 @@ if (OPENGL_FOUND AND GLUT_FOUND)
>   
>       set_target_properties(kshark-plot PROPERTIES  SUFFIX ".so.${KS_VERSION_STRING}")
>   
> -    install(TARGETS kshark-plot LIBRARY DESTINATION ${_INSTALL_PREFIX}/lib/${KS_APP_NAME})
> +    install(TARGETS kshark-plot LIBRARY DESTINATION ${_LIBDIR}/${KS_APP_NAME})
>   
>   endif (OPENGL_FOUND AND GLUT_FOUND)
>   
> @@ -85,7 +85,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
>   
>       install(TARGETS ${KS_APP_NAME} kshark-record kshark-gui
>               RUNTIME DESTINATION ${_INSTALL_PREFIX}/bin/
> -            LIBRARY DESTINATION ${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/)
> +            LIBRARY DESTINATION ${_LIBDIR}/${KS_APP_NAME}/)
>   
>       install(FILES "${KS_DIR}/${KS_APP_NAME}.desktop"
>               DESTINATION ${_INSTALL_PREFIX}/share/applications/)
> 

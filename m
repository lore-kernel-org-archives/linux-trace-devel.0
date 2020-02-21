Return-Path: <SRS0=rBiU=4J=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AD60C35647
	for <linux-trace-devel@archiver.kernel.org>; Fri, 21 Feb 2020 14:00:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B75520578
	for <linux-trace-devel@archiver.kernel.org>; Fri, 21 Feb 2020 14:00:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gf1sqgAu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728326AbgBUOAf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 21 Feb 2020 09:00:35 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42043 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727876AbgBUOAe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 21 Feb 2020 09:00:34 -0500
Received: by mail-lj1-f194.google.com with SMTP id d10so2272547ljl.9
        for <linux-trace-devel@vger.kernel.org>; Fri, 21 Feb 2020 06:00:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=z1DXJIMw7ZC0BE10eMav/TnLXhYS6LPaxe/9i/QEKxM=;
        b=Gf1sqgAurYzFKlKLEBSH6X8pEXTYXjb3Ih5SuVJ/ERY/99TXJad6Qu3m3x4cF7QPko
         6rIwygNMRSF7BXrHGwH+xogqqAgEvlr6sCMACI54655iRcdJalrFoanCvQOlnS6OX/Yk
         eCCczsTixOerPS6emVID51M/ihP9C2NDI3LflvR6uFIOB6KCNBIn1gg7RwP22n4VDgcp
         tkQ+2LEhlGNSwEfWnSXbjkXIaz69b7a3abl2u8fxa8UyAHGcHrlPn7i18mA3n7/hAvF1
         GxTNjuutLBwcubh2TAWW4/rbofnGlqldFFJun2mV4y/0JP3TZux3dbGbT1V3AAYAf+ek
         ucYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z1DXJIMw7ZC0BE10eMav/TnLXhYS6LPaxe/9i/QEKxM=;
        b=INPUfsIvUZcC1+uYmNt3gsiWsCCSxZbqYqqequAFA+dTWsZfEAafF7fYCBjI31ZLX9
         5j2ycuC9hV3LmZ9G16ijFsBS0AGEKUTKowKtqO013Qa3QWQYKCEzJVPk3NbseQwT0Pk+
         A7HkPdAI32UWtzt4IkaCUuh4zzL3U8fTdSADS6jxQ6HkoNNmYi+lykJReWWKhkhxNAsy
         TXoWt41ovomkfc8cTB4oQRAIjGxp3kiMrLG64B6zq4npxy7x5xgV23OdVeyDtif5OhS8
         XJRNefvD8Ubj/+qE4bmbXZGn1x+O0+rmZf6xB/UyfMQ8hIgcb90dk4SuCHDmztewFnvc
         xC/g==
X-Gm-Message-State: APjAAAXh7Ufhbvw7SHmKdUwnlLe9Xv2jrr6u7XIblnZ7gmc6OpuTCK6N
        w9HLFbQlorQCxHQhoFXkq9IyuEgA
X-Google-Smtp-Source: APXvYqzraILlvpNzbtS1dJ5xBe00FYlsVUBmwGTXj/KUV12hC0mBWLe8JQ4sC21ow84XO1mb1zYd3A==
X-Received: by 2002:a2e:81c7:: with SMTP id s7mr22508969ljg.3.1582293631555;
        Fri, 21 Feb 2020 06:00:31 -0800 (PST)
Received: from [10.27.112.58] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id r10sm2033092ljk.9.2020.02.21.06.00.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 06:00:30 -0800 (PST)
Subject: Re: [PATCH v3] KernelShark: Inherit libdir from Makefile
To:     sztsian@gmail.com, rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
References: <20200221135713.323958-1-sztsian@gmail.com>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <70ac584e-26aa-f83b-8d17-b9d90d20f764@gmail.com>
Date:   Fri, 21 Feb 2020 16:00:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200221135713.323958-1-sztsian@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 21.02.20 г. 15:57 ч., sztsian@gmail.com wrote:
> From: "Ziqian SUN (Zamir)" <sztsian@gmail.com>
> 
> The trace-cmd makefile supports install lib into a different name like
> lib64. Now this patch implemented the same in kernel-shark.
> 
> Change since v2: Drop the change of LIBRARY_OUTPUT_PATH as well
> 
> Change since v1: Drop the change of EXECUTABLE_OUTPUT_PATH and fix set
> command to lower case.
> 
> Signed-off-by: Ziqian SUN (Zamir) <sztsian@gmail.com>

Thanks Zamir!

Reviewed-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>


> ---
>   Makefile                        | 2 +-
>   kernel-shark/CMakeLists.txt     | 8 ++++++--
>   kernel-shark/src/CMakeLists.txt | 6 +++---
>   3 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index a3facaa..2f9620e 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -297,7 +297,7 @@ CMAKE_COMMAND = /usr/bin/cmake
>   BUILD_TYPE ?= RelWithDebInfo
>   
>   $(kshark-dir)/build/Makefile: $(kshark-dir)/CMakeLists.txt
> -	$(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) -DCMAKE_BUILD_TYPE=$(BUILD_TYPE) -D_INSTALL_PREFIX=$(prefix) ..
> +	$(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) -DCMAKE_BUILD_TYPE=$(BUILD_TYPE) -D_INSTALL_PREFIX=$(prefix) -D_LIBDIR=$(libdir) ..
>   
>   gui: force $(CMD_TARGETS) $(kshark-dir)/build/Makefile
>   	$(Q)$(MAKE) $(S) -C $(kshark-dir)/build
> diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
> index 8786b83..1c9ac2e 100644
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
> @@ -54,14 +58,14 @@ if (NOT CMAKE_CXX_FLAGS_PACKAGE)
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

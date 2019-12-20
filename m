Return-Path: <SRS0=9eMf=2K=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0594C43603
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Dec 2019 09:27:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 974302467F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Dec 2019 09:27:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cTHpsTCr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727209AbfLTJ1c (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Dec 2019 04:27:32 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36840 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727345AbfLTJ1c (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Dec 2019 04:27:32 -0500
Received: by mail-wm1-f66.google.com with SMTP id p17so8473964wma.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Dec 2019 01:27:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GZiDkjEooCthf/SjDdne/zNAmw4TaeHwI0hjvPYKTS0=;
        b=cTHpsTCrCsHTiHT+eofxN6qgx876WFmxTLb6knYrZnhPgqG2EqQYX8PTbx4ZroCjtx
         hhD3Wi/qGoZH57iFQPEyYogC9DjavFxBrCFwkmxlR26ifPQdgA34NzlEi1Wq6wJZ0w3v
         slTlhMlUpB3AroXHKQSk5uXRCtWeeyUT7d15ZUQ9VGUeD2pVQtQvrhZmDIqRHrrHFp3j
         YCOga0w/3xVbl6b3mfjpYyY9t5sF6fOigoDP4Cl3DerLsZQ8uZI3dnt4y37gAurYgZM1
         EpAVozLLOrxBdaa8cnJJ44hwqAdeuJORim8HSd12CKyEoPbZJDLDqFT/++hWexM+MdUq
         R0KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GZiDkjEooCthf/SjDdne/zNAmw4TaeHwI0hjvPYKTS0=;
        b=VWyIy046YJ57D0xiQaYocVHEhqRsVJSI3ix9r30ylAxA5pJTIWa4mqdSEwxX3LhW3L
         G7AyT9VUu0sZ/g4A+FIBNofFe7jM3aUvsVB/QqmYoKMfdiBc196852F7tHMgoKCeUA1L
         NuWIokXZGacM6eZGK0u2uT98Vy/TxiotaCsUpMQOdkIiCP52xFuEeOPTk+2t1PAKIjNo
         p4VJIzBsmvTDr2SiTBaEd1RUm9P7q7U4HcKcth7h7GXTVPCSbURM50VVN/QcUAFTa6m8
         GjncupzMKQD/lFfIaJNvYQeZ5BtyEZiHXeHjhBZJVOzvbpxhnaHvJ3RWkJhFGT8A2UlL
         /CuQ==
X-Gm-Message-State: APjAAAWmsn3nFg26ygHRIER9EpFYlrCUIYjJFX+KNGs6o+RQa4u2ptIa
        Th1xnuxMRRIJ5H+d0CofVOGzLfRx
X-Google-Smtp-Source: APXvYqxVM8CvQzuS+pBYi7XNgYssetA+bmsbh7DCAPDaxb/9qpNCXeGvrnnjRS9NzQNWC0AZ4YHbYQ==
X-Received: by 2002:a05:600c:2301:: with SMTP id 1mr15936360wmo.147.1576834048909;
        Fri, 20 Dec 2019 01:27:28 -0800 (PST)
Received: from [10.27.112.58] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id o129sm9318187wmb.1.2019.12.20.01.27.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2019 01:27:27 -0800 (PST)
Subject: Re: [PATCH 2/6] kernel-shark: Use new tracefs library
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
References: <20191219113502.28964-1-tz.stoyanov@gmail.com>
 <20191219113502.28964-3-tz.stoyanov@gmail.com>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <402e91f5-06bc-24ec-2653-845fc7818e01@gmail.com>
Date:   Fri, 20 Dec 2019 11:27:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191219113502.28964-3-tz.stoyanov@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 19.12.19 г. 13:34 ч., Tzvetomir Stoyanov (VMware) wrote:
> Link libtracefs to kernel-shark and use its API:
>    tracefs_get_tracing_dir()
> 

Looks good.
Thanks!

Reviewed-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>

> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>   kernel-shark/CMakeLists.txt           |  3 ++-
>   kernel-shark/build/FindTraceCmd.cmake | 30 +++++++++++++++++++++++++++
>   kernel-shark/src/CMakeLists.txt       |  2 ++
>   kernel-shark/src/KsCaptureDialog.cpp  |  4 ++--
>   kernel-shark/src/libkshark.h          |  1 +
>   5 files changed, 37 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
> index 20478b9..8786b83 100644
> --- a/kernel-shark/CMakeLists.txt
> +++ b/kernel-shark/CMakeLists.txt
> @@ -76,7 +76,8 @@ endif (CMAKE_BUILD_TYPE MATCHES Package)
>   include_directories(${KS_DIR}/src/
>                       ${KS_DIR}/build/src/
>                       ${JSONC_INCLUDE_DIR}
> -                    ${TRACECMD_INCLUDE_DIR})
> +                    ${TRACECMD_INCLUDE_DIR}
> +                    ${TRACEFS_INCLUDE_DIR})
>   
>   message("")
>   message(STATUS "C flags      : " ${CMAKE_C_FLAGS})
> diff --git a/kernel-shark/build/FindTraceCmd.cmake b/kernel-shark/build/FindTraceCmd.cmake
> index d3e145c..f27fafe 100644
> --- a/kernel-shark/build/FindTraceCmd.cmake
> +++ b/kernel-shark/build/FindTraceCmd.cmake
> @@ -6,6 +6,8 @@
>   #  TRACEEVENT_FOUND, If false, do not try to use traceevent.
>   #
>   #  TRACECMD_INCLUDE_DIR, where to find trace-cmd header.
> +#  TRACEFS_INCLUDE_DIR, where to find tracefs header.
> +#  TRACEFS_LIBRARY, the tracefs library.
>   #  TRACECMD_LIBRARY, the trace-cmd library.
>   #  TRACECMD_FOUND, If false, do not try to use trace-cmd.
>   
> @@ -31,12 +33,21 @@ find_path(TRACECMD_INCLUDE_DIR  NAMES  trace-cmd/trace-cmd.h
>                                   PATHS  $ENV{TRACE_CMD}/include/
>                                          ${CMAKE_SOURCE_DIR}/../include/
>                                   NO_DEFAULT_PATH)
> +find_path(TRACEFS_INCLUDE_DIR   NAMES  tracefs/tracefs.h
> +                                PATHS  $ENV{TRACE_CMD}/include/
> +                                       ${CMAKE_SOURCE_DIR}/../include/
> +                                NO_DEFAULT_PATH)
>   
>   find_library(TRACECMD_LIBRARY   NAMES  trace-cmd/libtracecmd.a
>                                   PATHS  $ENV{TRACE_CMD}/lib/
>                                          ${CMAKE_SOURCE_DIR}/../lib/
>                                   NO_DEFAULT_PATH)
>   
> +find_library(TRACEFS_LIBRARY    NAMES  trace-cmd/libtracefs.a
> +                                PATHS  $ENV{TRACE_CMD}/lib/
> +                                       ${CMAKE_SOURCE_DIR}/../lib/
> +                                NO_DEFAULT_PATH)
> +
>   find_library(TRACEEVENT_LIBRARY NAMES  traceevent/libtraceevent.a
>                                   PATHS  $ENV{TRACE_CMD}/lib/
>                                          ${CMAKE_SOURCE_DIR}/../lib/
> @@ -46,7 +57,9 @@ find_library(TRACEEVENT_LIBRARY NAMES  traceevent/libtraceevent.a
>   # search was successful "find_path" will do nothing this time.
>   find_program(TRACECMD_EXECUTABLE   NAMES  trace-cmd)
>   find_path(TRACECMD_INCLUDE_DIR  NAMES  trace-cmd/trace-cmd.h)
> +find_path(TRACEFS_INCLUDE_DIR   NAMES  tracefs/tracefs.h)
>   find_library(TRACECMD_LIBRARY   NAMES  trace-cmd/libtracecmd.so)
> +find_library(TRACEFS_LIBRARY    NAMES  tracefs/libtracefs.so)
>   find_library(TRACEEVENT_LIBRARY NAMES  traceevent/libtraceevent.so)
>   
>   IF (TRACECMD_INCLUDE_DIR AND TRACECMD_LIBRARY)
> @@ -65,6 +78,23 @@ ELSE (TRACECMD_FOUND)
>   
>   ENDIF (TRACECMD_FOUND)
>   
> +IF (TRACEFS_INCLUDE_DIR AND TRACEFS_LIBRARY)
> +
> +  SET(TRACEFS_FOUND TRUE)
> +
> +ENDIF (TRACEFS_INCLUDE_DIR AND TRACEFS_LIBRARY)
> +
> +IF (TRACEFS_FOUND)
> +
> +  MESSAGE(STATUS "Found tracefs: ${TRACEFS_LIBRARY}")
> +
> +ELSE (TRACEFS_FOUND)
> +
> +  MESSAGE(FATAL_ERROR "\nCould not find tracefs!\n")
> +
> +ENDIF (TRACEFS_FOUND)
> +
> +
>   IF (TRACEEVENT_LIBRARY)
>   
>     SET(TRACEEVENT_FOUND TRUE)
> diff --git a/kernel-shark/src/CMakeLists.txt b/kernel-shark/src/CMakeLists.txt
> index e20a030..33b5db8 100644
> --- a/kernel-shark/src/CMakeLists.txt
> +++ b/kernel-shark/src/CMakeLists.txt
> @@ -9,6 +9,7 @@ add_library(kshark SHARED libkshark.c
>   
>   target_link_libraries(kshark ${TRACEEVENT_LIBRARY}
>                                ${TRACECMD_LIBRARY}
> +                             ${TRACEFS_LIBRARY}
>                                ${JSONC_LIBRARY}
>                                ${CMAKE_DL_LIBS})
>   
> @@ -69,6 +70,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
>                                        Qt5::Network
>                                        ${TRACEEVENT_LIBRARY}
>                                        ${TRACECMD_LIBRARY}
> +                                     ${TRACEFS_LIBRARY}
>                                        ${CMAKE_DL_LIBS})
>   
>       set_target_properties(kshark-gui PROPERTIES  SUFFIX ".so.${KS_VERSION_STRING}")
> diff --git a/kernel-shark/src/KsCaptureDialog.cpp b/kernel-shark/src/KsCaptureDialog.cpp
> index ad05917..548b6fb 100644
> --- a/kernel-shark/src/KsCaptureDialog.cpp
> +++ b/kernel-shark/src/KsCaptureDialog.cpp
> @@ -26,7 +26,7 @@ extern "C" {
>   
>   static inline tep_handle *local_events()
>   {
> -	return tracecmd_local_events(tracecmd_get_tracing_dir());
> +	return tracecmd_local_events(tracefs_get_tracing_dir());
>   }
>   
>   /**
> @@ -204,7 +204,7 @@ QStringList KsCaptureControl::_getPlugins()
>   	QStringList pluginList;
>   	char **all_plugins;
>   
> -	all_plugins = tracecmd_local_plugins(tracecmd_get_tracing_dir());
> +	all_plugins = tracecmd_local_plugins(tracefs_get_tracing_dir());
>   
>   	if (!all_plugins)
>   		return pluginList;
> diff --git a/kernel-shark/src/libkshark.h b/kernel-shark/src/libkshark.h
> index 3407db1..b05aa90 100644
> --- a/kernel-shark/src/libkshark.h
> +++ b/kernel-shark/src/libkshark.h
> @@ -28,6 +28,7 @@ extern "C" {
>   #include "trace-cmd/trace-cmd.h"
>   #include "trace-cmd/trace-filter-hash.h"
>   #include "traceevent/event-parse.h"
> +#include "tracefs/tracefs.h"
>   
>   // KernelShark
>   #include "libkshark-plugin.h"
> 

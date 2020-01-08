Return-Path: <SRS0=VTjS=25=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACF21C282DD
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Jan 2020 19:05:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8236820678
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Jan 2020 19:05:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728230AbgAHTFN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 8 Jan 2020 14:05:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:60150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727329AbgAHTFN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 Jan 2020 14:05:13 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C61020678;
        Wed,  8 Jan 2020 19:05:11 +0000 (UTC)
Date:   Wed, 8 Jan 2020 14:05:09 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 2/5] kernel-shark: Use new tracefs library
Message-ID: <20200108140509.2c701590@gandalf.local.home>
In-Reply-To: <20200106154058.60660-3-tz.stoyanov@gmail.com>
References: <20200106154058.60660-1-tz.stoyanov@gmail.com>
        <20200106154058.60660-3-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon,  6 Jan 2020 17:40:55 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Link libtracefs to kernel-shark and use its API:
>   tracefs_get_tracing_dir()
> 

This needs to be merged into the first patch, because the first patch
breaks the build, with breaks bisectability, which is a no-no.

-- Steve

> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  kernel-shark/CMakeLists.txt           |  3 ++-
>  kernel-shark/build/FindTraceCmd.cmake | 30 +++++++++++++++++++++++++++
>  kernel-shark/src/CMakeLists.txt       |  2 ++
>  kernel-shark/src/KsCaptureDialog.cpp  |  4 ++--
>  kernel-shark/src/libkshark.h          |  1 +
>  5 files changed, 37 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
> index 20478b9..8786b83 100644
> --- a/kernel-shark/CMakeLists.txt
> +++ b/kernel-shark/CMakeLists.txt
> @@ -76,7 +76,8 @@ endif (CMAKE_BUILD_TYPE MATCHES Package)
>  include_directories(${KS_DIR}/src/
>                      ${KS_DIR}/build/src/
>                      ${JSONC_INCLUDE_DIR}
> -                    ${TRACECMD_INCLUDE_DIR})
> +                    ${TRACECMD_INCLUDE_DIR}
> +                    ${TRACEFS_INCLUDE_DIR})
>  
>  message("")
>  message(STATUS "C flags      : " ${CMAKE_C_FLAGS})
> diff --git a/kernel-shark/build/FindTraceCmd.cmake b/kernel-shark/build/FindTraceCmd.cmake
> index d3e145c..f27fafe 100644
> --- a/kernel-shark/build/FindTraceCmd.cmake
> +++ b/kernel-shark/build/FindTraceCmd.cmake
> @@ -6,6 +6,8 @@
>  #  TRACEEVENT_FOUND, If false, do not try to use traceevent.
>  #
>  #  TRACECMD_INCLUDE_DIR, where to find trace-cmd header.
> +#  TRACEFS_INCLUDE_DIR, where to find tracefs header.
> +#  TRACEFS_LIBRARY, the tracefs library.
>  #  TRACECMD_LIBRARY, the trace-cmd library.
>  #  TRACECMD_FOUND, If false, do not try to use trace-cmd.
>  
> @@ -31,12 +33,21 @@ find_path(TRACECMD_INCLUDE_DIR  NAMES  trace-cmd/trace-cmd.h
>                                  PATHS  $ENV{TRACE_CMD}/include/
>                                         ${CMAKE_SOURCE_DIR}/../include/
>                                  NO_DEFAULT_PATH)
> +find_path(TRACEFS_INCLUDE_DIR   NAMES  tracefs/tracefs.h
> +                                PATHS  $ENV{TRACE_CMD}/include/
> +                                       ${CMAKE_SOURCE_DIR}/../include/
> +                                NO_DEFAULT_PATH)
>  
>  find_library(TRACECMD_LIBRARY   NAMES  trace-cmd/libtracecmd.a
>                                  PATHS  $ENV{TRACE_CMD}/lib/
>                                         ${CMAKE_SOURCE_DIR}/../lib/
>                                  NO_DEFAULT_PATH)
>  
> +find_library(TRACEFS_LIBRARY    NAMES  trace-cmd/libtracefs.a
> +                                PATHS  $ENV{TRACE_CMD}/lib/
> +                                       ${CMAKE_SOURCE_DIR}/../lib/
> +                                NO_DEFAULT_PATH)
> +
>  find_library(TRACEEVENT_LIBRARY NAMES  traceevent/libtraceevent.a
>                                  PATHS  $ENV{TRACE_CMD}/lib/
>                                         ${CMAKE_SOURCE_DIR}/../lib/
> @@ -46,7 +57,9 @@ find_library(TRACEEVENT_LIBRARY NAMES  traceevent/libtraceevent.a
>  # search was successful "find_path" will do nothing this time.
>  find_program(TRACECMD_EXECUTABLE   NAMES  trace-cmd)
>  find_path(TRACECMD_INCLUDE_DIR  NAMES  trace-cmd/trace-cmd.h)
> +find_path(TRACEFS_INCLUDE_DIR   NAMES  tracefs/tracefs.h)
>  find_library(TRACECMD_LIBRARY   NAMES  trace-cmd/libtracecmd.so)
> +find_library(TRACEFS_LIBRARY    NAMES  tracefs/libtracefs.so)
>  find_library(TRACEEVENT_LIBRARY NAMES  traceevent/libtraceevent.so)
>  
>  IF (TRACECMD_INCLUDE_DIR AND TRACECMD_LIBRARY)
> @@ -65,6 +78,23 @@ ELSE (TRACECMD_FOUND)
>  
>  ENDIF (TRACECMD_FOUND)
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
>  IF (TRACEEVENT_LIBRARY)
>  
>    SET(TRACEEVENT_FOUND TRUE)
> diff --git a/kernel-shark/src/CMakeLists.txt b/kernel-shark/src/CMakeLists.txt
> index e20a030..33b5db8 100644
> --- a/kernel-shark/src/CMakeLists.txt
> +++ b/kernel-shark/src/CMakeLists.txt
> @@ -9,6 +9,7 @@ add_library(kshark SHARED libkshark.c
>  
>  target_link_libraries(kshark ${TRACEEVENT_LIBRARY}
>                               ${TRACECMD_LIBRARY}
> +                             ${TRACEFS_LIBRARY}
>                               ${JSONC_LIBRARY}
>                               ${CMAKE_DL_LIBS})
>  
> @@ -69,6 +70,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
>                                       Qt5::Network
>                                       ${TRACEEVENT_LIBRARY}
>                                       ${TRACECMD_LIBRARY}
> +                                     ${TRACEFS_LIBRARY}
>                                       ${CMAKE_DL_LIBS})
>  
>      set_target_properties(kshark-gui PROPERTIES  SUFFIX ".so.${KS_VERSION_STRING}")
> diff --git a/kernel-shark/src/KsCaptureDialog.cpp b/kernel-shark/src/KsCaptureDialog.cpp
> index ad05917..548b6fb 100644
> --- a/kernel-shark/src/KsCaptureDialog.cpp
> +++ b/kernel-shark/src/KsCaptureDialog.cpp
> @@ -26,7 +26,7 @@ extern "C" {
>  
>  static inline tep_handle *local_events()
>  {
> -	return tracecmd_local_events(tracecmd_get_tracing_dir());
> +	return tracecmd_local_events(tracefs_get_tracing_dir());
>  }
>  
>  /**
> @@ -204,7 +204,7 @@ QStringList KsCaptureControl::_getPlugins()
>  	QStringList pluginList;
>  	char **all_plugins;
>  
> -	all_plugins = tracecmd_local_plugins(tracecmd_get_tracing_dir());
> +	all_plugins = tracecmd_local_plugins(tracefs_get_tracing_dir());
>  
>  	if (!all_plugins)
>  		return pluginList;
> diff --git a/kernel-shark/src/libkshark.h b/kernel-shark/src/libkshark.h
> index 3407db1..b05aa90 100644
> --- a/kernel-shark/src/libkshark.h
> +++ b/kernel-shark/src/libkshark.h
> @@ -28,6 +28,7 @@ extern "C" {
>  #include "trace-cmd/trace-cmd.h"
>  #include "trace-cmd/trace-filter-hash.h"
>  #include "traceevent/event-parse.h"
> +#include "tracefs/tracefs.h"
>  
>  // KernelShark
>  #include "libkshark-plugin.h"


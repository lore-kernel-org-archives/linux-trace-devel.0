Return-Path: <SRS0=rBiU=4J=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE1D7C35666
	for <linux-trace-devel@archiver.kernel.org>; Fri, 21 Feb 2020 20:41:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BF44207FD
	for <linux-trace-devel@archiver.kernel.org>; Fri, 21 Feb 2020 20:41:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbgBUUlb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 21 Feb 2020 15:41:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:57530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726878AbgBUUlb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 21 Feb 2020 15:41:31 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B057206ED;
        Fri, 21 Feb 2020 20:41:29 +0000 (UTC)
Date:   Fri, 21 Feb 2020 15:41:28 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     sztsian@gmail.com
Cc:     y.karadz@gmail.com, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3] KernelShark: Inherit libdir from Makefile
Message-ID: <20200221154128.31fb6615@gandalf.local.home>
In-Reply-To: <20200221135713.323958-1-sztsian@gmail.com>
References: <20200221135713.323958-1-sztsian@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 21 Feb 2020 21:57:13 +0800
sztsian@gmail.com wrote:

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

Hi Ziqian,

Just FYI. When adding "Changes since", it is common practice to put
that information below the "---" and above the diffstat. This way it's
not picked up and added to the git commit log when using scripts to
commit patches.

Thanks!

-- Steve


> Signed-off-by: Ziqian SUN (Zamir) <sztsian@gmail.com>
> ---
>  Makefile                        | 2 +-
>  kernel-shark/CMakeLists.txt     | 8 ++++++--
>  kernel-shark/src/CMakeLists.txt | 6 +++---
>  3 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index a3facaa..2f9620e 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -297,7 +297,7 @@ CMAKE_COMMAND = /usr/bin/cmake
>  BUILD_TYPE ?= RelWithDebInfo
>  
>  $(kshark-dir)/build/Makefile: $(kshark-dir)/CMakeLists.txt
> -	$(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) -DCMAKE_BUILD_TYPE=$(BUILD_TYPE) -D_INSTALL_PREFIX=$(prefix) ..
> +	$(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) -DCMAKE_BUILD_TYPE=$(BUILD_TYPE) -D_INSTALL_PREFIX=$(prefix) -D_LIBDIR=$(libdir) ..
>  
>  gui: force $(CMD_TARGETS) $(kshark-dir)/build/Makefile
>  	$(Q)$(MAKE) $(S) -C $(kshark-dir)/build
> diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
> index 8786b83..1c9ac2e 100644
> --- a/kernel-shark/CMakeLists.txt
> +++ b/kernel-shark/CMakeLists.txt
> @@ -17,6 +17,10 @@ if (NOT _INSTALL_PREFIX)
>      set(_INSTALL_PREFIX "/usr/local")
>  endif (NOT _INSTALL_PREFIX)
>  
> +if (NOT _LIBDIR)
> +    set(_LIBDIR "${_INSTALL_PREFIX}/lib")
> +endif (NOT _LIBDIR)
> +
>  include(${KS_DIR}/build/FindTraceCmd.cmake)
>  include(${KS_DIR}/build/FindJSONC.cmake)
>  
> @@ -54,14 +58,14 @@ if (NOT CMAKE_CXX_FLAGS_PACKAGE)
>      set(CMAKE_CXX_FLAGS_PACKAGE "-O3")
>  endif (NOT CMAKE_CXX_FLAGS_PACKAGE)
>  
> -set(KS_PLUGIN_INSTALL_PREFIX ${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/plugins/)
> +set(KS_PLUGIN_INSTALL_PREFIX ${_LIBDIR}/${KS_APP_NAME}/plugins/)
>  
>  set(KS_ICON        KS_icon_shark.svg)
>  set(KS_ICON_FIN    KS_icon_fin.svg)
>  set(KS_LOGO        KS_logo_symbol.svg)
>  set(KS_LOGO_LABEL  KS_logo_horizontal.svg)
>  
> -set(CMAKE_INSTALL_RPATH "${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/")
> +set(CMAKE_INSTALL_RPATH "${_LIBDIR}/${KS_APP_NAME}/")
>  
>  if (CMAKE_BUILD_TYPE MATCHES Package)
>  
> diff --git a/kernel-shark/src/CMakeLists.txt b/kernel-shark/src/CMakeLists.txt
> index 33b5db8..9666b18 100644
> --- a/kernel-shark/src/CMakeLists.txt
> +++ b/kernel-shark/src/CMakeLists.txt
> @@ -15,7 +15,7 @@ target_link_libraries(kshark ${TRACEEVENT_LIBRARY}
>  
>  set_target_properties(kshark  PROPERTIES SUFFIX	".so.${KS_VERSION_STRING}")
>  
> -install(TARGETS kshark LIBRARY DESTINATION ${_INSTALL_PREFIX}/lib/${KS_APP_NAME})
> +install(TARGETS kshark LIBRARY DESTINATION ${_LIBDIR}/${KS_APP_NAME})
>  
>  if (OPENGL_FOUND AND GLUT_FOUND)
>  
> @@ -29,7 +29,7 @@ if (OPENGL_FOUND AND GLUT_FOUND)
>  
>      set_target_properties(kshark-plot PROPERTIES  SUFFIX ".so.${KS_VERSION_STRING}")
>  
> -    install(TARGETS kshark-plot LIBRARY DESTINATION ${_INSTALL_PREFIX}/lib/${KS_APP_NAME})
> +    install(TARGETS kshark-plot LIBRARY DESTINATION ${_LIBDIR}/${KS_APP_NAME})
>  
>  endif (OPENGL_FOUND AND GLUT_FOUND)
>  
> @@ -85,7 +85,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
>  
>      install(TARGETS ${KS_APP_NAME} kshark-record kshark-gui
>              RUNTIME DESTINATION ${_INSTALL_PREFIX}/bin/
> -            LIBRARY DESTINATION ${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/)
> +            LIBRARY DESTINATION ${_LIBDIR}/${KS_APP_NAME}/)
>  
>      install(FILES "${KS_DIR}/${KS_APP_NAME}.desktop"
>              DESTINATION ${_INSTALL_PREFIX}/share/applications/)


Return-Path: <SRS0=kFh5=SK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2C7CC10F13
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Apr 2019 15:01:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F77021473
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Apr 2019 15:01:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbfDHPBM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Apr 2019 11:01:12 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42236 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfDHPBM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Apr 2019 11:01:12 -0400
Received: by mail-wr1-f65.google.com with SMTP id g3so16773408wrx.9
        for <linux-trace-devel@vger.kernel.org>; Mon, 08 Apr 2019 08:01:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mtyfCO+4kvlBslQ4gDC6FrqmWT+tFzt/7nMy65PTSdc=;
        b=stEZje5tulncQ2gOJtexC6NVf15GWWSiSbDIn9hbitXRSTpVHObaAITGRN8buyDdTZ
         coHA3ipruyEkp1yWgJZlknb55ofO6Lk4UAs39ew4u/lTynvWTZipLZ00l1EKeOhuk+XS
         k8gpELXKd7Sh29Ruos+O/MeqJ+PhDpOcN64ZJv9qiHJy4Fq4ecrU/Ocl6sKTpsvzU4FQ
         h4bJYglCAsSXWzxZMPSsFZxy8u/StFHSgBqitrrrX4/p3J4MaXtMv1TJNZfxjfxjBy2I
         SE6n8ShKGcjgT977QdFr/1MaiJQMog8/NcztIzl0jm/9LmnWA/Sxy9LLpATPPXTs1DC4
         J1cw==
X-Gm-Message-State: APjAAAV8LoN60Ic902Ffevtrb+u/G02QqzRQNMYCMI29/WsWmJ1WwS25
        xd01CSEykt4/32ZJZj72Bg==
X-Google-Smtp-Source: APXvYqzFGpsvHRLwBXYaCHlcQYvpCMH6zCIG7yqnrUih1FYfuAZQrvB/8RaRddAj6K93LNKP68f/dg==
X-Received: by 2002:adf:f7cc:: with SMTP id a12mr19351906wrq.87.1554735669502;
        Mon, 08 Apr 2019 08:01:09 -0700 (PDT)
Received: from box ([146.247.46.6])
        by smtp.gmail.com with ESMTPSA id e7sm10315969wme.37.2019.04.08.08.01.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Apr 2019 08:01:08 -0700 (PDT)
Date:   Mon, 8 Apr 2019 18:01:03 +0300
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/4] kernel-shark: Configuration information in
 ${HOME}/.cache/kernelshark
Message-ID: <20190408150102.GA6430@box>
References: <20190404145603.13592-1-ykaradzhov@vmware.com>
 <20190404145603.13592-2-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190404145603.13592-2-ykaradzhov@vmware.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Apr 04, 2019 at 05:56:00PM +0300, Yordan Karadzhov wrote:
> By default the "Last session" configuration file will be saved in
> ${HOME}/.cache/kernelshark
> 
> After applying this patch you may need to clean the CMAKE cache.
> This can be done by:
> 
>     cd kernel-shark/build/;./cmake_clean.sh; cd -
>     make gui
> 
> Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> ---
>  Makefile                          |  5 ++++-
>  kernel-shark/CMakeLists.txt       | 13 ++++++++-----
>  kernel-shark/README               |  8 +++++++-
>  kernel-shark/build/deff.h.cmake   |  4 ++--
>  kernel-shark/src/KsMainWindow.cpp |  4 ++--
>  5 files changed, 23 insertions(+), 11 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index cde45f8..d9b0c0e 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -254,7 +254,10 @@ all_cmd: $(CMD_TARGETS)
>  CMAKE_COMMAND = /usr/bin/cmake
>  
>  $(kshark-dir)/build/Makefile: $(kshark-dir)/CMakeLists.txt
> -	$(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) -D_INSTALL_PREFIX=$(prefix) ..
> +
> +	$(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) \
> +		-D_KS_CACHE_DIR=$(HOME)/.cache/kernelshark \
                                ^
Which $HOME would that be? The one for the user who built kernelshark and not the user who runs it.


> +		-D_INSTALL_PREFIX=$(prefix) ..
>  
>  gui: force $(CMD_TARGETS) $(kshark-dir)/build/Makefile
>  	$(Q)$(MAKE) $(S) -C $(kshark-dir)/build
> diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
> index 8858eb7..14d73f5 100644
> --- a/kernel-shark/CMakeLists.txt
> +++ b/kernel-shark/CMakeLists.txt
> @@ -12,10 +12,12 @@ message("\n project: Kernel Shark: (version: ${KS_VERSION_STRING})\n")
>  
>  set(KS_DIR ${CMAKE_SOURCE_DIR})
>  
> -# Make a directory to hold configuration files. To change this do:
> -# cmake .. -DKS_CONF_DIR=/your/preferred/path
> -set(KS_CONF_DIR "${KS_DIR}/.ksconf" CACHE STRING "Directory for configuration files.")
> -file(MAKE_DIRECTORY ${KS_CONF_DIR})
> +# Make a directory to hold cached configuration files. To change this do:
> +# cmake .. -D_KS_CACHE_DIR=/your/preferred/path
> +set(_KS_CACHE_DIR "$ENV{HOME}/.cache/kernelshark"
> +    CACHE STRING "Directory for cached configuration files.")
> +
> +file(MAKE_DIRECTORY ${_KS_CACHE_DIR})
>  
>  include(${KS_DIR}/build/FindTraceCmd.cmake)
>  include(${KS_DIR}/build/FindJSONC.cmake)
> @@ -66,7 +68,8 @@ include_directories(${KS_DIR}/src/
>  message("")
>  message(STATUS "C flags      : " ${CMAKE_C_FLAGS})
>  message(STATUS "CXX flags    : " ${CMAKE_CXX_FLAGS})
> -message(STATUS "Linker flags : " ${CMAKE_EXE_LINKER_FLAGS})
> +message(STATUS "Linker flags : " ${CMAKE_EXE_LINKER_FLAGS}\n)
> +message(STATUS "config. files saved in ${_KS_CACHE_DIR}")
>  
>  add_subdirectory(${KS_DIR}/src)
>  add_subdirectory(${KS_DIR}/examples)
> diff --git a/kernel-shark/README b/kernel-shark/README
> index 9f7db26..a75b08b 100644
> --- a/kernel-shark/README
> +++ b/kernel-shark/README
> @@ -52,8 +52,14 @@ as a CMake Command-Line option.
>  2.1.3 By default, installation prefix is "/usr/local". It can be changed using
>  -D_INSTALL_PREFIX= as a CMake Command-Line option.
>  
> -Example:
> +2.1.4 By default, the directory that holds cached configuration files is
> +${HOME}/.cache/kernelshark/ .It can be changed using -D_KS_CACHE_DIR=
> +as a CMake Command-Line option. Use only absolute paths for this option.
> +
> +
> +Examples:
>      cmake -D_DOXYGEN_DOC=1 -D_DEBUG=1 -D_INSTALL_PREFIX=/usr ../
> +    cmake -D_KS_CACHE_DIR=${PWD}../.kscache ../
>  
>  2.2.1 Use "make clean" if you want to delete all already compiled objects.
>  
> diff --git a/kernel-shark/build/deff.h.cmake b/kernel-shark/build/deff.h.cmake
> index 80d624c..f1f6a35 100644
> --- a/kernel-shark/build/deff.h.cmake
> +++ b/kernel-shark/build/deff.h.cmake
> @@ -14,8 +14,8 @@
>  /** KernelShark source code path. */
>  #cmakedefine KS_DIR "@KS_DIR@"
>  
> -/** KernelShark configuration directory path. */
> -#cmakedefine KS_CONF_DIR "@KS_CONF_DIR@"
> +/** KernelShark cache directory path. */
> +#cmakedefine _KS_CACHE_DIR "@_KS_CACHE_DIR@"
>  
>  /** Location of the trace-cmd executable. */
>  #cmakedefine TRACECMD_BIN_DIR "@TRACECMD_BIN_DIR@"
> diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
> index 7afb721..d07a89d 100644
> --- a/kernel-shark/src/KsMainWindow.cpp
> +++ b/kernel-shark/src/KsMainWindow.cpp
> @@ -133,7 +133,7 @@ KsMainWindow::KsMainWindow(QWidget *parent)
>  KsMainWindow::~KsMainWindow()
>  {
>  	kshark_context *kshark_ctx(nullptr);
> -	QString file = KS_CONF_DIR;
> +	QString file = _KS_CACHE_DIR;
>  
>  	file += "/lastsession.json";
>  
> @@ -370,7 +370,7 @@ void KsMainWindow::_open()
>  
>  void KsMainWindow::_restoreSession()
>  {
> -	QString file = KS_CONF_DIR;
> +	QString file = _KS_CACHE_DIR;
>  	file += "/lastsession.json";
>  
>  	loadSession(file);
> -- 
> 2.19.1
> 

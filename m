Return-Path: <SRS0=P3iB=VU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3BD0C76186
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Jul 2019 18:48:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B231020821
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Jul 2019 18:48:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728482AbfGWSsl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Jul 2019 14:48:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:53580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728243AbfGWSsl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Jul 2019 14:48:41 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7908A20821;
        Tue, 23 Jul 2019 18:48:40 +0000 (UTC)
Date:   Tue, 23 Jul 2019 14:48:37 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] kernel-shark: Get the path to trace-cmd executable from
 _INSTALL_PREFIX
Message-ID: <20190723144837.7616d6d5@gandalf.local.home>
In-Reply-To: <20190723182542.1295-1-y.karadz@gmail.com>
References: <20190723182542.1295-1-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 23 Jul 2019 21:25:42 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> The absolute path to the trace-cmd executable gets derived from
> "_INSTALL_PREFIX", and the "Record" dialog will be using its installed
> version. This is done because nothing guaranties that the trace-cmd
> executable will be presented at the time when the KernelShark package
> is built. The rule has one exception and this is the case when the build
> type is "Debug". In "Debug" mode the "Record" dialog will try to use the
> version of the trace-cmd executable from the build location.
> 
> Sugested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>

Thanks Yordan!

I just applied this and tested it this way.

On my build system, I removed all trace-cmd and kernelshark code, and
did this:

 $ mkdir /tmp/packages
 $ make clean
 $ make DESTDIR=/tmp/packages prefix=/usr install_gui
 $ cd /tmp/packages
 $ tar -cvjf /tmp/ks-package.tar.bz2 .
 $ scp /tmp/ks-package.tar.bz2 test-machine:/tmp

on test-machine:

 $ su -
 # cd /
 # tar xvf /tmp/ks-package.tar.bz2
 # cd ~
 # which kernelshark
/usr/bin/kernelshark
 # kernelshark

And tried a record, and all seems to be working!

-- Steve


> ---
>  kernel-shark/CMakeLists.txt           |  8 ++++----
>  kernel-shark/README                   |  7 ++++++-
>  kernel-shark/build/FindTraceCmd.cmake | 10 ++++++++--
>  3 files changed, 18 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
> index 45c6f23..075c4af 100644
> --- a/kernel-shark/CMakeLists.txt
> +++ b/kernel-shark/CMakeLists.txt
> @@ -13,6 +13,10 @@ message("\n project: Kernel Shark: (version: ${KS_VERSION_STRING})\n")
>  
>  set(KS_DIR ${CMAKE_SOURCE_DIR})
>  
> +if (NOT _INSTALL_PREFIX)
> +    set(_INSTALL_PREFIX "/usr/local")
> +endif (NOT _INSTALL_PREFIX)
> +
>  include(${KS_DIR}/build/FindTraceCmd.cmake)
>  include(${KS_DIR}/build/FindJSONC.cmake)
>  
> @@ -50,10 +54,6 @@ if (NOT CMAKE_CXX_FLAGS_PACKAGE)
>      set(CMAKE_CXX_FLAGS_PACKAGE "-O3")
>  endif (NOT CMAKE_CXX_FLAGS_PACKAGE)
>  
> -if (NOT _INSTALL_PREFIX)
> -    set(_INSTALL_PREFIX "/usr/local")
> -endif (NOT _INSTALL_PREFIX)
> -
>  set(KS_PLUGIN_INSTALL_PREFIX ${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/plugins/)
>  
>  set(KS_ICON        KS_icon_shark.svg)
> diff --git a/kernel-shark/README b/kernel-shark/README
> index 7e50479..6c360bb 100644
> --- a/kernel-shark/README
> +++ b/kernel-shark/README
> @@ -86,9 +86,14 @@ By default this build type adds the "-O2" compiler flag. Package maintainers
>  can chose their own compiler flags by providing the corresponding
>  CMAKE_XXXX_FLAGS_PACKAGE Command-Line options (see the example below).
>  
> -Note that when built as a "Package" the RPATH-s of the executables are
> +-- Note that when built as a "Package" the RPATH-s of the executables are
>  set directly to _INSTALL_PREFIX/lib/kernelshark/
>  
> +-- Note that when built as a "Debug" the "Record" dialog will try to use the
> +version of the trace-cmd executable from the build location. In all other cases
> +the dialog will derive the absolut path to the trace-cmd executable from
> +"_INSTALL_PREFIX", hence the dialog will use the installed version.
> +
>  If no build types is specified, the type will be "RelWithDebInfo".
>  
>  Examples:
> diff --git a/kernel-shark/build/FindTraceCmd.cmake b/kernel-shark/build/FindTraceCmd.cmake
> index 2da4eee..d3e145c 100644
> --- a/kernel-shark/build/FindTraceCmd.cmake
> +++ b/kernel-shark/build/FindTraceCmd.cmake
> @@ -21,6 +21,12 @@ if (CMAKE_BUILD_TYPE MATCHES Debug)
>  
>  endif (CMAKE_BUILD_TYPE MATCHES Debug)
>  
> +if (NOT TRACECMD_EXECUTABLE)
> +
> +  set(TRACECMD_EXECUTABLE "${_INSTALL_PREFIX}/bin/trace-cmd")
> +
> +endif (NOT TRACECMD_EXECUTABLE)
> +
>  find_path(TRACECMD_INCLUDE_DIR  NAMES  trace-cmd/trace-cmd.h
>                                  PATHS  $ENV{TRACE_CMD}/include/
>                                         ${CMAKE_SOURCE_DIR}/../include/
> @@ -43,11 +49,11 @@ find_path(TRACECMD_INCLUDE_DIR  NAMES  trace-cmd/trace-cmd.h)
>  find_library(TRACECMD_LIBRARY   NAMES  trace-cmd/libtracecmd.so)
>  find_library(TRACEEVENT_LIBRARY NAMES  traceevent/libtraceevent.so)
>  
> -IF (TRACECMD_INCLUDE_DIR AND TRACECMD_LIBRARY AND TRACECMD_EXECUTABLE)
> +IF (TRACECMD_INCLUDE_DIR AND TRACECMD_LIBRARY)
>  
>    SET(TRACECMD_FOUND TRUE)
>  
> -ENDIF (TRACECMD_INCLUDE_DIR AND TRACECMD_LIBRARY AND TRACECMD_EXECUTABLE)
> +ENDIF (TRACECMD_INCLUDE_DIR AND TRACECMD_LIBRARY)
>  
>  IF (TRACECMD_FOUND)
>  


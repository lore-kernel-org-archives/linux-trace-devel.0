Return-Path: <SRS0=xW9H=SA=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02A63C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Mar 2019 14:45:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B91082183F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Mar 2019 14:45:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MHcozofz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729150AbfC2Opl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 29 Mar 2019 10:45:41 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39333 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728737AbfC2Opl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 29 Mar 2019 10:45:41 -0400
Received: by mail-wr1-f67.google.com with SMTP id j9so2926149wrn.6
        for <linux-trace-devel@vger.kernel.org>; Fri, 29 Mar 2019 07:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LdC/5fJa8BSPLpfss5bXQlRlJTtFiZJ3fjrQEBf6Gp4=;
        b=MHcozofzFWO9FQFnjvPto4bTzD0KP/RZPN2DBUZDESX6/6AI95a3EedCYha70SRFLr
         W9fnFBySd8IcfqxQxszHLi1c6zJuwDVWHqyn8CVQc0qKPnjigbCSIy4bZ9h44rISXsEE
         rvdiAv4erWzPvH1blOf/gr3MAxqYuTtydRs2CksFyGnd8opRgIj6tdSsh/TtPtYqgSvH
         cz4QJOaJriCm09vDjIi0pAB4x7UG4n0DF0QHkxW8msgLp6jStSLcgnSwVdDKv+GqoLG9
         L4nTG2q1WubO5c/ScsxoAUcKabWoaUihIzeD2V1MZ+Ta5X4K+Tie1PXtLa7KRzrf5JtH
         /Bxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LdC/5fJa8BSPLpfss5bXQlRlJTtFiZJ3fjrQEBf6Gp4=;
        b=oXeFm6MB86Mfv/nPbNISXObQ2Z4vHAgJyM2mLtgGKj2hYa0BBGnNs/It0e7C9jXDdp
         ZCXOZWdtx19oSKTnDmTonRkdUPWf4AVfkeCiLb9VW2jCqtfUcrJFNN5G56hELrwIKh5O
         GEgLw9mXuu7FaThP7YMSWGujAN59ZXBmYyVhizUf6GXUpv39apdmNUO+NMX+UvbQ4HD5
         bkVAV+H0XHFo74V2bGiiOmYrZpnCcw4oM5A+9ajOs568EtrSnJHTLRwJRpVhpT64BEw7
         QqiG+RdR3roeZ/FU4jJvSE8iz+TI/Gv4zBR4xd8yFbrDTmxxkzY7Asu29LWrFRxXWAGo
         PMqQ==
X-Gm-Message-State: APjAAAX1YZFSN+2xdcugZh9iWE9mamBrBaKExXlLS/RY7voRKbmFV00T
        0j4gFnsNgIfPkytz+XmjtJl5x4rBCwQ=
X-Google-Smtp-Source: APXvYqy8+aJORozl4uJzmu3MCmrLhyJkXbE0AzEUoyCoYZOjy+Tx+r3cGwRpNfdQ6dFwn0bKVe1kkg==
X-Received: by 2002:a5d:488d:: with SMTP id g13mr18315063wrq.119.1553870738569;
        Fri, 29 Mar 2019 07:45:38 -0700 (PDT)
Received: from [10.27.113.15] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id h9sm1791228wmb.5.2019.03.29.07.45.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 29 Mar 2019 07:45:38 -0700 (PDT)
Subject: Re: [PATCH] kernel-shark: remove hardcoded /usr/local install prefix
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>, rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
References: <20190329140514.1373-1-tstoyanov@vmware.com>
 <20190329140514.1373-2-tstoyanov@vmware.com>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <5d49542e-99ac-430c-1c41-f97fee7f09aa@gmail.com>
Date:   Fri, 29 Mar 2019 16:45:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190329140514.1373-2-tstoyanov@vmware.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 29.03.19 г. 16:05 ч., Tzvetomir Stoyanov wrote:
> Installation prefix of kernelshark should not be hardcoded, it should be
> configurable at build time. As kernelshark and trace-cmd are built together,
> they should share the same installation prefix. The patch removes hardcoded
> /usr/local prefix from kernelshark make files and replaces it with the one,
> specified in the top Makefile.
> 

Maybe you need to add a comment explaning that, one has to run

kernel-shark/build/cmake_clean.sh

after applying the patch

Also please update the kernel-shark/README file describing the 
-D_INSTALL_PREFIX cmake option



> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>   Makefile                                                 | 2 +-
>   kernel-shark/CMakeLists.txt                              | 9 ++++++++-
>   kernel-shark/build/cmake_clean.sh                        | 1 +
>   kernel-shark/build/ks.desktop.cmake                      | 2 +-
>   .../org.freedesktop.kshark-record.policy.cmake}          | 2 +-
>   kernel-shark/src/CMakeLists.txt                          | 6 +++---
>   kernel-shark/src/plugins/CMakeLists.txt                  | 2 +-
>   7 files changed, 16 insertions(+), 8 deletions(-)
>   rename kernel-shark/{org.freedesktop.kshark-record.policy => build/org.freedesktop.kshark-record.policy.cmake} (86%)
> 
> diff --git a/Makefile b/Makefile
> index b780718..0b08e53 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -254,7 +254,7 @@ all_cmd: $(CMD_TARGETS)
>   CMAKE_COMMAND = /usr/bin/cmake
>   
>   $(kshark-dir)/build/Makefile: $(kshark-dir)/CMakeLists.txt
> -	$(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) ..
> +	$(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) -D_INSTALL_PREFIX=$(prefix) ..
>   

  trailing whitespace here


Reviewed-by: Yordan Karadzhov <ykaradzhov@vmware.com>
Tested-by: Yordan Karadzhov <ykaradzhov@vmware.com>

>   gui: force $(CMD_TARGETS) $(kshark-dir)/build/Makefile
>   	$(Q)$(MAKE) $(S) -C $(kshark-dir)/build
> diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
> index 20ced14..10cb696 100644
> --- a/kernel-shark/CMakeLists.txt
> +++ b/kernel-shark/CMakeLists.txt
> @@ -40,6 +40,10 @@ set(EXECUTABLE_OUTPUT_PATH "${KS_DIR}/bin")
>   set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -Wall -g -pthread")
>   set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -g -std=c++11 -pthread")
>   
> +if(NOT _INSTALL_PREFIX)
> +	set(_INSTALL_PREFIX "/usr/local")
> +endif()
> +
>   if (NOT _DEBUG)
>   
>   	set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -O2")
> @@ -47,7 +51,7 @@ if (NOT _DEBUG)
>   
>   endif (NOT _DEBUG)
>   
> -SET(CMAKE_INSTALL_RPATH "/usr/local/lib/kshark/")
> +SET(CMAKE_INSTALL_RPATH "${_INSTALL_PREFIX}/lib/kshark/")
>   SET(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
>   
>   include_directories(${KS_DIR}/src/
> @@ -82,4 +86,7 @@ endif ()
>   configure_file( ${KS_DIR}/build/ks.desktop.cmake
>                   ${KS_DIR}/kernelshark.desktop)
>   
> +configure_file( ${KS_DIR}/build/org.freedesktop.kshark-record.policy.cmake
> +                ${KS_DIR}/org.freedesktop.kshark-record.policy)
> +
>   message("")
> diff --git a/kernel-shark/build/cmake_clean.sh b/kernel-shark/build/cmake_clean.sh
> index ea04dc0..2e7c8f9 100755
> --- a/kernel-shark/build/cmake_clean.sh
> +++ b/kernel-shark/build/cmake_clean.sh
> @@ -7,6 +7,7 @@ rm -rf src/
>   rm -rf examples/
>   rm -f ../lib/*
>   rm ../kernelshark.desktop
> +rm ../org.freedesktop.kshark-record.policy
>   rm -f ../src/KsCmakeDef.hpp
>   rm -f CMakeDoxyfile.in
>   rm -f CMakeDoxygenDefaults.cmake
> diff --git a/kernel-shark/build/ks.desktop.cmake b/kernel-shark/build/ks.desktop.cmake
> index f1951f0..10e3610 100644
> --- a/kernel-shark/build/ks.desktop.cmake
> +++ b/kernel-shark/build/ks.desktop.cmake
> @@ -4,7 +4,7 @@ Type=Application
>   Name=Kernel Shark
>   GenericName=Kernel Shark
>   Comment=
> -Exec=/usr/local/bin/kernelshark
> +Exec=@_INSTALL_PREFIX@/bin/kernelshark
>   Icon=@KS_DIR@/icons/ksharkicon.png
>   Categories=System;
>   Terminal=false
> diff --git a/kernel-shark/org.freedesktop.kshark-record.policy b/kernel-shark/build/org.freedesktop.kshark-record.policy.cmake
> similarity index 86%
> rename from kernel-shark/org.freedesktop.kshark-record.policy
> rename to kernel-shark/build/org.freedesktop.kshark-record.policy.cmake
> index dc73817..988db78 100644
> --- a/kernel-shark/org.freedesktop.kshark-record.policy
> +++ b/kernel-shark/build/org.freedesktop.kshark-record.policy.cmake
> @@ -11,7 +11,7 @@
>         <allow_inactive>auth_admin</allow_inactive>
>         <allow_active>auth_admin</allow_active>
>       </defaults>
> -    <annotate key="org.freedesktop.policykit.exec.path">/usr/local/bin/kshark-record</annotate>
> +    <annotate key="org.freedesktop.policykit.exec.path">@_INSTALL_PREFIX@/bin/kshark-record</annotate>
>       <annotate key="org.freedesktop.policykit.exec.allow_gui">true</annotate>
>     </action>
>   
> diff --git a/kernel-shark/src/CMakeLists.txt b/kernel-shark/src/CMakeLists.txt
> index 1e0a794..b7dbd7e 100644
> --- a/kernel-shark/src/CMakeLists.txt
> +++ b/kernel-shark/src/CMakeLists.txt
> @@ -78,8 +78,8 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
>       target_link_libraries(kshark-record kshark-gui)
>   
>       install(TARGETS kernelshark kshark-record kshark kshark-plot kshark-gui
> -            RUNTIME DESTINATION /usr/local/bin/
> -            LIBRARY DESTINATION /usr/local/lib/kshark/)
> +            RUNTIME DESTINATION ${_INSTALL_PREFIX}/bin/
> +            LIBRARY DESTINATION ${_INSTALL_PREFIX}/lib/kshark/)
>   
>       install(FILES "${KS_DIR}/kernelshark.desktop"
>               DESTINATION /usr/share/applications/)
> @@ -88,7 +88,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
>               DESTINATION /usr/share/polkit-1/actions/)
>   
>       install(PROGRAMS "${KS_DIR}/bin/kshark-su-record"
> -            DESTINATION /usr/local/bin/)
> +            DESTINATION ${_INSTALL_PREFIX}/bin/)
>   
>   endif (Qt5Widgets_FOUND AND Qt5Network_FOUND)
>   
> diff --git a/kernel-shark/src/plugins/CMakeLists.txt b/kernel-shark/src/plugins/CMakeLists.txt
> index 853214e..6098275 100644
> --- a/kernel-shark/src/plugins/CMakeLists.txt
> +++ b/kernel-shark/src/plugins/CMakeLists.txt
> @@ -29,6 +29,6 @@ BUILD_PLUGIN(NAME missed_events
>   list(APPEND PLUGIN_LIST "missed_events default") # This plugin will be loaded by default
>   
>   install(TARGETS sched_events missed_events
> -        LIBRARY DESTINATION /usr/local/lib/kshark/)
> +        LIBRARY DESTINATION ${_INSTALL_PREFIX}/lib/kshark/)
>   
>   set(PLUGINS ${PLUGIN_LIST} PARENT_SCOPE)
> 

Return-Path: <SRS0=XbHK=M7=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:43804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727042AbeJSX7V (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Oct 2018 19:59:21 -0400
Date: Fri, 19 Oct 2018 11:52:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <ykaradzhov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>,
        Yordan Karadzhov <y.karadz@gmail.com>
Subject: Re: [PATCH v2 20/23] kernel-shark-qt: Add make install
Message-ID: <20181019115238.7025f2b7@gandalf.local.home>
In-Reply-To: <20181016155232.5257-21-ykaradzhov@vmware.com>
References: <20181016155232.5257-1-ykaradzhov@vmware.com>
        <20181016155232.5257-21-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Tue, 16 Oct 2018 15:53:21 +0000
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> diff --git a/kernel-shark-qt/build/cmake_uninstall.sh b/kernel-shark-qt/build/cmake_uninstall.sh
> new file mode 100755
> index 0000000..50c163b
> --- /dev/null
> +++ b/kernel-shark-qt/build/cmake_uninstall.sh
> @@ -0,0 +1,17 @@
> +#!/bin/bash
> +
> +CYAN='\033[0;36m'
> +PURPLE='\033[0;35m'
> +NC='\033[0m' # No Color

BTW, this also works:

 CYAN='\e[36m'
 PURPLE='\e[35m'
 NC='\e[0m' # No Color

Which is a little cleaner.

If you agree, can you resend just this patch with the update (as v2)?

Thanks!

-- Steve

> +
> +if [[ $EUID -ne 0 ]]; then
> +   echo -e "${PURPLE}Permission denied${NC}" 1>&2
> +   exit 100
> +fi
> +
> +if [ -e install_manifest.txt ]
> +then
> +    echo -e "${CYAN}Uninstall the project...${NC}"
> +    xargs rm -v < install_manifest.txt
> +    rm -f install_manifest.txt
> +fi
> diff --git a/kernel-shark-qt/src/CMakeLists.txt b/kernel-shark-qt/src/CMakeLists.txt
> index 6819f86..2592094 100644
> --- a/kernel-shark-qt/src/CMakeLists.txt
> +++ b/kernel-shark-qt/src/CMakeLists.txt
> @@ -73,6 +73,16 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
>      add_executable(kshark-record        kshark-record.cpp)
>      target_link_libraries(kshark-record kshark-gui)
>  
> +    install(TARGETS kernelshark kshark-record kshark kshark-plot kshark-gui
> +            RUNTIME DESTINATION /usr/local/bin/
> +            LIBRARY DESTINATION /usr/local/lib/kshark/)
> +
> +    install(FILES "${KS_DIR}/kernelshark.desktop"
> +            DESTINATION /usr/share/applications/)
> +
> +    install(FILES "${KS_DIR}/org.freedesktop.kshark-record.policy"
> +            DESTINATION /usr/share/polkit-1/actions/)
> +
>  endif (Qt5Widgets_FOUND AND Qt5Network_FOUND)
>  
>  add_subdirectory(plugins)
> diff --git a/kernel-shark-qt/src/plugins/CMakeLists.txt b/kernel-shark-qt/src/plugins/CMakeLists.txt
> index 88fd93c..2d7251d 100644
> --- a/kernel-shark-qt/src/plugins/CMakeLists.txt
> +++ b/kernel-shark-qt/src/plugins/CMakeLists.txt
> @@ -24,4 +24,7 @@ BUILD_PLUGIN(NAME sched_events
>  list(APPEND PLUGIN_LIST "sched_events default") # This plugin will be loaded by default
>  # list(APPEND PLUGIN_LIST "sched_events") # This plugin isn't loaded by default
>  
> +install(TARGETS sched_events
> +        LIBRARY DESTINATION /usr/local/lib/kshark/)
> +
>  set(PLUGINS ${PLUGIN_LIST} PARENT_SCOPE)

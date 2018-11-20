Return-Path: <SRS0=VnmA=N7=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:59388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730148AbeKTO2H (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 20 Nov 2018 09:28:07 -0500
Date: Mon, 19 Nov 2018 23:01:02 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/3] tools/lib/traceevent: Added support for pkg-config
Message-ID: <20181119230102.6079ea82@vmware.local.home>
In-Reply-To: <20180928071940.29810-3-tstoyanov@vmware.com>
References: <20180928071940.29810-1-tstoyanov@vmware.com>
        <20180928071940.29810-3-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 28 Sep 2018 10:19:39 +0300
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> This patch implements integration with pkg-config framework.
> pkg-config can be used by the library users to determine
> required CFLAGS and LDFLAGS in order to use the library

Do we still need this patch. I thought that there was some issue with
PowerTop where this wasn't working. If you think it's still useful then
we'll keep it.

Thanks!

-- Steve

> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  tools/lib/traceevent/Makefile                 | 26 ++++++++++++++++---
>  .../lib/traceevent/libtraceevent.pc.template  | 10 +++++++
>  2 files changed, 33 insertions(+), 3 deletions(-)
>  create mode 100644 tools/lib/traceevent/libtraceevent.pc.template
> 
> diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
> index 0b4e833088a4..05ac0ec9bcd1 100644
> --- a/tools/lib/traceevent/Makefile
> +++ b/tools/lib/traceevent/Makefile
> @@ -25,6 +25,7 @@ endef
>  $(call allow-override,CC,$(CROSS_COMPILE)gcc)
>  $(call allow-override,AR,$(CROSS_COMPILE)ar)
>  $(call allow-override,NM,$(CROSS_COMPILE)nm)
> +$(call allow-override,PKG_CONFIG,pkg-config)
>  
>  EXT = -std=gnu99
>  INSTALL = install
> @@ -47,6 +48,8 @@ prefix ?= /usr/local
>  libdir = $(prefix)/$(libdir_relative)
>  man_dir = $(prefix)/share/man
>  man_dir_SQ = '$(subst ','\'',$(man_dir))'
> +pkgconfig_dir ?= $(word 1,$(shell $(PKG_CONFIG) 		\
> +			--variable pc_path pkg-config | tr ":" " "))
>  
>  export man_dir man_dir_SQ INSTALL
>  export DESTDIR DESTDIR_SQ
> @@ -270,7 +273,19 @@ define do_generate_dynamic_list_file
>  	fi
>  endef
>  
> -install_lib: all_cmd install_plugins
> +PKG_CONFIG_FILE = libtraceevent.pc
> +define do_install_pkgconfig_file
> +	if [ -n "${pkgconfig_dir}" ]; then 					\
> +		cp -f ${PKG_CONFIG_FILE}.template ${PKG_CONFIG_FILE}; 		\
> +		sed -i "s|INSTALL_PREFIX|${1}|g" ${PKG_CONFIG_FILE}; 		\
> +		sed -i "s|LIB_VERSION|${EVENT_PARSE_VERSION}|g" ${PKG_CONFIG_FILE}; \
> +		$(call do_install,$(PKG_CONFIG_FILE),$(pkgconfig_dir),644); 	\
> +	else 									\
> +		(echo Failed to locate pkg-config directory) 1>&2;		\
> +	fi	
> +endef
> +
> +install_lib: all_cmd install_plugins install_pkgconfig
>  	$(call QUIET_INSTALL, $(LIB_TARGET)) \
>  		$(call do_install_mkdir,$(libdir_SQ)); \
>  		cp -fpR $(LIB_INSTALL) $(DESTDIR)$(libdir_SQ)
> @@ -279,6 +294,10 @@ install_plugins: $(PLUGINS)
>  	$(call QUIET_INSTALL, trace_plugins) \
>  		$(call do_install_plugins, $(PLUGINS))
>  
> +install_pkgconfig:
> +	$(call QUIET_INSTALL, $(PKG_CONFIG_FILE)) \
> +		$(call do_install_pkgconfig_file,$(prefix))
> +
>  install_headers:
>  	$(call QUIET_INSTALL, headers) \
>  		$(call do_install,event-parse.h,$(prefix)/include/traceevent,644); \
> @@ -289,8 +308,9 @@ install: install_lib
>  
>  clean:
>  	$(call QUIET_CLEAN, libtraceevent) \
> -		$(RM) *.o *~ $(TARGETS) *.a *.so $(VERSION_FILES) .*.d .*.cmd \
> -		$(RM) TRACEEVENT-CFLAGS tags TAGS
> +		$(RM) *.o *~ $(TARGETS) *.a *.so $(VERSION_FILES) .*.d .*.cmd; \
> +		$(RM) TRACEEVENT-CFLAGS tags TAGS; \
> +		$(RM) $(PKG_CONFIG_FILE)
>  
>  PHONY += force plugins
>  force:
> diff --git a/tools/lib/traceevent/libtraceevent.pc.template b/tools/lib/traceevent/libtraceevent.pc.template
> new file mode 100644
> index 000000000000..7e5078aadf85
> --- /dev/null
> +++ b/tools/lib/traceevent/libtraceevent.pc.template
> @@ -0,0 +1,10 @@
> +prefix=INSTALL_PREFIX
> +libdir=${prefix}/lib64
> +includedir=${prefix}/include/traceevent
> +
> +Name: libtraceevent
> +URL: https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/about/
> +Description: traceevent library
> +Version: LIB_VERSION
> +Cflags: -I${includedir}
> +Libs: -L${libdir} -ltraceevent

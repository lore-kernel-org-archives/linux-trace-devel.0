Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:56220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753995AbeBGTWk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Feb 2018 14:22:40 -0500
Date: Wed, 7 Feb 2018 14:22:38 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Cc: linux-trace-devel@vger.kernel.org, y.karadz@gmail.com
Subject: Re: [PATCH v2 13/24] trace-cmd: Move python-related files in
 python/
Message-ID: <20180207142238.74d12ec3@gandalf.local.home>
In-Reply-To: <20180206084906.9854-14-vladislav.valtchev@gmail.com>
References: <20180206084906.9854-1-vladislav.valtchev@gmail.com>
        <20180206084906.9854-14-vladislav.valtchev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Tue,  6 Feb 2018 10:48:55 +0200
"Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com> wrote:

Hi Vladislav,

This is actually the problem commit. The other commit fixed the output
of the test and this code wasn't being executed until you added the
fix. Which is why the fix caused the bisect to blame it.

I'm looking at why this breaks install, but I found another concern.

> This patch moves all the files related with trace-cmd's python support to a
> dedicated directory, as part of a bigger restructuring plan of trace-cmd's code
> base. The build system has been updated to support this new directory structure
> by adding a separate Makefile in python/ and by making the parent Makefile to
> invoke it.
> 
> Signed-off-by: Vladislav Valtchev (VMware) <vladislav.valtchev@gmail.com>
> ---
>  Makefile                                  | 42 +++++++++----------------------
>  python/Makefile                           | 40 +++++++++++++++++++++++++++++
>  ctracecmd.i => python/ctracecmd.i         |  0
>  ctracecmdgui.i => python/ctracecmdgui.i   |  0
>  event-viewer.py => python/event-viewer.py |  0
>  tracecmd.py => python/tracecmd.py         |  0
>  tracecmdgui.py => python/tracecmdgui.py   |  0
>  7 files changed, 52 insertions(+), 30 deletions(-)
>  create mode 100644 python/Makefile
>  rename ctracecmd.i => python/ctracecmd.i (100%)
>  rename ctracecmdgui.i => python/ctracecmdgui.i (100%)
>  rename event-viewer.py => python/event-viewer.py (100%)
>  rename tracecmd.py => python/tracecmd.py (100%)
>  rename tracecmdgui.py => python/tracecmdgui.py (100%)
> 
> diff --git a/Makefile b/Makefile
> index 2dfb8fd..b1f4c2c 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -113,13 +113,12 @@ PYTHON_VERS ?= python
>  ifeq ($(shell sh -c "pkg-config --cflags $(PYTHON_VERS) > /dev/null 2>&1 && which swig && echo y"), y)
>  	PYTHON_PLUGINS := plugin_python.so
>  	BUILD_PYTHON := $(PYTHON) $(PYTHON_PLUGINS)
> -	PYTHON_SO_INSTALL := ctracecmd.install
> -	PYTHON_PY_PROGS := event-viewer.install
> -	PYTHON_PY_LIBS := tracecmd.install tracecmdgui.install
> +	BUILD_PYTHON_WORKS := 1
>  endif
>  endif # NO_PYTHON
>  
>  export PYTHON_PLUGINS
> +export BUILD_PYTHON_WORKS
>  
>  # $(call test-build, snippet, ret) -> ret if snippet compiles
>  #                                  -> empty otherwise
> @@ -176,6 +175,7 @@ LIBTRACECMD_SHARED = $(LIBTRACECMD_DIR)/libtracecmd.so
>  
>  export LIBS
>  export LIBTRACEEVENT_DIR LIBTRACECMD_DIR
> +export LIBTRACECMD_STATIC LIBTRACECMD_SHARED
>  
>  CONFIG_INCLUDES = 
>  CONFIG_LIBS	=
> @@ -248,10 +248,6 @@ $(obj)/%.o: $(src)/%.c
>  %.o: $(src)/%.c
>  	$(Q)$(call do_compile)
>  
> -TRACE_VIEW_OBJS =
> -TRACE_VIEW_OBJS += $(obj)/kernel-shark/trace-view.o
> -TRACE_VIEW_OBJS += $(obj)/kernel-shark/trace-view-store.o

Why is this being moved into python code?

-- Steve

> -
>  TRACE_CMD_OBJS = trace-cmd.o trace-record.o trace-read.o trace-split.o trace-listen.o \
>  	 trace-stack.o trace-hist.o trace-mem.o trace-snapshot.o trace-stat.o \
>  	 trace-profile.o trace-stream.o trace-record.o trace-restore.o \
> @@ -372,19 +368,8 @@ cscope: force
>  install_plugins: force
>  	$(Q)$(MAKE) -C $(src)/plugins $@
>  
> -$(PYTHON_SO_INSTALL): %.install : %.so force
> -	$(Q)$(call do_install_data,$<,$(python_dir_SQ))
> -
> -$(PYTHON_PY_PROGS): %.install : %.py force
> -	$(Q)$(call do_install,$<,$(python_dir_SQ))
> -
> -$(PYTHON_PY_LIBS): %.install : %.py force
> -	$(Q)$(call do_install_data,$<,$(python_dir_SQ))
> -
> -$(PYTHON_PY_PLUGINS): %.install : %.py force
> -	$(Q)$(call do_install_data,$<,$(plugin_dir_SQ))
> -
> -install_python: $(PYTHON_SO_INSTALL) $(PYTHON_PY_PROGS) $(PYTHON_PY_LIBS) $(PYTHON_PY_PLUGINS)
> +install_python: force
> +	$(Q)$(MAKE) -C $(src)/python $@
>  
>  install_bash_completion: force
>  	$(Q)$(call do_install_data,trace-cmd.bash,$(BASH_COMPLETE_DIR))
> @@ -417,19 +402,20 @@ install_doc:
>  	$(MAKE) -C $(src)/Documentation install
>  
>  clean:
> -	$(RM) *.o *~ $(TARGETS) *.a *.so ctracecmd_wrap.c .*.d
> +	$(RM) *.o *~ $(TARGETS) *.a *.so .*.d
>  	$(RM) tags TAGS cscope*
>  	$(MAKE) -C $(src)/lib/traceevent clean
>  	$(MAKE) -C $(src)/lib/trace-cmd clean
>  	$(MAKE) -C $(src)/kernel-shark clean
>  	$(MAKE) -C $(src)/plugins clean
> +	$(MAKE) -C $(src)/python clean
>  
>  
>  ##### PYTHON STUFF #####
>  
>  report_noswig: force
>  	$(Q)echo
> -	$(Q)echo "    NO_PYTHON forced: swig not installed, not compling python plugins"
> +	$(Q)echo "    NO_PYTHON forced: swig not installed, not compiling python plugins"
>  	$(Q)echo
>  
>  PYTHON_INCLUDES = `pkg-config --cflags $(PYTHON_VERS)`
> @@ -441,15 +427,11 @@ export PYTHON_INCLUDES
>  export PYTHON_LDFLAGS
>  export PYGTK_CFLAGS
>  
> -ctracecmd.so: $(TCMD_LIB_OBJS) ctracecmd.i
> -	swig -Wall -python -noproxy -I$(src)/include/traceevent -I$(src)/include/trace-cmd ctracecmd.i
> -	$(CC) -fpic -c $(CPPFLAGS) $(CFLAGS) $(PYTHON_INCLUDES)  ctracecmd_wrap.c
> -	$(CC) --shared $(LIBTRACECMD_STATIC) $(LDFLAGS) ctracecmd_wrap.o -o ctracecmd.so
> +ctracecmd.so: force $(LIBTRACECMD_STATIC)
> +	$(Q)$(MAKE) -C $(src)/python $@
>  
> -ctracecmdgui.so: trace-view $(LIBTRACECMD_STATIC)
> -	swig -Wall -python -noproxy -I$(src)/kernel-shark/include ctracecmdgui.i
> -	$(CC) -fpic -c  $(CPPFLAGS) $(CFLAGS) $(INCLUDES) $(PYTHON_INCLUDES) $(PYGTK_CFLAGS) ctracecmdgui_wrap.c
> -	$(CC) --shared $(TRACE_VIEW_OBJS) $(LIBTRACECMD_STATIC) $(LDFLAGS) $(LIBS) $(CONFIG_LIBS) ctracecmdgui_wrap.o -o ctracecmdgui.so
> +ctracecmdgui.so: force $(LIBTRACECMD_STATIC) trace-view
> +	$(Q)$(MAKE) -C $(src)/python $@
>  
>  PHONY += python
>  python: $(PYTHON)
> diff --git a/python/Makefile b/python/Makefile
> new file mode 100644
> index 0000000..b07c0d8
> --- /dev/null
> +++ b/python/Makefile
> @@ -0,0 +1,40 @@
> +include $(src)/scripts/utils.mk
> +
> +TRACE_VIEW_OBJS =
> +TRACE_VIEW_OBJS += $(obj)/kernel-shark/trace-view.o
> +TRACE_VIEW_OBJS += $(obj)/kernel-shark/trace-view-store.o
> +
> +ifdef BUILD_PYTHON_WORKS
> +PYTHON_SO_INSTALL := ctracecmd.install
> +PYTHON_PY_PROGS := event-viewer.install
> +PYTHON_PY_LIBS := tracecmd.install tracecmdgui.install
> +endif
> +
> +ctracecmd.so: ctracecmd.i $(LIBTRACECMD_STATIC)
> +	swig -Wall -python -noproxy -I$(src)/include/traceevent -I$(src)/include/trace-cmd ctracecmd.i
> +	$(CC) -fpic -c $(CPPFLAGS) $(CFLAGS) $(PYTHON_INCLUDES)  ctracecmd_wrap.c
> +	$(CC) --shared $(LIBTRACECMD_STATIC) $(LDFLAGS) ctracecmd_wrap.o -o ctracecmd.so
> +
> +ctracecmdgui.so: ctracecmdgui.i $(LIBTRACECMD_STATIC) $(TRACE_VIEW_OBJS)
> +	swig -Wall -python -noproxy -I$(src)/kernel-shark/include ctracecmdgui.i
> +	$(CC) -fpic -c  $(CPPFLAGS) $(CFLAGS) $(INCLUDES) $(PYTHON_INCLUDES) $(PYGTK_CFLAGS) ctracecmdgui_wrap.c
> +	$(CC) --shared $(TRACE_VIEW_OBJS) $(LIBTRACECMD_STATIC) $(LDFLAGS) $(LIBS) $(CONFIG_LIBS) ctracecmdgui_wrap.o -o ctracecmdgui.so
> +
> +
> +$(PYTHON_SO_INSTALL): %.install : %.so force
> +	$(Q)$(call do_install_data,$<,$(python_dir_SQ))
> +
> +$(PYTHON_PY_PROGS): %.install : %.py force
> +	$(Q)$(call do_install,$<,$(python_dir_SQ))
> +
> +$(PYTHON_PY_LIBS): %.install : %.py force
> +	$(Q)$(call do_install_data,$<,$(python_dir_SQ))
> +
> +install_python: $(PYTHON_SO_INSTALL) $(PYTHON_PY_PROGS) $(PYTHON_PY_LIBS)
> +
> +
> +clean:
> +	$(RM) *.a *.so *.o .*.d ctracecmd_wrap.* ctracecmdgui_wrap.*
> +
> +force:
> +.PHONY: clean force
> diff --git a/ctracecmd.i b/python/ctracecmd.i
> similarity index 100%
> rename from ctracecmd.i
> rename to python/ctracecmd.i
> diff --git a/ctracecmdgui.i b/python/ctracecmdgui.i
> similarity index 100%
> rename from ctracecmdgui.i
> rename to python/ctracecmdgui.i
> diff --git a/event-viewer.py b/python/event-viewer.py
> similarity index 100%
> rename from event-viewer.py
> rename to python/event-viewer.py
> diff --git a/tracecmd.py b/python/tracecmd.py
> similarity index 100%
> rename from tracecmd.py
> rename to python/tracecmd.py
> diff --git a/tracecmdgui.py b/python/tracecmdgui.py
> similarity index 100%
> rename from tracecmdgui.py
> rename to python/tracecmdgui.py

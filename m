Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:33278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754129AbeBGULR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Feb 2018 15:11:17 -0500
Date: Wed, 7 Feb 2018 15:11:14 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Cc: linux-trace-devel@vger.kernel.org, y.karadz@gmail.com
Subject: Re: [PATCH v2 13/24] trace-cmd: Move python-related files in
 python/
Message-ID: <20180207151114.29e76c2e@gandalf.local.home>
In-Reply-To: <20180207142238.74d12ec3@gandalf.local.home>
References: <20180206084906.9854-1-vladislav.valtchev@gmail.com>
        <20180206084906.9854-14-vladislav.valtchev@gmail.com>
        <20180207142238.74d12ec3@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 7 Feb 2018 14:22:38 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> > @@ -248,10 +248,6 @@ $(obj)/%.o: $(src)/%.c
> >  %.o: $(src)/%.c
> >  	$(Q)$(call do_compile)
> >  
> > -TRACE_VIEW_OBJS =
> > -TRACE_VIEW_OBJS += $(obj)/kernel-shark/trace-view.o
> > -TRACE_VIEW_OBJS += $(obj)/kernel-shark/trace-view-store.o  
> 
> Why is this being moved into python code?

I now understand why you did it this way.



> > +++ b/python/Makefile
> > @@ -0,0 +1,40 @@
> > +include $(src)/scripts/utils.mk
> > +
> > +TRACE_VIEW_OBJS =
> > +TRACE_VIEW_OBJS += $(obj)/kernel-shark/trace-view.o
> > +TRACE_VIEW_OBJS += $(obj)/kernel-shark/trace-view-store.o
> > +
> > +ifdef BUILD_PYTHON_WORKS
> > +PYTHON_SO_INSTALL := ctracecmd.install
> > +PYTHON_PY_PROGS := event-viewer.install
> > +PYTHON_PY_LIBS := tracecmd.install tracecmdgui.install
> > +endif
> > +
> > +ctracecmd.so: ctracecmd.i $(LIBTRACECMD_STATIC)
> > +	swig -Wall -python -noproxy -I$(src)/include/traceevent -I$(src)/include/trace-cmd ctracecmd.i
> > +	$(CC) -fpic -c $(CPPFLAGS) $(CFLAGS) $(PYTHON_INCLUDES)  ctracecmd_wrap.c
> > +	$(CC) --shared $(LIBTRACECMD_STATIC) $(LDFLAGS) ctracecmd_wrap.o -o ctracecmd.so
> > +
> > +ctracecmdgui.so: ctracecmdgui.i $(LIBTRACECMD_STATIC) $(TRACE_VIEW_OBJS)

For this above.

I'd rather have that depend on a single file in kernel-shark directory,
or something that makes it a little cleaner.

-- Steve


> > +	swig -Wall -python -noproxy -I$(src)/kernel-shark/include ctracecmdgui.i
> > +	$(CC) -fpic -c  $(CPPFLAGS) $(CFLAGS) $(INCLUDES) $(PYTHON_INCLUDES) $(PYGTK_CFLAGS) ctracecmdgui_wrap.c
> > +	$(CC) --shared $(TRACE_VIEW_OBJS) $(LIBTRACECMD_STATIC) $(LDFLAGS) $(LIBS) $(CONFIG_LIBS) ctracecmdgui_wrap.o -o ctracecmdgui.so
> > +
> > +
> > +$(PYTHON_SO_INSTALL): %.install : %.so force
> > +	$(Q)$(call do_install_data,$<,$(python_dir_SQ))
> > +
> > +$(PYTHON_PY_PROGS): %.install : %.py force
> > +	$(Q)$(call do_install,$<,$(python_dir_SQ))
> > +
> > +$(PYTHON_PY_LIBS): %.install : %.py force
> > +	$(Q)$(call do_install_data,$<,$(python_dir_SQ))
> > +
> > +install_python: $(PYTHON_SO_INSTALL) $(PYTHON_PY_PROGS) $(PYTHON_PY_LIBS)
> > +
> > +
> > +clean:
> > +	$(RM) *.a *.so *.o .*.d ctracecmd_wrap.* ctracecmdgui_wrap.*
> > +
> > +force:
> > +.PHONY: clean force
> > diff --git a/ctracecmd.i b/python/ctracecmd.i
> > similarity index 100%
> > rename from ctracecmd.i
> > rename to python/ctracecmd.i
> > diff --git a/ctracecmdgui.i b/python/ctracecmdgui.i
> > similarity index 100%
> > rename from ctracecmdgui.i
> > rename to python/ctracecmdgui.i
> > diff --git a/event-viewer.py b/python/event-viewer.py
> > similarity index 100%
> > rename from event-viewer.py
> > rename to python/event-viewer.py
> > diff --git a/tracecmd.py b/python/tracecmd.py
> > similarity index 100%
> > rename from tracecmd.py
> > rename to python/tracecmd.py
> > diff --git a/tracecmdgui.py b/python/tracecmdgui.py
> > similarity index 100%
> > rename from tracecmdgui.py
> > rename to python/tracecmdgui.py  
> 

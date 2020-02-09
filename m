Return-Path: <SRS0=G/7s=35=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E25D4C2BA83
	for <linux-trace-devel@archiver.kernel.org>; Sun,  9 Feb 2020 03:42:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A66CD20820
	for <linux-trace-devel@archiver.kernel.org>; Sun,  9 Feb 2020 03:42:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RC4+F37q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727574AbgBIDmr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 8 Feb 2020 22:42:47 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:42421 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726474AbgBIDmr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 8 Feb 2020 22:42:47 -0500
Received: by mail-qt1-f196.google.com with SMTP id r5so1270139qtt.9
        for <linux-trace-devel@vger.kernel.org>; Sat, 08 Feb 2020 19:42:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BUqN8wPRWAePsK+PA9vBL+gbwT+OA96z0Vmt8UbVGQw=;
        b=RC4+F37q8vNssopb038LhVdRu0oPGV0BvEmrDlxOciecHFOa2de9eH7m+E01dcC54q
         CPPj6H+bYa0K1bbowKyL509mDK8GhxtDdQ3FkNFrnHJS3k4Zw+DLH3Wz294hSZ2g60Qh
         jGT3DO8AlMVk0WHF7iru/q+/0ernWDq2RyKnDppzX2vpYRcv6kNKgMQiQRd0oPJlPZ4M
         WAaXB8BoTIuwRkf4wjjuFnExlVZuNMMlqsAKjex4as6/yfh0Z34UT8ruR7DvvO5TYeDx
         jw2kcNeL1Eku/wBesl96HWUcHkH0h8lmjDKn+MwcdfOnsOJoW1ZBFV71BAOwPthpodBc
         B/AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BUqN8wPRWAePsK+PA9vBL+gbwT+OA96z0Vmt8UbVGQw=;
        b=Ek4H6xMLocaeDztW3/CSh68wLCBtjpUwiNMN/XxNrQHGb4sLO1+inIOG4KeRZ/27yg
         7pPI1XveP49X0IfFoyIbfV7FInd4zf9lsw/ACoxcQIjbugmAXUloW/SrsaezqR5vvnle
         2r3N4VecACuWu/hea9uxuxHkyI7FvqU9Q18cduE2ucczHH83FPH+Yo8tP0uaB1DBHn+/
         vZaY0F5DUEx+nw7Q+GJur+pnyjK80gORlyiK2B64QT7G2Q4ftPErzI72ecYAzJLSkNKY
         qaoIBnqc47qWZjsRd0LHx/mrPAEzlZJMDNBMjzHggNNDv0yWw/gxLm5zbC6pbqHlRXhl
         djNA==
X-Gm-Message-State: APjAAAV8XuaSQQfgFVWhWKPCx7j+jF0SKa2e/QTENc3doKqm9MBxIipJ
        eumvQ6kXd4I7d6YR/pBnfWE=
X-Google-Smtp-Source: APXvYqyoYrdkgLJJEBfhRNpihKTIGPO+ZnWv4daobw1hOm92rq30X0JSCvffU6/Crkb3i9zY4y4Mlg==
X-Received: by 2002:ac8:38ae:: with SMTP id f43mr4932582qtc.291.1581219765750;
        Sat, 08 Feb 2020 19:42:45 -0800 (PST)
Received: from i7.lan (whoami.aosc.io. [104.224.149.185])
        by smtp.gmail.com with ESMTPSA id g62sm3749947qkd.25.2020.02.08.19.42.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Feb 2020 19:42:45 -0800 (PST)
From:   sztsian@gmail.com
To:     tz.stoyanov@gmail.com, rostedt@goodmis.org
Cc:     sztsian@gmail.com, linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/2] trace-cmd: Clean up old gtk stuff
Date:   Sun,  9 Feb 2020 11:42:26 +0800
Message-Id: <20200209034226.287464-3-sztsian@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200209034226.287464-1-sztsian@gmail.com>
References: <20200209034226.287464-1-sztsian@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Ziqian SUN (Zamir)" <sztsian@gmail.com>

With ab37762ba9ad06a4f3902ad53ac2e9104bfd651f the gtk stuff was removed
from kernel-shark. This patch removes the python-gui which depends on
the trace-view from the gtk stuff.

Signed-off-by: Ziqian SUN (Zamir) <sztsian@gmail.com>
---
 Makefile              |  6 ---
 python/Makefile       | 14 +------
 python/ctracecmdgui.i | 88 -------------------------------------------
 3 files changed, 2 insertions(+), 106 deletions(-)
 delete mode 100644 python/ctracecmdgui.i

diff --git a/Makefile b/Makefile
index 1aca807..75bf1ef 100644
--- a/Makefile
+++ b/Makefile
@@ -126,7 +126,6 @@ endif
 
 ifndef NO_PYTHON
 PYTHON		:= ctracecmd.so
-PYTHON_GUI	:= ctracecmd.so ctracecmdgui.so
 
 PYTHON_VERS ?= python
 PYTHON_PKGCONFIG_VERS ?= $(PYTHON_VERS)
@@ -473,14 +472,9 @@ export PYGTK_CFLAGS
 ctracecmd.so: force $(LIBTRACECMD_STATIC)
 	$(Q)$(MAKE) -C $(src)/python $@
 
-ctracecmdgui.so: force $(LIBTRACECMD_STATIC) trace-view
-	$(Q)$(MAKE) -C $(src)/python $@
-
 PHONY += python
 python: $(PYTHON)
 
-PHONY += python-gui
-python-gui: $(PYTHON_GUI)
 
 dist:
 	git archive --format=tar --prefix=trace-cmd-$(TRACECMD_VERSION)/ HEAD \
diff --git a/python/Makefile b/python/Makefile
index 85224af..deaa83e 100644
--- a/python/Makefile
+++ b/python/Makefile
@@ -1,13 +1,9 @@
 include $(src)/scripts/utils.mk
 
-TRACE_VIEW_OBJS =
-TRACE_VIEW_OBJS += $(obj)/kernel-shark/trace-view.o
-TRACE_VIEW_OBJS += $(obj)/kernel-shark/trace-view-store.o
-
 ifdef BUILD_PYTHON_WORKS
 PYTHON_SO_INSTALL := ctracecmd.install
 PYTHON_PY_PROGS := event-viewer.install
-PYTHON_PY_LIBS := tracecmd.install tracecmdgui.install
+PYTHON_PY_LIBS := tracecmd.install
 endif
 
 ctracecmd.so: ctracecmd.i $(LIBTRACECMD_STATIC)
@@ -15,12 +11,6 @@ ctracecmd.so: ctracecmd.i $(LIBTRACECMD_STATIC)
 	$(CC) -fpic -c $(CPPFLAGS) $(CFLAGS) $(PYTHON_INCLUDES)  ctracecmd_wrap.c
 	$(CC) --shared $(LIBTRACECMD_STATIC) $(LDFLAGS) ctracecmd_wrap.o -o ctracecmd.so $(TRACE_LIBS)
 
-ctracecmdgui.so: ctracecmdgui.i $(LIBTRACECMD_STATIC) $(TRACE_VIEW_OBJS)
-	swig -Wall -python -noproxy -I$(src)/kernel-shark/include ctracecmdgui.i
-	$(CC) -fpic -c  $(CPPFLAGS) $(CFLAGS) $(INCLUDES) $(PYTHON_INCLUDES) $(PYGTK_CFLAGS) ctracecmdgui_wrap.c
-	$(CC) --shared $(TRACE_VIEW_OBJS) $(LIBTRACECMD_STATIC) $(LDFLAGS) $(LIBS) $(CONFIG_LIBS) ctracecmdgui_wrap.o -o ctracecmdgui.so $(TRACE_LIBS)
-
-
 $(PYTHON_SO_INSTALL): %.install : %.so force
 	$(Q)$(call do_install_data,$<,$(python_dir_SQ))
 
@@ -34,7 +24,7 @@ install_python: $(PYTHON_SO_INSTALL) $(PYTHON_PY_PROGS) $(PYTHON_PY_LIBS)
 
 
 clean:
-	$(RM) *.a *.so *.o .*.d ctracecmd_wrap.* ctracecmdgui_wrap.*
+	$(RM) *.a *.so *.o .*.d ctracecmd_wrap.*
 
 force:
 .PHONY: clean force
diff --git a/python/ctracecmdgui.i b/python/ctracecmdgui.i
deleted file mode 100644
index 4a7c6ac..0000000
--- a/python/ctracecmdgui.i
+++ /dev/null
@@ -1,88 +0,0 @@
-// ctracecmdgui.i
-%module ctracecmdgui
-%include typemaps.i
-
-%{
-#include "trace-view-store.h"
-#include <pygobject.h>
-#include <pyglib.h>
-#include <Python.h>
-#include <memoryobject.h>
-
-extern GtkTreeModel *trace_view_store_as_gtk_tree_model(struct trace_view_store *store);
-
-PyObject *
-pytype_from_gtype(GType gtype)
-{
-    PyTypeObject *pt = NULL;
-    switch (gtype) {
-    case G_TYPE_INT:
-    case G_TYPE_UINT:
-        pt = &PyLong_Type;
-        break;
-    case G_TYPE_STRING:
-        pt = &PyUnicode_Type;
-        break;
-    default:
-        return Py_None;
-    }
-    return (PyObject *)pt;
-}
-%}
-
-
-/* return python longs from unsigned long long functions */
-%typemap(out) unsigned long long {
-    $result = PyLong_FromUnsignedLongLong((unsigned long long) $1);
-}
-
-/* help swig cope with g* types */
-#if PY_MAJOR_VERSION >= 3
-%typemap(in) gint {
-    $1 = PyLong_AsLong($input);
-}
-%typemap(out) gint {
-    $result = PyLong_FromLong($1);
-}
-#else
-%typemap(in) gint {
-    $1 = PyInt_AsLong($input);
-}
-%typemap(out) gint {
-    $result = PyInt_FromLong($1);
-}
-#endif
-%typemap(in) guint {
-    $1 = PyLong_AsUnsignedLong($input);
-}
-%typemap(out) guint {
-    $result = PyLong_FromUnsignedLong($1);
-}
-%typemap(in) guint64 {
-    $1 = PyLong_AsUnsignedLongLong($input);
-}
-%typemap(out) guint64 {
-    $result = PyLong_FromUnsignedLongLong($1);
-}
-%typemap(out) GType {
-    $result = pytype_from_gtype($1);
-}
-%typemap(out) GtkTreeModelFlags {
-    $result = PyLong_FromLong($1);
-}
-
-
-%inline %{
-GtkTreeModel *trace_view_store_as_gtk_tree_model(struct trace_view_store *store)
-{
-    return GTK_TREE_MODEL(store);
-}
-%}
-
-
-/* SWIG can't grok these, define them to nothing */
-#define __trace
-#define __attribute__(x)
-#define __thread
-
-%include "trace-view-store.h"
-- 
2.24.1


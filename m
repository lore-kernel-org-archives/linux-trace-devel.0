Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33637 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932075AbdLTSIE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Dec 2017 13:08:04 -0500
From: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
To: rostedt@goodmis.org
Cc: y.karadz@gmail.com, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Subject: [PATCH 03/18] trace-cmd: Move trace-cmd headers in include/trace-cmd
Date: Wed, 20 Dec 2017 20:07:33 +0200
Message-Id: <20171220180748.17273-4-vladislav.valtchev@gmail.com>
In-Reply-To: <20171220180748.17273-1-vladislav.valtchev@gmail.com>
References: <20171220180748.17273-1-vladislav.valtchev@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch moves trace-cmd.h and trace-hash.h in include/trace-cmd as part of a
bigger restructuring plan of trace-cmd's code base. In this case, the new
directory will be the "public headers" directory of the trace-cmd library.

Signed-off-by: Vladislav Valtchev (VMware) <vladislav.valtchev@gmail.com>
---
 Makefile                                       | 5 +++--
 trace-cmd.h => include/trace-cmd/trace-cmd.h   | 0
 trace-hash.h => include/trace-cmd/trace-hash.h | 0
 3 files changed, 3 insertions(+), 2 deletions(-)
 rename trace-cmd.h => include/trace-cmd/trace-cmd.h (100%)
 rename trace-hash.h => include/trace-cmd/trace-hash.h (100%)

diff --git a/Makefile b/Makefile
index a5aea70..b2728c1 100644
--- a/Makefile
+++ b/Makefile
@@ -238,6 +238,7 @@ KERNELSHARK_VERSION = $(KS_VERSION).$(KS_PATCHLEVEL).$(KS_EXTRAVERSION)
 
 INCLUDES = -I. -I ./include -I $(srctree)/../../include $(CONFIG_INCLUDES)
 INCLUDES += -I$(src)/include/traceevent
+INCLUDES += -I$(src)/include/trace-cmd
 
 include $(src)/features.mk
 
@@ -606,7 +607,7 @@ install_libs: libs
 	$(Q)$(call do_install,libtracecmd.so,$(libdir_SQ))
 	$(Q)$(call do_install,libtraceevent.so,$(libdir_SQ))
 	$(Q)$(call do_install,$(src)/include/traceevent/event-parse.h,$(includedir_SQ))
-	$(Q)$(call do_install,trace-cmd.h,$(includedir_SQ))
+	$(Q)$(call do_install,$(src)/include/trace-cmd/trace-cmd.h,$(includedir_SQ))
 
 doc:
 	$(MAKE) -C $(src)/Documentation all
@@ -635,7 +636,7 @@ PYTHON_LDFLAGS = `pkg-config --libs $(PYTHON_VERS)` \
 PYGTK_CFLAGS = `pkg-config --cflags pygtk-2.0`
 
 ctracecmd.so: $(TCMD_LIB_OBJS) ctracecmd.i
-	swig -Wall -python -noproxy -I$(src)/include/traceevent ctracecmd.i
+	swig -Wall -python -noproxy -I$(src)/include/traceevent -I$(src)/include/trace-cmd ctracecmd.i
 	$(CC) -fpic -c $(CPPFLAGS) $(CFLAGS) $(PYTHON_INCLUDES)  ctracecmd_wrap.c
 	$(CC) --shared $(TCMD_LIB_OBJS) $(LDFLAGS) ctracecmd_wrap.o -o ctracecmd.so
 
diff --git a/trace-cmd.h b/include/trace-cmd/trace-cmd.h
similarity index 100%
rename from trace-cmd.h
rename to include/trace-cmd/trace-cmd.h
diff --git a/trace-hash.h b/include/trace-cmd/trace-hash.h
similarity index 100%
rename from trace-hash.h
rename to include/trace-cmd/trace-hash.h
-- 
2.14.1

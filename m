Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-pl0-f67.google.com ([209.85.160.67]:39338 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752278AbeBFItL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Feb 2018 03:49:11 -0500
Received: by mail-pl0-f67.google.com with SMTP id o13so847497pli.6
        for <linux-trace-devel@vger.kernel.org>; Tue, 06 Feb 2018 00:49:11 -0800 (PST)
From: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Subject: [PATCH v2 02/24] trace-cmd: Move libtraceevent headers in include/traceevent
Date: Tue,  6 Feb 2018 10:48:44 +0200
Message-Id: <20180206084906.9854-3-vladislav.valtchev@gmail.com>
In-Reply-To: <20180206084906.9854-1-vladislav.valtchev@gmail.com>
References: <20180206084906.9854-1-vladislav.valtchev@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch moves event-parse.h and kbuffer.h in include/traceevent as part of a
bigger restructuring plan of trace-cmd's code base. In this case, the new
directory will be the "public headers" directory of the traceevent library.

Signed-off-by: Vladislav Valtchev (VMware) <vladislav.valtchev@gmail.com>
---
 Makefile                                          | 5 +++--
 event-parse.h => include/traceevent/event-parse.h | 0
 kbuffer.h => include/traceevent/kbuffer.h         | 0
 3 files changed, 3 insertions(+), 2 deletions(-)
 rename event-parse.h => include/traceevent/event-parse.h (100%)
 rename kbuffer.h => include/traceevent/kbuffer.h (100%)

diff --git a/Makefile b/Makefile
index a3a60bf..b79f91f 100644
--- a/Makefile
+++ b/Makefile
@@ -238,6 +238,7 @@ TRACECMD_VERSION = $(TC_VERSION).$(TC_PATCHLEVEL).$(TC_EXTRAVERSION)
 KERNELSHARK_VERSION = $(KS_VERSION).$(KS_PATCHLEVEL).$(KS_EXTRAVERSION)
 
 INCLUDES = -I. -I ./include -I $(srctree)/../../include $(CONFIG_INCLUDES)
+INCLUDES += -I$(src)/include/traceevent
 
 include $(src)/features.mk
 
@@ -610,7 +611,7 @@ install_gui: install_cmd gui
 install_libs: libs
 	$(Q)$(call do_install,libtracecmd.so,$(libdir_SQ))
 	$(Q)$(call do_install,libtraceevent.so,$(libdir_SQ))
-	$(Q)$(call do_install,event-parse.h,$(includedir_SQ))
+	$(Q)$(call do_install,$(src)/include/traceevent/event-parse.h,$(includedir_SQ))
 	$(Q)$(call do_install,trace-cmd.h,$(includedir_SQ))
 
 doc:
@@ -640,7 +641,7 @@ PYTHON_LDFLAGS = `pkg-config --libs $(PYTHON_VERS)` \
 PYGTK_CFLAGS = `pkg-config --cflags pygtk-2.0`
 
 ctracecmd.so: $(TCMD_LIB_OBJS) ctracecmd.i
-	swig -Wall -python -noproxy ctracecmd.i
+	swig -Wall -python -noproxy -I$(src)/include/traceevent ctracecmd.i
 	$(CC) -fpic -c $(CPPFLAGS) $(CFLAGS) $(PYTHON_INCLUDES)  ctracecmd_wrap.c
 	$(CC) --shared $(TCMD_LIB_OBJS) $(LDFLAGS) ctracecmd_wrap.o -o ctracecmd.so
 
diff --git a/event-parse.h b/include/traceevent/event-parse.h
similarity index 100%
rename from event-parse.h
rename to include/traceevent/event-parse.h
diff --git a/kbuffer.h b/include/traceevent/kbuffer.h
similarity index 100%
rename from kbuffer.h
rename to include/traceevent/kbuffer.h
-- 
2.14.1

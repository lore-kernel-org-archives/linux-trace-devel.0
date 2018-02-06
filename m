Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-pf0-f194.google.com ([209.85.192.194]:39108 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752335AbeBFItZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Feb 2018 03:49:25 -0500
Received: by mail-pf0-f194.google.com with SMTP id l9so316590pfi.6
        for <linux-trace-devel@vger.kernel.org>; Tue, 06 Feb 2018 00:49:25 -0800 (PST)
From: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Subject: [PATCH v2 09/24] trace-cmd: Move GUI headers in kernel-shark/include
Date: Tue,  6 Feb 2018 10:48:51 +0200
Message-Id: <20180206084906.9854-10-vladislav.valtchev@gmail.com>
In-Reply-To: <20180206084906.9854-1-vladislav.valtchev@gmail.com>
References: <20180206084906.9854-1-vladislav.valtchev@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch moves, as part of a bigger code base restructuring, all the header
files of kernelshark in a dedicated directory. The next patch will move all
of kernelshark's source files in kernel-shark/.

Signed-off-by: Vladislav Valtchev (VMware) <vladislav.valtchev@gmail.com>
---
 Makefile                                                        | 3 ++-
 cpu.h => kernel-shark/include/cpu.h                             | 0
 kernel-shark.h => kernel-shark/include/kernel-shark.h           | 0
 kshark-plugin.h => kernel-shark/include/kshark-plugin.h         | 0
 trace-capture.h => kernel-shark/include/trace-capture.h         | 0
 trace-compat.h => kernel-shark/include/trace-compat.h           | 0
 trace-filter-hash.h => kernel-shark/include/trace-filter-hash.h | 0
 trace-filter.h => kernel-shark/include/trace-filter.h           | 0
 trace-graph.h => kernel-shark/include/trace-graph.h             | 0
 trace-gui.h => kernel-shark/include/trace-gui.h                 | 0
 trace-view-store.h => kernel-shark/include/trace-view-store.h   | 0
 trace-view.h => kernel-shark/include/trace-view.h               | 0
 trace-xml.h => kernel-shark/include/trace-xml.h                 | 0
 13 files changed, 2 insertions(+), 1 deletion(-)
 rename cpu.h => kernel-shark/include/cpu.h (100%)
 rename kernel-shark.h => kernel-shark/include/kernel-shark.h (100%)
 rename kshark-plugin.h => kernel-shark/include/kshark-plugin.h (100%)
 rename trace-capture.h => kernel-shark/include/trace-capture.h (100%)
 rename trace-compat.h => kernel-shark/include/trace-compat.h (100%)
 rename trace-filter-hash.h => kernel-shark/include/trace-filter-hash.h (100%)
 rename trace-filter.h => kernel-shark/include/trace-filter.h (100%)
 rename trace-graph.h => kernel-shark/include/trace-graph.h (100%)
 rename trace-gui.h => kernel-shark/include/trace-gui.h (100%)
 rename trace-view-store.h => kernel-shark/include/trace-view-store.h (100%)
 rename trace-view.h => kernel-shark/include/trace-view.h (100%)
 rename trace-xml.h => kernel-shark/include/trace-xml.h (100%)

diff --git a/Makefile b/Makefile
index 2c08162..2269a96 100644
--- a/Makefile
+++ b/Makefile
@@ -243,6 +243,7 @@ INCLUDES += -I$(src)/include/traceevent
 INCLUDES += -I$(src)/include/trace-cmd
 INCLUDES += -I$(src)/lib/traceevent/include
 INCLUDES += -I$(src)/lib/trace-cmd/include
+INCLUDES += -I$(src)/kernel-shark/include
 
 include $(src)/features.mk
 
@@ -602,7 +603,7 @@ ctracecmd.so: $(TCMD_LIB_OBJS) ctracecmd.i
 	$(CC) --shared $(LIBTRACECMD_STATIC) $(LDFLAGS) ctracecmd_wrap.o -o ctracecmd.so
 
 ctracecmdgui.so: $(TRACE_VIEW_OBJS) $(LIBTRACECMD_STATIC)
-	swig -Wall -python -noproxy ctracecmdgui.i
+	swig -Wall -python -noproxy -I$(src)/kernel-shark/include ctracecmdgui.i
 	$(CC) -fpic -c  $(CPPFLAGS) $(CFLAGS) $(INCLUDES) $(PYTHON_INCLUDES) $(PYGTK_CFLAGS) ctracecmdgui_wrap.c
 	$(CC) --shared $^ $(LDFLAGS) $(LIBS) $(CONFIG_LIBS) ctracecmdgui_wrap.o -o ctracecmdgui.so
 
diff --git a/cpu.h b/kernel-shark/include/cpu.h
similarity index 100%
rename from cpu.h
rename to kernel-shark/include/cpu.h
diff --git a/kernel-shark.h b/kernel-shark/include/kernel-shark.h
similarity index 100%
rename from kernel-shark.h
rename to kernel-shark/include/kernel-shark.h
diff --git a/kshark-plugin.h b/kernel-shark/include/kshark-plugin.h
similarity index 100%
rename from kshark-plugin.h
rename to kernel-shark/include/kshark-plugin.h
diff --git a/trace-capture.h b/kernel-shark/include/trace-capture.h
similarity index 100%
rename from trace-capture.h
rename to kernel-shark/include/trace-capture.h
diff --git a/trace-compat.h b/kernel-shark/include/trace-compat.h
similarity index 100%
rename from trace-compat.h
rename to kernel-shark/include/trace-compat.h
diff --git a/trace-filter-hash.h b/kernel-shark/include/trace-filter-hash.h
similarity index 100%
rename from trace-filter-hash.h
rename to kernel-shark/include/trace-filter-hash.h
diff --git a/trace-filter.h b/kernel-shark/include/trace-filter.h
similarity index 100%
rename from trace-filter.h
rename to kernel-shark/include/trace-filter.h
diff --git a/trace-graph.h b/kernel-shark/include/trace-graph.h
similarity index 100%
rename from trace-graph.h
rename to kernel-shark/include/trace-graph.h
diff --git a/trace-gui.h b/kernel-shark/include/trace-gui.h
similarity index 100%
rename from trace-gui.h
rename to kernel-shark/include/trace-gui.h
diff --git a/trace-view-store.h b/kernel-shark/include/trace-view-store.h
similarity index 100%
rename from trace-view-store.h
rename to kernel-shark/include/trace-view-store.h
diff --git a/trace-view.h b/kernel-shark/include/trace-view.h
similarity index 100%
rename from trace-view.h
rename to kernel-shark/include/trace-view.h
diff --git a/trace-xml.h b/kernel-shark/include/trace-xml.h
similarity index 100%
rename from trace-xml.h
rename to kernel-shark/include/trace-xml.h
-- 
2.14.1

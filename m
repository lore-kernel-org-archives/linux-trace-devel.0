Return-Path: <SRS0=aTL9=JH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:42534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933367AbeFUPrX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Jun 2018 11:47:23 -0400
Message-Id: <20180621154722.045084294@goodmis.org>
Date: Thu, 21 Jun 2018 11:43:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH 2/5] trace-cmd/kernelshark: Move trace-filter-hash.o libtracecmd.a
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0002-trace-cmd-kernelshark-Move-trace-filter-hash.o-libtr.patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Move trace-filter-hash.o into libtracecmd.a as it has useful features for
filtering than just for KernelShark.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 {kernel-shark/include => include/trace-cmd}/trace-filter-hash.h | 0
 kernel-shark/Makefile                                           | 2 +-
 lib/trace-cmd/Makefile                                          | 1 +
 {kernel-shark => lib/trace-cmd}/trace-filter-hash.c             | 0
 4 files changed, 2 insertions(+), 1 deletion(-)
 rename {kernel-shark/include => include/trace-cmd}/trace-filter-hash.h (100%)
 rename {kernel-shark => lib/trace-cmd}/trace-filter-hash.c (100%)

diff --git a/kernel-shark/include/trace-filter-hash.h b/include/trace-cmd/trace-filter-hash.h
similarity index 100%
rename from kernel-shark/include/trace-filter-hash.h
rename to include/trace-cmd/trace-filter-hash.h
diff --git a/kernel-shark/Makefile b/kernel-shark/Makefile
index 8576f3d18dbb..75e4184e5e6c 100644
--- a/kernel-shark/Makefile
+++ b/kernel-shark/Makefile
@@ -27,7 +27,7 @@ KS_VERSION := $(bdir)/include/ks_version.h
 
 GUI_TARGETS = $(KS_VERSION) $(bdir)/trace-graph $(bdir)/trace-view $(bdir)/kernelshark
 
-TRACE_GUI_OBJS = trace-filter.o trace-compat.o trace-filter-hash.o \
+TRACE_GUI_OBJS = trace-filter.o trace-compat.o \
 		 trace-dialog.o trace-xml.o
 TRACE_VIEW_OBJS = trace-view.o trace-view-store.o
 TRACE_GRAPH_OBJS = trace-graph.o trace-plot.o trace-plot-cpu.o trace-plot-task.o
diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index ee090990d9c2..44c1332d0d13 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -12,6 +12,7 @@ OBJS += trace-hooks.o
 OBJS += trace-input.o
 OBJS += trace-recorder.o
 OBJS += trace-util.o
+OBJS += trace-filter-hash.o
 
 # Additional util objects
 OBJS += trace-blk-hack.o
diff --git a/kernel-shark/trace-filter-hash.c b/lib/trace-cmd/trace-filter-hash.c
similarity index 100%
rename from kernel-shark/trace-filter-hash.c
rename to lib/trace-cmd/trace-filter-hash.c
-- 
2.17.1

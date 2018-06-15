Return-Path: <SRS0=1RmU=JB=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34629 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756331AbeFOVZL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 Jun 2018 17:25:11 -0400
Received: by mail-wr0-f196.google.com with SMTP id a12-v6so11187520wro.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 15 Jun 2018 14:25:10 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/4] trace-cmd: Header files management in trace-hash.h
Date: Sat, 16 Jun 2018 00:21:28 +0300
Message-Id: <20180615212131.28121-2-y.karadz@gmail.com>
In-Reply-To: <20180615212131.28121-1-y.karadz@gmail.com>
References: <20180615212131.28121-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

The unnecessary inclusion of trace-hash-local.h and list.h is
removed from trace-cmd/trace-hash.h, because this header file
is part of the public interface of the library.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 include/trace-cmd/trace-hash.h | 3 ---
 tracecmd/trace-hist.c          | 1 +
 tracecmd/trace-profile.c       | 2 ++
 tracecmd/trace-read.c          | 1 +
 4 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/trace-cmd/trace-hash.h b/include/trace-cmd/trace-hash.h
index 2529f4d..8cf0710 100644
--- a/include/trace-cmd/trace-hash.h
+++ b/include/trace-cmd/trace-hash.h
@@ -20,9 +20,6 @@
 #ifndef _TRACE_HASH_H
 #define _TRACE_HASH_H
 
-#include "trace-hash-local.h"
-#include "list.h"
-
 struct trace_hash_item {
 	struct trace_hash_item	*next;
 	struct trace_hash_item	*prev;
diff --git a/tracecmd/trace-hist.c b/tracecmd/trace-hist.c
index 2a2e780..7cd338c 100644
--- a/tracecmd/trace-hist.c
+++ b/tracecmd/trace-hist.c
@@ -28,6 +28,7 @@
 #include <getopt.h>
 #include <signal.h>
 
+#include "trace-hash-local.h"
 #include "trace-local.h"
 #include "list.h"
 
diff --git a/tracecmd/trace-profile.c b/tracecmd/trace-profile.c
index a2bb3fc..94ee453 100644
--- a/tracecmd/trace-profile.c
+++ b/tracecmd/trace-profile.c
@@ -28,6 +28,8 @@
 #endif
 #include "trace-local.h"
 #include "trace-hash.h"
+#include "trace-hash-local.h"
+#include "list.h"
 
 #include <linux/time64.h>
 
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 6360273..9177ff4 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -37,6 +37,7 @@
 
 #include "trace-local.h"
 #include "trace-hash.h"
+#include "trace-hash-local.h"
 #include "kbuffer.h"
 #include "list.h"
 
-- 
2.17.1

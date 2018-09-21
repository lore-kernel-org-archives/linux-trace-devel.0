Return-Path: <SRS0=4N8R=MD=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-by2nam01on0086.outbound.protection.outlook.com ([104.47.34.86]:33856
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728100AbeIUSTd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 21 Sep 2018 14:19:33 -0400
From: Slavomir Kaslev <kaslevs@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Remove unused <pthread.h> includes.
Date: Fri, 21 Sep 2018 15:30:27 +0300
Message-Id: <20180921123027.30405-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

There are several <pthread.h> includes lurking eventhough trace-cmd
makes no use of threading. This patch gets rid of them.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 tracecmd/trace-output.c  | 1 -
 tracecmd/trace-read.c    | 1 -
 tracecmd/trace-record.c  | 1 -
 tracecmd/trace-restore.c | 1 -
 tracecmd/trace-split.c   | 1 -
 5 files changed, 5 deletions(-)

diff --git a/tracecmd/trace-output.c b/tracecmd/trace-output.c
index ff7b198..e439c44 100644
--- a/tracecmd/trace-output.c
+++ b/tracecmd/trace-output.c
@@ -14,7 +14,6 @@
 #include <sys/stat.h>
 #include <sys/wait.h>
 #include <sys/mman.h>
-#include <pthread.h>
 #include <fcntl.h>
 #include <unistd.h>
 #include <ctype.h>
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 02f0ce8..35d70c3 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -14,7 +14,6 @@
 #include <sys/stat.h>
 #include <sys/wait.h>
 #include <sys/mman.h>
-#include <pthread.h>
 #include <fcntl.h>
 #include <signal.h>
 #include <unistd.h>
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 5a1d2a0..ce550a2 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -24,7 +24,6 @@
 #endif
 #endif
 #include <netdb.h>
-#include <pthread.h>
 #include <fcntl.h>
 #include <unistd.h>
 #include <ctype.h>
diff --git a/tracecmd/trace-restore.c b/tracecmd/trace-restore.c
index 1544cf2..b649cf4 100644
--- a/tracecmd/trace-restore.c
+++ b/tracecmd/trace-restore.c
@@ -14,7 +14,6 @@
 #include <sys/stat.h>
 #include <sys/wait.h>
 #include <sys/mman.h>
-#include <pthread.h>
 #include <fcntl.h>
 #include <signal.h>
 #include <unistd.h>
diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index cabcc3d..5b2fc4f 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -15,7 +15,6 @@
 #include <sys/stat.h>
 #include <sys/wait.h>
 #include <sys/mman.h>
-#include <pthread.h>
 #include <fcntl.h>
 #include <unistd.h>
 #include <ctype.h>
-- 
2.17.1

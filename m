Return-Path: <SRS0=0hTv=NZ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38859 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728000AbeKOBrE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 14 Nov 2018 20:47:04 -0500
Received: by mail-wm1-f68.google.com with SMTP id f2-v6so15141056wme.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 14 Nov 2018 07:43:18 -0800 (PST)
From: kaslevs@vmware.com
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Fix warnings reported by gcc 8.2
Date: Wed, 14 Nov 2018 17:43:10 +0200
Message-Id: <20181114154310.14649-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: Slavomir Kaslev <kaslevs@vmware.com>

Compiling trace-cmd with gcc 8.2 reports:

    str_error_r.c: In function ‘str_error_r’:
    str_error_r.c:24:3: warning: passing argument 1 to restrict-qualified parameter aliases with argument 5 [-Wrestrict]
       snprintf(buf, buflen, "INTERNAL ERROR: strerror_r(%d, %p, %zd)=%d", errnum, buf, buflen, err);
       ^~~~~~~~

since `snprintf` declares its first argument as __restrict but `buf` is also
passed as argument #5.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 lib/traceevent/str_error_r.c | 2 +-
 tracecmd/trace-read.c        | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/lib/traceevent/str_error_r.c b/lib/traceevent/str_error_r.c
index 503ae07..53c7206 100644
--- a/lib/traceevent/str_error_r.c
+++ b/lib/traceevent/str_error_r.c
@@ -21,6 +21,6 @@ char *str_error_r(int errnum, char *buf, size_t buflen)
 {
 	int err = strerror_r(errnum, buf, buflen);
 	if (err)
-		snprintf(buf, buflen, "INTERNAL ERROR: strerror_r(%d, %p, %zd)=%d", errnum, buf, buflen, err);
+		snprintf(buf, buflen, "INTERNAL ERROR: strerror_r(%d)=%d", errnum, err);
 	return buf;
 }
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index c406d66..1f91fff 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -386,7 +386,7 @@ static void add_pid_filter(const char *arg)
 static char *append_pid_filter(char *curr_filter, char *pid)
 {
 	char *filter;
-	int len;
+	int len, curr_len;
 
 #define FILTER_FMT "(common_pid==" __STR ")||(pid==" __STR ")||(next_pid==" __STR ")"
 
@@ -405,13 +405,13 @@ static char *append_pid_filter(char *curr_filter, char *pid)
 			die("Failed to allocate for filter %s", curr_filter);
 		sprintf(filter, ".*:" FILTER_FMT, pid, pid, pid);
 	} else {
-
-		len += strlen(curr_filter);
+		curr_len = strlen(curr_filter);
+		len += curr_len;
 
 		filter = realloc(curr_filter, len);
 		if (!filter)
 			die("realloc");
-		sprintf(filter, "%s||" FILTER_FMT, filter, pid, pid, pid);
+		sprintf(filter + curr_len, "||" FILTER_FMT, pid, pid, pid);
 	}
 
 	return filter;
-- 
2.19.1

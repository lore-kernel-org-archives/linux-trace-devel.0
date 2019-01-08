Return-Path: <linux-trace-devel-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33027 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727678AbfAHPA0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Jan 2019 10:00:26 -0500
Received: by mail-pf1-f193.google.com with SMTP id c123so2069724pfb.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 08 Jan 2019 07:00:26 -0800 (PST)
From: Slavomir Kaslev <kaslevs@vmware.com>
To: linux-trace-devel@vger.kernel.org
Cc: rostedt@goodmis.org, ykaradzhov@vmware.com, tstoyanov@vmware.com
Subject: [PATCH v2 2/6] trace-cmd: Fix warnings reported by gcc 8.2
Date: Tue,  8 Jan 2019 17:00:11 +0200
Message-Id: <20190108150015.21327-3-kaslevs@vmware.com>
In-Reply-To: <20190108150015.21327-1-kaslevs@vmware.com>
References: <20190108150015.21327-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Compiling trace-cmd with gcc 8.2 reports:

    trace-read.c: In function ‘append_pid_filter’:
    trace-read.c:414:3: warning: passing argument 1 to restrict-qualified parameter aliases with argument 3 [-Wrestrict]
       sprintf(filter, "%s||" FILTER_FMT, filter, pid, pid, pid);
       ^~~~~~~

since `snprintf` declares its first argument as __restrict but `buf` is also
passed as argument #5.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 tracecmd/trace-read.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

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

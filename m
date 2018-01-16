Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-wr0-f196.google.com ([209.85.128.196]:36904 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751628AbeAPTyw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Jan 2018 14:54:52 -0500
From: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        y.karadz@gmail.com,
        "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Subject: [PATCH v4 2/3] trace-cmd: Remove the die() call from read_proc()
Date: Tue, 16 Jan 2018 21:53:42 +0200
Message-Id: <20180116195343.12800-3-vladislav.valtchev@gmail.com>
In-Reply-To: <20180116195343.12800-1-vladislav.valtchev@gmail.com>
References: <20180116195343.12800-1-vladislav.valtchev@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

As trace-stack.c's read_proc() function is going to be used by trace-cmd stat,
we don't want it to make the program die in case something went wrong.
Therefore, this simple patch makes read_proc() to just return -1 in case the
proc file was empty or read() failed with an error, instead of using die().

Signed-off-by: Vladislav Valtchev (VMware) <vladislav.valtchev@gmail.com>
---
 trace-stack.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/trace-stack.c b/trace-stack.c
index fada62d..3e1e41b 100644
--- a/trace-stack.c
+++ b/trace-stack.c
@@ -79,7 +79,7 @@ static int read_proc(int *status)
 	close(fd);
 
 	if (n <= 0)
-		die("error reading %s", PROC_FILE);
+		return -1;
 
 	if (n >= sizeof(buf))
 		return -1;
@@ -101,6 +101,7 @@ static void change_stack_tracer_status(unsigned new_status)
 {
 	char buf[1];
 	int status;
+	int ret;
 	int fd;
 	int n;
 
@@ -109,7 +110,11 @@ static void change_stack_tracer_status(unsigned new_status)
 		return;
 	}
 
-	if (read_proc(&status) > 0 && status == new_status)
+	ret = read_proc(&status);
+	if (ret < 0)
+		die("error reading %s", PROC_FILE);
+
+	if (ret > 0 && status == new_status)
 		return; /* nothing to do */
 
 	fd = open(PROC_FILE, O_WRONLY);
-- 
2.14.1

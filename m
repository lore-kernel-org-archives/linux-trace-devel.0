Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-wr0-f196.google.com ([209.85.128.196]:46007 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751280AbeAPTyv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Jan 2018 14:54:51 -0500
From: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        y.karadz@gmail.com,
        "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Subject: [PATCH v4 1/3] trace-cmd: Make read_proc() to return int status via OUT arg
Date: Tue, 16 Jan 2018 21:53:41 +0200
Message-Id: <20180116195343.12800-2-vladislav.valtchev@gmail.com>
In-Reply-To: <20180116195343.12800-1-vladislav.valtchev@gmail.com>
References: <20180116195343.12800-1-vladislav.valtchev@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch changes both the implementation and the interface of read_proc()
in trace-stack.c. First, it makes the function to read a string from the proc
file and then parse it as an integer using strtol(). Then, it makes the function
to return the integer read from the proc file using the int *status OUT
parameter, in order to make possible its return value to be used by the caller
to check if the operation succeeded.

This new implementation relaxes the external contraints the function relies on,
making it possible to be used by trace stat. The point is that 'stat' should not
fail in case there is something wrong with the stack tracer. Only the call to
die() in case the file is empty has been left in this patch: it will be removed
as well in a separate commit.

Signed-off-by: Vladislav Valtchev (VMware) <vladislav.valtchev@gmail.com>
---
 trace-stack.c | 72 ++++++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 57 insertions(+), 15 deletions(-)

diff --git a/trace-stack.c b/trace-stack.c
index aa79ae3..fada62d 100644
--- a/trace-stack.c
+++ b/trace-stack.c
@@ -20,6 +20,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <limits.h>
 #include <getopt.h>
 #include <sys/types.h>
 #include <sys/stat.h>
@@ -49,37 +50,74 @@ static void test_available(void)
 		die("stack tracer not configured on running kernel");
 }
 
-static char read_proc(void)
+/*
+ * Returns:
+ *   -1 - Something went wrong
+ *    0 - File does not exist (stack tracer not enabled)
+ *    1 - Success
+ */
+static int read_proc(int *status)
 {
-	char buf[1];
+	struct stat stat_buf;
+	char buf[64];
+	long num;
 	int fd;
 	int n;
 
+	if (stat(PROC_FILE, &stat_buf) < 0) {
+		/* stack tracer not configured on running kernel */
+		*status = 0; /* not configured means disabled */
+		return 0;
+	}
+
 	fd = open(PROC_FILE, O_RDONLY);
+
 	if (fd < 0)
-		die("reading %s", PROC_FILE);
-	n = read(fd, buf, 1);
+		return -1;
+
+	n = read(fd, buf, sizeof(buf));
 	close(fd);
-	if (n != 1)
+
+	if (n <= 0)
 		die("error reading %s", PROC_FILE);
 
-	return buf[0];
+	if (n >= sizeof(buf))
+		return -1;
+
+	buf[n] = 0;
+	errno = 0;
+	num = strtol(buf, NULL, 10);
+
+	/* Check for various possible errors */
+	if (num > INT_MAX || num < INT_MIN || (!num && errno))
+		return -1;
+
+	*status = num;
+	return 1; /* full success */
 }
 
-static void start_stop_trace(char val)
+/* NOTE: this implementation only accepts new_status in the range [0..9]. */
+static void change_stack_tracer_status(unsigned new_status)
 {
 	char buf[1];
+	int status;
 	int fd;
 	int n;
 
-	buf[0] = read_proc();
-	if (buf[0] == val)
+	if (new_status > 9) {
+		warning("invalid status %d\n", new_status);
 		return;
+	}
+
+	if (read_proc(&status) > 0 && status == new_status)
+		return; /* nothing to do */
 
 	fd = open(PROC_FILE, O_WRONLY);
 	if (fd < 0)
 		die("writing %s", PROC_FILE);
-	buf[0] = val;
+
+	buf[0] = new_status + '0';
+
 	n = write(fd, buf, 1);
 	if (n < 0)
 		die("writing into %s", PROC_FILE);
@@ -88,12 +126,12 @@ static void start_stop_trace(char val)
 
 static void start_trace(void)
 {
-	start_stop_trace('1');
+	change_stack_tracer_status(1);
 }
 
 static void stop_trace(void)
 {
-	start_stop_trace('0');
+	change_stack_tracer_status(0);
 }
 
 static void reset_trace(void)
@@ -118,13 +156,17 @@ static void reset_trace(void)
 
 static void read_trace(void)
 {
-	FILE *fp;
-	char *path;
 	char *buf = NULL;
+	int status;
+	char *path;
+	FILE *fp;
 	size_t n;
 	int r;
 
-	if (read_proc() == '1')
+	if (read_proc(&status) <= 0)
+		die("Invalid stack tracer state");
+
+	if (status > 0)
 		printf("(stack tracer running)\n");
 	else
 		printf("(stack tracer not running)\n");
-- 
2.14.1

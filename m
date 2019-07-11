Return-Path: <SRS0=ayt5=VI=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88239C74A35
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Jul 2019 13:03:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D8F221019
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Jul 2019 13:03:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HHLxh+6I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728597AbfGKNDV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Jul 2019 09:03:21 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38626 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728645AbfGKNDV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Jul 2019 09:03:21 -0400
Received: by mail-wr1-f68.google.com with SMTP id g17so6220742wrr.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Jul 2019 06:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bQBV9G+B2hAmMg3gfg98ZAsN206h3AQ53nVV5eoKMtE=;
        b=HHLxh+6Io3qO4btvPodOmQncqO+eeN6uA/mMbJiujPBgbzlp5nKM6ybvwtf+x3TPNc
         hmzmIzECXeRQiYPR6wfjMoqcREJCrijQSJFj/ULyyN6RqXorBKcODopPlQjAZKbCy+Pv
         I71c+we1Zxrf16AOt5sJVCaEVpz970Vo1596UyfByhORaGf4mUag7HVbOXybHAsdoOzE
         17ZzMN+VRpaFR4BXob4dXOOqbctnFCeU/VZOC2TU6XxDp7Q+ei10BpKKYyD2qQL2J6k3
         zB6zBvSGkW9DAjyjzoeOf1UG1rXzwRuE0HR609R9avSz3xiBg8li/Ycr1ahoclfihFIL
         3i+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bQBV9G+B2hAmMg3gfg98ZAsN206h3AQ53nVV5eoKMtE=;
        b=A5eoxzQWcwFkpsWygh+QHp8GTWHgi1m/W5GZ8btVaGVGU1CJGhfTgsRKxl74L1Mq6/
         bKBW9JFL2QNn3vS64/vpl0oq5UNCwQvNZru/9wnfK3PQl0TzYkbQ6M2mNm3EhjtESN7R
         A8m08Vt80262woMKKSyO3mZ+OYHI4Sufoj7unOQmCjlhEqhqJXyGf3Vb7emmOWPM6vXI
         JlFa8Ll/475T0hWg9ak9aO4tCSDf/EU2LLTXjr9+1suNPRKxh8UIjbyXjOE6NJ8UKvAu
         xTbsGtO4i0Z0ZZ0cWAt+/pq/2Y+FgBxrRcOenzsUoBeqGey8Yr+VT5vhK8Y1Fxo7iI7U
         JUzA==
X-Gm-Message-State: APjAAAVi/WT7YugitqBviLlNrKo8grU296DPo/EDFt8Cb4xHGjR4ZobJ
        AHQyZG7bbxMBlb9/4k81AoSISBbX
X-Google-Smtp-Source: APXvYqwLa3fD/lX4K8dQSoYtE1P5rSPbIAmQigEcj5MiTFlR8VW3HIf7DQt7xHfDIYIWMo4cGyzOyQ==
X-Received: by 2002:a5d:53c2:: with SMTP id a2mr5385856wrw.8.1562850198654;
        Thu, 11 Jul 2019 06:03:18 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id h6sm4642590wre.82.2019.07.11.06.03.17
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 11 Jul 2019 06:03:17 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 7/7] trace-cmd: Move tracecmd_stack_tracer_status() function to libtracecmd
Date:   Thu, 11 Jul 2019 16:03:07 +0300
Message-Id: <20190711130307.25041-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190711130307.25041-1-tz.stoyanov@gmail.com>
References: <20190711130307.25041-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

tracecmd_stack_tracer_status() function reads the stack tracer status
from the proc file system. It does not depend on trace-cmd context and
can be used standalone. The function is moved from trace-cmd application
into libtracecmd.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-util.c | 49 +++++++++++++++++++++++++++++++++
 tracecmd/trace-stack.c     | 56 ++------------------------------------
 2 files changed, 51 insertions(+), 54 deletions(-)

diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 8c1a0a0..d16a018 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -25,6 +25,7 @@
 #define LOCAL_PLUGIN_DIR ".trace-cmd/plugins"
 #define TRACEFS_PATH "/sys/kernel/tracing"
 #define DEBUGFS_PATH "/sys/kernel/debug"
+#define PROC_STACK_FILE "/proc/sys/kernel/stack_tracer_enabled"
 
 int tracecmd_disable_sys_plugins;
 int tracecmd_disable_plugins;
@@ -1787,3 +1788,51 @@ int trace_set_log_file(char *logfile)
 	return 0;
 }
 
+/**
+ * tracecmd_stack_tracer_status - Check stack trace status
+ * @status: Returned stack trace status:
+ *		0 - not configured, disabled
+ *		non 0 - enabled
+ *
+ * Returns -1 in case of an error, 0 if file does not exist
+ *  (stack tracer not enabled) or 1 on successful completion.
+ */
+int tracecmd_stack_tracer_status(int *status)
+{
+	struct stat stat_buf;
+	char buf[64];
+	long num;
+	int fd;
+	int n;
+
+	if (stat(PROC_STACK_FILE, &stat_buf) < 0) {
+		/* stack tracer not configured on running kernel */
+		*status = 0; /* not configured means disabled */
+		return 0;
+	}
+
+	fd = open(PROC_STACK_FILE, O_RDONLY);
+
+	if (fd < 0)
+		return -1;
+
+	n = read(fd, buf, sizeof(buf));
+	close(fd);
+
+	if (n <= 0)
+		return -1;
+
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
+}
diff --git a/tracecmd/trace-stack.c b/tracecmd/trace-stack.c
index 34b3b58..bb002c0 100644
--- a/tracecmd/trace-stack.c
+++ b/tracecmd/trace-stack.c
@@ -36,58 +36,6 @@ static void test_available(void)
 		die("stack tracer not configured on running kernel");
 }
 
-/*
- * Returns:
- *   -1 - Something went wrong
- *    0 - File does not exist (stack tracer not enabled)
- *    1 - Success
- */
-static int read_proc(int *status)
-{
-	struct stat stat_buf;
-	char buf[64];
-	long num;
-	int fd;
-	int n;
-
-	if (stat(PROC_FILE, &stat_buf) < 0) {
-		/* stack tracer not configured on running kernel */
-		*status = 0; /* not configured means disabled */
-		return 0;
-	}
-
-	fd = open(PROC_FILE, O_RDONLY);
-
-	if (fd < 0)
-		return -1;
-
-	n = read(fd, buf, sizeof(buf));
-	close(fd);
-
-	if (n <= 0)
-		return -1;
-
-	if (n >= sizeof(buf))
-		return -1;
-
-	buf[n] = 0;
-	errno = 0;
-	num = strtol(buf, NULL, 10);
-
-	/* Check for various possible errors */
-	if (num > INT_MAX || num < INT_MIN || (!num && errno))
-		return -1;
-
-	*status = num;
-	return 1; /* full success */
-}
-
-/* Public wrapper of read_proc() */
-int tracecmd_stack_tracer_status(int *status)
-{
-	return read_proc(status);
-}
-
 /* NOTE: this implementation only accepts new_status in the range [0..9]. */
 static void change_stack_tracer_status(unsigned new_status)
 {
@@ -102,7 +50,7 @@ static void change_stack_tracer_status(unsigned new_status)
 		return;
 	}
 
-	ret = read_proc(&status);
+	ret = tracecmd_stack_tracer_status(&status);
 	if (ret < 0)
 		die("error reading %s", PROC_FILE);
 
@@ -160,7 +108,7 @@ static void read_trace(void)
 	size_t n;
 	int r;
 
-	if (read_proc(&status) <= 0)
+	if (tracecmd_stack_tracer_status(&status) <= 0)
 		die("Invalid stack tracer state");
 
 	if (status > 0)
-- 
2.21.0


Return-Path: <SRS0=NxYB=W6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AAE9C3A5A7
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Sep 2019 13:34:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FD3C23431
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Sep 2019 13:34:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hRA8P6DC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725782AbfICNex (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Sep 2019 09:34:53 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45136 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729079AbfICNew (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Sep 2019 09:34:52 -0400
Received: by mail-wr1-f67.google.com with SMTP id q12so17484700wrj.12
        for <linux-trace-devel@vger.kernel.org>; Tue, 03 Sep 2019 06:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Voz7nvReBY24TLcA5RUoWGWvD5uFPu6TGoUNfcBjLiM=;
        b=hRA8P6DCtBCaAiCtZuUkO+0FylmaIXPBwwZU1qykvhbHWFJVKUPhOCsqkAwgupg9Fo
         cx32M4peoNkNitJYin3z3rKR0zgfC5+TCieqZa6mNxyxzBZ2nDX1Ci5FnZXr9LvWB4j2
         fWm3/9FDLu/C9qBmQAF+3Ooo2P3gLHxeAiP75ifulRglUF5TPO7zzvWgc/h2aACWYEnB
         q6Elf3A4Ayqvi1WTh04d7IhleWiX3y3OGvM6JcgdpSPNilq+sVrLLmP4wV8QBNqHbB2E
         1sa0XJ2eMTRtMy1btytwoJXsYSafpm0/gWxXogtDX9Ehx5H0aKJuTbYHD+WDaL3Rqs0A
         F99w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Voz7nvReBY24TLcA5RUoWGWvD5uFPu6TGoUNfcBjLiM=;
        b=HmXZJh/IeSOnpHe077z6vpK1a8Z8UTKd4Gx3s+W12jrJ46IgBzVEnoELTZD7IJxpTZ
         od6jPU9h6LN0pD/KZzWXZIYWIVs9+To5DOH+27kaME/KHNVY3mtsmmQpUks8j+o4+h8p
         V2Fl8GPcf4u6lHShuPYi5VkQZvNPy+9le+0IE7a0K94Qbs7KcFS08YZUOa74Dht2V2/P
         R8JNmckSgdWe7MohTE2fhIxlqJ+sAWjGN3A88HVZ6bKQdLlrWls3lEXB5c3mQwTS2l0x
         DAAexOy610iPZ9Qiwp7G3Nq4EdtUbLovVjuvWns5+I9kerCbdzX1SsJh92fIIlMWRHJl
         Vq5A==
X-Gm-Message-State: APjAAAW0M4YIZxissxE3tTiF4jjsTcWEejTw+8GbVFbpTdaYmE8VUVfg
        T0w3s7E3A+N/kycjwitEp4DOuVxJ
X-Google-Smtp-Source: APXvYqxkN3zzYhzAshh11zYVokpWaJUBUPqgHebX9kfkrdd9QjiMju/ivSMfTTHqANDIr5/fD2+MyA==
X-Received: by 2002:a5d:574c:: with SMTP id q12mr14323600wrw.69.1567517690026;
        Tue, 03 Sep 2019 06:34:50 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id r16sm33509833wrc.81.2019.09.03.06.34.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 06:34:49 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 3/4] trace-cmd: Move tracecmd_stack_tracer_status() function to libtracecmd
Date:   Tue,  3 Sep 2019 16:34:44 +0300
Message-Id: <20190903133445.30486-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190903133445.30486-1-tz.stoyanov@gmail.com>
References: <20190903133445.30486-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-util.c | 51 ++++++++++++++++++++++++++++++++++
 tracecmd/trace-stack.c     | 56 ++------------------------------------
 2 files changed, 53 insertions(+), 54 deletions(-)

diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 60bcb68..6e2a352 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -25,6 +25,7 @@
 #define LOCAL_PLUGIN_DIR ".trace-cmd/plugins"
 #define TRACEFS_PATH "/sys/kernel/tracing"
 #define DEBUGFS_PATH "/sys/kernel/debug"
+#define PROC_STACK_FILE "/proc/sys/kernel/stack_tracer_enabled"
 
 int tracecmd_disable_sys_plugins;
 int tracecmd_disable_plugins;
@@ -1765,3 +1766,53 @@ int tracecmd_set_logfile(char *logfile)
 		return -1;
 	return 0;
 }
+
+/**
+ * tracecmd_stack_tracer_status - Check stack trace status
+ * @status: Returned stack trace status:
+ *             0 - not configured, disabled
+ *             non 0 - enabled
+ *
+ * Returns -1 in case of an error, 0 if file does not exist
+ * (stack tracer not configured in kernel) or 1 on successful completion.
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
+
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


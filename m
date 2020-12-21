Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E7A7C433DB
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Dec 2020 06:52:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EA8622273
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Dec 2020 06:52:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725897AbgLUGvr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Dec 2020 01:51:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbgLUGvr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Dec 2020 01:51:47 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAFCEC0613D3
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Dec 2020 22:51:06 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id p22so8513117edu.11
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Dec 2020 22:51:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h+J0rzeWl88CHAsL5wX64MsZ88LJRf9QlWL4ATXXYHU=;
        b=RThk9Nqb4KheeLeTMZx9bT2DS1gUScfprontznq3mi/WU9sGAyQl9qn+3O46PtJcQ3
         LmMST4cQr1/BB0TojK+jVn9XFsq/wnQJxN1cnqfBk3+SQgdaQf7v0AFuzZp/tY3RMPdD
         3UjsxStxLH9GPKJxpFsB2w5nq//IRUjiQHJxJnhauKmrx9qMsNIkhL0q4kR9Ja3qrgcr
         Ez4fiUuK1dBmFJveaBbOp9OwWQHkQinOqvIfBy3h9mdmUSnHx8XpQCtjTPyN1i6c8uH5
         oa5ZzP2KYJjr4HQtsnhzKy9KAYRvzph670kmvKVZPX4Hb8Mk6SXCy4DnseU8iMhKb7D+
         sCwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h+J0rzeWl88CHAsL5wX64MsZ88LJRf9QlWL4ATXXYHU=;
        b=hcdnSvHHDa6y49HddaOMusaMsrfpG4xstcf5+fAbnofGq1xNjglaSyPzjhAgX1syrz
         HIaj7PhBfduymh9olSmMbSGrbsIqZkuAqMMCvwvoRQiJDHsirww5o+i2vC9wnwQTs6pg
         wI9HO2A3eA41WsT2uZMOCCha4Ca8tYb4XbGAI3Sf80EreV26F2YjiMGsRY3C/iGDTuH3
         Dr2YGiYX/u7xFYviy424SF5TjnaFRSjraEaAIb8UJK6om8nJ3m3VnOIdqd/TpSFsAvp/
         0YgZAM/uxQ+yHAGTdj4uuLURpIAPZSltATLWyiodJ2ZZr4OfI/PcaaBr/En/2j7sg6qa
         FsMw==
X-Gm-Message-State: AOAM5320/M9X9EpMG9yDf33yiD7tMxPFtPpwztt0uxgwzHggePNOTH77
        CRY42N+GQywsP4hIb/9+bWA85rpnrNov2e/h
X-Google-Smtp-Source: ABdhPJzVvQCObeW5AOSNgBdgZsDVCnP3VD0bzgezwy+YesevX1EMDMLkU/fvS51rf+WifS7tfD6arQ==
X-Received: by 2002:a05:6402:254a:: with SMTP id l10mr7470269edb.264.1608533465723;
        Sun, 20 Dec 2020 22:51:05 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id t9sm398001ejc.51.2020.12.20.22.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Dec 2020 22:51:04 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Use tracefs_tracing_dir() instead of tracefs_find_tracing_dir()
Date:   Mon, 21 Dec 2020 08:51:03 +0200
Message-Id: <20201221065103.199777-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The tracefs_find_tracing_dir() and tracefs_tracing_dir() are
consolidated. All usage of tracefs_find_tracing_dir() are replaced with
calls to tracefs_tracing_dir().

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs/tracefs.h           |  3 ---
 lib/trace-cmd/trace-output.c        |  7 +++++--
 lib/tracefs/include/tracefs-local.h |  2 ++
 lib/tracefs/tracefs-instance.c      |  2 +-
 lib/tracefs/tracefs-utils.c         |  8 ++++----
 tracecmd/trace-record.c             | 19 ++++++++++++-------
 utest/tracefs-utest.c               |  9 ---------
 7 files changed, 24 insertions(+), 26 deletions(-)

diff --git a/include/tracefs/tracefs.h b/include/tracefs/tracefs.h
index 8308e3ac..9a99ad6c 100644
--- a/include/tracefs/tracefs.h
+++ b/include/tracefs/tracefs.h
@@ -15,9 +15,6 @@ void tracefs_put_tracing_file(char *name);
 /* The returned string must *not* be freed */
 const char *tracefs_tracing_dir(void);
 
-/* tracefs_find_tracing_dir must be freed */
-char *tracefs_find_tracing_dir(void);
-
 /* ftarce instances */
 struct tracefs_instance;
 
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index cd7dcec8..de76e3e7 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -240,9 +240,12 @@ static tsize_t copy_file(struct tracecmd_output *handle,
  */
 static const char *find_tracing_dir(struct tracecmd_output *handle)
 {
-	if (!handle->tracing_dir)
-		handle->tracing_dir = tracefs_find_tracing_dir();
+	if (!handle->tracing_dir) {
+		const char *dir = tracefs_tracing_dir();
 
+		if (dir)
+			handle->tracing_dir = strdup(dir);
+	}
 	return handle->tracing_dir;
 }
 
diff --git a/lib/tracefs/include/tracefs-local.h b/lib/tracefs/include/tracefs-local.h
index bdbf89e8..c222fe4f 100644
--- a/lib/tracefs/include/tracefs-local.h
+++ b/lib/tracefs/include/tracefs-local.h
@@ -13,6 +13,8 @@ void warning(const char *fmt, ...);
 int str_read_file(const char *file, char **buffer);
 char *trace_append_file(const char *dir, const char *name);
 
+char *trace_find_tracing_dir(void);
+
 #ifndef ACCESSPERMS
 #define ACCESSPERMS (S_IRWXU|S_IRWXG|S_IRWXO) /* 0777 */
 #endif
diff --git a/lib/tracefs/tracefs-instance.c b/lib/tracefs/tracefs-instance.c
index e9e24ef8..bf3de7cc 100644
--- a/lib/tracefs/tracefs-instance.c
+++ b/lib/tracefs/tracefs-instance.c
@@ -210,7 +210,7 @@ char *tracefs_instance_get_dir(struct tracefs_instance *instance)
 		path = tracefs_get_tracing_file(buf);
 		free(buf);
 	} else
-		path = tracefs_find_tracing_dir();
+		path = trace_find_tracing_dir();
 
 	return path;
 }
diff --git a/lib/tracefs/tracefs-utils.c b/lib/tracefs/tracefs-utils.c
index 8483cb61..acfcacf7 100644
--- a/lib/tracefs/tracefs-utils.c
+++ b/lib/tracefs/tracefs-utils.c
@@ -60,12 +60,12 @@ static int mount_debugfs(void)
 }
 
 /**
- * tracefs_find_tracing_dir - Find tracing directory
+ * trace_find_tracing_dir - Find tracing directory
  *
  * Returns string containing the full path to the system's tracing directory.
  * The string must be freed by free()
  */
-char *tracefs_find_tracing_dir(void)
+char *trace_find_tracing_dir(void)
 {
 	char *debug_str = NULL;
 	char fspath[PATH_MAX+1];
@@ -143,7 +143,7 @@ const char *tracefs_tracing_dir(void)
 	if (tracing_dir)
 		return tracing_dir;
 
-	tracing_dir = tracefs_find_tracing_dir();
+	tracing_dir = trace_find_tracing_dir();
 	return tracing_dir;
 }
 
@@ -166,7 +166,7 @@ char *tracefs_get_tracing_file(const char *name)
 		return NULL;
 
 	if (!tracing) {
-		tracing = tracefs_find_tracing_dir();
+		tracing = trace_find_tracing_dir();
 		if (!tracing)
 			return NULL;
 	}
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index e2d1cedf..ade52421 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -450,13 +450,11 @@ static int __add_all_instances(const char *tracing_dir)
  */
 void add_all_instances(void)
 {
-	char *tracing_dir = tracefs_find_tracing_dir();
+	const char *tracing_dir = tracefs_tracing_dir();
 	if (!tracing_dir)
-		die("malloc");
+		die("can't get the tracing directory");
 
 	__add_all_instances(tracing_dir);
-
-	tracefs_put_tracing_file(tracing_dir);
 }
 
 /**
@@ -3539,10 +3537,17 @@ static int create_recorder(struct buffer_instance *instance, int cpu,
 		}
 		if (fd < 0)
 			die("Failed connecting to client");
-		if (tracefs_instance_get_name(instance->tracefs) && !is_agent(instance))
+		if (tracefs_instance_get_name(instance->tracefs) && !is_agent(instance)) {
 			path = tracefs_instance_get_dir(instance->tracefs);
-		else
-			path = tracefs_find_tracing_dir();
+		} else {
+			const char *dir = tracefs_tracing_dir();
+
+			if (dir)
+				path = strdup(path);
+		}
+		if (!path)
+			die("can't get the tracing directory");
+
 		recorder = tracecmd_create_buffer_recorder_fd(fd, cpu, flags, path);
 		tracefs_put_tracing_file(path);
 	} else {
diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 4a622d59..9c9eee06 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -162,21 +162,12 @@ static void test_trace_file(void)
 	const char *tdir;
 	struct stat st;
 	char *file;
-	char *dir;
-
-	dir = tracefs_find_tracing_dir();
-	CU_TEST(dir != NULL);
-	CU_TEST(stat(dir, &st) == 0);
-	CU_TEST(S_ISDIR(st.st_mode));
 
 	tdir  = tracefs_tracing_dir();
 	CU_TEST(tdir != NULL);
 	CU_TEST(stat(tdir, &st) == 0);
 	CU_TEST(S_ISDIR(st.st_mode));
 
-	CU_TEST(strcmp(dir, tdir) == 0);
-	free(dir);
-
 	file = tracefs_get_tracing_file(NULL);
 	CU_TEST(file == NULL);
 	file = tracefs_get_tracing_file(tmp);
-- 
2.28.0


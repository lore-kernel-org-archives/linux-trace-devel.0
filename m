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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67B4EC433DB
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Dec 2020 05:07:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E06B23122
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Dec 2020 05:07:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbgLVFHd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Dec 2020 00:07:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbgLVFHc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Dec 2020 00:07:32 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2589CC0617A6
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Dec 2020 21:06:52 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id q75so933088wme.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Dec 2020 21:06:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h+J0rzeWl88CHAsL5wX64MsZ88LJRf9QlWL4ATXXYHU=;
        b=ITnlpb/iJh/gwP+Oe1xJFvcsVsvzz++uKj5z/V6cVICUcqPCKtHvGpCV484QME0wii
         jIGwkUmSi8Xx4blHQE9NUL4mVljoBme4a/ouB3d4zdriom9GiIUXU05PrMpU4Gz8zZxG
         UaiPeFIdD1wjVqVijIUl9Z6EsidRK3tHMyAOCjDmtPsNQKXuCKsnkoVV+DQt/5qEGVuT
         J8UlqOyQAvuGIyPJC+OojGPhpddMiCTS2vVDYPk96AxErgRPsIzNS6Anr/eatTwKIm9a
         lswwECQs2z4TOv+/kZBXTTdm2zmmRIxZz9/EatnH/x5HMwp2rHx5z1E4OFzJ98PKPXr4
         /FzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h+J0rzeWl88CHAsL5wX64MsZ88LJRf9QlWL4ATXXYHU=;
        b=FyqRQ5uWRYaX+4b0QMqsf8vh+25RS2BCqYXbN45o1FshKIqSZYg97TtqNBU57bg8sX
         puFKrXNVrm2FG5LZtIzf4j2xNrbj/FJigRUPhb/GJa6HEkrGX5de/OyLFVVMS2TXgEqf
         SZ4IANjedjO9Fk1AL9kGLI7OEKxka4j0SBFAb9CossnLV95BfEzFv2Yf2MPOLLFWqIyV
         +AvuY2Zr7atmbMsch/aP7A7+58mYMJOXfIeo1UR8OMEORCPxutnupI/N0y4QhFCRYN1W
         +zLeJCsd4UIl3wEMeln3dQZKFpCqIXBS5JYcyC2pmDF2J7dKx7jMwzVHXkGdffseX/KI
         /jXA==
X-Gm-Message-State: AOAM533w50XpsimbXU9I2JLN01TK6/6hrXvtYSm2WZkO9jkLd7WPJg5h
        WPpYuIb6P0L1kPkDFfab0uJn1W7jmYhdY0d5
X-Google-Smtp-Source: ABdhPJxxz+mMSgv0ey1Nfuxc8gxoUs7YiEEvt+zeyX+HBzWs7F+8mNZtqIcGvuzAj8veMGakE39NMQ==
X-Received: by 2002:a7b:cd91:: with SMTP id y17mr19183892wmj.171.1608613610194;
        Mon, 21 Dec 2020 21:06:50 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n8sm28828686wrs.34.2020.12.21.21.06.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 21:06:49 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/2] trace-cmd: Use tracefs_tracing_dir() instead of tracefs_find_tracing_dir()
Date:   Tue, 22 Dec 2020 07:06:46 +0200
Message-Id: <20201222050646.375340-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201222050646.375340-1-tz.stoyanov@gmail.com>
References: <20201222050646.375340-1-tz.stoyanov@gmail.com>
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


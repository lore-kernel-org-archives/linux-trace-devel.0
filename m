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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC378C433DB
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Dec 2020 06:03:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABD9422513
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Dec 2020 06:03:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbgLUGD5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Dec 2020 01:03:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725984AbgLUGD5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Dec 2020 01:03:57 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4FDBC061285
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Dec 2020 22:02:45 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id 6so11792516ejz.5
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Dec 2020 22:02:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RerauUTUQ8QMaI9TOtv0AAAxauDTiARmBus7H+mRd0U=;
        b=G2w4P3WF9OO58+IsVTSmWiB+sS7Kjl4fOmXDu/R3Z8ebnmrp14mbGBhyKxjCLenNwJ
         cJ7CkRq6l4/5ju1r0stfchSlCFwLdaQB1JvO9WWGTerUHVSAfMem6dsbaR8ldeQxgstk
         trsdD/5BYqYS9ncMR08GOzd1Bo2W/pH6B2QDj+64NJkoYpbhEFgsEflMXzYQJETzDDnY
         WLIugR7zJX/9POzVODoSja1eo5EgAfaloQ8ebTVVVjW1PZdu7NoU6mOHNdCrwzAjmgD3
         eVTqyQZ2DcOOOkHwcERVOG0ij+zJAtf3QOhsfv9vUlWG2lae9mohZ4epK/sGE6cx27hA
         O4nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RerauUTUQ8QMaI9TOtv0AAAxauDTiARmBus7H+mRd0U=;
        b=K6qX9retIr1phOpPMesreyjWuszv7B8XMDo3/T3xng03KdoK9btG4GAXBCKOCna4LW
         Dt05XB2ZsBU1Y9rcaTGLEZpuqkd8xCo5nHnC5IgNuIunYND9par97p+IqDIxJk/aEDlp
         xzjn6eg9dVyhKrWcgNU8Cih/Db437MCFD0qmy4E8ZgCEn49j+SsAVOQ8fdQQ3T8VEBJs
         gWozH0hbTCceDDjmFgDCfue/7ZQ/t0lckeC+8Ykx73TEvKo0WxOD6jN9Vqsc/wkkG1K6
         L5rJK7ZTPbPlLv/Ui5AFSS5a2qEMT8yvKqUPxVTWB4ATE7GAwHzcw9rsTNmoQ0tsPeqK
         rWGw==
X-Gm-Message-State: AOAM531qcRfadcZ7d24lrCYRQGvApIe7jhGvAQd+bEgZtnv9evcwcvA3
        9ulfPJHcrR0JLH8r954NpNiSz0DqRo4yokTM
X-Google-Smtp-Source: ABdhPJwW6glkqgFjvJ7gobtH+6URPO8X4GblDhUoVy6ryaVc7qpZLnbi55sETHgnKKt3RzHeaXBPIw==
X-Received: by 2002:a17:906:edc8:: with SMTP id sb8mr14048176ejb.247.1608530564467;
        Sun, 20 Dec 2020 22:02:44 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id i8sm27706247eds.72.2020.12.20.22.02.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Dec 2020 22:02:43 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/2] libtracefs: Remove tracefs_find_tracing_dir() API
Date:   Mon, 21 Dec 2020 08:02:40 +0200
Message-Id: <20201221060241.177767-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201221060241.177767-1-tz.stoyanov@gmail.com>
References: <20201221060241.177767-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

There are two APIs to get the tracefs mount point:
tracefs_get_tracing_dir() and tracefs_find_tracing_dir().
The only difference between them is that the first returns
a static cashed string and the second a newly allocated string.
In order not to confused the users with too many APIs that do
the same, the tracefs_find_tracing_dir() is removed as an API,
renamed to trace_find_tracing_dir() and is used only as library
internal function.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs-local.h | 2 ++
 include/tracefs.h       | 3 ---
 src/tracefs-instance.c  | 2 +-
 src/tracefs-utils.c     | 8 ++++----
 utest/tracefs-utest.c   | 9 ---------
 5 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/include/tracefs-local.h b/include/tracefs-local.h
index bdbf89e..3a7ec32 100644
--- a/include/tracefs-local.h
+++ b/include/tracefs-local.h
@@ -10,8 +10,10 @@
 
 /* Can be overridden */
 void warning(const char *fmt, ...);
+
 int str_read_file(const char *file, char **buffer);
 char *trace_append_file(const char *dir, const char *name);
+char *trace_find_tracing_dir(void);
 
 #ifndef ACCESSPERMS
 #define ACCESSPERMS (S_IRWXU|S_IRWXG|S_IRWXO) /* 0777 */
diff --git a/include/tracefs.h b/include/tracefs.h
index 5cbe898..ae4ffa0 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -15,9 +15,6 @@ void tracefs_put_tracing_file(char *name);
 /* tracefs_get_tracing_dir must *not* be freed */
 const char *tracefs_get_tracing_dir(void);
 
-/* tracefs_find_tracing_dir must be freed */
-char *tracefs_find_tracing_dir(void);
-
 /* ftrace instances */
 struct tracefs_instance;
 
diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index e9e24ef..bf3de7c 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -210,7 +210,7 @@ char *tracefs_instance_get_dir(struct tracefs_instance *instance)
 		path = tracefs_get_tracing_file(buf);
 		free(buf);
 	} else
-		path = tracefs_find_tracing_dir();
+		path = trace_find_tracing_dir();
 
 	return path;
 }
diff --git a/src/tracefs-utils.c b/src/tracefs-utils.c
index 326b455..e9d2b0b 100644
--- a/src/tracefs-utils.c
+++ b/src/tracefs-utils.c
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
@@ -143,7 +143,7 @@ const char *tracefs_get_tracing_dir(void)
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
diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 941b9cf..965f1ec 100644
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
 
 	tdir  = tracefs_get_tracing_dir();
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


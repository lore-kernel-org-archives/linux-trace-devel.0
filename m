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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 021B0C433E0
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Dec 2020 06:03:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD12322B2C
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Dec 2020 06:03:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725984AbgLUGD5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Dec 2020 01:03:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727224AbgLUGD5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Dec 2020 01:03:57 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 166C9C061248
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Dec 2020 22:02:47 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id g20so11833901ejb.1
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Dec 2020 22:02:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/f1AxuikG0fQMCo1LVuxfVgxfRm2uBPBqyV6Xih6nKo=;
        b=bfEcAlMtxF5lT5XX7vT38ZGVAw0FYwazbvuwYJ4FAw1AB65OW6nWG5xLNNmowzif2u
         XpwmDf1Sn9GBHSjAH2Oy353ShuWkenW0yW8LIMN0M+6HiqbprwMlNDZCSmL1i9jZI6o/
         dLQvtVkv7SPrPtG03+VCZGLePq8Z/EpElM0GGyL4cNsyGwXpJNxjoPrigty4zzopxCqb
         nUPe8uP+iaj4+8TtULBC04HZgOIUmW9jnKatvGPuCOOwXF/BtZKsPjYMYfbYLQ8IzA/a
         U1Cn4Au++GTMlBZT/qQ69aR7GXWs4c0lIPCUDC1a92iZYBh8dSrHLxW0a1GNSfMaVs4q
         7VUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/f1AxuikG0fQMCo1LVuxfVgxfRm2uBPBqyV6Xih6nKo=;
        b=WIhCFmh1YbgHpgDTjdZCudlV65zmOIPAKma2nxmI6ZiZl8/UBPsMal73f/2KHalju9
         uriA+IR/L4loRFpLqdIU4Beul5YP2gpMS/fyXt5q7I0RFMCfqFov4S4i+hGL/DcE5VnL
         nv+uVzOsqwyMzhG9wYi1irc0YcVgaLBKBB2SNRxk2pn5BkR/8BRp8cLZYy4YJJQhoJJj
         WcLa/ItibgflwzRb94Vq4Ejn5jhAvhBVJN5hMNZZ38mBmqoPqR1GNVaWCvWYORgakmZO
         IjcZpvUJmZ3i8lWbk+Y/noq+HEfRRWtT0Zm7ENA2IMDW3CIUKK5okWwbXUAeLPsJM4sF
         Z4Bg==
X-Gm-Message-State: AOAM533InDJdDi+c5EVJ2vVgmiMHAwK92OqXd83BPMnxZdw0CPL8EVIe
        6Uh8sZ5qKV9m+zcUe/dUrCI=
X-Google-Smtp-Source: ABdhPJzlGP1ETRK+HB1K6Sk8Ga0vkYeD3uDqkKtLNKiw9CXYZCHBGrCpSDR2DsWrsPHMmmO5F/lAUg==
X-Received: by 2002:a17:906:3813:: with SMTP id v19mr13949063ejc.462.1608530565847;
        Sun, 20 Dec 2020 22:02:45 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id i8sm27706247eds.72.2020.12.20.22.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Dec 2020 22:02:45 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/2] libtracefs: Rename tracefs_get_tracing_dir() to tracefs_tracing_dir()
Date:   Mon, 21 Dec 2020 08:02:41 +0200
Message-Id: <20201221060241.177767-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201221060241.177767-1-tz.stoyanov@gmail.com>
References: <20201221060241.177767-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The tracefs_get_tracing_dir() API mounts, locates and returns tracefs
mount point. In order to reflect more closely its logic, it is renamed
to tracefs_tracing_dir().

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs.h     |  4 ++--
 src/tracefs-events.c  |  8 ++++----
 src/tracefs-utils.c   |  6 +++---
 test.c                |  2 +-
 utest/tracefs-utest.c | 14 +++++++-------
 5 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index ae4ffa0..3d70aca 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -12,8 +12,8 @@
 char *tracefs_get_tracing_file(const char *name);
 void tracefs_put_tracing_file(char *name);
 
-/* tracefs_get_tracing_dir must *not* be freed */
-const char *tracefs_get_tracing_dir(void);
+/* the returned string must *not* be freed */
+const char *tracefs_tracing_dir(void);
 
 /* ftrace instances */
 struct tracefs_instance;
diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index 58fa153..825f916 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -268,7 +268,7 @@ char **tracefs_event_systems(const char *tracing_dir)
 	int ret;
 
 	if (!tracing_dir)
-		tracing_dir = tracefs_get_tracing_dir();
+		tracing_dir = tracefs_tracing_dir();
 
 	if (!tracing_dir)
 		return NULL;
@@ -342,7 +342,7 @@ char **tracefs_system_events(const char *tracing_dir, const char *system)
 	int ret;
 
 	if (!tracing_dir)
-		tracing_dir = tracefs_get_tracing_dir();
+		tracing_dir = tracefs_tracing_dir();
 
 	if (!tracing_dir || !system)
 		return NULL;
@@ -407,7 +407,7 @@ char **tracefs_tracers(const char *tracing_dir)
 	int ret;
 
 	if (!tracing_dir)
-		tracing_dir = tracefs_get_tracing_dir();
+		tracing_dir = tracefs_tracing_dir();
 
 	if (!tracing_dir)
 		return NULL;
@@ -544,7 +544,7 @@ static int fill_local_events_system(const char *tracing_dir,
 	int i;
 
 	if (!tracing_dir)
-		tracing_dir = tracefs_get_tracing_dir();
+		tracing_dir = tracefs_tracing_dir();
 	if (!tracing_dir)
 		return -1;
 
diff --git a/src/tracefs-utils.c b/src/tracefs-utils.c
index e9d2b0b..45724a0 100644
--- a/src/tracefs-utils.c
+++ b/src/tracefs-utils.c
@@ -131,12 +131,12 @@ char *trace_find_tracing_dir(void)
 }
 
 /**
- * tracefs_get_tracing_dir - Get tracing directory
+ * tracefs_tracing_dir - Get tracing directory
  *
  * Returns string containing the full path to the system's tracing directory.
  * The returned string must *not* be freed.
  */
-const char *tracefs_get_tracing_dir(void)
+const char *tracefs_tracing_dir(void)
 {
 	static const char *tracing_dir;
 
@@ -182,7 +182,7 @@ char *tracefs_get_tracing_file(const char *name)
  * tracefs_put_tracing_file - Free tracing file or directory name
  *
  * Frees tracing file or directory, returned by
- * tracefs_get_tracing_file() or tracefs_get_tracing_dir() APIs
+ * tracefs_get_tracing_file()API.
  */
 void tracefs_put_tracing_file(char *name)
 {
diff --git a/test.c b/test.c
index daf99d6..d38fc92 100644
--- a/test.c
+++ b/test.c
@@ -2,6 +2,6 @@
 
 int main()
 {
-	tracefs_get_tracing_dir();
+	tracefs_tracing_dir();
 	return 0;
 }
diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 965f1ec..b45a3c6 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -163,7 +163,7 @@ static void test_trace_file(void)
 	struct stat st;
 	char *file;
 
-	tdir  = tracefs_get_tracing_dir();
+	tdir  = tracefs_tracing_dir();
 	CU_TEST(tdir != NULL);
 	CU_TEST(stat(tdir, &st) == 0);
 	CU_TEST(S_ISDIR(st.st_mode));
@@ -183,7 +183,7 @@ static void test_trace_file(void)
 
 static void test_instance_file_read(struct tracefs_instance *inst, char *fname)
 {
-	const char *tdir  = tracefs_get_tracing_dir();
+	const char *tdir  = tracefs_tracing_dir();
 	char buf[BUFSIZ];
 	char *fpath;
 	char *file;
@@ -235,7 +235,7 @@ static void test_instance_file(void)
 	int size;
 	int ret;
 
-	tdir  = tracefs_get_tracing_dir();
+	tdir  = tracefs_tracing_dir();
 	CU_TEST(tdir != NULL);
 	CU_TEST(asprintf(&inst_dir, "%s/instances/%s", tdir, name) > 0);
 	CU_TEST(stat(inst_dir, &st) != 0);
@@ -360,7 +360,7 @@ static void test_system_event(void)
 	char **events;
 	char *sdir = NULL;
 
-	tdir  = tracefs_get_tracing_dir();
+	tdir  = tracefs_tracing_dir();
 	CU_TEST(tdir != NULL);
 
 	systems = tracefs_event_systems(tdir);
@@ -393,7 +393,7 @@ static void test_tracers(void)
 	char *tracer;
 	int i;
 
-	tdir  = tracefs_get_tracing_dir();
+	tdir  = tracefs_tracing_dir();
 	CU_TEST(tdir != NULL);
 
 	tracers = tracefs_tracers(tdir);
@@ -424,7 +424,7 @@ static void test_check_events(struct tep_handle *tep, char *system, bool exist)
 	DIR *dir;
 	int fd;
 
-	tdir  = tracefs_get_tracing_dir();
+	tdir  = tracefs_tracing_dir();
 	CU_TEST(tdir != NULL);
 
 	asprintf(&edir, "%s/events/%s", tdir, system);
@@ -461,7 +461,7 @@ static void test_local_events(void)
 	char *lsystems[3];
 	int i;
 
-	tdir  = tracefs_get_tracing_dir();
+	tdir  = tracefs_tracing_dir();
 	CU_TEST(tdir != NULL);
 
 	tep = tracefs_local_events(tdir);
-- 
2.28.0


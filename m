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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67CCCC433DB
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Dec 2020 05:07:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BDA123122
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Dec 2020 05:07:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbgLVFHb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Dec 2020 00:07:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbgLVFHa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Dec 2020 00:07:30 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6062FC06179C
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Dec 2020 21:06:50 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id c5so13219498wrp.6
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Dec 2020 21:06:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Vu5AQi25mW9AZFUA9Q2qIlB2fdp5ebCpYi/rSbfi928=;
        b=DIUhBKLWr5ksj00ZnUfAT+PjdNqFFcz7BwyQ04VDo6Yku7uI+kp8CUA9Hxnqu7xkLZ
         N3u4S3hP61NOSVBvwfRMyJVAAVHH6GMOXZNHVEknPgpiAPveoAdxKSpkvFcK3CEmqifs
         3+NX3L6F2+Dw+Op9Hu7AG4sD2IVToLY/tWqfYtkAXwIbzyXg6MUgjLpNxeVXuPIPIayh
         gojkl2K7BoLc9keLcyaUZnahYuDYc5LVyWGE1i9bBY6oPUuogXcp4ewSc0btVoQ7d+1o
         PZaRD69O+eCXA64ItEZ7Wzgo3hMFGCR6+EgAyqlq/oBq10gPKqxjacaoQMTkHiZVINpL
         Z1vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vu5AQi25mW9AZFUA9Q2qIlB2fdp5ebCpYi/rSbfi928=;
        b=dsYoZCNazfmFWiHTvNmhF+kCP4qI9cjxYmS2gNK0IKQ9JbDUUSA63+Huc1kSQ1Q/8Q
         xi2e9D7Rv5nCvDDLbe86ZfTNSTxGia5QeXvCnSPx87yiDs0tANsemt6HePd1E0Aoe8VO
         gIwa8PIiMjzzsK9qHWK8amUwwrR/LlkkfcqxkoDKsfnciPFO+l9OUO8GffVPq9qxBBhm
         faxgdb6ZJBz0+/UfswfJK3BYBAZN8ibMu9JyEtFF011poSutZZnfPjERXux6hbDWQJOU
         CX/J4qVe9dUe5Q71WxL4i2AbPMFWs4A22666SdLncAfJrM9d2jVaWpqKQUgoReeP/TOg
         ka/A==
X-Gm-Message-State: AOAM533LtbqPDaibbp9OV0q9ri+4SbG4Ovtk8GwfSYezlm2q/G1lSXqS
        DHRfwE2T+08z8kPhVDMTa04=
X-Google-Smtp-Source: ABdhPJz7v3/miWPbLxPXa7VHdyskj1JDNeboNQ8uQkUJ6QFd04hpa5oU7pQc+YSwiilUCELHe+Hmsw==
X-Received: by 2002:a5d:400c:: with SMTP id n12mr22201570wrp.218.1608613609147;
        Mon, 21 Dec 2020 21:06:49 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n8sm28828686wrs.34.2020.12.21.21.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 21:06:48 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/2] trace-cmd: Rename tracefs_get_tracing_dir() to tracefs_tracing_dir()
Date:   Tue, 22 Dec 2020 07:06:45 +0200
Message-Id: <20201222050646.375340-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201222050646.375340-1-tz.stoyanov@gmail.com>
References: <20201222050646.375340-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The libtracefs API fo locating trace file system mount point is renamed,
use the new API in trace-cmd.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs/tracefs.h            |  4 ++--
 kernel-shark/src/KsCaptureDialog.cpp |  4 ++--
 lib/trace-cmd/trace-recorder.c       |  6 +++---
 lib/tracefs/tracefs-events.c         |  6 +++---
 lib/tracefs/tracefs-utils.c          |  6 +++---
 tracecmd/trace-check-events.c        |  2 +-
 utest/tracefs-utest.c                | 14 +++++++-------
 7 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/include/tracefs/tracefs.h b/include/tracefs/tracefs.h
index ce8b09ca..8308e3ac 100644
--- a/include/tracefs/tracefs.h
+++ b/include/tracefs/tracefs.h
@@ -12,8 +12,8 @@
 char *tracefs_get_tracing_file(const char *name);
 void tracefs_put_tracing_file(char *name);
 
-/* tracefs_get_tracing_dir must *not* be freed */
-const char *tracefs_get_tracing_dir(void);
+/* The returned string must *not* be freed */
+const char *tracefs_tracing_dir(void);
 
 /* tracefs_find_tracing_dir must be freed */
 char *tracefs_find_tracing_dir(void);
diff --git a/kernel-shark/src/KsCaptureDialog.cpp b/kernel-shark/src/KsCaptureDialog.cpp
index 63fd5d6e..7253ab68 100644
--- a/kernel-shark/src/KsCaptureDialog.cpp
+++ b/kernel-shark/src/KsCaptureDialog.cpp
@@ -26,7 +26,7 @@ extern "C" {
 
 static inline tep_handle *local_events()
 {
-	return tracefs_local_events(tracefs_get_tracing_dir());
+	return tracefs_local_events(tracefs_tracing_dir());
 }
 
 /**
@@ -204,7 +204,7 @@ QStringList KsCaptureControl::_getPlugins()
 	QStringList pluginList;
 	char **all_plugins;
 
-	all_plugins = tracefs_tracers(tracefs_get_tracing_dir());
+	all_plugins = tracefs_tracers(tracefs_tracing_dir());
 
 	if (!all_plugins)
 		return pluginList;
diff --git a/lib/trace-cmd/trace-recorder.c b/lib/trace-cmd/trace-recorder.c
index 6b647d6c..c811028a 100644
--- a/lib/trace-cmd/trace-recorder.c
+++ b/lib/trace-cmd/trace-recorder.c
@@ -307,7 +307,7 @@ struct tracecmd_recorder *tracecmd_create_recorder_fd(int fd, int cpu, unsigned
 {
 	const char *tracing;
 
-	tracing = tracefs_get_tracing_dir();
+	tracing = tracefs_tracing_dir();
 	if (!tracing) {
 		errno = ENODEV;
 		return NULL;
@@ -320,7 +320,7 @@ struct tracecmd_recorder *tracecmd_create_recorder(const char *file, int cpu, un
 {
 	const char *tracing;
 
-	tracing = tracefs_get_tracing_dir();
+	tracing = tracefs_tracing_dir();
 	if (!tracing) {
 		errno = ENODEV;
 		return NULL;
@@ -334,7 +334,7 @@ tracecmd_create_recorder_maxkb(const char *file, int cpu, unsigned flags, int ma
 {
 	const char *tracing;
 
-	tracing = tracefs_get_tracing_dir();
+	tracing = tracefs_tracing_dir();
 	if (!tracing) {
 		errno = ENODEV;
 		return NULL;
diff --git a/lib/tracefs/tracefs-events.c b/lib/tracefs/tracefs-events.c
index ba640a9e..826b6fc7 100644
--- a/lib/tracefs/tracefs-events.c
+++ b/lib/tracefs/tracefs-events.c
@@ -267,7 +267,7 @@ char **tracefs_event_systems(const char *tracing_dir)
 	int ret;
 
 	if (!tracing_dir)
-		tracing_dir = tracefs_get_tracing_dir();
+		tracing_dir = tracefs_tracing_dir();
 
 	if (!tracing_dir)
 		return NULL;
@@ -341,7 +341,7 @@ char **tracefs_system_events(const char *tracing_dir, const char *system)
 	int ret;
 
 	if (!tracing_dir)
-		tracing_dir = tracefs_get_tracing_dir();
+		tracing_dir = tracefs_tracing_dir();
 
 	if (!tracing_dir || !system)
 		return NULL;
@@ -540,7 +540,7 @@ static int fill_local_events_system(const char *tracing_dir,
 	int i;
 
 	if (!tracing_dir)
-		tracing_dir = tracefs_get_tracing_dir();
+		tracing_dir = tracefs_tracing_dir();
 	if (!tracing_dir)
 		return -1;
 
diff --git a/lib/tracefs/tracefs-utils.c b/lib/tracefs/tracefs-utils.c
index 326b4559..8483cb61 100644
--- a/lib/tracefs/tracefs-utils.c
+++ b/lib/tracefs/tracefs-utils.c
@@ -131,12 +131,12 @@ char *tracefs_find_tracing_dir(void)
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
+ * tracefs_get_tracing_file() API
  */
 void tracefs_put_tracing_file(char *name)
 {
diff --git a/tracecmd/trace-check-events.c b/tracecmd/trace-check-events.c
index 1dadb046..0fa9082c 100644
--- a/tracecmd/trace-check-events.c
+++ b/tracecmd/trace-check-events.c
@@ -29,7 +29,7 @@ void trace_check_events(int argc, char **argv)
 			break;
 		}
 	}
-	tracing = tracefs_get_tracing_dir();
+	tracing = tracefs_tracing_dir();
 
 	if (!tracing) {
 		printf("Can not find or mount tracing directory!\n"
diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index e7d637f5..4a622d59 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -169,7 +169,7 @@ static void test_trace_file(void)
 	CU_TEST(stat(dir, &st) == 0);
 	CU_TEST(S_ISDIR(st.st_mode));
 
-	tdir  = tracefs_get_tracing_dir();
+	tdir  = tracefs_tracing_dir();
 	CU_TEST(tdir != NULL);
 	CU_TEST(stat(tdir, &st) == 0);
 	CU_TEST(S_ISDIR(st.st_mode));
@@ -192,7 +192,7 @@ static void test_trace_file(void)
 
 static void test_instance_file_read(struct tracefs_instance *inst, char *fname)
 {
-	const char *tdir  = tracefs_get_tracing_dir();
+	const char *tdir  = tracefs_tracing_dir();
 	char buf[BUFSIZ];
 	char *fpath;
 	char *file;
@@ -244,7 +244,7 @@ static void test_instance_file(void)
 	int size;
 	int ret;
 
-	tdir  = tracefs_get_tracing_dir();
+	tdir  = tracefs_tracing_dir();
 	CU_TEST(tdir != NULL);
 	CU_TEST(asprintf(&inst_dir, "%s/instances/%s", tdir, name) > 0);
 	CU_TEST(stat(inst_dir, &st) != 0);
@@ -369,7 +369,7 @@ static void test_system_event(void)
 	char **events;
 	char *sdir = NULL;
 
-	tdir  = tracefs_get_tracing_dir();
+	tdir  = tracefs_tracing_dir();
 	CU_TEST(tdir != NULL);
 
 	systems = tracefs_event_systems(tdir);
@@ -402,7 +402,7 @@ static void test_tracers(void)
 	char *tracer;
 	int i;
 
-	tdir  = tracefs_get_tracing_dir();
+	tdir  = tracefs_tracing_dir();
 	CU_TEST(tdir != NULL);
 
 	tracers = tracefs_tracers(tdir);
@@ -433,7 +433,7 @@ static void test_check_events(struct tep_handle *tep, char *system, bool exist)
 	DIR *dir;
 	int fd;
 
-	tdir  = tracefs_get_tracing_dir();
+	tdir  = tracefs_tracing_dir();
 	CU_TEST(tdir != NULL);
 
 	asprintf(&edir, "%s/events/%s", tdir, system);
@@ -470,7 +470,7 @@ static void test_local_events(void)
 	char *lsystems[3];
 	int i;
 
-	tdir  = tracefs_get_tracing_dir();
+	tdir  = tracefs_tracing_dir();
 	CU_TEST(tdir != NULL);
 
 	tep = tracefs_local_events(tdir);
-- 
2.28.0


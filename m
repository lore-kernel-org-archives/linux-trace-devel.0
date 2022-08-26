Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B25D4ECAAA3
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Aug 2022 05:42:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241159AbiHZFmS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 26 Aug 2022 01:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230517AbiHZFmR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 26 Aug 2022 01:42:17 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8841DD0201
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Aug 2022 22:42:15 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id w20so805730edd.10
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Aug 2022 22:42:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=HHVHS7rw8WdClemwtOECyOC70LzLb0PBX2zqA3iHMcc=;
        b=D2B3hjANYIK7DxE/5tId5Il/waQP806LgzYn8PAbitNEtq0wRCKkY/Y2GOFyS/FtkN
         E9EXu54TYT5PyifGUxLrEQlVRZxsPoNJ0ONyijiD/iydPVcOBhU1f8KRrGLDAt3RDV+i
         frq8El1MbTIq57AQHzcFQ/MwA5552xPC1JqRHAu6OP2mvqi6ASSZkDEPznV8TSe4PhCs
         QKDtNBmxu6NFW+xBKAe0Cd4QuRESbrFFylOytS3J7qO41PEMThKcTn+rlFTHBRaY7+HC
         TTVtX9N2L2a5qmZ4A5FPH3DPqnbbYi3k+O1RE7ZZzJ7gef0TKcnU7F7+3kdykmVYtSyQ
         3Wmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=HHVHS7rw8WdClemwtOECyOC70LzLb0PBX2zqA3iHMcc=;
        b=FbmHIDOiLlnGugBoojx3st3ljZVqsoz3sWX/SFtCx8QpBXjZmxyC5PSNJCZqdAmxBL
         I0FUGXBOelbk48h1U394tdubuaESnKCEy2X/URtY6/v4xSGxd9wg/5jyX4Vcl4wt6BDl
         hXzpczE6Vaw4izTM79IwCmQTcLJ0a7HCTdlummQL4YkXR5NN98I3pZ7oE0Bwytr9Sxll
         p2KZGQX4vBIsQIigkZsMbW+GMkbQfWUQYV7GTEHucVO87dVNcz+6Uo0Qp8MTiLdokGaQ
         ER2j36Y0N6CNlTzSahkEICJW5kqE2aigsImAlf2yv+eud1QS8HA6ZKVyeTg2R6l5Zleh
         IyYg==
X-Gm-Message-State: ACgBeo39Qvh4TJNzeWSl9YYQdrl0+pGLPxDvHY9EpAq1/BWGLzZNZb9M
        CSFqSYuUL2P58oiAMsMhUNzNkAnKLuc=
X-Google-Smtp-Source: AA6agR6NPxoKZ/O0cl9MJyeiWi2DOWpLwv6yMeV6H8XojTVfBE24SA4zeJhjzxFa738pJL+fEGtClQ==
X-Received: by 2002:a05:6402:206b:b0:446:ce5d:3e60 with SMTP id bd11-20020a056402206b00b00446ce5d3e60mr5567298edb.139.1661492534085;
        Thu, 25 Aug 2022 22:42:14 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id a8-20020aa7cf08000000b0044604ad8b41sm737696edy.23.2022.08.25.22.42.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 22:42:13 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] libtracefs: Add API to set custom tracing directory
Date:   Fri, 26 Aug 2022 08:42:12 +0300
Message-Id: <20220826054212.146976-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Usually the system's tracing directory is mounted as a subfolder in
/sys/kernel and is auto detected by the tracefs library, using the
information from the "/proc/mounts" file. But there are cases where
/sys and /proc are mounted inside a container on a custom mount point.
In those cases the tracefs library cannot auto detect the system's
tracing directory. That's why a new API is introduced, to handle these
custom use cases:
 int tracefs_set_tracing_dir(char *tracing_dir);

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracefs-files.txt | 14 ++++++++++++--
 Documentation/libtracefs.txt       |  1 +
 include/tracefs.h                  |  1 +
 src/tracefs-utils.c                | 30 ++++++++++++++++++++++++++++++
 utest/tracefs-utest.c              | 20 ++++++++++++++++++++
 5 files changed, 64 insertions(+), 2 deletions(-)

diff --git a/Documentation/libtracefs-files.txt b/Documentation/libtracefs-files.txt
index ab917a6..2a3f544 100644
--- a/Documentation/libtracefs-files.txt
+++ b/Documentation/libtracefs-files.txt
@@ -3,8 +3,8 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_get_tracing_file, tracefs_put_tracing_file, tracefs_tracing_dir, tracefs_debug_dir -
-Find locations of trace directory and files.
+tracefs_get_tracing_file, tracefs_put_tracing_file, tracefs_tracing_dir, tracefs_debug_dir, tracefs_set_tracing_dir -
+Find and set locations of trace directory and files.
 
 SYNOPSIS
 --------
@@ -16,6 +16,7 @@ char pass:[*]*tracefs_get_tracing_file*(const char pass:[*]_name_);
 void *tracefs_put_tracing_file*(char pass:[*]_name_);
 const char pass:[*]*tracefs_tracing_dir*(void);
 const char pass:[*]*tracefs_debug_dir*(void);
+int *tracefs_set_tracing_dir*(char pass:[*]_tracing_dir_)
 --
 
 DESCRIPTION
@@ -23,6 +24,13 @@ DESCRIPTION
 This set of APIs can be used to find the full path of the trace file
 system mount point and trace files in it.
 
+The *tracefs_set_tracing_dir()* function sets a custom location of the
+system's tracing directory mount point. Usually, the library auto detects
+it using the information from the /proc/mounts file. Use this API only if the
+mount point is not standard and cannot be detected by the library. The _tracing_dir_
+argument can be NULL, in that case the custom location is deleted and the library
+auto detection logic is used.
+
 The *tracefs_get_tracing_file()* function returns the full path of the
 file with given _name_ in the trace file system. The function works
 only with files in the tracefs main directory, it is not trace instance
@@ -46,6 +54,8 @@ be freed.
 
 RETURN VALUE
 ------------
+The *tracefs_set_tracing_dir()* function returns 0 on success, -1 otherwise.
+
 The *tracefs_get_tracing_file()* function returns a string or NULL in case
 of an error. The returned string must be freed with *tracefs_put_tracing_file()*.
 
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index 82cb574..eb2eff4 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -15,6 +15,7 @@ Locations of tracing files and directories:
 	char pass:[*]*tracefs_get_tracing_file*(const char pass:[*]_name_);
 	void *tracefs_put_tracing_file*(char pass:[*]_name_);
 	const char pass:[*]*tracefs_tracing_dir*(void);
+	int *tracefs_set_tracing_dir*(char pass:[*]_tracing_dir_)
 
 Trace instances:
 	struct tracefs_instance pass:[*]*tracefs_instance_create*(const char pass:[*]_name_);
diff --git a/include/tracefs.h b/include/tracefs.h
index 693860d..fd2240a 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -16,6 +16,7 @@ void tracefs_put_tracing_file(char *name);
 /* the returned string must *not* be freed */
 const char *tracefs_tracing_dir(void);
 const char *tracefs_debug_dir(void);
+int tracefs_set_tracing_dir(char *tracing_dir);
 
 /* ftrace instances */
 struct tracefs_instance;
diff --git a/src/tracefs-utils.c b/src/tracefs-utils.c
index 22f82af..55a2f0a 100644
--- a/src/tracefs-utils.c
+++ b/src/tracefs-utils.c
@@ -29,6 +29,7 @@
 #define STR(x) _STR(x)
 
 static int log_level = TEP_LOG_CRITICAL;
+static char *custom_tracing_dir;
 
 /**
  * tracefs_set_loglevel - set log level of the library
@@ -164,6 +165,32 @@ __hidden char *trace_find_tracing_dir(bool debugfs)
 	return tracing_dir;
 }
 
+/**
+ * tracefs_set_tracing_dir - Set location of the tracing directory
+ * @tracing_dir: full path to the system's tracing directory mount point.
+ *
+ * Set the location to the system's tracing directory. This API should be used
+ * to set a custom location of the tracing directory. There is no need to call
+ * it if the location is standard, in that case the library will auto detect it.
+ *
+ * Returns 0 on success, -1 otherwise.
+ */
+int tracefs_set_tracing_dir(char *tracing_dir)
+{
+	if (custom_tracing_dir) {
+		free(custom_tracing_dir);
+		custom_tracing_dir = NULL;
+	}
+
+	if (tracing_dir) {
+		custom_tracing_dir = strdup(tracing_dir);
+		if (!custom_tracing_dir)
+			return -1;
+	}
+
+	return 0;
+}
+
 /**
  * tracefs_tracing_dir - Get tracing directory
  *
@@ -174,6 +201,9 @@ const char *tracefs_tracing_dir(void)
 {
 	static const char *tracing_dir;
 
+	if (custom_tracing_dir)
+		return custom_tracing_dir;
+
 	if (tracing_dir)
 		return tracing_dir;
 
diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 3f63837..6f083db 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -11,6 +11,7 @@
 #include <time.h>
 #include <dirent.h>
 #include <ftw.h>
+#include <libgen.h>
 
 #include <CUnit/CUnit.h>
 #include <CUnit/Basic.h>
@@ -1701,8 +1702,11 @@ void del_trace_dir(char *dir)
 
 static void test_custom_trace_dir(void)
 {
+	char *tdir = "/tmp/custom_tracefs";
 	struct tracefs_instance *instance;
 	char *dname = copy_trace_dir();
+	const char *trace_dir;
+	char *tfile;
 
 	instance = tracefs_instance_alloc(dname, NULL);
 	CU_TEST(instance != NULL);
@@ -1717,6 +1721,22 @@ static void test_custom_trace_dir(void)
 	tracefs_instance_free(instance);
 	del_trace_dir(dname);
 	free(dname);
+
+	trace_dir = tracefs_tracing_dir();
+	CU_TEST(trace_dir != NULL);
+	CU_TEST(tracefs_set_tracing_dir(tdir) == 0);
+	CU_TEST(strcmp(tdir, tracefs_tracing_dir()) == 0);
+	tfile = tracefs_get_tracing_file("trace");
+	CU_TEST(tfile != NULL);
+	CU_TEST(strcmp(tdir, dirname(tfile)) == 0);
+	free(tfile);
+
+	CU_TEST(tracefs_set_tracing_dir(NULL) == 0);
+	CU_TEST(strcmp(trace_dir, tracefs_tracing_dir()) == 0);
+	tfile = tracefs_get_tracing_file("trace");
+	CU_TEST(tfile != NULL);
+	CU_TEST(strcmp(trace_dir, dirname(tfile)) == 0);
+	free(tfile);
 }
 
 static int test_suite_destroy(void)
-- 
2.37.1


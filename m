Return-Path: <SRS0=o21U=56=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39E58C2BB86
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Apr 2020 01:46:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23F7C20775
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Apr 2020 01:46:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728252AbgDNBqO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Apr 2020 21:46:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:49872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403847AbgDNBqN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Apr 2020 21:46:13 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 574F5206B6
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Apr 2020 01:46:12 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jOAeR-004H43-8m
        for linux-trace-devel@vger.kernel.org; Mon, 13 Apr 2020 21:46:11 -0400
Message-Id: <20200414014611.146422111@goodmis.org>
User-Agent: quilt/0.65
Date:   Mon, 13 Apr 2020 21:44:04 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/2] trace-cmd: Use "exists" instead of "exist"
References: <20200414014403.968063641@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

As a native English speaker, I find that the words "file_exists" and
"dir_exists" sounds better to the ear than "file_exist" and "dir_exist".
As "exist" is for the plural, and "exists" is for the singular.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/tracefs/tracefs.h      |  4 ++--
 lib/tracefs/tracefs-instance.c | 14 +++++++-------
 tracecmd/trace-record.c        |  2 +-
 utest/tracefs-utest.c          | 28 ++++++++++++++--------------
 4 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/include/tracefs/tracefs.h b/include/tracefs/tracefs.h
index bc8bebcb05a0..8ee7ba6e9d7a 100644
--- a/include/tracefs/tracefs.h
+++ b/include/tracefs/tracefs.h
@@ -33,8 +33,8 @@ int tracefs_instance_file_write(struct tracefs_instance *instance,
 char *tracefs_instance_file_read(struct tracefs_instance *instance,
 				 char *file, int *psize);
 
-bool tracefs_file_exist(struct tracefs_instance *instance, char *name);
-bool tracefs_dir_exist(struct tracefs_instance *instance, char *name);
+bool tracefs_file_exists(struct tracefs_instance *instance, char *name);
+bool tracefs_dir_exists(struct tracefs_instance *instance, char *name);
 
 /* events */
 void tracefs_list_free(char **list);
diff --git a/lib/tracefs/tracefs-instance.c b/lib/tracefs/tracefs-instance.c
index 67123e7c14bf..a8729406b9fc 100644
--- a/lib/tracefs/tracefs-instance.c
+++ b/lib/tracefs/tracefs-instance.c
@@ -248,7 +248,7 @@ char *tracefs_instance_file_read(struct tracefs_instance *instance,
 	return buf;
 }
 
-static bool check_file_exist(struct tracefs_instance *instance,
+static bool check_file_exists(struct tracefs_instance *instance,
 			     char *name, bool dir)
 {
 	char file[PATH_MAX];
@@ -272,25 +272,25 @@ static bool check_file_exist(struct tracefs_instance *instance,
 }
 
 /**
- * tracefs_file_exist - Check if a file with given name exists in given instance
+ * tracefs_file_exists - Check if a file with given name exists in given instance
  * @instance: ftrace instance, can be NULL for the top instance
  * @name: name of the file
  *
  * Returns true if the file exists, false otherwise
  */
-bool tracefs_file_exist(struct tracefs_instance *instance, char *name)
+bool tracefs_file_exists(struct tracefs_instance *instance, char *name)
 {
-	return check_file_exist(instance, name, false);
+	return check_file_exists(instance, name, false);
 }
 
 /**
- * tracefs_dir_exist - Check if a directory with given name exists in given instance
+ * tracefs_dir_exists - Check if a directory with given name exists in given instance
  * @instance: ftrace instance, can be NULL for the top instance
  * @name: name of the directory
  *
  * Returns true if the directory exists, false otherwise
  */
-bool tracefs_dir_exist(struct tracefs_instance *instance, char *name)
+bool tracefs_dir_exists(struct tracefs_instance *instance, char *name)
 {
-	return check_file_exist(instance, name, true);
+	return check_file_exists(instance, name, true);
 }
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 955ab75d1b47..d89b32d3e2dd 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4791,7 +4791,7 @@ static void clear_instance_error_log(struct buffer_instance *instance)
 {
 	char *file;
 
-	if (!tracefs_file_exist(instance->tracefs, "error_log"))
+	if (!tracefs_file_exists(instance->tracefs, "error_log"))
 		return;
 
 	file = tracefs_instance_get_file(instance->tracefs, "error_log");
diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 3f57ecad3962..1c1465767ecc 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -252,20 +252,20 @@ static void test_instance_file(void)
 	tracefs_put_tracing_file(inst_file);
 	free(fname);
 
-	CU_TEST(tracefs_file_exist(NULL, (char *)name) == false);
-	CU_TEST(tracefs_dir_exist(NULL, (char *)name) == false);
-	CU_TEST(tracefs_file_exist(instance, (char *)name) == false);
-	CU_TEST(tracefs_dir_exist(instance, (char *)name) == false);
-
-	CU_TEST(tracefs_file_exist(NULL, CUR_TRACER) == true);
-	CU_TEST(tracefs_dir_exist(NULL, CUR_TRACER) == false);
-	CU_TEST(tracefs_file_exist(instance, CUR_TRACER) == true);
-	CU_TEST(tracefs_dir_exist(instance, CUR_TRACER) == false);
-
-	CU_TEST(tracefs_file_exist(NULL, PER_CPU) == false);
-	CU_TEST(tracefs_dir_exist(NULL, PER_CPU) == true);
-	CU_TEST(tracefs_file_exist(instance, PER_CPU) == false);
-	CU_TEST(tracefs_dir_exist(instance, PER_CPU) == true);
+	CU_TEST(tracefs_file_exists(NULL, (char *)name) == false);
+	CU_TEST(tracefs_dir_exists(NULL, (char *)name) == false);
+	CU_TEST(tracefs_file_exists(instance, (char *)name) == false);
+	CU_TEST(tracefs_dir_exists(instance, (char *)name) == false);
+
+	CU_TEST(tracefs_file_exists(NULL, CUR_TRACER) == true);
+	CU_TEST(tracefs_dir_exists(NULL, CUR_TRACER) == false);
+	CU_TEST(tracefs_file_exists(instance, CUR_TRACER) == true);
+	CU_TEST(tracefs_dir_exists(instance, CUR_TRACER) == false);
+
+	CU_TEST(tracefs_file_exists(NULL, PER_CPU) == false);
+	CU_TEST(tracefs_dir_exists(NULL, PER_CPU) == true);
+	CU_TEST(tracefs_file_exists(instance, PER_CPU) == false);
+	CU_TEST(tracefs_dir_exists(instance, PER_CPU) == true);
 
 	CU_TEST(tracefs_instance_destroy(NULL) != 0);
 	CU_TEST(tracefs_instance_destroy(instance) == 0);
-- 
2.25.1



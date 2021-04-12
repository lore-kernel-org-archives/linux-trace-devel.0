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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C440EC433ED
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Apr 2021 15:20:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3D956128C
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Apr 2021 15:20:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242786AbhDLPUj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Apr 2021 11:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242770AbhDLPUj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Apr 2021 11:20:39 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0E1C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Apr 2021 08:20:21 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id m9so616399wrx.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Apr 2021 08:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q4em6xFy0TZBtuI2iTeBaStk0McDl6NFFLO8nWLprTU=;
        b=NEsVdDbhlXWAjeHbJTOvEafIJA8TD5yXzeO+G6Mgnt7NPuUz4Ci6GS6ZPC75itbwJr
         JB8GVDPOwqurEvwlldLC4J47R6jj2YtnfNiEjkVVYB3JUDWMSLj26kb/PZhCel9QmyQZ
         nh6yhs+zG3lpB5m06Qpzn/dYUwmxYqjghW9yIAdwwonRv1R6qpvxILpL3aDhdfO/LmMK
         5WfdFA0HVwoue8492O+kfMBh2i8jk3C5f+e/TxUNq+ooOPlYqR/EBpJPGn5O2m9B1Mj1
         zAbAF/PW8rmJ69p9OtMX4dn3Ianr2JsZuu3uWvdA2CCTfbR1egISH5J7LaLnHm+o2uQn
         bAvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q4em6xFy0TZBtuI2iTeBaStk0McDl6NFFLO8nWLprTU=;
        b=lccf8jqV2hY/RZeD4hoNvCTxbDwYtKWUshPzANfBQfKjtvfWDKTUorNZSl64SpShf9
         +HqxTeNeDcqa61KdKNLzXaYoRo7Zpc4kBzD5l1T/qRUbsg8JzwKPUF3oFNms2Vd81OgG
         KwZ4fuVljxD2Ea2B8HOQhRoMJKVz85SgAvoQiD7DBlMo4Epo8apUJdwJiHaH9KWbdmpW
         jIOK08jqqn6eMBxXWqE+wKfV6E9cED/129RL7QPOZoUTCov/gJ87tlkRPfIlOXfcVsQi
         j1vkbSFXVDAbTUfBOYeZMrVRBmJwnkq10gcHHhsxzy4xk0qHUAAsCEVnW9KfMy3L6J5F
         J8fg==
X-Gm-Message-State: AOAM531JYpZ4W4Q9ienJBHjqzhy5Bc8ZNb5Kg8hlwDKwrA8RDFUmVv1w
        uYADuxFWIWcsB3soPsgFSI/8Kz4khxkFcg==
X-Google-Smtp-Source: ABdhPJx3aJDU+VRkTp0Twz2z7G+BU0iM5o9K0p+BsNTLZmFQUjSTWQZOJ8qYjluPuPDnT9p1gMhMCA==
X-Received: by 2002:adf:f944:: with SMTP id q4mr28471878wrr.281.1618240819977;
        Mon, 12 Apr 2021 08:20:19 -0700 (PDT)
Received: from localhost.localdomain ([95.87.199.115])
        by smtp.gmail.com with ESMTPSA id b6sm18387544wrv.12.2021.04.12.08.20.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 08:20:19 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [RFC PATCH] libtracefs: Add more methods for writing to files
Date:   Mon, 12 Apr 2021 18:20:06 +0300
Message-Id: <20210412152006.58332-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

For the moment the library provides only one method for writing to
tracefs files, that is:

int tracefs_instance_file_write()

This method first truncates the size of the file to 0 (clearing it),
then writes new content to this file. Essentially this method overwrites
(clear + write). In this patch we add two additional methids:

int tracefs_instance_file_append()

which writes without clearing and

int tracefs_instance_file_clear()

which clears without writing anything. Those two new APIs have various
use-cases. For example one can use the two methods when adding/clearing
kprobes.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 include/tracefs.h      |  4 +++
 src/tracefs-instance.c | 65 ++++++++++++++++++++++++++++++++----------
 2 files changed, 54 insertions(+), 15 deletions(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index 55ee867..551c37c 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -33,6 +33,10 @@ tracefs_instance_get_file(struct tracefs_instance *instance, const char *file);
 char *tracefs_instance_get_dir(struct tracefs_instance *instance);
 int tracefs_instance_file_write(struct tracefs_instance *instance,
 				const char *file, const char *str);
+int tracefs_instance_file_append(struct tracefs_instance *instance,
+				 const char *file, const char *str);
+int tracefs_instance_file_clear(struct tracefs_instance *instance,
+				const char *file);
 char *tracefs_instance_file_read(struct tracefs_instance *instance,
 				 const char *file, int *psize);
 int tracefs_instance_file_read_number(struct tracefs_instance *instance,
diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index b8ce36f..e9dbba4 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -337,21 +337,41 @@ const char *tracefs_instance_get_trace_dir(struct tracefs_instance *instance)
 	return NULL;
 }
 
-static int write_file(const char *file, const char *str)
+static int write_file(const char *file, const char *str, int flags)
 {
-	int ret;
+	int ret = 0;
 	int fd;
 
-	fd = open(file, O_WRONLY | O_TRUNC);
+	fd = open(file, flags);
 	if (fd < 0) {
 		tracefs_warning("Failed to open '%s'", file);
 		return -1;
 	}
-	ret = write(fd, str, strlen(str));
+
+	if (str)
+		ret = write(fd, str, strlen(str));
+
 	close(fd);
 	return ret;
 }
 
+static int instance_file_write(struct tracefs_instance *instance,
+			       const char *file, const char *str, int flags)
+{
+	struct stat st;
+	char *path;
+	int ret;
+
+	path = tracefs_instance_get_file(instance, file);
+	if (!path)
+		return -1;
+	ret = stat(path, &st);
+	if (ret == 0)
+		ret = write_file(path, str, flags);
+	tracefs_put_tracing_file(path);
+
+	return ret;
+}
 
 /**
  * tracefs_instance_file_write - Write in trace file of specific instance.
@@ -364,19 +384,34 @@ static int write_file(const char *file, const char *str)
 int tracefs_instance_file_write(struct tracefs_instance *instance,
 				 const char *file, const char *str)
 {
-	struct stat st;
-	char *path;
-	int ret;
+	return instance_file_write(instance, file, str, O_WRONLY | O_TRUNC);
+}
 
-	path = tracefs_instance_get_file(instance, file);
-	if (!path)
-		return -1;
-	ret = stat(path, &st);
-	if (ret == 0)
-		ret = write_file(path, str);
-	tracefs_put_tracing_file(path);
+/**
+ * tracefs_instance_file_write - Append to a trace file of specific instance.
+ * @instance: ftrace instance, can be NULL for the top instance
+ * @file: name of the file
+ * @str: nul terminated string, that will be appended to the file.
+ *
+ * Returns the number of appended bytes, or -1 in case of an error.
+ */
+int tracefs_instance_file_append(struct tracefs_instance *instance,
+				 const char *file, const char *str)
+{
+	return instance_file_write(instance, file, str, O_WRONLY);
+}
 
-	return ret;
+/**
+ * tracefs_instance_file_write - Clear a trace file of specific instance.
+ * @instance: ftrace instance, can be NULL for the top instance
+ * @file: name of the file
+ *
+ * Returns 0 on success, or -1 in case of an error.
+ */
+int tracefs_instance_file_clear(struct tracefs_instance *instance,
+				const char *file)
+{
+	return instance_file_write(instance, file, NULL, O_WRONLY | O_TRUNC);
 }
 
 /**
-- 
2.25.1


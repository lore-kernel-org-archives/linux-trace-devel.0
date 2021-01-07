Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 461F4C433E6
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Jan 2021 08:33:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13C2D20738
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Jan 2021 08:33:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbhAGIdf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Jan 2021 03:33:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbhAGIdf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Jan 2021 03:33:35 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07FF3C0612F5
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Jan 2021 00:32:55 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id t30so4784930wrb.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Jan 2021 00:32:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vcKhDeYU3eG+D7PcdFnAB8JZNBcJUbcNVUYI5AulMkQ=;
        b=c1i5ohjYDGcjHL6EcMXuocVrPIFny/UQbrDo+YeGQyj9ZfZiM5QxKrnIQFn7v+PV3s
         X2jyJgkdz06h/UTyjekpUfjpmXDJV6PmPcdftzma1CV41HdwmCr5K51hN5HoiBkftyUU
         x7lIkMQ8LkWqWgvT17v5xnqyKreDPY6dwBuYsBaANOpQVUnnSONOGDRgMRDyGa6g3N/H
         s4DtpMEo0Xdl4qs+z51L+eYPEV9q5rdqwKi8fsXFLoUKdOi8NE0LOZhF9jAql+69BFD2
         B2Piufp5iVQ0vUlm8og3/nltMEHpcE3b0PL7sIOqxhJuseZN3gSd7n7LRUumiDHWP2h8
         qs6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vcKhDeYU3eG+D7PcdFnAB8JZNBcJUbcNVUYI5AulMkQ=;
        b=fMQE8Cb1/Sm/KKqQafV/leiat7lQi/NuRgMm53X15EZ0iz87LAQWYuJd0T7gx0kolP
         gyxebpmnQuneSfwM02+0E9DrfrgPm3G9TBEWNNINBr48YRIZKHTDo7brpkvbf5tX8e7N
         t4R2KIYi+Ht10ic1DPHNBYTdPviwMvwlZiADrHoeq250YFPL5B2F1zoikZOiZ8diYfZp
         3ygM6GZKDp2u8FDA5LwhksZA/saffYAcx+cNUamKvkgXPyBUGx5pRrWU4PK0WoGyYJYO
         pxvkKl4N3yxWgumiy5BQDRiPR/iq0yhNAkaWhp+DSPwcxDN3P+hkJrUSbDK+5nSpfGxS
         eGQg==
X-Gm-Message-State: AOAM531Kcrd3RUfM/O3N/xZ20+tsqazYhRM2XFueqm2i/QSIhSPgYSvi
        CpdHb0fss+VyHgcQBqLg1ALXpZA9a6dafOeq
X-Google-Smtp-Source: ABdhPJwHkfg5bM4a7bNRtn/83qaUeIsSals6y1PmWTGei/Q9/CWcihs+Vs290h/nttykWo8jDHnLbg==
X-Received: by 2002:a5d:4b4c:: with SMTP id w12mr7692569wrs.402.1610008373771;
        Thu, 07 Jan 2021 00:32:53 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v20sm7293867wra.19.2021.01.07.00.32.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 00:32:53 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/6] libtracefs: New APIs for opening and reading ftrace files
Date:   Thu,  7 Jan 2021 10:32:45 +0200
Message-Id: <20210107083250.16295-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210107083250.16295-1-tz.stoyanov@gmail.com>
References: <20210107083250.16295-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

These new APIs can be used to read integer from frtace file and to open
ftrace file:
  tracefs_instance_file_read_int();
  tracefs_instance_file_open();

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs.h      |  6 ++++-
 src/tracefs-instance.c | 59 ++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 62 insertions(+), 3 deletions(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index 3d70aca..460fa4c 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -29,7 +29,11 @@ char *tracefs_instance_get_dir(struct tracefs_instance *instance);
 int tracefs_instance_file_write(struct tracefs_instance *instance,
 				const char *file, const char *str);
 char *tracefs_instance_file_read(struct tracefs_instance *instance,
-				 char *file, int *psize);
+				 const char *file, int *psize);
+int tracefs_instance_file_read_int(struct tracefs_instance *instance,
+				   const char *file, long long *res);
+int tracefs_instance_file_open(struct tracefs_instance *instance,
+			       const char *file, int mode);
 int tracefs_instances_walk(int (*callback)(const char *, void *), void *context);
 
 bool tracefs_instance_exists(const char *name);
diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index bf3de7c..27b9e99 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -14,7 +14,7 @@
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <dirent.h>
-#include <linux/limits.h>
+#include <limits.h>
 #include "tracefs.h"
 #include "tracefs-local.h"
 
@@ -282,7 +282,7 @@ int tracefs_instance_file_write(struct tracefs_instance *instance,
  * The return string must be freed by free()
  */
 char *tracefs_instance_file_read(struct tracefs_instance *instance,
-				  char *file, int *psize)
+				 const char *file, int *psize)
 {
 	char *buf = NULL;
 	int size = 0;
@@ -301,6 +301,61 @@ char *tracefs_instance_file_read(struct tracefs_instance *instance,
 	return buf;
 }
 
+/**
+ * tracefs_instance_file_read_int - Read an integer from a trace file.
+ * @instance: ftrace instance, can be NULL for the top instance
+ * @file: name of the file
+ * @res: The integer from the file.
+ *
+ * Returns 0 if the reading is successful and the result is stored in res, -1
+ * in case of an error.
+ */
+int tracefs_instance_file_read_int(struct tracefs_instance *instance,
+				   const char *file, long long *res)
+{
+	long long ret = LLONG_MAX;
+	int size = 0;
+	char *str;
+
+	str = tracefs_instance_file_read(instance, file, &size);
+	if (size && str)
+		ret = strtoll(str, NULL, 0);
+	free(str);
+
+	if (LLONG_MIN == ret || LLONG_MAX == ret)
+		return -1;
+	*res = ret;
+	return 0;
+}
+
+/**
+ * tracefs_instance_file_open - Open a trace file for reading and writing
+ * @instance: ftrace instance, can be NULL for the top instance
+ * @file: name of the file
+ * @mode: file open flags, -1 for default O_RDWR
+ *
+ * Returns -1 in case of an error, or a valid file descriptor otherwise.
+ * The returned FD must be closed with close()
+ */
+int tracefs_instance_file_open(struct tracefs_instance *instance,
+			       const char *file, int mode)
+{
+	int flags = O_RDWR;
+	int fd = -1;
+	char *path;
+
+	path = tracefs_instance_get_file(instance, file);
+	if (!path)
+		return -1;
+
+	if (mode >= 0)
+		flags = mode;
+	fd = open(path, flags);
+	tracefs_put_tracing_file(path);
+
+	return fd;
+}
+
 static bool check_file_exists(struct tracefs_instance *instance,
 			     char *name, bool dir)
 {
-- 
2.29.2


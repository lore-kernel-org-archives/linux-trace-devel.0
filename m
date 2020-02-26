Return-Path: <SRS0=1BtL=4O=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 898A5C4BA18
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Feb 2020 16:32:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6281524680
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Feb 2020 16:32:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I9zkG5DT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbgBZQcG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Feb 2020 11:32:06 -0500
Received: from mail-lf1-f54.google.com ([209.85.167.54]:42036 "EHLO
        mail-lf1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727173AbgBZQcG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Feb 2020 11:32:06 -0500
Received: by mail-lf1-f54.google.com with SMTP id 83so2440914lfh.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Feb 2020 08:32:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T4zUXxck4HFOGvDPhR/G9ns6j0YeeWdcvt2M0bB8PGM=;
        b=I9zkG5DTeViIvtRwgWSLZYN/PXXScflYj7bmmY8b7Nig8Lha3mckA0dHH/a+8UcYi6
         ew2ZgU2Gv6+q9dBksZmTtdUQa0nB/KGxJfyhZbcO5TpKmLix5DRpI83LUVJOJq6Y4XOQ
         D3PABR1bo7GyWdcjrSsOb88rlpci+jqu1wbz3/80bFIrtyEfPaeDtcnx4wdUuYJ7NdPf
         hqQXw3s2nGwbPGuio9sQFIhz+7d/XQf+JuEzbloi2jxMCbZO0Zsu2DIbVRz7H3pix0kt
         MoUADxl8gd2Njnnj9s6zb4rmJnQM6ziNCjcaAIy4C4QZN3IhFMeyWkrJl86GC/SpYNCy
         E3sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T4zUXxck4HFOGvDPhR/G9ns6j0YeeWdcvt2M0bB8PGM=;
        b=GlTak0yxgk5uO15edidv1/sjsG1EvITZB25D4ptU+uYxSGZYCK4gKWp/7nrVOUHHoQ
         RscxMv5XA3N+VX3Us/6jatSNXUe3N6ZtC/yB9WZc+RTLo2swzKaVMdmoKR5jvNhdUceI
         putJn+TLZWGYAJ6YB9e7yi6O6LF9C5n4EpJeNWAPPjaCBZDMHIU6QUrnwdSvoOEgcBZ3
         mM1Pekkak8KsjVhFrv0yxzVPiuMnLwUKoD3CW5PSNavHRd2b76Mozsq6isjx3I1U+P3v
         j3tnxUoRImunxRYkkD6fwKZLjR/+2gNYbJqJfXV1l7e5a1xSS//KwW2eoVP4gtq3iOlZ
         +J3w==
X-Gm-Message-State: APjAAAXh5eNEZIL5CKizNJzVMxTxDnS05/E02qhBNIG/ZSUGGpJoDSvF
        AC0R9m4tJNSXASyFoNteEgqGQbGkNeA=
X-Google-Smtp-Source: APXvYqxKyKEiEiTHLlVd5BHPZYFqOKzGJe1PZ/oDZACM7wq69pN+cwfNRGSIshGOYD78dT9+ARIfUw==
X-Received: by 2002:ac2:44a5:: with SMTP id c5mr2771256lfm.4.1582734723238;
        Wed, 26 Feb 2020 08:32:03 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s2sm1264133lfd.67.2020.02.26.08.32.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 08:32:02 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 1/5] trace-cmd: Add new libtracefs API tracefs_instance_file_append()
Date:   Wed, 26 Feb 2020 18:31:55 +0200
Message-Id: <20200226163159.20232-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200226163159.20232-1-tz.stoyanov@gmail.com>
References: <20200226163159.20232-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The existing tracefs_instance_file_write() API truncates the file before writing to it.
The are use cases where the file must not be truncated. The new
  tracefs_instance_file_append()
API appends to the end of the file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs/tracefs.h      |  2 ++
 lib/tracefs/tracefs-instance.c | 53 +++++++++++++++++++++++++---------
 2 files changed, 41 insertions(+), 14 deletions(-)

diff --git a/include/tracefs/tracefs.h b/include/tracefs/tracefs.h
index bc8bebcb..22f147a3 100644
--- a/include/tracefs/tracefs.h
+++ b/include/tracefs/tracefs.h
@@ -30,6 +30,8 @@ tracefs_instance_get_file(struct tracefs_instance *instance, const char *file);
 char *tracefs_instance_get_dir(struct tracefs_instance *instance);
 int tracefs_instance_file_write(struct tracefs_instance *instance,
 				const char *file, const char *str);
+int tracefs_instance_file_append(struct tracefs_instance *instance,
+				 const char *file, const char *str);
 char *tracefs_instance_file_read(struct tracefs_instance *instance,
 				 char *file, int *psize);
 
diff --git a/lib/tracefs/tracefs-instance.c b/lib/tracefs/tracefs-instance.c
index 67123e7c..cc4bc1b4 100644
--- a/lib/tracefs/tracefs-instance.c
+++ b/lib/tracefs/tracefs-instance.c
@@ -176,12 +176,16 @@ char *tracefs_instance_get_name(struct tracefs_instance *instance)
 	return NULL;
 }
 
-static int write_file(const char *file, const char *str)
+static int write_file(const char *file, const char *str, bool appned)
 {
 	int ret;
 	int fd;
 
-	fd = open(file, O_WRONLY | O_TRUNC);
+	if (appned)
+		fd = open(file, O_WRONLY | O_APPEND);
+	else
+		fd = open(file, O_WRONLY | O_TRUNC);
+
 	if (fd < 0) {
 		warning("Failed to open '%s'", file);
 		return -1;
@@ -191,17 +195,8 @@ static int write_file(const char *file, const char *str)
 	return ret;
 }
 
-
-/**
- * tracefs_instance_file_write - Write in trace file of specific instance.
- * @instance: ftrace instance, can be NULL for the top instance
- * @file: name of the file
- * @str: nul terminated string, that will be written in the file.
- *
- * Returns the number of written bytes, or -1 in case of an error
- */
-int tracefs_instance_file_write(struct tracefs_instance *instance,
-				 const char *file, const char *str)
+static int instance_file_write(struct tracefs_instance *instance,
+			       const char *file, const char *str, bool appned)
 {
 	struct stat st;
 	char *path;
@@ -212,12 +207,42 @@ int tracefs_instance_file_write(struct tracefs_instance *instance,
 		return -1;
 	ret = stat(path, &st);
 	if (ret == 0)
-		ret = write_file(path, str);
+		ret = write_file(path, str, appned);
 	tracefs_put_tracing_file(path);
 
 	return ret;
 }
 
+/**
+ * tracefs_instance_file_write - Write in trace file of specific instance.
+ * @instance: ftrace instance, can be NULL for the top instance
+ * @file: name of the file
+ * @str: nul terminated string, that will be written in the file.
+ *
+ * Returns the number of written bytes, or -1 in case of an error.
+ * The content of the file is replaced with the new one.
+ *
+ */
+int tracefs_instance_file_write(struct tracefs_instance *instance,
+				 const char *file, const char *str)
+{
+	return instance_file_write(instance, file, str, false);
+}
+
+/**
+ * tracefs_instance_file_append - Append to a trace file of specific instance.
+ * @instance: ftrace instance, can be NULL for the top instance
+ * @file: name of the file
+ * @str: nul terminated string, that will be written in the file.
+ *
+ * Returns the number of written bytes, or -1 in case of an error.
+ */
+int tracefs_instance_file_append(struct tracefs_instance *instance,
+				 const char *file, const char *str)
+{
+	return instance_file_write(instance, file, str, true);
+}
+
 /**
  * tracefs_instance_file_read - Read from a trace file of specific instance.
  * @instance: ftrace instance, can be NULL for the top instance
-- 
2.24.1


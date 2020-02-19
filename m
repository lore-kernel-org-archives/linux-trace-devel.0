Return-Path: <SRS0=qXaB=4H=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 798ADC3404D
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Feb 2020 13:15:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50EB724656
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Feb 2020 13:15:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O4g+tV5a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbgBSNPb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Feb 2020 08:15:31 -0500
Received: from mail-lj1-f175.google.com ([209.85.208.175]:44451 "EHLO
        mail-lj1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbgBSNPb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Feb 2020 08:15:31 -0500
Received: by mail-lj1-f175.google.com with SMTP id q8so288253ljj.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Feb 2020 05:15:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yUJEFgqF77a22sVBVp5KftZucbUUwOArGg2spM5M8EM=;
        b=O4g+tV5aGQBT/S0EWV9kQ3RnAnPUPfMSQy2k0K65vD0EvaCxJZnY0cdTw9LNXjfvh3
         C2O4vyLLqOu37kJ3F3whdYR8yIsQ/prV+nyxmZUJR/S3P1bEIGSN12qpXk3baFId+LGq
         dJqRY+SO1Gc5h3KwZnpq0n2wn8as43Kq+1DcbZQkbUfaRtwITyR0YzQjk97BgS5YfG2E
         8OfT60eMBN8Ohqva6T+J6yLXDsnzqaHqW8DaNFkQeCxEBlErrNdyS/WRyEqp55O2Q4wd
         i/CiQlifJ1vqdKkPcmkLO5OfGSrELXAbfLmGlpkMWadpB/XgTc74kotZgvHGSQ/GvNn5
         BXQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yUJEFgqF77a22sVBVp5KftZucbUUwOArGg2spM5M8EM=;
        b=g4wo3LsGcmGhgvtn+8/7HWypFH+1eU+B5OqLtAeHZ90h1CCgRywpdHPBKKhq3Bh8JD
         cWpp4vLu6cV2e9ofbpglSKSIaQRL+6YdnifZQIRpWT293LB47+gA9fr1L1iXFTCWmiQ4
         11YDb7bcxtja73iq7BNxK8mS4rBEKI+fXQDT3C0zO3r0ZpRA0QSw0OGr3AU6t24juQ97
         /iI+dH+112bdGBXOtige+xBqGSfZ5DpLXEPcgcDQsA7cgdrNvB9PoCrvIVaud+cn+H93
         3PIP21/KFQpWzazkgYiecdp8Pt4VyE/JxL9IJ7+HfeUv61yLyGbKsUu64JhKCNV5oqbd
         UzCg==
X-Gm-Message-State: APjAAAW4pmO36jqNXBw62kwZNPA0Opc3CJBzGFIvYK01rqgwkeYvPWVD
        dp1uswTL9MZs18Hx1KsA7GM=
X-Google-Smtp-Source: APXvYqwvb1Inl7igrONzHyy6WiTO+cHeM7zDHtPxuNv/4w4UlKgjMIDwVCnMJTk3SvfVsPb33zP+ww==
X-Received: by 2002:a2e:9256:: with SMTP id v22mr16723306ljg.45.1582118128814;
        Wed, 19 Feb 2020 05:15:28 -0800 (PST)
Received: from localhost.localdomain ([151.251.253.122])
        by smtp.gmail.com with ESMTPSA id f11sm1482766lfa.9.2020.02.19.05.15.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 05:15:28 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 1/2] trace-cmd: Add new libtracefs API tracefs_instance_file_append()
Date:   Wed, 19 Feb 2020 15:15:22 +0200
Message-Id: <20200219131523.447352-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200219131523.447352-1-tz.stoyanov@gmail.com>
References: <20200219131523.447352-1-tz.stoyanov@gmail.com>
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
 lib/tracefs/tracefs-instance.c | 40 ++++++++++++++++++++++++++++++----
 2 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/include/tracefs/tracefs.h b/include/tracefs/tracefs.h
index bd3f732..16fcb66 100644
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
index b96ab61..e6b0a95 100644
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
@@ -198,7 +202,9 @@ static int write_file(const char *file, const char *str)
  * @file: name of the file
  * @str: nul terminated string, that will be written in the file.
  *
- * Returns the number of written bytes, or -1 in case of an error
+ * Returns the number of written bytes, or -1 in case of an error.
+ * The content of the file is replaced with the new one.
+ *
  */
 int tracefs_instance_file_write(struct tracefs_instance *instance,
 				 const char *file, const char *str)
@@ -212,7 +218,33 @@ int tracefs_instance_file_write(struct tracefs_instance *instance,
 		return -1;
 	ret = stat(path, &st);
 	if (ret == 0)
-		ret = write_file(path, str);
+		ret = write_file(path, str, false);
+	tracefs_put_tracing_file(path);
+
+	return ret;
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
+	struct stat st;
+	char *path;
+	int ret;
+
+	path = tracefs_instance_get_file(instance, file);
+	if (!path)
+		return -1;
+	ret = stat(path, &st);
+	if (ret == 0)
+		ret = write_file(path, str, true);
 	tracefs_put_tracing_file(path);
 
 	return ret;
-- 
2.24.1


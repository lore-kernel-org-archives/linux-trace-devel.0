Return-Path: <SRS0=ULQB=4F=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A435FC34024
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 Feb 2020 17:40:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EB7C20725
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 Feb 2020 17:40:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lurxcQy0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729361AbgBQRkH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 Feb 2020 12:40:07 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:34419 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726818AbgBQRkH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 Feb 2020 12:40:07 -0500
Received: by mail-lf1-f66.google.com with SMTP id l18so12500626lfc.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Feb 2020 09:40:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yUJEFgqF77a22sVBVp5KftZucbUUwOArGg2spM5M8EM=;
        b=lurxcQy0uFmpH4U0f8fsIs/5zF32hgYidFF+6oyctAh+SrjD705Nu76AtlDWtYcbOS
         0sPrvRQXATn7pCjneFwxW101J2Ftef/WZdQFj1mdS+AOYgPJzb751uG0g0PCifJo0g6v
         5beVF6GUs7Fuapp0AoqSzJDTHEX+0o4evgqn5b0gTecqUcr5ByIp0U4kn21jLM0d2tKj
         IJpw4RSYjuWm3uYTlYc5CbRNVr234GMbOOxnj+KB5Q6TAypd1ki18vx/WZb7JEKB68I6
         f18fvrt77nGNWxXHJC+UszA+pMPZl35MZ6XDgnBllRlVa+aEM8x6fevJOlNKlb4dQyIF
         GL0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yUJEFgqF77a22sVBVp5KftZucbUUwOArGg2spM5M8EM=;
        b=h5wfeTjseezKanedNBqogeMbfFSwrnETehH3fBCTmjU0O99YkluRkdgbQVOdPUWX2A
         LEfCPMxQO3opF1lS+Xw84aoU5zMvffMsxM4A3zcc3WWG5smmbQrifshJCv4iFBMjf49y
         96+Z4N97mvzYKqTNuUwYZN9FRc0OYAPAupXttGhOgU6ShgSn6VD+tYhA6e7+m4q2w5lt
         42no/ukzIBa+6L4ewXbDYqmSMlHkqcHmXkuWgOiffMnOJLXx0nQ+OqaE2xxg/9GUQBZ/
         giAYZ96Fcdwmmt9HNVjkH5UvM1fgp0saTb05dLf+eRS9ND9ZSNswsEQnpCAsnBEYB+13
         CeZQ==
X-Gm-Message-State: APjAAAXh4Q+lAy/DUlLWxO2E7Wox7J15Qz6TIRD5adJrvKE273gcw/lv
        F6Fbgzbqm3X509NbDxcSRGppR4sDhQg=
X-Google-Smtp-Source: APXvYqwnRjq0ZwWJupKOYV27MB/m7px1WaVF9jH4imgFkIquFXrvLRz1PsS5RJnOHsgbEWbg0o9PkA==
X-Received: by 2002:a19:f610:: with SMTP id x16mr8459975lfe.80.1581961205249;
        Mon, 17 Feb 2020 09:40:05 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e8sm933508ljb.45.2020.02.17.09.40.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 09:40:04 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/4] trace-cmd: Add new libtracefs API tracefs_instance_file_append()
Date:   Mon, 17 Feb 2020 19:39:56 +0200
Message-Id: <20200217173959.385278-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200217173959.385278-1-tz.stoyanov@gmail.com>
References: <20200217173959.385278-1-tz.stoyanov@gmail.com>
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


Return-Path: <SRS0=Ara6=2J=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB49DC43603
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Dec 2019 11:35:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9123D20716
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Dec 2019 11:35:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="deA5Zmpa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbfLSLfN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Dec 2019 06:35:13 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:43546 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbfLSLfN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Dec 2019 06:35:13 -0500
Received: by mail-lj1-f193.google.com with SMTP id a13so5844687ljm.10
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Dec 2019 03:35:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ah33Za9HfOuq0wk/2g+CL5lAhkGRvrmcjpWhZWByOWc=;
        b=deA5Zmpanho7d0b7TLH86dMQUJ4nswdPe5ek0+MsXgKLUpvV/90bvRDpFnJ/2165V2
         7vCj1Qnv7q8uRY/nccJcKgQRvhMoblhn4MexKuh7+zCZfL0aumWYy/yvq00JJo0+O5sK
         i+XIx9IrbLXLTV/xSokL64Pc1jrYgkWIDcoHuwu1iajRWlQfTcRMPnoeWL2qiWi67oIO
         pmFA1Vy51bJNqe6orNWaSR3mssXwXMzZeuGpswapXFrV7Kw+xEoEghfAeLCWBPj7eVgR
         0or/6gazyLhbq7AcwbJIUWKyr4WeihkDyZgAwWrIaOsmoVhc/tqrW2tfAPgT4ysbmJFH
         LHaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ah33Za9HfOuq0wk/2g+CL5lAhkGRvrmcjpWhZWByOWc=;
        b=Wlj2/0ZmxIkxXeVIHAjH+OsVzK9bVyZy5koe3zylwegYltNiAXiEaNWcx7KjtHmJbx
         17uMXdN2LErjTISWMTFvXQjm4wqYEs9J3U+phKtcUyAdYtkcpPkYe/2u9EXDOmhRlB15
         hTzCIZSvQiEykhMJM0/Fzn7wkK8H+8tH19BkwrAkAJjCqQdhURc9CfLC3oeqjkjgMeP0
         Pggdz3YZG1YSzqVgo5g37uI9xojVXFGRejOSIPs8ZUhUg6uNY0BsqYhilU2L+HwUlLM7
         QaidGPTjlJeQa8iRsZ5EPzSDWvZYwL4rKt+kqHjJZavZrFv4bi2wDgnKWdOaREl99tJx
         W0gw==
X-Gm-Message-State: APjAAAWWUXvQVavFfppXdPHj/bJyKnXRSWVcZ9s+f3zAdNpxzDArSuhr
        zOlN836pekZ97MHPJ+0i39kMo5wPLEI=
X-Google-Smtp-Source: APXvYqwcsOW9TRPlbTdSbPFortH4U18uytTcHw2LTCyrPfAi9knn2Z4Uf3W2jA1nBERv6EyU6gQYFg==
X-Received: by 2002:a2e:880c:: with SMTP id x12mr5119204ljh.44.1576755310407;
        Thu, 19 Dec 2019 03:35:10 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id d4sm2437022lfn.42.2019.12.19.03.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 03:35:09 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/6] trace-cmd: New libtracefs API tracefs_write_file()
Date:   Thu, 19 Dec 2019 13:34:59 +0200
Message-Id: <20191219113502.28964-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191219113502.28964-1-tz.stoyanov@gmail.com>
References: <20191219113502.28964-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Moved write_file() static function from trace-record.c to
libtracefs API. The new API will be useful in future libtracefs
extension.
All die() calls in its implementation are replaced with warning().
A check is added to all current callers of tracefs_write_file(),
in case of a error die() is called, to keep the existing behavior.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs/tracefs.h   |  2 ++
 lib/tracefs/tracefs-utils.c | 41 ++++++++++++++++++++++++++++++++
 tracecmd/trace-record.c     | 47 ++++++++++++-------------------------
 3 files changed, 58 insertions(+), 32 deletions(-)

diff --git a/include/tracefs/tracefs.h b/include/tracefs/tracefs.h
index e844c75..6120dbe 100644
--- a/include/tracefs/tracefs.h
+++ b/include/tracefs/tracefs.h
@@ -17,4 +17,6 @@ const char *tracefs_get_tracing_dir(void);
 /* tracefs_find_tracing_dir must be freed */
 char *tracefs_find_tracing_dir(void);
 
+int tracefs_write_file(const char *file, const char *str, const char *type);
+
 #endif /* _TRACE_FS_H */
diff --git a/lib/tracefs/tracefs-utils.c b/lib/tracefs/tracefs-utils.c
index c695b8b..42a3f46 100644
--- a/lib/tracefs/tracefs-utils.c
+++ b/lib/tracefs/tracefs-utils.c
@@ -7,6 +7,8 @@
 #include <sys/mount.h>
 #include <sys/stat.h>
 #include <linux/limits.h>
+#include <fcntl.h>
+#include <unistd.h>
 
 #include "tracefs.h"
 
@@ -178,3 +180,42 @@ void tracefs_put_tracing_file(char *name)
 {
 	free(name);
 }
+
+/*
+ * tracefs_write_file - Write in trace file
+ * @file: Full name of the trace file.
+ * @str: A null-terminated string, that will be written in the file.
+ * @type: A null-terminated string, describing the current write operation.
+ *        Used for logging purposes. If not NULL, in case of an error the
+ *        content of the file is dumped to stderror.
+ *
+ * Returns the number of written bytes, or -1 in case of an error
+ */
+int tracefs_write_file(const char *file, const char *str, const char *type)
+{
+	char buf[BUFSIZ];
+	int ret;
+	int fd;
+
+	fd = open(file, O_WRONLY | O_TRUNC);
+	if (fd < 0) {
+		warning("Failed to open '%s'", file);
+		return -1;
+	}
+	ret = write(fd, str, strlen(str));
+	close(fd);
+	if (ret < 0 && type) {
+		/* write failed */
+		fd = open(file, O_RDONLY);
+		if (fd < 0) {
+			warning("Failed to write in '%s'", file);
+			return -1;
+		}
+
+		while ((ret = read(fd, buf, BUFSIZ)) > 0)
+			fprintf(stderr, "%.*s", ret, buf);
+		warning("Failed %s of %s\n", type, file);
+		close(fd);
+	}
+	return ret;
+}
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 5355813..be21f3d 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -832,31 +832,6 @@ get_instance_dir(struct buffer_instance *instance)
 	return path;
 }
 
-static int write_file(const char *file, const char *str, const char *type)
-{
-	char buf[BUFSIZ];
-	int fd;
-	int ret;
-
-	fd = open(file, O_WRONLY | O_TRUNC);
-	if (fd < 0)
-		die("opening to '%s'", file);
-	ret = write(fd, str, strlen(str));
-	close(fd);
-	if (ret < 0 && type) {
-		/* write failed */
-		fd = open(file, O_RDONLY);
-		if (fd < 0)
-			die("writing to '%s'", file);
-		/* the filter has the error */
-		while ((ret = read(fd, buf, BUFSIZ)) > 0)
-			fprintf(stderr, "%.*s", ret, buf);
-		die("Failed %s of %s\n", type, file);
-		close(fd);
-	}
-	return ret;
-}
-
 static int
 write_instance_file(struct buffer_instance *instance,
 		    const char *file, const char *str, const char *type)
@@ -867,8 +842,11 @@ write_instance_file(struct buffer_instance *instance,
 
 	path = get_instance_file(instance, file);
 	ret = stat(path, &st);
-	if (ret == 0)
-		ret = write_file(path, str, type);
+	if (ret == 0) {
+		ret = tracefs_write_file(path, str, type);
+		if (ret < 0)
+			die("Failed to write file");
+	}
 	tracefs_put_tracing_file(path);
 
 	return ret;
@@ -2010,7 +1988,8 @@ static int find_trigger(const char *file, char *buf, int size, int fields)
 
 static void write_filter(const char *file, const char *filter)
 {
-	write_file(file, filter, "filter");
+	if (tracefs_write_file(file, filter, "filter") < 0)
+		die("Failed to write file");
 }
 
 static void clear_filter(const char *file)
@@ -2020,12 +1999,14 @@ static void clear_filter(const char *file)
 
 static void write_trigger(const char *file, const char *trigger)
 {
-	write_file(file, trigger, "trigger");
+	if (tracefs_write_file(file, trigger, "trigger") < 0)
+		die("Failed to write file");
 }
 
 static void write_func_filter(const char *file, const char *trigger)
 {
-	write_file(file, trigger, "function filter");
+	if (tracefs_write_file(file, trigger, "function filter") < 0)
+		die("Failed to write file");
 }
 
 static void clear_trigger(const char *file)
@@ -2117,8 +2098,10 @@ static void update_reset_files(void)
 		reset = reset_files;
 		reset_files = reset->next;
 
-		if (!keep)
-			write_file(reset->path, reset->reset, "reset");
+		if (!keep) {
+			if (tracefs_write_file(reset->path, reset->reset, "reset") < 0)
+				die("Failed to write file");
+		}
 		free(reset->path);
 		free(reset->reset);
 		free(reset);
-- 
2.23.0


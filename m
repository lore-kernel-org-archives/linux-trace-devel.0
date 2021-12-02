Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DC17C433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:19:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357781AbhLBMXT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:23:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357775AbhLBMXR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:23:17 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7335C061757
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:19:54 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id y12so115142109eda.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:19:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jTd3PP6x1sTycb4jaHwd23/AOF7eQ9WTKpV3YjO16bk=;
        b=QGMrNBiWkj7TKyYEPsGyacFNJPKB2F5iWH3wblBhu0Pw0pr85LRFUgnG/CZkxKqVrf
         uBGXmt6rjeAx6aPMz6ZKeSVBhoh8OiOKlegFR/bocFwxg3sUx/1iHxX53U4aSx2lvFuI
         k3shrtbzpGXdS+2ToH2gdxzyiRyH0UJ/S20j6jG58K0iuSE1BkKY7aFVGRud1R8RDWXg
         oY/LySDTvpRm+BJlvctIpPuSCviS1Sbj7F0UkNVQySBwmrbsy1duTB55qH6au7VtUUn1
         NxV1XUrEIiwKFoS8R6twk28G1asx//9cWgyffcL6E4kxjHp0F8/bEZ/XIBi0t2vhYLwg
         EOPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jTd3PP6x1sTycb4jaHwd23/AOF7eQ9WTKpV3YjO16bk=;
        b=6LkRGxRpDN4q8+pQchRu22/TzSW/5GRgIu7jraIV7JyluZ6k1Aldow8uZT0Z+W69JX
         Q77DXQmTYWz1qaHweDCVGlrm51/1HTUoKOE3pqhQS/vZl8ym2H/sVl+dvrlGsKzlV2eO
         aKCBsGHy6rUaepllRLgJQg87XzdYqvVyCyZsszipo8Ai/HzCc0ljK4FIwXY3J6SAMdmt
         moANFmylIDHL4CEuBxWJ87/kBuzpR7LsjrWIVlfNehqWJqRkBYaaR2jhebzVpcDB8xL4
         9BNFY9qIAQPhMK68RaqHyi0AS6p3bEPkZftJTnxIQHxYTo59UmJGa1JU0CvdFB9WHSN1
         5K7w==
X-Gm-Message-State: AOAM531TnFUF+eAZ3CuRFU08Dzc5xC/UzNlOD//+0i5f+eYH91miuLYD
        ovVTT9t+28Rm0p7x2rkB6sZdVUoldW+TtA==
X-Google-Smtp-Source: ABdhPJyFoSPd8QEpLu6UdSV3FDRGBDN/5rQJm/1GGhacdb6J5NiRKJvqh2yNSmtJH7do2E2nymAnLg==
X-Received: by 2002:a17:906:6a0a:: with SMTP id qw10mr14706167ejc.547.1638447593335;
        Thu, 02 Dec 2021 04:19:53 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id y15sm2229019eda.13.2021.12.02.04.19.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:19:52 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/5] trace-cmd library: New API for creating an output trace handle
Date:   Thu,  2 Dec 2021 14:19:46 +0200
Message-Id: <20211202121949.43084-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202121949.43084-1-tz.stoyanov@gmail.com>
References: <20211202121949.43084-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

There is lack of API to create an output trace handle to file with
given name, which is common use case. Existing flow is -  the library
user should create the file, open it and pass a file descriptor to the
library for creating the output handle. The proposed new API
	tracecmd_output_create()
has file name as input parameter. It creates a file with given name (or
truncates existing one) and create an output trace handle to that file.
The file name parameter is optional, if NULL is passed - the created
output trace handle will not be associated with a file.

Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  1 +
 lib/trace-cmd/trace-output.c                  | 46 +++++++++++++------
 tracecmd/trace-record.c                       | 12 ++---
 tracecmd/trace-restore.c                      | 16 +++----
 4 files changed, 44 insertions(+), 31 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index c7ade7ae..80027c9e 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -279,6 +279,7 @@ int tracecmd_output_write_init(struct tracecmd_output *handle);
 int tracecmd_output_write_headers(struct tracecmd_output *handle,
 				  struct tracecmd_event_list *list);
 
+struct tracecmd_output *tracecmd_output_create(const char *output_file);
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus);
 struct tracecmd_output *tracecmd_create_init_fd(int fd);
 
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 31f08751..2f8ebf25 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1442,17 +1442,11 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 {
 	struct tracecmd_output *handle;
 	char *path;
-	int fd;
 
-	fd = open(output_file, O_RDWR | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
-	if (fd < 0)
+	handle = tracecmd_output_create(output_file);
+	if (!handle)
 		return NULL;
 
-	handle = tracecmd_output_allocate(fd);
-	if (!handle)
-		goto out_free;
-	if (tracecmd_output_write_init(handle))
-		goto out_free;
 	if (tracecmd_output_write_headers(handle, NULL))
 		goto out_free;
 	/*
@@ -1806,6 +1800,34 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 	return NULL;
 }
 
+/**
+ * tracecmd_output_create - Create new output handle to a trace file with given name
+ * @output_file: Name of the trace file that will be created.
+ *
+ * The @output_file parameter can be NULL. In this case the output handle is created
+ * and initialized, but is not associated with a file.
+ *
+ * Returns pointer to created outpuy handle, or NULL in case of an error.
+ */
+struct tracecmd_output *tracecmd_output_create(const char *output_file)
+{
+	struct tracecmd_output *out;
+	int fd = -1;
+
+	if (output_file) {
+		fd = open(output_file, O_RDWR | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
+		if (fd < 0)
+			return NULL;
+	}
+	out = tracecmd_output_allocate(fd);
+	if (!out && fd >= 0) {
+		close(fd);
+		unlink(output_file);
+	}
+
+	return out;
+}
+
 struct tracecmd_output *tracecmd_create_init_fd(int fd)
 {
 	struct tracecmd_output *out;
@@ -1855,15 +1877,11 @@ struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle,
 				      const char *file)
 {
 	struct tracecmd_output *handle;
-	int fd;
 
-	fd = open(file, O_RDWR | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
-	if (fd < 0)
+	handle = tracecmd_output_create(file);
+	if (!handle)
 		return NULL;
 
-	handle = tracecmd_output_allocate(fd);
-	if (!handle)
-		goto out_free;
 	if (tracecmd_output_set_from_input(handle, ihandle))
 		goto out_free;
 	tracecmd_output_write_init(handle);
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 3a84e116..677a4bd9 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3694,7 +3694,7 @@ static struct tracecmd_output *create_net_output(struct common_record_context *c
 {
 	struct tracecmd_output *out;
 
-	out = tracecmd_output_allocate(-1);
+	out = tracecmd_output_create(NULL);
 	if (!out)
 		return NULL;
 	if (tracecmd_output_set_msg(out, msg_handle))
@@ -4458,23 +4458,21 @@ static void write_guest_file(struct buffer_instance *instance)
 static struct tracecmd_output *create_output(struct common_record_context *ctx)
 {
 	struct tracecmd_output *out;
-	int fd;
 
-	fd = open(ctx->output, O_RDWR | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
-	if (fd < 0)
+	if (!ctx->output)
 		return NULL;
 
-	out = tracecmd_output_allocate(fd);
+	out = tracecmd_output_create(ctx->output);
 	if (!out)
 		goto error;
+
 	if (tracecmd_output_write_headers(out, listed_events))
 		goto error;
+
 	return out;
 error:
 	if (out)
 		tracecmd_output_close(out);
-	else
-		close(fd);
 	unlink(ctx->output);
 	return NULL;
 }
diff --git a/tracecmd/trace-restore.c b/tracecmd/trace-restore.c
index 8d2fcae8..23a7f4af 100644
--- a/tracecmd/trace-restore.c
+++ b/tracecmd/trace-restore.c
@@ -26,15 +26,11 @@ static struct tracecmd_output *create_output(const char *file,
 					     const char *tracing_dir, const char *kallsyms)
 {
 	struct tracecmd_output *out;
-	int fd;
 
-	fd = open(file, O_RDWR | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
-	if (fd < 0)
-		return NULL;
-
-	out = tracecmd_output_allocate(fd);
+	out = tracecmd_output_create(file);
 	if (!out)
 		goto error;
+
 	if (tracing_dir && tracecmd_output_set_trace_dir(out, tracing_dir))
 		goto error;
 	if (kallsyms && tracecmd_output_set_kallsyms(out, kallsyms))
@@ -45,8 +41,6 @@ static struct tracecmd_output *create_output(const char *file,
 error:
 	if (out)
 		tracecmd_output_close(out);
-	else
-		close(fd);
 	unlink(file);
 	return NULL;
 }
@@ -155,8 +149,10 @@ void trace_restore (int argc, char **argv)
 
 		handle = tracecmd_copy(ihandle, output);
 		tracecmd_close(ihandle);
-	} else
-		handle = tracecmd_create_init_file(output);
+	} else {
+		handle = tracecmd_output_create(output);
+		tracecmd_output_write_headers(handle, NULL);
+	}
 
 	if (!handle)
 		die("error writing to %s", output);
-- 
2.33.1


Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8AF3C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FEB361019
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233890AbhG2FKS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233899AbhG2FKR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:17 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8404C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:13 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id yk17so752187ejb.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iqXq1btnwLlu6+e/tvIEz5L9oqCqgH9SaYhQNAigCmA=;
        b=J5Pov3rE5lLIdVD0GD5SEkcsjncOeKsSd5+ul4ZWlreX+PknuU2+nhJrOOQqUsXYX8
         krI0S1FFLXUPLbjwmtQ9OeqcsaxBFIi3Q2wA7kzStDr4DUW7WIb2SdMFLcjnEYOT36Iz
         mL2IEgUDJlQ2Y1Cr6LdOirA1A9pXpCzSmsW+aGAKn8L3kVNuzqEQAXMm+zXXhp/bUwhF
         VjcWFqcymEj6JhDKTVFvnAtQ5eL7PV0y2Dn76guyg5+MtRIP8jPPvw8g4onr83Ileoci
         v2l7EhskvNbo1KhHWV9otRIF35Qf+XQcu9bxsO4z1nIw1/3oNa/g1w5Vj78VZYl3BtQ0
         r0Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iqXq1btnwLlu6+e/tvIEz5L9oqCqgH9SaYhQNAigCmA=;
        b=JNWBHnIpzEOJOh0Dic3TXQfx6J48o+lKYXSCwqzVADWzdMA0ZGVDYzyfpIfvZyOoCt
         he4x+XGoJ8KbZrd5DMa8QZUJ4KvInthvo7Z0J2n9Q+K7L2hvVxTFBu1Psq7Kuc9/w+W2
         CD+MYg6ZMHZ2JdZFWq46RQ6BZc17bjJiknhkWnX3sn5z7XpxbCMvtrxpESSBdQlIPXpG
         +tZSu3z9iBvGyxtfY3I7XAA6cBpgaPF46Vy5IwJPzdv6vTiVGeNzmlDXTQv7TRaXkUNk
         myzDQkW1IR7PZ48F8J8/4lWJnB6OAk3eiC8/S/DZvhAeiuSK435CFQntlZwA14olnZiV
         vT6g==
X-Gm-Message-State: AOAM531EAZuJLZshgI7M2wiJfgEAhSAGtnWKB9cLeH7rgOJ4q26IXlbJ
        PU+ZqXvdaiCOZ3Q9VsTFJ25gqp/ch6q+2w==
X-Google-Smtp-Source: ABdhPJxFCH5dzyb8+d958KDnchNIUdtpSxvAU/ZdDiGlOmWCYXAc8OMs5qTmpzwZGYi1QLNmkwZGVw==
X-Received: by 2002:a17:906:cc57:: with SMTP id mm23mr2793192ejb.12.1627535412470;
        Wed, 28 Jul 2021 22:10:12 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:12 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 11/87] trace-cmd library: Internal helpers for uncompressing data
Date:   Thu, 29 Jul 2021 08:08:43 +0300
Message-Id: <20210729050959.12263-12-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

New library internal helper functions are introduced, to add compression
functionality to the input trace handler.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/trace-cmd-local.h |  4 ++
 lib/trace-cmd/trace-input.c             | 53 +++++++++++++++++++++----
 2 files changed, 49 insertions(+), 8 deletions(-)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 14c4dd08..271c55a7 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -38,6 +38,10 @@ int out_uncompress_block(struct tracecmd_output *handle);
 int out_compression_start(struct tracecmd_output *handle);
 int out_compression_end(struct tracecmd_output *handle);
 void out_compression_reset(struct tracecmd_output *handle);
+
+void in_uncompress_reset(struct tracecmd_input *handle);
+int in_uncompress_block(struct tracecmd_input *handle);
+
 unsigned long long out_copy_fd_compress(struct tracecmd_output *handle,
 					int fd, unsigned long long max,
 					unsigned long long *write_size);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 787d6825..e759285b 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -136,6 +136,9 @@ struct tracecmd_input {
 	long long		ts_offset;
 	struct tsc2nsec		tsc_calc;
 
+	bool			read_compress;
+	struct tracecmd_compression *compress;
+
 	struct host_trace_info	host;
 	double			ts2secs;
 	char *			cpustats;
@@ -238,13 +241,13 @@ static const char *show_records(struct page **pages, int nr_pages)
 
 static int init_cpu(struct tracecmd_input *handle, int cpu);
 
-static ssize_t do_read(struct tracecmd_input *handle, void *data, size_t size)
+static ssize_t do_read_fd(int fd, void *data, size_t size)
 {
 	ssize_t tot = 0;
 	ssize_t r;
 
 	do {
-		r = read(handle->fd, data + tot, size - tot);
+		r = read(fd, data + tot, size - tot);
 		tot += r;
 
 		if (!r)
@@ -256,12 +259,28 @@ static ssize_t do_read(struct tracecmd_input *handle, void *data, size_t size)
 	return tot;
 }
 
+static inline int do_lseek(struct tracecmd_input *handle, int offset, int whence)
+{
+	if (handle->read_compress)
+		return tracecmd_compress_lseek(handle->compress, offset, whence);
+	else
+		return lseek(handle->fd, offset, whence);
+}
+
+static inline ssize_t do_read_compressed(struct tracecmd_input *handle, void *data, size_t size)
+{
+	if (handle->read_compress)
+		return tracecmd_compress_read(handle->compress, data, size);
+	else
+		return do_read_fd(handle->fd, data, size);
+}
+
 static ssize_t
 do_read_check(struct tracecmd_input *handle, void *data, size_t size)
 {
 	ssize_t ret;
 
-	ret = do_read(handle, data, size);
+	ret = do_read_compressed(handle, data, size);
 	if (ret < 0)
 		return ret;
 	if (ret != size)
@@ -279,10 +298,8 @@ static char *read_string(struct tracecmd_input *handle)
 	ssize_t r;
 
 	for (;;) {
-		r = do_read(handle, buf, BUFSIZ);
-		if (r < 0)
-			goto fail;
-		if (!r)
+		r = do_read_compressed(handle, buf, BUFSIZ);
+		if (r <= 0)
 			goto fail;
 
 		for (i = 0; i < r; i++) {
@@ -308,7 +325,7 @@ static char *read_string(struct tracecmd_input *handle)
 	}
 
 	/* move the file descriptor to the end of the string */
-	r = lseek(handle->fd, -(r - (i+1)), SEEK_CUR);
+	r = do_lseek(handle, -(r - (i+1)), SEEK_CUR);
 	if (r < 0)
 		goto fail;
 
@@ -372,6 +389,26 @@ static int read8(struct tracecmd_input *handle, unsigned long long *size)
 	return 0;
 }
 
+__hidden void in_uncompress_reset(struct tracecmd_input *handle)
+{
+	if (handle->compress) {
+		handle->read_compress = false;
+		tracecmd_compress_reset(handle->compress);
+	}
+}
+
+__hidden int in_uncompress_block(struct tracecmd_input *handle)
+{
+	int ret = 0;
+
+	if (handle->compress) {
+		ret = tracecmd_uncompress_block(handle->compress);
+		if (!ret)
+			handle->read_compress = true;
+	}
+	return ret;
+}
+
 static int read_header_files(struct tracecmd_input *handle)
 {
 	struct tep_handle *pevent = handle->pevent;
-- 
2.31.1


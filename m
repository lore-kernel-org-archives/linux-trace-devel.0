Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A14D2C4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:25:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbhLBM2h (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:28:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231820AbhLBM2f (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:28:35 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F552C06174A
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:25:13 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id t5so115449499edd.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:25:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bVSawsv30ZVfg5NoTn5D9FwmtdRF9aNmZ70voQlRL6w=;
        b=oE6MNkIqBrtsob/OlfSSmOu+jlVN+7pkTBQOtF4w9JwU9JNuU5YbzEZgLj20ur4QIb
         UyGysribet+YSToVRIb00YEYX5nFVO+XyTMJmBFkLD2bBeN5aEd73Ta8uXkd4jZg/ERX
         pq5Up6ttMQbPzQiaJ/7/z2BAGLXiMwEKd6uUOmOKVtspRJcPaV0hzyAEMZZHKP6z7XCm
         3wJzIxtZLpSR1UstPoJtCMEL+a5z/gotcq4h34qQAtqKxkGuUYxjTmjWqM/llxgJxV70
         QcBYVS1WbRzL/+sYgahhmUo15UNX/jxDuN47jfYyE9lMeWyPOyswwPrvkFnilrzoRGA4
         oF8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bVSawsv30ZVfg5NoTn5D9FwmtdRF9aNmZ70voQlRL6w=;
        b=BweYA8iJYMDopY4xjvNlmnL8pfSM8hLBMX6Bg3PLP5oe2tL2qAZTRtmkIRGjTBJUx5
         v1flLi8bdTgPVPb9m9tUJrSBC3cKltf50ty8iRnBEiulvdsra+p9/9YvKuOSd8c2It7W
         pn5Pzwr77uQahN0XJm8tmwwkF9lNlt3O+JVj04FwgBXaE7tyAqkurrul4NP8S4dCOosV
         Pb1QnVkufiICKAlgW72OoaIJR312Y5wklElfX3Gzj7gHhIRAcZrXGoLt+JZg5+KofRhO
         7ftxo6L28wBMUUe5AkUxSEImDjRzEpxcGD7XNWHJUPKT1K+MzlzXx9dTLnQIhU/Qs547
         7syA==
X-Gm-Message-State: AOAM532NsJ37kMhsCWAsrxxqypxuHeII4zEdkSFniF2UYntxZiNwq8k+
        txBo1W4zutTn6MbsbyrfPq8ua4RzzypBtQ==
X-Google-Smtp-Source: ABdhPJztdlyJ5O1sVbQx42IQ8kfxPLGJdpezqm04HDX3TumOX8+yhx/X0Wu55D5LeTKzFSPgplpkbw==
X-Received: by 2002:a05:6402:27cd:: with SMTP id c13mr17431240ede.236.1638447911714;
        Thu, 02 Dec 2021 04:25:11 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id eg8sm1998507edb.75.2021.12.02.04.25.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:25:11 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 03/20] trace-cmd library: Internal helpers for uncompressing data
Date:   Thu,  2 Dec 2021 14:24:50 +0200
Message-Id: <20211202122507.43572-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122507.43572-1-tz.stoyanov@gmail.com>
References: <20211202122507.43572-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

New library internal helper functions are introduced, to add compression
functionality to the input trace handler.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/trace-cmd-local.h |  3 ++
 lib/trace-cmd/trace-input.c             | 49 ++++++++++++++++++++++---
 2 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 4d58438b..fb479d8d 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -49,6 +49,9 @@ void out_compression_reset(struct tracecmd_output *handle, bool compress);
 unsigned long long out_copy_fd_compress(struct tracecmd_output *handle,
 					int fd, unsigned long long max,
 					unsigned long long *write_size);
+void in_uncompress_reset(struct tracecmd_input *handle);
+int in_uncompress_block(struct tracecmd_input *handle);
+
 unsigned long long
 out_write_section_header(struct tracecmd_output *handle, unsigned short header_id,
 			 char *description, int flags, bool option);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 5b8f5c93..f6d60aea 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -157,6 +157,9 @@ struct tracecmd_input {
 	long long		ts_offset;
 	struct tsc2nsec		tsc_calc;
 
+	bool			read_compress;
+	struct tracecmd_compression *compress;
+
 	struct host_trace_info	host;
 	double			ts2secs;
 	char *			cpustats;
@@ -263,13 +266,13 @@ static const char *show_records(struct page **pages, int nr_pages)
 
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
@@ -281,6 +284,22 @@ static ssize_t do_read(struct tracecmd_input *handle, void *data, size_t size)
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
+static inline ssize_t do_read(struct tracecmd_input *handle, void *data, size_t size)
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
@@ -305,9 +324,7 @@ static char *read_string(struct tracecmd_input *handle)
 
 	for (;;) {
 		r = do_read(handle, buf, BUFSIZ);
-		if (r < 0)
-			goto fail;
-		if (!r)
+		if (r <= 0)
 			goto fail;
 
 		for (i = 0; i < r; i++) {
@@ -333,7 +350,7 @@ static char *read_string(struct tracecmd_input *handle)
 	}
 
 	/* move the file descriptor to the end of the string */
-	r = lseek(handle->fd, -(r - (i+1)), SEEK_CUR);
+	r = do_lseek(handle, -(r - (i+1)), SEEK_CUR);
 	if (r < 0)
 		goto fail;
 
@@ -397,6 +414,26 @@ static int read8(struct tracecmd_input *handle, unsigned long long *size)
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
 static struct file_section *section_get(struct tracecmd_input *handle, int id)
 {
 	struct file_section *sec;
-- 
2.33.1


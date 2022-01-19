Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96ACAC433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:27:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352479AbiASI1h (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:27:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352465AbiASI1d (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:27:33 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE18C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:27:33 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id j2so7540395edj.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:27:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bJy8UUzL2DhI3wDSTtX7iRU3BncYzFKDyu55GqD5EMY=;
        b=Zru0kviUvMd8tQZYHRchlfXTv1DlivLPBobsug2kE8tROI91Z6G2dg3cZEPItvDVQH
         kRpmE4r87J80wQGMZNiXHBUie09kFPMugQfrK3pQQ8Dt1j2SD399p7mSlrtA9NfnlQz+
         zXhOwx8KgM2T0egnHRe3ntindvrC/pRmJdDg4spWhFJxqZU9hChYqjfZx3V2K1rOdZQR
         EkbCuT8fUifC3OSGsxKjoYlunhI7invMtNMKSFYe46BOtKIq/D33kkl3zJF/ghIYueU2
         wr4raple4fBIej+jJZodM9M7S76pfmA5QIM8c7phZOxxlxmqJL1YDMPUGXDDAo9Ocj+Z
         7uDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bJy8UUzL2DhI3wDSTtX7iRU3BncYzFKDyu55GqD5EMY=;
        b=QviBOHPyZfDn/wKvQd+0fXrleXW3xt3sq/zCkJfhlr9JhrpBBmN7F5djAhuy+NxQBX
         GNm6u93AtHR7XLI+rulk45LYMjpYlLmsI0sbaNad2Ts3gTueGf8HOmXn7B6sZBGAzv09
         aq35KVSvZY7ADYXQZLUARzr8vCytDmdjnu48kppfd1hCH2XzPe2qVdTt40FFZx2ryUxS
         yF73pXhPfBvx47Uw/tXgPQ0psBGquMXWrRT7pupsdLCKOpJHMnJQHzGMVNxS72MNtnMf
         uqZY1ZBqqTv4j2alLjxun/GBYfky2wRfVL/VTuKxL61gbEmWFZw2DGVmEmbEdnbjiIo4
         h7DQ==
X-Gm-Message-State: AOAM5334mROeV+kGmQEj7L9blS31Bs+ufTZC7Chi58bSvjersZP9c2Ds
        qQDYfAvgbnI9v/K5AIM4iVFYM4nY0dM=
X-Google-Smtp-Source: ABdhPJzKXYnfB++kcQx2l7tr75FFYvc+YuqEqexl+XCkyMXPTJK/TB1JRUQZh71AyKYGuZrqnfBmIg==
X-Received: by 2002:a17:907:7292:: with SMTP id dt18mr3922250ejc.446.1642580851830;
        Wed, 19 Jan 2022 00:27:31 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d14sm848703edu.57.2022.01.19.00.27.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:27:31 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 15/20] trace-cmd library: Read compressed latency data
Date:   Wed, 19 Jan 2022 10:27:10 +0200
Message-Id: <20220119082715.245846-16-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119082715.245846-1-tz.stoyanov@gmail.com>
References: <20220119082715.245846-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Extended the latency read logic for reading comperssed latency trace
data. Both decompressing approaches are supported: in-memory and
using temporary file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 74 +++++++++++++++++++++++++++++++++----
 1 file changed, 66 insertions(+), 8 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index f5241e4b..e772b463 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -177,6 +177,7 @@ struct tracecmd_input {
 	bool			cpu_compressed;
 	int			file_version;
 	unsigned int		cpustats_size;
+	struct cpu_zdata	latz;
 	struct cpu_data 	*cpu_data;
 	long long		ts_offset;
 	struct tsc2nsec		tsc_calc;
@@ -3465,20 +3466,52 @@ static int read_options_type(struct tracecmd_input *handle)
 
 int tracecmd_latency_data_read(struct tracecmd_input *handle, char **buf, size_t *size)
 {
+	struct cpu_zdata *zdata = &handle->latz;
+	void *data;
+	int rsize;
+	int fd = -1;
+	int id;
+
 	if (!handle || !buf || !size)
 		return -1;
 	if (handle->file_state != TRACECMD_FILE_CPU_LATENCY)
 		return -1;
 
-	/* Read data from a file */
-	if (!(*buf)) {
-		*size = BUFSIZ;
-		*buf = malloc(*size);
-		if (!(*buf))
+	if (!handle->cpu_compressed) {
+		fd = handle->fd;
+	} else if (!handle->read_zpage) {
+		if (zdata->fd < 0)
 			return -1;
+		fd = zdata->fd;
 	}
 
-	return do_read(handle, *buf, *size);
+	/* Read data from a file */
+	if (fd >= 0) {
+		if (!(*buf)) {
+			*size = BUFSIZ;
+			*buf = malloc(*size);
+			if (!(*buf))
+				return -1;
+		}
+		return do_read_fd(fd, *buf, *size);
+	}
+
+	/* Uncompress data in memory */
+	if (zdata->last_chunk >= zdata->count)
+		return 0;
+	id = zdata->last_chunk;
+	if (!*buf || *size < zdata->chunks[id].size) {
+		data = realloc(*buf, zdata->chunks[id].size);
+		if (!data)
+			return -1;
+		*buf = data;
+		*size = zdata->chunks[id].size;
+	}
+	if (tracecmd_uncompress_chunk(handle->compress, &zdata->chunks[id], *buf))
+		return -1;
+	rsize = zdata->chunks[id].size;
+	zdata->last_chunk++;
+	return rsize;
 }
 
 static int init_cpu_data(struct tracecmd_input *handle)
@@ -3546,7 +3579,27 @@ static int init_cpu_data(struct tracecmd_input *handle)
 
 int init_latency_data(struct tracecmd_input *handle)
 {
-	/* To do */
+	unsigned long long wsize;
+	int ret;
+
+	if (!handle->cpu_compressed)
+		return 0;
+
+	if (handle->read_zpage) {
+		handle->latz.count = tracecmd_load_chunks_info(handle->compress, &handle->latz.chunks);
+		if (handle->latz.count < 0)
+			return -1;
+	} else {
+		strcpy(handle->latz.file, COMPR_TEMP_FILE);
+		handle->latz.fd = mkstemp(handle->latz.file);
+		if (handle->latz.fd < 0)
+			return -1;
+		ret = tracecmd_uncompress_copy_to(handle->compress, handle->latz.fd, NULL, &wsize);
+		if (ret)
+			return -1;
+		lseek64(handle->latz.fd, 0, SEEK_SET);
+	}
+
 	return 0;
 }
 
@@ -4058,6 +4111,7 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 
 	handle->fd = fd;
 	handle->ref = 1;
+	handle->latz.fd = -1;
 	/* By default, use usecs, unless told otherwise */
 	handle->flags |= TRACECMD_FL_IN_USECS;
 
@@ -4349,7 +4403,11 @@ void tracecmd_close(struct tracecmd_input *handle)
 	free(handle->strings);
 	free(handle->version);
 	close(handle->fd);
-
+	free(handle->latz.chunks);
+	if (handle->latz.fd >= 0) {
+		close(handle->latz.fd);
+		unlink(handle->latz.file);
+	}
 	while (handle->sections) {
 		del_sec = handle->sections;
 		handle->sections = handle->sections->next;
-- 
2.34.1


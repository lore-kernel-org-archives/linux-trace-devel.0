Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2809AC433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:25:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235548AbhLBM2u (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:28:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235035AbhLBM2r (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:28:47 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8044FC061757
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:25:24 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id z5so50279130edd.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:25:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pUl0FrQ08+8JJ48IxcOYd6UdUBPSrP/d+5xADJCF6DE=;
        b=S0Qk5MWEVwMSyUzBH6DfKMArjDRceyt/OOeAL/rTXyPzkPZzC9HJ31ak3Fjknq+E0x
         js8Y3dHklgd80nHWVOgjLpPLS9mXh5sIe34zp1imHOTNuNm7TVSH7FfFtHCoElNMuLe5
         jQiFsXnp5RxkxODoSogqVeve4FUxc6GFz0ljFgsiclTLdtrMeRASrwbnb8LYp+kIpsL9
         +LyJh4RJsnFmkXa6rP0WLu1Dk1GwoHOlRbZ3bGE1hnx7UNoTblGdTyidzIM7w5/1BpN4
         F8MI0aOKLWbd2UXjJgob0cwoesUswpIS9vCT8MfnVZ/M44K3q3tYLrvoBlH0+mAxf9wJ
         uwtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pUl0FrQ08+8JJ48IxcOYd6UdUBPSrP/d+5xADJCF6DE=;
        b=yESvlgVYBbEhkKH2ndLkbLKMnBSdeCe/yKPR31ljZmjpZ9KokUXuwgAzo2D/YLdIe0
         rYNTL77UxopOINS7mAfwHpNog5oMqgvsrSQOS4l60G8o23APdFiXiVTsg/9253BWKiDh
         gYw2l44L826qEz85vONuSLkm14hNi2F/3Yu/yya902/OJJxzbZydcLxGnhCpuqnN6Iyj
         CdN19X2XBqQs603N0iyLFClIqjS9pSeS1pYos3XJgz6dwBK2ihofwKgLKyf90KxjwR2p
         WSZ4zCx+vwf/+6P7MXAUmBHLaIqe6eHdcxeLCdf6U7MhF873DHsPcyJczkGbKzUHdhCH
         y4cw==
X-Gm-Message-State: AOAM532aeN49PhNWkOvqDu57jpwJ6wzz7rH3pbXXVEo7MnFATd/UM0rt
        oDap640h6PJwYJxFn8TFfgyCcLKOGGpHXw==
X-Google-Smtp-Source: ABdhPJxZrxZNo2QZUNlg1ZRPMQ8r36GiZd1Yddh77mQXY3icDbOI7/cHZt9neIQbWYqKEMQFbZ8y3A==
X-Received: by 2002:a05:6402:2d9:: with SMTP id b25mr16582079edx.383.1638447923091;
        Thu, 02 Dec 2021 04:25:23 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id eg8sm1998507edb.75.2021.12.02.04.25.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:25:22 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 15/20] trace-cmd library: Read compressed latency data
Date:   Thu,  2 Dec 2021 14:25:02 +0200
Message-Id: <20211202122507.43572-16-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122507.43572-1-tz.stoyanov@gmail.com>
References: <20211202122507.43572-1-tz.stoyanov@gmail.com>
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
index baad5994..9bf5cf7a 100644
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
@@ -3444,20 +3445,52 @@ static int read_options_type(struct tracecmd_input *handle)
 
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
@@ -3525,7 +3558,27 @@ static int init_cpu_data(struct tracecmd_input *handle)
 
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
 
@@ -3993,6 +4046,7 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 
 	handle->fd = fd;
 	handle->ref = 1;
+	handle->latz.fd = -1;
 	/* By default, use usecs, unless told otherwise */
 	handle->flags |= TRACECMD_FL_IN_USECS;
 
@@ -4282,7 +4336,11 @@ void tracecmd_close(struct tracecmd_input *handle)
 	free(handle->trace_clock);
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
2.33.1


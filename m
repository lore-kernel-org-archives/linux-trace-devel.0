Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D47D9C4321E
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:22:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEB9C61073
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:22:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237506AbhJHEYa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237272AbhJHEY2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:24:28 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D53C1C061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:22:33 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id p13so31789602edw.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P996cjf3GrFUMmj4HFkJqxrKoqFh12ht3l56R5JeA1E=;
        b=DiNoyKODDyTL5Od3cK8qmnIFzo8sx2ABujbpKTWOhywX7v8qAnW+qoupJDV+nXqCAs
         2oIouXl8ULE61d9jslL5pOc7ofCkhT11yl9hV/6QWR12CgU4v7f/u0JawCawQ7Agn0bZ
         BE4Q1QKuBt4siriNjjTqji8BJwWoVJZQGK+jmWZOelYNoy0tMads0Etc8IvNAmK1FpcC
         gmKgreFCsfoR90/Zo9PVYwSqSmPcoraxH3MgnsF9fbQUWu3YBuXcdYnXTWqsHOGGHaQ3
         4nhAByROb2Q9oexzNwbIPDUR6PP4M8e8/5E70iNlLqSpUBTpvhjn4pp0Y+/bl5V/xYul
         ZaUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P996cjf3GrFUMmj4HFkJqxrKoqFh12ht3l56R5JeA1E=;
        b=pV5Rhjhj1PHelilxvynjLbxP8j45FbGd7thlqDewDUF64gwpiK9Vh6lC6yLAcwA4fb
         i/x0q6AEqYu3yMTh9XEAB4ggMX8Q+qYo/kR284tpSquvGeYS1+2o8ehFw0Kx7COxB0im
         7Qic2r/NsVBBFbTmheurerZOmuBUD+98f3E7vB8+Ri2lHRZG2puDA2K3I2hXJ7ARkfGZ
         sHHoQDoTynjJ2AkD1xRxB7wJS/VXCjU9MNa2DWy+Wx0epZXsgmEpylPhYYfP6jyWxlmN
         xDzVpvsAlEbOpog/N4Oz1OJkJtCfAdfPY/JeGCNU17MZdehEKFaJHjMFaUO4hhM5s1Xx
         P5Mg==
X-Gm-Message-State: AOAM530Io2hnUe7rn1u8LNkES/fu6MBlE5GczkpbdhqnirLXX1edWDVi
        BYuGQxsCzj/UnwfqI1E/zFifU6Fi9aIgrQ==
X-Google-Smtp-Source: ABdhPJyco6qq+CmuBnE6mBLG5YNF/VD/1lQrtpiYTDlmDKxqtaH7RbJEjS1MAj3aOeziynPSgHueqA==
X-Received: by 2002:a17:906:5ac8:: with SMTP id x8mr1339240ejs.132.1633666952385;
        Thu, 07 Oct 2021 21:22:32 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g23sm517429edt.1.2021.10.07.21.22.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:22:31 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 15/20] trace-cmd library: Read compressed latency data
Date:   Fri,  8 Oct 2021 07:22:09 +0300
Message-Id: <20211008042214.977193-16-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008042214.977193-1-tz.stoyanov@gmail.com>
References: <20211008042214.977193-1-tz.stoyanov@gmail.com>
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
index 5b9ff041..fac19bc3 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -176,6 +176,7 @@ struct tracecmd_input {
 	bool			cpu_compressed;
 	int			file_version;
 	unsigned int		cpustats_size;
+	struct cpu_zdata	latz;
 	struct cpu_data 	*cpu_data;
 	long long		ts_offset;
 	struct tsc2nsec		tsc_calc;
@@ -3445,20 +3446,52 @@ static int read_options_type(struct tracecmd_input *handle)
 
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
@@ -3526,7 +3559,27 @@ static int init_cpu_data(struct tracecmd_input *handle)
 
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
 
@@ -3994,6 +4047,7 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 
 	handle->fd = fd;
 	handle->ref = 1;
+	handle->latz.fd = -1;
 	/* By default, use usecs, unless told otherwise */
 	handle->flags |= TRACECMD_FL_IN_USECS;
 
@@ -4283,7 +4337,11 @@ void tracecmd_close(struct tracecmd_input *handle)
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
2.31.1


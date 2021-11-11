Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE0E7C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:12:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D769603E9
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:12:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234005AbhKKPPD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:15:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233991AbhKKPPC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:15:02 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5D5C061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:12:13 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id f4so25349385edx.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:12:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WPuH75SD2kG5GcNF4ZEfZX2r12d6dnM33DDW8nEDB2E=;
        b=WW5q3jBaY8iz+pnMN4KI/xW1ieMBKKjKnVswajRr5fT02Dfi73nytdc4H0QnvyYmFw
         PEQG6Dj+2uHelhgTNIEQEkLNO/8+2WaDsmunE/HAhLF1U326PN3VxdrfKsPh30f0AkAb
         e0nd9xD6Muu9TqOv1j/xfMrCNLU3W97oCzDFWBbH+R/JIFzFc9vfRcmjKgUje52Sluom
         mFi9vBlL4+JD8FvPgYdnSr1jf6u9rNZJCXCQnvCkVV+qTOk1hUmdpKgBDYbRo4cYCX5A
         uF2su23eCxuH2kc+zXphYmkAdGxWxYJTzIP8il21coSB4OalIsU1b/Y4WeijKJcf5/bf
         cifA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WPuH75SD2kG5GcNF4ZEfZX2r12d6dnM33DDW8nEDB2E=;
        b=62L2JaWxTpA60CCJHcIWYiRCzvMaQx8o4tk+HcGRF1+XPWmVBWlgiEEdWyd/IiY2R5
         80QlWQiHVGK7hA6UUoI16RkiTKv695HRutV8Q42b8FZigeSdRnr6uIirkTt3LrTL+mQZ
         RBHA20a58pnOHDFimPNopktikyIsgxLxtcxLs70v8L4oiFRh/x3AZnI7EqMwws+dDsQj
         Bibzzm15pjls9FcCpPcYWUbN1RjUpYZ9CKezkwTiROgUQiW/5pCGZ4iko7PGxq1NoKFN
         scjiSaapnXZiUxKTlXiomA/VJnOvgyRCZnsf/WPZxsJwVRBW/MkgeKAVRiq+ikYbjRhy
         BhxQ==
X-Gm-Message-State: AOAM532u4DdBTRbABClWVMVqvT1Owntl9ZOuWslKjMv3VgA/L/YEzba1
        IPT330QwGnsN0E40t6ts34DROBf3Fznp/A==
X-Google-Smtp-Source: ABdhPJwLotPr1NotaTPUC/i3fz4jJllxb8ww6Diy5DThlTkW0GLAXqvKXA6qkFu65V30gyYQ1+X9JA==
X-Received: by 2002:a17:907:d22:: with SMTP id gn34mr10045539ejc.195.1636643531881;
        Thu, 11 Nov 2021 07:12:11 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id qf9sm1479509ejc.18.2021.11.11.07.12.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:12:11 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 15/20] trace-cmd library: Read compressed latency data
Date:   Thu, 11 Nov 2021 17:11:48 +0200
Message-Id: <20211111151153.86855-16-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111151153.86855-1-tz.stoyanov@gmail.com>
References: <20211111151153.86855-1-tz.stoyanov@gmail.com>
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
index 9e27337c..43094b11 100644
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


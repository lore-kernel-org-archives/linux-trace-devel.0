Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25DA8C4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 10:59:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240119AbhLJLD3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 06:03:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237285AbhLJLD3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 06:03:29 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E68C061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:59:54 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id l25so28880361eda.11
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:59:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yArGJOm0EyvU1cDsxj2ccxRvQwNkhsYWa8UP6TkXvps=;
        b=oErn7xqgKz4ZDiINC/qqNh4F2ajlWwOV3oBxUrn7UwZR+WnikKUWIJFALrlNp9JYPd
         CZNWY1NLwS2JCPiGvkb2lWOpyuPyp/yRgrYNiPbFD/Rro33+ODY0vqZ/DPfArGWK+zLh
         GCvi2wbqeTnufCTIgNiuaxxLtdgDaNAoLdjPTUOV1WzikpGDraPFJyqYzA/of2rlhhY+
         lOKC6yh4+RSU75RaJ+SxPd6YQMyQ8BnlyZF0mLR8blS1uBymSCMWn2c4Np3pyUa8yhmO
         1ws70pTB+UR7y/PNMLycw0KPqaFGkRYcePNRng23r0oUXtYCxonEyyerkNnqvhQQI1D3
         uwfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yArGJOm0EyvU1cDsxj2ccxRvQwNkhsYWa8UP6TkXvps=;
        b=FB0wUiA+H/60TQr2iLpHim715s6bDnLfz1U87RPkWFEzzGBFlzFmMC1sKvdWgBDL02
         wqHlwzLEaF+wYN4ReQCOiG+Z7QOnmMduPdawD4tm8gtCCn/ziUX+s9eUI/nsY3ku1WDi
         Db+qJdmJSPY8MTV1HQ/xlnIPHU200koRCzUlvzCwE2jkOs6DBvMtc8y6ZEEjoq0Q2ck5
         s43BJBGtDEEegPuBvevy+ZrRR89tCNDUa5TT+FRxiKlhIHhnUQipBkjodsASY5EDPbgR
         Q3I9KGY5LGRpHhjjcCm5VeIanU22QXnc3ULLWEILKwV8R2/8AydmaqYUramqqAMq+fYD
         Vkcw==
X-Gm-Message-State: AOAM530Q3agRWfNuLiiYfgBlnDsveZv2x4Luly9tvBAc1kQvcOSGbQtR
        XoLG3jPOrSsynv9A5vP/FPhvEweblNA=
X-Google-Smtp-Source: ABdhPJx2puOw0eomGIiSh+nvpG+fYd+ueQLpDePoQDzBWoPS0F64/tG4+fojU6eyZ3UAML7FBbrb2Q==
X-Received: by 2002:a17:907:7ba8:: with SMTP id ne40mr23087838ejc.391.1639133992742;
        Fri, 10 Dec 2021 02:59:52 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j17sm1320379edj.0.2021.12.10.02.59.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 02:59:52 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 15/20] trace-cmd library: Read compressed latency data
Date:   Fri, 10 Dec 2021 12:59:33 +0200
Message-Id: <20211210105938.98250-16-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210105938.98250-1-tz.stoyanov@gmail.com>
References: <20211210105938.98250-1-tz.stoyanov@gmail.com>
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
index f151954a..a631692a 100644
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
@@ -3454,20 +3455,52 @@ static int read_options_type(struct tracecmd_input *handle)
 
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
@@ -3535,7 +3568,27 @@ static int init_cpu_data(struct tracecmd_input *handle)
 
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
 
@@ -4047,6 +4100,7 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 
 	handle->fd = fd;
 	handle->ref = 1;
+	handle->latz.fd = -1;
 	/* By default, use usecs, unless told otherwise */
 	handle->flags |= TRACECMD_FL_IN_USECS;
 
@@ -4338,7 +4392,11 @@ void tracecmd_close(struct tracecmd_input *handle)
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
2.33.1


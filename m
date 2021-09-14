Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C357EC433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:17:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1C1F610D1
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:17:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbhINNSW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbhINNSV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:18:21 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D79C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:17:04 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id v20-20020a1cf714000000b002e71f4d2026so1948792wmh.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dzEv3aV9AetR6VmyaD18uFySaeAq9X3N7n9UMXGUAdA=;
        b=WiIjpF91SAshBBAkL8W1qweuW9hGs3AOpl2wblR87spEknRHjMymeg9LafyFfKx/il
         mtjSVr64YmjcsCy446cUx7u1a+BFblBKdloU8GPh3oTTTNzzJgoEWA9m+zbry4JIfdm0
         h+Hl1kVEO7ZpZ+NPo8xqoM+XsDkYlAKUJlpBkb2rfBX9it7AGstdD0HF3GMDp2oWamdt
         k2XdxEEwKJdpmXuoYq7QXck+4okKKpl25Jqs/dcCFf9/I+TVuAnfxyNbpI/XoTyvLWMs
         1gP5sSjeFKkoPRe0KJVMvXoC1IcbwidervfN2Nt1eckw18tR0uvcMbeBEX1BrTFEy+Mw
         8MiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dzEv3aV9AetR6VmyaD18uFySaeAq9X3N7n9UMXGUAdA=;
        b=nt+pNUh6ezNJj+jlOtqp1Tgi0m4AaejJ9QixVcW3YrLGVWYGthjxrd+2KNHyLgjlaS
         M+GYivCdXWiVlCWJ7//FhcyFTXO0a5M7JX+xRXiADXIzAvj3AmQ7dqkFMcc8YYY6FXZv
         VQsYeUYEDPLas3KM64iocxQlSpILFBPrsgeWCI/PPfH+jnp/18X9hvw/+u+gYBFKZLMX
         TNY/I0Xiljvk/0RijmhYfWkPyfzNmZOa8yKogEJltIPI6KI7GPyXGZxtWe9tOoi3yY+O
         6UJaWnPw0jT7QJWvTdOVMSz238HDlC514kB/zIqL296ijoACkZ5ezhllGGaBwsk4CjLV
         Hz/Q==
X-Gm-Message-State: AOAM531qfV3FxWe8zcaFrzNiIGdwzAl1FNXOjkaxIaywvogKK9Q49nBr
        iG6e9nKBDVZNVjQ0e+HAuMFUfBhP9H8=
X-Google-Smtp-Source: ABdhPJyHoYgiGFfmFp/U9y/fW7sWaNfwerflx8ITb1J4OevD/Pm+VPH2l0e8pMg46Kx6HgdhW8ir6Q==
X-Received: by 2002:a1c:2b04:: with SMTP id r4mr2151070wmr.168.1631625422715;
        Tue, 14 Sep 2021 06:17:02 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q10sm1119624wmq.12.2021.09.14.06.17.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:17:02 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 15/20] trace-cmd library: Read compressed latency data
Date:   Tue, 14 Sep 2021 16:16:40 +0300
Message-Id: <20210914131645.3966308-16-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131645.3966308-1-tz.stoyanov@gmail.com>
References: <20210914131645.3966308-1-tz.stoyanov@gmail.com>
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
index 040fb391..80230ba5 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -175,6 +175,7 @@ struct tracecmd_input {
 	bool			read_zpage; /* uncompress pages in memory, do not use tmp files */
 	bool			cpu_compressed;
 	int			file_version;
+	struct cpu_zdata	latz;
 	struct cpu_data 	*cpu_data;
 	long long		ts_offset;
 	struct tsc2nsec		tsc_calc;
@@ -3452,20 +3453,52 @@ static int read_options_type(struct tracecmd_input *handle)
 
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
@@ -3533,7 +3566,27 @@ static int init_cpu_data(struct tracecmd_input *handle)
 
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
 
@@ -4006,6 +4059,7 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 
 	handle->fd = fd;
 	handle->ref = 1;
+	handle->latz.fd = -1;
 	/* By default, use usecs, unless told otherwise */
 	handle->flags |= TRACECMD_FL_IN_USECS;
 
@@ -4295,7 +4349,11 @@ void tracecmd_close(struct tracecmd_input *handle)
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


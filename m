Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 777EFC2BA4C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 09:49:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239400AbiAZJtb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 04:49:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239395AbiAZJtb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 04:49:31 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD702C06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:49:30 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id c24so66000985edy.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:49:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aBdfDKckF1ik6ffDV9Hcyh4jYXX5At3TamRLhiZryL8=;
        b=d+joSndw8A1S0J72WiTWdMcXlsdcGNmo/lh54VGPi2k1AOuiWk0NPSGDpBt6yBIAkb
         7pbGY8PLTXoxTNLFbnsWw69PEf0HeHx7ga7a87fQOGWOeYWL6gRr9MfHcUIjHYjbNwfk
         UztQqqG58YC/5HeC1nza8DrIM1vu5QB9+G1racUbaLgDnx/1CwIoGwXWeMKKnhHDIrin
         neRTXYxnjaU9Kz3zpEv971iIPc4Q9kb6naPyMmh74HHxBgnchjyKx8dTSLt7S5znrCaV
         8pY/Fx1zz/XrfIjBaHsiK8llCmaVR81/kUzD2Az0AbbObk3pzYkmwocvzlBay+X4vZCD
         imyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aBdfDKckF1ik6ffDV9Hcyh4jYXX5At3TamRLhiZryL8=;
        b=OhD8hQs9yxS9NfR1dtZgGVsX1rcK5+SslSdzkIs40lxAxmnMQu/7K4DeDfsoaOFlmd
         jWavlx2sXL5PxhwKkhbM2iTlMznRi4hGUnXT+LUXGAIdosY5F/+ZpDgGfyGRrJY5dkM5
         JbEaKDXEdL4IStxJSZvBmO95F5tDd1mseoWysoOXtLr/t1hyD9aWmX6izFcMHD5mC8Eg
         xWo49tTNNNJp7o0RbVDZpYMr8RP9+l0ShkZCiGisXkVhuWBjWMrtgDOZxqLjBcKHMSVm
         R1KunR416x+MBIrU2/e4mEQbzrrHoavzEmbJ491bXaM3UdVQhZpw+spQAZMeE6me3ABl
         Mh2A==
X-Gm-Message-State: AOAM531WVv/eMR2ItvLOT+zTvEY3b4UuJ84sOGB24e408DbVBxsDFq29
        CRwxv8EVhSNk1J2rIzox6OS6ebkgdno=
X-Google-Smtp-Source: ABdhPJzbYWJFbBMUXYdjN5XKIceVeTu25NOflipc97PIP1PLt6gnBFdahYq+ehhMik4laptydAYjDQ==
X-Received: by 2002:a05:6402:175b:: with SMTP id v27mr3921187edx.413.1643190569270;
        Wed, 26 Jan 2022 01:49:29 -0800 (PST)
Received: from oberon.zico.biz ([151.251.254.11])
        by smtp.gmail.com with ESMTPSA id e17sm7119155eje.218.2022.01.26.01.49.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 01:49:28 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 15/20] trace-cmd library: Read compressed latency data
Date:   Wed, 26 Jan 2022 11:49:01 +0200
Message-Id: <20220126094906.570451-16-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126094906.570451-1-tz.stoyanov@gmail.com>
References: <20220126094906.570451-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-input.c | 77 +++++++++++++++++++++++++++++++++----
 1 file changed, 70 insertions(+), 7 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index c52aa951..7d8f0fe4 100644
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
@@ -3485,20 +3486,55 @@ static int read_options_type(struct tracecmd_input *handle)
 
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
 
+	if (!handle->cpu_compressed) {
+		fd = handle->fd;
+	} else if (!handle->read_zpage) {
+		if (zdata->fd < 0)
+			return -1;
+		fd = zdata->fd;
+	}
+
 	/* Read data from a file */
-	if (!(*buf)) {
-		*size = BUFSIZ;
-		*buf = malloc(*size);
-		if (!(*buf))
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
+
+	id = zdata->last_chunk;
+	if (!*buf || *size < zdata->chunks[id].size) {
+		data = realloc(*buf, zdata->chunks[id].size);
+		if (!data)
 			return -1;
+		*buf = data;
+		*size = zdata->chunks[id].size;
 	}
 
-	return do_read(handle, *buf, *size);
+	if (tracecmd_uncompress_chunk(handle->compress, &zdata->chunks[id], *buf))
+		return -1;
+
+	rsize = zdata->chunks[id].size;
+	zdata->last_chunk++;
+	return rsize;
 }
 
 static int init_cpu_data(struct tracecmd_input *handle)
@@ -3566,7 +3602,29 @@ static int init_cpu_data(struct tracecmd_input *handle)
 
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
+
+		ret = tracecmd_uncompress_copy_to(handle->compress, handle->latz.fd, NULL, &wsize);
+		if (ret)
+			return -1;
+
+		lseek64(handle->latz.fd, 0, SEEK_SET);
+	}
+
 	return 0;
 }
 
@@ -4078,6 +4136,7 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 
 	handle->fd = fd;
 	handle->ref = 1;
+	handle->latz.fd = -1;
 	/* By default, use usecs, unless told otherwise */
 	handle->flags |= TRACECMD_FL_IN_USECS;
 
@@ -4372,7 +4431,11 @@ void tracecmd_close(struct tracecmd_input *handle)
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


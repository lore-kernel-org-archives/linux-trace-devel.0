Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07C6FC43214
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E959060FED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236658AbhG1NdU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236659AbhG1NdT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:19 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F30C0613D3
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:17 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id r16so3228549edt.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mVibTEHuc9wg17LOOiVA/WqDK1Gg1R5MO2wxmhlHoJQ=;
        b=tV6DnsNm2HX/2iUhhb7+h8I6GYeQTNF1dxtaG57uKNuH+j6szB9DaDUdF7kMr7bDIG
         PS9CGSzo8vM2GGJ/gNfjn8SHSY9VSuuNWLNnpYvtAv0DGWVX3rN0FX9FD/GLik2RXsFj
         tFZvDq9KUa5GPOu3epBtbN0r9JssVBIGHToMVJPALgcLBJnUpYJytvOEP0z28J6gjLuF
         Em7TBHWwj/pU1pyV7g3tCS5wlf8anpLiGonAv5u6RfdIiCMl2Hnc7pUOkPHFuo4AsY8f
         qhaJa74kwtVtV+HOx85FfFPcnIf+FRSyZ37y6nBJkTlYwINOq51phiFXOXLdi4XDFOQU
         Ib0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mVibTEHuc9wg17LOOiVA/WqDK1Gg1R5MO2wxmhlHoJQ=;
        b=mQLvNYrKI6KwXfbtXBrAuMYRba6U8t+kAdCnIZrWUKYjRUCwkcpUkF9F/XMkJXipHr
         C0KdxGesvxLvmedSotSF6eDAegSGnpcUQkXuVffTsWP3eiGPhVPsFzZbh1f2mCZjY7X9
         /33gSA/wr7Fj/ylbBj+NJxVC6FjyULq6Shp+cf4b6k8MELUSM1lqRNnkkV6NL3V2xMhO
         AttoynqbnJGbN+kScVJGm7LwKOZ5ynjjyj90mr4MXpnXX0gu0Xasq++/tITGEEKSd+EY
         Bj5ffeEEpoI8Lrd7p2GPP+pu+U5Td5EZW1mbSeCVGbffndg4lRWx75d63pPzmbVk3aW1
         EzyA==
X-Gm-Message-State: AOAM5302WPJ45opqgWZP2arV3Za/ptS3BWhsPZT7v+XwsteTW1Vlpc3s
        4CPqO6R5L7HgsicN809+Etl1iRUilqbaAA==
X-Google-Smtp-Source: ABdhPJwnaqB6F/Kn0C5LpUm1fPilOXBH8CHW/3z7+DZgKUswd4ZP9gaZhE8eT275HMn5w2tGe2smAA==
X-Received: by 2002:a50:ff03:: with SMTP id a3mr29518288edu.0.1627479196140;
        Wed, 28 Jul 2021 06:33:16 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.33.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:33:15 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 24/87] trace-cmd library: Add local helper function for data compression
Date:   Wed, 28 Jul 2021 16:31:47 +0300
Message-Id: <20210728133250.234140-25-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The newly added helper functions read data from a file and compress it,
before writing into the trace file. The trace data is comressed in
chunks, which are page aligned. A new local define is introduced:
  PAGES_IN_CHUNK
which can be used to tune how big a compression chunk is.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 70 ++++++++++++++++++++++++++++++++----
 1 file changed, 64 insertions(+), 6 deletions(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index d0090790..ad0fcaff 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -285,18 +285,26 @@ static unsigned long get_size(const char *file)
 	return size;
 }
 
-static tsize_t copy_file_fd(struct tracecmd_output *handle, int fd)
+static tsize_t copy_file_fd(struct tracecmd_output *handle, int fd, unsigned long long max)
 {
+	tsize_t rsize = 0;
 	tsize_t size = 0;
 	char buf[BUFSIZ];
 	stsize_t r;
 
 	do {
-		r = read(fd, buf, BUFSIZ);
+		if (max > 0 && (max - size) < BUFSIZ)
+			rsize = (max - size);
+		else
+			rsize = BUFSIZ;
+
+		r = read(fd, buf, rsize);
 		if (r > 0) {
 			size += r;
 			if (do_write_check(handle, buf, r))
 				return 0;
+			if (max > 0 && size >= max)
+				break;
 		}
 	} while (r > 0);
 
@@ -314,12 +322,62 @@ static tsize_t copy_file(struct tracecmd_output *handle,
 		tracecmd_warning("Can't read '%s'", file);
 		return 0;
 	}
-	size = copy_file_fd(handle, fd);
+	size = copy_file_fd(handle, fd, 0);
 	close(fd);
 
 	return size;
 }
 
+#define PAGES_IN_CHUNK 10
+__hidden unsigned long long out_copy_fd_compress(struct tracecmd_output *handle,
+						 int fd, unsigned long long max,
+						 unsigned long long *write_size)
+{
+	unsigned long long rsize = 0;
+	unsigned long long wsize = 0;
+	unsigned long long size;
+	int ret;
+
+	if (handle->compress) {
+		rsize = max;
+		ret = tracecmd_compress_copy_from(handle->compress, fd,
+						  PAGES_IN_CHUNK * handle->page_size,
+						  &rsize, &wsize);
+		if (ret < 0)
+			return 0;
+
+		size = rsize;
+		if (write_size)
+			*write_size = wsize;
+	} else {
+		size = copy_file_fd(handle, fd, max);
+		if (write_size)
+			*write_size = size;
+	}
+
+	return size;
+}
+
+static tsize_t copy_file_compress(struct tracecmd_output *handle,
+				  const char *file, unsigned long long *write_size)
+{
+	int ret;
+	int fd;
+
+	fd = open(file, O_RDONLY);
+	if (fd < 0) {
+		tracecmd_warning("Can't read '%s'", file);
+		return 0;
+	}
+
+	ret = out_copy_fd_compress(handle, fd, 0, write_size);
+	if (!ret)
+		tracecmd_warning("Can't compress '%s'", file);
+
+	close(fd);
+	return ret;
+}
+
 /*
  * Finds the path to the debugfs/tracing
  * Allocates the string and stores it.
@@ -516,7 +574,7 @@ static int read_header_files(struct tracecmd_output *handle, bool compress)
 	endian8 = convert_endian_8(handle, size);
 	if (do_write_check(handle, &endian8, 8))
 		goto out_close;
-	check_size = copy_file_fd(handle, fd);
+	check_size = copy_file_fd(handle, fd, 0);
 	close(fd);
 	if (size != check_size) {
 		tracecmd_warning("wrong size for '%s' size=%lld read=%lld", path, size, check_size);
@@ -542,7 +600,7 @@ static int read_header_files(struct tracecmd_output *handle, bool compress)
 	endian8 = convert_endian_8(handle, size);
 	if (do_write_check(handle, &endian8, 8))
 		goto out_close;
-	check_size = copy_file_fd(handle, fd);
+	check_size = copy_file_fd(handle, fd, 0);
 	close(fd);
 	if (size != check_size) {
 		tracecmd_warning("wrong size for '%s'", path);
@@ -1980,7 +2038,7 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 		if (lseek64(data[i].fd, data[i].offset, SEEK_SET) == (off64_t)-1)
 			goto out_free;
 		if (data[i].size) {
-			read_size = copy_file_fd(handle, data[i].fd);
+			read_size = copy_file_fd(handle, data[i].fd, data[i].size);
 			if (read_size != data_files[i].file_size) {
 				errno = EINVAL;
 				tracecmd_warning("did not match size of %lld to %lld",
-- 
2.31.1


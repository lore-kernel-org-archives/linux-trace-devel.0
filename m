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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30954C432BE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12E2061052
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233941AbhG2FKb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233938AbhG2FKa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:30 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75461C061765
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:26 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id da26so6430009edb.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Lm1bsc5GF6Gt49CSDosY+JTZ/5fZAVJTfd9TKbeSrcw=;
        b=kImVaGTZe0PYd3Mu/iLd5hIBhefErK4hu/2L1XBFQegNR67xmpKNGS2qGinMxARaVr
         uWNQoUcHQfZXJMDAaJU2+LCliK+kNylnrUJIcs4Djmcn5t/A2KF0wOVwXdcC0FoSzcna
         ORuV4MjJjnOw/SqSfvq04/YjArQG1pD2gjx9P/dQx4fs6jmL3zOb8wnJ8kKHF4XbdK+t
         cR4egWxbq02FCQaHAnxwwv44BfwP7eB5NX08fLTgEThnN4su6l0BhbUDpU1sDRwXeY/S
         shQoQpWttHplacIEcCFt9aaD6HWrhA0llMPU9tSQ+QV04aNWXEUxRPn5pZaS/BKS5/2d
         RxkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Lm1bsc5GF6Gt49CSDosY+JTZ/5fZAVJTfd9TKbeSrcw=;
        b=kl29eVwNjYzK2Gp84AKaUO6o8hBMAZiSBdrc9UTxqx8/d2TRN9qurkMX0VUjlcuIMy
         LEFk/WA+bQBCIn41Zp3s0WAiyX0C8mc/ZzpdDYEI2EYGUCDQCIao+6Q9P+N7Mp5RDyql
         LNox9KYhTa2vFN0RzX+rLeg21z6Gs64pfXXK4hMpbSbvvPpG1Yjs2xTqzhhz3sJ2aTtL
         +Kxd8NVTHIkm6FHOO4qFGjzURVdlHoEjBmwAzfnsOhsqxMhDm5PwI7+Ggy61XaL3AQ48
         ivzfyRaXfBNlnO9gvY+MGNBCFnB7JCNzZ2ntW/q6wRTvW+spyJFoKTRZaLf+bWroeL9z
         pcIA==
X-Gm-Message-State: AOAM5316g+JaCi5WubiCazgYfJA2aOkfS8QLPG+hFSAg+//aPaRr70Uj
        ocqdTkFZcNi9++CqAZU9/XUgzYLxl9HTFg==
X-Google-Smtp-Source: ABdhPJzQuYohn8+xcW+zid4T/RLZ9sIpjhYrmipIHoeq2klY8HO2KcGEpkSef5rkbJXXBqmGGrpT+A==
X-Received: by 2002:a50:d651:: with SMTP id c17mr2252345edj.69.1627535425136;
        Wed, 28 Jul 2021 22:10:25 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:24 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 24/87] trace-cmd library: Add local helper function for data compression
Date:   Thu, 29 Jul 2021 08:08:56 +0300
Message-Id: <20210729050959.12263-25-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
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
index 6a44a99b..90625c4e 100644
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
@@ -1984,7 +2042,7 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
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


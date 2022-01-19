Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39A2CC433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:27:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352449AbiASI12 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:27:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352446AbiASI11 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:27:27 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD092C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:27:26 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id 30so7635315edv.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:27:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=413OjZJM1Z7F2rj3MwiyKK8vli4GllgDEOol2+g1xto=;
        b=OUrjBRmOWgNPhGGcqGF62IeKv9dLSH3b4A3RAXGADce3yLrhG1ii8rlJYSeEXuNaAH
         GH7PmzfPjBxwMvkN+JDrX1EbNjOVwDO+0jQnmXugFKQRimZ8uAOlE6DnIl89oIIA8qyV
         5ZWmJkRjX+idvbleHH+sGnczQuNOFljZOFmCdT4wNdMBBa4HXOqjTiL4ABO1Wz1R+b3v
         TLxsZMTZ+KEy1bhRfqZkd9RDjATvoBOKnDOZte+mEgH+6vau7FZe5BZ7NhLsnnGXQx3K
         sM8Wy6O8VH2AOi8js+RTpEHTSMJAmNb87mQU8PziYHZ/Wefg1+2sz48twYOi522YuDyC
         vRpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=413OjZJM1Z7F2rj3MwiyKK8vli4GllgDEOol2+g1xto=;
        b=QNAn/vL31byYyyvyWMGxlEVLdYpQi73FrtYyKJpQhkcKA2bu+43OeTAuaZrRik0eus
         Bb7nStS4VhqXvTwJyL+W+3AFl+U1i2SyTSIZlky25UiQmNCoCU+pAqqEgfeJ1FmMp82u
         tWh/2LHqICCCuHmmYEhfX22PvlNH9S++ny3fBQBup95J1GZwX0aXAVH8balGYOQ7WImb
         tpq5m9ZR0bd77fAelGj9Q4tgYSxGvQZXLClZ/FJeL/S9yR5x1L44O6OW6yquayw6ivrN
         byOH7XTARl+faTbhCklcJQtegQP8i2ecDFkMJffcxFMJkrRHYpPMIlHQf1Ne4UXRHTQr
         LREQ==
X-Gm-Message-State: AOAM530yc06ngzcTXoO6rovTjK7qtwNJtJc0nNM0aTEYsL4/rsqO4qh4
        XpeFqq1H4KBZ2FipVwZ+Wxsq6fApojI=
X-Google-Smtp-Source: ABdhPJzTengmD/Awr9du8LOQzrBoTiFCXF4UX36x5o8dRyWsknRUKcJEIHVVw+SwBzxjGorIveOjiw==
X-Received: by 2002:a17:907:7b99:: with SMTP id ne25mr19919555ejc.769.1642580845211;
        Wed, 19 Jan 2022 00:27:25 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d14sm848703edu.57.2022.01.19.00.27.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:27:24 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 08/20] trace-cmd library: Add local helper function for data compression
Date:   Wed, 19 Jan 2022 10:27:03 +0200
Message-Id: <20220119082715.245846-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119082715.245846-1-tz.stoyanov@gmail.com>
References: <20220119082715.245846-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The newly added helper functions read data from a file and compress it,
before writing into the trace file. The trace data is compressed in
chunks, which are page aligned. A new local define is introduced:
  PAGES_IN_CHUNK
which can be used to tune how big a compression chunk is.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 71 +++++++++++++++++++++++++++++++++---
 1 file changed, 65 insertions(+), 6 deletions(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index df65d02c..e2e03cf9 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -320,18 +320,27 @@ static unsigned long get_size(const char *file)
 	return size;
 }
 
-static tsize_t copy_file_fd(struct tracecmd_output *handle, int fd)
+static tsize_t copy_file_fd(struct tracecmd_output *handle, int fd, unsigned long long max)
 {
+	tsize_t rsize = BUFSIZ;
 	tsize_t size = 0;
 	char buf[BUFSIZ];
 	stsize_t r;
 
 	do {
-		r = read(fd, buf, BUFSIZ);
+		if (max && rsize > max)
+			rsize = max;
+
+		r = read(fd, buf, rsize);
 		if (r > 0) {
 			size += r;
 			if (do_write_check(handle, buf, r))
 				return 0;
+			if (max) {
+				max -= r;
+				if (!max)
+					break;
+			}
 		}
 	} while (r > 0);
 
@@ -349,12 +358,62 @@ static tsize_t copy_file(struct tracecmd_output *handle,
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
@@ -601,7 +660,7 @@ static int read_header_files(struct tracecmd_output *handle, bool compress)
 	endian8 = convert_endian_8(handle, size);
 	if (do_write_check(handle, &endian8, 8))
 		goto out_close;
-	check_size = copy_file_fd(handle, fd);
+	check_size = copy_file_fd(handle, fd, 0);
 	close(fd);
 	if (size != check_size) {
 		tracecmd_warning("wrong size for '%s' size=%lld read=%lld", path, size, check_size);
@@ -627,7 +686,7 @@ static int read_header_files(struct tracecmd_output *handle, bool compress)
 	endian8 = convert_endian_8(handle, size);
 	if (do_write_check(handle, &endian8, 8))
 		goto out_close;
-	check_size = copy_file_fd(handle, fd);
+	check_size = copy_file_fd(handle, fd, 0);
 	close(fd);
 	if (size != check_size) {
 		tracecmd_warning("wrong size for '%s'", path);
@@ -2292,7 +2351,7 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 		if (data[i].size) {
 			if (lseek64(data[i].fd, data[i].offset, SEEK_SET) == (off64_t)-1)
 				goto out_free;
-			read_size = copy_file_fd(handle, data[i].fd);
+			read_size = copy_file_fd(handle, data[i].fd, data[i].size);
 			if (read_size != data_files[i].file_size) {
 				errno = EINVAL;
 				tracecmd_warning("did not match size of %lld to %lld",
-- 
2.34.1


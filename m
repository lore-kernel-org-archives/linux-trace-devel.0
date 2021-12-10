Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D5F5C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 10:59:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240105AbhLJLDX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 06:03:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237285AbhLJLDX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 06:03:23 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 145E2C061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:59:48 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id t5so28322011edd.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:59:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J0pHtu//6As10l0ieQVxU0zhtHdqLlD61BrnvWG8TG8=;
        b=IKBBW1LLerE84F9AbGJmvjDcupU9JzYNf6RodzuC/roqgq5c1CeTCUZ2rp2QMRwblj
         3RCxoN9ZD2Lgxwco+1T8ARTkCleYZPVPR0stp5Qco13RQlB5/A/5Vp6T8I5WvWIbe7xE
         efzo8RiVqBOrgzQi5aon+zKhomPEnJYg2CKBTyif+Txw9wAE54dJVMjTlqPIgyWSsDQd
         uCWp4NaIS3K4UtWwoWqGFgWol6Aqu3M47nOSH1m4yjfDNC23yC68/7Ua6+ylHrnLVUSl
         9HWc2ainr6VDsqtk2wW9uxE52Vzl9rlBMtwyCnlqCMB+aDNLsFYnDfGqoWWQzOdmnTrz
         P/1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J0pHtu//6As10l0ieQVxU0zhtHdqLlD61BrnvWG8TG8=;
        b=Jk8CgX4m0LKDdLC6vA39yLy/C558ViaeBE52+qhdDf7u9T8pXqtZG4eO1yfRW/IQtk
         xg71TOjpfDzF+jIrzLZ537911cjmsyCK5S4bB5z5y4RnoXPU6y7fupmHyNBp/TRGi0ou
         1KpePlckqhWnWVFtJj1e0d+siQ6+yy3e24RCV/bLILwBjSr9oAIs87Sxkxwnt2BcnpLD
         UbnfFE9JD1AttUNNVcGHvb2k2Fw5VocDjUpwFMJZ6M1t5xAOro/zTnGVW9P4CqV8GdvZ
         QuqYL3otRfqK6MvgrJE8D484gMSt8XPrxq6HhBoyN3LDroe5zNxcH8mDOwo7LZy0yJvD
         Xnuw==
X-Gm-Message-State: AOAM530nrx6+JbFIAulSF0EkiLsM4GT9+2JjolIxuBGnJeZ7wByVHnCn
        ovVX9LjWnM1ewjOVxjJmfCt4B+jGohg=
X-Google-Smtp-Source: ABdhPJxLFcNwGu+gcsXdKNWRmrZSSeM0lPcZ67PrtPOxTZHEWpx5TzRVCAgYVYHK8fmFEE30MtmuyQ==
X-Received: by 2002:a17:907:608b:: with SMTP id ht11mr23789434ejc.80.1639133986670;
        Fri, 10 Dec 2021 02:59:46 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j17sm1320379edj.0.2021.12.10.02.59.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 02:59:46 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 08/20] trace-cmd library: Add local helper function for data compression
Date:   Fri, 10 Dec 2021 12:59:26 +0200
Message-Id: <20211210105938.98250-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210105938.98250-1-tz.stoyanov@gmail.com>
References: <20211210105938.98250-1-tz.stoyanov@gmail.com>
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
index a5878636..3bd67312 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -315,18 +315,27 @@ static unsigned long get_size(const char *file)
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
 
@@ -344,12 +353,62 @@ static tsize_t copy_file(struct tracecmd_output *handle,
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
@@ -596,7 +655,7 @@ static int read_header_files(struct tracecmd_output *handle, bool compress)
 	endian8 = convert_endian_8(handle, size);
 	if (do_write_check(handle, &endian8, 8))
 		goto out_close;
-	check_size = copy_file_fd(handle, fd);
+	check_size = copy_file_fd(handle, fd, 0);
 	close(fd);
 	if (size != check_size) {
 		tracecmd_warning("wrong size for '%s' size=%lld read=%lld", path, size, check_size);
@@ -622,7 +681,7 @@ static int read_header_files(struct tracecmd_output *handle, bool compress)
 	endian8 = convert_endian_8(handle, size);
 	if (do_write_check(handle, &endian8, 8))
 		goto out_close;
-	check_size = copy_file_fd(handle, fd);
+	check_size = copy_file_fd(handle, fd, 0);
 	close(fd);
 	if (size != check_size) {
 		tracecmd_warning("wrong size for '%s'", path);
@@ -2276,7 +2335,7 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 		if (data[i].size) {
 			if (lseek64(data[i].fd, data[i].offset, SEEK_SET) == (off64_t)-1)
 				goto out_free;
-			read_size = copy_file_fd(handle, data[i].fd);
+			read_size = copy_file_fd(handle, data[i].fd, data[i].size);
 			if (read_size != data_files[i].file_size) {
 				errno = EINVAL;
 				tracecmd_warning("did not match size of %lld to %lld",
-- 
2.33.1


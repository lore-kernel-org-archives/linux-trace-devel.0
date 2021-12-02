Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 156E6C4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:25:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232969AbhLBM2l (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:28:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231949AbhLBM2k (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:28:40 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B75E8C06175B
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:25:17 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id w1so115507655edc.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:25:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LSgYRmDfZp81HNGOmHabjzlTc32cEBgh9Ei/Ctt8H/Y=;
        b=XAaZUGBpElVdvwpnReqftscY4d/MF94uU31SP2wz5TgQp2mUfLoqXAXYS+SzNwXSCO
         ETUberhWxZeyK2eg0GtXCiqI5/MvIjvoSJo7rHdKVymJQuEI0V0JTj4qvnkOl/ccYtbm
         0Qad94N00iCYtPmMOUV38GPMrma7eJ1rtDMiSTvJfWVCnrp6v5FkL4YggXDDsFxyxi0O
         0Qz3VxIc33fIVYk1gzsgpsnjy8Yrc4AyRLW1RUuXaSQ9FRQ35WLrPfLNuLeU4adU5N8Q
         CzeBoHsnrz59ufj/cP8vsoK/XefQm+/BmWaO1cNT0aYXWVeQS2pI6Fk8Xs+u44fnXW9p
         gs1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LSgYRmDfZp81HNGOmHabjzlTc32cEBgh9Ei/Ctt8H/Y=;
        b=f4U8Spd+c0wyCXXgZk+jP8oc2G383nj5MEFkAimkJ+W6K1d6kJv0rsigqb7q0MFulM
         CwGio/ta65+55ifnD58L/51Mx0a+jC9ewVoSWG47IMU0/EQk5nYGyAvNM3cyX9ijwiS9
         M3DBgASEa18wUe23dEM146IVFuUMOb3pokzDlCVNQ9ymB2iGBrKzsM4POE1wzCtG25Rk
         +t56ijIi/O1fpoY8SaP5FRuhKYqx+jYKIdt9x+NGWopyFZvg7kFwmG/Ogo/b/u3O0SF5
         Y1G41gMWOXBkOaLTKYoPb6OSeQVTXs1/qJPO8ihhXpLAAIbpTmQ4XH0Cid4+0Z4ddyWH
         t8/g==
X-Gm-Message-State: AOAM533ptuI4Ztilw5p6HgtMZEQYtPqLdEJZpzwfLQ0hnxF7PnyBQHPm
        K9Ycy2dK2t2/G6hWVLnZG+yES8em+OeO4g==
X-Google-Smtp-Source: ABdhPJxJvKjQ9xrm5FS/ypr+7HD4QpKSSm72RpeCyr7t/YGYP5b4/kw1RFyEKUQ2wA++K+Hrb64koQ==
X-Received: by 2002:a17:906:1c56:: with SMTP id l22mr14791431ejg.208.1638447916231;
        Thu, 02 Dec 2021 04:25:16 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id eg8sm1998507edb.75.2021.12.02.04.25.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:25:15 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 08/20] trace-cmd library: Add local helper function for data compression
Date:   Thu,  2 Dec 2021 14:24:55 +0200
Message-Id: <20211202122507.43572-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122507.43572-1-tz.stoyanov@gmail.com>
References: <20211202122507.43572-1-tz.stoyanov@gmail.com>
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
index 876be404..bfd99b8a 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -289,18 +289,27 @@ static unsigned long get_size(const char *file)
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
 
@@ -318,12 +327,62 @@ static tsize_t copy_file(struct tracecmd_output *handle,
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
@@ -519,7 +578,7 @@ static int read_header_files(struct tracecmd_output *handle, bool compress)
 	endian8 = convert_endian_8(handle, size);
 	if (do_write_check(handle, &endian8, 8))
 		goto out_close;
-	check_size = copy_file_fd(handle, fd);
+	check_size = copy_file_fd(handle, fd, 0);
 	close(fd);
 	if (size != check_size) {
 		tracecmd_warning("wrong size for '%s' size=%lld read=%lld", path, size, check_size);
@@ -545,7 +604,7 @@ static int read_header_files(struct tracecmd_output *handle, bool compress)
 	endian8 = convert_endian_8(handle, size);
 	if (do_write_check(handle, &endian8, 8))
 		goto out_close;
-	check_size = copy_file_fd(handle, fd);
+	check_size = copy_file_fd(handle, fd, 0);
 	close(fd);
 	if (size != check_size) {
 		tracecmd_warning("wrong size for '%s'", path);
@@ -2192,7 +2251,7 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
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


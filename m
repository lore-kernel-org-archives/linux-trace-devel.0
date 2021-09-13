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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55F09C4332F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:42:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41EDE60FDA
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:42:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239137AbhIMMnb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239946AbhIMMn3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:43:29 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E38A8C061764
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:42:13 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id g128so2115241wma.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:42:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t7LybXcZs8hWo1S+cBmstKmaqsKoBt8ivugmVPGLzTg=;
        b=ZMa4NcSlH07WCAPrBhsIaENzhdLhJikXM/ZdV5+70pLm63JFOzSOkpr2Ig793lixd6
         24zbXko11bPN2KpaCLqr99SHNv1v/wEe7Nx2C1EYzzD27iUer0klKX6JppSuXbUkmib/
         Y3a2htlNsvI2fkSLAjHqgVKG+UnhW0s4ztfCWqSOdxVIcL7W7kVTZBThtA0UsxDVE/n+
         cRcgYnf9FEpFw6J1/cmImWwbMgliSSxHQWTOeV1hgEZ0lwPbOj3XH/ykt1funP2GeuA6
         frOfKi55dE6f73r3PqAoD6fMxCgoDg8F/9pLGfUX7BbVLaY42+Nf++6Qc5fzY1Cc0XMa
         BQJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t7LybXcZs8hWo1S+cBmstKmaqsKoBt8ivugmVPGLzTg=;
        b=2qenT27tw6iJcWxUihnQG5AI8SqvxLauidi6tAbaC9Z5fW9OvPZ//ZL4AIpEDCl5fU
         aW1FMCMIQqE5SwDYC1kzrPoekakSLCE9UIooPJfH1vBB85u1WgRxw+m55suTewvINAF2
         x6hpaSjtEcFYzrzuZjhAUfAoyveyZ/xHwjButlTdjkHreb6p/DvmMl8vW+hhwo5r+mUL
         ApBVn3PC5bel7HVx+AJ5G935xlA6XwvHXgjCOmsFPbGBh0v/0vpNTcC0U1Rdpso5NzMU
         1yWElpt0+ZobADldssX3VPqs6rpo6zgC1TB1lG1WR56dZGcjRn6cVYG2tAX2E5ZBpqdw
         b90g==
X-Gm-Message-State: AOAM5302jHI+4/8rXaSPjRpRRsTLM1upysQliLDo+dB3PQCj7tNPMrjq
        ki/Q+bEI+tcy5ickF5ly9xoTM1GA5xU=
X-Google-Smtp-Source: ABdhPJwfYyommN3Whsu5bYwM4GsvKhjkyYD1ZwabQcJ8FQSUNPowrSgk28niqZAEimN/V889X59kmQ==
X-Received: by 2002:a1c:7e85:: with SMTP id z127mr11050909wmc.141.1631536932059;
        Mon, 13 Sep 2021 05:42:12 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u13sm7244290wrt.41.2021.09.13.05.42.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:42:11 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 08/20] trace-cmd library: Add local helper function for data compression
Date:   Mon, 13 Sep 2021 15:41:51 +0300
Message-Id: <20210913124203.3677760-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913124203.3677760-1-tz.stoyanov@gmail.com>
References: <20210913124203.3677760-1-tz.stoyanov@gmail.com>
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
index 1c6e9728..c69d6d4f 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -283,18 +283,27 @@ static unsigned long get_size(const char *file)
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
 
@@ -312,12 +321,62 @@ static tsize_t copy_file(struct tracecmd_output *handle,
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
@@ -513,7 +572,7 @@ static int read_header_files(struct tracecmd_output *handle, bool compress)
 	endian8 = convert_endian_8(handle, size);
 	if (do_write_check(handle, &endian8, 8))
 		goto out_close;
-	check_size = copy_file_fd(handle, fd);
+	check_size = copy_file_fd(handle, fd, 0);
 	close(fd);
 	if (size != check_size) {
 		tracecmd_warning("wrong size for '%s' size=%lld read=%lld", path, size, check_size);
@@ -539,7 +598,7 @@ static int read_header_files(struct tracecmd_output *handle, bool compress)
 	endian8 = convert_endian_8(handle, size);
 	if (do_write_check(handle, &endian8, 8))
 		goto out_close;
-	check_size = copy_file_fd(handle, fd);
+	check_size = copy_file_fd(handle, fd, 0);
 	close(fd);
 	if (size != check_size) {
 		tracecmd_warning("wrong size for '%s'", path);
@@ -2177,7 +2236,7 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
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


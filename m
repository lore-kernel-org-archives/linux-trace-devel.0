Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D9D8C433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:13:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2378161268
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:13:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbhKKPPs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:15:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233909AbhKKPPo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:15:44 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E58C061767
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:12:55 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id w1so25481885edd.10
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:12:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9oXXCwAzmHcpVWjxzfY8kimTg/T2kFD6d0BsjQXDCWI=;
        b=A1y+xJwzI/akXTa1kKJ/drmzIKDzAh0Ujb3Fi7Kh/6OmqWvhg/Dg7b3ppqBl0TmVYW
         R+FT1NpuOeyYmg+YcUAoqjP0khteB9e2YLrw1cFqk2SMeEmD4XRz8jbD4+0BPeK7mcwa
         ng64iikRQfuAffpPb+NAEXroaR169orZ6ZrG8FFuFom7U2REyBQv1uaFF2AXYOSE/D7S
         8I2av4aXg1ktRYMYF+lCurjcnN62ULwBb9SD4tsImZIP9oJHyHS3QtY6n1W6VX9iE7TU
         Q8xqa7nmI6nS8VwXDA5FwVfcABItt6r1aSYXfN3mSgYwBqe8KAyqizpIIoadoQordlSH
         /+DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9oXXCwAzmHcpVWjxzfY8kimTg/T2kFD6d0BsjQXDCWI=;
        b=xBqokkIzyuaaFjB6ZoZn4C+KZPI9Yq59XYF8am5E2vGwhWFaRhk3JJ4WCT9rkoG/M/
         NOtUOOaFP/09rR+16YDb9D0LlHYALXeNvHt/2WSLYrsU2435ZrJtO6XfgAVID0XpYCt5
         DlaB6m4U6T/zWKJsx7WYXo+DO1kSuE7LV0zUcG2o+ShsL5diOIcg7/i+N478qywffiGY
         1Oxa0EZvAXrjBWadHFjl5jHiZRQGjzplRTEJ48UqF/LUv/KT68EPeGIgriPuj6LwW4/s
         llXH8l1Cy0Is6mEuRrZawHKDXiDzuAz+rgJiaFVoMo5NAcndhNd2WXX+KqEcyHdE4Xyu
         2aDg==
X-Gm-Message-State: AOAM532shxNPZ4BaxnOPvwDpPGkOQvPdXwSOv+J+TqVapjJf+CSmvBpx
        LwmBL/e4p+3Z6l51FPtO1AXdxkeA53XBzA==
X-Google-Smtp-Source: ABdhPJw2G6o67mZo2m8QSC2ZzeTYQMDySJDA/gnS9Nsyd884gklh0dHLomQzR7foB6fulkYhfM6O8Q==
X-Received: by 2002:a17:907:1b11:: with SMTP id mp17mr10218581ejc.275.1636643573733;
        Thu, 11 Nov 2021 07:12:53 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q2sm1443375eje.118.2021.11.11.07.12.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:12:53 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 01/10] trace-cmd dump: Add helpers for processing trace file version 7
Date:   Thu, 11 Nov 2021 17:12:41 +0200
Message-Id: <20211111151250.87023-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111151250.87023-1-tz.stoyanov@gmail.com>
References: <20211111151250.87023-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

New global variables are added, that hold trace file context:
 - trace file version
 - compression context
Also a few helper functions for reading compressed data.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-dump.c | 88 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 67 insertions(+), 21 deletions(-)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index b19ce89a..75e40911 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -26,6 +26,9 @@
 static struct tep_handle *tep;
 static unsigned int trace_cpus;
 static int has_clock;
+static unsigned long file_version;
+static bool	read_compress;
+static struct tracecmd_compression *compress;
 
 enum dump_items {
 	SUMMARY		= (1 << 0),
@@ -52,46 +55,69 @@ enum dump_items verbosity;
 			tracecmd_plog(fmt, ##__VA_ARGS__);	\
 	} while (0)
 
-static int read_file_string(int fd, char *dst, int len)
+static int read_fd(int fd, char *dst, int len)
 {
 	size_t size = 0;
 	int r;
 
 	do {
-		r = read(fd, dst+size, 1);
+		r = read(fd, dst+size, len);
 		if (r > 0) {
-			size++;
-			len--;
+			size += r;
+			len -= r;
 		} else
 			break;
-		if (!dst[size - 1])
-			break;
-	} while (r > 0 && len);
+	} while (r > 0);
 
-	if (!size || dst[size - 1])
+	if (len)
 		return -1;
-	return 0;
+	return size;
 }
 
-static int read_file_bytes(int fd, char *dst, int len)
+static int read_compressed(int fd, char *dst, int len)
+{
+
+	if (read_compress)
+		return tracecmd_compress_read(compress, dst, len);
+	return read_fd(fd, dst, len);
+}
+
+static int do_lseek(int fd, int offset, int whence)
+{
+	if (read_compress)
+		return tracecmd_compress_lseek(compress, offset, whence);
+	return lseek64(fd, offset, whence);
+}
+
+static int read_file_string(int fd, char *dst, int len)
 {
 	size_t size = 0;
 	int r;
 
 	do {
-		r = read(fd, dst+size, len);
+		r = read_compressed(fd, dst+size, 1);
 		if (r > 0) {
-			size += r;
-			len -= r;
+			size++;
+			len--;
 		} else
 			break;
-	} while (r > 0);
+		if (!dst[size - 1])
+			break;
+	} while (r > 0 && len);
 
-	if (len)
+	if (!size || dst[size - 1])
 		return -1;
 	return 0;
 }
 
+static int read_file_bytes(int fd, char *dst, int len)
+{
+	int ret;
+
+	ret = read_compressed(fd, dst, len);
+	return ret < 0 ? ret : 0;
+}
+
 static void read_dump_string(int fd, int size, enum dump_items id)
 {
 	char buf[DUMP_SIZE];
@@ -146,7 +172,6 @@ static void dump_initial_format(int fd)
 	char magic[] = TRACECMD_MAGIC;
 	char buf[DUMP_SIZE];
 	int val4;
-	unsigned long ver;
 
 	do_print(SUMMARY, "\t[Initial format]\n");
 
@@ -168,11 +193,11 @@ static void dump_initial_format(int fd)
 		die("no version string");
 
 	do_print(SUMMARY, "\t\t%s\t[Version]\n", buf);
-	ver = strtol(buf, NULL, 10);
-	if (!ver && errno)
+	file_version = strtol(buf, NULL, 10);
+	if (!file_version && errno)
 		die("Invalid file version string %s", buf);
-	if (!tracecmd_is_version_supported(ver))
-		die("Unsupported file version %lu", ver);
+	if (!tracecmd_is_version_supported(file_version))
+		die("Unsupported file version %lu", file_version);
 
 	/* get file endianness*/
 	if (read_file_bytes(fd, buf, 1))
@@ -234,6 +259,27 @@ static void dump_header_event(int fd)
 	read_dump_string(fd, size, HEAD_EVENT);
 }
 
+static void uncompress_reset(void)
+{
+	if (compress && file_version >= FILE_VERSION_COMPRESSION) {
+		read_compress = false;
+		tracecmd_compress_reset(compress);
+	}
+}
+
+static int uncompress_block(void)
+{
+	int ret = 0;
+
+	if (compress && file_version >= FILE_VERSION_COMPRESSION) {
+		ret = tracecmd_uncompress_block(compress);
+		if (!ret)
+			read_compress = true;
+
+	}
+	return ret;
+}
+
 static void dump_ftrace_events_format(int fd)
 {
 	unsigned long long size;
@@ -623,7 +669,7 @@ static void dump_options(int fd)
 		default:
 			do_print(OPTIONS, " %d %d\t[Unknown option, size - skipping]\n",
 				 option, size);
-			lseek64(fd, size, SEEK_CUR);
+			do_lseek(fd, size, SEEK_CUR);
 			break;
 		}
 	}
-- 
2.33.1


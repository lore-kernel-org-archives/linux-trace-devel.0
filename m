Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A22C2C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:30:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351533AbiASIa0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234262AbiASIaX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:30:23 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F230C06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:30:23 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id cx27so7735860edb.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:30:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+q1AC6uEFBIqtXdCRvnGmv8PVSyVX5IUmDh2Uc2MyYE=;
        b=Wul9WUB5bxLWbqfZ7Ae/gxgqtB8zsdw48Lp+phV3X8d0kO9OC//8Ag9U0VyP0aUNa5
         uMQJTxjD6Zv0E7oqgHoI9BDaLHFNIzJ1Gw3bj2D9kKh891756+u3CFhuMy+eVDqch3RF
         323aSkjsyrQsT6n4uRg4CSi49H80aEpPWGnYWed/TzUKzW4BRlLCKVMNzDACJrtlgyXg
         7tzyXF5dNjPdKVDR72PcoX9P8YwGfhlQrMuBRfre1SU/4/T8AFzXqrh0mR2B3r1yr3qf
         suB4a+Fz7ghrkaD8w30f3hasMIgKQwPvZFY2KNn+LHQxpWHh0FjUSpvCE/isZB3wr3gn
         jQFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+q1AC6uEFBIqtXdCRvnGmv8PVSyVX5IUmDh2Uc2MyYE=;
        b=X3H4B2icca1c6gNHsftB7yhDsD3BAyDCqMzTU+2GP+rFxBghuvbelqtboEA3ynD81X
         nHcCsP5uOEXBBPldWbIbNLbYzM07xy+Arqxnh7y3FLmGgVxH5ZizkAC9ly5OF1/WOI5k
         kJK3pQKAPk+9AWLEjrbQod8Z728Fu44RCfkAoWXiaX0TgRocf33OFwhhVULQQNxecdb3
         z3aiWvqB2qJV7zedm9XiMl7ohJ7yFLabEV3eJLUcRuzjZsMUH9TrOoqSfFXgGgd6z0EU
         qhruJOergnlpaNQn0Zb4JXFjUIMadWTdvTVqluPG36U0YLmztPoNSqzJX1n9QOwVPO+D
         X/cQ==
X-Gm-Message-State: AOAM533HHkc85dMw63iLRVqMJHbTQ7mcxRo7tBFmcxgmq62joYYCkWa+
        JM/5Mpp6TAKE3s2tLnuT16tKRaj4Cpc=
X-Google-Smtp-Source: ABdhPJxDs6L4YSrSgncJbasrU21YHSa5Tx4Hw/hVxxtnONROP+i56b1Q/DIcGUeDysld6hcY5mKUeg==
X-Received: by 2002:a17:906:7302:: with SMTP id di2mr8044639ejc.322.1642581022153;
        Wed, 19 Jan 2022 00:30:22 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id la7sm6095530ejc.94.2022.01.19.00.30.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:30:21 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 01/11] trace-cmd dump: Add helpers for processing trace file version 7
Date:   Wed, 19 Jan 2022 10:30:09 +0200
Message-Id: <20220119083019.246153-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119083019.246153-1-tz.stoyanov@gmail.com>
References: <20220119083019.246153-1-tz.stoyanov@gmail.com>
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
index 2408a4ab..23733194 100644
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
2.34.1


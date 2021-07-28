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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2E49C4338F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:34:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C654B60FED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:34:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236712AbhG1NeH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236254AbhG1NeH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:34:07 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08AE0C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:34:02 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id jg2so4736525ejc.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0e3pzSC/jURaDUPtk817CJ7QmZ7kWKFhZA8bjqTmygo=;
        b=aNO11SG2llIOKqNz7CcqhakFUjUeaFLegOBA5DxF7T6DMlH7fTUMCm/cal6vclvRlv
         uYIIYrVz/1Wgr5e9dpTr8GrankrsUnyRx8cB+hO7esrGAvuQ0p3Kgurh865CNROJQTfA
         Sx7PqEs36+Xbg90UZCv+pnrN+J6uYY1izlf1RaNqBBlwiGqoykYRFZcg1pQ5iwbSq6XL
         lAMAGHx3Ad3iT9xkc0MFKEEggOSEHdURH5Nrf8XnTt6K5QYD88IU6cjpiINLsKHJryUF
         CHqVLmkA2NRFai2yKC9OgHc2uGP8W9awQK2XVuRU985rzUl8h8uB6nBUp7QBa6skLvDR
         C3ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0e3pzSC/jURaDUPtk817CJ7QmZ7kWKFhZA8bjqTmygo=;
        b=KLmXhCps4G2AbfAyd23UZQ1rzzJbiUwtNlSPLH8K2dR0iZafxlpVhM4oXgGCpCd5tU
         z7X96zqcKS5uzXiIJvSgJt9gPJi/83wq5KXOiB/CBOHdQonvsIMmtwo8IAdJQucuUT0B
         yATYpkKYnSGuek6vyzGO7FswiNQttLqyNbs5XIxMPCOnAknuj07DPWm1heqwXZHr9HRm
         AL24YPTA7Y/G29oMAuAevO4ttgywffX0saS49O9tmMERm9u2MgVzRZCJ7fSXMOo8h5+c
         XMS9jTqiIQ+YBvcRKsYCMYAkjfHc9SWmjdYhYblJejQZNWrf1Pbu4k1sUkjNhD1mkQVt
         ctlg==
X-Gm-Message-State: AOAM531bOI4kn1zssgBYOdjsH4w4kYks2t/a7MA+Awh8iSiaW9e1ZT4g
        LOWuZLbjNEDvE9UuSqCR/6XBocTsEQ+mkg==
X-Google-Smtp-Source: ABdhPJz+TPAZr4RtywXD3hnSsFOH7pcXcp0+nVHE9bllnypm65J+OGBaHbWim27ZGJ1sf6QzdemwpA==
X-Received: by 2002:a17:906:4310:: with SMTP id j16mr27945345ejm.182.1627479240661;
        Wed, 28 Jul 2021 06:34:00 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.33.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:34:00 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 62/87] trace-cmd dump: Add helpers for processing trace file version 7
Date:   Wed, 28 Jul 2021 16:32:25 +0300
Message-Id: <20210728133250.234140-63-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
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
index 2334b57e..e150a17d 100644
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
+	if (compress && file_version >= 7) {
+		read_compress = false;
+		tracecmd_compress_reset(compress);
+	}
+}
+
+static int uncompress_block(void)
+{
+	int ret = 0;
+
+	if (compress && file_version >= 7) {
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
@@ -578,7 +624,7 @@ static void dump_options(int fd)
 		default:
 			do_print(OPTIONS, " %d %d\t[Unknown option, size - skipping]\n",
 				 option, size);
-			lseek64(fd, size, SEEK_CUR);
+			do_lseek(fd, size, SEEK_CUR);
 			break;
 		}
 	}
-- 
2.31.1


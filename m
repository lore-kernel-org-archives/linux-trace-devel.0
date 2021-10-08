Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95BFCC433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:27:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 689E260F35
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:27:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbhJHE3B (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233346AbhJHE3A (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:29:00 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE00C061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:27:05 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id t16so9484426eds.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KS8r8oY8x2kfdcoMywa4LhAV1/KUW+EnGnL0wzDkhKI=;
        b=cQUjolmZ8chBhvRWR7DxyGaSJrjLriLvt0l48q0oDazp6zN5KkWiZnFHzk8vYVY/de
         AvlTcd8iuttE0A2gCRyNqT9vB/VzS9UiqdD6auZrjc/u5B1dRlczLGydKO4LQi5Qsz+6
         dtkpV2psyGUuYyTLPpkuDIzC0nvbU1j67UW5+fW4fBoLIQi8qfjBqK8qpwMlP+2JcYuk
         N3BrmFpOm+9GN2akrcy4lHlWCa+9XgkR6IKJdN7/c9ehNtsTnLObY+trEd4FG+j69BJN
         q3uPe1TBsGe1wsMDo2i+QyGV1oqUeeH9V9Q4cyn3fOGMfvx4kahTtEjPCHaccrfJdP8p
         zrrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KS8r8oY8x2kfdcoMywa4LhAV1/KUW+EnGnL0wzDkhKI=;
        b=mojjIvMbGXQ5BgeIxumzTQS4T7HWrYksjTSdXqdP2cYFko3e7Jds5Jipe+Jhet5DCz
         msHKQfb6QFGEw3HM0AtWSQPyaqfhM4V+1HjMO1ESzWZi6OjzpaMznc5mLk7EKdmyvJxG
         oPB79bEeG5jUHtTYmQhiPLEz0QMA1kCYE5Z0feyD+Dt+C5AFJjnofb+TvPsY33gc76EH
         dw1UCvB4Tnu2Ifbg2LIw4Q2kz53rHw1PrRR2/+uLTh3eaMAV4OOStss+Xd+CpqEtgO1X
         wqSpX0AO+JY7zUmsO8IuieNouLJXcrrMVi6HxO15F6PpI7vgdlqVoNPLyPZi2j5K94/L
         0++A==
X-Gm-Message-State: AOAM530/i4Qohq55Uo8RNQjCGVIR0Duj7W160dvNjUkSA1eqnG5WbchP
        XBaODXd6/6eFur+7bbCA7XYagUCefxNj5Q==
X-Google-Smtp-Source: ABdhPJzFcx+eWsJQKRv7mLF8apQaGfRvJFN0KV+9ioKUf1R47r/RatHCinXubND6lTQTaQjjh0lO1w==
X-Received: by 2002:a50:cfc3:: with SMTP id i3mr11870213edk.36.1633667224180;
        Thu, 07 Oct 2021 21:27:04 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q6sm456536ejm.106.2021.10.07.21.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:27:03 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 01/10] trace-cmd dump: Add helpers for processing trace file version 7
Date:   Fri,  8 Oct 2021 07:26:52 +0300
Message-Id: <20211008042701.979075-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008042701.979075-1-tz.stoyanov@gmail.com>
References: <20211008042701.979075-1-tz.stoyanov@gmail.com>
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
index 2334b57e..d0278f7e 100644
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


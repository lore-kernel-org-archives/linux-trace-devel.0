Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 158DAC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:29:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbhLBMcg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:32:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240508AbhLBMcf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:32:35 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F4F9C061757
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:29:11 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id w1so115550127edc.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:29:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9oXXCwAzmHcpVWjxzfY8kimTg/T2kFD6d0BsjQXDCWI=;
        b=b2GN4TJIVcdlHiDTaEJznvV92ZH8nl2fWoPffw/jTqzsWJ9jVQaFzntcLIFzUjC9qg
         5jJjlcY1qpHd/YVyQE8oqdTQpAjovhPhFxGkuA/M+qIvp2eEfHBr/baiCaTHldMHBGRc
         ZOxPn6eJmcqhMOPiVGFAm4O5ynkpBh/JBU4mRGSeDNXYaXnNOWyJLumcKPLNYubl3PNp
         Q0Y7H7LdNMug/2Y6cyxtvHr1EN/TNF4VaVEZRvcMU3XCb7lBLzqMeXkghdwEQAoYE7zv
         DLXgv9O37FkO37FV0wrB6buB16Y3MYHedvQx2/N4Uu+gAjcFTHluiYM/iZP6nPgCdW0K
         0hbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9oXXCwAzmHcpVWjxzfY8kimTg/T2kFD6d0BsjQXDCWI=;
        b=RCY1f/Ccdj9dapTWapVtCaOHFFvDMLMwoySUqcGLwtHe/oeyjChjPIEzUMi1X9WRus
         Whucl4/Buzfvo/64d4gQvHey7l6wIYageVu6tV8KSpciqiiE0I8wSW1vbT5enwfFuzpp
         R4f2wJqPWtGN9zB7SPqlWaT4jy7yrofQuHGkEFsbnMOrChcBfVhvFNq0PB0HrsSb2pSu
         wff36T0DguXSXc3y23VFyc2zfdHPma5ZcnIWupa2Zi8wwL7I7JpXYdAfLhBBwsN5mEH9
         mpsNSIirjjUjcZX6+YKaejU8LAC2ajVOHJ5HtdCkrQyR0itLdXs6wJqWlJZMsPMR5Phm
         5gHQ==
X-Gm-Message-State: AOAM5339tvmvh+li53PPNudYOpOo+o45cfuATy/l2nxmekXPK9pRweOb
        iy69iYq92MJTp0tarvEPbyaPDXMzj7SEaQ==
X-Google-Smtp-Source: ABdhPJwIYt8CXb8GfnWz4sSiRJaXKhZuMPjWuIp6ybX7RjZE0rK4ES17HZ/lfwbR5r5ODfQKHHLmmA==
X-Received: by 2002:a17:906:d550:: with SMTP id cr16mr15255463ejc.544.1638448149688;
        Thu, 02 Dec 2021 04:29:09 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id m16sm2182692edd.61.2021.12.02.04.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:29:09 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 01/10] trace-cmd dump: Add helpers for processing trace file version 7
Date:   Thu,  2 Dec 2021 14:28:58 +0200
Message-Id: <20211202122907.44008-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122907.44008-1-tz.stoyanov@gmail.com>
References: <20211202122907.44008-1-tz.stoyanov@gmail.com>
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


Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB4DBC43460
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 07:39:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB5C86121E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 07:39:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235131AbhDVHkC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Apr 2021 03:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235139AbhDVHj5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Apr 2021 03:39:57 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17E08C061344
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Apr 2021 00:39:14 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id g5so60572205ejx.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Apr 2021 00:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gGcjKPtWmKpmkPgmiYCx4y3gtTcPTph8WVn/e4bDS7c=;
        b=kMbPg1yJMqJBEdH2uEIwRnnXiRuktijqa8S3iJ/WcHb4lOxtf+sS4KSTGm1Bub3OyL
         peTrRdSRdfeNimKVDNwJShjwXr64TsUBHmSxxHzADk9caPiWEy8QQyqQzUIbEYVaGXD8
         qu9toUi61+rBTovsn4x/aj9PpSy/wZZrH/FWpcEOQ6Oc1qTp/VSTbCrvbltySTyquvEv
         1g7MW53mrRWrdf3ee3W+oGY95UoUqDrv6k52ysmhqu4LCtUWNQSlbzQdS5ry4yAfD9eQ
         1pNQc1i8H6BQM10sIp/Ki960hAjTSGrrxqYlgc58YdDRd7aVqooi5HB7j3Em0e6Qv+fX
         EkwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gGcjKPtWmKpmkPgmiYCx4y3gtTcPTph8WVn/e4bDS7c=;
        b=sO2DuFfJ04m7ls6WG0srOIixIf+RH2tDLEwwn7mLRFXURtE/fDQEnb9hp74d8zBEaA
         +KQRi7bFLRayYJdnPkDlWkBzMELFBJdgMmq2XQIN28BVpIv7IJrdtxN6LZ/H04p6PYTJ
         fJtbGvLna6kmpytVmdrpvnCrB/mVXScsnmlvCNiw7KriWmjiRFLdgxoaIdjNuwIwsFD0
         +0bFb56wXeP8ckPc7By3xA+SzXBPpkBJM5SqGV0iEX6/xlZsnq0qnBEhZwTBQB68HvxU
         IYk4VBSm5340erxPMveTrekOP+DBm6EIu8pS7iwi9WLgYPz5i0P6DsFaSg2RYJNkYZFX
         qrcw==
X-Gm-Message-State: AOAM531NPEqQzf5H6CbAW8WkTNaupiyBoweQ2s/CGwJMER+KbxDSfRgN
        ShZuYHyourjxCyK08KoN7an0qKuzwmGVFQ==
X-Google-Smtp-Source: ABdhPJzrtZZtfPPRdTJzI6o0yfykY2orsGrNBx7m6jcLsow8dezAdi96OfZxLKjQd0ntAzf1Nj5bsA==
X-Received: by 2002:a17:906:3945:: with SMTP id g5mr1895564eje.427.1619077152620;
        Thu, 22 Apr 2021 00:39:12 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s5sm1253692ejq.52.2021.04.22.00.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 00:39:12 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 09/10] trace-cmd dump: Add support for trace files version 7
Date:   Thu, 22 Apr 2021 10:39:01 +0300
Message-Id: <20210422073902.484953-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210422073902.484953-1-tz.stoyanov@gmail.com>
References: <20210422073902.484953-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added support to read and dump information of trace files version 7.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-dump.c | 164 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 144 insertions(+), 20 deletions(-)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index aa48eaad..2c65a1d8 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -26,6 +26,12 @@
 static struct tep_handle *tep;
 static unsigned int trace_cpus;
 static int has_clock;
+static unsigned long file_version;
+
+static struct tracecmd_compress_proto *z_handle;
+static char *z_buffer;
+static unsigned long z_buffer_size;
+static unsigned long z_pointer;
 
 enum dump_items {
 	SUMMARY		= (1 << 0),
@@ -52,46 +58,72 @@ enum dump_items verbosity;
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
+
+static int read_compressed(int fd, char *dst, int len)
+{
+	int ret;
+
+	if (z_buffer) {
+		if (z_pointer + len > z_buffer_size)
+			return -1;
+		memcpy(dst, z_buffer + z_pointer, len);
+		z_pointer += len;
+		ret = len;
+	} else {
+		ret = read_fd(fd, dst, len);
+	}
+
+	return ret;
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
@@ -146,7 +178,6 @@ static void dump_initial_format(int fd)
 	char magic[] = TRACECMD_MAGIC;
 	char buf[DUMP_SIZE];
 	int val4;
-	unsigned long ver;
 
 	do_print(SUMMARY, "\t[Initial format]\n");
 
@@ -168,11 +199,11 @@ static void dump_initial_format(int fd)
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
@@ -192,6 +223,29 @@ static void dump_initial_format(int fd)
 	do_print(SUMMARY, "\t\t%d\t[Page size, bytes]\n", val4);
 }
 
+static void dump_compress(int fd)
+{
+	char compr[DUMP_SIZE];
+	char *ver = NULL;
+
+	if (file_version < 7)
+		return;
+
+	/* get compression header */
+	if (read_file_string(fd, compr, DUMP_SIZE))
+		die("no compression header");
+	ver = strchr(compr, ' ');
+	if (!ver)
+		die("no compression version");
+	*ver = '\0';
+	do_print((SUMMARY), "\t\t%s\t[Compression algorithm]\n", compr);
+	do_print((SUMMARY), "\t\t%s\t[Compression version]\n", ver + 1);
+
+	z_handle = tracecmd_compress_proto_get(compr, ver + 1);
+	if (!z_handle)
+		die("cannot uncomress the file");
+}
+
 static void dump_header_page(int fd)
 {
 	unsigned long long size;
@@ -234,11 +288,60 @@ static void dump_header_event(int fd)
 	read_dump_string(fd, size, HEAD_EVENT);
 }
 
+static void uncompress_reset(void)
+{
+	free(z_buffer);
+	z_buffer = NULL;
+	z_buffer_size = 0;
+	z_pointer = 0;
+}
+
+static int uncompress_block(int fd)
+{
+	unsigned int s_compressed;
+	unsigned int s_uncompressed;
+	char *bytes = NULL;
+	int ret;
+
+	if (file_version < 7 || !z_handle)
+		return 0;
+	uncompress_reset();
+	if (read_file_number(fd, &s_compressed, 4))
+		return -1;
+	if (read_file_number(fd, &s_uncompressed, 4))
+		return -1;
+
+	z_buffer = malloc(s_uncompressed);
+	if (!z_buffer)
+		return -1;
+	bytes = malloc(s_compressed);
+	if (!bytes)
+		goto error;
+
+	if (read_fd(fd, bytes, s_compressed) < 0)
+		goto error;
+	ret = tracecmd_uncompress_data(z_handle, bytes, s_compressed,
+				       z_buffer, &s_uncompressed);
+	if (ret)
+		goto error;
+	free(bytes);
+	z_buffer_size = s_uncompressed;
+	z_pointer = 0;
+	return 0;
+error:
+	uncompress_reset();
+	free(bytes);
+	return -1;
+
+}
+
 static void dump_ftrace_events_format(int fd)
 {
 	unsigned long long size;
 	unsigned int count;
 
+	if (uncompress_block(fd))
+		die("cannot uncopress file block");
 	do_print((SUMMARY | FTRACE_FORMAT), "\t[Ftrace format, ");
 	if (read_file_number(fd, &count, 4))
 		die("cannot read the count of the ftrace events");
@@ -251,6 +354,7 @@ static void dump_ftrace_events_format(int fd)
 		read_dump_string(fd, size, FTRACE_FORMAT);
 		count--;
 	}
+	uncompress_reset();
 }
 
 static void dump_events_format(int fd)
@@ -262,6 +366,9 @@ static void dump_events_format(int fd)
 
 	do_print((SUMMARY | EVENT_FORMAT | EVENT_SYSTEMS), "\t[Events format, ");
 
+	if (uncompress_block(fd))
+		die("cannot uncopress file block");
+
 	if (read_file_number(fd, &systems, 4))
 		die("cannot read the count of the event systems");
 
@@ -284,6 +391,7 @@ static void dump_events_format(int fd)
 		}
 		systems--;
 	}
+	uncompress_reset();
 }
 
 static void dump_kallsyms(int fd)
@@ -292,12 +400,17 @@ static void dump_kallsyms(int fd)
 
 	do_print((SUMMARY | KALLSYMS), "\t[Kallsyms, ");
 
+	if (uncompress_block(fd))
+		die("cannot uncopress file block");
+
 	if (read_file_number(fd, &size, 4))
 		die("cannot read the size of the kallsyms");
 
 	do_print((SUMMARY | KALLSYMS), "%d bytes]\n", size);
 
 	read_dump_string(fd, size, KALLSYMS);
+
+	uncompress_reset();
 }
 
 static void dump_printk(int fd)
@@ -306,12 +419,17 @@ static void dump_printk(int fd)
 
 	do_print((SUMMARY | TRACE_PRINTK), "\t[Trace printk, ");
 
+	if (uncompress_block(fd))
+		die("cannot uncopress file block");
+
 	if (read_file_number(fd, &size, 4))
 		die("cannot read the size of the trace printk");
 
 	do_print((SUMMARY | TRACE_PRINTK), "%d bytes]\n", size);
 
 	read_dump_string(fd, size, TRACE_PRINTK);
+
+	uncompress_reset();
 }
 
 static void dump_cmdlines(int fd)
@@ -320,12 +438,17 @@ static void dump_cmdlines(int fd)
 
 	do_print((SUMMARY | CMDLINES), "\t[Saved command lines, ");
 
+	if (uncompress_block(fd))
+		die("cannot uncopress file block");
+
 	if (read_file_number(fd, &size, 8))
 		die("cannot read the size of the saved command lines");
 
 	do_print((SUMMARY | CMDLINES), "%d bytes]\n", size);
 
 	read_dump_string(fd, size, CMDLINES);
+
+	uncompress_reset();
 }
 
 static void dump_cpus_count(int fd)
@@ -669,6 +792,7 @@ static void dump_file(const char *file)
 	do_print(SUMMARY, "\n Tracing meta data in file %s:\n", file);
 
 	dump_initial_format(fd);
+	dump_compress(fd);
 	dump_header_page(fd);
 	dump_header_event(fd);
 	dump_ftrace_events_format(fd);
-- 
2.30.2


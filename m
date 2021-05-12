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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFC5CC43461
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 06:38:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F5B5613B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 06:38:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhELGju (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 May 2021 02:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbhELGjt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 May 2021 02:39:49 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F115EC06175F
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 23:38:41 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id b17so25720331ede.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 23:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KcqaeC0E8JB2QkU0ajzNoubjwOnME2GGI/iefg1BUC4=;
        b=PdXUYxxbp6Uzd2DrV4SFI2//KO3rG1Oormqx1CfetgyBcIoZ81y5Q33M85+tqDwIww
         6zgIC/TZBtTEyBg3uGy5I5dhrE33ZdcBXOB7Cd202h1n11N0ZQlS0QTxEfRFwJNxmmXs
         IIFAN1Z+JEKt4n96O2YNPi2u7780j9HWu/uCG48e93juLlmEIuNZyNDtVzg9+BJm2fKD
         jNDoSiQcpG+Q7DXT8/k9JGBkkM2J5bYVIvfAgzyAwfTxRDugghHL3ungiuMkJ5iZV7ST
         7k4YKl4kLbBoQl1lnLo5qOCn/vkKs7hdzdTjDvfI11/8qRDHFvnQWWUOmdR8Y4SEnjwn
         a+fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KcqaeC0E8JB2QkU0ajzNoubjwOnME2GGI/iefg1BUC4=;
        b=Y5L2VyCINSVQWSbIgJIHXne+TKv0yWOlSAEty4d5J9Fcsn7nggYQZWmtEpdtT1Kqt5
         c2XJN+B72NwKHSD8fL1oDpPGhp2Ra0T/Q5CKtdK7GbB9XBxaI0x9MILj1qewvHH0jJ/l
         vWm8yTTtvqTF2NxonUxRLVFgq49b0QijRiHhu91ZbzOGsMdl9XGhNjhDHIDUfLL2wwrO
         DbEH1cVY5e5uFG9oA++2a3Q78E09DwS2tKaweWIwDkWiGFum0UbqEFaDd31u7EVSbJyF
         gFyYJkTKLMr/S7iDHjbGyoIiSzQk/0Aog62XuFHOTanWlob5z9t8tTRAdjcFF47six49
         rnYw==
X-Gm-Message-State: AOAM533lBwOTlenAD4G4nDUvWAP5JmuJTPe5pKAY7W5NGjXOr8BPkdJX
        3AW5OaEYaBcPPHu5ZUB9h7i4sv3MXYxgyQ==
X-Google-Smtp-Source: ABdhPJzVCj7zKfpgm82x7f5HPhDLXjpqoeXJAVpPzcQRGkFAH+fthJ9Zp7HSYIOCuJzTGf4GOsfdyw==
X-Received: by 2002:a50:8fe6:: with SMTP id y93mr41004890edy.224.1620801520691;
        Tue, 11 May 2021 23:38:40 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id h23sm13387723ejx.90.2021.05.11.23.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 23:38:40 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 16/25] trace-cmd dump: Add support for trace files version 7
Date:   Wed, 12 May 2021 09:38:14 +0300
Message-Id: <20210512063823.324610-17-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512063823.324610-1-tz.stoyanov@gmail.com>
References: <20210512063823.324610-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added support to read and dump information of trace files version 7.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-dump.c | 125 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 105 insertions(+), 20 deletions(-)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index 03cc82b4..ed82104b 100644
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
@@ -52,46 +55,62 @@ enum dump_items verbosity;
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
@@ -146,7 +165,6 @@ static void dump_initial_format(int fd)
 	char magic[] = TRACECMD_MAGIC;
 	char buf[DUMP_SIZE];
 	int val4;
-	unsigned long ver;
 
 	do_print(SUMMARY, "\t[Initial format]\n");
 
@@ -168,11 +186,11 @@ static void dump_initial_format(int fd)
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
@@ -192,6 +210,29 @@ static void dump_initial_format(int fd)
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
+	compress = tracecmd_compress_alloc(compr, ver + 1, fd, tep, NULL);
+	if (!compress)
+		die("cannot uncomress the file");
+}
+
 static void dump_header_page(int fd)
 {
 	unsigned long long size;
@@ -234,11 +275,34 @@ static void dump_header_event(int fd)
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
 	unsigned int count;
 
+	if (uncompress_block())
+		die("cannot uncompress file block");
 	do_print((SUMMARY | FTRACE_FORMAT), "\t[Ftrace format, ");
 	if (read_file_number(fd, &count, 4))
 		die("cannot read the count of the ftrace events");
@@ -251,6 +315,7 @@ static void dump_ftrace_events_format(int fd)
 		read_dump_string(fd, size, FTRACE_FORMAT);
 		count--;
 	}
+	uncompress_reset();
 }
 
 static void dump_events_format(int fd)
@@ -262,6 +327,9 @@ static void dump_events_format(int fd)
 
 	do_print((SUMMARY | EVENT_FORMAT | EVENT_SYSTEMS), "\t[Events format, ");
 
+	if (uncompress_block())
+		die("cannot uncompress file block");
+
 	if (read_file_number(fd, &systems, 4))
 		die("cannot read the count of the event systems");
 
@@ -284,6 +352,7 @@ static void dump_events_format(int fd)
 		}
 		systems--;
 	}
+	uncompress_reset();
 }
 
 static void dump_kallsyms(int fd)
@@ -292,12 +361,17 @@ static void dump_kallsyms(int fd)
 
 	do_print((SUMMARY | KALLSYMS), "\t[Kallsyms, ");
 
+	if (uncompress_block())
+		die("cannot uncompress file block");
+
 	if (read_file_number(fd, &size, 4))
 		die("cannot read the size of the kallsyms");
 
 	do_print((SUMMARY | KALLSYMS), "%d bytes]\n", size);
 
 	read_dump_string(fd, size, KALLSYMS);
+
+	uncompress_reset();
 }
 
 static void dump_printk(int fd)
@@ -306,12 +380,17 @@ static void dump_printk(int fd)
 
 	do_print((SUMMARY | TRACE_PRINTK), "\t[Trace printk, ");
 
+	if (uncompress_block())
+		die("cannot uncompress file block");
+
 	if (read_file_number(fd, &size, 4))
 		die("cannot read the size of the trace printk");
 
 	do_print((SUMMARY | TRACE_PRINTK), "%d bytes]\n", size);
 
 	read_dump_string(fd, size, TRACE_PRINTK);
+
+	uncompress_reset();
 }
 
 static void dump_cmdlines(int fd)
@@ -320,12 +399,17 @@ static void dump_cmdlines(int fd)
 
 	do_print((SUMMARY | CMDLINES), "\t[Saved command lines, ");
 
+	if (uncompress_block())
+		die("cannot uncompress file block");
+
 	if (read_file_number(fd, &size, 8))
 		die("cannot read the size of the saved command lines");
 
 	do_print((SUMMARY | CMDLINES), "%d bytes]\n", size);
 
 	read_dump_string(fd, size, CMDLINES);
+
+	uncompress_reset();
 }
 
 static void dump_cpus_count(int fd)
@@ -669,6 +753,7 @@ static void dump_file(const char *file)
 	do_print(SUMMARY, "\n Tracing meta data in file %s:\n", file);
 
 	dump_initial_format(fd);
+	dump_compress(fd);
 	dump_header_page(fd);
 	dump_header_event(fd);
 	dump_ftrace_events_format(fd);
-- 
2.31.1


Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F704C43219
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:13:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE11361252
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:13:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234029AbhKKPPt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:15:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234030AbhKKPPr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:15:47 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF48C061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:12:57 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id f8so25656165edy.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:12:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PH/XyhHdUEZTPFiWA1EBnh+dtXsTepoAuGsqMwaJ0o0=;
        b=lnbC5n/240a5HEpY2O7k7VB9fc/ihUyXlqjG6kK7H1sLQokf4MUUlaS5cwIk82jUz/
         z9wxMtDhuu62o++CzzkRfvcTAdj02eBXpVQ40SeawPWY+J7eotMvruApeNy8MHMoDDvb
         9h1OT/jkKs2mW0UYQjt2cZbfQC2n5xGcfehjIwd6yTaj/7SjeW0No13JGRHd5swQADat
         CVr5x3cZ2pvJ/Qacv0f631L4OXFjlX44A+4ASo6TP1goWNpNIPgKsl/6agy+ybRTgVDd
         G0+9iB0oalhU8BK8xp+hEXc34nqgOWkTtkxo9KUhdtjnREfZ0yTZMMsA0p/46c3i551h
         LUKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PH/XyhHdUEZTPFiWA1EBnh+dtXsTepoAuGsqMwaJ0o0=;
        b=wC/At5pfttNx3gCe3JCnBFRAmuiu/BYsNYlUA2eW1wLrJvYoaIsyLHYKeefW2hIkZs
         PaY+04ubcT0FgGBUvZ8SiQBoc71kp8oPSpx6Q03msV3PP5uNue/4YL/YeX9Tql/2VYV7
         H9JvDoLNg8iXqi4pl0GnvZMh5Z2QTt/X7MppxYS4v2iq+UGD2mD9HuQtud5az54193IL
         QzVNm3a5nPxr0+z+ZFY39qIH+6iNLd+fmI/BhIUEcdGTyPLDp1Pu2NaEGLFzESi/SQvk
         WbXUC5kr+Mk/2D3jUbkDNUfXLxoARgUxdbynQFfzIf56FwfKdRW45VDjZZDEmTjj5NdM
         kgng==
X-Gm-Message-State: AOAM5332LVwG4Ynorj57I3MaHVA4NSKwW2m34u6Fls9eDDRvB/GHs2XI
        VIKzNffsis/zp/mrHf4efLTq9c0SQtYC+Q==
X-Google-Smtp-Source: ABdhPJzHZveY2W4DxVN8kt8+80xCBIESjsxVu3hqmqf12AQaJsDrjVGhVLcZEiVN98qPWbcYoZBKqQ==
X-Received: by 2002:a05:6402:2808:: with SMTP id h8mr10770618ede.267.1636643576552;
        Thu, 11 Nov 2021 07:12:56 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q2sm1443375eje.118.2021.11.11.07.12.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:12:56 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 04/10] trace-cmd dump: Read recursively all options sections
Date:   Thu, 11 Nov 2021 17:12:44 +0200
Message-Id: <20211111151250.87023-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111151250.87023-1-tz.stoyanov@gmail.com>
References: <20211111151250.87023-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Trace file version 7 supports multiple options sections in the file. The
DONE option is extended to hold the offset to the next options section.
A new logic for handling the extended DONE option and to read recursively
all options sections is added.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-dump.c | 76 ++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 68 insertions(+), 8 deletions(-)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index e3c40a0d..a808c7d7 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -422,6 +422,30 @@ static void dump_option_string(int fd, int size, char *desc)
 		read_dump_string(fd, size, OPTIONS);
 }
 
+static void dump_section_header(int fd, enum dump_items v, unsigned short *flags)
+{
+	unsigned long long offset;
+	unsigned short fl;
+	char buf[DUMP_SIZE];
+	unsigned short id;
+	int size;
+
+	offset = lseek64(fd, 0, SEEK_CUR);
+	if (read_file_number(fd, &id, 2))
+		die("cannot read the section id");
+	if (read_file_string(fd, buf, DUMP_SIZE))
+		die("no section description");
+	if (read_file_number(fd, &fl, 2))
+		die("cannot read the section flags");
+	if (read_file_number(fd, &size, 4))
+		die("cannot read section size");
+	do_print(v, "\t[Section %d @ %lld: \"%s\", flags 0x%X, %d bytes]\n",
+		 id, offset, buf, fl, size);
+
+	if (flags)
+		*flags = fl;
+}
+
 static void dump_option_buffer(int fd, int size)
 {
 	unsigned long long offset;
@@ -636,25 +660,48 @@ void dump_option_tsc2nsec(int fd, int size)
 	do_print(OPTIONS, "%d %d %llu [multiplier, shift, offset]\n", mult, shift, offset);
 }
 
-static void dump_options(int fd)
+static int dump_options_read(int fd);
+
+static int dump_option_done(int fd, int size)
 {
+	unsigned long long offset;
+
+	do_print(OPTIONS, "\t\t[Option DONE, %d bytes]\n", size);
+
+	if (file_version < FILE_VERSION_SECTIONS || size < 8)
+		return 0;
+	if (read_file_number(fd, &offset, 8))
+		die("cannot read the next options offset");
+	do_print(OPTIONS, "%lld\n", offset);
+	if (!offset)
+		return 0;
+
+	if (lseek64(fd, offset, SEEK_SET) == (off_t)-1)
+		die("cannot goto next options offset %lld", offset);
+	return dump_options_read(fd);
+}
+
+static int dump_options_read(int fd)
+{
+	unsigned short flags = 0;
 	unsigned short option;
 	unsigned int size;
 	int count = 0;
 
+	if (file_version >= FILE_VERSION_SECTIONS)
+		dump_section_header(fd, OPTIONS, &flags);
+	if ((flags & TRACECMD_SEC_FL_COMPRESS) && uncompress_block())
+		die("cannot uncompress file block");
+
 	for (;;) {
 		if (read_file_number(fd, &option, 2))
 			die("cannot read the option id");
-		if (!option)
+		if (option == TRACECMD_OPTION_DONE && file_version < FILE_VERSION_SECTIONS)
 			break;
 		if (read_file_number(fd, &size, 4))
 			die("cannot read the option size");
 
 		count++;
-		if (!DUMP_CHECK(OPTIONS) && !DUMP_CHECK(CLOCK) && !DUMP_CHECK(SUMMARY)) {
-			lseek64(fd, size, SEEK_CUR);
-			continue;
-		}
 		switch (option) {
 		case TRACECMD_OPTION_DATE:
 			dump_option_string(fd, size, "DATE");
@@ -666,7 +713,8 @@ static void dump_options(int fd)
 			dump_option_buffer(fd, size);
 			break;
 		case TRACECMD_OPTION_TRACECLOCK:
-			dump_option_string(fd, size, "TRACECLOCK");
+			do_print(OPTIONS, "\t\t[Option TRACECLOCK, %d bytes]\n", size);
+			read_dump_string(fd, size, OPTIONS | CLOCK);
 			has_clock = 1;
 			break;
 		case TRACECMD_OPTION_UNAME:
@@ -699,6 +747,10 @@ static void dump_options(int fd)
 		case TRACECMD_OPTION_TSC2NSEC:
 			dump_option_tsc2nsec(fd, size);
 			break;
+		case TRACECMD_OPTION_DONE:
+			uncompress_reset();
+			count += dump_option_done(fd, size);
+			return count;
 		default:
 			do_print(OPTIONS, " %d %d\t[Unknown option, size - skipping]\n",
 				 option, size);
@@ -706,8 +758,16 @@ static void dump_options(int fd)
 			break;
 		}
 	}
-	do_print(SUMMARY, "\t[%d options]\n", count);
+	uncompress_reset();
+	return count;
+}
+
+static void dump_options(int fd)
+{
+	int count;
 
+	count = dump_options_read(fd);
+	do_print(SUMMARY|OPTIONS, "\t[%d options]\n", count);
 }
 
 static void dump_latency(int fd)
-- 
2.33.1


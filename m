Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4019C43219
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:29:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346808AbhLBMci (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:32:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240508AbhLBMcg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:32:36 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 318F8C06174A
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:29:14 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id y13so115259775edd.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:29:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PH/XyhHdUEZTPFiWA1EBnh+dtXsTepoAuGsqMwaJ0o0=;
        b=Rdz/wMP0Fg0Lv7o8PQkZhLheMTm/aL+ZsLvWimFdDP+If9Hh5TebVKq6ydxgQytTHL
         0WVM4w5gur7dss+zEFfsivQRSwFK0PIQigs8qFHhT1rFRwGMnUMIc2D1i1wpFT3ppWV3
         +kzT105A8z3VGorDcwPsaKZRXpULI7ByA62Bv7ol4kBmnOrQmwwEk+xRn9jrjt6e5CU4
         cVm3zF6Whzj0Tj8P4Xr4RpBQzB02u8FxVrSuCILBg0DbvN2NHzdCaV8SbsudJcz7P+Vf
         NEPEmFDmBoM3AkvMtGbDg9GqJRFFViG2cAq5Wgs3B0MV/EjALxUsJozMbsJBxRaroZam
         evBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PH/XyhHdUEZTPFiWA1EBnh+dtXsTepoAuGsqMwaJ0o0=;
        b=4A5iY2Oyw1B9QhQMFg4b+nrFuwtcBechwUIOtrYFoLQUi6y6SJHHvy+rL7nWArEUv4
         FTJP5KNgcMKAd0+Iwx+fh+m2HXDMDGiZCGKOXGl7T4oPSttWqBVeViCZC7M+EUSDhbqF
         +hUyEkAmbVpHpxcADozfxWIPBiCO93Ee42dlmBZVM06g6sO/oN534CXIas54HFHLxaJz
         pACdI6T8d30zqG/evLVpOrb2iQOkCPe2Pco7YTSq2V6CmpwEStSiYY45nEmYXZ5EsMO9
         XurArsNw1LejB6Oe8O2lUVREfmf3yUGJUUo+csJkt7s41393p2FSg6iRCuseZXYPBmOI
         1Hwg==
X-Gm-Message-State: AOAM532X+KHvIpd+sb2ambo5JUILfWjo5ONBTjLizEWGHcjXUXBGsQV+
        kRQL6I4MLvXvq9hkdc1Bm0ixjDFUhO6u2w==
X-Google-Smtp-Source: ABdhPJxoojIphzMCUMQSc51vOviys3bZEGTOcNkuVolxKe+wFWmCYpIhYMgcxCAD8lw5A7PMJb89kQ==
X-Received: by 2002:a05:6402:12c1:: with SMTP id k1mr17209044edx.355.1638448152814;
        Thu, 02 Dec 2021 04:29:12 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id m16sm2182692edd.61.2021.12.02.04.29.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:29:12 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 04/10] trace-cmd dump: Read recursively all options sections
Date:   Thu,  2 Dec 2021 14:29:01 +0200
Message-Id: <20211202122907.44008-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122907.44008-1-tz.stoyanov@gmail.com>
References: <20211202122907.44008-1-tz.stoyanov@gmail.com>
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


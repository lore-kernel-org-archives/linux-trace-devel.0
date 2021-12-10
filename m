Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF1F7C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 11:05:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240274AbhLJLIz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 06:08:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240250AbhLJLIy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 06:08:54 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52355C061A32
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:05:19 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id y12so28156691eda.12
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:05:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AuBFvWKU2KH1ROEAP0YCbTsIUDqlZwTOWLgEb58W5kI=;
        b=lVBIO+j1NSt7jjqYM/qjclZAtlvRcUsIj4kDrMXpj+cKG5IiD8N+IhlQWhQsR9yN1N
         /Q9xeeJNhx/Q91358pUSOMp1RbYR45e0CtLL8kafsk+gq7SoyM4GZHgFIRgkRhTcZFjA
         rY3QCgcn8sq9CSz1ImBEsBxvX8jgXsEq9xa8MusuzgtJPH4ol8iF6PvYR9kykby+/5YW
         bJHRq/5FDnhGlnW5ctHhUOGAZPdgFg+T8asXvEznAf9mk38+uqNO/lSeYGse1RzJ/uxC
         EGkHYR/bR2/To22bga+EwnZMqNcNUNRMO799c4k8/oMuLw/yRWef/2wAbfDo9zzsA3om
         GGZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AuBFvWKU2KH1ROEAP0YCbTsIUDqlZwTOWLgEb58W5kI=;
        b=d9+VQoqAdlcvhYpU+/lhGUtRrM8dqXUgln9Mx1jJa8oUFfATS6Rte/C2AAb2MJEngN
         5eV5pbGTMUbVo6xJImYKSpr/du8e4c7yczADCoIDx1kPuVjZAG7ovedeaq3ZnrbrcUnf
         17fJAJ6Q7rhvl8aCGeebQmYfwRiFeGwzUjXI0ugLOmOb80ml32FbXAS4vOWRPgMkG1uN
         TbvqN/ATI38DP8/FRAFrWSDSRcoV1HLMigq7Jgj0mCGOlsXezJw369s3/gYUY282UPd9
         8GlnBsRz5TBVkd31UtTpCEQYJiZirJ9hsV7OgKAXVsXS12QPM2PSb5lbU/mGVV/9X2Dn
         YMyQ==
X-Gm-Message-State: AOAM532FR8zCzGlF1JgwjUxfii/3b+bQRyIdIdWiSDDp6WCTHMKJlHWh
        yVQkzE7roGQ6QpJpwg/DgPgEkwLWGCE=
X-Google-Smtp-Source: ABdhPJx8zKcGuOpEuaQEqCQ8s0dH0JqKo+uh9NhqT27cEU4fZym6/1TN+QMY7ZbkcEqcJ7Oj1sl2Rg==
X-Received: by 2002:a05:6402:270a:: with SMTP id y10mr38172591edd.108.1639134317786;
        Fri, 10 Dec 2021 03:05:17 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gs17sm1278887ejc.28.2021.12.10.03.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 03:05:17 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 04/11] trace-cmd dump: Read recursively all options sections
Date:   Fri, 10 Dec 2021 13:05:04 +0200
Message-Id: <20211210110511.98856-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210110511.98856-1-tz.stoyanov@gmail.com>
References: <20211210110511.98856-1-tz.stoyanov@gmail.com>
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
 tracecmd/trace-dump.c | 78 ++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 70 insertions(+), 8 deletions(-)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index 113eee8e..53e2f9c0 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -422,6 +422,29 @@ static void dump_option_string(int fd, int size, char *desc)
 		read_dump_string(fd, size, OPTIONS);
 }
 
+static void dump_section_header(int fd, enum dump_items v, unsigned short *flags)
+{
+	unsigned long long offset, size;
+	unsigned short fl;
+	unsigned short id;
+	int desc_id;
+
+	offset = lseek64(fd, 0, SEEK_CUR);
+	if (read_file_number(fd, &id, 2))
+		die("cannot read the section id");
+	if (read_file_number(fd, &desc_id, 4))
+		die("no section description");
+	if (read_file_number(fd, &fl, 2))
+		die("cannot read the section flags");
+	if (read_file_number(fd, &size, 8))
+		die("cannot read section size");
+	do_print(v, "\t[Section %d @ %lld, flags 0x%X, %lld bytes]\n",
+		 id, offset, fl, size);
+
+	if (flags)
+		*flags = fl;
+}
+
 static void dump_option_buffer(int fd, int size)
 {
 	unsigned long long offset;
@@ -636,25 +659,51 @@ void dump_option_tsc2nsec(int fd, int size)
 	do_print(OPTIONS, "%d %d %llu [multiplier, shift, offset]\n", mult, shift, offset);
 }
 
-static void dump_options(int fd)
+static int dump_options_read(int fd);
+
+static int dump_option_done(int fd, int size)
+{
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
+
+	do_print(OPTIONS, "\n\n");
+
+	return dump_options_read(fd);
+}
+
+static int dump_options_read(int fd)
 {
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
@@ -666,7 +715,8 @@ static void dump_options(int fd)
 			dump_option_buffer(fd, size);
 			break;
 		case TRACECMD_OPTION_TRACECLOCK:
-			dump_option_string(fd, size, "TRACECLOCK");
+			do_print(OPTIONS, "\t\t[Option TRACECLOCK, %d bytes]\n", size);
+			read_dump_string(fd, size, OPTIONS | CLOCK);
 			has_clock = 1;
 			break;
 		case TRACECMD_OPTION_UNAME:
@@ -699,6 +749,10 @@ static void dump_options(int fd)
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
@@ -706,8 +760,16 @@ static void dump_options(int fd)
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


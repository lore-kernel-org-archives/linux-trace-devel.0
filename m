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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDF92C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5BB160EB2
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234107AbhG2FLJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234099AbhG2FLJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:11:09 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D684C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:11:05 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id y7so4163391eda.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n5T1nB9MQRSSRkYUuBZFkjXArsJT3nSCVMgCmD3VoXw=;
        b=AdLIQGtfWFGtjnNHqc6fiY4FT65BRff+k2XjaJuC5mrbefLYiPo32fOZOMBt5R8NUw
         u97vH1BiKUCUtGIE7xfJL3MFI3QjIFxib0RROUdw5Df2vE2k3U242ODnCCpJv9eftHHI
         4t9pqh+IntvaIawyS35j1tCv8mki9yPIIK2FKXJBGEPBr265AnSlM73/+PTWcCsfcGvw
         pqVRDjbzTZ5pdoBoCj22/9G3LZNXdyD9yEhiK2moc2NGlHm/LEkk/RA6BxIkfc20+w+i
         W8fSzFu5FJLsym5waJNssrXGjYHqZi77hBK4TNrUTAQPUSxFzsCArKkW3FYQSnNoyqpK
         TrSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n5T1nB9MQRSSRkYUuBZFkjXArsJT3nSCVMgCmD3VoXw=;
        b=krQBYMCMPNXohPVFcprSYWsmVpRqyKIlLVaCTz6FgZ3E9UAXvKZ/9vG2MjCT3qxNzn
         8esmt5IYwDLNoZawfSBEMZnSZRDKZluLXjESBpovbqvqg7ms4lkJUS/mfu1aK0XtMk48
         EfiAVRc2SLeN72iqd9JSqduM8IVTsgvLH0W466rDd12AG8cesQgVq+s4JGRXkOKrcq3g
         RO5UysGBsc2aiusKAkSk4B+0NfKdmAenyzoJbGsxLLSQJ3pfpMmSsS6pfSXL6JP9pxvU
         TwFgrzxq7tc1FjRW2AE6Sqllt7lgi3/n1aHlzKgcU/uFO8aiIhhvMlAeal/h3SGDhSy2
         7BNA==
X-Gm-Message-State: AOAM531jygpX+GlCOU5Vy6d/wos90b5/7sNpRhs55xzlLUPAeUYZjOgv
        ZyyrLxF+3oVrP4IQhHfY+t0=
X-Google-Smtp-Source: ABdhPJyzQMLwIwpFS0DDTkrPibijtGO/lp8GfKhZdWF2MLFoSOXUABEUkd96Tn3idxmamo248bL3pg==
X-Received: by 2002:a05:6402:10d9:: with SMTP id p25mr3896917edu.51.1627535464242;
        Wed, 28 Jul 2021 22:11:04 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.11.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:11:03 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 65/87] trace-cmd dump: Read recursively all options sections
Date:   Thu, 29 Jul 2021 08:09:37 +0300
Message-Id: <20210729050959.12263-66-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
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
index 010a8188..f801e0b6 100644
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
@@ -591,25 +615,48 @@ void dump_option_tsc2nsec(int fd, int size)
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
+	if (file_version < 7 || size < 8)
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
 
+	if (file_version >= 7)
+		dump_section_header(fd, OPTIONS, &flags);
+	if ((flags & TRACECMD_SEC_FL_COMPRESS) && uncompress_block())
+		die("cannot uncompress file block");
+
 	for (;;) {
 		if (read_file_number(fd, &option, 2))
 			die("cannot read the option id");
-		if (!option)
+		if (option == TRACECMD_OPTION_DONE && file_version < 7)
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
@@ -621,7 +668,8 @@ static void dump_options(int fd)
 			dump_option_buffer(fd, size);
 			break;
 		case TRACECMD_OPTION_TRACECLOCK:
-			dump_option_string(fd, size, "TRACECLOCK");
+			do_print(OPTIONS, "\t\t[Option TRACECLOCK, %d bytes]\n", size);
+			read_dump_string(fd, size, OPTIONS | CLOCK);
 			has_clock = 1;
 			break;
 		case TRACECMD_OPTION_UNAME:
@@ -654,6 +702,10 @@ static void dump_options(int fd)
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
@@ -661,8 +713,16 @@ static void dump_options(int fd)
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
2.31.1


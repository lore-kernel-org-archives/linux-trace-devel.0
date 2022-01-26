Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EE42C63682
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 09:53:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232875AbiAZJxs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 04:53:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbiAZJxs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 04:53:48 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04691C061744
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:53:48 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id me13so37849489ejb.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:53:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GE0s7iwcPZplwcBlTdkT7JDgvtvuOg4fTx6PEReRF0M=;
        b=X1zjVcrwWYeqepSjZfMQpQxH7zLIySrorDzkV8NI3hA4wLqgVDNcUbl9EPI4BzkO2j
         DK/pcOKjSpVc4BapwoogimymFx4B4bY64t/cQRL2xzKo/jfTey8ow2TxX6lnkl9cIRF9
         oRvzWu9lCpNuRzBBIM99MP7w4Pjnpg8zKCtS/ncAdzy9pgxRTrbEdpAHlougFZyUDA98
         +8wFL/4BgUb6XUIua8Txa3dWp5a9V377EpDyJ9Cueibc4KUkciAzmqbkqt50kQIM9/XL
         HUFuAJmrHxfqTIy7zFz4ZIhERAEz/iZ6qGDb5dIB4d6BepTJ4eaaCdox9fRROM5pYGTy
         je5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GE0s7iwcPZplwcBlTdkT7JDgvtvuOg4fTx6PEReRF0M=;
        b=WEg2cnXp4Kzdoom+mTSqkkWyC2lKOr/xR/5o1wCfsEAZViwU8hE77S9xdafea3iF82
         ugQsa1zSf7Sq6Ary6bQaHaK/d/x2tT+SIHncG6dHxak9w2xNs3ifvf2QkAvBpTO0qPwK
         sS68Cwldw/kPZyR0X8CQYMrQjuboHtOIQhrEBfj0t+2LlR6mDD5F7eTOs0rKX8eD9PSv
         T2pMdNChHgb511AIUhr5SzxjtTcEn9YM2f7wKjEQSrnx5KXn0y8mskr1DYUQh0F7LC9V
         u5lGco5u0jBIAF92f3znH9v4rNkjlDxNfxuUqOhqQ5N0lRLg8k90zq8rOfeOtHasdmhk
         BQ4Q==
X-Gm-Message-State: AOAM532ENBbCwM4cWrgQUByj9tjGuODs5hSukABlCNaE2gBC1iYPQS+6
        sfJOz6y/0SudQt8jOyVLBATj4+jG/EM=
X-Google-Smtp-Source: ABdhPJxQ47Sedtay618Ok4yxhi9BiuOIHyffEmR14OWgPloEeW8UvUEc6usmukuo5O3mFHMp1UOI1A==
X-Received: by 2002:a17:907:1b24:: with SMTP id mp36mr19454624ejc.487.1643190826582;
        Wed, 26 Jan 2022 01:53:46 -0800 (PST)
Received: from oberon.zico.biz ([151.251.254.11])
        by smtp.gmail.com with ESMTPSA id h19sm3177266edv.90.2022.01.26.01.53.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 01:53:46 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 04/11] trace-cmd dump: Read recursively all options sections
Date:   Wed, 26 Jan 2022 11:53:30 +0200
Message-Id: <20220126095337.570867-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126095337.570867-1-tz.stoyanov@gmail.com>
References: <20220126095337.570867-1-tz.stoyanov@gmail.com>
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
 tracecmd/trace-dump.c | 85 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 77 insertions(+), 8 deletions(-)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index c4ad6c5b..e04e275a 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -427,6 +427,33 @@ static void dump_option_string(int fd, int size, char *desc)
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
+
+	if (read_file_number(fd, &fl, 2))
+		die("cannot read the section flags");
+
+	if (read_file_number(fd, &desc_id, 4))
+		die("no section description");
+
+	if (read_file_number(fd, &size, 8))
+		die("cannot read section size");
+
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
@@ -641,25 +668,54 @@ void dump_option_tsc2nsec(int fd, int size)
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
+
+	if (read_file_number(fd, &offset, 8))
+		die("cannot read the next options offset");
+
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
+{
+	unsigned short flags = 0;
 	unsigned short option;
 	unsigned int size;
 	int count = 0;
 
+	if (file_version >= FILE_VERSION_SECTIONS)
+		dump_section_header(fd, OPTIONS, &flags);
+
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
@@ -671,7 +727,8 @@ static void dump_options(int fd)
 			dump_option_buffer(fd, size);
 			break;
 		case TRACECMD_OPTION_TRACECLOCK:
-			dump_option_string(fd, size, "TRACECLOCK");
+			do_print(OPTIONS, "\t\t[Option TRACECLOCK, %d bytes]\n", size);
+			read_dump_string(fd, size, OPTIONS | CLOCK);
 			has_clock = 1;
 			break;
 		case TRACECMD_OPTION_UNAME:
@@ -704,6 +761,10 @@ static void dump_options(int fd)
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
@@ -711,8 +772,16 @@ static void dump_options(int fd)
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
2.34.1


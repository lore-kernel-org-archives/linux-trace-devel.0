Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C533BC433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:21:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A88DA60ED8
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:21:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233105AbhINNXN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233079AbhINNXM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:23:12 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC55C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:21:55 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id x22so334385ejj.8
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wg0a57cr/r26Fm3sybPaTjbWfq8hx070vW8oQ3zhuAQ=;
        b=bZ+wDUmhDWtZNgSqHzKVG7shM0gFDAtVl/x0sZzWnQguvtwHhBQgR/EGD8DNEt35pa
         QL9XXapCVJaoe58G7J63Z+uplk31K81Y4lgU/6GOmbmD/oDCSzHFYonTGFGZHzsnzf3X
         m0vWf0xUfXIhNUtBGa2uq26q5BpGpi37Xda7ahMu0t77hJHbkXlyBvY7Jn405BmZrvtl
         odT4aoNI5KPqx+O/C5lWwh1ZT4NlS/R0k+VXY/8jWWnY5BZlm0RmTxR+bdhvmy01845h
         VUgWBywBKSFlm8rI1oXS7Jr3L7e8FDF98r22Jpjfi/pozulVVaMLy2Hn3juxlde97TSj
         CReQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wg0a57cr/r26Fm3sybPaTjbWfq8hx070vW8oQ3zhuAQ=;
        b=QrecU2GQVQ5rqCyRUW/KZxtg2oLc4ehSWdJX4O3gla7KjrRLaESbnXmkcQS/UI0YsP
         wjldNGk/CPWlblRbdY01Vf7FVJCoEgZUtzxJo/Wl6jb3zkCjFRlJPm2WutQBrNvSdNqx
         YthRIyQ7kk2TwQvDEOUSLpKF2eb5zemGGA6U95dYoViHnJO3u72WdoBIHUg7jHReARc4
         /r9Pou5l0EANZRi74VVoy/msyimnoqo2iZjuAsqpYVmcVWsLq7s4JJARXoI6hmjTIRkH
         lcxRfAub30XRvVLPdk+dLfFFAJOcTrNsf/jU8sfEnFwf+kXNc7b0dxWu6ERXXgTh4qbg
         Bf5g==
X-Gm-Message-State: AOAM531RQIsTD8eDigW76h/CMaCZWfEZ5EjNOCBZMgJ/mg9R7+XAVbZE
        gIy9eYjRzfG6uIDNp9RQapBpaPR6V64=
X-Google-Smtp-Source: ABdhPJzWeKH9wOmkgirtZgPu3uUlqk5GO1ryN7Wilvia1D9DAQ0K4b1J70kCE6DrrRFJLtbKk2Ugbw==
X-Received: by 2002:a17:906:31d7:: with SMTP id f23mr18467844ejf.190.1631625714004;
        Tue, 14 Sep 2021 06:21:54 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l7sm5708431edb.26.2021.09.14.06.21.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:21:53 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 04/10] trace-cmd dump: Read recursively all options sections
Date:   Tue, 14 Sep 2021 16:21:42 +0300
Message-Id: <20210914132148.3968401-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914132148.3968401-1-tz.stoyanov@gmail.com>
References: <20210914132148.3968401-1-tz.stoyanov@gmail.com>
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
index f7284436..dcc41030 100644
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


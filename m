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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43A0EC4320A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:34:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B73260FED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:34:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236792AbhG1NeN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236768AbhG1NeM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:34:12 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1651C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:34:09 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id u12so3272345eds.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jGdTA6PBLOJIDUGnHGfDjGvq7YEBTD41Ff21V5ChQEA=;
        b=ToqfRIGRCa0BldCt2+YFAAU0uv6UdSLbAurfK426CWTh40tm+xy4VNfcYqKz8C2MsO
         1myqaIMwDNkHkCO7uoX3zuTv7uKmxarXBmXkclTIrQi0NRlQjyZrLoGDSW4rHxbbm9lY
         wGS9PrjqNoq2VykA99j5VZwVWvxCSPfKqOUiFpNRjo/V38wdd2ZScH+WRmKIL6fCKmC0
         5NWA+Yb2oVURWmkAcWrOox7TCtK2VN/zS7gVGTi6vASOdDLGeViBjRkhwXN1LlaSsz4F
         Al7WZkVAprp8urAjEUoFqLoRGSZV8ECfuCjV8l37Yex+e3H3ctnmEKpEM5SRKZQk+ZWb
         q2lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jGdTA6PBLOJIDUGnHGfDjGvq7YEBTD41Ff21V5ChQEA=;
        b=D/4WHych6S9pRkS6K7pAeKB6PRLq1CsIot88tNdCwsJ37QyxoMLs8IpBbgKBwYGVKb
         aG/EFnr0fMhujp+HTqpG0Z8+NXt+W+z5m3zhvDLV4Km7z14xdhDHzVTIHITCsRrzeTq2
         CPWuHZaHYqxDLmw4Zc68J5fhJocJChVxB9Xk+p7nNZtfrzS0TPlUUyd/AcqRszbJ1lkY
         yKXp+a2X1sIagqFdo1hQ+lFgozJOWC51fLrhmaDHNQD5z5nttpIy3zxKyeAQfHH/1Yzz
         H6Jc8czbw1Dxy7WogrD8vg1ZqMJjxbRkXeYXfR6kjJ0W5pH30q35gTy8igxJArc8L++x
         SxmQ==
X-Gm-Message-State: AOAM530mKuoSIFSeLcFGNRh4caCHpZUoGdRMQDUz4J9zlmLEsZ1D48Sx
        yxaxL9pRjkWK//5Q2tM3qHw=
X-Google-Smtp-Source: ABdhPJwjR27OfJbE/pql+zfKtI/OO3cRfF6IwUuSVgfVkOl7AXz9h0V8GBSql0Q39N+mSCwZYB/YXg==
X-Received: by 2002:a05:6402:2788:: with SMTP id b8mr34158903ede.244.1627479248296;
        Wed, 28 Jul 2021 06:34:08 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:34:07 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 70/87] trace-cmd dump: Add new argument --sections
Date:   Wed, 28 Jul 2021 16:32:33 +0300
Message-Id: <20210728133250.234140-71-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The new "trace-cmd dump --sections" argument walks through the sections
from a trace file version 7 and prints their headers. The logic does
not rely on the options, describing these sections. It could be useful
to dump broken or incomplete trace files.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-dump.c | 70 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 67 insertions(+), 3 deletions(-)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index 126f50c8..57132c52 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -686,7 +686,7 @@ static void dump_option_section(int fd, unsigned int size,
 	do_print(OPTIONS, "%lld\n", sec->offset);
 }
 
-static void dump_sections(int fd)
+static void dump_sections(int fd, int count)
 {
 	struct file_section *sec = sections;
 	unsigned short flags;
@@ -724,6 +724,7 @@ static void dump_sections(int fd)
 		uncompress_reset();
 		sec = sec->next;
 	}
+	do_print(SUMMARY|SECTIONS, "\t[%d sections]\n", count);
 }
 
 static int dump_options_read(int fd);
@@ -936,17 +937,76 @@ static void dump_v6_file(int fd)
 	dump_therest(fd);
 }
 
+static int walk_v7_sections(int fd)
+{
+	unsigned long long offset, soffset;
+	unsigned short fl;
+	char buf[DUMP_SIZE];
+	unsigned short id;
+	int size, csize, rsize;
+	int count = 0;
+
+	offset = lseek64(fd, 0, SEEK_CUR);
+	do {
+		soffset = lseek64(fd, 0, SEEK_CUR);
+		if (read_file_number(fd, &id, 2))
+			break;
+		if (id >= TRACECMD_OPTION_MAX)
+			die("Unknown section id %d", id);
+		if (read_file_string(fd, buf, DUMP_SIZE))
+			die("cannot read section description");
+		if (read_file_number(fd, &fl, 2))
+			die("cannot read section flags");
+		if (read_file_number(fd, &size, 4))
+			die("cannot read section size");
+		if (size <= 4)
+			die("Section %d (%s) is too small, %d bytes", id, buf, size);
+		count++;
+		if (fl & TRACECMD_SEC_FL_COMPRESS) {
+			if (id == TRACECMD_OPTION_BUFFER ||
+			    id == TRACECMD_OPTION_BUFFER_LAT) {
+				do_print(SECTIONS,
+					"\t[Section %2d @ %-16lld\t\"%s\", flags 0x%X, "
+					"%d compressed bytes]\n",
+					 id, soffset, buf, fl, size);
+			} else {
+				if (read_file_number(fd, &csize, 4))
+					die("cannot read section size");
+				if (read_file_number(fd, &rsize, 4))
+					die("cannot read section size");
+				do_print(SECTIONS, "\t[Section %2d @ %-16lld\t\"%s\", flags 0x%X, "
+					 "%d compressed, %d uncompressed]\n",
+					 id, soffset, buf, fl, csize, rsize);
+				size -= 8;
+			}
+		} else {
+			do_print(SECTIONS, "\t[Section %2d @ %-16lld\t\"%s\", flags 0x%X, %d bytes]\n",
+				 id, soffset, buf, fl, size);
+		}
+
+		if (lseek64(fd, size, SEEK_CUR) == (off_t)-1)
+			break;
+	} while (1);
+
+	if (lseek64(fd, offset, SEEK_SET) == (off_t)-1)
+		die("cannot restore the original file location");
+	return count;
+}
+
 static void dump_v7_file(int fd)
 {
 	long long offset;
+	int sections;
 
 	if (read_file_number(fd, &offset, 8))
 		die("cannot read offset of the first option section");
 
-	if (lseek64(fd, offset, SEEK_SET) == (off64_t)-1)
+	sections = walk_v7_sections(fd);
+
+	if (lseek64(fd, offset, SEEK_SET) == (off_t)-1)
 		die("cannot goto options offset %lld", offset);
 	dump_options(fd);
-	dump_sections(fd);
+	dump_sections(fd, sections);
 }
 
 static void free_sections(void)
@@ -987,6 +1047,7 @@ static void dump_file(const char *file)
 }
 
 enum {
+	OPT_sections	= 241,
 	OPT_verbose	= 242,
 	OPT_clock	= 243,
 	OPT_all		= 244,
@@ -1030,6 +1091,7 @@ void trace_dump(int argc, char **argv)
 			{"options", no_argument, NULL, OPT_options},
 			{"flyrecord", no_argument, NULL, OPT_flyrecord},
 			{"clock", no_argument, NULL, OPT_clock},
+			{"sections", no_argument, NULL, OPT_sections},
 			{"validate", no_argument, NULL, 'v'},
 			{"help", no_argument, NULL, '?'},
 			{"verbose", optional_argument, NULL, OPT_verbose},
@@ -1092,6 +1154,8 @@ void trace_dump(int argc, char **argv)
 		case OPT_verbose:
 			if (trace_set_verbose(optarg) < 0)
 				die("invalid verbose level %s", optarg);
+		case OPT_sections:
+			verbosity |= SECTIONS;
 			break;
 		default:
 			usage(argv);
-- 
2.31.1


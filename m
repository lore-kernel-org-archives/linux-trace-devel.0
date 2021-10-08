Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23012C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:27:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 002A160F35
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:27:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233346AbhJHE3L (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236409AbhJHE3J (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:29:09 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E63C061755
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:27:14 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id v18so31594869edc.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ouUPdX/PFfDz4Wyg9WnRuXzTY+cYqywgfcxBHCDWMBY=;
        b=XgRzZ6ysf3wj1ABKBwYL4VgxqlKT641fTPLcssj1v0ABclAe/zWGxg7d4Nsktcp452
         IS0MMZJMfswQ3QKnhJx4GxqFkD8Bbkpt3EiXaKyAsiHNA/0L7c+kS0FYMDEXl5ae14g1
         MnKH1dPdXPSsL8/o5VM6JJxKMPtJYUtqtfj0cI8cC4j6t7DWyBN/v9ATxVeAiEeJ9vVh
         z9a7OA2c8oSMoisaWwbei7REQNYA3zmkmAnIbhOOy3Ie7M+u+kZX2yB/TDzLtwRMd71I
         vsJATbfSNu98F+DoK/xarUJTTsiRxpaaRKOiHGxqAGbo88m+R5/6Rm9AQqvMoRBvXhYM
         p46w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ouUPdX/PFfDz4Wyg9WnRuXzTY+cYqywgfcxBHCDWMBY=;
        b=wBs2zCeckKa3gV1u1TASqfnZ4yxaCV7fyOR7VIxn1xuVpM58xwUZIvQdP+H6je53Jo
         ObJBPClSv++Y54n2MOrWeebVzaPDuqrwF0mp+xq04ssgy5ZCoNtyWnqjTbIf4BBgz4r3
         8EdVm/okBT4tIMW84F0vQlKfotwsrnQYzC2MTWMfB1s0ToSzxURoAW09aFv6kavM5S4l
         hDT1EzuwPl4FcjjpYULxTE4CqZuNjkTEHm7p/6hr5CPQ+MaY3YDyHoBY8CBB0AvxaQP0
         N5wk1/m78MJHvFsnHzZqtQBdbtgmNSAjv5YVeJCqJZvBRZarCJMGsluXF/zd5lMtClFi
         4UoA==
X-Gm-Message-State: AOAM5333EGQrqD2Kixzp93v0BIAlel+DHvIPMr7jaoeJKTHWxVi0jmoz
        PE3XzHQhxl88MUsQZJZ0cEqsSDumYy1eug==
X-Google-Smtp-Source: ABdhPJznKyjyPtUEfS9+9GywvgXbXWPEbmTc9ah6t0/5xNjRgcv2AKMYFSioe4SZ0DMUuzLwo8udLw==
X-Received: by 2002:a05:6402:7:: with SMTP id d7mr11960382edu.265.1633667233250;
        Thu, 07 Oct 2021 21:27:13 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q6sm456536ejm.106.2021.10.07.21.27.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:27:12 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 09/10] trace-cmd dump: Add new argument --sections
Date:   Fri,  8 Oct 2021 07:27:00 +0300
Message-Id: <20211008042701.979075-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008042701.979075-1-tz.stoyanov@gmail.com>
References: <20211008042701.979075-1-tz.stoyanov@gmail.com>
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
 tracecmd/trace-dump.c | 71 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 68 insertions(+), 3 deletions(-)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index c222cd66..ab2fa2e5 100644
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
@@ -937,17 +938,76 @@ static void dump_v6_file(int fd)
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
+			    id == TRACECMD_OPTION_BUFFER_TEXT) {
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
@@ -988,6 +1048,7 @@ static void dump_file(const char *file)
 }
 
 enum {
+	OPT_sections	= 241,
 	OPT_verbose	= 242,
 	OPT_clock	= 243,
 	OPT_all		= 244,
@@ -1031,6 +1092,7 @@ void trace_dump(int argc, char **argv)
 			{"options", no_argument, NULL, OPT_options},
 			{"flyrecord", no_argument, NULL, OPT_flyrecord},
 			{"clock", no_argument, NULL, OPT_clock},
+			{"sections", no_argument, NULL, OPT_sections},
 			{"validate", no_argument, NULL, 'v'},
 			{"help", no_argument, NULL, '?'},
 			{"verbose", optional_argument, NULL, OPT_verbose},
@@ -1094,6 +1156,9 @@ void trace_dump(int argc, char **argv)
 			if (trace_set_verbose(optarg) < 0)
 				die("invalid verbose level %s", optarg);
 			break;
+		case OPT_sections:
+			verbosity |= SECTIONS;
+			break;
 		default:
 			usage(argv);
 		}
-- 
2.31.1


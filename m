Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E813C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:29:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346833AbhLBMcn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:32:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346814AbhLBMcm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:32:42 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB36C06174A
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:29:19 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id l25so115169981eda.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:29:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YrVrPP534jX6fRrmD3ChIy6tMTByr1OJWLRo+Vo8E6A=;
        b=fouPx5iX9MezG25aQQ5KRt43zVS9AhRhLVTQ9KBnR2v9FuEmcw7ExE9IJJQY0XcG6/
         qO2tdUtGYYJ5AV21OCnaS3gupybXEtXpgsrnCOTyKFrH5LCghT91ixNV1C0MmeJTqhPz
         aY1KfHXxAzx5lE1QoqfIKyZGHCV+xE+OctExHNDarJRi4NcUNJQXyxd5WwJqTapRuwVw
         TkIV6Wzf3rEMcpdvbzssbZKlqw61xlf91Y4imgsLCrQfpv6+OLmD6/ePhwT4RaTOvSR3
         3Fw/NYnt84aOn3oZ8errHSVXfnyT7gAi+zV3+67gMHh2g1WV2M7aopziS2vH4LGIfAuX
         VqsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YrVrPP534jX6fRrmD3ChIy6tMTByr1OJWLRo+Vo8E6A=;
        b=XPO+wRnF32R+aH7LzTEhti+N9lo2XVUT3vc7KL8C0XBdYKJ2Ni4pOQj6pOMTYgq3DE
         ZYfzn9StMzk2xba9mHYv2D4reW7CMax8Ht9BAAgI/Y81gRqof5JVaB+Kh/7nqCVGdNvk
         m1jFDFkx49COk1cAW7T6L1pPch3tK6Vb+rNVaUsxbrZPACwpGLIaajFZcpX9/nBhDB4L
         95/0BvRGbFPqGhqejJ28Ey1Tjm9qpu15qh9+sJuFu1jPkfaEwLUBOFkyJVoZ9G/BIs5e
         VUSBm4UnVuZcQKMQm0HbCzYEBPFGvDlngP0FKwJ+1+bzbZt2rTHosZR7ITb4Cy9GXxzX
         /fSA==
X-Gm-Message-State: AOAM5336mQW9lVBO3WcMz9pW1Xz3lvK7sktYVl8hsYY4JbE1DaxSIGfz
        Vtj0Bq5BIxnMUTyL4z8Y2rst01t8s0DqKA==
X-Google-Smtp-Source: ABdhPJwvoxi119t5tyA6Oad94xNoGjzIa1ZYzzvv2WelYo8zitsMBH3BlXw4St07gHHxhbOYDTl5LA==
X-Received: by 2002:a50:950c:: with SMTP id u12mr17845415eda.361.1638448157694;
        Thu, 02 Dec 2021 04:29:17 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id m16sm2182692edd.61.2021.12.02.04.29.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:29:17 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 09/10] trace-cmd dump: Add new argument --sections
Date:   Thu,  2 Dec 2021 14:29:06 +0200
Message-Id: <20211202122907.44008-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122907.44008-1-tz.stoyanov@gmail.com>
References: <20211202122907.44008-1-tz.stoyanov@gmail.com>
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
index b2670744..8986f9b0 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -731,7 +731,7 @@ static void dump_option_section(int fd, unsigned int size,
 	do_print(OPTIONS, "%lld\n", sec->offset);
 }
 
-static void dump_sections(int fd)
+static void dump_sections(int fd, int count)
 {
 	struct file_section *sec = sections;
 	unsigned short flags;
@@ -769,6 +769,7 @@ static void dump_sections(int fd)
 		uncompress_reset();
 		sec = sec->next;
 	}
+	do_print(SUMMARY|SECTIONS, "\t[%d sections]\n", count);
 }
 
 static int dump_options_read(int fd);
@@ -982,17 +983,76 @@ static void dump_v6_file(int fd)
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
@@ -1033,6 +1093,7 @@ static void dump_file(const char *file)
 }
 
 enum {
+	OPT_sections	= 241,
 	OPT_verbose	= 242,
 	OPT_clock	= 243,
 	OPT_all		= 244,
@@ -1076,6 +1137,7 @@ void trace_dump(int argc, char **argv)
 			{"options", no_argument, NULL, OPT_options},
 			{"flyrecord", no_argument, NULL, OPT_flyrecord},
 			{"clock", no_argument, NULL, OPT_clock},
+			{"sections", no_argument, NULL, OPT_sections},
 			{"validate", no_argument, NULL, 'v'},
 			{"help", no_argument, NULL, '?'},
 			{"verbose", optional_argument, NULL, OPT_verbose},
@@ -1139,6 +1201,9 @@ void trace_dump(int argc, char **argv)
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
2.33.1


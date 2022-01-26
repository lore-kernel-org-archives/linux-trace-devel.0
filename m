Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02D76C63682
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 09:53:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239322AbiAZJx4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 04:53:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbiAZJx4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 04:53:56 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F42C06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:53:55 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id ah7so37537576ejc.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:53:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OIR+jEwVy6Y6Ra9hmuFm+M+zsZN6yh2Xm1VXibJKyVs=;
        b=JnrUIZL1D2wcjWxi30B5Dg/Fp/ugMxhdj7+bzorWkEg0w6QJtQ4FDgo33gll2li96e
         7mu1ss5xBXI9R/fuf3N5cULGXhRQJrDcVuW7e7aD08FsrCull08F8R8GH1SRXR8jDutl
         KXfxP/FhLrI+PpZmgMifDs1jK+yxiIr35XrBjKrJfy6Id/hTkn3rIkGVE6pSJBZnjJ5y
         SaOe2/fUeuiBCo8NAh9M5cOXYl80j+Cgg3FzUdGwCYCHEo31X/PVkIWRy4gpbZ+0Icg9
         Rl0SIfJxn0YaJOlEzmRBBskCnUX4xHD8ZvkSlEwXGIF7b4he2DVf8oIa/mIB6yrvlwI2
         KL0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OIR+jEwVy6Y6Ra9hmuFm+M+zsZN6yh2Xm1VXibJKyVs=;
        b=XkNP0hz/EORaXAVtcmsNa5JfMUlNSq+EnlVU0AtZFaYLGLs6cPhjiWRYQTw3Rp7zOE
         r5fJatPgPrzB5Gkkh+Yq2e+6UmjieZJtzxlqi5tXaRFFu48GoR4/htgneLN8OzgBYQlU
         1mHYid9aKw3qYLoVQRFAk2Jw9cO3nookS1kMWGYbADv4Xr41xfhQLIDdNBiIWCBg4GFb
         /t9JnsXSXde3SdeH2SZU7Jm4V3ZOnnwWatiA7tA1/NC7uufW3c6HbspmF0TGJJPwGCZX
         01qfp5sLDQvuXTDgEin/75YLVLqikztlpgZAbJ5j50mvlo/nlpkvoxQ0NWZTTXfJPAb7
         ukIg==
X-Gm-Message-State: AOAM532X6FDMx2rkCxlc5j59F+n7dM/xHYN46Gt1MZLeHwBjoYQcWfHp
        ZQAqzCjTx+cf0JgnNDyaxNHSO/n4ubY=
X-Google-Smtp-Source: ABdhPJz+78ve8ivj33pyNpvDkwa5+KoPe+g8yoytmeBCCfVpEfYgIXBOCOq/Bd596tdcEKAL2VSOOA==
X-Received: by 2002:a17:907:7f86:: with SMTP id qk6mr19322238ejc.631.1643190834188;
        Wed, 26 Jan 2022 01:53:54 -0800 (PST)
Received: from oberon.zico.biz ([151.251.254.11])
        by smtp.gmail.com with ESMTPSA id h19sm3177266edv.90.2022.01.26.01.53.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 01:53:53 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 10/11] trace-cmd dump: Add new argument --sections
Date:   Wed, 26 Jan 2022 11:53:36 +0200
Message-Id: <20220126095337.570867-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126095337.570867-1-tz.stoyanov@gmail.com>
References: <20220126095337.570867-1-tz.stoyanov@gmail.com>
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
 tracecmd/trace-dump.c | 81 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 78 insertions(+), 3 deletions(-)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index 19f77687..d6efa425 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -762,7 +762,7 @@ static void dump_option_section(int fd, unsigned int size,
 	do_print(OPTIONS, "\t\t[Option %s, %d bytes] @ %lld\n", desc, size, sec->offset);
 }
 
-static void dump_sections(int fd)
+static void dump_sections(int fd, int count)
 {
 	struct file_section *sec = sections;
 	unsigned short flags;
@@ -800,6 +800,7 @@ static void dump_sections(int fd)
 		uncompress_reset();
 		sec = sec->next;
 	}
+	do_print(SUMMARY|SECTIONS, "\t[%d sections]\n", count);
 }
 
 static int dump_options_read(int fd);
@@ -1086,20 +1087,89 @@ static void get_meta_strings(int fd)
 		die("cannot restore the original file location");
 }
 
+static int walk_v7_sections(int fd)
+{
+	unsigned long long offset, soffset, size;
+	unsigned short fl;
+	unsigned short id;
+	int csize, rsize;
+	int count = 0;
+	int desc_id;
+	const char *desc;
+
+	offset = lseek64(fd, 0, SEEK_CUR);
+	do {
+		soffset = lseek64(fd, 0, SEEK_CUR);
+		if (read_file_number(fd, &id, 2))
+			break;
+
+		if (read_file_number(fd, &fl, 2))
+			die("cannot read section flags");
+
+		if (read_file_number(fd, &desc_id, 4))
+			die("cannot read section description");
+
+		desc = get_metadata_string(desc_id);
+		if (!desc)
+			desc = "Unknown";
+
+		if (read_file_number(fd, &size, 8))
+			die("cannot read section size");
+
+		if (id >= TRACECMD_OPTION_MAX)
+			do_print(SECTIONS, "Unknown section id %d: %s", id, desc);
+
+		count++;
+		if (fl & TRACECMD_SEC_FL_COMPRESS) {
+			if (id == TRACECMD_OPTION_BUFFER ||
+			    id == TRACECMD_OPTION_BUFFER_TEXT) {
+				do_print(SECTIONS,
+					"\t[Section %2d @ %-16lld\t\"%s\", flags 0x%X, "
+					"%lld compressed bytes]\n",
+					 id, soffset, desc, fl, size);
+			} else {
+				if (read_file_number(fd, &csize, 4))
+					die("cannot read section size");
+
+				if (read_file_number(fd, &rsize, 4))
+					die("cannot read section size");
+
+				do_print(SECTIONS, "\t[Section %2d @ %-16lld\t\"%s\", flags 0x%X, "
+					 "%d compressed, %d uncompressed]\n",
+					 id, soffset, desc, fl, csize, rsize);
+				size -= 8;
+			}
+		} else {
+			do_print(SECTIONS, "\t[Section %2d @ %-16lld\t\"%s\", flags 0x%X, %lld bytes]\n",
+				 id, soffset, desc, fl, size);
+		}
+
+		if (lseek64(fd, size, SEEK_CUR) == (off_t)-1)
+			break;
+	} while (1);
+
+	if (lseek64(fd, offset, SEEK_SET) == (off_t)-1)
+		die("cannot restore the original file location");
+
+	return count;
+}
+
 static void dump_v7_file(int fd)
 {
 	long long offset;
+	int sections;
 
 	if (read_file_number(fd, &offset, 8))
 		die("cannot read offset of the first option section");
 
 	get_meta_strings(fd);
+	sections = walk_v7_sections(fd);
 
-	if (lseek64(fd, offset, SEEK_SET) == (off64_t)-1)
+	if (lseek64(fd, offset, SEEK_SET) == (off_t)-1)
 		die("cannot goto options offset %lld", offset);
 
 	dump_options(fd);
-	dump_sections(fd);
+	dump_sections(fd, sections);
 }
 
 static void free_sections(void)
@@ -1140,6 +1210,7 @@ static void dump_file(const char *file)
 }
 
 enum {
+	OPT_sections	= 240,
 	OPT_strings	= 241,
 	OPT_verbose	= 242,
 	OPT_clock	= 243,
@@ -1185,6 +1256,7 @@ void trace_dump(int argc, char **argv)
 			{"flyrecord", no_argument, NULL, OPT_flyrecord},
 			{"clock", no_argument, NULL, OPT_clock},
 			{"strings", no_argument, NULL, OPT_strings},
+			{"sections", no_argument, NULL, OPT_sections},
 			{"validate", no_argument, NULL, 'v'},
 			{"help", no_argument, NULL, '?'},
 			{"verbose", optional_argument, NULL, OPT_verbose},
@@ -1251,6 +1323,9 @@ void trace_dump(int argc, char **argv)
 		case OPT_strings:
 			verbosity |= STRINGS;
 			break;
+		case OPT_sections:
+			verbosity |= SECTIONS;
+			break;
 		default:
 			usage(argv);
 		}
-- 
2.34.1


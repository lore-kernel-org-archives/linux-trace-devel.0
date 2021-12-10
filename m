Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A89D7C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 11:05:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240382AbhLJLJD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 06:09:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240267AbhLJLI7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 06:08:59 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A84EC061A32
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:05:24 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id e3so29127175edu.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:05:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9Y3rklqxxMOq7gesFvsO7dFqIEA5fNeflDjZudTR5qY=;
        b=btVTZ+ERzOK4sRPXa7vILRTZE8x9aZ8NU4kUtwsIyigOVcFU00CtzJMmxdFn8O8STY
         pm5xOIZUHe76hqmuvTeLJfU+3xIPfkL81ZiFBUIkKpe7/61Mi569EuIVeKDhVxPs6btP
         bjplch4NQ5sLyboViMCFBU0z4twGqVA4MnblXxxKfIuApBucSOhiKkvzSh+gF26bTh7Y
         BkInW0QSHxC7xrb9dU26mpZAzikfdgdKr9IIJ9vLyjrQDVQwg2aIayl43JlcB1t+scsT
         QlQ98VPseQxp/S4zEqFtNLHotV7oTsqOjtRk0ik5mVW9M4ha9YzqMPyTbBoxCelRJijk
         Exgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9Y3rklqxxMOq7gesFvsO7dFqIEA5fNeflDjZudTR5qY=;
        b=LVfKuPpQ66vdZyyN6zJZdcMr9J/Uhn+Hf3kPgKIA719quJx+PePI/jgPvtfLcjvMwg
         4tz+bEfxo6tkYAo06dEv2xEAUZdoGthY6jWK2TqvYHBAUEMnQ1+zT6h73gNhBArnbJgp
         YdOnoeb8PMG1VdOO5KBuatZfHNmfy8XKPi5/ESTVnC+aInFT6g9BFzNW2AQJgQOkNSyG
         v7nsPr5OVhIAN+lM8b2fhZLcSCr0ahqiVWq4ZdGyYRH9siMANPAsov4Q7pFSs68PDdLa
         sDlQD3+2Uh+873394GNNxxqqatt766qcszV6pF6S3OVKdfpMmXh2L6OVpY/V2FtZyT45
         Y5vw==
X-Gm-Message-State: AOAM531i+3z/Vn5nnCw0FMnyfl9hi6cBGqH7fcvQO4mX31ppYqTaKcH0
        prUzVoGwj0GV1BmeKtdrrgyeDvl3P5g=
X-Google-Smtp-Source: ABdhPJzPaZRRaeBulv7IPnSEYxzx8EqRyJEsmT6NhVk5yjKhr5qQLDe407l3TV1Gyue4DW5g5SMydg==
X-Received: by 2002:a05:6402:5106:: with SMTP id m6mr37161527edd.191.1639134323221;
        Fri, 10 Dec 2021 03:05:23 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gs17sm1278887ejc.28.2021.12.10.03.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 03:05:22 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 10/11] trace-cmd dump: Add new argument --sections
Date:   Fri, 10 Dec 2021 13:05:10 +0200
Message-Id: <20211210110511.98856-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210110511.98856-1-tz.stoyanov@gmail.com>
References: <20211210110511.98856-1-tz.stoyanov@gmail.com>
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
 tracecmd/trace-dump.c | 72 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 69 insertions(+), 3 deletions(-)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index 3b2ba138..907ebc90 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -744,7 +744,7 @@ static void dump_option_section(int fd, unsigned int size,
 	do_print(OPTIONS, "\t\t[Option %s, %d bytes] @ %lld\n", desc, size, sec->offset);
 }
 
-static void dump_sections(int fd)
+static void dump_sections(int fd, int count)
 {
 	struct file_section *sec = sections;
 	unsigned short flags;
@@ -782,6 +782,7 @@ static void dump_sections(int fd)
 		uncompress_reset();
 		sec = sec->next;
 	}
+	do_print(SUMMARY|SECTIONS, "\t[%d sections]\n", count);
 }
 
 static int dump_options_read(int fd);
@@ -1065,19 +1066,79 @@ static void get_meta_strings(int fd)
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
+		if (read_file_number(fd, &desc_id, 4))
+			die("cannot read section description");
+		desc = get_metadata_string(desc_id);
+		if (!desc)
+			desc = "Uknown";
+		if (read_file_number(fd, &fl, 2))
+			die("cannot read section flags");
+		if (read_file_number(fd, &size, 8))
+			die("cannot read section size");
+		if (id >= TRACECMD_OPTION_MAX)
+			do_print(SECTIONS, "Unknown section id %d: %s", id, desc);
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
+				if (read_file_number(fd, &rsize, 4))
+					die("cannot read section size");
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
@@ -1118,6 +1179,7 @@ static void dump_file(const char *file)
 }
 
 enum {
+	OPT_sections	= 240,
 	OPT_strings	= 241,
 	OPT_verbose	= 242,
 	OPT_clock	= 243,
@@ -1163,6 +1225,7 @@ void trace_dump(int argc, char **argv)
 			{"flyrecord", no_argument, NULL, OPT_flyrecord},
 			{"clock", no_argument, NULL, OPT_clock},
 			{"strings", no_argument, NULL, OPT_strings},
+			{"sections", no_argument, NULL, OPT_sections},
 			{"validate", no_argument, NULL, 'v'},
 			{"help", no_argument, NULL, '?'},
 			{"verbose", optional_argument, NULL, OPT_verbose},
@@ -1229,6 +1292,9 @@ void trace_dump(int argc, char **argv)
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
2.33.1


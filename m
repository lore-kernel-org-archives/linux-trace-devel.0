Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 818B3C4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:30:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352488AbiASIae (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:30:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352486AbiASIad (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:30:33 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AEB2C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:30:33 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id j2so7575396edj.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:30:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ij35J1yQ/yW203B+uK70SAPMlWJUg8uswRuxK0rVHn0=;
        b=WXYVO4l3ThN4hHPcjI4dAXZVpxPbKEOgIMlwUtmDzKYT9r2yWuTZtjkKQbY0Wtdfg1
         hLpCD5Lubb622UI2kXjM/+yLJ9GASLkzx8mJZ1JZUmQiPbpOyCx88rgETnqgso6bI+n4
         PQil5lw9piIDJgh3M6F0rJzHq5DyCuPBwSkM+b6Yv5LQ7e3Th/R9ZogRtyZk38jv1lIZ
         7TvGMXlz5is0IngR11Xy1WDAvS+q/vf2MIERrhLuvLkixCZkAsuzUiY26vkrVF2lezRe
         53OKEo6tZXOi0j0RtmR+wwc9UvXY3SfkIXTSgDcl6Smv1bBWma4van1xBBNmxKVyxG6F
         iYVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ij35J1yQ/yW203B+uK70SAPMlWJUg8uswRuxK0rVHn0=;
        b=OnxpSzfsP1Ur19RZ/NNTpxm/PTSaYd6oV0k0K7Iv3QRSCjcZS1z0r616yqBbfG2yBI
         q2yUtDih1qHyqwsOmN0RFNrK9Vat3bJ2P6PMawNEtZfiV52Fg2wObb9LRgRN4gkhf7pO
         XKO9Y3L3TvcpyH0ySkQYEKf2flZuj8dMutn+qHqx6U87cjZ/VEdYNUPBsqRgN/SRwfwH
         nYoQdctDFDNdZhWubNeGajvqVeZFGFgxDOVTqash6UR/7Rk/mUfhMWlCLh/1EpkWui3i
         tWlYde9GSeqYLorixR9bbHgY5q1iTpkxCIBFhEZ4F+W3Qhq7ApMu6u9brK+cTjyrSffi
         27Ww==
X-Gm-Message-State: AOAM530MlI8d5o0luxnTwMUXhAb8VuogEksXwvl6KnVjzurtKELNupyb
        Ey1K8u5vdxLcKjha/3bg+F4pbML/EGM=
X-Google-Smtp-Source: ABdhPJwQu0W+mlOFYg0eW8ZK32hq0G1amLtbokLkWu4ptLI1ldCNdKX040qrWIFiPpPE1tbqwGhHRA==
X-Received: by 2002:aa7:cd69:: with SMTP id ca9mr27128562edb.16.1642581031741;
        Wed, 19 Jan 2022 00:30:31 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id la7sm6095530ejc.94.2022.01.19.00.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:30:31 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 10/11] trace-cmd dump: Add new argument --sections
Date:   Wed, 19 Jan 2022 10:30:18 +0200
Message-Id: <20220119083019.246153-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119083019.246153-1-tz.stoyanov@gmail.com>
References: <20220119083019.246153-1-tz.stoyanov@gmail.com>
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
index fd54ee5c..fd9008fd 100644
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
+		if (read_file_number(fd, &fl, 2))
+			die("cannot read section flags");
+		if (read_file_number(fd, &desc_id, 4))
+			die("cannot read section description");
+		desc = get_metadata_string(desc_id);
+		if (!desc)
+			desc = "Unknown";
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
2.34.1


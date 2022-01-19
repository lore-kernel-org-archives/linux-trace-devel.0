Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49848C43219
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:30:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352487AbiASIae (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:30:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352474AbiASIac (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:30:32 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4394AC06173E
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:30:31 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id j23so2488494edp.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:30:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J6L1X6h9L3q0sykVyHmdOdb9pnuOjtw0mZlPm2QARw4=;
        b=qEZIJfhC5etTRZey6YPyhK9UZDLwTYcHjRH4yyzjycVgoPxoo08G8FUMb9ndYP2Av2
         ObmLujYSzRbtwyrv5pzduC7eQ2W8Pu2ssUDyE4LL7Nb17Jlhi36njvGqHA8G5ZJGuoip
         T93fAHdqpBlfxJDxfjd34XjgBBgdd9N0tAW0wfyLhgQl4jno9L8mNLyGit+cj2Ql/Tb2
         HY9XBn4CjZaS41NzxUYqPbb4gAN+gG/EqpeLm+lXqV2dPhjVt5XzNAyja5lmsZ2b57KT
         QhzipZ30qIg307fvVw9g8wC3m9HNAvYQ4kU3Q1rTg9BSOEzgqizzpj4IqgMWaJpDEfbb
         eXhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J6L1X6h9L3q0sykVyHmdOdb9pnuOjtw0mZlPm2QARw4=;
        b=651KGNbQBJPdA8cObaAcUEcHUdlpHqpAqeQ0jXqaD1YCA1/ELdxRB6cVQVel5397Ky
         vsLuZuiA8dM25IpYxV5W0+E6Rdy/zR+T5o/5HjX88hXwp3AI5mq/BodIJmLJ4rvjEaM5
         qheZ9lZe3L60j03NixEV5M57jpt/adTjkiaGEizuijkq5/fyWLukMgVfRzFIM8E76kur
         OzNkIDGXvTiJ7NbfpTwzmYlxGYS9/46ZF/IwdZF2tFI74H9lw9HCynsXC9R2hWwOi3w4
         qqgvb1ZpmnpzorGE8voCEyuVcSLtKwWOCw6hiTG3ScrHdMhECT+xGLqU9APahGP81BqN
         U+fQ==
X-Gm-Message-State: AOAM531VWRJvQBcC96pYJUl1iJTCGrC07NQm4Va2Rn5My9ySbw5WLGiD
        WC1CfcnQZHs/gCWoRmhtaG4s0hRW09I=
X-Google-Smtp-Source: ABdhPJwfmuTsvO5Nas+19zD9CkKOVnOdZYowket6xtYNFh6AH1TfvclOcUi/JEpwkpBHw79urkPtZQ==
X-Received: by 2002:a17:906:af8b:: with SMTP id mj11mr1549025ejb.66.1642581029258;
        Wed, 19 Jan 2022 00:30:29 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id la7sm6095530ejc.94.2022.01.19.00.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:30:28 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 08/11] trace-cmd dump: Read strings sections from v7 trace files
Date:   Wed, 19 Jan 2022 10:30:16 +0200
Message-Id: <20220119083019.246153-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119083019.246153-1-tz.stoyanov@gmail.com>
References: <20220119083019.246153-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Trace file v7 has sections with metadata strings. When such file is
opened with "trace-cmd dump", read that section and store the strings in
an internal database. Also, a new argument "--strings" is added to
"trace-cmd dump", to display all strings sections from the file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-dump.c | 93 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 91 insertions(+), 2 deletions(-)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index cbf94206..a765d1cc 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -29,6 +29,8 @@ static int has_clock;
 static unsigned long file_version;
 static bool	read_compress;
 static struct tracecmd_compression *compress;
+static char *meta_strings;
+static int meta_strings_size;
 
 enum dump_items {
 	SUMMARY		= (1 << 0),
@@ -44,6 +46,7 @@ enum dump_items {
 	FLYRECORD	= (1 << 10),
 	CLOCK		= (1 << 11),
 	SECTIONS	= (1 << 12),
+	STRINGS		= (1 << 13),
 };
 
 struct file_section {
@@ -177,6 +180,14 @@ static int read_file_number(int fd, void *digit, int size)
 	return 0;
 }
 
+static const char *get_metadata_string(int offset)
+{
+	if (!meta_strings || offset < 0 || meta_strings_size <= offset)
+		return NULL;
+
+	return meta_strings + offset;
+}
+
 static void dump_initial_format(int fd)
 {
 	char magic[] = TRACECMD_MAGIC;
@@ -427,6 +438,7 @@ static void dump_section_header(int fd, enum dump_items v, unsigned short *flags
 	unsigned long long offset, size;
 	unsigned short fl;
 	unsigned short id;
+	const char *desc;
 	int desc_id;
 
 	offset = lseek64(fd, 0, SEEK_CUR);
@@ -436,10 +448,13 @@ static void dump_section_header(int fd, enum dump_items v, unsigned short *flags
 		die("cannot read the section flags");
 	if (read_file_number(fd, &desc_id, 4))
 		die("no section description");
+	desc = get_metadata_string(desc_id);
+	if (!desc)
+		desc = "Unknown";
 	if (read_file_number(fd, &size, 8))
 		die("cannot read section size");
-	do_print(v, "\t[Section %d @ %lld, flags 0x%X, %lld bytes]\n",
-		 id, offset, fl, size);
+	do_print(v, "\t[Section %d @ %lld: \"%s\", flags 0x%X, %lld bytes]\n",
+		 id, offset, desc, fl, size);
 
 	if (flags)
 		*flags = fl;
@@ -943,6 +958,73 @@ static void dump_v6_file(int fd)
 	dump_therest(fd);
 }
 
+static int read_metadata_strings(int fd, unsigned long long size)
+{
+	char *str, *strings;
+	int psize;
+	int ret;
+
+	strings = realloc(meta_strings, meta_strings_size + size);
+	if (!strings)
+		return -1;
+	meta_strings = strings;
+
+	ret = read_file_bytes(fd, meta_strings + meta_strings_size, size);
+	if (ret < 0)
+		return -1;
+
+	do_print(STRINGS, "\t[String @ offset]\n");
+	psize = 0;
+	while (psize < size) {
+		str = meta_strings + meta_strings_size + psize;
+		do_print(STRINGS, "\t\t\"%s\" @ %d\n", str, meta_strings_size + psize);
+		psize += strlen(str) + 1;
+	}
+
+	meta_strings_size += size;
+
+	return 0;
+}
+
+static void get_meta_strings(int fd)
+{
+	unsigned long long offset, size;
+	unsigned int csize, rsize;
+	unsigned short fl, id;
+	int desc_id;
+
+	offset = lseek64(fd, 0, SEEK_CUR);
+	do {
+		if (read_file_number(fd, &id, 2))
+			break;
+		if (read_file_number(fd, &fl, 2))
+			die("cannot read section flags");
+		if (read_file_number(fd, &desc_id, 4))
+			die("cannot read section description");
+		if (read_file_number(fd, &size, 8))
+			die("cannot read section size");
+		if (id == TRACECMD_OPTION_STRINGS) {
+			if ((fl & TRACECMD_SEC_FL_COMPRESS)) {
+				read_file_number(fd, &csize, 4);
+				read_file_number(fd, &rsize, 4);
+				lseek64(fd, -8, SEEK_CUR);
+				if (uncompress_block())
+					break;
+			} else {
+				rsize = size;
+			}
+			read_metadata_strings(fd, rsize);
+			uncompress_reset();
+		} else {
+			if (lseek64(fd, size, SEEK_CUR) == (off_t)-1)
+				break;
+		}
+	} while (1);
+
+	if (lseek64(fd, offset, SEEK_SET) == (off_t)-1)
+		die("cannot restore the original file location");
+}
+
 static void dump_v7_file(int fd)
 {
 	long long offset;
@@ -950,6 +1032,8 @@ static void dump_v7_file(int fd)
 	if (read_file_number(fd, &offset, 8))
 		die("cannot read offset of the first option section");
 
+	get_meta_strings(fd);
+
 	if (lseek64(fd, offset, SEEK_SET) == (off64_t)-1)
 		die("cannot goto options offset %lld", offset);
 	dump_options(fd);
@@ -993,6 +1077,7 @@ static void dump_file(const char *file)
 }
 
 enum {
+	OPT_strings	= 241,
 	OPT_verbose	= 242,
 	OPT_clock	= 243,
 	OPT_all		= 244,
@@ -1036,6 +1121,7 @@ void trace_dump(int argc, char **argv)
 			{"options", no_argument, NULL, OPT_options},
 			{"flyrecord", no_argument, NULL, OPT_flyrecord},
 			{"clock", no_argument, NULL, OPT_clock},
+			{"strings", no_argument, NULL, OPT_strings},
 			{"validate", no_argument, NULL, 'v'},
 			{"help", no_argument, NULL, '?'},
 			{"verbose", optional_argument, NULL, OPT_verbose},
@@ -1099,6 +1185,9 @@ void trace_dump(int argc, char **argv)
 			if (trace_set_verbose(optarg) < 0)
 				die("invalid verbose level %s", optarg);
 			break;
+		case OPT_strings:
+			verbosity |= STRINGS;
+			break;
 		default:
 			usage(argv);
 		}
-- 
2.34.1


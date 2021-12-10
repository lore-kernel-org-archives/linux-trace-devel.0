Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80E78C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 11:05:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240353AbhLJLJB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 06:09:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240301AbhLJLI5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 06:08:57 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8497C0617A2
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:05:22 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id g14so28021751edb.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:05:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1pZfRn7VIhOLMNi4GJTD7rcBdqN8ePzWIVTbxc3bKvM=;
        b=lsHo7YT/3z6s+MOVvrQiFHaKYxy+7DUSNF9/emQWwS/98XmdRfUDAOUYqMWTzQE8JI
         QPBZNmkdXj3NOKV/2RUCSzbn7W9sUwwwwmpvCJEKMhO7fxt1gLGh9fvXf0PhdaCPaX08
         Y6O4+7Y+z7OLGkOMXUCr47yCR/pGH2Ah3l9bz4yJ/oN7cDg6wvQ9jYSFD8f+KQpvC3Wk
         ewFkAySXjsa0t/KHz3e4cJL/6YWuzJ3oH8Tm65ZeNHBFmkOV0aZexIwUYxoDc8cF6kpe
         4Ee+byUPYYCaU5lHdrmAjSpLpUwZEHElZNWf4giymzgMjP/+9GjMBy4wePYD6GtBe4Qa
         Ar3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1pZfRn7VIhOLMNi4GJTD7rcBdqN8ePzWIVTbxc3bKvM=;
        b=M6xtY5nooJK06ym69TQqECY/IhlxWnuT2UZGC2W0ZSWrpL5nl8F4IUtrpPOwGghfFg
         MFwcxe+u6f39S/B6gx4gNRF7d7VGoTVM2RHxGO9mNeWj32h/JuyH8txr/PVnVjChHjyP
         sw/PZBmUBhJlMmclMAFic/MFIM943jdlfJGW7QGHCnkkWXlj/ntjNeM/S5KcOmojOY/9
         PzBlzAdclp9hUYaZI0QQTvtMsbWBJedrsZP2Gv3wHrm3FDgOpJzx7MB3Bvz+2h5K4ksH
         OoELeX0YtcymzYQggGILtO3rQnDZGhPMYKNqz2nj8O5hZ78IFwarIqNlDy8NID7kXvHq
         gR9Q==
X-Gm-Message-State: AOAM531543twlYf08IYdY90gMOFwA/KbSbYPDSzJ37zHvAjuqA815Wv/
        yr9itiAHRTnnTubEfj9PQifDk7NyknU=
X-Google-Smtp-Source: ABdhPJwCrLT5OFJgCI5IvH5kXLEPDnCPM8kDO7mzVDR4tgY8hbSgMehWSD606JCf+EXwreXSWY3f0w==
X-Received: by 2002:aa7:d445:: with SMTP id q5mr37297388edr.330.1639134321308;
        Fri, 10 Dec 2021 03:05:21 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gs17sm1278887ejc.28.2021.12.10.03.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 03:05:20 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 08/11] trace-cmd dump: Read strings sections from v7 trace files
Date:   Fri, 10 Dec 2021 13:05:08 +0200
Message-Id: <20211210110511.98856-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210110511.98856-1-tz.stoyanov@gmail.com>
References: <20211210110511.98856-1-tz.stoyanov@gmail.com>
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
index 1ccdec22..4504645c 100644
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
@@ -434,12 +446,15 @@ static void dump_section_header(int fd, enum dump_items v, unsigned short *flags
 		die("cannot read the section id");
 	if (read_file_number(fd, &desc_id, 4))
 		die("no section description");
+	desc = get_metadata_string(desc_id);
+	if (!desc)
+		desc = "Uknown";
 	if (read_file_number(fd, &fl, 2))
 		die("cannot read the section flags");
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
+		if (read_file_number(fd, &desc_id, 4))
+			die("cannot read section description");
+		if (read_file_number(fd, &fl, 2))
+			die("cannot read section flags");
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
2.33.1


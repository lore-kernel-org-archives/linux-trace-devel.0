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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 658E9C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:50:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5141761029
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:50:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235776AbhIMMwH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234945AbhIMMwG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:52:06 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06DD3C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:50:51 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id m9so14541442wrb.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ouUPdX/PFfDz4Wyg9WnRuXzTY+cYqywgfcxBHCDWMBY=;
        b=JjDdfN+9Qqr03YbmKx1DxwnHWC2qDl+ev+4wpUgPTT8PDJE/KYByc3LnDUW94Mmzy3
         oKO2OPiTDbj5IwW4bwWDUkoxALA3E+FgvW3A7yiSldG/3YktJ2Os1pIjTH7m099yn8Yc
         hzMSEtXpNbzZH26lq3ijY0ZQIOjwXEWXvc4kc1gH/vCgtC25zIXMRNTHBFBNZUE259FM
         nvYDYFv0XijTHGnSxIDIPz25j5m9VJk5IqvRtbSe4fpDD9NY8ir3zIiyUn9XDczrTUL6
         JoQfbg4nDhOo+8jzABIpF6vPOl7E1+h+BzID6vIamgXybEhStrVzM7bJStDoMGO0om7a
         MjbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ouUPdX/PFfDz4Wyg9WnRuXzTY+cYqywgfcxBHCDWMBY=;
        b=ce/o/1CGQNKx0FPph8LknRuUhQuTpGhFuiVbDsIIttTdVIeUACWjTA1rQSUbSRB2z8
         hht2T8YdVqK1VcO+OGDUi/QR0jM+WnKq3BqSSGIhKLpRNRKVO5IKcnAi4/VWEQ+wJayO
         Di2twOmQgPHpKAVvH2vlZ2J6iTFXkG0rg1NpsmCSA5zZbibgNg52Uo5DdpzoUGowIlrw
         ko34jRhcodBieCNHMOLQeeYxYOtAQzIF2XheY/FnYVLEg2EYSHqz1YD6Q5jKBAjtq8J2
         LUCtiZ2+QmBly2X3IG11a7y6lAyY+GBeuj/sHUYs++1fwB6yscJGpFmLS1FwM491yy/E
         P81w==
X-Gm-Message-State: AOAM531EaElo4JFe96EUxwKpYztqAK6LcAVcxJNop6HGXte/5NBqggS/
        C1ZHw2LVOY5S6VieuXi0/khdrRUFG7E=
X-Google-Smtp-Source: ABdhPJwo+GzpGBoNFIBVBva/fZh1lR8IyLpX6Jy6Fk6tfZi7VAZZ0bshk2w3QXeVlcbkIHJAW+a4wA==
X-Received: by 2002:a5d:56c4:: with SMTP id m4mr12525866wrw.225.1631537449616;
        Mon, 13 Sep 2021 05:50:49 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u27sm7756448wru.2.2021.09.13.05.50.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:50:49 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 09/10] trace-cmd dump: Add new argument --sections
Date:   Mon, 13 Sep 2021 15:50:38 +0300
Message-Id: <20210913125039.3680986-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913125039.3680986-1-tz.stoyanov@gmail.com>
References: <20210913125039.3680986-1-tz.stoyanov@gmail.com>
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


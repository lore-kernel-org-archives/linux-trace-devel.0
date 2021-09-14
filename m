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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6051C433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:21:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 917A4610A6
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:21:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233166AbhINNXP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233079AbhINNXO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:23:14 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70F2FC061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:21:57 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id t6so18463357edi.9
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w07ei+vuellAhsrpRQKM7ECaOSyrjL1xjJLvVhkLfpg=;
        b=B36t3CYQ7ybtV/cb/cfPr25D4audCWy56hxu2l63h011B+B/KmCvELItN1lisvDQjX
         foS6XJZlw+SHkjwHaaQEyyE10qc1DfpfC7rMOfLtlXwenouXpHamucwkz45dda/VBfaG
         d6fmiMb5UX8GeIkfEcnG65v8ZTTyVl+NErpg5jZXdc0h4/Qf1zSVXhB+2qscVYHkw0I1
         pt1UsANTslOS+pppdsOrcRuc2huorkP085o32aaxj3PIM+OeULKseazJUKqPMUyTHfTJ
         izdVBlQjvk4NmqTZl4ZDsGuax4WkiJD6y5vx41HUou/VzMovg4oZiF99dNxL+r3Pkez1
         0zwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w07ei+vuellAhsrpRQKM7ECaOSyrjL1xjJLvVhkLfpg=;
        b=HJXNPLbfhIk9wVAjc+kiNA/c63ag4/8B8wTbnjgmnkDNC+wJ/xXGhZMm0txr4vm51d
         Hw7izGHLPVicb9nz4O7atVPLOqajGufYQENOpOIVfLe70ddNcoXg2FWY+//0GtdPVF88
         b9IU74J0kF1YZsAIshrSQLVIZSKuv4X+dXnWG/Ed/JBVSU4szEVc8ZjxRxm3Pbi+o99D
         q3Gwl4KoLW8lB3JTD+v6DKqByyhph1PpcroRiuIDmFxhUEdwgDIq343isBlL0+OaEdrZ
         cmV89/UveCRg/D5I8c2UlJ1ILa/dQVDKR/vvzsrjJ+Q6d2EBkqLEsZzsbgfrF0aZYCYn
         uCPQ==
X-Gm-Message-State: AOAM530t3g5ZJQmze7k0WGmfTfUWzTB0KatbE9pRlg7eWffakrhgwQta
        CSpfhiZG/aoAn6ITEu9x1eSOCTcUOGg=
X-Google-Smtp-Source: ABdhPJzbQj/5dgYOTWnNxeUkSsnIeXU0KSXPd9RoCZJ8FIk6f05bC/6kaV+2yExAX3wIg8KhxKkDTQ==
X-Received: by 2002:a50:aa9c:: with SMTP id q28mr18979677edc.199.1631625716103;
        Tue, 14 Sep 2021 06:21:56 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l7sm5708431edb.26.2021.09.14.06.21.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:21:55 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 06/10] trace-cmd dump: Dump sections
Date:   Tue, 14 Sep 2021 16:21:44 +0300
Message-Id: <20210914132148.3968401-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914132148.3968401-1-tz.stoyanov@gmail.com>
References: <20210914132148.3968401-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In trace file version 7, headers are stored as sections. This allows
their position in the file not to be fixed. Pointers to these sections are
stored as trace options. Add logic to handle these new options:
 HEADER_INFO
 FTRACE_EVENTS
 EVENT_FORMATS
 KALLSYM
 PRINTK
 CMDLINES

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-dump.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index c44870c4..3394847c 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -668,6 +668,24 @@ void dump_option_tsc2nsec(int fd, int size)
 	do_print(OPTIONS, "%d %d %llu [multiplier, shift, offset]\n", mult, shift, offset);
 }
 
+static void dump_option_section(int fd, unsigned int size,
+				unsigned short id, char *desc, enum dump_items v)
+{
+	struct file_section *sec;
+
+	sec = calloc(1, sizeof(struct file_section));
+	if (!sec)
+		die("cannot allocate new section");
+	sec->next = sections;
+	sections = sec;
+	sec->id = id;
+	sec->verbosity = v;
+	if (read_file_number(fd, &sec->offset, 8))
+		die("cannot read the option %d offset", id);
+	do_print(OPTIONS, "\t\t[Option %s, %d bytes]\n", desc, size);
+	do_print(OPTIONS, "%lld\n", sec->offset);
+}
+
 static int dump_options_read(int fd);
 
 static int dump_option_done(int fd, int size)
@@ -756,6 +774,25 @@ static int dump_options_read(int fd)
 		case TRACECMD_OPTION_TSC2NSEC:
 			dump_option_tsc2nsec(fd, size);
 			break;
+		case TRACECMD_OPTION_HEADER_INFO:
+			dump_option_section(fd, size, option, "HEADERS", HEAD_PAGE | HEAD_EVENT);
+			break;
+		case TRACECMD_OPTION_FTRACE_EVENTS:
+			dump_option_section(fd, size, option, "FTRACE EVENTS", FTRACE_FORMAT);
+			break;
+		case TRACECMD_OPTION_EVENT_FORMATS:
+			dump_option_section(fd, size, option,
+					    "EVENT FORMATS", EVENT_SYSTEMS | EVENT_FORMAT);
+			break;
+		case TRACECMD_OPTION_KALLSYMS:
+			dump_option_section(fd, size, option, "KALLSYMS", KALLSYMS);
+			break;
+		case TRACECMD_OPTION_PRINTK:
+			dump_option_section(fd, size, option, "PRINTK", TRACE_PRINTK);
+			break;
+		case TRACECMD_OPTION_CMDLINES:
+			dump_option_section(fd, size, option, "CMDLINES", CMDLINES);
+			break;
 		case TRACECMD_OPTION_DONE:
 			uncompress_reset();
 			count += dump_option_done(fd, size);
-- 
2.31.1


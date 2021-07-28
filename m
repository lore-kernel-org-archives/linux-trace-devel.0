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
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3790C4338F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:34:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE1ED60FED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:34:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236782AbhG1NeM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236711AbhG1NeK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:34:10 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE39C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:34:08 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id b7so3276372edu.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a4leua4W8aVjmJfOTxppgjyQpV2acDWrH/UL1t1mhqU=;
        b=skCRE+a5DAkhAWSJfizDf+dcJJJziuFRqWm/MMsThEsQZ3SXlaym9vzcySksEbcpEN
         FYWeHY/qbEG8kONnTS+okdUWa7hfjRDgdKmFhSAnMZLeoZ96g5DbyrPHGwFCsJr8hT5U
         YIl7kNsUBlAOqjJoKxpe9iRl0zEmA4qQdH4x534I4kIJZ9lVZ9o+6KX3KH3fQmqeTq9o
         efeU7Jg8wS+ANQSlbyXFWOURGoxM8oaAuDJo6030+pYMCH49j8JKsbR7DsIyoMzYNN30
         Y3HOIdiwGlqACcUGWfmAgFoKwIsGC5donAMWR+8kaORQrPjk1icI4KWGFpbkKrNHkS9b
         14qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a4leua4W8aVjmJfOTxppgjyQpV2acDWrH/UL1t1mhqU=;
        b=p4Fa2o8a+9DUKIMrdKnk9awU3Tip1s5Oig6lOibt8vK86Kh5sgj7oMGJJE2Z8u2fhY
         RIU+VkhQZ6rUn2z/Gx7PGBYdjFLhyEEJBfmwhmV78KSh89iMSa0V9cs15qbXST6+EZFB
         KNUd8QV/KAAC+OgtKCqtD3mjL1c+JQF5ISxu67lOQ6PFX/pTbO5pH7Cfpgm6q+scuyB0
         d/B4PPZYODTbqhai02NK9nNDW5DYEC3Ost7Rqi8IOZ4smOiPojLo5u57AueqtG7vZh/Y
         oaIqIoW5BebA73tE1P5usyAggxR12ugmbFaUfzKNm4QoCKqLxrL/qLLPvSmFsQIm5Qxv
         iHKw==
X-Gm-Message-State: AOAM533BrEBNStccDC2JQINHv9GmiKUslFdSkm2aCAc3NGnVIKygq8Jy
        W7GKJuWEgeTeTzeXn76OinQ=
X-Google-Smtp-Source: ABdhPJx/wHef3xJl7D1lKTSaIuBAHSr5R/UfpCeokt7K9DnetIfwNE9w4TkAU2aVBz4FrR7fvn3X5g==
X-Received: by 2002:a05:6402:d68:: with SMTP id ec40mr14735733edb.344.1627479247374;
        Wed, 28 Jul 2021 06:34:07 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.34.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:34:06 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 69/87] trace-cmd dump: Dump sections content
Date:   Wed, 28 Jul 2021 16:32:32 +0300
Message-Id: <20210728133250.234140-70-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In trace file version 7, dump the content of the headers content, that
are stored as sections. Added logic to dump these headers:
 HEADER_INFO
 FTRACE_EVENTS
 EVENT_FORMATS
 KALLSYM
 PRINTK
 CMDLINES

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-dump.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index 99dc0ea4..126f50c8 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -686,6 +686,46 @@ static void dump_option_section(int fd, unsigned int size,
 	do_print(OPTIONS, "%lld\n", sec->offset);
 }
 
+static void dump_sections(int fd)
+{
+	struct file_section *sec = sections;
+	unsigned short flags;
+
+	while (sec) {
+		if (lseek64(fd, sec->offset, SEEK_SET) == (off_t)-1)
+			die("cannot goto option offset %lld", sec->offset);
+
+		dump_section_header(fd, sec->verbosity, &flags);
+
+		if ((flags & TRACECMD_SEC_FL_COMPRESS) && uncompress_block())
+			die("cannot uncompress section block");
+
+		switch (sec->id) {
+		case TRACECMD_OPTION_HEADER_INFO:
+			dump_header_page(fd);
+			dump_header_event(fd);
+			break;
+		case TRACECMD_OPTION_FTRACE_EVENTS:
+			dump_ftrace_events_format(fd);
+			break;
+		case TRACECMD_OPTION_EVENT_FORMATS:
+			dump_events_format(fd);
+			break;
+		case TRACECMD_OPTION_KALLSYMS:
+			dump_kallsyms(fd);
+			break;
+		case TRACECMD_OPTION_PRINTK:
+			dump_printk(fd);
+			break;
+		case TRACECMD_OPTION_CMDLINES:
+			dump_cmdlines(fd);
+			break;
+		}
+		uncompress_reset();
+		sec = sec->next;
+	}
+}
+
 static int dump_options_read(int fd);
 
 static int dump_option_done(int fd, int size)
@@ -906,6 +946,7 @@ static void dump_v7_file(int fd)
 	if (lseek64(fd, offset, SEEK_SET) == (off64_t)-1)
 		die("cannot goto options offset %lld", offset);
 	dump_options(fd);
+	dump_sections(fd);
 }
 
 static void free_sections(void)
-- 
2.31.1


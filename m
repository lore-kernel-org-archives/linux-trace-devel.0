Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5C9BC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:13:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B12BC610D0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:13:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234033AbhKKPPz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:15:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234036AbhKKPPx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:15:53 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD64C0613F5
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:13:04 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id j21so25231521edt.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:13:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5tO/vriOUpiSa2W8k4G1fuBKcjRtAbnryAqq55gN4qY=;
        b=AOQ5FmBYbeVYjvH07Sd5Q/afh1vQQab45AtkaH/Re7pQ468Ng5bHzhM6DyZWntef4q
         AxnIU4bI8vCeAJJCBTOwau3yJ9AeUtid0C69vfQF/nTfmofgfiP/tOGVA3nAxvqRGpFc
         /gM+j7hrkysCOyecZHQ04EMp2nAjglST4bVv8bqUHrTQx5OYXHIB2mCIkm7lIlq0epym
         09MqS2zycLCxaqOBdQQVDQhqz3ZLhVYSjLRX3em+MHMiAZKbhXVyB+fLCJY8z/hno4iC
         4jwUxLZwITZawiXRrMPlCXzFP705+1+6Birluob2Vq5LYVH6TBSO4lp5Bp32oUM5Mcjy
         w4xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5tO/vriOUpiSa2W8k4G1fuBKcjRtAbnryAqq55gN4qY=;
        b=tE+H1E5IRxShRiYATF3kOdifCgvdB1+vg05wQyzN1c6HgWOkL80yISz9BKgqGhMvuw
         GLwFcs9n+31PsTF7szrbBkMhxPA9Bo/69xP9ENPLJYQm1vNQi6H6OZ+uZR8Ras6DsBJA
         L7E5rFP4Rh0QwhLbtsUkuOvYHopX4cXZsnzariVD8TgQ+sF/iWmACJxd3V5Dfws373GT
         dlF3IDsYy32QF5tIK+ClPCkHbl3OsG1E1qXzcw/KKwhHIv35cwrbOqpNw/91u894h++9
         P8cHr7Jes4TAjmt8fV0irPT6mMLMIYgYlgMP1nQMWu2zhPQUQg+ILQxa3vEB1fLwWv5/
         RN2g==
X-Gm-Message-State: AOAM532fnCsPn68wwtkkzy1GG9rkR9uH/OJmVo8TCjQ1RtGJyxittDtF
        iyeZsisgXIgU/9eSj5ELVrtN7wCYZ5iQyQ==
X-Google-Smtp-Source: ABdhPJzhpo6aiPRIukvIYf3bq4rBrjnOTEpcwG0gyBw/z0ys7+KXvb6ROxGuKfAKonnAJJ0K7KuQXQ==
X-Received: by 2002:a17:907:1b16:: with SMTP id mp22mr10105954ejc.487.1636643582405;
        Thu, 11 Nov 2021 07:13:02 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q2sm1443375eje.118.2021.11.11.07.13.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:13:01 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 08/10] trace-cmd dump: Dump sections content
Date:   Thu, 11 Nov 2021 17:12:48 +0200
Message-Id: <20211111151250.87023-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111151250.87023-1-tz.stoyanov@gmail.com>
References: <20211111151250.87023-1-tz.stoyanov@gmail.com>
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
index 11a6e1df..b2670744 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -731,6 +731,46 @@ static void dump_option_section(int fd, unsigned int size,
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
@@ -952,6 +992,7 @@ static void dump_v7_file(int fd)
 	if (lseek64(fd, offset, SEEK_SET) == (off64_t)-1)
 		die("cannot goto options offset %lld", offset);
 	dump_options(fd);
+	dump_sections(fd);
 }
 
 static void free_sections(void)
-- 
2.33.1


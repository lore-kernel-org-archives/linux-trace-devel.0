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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E492C432BE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E47A36023E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234108AbhG2FLM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234112AbhG2FLM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:11:12 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701D6C061765
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:11:09 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id gn26so8489208ejc.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TVer/DT+huronqlCp2uYINmtsbXFUc4Q94qjFRQGwgc=;
        b=M9p2aSvzFjz7AgVViRgHd15hZqVllAIRBUSENR8gHltTR0P750Knjpai1KceW3jsiQ
         Eoj0hNAoo5Ct892RqETqHeCExkT2/aJ7TRhpoD3kjBMAAVMnpVkI1MVns38ywc+PTgT/
         78OkLabU+yoiXiLI5+3ij/EObIDFWEwUcCN0Ly9wLigBBWBU7HPOCFGFvN8yThr1WIUT
         IsU34hCGY9DaFWVR8Rutyw5dA0yW1S0wYovSK3efspLcNzmZDO+mSFN3tXrZAGrf3rGe
         1rqSjypoGCBV01D9kRTZdcJ0Q/a9zhQRZ7+lajuUdBY7N2Ap40B7lJ+hoAAV+3V1rHZZ
         qCZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TVer/DT+huronqlCp2uYINmtsbXFUc4Q94qjFRQGwgc=;
        b=jjdq2pN0tPJXHWGwukthkV5iitNwu1qMqnY1sVs92ApX4GXqC411P/0nYL+AAYypR1
         A06993YgTXttd5YwNGFz3JDbWnr2M2wSlqE42nsVOUOf/wju9DDEGbv0JsXLL9aa3MNt
         Tpz8h01gknihFW+V/lusvK7bYE9c4tWC6liGLLRl9Gt3PkI8pVu/4Jg5HwDKgYLg1aXu
         p2PHGW4r7aKSpO6+M7U9I2sWYaqgbTUHRzVbzcXOHtgoi+42X2dL33o1kdk6jphmUzem
         jES0u0fwknVWJGhpYIgjCxOg8Ole2vI5MXkAsoTZ/ftjgzBc1q/zmy+TLCN0r/Znp5T/
         pmgQ==
X-Gm-Message-State: AOAM532wyhNcYGmJdd0yiB7FQsyKSTiALkbtWUcHNKCMHutJAImZdR5f
        UbQjG5P2KV6tWocRajAl40orffkSrrPyxA==
X-Google-Smtp-Source: ABdhPJygFbkZ8z/D6YRpjbvlSv0emaotLS77/3ftJvfcQ2EFInaFToLvrkQny/LvOlBt9RMXGE2xVQ==
X-Received: by 2002:a17:906:1703:: with SMTP id c3mr2930665eje.64.1627535468131;
        Wed, 28 Jul 2021 22:11:08 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.11.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:11:07 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 69/87] trace-cmd dump: Dump sections content
Date:   Thu, 29 Jul 2021 08:09:41 +0300
Message-Id: <20210729050959.12263-70-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
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
index 9088d2f5..1dcc8c7c 100644
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
@@ -907,6 +947,7 @@ static void dump_v7_file(int fd)
 	if (lseek64(fd, offset, SEEK_SET) == (off64_t)-1)
 		die("cannot goto options offset %lld", offset);
 	dump_options(fd);
+	dump_sections(fd);
 }
 
 static void free_sections(void)
-- 
2.31.1


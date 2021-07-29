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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06E58C4320A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E40D060041
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234089AbhG2FLK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234108AbhG2FLK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:11:10 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7866BC061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:11:07 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id j2so6364089edp.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zvljAPEL24RuPR31f9JTK/flseOCHo3TBjbEyZ3P9rc=;
        b=VL4bHeoUFz+o5SYpHdBbWKBEVyHQLZ6blK7olGjXqjmyliD08eadkIjovik/dS8RYr
         m0RxpKzV7XYbLVwvZBCZjf8xhxAFN//23gM0Ox6CUn2W7blhJO4yilYbStxoQgQAhXFY
         VR/bjcO1vDzfkzGWOAs6QnUgftLjRI0OqqEeGSylFgmVMOF+KSA56sqzEX8ENWpbc3Zp
         yCudqYgw3VQHRENp0zdvtk6kJu4T5pXe8Q8UqFy2OeJ/d4qZXAEXqJ004LMoS1WjjQrf
         Pk2eOFE9PgSAxDVE0Z75HsSNzybO5IArHiq1YP/LnuFZ2BjBiCEsdKGG+Tpeq6i5q0Nz
         AOnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zvljAPEL24RuPR31f9JTK/flseOCHo3TBjbEyZ3P9rc=;
        b=sw0cpQjfA9RVqIwkAz5v/gQzgDy3Bmk1fShXx8wUj3aMi+MKxbCnWxkJzOUmuvM4iN
         7HlFJDUYvhUuGznjK1sCJPjdOLzQalVl0e8Y7tQVIa2yN3EgvEgd1Z3Izr49eJOm3xN0
         H8SOWWOTkqsGTI6QmWcngDNc+rm+cxXA6iE4zQhbu/Elj24R0Kt3k3tqg08DpfDdeii/
         bLCMPTeCh0bEeDwGAJINKl25OhvSrnhJD+B3p6kRJ8/Z1J329ThBEHq0u50tllilERPx
         VaUdGtd2+8c9PC+iVEEZECo+uavFhaqpTc+spzrjqgGypI1KLpg3utVs7+dC0U/aKMSp
         EQzg==
X-Gm-Message-State: AOAM533ybmb3MYrlxG8DUux212VgJRCHIqMORpqJErZpFycd7GM7+DJg
        r1b3r0rIPtIwhE1iNNGAtaA=
X-Google-Smtp-Source: ABdhPJyToayfr3/oWMjQStkH00PPzPSMFubjlUOZ8hhUpav6B+KroZb3k6f3xhe0ZEWJ5YihAjKVsw==
X-Received: by 2002:aa7:c603:: with SMTP id h3mr3854676edq.165.1627535466117;
        Wed, 28 Jul 2021 22:11:06 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.11.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:11:05 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 67/87] trace-cmd dump: Dump sections
Date:   Thu, 29 Jul 2021 08:09:39 +0300
Message-Id: <20210729050959.12263-68-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In trace file version 7, headers are stored as sections. This allows
their position in the file not to be fixed. Poters to these sections are
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
index 63d8bb81..571b6ac2 100644
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


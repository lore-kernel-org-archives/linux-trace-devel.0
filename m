Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FC15C43217
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:13:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BDA961252
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234032AbhKKPPu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:15:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234033AbhKKPPt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:15:49 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2FBC061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:13:00 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id j21so25230635edt.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:13:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NHfFRdwp2KHFwMpvZOIB10k6MKj2ejsBTBRhj6Zgd5E=;
        b=qG3eVvD0tqABjXyLks1c96O2FEtkA4Fx9rlShlS8bYBe+j72vAqIyw83L4zxdoxcm/
         /9klFTPRjJ0C+8zGxL3BEiKa30I+fMs1qfcG3gT6eIG34SC4GKfr+xzZ3FK+14BRCSlm
         /9ARrUSGiOSUVaEbmCLhrKQNkhvsXaZj4PdLx8JcIxR5eTQY7YI81Y8RuGOOoQQnqmnu
         jj2VtBf/wTWc7lm//7LrcLw9XLxYz5QXGoB62fr66HZWO0gHsU/82jTXMl9Q/+1GdmLB
         ykVks1He+Ah1tKEbSXCxG3K5dEftZcE/GIdtm23wo7XapnTZEmB7myWSKze9F/Ej5YIq
         cFIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NHfFRdwp2KHFwMpvZOIB10k6MKj2ejsBTBRhj6Zgd5E=;
        b=z/ztwkbTn5mKNkol5hm2yw7F8SiGTsJSJKEw4eQShXZ9I211su4VV2ZjYHS8KiMXWg
         jTSSCbBAJlkRtHgh6Pvaj+brw/B5nZZ5mpazLrX5iATUgxZJWzP+lL7xd5eVDwIEbTJl
         OMyfmZUrGmLRyxGIswDD2olopJnvDSkELHVJMFdrFf/qXcEmsy2Ls6IbIZmJKlkPCunQ
         lnYgJqaHNvYBzUnMOHVbwD1pfkULsjQCQeKqtugSVdJh4q5ofJE3PQXJ+B4ikP8e4XqO
         60DHnY5xl9SLUpwLvYHjt9ewUeHJSIp85hC0SmB60Dk7RrBOnYCztolSjv4R6DcyHj25
         OP5w==
X-Gm-Message-State: AOAM530h8umhR1RdfeC5KVjkaHnvhyGPSpcpJq0kG5xVL0k+Xjmrmqau
        wCxWGMe0zs+09HwsdJFfTL1l66eUR27fGw==
X-Google-Smtp-Source: ABdhPJzT910GojluDjWufsr2fGLnuLokmLQGKgnhG8XyRw9SDOheKc9zCkTBbfjcTX6dWKAksn5U3A==
X-Received: by 2002:a50:becf:: with SMTP id e15mr10961819edk.114.1636643578620;
        Thu, 11 Nov 2021 07:12:58 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q2sm1443375eje.118.2021.11.11.07.12.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:12:58 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 06/10] trace-cmd dump: Dump sections
Date:   Thu, 11 Nov 2021 17:12:46 +0200
Message-Id: <20211111151250.87023-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111151250.87023-1-tz.stoyanov@gmail.com>
References: <20211111151250.87023-1-tz.stoyanov@gmail.com>
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
index f8909faa..2f8cd5fb 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -713,6 +713,24 @@ void dump_option_tsc2nsec(int fd, int size)
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
@@ -801,6 +819,25 @@ static int dump_options_read(int fd)
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
2.33.1


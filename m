Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0E37C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 11:05:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240318AbhLJLI6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 06:08:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240267AbhLJLIz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 06:08:55 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0CEFC061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:05:20 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id r25so28243071edq.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:05:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S0oPuBqmz0nlEBUWWBZJvD5Y08KtUeqByEXy2aXH1PA=;
        b=lPQz6u5f1TwPM/6ZNtKeL5NzTT3kIp6NzlprjNKKHZFiOv5+i5la/1yVTNrbVgAxda
         r+lqVn4FV3rwNfs9kIVRxeTEhL7261gFv6Vyqsb5izFKwNYkxyVirYQGxrodYfSyShpG
         OUmqBCToS59SWOJUz6/NdcA1q/rNi9ZlxXNjW9YYkFKG+HUJgIoqK7V2Aw5xeQKTs554
         WzjkT7qRzs9TudeXzcgxDSe5AulkKIjgHLs0LXEfd7cPfMJ9qwNeTQux4ueuFJ4fSDdk
         tytC/Z/CRGfZsuyWvKAM0j2dHiAlkpG46E5ocsSc8dpmuYDUXyh8k7vCEOpAxr/1XuGU
         8ziA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S0oPuBqmz0nlEBUWWBZJvD5Y08KtUeqByEXy2aXH1PA=;
        b=2ELqWOpLq6FAWbUsYFfqd6+Z+UAjuJj2ZnAGfEXYnkofmlIpLtSqUnKUE8hyjE+LeQ
         z0UUBkjh21QgzO5LzBYHrlXTUNiwUzjCNEG+wTdCL8AkAxrjCES/nleOIKQja5Bl/UMt
         HTZL61f9p2n1J5GhX1rJdQ5wjAzL5PFOQzU+/DlNJXx0WAmU5rL3IUJqnAcZx/JTuv2/
         eOXSmpM9fvK8QAkFANRK0YcY7VHO0X62+sXk2TOW4lB+Jtx8I4i431sk227nmn2M5uj6
         1YKEKOs0c3LE42+LvmMaG2shuqk/ADDLqXt63y21UNKafwuDW7yFFbLBgH9sTA2d6E9y
         2vQw==
X-Gm-Message-State: AOAM532clZs4YI+uqj10LrpzSCqdjSqgMNDnPuPBXiVCUZrsa82ewQd0
        RK0RCJM/STnFqb6+LbRLHVJVK1XAU54=
X-Google-Smtp-Source: ABdhPJy7FCWOQeDlJ80inzbcA1KMjhAwUWSKnIveJHdQXbkdBqZQP+huYhTAjuCJ9NIAavN18dKl9A==
X-Received: by 2002:a17:906:3ce9:: with SMTP id d9mr22726650ejh.172.1639134319404;
        Fri, 10 Dec 2021 03:05:19 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gs17sm1278887ejc.28.2021.12.10.03.05.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 03:05:19 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 06/11] trace-cmd dump: Dump sections
Date:   Fri, 10 Dec 2021 13:05:06 +0200
Message-Id: <20211210110511.98856-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210110511.98856-1-tz.stoyanov@gmail.com>
References: <20211210110511.98856-1-tz.stoyanov@gmail.com>
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
 tracecmd/trace-dump.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index e4609c39..f6d84e3b 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -712,6 +712,23 @@ void dump_option_tsc2nsec(int fd, int size)
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
+	do_print(OPTIONS, "\t\t[Option %s, %d bytes] @ %lld\n", desc, size, sec->offset);
+}
+
 static int dump_options_read(int fd);
 
 static int dump_option_done(int fd, int size)
@@ -803,6 +820,25 @@ static int dump_options_read(int fd)
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


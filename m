Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A606C43217
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:29:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241394AbhLBMcj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:32:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240508AbhLBMci (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:32:38 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31C70C06174A
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:29:16 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id w1so115550982edc.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:29:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NHfFRdwp2KHFwMpvZOIB10k6MKj2ejsBTBRhj6Zgd5E=;
        b=pXyP+qCh+VjIyqi1MBYYz1nV6Wfeqeod+r1awasDBNrhY6kGFu7jyQn3zb2mSwoCj/
         MGwj2MsXv3UFrRBWs0HcvK2PtY/RwhROSiujDiZpWYK6m+i38qiw3ruF0VGqn86MrUCr
         ijbMHfjPXhWjT2sWcdQPvKP9n7sWQH9jrXeYAH3n7GHrtGEoE8WxnFkOKnbHrcQCHbL/
         vk80N+WZdTdoChgIZ3MFjIYyzR/yv8hg8JP0vKCtBSVt839ahv8+OPh0Tiey8AkftfXp
         6C6G8+EXiLiu0pqucmEdHaq3dGAYmJF39mKQzwdXzXXYALj+cgBZ4vg0y70y+bTLiN9f
         LQbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NHfFRdwp2KHFwMpvZOIB10k6MKj2ejsBTBRhj6Zgd5E=;
        b=21sTkcKfyYcJEU/hF+HZ4oFC4KXeRmnEv1ypCK7DNZBuhoDCY6IGIS1DZuJH8ghW5U
         Ytdw2iwWoaxEq2DCmSmOGpU6TuSudW1zy2e10Kq/pElbnITcDwZHXXSi19pAyS+Z7Df7
         6ot017BOm6rZms0fg6O5PGt9mcJivOH+ZmvT8ARTrH3WhKNzK/iPJS+m8dgRxHoZJQSg
         f10iOp5ZDzsa/SAfqlKoYsK0ej7CMLS3YBi99EQ7qeMBSPhwAbtF8TcMhmmPxInDIGry
         KlJEbyC4VejGehU8iOpdFVEW0Tg2O0qO1jE6TwKgJpZcKnQK83PmVhuTcpBO8xAPsnwx
         Okig==
X-Gm-Message-State: AOAM5337roKSo10ljmtriuyvjRiAa+AXUnVKPpCp3QxWfGZ+V3Xarume
        iCJueyjn2wPK0dAZt0YIaiyzCk1S+RrXdw==
X-Google-Smtp-Source: ABdhPJwUQEIbszbAvFlSLEded0DTz0leWLEJrFmXQAMy7Sr80mnNQfikw0nX4WLJNG2JSfDLk7Ft5Q==
X-Received: by 2002:a17:906:2c16:: with SMTP id e22mr15129506ejh.501.1638448154768;
        Thu, 02 Dec 2021 04:29:14 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id m16sm2182692edd.61.2021.12.02.04.29.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:29:14 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 06/10] trace-cmd dump: Dump sections
Date:   Thu,  2 Dec 2021 14:29:03 +0200
Message-Id: <20211202122907.44008-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122907.44008-1-tz.stoyanov@gmail.com>
References: <20211202122907.44008-1-tz.stoyanov@gmail.com>
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


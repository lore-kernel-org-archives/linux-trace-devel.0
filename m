Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A59FC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 11:05:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240377AbhLJLJC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 06:09:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240314AbhLJLI6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 06:08:58 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACEE5C061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:05:23 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id z5so29250652edd.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:05:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QqNop7z0zDfR5V4AXrYHtQdcUO0DiKaa8aLuPxN3IAA=;
        b=H51rKsvJ9/tl5nTOBoanur35PlhlBcGqaBdKkkmThfWWCEpv7w/rKFI9oyvq9iyww5
         Lb6n9kGFA5qtqh2a4fwhfxisluUk/qBLB2Zc0/W1yXVft8muRbj225GGEy3EfmT+jcHY
         iZUbWzmiJ0h8hDK3I3AzBcqTpZJDe6e82pUf8edx9M6AlwcKVDZuTqsOe1DC91858QN/
         NeSlvMRkrCCGSVG84OY++XeDGHvxFwmoz+YCT6bJvz5uIdfQLOVHPTngzNkrzqBvuVoI
         x4I0aueHjJ/EACn2UCwxEqR5dQbX8jAIHTjGP/C3O3UrVUscSVzKIRjvngSOb7aIb6TA
         W81A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QqNop7z0zDfR5V4AXrYHtQdcUO0DiKaa8aLuPxN3IAA=;
        b=saC0pLZBHvQVbSsnu2AhsdhoTyR4iYaLwwBNju2+j98J2NUDsnxT0g0hV5xrfcIkm2
         Q9e0r2ZEW1EE0ANUT/RdmsvYDwla1A78HQFrLcISPa8O9KREpNyge8WHYls4agh2MZMr
         +FuhsIfm1J2SymPELbreSrBLjgjRG+vzLE4dpJd5dugV25lYu4v75zIBHj+eF0XMVdEL
         nB9WLTiRSw2ECkcnGekur5/qgSYah2jBLwWpSpTMR8bJ7w7rni9ddFD0oAHqEklScWKe
         iU8zZ3/FTa5HNB77leqCvtYhCVADMEBYC/v9+Sx7d9kyDtWZ8m9o7GthhrEk1eXbxFwq
         Xe1w==
X-Gm-Message-State: AOAM531lQ7JCfSVfp0Ih5kqC3Fjy1YmQ3CfQDDaI5fxQigHMAKY11CIM
        R8rzKapN/5PGIOUVL9HdF779xY2gu0M=
X-Google-Smtp-Source: ABdhPJzb8jFE2Z2ULvJEuhICpjd0qGxk8QCl2vQmJm55R0+rzpqX854NIY85eTVKOw/tTZp1i+8v3A==
X-Received: by 2002:a05:6402:b23:: with SMTP id bo3mr37046685edb.366.1639134322334;
        Fri, 10 Dec 2021 03:05:22 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gs17sm1278887ejc.28.2021.12.10.03.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 03:05:21 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 09/11] trace-cmd dump: Dump sections content
Date:   Fri, 10 Dec 2021 13:05:09 +0200
Message-Id: <20211210110511.98856-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210110511.98856-1-tz.stoyanov@gmail.com>
References: <20211210110511.98856-1-tz.stoyanov@gmail.com>
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
index 4504645c..3b2ba138 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -744,6 +744,46 @@ static void dump_option_section(int fd, unsigned int size,
 	do_print(OPTIONS, "\t\t[Option %s, %d bytes] @ %lld\n", desc, size, sec->offset);
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
@@ -1037,6 +1077,7 @@ static void dump_v7_file(int fd)
 	if (lseek64(fd, offset, SEEK_SET) == (off64_t)-1)
 		die("cannot goto options offset %lld", offset);
 	dump_options(fd);
+	dump_sections(fd);
 }
 
 static void free_sections(void)
-- 
2.33.1


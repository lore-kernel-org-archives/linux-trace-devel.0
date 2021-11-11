Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45081C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:13:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E570610D0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:13:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234041AbhKKPPy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:15:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234033AbhKKPPv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:15:51 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC332C061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:13:01 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id j21so25230937edt.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:13:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8gCpS+fcA3sOrLSl9R3BhH9qJggh8STZ7fo9+83uT00=;
        b=KJu7aN9fy4mN0NfuHUUo2Ia8V51sVysuKrrUxuUsIXjkQgWwoBVuXEQ7E4WJhtAf5e
         H/0qOS8SMq81wmFVxz2y8794H3bxAUiitbinNNcVT+wPrxclTtcYfASSvgacJEcdw3VP
         oNI5BeaP1FbzlcdZkYbReMbT59QK87+qllVoEocSiThaNIFhP357+xPWMq8wucu0JE5I
         uAZVbRHFf0BKgag2JY882GhqpEhNRYF69X5ZZll6XYeFFd01v+4y8zOHSsTmZUCLR9v4
         ny5AnmZoz0FRPxMrXrpKCbP7TQvuMe9iH0mN3yGnnaiE86GL9ER4xJEQGsAsD7eZxKLe
         1bYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8gCpS+fcA3sOrLSl9R3BhH9qJggh8STZ7fo9+83uT00=;
        b=crrMimhF/58d6nbtr3c2v5JthPToMy7j8lEFeW9srrH8xR/eC7DwWhPeUeGDpgUB6W
         1UAesOABSMyscRu966f14yJQos3W/KrXiBmmX2Cze5+rcXwfmFwjnm/vvr2qWxvuM/xA
         lu1/9nmvhKsLc0otlT8lGSf9lIdJYTNh7ogbnmzajkK+I/bIygmV9zuU7Ce7ws6YZ84Q
         bsMjY+/usAkGQ76hBowoHqxPcb3IYuK2fPvDYSkij+1SexrD+j9aBy0I8shfGs6FxDck
         7pg/GRbY+/PRH5nkKNatVscEJKrIkQg4n1T2iLJzn66PLXZUxmwtvOqudNcwrjWgaXm+
         NR2g==
X-Gm-Message-State: AOAM533JxZ+8EwcOz8kgH+sGigegpPH7EHGjIPGfCOGm+gBP46uROajT
        1M04JPtB7VAK6gY83YCTWDyVR1S4ulZ/AA==
X-Google-Smtp-Source: ABdhPJwCC+yTl/0fWanI77xmKslNuTvIJMKsWYAs+dtEGVNBHwI/ZN3Zr29gtfP9ytw5UqVdE7VQNQ==
X-Received: by 2002:a05:6402:4315:: with SMTP id m21mr10846824edc.54.1636643580098;
        Thu, 11 Nov 2021 07:13:00 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q2sm1443375eje.118.2021.11.11.07.12.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:12:59 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 07/10] trace-cmd dump: Dump trace file version 7
Date:   Thu, 11 Nov 2021 17:12:47 +0200
Message-Id: <20211111151250.87023-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111151250.87023-1-tz.stoyanov@gmail.com>
References: <20211111151250.87023-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Trace file version 7 has different structure than version 6. Separates
parsing both versions in different flows.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-dump.c | 38 +++++++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 9 deletions(-)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index 2f8cd5fb..11a6e1df 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -929,6 +929,31 @@ static void dump_therest(int fd)
 	}
 }
 
+static void dump_v6_file(int fd)
+{
+	dump_header_page(fd);
+	dump_header_event(fd);
+	dump_ftrace_events_format(fd);
+	dump_events_format(fd);
+	dump_kallsyms(fd);
+	dump_printk(fd);
+	dump_cmdlines(fd);
+	dump_cpus_count(fd);
+	dump_therest(fd);
+}
+
+static void dump_v7_file(int fd)
+{
+	long long offset;
+
+	if (read_file_number(fd, &offset, 8))
+		die("cannot read offset of the first option section");
+
+	if (lseek64(fd, offset, SEEK_SET) == (off64_t)-1)
+		die("cannot goto options offset %lld", offset);
+	dump_options(fd);
+}
+
 static void free_sections(void)
 {
 	struct file_section *del;
@@ -956,15 +981,10 @@ static void dump_file(const char *file)
 
 	dump_initial_format(fd);
 	dump_compress(fd);
-	dump_header_page(fd);
-	dump_header_event(fd);
-	dump_ftrace_events_format(fd);
-	dump_events_format(fd);
-	dump_kallsyms(fd);
-	dump_printk(fd);
-	dump_cmdlines(fd);
-	dump_cpus_count(fd);
-	dump_therest(fd);
+	if (file_version < FILE_VERSION_SECTIONS)
+		dump_v6_file(fd);
+	else
+		dump_v7_file(fd);
 	free_sections();
 	tep_free(tep);
 	tep = NULL;
-- 
2.33.1


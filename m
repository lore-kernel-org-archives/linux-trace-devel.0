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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2596C433FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:21:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D84160E9B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:21:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233172AbhINNXQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233079AbhINNXP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:23:15 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A558C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:21:58 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id qq21so22990381ejb.10
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XBqB9KoV1o24qWOyKjje4CKxWGz3YUwcOPKCLKEWJ0Y=;
        b=pVlgUcYwGqtEpwL+sTWqjhOjYfaguHh/gTweZnv8Uq6vnaK+Idp7QXhX2UiUGPsvNZ
         GcdY7w4500yhYuvUWRY8bOCAuB+qvfX/RUg/s2YB4EvuW5ypZ3I+V9kFh7WouLzV04AY
         9vax45GAv6i35x1Djo6TSwViZkY+vusCZv57ZHX7wjs46Xye3YmSZz9LpxoivC0ujwMc
         qIpO3tp+hgPP48VA1k53YZ4/l9/TkrvrP4HH3PWB5cNrF1js23nLm1CD4OLBbXYcc5I+
         97Y20s8Fw27xt2eYYsyUeZc5E5c1CZUqYYsipckx+y6/p1c4J47mCW2R7sKmbHz5dRWd
         +lqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XBqB9KoV1o24qWOyKjje4CKxWGz3YUwcOPKCLKEWJ0Y=;
        b=vWrmMmEL09QVVuDNztQyx94320STa1snFfBcnYLvg4X96Tm2sZMsVmItLa/ZyZq2e9
         f/vTL+j5oKxQKB9m2xCieGHLTWb8KJMZvdTo8Ye05MRZR9OFE+vSjlmeMlOJU8238/e+
         tSJJ6WpA7L7l5DZixDkY3PC+/6E6ZcGYa5isC5Tw9UOMopWPVKa/qVX6jLJM4oIuS0Lx
         4XCZLgrUfDMRto/hqLAoWTXOz0pOhbchu3RCaumehfYEaj/F9DTHLnvrUfCvkANV3h1R
         q36j1SNt9ZDXU5/eLyQWw7SNHvqKvGD6mD83yagztzN9zV0TfCoE4Og4xZqnIcpBohoC
         iv3A==
X-Gm-Message-State: AOAM531QabbHXsLpmLp7yvjgWPS63JAuCziDJYFXusHOntp86Ah02yFk
        /BclHfCO2v6XDZywxSxuThLYUTxM8Wc=
X-Google-Smtp-Source: ABdhPJyWWmUyedR1MDqWO2+Ua123MSKvZMl4wvB8W3L8euMIRQTTJC7+a+wyJGyfL62x1TU5N2hpgw==
X-Received: by 2002:a17:906:8450:: with SMTP id e16mr19018934ejy.305.1631625717081;
        Tue, 14 Sep 2021 06:21:57 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l7sm5708431edb.26.2021.09.14.06.21.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:21:56 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 07/10] trace-cmd dump: Dump trace file version 7
Date:   Tue, 14 Sep 2021 16:21:45 +0300
Message-Id: <20210914132148.3968401-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914132148.3968401-1-tz.stoyanov@gmail.com>
References: <20210914132148.3968401-1-tz.stoyanov@gmail.com>
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
index 3394847c..44f103d8 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -884,6 +884,31 @@ static void dump_therest(int fd)
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
@@ -911,15 +936,10 @@ static void dump_file(const char *file)
 
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
2.31.1


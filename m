Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E593C4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:29:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbhLBMch (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:32:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346825AbhLBMcf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:32:35 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4599FC06175B
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:29:13 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id z5so50321468edd.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:29:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/LcOcTAQq/E0EFpf44euFOpIpRgzGloaNazoVxOO5cs=;
        b=MwAPTxv9ToiollQ4thYvKi2cnOaM9oXqne8T3cbKlYc72HR2ssPAVOw5QCbTitOE0A
         Ay4Z+ZhQvhrDxPZ7KyQFsGpj9mFwxriG28W+BjqvA16HBA+ipwpRDN20vNxrqafLJlW+
         gfpi3NnwD0rJl+JYa8fTP/QGkqGi1toV9l4kfpV1wq/IslSnWCfCYszAHnX3fmNtMXpj
         PPkJ280BqgCEZvSExugMgHjr4xRGXb93Sz69O9AAXUQrQ9DnWN14F/CElt2xr1wAHmQj
         PhGb1FbAIiWa2jjkKU56DkuxA94LH5gwGlEIvpCwY6D6FqtyI18R/GL0K5Qvv9Me80J1
         j7pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/LcOcTAQq/E0EFpf44euFOpIpRgzGloaNazoVxOO5cs=;
        b=5F8nIF5L7R2EOIGsgnkV40NvXB8HDORTN7LLLvuARNgagU9N78ITYkmXrCyzNP2Nkd
         rtu21UvO9YJtxX7M8elmJBMPRBOJDPn5lEM2bKJRnAtSnKAPzVsHBlAmxc3FN8H8Bs5r
         BYCJ2ivIwrAYdWgfHG9ojseSwagTcau/6fwPFIsjvjD0C+vhMu9YC9oMxE/DV3ltXQfG
         ckmZDva3RyCGOxHbfhFePJSf0Px9z5w0l2/g/5DZvdxWBmWzs5XHhGv4lS32NnVFNwur
         ETjquDLO4JPIy1zPbRqLMg3Wt13TXfLg3nCdsRGVM06wPazhdywuTqEZstMIYrTAgLX4
         lLlA==
X-Gm-Message-State: AOAM533ZnZ40GCUDr8pgukziGpVZb15Db5alc/7wj4F1gmi6cJQXtDs5
        RvrBbpITvbd7bJ0S5TSt0gbmBvdu7b1Xfw==
X-Google-Smtp-Source: ABdhPJzBP+oWImuv+kMnvCJg7TA3msOXlcSj+lBncmfPYRF6FVPQ7LcO66HzayQ79omnLONgrVWgcA==
X-Received: by 2002:a17:906:794e:: with SMTP id l14mr15490463ejo.64.1638448151831;
        Thu, 02 Dec 2021 04:29:11 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id m16sm2182692edd.61.2021.12.02.04.29.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:29:11 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 03/10] trace-cmd dump: Add helpers for processing trace file sections
Date:   Thu,  2 Dec 2021 14:29:00 +0200
Message-Id: <20211202122907.44008-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122907.44008-1-tz.stoyanov@gmail.com>
References: <20211202122907.44008-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added a new local database for storing sections, found in trace file
version 7.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-dump.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index a1fc6d7b..e3c40a0d 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -43,8 +43,18 @@ enum dump_items {
 	OPTIONS		= (1 << 9),
 	FLYRECORD	= (1 << 10),
 	CLOCK		= (1 << 11),
+	SECTIONS	= (1 << 12),
 };
 
+struct file_section {
+	int id;
+	unsigned long long offset;
+	struct file_section *next;
+	enum dump_items verbosity;
+};
+
+static struct file_section *sections;
+
 enum dump_items verbosity;
 
 #define DUMP_CHECK(X) ((X) & verbosity)
@@ -768,6 +778,17 @@ static void dump_therest(int fd)
 	}
 }
 
+static void free_sections(void)
+{
+	struct file_section *del;
+
+	while (sections) {
+		del = sections;
+		sections = sections->next;
+		free(del);
+	}
+}
+
 static void dump_file(const char *file)
 {
 	int fd;
@@ -793,7 +814,7 @@ static void dump_file(const char *file)
 	dump_cmdlines(fd);
 	dump_cpus_count(fd);
 	dump_therest(fd);
-
+	free_sections();
 	tep_free(tep);
 	tep = NULL;
 	close(fd);
-- 
2.33.1


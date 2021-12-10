Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D42FAC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 11:05:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240263AbhLJLIy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 06:08:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237368AbhLJLIy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 06:08:54 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B129C061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:05:18 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id e3so29125924edu.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:05:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1RF9iTs0YQheWjPYt7oNCLhohHvFqiNhoZNvOlMV/x4=;
        b=hvaJaHJ7PEvhcImRWRWeE3K2ahx2/FYAb0R5/ydrhByAOC6ch0P01BSJ9VHzIB29hF
         U4exHkBpH0SBYRo3zsbMshTPvp8z92XIBrvuYLUai5mmKD2PzQpNIr8C19muckqWs/gj
         hjHIb8hiV8ss3sYWAj2x+4sPaRhVIH/qy8LBPmKf7RwC9KtKc4sBLr+v5InhHrdPuRfh
         t7n4XunDal3jaXaAIWgaQg/avQA9GW8elzZme/ddmtGyllCOt2w7B7okw/oU623284ox
         lHKW8BDRJDdztEwE3jbAF0kGVS46Ppg7aH7MFoNCDnsGMMhk7N7ttoutgkMuqfLSFQ7J
         l5ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1RF9iTs0YQheWjPYt7oNCLhohHvFqiNhoZNvOlMV/x4=;
        b=ML0/N8/3VEM4QFs7h4Zfjk7hUZ/5RbjhWos0l/EKI1A0ziMqqy5Vw7annXcvsvuxvJ
         soFVDnhJQnppr3DD6eh6I03Ulgmr+UjgdhP6EorNwpdtGEM+du6KCXpy3qa2CNMzJ+P3
         hMceHRaO5UjoiBpiNozcvvtZAX+yw7SfY9HRdd89PRsKhkSkflTaqDJXoS3hadtCUKda
         14DyKx88yW+4WK+QAT00TQG38AB/ENp3gSY/yjD/ybOtWfpjln1PqaCvPe88Dy815XE0
         jXxM5Datmgx1oj5AdNywZPuHGph1YRo+ya8F+2+FwvwFyVITwZls7B2oa/AZxz/PTowE
         V3Kw==
X-Gm-Message-State: AOAM533VZ3s4Uo8f38deK4ndl9+Z7QoKxWJsLaMXeH7IOuayZVKOczcE
        dJmGSTs1uqnNov5hjPnwUa3/+k1Ocf8=
X-Google-Smtp-Source: ABdhPJyJpBuCHJCEyrhZqoOQJo/+wIEJAb1Gs/5D4sWgOQG9znOIwyu8gSodDKq1FT71ppzfvb9N+Q==
X-Received: by 2002:a17:907:3f29:: with SMTP id hq41mr22970477ejc.216.1639134316882;
        Fri, 10 Dec 2021 03:05:16 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gs17sm1278887ejc.28.2021.12.10.03.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 03:05:16 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 03/11] trace-cmd dump: Add helpers for processing trace file sections
Date:   Fri, 10 Dec 2021 13:05:03 +0200
Message-Id: <20211210110511.98856-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210110511.98856-1-tz.stoyanov@gmail.com>
References: <20211210110511.98856-1-tz.stoyanov@gmail.com>
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
index 1503e2bf..113eee8e 100644
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


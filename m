Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E4FCC433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:30:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235211AbiASIaa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:30:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232460AbiASIa0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:30:26 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA61C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:30:25 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id j23so2487167edp.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:30:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oSncKr1Yq5cH10X6nVu9hqk2u5RbAFMeSnzG2SlLsHs=;
        b=YHwEq1lMMCxAtO5MSfMLM9yXyul33nSzX/OF/9ge65l5edHrvf6mfFdh5mrn46zKtz
         XTIGQnKcFH5UX4Cz+iZMipyPJE5IQQEMqt/ISjZeZmPKfjBl3xtr1yQ1txeatDwc+JVe
         9r6t6cssSnIejz72MqDnIs6O65wPKyoldxs/G8CxzKQd0gZOFpHYPWOM+V72gXWmEp/H
         TCSF7resgyy4CJA9IlcxsmZcmICMMVTCYAjDZne5mQaIBzVAUnQtHYb7QFZq3iHVRtuo
         MVNhOC2ZXlPUws7lPq6WzFuZaMyO//PIUmRz/QyXEhFnW6F9KHN4+qq4qanN+gDztDfF
         DElg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oSncKr1Yq5cH10X6nVu9hqk2u5RbAFMeSnzG2SlLsHs=;
        b=e8BhZSQlXvcy4iwmWCYHcFUQ4vnH/KxneSuoq2GY+oHykZaNfVsRknUfK/mkaMQkrj
         jThymWNuoedUxqCmdkL1rVZMygjYbzY7Eeiu0fnyKS63Tb63eaJt9NTBsCZJD/j7elIq
         aNETlz8rDlqdXz3hmHWQ4flhO1DVMaNBEU6hUrWEM7YmhUws12Mfgf8muIakTyaw/RvW
         c90/+0USWWrB5xSU0pXmCEzkXXSdZHpIq9un1R2eKUUB7n7tUXC7JJrGxcvra9xZPfTv
         LZnxdBElEvKI0rziZ9U422w1EMtBo3R0tMJ9XD0BYH0v8Ma/IG7E0e3QXdej/KNUvgaJ
         JEUg==
X-Gm-Message-State: AOAM533a3N3R6YPjJyXbBmt8vC0ZWLlZvdD0xONjtX3f2LGVZoIKgf0r
        PVxxt5CIZDMjx/OEbWvD+rb8HY0jeuA=
X-Google-Smtp-Source: ABdhPJw9QTiuiRzDrVxkPRmDU00RdLFAWu4DmIwSN7R6HNMHDDQuR1drHmlkxhelA1NcwWLLlL5eBw==
X-Received: by 2002:a05:6402:2552:: with SMTP id l18mr29300960edb.124.1642581024348;
        Wed, 19 Jan 2022 00:30:24 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id la7sm6095530ejc.94.2022.01.19.00.30.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:30:23 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 03/11] trace-cmd dump: Add helpers for processing trace file sections
Date:   Wed, 19 Jan 2022 10:30:11 +0200
Message-Id: <20220119083019.246153-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119083019.246153-1-tz.stoyanov@gmail.com>
References: <20220119083019.246153-1-tz.stoyanov@gmail.com>
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
2.34.1


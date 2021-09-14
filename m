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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE9ADC433FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:21:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A272A60F11
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:21:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233145AbhINNXM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233079AbhINNXL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:23:11 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9646AC061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:21:54 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id t6so18463045edi.9
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Yh40ZYgMwbP81n6hFixo15LEQgbd5DixHArPEoYRm6A=;
        b=VN23/9iZgUlqiCK2Rj9Wi5+FHwarr/BZJJo1t36dWyebjjwQH9slUMz6IeESriLfuG
         l0J/NtWiIecsRQ2TZKfACiFgYVf4DRqMCaRS6jxEvGA+Mlb9WO8+WI5J3LO+1EmTWypJ
         QNnntkOnxybh30ETrUm4+6IPvtvOOLGagLf+eCvoiCsedQ0Dv+dr/2uahSb80UhvtMUk
         50lccoxt7vDopZl/uXvoWvvOy+KBgu2Bc7q1qjrTIBeAa/O1lmDJ7kUZCb806rvK7SZw
         CWGc9LYLsJ8QIZOOW/LQ6RfozvCPGKgvmXf3EY7dtDFQJaOqGqlSshI2HWR8i43Z49ua
         hNVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Yh40ZYgMwbP81n6hFixo15LEQgbd5DixHArPEoYRm6A=;
        b=vO7IcKpG2V8m85//90SSh1JGqfwYE6s8KV5OxZxhH1bIt2HocTv8bfp63FhrXaKZyx
         EJsEouS3QNzxxG6tMssCuA80iZ1+1KjFO1Jo4MJkvOOPv1LOdj/XtLLMFz8lSv7YpohJ
         PDukJ41JEYjt/dFpEzGzsVnhiYKjM9JfvYMI2MWdhMjrRFWlVhMNLOuOQcHjeTHEDVVz
         VjCNRD8TdEuKwFdkYI8c8HTekneigfQbnIFUoDTY6Vdl+0/+ZXmKBxjWl28jYgHyJkIp
         NKMXP9lt64RZbB4sjtxd2kleKEvD/vIRlJnSOxXJjWNM9az3ph7qrXbw9Xz+JTnUteO4
         MgKQ==
X-Gm-Message-State: AOAM531jTe2juzKqd9ZkCBMllbhJK4AiU6GIxFaLOyHDDntOZ56IJjL1
        zjAPszmUYi6feIBaNE6yBkzRigZ3S80=
X-Google-Smtp-Source: ABdhPJzmzYX1rVpyA2I/x/zYwF9T5NOlTA+pL6dc+5pfZuNsGtxR9sCPAkQzVnfEzjAKabkNWrqIcw==
X-Received: by 2002:aa7:cdc8:: with SMTP id h8mr10545594edw.272.1631625713164;
        Tue, 14 Sep 2021 06:21:53 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l7sm5708431edb.26.2021.09.14.06.21.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:21:52 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 03/10] trace-cmd dump: Add helpers for processing trace file sections
Date:   Tue, 14 Sep 2021 16:21:41 +0300
Message-Id: <20210914132148.3968401-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914132148.3968401-1-tz.stoyanov@gmail.com>
References: <20210914132148.3968401-1-tz.stoyanov@gmail.com>
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
index 3cce231f..f7284436 100644
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
@@ -723,6 +733,17 @@ static void dump_therest(int fd)
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
@@ -748,7 +769,7 @@ static void dump_file(const char *file)
 	dump_cmdlines(fd);
 	dump_cpus_count(fd);
 	dump_therest(fd);
-
+	free_sections();
 	tep_free(tep);
 	tep = NULL;
 	close(fd);
-- 
2.31.1


Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97E6CC432BE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 830976023E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233875AbhG2FLH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234089AbhG2FLH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:11:07 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B22C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:11:04 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id n2so6358113eda.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zV0CqwA9/wXmtBv9QTZRvsjfkc0zh38RvP8876u1PMw=;
        b=juPpLBfqxhyo5QiJkI/jEhsbzzpa9XsvsUkgJ+WiccR6RC+Ikh2B7LyszG5QWHamTh
         9McwSVQK1+AXNB67IolaE6tR5h3P/IG0lIHQgDMxs3i2JIwMQ/KWIe4kHKbUAYVLPOmt
         IqiuTXsHc6L6CC2jRrUr1VTdopSSSENaWgqcN27dNXAfHWTMm//5RgbvUcdX1u/SJ6cF
         EEvo8DD9hTt46iEYOEA+BoHTJAcJ8WFI3rK6lzghMXlQzPM483yH8mVGngKFCf1kh+Pp
         X80AF9hUJWArTHXw8qQjVXAgH+rdKpLAfPxusAdsb2k5TBSNAtSrI65GDa5oX1qiMsCa
         gTWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zV0CqwA9/wXmtBv9QTZRvsjfkc0zh38RvP8876u1PMw=;
        b=tXNCEPrRB6NobZTQdJ5QvD/Uew1KuXsJBYpZmz67DEyEaXOlo2PNJu6NWzTols/xXl
         03ouYEttXExACOI5hAE8DC2qL3K/lvoqh/96BlvukUnJ0Mo9J4SQ1eDdbb8JN33y7ux+
         7g7O0bi2UlS48P5e+DRxh6ZSVpbZbdjzFAopNdITwY10VJx2ZxrNHHJflJgFF/XP/98m
         F/x9mqcvpM1VpuLQgBwQrOq/ldAymc86g7fZjClBwo45yhGOVUxFpfwQHG22LzC4VDRr
         3V+JklAXl7jPXM4pRlWmfAuPGO5RDXLNTecsBA+65RN4LzdGq/fExjHHgPI46QJu+RQ7
         ms5A==
X-Gm-Message-State: AOAM533AQEWBBEYJh0y96S79WcEElV2hknxl2r7l7aWXht0Pi9CWcBTr
        V8f1gnu4nxfxB55VwvLWMIw=
X-Google-Smtp-Source: ABdhPJxvzP6suW157fG0p4641eKb60QvOCfdT+7tCmizTQP8jEGB/eQ4fmNWFahVVQSssG/vjP0hEA==
X-Received: by 2002:a50:ab1c:: with SMTP id s28mr3844633edc.214.1627535463228;
        Wed, 28 Jul 2021 22:11:03 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.11.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:11:02 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 64/87] trace-cmd dump: Add helpers for processing trace file sections
Date:   Thu, 29 Jul 2021 08:09:36 +0300
Message-Id: <20210729050959.12263-65-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added a new local databse for storing sections, found in trace file
version 7.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-dump.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index e6f774bd..010a8188 100644
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


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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ABACC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:50:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 808006101B
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:50:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235629AbhIMMwB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234945AbhIMMwB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:52:01 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 702E4C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:50:45 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id g19-20020a1c9d13000000b003075062d4daso1364325wme.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Yh40ZYgMwbP81n6hFixo15LEQgbd5DixHArPEoYRm6A=;
        b=EY3H9TgJUkvhHoE7k0g1RqojIJCLGXv7k7b2+bf95vidpZvRc8CfiEBUsjGN206WgG
         A/63NPIBQJr0DRzA5OBb4OmiJBk+Na2qydlwgRhqAXppSz0AC/bFZx3OXn+sL8gMNbug
         XEiJl1snKpNz/Cu8emxlN4//iD03HysqeQL37zcCYqHMx/RXC1zo9Ce/4UokCc4KiSB4
         hN2bxWqpwAoi0UgvjKgBHrMmhslF6dqoaR/ozVeF+Xq0rBD6G69u7LKDLyj7QCMSBQ+V
         DrdCSdFxXGwWEee2DTqWl2ZlRLBoquk8C4kZ1TO2LXog4QttoyFT0t8jCstGD34gbyVr
         zExQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Yh40ZYgMwbP81n6hFixo15LEQgbd5DixHArPEoYRm6A=;
        b=wk3PeuYETwe2LdGUEcK4YbbponwZBxiX1SU29SSDpYxl89PDNYxuaDgtxcjprtxlC6
         /B2wslG0r4m+8ws1U/BSdbyE0l75f3XL7vv+eJVOolW4t0V98UedYDK6/W1y6mNWdf8S
         RdhJRWDPXCI1K0/JEctizV99J6fo49ybEfrAv8e0vWxtUTOqq6ISa4gyhj0vxf3XKcQk
         XXwU0pDKUqBpn6XhS7/UwcN/rd8wfAOHLSroRApSIPCKKivTmoDgPjK/WXPaRTc2Exzm
         sSww2MsSx+x1u7xHH9iHrkNSWJNQPom6kg7ZBegRS6IDeB3iOjy9HEleoHHM8YwyNZ2X
         jemg==
X-Gm-Message-State: AOAM5304q6AWDu0Naat0xVB77+W2HPdNyvYPTNJhiyefVKe9JyWvcF1x
        t8g1kNYJ/WFhD5qBf3Je/YmsnNNag3U=
X-Google-Smtp-Source: ABdhPJwmayJeVnBEZqU82EiHdT+uTmoHB8C7eTC9mkZD2zMNAcWbYJrTY75RVymDKrImZ0VNcrz6vw==
X-Received: by 2002:a7b:c767:: with SMTP id x7mr11173291wmk.62.1631537444121;
        Mon, 13 Sep 2021 05:50:44 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u27sm7756448wru.2.2021.09.13.05.50.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:50:43 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 03/10] trace-cmd dump: Add helpers for processing trace file sections
Date:   Mon, 13 Sep 2021 15:50:32 +0300
Message-Id: <20210913125039.3680986-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913125039.3680986-1-tz.stoyanov@gmail.com>
References: <20210913125039.3680986-1-tz.stoyanov@gmail.com>
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


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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14663C433DB
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 11:55:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B426D61990
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 11:55:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbhCVLyv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Mar 2021 07:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbhCVLy0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Mar 2021 07:54:26 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E0A3C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Mar 2021 04:54:26 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id l4so20724826ejc.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Mar 2021 04:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UflBtmQ2eZh4QyP/nWW4AHSJg0R4zlrauOPb3agZU4w=;
        b=TwjWDQ77giNHNiDS3Y75KQCoLM7BGWqtOim+Sk8j9uGM4/yAlkyXsYkcxtA54/OLRK
         cT6hcG9WBcPC/02Pogxv7rBzlWSYsKXYC/6OppHLBTGbylP2woNNHl7o09LdqSoi8r0C
         JzJgitKjR0BCHQjKOyCduxtdTh+QM0+fzE/++qCtLYXCcfIxM4DdnYvChmSKhyXku3TE
         d4tjFb5MS9+ujZSHy8e9qVFzemhvd+Lo9Xb5hUncdrkl36O0R51f99xOsJtZAJv//8WR
         uYhvIokiqPAminb/rBSIhY7GeRaMTeJV6Xi5EVXEY6n/eOe9jkTYdB2yXIKQ8A1aVuBF
         PbVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UflBtmQ2eZh4QyP/nWW4AHSJg0R4zlrauOPb3agZU4w=;
        b=qoG85QhSiHCE/iOCfXxmty0zjV+QNujXfuUYwW10SHJqhCFP9S/8dtXDDFNf21fT9A
         EA6gcCLmouhruM/y1ERfeFD1FBjgeUo61gmJJV8bUEthXWC9nRsfVYL3s6/MaoMXZkRy
         Tsn6cIoYtl1r7dYBoIrIEMkUFiQAQkUrYPuU/spMTTt1fJ97IjsSm9YNDH867aYtrXQT
         ecyMOx5vGd+Z5Ij4x73XvzjDrVJmxNLqw06wOI9Hgtxm1xGrJ1b2UV2ALe6ZPz98GC7/
         UEkTH+yggWjfMIMPBCfjreiswJxvh2g4aEqj2hbnRg0eEMVhK/SVULHpkCJhPl13ol+/
         U4PA==
X-Gm-Message-State: AOAM533RWXI33JlwaJHptioXzxxN8dWxwvz7jsdoLlPBvH/f71L1nN1I
        a4PDXQm3+2nc7DeY6lBi8KQPvhOb0kAXPw==
X-Google-Smtp-Source: ABdhPJxKocQpJ0e+DylpJTjeXRR2lCpGKzbMf07Gr79d7WApWQ1/y0JAZ1LbSOfCTgBfG32gM0w43w==
X-Received: by 2002:a17:906:8408:: with SMTP id n8mr18297163ejx.152.1616414064788;
        Mon, 22 Mar 2021 04:54:24 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id r17sm11358871edm.89.2021.03.22.04.54.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 04:54:24 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Remove all die()s from trace-cmd library
Date:   Mon, 22 Mar 2021 13:54:22 +0200
Message-Id: <20210322115422.272718-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The die() call is used for a fatal error. It terminates the current
program with exit(). The program should not be terminated from a library
routine, the die() call should not be used in trace-cmd library context.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 10 ++++------
 lib/trace-cmd/trace-util.c  | 21 +--------------------
 2 files changed, 5 insertions(+), 26 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 2093a3dc..5398154f 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1088,7 +1088,7 @@ static void __free_page(struct tracecmd_input *handle, struct page *page)
 	int index;
 
 	if (!page->ref_count)
-		die("Page ref count is zero!\n");
+		return;
 
 	page->ref_count--;
 	if (page->ref_count)
@@ -1147,7 +1147,7 @@ void tracecmd_free_record(struct tep_record *record)
 		return;
 
 	if (!record->ref_count)
-		die("record ref count is zero!");
+		return;
 
 	record->ref_count--;
 
@@ -1155,7 +1155,7 @@ void tracecmd_free_record(struct tep_record *record)
 		return;
 
 	if (record->locked)
-		die("freeing record when it is locked!");
+		return;
 
 	record->data = NULL;
 
@@ -1318,7 +1318,6 @@ static int get_page(struct tracecmd_input *handle, int cpu,
 
 	if (offset & (handle->page_size - 1)) {
 		errno = -EINVAL;
-		die("bad page offset %llx", offset);
 		return -1;
 	}
 
@@ -1326,7 +1325,6 @@ static int get_page(struct tracecmd_input *handle, int cpu,
 	    offset > handle->cpu_data[cpu].file_offset +
 	    handle->cpu_data[cpu].file_size) {
 		errno = -EINVAL;
-		die("bad page offset %llx", offset);
 		return -1;
 	}
 
@@ -1892,7 +1890,7 @@ tracecmd_peek_data(struct tracecmd_input *handle, int cpu)
 
 		record = handle->cpu_data[cpu].next;
 		if (!record->data)
-			die("Something freed the record");
+			return NULL;
 
 		if (handle->cpu_data[cpu].timestamp == record->ts)
 			return record;
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 538adbc2..ce2e7afb 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -378,25 +378,6 @@ void __noreturn __die(const char *fmt, ...)
 	va_end(ap);
 }
 
-void __weak __noreturn die(const char *fmt, ...)
-{
-	va_list ap;
-
-	va_start(ap, fmt);
-	__vdie(fmt, ap);
-	va_end(ap);
-}
-
-void __weak *malloc_or_die(unsigned int size)
-{
-	void *data;
-
-	data = malloc(size);
-	if (!data)
-		die("malloc");
-	return data;
-}
-
 #define LOG_BUF_SIZE 1024
 static void __plog(const char *prefix, const char *fmt, va_list ap, FILE *fp)
 {
@@ -547,7 +528,7 @@ int tracecmd_count_cpus(void)
 
 	fp = fopen("/proc/cpuinfo", "r");
 	if (!fp)
-		die("Can not read cpuinfo");
+		return 0;
 
 	while ((r = getline(&pbuf, pn, fp)) >= 0) {
 		char *p;
-- 
2.30.2


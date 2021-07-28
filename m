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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10080C432BE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4CF461019
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236690AbhG1Ndn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235325AbhG1Ndn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:43 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C1B9C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:41 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id gs8so4565650ejc.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IaeBNmUKVr4V3lRGIIXS7l1izwZEaVAjcNGqRUBjdHs=;
        b=Qv6YWtFfjzJgTecB6HOd8yowEoGAkmYOTI/esfHj8XJZYcKrfXQ73QW9JHBHFXbM53
         Q7N6DDCDBRL1uq/rbHxbGCSJ3vPMbkm2og+ijAvx7qTqN6uHD36S7bk2UlDkXgYxFUfa
         HK+7kq8rdBKaP9MZ6SZPJYo+PqEpV/leot5EZ3kle0mXyQZHBvp8B2mF6+a9tcXn3miJ
         NEf5H8hHbcHQfGUoPlQfH155tEF6Gkz2NE00pOHXvW+xd5KMUuZ2bRwoBWeFoNMTsmTJ
         7uHbroRPAWKYx10bq6ANaK4PbgQECWlwa/6yrQBpCgxRy6ljG4ouzCA7InhoV8lWiGlL
         ABqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IaeBNmUKVr4V3lRGIIXS7l1izwZEaVAjcNGqRUBjdHs=;
        b=paR4RAffWvA5cM8MqzScm4RxozJ0XcLWreVufY+phStTimUPaOQBhlQ4E6+uelBS99
         Xexr4d5KaCHGe26GPCKvlkYalxpOVSG7kQFapP/WI5BNUtKXqHN3eRbRwVMWdYAFkMc7
         ny9Ph1FHzu5CqIWkuMGK+CnACthVn24ErXx+wdRtc7+AflbK4zxnFFbp590zce3L4Mra
         pQTF+j11kEI9Twq7+jOdDy/QSS2nIOzU/t2SnGwl/PENrXDvAIcDOS9i6cF74IR31f9h
         pA8ODtyZYDApBYDaMIHn2GghHIGB7SwXKpiCjs2g+qnvYwLV3ww+PKZI0mYJv15AviAJ
         W5uA==
X-Gm-Message-State: AOAM533sP9sY4YzWA3s/oK0Qxib5+V4NCZIjubn1ItgmmFaZdCLR7hTc
        PrTtfLqkM9SZg1CcPOSUv2M=
X-Google-Smtp-Source: ABdhPJwpHq7rdKQY5jW2MC9TjGUggiUlWf6U36DNgjXIEVJQjWBvXVNX7cQMoU4gL1UfdlWe9kaJmg==
X-Received: by 2002:a17:906:7111:: with SMTP id x17mr26848857ejj.294.1627479219628;
        Wed, 28 Jul 2021 06:33:39 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.33.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:33:39 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 47/87] trace-cmd library: Read handle header and compression of the option section
Date:   Wed, 28 Jul 2021 16:32:10 +0300
Message-Id: <20210728133250.234140-48-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In trace file version 7, options section has a section header and
possible compression of the data. Extend the options handling logic with
this new format.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 50 ++++++++++++++++++++++++++-----------
 1 file changed, 35 insertions(+), 15 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 2bab3208..87fc7cad 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2910,30 +2910,47 @@ static int handle_options(struct tracecmd_input *handle)
 	long long offset;
 	unsigned short option;
 	unsigned int size;
+	unsigned short id, flags;
 	char *cpustats = NULL;
 	struct input_buffer_instance *buffer;
 	struct hook_list *hook;
+	bool comperss = false;
 	char *buf;
 	int cpus;
 	int ret;
 
-	handle->options_start = lseek64(handle->fd, 0, SEEK_CUR);
-
-	for (;;) {
-		if (read2(handle, &option))
+	if (handle->file_version < 7) {
+		handle->options_start = lseek64(handle->fd, 0, SEEK_CUR);
+	} else {
+		if (read_section_header(handle, &id, &flags, NULL, NULL))
 			return -1;
+		if (id != TRACECMD_OPTION_DONE)
+			return -1;
+		if (flags & TRACECMD_SEC_FL_COMPRESS)
+			comperss = true;
+	}
 
-		if (option == TRACECMD_OPTION_DONE)
+	if (comperss && in_uncompress_block(handle))
+		return -1;
+	for (;;) {
+		ret = read2(handle, &option);
+		if (ret)
+			goto out;
+		if (handle->file_version < 7 && option == TRACECMD_OPTION_DONE)
 			break;
 
 		/* next 4 bytes is the size of the option */
-		if (read4(handle, &size))
-			return -1;
+		ret = read4(handle, &size);
+		if (ret)
+			goto out;
 		buf = malloc(size);
-		if (!buf)
-			return -ENOMEM;
-		if (do_read_check(handle, buf, size))
-			return -1;
+		if (!buf) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		ret = do_read_check(handle, buf, size);
+		if (ret)
+			goto out;
 
 		switch (option) {
 		case TRACECMD_OPTION_DATE:
@@ -2983,7 +3000,7 @@ static int handle_options(struct tracecmd_input *handle)
 							     buf + 8, 4);
 			ret = tsync_cpu_offsets_load(handle, buf + 12, size - 12);
 			if (ret < 0)
-				return ret;
+				goto out;
 			tracecmd_enable_tsync(handle, true);
 			break;
 		case TRACECMD_OPTION_CPUSTAT:
@@ -2992,7 +3009,7 @@ static int handle_options(struct tracecmd_input *handle)
 					   handle->cpustats_size + size + 1);
 			if (!cpustats) {
 				ret = -ENOMEM;
-				return ret;
+				goto out;
 			}
 			memcpy(cpustats + handle->cpustats_size, buf, size);
 			handle->cpustats_size += size;
@@ -3079,9 +3096,12 @@ static int handle_options(struct tracecmd_input *handle)
 
 	}
 
-	handle->cpustats = cpustats;
+	ret = 0;
 
-	return 0;
+out:
+	if (comperss)
+		in_uncompress_reset(handle);
+	return ret;
 }
 
 static int read_options_type(struct tracecmd_input *handle)
-- 
2.31.1


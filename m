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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 892C4C4320E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A80E6101B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236669AbhG1Nd3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236645AbhG1Nd2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:28 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6733CC061764
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:26 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id o5so4673877ejy.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A8ehixIC+OX5rbrQ3cu/o55UHWZmCB24DttcFrYX6kk=;
        b=ZGSH3lwLF+x2vob+ZE73hotWSBO7oKDyjmXJ9N6IlaE7Um41KYsAbqR1piYpXsOidt
         hSxDsFInOJ5B03688qzqUdbSDPLG/XsGmErLx4//fcEV4ALLsysPAtINqqXGZ0punvni
         p+nWfVy3+uYeshaN6mHMax1h7z/KFeaiSA1jL2SAClBETZVxiNq4IrR0PBxi/xRJBX6r
         in7IZV4ImrkxT5zdQgAuQKNeJv3jboxM4BgPAcAeE4aXwlYNjY+QsVHw/anO2mTU7+tn
         50p5ocEZNULQ1FbZYzNfpaQ9NdxWXi7KoaJMtQbJOKuc0Z37X21bI5ICodvT5HsFUYnL
         4JtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A8ehixIC+OX5rbrQ3cu/o55UHWZmCB24DttcFrYX6kk=;
        b=eCHaDrlubJo0p2SMLzfCyfJu0kkjIc/5dSxc3AQiz/3c25eDVD2nHBQQ7ed4hXL2mP
         dvS/Kh37ebeZj4B71JV/Tnd/96ZFezepWNG6RRysNaaetUYe/t9MiOtZ5jvpvxBARRjt
         zHI79gK/qhXh1R8LGOr+HaptESMaxwO/KH9eiWs4WxZSZbQRGQ0MTs5z+iBfiQJTo77F
         U8Jd94zuwc2MBZn6TAElJsqmvrvu+8uHsWB9MOscf4kLSpTli+dGI9yXUEnVd4C9L6OW
         0ixobddZt3moDsQCrEdYbRArm1GQkLQOmnI4hpDM0xigrxUChL2fnRvfReZ+fHn2u3PU
         lZuw==
X-Gm-Message-State: AOAM530h3nkCc39D59lLmv3MkjqwfHttFROvcETbg6K8PT//wZlvx473
        l+w1hiG5OlBXEiVW9R50NW0=
X-Google-Smtp-Source: ABdhPJxNBw5HAvs/CXV4g6qfERw3GgzFLegL7zKCJ7VjgXCFvd2CA1gKS8LK9Mi1Y5bJVgQPYkq8OQ==
X-Received: by 2002:a17:907:970f:: with SMTP id jg15mr7713876ejc.175.1627479205054;
        Wed, 28 Jul 2021 06:33:25 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:33:24 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 33/87] trace-cmd library: Add macro to check file state on reading
Date:   Wed, 28 Jul 2021 16:31:56 +0300
Message-Id: <20210728133250.234140-34-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Trace file version 7 has flexible structure. It allows reading almost
any part of the file at any time, unlike the version 6 file when reading
state must be validated at each step. Added a macro to handle these
checks.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 28eb4d1e..b858a256 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -166,6 +166,8 @@ struct tracecmd_input {
 
 __thread struct tracecmd_input *tracecmd_curr_thread_handle;
 
+#define CHECK_READ_STATE(H, S) ((H)->file_version < 7 && (H)->file_state >= (S))
+
 static int read_options_type(struct tracecmd_input *handle);
 
 void tracecmd_set_flag(struct tracecmd_input *handle, int flag)
@@ -416,7 +418,7 @@ static int read_header_files(struct tracecmd_input *handle)
 	char *header;
 	char buf[BUFSIZ];
 
-	if (handle->file_state >= TRACECMD_FILE_HEADERS)
+	if (CHECK_READ_STATE(handle, TRACECMD_FILE_HEADERS))
 		return 0;
 
 	if (do_read_check(handle, buf, 12))
@@ -623,7 +625,7 @@ static int read_ftrace_files(struct tracecmd_input *handle, const char *regex)
 	int unique;
 	int ret;
 
-	if (handle->file_state >= TRACECMD_FILE_FTRACE_EVENTS)
+	if (CHECK_READ_STATE(handle, TRACECMD_FILE_FTRACE_EVENTS))
 		return 0;
 
 	if (regex) {
@@ -694,7 +696,7 @@ static int read_event_files(struct tracecmd_input *handle, const char *regex)
 	int unique;
 	int ret;
 
-	if (handle->file_state >= TRACECMD_FILE_ALL_EVENTS)
+	if (CHECK_READ_STATE(handle, TRACECMD_FILE_ALL_EVENTS))
 		return 0;
 
 	if (regex) {
@@ -779,7 +781,7 @@ static int read_proc_kallsyms(struct tracecmd_input *handle)
 	unsigned int size;
 	char *buf;
 
-	if (handle->file_state >= TRACECMD_FILE_KALLSYMS)
+	if (CHECK_READ_STATE(handle, TRACECMD_FILE_KALLSYMS))
 		return 0;
 
 	if (read4(handle, &size) < 0)
@@ -810,7 +812,7 @@ static int read_ftrace_printk(struct tracecmd_input *handle)
 	unsigned int size;
 	char *buf;
 
-	if (handle->file_state >= TRACECMD_FILE_PRINTK)
+	if (CHECK_READ_STATE(handle, TRACECMD_FILE_PRINTK))
 		return 0;
 
 	if (read4(handle, &size) < 0)
@@ -856,7 +858,7 @@ static int read_cpus(struct tracecmd_input *handle)
 {
 	unsigned int cpus;
 
-	if (handle->file_state >= TRACECMD_FILE_CPU_COUNT)
+	if (CHECK_READ_STATE(handle, TRACECMD_FILE_CPU_COUNT))
 		return 0;
 
 	if (read4(handle, &cpus) < 0)
@@ -2862,7 +2864,7 @@ static int read_options_type(struct tracecmd_input *handle)
 {
 	char buf[10];
 
-	if (handle->file_state >= TRACECMD_FILE_CPU_LATENCY)
+	if (CHECK_READ_STATE(handle, TRACECMD_FILE_CPU_LATENCY))
 		return 0;
 
 	if (do_read_check(handle, buf, 10))
@@ -3026,7 +3028,7 @@ static int read_and_parse_cmdlines(struct tracecmd_input *handle)
 	unsigned long long size;
 	char *cmdlines;
 
-	if (handle->file_state >= TRACECMD_FILE_CMD_LINES)
+	if (CHECK_READ_STATE(handle, TRACECMD_FILE_CMD_LINES))
 		return 0;
 
 	if (read_data_and_size(handle, &cmdlines, &size) < 0)
-- 
2.31.1


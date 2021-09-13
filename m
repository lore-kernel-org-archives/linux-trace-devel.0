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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EA86C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:30:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85B8560F6D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:30:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240005AbhIMMbU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240001AbhIMMbU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:31:20 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A3BDC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:30:04 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id d6so14398179wrc.11
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M8YlL1SlQNYrxnekGaIBaXbmG7rEz6Zt19sqQpUN2hk=;
        b=g6Uyh9FoSbjjB2mFFhJbgddVYPlFDIqFZkF8WpQv7P390bXUuYvUgPd1lnrGjZbf5R
         YqH/MiJnOVppkXu5jnPjV/4958ZxXBhKzyf4cr8k8x/dAfn9vCIscio7MK7RsZD9HHj/
         JZ1It8KZTbdS0Bcc5k4g2kraQCriWp/Yab+gVdq/iLNlHQc1CMwulwcxoJyNgaBLdbxM
         lZ4RamavqhsvPg+GCsM3bSvIywBQ8FPi8990NPz03ttp7Slmb/w/CLgXON9kKjMHdMzH
         MqgHBU/iK33564RRQeyli2HhF9cZJCM/lPdnvTCvKmVAv6QbMl7UHAKgz+7dldXoLN1e
         oH2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M8YlL1SlQNYrxnekGaIBaXbmG7rEz6Zt19sqQpUN2hk=;
        b=RSDwasTIaSHY7pE0x5+zc4gZEgZrTL1ZrWHpFzuaJo13IzWwLsF8FjuN144psWjR53
         I1Wh0kknR3z7/V3AZ7u0BqUztrlljYMvVQofBFLrc5Gg4vG/Ea899rlCvk6OUGiuRbXH
         KfAUOo3pbsne4IrK1R9Q2xLw+xB9EMhtdAyQel1sFHOrwaYLOQD8qZ2SPKvt3T1uOPdB
         D27vojz4v206nAm55sHUPNSj26Dh//TyXM1Rrfb0bzluUF9q47NWMIeJgEP4MBx/Qz05
         TbMGykvWYZ0lvjqPYJoopikpLoHCokbb/5mfHnZRZmak1k2QCzhVaRFH+AL8tKfX1qix
         u6hg==
X-Gm-Message-State: AOAM532MB4PzT1F+b1ODfQDxugSmu6W9z4cm0zWYB13jOIOQLt0lw4PV
        BEf0Cno7R8dvwwO7eVYXiuIjv5kj/kY=
X-Google-Smtp-Source: ABdhPJzt15LX0IQi2L7viabRI/1UrUUl0M6wmbcNbFnVLvuTXUaFF27+TbVYWedlDTDfbRQTmA4CuA==
X-Received: by 2002:adf:dd46:: with SMTP id u6mr2016344wrm.393.1631536202734;
        Mon, 13 Sep 2021 05:30:02 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z5sm6842030wmf.33.2021.09.13.05.30.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:30:02 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 13/25] trace-cmd library: Add macro to check file state on reading
Date:   Mon, 13 Sep 2021 15:29:35 +0300
Message-Id: <20210913122947.3673239-14-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913122947.3673239-1-tz.stoyanov@gmail.com>
References: <20210913122947.3673239-1-tz.stoyanov@gmail.com>
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
index de8e0d72..85100aa4 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -165,6 +165,8 @@ struct tracecmd_input {
 
 __thread struct tracecmd_input *tracecmd_curr_thread_handle;
 
+#define CHECK_READ_STATE(H, S) ((H)->file_version < FILE_VERSION_SECTIONS && (H)->file_state >= (S))
+
 static int read_options_type(struct tracecmd_input *handle);
 
 void tracecmd_set_flag(struct tracecmd_input *handle, int flag)
@@ -381,7 +383,7 @@ static int read_header_files(struct tracecmd_input *handle)
 	char *header;
 	char buf[BUFSIZ];
 
-	if (handle->file_state >= TRACECMD_FILE_HEADERS)
+	if (CHECK_READ_STATE(handle, TRACECMD_FILE_HEADERS))
 		return 0;
 
 	if (do_read_check(handle, buf, 12))
@@ -587,7 +589,7 @@ static int read_ftrace_files(struct tracecmd_input *handle, const char *regex)
 	int unique;
 	int ret;
 
-	if (handle->file_state >= TRACECMD_FILE_FTRACE_EVENTS)
+	if (CHECK_READ_STATE(handle, TRACECMD_FILE_FTRACE_EVENTS))
 		return 0;
 
 	if (regex) {
@@ -660,7 +662,7 @@ static int read_event_files(struct tracecmd_input *handle, const char *regex)
 	int unique;
 	int ret;
 
-	if (handle->file_state >= TRACECMD_FILE_ALL_EVENTS)
+	if (CHECK_READ_STATE(handle, TRACECMD_FILE_ALL_EVENTS))
 		return 0;
 
 	if (regex) {
@@ -745,7 +747,7 @@ static int read_proc_kallsyms(struct tracecmd_input *handle)
 	char *buf = NULL;
 	int ret;
 
-	if (handle->file_state >= TRACECMD_FILE_KALLSYMS)
+	if (CHECK_READ_STATE(handle, TRACECMD_FILE_KALLSYMS))
 		return 0;
 
 	ret = read4(handle, &size);
@@ -781,7 +783,7 @@ static int read_ftrace_printk(struct tracecmd_input *handle)
 	char *buf = NULL;
 	int ret;
 
-	if (handle->file_state >= TRACECMD_FILE_PRINTK)
+	if (CHECK_READ_STATE(handle, TRACECMD_FILE_PRINTK))
 		return 0;
 
 	ret = read4(handle, &size);
@@ -832,7 +834,7 @@ static int read_cpus(struct tracecmd_input *handle)
 {
 	unsigned int cpus;
 
-	if (handle->file_state >= TRACECMD_FILE_CPU_COUNT)
+	if (CHECK_READ_STATE(handle, TRACECMD_FILE_CPU_COUNT))
 		return 0;
 
 	if (read4(handle, &cpus) < 0)
@@ -2838,7 +2840,7 @@ static int read_options_type(struct tracecmd_input *handle)
 {
 	char buf[10];
 
-	if (handle->file_state >= TRACECMD_FILE_CPU_LATENCY)
+	if (CHECK_READ_STATE(handle, TRACECMD_FILE_CPU_LATENCY))
 		return 0;
 
 	if (do_read_check(handle, buf, 10))
@@ -3004,7 +3006,7 @@ static int read_and_parse_cmdlines(struct tracecmd_input *handle)
 	char *cmdlines = NULL;
 	int ret;
 
-	if (handle->file_state >= TRACECMD_FILE_CMD_LINES)
+	if (CHECK_READ_STATE(handle, TRACECMD_FILE_CMD_LINES))
 		return 0;
 
 	ret = read_data_and_size(handle, &cmdlines, &size);
-- 
2.31.1


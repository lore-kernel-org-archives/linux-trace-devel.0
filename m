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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD318C4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:51:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFB13611CB
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:51:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233745AbhIJNwb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 09:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233775AbhIJNw3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 09:52:29 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC462C061762
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:51:16 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id 9so2578679edx.11
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GTNY+w2TfddmUI44dncu5siS53lj8GzdRia/nNGWE7A=;
        b=q6Ohq2/+d582eRwOF2eziPZT8y9pLpU7nPbGu0t5DS0F7b4fNXh3Arplx281oLlYjf
         6CLcrWpeYH3RBYu+8ctGMkx/hLZ0a6/1F/caZ+2i0pq/dreM9QMs2EZlsGZH7rgnX+he
         gDO2DBT41LOEaU7kUIcFAaxSP8CztFfgHxnin5WFm5whZk5Vgk4I9MAsrvRn99cyXv9W
         hfaqbW3beoA4JeJec9M/QEuBf33KjzPo0yThuLq3u9hoi/qvrTfzxqckp6s3cfxGDs65
         GT6vqr+/sqe5/KCn6chPe6ClGg/ZjzD6Hwqp6zVLCdV9HFT4mkikELIFYLYWS9LAS2cU
         Ej3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GTNY+w2TfddmUI44dncu5siS53lj8GzdRia/nNGWE7A=;
        b=3muTgPZkCb1oUc8O3wMz+yUrroznILOrd13jzvDog1WCanh5IOh0cGWIvdRuOhF0kn
         YUpniJ4ROMDtgoPHpJvVLGmaw46KsdgseO/2xq3s8gruZJlbbO4vk5mq7mAdOQX3mDSD
         t8kUBF9zqF/RYUC4F78NYFwSPX1q4jRhQ24QnGBMkRehalJTQSOBFlm3Vc9ABeHZ/9WK
         28gsggJYZa6At0+RmNxlnHF8FaIzu5tFlZuwEK6CjKYMB3txP3Lehav4FJF02gH46SAt
         z7jYMSm704Z+9/dipj2v0a8QI7UavZPizlh2RxyObghjNpUpY3GvjJA/lOwdO5qzj16/
         ldVQ==
X-Gm-Message-State: AOAM531FLex95Vw2vtxx2aU88hl5EtKU2u0HbvdRdqR88yu7fmzzo1NK
        luwOGYaNLPmWjZeT/uzK3KM1FTN6rmM=
X-Google-Smtp-Source: ABdhPJyVbLmiAu2EJJoDDyRLd+u+2P7pGmu/hd01SHGTIssVChMyVK3H9hFof1NYX+iNahpjgtsQjA==
X-Received: by 2002:a05:6402:19a:: with SMTP id r26mr9329275edv.230.1631281875486;
        Fri, 10 Sep 2021 06:51:15 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w13sm2484683ejc.100.2021.09.10.06.51.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 06:51:15 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 13/25] trace-cmd library: Add macro to check file state on reading
Date:   Fri, 10 Sep 2021 16:50:49 +0300
Message-Id: <20210910135101.2865226-14-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210910135101.2865226-1-tz.stoyanov@gmail.com>
References: <20210910135101.2865226-1-tz.stoyanov@gmail.com>
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
index 48931f2c..edb5ddb2 100644
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
@@ -2840,7 +2842,7 @@ static int read_options_type(struct tracecmd_input *handle)
 {
 	char buf[10];
 
-	if (handle->file_state >= TRACECMD_FILE_CPU_LATENCY)
+	if (CHECK_READ_STATE(handle, TRACECMD_FILE_CPU_LATENCY))
 		return 0;
 
 	if (do_read_check(handle, buf, 10))
@@ -3006,7 +3008,7 @@ static int read_and_parse_cmdlines(struct tracecmd_input *handle)
 	char *cmdlines = NULL;
 	int ret;
 
-	if (handle->file_state >= TRACECMD_FILE_CMD_LINES)
+	if (CHECK_READ_STATE(handle, TRACECMD_FILE_CMD_LINES))
 		return 0;
 
 	ret = read_data_and_size(handle, &cmdlines, &size);
-- 
2.31.1


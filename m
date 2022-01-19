Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88301C433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:25:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352393AbiASIZa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:25:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352370AbiASIZY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:25:24 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ABFEC06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:25:23 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id c71so7589121edf.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:25:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ydecgpCjx+5Q/YsLWcwO/BA1/5xVLF2taCoipK09S+U=;
        b=IULEt4+nk9SWk7BfVdv4e8jOBbmvBtUZD2hnRA6JpgqAXSGCrobM5WA2yUNIFN8DeR
         RMvu4g67CfP0IDP4ljhgN8tH9cratT7CibUBXkqY0obqfhoa6KNHML9jmSwU7B2IBLQU
         zbZx6g3AGvCz/H3M5xPS4pQBObGSGLFVx2vFqouE/VOOFgKWDw/LJj0qpUKl3/gijRq4
         Om2/8GejZUHCHgW6ynpTi9HiFvH4/nv/TvgqhuqJyasy0T+l6OEX9vc6+0m0ST82KX6H
         taN0QHHqVVIRuCpz7SCcwwg32hCsO1Z1G2Xq6n34/fTn8v2y+0KCYVj8avye2tAjQIes
         9lTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ydecgpCjx+5Q/YsLWcwO/BA1/5xVLF2taCoipK09S+U=;
        b=miPnZW5zFHZhNXKmuUZNuHtsAanV0NiQZXyGVFtS58v3hIKcni0n9QRxpyikVMm1H+
         nTQNbNoKRGsEEixhZH3ToDth0fjVLpL1cGWQispfbtic0l+B0ieW8GKxBBVNQ0uVEmZW
         XiUBHtvtbe3afN9KrfSZ7CebCnc3eRBu/S8sRPz3Ol3GlZL20mvRlMaA/KBov+gc/3/N
         2Ri1SglenDR4cLNnKI6lxLDJt9uqLqQk/vyNEYZctTzVNnueculZy5ik4A0HBCUyWFEL
         BMjhw3hxJCJBvqrgSGSrkcQGfHZvXg8+XfWU0sOe2lGuTG1blfQMayCPOOaPhAIaOFx3
         XA9Q==
X-Gm-Message-State: AOAM532+Px/pprh6kHkcSXMQ9sS6ant6HyOqBzyYMGHtsiay58m1z9qy
        B8TqKIv3SvHt/G/QCfV4d7yrofhma0M=
X-Google-Smtp-Source: ABdhPJyav0MEo24LX8IGdLNuSbWw2S+Hmx+xRK1bHvxSDbq+lsG2fF5620jJ/iBICjZal5SWkKtMZA==
X-Received: by 2002:a17:907:972a:: with SMTP id jg42mr24619692ejc.757.1642580722265;
        Wed, 19 Jan 2022 00:25:22 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l1sm5011122ejf.44.2022.01.19.00.25.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:25:21 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 12/25] trace-cmd library: Add macro to check file state on reading
Date:   Wed, 19 Jan 2022 10:24:54 +0200
Message-Id: <20220119082507.245600-13-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119082507.245600-1-tz.stoyanov@gmail.com>
References: <20220119082507.245600-1-tz.stoyanov@gmail.com>
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
index c7998301..50eaa5c0 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -166,6 +166,8 @@ struct tracecmd_input {
 
 __thread struct tracecmd_input *tracecmd_curr_thread_handle;
 
+#define CHECK_READ_STATE(H, S) ((H)->file_version < FILE_VERSION_SECTIONS && (H)->file_state >= (S))
+
 static int read_options_type(struct tracecmd_input *handle);
 
 void tracecmd_set_flag(struct tracecmd_input *handle, int flag)
@@ -382,7 +384,7 @@ static int read_header_files(struct tracecmd_input *handle)
 	char *header;
 	char buf[BUFSIZ];
 
-	if (handle->file_state >= TRACECMD_FILE_HEADERS)
+	if (CHECK_READ_STATE(handle, TRACECMD_FILE_HEADERS))
 		return 0;
 
 	if (do_read_check(handle, buf, 12))
@@ -588,7 +590,7 @@ static int read_ftrace_files(struct tracecmd_input *handle, const char *regex)
 	int unique;
 	int ret;
 
-	if (handle->file_state >= TRACECMD_FILE_FTRACE_EVENTS)
+	if (CHECK_READ_STATE(handle, TRACECMD_FILE_FTRACE_EVENTS))
 		return 0;
 
 	if (regex) {
@@ -661,7 +663,7 @@ static int read_event_files(struct tracecmd_input *handle, const char *regex)
 	int unique;
 	int ret;
 
-	if (handle->file_state >= TRACECMD_FILE_ALL_EVENTS)
+	if (CHECK_READ_STATE(handle, TRACECMD_FILE_ALL_EVENTS))
 		return 0;
 
 	if (regex) {
@@ -745,7 +747,7 @@ static int read_proc_kallsyms(struct tracecmd_input *handle)
 	unsigned int size;
 	char *buf;
 
-	if (handle->file_state >= TRACECMD_FILE_KALLSYMS)
+	if (CHECK_READ_STATE(handle, TRACECMD_FILE_KALLSYMS))
 		return 0;
 
 	if (read4(handle, &size) < 0)
@@ -778,7 +780,7 @@ static int read_ftrace_printk(struct tracecmd_input *handle)
 	unsigned int size;
 	char *buf;
 
-	if (handle->file_state >= TRACECMD_FILE_PRINTK)
+	if (CHECK_READ_STATE(handle, TRACECMD_FILE_PRINTK))
 		return 0;
 
 	if (read4(handle, &size) < 0)
@@ -826,7 +828,7 @@ static int read_cpus(struct tracecmd_input *handle)
 {
 	unsigned int cpus;
 
-	if (handle->file_state >= TRACECMD_FILE_CPU_COUNT)
+	if (CHECK_READ_STATE(handle, TRACECMD_FILE_CPU_COUNT))
 		return 0;
 
 	if (read4(handle, &cpus) < 0)
@@ -2829,7 +2831,7 @@ static int read_options_type(struct tracecmd_input *handle)
 {
 	char buf[10];
 
-	if (handle->file_state >= TRACECMD_FILE_CPU_LATENCY)
+	if (CHECK_READ_STATE(handle, TRACECMD_FILE_CPU_LATENCY))
 		return 0;
 
 	if (do_read_check(handle, buf, 10))
@@ -2994,7 +2996,7 @@ static int read_and_parse_cmdlines(struct tracecmd_input *handle)
 	unsigned long long size;
 	char *cmdlines;
 
-	if (handle->file_state >= TRACECMD_FILE_CMD_LINES)
+	if (CHECK_READ_STATE(handle, TRACECMD_FILE_CMD_LINES))
 		return 0;
 
 	if (read_data_and_size(handle, &cmdlines, &size) < 0)
-- 
2.34.1


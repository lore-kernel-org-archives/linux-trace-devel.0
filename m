Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B936C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:22:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358162AbhLBMZm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:25:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358013AbhLBMZ3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:25:29 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB0CC0613F1
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:22:06 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id t5so115414980edd.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:22:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HBQ21A+hDDClbh44U63m7ICaBf9ViJ8+cNcu7iK/WBs=;
        b=Z8OjL+Yy3SVvO/QJMyBnb9hqh720n5AtbCJIYX0PFl+9/wB34ULXNraBPfihByG2eT
         sIfQ6fbflAFarEO2S9B9sXcAiFaxsrLa1GgmzR8J2HtL8t/AvZLI6yRx43InNfJj8DQk
         ts2gqYq3ijYW0lZZSm/91w7HwfZbO+hohf9OInFVtipzZZjEjnUIQKrbkk/KPn1XsfPh
         +oUu1qWkeHxSIrz/dFe7y5z2Ceuy2tYS1hmQ38+V2HWogIn4k6s6exYaSuXvm4NsYGz4
         PBS6V8SqqhgBNj4rBuksT8m5OoRd9cnxA/y5/vTMf+v7KsCiJp6W4Mlb9psfkSvIYARP
         jxIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HBQ21A+hDDClbh44U63m7ICaBf9ViJ8+cNcu7iK/WBs=;
        b=UTZQPWCmD/7ftwwOTudVRtx3HHUczGcwJek2/3Y6ZVnssJBFYH3uc1r1V+2Vz7MpeV
         uXBOD0eL3sFqsrZUOh1bWO9Sb0utHQSAHQG5b+mbd+aKsojMnT6nAoj2ZjadhaEcIxjT
         Xbq3lEcHCW3WjrukMR91jtDvJDUIzCIBfxnkw+Arx2ZgHB1l8uNfZa6GXP7FR6rl/hXV
         T0m754qpHfU7R54qpVl3tNnM0v6yuCZ3FCYQBqmkJ4NvKL/99JS/ROvTk4D8L+svfi2K
         SFQHsZ/qry6MVN7OmUIPB8cTP9ChV4L4D6G3GeL9r0IxyaJlF4R+L+wmbdFgt/vyWNic
         fyhw==
X-Gm-Message-State: AOAM531VXk4PJLOklG4a9VVWcYArt3cKMT0YIXKydW3LeSz7Yu4BQR8D
        i4tP+rG7PkzNz3/4EPw1MJrk2G8P366m0w==
X-Google-Smtp-Source: ABdhPJwuQY/aIHxau20DggS9063pbiI+4+RapONIoFldAnDcLeca3KsIoW5knRfrvOpkczwjr235GA==
X-Received: by 2002:a50:fe1a:: with SMTP id f26mr16957250edt.132.1638447725238;
        Thu, 02 Dec 2021 04:22:05 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gb42sm1892772ejc.49.2021.12.02.04.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:22:04 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 11/23] trace-cmd library: Add macro to check file state on reading
Date:   Thu,  2 Dec 2021 14:21:40 +0200
Message-Id: <20211202122152.43275-12-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122152.43275-1-tz.stoyanov@gmail.com>
References: <20211202122152.43275-1-tz.stoyanov@gmail.com>
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
index 31e5e674..0375afba 100644
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
2.33.1


Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BF49C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 10:55:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237063AbhLJK6i (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 05:58:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236851AbhLJK6h (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 05:58:37 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B360DC061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:55:02 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id z5so29158260edd.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:55:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HBQ21A+hDDClbh44U63m7ICaBf9ViJ8+cNcu7iK/WBs=;
        b=m/8Q25rLtiBEoYeYgMe6XPTJWinapyZqihgNwDst8Tu/GH+EZCRVGkWpnznW95Yijn
         tT1zXxXBhchYuOjb/S3NiYF7X2ITb3fmRTPmR0YdF8/QgrZtRX7AzFUh7Vrih4InShi6
         LZ1Wu9y+lKajCQGSFrxcWqdqFAPfeTPAYXIro40k6EEBT0UEzr37W89+Un4UxcnZMTT+
         lt82PYLWuhVcJ/BVVDNNsCJoNcw72gM3+f6/r/4A8yLVlrLZoSCMrUmGulJPp3LANF0q
         Bx/d0RcSj/ks9rqFYW5ZIu3h3mzwJt4g4nOBJ5WHmEn0CZ8v61/ncgTJI79y65pdA/Nz
         oNxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HBQ21A+hDDClbh44U63m7ICaBf9ViJ8+cNcu7iK/WBs=;
        b=J+0SJkquVb3LHqitM9foSaTP/6L0izZAoO09cqG6B4u+iYWVKe9SuAT53x6gsc/FEy
         BfYsyGxlgyTPVki+r2xB+EOo9jma1omSdIorsZhpv+RDEYMwfSR06jMi3ENRMqRIMLfF
         AqAgeNrebMb5zJlzLdbDJPEoq44NgCqVTUEaoePK+HLRGGSEdgHkR3VCsM3KgIOn8d84
         yuvMDEhnFycIcxm91Qe3xOirSsqc2htxDHrxleWXO4kBDCdOwbmSNJzwZ2vQHByLJiR3
         wsdZYDSz56kWHiURbVQK1rEBoe9Vip0Sym9kIf1fzAOB5D97uQBkcVmL0LzyYE55fPEW
         W0cQ==
X-Gm-Message-State: AOAM532MfWuT/borWdpCxsX6DrZBlkLpX+CWPcfUAQ6nPASZdZN0xcj0
        WANB8Y+M/CFJ9uDwEh83zvhNdS4nxi8=
X-Google-Smtp-Source: ABdhPJxgZK6lcrUqlGLSROvWEoLNsC7cPT3MsyQmpxoz6tCzopSX63LsldbFp++RmAt+xw9RHui95A==
X-Received: by 2002:a05:6402:22a5:: with SMTP id cx5mr36708451edb.334.1639133701295;
        Fri, 10 Dec 2021 02:55:01 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id x7sm1306314edd.28.2021.12.10.02.55.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 02:55:00 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 12/25] trace-cmd library: Add macro to check file state on reading
Date:   Fri, 10 Dec 2021 12:54:35 +0200
Message-Id: <20211210105448.97850-13-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210105448.97850-1-tz.stoyanov@gmail.com>
References: <20211210105448.97850-1-tz.stoyanov@gmail.com>
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


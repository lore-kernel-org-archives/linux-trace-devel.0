Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5E7FC433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:20:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EDA3610CE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:20:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237470AbhJHEWL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237473AbhJHEWK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:22:10 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF68C061760
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:20:15 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id i20so15191362edj.10
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j439jX5+zRpwDHCiJw0sGhX2zJ6J9bQI/D+SAuuR3oQ=;
        b=FeRjFHLmw+vzjQsRjNYDTYQ0xzmqrfGPcyhEGP0pDKMcaqCerhRoKyli65gFhuuBp9
         +lFdBT53lYq3vGiQP2GJhqXzv6BgJxoaKgTpNaRBsn32EWSV5BW6bu6JujAdSEStqCc/
         lutS4zO4mPBUaOaHBCItSEdq8S0on9MUHI5z/gJQmXbO8Z2uGZZ3vHSHl9GiZmN8jFst
         0ByYT3qajfE68Py7dxNbmJoPHEjgxw7kIMo6h/wW05QWfIpxn1XAHlF0Q1FONFHBYmR2
         DyGjm3F8utDrHU50tIyHp96VcU1drX8qKMUrerCaW1cFbR0Sk2xAAmHTYEIUjoN6Ur12
         hzAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j439jX5+zRpwDHCiJw0sGhX2zJ6J9bQI/D+SAuuR3oQ=;
        b=u40kFhATEkkajesmur7dcbwrHjbxec5qML0P7SxlIf3LCuCWUqaYCzGBjKLRkZRuc4
         O0leN+H18YtkDeAjtMdTgv2lsufydqjiUXWX5vj2FLAuqmG5F/S/UbXaFeUbU5ix2A5a
         JUqYLH/ukCq7nFdrLFtKcKTUSpqpWRuPPuMSaOhfP0/cFfG/wS/QYU6+8n5QbpQNHreT
         ofYKVfarXhOcFzakL+TUt3iQLfTPUd5sLosE191Jsed5P95/xhY/Fjt4ME+vVtDg6urI
         fknXM13XrqBHpvexOFjCYY9Dh+Bnvh4ZHUmD77Mub7AQJEoOGJbsNtj6DW0LgG4fkYBi
         AdFw==
X-Gm-Message-State: AOAM531hGyFSdDmMOCUkSZaYVTg+M7OMhTGw6b9+qviHW046DgwPxZxI
        z5MMOhiUxRZQsgqzm12xOBGmsX1pr10CmA==
X-Google-Smtp-Source: ABdhPJyeU7aXBss+HRdZ8PbA/kdlDScphGmeDArL+Rqt5psGp1oQh6+Qaht0l7Cewr28NdtAS6s4Cg==
X-Received: by 2002:a05:6402:7d0:: with SMTP id u16mr11813278edy.62.1633666814023;
        Thu, 07 Oct 2021 21:20:14 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p6sm511669edi.18.2021.10.07.21.20.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:20:13 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 13/25] trace-cmd library: Add macro to check file state on reading
Date:   Fri,  8 Oct 2021 07:19:46 +0300
Message-Id: <20211008041958.976309-14-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008041958.976309-1-tz.stoyanov@gmail.com>
References: <20211008041958.976309-1-tz.stoyanov@gmail.com>
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
index 38c7a3b8..e7e86c14 100644
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
@@ -744,7 +746,7 @@ static int read_proc_kallsyms(struct tracecmd_input *handle)
 	unsigned int size;
 	char *buf;
 
-	if (handle->file_state >= TRACECMD_FILE_KALLSYMS)
+	if (CHECK_READ_STATE(handle, TRACECMD_FILE_KALLSYMS))
 		return 0;
 
 	if (read4(handle, &size) < 0)
@@ -777,7 +779,7 @@ static int read_ftrace_printk(struct tracecmd_input *handle)
 	unsigned int size;
 	char *buf;
 
-	if (handle->file_state >= TRACECMD_FILE_PRINTK)
+	if (CHECK_READ_STATE(handle, TRACECMD_FILE_PRINTK))
 		return 0;
 
 	if (read4(handle, &size) < 0)
@@ -825,7 +827,7 @@ static int read_cpus(struct tracecmd_input *handle)
 {
 	unsigned int cpus;
 
-	if (handle->file_state >= TRACECMD_FILE_CPU_COUNT)
+	if (CHECK_READ_STATE(handle, TRACECMD_FILE_CPU_COUNT))
 		return 0;
 
 	if (read4(handle, &cpus) < 0)
@@ -2830,7 +2832,7 @@ static int read_options_type(struct tracecmd_input *handle)
 {
 	char buf[10];
 
-	if (handle->file_state >= TRACECMD_FILE_CPU_LATENCY)
+	if (CHECK_READ_STATE(handle, TRACECMD_FILE_CPU_LATENCY))
 		return 0;
 
 	if (do_read_check(handle, buf, 10))
@@ -2995,7 +2997,7 @@ static int read_and_parse_cmdlines(struct tracecmd_input *handle)
 	unsigned long long size;
 	char *cmdlines;
 
-	if (handle->file_state >= TRACECMD_FILE_CMD_LINES)
+	if (CHECK_READ_STATE(handle, TRACECMD_FILE_CMD_LINES))
 		return 0;
 
 	if (read_data_and_size(handle, &cmdlines, &size) < 0)
-- 
2.31.1


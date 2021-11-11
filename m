Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E308EC4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:11:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC31F610D0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:11:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbhKKPOI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:14:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233937AbhKKPOH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:14:07 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29616C061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:11:18 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id c8so25062589ede.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:11:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HBQ21A+hDDClbh44U63m7ICaBf9ViJ8+cNcu7iK/WBs=;
        b=o8ZgzhSiCw0VsbQ9JH55B3owv2CMI3Dyz5ar8AfQ7/GVtimgFe/ri6frRL63gK9Cx4
         SwBDM5FLClDMgeEpzGwq+k3bbG4jHOP7ptVVHgHMCqpciSSflHDDDEG99r1p9NqozX0s
         vJaG0FZQP3pys7Le51EWvlYRt5pOqpxg1k5Rcfu/HgAtDtZRMldHKsxEY6/CjQYaNZ2r
         jBm5Hn/d2fwAPd01AMqelJUXGQpNTDlo2cdjtVsxmALwPszqphnhC3Er4yT1i8NGXyR8
         J0UAPct/7DKAdE858uvGNEDKbSidqFJxszcPK1SSENkwuupNcSYJkjbNRGdRT9MLjG+a
         s8Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HBQ21A+hDDClbh44U63m7ICaBf9ViJ8+cNcu7iK/WBs=;
        b=F3rL/w1bBiXRQz8mD0RX9iSI1XB3WDA0ji0B6YRtOiQqWfwF/IbPJYbnn21FTPk3of
         32NRmCOluvwCTVvHW7v1OsygKolSa+/f/b27ZXq32bW0QvOYXX4ORL/X5+7ywJhx3AMy
         V3Zu3YsOIwYlcRH3OgpMT+2B+IOTTbx/+4H0dRmtk2k1apoUWXmyF4znEDs1/WZdTFM6
         TkCnqYZ9N32/0wh1z/K/VvRJMYiG0e/O0MPPGOHt5BlOQuhF6iHx44sg1muiXNGsK1sc
         JiMatwS/obsRhF3XMT+4IyUe5UToa9QTiVZ+4NWyHqAZixtdsTVhT3moW/55mUl/9vU2
         sycg==
X-Gm-Message-State: AOAM530rMQ0KlBNYauaq8VMnMgCsKvhNnmRJQo5ukaUp/LtrqnBo3VVm
        vDjLl0VYPTYSzsWSz8B5l/tMAMxKIsw9Xw==
X-Google-Smtp-Source: ABdhPJw0Mumg8jJtxERh44XZ21Bc0cIwFqENlN27graE3sXPy35wgqnrDw1YwxmBS95QZOZwQoJ5mw==
X-Received: by 2002:a17:907:2d10:: with SMTP id gs16mr9888646ejc.353.1636643476781;
        Thu, 11 Nov 2021 07:11:16 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id nc30sm1648803ejc.35.2021.11.11.07.11.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:11:16 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 13/25] trace-cmd library: Add macro to check file state on reading
Date:   Thu, 11 Nov 2021 17:11:06 +0200
Message-Id: <20211111151112.86751-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111151112.86751-1-tz.stoyanov@gmail.com>
References: <20211111151112.86751-1-tz.stoyanov@gmail.com>
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


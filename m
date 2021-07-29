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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E96DDC4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D31F461052
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233965AbhG2FKj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233782AbhG2FKi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:38 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28C6DC061765
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:35 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id nd39so8463978ejc.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hHTRLRkVeHPOPLN7JMHBp+dCdTrGhBJFy8HEkuTNVcU=;
        b=Ast5OoxcIl4tn5IVQkcygMzyrc76scEXYc7sKRVbAUpGvZYQQHXt7HtsIm2ZQHnEZJ
         oX+tcowZ+DEtJ3tV5XHIhYX73TZhQqqJvUMgY6NXUAMQeGaY3PpSsL7rHHFW6A81M8un
         5XWCRjm2b/SK25grFGQ1JT5XVIIiDsJFFd5sGBdpEiwevrpnU/4SVOHFf3JXAH+gI9qD
         9oDprQkXFtVp7rUz5MteZn9W+0kfQncEGDHWvd5QOeYztYktCDoTY5y2fyk7Go8k5x+P
         y7lGV5XwfkRtUVp2UOpGIHj6gHvxuxknsPHCybB+QXE0r3TaJtka49gPLcuO8SNeiFAa
         J4tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hHTRLRkVeHPOPLN7JMHBp+dCdTrGhBJFy8HEkuTNVcU=;
        b=AXjqNnfNejI/C7djz9IyaumFS8eLbLnwauvxGMb7jqQsj33aqjpm3ykoXBzFBS/EV8
         NNTbTgW/o/HbivdmE9g/q9FiYMQSMqGzV8PfoFuErIOTSvZ/UDC8wabfI2E0ibH78Ume
         l19VuanvyaRkiHUNClqLRGVP9iIxE8hslPXsqGAT+B9lJ492iQOXTEl5rl6NdfcWRtwd
         ceMehIu9qnfdlRKnU8DYO7s0o/HPYizjOSrWmhtp/1GhHfDZZ6+kxBlUeo9d+6flBWq2
         YQe7CW7weHBE2XkJxmx2hO3Ck2IE0ZSr+xKsGNfWVptaxAcj3K3dhcuDUESm8OBDmFQt
         n+yA==
X-Gm-Message-State: AOAM530b86cOcOQl0QnODDO3R1rlCzh5CUq/h6kIzZfsQRhQVkbCM21R
        ZOi0zzD4IEJeEHOllY6TIdRNczEiytsVTw==
X-Google-Smtp-Source: ABdhPJyZFIgARw4N5AsI1ntY9bKbFfFc0l9tRIyLirH9Q+U7RvR90TZiW9sY5hKwh5q3QWIDsehhjA==
X-Received: by 2002:a17:906:2b91:: with SMTP id m17mr2973616ejg.48.1627535433828;
        Wed, 28 Jul 2021 22:10:33 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:33 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 33/87] trace-cmd library: Add macro to check file state on reading
Date:   Thu, 29 Jul 2021 08:09:05 +0300
Message-Id: <20210729050959.12263-34-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
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
index c5b4c32e..6872f6ef 100644
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
@@ -622,7 +624,7 @@ static int read_ftrace_files(struct tracecmd_input *handle, const char *regex)
 	int unique;
 	int ret;
 
-	if (handle->file_state >= TRACECMD_FILE_FTRACE_EVENTS)
+	if (CHECK_READ_STATE(handle, TRACECMD_FILE_FTRACE_EVENTS))
 		return 0;
 
 	if (regex) {
@@ -693,7 +695,7 @@ static int read_event_files(struct tracecmd_input *handle, const char *regex)
 	int unique;
 	int ret;
 
-	if (handle->file_state >= TRACECMD_FILE_ALL_EVENTS)
+	if (CHECK_READ_STATE(handle, TRACECMD_FILE_ALL_EVENTS))
 		return 0;
 
 	if (regex) {
@@ -778,7 +780,7 @@ static int read_proc_kallsyms(struct tracecmd_input *handle)
 	unsigned int size;
 	char *buf;
 
-	if (handle->file_state >= TRACECMD_FILE_KALLSYMS)
+	if (CHECK_READ_STATE(handle, TRACECMD_FILE_KALLSYMS))
 		return 0;
 
 	if (read4(handle, &size) < 0)
@@ -809,7 +811,7 @@ static int read_ftrace_printk(struct tracecmd_input *handle)
 	unsigned int size;
 	char *buf;
 
-	if (handle->file_state >= TRACECMD_FILE_PRINTK)
+	if (CHECK_READ_STATE(handle, TRACECMD_FILE_PRINTK))
 		return 0;
 
 	if (read4(handle, &size) < 0)
@@ -855,7 +857,7 @@ static int read_cpus(struct tracecmd_input *handle)
 {
 	unsigned int cpus;
 
-	if (handle->file_state >= TRACECMD_FILE_CPU_COUNT)
+	if (CHECK_READ_STATE(handle, TRACECMD_FILE_CPU_COUNT))
 		return 0;
 
 	if (read4(handle, &cpus) < 0)
@@ -2861,7 +2863,7 @@ static int read_options_type(struct tracecmd_input *handle)
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


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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C709C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:14:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75F7A610A6
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:14:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233241AbhINNQQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233235AbhINNQO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:16:14 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 232E8C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:14:57 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id w29so19379557wra.8
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M8YlL1SlQNYrxnekGaIBaXbmG7rEz6Zt19sqQpUN2hk=;
        b=fpr+rgjZyjpiSSWWrxgrw88PV7oGoefAYnGovNDleuOH0AgB61ssa3eugkexSvQfL8
         Skk8mfNV6jIZBBQLeTJdDgdAscTnTd8VPxaThsKvuRALP4NPaO+Bk/sc4Prb1tdBdNiS
         j8INd6UBHQa9Lmo+aR0GIbfA62ukRTO9rnldnCKHlKzAqsqaNZZVjG0tfUiPR+At6Guz
         SkL09y5gMXNLmJZSw9TGzsbhvx2GpzeauFQSKU6FfKUJ/Y+hEF/dF35NovP5rci0r6oF
         mCCHYzBl+dfj4esDHuH4VaK8+PooVNVO1HkYDNpW5XvdNSRhcivwuvCQFFFW1zxOmxkO
         2JiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M8YlL1SlQNYrxnekGaIBaXbmG7rEz6Zt19sqQpUN2hk=;
        b=tsd/dMgwb4iW3WjyS2rkVKZMVP+aZKEugTkmm5cyPsUJ7z5oIbdwFsok/NMpbOsYu3
         0pRfdG77T5DV9X8b6NlXKn6sLrTd/nykKMKW3PcrUCwAZ97CrrQYfiySYm/4zeVhtsZd
         VbrrF0YKWjhjNyrM8SeE5OLV88TTkIYu/n/PH5cdLt1tzU9A2WXBsrRViRdVATT5Mt9P
         pisPWbCTZwTCMjV6JnaEm3kXnpEOM8nERZtk6Na6fizIMZqWa+i/jjkXwJCuk11IGd+Q
         cWCFipApU0oOqtl5I2QR1fgqrr1xi61wm431FokxPcQus7oI63lwMn8D250GQC+2Z4ud
         6tMw==
X-Gm-Message-State: AOAM5311a2FEK1TaxYjRcYxCrh40pI7KJ6K5liXfK23RyzN3DOVhuc0K
        mSDrKQt9hVqLeanNNhpjNDJtFKZLeI8=
X-Google-Smtp-Source: ABdhPJwcSKZ5y7RjI5rdE3JP+prVIv8BcjafEri57qF8/I9S9/i9j/j7JcTy2dRH+P47cHgAzQAWEw==
X-Received: by 2002:a05:6000:1287:: with SMTP id f7mr19092348wrx.221.1631625295716;
        Tue, 14 Sep 2021 06:14:55 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id y9sm1274760wmj.36.2021.09.14.06.14.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:14:54 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 13/25] trace-cmd library: Add macro to check file state on reading
Date:   Tue, 14 Sep 2021 16:14:26 +0300
Message-Id: <20210914131438.3965484-14-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131438.3965484-1-tz.stoyanov@gmail.com>
References: <20210914131438.3965484-1-tz.stoyanov@gmail.com>
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


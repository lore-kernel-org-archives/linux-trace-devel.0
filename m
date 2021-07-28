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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 701FEC4338F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B96060EC0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236659AbhG1Nd0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236645AbhG1NdZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:25 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F709C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:23 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id o5so4673644ejy.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YP3jhVGSPjqa15AFnGWCn3ConUuAPycu+JXnSVhNb3M=;
        b=HPUNzhXOtsR3rq0STx/iMzkuvgoX7SppWQu9LuvRSPmJ4sRVm5Mv115qnSLs66I4qA
         cYXyeO3BrtRzXG7NVQ1K0Sb36K4TNWBmeWI/ad4hN43KVRJT7l/AsCywzTgcG75JRlFp
         eVQbAbk0++PvEfPRnECaNlXvsbe9ZgUvP/MWt+K9d3Q5kvLy5hq9x4oU9jpoEoOYO7Fk
         HSC9ZKxh/31ZRNn3TBRhUXYd3gCGIF0Q3OnqU6kBpEWDjwlu0cnGOEAqX3oXTL+tuYAQ
         6dLHRyL4/N2JWvVivkQrLXn9wq0ebhY8p4x2AtjjIiog71ackT3kRbUO7y+7hzDPqS3h
         lx7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YP3jhVGSPjqa15AFnGWCn3ConUuAPycu+JXnSVhNb3M=;
        b=NWAyUyzi4PJiQS/A0B+qOY9M5R8AXIrOAiSysf1InuQtw8DhXY9X6rBO57NaFhBmGf
         ldTZq8VSHnZfvp3/Yy6BNjcU9JPWZ1Q++NrnTX9G57sMLD5dWk0aEjQRMQI7MKS3w3Rv
         X08s3pOgtDBr2f9ZAhs5/1JOEGSrcsrByGEgVnMtSGzWpF9tfDlXe66/aHnUJx7ik8SY
         P9L/WsfWfV1vX4raMLFyk9bbwQhkoVgph9zDpff8fdqJKFGNltSsBDAiDi0W6f6n1teS
         Enje1DIkqqqnOTcG46S9ut/7Dl8FYru1Kr6wWVzbPEpjUXbrxs79wXJE1x92mi7k1f27
         fQNA==
X-Gm-Message-State: AOAM532sMYOWgOtNC24Co5svpcGxJUaigZWjZgp6kZMeDR2/3Z4en2Pp
        wxUCJkhwuxsfU3OOZH8MadUvVoV/YXICiw==
X-Google-Smtp-Source: ABdhPJxs50reInAgJf9pxGFlDzxqbXfUuTBYi/BwnQGI3seKLz0U9HHXMW9Wc6XZyKeUkqW30lBD/A==
X-Received: by 2002:a17:907:1b29:: with SMTP id mp41mr27368458ejc.459.1627479202171;
        Wed, 28 Jul 2021 06:33:22 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.33.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:33:21 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 30/87] trace-cmd library: Add section header before flyrecord trace data
Date:   Wed, 28 Jul 2021 16:31:53 +0300
Message-Id: <20210728133250.234140-31-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In trace file version 7, write a section header at the beginning of each
section with flyrecord trace data.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 3470e6dc..e027dd93 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2142,10 +2142,12 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 				int cpus, struct cpu_data_source *data, const char *buff_name)
 {
 	struct data_file_write *data_files = NULL;
+	enum tracecmd_section_flags flags = 0;
 	tsize_t data_offs, offset;
 	unsigned long long endian8;
 	unsigned long long read_size;
 	char *clock;
+	char *str;
 	int ret;
 	int i;
 
@@ -2164,6 +2166,16 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 	if (handle->file_version < 7 && do_write_check(handle, "flyrecord", 10))
 		goto out_free;
 
+	if (handle->compress)
+		flags |= TRACECMD_SEC_FL_COMPRESS;
+	if (asprintf(&str, "buffer flyrecord %s", buff_name) < 1)
+		goto out_free;
+
+	offset = out_write_section_header(handle, TRACECMD_OPTION_BUFFER, str, flags, false);
+	free(str);
+	if (offset == (off_t)-1)
+		goto out_free;
+
 	data_files = calloc(cpus, sizeof(struct data_file_write));
 	if (!data_files)
 		goto out_free;
@@ -2244,6 +2256,9 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 	if (do_lseek(handle, 0, SEEK_END) == (off64_t)-1)
 		goto out_free;
 
+	if (out_update_section_header(handle, offset))
+		goto out_free;
+
 	free(data_files);
 	handle->file_state = TRACECMD_FILE_CPU_FLYRECORD;
 
-- 
2.31.1


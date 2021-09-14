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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6752AC433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:14:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51156610E6
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:14:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233254AbhINNQL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233235AbhINNQJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:16:09 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 682BCC061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:14:52 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id t18so20200207wrb.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bZYW/4C9hB/Gnz9nbQ499Xz+kEDrIm9y7WAFhfj/BVU=;
        b=lpW2xKKoESggUjpj/GkMFUA1UbFe7zOEuqvKDSzvU6JyyG+jxP4Pzn2CXYieLCiSaT
         WgDXylMTug3Q5KMqImADY1ToGkKVuvvFb0ziDEoYpvx4qraGflBOhZH0uR/EF2OFUGRl
         fTr4SF4R+LH0uXFnASW1iSmRSvyx/eKltqtaKQKJwHQP7Bj9OvTDv4EHTIo/I5SEG65Z
         DKup0JL+xnALAPIqEqVS5HycNLW50UJrfuSPKF7dTlHrZTyEmwXXVp9bR60Pb04o31K8
         zxeI5aNyrWeeWopuHaTwUYf4dH0vvF3yBq9ozZM9cXnw5S23kbbe+VD6xn8SEAu0RdJU
         Koww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bZYW/4C9hB/Gnz9nbQ499Xz+kEDrIm9y7WAFhfj/BVU=;
        b=PFUe34u10+X7g92LXtx6bUCdcH3i3KC4aRr/3PIjOhknwD7PyJY8vlnGr06Al5YrBs
         YLut8SGibiGXt5GekMn07SawAtJMxIu8m+B0F31uxidwVd0lDO+a/ClH26BXj57zlWoP
         9qe4zzY/fsKovlI8Gvc5qt3SqIhtFnHV95BOGP3RxEZ8ijcq0o8+8wBYxkzSDpbiN7sF
         tRP01YyTHnL8BZw2Kpj4q4aMPiGiVSpokLY6Q2qpNhaLvL6RAZSteWfeIDljlRabLhRj
         vJJLPEzzTJFSmAUh32BzNTX2EIaxFz32MUHpTemsUW56AlGxfJpTGsxLn81pseapqzbb
         A3nA==
X-Gm-Message-State: AOAM530V/T5mn+Xj6u3VbYXPX01d8pd7YgGgCaHofgI4tbV86vYhdhA6
        onYi4jUQeUaUdug/wn9J8yH+OEQvXuk=
X-Google-Smtp-Source: ABdhPJyPhfGZxr9U4NSmYeMaaNV/3YqGJAfOV1eHovwWNb7n4vbGQpLKyalp9ZuYTyLTtcozwpMTyg==
X-Received: by 2002:adf:82a8:: with SMTP id 37mr19053925wrc.409.1631625290972;
        Tue, 14 Sep 2021 06:14:50 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id y9sm1274760wmj.36.2021.09.14.06.14.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:14:50 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 10/25] trace-cmd library: Add section header before flyrecord trace data
Date:   Tue, 14 Sep 2021 16:14:23 +0300
Message-Id: <20210914131438.3965484-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131438.3965484-1-tz.stoyanov@gmail.com>
References: <20210914131438.3965484-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In trace file version 7, write a section header at the beginning of each
section with flyrecord trace data.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index e2d03f1c..e0bdf47f 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1896,10 +1896,12 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
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
 
@@ -1918,6 +1920,13 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 	if (!HAS_SECTIONS(handle) && do_write_check(handle, "flyrecord", 10))
 		goto out_free;
 
+	if (asprintf(&str, "buffer flyrecord %s", buff_name) < 1)
+		goto out_free;
+	offset = out_write_section_header(handle, TRACECMD_OPTION_BUFFER, str, flags, false);
+	free(str);
+	if (offset == (off_t)-1)
+		goto out_free;
+
 	data_files = calloc(cpus, sizeof(struct data_file_write));
 	if (!data_files)
 		goto out_free;
@@ -1998,6 +2007,9 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 	if (do_lseek(handle, 0, SEEK_END) == (off64_t)-1)
 		goto out_free;
 
+	if (out_update_section_header(handle, offset))
+		goto out_free;
+
 	free(data_files);
 	handle->file_state = TRACECMD_FILE_CPU_FLYRECORD;
 
-- 
2.31.1


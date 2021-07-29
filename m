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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92A6DC43214
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80F6361054
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233607AbhG2FKh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233965AbhG2FKh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:37 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 646EDC061765
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:32 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id f13so6341529edq.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z8XLY6lbSQHAj+YMOU7pBwRn88Cd/3oy3KvyffkBsE4=;
        b=p8etO9slVlQtl1nMMUcYkJJPKE4Ks/uA/Ttn9ja18rCQNvLN6vMD9SIuikGvBDgwU2
         rW93rNWI7WySxW4fKZ+EMTaN79pmxUrGPrJo7C/KWV4QCkMvYFhsKjQVHlvsTA/hiA0O
         hgD1ARI7NphPPLd2hsZoE85+VBfW7sG2G8LMimSLpFZvNxMTEkSk0o47LNqBx4tud7Tb
         ZzE6GFS8czwLehQF5e8dK0oHlGgKw95UVjknUL5g6Z5inNO186jlV+cHcTOBMvm1BGJA
         BOH70lKq8WHXROxnA2DVd3QWQT0rOUjty1FQBvy4DYFZ1KhmEwsJWxU7dKmi/FV0TYDF
         eA8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z8XLY6lbSQHAj+YMOU7pBwRn88Cd/3oy3KvyffkBsE4=;
        b=KKAgEtuGOMBw5x+KCnZeP/9TOYV55IKsYnMCI7ZM0qtRryGwkaQE4i8iL7nDOOZLQ7
         yNii0lTflHkzsDAE6dnCLvgN/QSRkrKHJ4uekJbAORb7GeYB0lAcspW5zluLCYLmucHZ
         z/YQOJa+EWlpnbHhs9vDhMi7WniaRRnYxzdY8RCAAyPsAVuzGWh/mjBKkhzp4TmE0bSc
         PkU+aoei17piXpLEWps7VzxKMuN5Ylm9LafwGdbUEw6otxIrTZRl4MfIkJvbkWOMU1H5
         3TQgVPBzUyEV/E8IkUNkYY9v7dRqSoyEGKZWHa4QSk3F+W2odw7shfeFeR1Wtm3OW2w6
         Qsvg==
X-Gm-Message-State: AOAM530JsLm44JX73FIgZcmM35PWzWftkcgpbBjn99wsiiqlVMUJqulC
        VXDfGBtKsvzmnbafipdZwOI=
X-Google-Smtp-Source: ABdhPJxT3swnCvIZHDJJJOfDRUugZZU3pt0MhnsOxIH7fvOzB/jsmTewMw/wf4pWX8z8TKIdH5FBnw==
X-Received: by 2002:aa7:c603:: with SMTP id h3mr3852448edq.165.1627535430882;
        Wed, 28 Jul 2021 22:10:30 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:30 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 30/87] trace-cmd library: Add section header before flyrecord trace data
Date:   Thu, 29 Jul 2021 08:09:02 +0300
Message-Id: <20210729050959.12263-31-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
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
index 21555d6d..30a6acf4 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2146,10 +2146,12 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
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
 
@@ -2168,6 +2170,16 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
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
@@ -2248,6 +2260,9 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 	if (do_lseek(handle, 0, SEEK_END) == (off64_t)-1)
 		goto out_free;
 
+	if (out_update_section_header(handle, offset))
+		goto out_free;
+
 	free(data_files);
 	handle->file_state = TRACECMD_FILE_CPU_FLYRECORD;
 
-- 
2.31.1


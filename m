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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF0E4C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:51:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3E1A611CC
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:51:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233689AbhIJNwa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 09:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233735AbhIJNwZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 09:52:25 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD2E0C061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:51:13 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id j13so2570583edv.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=agVLSiu/Q12j7g/SM+Jl2e/4wzuJwI9G/dagXdB5dDk=;
        b=BFjzyGTl2nIU5c47uvFDUTkRKxPeEKYsJB4XHUNUpACLqAnj50vulL2GqC1cn0YpDi
         VoIVoXUQFgf9IX22x1eEMZJYCX29WG5oSws+63glOBLKVPSmpHiOl0ud+q6IG4N78Wk8
         Ot03qXz1ES5EsP3A/hTD+sWVmgKJsyeWcojKB6RsAQMfuKSkjTlUB2bO4qsrvbnL2QXi
         IvjosSs3cGbjcAvW64OehksiDQMxTr36ssqIZbj+ve/078OGKLy+TSVMF4M8NhBTeDNu
         GeUIwnLXa8hI/zMyxG9KUOJSXFujXKnjYHzHpH4wRcj9SjFWUJ6/G8mrMZO3NKJ0QSh4
         Ad1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=agVLSiu/Q12j7g/SM+Jl2e/4wzuJwI9G/dagXdB5dDk=;
        b=Mx9sGNezofwfcwAzzC2Q5EAHuUmM/B5QyOLu780Sb5Vuv5UWpnIH6RmSUy+8GYkNm/
         /nWmKVUNahH7NxjzlQ8gXVWqK3nWz9d93/BTC7kVDJ7JWTwhcfA3AjXkYxdc01j+gpYg
         hqRm16kTp2VGwAJyVQ2KogHAwyrK7QUYV4/JsY38Tdj+fAlYJY67V0oo9+gy14J27V+s
         /p+v/tpRyj/ff+sKEYX/LgB91E1Je5xAQoKRAqeGHLRkTm4e5tKEmLlB4ATucDU27Jaf
         o7stXfuWo35Ivt3YTNe/nsLWJXp4ZqlScy182R3rIyOLPIj0IEhUHx7H3mbQq2LQ2t7j
         23DA==
X-Gm-Message-State: AOAM5326fOllq/xu5zN4QcSn0asD9WTwu0m3E+Sawmo16l4qgCcKt7l/
        xK/ZAFuj09OQwTLhGpZDGPZCeW5XlV8=
X-Google-Smtp-Source: ABdhPJz+tMBt/IBAxLlJpKIRsU7hZJ0nZaq5FS3I7pOyo0nfQnCBGNBpWx5RxZokXgHdmmCVBnF/Jw==
X-Received: by 2002:a05:6402:455:: with SMTP id p21mr9103142edw.309.1631281872553;
        Fri, 10 Sep 2021 06:51:12 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w13sm2484683ejc.100.2021.09.10.06.51.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 06:51:12 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 10/25] trace-cmd library: Add section header before flyrecord trace data
Date:   Fri, 10 Sep 2021 16:50:46 +0300
Message-Id: <20210910135101.2865226-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210910135101.2865226-1-tz.stoyanov@gmail.com>
References: <20210910135101.2865226-1-tz.stoyanov@gmail.com>
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
index 2ba35918..4602a1d4 100644
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


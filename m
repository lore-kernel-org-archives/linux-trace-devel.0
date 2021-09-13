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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E0B4C4332F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:30:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17E5760FC0
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:30:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239987AbhIMMbT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239946AbhIMMbS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:31:18 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14026C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:30:01 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id w29so13650297wra.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/PWBnkuChH7nnnnTH7/16VnQGRFsphyBjCJTQkbf25o=;
        b=oPvAKvmwSXWQ6Kob9ncPs4JNDhW/wUaJS7v1LUZgP0UiSVwF7/q1shS5aEyqmkSlh7
         HtGoia+wnNUv/jiXZUSx5CSNV9WVBqmPBNuwdVrAp+BdkSvoUGghXGh66MMwxdiCfbbS
         1kn5RL7PdA2RukvABvBaGYdHV/Gv183h+P+vIS7pTH1Z4rbqN93knLPjTbGeO0yJwg3J
         6IJKJAq4yhB2oAqsyE0IaNxnCxyaCVeKQPvfbpuvukC+v96WwKYCfwE7sP0k/stn/JHS
         Lun80NjobjihEC4jS3W8b094NqrvWTYteqZjgpt8LiPJJZ8bdGPJb5CAUdKgP7ns6/+8
         Ta5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/PWBnkuChH7nnnnTH7/16VnQGRFsphyBjCJTQkbf25o=;
        b=5pFrAlmo6j/EQjVfAOlv0pvRlIFiJapdS3Dk6dARwvaz9w3mYg1NCNG8RERviYc1zH
         q5gFD++VlM1e49MgcLqRV6EWmoCP1Tljs3L36t6nVZedLxCMIRbYUAWo8C5dyvtWr3dS
         x3q+dMEK247XU8qUBT9BeMPu2ayEVMmY0Ux8dS9gV/rwDRj/Y69JY6GHMdSo+hwcMbom
         fZ+O6z9VZ9jldR4aXiGnond7ocNTpng4w3q+0D5Fym4RaFWwE3MqeC+YIbFB8PmtwF3V
         pGrtyc/3LPNOlmDggzRqQ9MTS+EunR65+COV+A6XVnL9rWsonsFf77316nFaYbl7nrjd
         EIxg==
X-Gm-Message-State: AOAM532g/0HK0xAtT4dj+UHbMFSBsP3LWGyHibvPyqwP6DN6rwS3voWH
        p0fjRggLuUVi1nVtXIDd19A=
X-Google-Smtp-Source: ABdhPJwS/X8wHOhBr/ExflrUsTpSOFqVF8/aEWSc9UrJpjORuhZNNwKXPCL+r4y1Cf0PP2HdwMh0ew==
X-Received: by 2002:adf:c144:: with SMTP id w4mr12487865wre.398.1631536199704;
        Mon, 13 Sep 2021 05:29:59 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z5sm6842030wmf.33.2021.09.13.05.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:29:59 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 10/25] trace-cmd library: Add section header before flyrecord trace data
Date:   Mon, 13 Sep 2021 15:29:32 +0300
Message-Id: <20210913122947.3673239-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913122947.3673239-1-tz.stoyanov@gmail.com>
References: <20210913122947.3673239-1-tz.stoyanov@gmail.com>
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
index 07ea6d81..2515a5de 100644
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


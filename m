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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AEA3C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:30:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 413FE60FC0
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:30:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239998AbhIMMbQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240001AbhIMMbP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:31:15 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9EB5C061760
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:29:59 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id g16so14451629wrb.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DyXosnBNVez1kJvwW8Z59R0UfU/8CDxTC6gV2dbJ+wA=;
        b=Wuw+BSeH8831RGp7Guh2ql2hULnAgaXb7ouu1vGVvJaObFjpqxPIR4PgjNrT556oea
         mz+PPaa0Dw2nVvsJlmWXCK3kbda6WIT7ZGhBvjejKot2CvVwhoMIt1ApiMiedIBtcg5w
         jrS+3JkMfLFpEEuUp2N/qUE3en3S/LZQw/0coFnsnyOBiW0lNqj7n7o4u8pTxyY8sdj9
         ggmrDIK2GTx5wMfENW75K/Cfj83Ge/L8U7UFJiHwWXd+Oy9RxHcw/MI07cjfnrj36GqG
         0E5cG1/In9epDA0LayQ90xmRZB+UvSsDPiCYZfs8LnSOhrFRohaMSYC5prPqGkxaHo1Z
         i6yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DyXosnBNVez1kJvwW8Z59R0UfU/8CDxTC6gV2dbJ+wA=;
        b=whJF0tpzEfPRh/2nULW4CNKzx65fT2of32Oegga9aJ2NVi01LjkunmihTp72+ezrPD
         NmyEtcwTQHwtes75upqubiLeCwBr1fsrw7FWPJnXMPujnJiZXb7HzcJm8QybgFtTasXa
         OHLj1lmYAREVuzCAiJoD5rJkxSnAfp3W1iL/yWa8q6F+pf9+BoPcEdzC4+e2+Fd4/PFK
         cizf9/g3QcdM8q6LCTy3dpmcsyxS4EMCgTNcz+NlE9Hu81FCzgHpSjXLlZFfUGf3qS9z
         +8aS9uCmtFNP2DQqw2VUa70zd5CEyYBrzpVI3k9vYR5YWSNI4aEb971uq62u4ITrW5WX
         W6jw==
X-Gm-Message-State: AOAM532I0olvi6O2QAavQwS/C18hNfqzLK+TSGGwH/jECyo7M1PEnbP5
        WmuAIECg0iC3CbJgzcG4F+OgMn2BaBw=
X-Google-Smtp-Source: ABdhPJx51l/oG6zdy9UmtCtPGXK+lEYo5ls3LuiR5gO8FmliZytUb2/17gVW8SDv2ni5yDxwOSp0ww==
X-Received: by 2002:adf:d08d:: with SMTP id y13mr12619081wrh.156.1631536198603;
        Mon, 13 Sep 2021 05:29:58 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z5sm6842030wmf.33.2021.09.13.05.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:29:58 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 09/25] trace-cmd record: Append trace options after the trace data are written
Date:   Mon, 13 Sep 2021 15:29:31 +0300
Message-Id: <20210913122947.3673239-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913122947.3673239-1-tz.stoyanov@gmail.com>
References: <20210913122947.3673239-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In trace file version 7, the CPU trace metadata is saved in a trace
option. As this metadata has file offsets, which depend on the CPU trace
data, the option must be written in the file after the CPU trace data.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 35d9ee5f..879acb7c 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4449,6 +4449,9 @@ static void write_guest_file(struct buffer_instance *instance)
 
 	if (tracecmd_write_cpu_data(handle, cpu_count, temp_files, "") < 0)
 		die("failed to write CPU data");
+	if (tracecmd_get_out_file_version(handle) >= FILE_VERSION_SECTIONS)
+		tracecmd_write_options(handle);
+
 	tracecmd_output_close(handle);
 
 	for (i = 0; i < cpu_count; i++)
@@ -4597,7 +4600,8 @@ static void record_data(struct common_record_context *ctx)
 				append_buffer(handle, instance, temp_files);
 			}
 		}
-
+		if (tracecmd_get_out_file_version(handle) >= FILE_VERSION_SECTIONS)
+			tracecmd_write_options(handle);
 		free(temp_files);
 	}
 	if (!handle)
-- 
2.31.1


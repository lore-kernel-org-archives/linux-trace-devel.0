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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3644FC48BE6
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:51:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 107C561380
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:51:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232605AbhFNHxr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 03:53:47 -0400
Received: from mail-ej1-f50.google.com ([209.85.218.50]:43782 "EHLO
        mail-ej1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232594AbhFNHxq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 03:53:46 -0400
Received: by mail-ej1-f50.google.com with SMTP id ci15so15063005ejc.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jNmgwtkM7E5IR4z79tTsl2FEDjRbmtrhOhWVpEAWIrY=;
        b=rw9F4E3BGgxGQWiG9Mi0L3R0Fs8NyXGs5JqpJEYgsVxT21wkNAOLsLMloj15/5nRSe
         TRr9cuYR9nB9df0AQ6E4vuZJ5C/OEw+z07YlqieDpMmgHSfmOyi9iv6kGcGaBEuvFPbW
         RhM2e7OEOkZFaloUiB78tA+EwhOO54wKz2P4jFvITpwNb4xOa3PcncsAuX3r9DPjhvrS
         H3D/0atbwg6+BJRJ5E3aPpikCxIqf7qsu9IVOfUljjcoC1BYN5Kt2oJQoV8ESd2qoup0
         7++3YB2bZWevaH+ls4rr8yB/5+HYUCGF9rnokSmF2/JPUOjkB1K2H16Q6vBHwfUKhC1R
         ImEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jNmgwtkM7E5IR4z79tTsl2FEDjRbmtrhOhWVpEAWIrY=;
        b=NDlf31h5ACIzPh2BtRP4nnnnPEsR7Chzl6vDOs8VyPodto8SrMGqqpsiUVrmIZvW7T
         GNWLrUOijeJZPUWQmQ2TaMn5crIOMu02ATnr4HdJRBKEMFa4hA0/exoOg4tVft13PcwP
         M4g+MANrdAf6yK0myWAtv+XSB47jVbwuzFq+3OtHJFvzKVAiLT8289NRHJiPjNTx8kik
         TOKFrvsXTytKE6hwu2OS5W1yUlhzQpWGbaCv9FrogLWxRmDtddoGiym7xKfWUvyqzEI2
         1l0tO0NxIBrDsB32ERLYXyEjvw6IFKbjP7bxSY97mLa3T5WKshcldPx1PMjOenxqB1So
         nooA==
X-Gm-Message-State: AOAM533Er2fHnHsmXH9IwBSxx22qGf2icvp3RHuykMAk/z82TgLv7UsP
        Jt3pTQNteYfOSLU5VG0GFhA=
X-Google-Smtp-Source: ABdhPJxYRS1oWX2IFxliO5zME40BqfMrbVWdIf1EouFsl12XWdXijU7uxkQQhX11KiAil5XzTZi43w==
X-Received: by 2002:a17:906:d8cf:: with SMTP id re15mr14157190ejb.278.1623657043782;
        Mon, 14 Jun 2021 00:50:43 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f6sm6536444eja.108.2021.06.14.00.50.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 00:50:43 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 12/45] trace-cmd library: Add new API to get compression of input handler
Date:   Mon, 14 Jun 2021 10:49:56 +0300
Message-Id: <20210614075029.598048-13-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210614075029.598048-1-tz.stoyanov@gmail.com>
References: <20210614075029.598048-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The new API returns name and version of the compression algorithm,
used to compress the trace file associated with given input file handler:
 tracecmd_get_file_compress_proto()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h          |  2 ++
 lib/trace-cmd/trace-input.c                      | 16 ++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index ec534d51..624d0afb 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -236,6 +236,8 @@ unsigned long long
 tracecmd_get_cursor(struct tracecmd_input *handle, int cpu);
 
 unsigned long tracecmd_get_in_file_version(struct tracecmd_input *handle);
+int tracecmd_get_file_compress_proto(struct tracecmd_input *handle,
+				     const char **name, const char **version);
 
 int tracecmd_ftrace_overrides(struct tracecmd_input *handle, struct tracecmd_ftrace *finfo);
 bool tracecmd_get_use_trace_clock(struct tracecmd_input *handle);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 43d731e0..0b17b58d 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4148,6 +4148,22 @@ unsigned long tracecmd_get_in_file_version(struct tracecmd_input *handle)
 	return handle->file_version;
 }
 
+/**
+ * tracecmd_get_file_compress_proto - get name and version of compression algorithm,
+ *				      used to compress the trace file
+ * @handle: input handle for the trace.dat file
+ * @name: return, name of the compression algorithm.
+ * @version: return, version of the compression algorithm.
+ *
+ * Returns 0 on success, or -1 in case of an error. If 0 is returned, the name and version of the
+ * algorithm are stored in @name and @version. The returned strings must *not* be freed.
+ */
+int tracecmd_get_file_compress_proto(struct tracecmd_input *handle,
+				     const char **name, const char **version)
+{
+	return tracecmd_compress_proto_get_name(handle->compress, name, version);
+}
+
 /**
  * tracecmd_get_use_trace_clock - return use_trace_clock
  * @handle: input handle for the trace.dat file
-- 
2.31.1


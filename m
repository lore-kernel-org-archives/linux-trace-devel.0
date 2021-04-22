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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AAD0C433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 07:39:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA27A6121E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 07:39:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235097AbhDVHkA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Apr 2021 03:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235101AbhDVHjx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Apr 2021 03:39:53 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0947C06138F
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Apr 2021 00:39:09 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id i3so26549441edt.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Apr 2021 00:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RrreRLz8P0enx0b7FT0diazMpLiPHfZaexeyaneDWww=;
        b=PdbPiCFvBDl+ZuPGbkUil5N0u6rr/FvpjxbfdiUL9TPklkUZSH1sPdkpFZgpn/vsYk
         plwAgQgXQMkzEEX4GX2PeNI/LjwhY1D9ViYG+O48tja3meZ/IoqCEgTy6Zq63CuTGwha
         BhFDXSiwoEwP0GBMQndncLVqT3mvKWGw1yjzDQsTab/MXeDujstgbyUU8tLHgtKczXlX
         cMd9FlDLZ6NLAfIHOQdz7KtRfoo6F98j0Q9JKBsNi/cZ3vbCJTg1GqkJt120JYOIfg4J
         YKgSCUr/hcMDB0vc32IVHW+SucHTGJybkaskujexUjl6hFNGm2Zvmt4V50mvdKMOqScG
         k87w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RrreRLz8P0enx0b7FT0diazMpLiPHfZaexeyaneDWww=;
        b=QgawQ28uMdp4EeHXWzWpxHru7rGQzgisIJReldGfklOY4v3dGot0AbJ6mg5mLkVMPK
         YZCWy1F4rBn10Zwc5H5GxYZCKdnyiTj3uattWNuXX8jtPaFvGhv7NaAunxYqVn/JtZbT
         Mlp0UhWEOukhfL4ctcVVRaJm8lqj4vUIQbjgdZciofoyYfgLWuxi3//ryddU6lTvpGZe
         dnTXe7JKjnIowXX0p0qBVOpgyxLDj4j2HkxyJ3koBA+vmZMocxo163yn5ASbAlliFDxD
         5KitBbKSEc2abaW+envHgG8T+Ttdn8zCyjAteHZ0a6ifsNuvq8sIsC2tdpa4dqQg0V9K
         ii4g==
X-Gm-Message-State: AOAM530ZV3kt0ZSLoFWSFq9YoGka56igC15r9we+z1aXUoHNaK5Fmz+G
        ufkXicyvHRxLzLlFEZ/9p+w4UtyYmd/IAg==
X-Google-Smtp-Source: ABdhPJzy//4GG8KBQtjxTHwRBuVNIFknCzngLN9uDAvYo7mJKNCT2ULiTgFc0BUrlYEMgO9/o2qzhQ==
X-Received: by 2002:a50:82e5:: with SMTP id 92mr2082286edg.141.1619077148652;
        Thu, 22 Apr 2021 00:39:08 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s5sm1253692ejq.52.2021.04.22.00.39.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 00:39:08 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 05/10] trace-cmd library: Add new API to get compression of input handler
Date:   Thu, 22 Apr 2021 10:38:57 +0300
Message-Id: <20210422073902.484953-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210422073902.484953-1-tz.stoyanov@gmail.com>
References: <20210422073902.484953-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The new API returns a handler to compression algorithm, used to compress
the trace file asociated with given input file handler:
 tracecmd_get_file_comperssion()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/private/trace-cmd-private.h |  2 ++
 lib/trace-cmd/trace-input.c                       | 11 +++++++++++
 2 files changed, 13 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index c562fc5d..4d2116ab 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -236,6 +236,8 @@ unsigned long long
 tracecmd_get_cursor(struct tracecmd_input *handle, int cpu);
 
 unsigned long tracecmd_get_file_version(struct tracecmd_input *handle);
+struct tracecmd_compress_proto *
+tracecmd_get_file_comperssion(struct tracecmd_input *handle);
 
 int tracecmd_ftrace_overrides(struct tracecmd_input *handle, struct tracecmd_ftrace *finfo);
 bool tracecmd_get_use_trace_clock(struct tracecmd_input *handle);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index b96b0192..ad5af5fa 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4192,6 +4192,17 @@ unsigned long tracecmd_get_file_version(struct tracecmd_input *handle)
 	return handle->file_version;
 }
 
+/**
+ * tracecmd_get_file_comperssion - return a handler to compression protocol,
+ *				   used to compress the trace file
+ * @handle: input handle for the trace.dat file
+ */
+struct tracecmd_compress_proto *
+tracecmd_get_file_comperssion(struct tracecmd_input *handle)
+{
+	return handle->z_proto;
+}
+
 /**
  * tracecmd_get_use_trace_clock - return use_trace_clock
  * @handle: input handle for the trace.dat file
-- 
2.30.2


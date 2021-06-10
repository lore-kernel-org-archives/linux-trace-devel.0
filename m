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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3EB2C47094
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:34:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7FD0613F1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:34:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbhFJLgc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Jun 2021 07:36:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbhFJLga (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Jun 2021 07:36:30 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24DE0C061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:34:34 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id l2so1908070wrw.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K/wi6U7hzPtl4la0xaLhqgtGsmlwcZ2Gfg6Lcb4Uo4I=;
        b=pfuIuVzIAq6K10dKCNX4YwSKNvbNuB0ark9ziTLS7Vn/5U7wrYMHLdwou5sRZNA0ov
         75qShZh5K367O4xFNMjswUV3LzoML57qvxvrrK1JFtLdzxPfVIKRv5evwoGVpKADvcCH
         NnFEtYt7GeB1SWYwLd7rgrFbTdAFHSRij0YjmoZTLl5ZkM0e6IL5iGVxaXiW/KjMvBO1
         9nj6P3jWsiWxbxcnX6ObucP13dqOJD6ANsuI8Xev/Y8kaSZ442SMo/0P5EhgWd95UcW7
         U8HIbxd2xj75aBi/aPUNtmaPKUu9z0LvO3g2IOqJlfBf7K4ACa6oKOfoVG1eZGSKMsBC
         RENw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K/wi6U7hzPtl4la0xaLhqgtGsmlwcZ2Gfg6Lcb4Uo4I=;
        b=VWZue6+xrq6Y9Pu5e+PDL/NjWZlLuCslCPSd1yMsbmONLIt04cqtKcDVOUpQjqYrTY
         z0wffFA6bAIMzoj73LWTQiueUmbisngdAgZxzDaE+dT63IzSvMyu/BnUS/L+g23rYGNN
         FEvg/s83qmf/ZbjHmu6fjlJpUV+BKJ2WUrACW6H7BJ3ansIWiUBHVT0FPLwDWF5JGc7V
         5lgcSiFcwpC+mOCaxxwivSNDpFtyuYnH0Ae4A2ChryeYx2mfb47ufzjjhuD3tvSspueo
         YF1hwQLpgaIFpcbVvxClWVM2jBeBdZ4uS2GsgaGBZ2pj5IdorUP+DhsADyZTuCIHP50d
         s0bA==
X-Gm-Message-State: AOAM532aCFeSLTUKGtpAlj+8OQJ4kFCk9XwGcwtLhtXOIdvKXuuCFutn
        aRfKScdom8gjw8vES+EU9bbYMIpGJB1FHg==
X-Google-Smtp-Source: ABdhPJwE7AlPB16508cEOa25NnkELS5O+XJbtQR7s6TV9cKQN8iMOtGbSCRWKwNULNxT3LXQBQ3QPg==
X-Received: by 2002:a5d:4bc9:: with SMTP id l9mr4995162wrt.97.1623324872720;
        Thu, 10 Jun 2021 04:34:32 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n42sm8898391wms.29.2021.06.10.04.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 04:34:32 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 04/40] trace-cmd library: Add new API to get file version of input handler
Date:   Thu, 10 Jun 2021 14:33:50 +0300
Message-Id: <20210610113426.257931-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610113426.257931-1-tz.stoyanov@gmail.com>
References: <20210610113426.257931-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added an API to get the version of the trace file, associated with given
input file handler.
  tracecmd_get_in_file_version()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/private/trace-cmd-private.h | 2 ++
 lib/trace-cmd/trace-input.c                       | 9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 6fc18938..01b12c47 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -232,6 +232,8 @@ int tracecmd_set_cursor(struct tracecmd_input *handle,
 unsigned long long
 tracecmd_get_cursor(struct tracecmd_input *handle, int cpu);
 
+unsigned long tracecmd_get_in_file_version(struct tracecmd_input *handle);
+
 int tracecmd_ftrace_overrides(struct tracecmd_input *handle, struct tracecmd_ftrace *finfo);
 bool tracecmd_get_use_trace_clock(struct tracecmd_input *handle);
 tracecmd_show_data_func
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 97ad0a5d..46619ac7 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4046,6 +4046,15 @@ struct tep_handle *tracecmd_get_tep(struct tracecmd_input *handle)
 	return handle->pevent;
 }
 
+/**
+ * tracecmd_get_in_file_version - return the trace.dat file version
+ * @handle: input handle for the trace.dat file
+ */
+unsigned long tracecmd_get_in_file_version(struct tracecmd_input *handle)
+{
+	return handle->file_version;
+}
+
 /**
  * tracecmd_get_use_trace_clock - return use_trace_clock
  * @handle: input handle for the trace.dat file
-- 
2.31.1


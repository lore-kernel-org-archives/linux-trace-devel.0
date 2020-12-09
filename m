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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 528B4C2BB40
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:44:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D3A023A02
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732623AbgLINoU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 08:44:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732627AbgLINoT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 08:44:19 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA421C0619D7
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Dec 2020 05:42:43 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id d3so1517956wmb.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 09 Dec 2020 05:42:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TUWBfZ26wexvniEj7Ku7Ku7CEywO7ZiFvPGFqaZnChE=;
        b=bAxeD0WvhroxQ8T+0Vsyhx/MmuyDfgA4gEs3gyl7TW4fCg1kDt8nyR4o8VnHccMrCJ
         NFtMVuEZMF6Ha+P7jvHVXw1RiAYZLzkIE5nkjRM58gh9hQGbThcTZRHRhpLrE4+8vj3t
         vzY/MI+ImAvR9OvBxuNk3QKvjBsc9s7OMym2BeR2gTYGMVCOFDx9LCXtH9WB+g/E3+EJ
         ww1SNabt6KMr/h4Ya7yRZ0PBn/wFOLlVgiz0Jk37q58aR2dYj/DTNROQGGZUoo+Hv/WY
         S4lzPwD3rCvvizpgYwAODdOX+8BE+S5DXvMSqfoZ2Bk2eUD6NRutXJTBzg+gFN7RHXmP
         Pcuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TUWBfZ26wexvniEj7Ku7Ku7CEywO7ZiFvPGFqaZnChE=;
        b=ModsH+3oWDJ/BYitrQKRBrN+DXb1KkvN9lHQuOpVTZqJ5GQVMFRQw24cNQ48rlhwz5
         Dcv9lw0ytlMQSWxHbwgMf3SxhqsQg6AGTqmOt2w3LczRLMRx9L/AWyRe7VsU81FU3GtV
         Iw79vrUAlyIqKm9eIRzFr6eIXR4H/l7i8/qdf1eNX+cJiijVE5K+eC3LyyJ38PGg+vz+
         /cUpb/fzQpZnXelJimLscq//swA53oqOcyFFJodtfKEMqRbba3APB6Gdr4dy3leq6D/X
         ZYT46bikBZ1LTkDV6z0kCxaxg1NU8KWOiKW49ITeHau0dn1lHZA5yO4yHpg0I24SC3EV
         jV9Q==
X-Gm-Message-State: AOAM531UY6uSV7BBz7VLcZqFCwwM8hx3Z9JNjHHi87uRW46G7mopGKh0
        Ju2yjrcNklDFQztnmdDgMVJ7UNPvWEA=
X-Google-Smtp-Source: ABdhPJzBtFWb3a3AxJcfHDMAlbnRLXrG9/AL8SrfhFRDF9uF2EW5PriSFiPTUDF6IEdGiA54gPCOww==
X-Received: by 2002:a7b:c055:: with SMTP id u21mr2889704wmc.130.1607521362672;
        Wed, 09 Dec 2020 05:42:42 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id q143sm3871071wme.28.2020.12.09.05.42.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 05:42:42 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v6 25/27] kernel-shark: Do not use the ARRAY_SIZE macro
Date:   Wed,  9 Dec 2020 15:42:01 +0200
Message-Id: <20201209134203.428068-26-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201209134203.428068-1-y.karadz@gmail.com>
References: <20201209134203.428068-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This macro is no longer available in the trace-cmd public header.
Since it is used in only one place, we will just replace it with
the corresponding code.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark-tepdata.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
index 0b23912..5fc1eb8 100644
--- a/src/libkshark-tepdata.c
+++ b/src/libkshark-tepdata.c
@@ -1261,10 +1261,11 @@ const char *tep_plugin_names[] = {
  */
 int kshark_tep_handle_plugins(struct kshark_context *kshark_ctx, int sd)
 {
-	int i, n_tep_plugins = ARRAY_SIZE(tep_plugin_names);
 	struct kshark_plugin_list *plugin;
 	struct kshark_data_stream *stream;
+	int i, n_tep_plugins;
 
+	n_tep_plugins = (sizeof(tep_plugin_names) / sizeof((tep_plugin_names)[0]));
 	stream = kshark_get_data_stream(kshark_ctx, sd);
 	if (!stream)
 		return -EEXIST;
-- 
2.25.1


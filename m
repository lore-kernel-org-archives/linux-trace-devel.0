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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 614B9C432BE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4635B61053
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233782AbhG2FKK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233739AbhG2FKK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:10 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB2A1C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:07 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id ga41so8406945ejc.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6ypas6iex836tTwseQtXfnzbSaoAb7AFc6+3qdD4/Bs=;
        b=FUw0LqPKlmG4rN+P4EO8iuz1HyL9NJ/1yJS7MoGIVDo3ShFEfvmZ4g/VKgrzFjgBUC
         V9yBA0v+VLconscgcsajr08CVfrf2VsLL3foH03EzB3Tp6er6xy2rSm74Ku0zmsCSz6k
         QsyIRB8EdyGscPNHgh3DfuMjSY/bAJdMXbtg7TR53H5zB4pnDPmJE5JKvrCmQjCjhYJa
         mbYD9GR69+NDvAs+8q3437AHvWqvviXsa9P8Ysn0+3hKSLC8AK/LJcKsAmljyC9JR/ku
         sSvuc3oZE6k42+BkMazIVpTHK0W3AEg/cETA/2UEHKyxJh8782ztUu9uX2TJ6NxiGCDq
         s9Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6ypas6iex836tTwseQtXfnzbSaoAb7AFc6+3qdD4/Bs=;
        b=UGwMfnxF6tJUrI3kJiIKEQI2MTQqX4jQggretVNd4/rHWr9CsiIIsNCY9tA8PHRKoS
         OdRHS5MjDpbLLXk0kueGaKeIECti/fzJPfy21Rf2sumDHKoe0on5KOWbmuPHvzJ3nCvs
         osMJVgUHGV2BBRKgxvVOeibzykuvyIVGkjyfjBLxNaZAx/C6j+43oQNx0QbzAfWdq935
         av775+s1ebN6Ea52ErsHxI2mwU7R2+JvhcyTDl3T874XYoZVh7k9AfFcWbwFxoI8z5J8
         AHMdtQwtLDhZXt4u+m+gcG4R29GTM0IvuCfv6rbdSFfc6/1dKyWu/vPE6B0sNOE+B858
         oYgA==
X-Gm-Message-State: AOAM530vtlnFNbD4zi9yC1/edCd1B6RPtYPswK0ynpruVg2DSo3FwAJj
        IIFpA2rDFgvkY/L5yE4s6sM=
X-Google-Smtp-Source: ABdhPJwGb/ZVJfScGMLLwejKhfSbgkWyI2x0ip1oSvpZnSXAgkds8NLb7z4OoJZrn/4PCGMnwDmfIQ==
X-Received: by 2002:a17:906:a195:: with SMTP id s21mr2850361ejy.181.1627535406571;
        Wed, 28 Jul 2021 22:10:06 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:06 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 05/87] trace-cmd library: Fix possible memory corruption on processing a trace buffer
Date:   Thu, 29 Jul 2021 08:08:37 +0300
Message-Id: <20210729050959.12263-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When a new trace buffer is read from the trace file, a new input handler
is duplicated from the top one. Some of these data are poiters and
should not be duplicated, as it could lead to a memory corruption on
handler close.
Added a safety check to ensure requested buffer index is valid.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index af11cbc6..787d6825 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3946,13 +3946,14 @@ struct tracecmd_input *
 tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
 {
 	struct tracecmd_input *new_handle;
-	struct input_buffer_instance *buffer = &handle->buffers[indx];
+	struct input_buffer_instance *buffer;
 	size_t offset;
 	ssize_t ret;
 
 	if (indx >= handle->nr_buffers)
 		return NULL;
 
+	buffer = &handle->buffers[indx];
 	/*
 	 * We make a copy of the current handle, but we substitute
 	 * the cpu data with the cpu data for this buffer.
@@ -3966,6 +3967,7 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
 	new_handle->nr_buffers = 0;
 	new_handle->buffers = NULL;
 	new_handle->version = NULL;
+	new_handle->guest = NULL;
 	new_handle->ref = 1;
 	if (handle->trace_clock) {
 		new_handle->trace_clock = strdup(handle->trace_clock);
-- 
2.31.1


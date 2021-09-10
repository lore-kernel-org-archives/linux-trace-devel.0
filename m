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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE695C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:49:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D5EE611C9
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:49:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233485AbhIJNuN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 09:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233245AbhIJNtQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 09:49:16 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EF33C061766
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:48:05 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id t6so1156833edi.9
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6uflLdcxtwKc9UdYaXGxzpx3D+nzjM4vg/8RpU5kByg=;
        b=gQnB/3rF6Kj6cAutgS0u47p9WPvEps5pTd18FQo7YgkhypLbSqVVbwM7dHwV8eOCWW
         L3F6d7/Qh83y1aU5Bs8hZNmJOEcin21AMQ56mCEqEqR8QJ2hIF88APbTWmMoJshCUeGy
         5kznTMr7IkY5FB9T8KHM0zqFouA62xl4caPYK/66CpgX/X2JOIZhHNvWc82+KM+kN9IU
         M/ZkarX4n7y56qlvsi+9xXLPwXwSQ3An116O74i50V8Za1t6+yhzM/8wTfHNIgMqiVwX
         Pzj0QWFcdvBsUKPHpCioT4hjOYaYxJ6D8zPy3mX+OZ1OGoSQ2eopqkBM8jFLpe8AMXwW
         Xzig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6uflLdcxtwKc9UdYaXGxzpx3D+nzjM4vg/8RpU5kByg=;
        b=u3b61LmZSnMs+hVeScJ7P+L6whJ8bMqDoVLHbuYoFXxWOKNiJ3jrmLWFwZiER/fQVT
         Nf5C7H1jHPdP1OiB6iarrPULRB+TortwmjMXyZWAzqH5+vaohD8sxJLAf0jWNoQlOc91
         qdIzooIuwfiUj1Ce190ONvsZuKJO26l0Yr74+I8iCAle3TpW4t40pSJuMqQpEb6km5aA
         yQz3LmgOWZ4SqxgPr25BeRjOabGKmc/bG3x4B6Mf/DTk86Dr/GrNR0vb++11S9WXjzOO
         u1s5+pTCqXMdnoqXtnsJkoR/OT6SQc0rfXpq2tdUvsXmPgztvrIy+1OkX+TOWD5FuYjr
         k/gw==
X-Gm-Message-State: AOAM531NRWtWs1cAxwaRV7LWDL3Eduxx3/oqI+vvT1kCnhTSsYMX4ANw
        vFWAQQ2h2dN1S9BVje116EWF5ck6vng=
X-Google-Smtp-Source: ABdhPJwXTba8+hW8LEEVyvU/Sc48regOJykdyu4cX9uok63RYwlj1qaJXy0tGSvoHntAoQPNRcbamA==
X-Received: by 2002:a05:6402:5107:: with SMTP id m7mr9095359edd.63.1631281683809;
        Fri, 10 Sep 2021 06:48:03 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id r2sm605141edo.59.2021.09.10.06.48.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 06:48:03 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 04/21] trace-cmd library: Fixed a memory leak on input handler close
Date:   Fri, 10 Sep 2021 16:47:40 +0300
Message-Id: <20210910134757.2863982-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210910134757.2863982-1-tz.stoyanov@gmail.com>
References: <20210910134757.2863982-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When an input handler to a trace file is closed with tracecmd_close(),
the list with buffers is not freed. This leads to a memory leak. Added
logic to free that list.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 9253bc37..ffe87e8a 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3484,6 +3484,7 @@ void tracecmd_ref(struct tracecmd_input *handle)
 void tracecmd_close(struct tracecmd_input *handle)
 {
 	int cpu;
+	int i;
 
 	if (!handle)
 		return;
@@ -3521,6 +3522,10 @@ void tracecmd_close(struct tracecmd_input *handle)
 	free(handle->version);
 	close(handle->fd);
 
+	for (i = 0; i < handle->nr_buffers; i++)
+		free(handle->buffers[i].name);
+	free(handle->buffers);
+
 	tracecmd_free_hooks(handle->hooks);
 	handle->hooks = NULL;
 
-- 
2.31.1


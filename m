Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2BA3C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Mar 2022 14:37:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238790AbiCPOir (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Mar 2022 10:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236677AbiCPOiq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Mar 2022 10:38:46 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF24752E2A
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Mar 2022 07:37:31 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id t1so2999172edc.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Mar 2022 07:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e3mro1+5CIotbzwMPPXB1AsZ5y4fDO/jdJ2AUZJV26o=;
        b=earKWguaD6uF89IMPHMGF6wX9f+h1bQFp/PeaCy2HZKv/RomRo3hRt9Sf9/zwVaVVd
         DcS4uyC/fCHG08T1ebfuYyhZX67ttJ2tlfgYR9sjad0lAgTmqK1Ij35QYNjY+YWQsJAk
         Zke9iPlCGWRb52+KRxmw73u+qIDGWFDaq0LhTmUKGpNxFvNeZ73Zob70Dufv7Sx6oiXT
         0iLeoAr9wHZXMm/Z3p7MDxlHDAR8tuHqj/3+KCnVnXNPm39hhvt3z5+mrAlTmZhG895P
         TLo2hHMvAZbKJqwGSSUyFzOyQ6G8gKMkDyOpNuaXZYm7w4jRUmTfEdQlMHvvb2YfRyTS
         Q6og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e3mro1+5CIotbzwMPPXB1AsZ5y4fDO/jdJ2AUZJV26o=;
        b=rjTE8VJZU29jiJDfMrY78qkztN7HhbnZKAfcmFLuFDtAcFiOm+bY8lS5U8gaNatrtc
         N7dRhpUJEwBX7vfK3kCYdxD+JhCjy4bAMb38CN/stDfhzk09McCaSTEWb+n0DU7fAKEg
         pUf34p9MgQWxdpiwTDg+3AP6qcu+EhiqqX/mLLv3n0k8vHC6wumyduWL2NYV1wsW2gwu
         jO5ea/JiBK/TWHD4oZzn60YwsVeGlKJSCA2Zd0p9x41FXAWhcev0tSChx0kW0Vpg7+yk
         7Y0mm5Sz6e6XXZvv8rMFCd718n7r1s8H/grSHuCsvrmDFrcY41xq0JeJEMM47OzHuI4I
         H3pA==
X-Gm-Message-State: AOAM532MeEzVTsOsWRVZCYU0heu5aexjizyOfDmwhHWPeU6WqVkMbFoX
        UXVHSD4CXScEnTn0EpLEWSMAXmtsX5o=
X-Google-Smtp-Source: ABdhPJzts6LCwxsTFvPmkVIVKcqV2/1O+96CJZ11Wa3ztdDPic15ndmAPnXYx0mZOhsR1P86I3Qpxw==
X-Received: by 2002:a05:6402:292c:b0:416:8eb:3fc4 with SMTP id ee44-20020a056402292c00b0041608eb3fc4mr29594119edb.2.1647441450201;
        Wed, 16 Mar 2022 07:37:30 -0700 (PDT)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id y13-20020a1709060a8d00b006dabeaf86c7sm959445ejf.137.2022.03.16.07.37.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 07:37:29 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/2] kernel-shark: Hide CPUs with no data in them
Date:   Wed, 16 Mar 2022 16:37:16 +0200
Message-Id: <20220316143717.272899-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A hash table, storring all idle CPUs is added to the session context.
If a CPU does not contain any data (is idle), its plot is not shown
by default when KernelShark starts. Note that, if the option '--cpu'
is used, it has priority and if idle CPUs are selected, the
corresponding empty CPU plots will be displayed.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=215677
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/KsGLWidget.cpp      | 11 ++++++++---
 src/libkshark-tepdata.c |  5 ++++-
 src/libkshark.c         |  6 ++++++
 src/libkshark.h         |  3 +++
 4 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/src/KsGLWidget.cpp b/src/KsGLWidget.cpp
index 3b2e0d4..1c71ecb 100644
--- a/src/KsGLWidget.cpp
+++ b/src/KsGLWidget.cpp
@@ -419,6 +419,7 @@ void KsGLWidget::keyReleaseEvent(QKeyEvent *event)
 
 void KsGLWidget::_defaultPlots(kshark_context *kshark_ctx)
 {
+	struct kshark_data_stream *stream;
 	QVector<int> streamIds, plotVec;
 	uint64_t tMin, tMax;
 	int nCPUs, nBins;
@@ -432,15 +433,19 @@ void KsGLWidget::_defaultPlots(kshark_context *kshark_ctx)
 	 */
 	streamIds = KsUtils::getStreamIdList(kshark_ctx);
 	for (auto const &sd: streamIds) {
-		nCPUs = kshark_ctx->stream[sd]->n_cpus;
+		stream = kshark_ctx->stream[sd];
+		nCPUs = stream->n_cpus;
 		plotVec.clear();
 
 		/* If the number of CPUs is too big show only the first 16. */
 		if (nCPUs > KS_MAX_START_PLOTS / kshark_ctx->n_streams)
 			nCPUs = KS_MAX_START_PLOTS / kshark_ctx->n_streams;
 
-		for (int i = 0; i < nCPUs; ++i)
-			plotVec.append(i);
+		for (int cpu{0}; cpu < stream->n_cpus && plotVec.count() < nCPUs; ++cpu) {
+			/* Do not add plots for idle CPUs. */
+			if (!kshark_hash_id_find(stream->idle_cpus, cpu))
+				plotVec.append(cpu);
+		}
 
 		_streamPlots[sd]._cpuList = plotVec;
 		_streamPlots[sd]._taskList = {};
diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
index 9740ed9..e9244b0 100644
--- a/src/libkshark-tepdata.c
+++ b/src/libkshark-tepdata.c
@@ -391,7 +391,10 @@ static ssize_t get_records(struct kshark_context *kshark_ctx,
 			rec = tracecmd_read_data(kshark_get_tep_input(stream), cpu);
 		}
 
-		total += count;
+		if (!count)
+			kshark_hash_id_add(stream->idle_cpus, cpu);
+		else
+			total += count;
 	}
 
 	*rec_list = cpu_list;
diff --git a/src/libkshark.c b/src/libkshark.c
index 1222a81..44e553f 100644
--- a/src/libkshark.c
+++ b/src/libkshark.c
@@ -121,6 +121,8 @@ static void kshark_stream_free(struct kshark_data_stream *stream)
 	if (!stream)
 		return;
 
+	kshark_hash_id_free(stream->idle_cpus);
+
 	kshark_hash_id_free(stream->show_task_filter);
 	kshark_hash_id_free(stream->hide_task_filter);
 
@@ -147,6 +149,8 @@ static struct kshark_data_stream *kshark_stream_alloc()
 	if (!stream)
 		goto fail;
 
+	stream->idle_cpus = kshark_hash_id_alloc(KS_FILTER_HASH_NBITS);
+
 	stream->show_task_filter = kshark_hash_id_alloc(KS_FILTER_HASH_NBITS);
 	stream->hide_task_filter = kshark_hash_id_alloc(KS_FILTER_HASH_NBITS);
 
@@ -433,6 +437,8 @@ static int kshark_stream_close(struct kshark_data_stream *stream)
 	kshark_hash_id_clear(stream->show_cpu_filter);
 	kshark_hash_id_clear(stream->hide_cpu_filter);
 
+	kshark_hash_id_clear(stream->idle_cpus);
+
 	if (kshark_is_tep(stream))
 		return kshark_tep_close_interface(stream);
 
diff --git a/src/libkshark.h b/src/libkshark.h
index 23e3b49..1514f33 100644
--- a/src/libkshark.h
+++ b/src/libkshark.h
@@ -286,6 +286,9 @@ struct kshark_data_stream {
 	/** The number of CPUs presented in this data stream. */
 	int			n_cpus;
 
+	/** Hash table of Idle CPUs. */
+	struct kshark_hash_id	*idle_cpus;
+
 	/**
 	 * The number of distinct event types presented in this data stream.
 	 */
-- 
2.32.0


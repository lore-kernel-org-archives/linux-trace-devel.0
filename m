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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87B55C433E9
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Mar 2021 11:40:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46DDC64F70
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Mar 2021 11:40:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbhCQLkJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Mar 2021 07:40:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbhCQLjl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Mar 2021 07:39:41 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B22C06175F
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Mar 2021 04:39:41 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id ox4so2014513ejb.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Mar 2021 04:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MzEtItwD2XFh63jqrRSt2Ds+Y7M6GKF9gke/UQ1f85I=;
        b=GJIpU/pQ4r7n4lbcSr1XcZT0stMYEW/0ZvLKCdMU5ZtB/N73wDZWpULWASQlZ/uCfz
         6Tsw4TaO/y7vI3RnhtZHkt3RHTuWb9MQp4yQrfJP/EaRxHQ+46xLlZH65hsw1FCmliFb
         /7pwiO8pSdz5ti5BwnyGAdHZ8DKxbctWPLVJo9P1ixijTxcbsH6KrEP/QZomNkQ14nIw
         vUSrCKsE44gQRo5ozWdoOQHmf7v7SRjVYY6JKgzablOMmUOhMknltgaTpKyGuQCfqNgR
         t9rUuoK42AcbbwRGSk7ChS89SKM6vsT/66vePlG1d/g3Ipxppubset0CgTHk5wtKf/lG
         LpHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MzEtItwD2XFh63jqrRSt2Ds+Y7M6GKF9gke/UQ1f85I=;
        b=YEvkiIaiQe939+vLQ1GfBQJdMdIL6kBfZxe+dsjuFcXn39f2/dIERklBp2hjf3jZpF
         WNXSeHktfadQdDpI0DOxKN/+QD3C2PgFjdKYYpQWlKsIN3iOCL/HzNVse2V7Xs0zaBAg
         TMBlucKWMHOxyguE2W/iG3ui2/1cr6aQ5jSB8InXHjjov3n1TT1QRht6+g07JDIADE80
         +xjVvSth/fb91tq+ODchMq8J8rp/IkKus9XP+HTRc98dKa99Kw3YAkydiy9n7En9Ft0V
         jT8XymsIQ3D2qw2C4B439a8WskFS1E09ZFhMK6tkePnSyAqvNNT0DJnt5ZVr6NOOd2n8
         cr7A==
X-Gm-Message-State: AOAM532Du0bujk1wZlEuL3JBHhFniBA9oKmF6z9hLxRe8lCb356XywV+
        GFBj+721DhgQDk0NBGo2+nU=
X-Google-Smtp-Source: ABdhPJxjafNflhZjK/K8z5OoJAJRtgi/3I2S2d/+5Qh5CSzoAPGmCg71nsziNLue+f2lRCSISZPV1g==
X-Received: by 2002:a17:906:81c9:: with SMTP id e9mr34531938ejx.456.1615981180091;
        Wed, 17 Mar 2021 04:39:40 -0700 (PDT)
Received: from oberon.vmware.com ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p3sm11124492ejd.7.2021.03.17.04.39.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 04:39:39 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 2/2] trace-cmd: Wait for first time sync before the trace
Date:   Wed, 17 Mar 2021 13:39:36 +0200
Message-Id: <20210317113936.271143-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210317113936.271143-1-tz.stoyanov@gmail.com>
References: <20210317113936.271143-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added a barrier in time synchronization threads to ensure the first time
synchronization passed before to start the trace.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-timesync.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index 0c90b413..4c03052d 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -534,6 +534,7 @@ void tracecmd_tsync_free(struct tracecmd_time_sync *tsync)
 	tsync_context->sync_size = 0;
 	pthread_mutex_destroy(&tsync->lock);
 	pthread_cond_destroy(&tsync->cond);
+	pthread_barrier_destroy(&tsync->first_sync);
 	free(tsync->clock_str);
 	free(tsync->proto_name);
 	free(tsync);
@@ -645,12 +646,15 @@ static int tsync_with_guest(struct tracecmd_time_sync *tsync)
 	int ts_array_size = CLOCK_TS_ARRAY;
 	struct tsync_proto *proto;
 	struct timespec timeout;
+	bool first = true;
 	bool end = false;
 	int ret;
 
 	clock_context_init(tsync, &proto, false);
-	if (!tsync->context)
+	if (!tsync->context) {
+		pthread_barrier_wait(&tsync->first_sync);
 		return -1;
+	}
 
 	if (tsync->loop_interval > 0 &&
 	    tsync->loop_interval < (CLOCK_TS_ARRAY * 1000))
@@ -663,6 +667,10 @@ static int tsync_with_guest(struct tracecmd_time_sync *tsync)
 						  TRACECMD_TIME_SYNC_CMD_PROBE,
 						  0, NULL);
 		ret = tsync_get_sample(tsync, proto, ts_array_size);
+		if (first) {
+			first = false;
+			pthread_barrier_wait(&tsync->first_sync);
+		}
 		if (ret || end)
 			break;
 		if (tsync->loop_interval > 0) {
@@ -754,6 +762,7 @@ tracecmd_tsync_with_guest(unsigned long long trace_id, int loop_interval,
 		tsync->clock_str = strdup(clock);
 	pthread_mutex_init(&tsync->lock, NULL);
 	pthread_cond_init(&tsync->cond, NULL);
+	pthread_barrier_init(&tsync->first_sync, NULL, 2);
 	pthread_attr_init(&attrib);
 	pthread_attr_setdetachstate(&attrib, PTHREAD_CREATE_JOINABLE);
 
@@ -764,6 +773,7 @@ tracecmd_tsync_with_guest(unsigned long long trace_id, int loop_interval,
 
 	if (!get_first_cpu(&pin_mask, &mask_size))
 		pthread_setaffinity_np(tsync->thread, mask_size, pin_mask);
+	pthread_barrier_wait(&tsync->first_sync);
 
 	if (pin_mask)
 		CPU_FREE(pin_mask);
-- 
2.29.2


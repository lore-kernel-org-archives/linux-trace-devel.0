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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A8D8C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Feb 2021 16:25:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDAE364F1C
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Feb 2021 16:25:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233571AbhBYQZi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Feb 2021 11:25:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233443AbhBYQZb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Feb 2021 11:25:31 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 362E8C061788
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Feb 2021 08:24:50 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id c23so1212128edr.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Feb 2021 08:24:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=995If0yn/GvAjPK8BEWKuXaVZs/c2n3wjtKJKEMASog=;
        b=c4+EJqGelDSNug2wge4SI23E8mAWg9epDoeDFsHHSQqJUc1iy29x5lXl2keCnjLpLY
         DURb1wS3cmcNoy51JiV+DKGtCi/c27nSYYH1aQjRoPTPRFX0ToiB2XQY9a3qXZGuZZWw
         VulHjZRhZlN5CogaSQTuPpO9eIOCelivMZ3bOQ6RtvZGHlyWRSnUdMIWm6qp2Vnnx8o9
         F/pO4XBeFMp+e2Iwc3Korf8qpu7V1EbJT8nDJYAgvZ9PhDs/rFQu0hVtg32mUYXUgD6U
         x5rmXNFj2G9Xoqfu1GHT75rFXS27yeIs9U91u+gmeYS+dP09/RAo/iyS+Q8uYEjrynvU
         TdhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=995If0yn/GvAjPK8BEWKuXaVZs/c2n3wjtKJKEMASog=;
        b=sI2o3XvulGOaAhWx2tSwciREa+DlRIGfR9743AlfhKfc91CY1yIwutsZIOXbn4UZQD
         VXwPJ9xOYPKb/DCeXejpUSEfL7JUsmq+VPQMuMsN5frONRjd1HFyPJo4JYidek1M8Nqu
         6psiHNnOmz1gPGXIkCIzXUsd9pJW3zfLY0V8NDQ25VCbk9cQFBWucCEQ0bcbZ344UfFL
         D5uyQ3xocqZ6R9Wl6hKiVqviGZ06brYyA57C59TKpMXqpc/2hCiQPOmE2HxrzEFytTQ2
         r/TgIuPvm1825++Tscm5EL+7NRto4kxHpEexYfle9nHy6aCTtNwKW3PSeSJSybqVH7U8
         K/1A==
X-Gm-Message-State: AOAM53353lKanbCoSTr997kYyMWSK0ELoKNlG83Cg0oN1k83FNGQFMp9
        /zZnCvH0+qiEr+SgJaOTKIc4Qg6/d/M/cw==
X-Google-Smtp-Source: ABdhPJxuAslE99zW4XabjZIiu+x/BjW6ylwHbTCAbSPn2mHOlNjRay6hxJUWy2bTcOrahG22foPRrA==
X-Received: by 2002:aa7:da4b:: with SMTP id w11mr3841098eds.66.1614270289049;
        Thu, 25 Feb 2021 08:24:49 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id qn24sm3096339ejb.104.2021.02.25.08.24.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 08:24:48 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v30 4/7] trace-cmd: Wait for first time sync before the trace
Date:   Thu, 25 Feb 2021 18:24:39 +0200
Message-Id: <20210225162442.173759-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210225162442.173759-1-tz.stoyanov@gmail.com>
References: <20210225162442.173759-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added a barrier in time synchronization threads to ensure the first time
synchronization passed before to start the trace.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-timesync.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index d38ee975..1e8ba509 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -571,6 +571,7 @@ void tracecmd_tsync_free(struct tracecmd_time_sync *tsync)
 	}
 	pthread_mutex_destroy(&tsync->lock);
 	pthread_cond_destroy(&tsync->cond);
+	pthread_barrier_destroy(&tsync->first_sync);
 	free(tsync->clock_str);
 	free(tsync->proto_name);
 	free(tsync);
@@ -753,6 +754,7 @@ static int tsync_with_guest(struct tracecmd_time_sync *tsync)
 	int ts_array_size = CLOCK_TS_ARRAY;
 	struct tsync_proto *proto;
 	struct timespec timeout;
+	bool first = true;
 	bool end = false;
 	int ret;
 	int i;
@@ -777,6 +779,10 @@ static int tsync_with_guest(struct tracecmd_time_sync *tsync)
 			if (ret)
 				break;
 		}
+		if (first) {
+			first = false;
+			pthread_barrier_wait(&tsync->first_sync);
+		}
 		if (end || i < tsync->vcpu_count)
 			break;
 		if (tsync->loop_interval > 0) {
@@ -804,12 +810,17 @@ static int tsync_with_guest(struct tracecmd_time_sync *tsync)
 static void *tsync_host_thread(void *data)
 {
 	struct tracecmd_time_sync *tsync = NULL;
+	int ret;
 
 	tsync = (struct tracecmd_time_sync *)data;
-	tsync_with_guest(tsync);
+	ret = tsync_with_guest(tsync);
 	tracecmd_msg_handle_close(tsync->msg_handle);
 	tsync->msg_handle = NULL;
 
+	/* tsync with guest failed, release the barrier */
+	if (ret)
+		pthread_barrier_wait(&tsync->first_sync);
+
 	pthread_exit(0);
 }
 
@@ -868,6 +879,7 @@ tracecmd_tsync_with_guest(unsigned long long trace_id, int loop_interval,
 		tsync->clock_str = strdup(clock);
 	pthread_mutex_init(&tsync->lock, NULL);
 	pthread_cond_init(&tsync->cond, NULL);
+	pthread_barrier_init(&tsync->first_sync, NULL, 2);
 	pthread_attr_init(&attrib);
 	pthread_attr_setdetachstate(&attrib, PTHREAD_CREATE_JOINABLE);
 
@@ -878,6 +890,7 @@ tracecmd_tsync_with_guest(unsigned long long trace_id, int loop_interval,
 
 	if (!get_first_cpu(&pin_mask, &mask_size))
 		pthread_setaffinity_np(tsync->thread, mask_size, pin_mask);
+	pthread_barrier_wait(&tsync->first_sync);
 
 	if (pin_mask)
 		CPU_FREE(pin_mask);
-- 
2.29.2


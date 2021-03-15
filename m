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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F95FC433E0
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Mar 2021 06:19:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02DB860240
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Mar 2021 06:19:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbhCOGS6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Mar 2021 02:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbhCOGS1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Mar 2021 02:18:27 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9664DC061574
        for <linux-trace-devel@vger.kernel.org>; Sun, 14 Mar 2021 23:18:26 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id h10so15879832edt.13
        for <linux-trace-devel@vger.kernel.org>; Sun, 14 Mar 2021 23:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jTUUILfXsC6ue8Yx9j4AhYDrOTuy4f4+146+/asIGVc=;
        b=PRLUdjh5AoEtox9vcMysmurwpK8vL210aAC/7KxHbM7gvIckOeGx0Jvuq5Sw6F62HD
         +0zgb5uwi4oWsCuu5DaaddMyUlLkT5zgWOHeBhl+iRHoJetfCiTLW53udGwb3PlD8jmi
         BA9mEDy+mHQ+jx0rXaNJDx7a4f+/gqf0LqOeBhQ0Y9/8AXvbeLNb2hEqFvC0275zey9t
         dMXKfB76RCdaV5tSGBuCvAINCW3XIqsBFomo8LgsRRssYYoliNoxIS9UJeKoVKeBIrxo
         dFhJ2nptdVYN97WGGZocN9DqWVaBp3HOnfqYu6kdnoolHsCcFTQMICU1X0VcKE8Cw0J7
         eE3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jTUUILfXsC6ue8Yx9j4AhYDrOTuy4f4+146+/asIGVc=;
        b=So7dYKNbOOG5myx3RRUci5Czm+csbDOspaylGFRdolelFkGwmRYmHx+xy1xrBjJEJc
         oI8lvVgALUBPeH/6sIfUSgtuTgE3LvREEq3gcBs2kZP2IwIwKJIih+/gcrjuDM60coYr
         FBZDdw1QuRQeqjznbWGOCeKwmq3syguPoZ21V1V5uj6sKsWnVxzWEfsoI4sWijxY67V8
         RVcXJnCDHtTWIX2HIndgbAfCvbhH+VkhGECvqTd/RZxxZfsnX2fsW8kTj5s7VkU27IfB
         Ve43mwJIFyeK/22VC2g9T3m7zEm8dvGJ/gHxr2Jg5r9J/KVy29ux8LLVkRALiytXQeRz
         1t8w==
X-Gm-Message-State: AOAM533iVdRYZaPKkOzaV/RfUiH4j+AKH2ReJ29V7/Ftk3YLE/lPtIi8
        L/EeanBeJMi4tG+jh4MJiYhfMxDA9PRcjg==
X-Google-Smtp-Source: ABdhPJwjEOaI2n1vW5+6VD2I6Ael/fjwOCqxO5ulwBDMHknDt6Sed8XvRLsPM/p+wQa0LSnR8xFlMw==
X-Received: by 2002:a05:6402:32a:: with SMTP id q10mr27676585edw.15.1615789105385;
        Sun, 14 Mar 2021 23:18:25 -0700 (PDT)
Received: from localhost.localdomain ([130.185.229.134])
        by smtp.gmail.com with ESMTPSA id nd36sm3575317ejc.21.2021.03.14.23.18.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 23:18:24 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/2] trace-cmd: Wait for first time sync before the trace
Date:   Mon, 15 Mar 2021 08:18:19 +0200
Message-Id: <20210315061819.168426-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210315061819.168426-1-tz.stoyanov@gmail.com>
References: <20210315061819.168426-1-tz.stoyanov@gmail.com>
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
index 06853f9d..5995551e 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -537,6 +537,7 @@ void tracecmd_tsync_free(struct tracecmd_time_sync *tsync)
 	tsync_context->sync_size = 0;
 	pthread_mutex_destroy(&tsync->lock);
 	pthread_cond_destroy(&tsync->cond);
+	pthread_barrier_destroy(&tsync->first_sync);
 	free(tsync->clock_str);
 	free(tsync->proto_name);
 	free(tsync);
@@ -648,6 +649,7 @@ static int tsync_with_guest(struct tracecmd_time_sync *tsync)
 	int ts_array_size = CLOCK_TS_ARRAY;
 	struct tsync_proto *proto;
 	struct timespec timeout;
+	bool first = true;
 	bool end = false;
 	int ret;
 
@@ -666,6 +668,10 @@ static int tsync_with_guest(struct tracecmd_time_sync *tsync)
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
@@ -693,12 +699,17 @@ static int tsync_with_guest(struct tracecmd_time_sync *tsync)
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
 
@@ -757,6 +768,7 @@ tracecmd_tsync_with_guest(unsigned long long trace_id, int loop_interval,
 		tsync->clock_str = strdup(clock);
 	pthread_mutex_init(&tsync->lock, NULL);
 	pthread_cond_init(&tsync->cond, NULL);
+	pthread_barrier_init(&tsync->first_sync, NULL, 2);
 	pthread_attr_init(&attrib);
 	pthread_attr_setdetachstate(&attrib, PTHREAD_CREATE_JOINABLE);
 
@@ -767,6 +779,7 @@ tracecmd_tsync_with_guest(unsigned long long trace_id, int loop_interval,
 
 	if (!get_first_cpu(&pin_mask, &mask_size))
 		pthread_setaffinity_np(tsync->thread, mask_size, pin_mask);
+	pthread_barrier_wait(&tsync->first_sync);
 
 	if (pin_mask)
 		CPU_FREE(pin_mask);
-- 
2.29.2


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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1FCDC4332E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 08:49:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F56B64FD8
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 08:49:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbhCKItR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Mar 2021 03:49:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231735AbhCKItL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Mar 2021 03:49:11 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E8DCC061760
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Mar 2021 00:49:11 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id e19so44591358ejt.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Mar 2021 00:49:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=995If0yn/GvAjPK8BEWKuXaVZs/c2n3wjtKJKEMASog=;
        b=TRCUYff7Jvw9ECQ9l+YAUYQNfO/hpaL3jRQqUWon/mQ8QhbGLdI6+1lrh21h+S4urz
         XRZ5mbpATWeUbjbhbytUMCwzq1S+cVu1t+ZClxdwF11q7l+rjkFaqgWN6ulFVeKKtlsd
         /+n4RyM36sCxQS3l3O+uTxN/aLFEuFXgpxb7tWs7lRoAEfBcDzh28hL/EvUdGlYMUE8T
         Ual0nqWeGfKcuXXbhKvffirMQ4wem1wYc27h1TUDnYTjOwkr8sRAYTPV3uJc2PQWacE8
         ui1KXuyVkZi1lDoYiIxWj/KZiMQoh4fHap/NnltsTBUUkeMOBsbyxCSZi8h94wQld+tJ
         ZMMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=995If0yn/GvAjPK8BEWKuXaVZs/c2n3wjtKJKEMASog=;
        b=R1gxF8WzdQWhJPfDmtLPcBmCqqQT98QS7CZDGfLkuKoHrBthlDhyRhW1qAc6t/HceZ
         UHwIKw1BbShrwuqHt6a1Q86ncYD95gZsF8oNd1v9VUfWmd/NdS44cjVQkGMPevTSB1Bn
         DjcwmqyOeJ/tnsJCdQVNNO/DH5VwZHepT/Pt8iQh5jmbsMcuuRop7KF6hZtMQEACQlM5
         fFVGWkNfmpxzDX5YOJshjyWKgNfNvpve6OHwTBLlbDa0eWKyFaqdatbqR/g2lrx8ZJZf
         CHppKSYkE6L/M/jSa1oPrbpYDtVXOIUI6/hMXKrXRsRRn5Tj1Beb5dpc84GJTOFQWOG8
         f+ag==
X-Gm-Message-State: AOAM533SADHGhGAb8BS47N0R787+Y3CYVIwFrj1bAV3yX7xvBPQc2Pyj
        PwBhR8A2PVW21KQor4/Jut0=
X-Google-Smtp-Source: ABdhPJySY7qfguw1fHI35i9nuKXNpyHaUG7vzm5oyKRjplbV9xBFEVC6tmblVpKHx1Q7OQpljZQjWQ==
X-Received: by 2002:a17:906:c402:: with SMTP id u2mr2017765ejz.546.1615452549791;
        Thu, 11 Mar 2021 00:49:09 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id fi11sm901647ejb.73.2021.03.11.00.49.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 00:49:09 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v31 04/16] trace-cmd: Wait for first time sync before the trace
Date:   Thu, 11 Mar 2021 10:48:45 +0200
Message-Id: <20210311084857.1919805-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311084857.1919805-1-tz.stoyanov@gmail.com>
References: <20210311084857.1919805-1-tz.stoyanov@gmail.com>
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


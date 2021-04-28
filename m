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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F608C433ED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 13:47:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4331661158
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 13:47:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239917AbhD1Nsf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 09:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbhD1Nsd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 09:48:33 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6404AC06138B
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 06:47:48 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id d14so10478430edc.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 06:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0z89Or18S3fMIPn49h/dWPO7Hpy/HGngH6D0T3cQQYc=;
        b=F67XPhRb4ElMbk0grxXfkkfyhT2iR6iBkpZRTASOaUUkDLh2iXnKmnlKYU88yUQy9W
         nLry0eyuBEGU+J9Myce58vmREUoeDljl7dg/+cdoWBz7EiAl7MTJ9dk8rCUpNHKd9JgW
         xfOcAn7/sfFzS30KHaA6qgZL5PEbR76uijLKWQ8aQvVZq8CxYE06fu3rK3OOtVnXamah
         UO0kIJ232rc1uNfXP9NpqW4QqnY2+xUQvGRoB0axmDNRfWwlKyT885dwRH0+hzKlYGmc
         V2Hmo/gkpkRFzmOXa36XiOe8nXdtRTIIT5DLZnc7tZb234Ohfd/Dl6sUjcAXli3zhOe7
         XDSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0z89Or18S3fMIPn49h/dWPO7Hpy/HGngH6D0T3cQQYc=;
        b=UIFqxwVgAMiUt+csvGse3s/mVY7RpTMnyTHwvcHok24JEpJOmjOX9bY4jSuWD04pxI
         xMJevOkEsCGOahIJ7jN+cfgL+bB2L8zlfs9lYqhTuEhdLr4ES8q3a+YhhTqTrshT+gH1
         DivZCH7ruM/o8qda1PNm76cbAXJ+UcKBy6gtnEyWrYiWDWup+yR/r0H+F2LJsDF63x7c
         VoWTI3csA9NkrNDlQE3R61BcP3TOOXSOz1p+hFeFVDbckzTuiRy1az2On1s3IxoyH+iN
         0IJ+hbMvV2dulIAZkewl6GGJZUNvV36A6r2xEBqYXRqHULMwbsnoWQ/62VUE/JnJySYx
         xUEg==
X-Gm-Message-State: AOAM5334JRvwKDXMR7ee4DR3egOfseK8TS2Jf1aeSNdoTdHrHbM99bzp
        JhPiIYrkDwxAKEfMZZoQyYYrhguAQWM=
X-Google-Smtp-Source: ABdhPJytTVy6i8EJQstW1SezvCNnB1Qnaz8R3x/UKhWYRFdtygLTSqBb80uc8dndHXffMtKqwTM8Bw==
X-Received: by 2002:aa7:c2cc:: with SMTP id m12mr11338624edp.1.1619617667005;
        Wed, 28 Apr 2021 06:47:47 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id y6sm4755952edc.26.2021.04.28.06.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 06:47:46 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 8/9] kernel-shark: Remove debugging print out from plugins
Date:   Wed, 28 Apr 2021 16:47:29 +0300
Message-Id: <20210428134730.187533-9-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210428134730.187533-1-y.karadz@gmail.com>
References: <20210428134730.187533-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

We remove the print out that indicates when the "sched events" and
"missed events" plugins are initialized and closed.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/plugins/missed_events.c | 2 --
 src/plugins/sched_events.c  | 3 ---
 2 files changed, 5 deletions(-)

diff --git a/src/plugins/missed_events.c b/src/plugins/missed_events.c
index 8fe9780..8109eb8 100644
--- a/src/plugins/missed_events.c
+++ b/src/plugins/missed_events.c
@@ -20,7 +20,6 @@
 /** Load this plugin. */
 int KSHARK_PLOT_PLUGIN_INITIALIZER(struct kshark_data_stream *stream)
 {
-	printf("--> missed_events init %i\n", stream->stream_id);
 	kshark_register_draw_handler(stream, draw_missed_events);
 
 	return 1;
@@ -29,7 +28,6 @@ int KSHARK_PLOT_PLUGIN_INITIALIZER(struct kshark_data_stream *stream)
 /** Unload this plugin. */
 int KSHARK_PLOT_PLUGIN_DEINITIALIZER(struct kshark_data_stream *stream)
 {
-	printf("<-- missed_events close %i\n", stream->stream_id);
 	kshark_unregister_draw_handler(stream, draw_missed_events);
 
 	return 1;
diff --git a/src/plugins/sched_events.c b/src/plugins/sched_events.c
index e151a70..64dff8d 100644
--- a/src/plugins/sched_events.c
+++ b/src/plugins/sched_events.c
@@ -181,7 +181,6 @@ static void plugin_sched_wakeup_action(struct kshark_data_stream *stream,
 /** Load this plugin. */
 int KSHARK_PLOT_PLUGIN_INITIALIZER(struct kshark_data_stream *stream)
 {
-	printf("--> sched init %i\n", stream->stream_id);
 	struct plugin_sched_context *plugin_ctx;
 
 	plugin_ctx = __init(stream->stream_id);
@@ -206,7 +205,6 @@ int KSHARK_PLOT_PLUGIN_INITIALIZER(struct kshark_data_stream *stream)
 /** Unload this plugin. */
 int KSHARK_PLOT_PLUGIN_DEINITIALIZER(struct kshark_data_stream *stream)
 {
-	printf("<-- sched close %i\n", stream->stream_id);
 	struct plugin_sched_context *plugin_ctx = __get_context(stream->stream_id);
 	int ret = 0;
 
@@ -232,6 +230,5 @@ int KSHARK_PLOT_PLUGIN_DEINITIALIZER(struct kshark_data_stream *stream)
 /** Initialize the control interface of the plugin. */
 void *KSHARK_MENU_PLUGIN_INITIALIZER(void *gui_ptr)
 {
-	printf("--> sched init menu\n");
 	return plugin_set_gui_ptr(gui_ptr);
 }
-- 
2.27.0


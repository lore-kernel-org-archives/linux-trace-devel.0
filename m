Return-Path: <SRS0=2N9E=BG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 225FEC433ED
	for <linux-trace-devel@archiver.kernel.org>; Mon, 27 Jul 2020 07:18:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE19E20672
	for <linux-trace-devel@archiver.kernel.org>; Mon, 27 Jul 2020 07:18:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BSnffuRk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgG0HSc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 27 Jul 2020 03:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbgG0HSc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 27 Jul 2020 03:18:32 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173C1C0619D2
        for <linux-trace-devel@vger.kernel.org>; Mon, 27 Jul 2020 00:18:32 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id a14so13751411wra.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 27 Jul 2020 00:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1k5gPKYRnQprZKJ3rZxnNqBSMyTLaKsUKrZ5PCm4l20=;
        b=BSnffuRkaPrBsh++WWse/PR+F2gN5NVDsF9+F27nRGD+eCSfV5FFOOf7XoB8GKzRhC
         IgNmQsdIYwOT83xcAsIMR46Th0zaaMVpfOxW6zbTZhI+c4kzLj8FFheCP8etFzKSjYje
         HcQDJ4Li5f0GCoJiGgGGhWh+z4XC7upVLeWteJ5vU3HIxvY2LVYdrDYoGHcWQLU0fDA0
         ZQAjThGAUNejFZQpe2fNDEIfTYrwftwiOiqzP+zGEqSUxEHVt7v8+flKOIQDEtBoETwa
         p1hcDFp+/+NDOipj0cWn6z3rvVo4Ra5EJeNJrTCEx7oF5M9Oa9wsJKRnwyN0WRSLjEr5
         AJVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1k5gPKYRnQprZKJ3rZxnNqBSMyTLaKsUKrZ5PCm4l20=;
        b=D1WVCgGzIbhUzPpsWqGY/+wAmRXsPgre3/Jw7C72WFtebJjejwvBVfJIfkpiTurEwR
         WNsnTMdXjAFQm4h45lp6AldXLBkiLt/UJl2WvGNuvvaVswFXXYT3+5/LW8Xwi+Skllgm
         nfz0QeutUcc5+3hS62FfVExibUqwEjSuTDxgzkC6oUbpEiRS2fpf3J0iJmPxzKgQQsNZ
         wy7CU4WLHbcRSF6kttCXS92trJFzjAZgwIuy8pbc93984FgIaHje4+246lMBU+1yuc7Z
         xYP+6XNxnSkGAp5LYWmYjp8BR0tp+tRcH9VbSNpmkLvqBzNdj2fWwz1UliG48ej4ciH+
         oKfg==
X-Gm-Message-State: AOAM5307IPyzdQr18pGes3t0ekb4JIIXi9o974XG0Wv7T/32cc4CmLev
        tH+7FecxtVqqLKDSS/BNxnM=
X-Google-Smtp-Source: ABdhPJxnK6HJBD0Lm+rl/w/MnShaSfCTrWN+kfSiVXSSEPWlDF+6PJ/81JdLZUtldMwfMv5l2LTiTA==
X-Received: by 2002:adf:f8d0:: with SMTP id f16mr11823982wrq.66.1595834310808;
        Mon, 27 Jul 2020 00:18:30 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j24sm12312162wrb.49.2020.07.27.00.18.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 00:18:30 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 4/5] KernelShark: Load trace.dat file with ftrace sub-buffers
Date:   Mon, 27 Jul 2020 10:18:22 +0300
Message-Id: <20200727071823.169962-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200727071823.169962-1-tz.stoyanov@gmail.com>
References: <20200727071823.169962-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>

Ftrace supports parallel tracing in isolated ring buffers. Trace-cmd
also supprts this ftrace functionality, it saves the data from all
buffers into single trace.dat file. When such file is opened by
KernelShark, it loads the tracing data only from the top biffer.
Support for loading data from all buffers, located in a single trace.dat
file, is added. Each buffer is loaded as different KernelShark session.

Signed-off-by: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
---
 src/libkshark-tepdata.c | 122 ++++++++++++++++++++++++++++++----------
 1 file changed, 92 insertions(+), 30 deletions(-)

diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
index efd8c82..4b3a57d 100644
--- a/src/libkshark-tepdata.c
+++ b/src/libkshark-tepdata.c
@@ -1134,55 +1134,60 @@ out:
 	return peer_handle;
 }
 
-/** Initialize the FTRACE data input (from file). */
-int kshark_tep_init_input(struct kshark_data_stream *stream,
-			  const char *file)
+static int kshark_tep_init_stream(struct kshark_context *kshark_ctx,
+				  struct kshark_data_stream *stream,
+				  const char *file,
+				  struct kshark_data_stream *parent,
+				  int instance)
 {
-	struct kshark_context *kshark_ctx = NULL;
 	struct tepdata_handle *tep_handle;
-	struct kshark_plugin_list *plugin;
+	struct tepdata_handle *tep_parent;
 	struct tracecmd_input *merge_peer;
+	struct kshark_plugin_list *plugin;
 	struct tep_event *event;
 	int i, n_tep_plugins;
 	int ret;
-
-	if (!kshark_instance(&kshark_ctx) || !init_thread_seq())
-		return -EEXIST;
-
-	/*
-	 * Turn off function trace indent and turn on show parent
-	 * if possible.
-	 */
-	tep_plugin_add_option("ftrace:parent", "1");
-	tep_plugin_add_option("ftrace:indent", "0");
+	char *name;
 
 	tep_handle = calloc(1, sizeof(*tep_handle));
 	if (!tep_handle)
 		return -EFAULT;
 
-	/** Open the tracing file, parse headers and create trace input context */
-	tep_handle->input = tracecmd_open_head(file);
-	if (!tep_handle->input) {
-		free(tep_handle);
-		stream->interface.handle = NULL;
-		return -EEXIST;
+	if (!parent || instance < 0) {
+		/** Open the tracing file, parse headers and create trace input context */
+		tep_handle->input = tracecmd_open_head(file);
+		if (!tep_handle->input) {
+			free(tep_handle);
+			stream->interface.handle = NULL;
+			return -EEXIST;
+		}
+		/** Find a merge peer from the same tracing session */
+		merge_peer = kshark_tep_find_merge_peer(kshark_ctx, tep_handle->input);
+		if (merge_peer)
+			tracecmd_pair_peer(tep_handle->input, merge_peer);
+
+		/** Read the racing data from the file */
+		ret = tracecmd_init_data(tep_handle->input);
+		name = "top";
+	} else {
+		tep_parent = (struct tepdata_handle *)parent->interface.handle;
+		name = tracecmd_buffer_instance_name(tep_parent->input, instance);
+		stream->file = strdup(file);
+		asprintf(&stream->name, "%s:%s", stream->file, name);
+		tep_handle->input = tracecmd_buffer_instance_handle(tep_parent->input, instance);
+		tracecmd_print_stats(tep_handle->input);
+		if (!tep_handle->input)
+			ret = -1;
+		else
+			ret = 0;
 	}
 
-	/** Find a merge peer from the same tracing session */
-	merge_peer = kshark_tep_find_merge_peer(kshark_ctx, tep_handle->input);
-	if (merge_peer)
-		tracecmd_pair_peer(tep_handle->input, merge_peer);
-
-	/** Read the racing data from the file */
-	ret = tracecmd_init_data(tep_handle->input);
-
 	if (ret < 0) {
 		tracecmd_close(tep_handle->input);
 		free(tep_handle);
 		stream->interface.handle = NULL;
 		return -EEXIST;
 	}
-
 	tep_handle->tep = tracecmd_get_pevent(tep_handle->input);
 
 	tep_handle->sched_switch_event_id = -EINVAL;
@@ -1224,8 +1229,65 @@ int kshark_tep_init_input(struct kshark_data_stream *stream,
 	}
 
 	kshark_handle_all_dpis(stream, KSHARK_PLUGIN_INIT);
+	return 0;
+}
 
+/** Initialize the FTRACE data input (from file). */
+int kshark_tep_init_input(struct kshark_data_stream *stream,
+			  const char *file)
+{
+	struct kshark_context *kshark_ctx = NULL;
+	struct kshark_data_stream *child_stream;
+	struct tepdata_handle *tep_handle;
+	int count;
+	int ret;
+	int sd;
+	int i;
+
+	if (!kshark_instance(&kshark_ctx) || !init_thread_seq())
+		return -EEXIST;
+
+	/*
+	 * Turn off function trace indent and turn on show parent
+	 * if possible.
+	 */
+	tep_plugin_add_option("ftrace:parent", "1");
+	tep_plugin_add_option("ftrace:indent", "0");
+
+	ret = kshark_tep_init_stream(kshark_ctx, stream, file, NULL, -1);
+	if (ret < 0)
+		return ret;
+	tep_handle = (struct tepdata_handle *)stream->interface.handle;
+	count = tracecmd_buffer_instances(tep_handle->input);
+	for (i = 0; i < count; i++) {
+		sd = kshark_add_stream(kshark_ctx);
+		if (sd < 0) {
+			ret = sd;
+			goto error;
+		}
+		child_stream = kshark_ctx->stream[sd];
+		if (!child_stream) {
+			ret = -ENOMEM;
+			goto error;
+		}
+		if (pthread_mutex_init(&child_stream->input_mutex, NULL) != 0) {
+			ret = -EAGAIN;
+			goto error;
+		}
+		child_stream->format = KS_TEP_DATA;
+		ret = kshark_tep_init_stream(kshark_ctx, child_stream, file, stream, i);
+		if (ret < 0)
+			goto error;
+		kshark_ctx->n_streams++;
+	}
 	return 0;
+
+error:
+		tracecmd_close(tep_handle->input);
+		free(tep_handle);
+		stream->interface.handle = NULL;
+		return ret;
+
 }
 
 /** Initialize using the locally available tracing events. */
-- 
2.26.2


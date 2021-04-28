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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7765C43461
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 13:47:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA9ED61158
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 13:47:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239904AbhD1Nsd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 09:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234535AbhD1Nsa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 09:48:30 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F7DC061342
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 06:47:45 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id q6so15028143edr.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 06:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=stdNPv/pyxC7nT7tQP0ydAgWb6oYgZN23vCOEG8//SY=;
        b=mD8mnopRsaeSG/0a3SDfmfz8s//ZFobyrP1ls8zpCXPxO1IFApW3Q6wScqGgnn4nLw
         upb74yWKKXfUlAVmVkU3ilJFMVyMGvQB/hO9knd4lJnGsa4IxJ5tExn+/FZT3sjJthQJ
         OJkapfBTmjJyY0k2kc5/5RNNPcmxtiugmJxQB+ulpV4TbTWsdJ/Uk6jDdqyTFVoQfGJU
         EQWwPXXgIoiYXnutvMkUX6YDt8wPpnycnmj+qeZuPiPL3BFNubSt4Dk5VK5uYxW0nTDk
         NfOViTZsrfcKN5RRSBAXJpPyJLaWqOG66D+aeOtrSd3RgwL3cVVGJzusUAT64PIdcWui
         PDQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=stdNPv/pyxC7nT7tQP0ydAgWb6oYgZN23vCOEG8//SY=;
        b=m7l7jbJsJOmyQMmqIh7vpsQXHuRe6LU0PYNhGuCinrcDFT1A2KnJczneiDPBcT5bB8
         2BjJYII1SQRD6OWdLxo47wpTI5pzu50G8NbOdWv+qdCtqH1A7gP9PK9mUL0j1buN2bp5
         BjFGHJUrRf50gKmpYegk5Ptmwh9rQ2E97ziIrpO8PmQD7vEbpfHJrsRM7wQN9uWhmTWJ
         gcXyolhFSCXJcqnntKmj5Lza1HktpNjyJpjbEwOfikhVxwhuLdVLHUSCY5n78tlsqUd3
         wKluZYr48mTz7iSiiS9qUm2coIF+wUxi9+TKZIcftf4KlyvaW8XwrKzgr1RLBSyKbDRd
         JBZA==
X-Gm-Message-State: AOAM53259NyFw08nyicrwrFiDXk6oDSv4dmsI5B74MGEvAlhUxPbix7T
        x1hK2LUuqaiP9pYU2dmhkph21R/amT0=
X-Google-Smtp-Source: ABdhPJxq2QPhHQNbo1ogSiG8jTbeoYmmsmP2yxhu9VBoIG8ACwpe69W/QL3nmLbbVOt2d/v8vw2L7A==
X-Received: by 2002:a05:6402:190d:: with SMTP id e13mr11352422edz.151.1619617663567;
        Wed, 28 Apr 2021 06:47:43 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id y6sm4755952edc.26.2021.04.28.06.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 06:47:43 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 4/9] kernel-shark: Add cleanup of all plugin contexts
Date:   Wed, 28 Apr 2021 16:47:25 +0300
Message-Id: <20210428134730.187533-5-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210428134730.187533-1-y.karadz@gmail.com>
References: <20210428134730.187533-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When the macro KS_DEFINE_PLUGIN_CONTEXT is used by the plugin,
the final free of the memory is done by calling __close() with a
negative stream id. Althow, this was provisioned in the definition
of the macro, it was never implemented in the GUI.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark-plugin.c     | 10 ++++++++++
 src/libkshark-plugin.h     | 25 ++++++++++++++++---------
 src/libkshark.h            |  2 +-
 src/plugins/sched_events.c | 28 ++++++++++++++--------------
 4 files changed, 41 insertions(+), 24 deletions(-)

diff --git a/src/libkshark-plugin.c b/src/libkshark-plugin.c
index ebd2579..09886ce 100644
--- a/src/libkshark-plugin.c
+++ b/src/libkshark-plugin.c
@@ -117,6 +117,9 @@ int kshark_unregister_event_handler(struct kshark_data_stream *stream,
 {
 	struct kshark_event_proc_handler **last;
 
+	if (stream->stream_id < 0)
+		return 0;
+
 	for (last = &stream->event_handlers; *last; last = &(*last)->next) {
 		if ((*last)->id == event_id &&
 		    (*last)->event_func == evt_func) {
@@ -182,6 +185,9 @@ void kshark_unregister_draw_handler(struct kshark_data_stream *stream,
 {
 	struct kshark_draw_handler **last;
 
+	if (stream->stream_id < 0)
+		return;
+
 	for (last = &stream->draw_handlers; *last; last = &(*last)->next) {
 		if ((*last)->draw_func == draw_func) {
 			struct kshark_draw_handler *this_handler;
@@ -410,12 +416,16 @@ void kshark_unregister_plugin(struct kshark_context *kshark_ctx,
  */
 void kshark_free_plugin_list(struct kshark_plugin_list *plugins)
 {
+	struct kshark_data_stream stream;
 	struct kshark_plugin_list *last;
 
+	stream.stream_id = KS_PLUGIN_CONTEXT_FREE;
 	while (plugins) {
 		last = plugins;
 		plugins = plugins->next;
 
+		if (last->process_interface)
+			last->process_interface->close(&stream);
 		free_plugin(last);
 	}
 }
diff --git a/src/libkshark-plugin.h b/src/libkshark-plugin.h
index 752dbeb..b259b24 100644
--- a/src/libkshark-plugin.h
+++ b/src/libkshark-plugin.h
@@ -366,6 +366,9 @@ int kshark_handle_all_dpis(struct kshark_data_stream *stream,
 	__ok;								\
 })									\
 
+/** Identifier used to free the plugin context. */
+#define KS_PLUGIN_CONTEXT_FREE	-1
+
 /**
  * General purpose macro defining methods for adding plugin context.
  * Do not use this macro in header files.
@@ -393,21 +396,25 @@ __hidden type *__init(int sd)						\
 	__context_handler[sd] = obj;					\
 	return obj;							\
 }									\
+__hidden type *__get_context(int sd)					\
+{									\
+	if (sd < 0 || sd >= __n_streams)				\
+		return NULL;						\
+	return __context_handler[sd];					\
+}									\
 __hidden void __close(int sd)						\
 {									\
-	if (sd < 0) {							\
+	type *obj;							\
+	if (sd == KS_PLUGIN_CONTEXT_FREE) {				\
 		free(__context_handler);				\
 		__n_streams = -1;					\
 		return;							\
 	}								\
-	free(__context_handler[sd]);					\
-	__context_handler[sd] = NULL;					\
-}									\
-__hidden type *__get_context(int sd)					\
-{									\
-	if (sd < 0 || sd >= __n_streams)				\
-		return NULL;						\
-	return __context_handler[sd];					\
+	obj = __get_context(sd);					\
+	if (obj) {							\
+		free(__context_handler[sd]);				\
+		__context_handler[sd] = NULL;				\
+	}								\
 }									\
 
 /**
diff --git a/src/libkshark.h b/src/libkshark.h
index aa4b3ca..ee3a1d3 100644
--- a/src/libkshark.h
+++ b/src/libkshark.h
@@ -281,7 +281,7 @@ struct kshark_generic_stream_interface {
 /** Structure representing a stream of trace data. */
 struct kshark_data_stream {
 	/** Data stream identifier. */
-	uint16_t		stream_id;
+	int16_t			stream_id;
 
 	/** The number of CPUs presented in this data stream. */
 	int			n_cpus;
diff --git a/src/plugins/sched_events.c b/src/plugins/sched_events.c
index 5798322..f3c2c23 100644
--- a/src/plugins/sched_events.c
+++ b/src/plugins/sched_events.c
@@ -198,26 +198,26 @@ int KSHARK_PLOT_PLUGIN_INITIALIZER(struct kshark_data_stream *stream)
 int KSHARK_PLOT_PLUGIN_DEINITIALIZER(struct kshark_data_stream *stream)
 {
 	printf("<-- sched close %i\n", stream->stream_id);
-	struct plugin_sched_context *plugin_ctx;
-	int sd = stream->stream_id;
+	struct plugin_sched_context *plugin_ctx = __get_context(stream->stream_id);
+	int ret = 0;
 
-	plugin_ctx = __get_context(sd);
-	if (!plugin_ctx)
-		return 0;
+	if (plugin_ctx) {
+		kshark_unregister_event_handler(stream,
+						plugin_ctx->sched_switch_event->id,
+						plugin_sched_swith_action);
 
-	kshark_unregister_event_handler(stream,
-					plugin_ctx->sched_switch_event->id,
-					plugin_sched_swith_action);
+		kshark_unregister_event_handler(stream,
+						plugin_ctx->sched_waking_event->id,
+						plugin_sched_wakeup_action);
 
-	kshark_unregister_event_handler(stream,
-					plugin_ctx->sched_waking_event->id,
-					plugin_sched_wakeup_action);
+		kshark_unregister_draw_handler(stream, plugin_draw);
 
-	kshark_unregister_draw_handler(stream, plugin_draw);
+		ret = 1;
+	}
 
-	__close(sd);
+	__close(stream->stream_id);
 
-	return 1;
+	return ret;
 }
 
 /** Initialize the control interface of the plugin. */
-- 
2.27.0


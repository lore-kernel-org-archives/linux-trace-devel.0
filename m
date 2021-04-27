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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BF3BC433ED
	for <linux-trace-devel@archiver.kernel.org>; Tue, 27 Apr 2021 16:26:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 466A6613DD
	for <linux-trace-devel@archiver.kernel.org>; Tue, 27 Apr 2021 16:26:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238034AbhD0Q1B (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 27 Apr 2021 12:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238852AbhD0QZ6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Apr 2021 12:25:58 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17471C06135C
        for <linux-trace-devel@vger.kernel.org>; Tue, 27 Apr 2021 09:24:28 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id i24so11091141edy.8
        for <linux-trace-devel@vger.kernel.org>; Tue, 27 Apr 2021 09:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uPuP16XLbqaUCOs/SjKf2uENt8+iP9lH4i9xPgdBYUM=;
        b=ehAVyq1VnZjO5GCTjWoBYyARys25zx0f5GzPtYAQGTSIHKF/VIiYFSQJw50d89/Xfx
         oZ0xJd63B5I4H4GpCA9T5FQuZ/NuhSwHyG09k+X2HipeCTZNJ6xfBieAeDVwSxRrsrBN
         ah2YT9NLQx5nxig8DKoYeZMBZnGQccegpRDcDs4w3idueqws3ustCieE0wHreXQjwjQW
         a+GHwPZ5p8vxjHNrdwrITK+uGvzrQ483LWoxxOuAXFgiUemjVsdJP77EusCSuwExMvIg
         0QxOEvYPP/P6YAJtgeW+6twWHxBc8oq5hvYsrgMJ0I0IbAEzcLA5feH8efmW0lCxmLcd
         ZZHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uPuP16XLbqaUCOs/SjKf2uENt8+iP9lH4i9xPgdBYUM=;
        b=dQ0SwShmlSrG0agSS3nFJQcWWFBn/GPjA29MZkC0zNXJnw7Ml/OQ1qa6xv0hwMUKlz
         BTwxUtCSgwgcC5BRrynbdOLxYdAO5fprRyt7Rz+76Y5wRncKyr8sGsPGmbUn6QykZ9RH
         uE21hWztKwNO5jrq5M2wQRM2ALv7mrC/6YrwJH/VQAr+a5IeVVgTq7grLLcGp2dYcF/w
         DrLAUVeSowqygve/Rtt1WfHzCj8X99cIVP5ZaG0hjxrKFh3dgePWCNpkK8z5gVanyCDd
         gdoOtlNn0OyADj9zJoojPVwwS0OjMaNImHjePM9Gf5EMZjipJ8JIcqj3Yv4ZrmA7axba
         Yv7w==
X-Gm-Message-State: AOAM533RpVBJfPM38gusuVRnWz3x6u06FCB6eaBfQ8QkO0ulSlxluUo0
        yebOjhCyE4uwf/IRDwtbokKUZjM0tqg=
X-Google-Smtp-Source: ABdhPJwGa2KCD/PZ0e32vZ++OnymEKOD+ZfOSnjl73Ykigy24tiZtl/dmOYi4W/fKwGmIkJn1zNf0w==
X-Received: by 2002:aa7:dd01:: with SMTP id i1mr4710080edv.232.1619540666686;
        Tue, 27 Apr 2021 09:24:26 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id d15sm2740284edu.86.2021.04.27.09.24.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 09:24:26 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 4/7] kernel-shark: Add cleanup of all plugin contexts
Date:   Tue, 27 Apr 2021 19:24:05 +0300
Message-Id: <20210427162408.134001-5-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210427162408.134001-1-y.karadz@gmail.com>
References: <20210427162408.134001-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The when the macro KS_DEFINE_PLUGIN_CONTEXT is used by the plugin,
the final free of the memory is done by calling __close() with a
negative stream id. Althow, this was provisioned in the definition
of the macro, it was never implemented in the GUI.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark-plugin.c     | 10 ++++++++++
 src/libkshark-plugin.h     |  5 ++++-
 src/libkshark.h            |  2 +-
 src/plugins/sched_events.c |  4 ++++
 4 files changed, 19 insertions(+), 2 deletions(-)

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
index 752dbeb..85a0a8c 100644
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
@@ -395,7 +398,7 @@ __hidden type *__init(int sd)						\
 }									\
 __hidden void __close(int sd)						\
 {									\
-	if (sd < 0) {							\
+	if (sd == KS_PLUGIN_CONTEXT_FREE) {				\
 		free(__context_handler);				\
 		__n_streams = -1;					\
 		return;							\
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
index 5798322..5c82803 100644
--- a/src/plugins/sched_events.c
+++ b/src/plugins/sched_events.c
@@ -201,6 +201,9 @@ int KSHARK_PLOT_PLUGIN_DEINITIALIZER(struct kshark_data_stream *stream)
 	struct plugin_sched_context *plugin_ctx;
 	int sd = stream->stream_id;
 
+	if (sd == KS_PLUGIN_CONTEXT_FREE)
+		goto close;
+
 	plugin_ctx = __get_context(sd);
 	if (!plugin_ctx)
 		return 0;
@@ -215,6 +218,7 @@ int KSHARK_PLOT_PLUGIN_DEINITIALIZER(struct kshark_data_stream *stream)
 
 	kshark_unregister_draw_handler(stream, plugin_draw);
 
+ close:
 	__close(sd);
 
 	return 1;
-- 
2.27.0


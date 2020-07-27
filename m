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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A675EC433E0
	for <linux-trace-devel@archiver.kernel.org>; Mon, 27 Jul 2020 07:18:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F48920672
	for <linux-trace-devel@archiver.kernel.org>; Mon, 27 Jul 2020 07:18:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LYOsT/gX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgG0HS3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 27 Jul 2020 03:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbgG0HS3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 27 Jul 2020 03:18:29 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B04B7C0619D2
        for <linux-trace-devel@vger.kernel.org>; Mon, 27 Jul 2020 00:18:28 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id a5so3746155wrm.6
        for <linux-trace-devel@vger.kernel.org>; Mon, 27 Jul 2020 00:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6L53opn/gakiOJoGbLA4LSBmjPGetUemut73KkwNRAc=;
        b=LYOsT/gX603LGDCgjvZVrJG4Tjyo7WpprgXv3mhoCGp6VQBW7ySV1Ti9XZEinmWu60
         p2TPKNLjrlcDqfj7w/O9xR2iRv8rLvhyJ4/NW/NhUR24WCjAg4XlR54fPRoMv/hfwjaf
         oKRyOchir/80PxKt7a4fLqbdFvcDAhe4X4M3FwocnTtU1oDu8VCVPX9x4DBwdbWX1cud
         nDeRpwnkY0tkHpfbwy5cLpwHXWbL6wq1saVbzXpR6jrYdsBL4E4MISdmVdGKk6Ce21th
         J8m7Xt4i9hZMV7wubN2BtT1MzHK6nuKMbzswtE7I5T1gK0NyJs0DhDND2yt6d+zivLY9
         Xf9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6L53opn/gakiOJoGbLA4LSBmjPGetUemut73KkwNRAc=;
        b=Gq6WlsFif392CR1vLnhi2DaHClXUrkdjcVrZKbAcAKkddfVzEtAeCIOUMVcAeoq+hf
         7hBaJ80StqSOAQr3XKFQVdWoqKjXnXUVS74wuEj/UNVdEDNYqimpPTOl68JmetHB6bNZ
         pHlnhUKgIgzGz/WQJO/v4lEKua/wanJUEmOT/jdbNDmsHmSdmMxIx7HFLKbJ0jJWWwi+
         Wazkpwg+Agk9K2v2PXtCcE4HYFEvjkR+rdD9kL8FYg7vlTs2JEZLFo3CefDFgfcMMRAe
         E3qPotDg2D1CjiowKnWd8zWG+awpu3V3o629EK1lisKRt3ogFXdx0hrlVQwliBd0bhzO
         NI3g==
X-Gm-Message-State: AOAM532XWmghNRAu1HhmTHvsjxuSkWDnfEd7ykxYeP47EIP03v1z8SAC
        JkkAVO1fjTOPYYOs0QePwal8kqIfQlI=
X-Google-Smtp-Source: ABdhPJyR/J5fo6xIlrhoOHIaGLCcLWeq7ubeV0khW1Z/2UV6qs2v0QhjTDfGPZaLRFhdu/PgoGEeaA==
X-Received: by 2002:adf:d084:: with SMTP id y4mr18435234wrh.161.1595834307466;
        Mon, 27 Jul 2020 00:18:27 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j24sm12312162wrb.49.2020.07.27.00.18.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 00:18:26 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/5] KernelShark: Add stream name
Date:   Mon, 27 Jul 2020 10:18:19 +0300
Message-Id: <20200727071823.169962-2-tz.stoyanov@gmail.com>
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

There are use cases when multiple streams can be loaded from a single
file. Ftrace instances are such example. In these cases file name could
not be used to identify the streams. A new member 'name' is added to the
'struct kshark_data_stream', used to identify the streams by the user.
By default name is equal to the file name, in cases where there is onle
one stream in the file the behaviour is not changed. When there are
multiple streams in a single file, the name is formed as
"file name:stream name".

Signed-off-by: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
---
 src/KsAdvFilteringDialog.cpp   | 2 +-
 src/KsWidgetsLib.cpp           | 6 +++---
 src/libkshark-plugin.c         | 2 +-
 src/libkshark.c                | 2 ++
 src/libkshark.h                | 3 +++
 src/plugins/KVMCombo.cpp       | 4 ++--
 src/plugins/event_field_plot.c | 2 +-
 src/plugins/latency_plot.c     | 4 ++--
 8 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/src/KsAdvFilteringDialog.cpp b/src/KsAdvFilteringDialog.cpp
index 64c4cec..6979903 100644
--- a/src/KsAdvFilteringDialog.cpp
+++ b/src/KsAdvFilteringDialog.cpp
@@ -236,7 +236,7 @@ void KsAdvFilteringDialog::_getFtraceStreams(kshark_context *kshark_ctx)
 	for (int i = 0; i < kshark_ctx->n_streams; ++i) {
 		stream = kshark_ctx->stream[streamIds[i]];
 		if (stream->format == KS_TEP_DATA)
-			_streamComboBox.addItem(QString(stream->file),
+			_streamComboBox.addItem(QString(stream->name),
 						streamIds[i]);
 	}
 
diff --git a/src/KsWidgetsLib.cpp b/src/KsWidgetsLib.cpp
index e487eb8..f006a13 100644
--- a/src/KsWidgetsLib.cpp
+++ b/src/KsWidgetsLib.cpp
@@ -325,7 +325,7 @@ void KsCheckBoxWidget::_setStream(uint8_t sd)
 	if (!stream)
 		return;
 
-	_streamName = QString(stream->file);
+	_streamName = QString(stream->name);
 
 	KsUtils::setElidedText(&_stramLabel, _streamName,
 			       Qt::ElideLeft, width());
@@ -1148,7 +1148,7 @@ KsDStreamCheckBoxWidget::KsDStreamCheckBoxWidget(QWidget *parent)
 
 	for (int i = 0; i < nStreams; ++i) {
 		stream = kshark_ctx->stream[streamIds[i]];
-		QString name(stream->file);
+		QString name(stream->name);
 		if (name < 40) {
 			nameItem = new QTableWidgetItem(name);
 		} else {
@@ -1235,7 +1235,7 @@ void KsEventFieldSelectWidget::setStreamCombo()
 		sd = streamIds[i];
 		stream = kshark_ctx->stream[sd];
 		if (_streamComboBox.findData(sd) < 0)
-			_streamComboBox.addItem(QString(stream->file), sd);
+			_streamComboBox.addItem(QString(stream->name), sd);
 	}
 	free(streamIds);
 }
diff --git a/src/libkshark-plugin.c b/src/libkshark-plugin.c
index d341fea..583ea42 100644
--- a/src/libkshark-plugin.c
+++ b/src/libkshark-plugin.c
@@ -584,7 +584,7 @@ static void plugin_init(struct kshark_data_stream *stream,
 		fprintf(stderr,
 			"plugin \"%s\" failed to initialize on stream %s\n",
 			plugin->interface->name,
-			stream->file);
+			stream->name);
 
 		plugin->status |= KSHARK_PLUGIN_FAILED;
 		plugin->status &= ~KSHARK_PLUGIN_LOADED;
diff --git a/src/libkshark.c b/src/libkshark.c
index 7013d66..375874d 100644
--- a/src/libkshark.c
+++ b/src/libkshark.c
@@ -137,6 +137,7 @@ static void kshark_stream_free(struct kshark_data_stream *stream)
 
 	free(stream->calib_array);
 	free(stream->file);
+	free(stream->name);
 	free(stream);
 }
 
@@ -255,6 +256,7 @@ int kshark_stream_open(struct kshark_data_stream *stream, const char *file)
 		return -EAGAIN;
 
 	stream->file = strdup(file);
+	stream->name = strdup(file);
 	set_format(kshark_ctx, stream, file);
 
 	switch (stream->format) {
diff --git a/src/libkshark.h b/src/libkshark.h
index 0b9053d..44bec79 100644
--- a/src/libkshark.h
+++ b/src/libkshark.h
@@ -238,6 +238,9 @@ struct kshark_data_stream {
 	/** Trace data file pathname. */
 	char			*file;
 
+	/** Stream name. */
+	char			*name;
+
 	/** System clock calibration function. */
 	time_calib_func		calib;
 
diff --git a/src/plugins/KVMCombo.cpp b/src/plugins/KVMCombo.cpp
index 9b9d7a0..ceb1f47 100644
--- a/src/plugins/KVMCombo.cpp
+++ b/src/plugins/KVMCombo.cpp
@@ -250,7 +250,7 @@ void KsComboPlotDialog::update()
 		_guestMapCount = ret;
 
 	KsUtils::setElidedText(&_hostFileLabel,
-			       kshark_ctx->stream[_guestMap[0].host_id]->file,
+			       kshark_ctx->stream[_guestMap[0].host_id]->name,
 			       Qt::ElideLeft, LABEL_WIDTH);
 
 	_guestStreamComboBox.clear();
@@ -260,7 +260,7 @@ void KsComboPlotDialog::update()
 		if (sd >= kshark_ctx->n_streams)
 			continue;
 
-		_guestStreamComboBox.addItem(kshark_ctx->stream[sd]->file, sd);
+		_guestStreamComboBox.addItem(kshark_ctx->stream[sd]->name, sd);
 		color << colTable[sd];
 		_guestStreamComboBox.setItemData(i, QBrush(color),
 						    Qt::BackgroundRole);
diff --git a/src/plugins/event_field_plot.c b/src/plugins/event_field_plot.c
index fcc2a19..3c61cbf 100644
--- a/src/plugins/event_field_plot.c
+++ b/src/plugins/event_field_plot.c
@@ -72,7 +72,7 @@ plugin_efp_init_context(struct kshark_data_stream *stream)
 
 	if (plugin_ctx->event_id < 0) {
 		fprintf(stderr, "Event %s not found in stream %s\n",
-			plugin_ctx->event_name, stream->file);
+			plugin_ctx->event_name, stream->name);
 		goto fail;
 	}
 
diff --git a/src/plugins/latency_plot.c b/src/plugins/latency_plot.c
index bcd27f6..e2238e4 100644
--- a/src/plugins/latency_plot.c
+++ b/src/plugins/latency_plot.c
@@ -75,7 +75,7 @@ plugin_latency_init_context(struct kshark_data_stream *stream)
 		stream->interface.find_event_id(stream, plugin_ctx->event_name[0]);
 	if (plugin_ctx->event_id[0] < 0) {
 		fprintf(stderr, "Event %s not found in stream %s\n",
-			plugin_ctx->event_name[0], stream->file);
+			plugin_ctx->event_name[0], stream->name);
 		goto fail;
 	}
 
@@ -83,7 +83,7 @@ plugin_latency_init_context(struct kshark_data_stream *stream)
 		stream->interface.find_event_id(stream, plugin_ctx->event_name[1]);
 	if (plugin_ctx->event_id[1] < 0) {
 		fprintf(stderr, "Event %s not found in stream %s\n",
-			plugin_ctx->event_name[1], stream->file);
+			plugin_ctx->event_name[1], stream->name);
 		goto fail;
 	}
 
-- 
2.26.2


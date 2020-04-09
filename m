Return-Path: <SRS0=lsLa=5Z=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3C1DC2BBC7
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Apr 2020 14:25:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88D1220771
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Apr 2020 14:25:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IxI7gn7v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbgDIOZV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Apr 2020 10:25:21 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:33591 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727162AbgDIOZV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Apr 2020 10:25:21 -0400
Received: by mail-lj1-f195.google.com with SMTP id q22so7899337ljg.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 09 Apr 2020 07:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NZ9YLofvrpGVpsRUBmuxxvKQiZ0sjpDDHRzKMyKVSWw=;
        b=IxI7gn7vq+ZxhRwjI6ONOCLGQl09qtPmPQ5v8lwe+uWG5mePMDmeQyrwRG4HwofbLB
         M6UI3f7Z+BdksW3Dx5FPJ7JNQRygL0OE3j6pMVbI+Xomm0sixtXTp+VawnSP1jRkjugp
         Q+JD+m/cKCGuQJH3VaXJiTinlppXzT5eg70YPrxhTV7HanOZbIotV4QwMc39bIVohEaZ
         acqGk53MXgb/xix+APsSM75+bRGScAGJYycGQYiQUJYsg3n1+0/mc7AWrdFWpqv2A0wj
         7OIP60GBuCbH+6PRUzyWzMzPyLovmIdpcvRvluQ2C/BRJKIYx1aNKncK4unYDny0Sz0u
         Wn6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NZ9YLofvrpGVpsRUBmuxxvKQiZ0sjpDDHRzKMyKVSWw=;
        b=GtcWHhJzWvm2CtnfQmwxm2tBYhM3uer5wY7cIKcAyhoEWJWi0feWhfDwiY4wlrlnVH
         yMpaockoqZxpRtbNX3t9L6Z1kDsfAsMH9bucsaheVavCOe4yRkrjnuWz+V1WFmM8fet9
         zukoM0MkirJC7B9b0PDrI/HMnE6l4dggJK39P0E/3owmOElF9fYx1u+nx4KWmop0LnxL
         +YfaL10mKbcdDAQPiUu/kjz+v1zC3bQBeIAkEgrUdt7aBqK7ERx7YCcuaQEDs4J9s9QO
         JXjFGgMy3WrdyClZFQdLiiIQGuwCq0kU57OzD0CSxiwxPfkcJ1Q6BvJ5vpdAf5VFgx2H
         ESjA==
X-Gm-Message-State: AGi0PuYL9AD2sRFPXHWN94qrPNqLvnUGV+nsJYZt1wfBkYYtzdrOHmLB
        TISV9opADKGhMeWXcTiOpuI=
X-Google-Smtp-Source: APiQypIvWs4v8EOAXY5Otu3PgZyCgRTXfh8MZzTBhc85r6zSXN6SgJIoM2CsZyy7IRia24a8zbJmPg==
X-Received: by 2002:a2e:97c2:: with SMTP id m2mr28172ljj.228.1586442319664;
        Thu, 09 Apr 2020 07:25:19 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e7sm181230lfc.72.2020.04.09.07.25.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 07:25:19 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2] kernel-shark-2.alpha: Use new tracecmd APIs to open guest tracing file
Date:   Thu,  9 Apr 2020 17:25:11 +0300
Message-Id: <20200409142511.82228-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200409142511.82228-1-tz.stoyanov@gmail.com>
References: <20200409142511.82228-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>

The new tracecmd API tracecmd_open_head() allows opening a trace.dat
file on stages. First, only the headers from the file are read and parsed,
without reading the tracing data.
The tracecmd_set_merge_peer() API is used to bind a tracing peer to
this file, before parsing the trace data. This affects events timestamps
correction when the tracing data is loaded.
The tracecmd_get_guest_cpumap() API is used to find dependencies between
all files and find a possible tracing peers.

This change depends on these trace-cmd patch sets:
  "Useful APIs for merging tracing files"
https://patchwork.kernel.org/project/linux-trace-devel/list/?series=268745
  "Split reading the trace.dat options from trace data"
https://patchwork.kernel.org/project/linux-trace-devel/list/?series=268743

Signed-off-by: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
---
 src/libkshark-tepdata.c | 59 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 58 insertions(+), 1 deletion(-)

diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
index 8678e12..c68b52a 100644
--- a/src/libkshark-tepdata.c
+++ b/src/libkshark-tepdata.c
@@ -985,6 +985,45 @@ const char *tep_plugin_names[] = {"sched_events",
 
 #define LINUX_IDLE_TASK_PID	0
 
+/** Find a host stream from the same tracing session, that has guest information */
+struct tracecmd_input *kshark_tep_find_merge_peer(struct kshark_context *kshark_ctx,
+						  struct tracecmd_input *handle)
+{
+	struct tracecmd_input *peer_handle = NULL;
+	struct kshark_data_stream *peer_stream;
+	unsigned long long trace_id;
+	int *streamIds = NULL;
+	int ret;
+	int i;
+
+	trace_id = tracecmd_get_traceid(handle);
+	if (!trace_id)
+		goto out;
+
+	streamIds = kshark_all_streams(kshark_ctx);
+	if (!streamIds)
+		goto out;
+	for (i = 0; i < kshark_ctx->n_streams; i++) {
+		peer_stream = kshark_get_data_stream(kshark_ctx, streamIds[i]);
+		if (!peer_stream || peer_stream->format != KS_TEP_DATA)
+			continue;
+		peer_handle = kshark_get_tep_input(peer_stream);
+		if (!peer_handle)
+			continue;
+		ret = tracecmd_get_guest_cpumap(peer_handle, trace_id,
+						NULL, NULL, NULL);
+		if (!ret)
+			break;
+	}
+
+	if (i == kshark_ctx->n_streams)
+		peer_handle = NULL;
+
+out:
+	free(streamIds);
+	return peer_handle;
+}
+
 /** Initialize the FTRACE data input (from file). */
 int kshark_tep_init_input(struct kshark_data_stream *stream,
 			  const char *file)
@@ -992,8 +1031,10 @@ int kshark_tep_init_input(struct kshark_data_stream *stream,
 	struct kshark_context *kshark_ctx = NULL;
 	struct tepdata_handle *tep_handle;
 	struct kshark_plugin_list *plugin;
+	struct tracecmd_input *merge_peer;
 	struct tep_event *event;
 	int i, n_tep_plugins;
+	int ret;
 
 	if (!kshark_instance(&kshark_ctx) || !init_thread_seq())
 		return -EEXIST;
@@ -1009,13 +1050,29 @@ int kshark_tep_init_input(struct kshark_data_stream *stream,
 	if (!tep_handle)
 		return -EFAULT;
 
-	tep_handle->input = tracecmd_open(file);
+	/** Open the tracing file, parse headers and create trace input context */
+	tep_handle->input = tracecmd_open_head(file);
 	if (!tep_handle->input) {
 		free(tep_handle);
 		stream->interface.handle = NULL;
 		return -EEXIST;
 	}
 
+	/** Find a merge peer from the same tracing session */
+	merge_peer = kshark_tep_find_merge_peer(kshark_ctx, tep_handle->input);
+	if (merge_peer)
+		tracecmd_set_merge_peer(tep_handle->input, merge_peer);
+
+	/** Read the racing data from the file */
+	ret = tracecmd_init_data(tep_handle->input);
+
+	if (ret < 0) {
+		tracecmd_close(tep_handle->input);
+		free(tep_handle);
+		stream->interface.handle = NULL;
+		return -EEXIST;
+	}
+
 	tep_handle->tep = tracecmd_get_pevent(tep_handle->input);
 
 	tep_handle->sched_switch_event_id = -EINVAL;
-- 
2.25.1


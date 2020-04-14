Return-Path: <SRS0=o21U=56=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB3D5C38A29
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Apr 2020 15:24:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5E632064A
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Apr 2020 15:24:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CHqSis8h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439329AbgDNPYn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Apr 2020 11:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2440370AbgDNPYh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Apr 2020 11:24:37 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17597C061A0C
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Apr 2020 08:24:37 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id r7so155672ljg.13
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Apr 2020 08:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3WVkPHngvnXTMaSfW2K6KinwonLP6NtsBf6vtsn95lA=;
        b=CHqSis8hIuLErvcTfqi+Cjibx+icjejiepd3n2rbH9rvvZZvNwq8K/I+j6xlsDPrhG
         YJJMLaG8xNZQ6uDLREBD6DhZO36OJ84Lu2MxeYUfuwtCsUFcJ1S0rdyEjWeWaa+Cmf9U
         nuS7bKG73IhlEa7HjBMpscFRVgOhVxNHLVjeSmkK2vXdcu+yH0q9KgJHYyIvs+o31u7D
         3SRXhWlKud/jM88hjOdPMrlLjLlDREZW4XCWwLbchmC9vrhoQozsF8dVXeJNQBuz92c4
         Tw+PfqdtNG/MEoLlibLx9kwBuI9GgeVI2mDZoGI5ficO3U7ixXkIDR/Myns63h1yKKT8
         8aaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3WVkPHngvnXTMaSfW2K6KinwonLP6NtsBf6vtsn95lA=;
        b=gWDjvu8bvZSgt4T5yGV43AqeHvHJdeSccR3KyYIhGiGjKwfis5Pkc98l/zhumTAdGq
         7rrOOu/zsTG6JhDAgefSC4cVlac0jO5eT1BK3D6TxX+TagIaWKMie4YoQ/Qgru0BVIox
         +u8GvS0lCxDbkYFL8cpOCL4seFFN1uHsfe2EvDUa5U8607e5EGyxvOYgcmAuhVGsPib6
         QGkY5XRzsZClNvCM8CpJUb16d4qxfpCqSRY+Ws4WlUWc4eClsE4FIIVEBDtz4+KAvudM
         q+RkOVsZw19IRcYH2ldj0sWCyl/WxkCTH5MoFJaZaqI7hcemA+RE9jx3tI8w+ryzthjA
         f5yQ==
X-Gm-Message-State: AGi0Pub03myWb0U0Cm68Xdvs2od/ZhJUD3hPVpVSKWQJDMVQpRFFeRGs
        EssK10Y93DT/IpvdsOivhN1pCRnqZQ8=
X-Google-Smtp-Source: APiQypKk/Rx2P9O3f36ya/C3MvKotgMlHoz9UjR+D6Rliw67qgJ1QQxqwxyPnjqn59YWZ3Msty3Fsw==
X-Received: by 2002:a2e:a3cf:: with SMTP id w15mr414268lje.41.1586877875571;
        Tue, 14 Apr 2020 08:24:35 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v8sm10302828lfp.85.2020.04.14.08.24.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 08:24:34 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3] kernel-shark-2.alpha: Use new tracecmd APIs to open guest tracing file
Date:   Tue, 14 Apr 2020 18:24:32 +0300
Message-Id: <20200414152432.27878-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
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
The tracecmd_pair_peer() API is used to bind a tracing peer to
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
index 8678e12..f280e57 100644
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
+		tracecmd_pair_peer(tep_handle->input, merge_peer);
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


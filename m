Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 890CBC63684
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 09:49:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239394AbiAZJtg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 04:49:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239373AbiAZJtg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 04:49:36 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5291C06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:49:35 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id jx6so37800589ejb.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:49:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Rb+tApVwVfwPUvOhY6xMkXRjcKERM7HxfOBWMFm6taI=;
        b=kKE0UzRulb9NmYCbupi+JV2aEoM5kPnJ6eoQCv60v7ITqRSV8Eg8nJzyAWQ3TBDbVB
         f6e3+VivsJyxaYOtDa5lyzfSEbZkpf4Gs8mwo0oP+D+Dn4BFBQ+KdTA0syFsjiGPGpOk
         rpH//hViqrCbxVNdoVkSP51x4rigTtyAS2Csv5egV87TCXmHaejh2GDMu7bKsPgpui8A
         t0Rqn/Qp0JFMmuaIik9U03UtTazY6gIfhabgECGEbsJg9roGczBkq4GPQsOdzrdIKBZY
         gCsldoKhRGRBpb8MDIJNKXP4SjgfhGjGULl7y9KegZh7f3ys6/SJgbO2w0zY2mGYVxyK
         zUZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Rb+tApVwVfwPUvOhY6xMkXRjcKERM7HxfOBWMFm6taI=;
        b=T9P4Go2ReyJ5BRlkB9svs49CY0YkPtLOf3ovdr0UXB60QqkUy1HVcc8j2m6XEFr2yn
         hQ70AbxUQabFhURGlV/xuJYVmIIPUWohq0xJHNI9xzW0nYbR3awJXNr2pNkHjdQ5WZRr
         eH6FM9a8JFAPAXqrTUPGmHeU4Q25ghlpI9Nwt5VwLpM/k6NLKOkrMS6LiHPnP7zfQSDG
         EuUt3RJRc/NWGo5jObBiEeRL4wM4lmpiPxZyIN+Og+Rdu79zfLwL2sGEz17ev/VJBQcv
         8HZFB9ym3es8jox3HWhz/ImZg+Ft0uwt/zFEHQYr707Dw+kSQQOrKmPMVJZEDF/NoFbk
         JsNA==
X-Gm-Message-State: AOAM533Jt1Mi9O7HD+AohlpW4aWmNNA57rkbGjgIg7UWyGePXW1KPsrU
        6DUAdnzPrUFlQYsO9rm7MuAmXu8SKbM=
X-Google-Smtp-Source: ABdhPJwqZqL+4OIaC30TPEfyJORc7kaibxn5w6lmW1t86E1FaS6d3ORUTr1wD3OMoZe5FPycitHHBA==
X-Received: by 2002:a17:907:1ca4:: with SMTP id nb36mr11276102ejc.425.1643190574551;
        Wed, 26 Jan 2022 01:49:34 -0800 (PST)
Received: from oberon.zico.biz ([151.251.254.11])
        by smtp.gmail.com with ESMTPSA id e17sm7119155eje.218.2022.01.26.01.49.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 01:49:34 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 19/20] trace-cmd record: Add compression to the trace context
Date:   Wed, 26 Jan 2022 11:49:05 +0200
Message-Id: <20220126094906.570451-20-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126094906.570451-1-tz.stoyanov@gmail.com>
References: <20220126094906.570451-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

As the trace-cmd library supports trace file compression, trace-cmd
record command should have a way to configure this functionality. Trace
context is extended to hold the compression algorithm, used to
compress the file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index ece5a0c2..4df97d7d 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -199,6 +199,7 @@ struct common_record_context {
 	char *date2ts;
 	char *user;
 	const char *clock;
+	const char *compression;
 	struct tsc_nsec tsc2nsec;
 	int data_flags;
 	int tsync_loop_interval;
@@ -3702,6 +3703,14 @@ static struct tracecmd_output *create_net_output(struct common_record_context *c
 		goto error;
 	if (tracecmd_output_set_msg(out, msg_handle))
 		goto error;
+
+	if (ctx->compression) {
+		if (tracecmd_output_set_compression(out, ctx->compression))
+			goto error;
+	} else if (ctx->file_version >= FILE_VERSION_COMPRESSION) {
+		tracecmd_output_set_compression(out, "any");
+	}
+
 	if (tracecmd_output_write_headers(out, listed_events))
 		goto error;
 
@@ -3748,6 +3757,14 @@ setup_connection(struct buffer_instance *instance, struct common_record_context
 			goto error;
 		if (tracecmd_output_set_version(network_handle, ctx->file_version))
 			goto error;
+
+		if (ctx->compression) {
+			if (tracecmd_output_set_compression(network_handle, ctx->compression))
+				goto error;
+		} else if (ctx->file_version >= FILE_VERSION_COMPRESSION) {
+			tracecmd_output_set_compression(network_handle, "any");
+		}
+
 		if (tracecmd_output_write_headers(network_handle, listed_events))
 			goto error;
 		tracecmd_set_quiet(network_handle, quiet);
@@ -4477,6 +4494,14 @@ static struct tracecmd_output *create_output(struct common_record_context *ctx)
 		goto error;
 	if (ctx->file_version && tracecmd_output_set_version(out, ctx->file_version))
 		goto error;
+
+	if (ctx->compression) {
+		if (tracecmd_output_set_compression(out, ctx->compression))
+			goto error;
+	} else if (ctx->file_version >= FILE_VERSION_COMPRESSION) {
+		tracecmd_output_set_compression(out, "any");
+	}
+
 	if (tracecmd_output_write_headers(out, listed_events))
 		goto error;
 
@@ -4511,7 +4536,7 @@ static void record_data(struct common_record_context *ctx)
 
 	if (latency) {
 		handle = tracecmd_create_file_latency(ctx->output, local_cpu_count,
-						      ctx->file_version, NULL);
+						      ctx->file_version, ctx->compression);
 		tracecmd_set_quiet(handle, quiet);
 	} else {
 		if (!local_cpu_count)
-- 
2.34.1


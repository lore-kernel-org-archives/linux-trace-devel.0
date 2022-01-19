Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EC70C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:27:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352458AbiASI1m (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:27:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352480AbiASI1h (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:27:37 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01EFFC06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:27:37 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id q25so7671715edb.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:27:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YCky87BbhWShbH/aduoBm+n7yT9b6LFV+2ZPGGNgaQo=;
        b=L9seZpxqMR+AEnFqKxqNVt8RY/l22MtEyxo6E9op6s6wplTqZp7xrBA1IF5fQvTkj/
         Rrz7eFkBScHWLaHIyq7xfPbPcYVtiYc8Kh9NGMJXFXGh9A7lRiAwS9XyKk+4UVdd3Uql
         kKNHUq2U7BxpRC0yFC3O1TJwgo8ig7zgKM0w0E/nrFMi9pw7ibTZByen0G+b6TPyuTmU
         UeC+F7wvxu4q7pVPbHHHyfAho36vFZoILpO7FOd4K7nIroj2SenxgK9JeDdfeYEzkN79
         CzpiwLDPjMtq/fh9NzsTWSYGa7laebXmpKLhWYu80MuX/FYLlQYSc6s+AS+2VYbqCIsv
         MVwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YCky87BbhWShbH/aduoBm+n7yT9b6LFV+2ZPGGNgaQo=;
        b=HLllBLTMaxbE23ySYT/cdCI4pAD104LMjgOYfNdg1K5VfpPd6TawhenkzLyZ6GUt/1
         MoGynOGmPpcDSOauEMFF5oizYP7QN2ezaVd3jmT9zK9qudRo1WBG4CHAo0UmkUNgl33D
         tztRlSBZ4td2mTjZHNUqjH/TpxTfyYGj5gk0lNWpSKPJY4hBWwn2qca1kNQEC1bkYXql
         3kX02J0qkX4EbgcIaTYG9RHwxMdivzF+D4DSiEpfolnRWYAcizyxD72SX29YnFJH6II6
         SAHFnpSkDkdmNGia+BV2UKBpyeWEpwwqeFb7PvsXxQYcV+4zmn5zo5Az/zrT3ZxVDBpA
         K98w==
X-Gm-Message-State: AOAM53195KFDvulxGBhTADK4VTmB1quACl7A1TzeiLSixgzx/vTFrCvj
        MyAArP4hocyQVFNDzuTkoryfvz3IYrM=
X-Google-Smtp-Source: ABdhPJxQPZze4SVzS1Q0UPibBI6j4lBtp++b+6QZOoNmUYqdjMM3WMN7AMDdmtpWepmcT1O4ZKq4WA==
X-Received: by 2002:a17:906:dc8a:: with SMTP id cs10mr7814463ejc.598.1642580855602;
        Wed, 19 Jan 2022 00:27:35 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d14sm848703edu.57.2022.01.19.00.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:27:35 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 19/20] trace-cmd record: Add compression to the trace context
Date:   Wed, 19 Jan 2022 10:27:14 +0200
Message-Id: <20220119082715.245846-20-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119082715.245846-1-tz.stoyanov@gmail.com>
References: <20220119082715.245846-1-tz.stoyanov@gmail.com>
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
 tracecmd/trace-record.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index ece5a0c2..f1dfe458 100644
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
@@ -3702,6 +3703,12 @@ static struct tracecmd_output *create_net_output(struct common_record_context *c
 		goto error;
 	if (tracecmd_output_set_msg(out, msg_handle))
 		goto error;
+	if (ctx->compression) {
+		if (tracecmd_output_set_compression(out, ctx->compression))
+			goto error;
+	} else if (ctx->file_version >= FILE_VERSION_COMPRESSION) {
+		tracecmd_output_set_compression(out, "any");
+	}
 	if (tracecmd_output_write_headers(out, listed_events))
 		goto error;
 
@@ -3748,6 +3755,12 @@ setup_connection(struct buffer_instance *instance, struct common_record_context
 			goto error;
 		if (tracecmd_output_set_version(network_handle, ctx->file_version))
 			goto error;
+		if (ctx->compression) {
+			if (tracecmd_output_set_compression(network_handle, ctx->compression))
+				goto error;
+		} else if (ctx->file_version >= FILE_VERSION_COMPRESSION) {
+			tracecmd_output_set_compression(network_handle, "any");
+		}
 		if (tracecmd_output_write_headers(network_handle, listed_events))
 			goto error;
 		tracecmd_set_quiet(network_handle, quiet);
@@ -4477,6 +4490,12 @@ static struct tracecmd_output *create_output(struct common_record_context *ctx)
 		goto error;
 	if (ctx->file_version && tracecmd_output_set_version(out, ctx->file_version))
 		goto error;
+	if (ctx->compression) {
+		if (tracecmd_output_set_compression(out, ctx->compression))
+			goto error;
+	} else if (ctx->file_version >= FILE_VERSION_COMPRESSION) {
+		tracecmd_output_set_compression(out, "any");
+	}
 	if (tracecmd_output_write_headers(out, listed_events))
 		goto error;
 
@@ -4511,7 +4530,7 @@ static void record_data(struct common_record_context *ctx)
 
 	if (latency) {
 		handle = tracecmd_create_file_latency(ctx->output, local_cpu_count,
-						      ctx->file_version, NULL);
+						      ctx->file_version, ctx->compression);
 		tracecmd_set_quiet(handle, quiet);
 	} else {
 		if (!local_cpu_count)
-- 
2.34.1


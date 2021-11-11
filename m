Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDB38C433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:12:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B69F460F58
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:12:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234009AbhKKPPH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:15:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233991AbhKKPPG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:15:06 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C7C9C061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:12:17 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id o8so25333999edc.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:12:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ArPF4W8+YICbDVWNiHuRa29uK5W+Pn0glkD+rw5Vb30=;
        b=X/tDEsZy0BCVoroFX2fIrLpgaDmJ/Top//+yhhvEww+7CPToXm14NMV5BkNEAVoAsU
         A2ikhAHYffr/uxbogCmD85xtZt9GwSdqtqsErIQqHkzYZ6YkXVZBLfUOz5JyUlAtg9Kv
         qE5rDZgOgi8HnLQEWiUjPvVVzVLcovaYEy5pBIb73NGdS/qa+M+gnqZ89moNZV8j6N9X
         oriLFNE2spnSC2xFKvQFsJI0l/LWwRDZR69r4ur1FKxxLHIsgj8AUbdmS11k97gmBFPs
         TCvMxEEhI8Tk8/ueg+xLCc7nLxgK8k5ypx4GcN8tfgvRHs43Dpve9aqxsy6VR5ZLkRmj
         wLPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ArPF4W8+YICbDVWNiHuRa29uK5W+Pn0glkD+rw5Vb30=;
        b=wcLOhetQP5muwrnbet5YtylEbC+VD3IHMEwAIb/CsC6Rf/PQwPCr5orjpmGP+f3EFr
         PcSpSpCf3KS9J9KZMIHuP5cTcewGrWKFS0rPmrGXyieIhJyGE2NmJAXG051tCy31WqdK
         n5sNHXC82rJyZkqu3yN9te7qcAjoB1IBvf8jW8CWjBv/wUS3BN4GddnOSFiO2crQzMfB
         y9BO3FPee/SOirlV4FY7H8EsabxSniDszQEyhb/2tmacS+FBsniHVP8VIUxiOtnYiESL
         BAOU9GyTuWS8bf2Zm21EI4xb3ZvNr7o5XsF1h2oZImQHJICeJQ+17Uxk/8+gTeKVA192
         pQqw==
X-Gm-Message-State: AOAM531sFXncdAR0KxFsqXsRAEeCejjpOL+53P+p5crtQuO1t+/v35tH
        a4UtHFERRXY1xKCoQ48GMqE+pt4x92ua+g==
X-Google-Smtp-Source: ABdhPJwqrgm/idjLVLUx71ZRMKec5bem0reeV/0BFmSLc5kidAZvO8OfQ4SYY8eXZ463O9YajLL+KQ==
X-Received: by 2002:aa7:c34c:: with SMTP id j12mr10921755edr.31.1636643535915;
        Thu, 11 Nov 2021 07:12:15 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id qf9sm1479509ejc.18.2021.11.11.07.12.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:12:15 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 19/20] trace-cmd record: Add compression to the trace context
Date:   Thu, 11 Nov 2021 17:11:52 +0200
Message-Id: <20211111151153.86855-20-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111151153.86855-1-tz.stoyanov@gmail.com>
References: <20211111151153.86855-1-tz.stoyanov@gmail.com>
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
index 699fa511..98d663f1 100644
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
@@ -4481,6 +4494,12 @@ static struct tracecmd_output *create_output(struct common_record_context *ctx)
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
 	return out;
@@ -4516,7 +4535,7 @@ static void record_data(struct common_record_context *ctx)
 
 	if (latency) {
 		handle = tracecmd_create_file_latency(ctx->output, local_cpu_count,
-						      ctx->file_version, NULL);
+						      ctx->file_version, ctx->compression);
 		tracecmd_set_quiet(handle, quiet);
 	} else {
 		if (!local_cpu_count)
-- 
2.33.1


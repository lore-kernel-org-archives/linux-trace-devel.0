Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9601EC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:25:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236179AbhLBM2v (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:28:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235035AbhLBM2u (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:28:50 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD56C06174A
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:25:28 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id t5so115452333edd.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:25:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TDxUFwepNTTvF3M60OKnx4d8nzRSjUwdPXzqsUzLtXw=;
        b=Lu73oZ/4j8/7A9d1ag11a4dTSl6ovYgpxDo7Xw+9LTscu4r637kKoJdws+uzK0/HzX
         UxENjVtfAvkIY51ZuG1gQrPCa4FklEKXvSr0WanLsUAWw9MIF4Gb3qQhE8GFXcb1QFVe
         LXfj40mBRXMvwV6Me8V1NvlVyuiibYsP/pJDMAI7i6q56LzDnoKbSMaqWDj1d9ETyuYp
         xvyh9UMZ4oAZwBrlfmorUzUrlKHxBdcHUgPLF8dpVc11X6Jlz/ePULxT2BBZYlz3ZVFx
         6p641pBo9YHO9oE2DCQ+pU82OLO5EQtgBhgpvri9ju4UFIHR5FtJFaSx2i20XtC5+f4Y
         fp4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TDxUFwepNTTvF3M60OKnx4d8nzRSjUwdPXzqsUzLtXw=;
        b=IUlQOX2xQI2aj9rJfXw5oMZBWOrECbExWEFqaxxdKUnzzTDgUEKPvkIXIY8Womer+x
         nhbyNpTyoMQbq3kQkiTwvkUmW9MxpmHaPM6h1m48u64BsJ/HZck9Z5tbKepPx2At/Ktn
         qnpaWM7aI24Bp9zNtrfxp5Qt7cWVKiM8kPxu0Fmsty8S14ej/o1UlL7rs7dhCm0IW0j/
         Dh+vzMSh+FuHV63Xd8Ix0J6OG/1KL7/Wzf5Ob9kpLgT5oJE18KOIC9XeBL6IQAEEL6Gr
         N6Pl0VIi1Etsd6zRPKED+q2wRtrSg3JapaF4Sb6eZeBv6K06zQiodY0W+RnnjrDB71bu
         2z4g==
X-Gm-Message-State: AOAM532Aic+n8va7+xNo+zam0mR1Jt819L6bF0QLT2hDzTQ6AaxPN4qq
        iegbrEhFMqNZ2A/+a108nZ4rim/4PH654g==
X-Google-Smtp-Source: ABdhPJwB20egTo/fZk6eQ9eMXI/Ib1oKILM3zASfzKJItquj76+wtn03AbqzbUxI9BuPnMmk5ws7Sg==
X-Received: by 2002:a17:907:6d20:: with SMTP id sa32mr15149190ejc.108.1638447926942;
        Thu, 02 Dec 2021 04:25:26 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id eg8sm1998507edb.75.2021.12.02.04.25.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:25:26 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 19/20] trace-cmd record: Add compression to the trace context
Date:   Thu,  2 Dec 2021 14:25:06 +0200
Message-Id: <20211202122507.43572-20-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122507.43572-1-tz.stoyanov@gmail.com>
References: <20211202122507.43572-1-tz.stoyanov@gmail.com>
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
index 5f6fcc72..9c799197 100644
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
@@ -4476,6 +4489,12 @@ static struct tracecmd_output *create_output(struct common_record_context *ctx)
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
 
@@ -4510,7 +4529,7 @@ static void record_data(struct common_record_context *ctx)
 
 	if (latency) {
 		handle = tracecmd_create_file_latency(ctx->output, local_cpu_count,
-						      ctx->file_version, NULL);
+						      ctx->file_version, ctx->compression);
 		tracecmd_set_quiet(handle, quiet);
 	} else {
 		if (!local_cpu_count)
-- 
2.33.1


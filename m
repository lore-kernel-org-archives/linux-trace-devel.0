Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 702BDC433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:22:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CB22610D1
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:22:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237563AbhJHEYd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbhJHEYc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:24:32 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F30D1C061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:22:37 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id d9so7380526edh.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H/kfknDnaK/8HeyoD4vfja4iBq75jUdeNSesjqMXEnc=;
        b=iJ8BahdvLsW7URfqCyg00wjv3ipg8q2EG/zNuHju1KiWKy0ih/8Z8zl6+kFXKkWv0D
         2m2ERsUiAWUzDO7lbf1STUbctUuvLUjBgNnwqkvjZFWZu1hOqlCiEV8b+a0cGc33qwA7
         dDrVDWMO/4FkHtow7LTiV0uqqHCVe+nxvvPdbQBj7e7CtsXCJnFP+a9EgpmMo6FrvIOx
         VLuWzjl8it53GDqBMRYdl7v+xxGCNCojJGX6gLr8tHPb8IlEp9CWXe5imlm08GHyn2/V
         Vi8BZUmALGhESmeGrs8kn1qUHI7fl6fLV5oqtLM+wp/xfhmvg6bnsUde4Mu8ve+9vWma
         iu5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H/kfknDnaK/8HeyoD4vfja4iBq75jUdeNSesjqMXEnc=;
        b=E0Z9cvNPTPBYyC4fZj9g2sYehieYwNySW5vk3pbDomRqzsYtjqA5zAZ3ebDTkgRWcx
         S12dBO4WS+fnj+SHIRiVSwOatgGPULuMifFZkHKbfn35l9KuFodPgtNdQSKPIpV5kTrH
         w36nBRy6ZSgvh6vhuQURoFnlvYNzdvAK37G9tqPGPdAFi3iYTHqN/hHoM5ODU9zzAvXH
         K60ZNPlb9j8sWC4TPSes9kX4fQP+otSODGNsS34AQLYOhrjhNc+VUC39wMh2xNmL/5IT
         Zgve43UZUY0Poq2VEwk5hJyEFoHIdbQfI8ddQVS4dG5qLFQIW+jyps+U68SnocxY/g+7
         eZVw==
X-Gm-Message-State: AOAM533n/VqC787IWgrU+9NrRITrfuVlCtM8R1iabgGX0EapBJCi8XIx
        UhvQIF086nZ6i8i81gGcHaGuCGofHgfxsQ==
X-Google-Smtp-Source: ABdhPJzzyNFeTllLy8F6vxELmVI2Q6pXVKtkFQ3LkHcrecDFr4WKRrAaVXFYkmQy1UD29KlLmROSFw==
X-Received: by 2002:a17:906:3c51:: with SMTP id i17mr1346595ejg.86.1633666956642;
        Thu, 07 Oct 2021 21:22:36 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g23sm517429edt.1.2021.10.07.21.22.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:22:36 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 19/20] trace-cmd record: Add compression to the trace context
Date:   Fri,  8 Oct 2021 07:22:13 +0300
Message-Id: <20211008042214.977193-20-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008042214.977193-1-tz.stoyanov@gmail.com>
References: <20211008042214.977193-1-tz.stoyanov@gmail.com>
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
2.31.1


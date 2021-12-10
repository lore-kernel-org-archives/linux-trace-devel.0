Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1442C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 11:00:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237285AbhLJLDe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 06:03:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240134AbhLJLDc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 06:03:32 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E4E7C0617A1
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:59:57 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id e3so29074705edu.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:59:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nhok2iNIEn15a1HvxTL91Q46+hpNPYfftkRan6XLC8o=;
        b=Np5GnbzF859fkf1ceQicTO7DSP/AnfsXLrEt6R9eSX3HSqNhUwRp8IcuuJCO4ZAvLP
         t4tzHJHdHSD7AVv3D67ejMUQVJZY7msouqYUsho40Ok18tOWxhH9gbfW+bJ6Gxwlul2E
         Jx5q8a6MqGacQvWRX1cvGraPY4IeTX+1Y8ja677Bvu0gvXvkf2lKN72AbIK4A8KPQe6d
         EoaxwPJJ5D84Br7JqnxTmR9L13pROr5Rn/rDCmcKtGliHdskpsayqCmc/gbcFhrqnabo
         HMiBlTNCfnpOQ8inrVyQzCsMIDUwd2CpAN8bRnW99cgkMu1og5RyYVYBpfK0XTTCx9J7
         dpTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nhok2iNIEn15a1HvxTL91Q46+hpNPYfftkRan6XLC8o=;
        b=fxTWFlC/x/TRsUoMwtDX6CyKWc/e4jl1HOZ7b6ewbi4G6zH1MSw/EnOdhJz1cvXG5w
         hxralMK+xDFaM5qrcHAVV6teZDQ5jNtJDGlUsQoxgGNnW6RqZKM+gZAt9vZ0OT82jmkm
         owapxogi/qz91Uc5KIulx4HOmqSSoGedAp9fa9M85pBABlDFIszpZIc/76czM+ba3+wg
         Zxi4/sqlAHCrauL3TWxGvwHds8epUVYc8a8V8Tu9PajI8vYqTut7UA5V38KGVO8+B6bu
         uFhcShF3I3fSYqxP4acK98AXW9X9JU6rwLOAhUL2rT15pMLAra9P+/J/mhGNYivY8xdL
         KGXw==
X-Gm-Message-State: AOAM533DgvAgFTLsykEJvVaVxEaQK1pXOVwELkW2iFYp+PtoGMcxQnkT
        fSQBLHCy99gwhZd3RYqy4Bl2OcCYg7M=
X-Google-Smtp-Source: ABdhPJwwL5CcTyWL2wgcpS3OjzgvEQqdyRDDhApJEq3rhurAg/OeAct8e05Dxe9Pk/yaQClm+kdwOQ==
X-Received: by 2002:a05:6402:8:: with SMTP id d8mr37900392edu.61.1639133996043;
        Fri, 10 Dec 2021 02:59:56 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j17sm1320379edj.0.2021.12.10.02.59.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 02:59:55 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 19/20] trace-cmd record: Add compression to the trace context
Date:   Fri, 10 Dec 2021 12:59:37 +0200
Message-Id: <20211210105938.98250-20-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210105938.98250-1-tz.stoyanov@gmail.com>
References: <20211210105938.98250-1-tz.stoyanov@gmail.com>
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
index 21937562..20a36a62 100644
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
2.33.1


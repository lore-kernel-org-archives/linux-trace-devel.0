Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60907C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:13:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 453EE60F55
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:13:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237373AbhJHEP3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237288AbhJHEP2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:15:28 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D312C061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:13:34 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id x7so30377004edd.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cgA2EXLva61pHVu6N4nurZRVa3PGBo44xaD3Gjgteec=;
        b=powJ0GA5+NKUx+y5wGMAXoA0lZnsgLaJzRGske6mMPj22fTZUTaCi+2V1eSFgxJeAo
         jrZ+mAGsPrUR+QyJDjv8iBXnamoPG+hfLXfs8hbDjcjLtHtRKZjG8yxSnYpWuOhCZnGs
         LPFZLF46DYH+8/Ecs/16+rnCb9FfC8qL7ZFqGTsprIeXb49Jj4TA0Y1QmksV7t65mGxr
         ygtN9D6x3CdH2wl3Oe7Uyjt128kCDagFC3T6MwWLywcxXeuu9HkL0lsej2ujqB0pru5k
         xHFpaRtHCyRI1dGLqSGLScr9jAySr8OO9y9ZT/yEkN8JAEjnVA9/q6bwWapxszgHQnsD
         ZMYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cgA2EXLva61pHVu6N4nurZRVa3PGBo44xaD3Gjgteec=;
        b=dffzNLJVv8acsVyWpvqt4ntDrB4K4wxAMz0LlDLEvCPTgTgSg/xCjO2OtY6SwsRFYy
         8EoiYQEEzjKlwOjZMLiYssqNFxE66D9y+24smg9J023yRMNaOhP5AxTbx09OwYH3C4/d
         Pm7z8M1QpCZb49h26iOPBVIRmQop1W78bQbjKVl0sy46853ryXwuQglk4x1oZXOcfbFJ
         LVveo8JPpj3rcj2hVvraa0qmcFJMAa9cNupHxj91craHpk4LOuS3e2r83gES2mkbi0y7
         nJbkMf2WiOnVWRbHlkamJdJnjZ1wRP5tfxv4DhVLJiK3hL1jHffAFzShsZs+Qv9Kyvjm
         SZVQ==
X-Gm-Message-State: AOAM530jORRsEOJvWYGg+zvTnFMTksSLOUxEd9l3VsQ7B/mn0735axcN
        o2iFQNpp9hY878G5+oF8vcT8WM0vHeRZCw==
X-Google-Smtp-Source: ABdhPJy9osTsERL84H1n0z60dmuxZOBnAhKF6PKWME/GjijiYSMtzVOYo+m+MANVmYb2enSz3o0UGA==
X-Received: by 2002:a50:dac4:: with SMTP id s4mr11290983edj.374.1633666412657;
        Thu, 07 Oct 2021 21:13:32 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id lb12sm465740ejc.28.2021.10.07.21.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:13:32 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 09/10] trace-cmd: Use the new flow when creating output handler
Date:   Fri,  8 Oct 2021 07:13:20 +0300
Message-Id: <20211008041321.973755-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008041321.973755-1-tz.stoyanov@gmail.com>
References: <20211008041321.973755-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The trace-cmd commands, that create a new output handler to a trace
file, are converted to use the newly introduced trace-cmd APIs.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c  | 55 +++++++++++++++++++++++++++++++++++-----
 tracecmd/trace-restore.c | 32 +++++++++++++++++++++--
 2 files changed, 79 insertions(+), 8 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 1767a6c6..15e07cf0 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3689,6 +3689,25 @@ again:
 
 static void add_options(struct tracecmd_output *handle, struct common_record_context *ctx);
 
+static struct tracecmd_output *create_net_output(struct common_record_context *ctx,
+						 struct tracecmd_msg_handle *msg_handle)
+{
+	struct tracecmd_output *out;
+
+	out = tracecmd_output_allocate(-1);
+	if (!out)
+		return NULL;
+	if (tracecmd_output_set_msg(out, msg_handle))
+		goto error;
+	if (tracecmd_output_write_headers(out, listed_events))
+		goto error;
+
+	return out;
+error:
+	tracecmd_output_close(out);
+	return NULL;
+}
+
 static struct tracecmd_msg_handle *
 setup_connection(struct buffer_instance *instance, struct common_record_context *ctx)
 {
@@ -3700,7 +3719,7 @@ setup_connection(struct buffer_instance *instance, struct common_record_context
 
 	/* Now create the handle through this socket */
 	if (msg_handle->version == V3_PROTOCOL) {
-		network_handle = tracecmd_create_init_fd_msg(msg_handle, listed_events);
+		network_handle = create_net_output(ctx, msg_handle);
 		if (!network_handle)
 			goto error;
 		tracecmd_set_quiet(network_handle, quiet);
@@ -3718,10 +3737,11 @@ setup_connection(struct buffer_instance *instance, struct common_record_context
 		if (ret)
 			goto error;
 	} else {
-		network_handle = tracecmd_create_init_fd_glob(msg_handle->fd,
-							      listed_events);
+		network_handle = tracecmd_output_allocate(msg_handle->fd);
 		if (!network_handle)
 			goto error;
+		if (tracecmd_output_write_headers(network_handle, listed_events))
+			goto error;
 		tracecmd_set_quiet(network_handle, quiet);
 	}
 
@@ -4067,8 +4087,7 @@ static void setup_agent(struct buffer_instance *instance,
 {
 	struct tracecmd_output *network_handle;
 
-	network_handle = tracecmd_create_init_fd_msg(instance->msg_handle,
-						     listed_events);
+	network_handle = create_net_output(ctx, instance->msg_handle);
 	add_options(network_handle, ctx);
 	tracecmd_write_cmdlines(network_handle);
 	tracecmd_write_cpus(network_handle, instance->cpu_count);
@@ -4437,6 +4456,30 @@ static void write_guest_file(struct buffer_instance *instance)
 	free(temp_files);
 }
 
+static struct tracecmd_output *create_output(struct common_record_context *ctx)
+{
+	struct tracecmd_output *out;
+	int fd;
+
+	fd = open(ctx->output, O_RDWR | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
+	if (fd < 0)
+		return NULL;
+
+	out = tracecmd_output_allocate(fd);
+	if (!out)
+		goto error;
+	if (tracecmd_output_write_headers(out, listed_events))
+		goto error;
+	return out;
+error:
+	if (out)
+		tracecmd_output_close(out);
+	else
+		close(fd);
+	unlink(ctx->output);
+	return NULL;
+}
+
 static void record_data(struct common_record_context *ctx)
 {
 	struct tracecmd_option **buffer_options;
@@ -4491,7 +4534,7 @@ static void record_data(struct common_record_context *ctx)
 				touch_file(temp_files[i]);
 		}
 
-		handle = tracecmd_create_init_file_glob(ctx->output, listed_events);
+		handle = create_output(ctx);
 		if (!handle)
 			die("Error creating output file");
 		tracecmd_set_quiet(handle, quiet);
diff --git a/tracecmd/trace-restore.c b/tracecmd/trace-restore.c
index 280a37f0..8d2fcae8 100644
--- a/tracecmd/trace-restore.c
+++ b/tracecmd/trace-restore.c
@@ -22,6 +22,35 @@
 
 #include "trace-local.h"
 
+static struct tracecmd_output *create_output(const char *file,
+					     const char *tracing_dir, const char *kallsyms)
+{
+	struct tracecmd_output *out;
+	int fd;
+
+	fd = open(file, O_RDWR | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
+	if (fd < 0)
+		return NULL;
+
+	out = tracecmd_output_allocate(fd);
+	if (!out)
+		goto error;
+	if (tracing_dir && tracecmd_output_set_trace_dir(out, tracing_dir))
+		goto error;
+	if (kallsyms && tracecmd_output_set_kallsyms(out, kallsyms))
+		goto error;
+	if (tracecmd_output_write_headers(out, NULL))
+		goto error;
+	return out;
+error:
+	if (out)
+		tracecmd_output_close(out);
+	else
+		close(fd);
+	unlink(file);
+	return NULL;
+}
+
 void trace_restore (int argc, char **argv)
 {
 	struct tracecmd_output *handle;
@@ -90,8 +119,7 @@ void trace_restore (int argc, char **argv)
 			usage(argv);
 		}
 
-		handle = tracecmd_create_init_file_override(output, tracing_dir,
-							    kallsyms);
+		handle = create_output(output, tracing_dir, kallsyms);
 		if (!handle)
 			die("Unabled to create output file %s", output);
 		if (tracecmd_write_cmdlines(handle) < 0)
-- 
2.31.1


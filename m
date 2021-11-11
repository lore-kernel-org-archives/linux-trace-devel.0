Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAEE3C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:07:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3176610A0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232126AbhKKPKX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:10:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233820AbhKKPKX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:10:23 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC538C061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:07:33 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id b15so25172592edd.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:07:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Tba+Yb5RYVhhCDCM3O4kwPlU8dN/zlm3I15f52ZJxvI=;
        b=CLo84iQIvMBSAv5LtX5Q+sg9iTk2NGkCudtoNoMnnAbdUSaHCyi0Q69LJWKSwAwl7h
         lZvPZu/FM70KzWC+4R93frXiR/BoFsnrLAPq1qgEJt5wXOLn+eBxcI3+qQbB8UB2AZ+X
         hlwDPbNS2MifX2jMcNbgy9P8Fe6pb0cVTIbGhTvNQ6TpuMOg4hSJkoE/pnP1HqXVwsmb
         xLrVBl481QJ+yX15hQktmLI8ZHoJN1ji2smT7/IjhSXOBb9e7sf9v4GxdsmcSeYj0icP
         ABNGhNCdAX6OExjy5P4qd/b71BaVhSJEEPBejRe+IwJwCUlblQdDmHrzN9rFSdQkvZxt
         i0Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Tba+Yb5RYVhhCDCM3O4kwPlU8dN/zlm3I15f52ZJxvI=;
        b=kiKBjsPRy7lWlgv3dWnbwm/cs5H1qh60M8N5X2ktqb/GLfyQsjuKRm1y/+BtUfKVUo
         12E0scxNWg5nuyhz8AMVTe4LlZbMRuQ+i5DAdmXzM93g2gz1LV5llzQKOfK0mL72KasG
         OgPGEHYebNPvprfX4k6y6fArApgDDZALIA0rL4JbimDmVb/G2kSSxEayySlWtmw76OCn
         hXUBIWB5eO06twPebBbF86NWba87lSfdOAovjnJoXJY727tjnNUmO2scre2gMm/D8Bl3
         jOW4D+y5K0tEoQTAPp/HAf7IUEtawpnXIGSjSPp8nDf1hFL9DKWqnoMLmU6PG1BcRwW9
         cWkw==
X-Gm-Message-State: AOAM533e49YzVYTup/tS04RMm/aYWpuw3/5QqB4dIYyNv4aOoeHebv5A
        CHsD8K4GUqIE431o1lB/nabNH1uv/2c+2A==
X-Google-Smtp-Source: ABdhPJxIZO/PGgyXck8j13YW74X0IQja1548ltezhFxFsl5qTXxVzvR03tRF2/DAwgQqabcyAg+0JQ==
X-Received: by 2002:a17:907:c0e:: with SMTP id ga14mr10252946ejc.26.1636643252095;
        Thu, 11 Nov 2021 07:07:32 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gv34sm1492792ejc.104.2021.11.11.07.07.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:07:31 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 09/10] trace-cmd: Use the new flow when creating output handler
Date:   Thu, 11 Nov 2021 17:07:30 +0200
Message-Id: <20211111150730.86323-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
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
2.33.1


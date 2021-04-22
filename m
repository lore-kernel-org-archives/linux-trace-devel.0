Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5CF1C43461
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 07:17:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B46CC60200
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 07:17:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbhDVHSF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Apr 2021 03:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230324AbhDVHSC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Apr 2021 03:18:02 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0658C06138C
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Apr 2021 00:17:27 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id g17so51488817edm.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Apr 2021 00:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oXpQDHKheNT8I7Fks8vU+n9ljb7v0VP3gPjBiPzBdx4=;
        b=DjqkyGTecyzKi1V0iACstChGuDxdvROVlypKp2IvFxxhcGrtd0h2XZI1CWKecRMeh1
         E/Qk9UdIDzWNrLmIhIke+7ZMfciWO2R+PwQlpghiq+QZ9JBGOA4q4g0ZYTLBk7hMdk65
         Xy8ioNNAy3OHMtI83PcHrfAnJMgrtE0S0PXx8UvW+QZ+9fhtDH1OWwBY7LZOuV0nHcJX
         IrGW0RVifT8PoFL/XvIkDgEMA4swKkvQm+vKdE83ZtZmr4r9kGmm2pCOWh9z1A1Qvbt0
         fE+AvXVJkZ+K8NBha7wQf0ZDPrb4pbSrr73/JF9rwIIjhLkLSfEKUVAhDDQG49rTfZ7a
         78zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oXpQDHKheNT8I7Fks8vU+n9ljb7v0VP3gPjBiPzBdx4=;
        b=ei34Y9N8/itJ5eQfKccI0zs5KdxLSD+NWRsLMUCafWTyoDcPfv+h951yt85ashkhss
         Ii8+3HHgkTQV6ZrFTLYROyfgvbnyT7fRm5/73YS0jF40b6V3S0DynoZ0OHru+83Vy36t
         28ouzSOHsINvRpRwup6aFOv08E9lK3R4/yncNQyKJ1ETqJfyKtHDFmz3IW8kQXT3p3IN
         hA8TCdZXzB+fD3HsmhbJ4dkJr2Yts7n5knniLNyLLc0kmTxFr3CIM1JRFaHoJfJ1BUDX
         myi1n6LTBZdUQc3nGBvXcy/avDWOtUc5s0lsrwjgx7vlpNO6EFVPlE4P02fTEbkPQHq3
         byIw==
X-Gm-Message-State: AOAM530skNO+RQcMWyvieVqHSQOhCfia3MGJgFdq/SVJpUX9EzK/Dw5t
        V0uUYfu9dDaqwups/SvpayA=
X-Google-Smtp-Source: ABdhPJxUj0OFi1Sbp2kTcPZIYXiyTDILVmW31H5+iqNoutxTVuBTBKFmfKAgr8W74Ffa5hkUUaA/Xw==
X-Received: by 2002:a05:6402:cb3:: with SMTP id cn19mr2029571edb.206.1619075846371;
        Thu, 22 Apr 2021 00:17:26 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k19sm1193958ejk.117.2021.04.22.00.17.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 00:17:25 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 5/6] trace-cmd library: Extend the create file APIs to support different file version
Date:   Thu, 22 Apr 2021 10:17:17 +0300
Message-Id: <20210422071718.483383-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210422071718.483383-1-tz.stoyanov@gmail.com>
References: <20210422071718.483383-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added additional parameter for file version to all trace-cmd library
APIs for creating a new trace file. The caller could specify what is the
desired version of the created file:
 tracecmd_create_file_latency
 tracecmd_create_init_file_glob
 tracecmd_create_init_fd_glob
 tracecmd_create_init_fd_msg
 tracecmd_create_init_file
 tracecmd_create_init_file_override

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       | 19 ++++---
 lib/trace-cmd/trace-output.c                  | 56 ++++++++++++-------
 tracecmd/trace-record.c                       | 12 ++--
 tracecmd/trace-restore.c                      |  4 +-
 4 files changed, 54 insertions(+), 37 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 29e56271..def01b68 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -266,20 +266,25 @@ struct tracecmd_event_list {
 struct tracecmd_option;
 struct tracecmd_msg_handle;
 
-struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus);
+struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus,
+						     unsigned long file_version);
 struct tracecmd_output *
-tracecmd_create_init_file_glob(const char *output_file,
-			       struct tracecmd_event_list *list);
+tracecmd_create_init_file_glob(const char *output_file, struct tracecmd_event_list *list,
+			       unsigned long file_version);
 struct tracecmd_output *tracecmd_create_init_fd(int fd);
 struct tracecmd_output *
-tracecmd_create_init_fd_glob(int fd, struct tracecmd_event_list *list);
+tracecmd_create_init_fd_glob(int fd, struct tracecmd_event_list *list,
+			     unsigned long file_version);
 struct tracecmd_output *
 tracecmd_create_init_fd_msg(struct tracecmd_msg_handle *msg_handle,
-			    struct tracecmd_event_list *list);
-struct tracecmd_output *tracecmd_create_init_file(const char *output_file);
+			    struct tracecmd_event_list *list,
+			    unsigned long file_version);
+struct tracecmd_output *tracecmd_create_init_file(const char *output_file,
+						  unsigned long file_version);
 struct tracecmd_output *tracecmd_create_init_file_override(const char *output_file,
 							   const char *tracing_dir,
-							   const char *kallsyms);
+							   const char *kallsyms,
+							   unsigned long file_version);
 struct tracecmd_option *tracecmd_add_option(struct tracecmd_output *handle,
 					    unsigned short id, int size,
 					    const void *data);
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index f36718f1..edff7961 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -908,11 +908,13 @@ out_free:
 	return ret;
 }
 
-static int select_file_version(struct tracecmd_output *handle,
-				struct tracecmd_input *ihandle)
+static int select_file_version(struct tracecmd_output *handle, struct tracecmd_input *ihandle,
+			       unsigned long file_version)
 {
 	if (ihandle)
 		handle->file_version = tracecmd_get_file_version(ihandle);
+	else if (file_version > 0)
+		handle->file_version = file_version;
 	else
 		handle->file_version = FILE_VERSION;
 
@@ -924,7 +926,8 @@ create_file_fd(int fd, struct tracecmd_input *ihandle,
 	       const char *tracing_dir,
 	       const char *kallsyms,
 	       struct tracecmd_event_list *list,
-	       struct tracecmd_msg_handle *msg_handle)
+	       struct tracecmd_msg_handle *msg_handle,
+	       unsigned long file_version)
 {
 	struct tracecmd_output *handle;
 	struct tep_handle *pevent;
@@ -945,7 +948,7 @@ create_file_fd(int fd, struct tracecmd_input *ihandle,
 
 	handle->msg_handle = msg_handle;
 
-	if (select_file_version(handle, ihandle))
+	if (select_file_version(handle, ihandle, file_version))
 		goto out_free;
 
 	list_head_init(&handle->options);
@@ -1023,7 +1026,8 @@ static struct tracecmd_output *create_file(const char *output_file,
 					   struct tracecmd_input *ihandle,
 					   const char *tracing_dir,
 					   const char *kallsyms,
-					   struct tracecmd_event_list *list)
+					   struct tracecmd_event_list *list,
+					   unsigned long file_version)
 {
 	struct tracecmd_output *handle;
 	int fd;
@@ -1032,7 +1036,7 @@ static struct tracecmd_output *create_file(const char *output_file,
 	if (fd < 0)
 		return NULL;
 
-	handle = create_file_fd(fd, ihandle, tracing_dir, kallsyms, list, NULL);
+	handle = create_file_fd(fd, ihandle, tracing_dir, kallsyms, list, NULL, file_version);
 	if (!handle) {
 		close(fd);
 		unlink(output_file);
@@ -1332,13 +1336,15 @@ int tracecmd_write_cmdlines(struct tracecmd_output *handle)
 	return 0;
 }
 
-struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus)
+struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus,
+						     unsigned long file_version)
 {
 	struct tracecmd_output *handle;
 	char *path;
 	int ret;
 
-	handle = create_file(output_file, NULL, NULL, NULL, &all_event_list);
+	handle = create_file(output_file, NULL, NULL, NULL,
+			     &all_event_list, file_version);
 	if (!handle)
 		return NULL;
 
@@ -1633,39 +1639,46 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 
 struct tracecmd_output *tracecmd_create_init_fd(int fd)
 {
-	return create_file_fd(fd, NULL, NULL, NULL, &all_event_list, NULL);
+	return create_file_fd(fd, NULL, NULL, NULL, &all_event_list, NULL, 0);
 }
 
 struct tracecmd_output *
 tracecmd_create_init_fd_msg(struct tracecmd_msg_handle *msg_handle,
-			    struct tracecmd_event_list *list)
+			    struct tracecmd_event_list *list,
+			    unsigned long file_version)
 {
-	return create_file_fd(msg_handle->fd, NULL, NULL, NULL, list, msg_handle);
+	return create_file_fd(msg_handle->fd, NULL, NULL, NULL,
+			      list, msg_handle, file_version);
 }
 
 struct tracecmd_output *
-tracecmd_create_init_fd_glob(int fd, struct tracecmd_event_list *list)
+tracecmd_create_init_fd_glob(int fd, struct tracecmd_event_list *list,
+			     unsigned long file_version)
 {
-	return create_file_fd(fd, NULL, NULL, NULL, list, NULL);
+	return create_file_fd(fd, NULL, NULL, NULL, list, NULL, file_version);
 }
 
 struct tracecmd_output *
-tracecmd_create_init_file_glob(const char *output_file,
-			       struct tracecmd_event_list *list)
+tracecmd_create_init_file_glob(const char *output_file, struct tracecmd_event_list *list,
+			       unsigned long file_version)
 {
-	return create_file(output_file, NULL, NULL, NULL, list);
+	return create_file(output_file, NULL, NULL, NULL, list, file_version);
 }
 
-struct tracecmd_output *tracecmd_create_init_file(const char *output_file)
+struct tracecmd_output *tracecmd_create_init_file(const char *output_file,
+						  unsigned long file_version)
 {
-	return create_file(output_file, NULL, NULL, NULL, &all_event_list);
+	return create_file(output_file, NULL, NULL, NULL,
+			   &all_event_list, file_version);
 }
 
 struct tracecmd_output *tracecmd_create_init_file_override(const char *output_file,
 							   const char *tracing_dir,
-							   const char *kallsyms)
+							   const char *kallsyms,
+							   unsigned long file_version)
 {
-	return create_file(output_file, NULL, tracing_dir, kallsyms, &all_event_list);
+	return create_file(output_file, NULL, tracing_dir, kallsyms,
+			   &all_event_list, file_version);
 }
 
 /**
@@ -1682,7 +1695,8 @@ struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle,
 {
 	struct tracecmd_output *handle;
 
-	handle = create_file(file, ihandle, NULL, NULL, &all_event_list);
+	handle = create_file(file, ihandle, NULL, NULL, &all_event_list,
+			     tracecmd_get_file_version(ihandle));
 	if (!handle)
 		return NULL;
 
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index fd03a605..6775338b 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3645,7 +3645,7 @@ setup_connection(struct buffer_instance *instance, struct common_record_context
 
 	/* Now create the handle through this socket */
 	if (msg_handle->version == V3_PROTOCOL) {
-		network_handle = tracecmd_create_init_fd_msg(msg_handle, listed_events);
+		network_handle = tracecmd_create_init_fd_msg(msg_handle, listed_events, 0);
 		if (!network_handle)
 			goto error;
 		tracecmd_set_quiet(network_handle, quiet);
@@ -3663,8 +3663,7 @@ setup_connection(struct buffer_instance *instance, struct common_record_context
 		if (ret)
 			goto error;
 	} else {
-		network_handle = tracecmd_create_init_fd_glob(msg_handle->fd,
-							      listed_events);
+		network_handle = tracecmd_create_init_fd_glob(msg_handle->fd, listed_events, 0);
 		if (!network_handle)
 			goto error;
 		tracecmd_set_quiet(network_handle, quiet);
@@ -3851,8 +3850,7 @@ static void setup_agent(struct buffer_instance *instance,
 {
 	struct tracecmd_output *network_handle;
 
-	network_handle = tracecmd_create_init_fd_msg(instance->msg_handle,
-						     listed_events);
+	network_handle = tracecmd_create_init_fd_msg(instance->msg_handle, listed_events, 0);
 	add_options(network_handle, ctx);
 	tracecmd_write_cmdlines(network_handle);
 	tracecmd_write_cpus(network_handle, instance->cpu_count);
@@ -4244,7 +4242,7 @@ static void record_data(struct common_record_context *ctx)
 		return;
 
 	if (latency) {
-		handle = tracecmd_create_file_latency(ctx->output, local_cpu_count);
+		handle = tracecmd_create_file_latency(ctx->output, local_cpu_count, 0);
 		tracecmd_set_quiet(handle, quiet);
 	} else {
 		if (!local_cpu_count)
@@ -4275,7 +4273,7 @@ static void record_data(struct common_record_context *ctx)
 				touch_file(temp_files[i]);
 		}
 
-		handle = tracecmd_create_init_file_glob(ctx->output, listed_events);
+		handle = tracecmd_create_init_file_glob(ctx->output, listed_events, 0);
 		if (!handle)
 			die("Error creating output file");
 		tracecmd_set_quiet(handle, quiet);
diff --git a/tracecmd/trace-restore.c b/tracecmd/trace-restore.c
index 280a37f0..f2b15434 100644
--- a/tracecmd/trace-restore.c
+++ b/tracecmd/trace-restore.c
@@ -91,7 +91,7 @@ void trace_restore (int argc, char **argv)
 		}
 
 		handle = tracecmd_create_init_file_override(output, tracing_dir,
-							    kallsyms);
+							    kallsyms, 0);
 		if (!handle)
 			die("Unabled to create output file %s", output);
 		if (tracecmd_write_cmdlines(handle) < 0)
@@ -128,7 +128,7 @@ void trace_restore (int argc, char **argv)
 		handle = tracecmd_copy(ihandle, output);
 		tracecmd_close(ihandle);
 	} else
-		handle = tracecmd_create_init_file(output);
+		handle = tracecmd_create_init_file(output, 0);
 
 	if (!handle)
 		die("error writing to %s", output);
-- 
2.30.2


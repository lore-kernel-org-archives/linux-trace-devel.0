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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28761C433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 014B661A10
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbhCYGld (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 02:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbhCYGlC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 02:41:02 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9024C06174A
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:41:01 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id x7so1083099wrw.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BydiSnOJRjDENmt5NRZCJV7x/+M3vHm+ubCEz8/g42c=;
        b=lp+2ub1s9mDf2UTsp0KBB/RHkocM9chOeTAtNUaIXvSWRNTdqVr5pTm1LcPRSyz17L
         D1QG9jS9mX7MO0DnzHX8XNKfyQ6W5JkYBqEoB/dBeMqBfDw4Cr+1+9+6jZhRbOddEIpn
         dBeMZz8kZIsEDLQafZljB0bbQYhuvDrw2Po1w3kHV3vX1/wtt4F6C+MPHVO1bVh/sTp0
         rUWs5k73KXx1jhULiwxNfAprmJYWK0Kto2dRLBDChmiYT4ci+/IrqVwW9xo/VfyUYxWS
         v84gtS6Q1UkFaok7mnfnG4TAuZJ0ycLB7pD7YBrSa1v2wFYEz/6fFW6pOLrVZBowOQk7
         Ipvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BydiSnOJRjDENmt5NRZCJV7x/+M3vHm+ubCEz8/g42c=;
        b=r9IpSwG2GD//OkyuOGfL0Wsh/vg9snO2FOCOvq2EtglMUdh/a6OWdQ9TWJCzpH7ub3
         9BTXDK9n6I15b+nHduf/S6CUQzsw8siFayrD+NiuVYVFLpSnRaGkkZwZ6SZ1bKtNkZl7
         lWd/aAfKFIldJ6FiqP1htCLPtzzi9KFp5i0Z42YQfhNE5B5R3mMz3ghijDNAGdiTbnFw
         wdasoJ9ihXMvuI4BVy8yU7JeRLvK7gopxD1y2xqQF5IpkyTOUNcQPTZYpvkh6rBoTij+
         bUsQJUN5C+g8jvpM63zHxiddc5DDzwSnyQRHoL9cKnlW0yxu4ODVWw+4NdWX6atxDWg7
         hBjw==
X-Gm-Message-State: AOAM530mvHCP0chW+7Uhh6HRQuDI4E9QDdfyRrC/fHnVVoNQ7WPXKIg5
        kXsFOXEoM68QpMP4EnLnwjRzyMvn+hBgDg==
X-Google-Smtp-Source: ABdhPJxhNQqx9SJh8OZhVB0/ZHtOemqy0MyirzZSQMtq3Rze6VSYDobZF7rEGZOse1L3B/QJ1gihJA==
X-Received: by 2002:a5d:46d1:: with SMTP id g17mr7070485wrs.342.1616654460453;
        Wed, 24 Mar 2021 23:41:00 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e17sm6403259wra.65.2021.03.24.23.40.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 23:41:00 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 03/23] trace-cmd: Save only the selected clock in the trace.dat file
Date:   Thu, 25 Mar 2021 08:40:35 +0200
Message-Id: <20210325064055.539554-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325064055.539554-1-tz.stoyanov@gmail.com>
References: <20210325064055.539554-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Trace clock, used for curent trace sessions is saved in the trace.dat
file. This information is used when displaying timestamps of the events.
However, only the selected clock is needed.
A new API is added:
 tracecmd_set_out_clock();
that can be used to set the trace clock on the output handle.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  1 +
 lib/trace-cmd/trace-output.c                  | 66 +++++++++++++++----
 2 files changed, 56 insertions(+), 11 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 27f4c9c3..a4637046 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -83,6 +83,7 @@ tracecmd_plugin_context_output(struct trace_plugin_context *trace_context);
 
 void tracecmd_set_quiet(struct tracecmd_output *handle, bool set_quiet);
 bool tracecmd_get_quiet(struct tracecmd_output *handle);
+void tracecmd_set_out_clock(struct tracecmd_output *handle, char *clock);
 
 static inline int tracecmd_host_bigendian(void)
 {
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 54ddcb54..ea6d1ba3 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -59,6 +59,7 @@ struct tracecmd_output {
 	unsigned long		file_state;
 	struct list_head	options;
 	struct tracecmd_msg_handle *msg_handle;
+	char			*trace_clock;
 };
 
 struct list_event {
@@ -118,6 +119,12 @@ void tracecmd_set_quiet(struct tracecmd_output *handle, bool set_quiet)
 		handle->quiet = set_quiet;
 }
 
+void tracecmd_set_out_clock(struct tracecmd_output *handle, char *clock)
+{
+	if (handle && clock)
+		handle->trace_clock = strdup(clock);
+}
+
 /**
  * tracecmd_get_quiet - Get if to print output to the screen
  * Returns non zero, if no output to the screen should be printed
@@ -150,7 +157,7 @@ void tracecmd_output_free(struct tracecmd_output *handle)
 		free(option->data);
 		free(option);
 	}
-
+	free(handle->trace_clock);
 	free(handle);
 }
 
@@ -1359,6 +1366,46 @@ out_free:
 	return NULL;
 }
 
+static int save_clock(struct tracecmd_output *handle, char *clock)
+{
+	unsigned long long endian8;
+	char *str = NULL;
+	int ret;
+
+	ret = asprintf(&str, "[%s]", clock);
+	if (ret < 0)
+		return -1;
+
+	endian8 = convert_endian_8(handle, strlen(str));
+	ret = do_write_check(handle, &endian8, 8);
+	if (ret)
+		goto out;
+	ret = do_write_check(handle, str, strlen(str));
+
+out:
+	free(str);
+	return ret;
+}
+
+static char *get_clock(struct tracecmd_output *handle)
+{
+	struct tracefs_instance *inst;
+
+	if (handle->trace_clock)
+		return handle->trace_clock;
+
+	/*
+	 * If no clock is set on this handle, get the trace clock of
+	 * the top instance in the handle's tracing dir
+	 */
+	inst = tracefs_instance_alloc(handle->tracing_dir, NULL);
+	if (!inst)
+		return NULL;
+	handle->trace_clock = tracefs_get_clock(inst);
+	tracefs_instance_free(inst);
+	return handle->trace_clock;
+}
+
 int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 			    int cpus, char * const *cpu_data_files)
 {
@@ -1366,6 +1413,7 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 	unsigned long long *sizes = NULL;
 	off64_t offset;
 	unsigned long long endian8;
+	char *clock = NULL;
 	off64_t check_size;
 	char *file;
 	struct stat st;
@@ -1403,18 +1451,14 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 	 * we need to find the size of it before we define the final
 	 * offsets.
 	 */
-	file = get_tracing_file(handle, "trace_clock");
-	if (!file)
+	clock = get_clock(handle);
+	if (!clock)
 		goto out_free;
-
 	/* Save room for storing the size */
 	offset += 8;
-
-	ret = stat(file, &st);
-	if (ret >= 0)
-		offset += get_size(file);
-
-	put_tracing_file(file);
+	offset += strlen(clock);
+	/* 2 bytes for [] around the clock */
+	offset += 2;
 
 	/* Page align offset */
 	offset = (offset + (handle->page_size - 1)) & ~(handle->page_size - 1);
@@ -1439,7 +1483,7 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 			goto out_free;
 	}
 
-	if (save_tracing_file_data(handle, "trace_clock") < 0)
+	if (save_clock(handle, clock))
 		goto out_free;
 
 	for (i = 0; i < cpus; i++) {
-- 
2.30.2


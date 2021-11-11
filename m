Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74ABCC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:11:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A7B961252
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:11:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233887AbhKKPOa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:14:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233966AbhKKPOa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:14:30 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E9DFC061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:11:41 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id b15so25220843edd.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:11:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vmpYoO2hKc2Tt2B2GzLnV7lLQyhLhdSoGSsv86S+DsY=;
        b=FCTyxC/o0yRJJRli2Io9vlnYEkFX8dqBNSGqnsNbbZ9pe/EUIml14gQb8ybReO4/7V
         +di5EWISlYr6BFKZWp7dqWTqx7xtGCerbxHDCyv5NOimlLJei+jouY25N/qObNuGdvxj
         LA9uybIuaQA2YaL2nmOGqrwy+ETuOkfLLFhZkg+UMLr/ZPsZI/e0ScHdiAlfkAWEulhU
         1Tz1lgS+d0x3K2d5E9AdTz4vH7x5gHYJAfBGmdDgM2z2oYirUT7LlKROFLz9C7RkQS8s
         nVshE85KL6OlR6fEyH0SIDFa1SIXU2IucT6e/1OqkJZ9qC8B50452s3ouSWRkLP4XoMF
         zjxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vmpYoO2hKc2Tt2B2GzLnV7lLQyhLhdSoGSsv86S+DsY=;
        b=56z51P/XwBgjHj/vY1Wuo0czthEWbTcMMwZz/OVg4Srrgxv1yrSI3JubfKGE0wTIUq
         iV1Ljq3txcMQo55N7H55WYvKz8LVyC3i8gDX6nuylw3B9r5OzSgCzMchuKN3DiZ9njBr
         8t8L44BrSORlLNq2/Wdb/ZxCT6/WVg7taUd4v+UkAnNmO2KYoeMQQHZGcGKt+hjXksGb
         NtwxQTsCwERepfUpbae45HsD5NdDd0KVBpsXrSGHWN1dYGS7E+QwTO9uGx7MNLiKqMyq
         ra4EmIqBEEGVa7XSEmeJnyzZqKg+twgSS5q+b98rSTOxTgPWwjno9Yd+Pz7GvFeRL6Ff
         P0ZQ==
X-Gm-Message-State: AOAM532FriZyMcIWw5BqoIygFrvz2xfYc8+piTBQVtb7fg5ns5XZXu5f
        HN06ceAztmStOvL9PmpCXDnLyBXMciEjRg==
X-Google-Smtp-Source: ABdhPJxqDJmPzi4alyaYtWkurBJRKGreOSNylIBjCdAYOQWEafUeeYIoFcv3IcVd7KvINeeERL7hsA==
X-Received: by 2002:a17:907:3e10:: with SMTP id hp16mr10649766ejc.477.1636643499720;
        Thu, 11 Nov 2021 07:11:39 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d14sm967018edu.57.2021.11.11.07.11.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:11:38 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 24/25] trace-cmd: Call additional APIs when creating trace file
Date:   Thu, 11 Nov 2021 17:11:32 +0200
Message-Id: <20211111151133.86788-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111151133.86788-1-tz.stoyanov@gmail.com>
References: <20211111151133.86788-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When creating a trace file, two more APIs should be called, compared to
the old flow:
 - tracecmd_write_buffer_info(), to write version 6 buffers metadata in
   the file.
 - tracecmd_write_options() after the trace data is written, for version
   7 trace files, as the buffer metadata is appended to the options at
   the end.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-listen.c  | 6 ++++++
 tracecmd/trace-record.c  | 4 ++++
 tracecmd/trace-restore.c | 3 ++-
 tracecmd/trace-split.c   | 3 +++
 4 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index 45ba1211..28be6e7b 100644
--- a/tracecmd/trace-listen.c
+++ b/tracecmd/trace-listen.c
@@ -604,6 +604,9 @@ static int put_together_file(int cpus, int ofd, const char *node,
 
 	if (write_options) {
 		ret = tracecmd_write_cpus(handle, cpus);
+		if (ret)
+			goto out;
+		ret = tracecmd_write_buffer_info(handle);
 		if (ret)
 			goto out;
 		ret = tracecmd_write_options(handle);
@@ -612,6 +615,9 @@ static int put_together_file(int cpus, int ofd, const char *node,
 	}
 	ret = tracecmd_write_cpu_data(handle, cpus, temp_files, NULL);
 
+	if (!ret && tracecmd_get_out_file_version(handle) >= FILE_VERSION_SECTIONS)
+		tracecmd_write_options(handle);
+
 out:
 	tracecmd_output_close(handle);
 	for (cpu--; cpu >= 0; cpu--) {
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 0b1dc508..338a6a8a 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3729,6 +3729,9 @@ setup_connection(struct buffer_instance *instance, struct common_record_context
 		if (ret)
 			goto error;
 		ret = tracecmd_write_cpus(network_handle, instance->cpu_count);
+		if (ret)
+			goto error;
+		ret = tracecmd_write_buffer_info(network_handle);
 		if (ret)
 			goto error;
 		ret = tracecmd_write_options(network_handle);
@@ -4092,6 +4095,7 @@ static void setup_agent(struct buffer_instance *instance,
 	add_options(network_handle, ctx);
 	tracecmd_write_cmdlines(network_handle);
 	tracecmd_write_cpus(network_handle, instance->cpu_count);
+	tracecmd_write_buffer_info(network_handle);
 	tracecmd_write_options(network_handle);
 	tracecmd_msg_finish_sending_data(instance->msg_handle);
 	instance->network_handle = network_handle;
diff --git a/tracecmd/trace-restore.c b/tracecmd/trace-restore.c
index 8d2fcae8..a903c21a 100644
--- a/tracecmd/trace-restore.c
+++ b/tracecmd/trace-restore.c
@@ -163,6 +163,7 @@ void trace_restore (int argc, char **argv)
 
 	if (tracecmd_append_cpu_data(handle, args, &argv[first_arg]) < 0)
 		die("failed to append data");
-
+	if (tracecmd_get_out_file_version(handle) >= FILE_VERSION_SECTIONS)
+		tracecmd_write_options(handle);
 	return;
 }
diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index e4a0c3b3..671d6e9f 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -391,6 +391,9 @@ static double parse_file(struct tracecmd_input *handle,
 	if (tracecmd_append_cpu_data(ohandle, cpus, cpu_list) < 0)
 		die("Failed to append tracing data\n");
 
+	if (tracecmd_get_out_file_version(ohandle) >= FILE_VERSION_SECTIONS)
+		tracecmd_write_options(ohandle);
+
 	current = end;
 	for (cpu = 0; cpu < cpus; cpu++) {
 		/* Set the tracecmd cursor to the next set of records */
-- 
2.33.1


Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF9E1C432C3
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Feb 2021 12:14:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE8C264EEE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Feb 2021 12:14:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbhBZMN6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 26 Feb 2021 07:13:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbhBZMNv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 26 Feb 2021 07:13:51 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E46AC06174A
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Feb 2021 04:13:10 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id p1so6161174edy.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Feb 2021 04:13:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v35xj5Db4mb4kbOXG08FrLK/IaHJ6A8iXeM4oB2Xv1U=;
        b=jOGl+KZtRR9461ol9iIIeYMrQ1mNuui8Q4JPce5/dmbf46ZeMydPG1uBhMxSIrdkJm
         h9kXSr3kxLSATX6LOkc/v2KHZLJArPyiEFfvDryIzMvV6RIKdRBnmJ3EgAEfXl7p4KI5
         fZp0GkNel8x0jZD+vPndY4yVLQK965PpxPfEnqd7l25/9j/DuP79r7yWXjCBObJpTB4G
         zFqujp5KBYPI7P6tCeVjz5HQ4MJZb0PZW7mDbuAihsYKfQF8VtFuhiGxHrQjOhS/P22w
         t546kJpwmMqifHv1Xshxk1j3wWxXweDpV3U0Rvov95rjTrb26HzU15yX0KqtkPYvWatk
         TAxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v35xj5Db4mb4kbOXG08FrLK/IaHJ6A8iXeM4oB2Xv1U=;
        b=A/luIbZjqFPuEjchF3wjtRfQhm+D66p7Mu0kTGZl9iL++wd+PkPSfU/uDjiaiLyBfJ
         44la/ddsS7GL71GiNlKyNCa8rutZGgotIayEPQk3Ztv3yJ6FjMs0FoSeeUtybZbPBvOZ
         TPkCMPeJTdIxYFvELxwbuxOTHnV77Jje0RoHePyQE65QhNBJyj6P+zDAR9RWrxhMVApO
         XYD+LABRlVcZup5fUat5kn4twn6h6SNs7J4t3kGFReNrePpjxz6O0Lw6Q1KOqDDbudzp
         oeppaD6DyaUSkQh3Dh13F5Tl64JXayP+wwuf/fsJEGLFMUF2nA5g9Y9n/hjc7xn6olSK
         tz6A==
X-Gm-Message-State: AOAM530Hn1EKZUlNFUGP5w/jADjLuyIzIARRGGlykyZK7yZZwY8BOxKD
        aI6yFeNNxCKLIrrW3JuAHjRP6aNpzXVe1g==
X-Google-Smtp-Source: ABdhPJxjf9MldsTndB1w4lrGRo6soTElOilQKWMGyUP4GWPCYBBih1lo4hSSRODpB7p7ybQlUqgO4Q==
X-Received: by 2002:aa7:c7ce:: with SMTP id o14mr2908153eds.163.1614341588746;
        Fri, 26 Feb 2021 04:13:08 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n2sm5266773ejl.1.2021.02.26.04.13.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 04:13:08 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 1/5] trace-cmd Add API to save command lines in trace file
Date:   Fri, 26 Feb 2021 14:13:02 +0200
Message-Id: <20210226121306.216757-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210226121306.216757-1-tz.stoyanov@gmail.com>
References: <20210226121306.216757-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new API is added, a wrapper around an internal function to save
"saved_cmdlines" file from tracefs in the trace.dat file, as an option
in the meta data of the file. The wrapper will be used to add
validations when saving that option in the file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/private/trace-cmd-private.h |  4 +---
 lib/trace-cmd/trace-output.c                      | 13 +++++++++----
 tracecmd/trace-record.c                           |  2 +-
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index eddfd9eb..f0f06491 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -273,6 +273,7 @@ struct tracecmd_option *tracecmd_add_buffer_option(struct tracecmd_output *handl
 						   const char *name, int cpus);
 
 int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus);
+int tracecmd_write_cmdlines(struct tracecmd_output *handle);
 int tracecmd_write_options(struct tracecmd_output *handle);
 int tracecmd_append_options(struct tracecmd_output *handle);
 int tracecmd_update_option(struct tracecmd_output *handle,
@@ -500,7 +501,4 @@ void *tracecmd_record_page(struct tracecmd_input *handle,
 void *tracecmd_record_offset(struct tracecmd_input *handle,
 			     struct tep_record *record);
 
-int save_tracing_file_data(struct tracecmd_output *handle,
-			   const char *filename);
-
 #endif /* _TRACE_CMD_PRIVATE_H */
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 588f79a5..b087f5fa 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -797,8 +797,8 @@ static int read_ftrace_printk(struct tracecmd_output *handle)
 	return -1;
 }
 
-int save_tracing_file_data(struct tracecmd_output *handle,
-			   const char *filename)
+static int save_tracing_file_data(struct tracecmd_output *handle,
+				  const char *filename)
 {
 	unsigned long long endian8;
 	char *file = NULL;
@@ -1203,6 +1203,11 @@ tracecmd_add_buffer_option(struct tracecmd_output *handle, const char *name,
 	return option;
 }
 
+int tracecmd_write_cmdlines(struct tracecmd_output *handle)
+{
+	return save_tracing_file_data(handle, "saved_cmdlines");
+}
+
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus)
 {
 	struct tracecmd_output *handle;
@@ -1215,7 +1220,7 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 	/*
 	 * Save the command lines;
 	 */
-	if (save_tracing_file_data(handle, "saved_cmdlines") < 0)
+	if (tracecmd_write_cmdlines(handle) < 0)
 		goto out_free;
 
 	if (tracecmd_write_cpus(handle, cpus) < 0)
@@ -1356,7 +1361,7 @@ int tracecmd_append_cpu_data(struct tracecmd_output *handle,
 	/*
 	 * Save the command lines;
 	 */
-	ret = save_tracing_file_data(handle, "saved_cmdlines");
+	ret = tracecmd_write_cmdlines(handle);
 	if (ret)
 		return ret;
 
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index efd96d27..9396042d 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3770,7 +3770,7 @@ static void setup_agent(struct buffer_instance *instance,
 	network_handle = tracecmd_create_init_fd_msg(instance->msg_handle,
 						     listed_events);
 	add_options(network_handle, ctx);
-	save_tracing_file_data(network_handle, "saved_cmdlines");
+	tracecmd_write_cmdlines(network_handle);
 	tracecmd_write_cpus(network_handle, instance->cpu_count);
 	tracecmd_write_options(network_handle);
 	tracecmd_msg_finish_sending_data(instance->msg_handle);
-- 
2.29.2


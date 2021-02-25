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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4624C433E9
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Feb 2021 16:25:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C9C364F1D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Feb 2021 16:25:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbhBYQZf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Feb 2021 11:25:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233234AbhBYQZ3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Feb 2021 11:25:29 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA79C061756
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Feb 2021 08:24:48 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id w1so9844587ejf.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Feb 2021 08:24:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NDWE9Dc0GAvodM1b0J0NfichO1GKQ8xZYos0leqsUQg=;
        b=hWUkCwE1mSDvIstglNOKH5qpkrPn7IiJFnqbFIyKgkldrWiaX/5qYkp9X9Zofvv5T3
         4OlY3m/5Zox8cNcT1j6u6+tuBIJjDyhTclLe+IQuzHS3EWoYqsPT9KXsANEeZmBUDQsB
         9XIBMyXV7yzCiVZaCvR55UkX214KwsR2jbkPadBeFaPRbh1wQ33DPyf7uxk7eYC9EctW
         NpDG/DGfNzd4m2EXlxN+aLY1GSH71FtjBeGe9OzLFxj+mqO7EB1owJAt7ILvX6UbQcTU
         45yWwkylPxAstOoJIw059vgsCF80Z/G0+wCnTdZKs22jBZCYp+bE2lCAzzabNmqcK6va
         kgFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NDWE9Dc0GAvodM1b0J0NfichO1GKQ8xZYos0leqsUQg=;
        b=PGvMa4PrMRZVtMqqsSBCsrldzGxTA4puplNHr8weT7ruqgM/jCGc5VhZmAUi2UetH6
         668fMSbh9I8+7bOes0WiNU4fMvrcG8t4Hmbwp/g+4B6MAvYQEGgs28RjQ+SfilQ3dmQX
         IDaNdxw1iPNMo8m7XNYK2N77khG40u2dBdHW9DKuvdr6xcR9egj+qSwTS0t3ZbPEmfP4
         xyEJYMcwWqYPCukCX+aYvPjYUb8Fo1zJy3Q/n2bGFDXTM7qOjSrnnnYL7agvcmEAUk/H
         8e2JvCp1bBFw5rTRJk/t28/hUDaE8LWlRQostSSJnzlhYwe1EqfWyxte1egSoBKYYpMf
         8wyQ==
X-Gm-Message-State: AOAM533ZE41CbY8fPqv7Q3jsIR66gt41rkmtY1X1Uirsmsggr7aMrVzb
        xS0h5bOxXTQfV6N3HLUBn7E=
X-Google-Smtp-Source: ABdhPJw2ztYkWWms4xSOdjsV5rvnPHUyF9+ylReuog1lZNzemisydMKJrk6s7MegEwCEoezewezOjw==
X-Received: by 2002:a17:907:3fa6:: with SMTP id hr38mr3470999ejc.24.1614270286873;
        Thu, 25 Feb 2021 08:24:46 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id qn24sm3096339ejb.104.2021.02.25.08.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 08:24:45 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v30 2/7] trace-cmd: Add dummy function to initialize timestamp sync logic
Date:   Thu, 25 Feb 2021 18:24:37 +0200
Message-Id: <20210225162442.173759-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210225162442.173759-1-tz.stoyanov@gmail.com>
References: <20210225162442.173759-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A dummy empty function is added, will be used to initialize timestamp
synchronization logic:
  tracecmd_tsync_init()
When this code is implemented as real plugins, this function will be
removed. Then the initializion will be triggered at plugin load time.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-timesync.c |  8 ++++++++
 tracecmd/trace-agent.c         |  2 ++
 tracecmd/trace-record.c        | 23 +++++++++++++++--------
 3 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index 7c11ee1b..f49eafdd 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -57,6 +57,14 @@ static struct tsync_proto *tsync_proto_find(const char *proto_name)
 	return NULL;
 }
 
+/**
+ * tracecmd_tsync_init - Initialize the global, per task, time sync data.
+ */
+void tracecmd_tsync_init(void)
+{
+
+}
+
 int tracecmd_tsync_proto_register(const char *proto_name, int accuracy, int roles,
 				  int supported_clocks, unsigned int flags,
 				  int (*init)(struct tracecmd_time_sync *),
diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
index ff4a4e11..36444d32 100644
--- a/tracecmd/trace-agent.c
+++ b/tracecmd/trace-agent.c
@@ -248,6 +248,8 @@ static void agent_serve(unsigned int port)
 	if (sd < 0)
 		die("Failed to open vsocket");
 
+	tracecmd_tsync_init();
+
 	if (!get_local_cid(&cid))
 		printf("listening on @%u:%u\n", cid, port);
 
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index efd96d27..cc870124 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -6218,10 +6218,6 @@ static bool has_local_instances(void)
 	return false;
 }
 
-/*
- * This function contains common code for the following commands:
- * record, start, stream, profile.
- */
 static void record_trace(int argc, char **argv,
 			 struct common_record_context *ctx)
 {
@@ -6379,12 +6375,23 @@ static void record_trace(int argc, char **argv,
 	finalize_record_trace(ctx);
 }
 
+/*
+ * This function contains common code for the following commands:
+ * record, start, stream, profile.
+ */
+static void record_trace_command(int argc, char **argv,
+				 struct common_record_context *ctx)
+{
+	tracecmd_tsync_init();
+	record_trace(argc, argv, ctx);
+}
+
 void trace_start(int argc, char **argv)
 {
 	struct common_record_context ctx;
 
 	parse_record_options(argc, argv, CMD_start, &ctx);
-	record_trace(argc, argv, &ctx);
+	record_trace_command(argc, argv, &ctx);
 	exit(0);
 }
 
@@ -6476,7 +6483,7 @@ void trace_stream(int argc, char **argv)
 	struct common_record_context ctx;
 
 	parse_record_options(argc, argv, CMD_stream, &ctx);
-	record_trace(argc, argv, &ctx);
+	record_trace_command(argc, argv, &ctx);
 	exit(0);
 }
 
@@ -6495,7 +6502,7 @@ void trace_profile(int argc, char **argv)
 	if (!buffer_instances)
 		top_instance.flags |= BUFFER_FL_PROFILE;
 
-	record_trace(argc, argv, &ctx);
+	record_trace_command(argc, argv, &ctx);
 	do_trace_profile();
 	exit(0);
 }
@@ -6505,7 +6512,7 @@ void trace_record(int argc, char **argv)
 	struct common_record_context ctx;
 
 	parse_record_options(argc, argv, CMD_record, &ctx);
-	record_trace(argc, argv, &ctx);
+	record_trace_command(argc, argv, &ctx);
 	exit(0);
 }
 
-- 
2.29.2


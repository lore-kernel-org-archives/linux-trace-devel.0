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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85DB6C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 08:49:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3910A64FB0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 08:49:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbhCKItQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Mar 2021 03:49:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbhCKItJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Mar 2021 03:49:09 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C4F9C061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Mar 2021 00:49:09 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id z1so1524973edb.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Mar 2021 00:49:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=roU/w+KMRRvR4EP+/hSvYPxbYCTZDORlU5h+TeZSAb4=;
        b=TZ3bqKlqp78xXbiEfZkNS6+5sX7bSUh9tRiabHJ4c7bj7oLKZEjx4b1CVCP801FAK4
         EO1psaKfr9hB9N44Q8WjMTAxfbEO2rret7AXUhsV1EKTtrKoAFH1unKzUjMYrZOL5IKb
         t0RDDHqf3xcKgAVJcAfk4U6IsrqYGFJh0YhlG3A2ILTjpj69NfddxsULzLAqlE4Eqrzg
         wTl5U2DLKi7zM2WV3ZFNVV+4pN+lQ1v99aWDva6jvlFB47qoFUddPVzJsV1KLvw8huD7
         5om3ZNft4RALGJfh8FFIky2nLFjjZ/WvJgK8NmeSpPaDZAbswefq8K3HXmhcIRtZN0g4
         XoPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=roU/w+KMRRvR4EP+/hSvYPxbYCTZDORlU5h+TeZSAb4=;
        b=kBKhz+4KznvQrFhz4nuLFAnpJKAHzlIgVnbpF9sXWkeKvwmR/NYnfwzayhn6tw7UJE
         BBVFeU7vOkcJn3IY7RslCjM2ujbZc28FmA1mxXTkN1m10JXD95ofcR1p7W23sWXYFoIK
         dtMYBmyvse22lrLeXl3Tf3tTXPfbLHiXIL4B34YlVJVI7XOmmX1+id9G9VmpPVFO0Ox2
         50F+EnrTniN7QLzMBaHr9fW9rb0WW3+ef8sht5cnS4KrrkyKy29eWsl7LB/ngQwttV8H
         l1KoLfAGwAnP6IWbxTssTUtlo2wGFfXvUiOO5+TZIYJrafT+qG4LijO7jr40JawrThsp
         OHYA==
X-Gm-Message-State: AOAM532WKjpaTDsrh9hRjqZuBgplcCQINEvDlaN8aiTA95CmJ9y8Pnxj
        eJIQeaZcKT6AoS9Ebr7JIGCMzMQKi7Gt5Q==
X-Google-Smtp-Source: ABdhPJzcvHQd4E23hVWMY0onbNqlE/OmYEK0lgxhbLFObidFQaDrrUTJWzL7s+W2q7OF9zcXHmOB2w==
X-Received: by 2002:a05:6402:2076:: with SMTP id bd22mr7342436edb.378.1615452547787;
        Thu, 11 Mar 2021 00:49:07 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id fi11sm901647ejb.73.2021.03.11.00.49.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 00:49:06 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v31 02/16] trace-cmd: Add dummy function to initialize timestamp sync logic
Date:   Thu, 11 Mar 2021 10:48:43 +0200
Message-Id: <20210311084857.1919805-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311084857.1919805-1-tz.stoyanov@gmail.com>
References: <20210311084857.1919805-1-tz.stoyanov@gmail.com>
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
index e7428788..63e09b57 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -6242,10 +6242,6 @@ static bool has_local_instances(void)
 	return false;
 }
 
-/*
- * This function contains common code for the following commands:
- * record, start, stream, profile.
- */
 static void record_trace(int argc, char **argv,
 			 struct common_record_context *ctx)
 {
@@ -6403,12 +6399,23 @@ static void record_trace(int argc, char **argv,
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
 
@@ -6500,7 +6507,7 @@ void trace_stream(int argc, char **argv)
 	struct common_record_context ctx;
 
 	parse_record_options(argc, argv, CMD_stream, &ctx);
-	record_trace(argc, argv, &ctx);
+	record_trace_command(argc, argv, &ctx);
 	exit(0);
 }
 
@@ -6519,7 +6526,7 @@ void trace_profile(int argc, char **argv)
 	if (!buffer_instances)
 		top_instance.flags |= BUFFER_FL_PROFILE;
 
-	record_trace(argc, argv, &ctx);
+	record_trace_command(argc, argv, &ctx);
 	do_trace_profile();
 	exit(0);
 }
@@ -6529,7 +6536,7 @@ void trace_record(int argc, char **argv)
 	struct common_record_context ctx;
 
 	parse_record_options(argc, argv, CMD_record, &ctx);
-	record_trace(argc, argv, &ctx);
+	record_trace_command(argc, argv, &ctx);
 	exit(0);
 }
 
-- 
2.29.2


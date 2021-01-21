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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03EF3C4332B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Jan 2021 07:47:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6ED623975
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Jan 2021 07:47:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727529AbhAUHrl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 21 Jan 2021 02:47:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727727AbhAUHrB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Jan 2021 02:47:01 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C843DC06179A
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Jan 2021 23:45:13 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id g10so747947wrx.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Jan 2021 23:45:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oyrFCLUU/Egfusyp14CEETNslUJE59i2wQS3M/QXL18=;
        b=tUGEqLa7Fqdv3l9IzhnQdxHHLAUNVFBv7vnWwQ2qukI5ms2U7nf2vL+WsAqtegiwu3
         3oSIckQN2Dpx9C7pYRw/9iYYMD8EZrqmFjn0CCLB6RD31I2MA+BukxfMwbvH7kM8iZgt
         LmORwRB+4eTS+6laMPSDjLl7qCoz8m4uq8J8ALeP6PJ4nqesS1+MK5yiZfYUqdwoRHJi
         AfJkJ1cMcG4WwnHDUbNiemGHIHTIVS//6MyRoUcpx05JgH2aK8d2VICNbq8JtZCMwX8g
         21lH9ljzjeQXiENosRykcYw/Q0DSyedJp3Pe4eiZRw+bNrB+o3gWUStlc/YPW62x5Fe2
         VOzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oyrFCLUU/Egfusyp14CEETNslUJE59i2wQS3M/QXL18=;
        b=V9to/OhTj1g3hKVLN11qWCmN/J9ZlW4QPu5WTkI0vQXqgeSHWXpoYsQRhQ+m21LaN2
         PvZ2ZOZQ0edD02hwFqOaj+zSiGQjEHf0uOd41dfk+QfGMs+esVajwwl4oYc0zKD9u3ea
         PHp1SmAZC//zp3JLXMOm+JA3uWOdSxwSSBmb2VDzdmrLB1HY450z7yC0D2OTlJBOoLXs
         xD/O/G4ddFfI5wXZa/ClkcDObaTR4jypCmk9J1FD5DJ4e9FAU2DA3fPIVT6ayTIRa8dv
         FUUhAFILV19NRYjqSRnzYQNp/PO3kemhQPaFoCWRBe5B8RTgOJuh69947R4SOCxsNffA
         0eNQ==
X-Gm-Message-State: AOAM531sFj6hHxytrr01xhIQ7QjEDUBX0UQOUQhua7zrq78syKU8QApQ
        nKbdP5XuEwlYJJ3E2TMd/nE=
X-Google-Smtp-Source: ABdhPJzLIIzlz+lLonpcV9EI9TY4csV/6sL4hNfVHPS257VkK45dAEELGr2GuNw28U7m7EBwg+wgGg==
X-Received: by 2002:a05:6000:1048:: with SMTP id c8mr10476988wrx.420.1611215112582;
        Wed, 20 Jan 2021 23:45:12 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q6sm6788474wmj.32.2021.01.20.23.45.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 23:45:11 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v26 12/15] trace-cmd: Add dummy function to initialize timestamp sync logic
Date:   Thu, 21 Jan 2021 09:44:53 +0200
Message-Id: <20210121074456.157658-13-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210121074456.157658-1-tz.stoyanov@gmail.com>
References: <20210121074456.157658-1-tz.stoyanov@gmail.com>
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
index 8371a141..9db9d3a5 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -59,6 +59,14 @@ static struct tsync_proto *tsync_proto_find(const char *proto_name)
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
index 3bcb2403..e5b1eff5 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -6219,10 +6219,6 @@ static bool has_local_instances(void)
 	return false;
 }
 
-/*
- * This function contains common code for the following commands:
- * record, start, stream, profile.
- */
 static void record_trace(int argc, char **argv,
 			 struct common_record_context *ctx)
 {
@@ -6380,12 +6376,23 @@ static void record_trace(int argc, char **argv,
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
 
@@ -6477,7 +6484,7 @@ void trace_stream(int argc, char **argv)
 	struct common_record_context ctx;
 
 	parse_record_options(argc, argv, CMD_stream, &ctx);
-	record_trace(argc, argv, &ctx);
+	record_trace_command(argc, argv, &ctx);
 	exit(0);
 }
 
@@ -6496,7 +6503,7 @@ void trace_profile(int argc, char **argv)
 	if (!buffer_instances)
 		top_instance.flags |= BUFFER_FL_PROFILE;
 
-	record_trace(argc, argv, &ctx);
+	record_trace_command(argc, argv, &ctx);
 	do_trace_profile();
 	exit(0);
 }
@@ -6506,7 +6513,7 @@ void trace_record(int argc, char **argv)
 	struct common_record_context ctx;
 
 	parse_record_options(argc, argv, CMD_record, &ctx);
-	record_trace(argc, argv, &ctx);
+	record_trace_command(argc, argv, &ctx);
 	exit(0);
 }
 
-- 
2.29.2


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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D89EC433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 07:15:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30F8961A26
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 07:15:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbhCYHOe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 03:14:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhCYHOS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 03:14:18 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EAF1C06174A
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Mar 2021 00:14:18 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id b9so1158139wrt.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Mar 2021 00:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n/PcC3vShOs0tOTVX2TYRBKGhpAnKTLL0S2OF2+kdrc=;
        b=hYROnmDwxHa8Izone0UIqfa99cOOKlUmJ2RD47mETbMUS14/QlsBUSFYTRkQOgjjv7
         42IgzqWl8pm9thDSz7owffnkHR8JVEHHfl8lG1VHamq0dO71ypUvtSRg0YpQKIcjOAp4
         5sx3StowtdTRBechQfc//4AXgguKc1fib8MlxwUS/WhOm3XsD4GNfUIDqxGi2b8Rqu9W
         IuVvGrnOTMkDqxGguLItJRKmmGEyjh/UQTHJ3ij4u0fptUq/QODHd9g7UmY/Vhh1NZkE
         yei2YpXRdWIYkMGrkYbr2hswJduip7b5EthiiVKWC6JwE/k6h+smMB3G2z4dr4oSeD/g
         6iUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n/PcC3vShOs0tOTVX2TYRBKGhpAnKTLL0S2OF2+kdrc=;
        b=akr/L8rPh4YoTBmKMQRDJBwKKBeA0jl0RTtf2VE22VUM73Ssbln5pGsuHmFBZx6wCU
         tqOybHhtEw2g+UMedATMtAjvsiSvv018vwzcBNl4zUudxa5Xo8auVYqQT2ZENwtARsdh
         RmzhpAC+a5AZ2Pl8uAlfbVcAz+ZGUTwkJsGg5NPCdxxGWjvRKROf9JpAtw9fn3VjodHw
         aF5rsZ7hnxUecMWOUaUHcupv/9fV9FFeQ/3HOaayvn6iIkfgY4cnnGWBtwAKvafCsSk0
         fgamgPVR+KusXgZLKlC9QGSZSKewu3rc+D+XNfSgmAnFp6WtHoeLSm3Fso2/hswPBxJj
         mT9g==
X-Gm-Message-State: AOAM532RlNN4/cpW/yq/qwkQ4+r7rbzC9IfP1FhF/6xeTfQbKzh7Pi3P
        RKlFMSAJPjMahfCcdDZbVBg=
X-Google-Smtp-Source: ABdhPJwuugIaOxfXgRGLj8Hp+U4/MpLQOZ2vI05RiIlgRfogSQTHaZ0kX7vEmhw/PGdeBQMS6Ci4iA==
X-Received: by 2002:a5d:628c:: with SMTP id k12mr7158189wru.316.1616656456867;
        Thu, 25 Mar 2021 00:14:16 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q4sm5177487wma.20.2021.03.25.00.14.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 00:14:16 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, stefano.devenuto99@gmail.com
Subject: [PATCH v33 1/5] trace-cmd: Add dummy function to initialize timestamp sync logic
Date:   Thu, 25 Mar 2021 09:14:09 +0200
Message-Id: <20210325071413.543640-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325071413.543640-1-tz.stoyanov@gmail.com>
References: <20210325071413.543640-1-tz.stoyanov@gmail.com>
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
 tracecmd/trace-agent.c         |  1 +
 tracecmd/trace-record.c        | 25 ++++++++++++++++---------
 3 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index 0097ce15..62f5dc1e 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -55,6 +55,14 @@ static struct tsync_proto *tsync_proto_find(const char *proto_name)
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
index 49f6dd8c..1f7d9461 100644
--- a/tracecmd/trace-agent.c
+++ b/tracecmd/trace-agent.c
@@ -250,6 +250,7 @@ static void agent_serve(unsigned int port)
 	sd = trace_make_vsock(port);
 	if (sd < 0)
 		die("Failed to open vsocket");
+	tracecmd_tsync_init();
 
 	if (!get_local_cid(&cid))
 		printf("listening on @%u:%u\n", cid, port);
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 946bcb4d..6e579c22 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -6541,10 +6541,6 @@ out:
 	free(clock);
 }
 
-/*
- * This function contains common code for the following commands:
- * record, start, stream, profile.
- */
 static void record_trace(int argc, char **argv,
 			 struct common_record_context *ctx)
 {
@@ -6708,12 +6704,23 @@ static void record_trace(int argc, char **argv,
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
 
@@ -6722,7 +6729,7 @@ void trace_set(int argc, char **argv)
 	struct common_record_context ctx;
 
 	parse_record_options(argc, argv, CMD_set, &ctx);
-	record_trace(argc, argv, &ctx);
+	record_trace_command(argc, argv, &ctx);
 	exit(0);
 }
 
@@ -6805,7 +6812,7 @@ void trace_stream(int argc, char **argv)
 	struct common_record_context ctx;
 
 	parse_record_options(argc, argv, CMD_stream, &ctx);
-	record_trace(argc, argv, &ctx);
+	record_trace_command(argc, argv, &ctx);
 	exit(0);
 }
 
@@ -6824,7 +6831,7 @@ void trace_profile(int argc, char **argv)
 	if (!buffer_instances)
 		top_instance.flags |= BUFFER_FL_PROFILE;
 
-	record_trace(argc, argv, &ctx);
+	record_trace_command(argc, argv, &ctx);
 	do_trace_profile();
 	exit(0);
 }
@@ -6834,7 +6841,7 @@ void trace_record(int argc, char **argv)
 	struct common_record_context ctx;
 
 	parse_record_options(argc, argv, CMD_record, &ctx);
-	record_trace(argc, argv, &ctx);
+	record_trace_command(argc, argv, &ctx);
 	exit(0);
 }
 
-- 
2.30.2


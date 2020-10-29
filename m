Return-Path: <SRS0=entZ=EE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0AFCC61DD8
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Oct 2020 11:18:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A4CC20796
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Oct 2020 11:18:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SHPzDanH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727653AbgJ2LSg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Oct 2020 07:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727629AbgJ2LSf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Oct 2020 07:18:35 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D84A9C0613D4
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Oct 2020 04:18:34 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id w1so2330680wrm.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Oct 2020 04:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SYCbl4wOjx3+FQBsKTi1jBThOlSQ6mQ0b7vRSmCnm0I=;
        b=SHPzDanHH0B4qhDDFHQRszkFByae6eP4dKU+rx46RchUOuCYh1CxRdI+/9SY8er0Je
         KZ6dOytrYBbWdRqv/jOGwdY0k2qCjRltAcsbEqK3LaoQLtDYYNdZw2/tAs3VTF8CTtX7
         /63eDR9X7F0tB0TqqN0BASDYSkvCfjh1uOqkfEtvm4QVWN5D3Z+FXATajUEBw24zqiQ4
         v6aA+/GMtX4S+heyth3L9hNtLuyuWfshHC84UBGSXOXBBFvszIdi+hadA3aw0xUKHgjN
         Vcna47ctu76JsPsXHdtCefybfuzGwCskN46etGCSDd0PZ/iChoO5Bb7v75qJDehYoeJh
         bI0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SYCbl4wOjx3+FQBsKTi1jBThOlSQ6mQ0b7vRSmCnm0I=;
        b=JodXQN+F/feejrDQHgfcpSJVUj5rUB5uxbpbQyGVt05lmPf7mTc5KFz32eP1dUqFT4
         pDS0wHThQtG/S3wO6ES2/LJrSuhIcQ84pLVmwWR1Ll1ZFyPpVAobCWjWo0UikoB/cNHc
         5DXCsUFQLufW+l41uoBcdg66PWHhuCNnAICpFZ8HqtEQNiuBNXECKchhNNHBVAd7h9iE
         dLSydixCGliCErq2ICQdiW5F9UsAu4iOZJBgWz/wndj07IGuMPrJXAZ8ZuClvd2UGzyW
         aEJb3alc2MjG0aWzYJpCFpAPeZafnIKWO18d2PBZcHoypn5uLAoeuzhTd9NtdH+GmWfI
         3vuw==
X-Gm-Message-State: AOAM53078qxCwShHovMNR4l9TAsh7G7DdXS5ifE7Qn8waW+QnoLd/lvZ
        qKx5zs3JBV/coGoTrJKPWIsVUgK0O2s+Y9cq
X-Google-Smtp-Source: ABdhPJzTuLldOn6L2x+hKgGBFUq0cB3I40Y4prtIgn9oC3LSSbq7hMfcold+VBsuGvS5f6xf5KyuHg==
X-Received: by 2002:a5d:420d:: with SMTP id n13mr4934417wrq.196.1603970313661;
        Thu, 29 Oct 2020 04:18:33 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id a199sm4308067wmd.8.2020.10.29.04.18.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 04:18:33 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v25 13/16] trace-cmd: Add dummy function to initialize timestamp sync logic
Date:   Thu, 29 Oct 2020 13:18:13 +0200
Message-Id: <20201029111816.247241-14-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201029111816.247241-1-tz.stoyanov@gmail.com>
References: <20201029111816.247241-1-tz.stoyanov@gmail.com>
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
index 40d50fd5..c8c1f287 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -59,6 +59,14 @@ static struct tsync_proto *tsync_proto_find(char *proto_name)
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
 int tracecmd_tsync_proto_register(char *proto_name, int accuracy, int roles,
 				  int supported_clocks, unsigned int flags,
 				  int (*init)(struct tracecmd_time_sync *),
diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
index ca810607..cb1e608d 100644
--- a/tracecmd/trace-agent.c
+++ b/tracecmd/trace-agent.c
@@ -245,6 +245,8 @@ static void agent_serve(unsigned int port)
 	if (sd < 0)
 		die("Failed to open vsocket");
 
+	tracecmd_tsync_init();
+
 	if (!get_local_cid(&cid))
 		printf("listening on @%u:%u\n", cid, port);
 
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index b4e68234..28bb9904 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -6233,10 +6233,6 @@ static bool has_local_instances(void)
 	return false;
 }
 
-/*
- * This function contains common code for the following commands:
- * record, start, stream, profile.
- */
 static void record_trace(int argc, char **argv,
 			 struct common_record_context *ctx)
 {
@@ -6394,12 +6390,23 @@ static void record_trace(int argc, char **argv,
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
 
@@ -6491,7 +6498,7 @@ void trace_stream(int argc, char **argv)
 	struct common_record_context ctx;
 
 	parse_record_options(argc, argv, CMD_stream, &ctx);
-	record_trace(argc, argv, &ctx);
+	record_trace_command(argc, argv, &ctx);
 	exit(0);
 }
 
@@ -6510,7 +6517,7 @@ void trace_profile(int argc, char **argv)
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
2.26.2


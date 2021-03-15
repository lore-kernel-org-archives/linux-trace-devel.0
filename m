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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5720EC433E6
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Mar 2021 06:20:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C3E364E46
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Mar 2021 06:20:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbhCOGTc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Mar 2021 02:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbhCOGTE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Mar 2021 02:19:04 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19BB4C061574
        for <linux-trace-devel@vger.kernel.org>; Sun, 14 Mar 2021 23:19:04 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id j3so15928183edp.11
        for <linux-trace-devel@vger.kernel.org>; Sun, 14 Mar 2021 23:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g9/yMSjq4YusUEvBT6Cn61Nwun0Jng3D7ugCnpdbiBs=;
        b=owy7KV7LhXRodbAPsSL81N5ayTwbIA9LzhuGcSJHfMamy5EkrbJnRa7tEvw0SltglF
         VfnzHWPifI8y3xMChCV4eami1ER/raUhxnMyht8yR8ppADjmHJ5AB4iyKO6qS5/6bGYE
         ql19iEZCNsl9Tubjji9cn6WnXkPxh6btBYjktK65Z5tO26ebso3MNusIdn5rBWdWc+iD
         0g7Iv700moy52EqJGBVnk8TH2E0LCGjBE6SvMl4C64BD4a5583Zs5ELd+70+Jkhq44rD
         ki7k29Oj2HjniW/CFlfOu6UG09rzEY9MRr4Bi/GqWsrN8XnfEfPggm0LIxP2WM98aYOK
         Y+Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g9/yMSjq4YusUEvBT6Cn61Nwun0Jng3D7ugCnpdbiBs=;
        b=Mnl3QiPHwhhYqSbuA30wV/1XPwPH0hXr0cG4D4HpUJ/yuFZm5Em0Sxpof7rMzgqN00
         k6evLh+CpepE54NOaskwSsI9i/QkhktPw7y6O6MOl7K/8zoxMWrgDHupwR91SVVLCW76
         KvJbxRozGgVaNyxTJo72UYHIA4ghE/9r7udELVQ2tZ9PQGk2Jtv7JDvvmqOTiWkNpSst
         mi45jTeeEGcPJRZWaHrgwdiBtLWIi0ppGfCZh0tSO4hE01cpDEWmJO0U5zpEMdOxGa8H
         /Ygrjm7xTZKHssyunbtJqndCqdMMOVTuVnf/+7ia/TAxW1lL14JYMBwQjEXFmdhas6Rj
         pFEw==
X-Gm-Message-State: AOAM530q+2pSC0BHOhwBYeJIcoIMkQbSt4IPV6so+ZrxMXYXGee+wcsJ
        +TwRkXgey9ZJON3v6xewDolY5JmsES3fiQ==
X-Google-Smtp-Source: ABdhPJyVAnpxFMBQoxam4V1F+3IbuRUii+YSq87fb2F8+Fqg1dNeCCCegattKMvtGfUf2QIdxldQ9g==
X-Received: by 2002:aa7:ce16:: with SMTP id d22mr28081187edv.95.1615789142865;
        Sun, 14 Mar 2021 23:19:02 -0700 (PDT)
Received: from localhost.localdomain ([130.185.229.134])
        by smtp.gmail.com with ESMTPSA id u13sm6706086ejy.31.2021.03.14.23.19.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 23:19:02 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v32 1/5] trace-cmd: Add dummy function to initialize timestamp sync logic
Date:   Mon, 15 Mar 2021 08:18:53 +0200
Message-Id: <20210315061857.168570-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210315061857.168570-1-tz.stoyanov@gmail.com>
References: <20210315061857.168570-1-tz.stoyanov@gmail.com>
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
index 85a57f23..483ebd96 100644
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
index 49f6dd8c..e6fafd2b 100644
--- a/tracecmd/trace-agent.c
+++ b/tracecmd/trace-agent.c
@@ -251,6 +251,8 @@ static void agent_serve(unsigned int port)
 	if (sd < 0)
 		die("Failed to open vsocket");
 
+	tracecmd_tsync_init();
+
 	if (!get_local_cid(&cid))
 		printf("listening on @%u:%u\n", cid, port);
 
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 30d3ed89..e91c2cad 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -6376,10 +6376,6 @@ static bool has_local_instances(void)
 	return false;
 }
 
-/*
- * This function contains common code for the following commands:
- * record, start, stream, profile.
- */
 static void record_trace(int argc, char **argv,
 			 struct common_record_context *ctx)
 {
@@ -6540,12 +6536,23 @@ static void record_trace(int argc, char **argv,
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
 
@@ -6637,7 +6644,7 @@ void trace_stream(int argc, char **argv)
 	struct common_record_context ctx;
 
 	parse_record_options(argc, argv, CMD_stream, &ctx);
-	record_trace(argc, argv, &ctx);
+	record_trace_command(argc, argv, &ctx);
 	exit(0);
 }
 
@@ -6656,7 +6663,7 @@ void trace_profile(int argc, char **argv)
 	if (!buffer_instances)
 		top_instance.flags |= BUFFER_FL_PROFILE;
 
-	record_trace(argc, argv, &ctx);
+	record_trace_command(argc, argv, &ctx);
 	do_trace_profile();
 	exit(0);
 }
@@ -6666,7 +6673,7 @@ void trace_record(int argc, char **argv)
 	struct common_record_context ctx;
 
 	parse_record_options(argc, argv, CMD_record, &ctx);
-	record_trace(argc, argv, &ctx);
+	record_trace_command(argc, argv, &ctx);
 	exit(0);
 }
 
-- 
2.29.2


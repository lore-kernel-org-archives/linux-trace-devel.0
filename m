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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57E75C433E0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Feb 2021 10:17:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DE8E64EC7
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Feb 2021 10:17:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhBSKRW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Feb 2021 05:17:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbhBSKPn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Feb 2021 05:15:43 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E586FC06178A
        for <linux-trace-devel@vger.kernel.org>; Fri, 19 Feb 2021 02:15:02 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id w1so11681847ejf.11
        for <linux-trace-devel@vger.kernel.org>; Fri, 19 Feb 2021 02:15:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2i9HKc0rG7Ku6yBwucemoj5F9GSAxZRnARu8swhdHS4=;
        b=sGyeO9Jq5lClT/336FdT9nnPrB/OqyNRBaZZlVYYjPaPj7OVfl5yNJdFWZU7LcK8Wo
         ARb7966Yzbm8vH70SmDJAXnMiSj3LdFT6Mqod3F1vT4ZvJj3dHo+lxRZN6CzAxCJP+H/
         enBGejDWumm9A45cgBp4R8jBLZywiDGFbXUqMjsiDue6T8SNcrDEnEqjAC1phILakv9f
         madDMa+JrcfGUvWVh6kvNSAYy/0t8Xmp2peavYQISGxt8WIkRLnCxmslosNb5wkST36m
         cxre3r0NkhmlConHU2mZP7GUs4y//WgOo0O68lQo+c1stLtWN65mdxwyLrjWaJGW8+mw
         relA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2i9HKc0rG7Ku6yBwucemoj5F9GSAxZRnARu8swhdHS4=;
        b=Uv4O5lk4jW8detJZq1sUvxRmmjHvFwO9jFSjONiKE75RUB67v6qpjN1K+VhQJuzzOh
         tFLbYZ9uhvMlYUEJPh8PCkDDoIlAXx0Rox5qEHX/1DVejNfRQjqDPRSKYu2o2IUpJaTf
         lSqbkOpXJhvdMmZZHm6Oc6+Vm7VmgMrqHvlZj0QFYd6DoEoyZOUoLzMVfXXFU8QwYPYv
         mGXysQdEBy2Tnp0xR/S5r9F1BF0wBAlW7NO8VBaUqCljW33uox31XlUm07hQjjUwt72i
         hjaPUtg2kOB2LsyLUhRkuCx2sf9mHkLlu7nUYpLYe4RX+NLzHzCweMkYWYYRdrisGaU8
         6GOw==
X-Gm-Message-State: AOAM531vslgKTYQ0ubMDzDZ38CJX9xryBuYETM1Kiu21LCnbmI3858zB
        XhQlT5foCwA/6jUe+ZCaJww=
X-Google-Smtp-Source: ABdhPJwjk98fpGZrDWY6K0QbJ/HaXEP1fWNFwR9kRWfLIe0n8he21YGtoa1yHr8HXBTcZD5rXPuNtQ==
X-Received: by 2002:a17:906:5e06:: with SMTP id n6mr8151971eju.19.1613729701680;
        Fri, 19 Feb 2021 02:15:01 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k2sm4162481ejp.6.2021.02.19.02.15.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 02:15:01 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v29 2/5] trace-cmd: Add dummy function to initialize timestamp sync logic
Date:   Fri, 19 Feb 2021 12:14:54 +0200
Message-Id: <20210219101457.2345089-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210219101457.2345089-1-tz.stoyanov@gmail.com>
References: <20210219101457.2345089-1-tz.stoyanov@gmail.com>
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
index 2581363f..8c1586c7 100644
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


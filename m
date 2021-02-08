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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDC7BC4332B
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Feb 2021 06:18:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BE7164E59
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Feb 2021 06:18:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbhBHGSl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Feb 2021 01:18:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbhBHGSk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Feb 2021 01:18:40 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBB76C061756
        for <linux-trace-devel@vger.kernel.org>; Sun,  7 Feb 2021 22:17:54 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id y9so22719949ejp.10
        for <linux-trace-devel@vger.kernel.org>; Sun, 07 Feb 2021 22:17:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2i9HKc0rG7Ku6yBwucemoj5F9GSAxZRnARu8swhdHS4=;
        b=Tr04Ec4jLBMif0oz5TIHKnqqRQe3Ege+piN14CPJ8AFvWNX9x1A1c5gL62BUZPK/z5
         rl7+F74tbQHXbwDeZG7al9Fgw19gNSYM5zE5ALLfmcVTqRgyBCkImI3fqwzBZ2HHZgO4
         HBaF58UvVLcjfjgzKEP7FLbrQoayvt4zIBHLVO2THI3mUP6CUEdZml4JSq0FEYInaf0X
         gprVY35/Eo7yTjgAehh8JHUb18nbOk30wSonCgvLX/60040flV1wnGQiPEiGKWwarRLD
         dUgMmhvAt171isUgpZNr0aEz4LB5xSIclIakPXWUu60r+g2VF8hdDM+d9vWPShoZEgx8
         SmjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2i9HKc0rG7Ku6yBwucemoj5F9GSAxZRnARu8swhdHS4=;
        b=LZQvUDH9j5Jb24lUKh5vNFo6LFep1ofP0V/15H/57lwnt8DtnYe7RPI+M1udJAB5hQ
         ELpIbl09YTBn90wys1FA9VoYwBmtRgB1fg98qgl0nR7Ueq5laYnMvU5QTQb04iaajZmD
         XYnYPjf8B7MUpgt9GMeoPgSvGwk/y7i8GHPKEijipYzZJ/3stMmhIyE/BVGHb6RaDmGo
         p4RHS1Oqa3uq0QDEglbB0SV+XlW4Hy0foVb8wFnqwIQ88FJnRwIeaTSUZWJFphsX99el
         kUtNNGvruaJgTbrUHsxuu7BNP7TXDYl5N/Dza4UhVFnARagjqKLDNUtU1os7ZNg61Xfm
         I5sw==
X-Gm-Message-State: AOAM530ifACjKBQ80wuD+gMgHWAez/wp3pChfEAmGMIUw9WzkuJVbr1U
        Ac4Xv5E/giB7vBwMVizTRRc=
X-Google-Smtp-Source: ABdhPJzRPM9XW6L35b72CxuL0pVqhM+2ePx1N9VKt6149bskztqQklgovtzrYSbWan9NBX9e+IxoJg==
X-Received: by 2002:a17:907:7289:: with SMTP id dt9mr15435566ejc.446.1612765073694;
        Sun, 07 Feb 2021 22:17:53 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id 35sm135618edp.85.2021.02.07.22.17.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Feb 2021 22:17:53 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v28 5/8] trace-cmd: Add dummy function to initialize timestamp sync logic
Date:   Mon,  8 Feb 2021 08:17:40 +0200
Message-Id: <20210208061743.510964-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210208061743.510964-1-tz.stoyanov@gmail.com>
References: <20210208061743.510964-1-tz.stoyanov@gmail.com>
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


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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 322B7C433C1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 31 Mar 2021 07:30:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB7F1619D3
	for <linux-trace-devel@archiver.kernel.org>; Wed, 31 Mar 2021 07:30:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbhCaH3i (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 31 Mar 2021 03:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233830AbhCaH3G (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 31 Mar 2021 03:29:06 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7076DC061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 31 Mar 2021 00:29:06 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id j3so21037691edp.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 31 Mar 2021 00:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7nZJCi7YFOFQMDAXigdrICQKZJyGt+xH5JiTzrQzIsc=;
        b=MPJkd6kdFIu+BVG73g/pQYUjBG0Vmhy4iW+dqjZ3+kqc6I0PwcoEQjmyo/ptFQUrbQ
         xoSV18wJrS9mfg5t2PLakLNO2/g4l5aUxVM0pTB6YEAkz+k4Afxm/i65WQUer0SGxV4s
         x3nyRZXQkIrOWe0paQFd2cfqRWv1uUVuQoKVpQRs4OcaFR7oq3Z1BaitjxxkQbEOFsPU
         MGA4YoRf/m9y9fKQJnlQXsRh8liiVFQQjtLKFjNb52p/4w8ncAabyJXYLO2RGKPkobdV
         FBtlocOBK1ov3uptsFdtOKj0eXjbWVM8KbBW5blnWlHvjlaKMjXFylmBmKn6thbWaDfF
         cPkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7nZJCi7YFOFQMDAXigdrICQKZJyGt+xH5JiTzrQzIsc=;
        b=M5LQ8A8QJhlMR34Iuv+MsV38xMd4YEQxNcJozLQUjAlvIRKyG5rX507qcXIOxRbngG
         gbdpd4OdSA55IBTQXdmkHhjJZCNjBo+oRWfFTMaDfT11rxj5X5ahf6dUyR9dXckRG8G7
         9yz5/EsL6bsVgTmADe11JgV2QcZ6QZoITw9ytydfXc+9H+KdM6Y0zvy4BwFMSEwg7gcP
         XV8XH9NyFsCdbGXv+YNvYt2Jzw7Ojjkqe9Gd8yE9S9Vn15cMK8PXzkoVuUOCpLzwzKa2
         LSGK5ehnw12IbXpkVtRL2Ztr92rzH+i5o0zzn6kn9lQsy6v48wZwIIiQRPhNe/QNvoEg
         C6zg==
X-Gm-Message-State: AOAM530NeU9JM7WOv5+nBSTYqabQCJ33Tr3jWK+LDuoW9I8k0gdZDIXS
        k8ux1CcDAIzY5Uwvh7KjW8hQWMLzMCGTgA==
X-Google-Smtp-Source: ABdhPJy6pIn0pwpgySkFdNB2wPeIM43ERe1mFT7TduxnO36wNS8l2Clnl8c9fany3T1v6488sEJiBA==
X-Received: by 2002:aa7:c907:: with SMTP id b7mr2015438edt.37.1617175745137;
        Wed, 31 Mar 2021 00:29:05 -0700 (PDT)
Received: from oberon.vmware.com ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id ho11sm587469ejc.112.2021.03.31.00.29.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 00:29:04 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v34 1/5] trace-cmd: Add dummy function to initialize timestamp sync logic
Date:   Wed, 31 Mar 2021 10:28:57 +0300
Message-Id: <20210331072901.152880-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210331072901.152880-1-tz.stoyanov@gmail.com>
References: <20210331072901.152880-1-tz.stoyanov@gmail.com>
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
index e860c335..6f2d54aa 100644
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
index 5e69cf48..63817d43 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -6545,10 +6545,6 @@ out:
 	free(clock);
 }
 
-/*
- * This function contains common code for the following commands:
- * record, start, stream, profile.
- */
 static void record_trace(int argc, char **argv,
 			 struct common_record_context *ctx)
 {
@@ -6712,12 +6708,23 @@ static void record_trace(int argc, char **argv,
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
 
@@ -6726,7 +6733,7 @@ void trace_set(int argc, char **argv)
 	struct common_record_context ctx;
 
 	parse_record_options(argc, argv, CMD_set, &ctx);
-	record_trace(argc, argv, &ctx);
+	record_trace_command(argc, argv, &ctx);
 	exit(0);
 }
 
@@ -6809,7 +6816,7 @@ void trace_stream(int argc, char **argv)
 	struct common_record_context ctx;
 
 	parse_record_options(argc, argv, CMD_stream, &ctx);
-	record_trace(argc, argv, &ctx);
+	record_trace_command(argc, argv, &ctx);
 	exit(0);
 }
 
@@ -6828,7 +6835,7 @@ void trace_profile(int argc, char **argv)
 	if (!buffer_instances)
 		top_instance.flags |= BUFFER_FL_PROFILE;
 
-	record_trace(argc, argv, &ctx);
+	record_trace_command(argc, argv, &ctx);
 	do_trace_profile();
 	exit(0);
 }
@@ -6838,7 +6845,7 @@ void trace_record(int argc, char **argv)
 	struct common_record_context ctx;
 
 	parse_record_options(argc, argv, CMD_record, &ctx);
-	record_trace(argc, argv, &ctx);
+	record_trace_command(argc, argv, &ctx);
 	exit(0);
 }
 
-- 
2.30.2


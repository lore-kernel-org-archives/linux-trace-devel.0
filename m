Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A7EEC433E6
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Feb 2021 16:05:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2651D64E9B
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Feb 2021 16:05:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbhBAQEv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Feb 2021 11:04:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbhBAQE0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Feb 2021 11:04:26 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3780BC061756
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 Feb 2021 08:03:46 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id s7so14168036wru.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Feb 2021 08:03:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oyrFCLUU/Egfusyp14CEETNslUJE59i2wQS3M/QXL18=;
        b=u7I6IJCBmhPt1yF/tRpm4L2NSENYGkPYGdbww6b0+ArIOwcKI0gQSDlferuZuKLtd6
         KUWa4O6hbP0zA0dh3elBgU97iyouFmFLDoopBdjnySqzdBSB16wjQH6f0kRFPF2kY9wm
         F3LDK0TfEh1qOM9O7WMTpZDJB1nWhr6CmziMSJW0wszW55xhPp+PrfQfzD0SvjOVefsA
         hvbfa/kdfKYZ6Xd+lkzSgHHolDLzSGmpMuQ2VelhaHBv6+AVNPSn/hmUxig11WL5JRww
         nhRBYLqBKX4XpnpxJJn8+pJWo60FQbW2TU6VFX59M3N6OXCkJh1ODvS/UTLzPKDb8k4S
         1yRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oyrFCLUU/Egfusyp14CEETNslUJE59i2wQS3M/QXL18=;
        b=j6iEcbyg50lAuL38ew6JesANuwPq7eg7on6GLf2Rh8nBuBlz7Kmkk0ZB9/7jkQnG72
         vVNUM3bCQj+BoSe3b/PkBcj0KykcZaEJ+OTXScC9wOg/478efYgLgcE/Fx38b9uMRGbZ
         +DnNM7eT2mTDZ/B93nantTYVQERUDozFH6T2hqn6Cw+H5W2iQRjgmLoYVwLfiRRsoY0o
         MMxAJtvKllczMMbi4qQKyrFxsHWm2HvuvOULeQjCO2wCCooOwryiOpFu4yHZ26PjGwr2
         th7nPUkCbYB100y7TBNd3dEqxw43mNV3CQKBZLnE+mnb3nQFuRDiF3x++JlBT6AuVmln
         bbWw==
X-Gm-Message-State: AOAM533kglaw4bkbfyECwuazUaTdHZji7e4kwTnLoCFMU2nUlSnm5tmL
        iQM9yvL2Bun8+SSitMXk/VY=
X-Google-Smtp-Source: ABdhPJx79VpBW3zXyUPUyiouH92W29/w1sYGHRBgAaB0mi61p1GHkcj31tmZBfiHPCqKOTSlekYakg==
X-Received: by 2002:adf:ffcd:: with SMTP id x13mr19154719wrs.149.1612195424925;
        Mon, 01 Feb 2021 08:03:44 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id m18sm323288wmq.1.2021.02.01.08.03.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 08:03:44 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v27 2/5] trace-cmd: Add dummy function to initialize timestamp sync logic
Date:   Mon,  1 Feb 2021 18:03:36 +0200
Message-Id: <20210201160339.506562-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210201160339.506562-1-tz.stoyanov@gmail.com>
References: <20210201160339.506562-1-tz.stoyanov@gmail.com>
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


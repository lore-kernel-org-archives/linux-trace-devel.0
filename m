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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01EC2C433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Jan 2021 07:47:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7CA323356
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Jan 2021 07:47:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbhAUHrz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 21 Jan 2021 02:47:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727668AbhAUHpm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Jan 2021 02:45:42 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B99FC0613D3
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Jan 2021 23:45:02 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id l12so745790wry.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Jan 2021 23:45:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nyrs8pAZOTNh1VU/sM4KU6TnGp3INTO/Er4TnPCwv7A=;
        b=S0thjCuVMWQ/5Viqb4N5uk03Z3ja4QZCAcWxKYWCHQaVoj+1+eCwVYxPaxXvQ1Cr6O
         QWWY0ifeCeiE5ZbbqSR8yWuim0yy0zEMqiQgUVCkHGFPLq+T0QOBuyv/2vQ3Q7wUhfLf
         I87ySMb2/Llowm/ypNpu9mWyDfuL+4MuqWJdxFZtfs+he1uqqy2YBVOInDlDgo357MzC
         XVRGX1lC20FOilv7HgPEfRnXeZOynuIAZR/FSZTjjN/8l6atU+VhInfoPYaabPLU7Enk
         wQR/efL5qrdvBfZ1WtSQX5eznEubum0WVfr28WQomzF+8yOGdi4RTcA9nK3Pe6ovZNdI
         /Zgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nyrs8pAZOTNh1VU/sM4KU6TnGp3INTO/Er4TnPCwv7A=;
        b=rvJ3BHDqBrxsO5Zi57BSlX1RlH7E2ZOWTAnut825pbNSHWyQKxS3KP8zoSMRfmpoHD
         9XJCZYnv/RiRsQMbRELhM94pAkAFplghTAX6KAfjnYR4+Mn3GKHvthfEpq1rqbkOflBR
         nn15WJwgb6nC8huoY/dDPSWD8NNkrOSKA9tgUlzQT+8/EwWCP9BdP/Ln6u659o2O+hir
         sQ/SG1iZCMPocR+vJi/L2BPiIgAiYg3Flw8e/30t1fF8CqB10MQQPe1MLVeAfrzBrDJt
         fiF7DWtrs7AwYgJbblgCXyalyfvxTbAOwq1P6+Gfl/MyvMcwXKWytsymxMnJnB2y/Ual
         Vpzg==
X-Gm-Message-State: AOAM532KJiZlmCbj+a+/WcHxxZudsyL1d5JLrm7ePQXPAKyAoNdVEAHA
        5B4nPYo8rBW3ebF+SaRLMnqB3bFkihPTaVTA
X-Google-Smtp-Source: ABdhPJzmz6rDqx6b/kdMQMptp9WHly4tcfLSa2foDo7oA4hFVdle9x/QsgqwGo9w3AOud4ak+eNBFQ==
X-Received: by 2002:a5d:61c4:: with SMTP id q4mr12787818wrv.304.1611215101327;
        Wed, 20 Jan 2021 23:45:01 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q6sm6788474wmj.32.2021.01.20.23.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 23:45:00 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v26 02/15] trace-cmd: Add trace-cmd library APIs for ftrace clock name
Date:   Thu, 21 Jan 2021 09:44:43 +0200
Message-Id: <20210121074456.157658-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210121074456.157658-1-tz.stoyanov@gmail.com>
References: <20210121074456.157658-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added enum with ftrace clock IDs and APIs to convert ftrace name to ID
and vice versa, as part of libtracecmd. The clock items in the enum are
organized as a bitmask, as it will be used by the timestamp
synchronization protocol to declare supported ftrace clocks.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       | 16 ++++++
 lib/trace-cmd/trace-util.c                    | 52 +++++++++++++++++++
 2 files changed, 68 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 08e98a50..0d323947 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -393,6 +393,22 @@ int tracecmd_msg_recv_time_sync(struct tracecmd_msg_handle *msg_handle,
 				unsigned int *sync_msg_id,
 				unsigned int *payload_size, char **payload);
 
+enum tracecmd_clocks {
+	TRACECMD_CLOCK_UNKNOWN	= 0,
+	TRACECMD_CLOCK_LOCAL	= 1,
+	TRACECMD_CLOCK_GLOBAL	= 1 << 1,
+	TRACECMD_CLOCK_COUNTER	= 1 << 2,
+	TRACECMD_CLOCK_UPTIME	= 1 << 3,
+	TRACECMD_CLOCK_PERF	= 1 << 4,
+	TRACECMD_CLOCK_MONO	= 1 << 5,
+	TRACECMD_CLOCK_MONO_RAW	= 1 << 6,
+	TRACECMD_CLOCK_BOOT	= 1 << 7,
+	TRACECMD_CLOCK_X86_TSC	= 1 << 8
+};
+
+enum tracecmd_clocks tracecmd_clock_str2id(const char *clock);
+const char *tracecmd_clock_id2str(enum tracecmd_clocks clock);
+
 /* --- Timestamp synchronization --- */
 
 #define TRACECMD_TSYNC_PNAME_LENGTH	16
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 8caec7c1..9661b266 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -33,6 +33,58 @@ static bool debug;
 
 static FILE *logfp;
 
+const static struct {
+	const char *clock_str;
+	enum tracecmd_clocks clock_id;
+} trace_clocks[] = {
+	{"local", TRACECMD_CLOCK_LOCAL},
+	{"global", TRACECMD_CLOCK_GLOBAL},
+	{"counter", TRACECMD_CLOCK_COUNTER},
+	{"uptime", TRACECMD_CLOCK_UPTIME},
+	{"perf", TRACECMD_CLOCK_PERF},
+	{"mono", TRACECMD_CLOCK_MONO},
+	{"mono_raw", TRACECMD_CLOCK_MONO_RAW},
+	{"boot", TRACECMD_CLOCK_BOOT},
+	{"x86-tsc", TRACECMD_CLOCK_X86_TSC},
+	{NULL, -1}
+};
+
+/**
+ * tracecmd_clock_str2id - Convert ftrace clock name to clock ID
+ * @clock: Ftrace clock name
+ * Returns ID of the ftrace clock
+ */
+enum tracecmd_clocks tracecmd_clock_str2id(const char *clock)
+{
+	int i;
+
+	if (!clock)
+		return TRACECMD_CLOCK_UNKNOWN;
+
+	for (i = 0; trace_clocks[i].clock_str; i++) {
+		if (!strncmp(clock, trace_clocks[i].clock_str,
+		    strlen(trace_clocks[i].clock_str)))
+			return trace_clocks[i].clock_id;
+	}
+	return TRACECMD_CLOCK_UNKNOWN;
+}
+
+/**
+ * tracecmd_clock_id2str - Convert clock ID to ftare clock name
+ * @clock: Clock ID
+ * Returns name of a ftrace clock
+ */
+const char *tracecmd_clock_id2str(enum tracecmd_clocks clock)
+{
+	int i;
+
+	for (i = 0; trace_clocks[i].clock_str; i++) {
+		if (trace_clocks[i].clock_id == clock)
+			return trace_clocks[i].clock_str;
+	}
+	return NULL;
+}
+
 /**
  * tracecmd_set_debug - Set debug mode of the tracecmd library
  * @set_debug: The new "debug" mode. If true, the tracecmd library is
-- 
2.29.2


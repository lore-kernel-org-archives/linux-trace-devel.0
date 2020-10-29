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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93F00C2D0A3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Oct 2020 11:18:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34D26207DE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Oct 2020 11:18:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pHIPjll8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725805AbgJ2LSY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Oct 2020 07:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727212AbgJ2LSY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Oct 2020 07:18:24 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A74C0613CF
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Oct 2020 04:18:22 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id p22so936635wmg.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Oct 2020 04:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W0J4YtMMe0oDV1ey9nAwXakk8OJkSicQDnwBKJmqmFo=;
        b=pHIPjll8MaiXVag8uiAEJFAIPRHks9zD4NOHK68w/7ap5s5TRoZTTv9nR70nNByUyM
         K4zQRQNK1SBkMHPtHj33h9puY5/TgLa4Euaq58ReqduUX7nZa/RjIVt4J+VGndIzEBGb
         uHkjaXyJhp1+Ha8D8MS3cqxYTJakmVw99vZr87HXRmgqg9GEu5yIjSy9jQ0wMWrsus61
         NBIkCjpRlFTj8PIx8FbAsamSTM0kSWgK1kq/wexp7f7Ue71eWodsgCY2Ns6vzsLqSrJ3
         XnMz7FgKMVHaeOrlNFDLhqLrWKUQgURxc/zG+ZntN/1OSnvfYgIUmtk9hPMhEPMWqlpx
         8JLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W0J4YtMMe0oDV1ey9nAwXakk8OJkSicQDnwBKJmqmFo=;
        b=h4WTPSmUv+cL+viC9krXTt55KybL0pf48oKbgUpRRWiKgDeirxpu+0+dPA41GvVsSI
         45qP4xkk+YVDhdVntkGWJA4Mnu9WjnHWtLW2dIQsW4isVy+j5bxDDXiL7leGrRgJqAfj
         Gvp4uxaqtfspYGdRqRPlAi+8P6L/rX+ADpyQzPCv10T4KzuolfHUyb/OGd5aYLGwP6IO
         PZTnB/SbWHBY5c4K3p+R64munycYGVXobhkA7/nsYPtVR35Vq22/xu+ONs8nFU4U90jN
         7ng/SdMMQ783Rd1gaS947Xzq2cMg5S+0PbAKAoHKe5A9jtP/JUQhMbHFvWDSooNZekSa
         lFFQ==
X-Gm-Message-State: AOAM531AdAnMn5VhNkxTXlyiwFfnmOUaYPdQRUhlSptMzbXc2gczbMN1
        9dEPDxRFO8w2maoH35GCKyLE+cPa2vwFaoE9
X-Google-Smtp-Source: ABdhPJze9XX59IiQSS8YfFFAe7XylYKHvLLUU4uZjkIDlIwXw4+ws+Gjc7ch7MN3d6sZfnOb//5LnA==
X-Received: by 2002:a7b:c453:: with SMTP id l19mr3792610wmi.50.1603970301052;
        Thu, 29 Oct 2020 04:18:21 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id a199sm4308067wmd.8.2020.10.29.04.18.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 04:18:20 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v25 02/16] trace-cmd: Add trace-cmd library APIs for ftrace clock name
Date:   Thu, 29 Oct 2020 13:18:02 +0200
Message-Id: <20201029111816.247241-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201029111816.247241-1-tz.stoyanov@gmail.com>
References: <20201029111816.247241-1-tz.stoyanov@gmail.com>
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
 include/trace-cmd/trace-cmd.h | 16 +++++++++++
 lib/trace-cmd/trace-util.c    | 52 +++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 8d3bea73..b48381cd 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -411,6 +411,22 @@ int tracecmd_msg_recv_time_sync(struct tracecmd_msg_handle *msg_handle,
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
index 0ead96ea..524e3309 100644
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
2.26.2


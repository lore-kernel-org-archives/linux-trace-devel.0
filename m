Return-Path: <SRS0=rOCb=DQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7BF7C433E7
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Oct 2020 14:03:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D2A722267
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Oct 2020 14:03:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lht4XK9P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731820AbgJIODt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Oct 2020 10:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729045AbgJIODt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Oct 2020 10:03:49 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD069C0613D2
        for <linux-trace-devel@vger.kernel.org>; Fri,  9 Oct 2020 07:03:48 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id t25so13184539ejd.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 09 Oct 2020 07:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m8EODmOObj5hq8GGBMpIQngPSwLhMeE4S33NXmLIPeM=;
        b=lht4XK9Pwx2OsJf/Zx7IaXjcTK3MWg5GQwO/ClypKZI/ER2iVkt3LH3DBehmz5ocds
         0v8wNhzWGW9KYEh4qomsx43fbbgZiWXq6IJeZHGTOvXhjzRi7WISdly9CM8FNU71sOFR
         y1LeZ92tLbVLRfoNdp6sd2puXgXoDp4jC/zwJDZ3XagSi5RnRlf2/MMDdqwJqzfRslaH
         49jvil4pNgoWW+nZ6iTpNc/YJdYIHrN8HmyBb+QUzFS0VwhfJAe08DsH1MCTowQIKfUI
         D88IqJjd2MDxZgYuP2nPpQKbTkqW4u3g98BoKN03PWmEAHX7IvWnGKZ+eqzB49ZoTYh5
         ZIxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m8EODmOObj5hq8GGBMpIQngPSwLhMeE4S33NXmLIPeM=;
        b=UK1dfZg/3Is6/FalauxTM5hFvJ2WhN90wg8msnI5rzyJ+60yLrKAOnx2FUg/cKJUdX
         hTy6anrNld7d5L0pmGufvadWIz3C3EJnPUPllf5oOPa3FmShgtcxWLkKDJz6cqriGKht
         rfOP2EKU+hUwiLvaArOz1Ud4i/KzH4u5+sHJExQBTM1pesx6qVSSz6KMeFsZAviVbM7T
         yTD87ZQaTpvCtcB5+mSmu+gHiTz3qa10m0sBIbgPuVA0F/dfTI8IywrXUFZI47PllfQI
         PrA35+BzBMtcVggZSNQBjmZkjgjvrWWEw7Wei+YwwteqNtEzwKQnBTdxZLyjgJAoW2nQ
         KRIA==
X-Gm-Message-State: AOAM531cHBIr7MkFDNd1utLSZfh1U7j3ahlvfn+PLMNymi8IEXO1h05c
        oLIOxn+os3/kl+CENURS9VkbBIXgl2X8bHpO
X-Google-Smtp-Source: ABdhPJzTTa91OKk/75e7U21pePxcR2lpaF6WMlweWcGofgLhXlo4p33w3rDd1CW495BEw2SXhJ5A/g==
X-Received: by 2002:a17:906:7fd7:: with SMTP id r23mr2226011ejs.310.1602252227280;
        Fri, 09 Oct 2020 07:03:47 -0700 (PDT)
Received: from localhost.localdomain ([151.251.253.218])
        by smtp.gmail.com with ESMTPSA id ck19sm6362483ejb.99.2020.10.09.07.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 07:03:46 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v24 03/10] trace-cmd: Add trace-cmd library APIs for ftrace clock name
Date:   Fri,  9 Oct 2020 17:03:31 +0300
Message-Id: <20201009140338.25260-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201009140338.25260-1-tz.stoyanov@gmail.com>
References: <20201009140338.25260-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added enum with ftrace clock IDs and APIs to convert ftrace name to ID
and vice versa, as part of libtracecmd.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h | 16 +++++++++++++
 lib/trace-cmd/trace-util.c    | 45 +++++++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index f9c1f843..393a2e7b 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -415,6 +415,22 @@ int tracecmd_msg_recv_time_sync(struct tracecmd_msg_handle *msg_handle,
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
+char *tracecmd_clock_id2str(enum tracecmd_clocks clock);
+
 /* --- Timestamp synchronization --- */
 
 enum{
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 0ead96ea..e20362e3 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -33,6 +33,51 @@ static bool debug;
 
 static FILE *logfp;
 
+const static struct {
+	char *clock_str;
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
+	for (int i = 0; trace_clocks[i].clock_str; i++) {
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
+char *tracecmd_clock_id2str(enum tracecmd_clocks clock)
+{
+	for (int i = 0; trace_clocks[i].clock_str; i++) {
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


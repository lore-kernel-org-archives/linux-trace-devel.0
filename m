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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B101DC43462
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 09:53:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A85C6145E
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 09:53:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236866AbhEGJyp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 7 May 2021 05:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236636AbhEGJyo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 7 May 2021 05:54:44 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C40C061574
        for <linux-trace-devel@vger.kernel.org>; Fri,  7 May 2021 02:53:43 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id zg3so12693571ejb.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 07 May 2021 02:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g0vdklY04kD2npqSKc0g6BwKJeXmFQKNuUMCw4azhOE=;
        b=auzf7pi7v/6Z0cQIcMOxxYzDjknQ0WnfjHam6J2geIcMFiZwXAKKHllxn3YIGWKhpr
         jOxrL9X3d4vaXlrfR6CAyk7fU4BXJN2N+NYH8sFyzYCVIqj6cYlOWJNMdFRW/AV/DmSG
         HlcEpz1RGCGFsbTdB8mDsbx3kVITUz9DyAc9h0EaDWKOhz24ZKzO+fP/atlcM9rpJKze
         5IcySwZ3C+qbfF72el72jvxQnAQGEDJ12e4PnppuV7BjOef3UCfMudkds0GmoUqA5V0d
         Zhxdfk9dw8i0RGf1Ed8PKKtkhkq/UeuewGnSLDfG5VQaO2Q651xDaYOgFcV1pgq7uv2g
         utGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g0vdklY04kD2npqSKc0g6BwKJeXmFQKNuUMCw4azhOE=;
        b=nBE6TLDbQR+ODcx9yV1QHvnpLA+ro25gtqGwtjebUFlWGEde0fQykzN1cxFVGtU+UW
         h1Pmfc9U4fKIhAvwcgUHs8GVcCnl5AQneN3zquWJGPGsW1PtZPMFaDdL+bM7tTz/pPwe
         blSwt4UmczpN7qgFFRjjEBa9PYbGxfmG5VVEiRlYITWVidJhchacRvI+uaB0sWB0HW+Y
         1EKgc3ekeHjt/zKlckwlC4i8Kxp8OJlIi9eXviFrseex8b4oMlendTXGrvlCY74BvPDU
         oQGNA7vs9pGVrzYfgP7iDr/1HX/hetRv94VlAipADdJ6AJcu6bOe4CN4ziQxu3iSWN56
         FHOg==
X-Gm-Message-State: AOAM531xy1BYiV3Aa7G/3pKycEnMJ+1w/DNbC41FP95iKsAe8fnCkSoN
        +n2Xb7dtKZN8iaDjK9SxRlc=
X-Google-Smtp-Source: ABdhPJwtAZefgOZm1zCMM1KOgmuzFyq+Eu6oJqasEWi5VZzXoZPnBAcrLO3xAfvIKmFgDVaHQKuuIQ==
X-Received: by 2002:a17:906:5791:: with SMTP id k17mr8871331ejq.296.1620381222683;
        Fri, 07 May 2021 02:53:42 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id cr21sm3105812ejc.2.2021.05.07.02.53.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 02:53:41 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 8/8] trace-cmd: Add new function to set log level
Date:   Fri,  7 May 2021 12:53:33 +0300
Message-Id: <20210507095333.1080910-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210507095333.1080910-1-tz.stoyanov@gmail.com>
References: <20210507095333.1080910-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Introduce a new trace-cmd internal function to set the application log
level.
 trace_set_verbose()
The log level can be set using string with log id or log name.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/include/trace-local.h |  2 ++
 tracecmd/trace-cmd.c           | 41 ++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index b3997d00..8da07c83 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -39,6 +39,8 @@ void usage(char **argv);
 extern int silence_warnings;
 extern int show_status;
 
+int trace_set_verbose(char *level);
+
 struct pid_record_data {
 	int			pid;
 	int			brass[2];
diff --git a/tracecmd/trace-cmd.c b/tracecmd/trace-cmd.c
index 60cd3ea1..4e4a73af 100644
--- a/tracecmd/trace-cmd.c
+++ b/tracecmd/trace-cmd.c
@@ -45,6 +45,47 @@ void *malloc_or_die(unsigned int size)
 	return data;
 }
 
+static struct trace_log_severity {
+	int		id;
+	const char	*name;
+} log_severtity[] = {
+	{ .id = TEP_LOG_NONE, .name = "none" },
+	{ .id = TEP_LOG_CRITICAL, .name = "crit" },
+	{ .id = TEP_LOG_ERROR, .name = "err" },
+	{ .id = TEP_LOG_WARNING, .name = "warn" },
+	{ .id = TEP_LOG_INFO, .name = "info" },
+	{ .id = TEP_LOG_DEBUG, .name = "debug" },
+	{ .id = TEP_LOG_ALL, .name = "all" },
+};
+
+int trace_set_verbose(char *level)
+{
+	int id;
+
+	if (!level)
+		return -1;
+
+	if (isdigit(level[0])) {
+		id = atoi(level);
+		if (id >= TEP_LOG_NONE && id <= TEP_LOG_ALL) {
+			tracecmd_set_loglevel(id);
+			return 0;
+		}
+	} else {
+		int size = sizeof(log_severtity) / sizeof(log_severtity[0]);
+		int i;
+
+		for (i = 0; i < size; i++) {
+			if (strlen(level) >= strlen(log_severtity[i].name) &&
+			    !strncmp(level, log_severtity[i].name, strlen(log_severtity[i].name))) {
+				tracecmd_set_loglevel(log_severtity[i].id);
+				return 0;
+			}
+		}
+	}
+
+	return -1;
+}
 
 /**
  * struct command
-- 
2.31.1


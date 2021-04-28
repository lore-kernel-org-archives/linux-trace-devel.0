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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E672BC433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:42:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B137D61407
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:42:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237010AbhD1Hmu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 03:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236343AbhD1Hmt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 03:42:49 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55493C06138A
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:42:01 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id n25so897712edr.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MTz7XU6grsmUvJW3IYxouFKkQ7mInncv6WxuWL8XCig=;
        b=L9mmS+xYTMsGRnuSbHoEM3CsaOHGKbEJjbUCuULYJdzibo/wpCXcmhFgZrZFspEEP6
         nyW9vERLHU1H0qPORiG+gEBeR0wcgWu2AIrE0/ASaxRf0cmlHG1bae942qv/H3d7s6fV
         mEK/Q17YnEIThexpmJpG0z+QRcYza1Hty5czGS392PKtuCUH1Z7uZBcV6vSabsBpXrcH
         fbcqWZf/s6jT2s6ALt8/4g+3xCF7TEcIYs+xQpP2P4HxI9PXJasucFqAfgxyHWwuavtf
         cNLb9NDJixfU9oc0nOrclKWBfe4+HdKz7cx6vCvkCvO5WRGAS8hbaYnFor/WHXNVQw47
         UVbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MTz7XU6grsmUvJW3IYxouFKkQ7mInncv6WxuWL8XCig=;
        b=bpBLAHfWnLg1O9Dxo9ASZBC6Miqg0/oPbIJE3ClKtLHR+IM/HrOG3pAWYKtN/Dwsra
         W/5qzyFXqBvAUubUnDmA8QdaLds1ooX65yumqy9tHGR8EqUhOQrdofTKFKlwPi8BBqk/
         h6yptLy8qZsVkvDEevfCs6wVb0zz6eWE1WOCA78xd7ae/7Em5tRJbyADiqqiGLa8g8nO
         mXA4UtVMwEGGQ1JlxEvZq71rjZHigfd6/BwCowfu8P31jgBQD0YE7IhAQ5AEWuv6aSxc
         bcQvYB6kOzLJzcD1OjMTkGzCdIyEOqLBMr+pWdSmVx/lpnaXwU2K+hENNxc7P0nMX9ML
         k56A==
X-Gm-Message-State: AOAM533pT51EfQS0o3AfvAZVljcHJl6d+BvqYIsEnM/8MkPSbH4l5X1H
        sagpiemEY9Bu5ZShp2WadWxAodqS+W2WOw==
X-Google-Smtp-Source: ABdhPJx39akE4CCizWdceL6iDeqBYBk8hCk3ybyUXvhn71bwcDs8OwrNWx0LuX+O2r9rZNoCbOs7hQ==
X-Received: by 2002:aa7:c7d5:: with SMTP id o21mr9392726eds.166.1619595720157;
        Wed, 28 Apr 2021 00:42:00 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k5sm4530504edk.46.2021.04.28.00.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 00:41:59 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 8/8] trace-cmd: Add new function to set log level
Date:   Wed, 28 Apr 2021 10:41:49 +0300
Message-Id: <20210428074149.757163-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210428074149.757163-1-tz.stoyanov@gmail.com>
References: <20210428074149.757163-1-tz.stoyanov@gmail.com>
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
index 1218de12..cb929be4 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -36,6 +36,8 @@ void usage(char **argv);
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
2.30.2


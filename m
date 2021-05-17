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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76E43C433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 13:40:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AF0D611BF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 13:40:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237429AbhEQNlb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 May 2021 09:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237414AbhEQNla (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 May 2021 09:41:30 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF33C061573
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 May 2021 06:40:14 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id lz27so9245608ejb.11
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 May 2021 06:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yNQWqk+0Vcd131/VdVAxcd/19bSFyi3YCa/nRH/QYv8=;
        b=MrzJd5AquJY2q4xLTy9+2q7GECm8nmMDSwfnn2EBSQpNahQuUIB8812lwDNB5WwpVd
         prWt/6bq4U7uafGtXXqnS5yXEVnKxFGs/1ohJLngo3I3AI/3W/kdYkSQgiBgpzH9Qq2V
         /gGsKRGHbWFO4scBILkVmeNX1HSzBWhUqzEFM4JjFYkutygztPrjEVdzsTorE3FqPU8M
         JfwRNNLcM2pA9qFLItNAacOHtunG6lXJq7HDPTXBHOwkKxE8hvegj/qSf+v+HDGP9nxx
         m4ibtjumY3aREx+QbJutzZdn4q76QT/77xblWvcqewGJ9RsYxMkhc4gKHaXtL69eL6WA
         sMww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yNQWqk+0Vcd131/VdVAxcd/19bSFyi3YCa/nRH/QYv8=;
        b=pRWforY2emECRoydrgK7/gz2uSzW5s9NUFyv0Q+RO0ITe5YTV10zWhj3JOyoAiqpAF
         qjpU2XPGYljRSGnMStkgkyIAoL02QZUYhM+btz38PfsaGOqlrmO30KdzycdverWJ9dfj
         irOJ6r84j/ycVuPHoKxfVRH5oA2Qxw9gZZld5ZgcZD89SnwOGiQir6IVuKYa7VY6+2jI
         ueEQxNessVYgs7I6D/KqndPOwTPlqMOuQPGMA+Grp44/FAKnjsXmO93H2/q/idKTYvhq
         QMRK8mWq15Tf2jbtF5xhl/VLyPI9bJ4Akiy+48h280PXmCNhUsSgU9lri5Od5j+HGA67
         6Urg==
X-Gm-Message-State: AOAM531j7C+O1hRVXU5MdNuT56u5cCrI9SBiMRa6cQSF1TfXXgehVhs0
        7EavwYPQ9sm4xotvTs80voQsagN23qPEWg==
X-Google-Smtp-Source: ABdhPJy2S1pGnZdT6Lxl0XJSPWcIbcc7pHywa8wBI19vW6/xZWyekUxfEUw6PskszU3lnY8/51YG3w==
X-Received: by 2002:a17:906:2e82:: with SMTP id o2mr4968849eji.388.1621258813202;
        Mon, 17 May 2021 06:40:13 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id r25sm10961799edv.78.2021.05.17.06.40.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 06:40:12 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 6/6] trace-cmd: Add new function to set log level
Date:   Mon, 17 May 2021 16:40:05 +0300
Message-Id: <20210517134005.611251-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517134005.611251-1-tz.stoyanov@gmail.com>
References: <20210517134005.611251-1-tz.stoyanov@gmail.com>
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
 tracecmd/trace-cmd.c           | 40 ++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 4c5669c9..e9a0aea8 100644
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
index 60cd3ea1..00cdaa37 100644
--- a/tracecmd/trace-cmd.c
+++ b/tracecmd/trace-cmd.c
@@ -45,6 +45,46 @@ void *malloc_or_die(unsigned int size)
 	return data;
 }
 
+static struct trace_log_severity {
+	int		id;
+	const char	*name;
+} log_severity[] = {
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
+		int size = ARRAY_SIZE(log_severity);
+		int i;
+
+		for (i = 0; i < size; i++) {
+			if (!strncmp(level, log_severity[i].name, strlen(log_severity[i].name))) {
+				tracecmd_set_loglevel(log_severity[i].id);
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


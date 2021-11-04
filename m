Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F8F4C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 11:11:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D42D611EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 11:11:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbhKDLNh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Nov 2021 07:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231418AbhKDLNh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Nov 2021 07:13:37 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 455EEC061714
        for <linux-trace-devel@vger.kernel.org>; Thu,  4 Nov 2021 04:10:59 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id d5so8018017wrc.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 04 Nov 2021 04:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x3VwFCoyTfqgVhXpSDmiowloIpFHoLKymQedOdiM59w=;
        b=KihhQ7cbX0+5vwDEakSOEASQ0GQ3bCnUPUenk8+7bgOzyQbepbPhW1mp6T8Lkc1eoM
         9fuswUn/f2kkkByDY/kC7wxN9QT9Djx/NbpggmHmas6wzLg299EGMjE0wSV/1VO0jJxz
         uk0FR+yKyPY7r+Xkn0k0tR7BIuRcBsHHClaCU7LuvBiRw7c8kdK1Su4CCfZ/TdEEaocy
         HpPJFqzLXjokT73ce/JY9xvKmyos0eApxirM3WjBcsudmj5kwq7jqktp1n7rsR18PUpm
         m9SLu7IJauEQem33gW4z8V7ahjzJk8pCIQRrUaGNArrtb3mDvCPyuv8MssycBxYQ616W
         TvDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x3VwFCoyTfqgVhXpSDmiowloIpFHoLKymQedOdiM59w=;
        b=YH9gkyP+m++QViHZRfgQk1C/+HO8eUgI2GDFwZgf0362H377kpm3cSoIiTG+rUl1//
         X4S6LLCZc6I9FxPNSw9fmDdZzxFiF7wskuLMo45PttvH81836EQd6LT9iKl/RJBusEUs
         o21TLJSFpa5gHbh/jyrdyzI9edimBNZ9pvAMqMEcLsiAzJljyMvjDZOOlVck+APxHiHc
         QCrOptXZU+K0320DEAo7E8wCSutOWe6uoO6LO24mUjqDDz7cZmqMW9H7XxHM8UJfMMV0
         tygzWvrYtZvC0yOUs/Wc79+AMeE/5Weu4S4hXnfV/3Dq78pfuXmptuNNVcRqTvwQL9bY
         HxwQ==
X-Gm-Message-State: AOAM5318sf6UVvmeFkDiYlg4ixP2ErL1DBQCYGiikrlmOusAQilF3Z9d
        wjMhwlh8KbfhNMUp9Gv5F2pXXlwbtADijA==
X-Google-Smtp-Source: ABdhPJxnMnkRrVcyjojl6U4ABMOGp6Iih1GcNPRPKF1Huo8qXcvy/vA7MNKenZXIgHoFGz1N9hfK0A==
X-Received: by 2002:adf:e984:: with SMTP id h4mr60126843wrm.149.1636024257919;
        Thu, 04 Nov 2021 04:10:57 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l18sm5080843wrt.81.2021.11.04.04.10.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 04:10:57 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 08/10] libtracefs: Use the internal dynamic events API when creating synthetic events
Date:   Thu,  4 Nov 2021 13:10:45 +0200
Message-Id: <20211104111047.302660-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211104111047.302660-1-tz.stoyanov@gmail.com>
References: <20211104111047.302660-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Synthetic events are type of ftrace dynamic events. The tracefs library
has dedicated APIs to manage dynamic events of all types. In order the
code to be consistent, the creation of synthetic events inside the
library is reimplemented with these new dynamic events APIs.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 src/tracefs-hist.c | 103 +++++++++++++++++++++------------------------
 1 file changed, 47 insertions(+), 56 deletions(-)

diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 9009dba..08bb2da 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -661,6 +661,7 @@ struct tracefs_synth {
 	struct tep_event	*end_event;
 	struct action		*actions;
 	struct action		**next_action;
+	struct tracefs_dynevent	*dyn_event;
 	char			*name;
 	char			**synthetic_fields;
 	char			**synthetic_args;
@@ -719,6 +720,7 @@ void tracefs_synth_free(struct tracefs_synth *synth)
 		synth->actions = action->next;
 		action_free(action);
 	}
+	tracefs_dynevent_free(synth->dyn_event);
 
 	free(synth);
 }
@@ -889,6 +891,28 @@ synth_init_from(struct tep_handle *tep, const char *start_system,
 	return synth;
 }
 
+static int alloc_synthetic_event(struct tracefs_synth *synth)
+{
+	char *synthetic_format;
+	const char *field;
+	int i;
+
+	synthetic_format = strdup("");
+	if (!synthetic_format)
+		return -1;
+
+	for (i = 0; synth->synthetic_fields && synth->synthetic_fields[i]; i++) {
+		field = synth->synthetic_fields[i];
+		synthetic_format = append_string(synthetic_format, " ", field);
+	}
+
+	synth->dyn_event = dynevent_alloc(TRACEFS_DYNEVENT_SYNTH, NULL,
+					  synth->name, NULL, synthetic_format);
+	free(synthetic_format);
+
+	return synth->dyn_event ? 0 : -1;
+}
+
 /**
  * tracefs_synth_alloc - create a new tracefs_synth instance
  * @tep: The tep handle that holds the events to work on
@@ -1609,38 +1633,6 @@ int tracefs_synth_save(struct tracefs_synth *synth,
 	return 0;
 }
 
-static char *create_synthetic_event(struct tracefs_synth *synth)
-{
-	char *synthetic_event;
-	const char *field;
-	int i;
-
-	synthetic_event = strdup(synth->name);
-	if (!synthetic_event)
-		return NULL;
-
-	for (i = 0; synth->synthetic_fields && synth->synthetic_fields[i]; i++) {
-		field = synth->synthetic_fields[i];
-		synthetic_event = append_string(synthetic_event, " ", field);
-	}
-
-	return synthetic_event;
-}
-
-static int remove_synthetic(const char *synthetic)
-{
-	char *str;
-	int ret;
-
-	ret = asprintf(&str, "!%s", synthetic);
-	if (ret < 0)
-		return -1;
-
-	ret = tracefs_instance_file_append(NULL, "synthetic_events", str);
-	free(str);
-	return ret < 0 ? -1 : 0;
-}
-
 static int remove_hist(struct tracefs_instance *instance,
 		       struct tep_event *event, const char *hist)
 {
@@ -1919,7 +1911,6 @@ tracefs_synth_get_start_hist(struct tracefs_synth *synth)
 int tracefs_synth_create(struct tracefs_instance *instance,
 			 struct tracefs_synth *synth)
 {
-	char *synthetic_event;
 	char *start_hist = NULL;
 	char *end_hist = NULL;
 	int ret;
@@ -1937,14 +1928,10 @@ int tracefs_synth_create(struct tracefs_instance *instance,
 	if (verify_state(synth) < 0)
 		return -1;
 
-	synthetic_event = create_synthetic_event(synth);
-	if (!synthetic_event)
+	if (!synth->dyn_event && alloc_synthetic_event(synth))
+		return -1;
+	if (!tracefs_dynevent_create(synth->dyn_event))
 		return -1;
-
-	ret = tracefs_instance_file_append(NULL, "synthetic_events",
-					   synthetic_event);
-	if (ret < 0)
-		goto free_synthetic;
 
 	start_hist = create_hist(synth->start_keys, synth->start_vars);
 	start_hist = append_filter(start_hist, synth->start_filter,
@@ -1980,9 +1967,7 @@ int tracefs_synth_create(struct tracefs_instance *instance,
  remove_synthetic:
 	free(end_hist);
 	free(start_hist);
-	remove_synthetic(synthetic_event);
- free_synthetic:
-	free(synthetic_event);
+	tracefs_dynevent_destroy(synth->dyn_event, false);
 	return -1;
 }
 
@@ -2007,7 +1992,6 @@ int tracefs_synth_create(struct tracefs_instance *instance,
 int tracefs_synth_destroy(struct tracefs_instance *instance,
 			  struct tracefs_synth *synth)
 {
-	char *synthetic_event;
 	char *hist;
 	int ret;
 
@@ -2041,11 +2025,7 @@ int tracefs_synth_destroy(struct tracefs_instance *instance,
 	ret = remove_hist(instance, synth->start_event, hist);
 	free(hist);
 
-	synthetic_event = create_synthetic_event(synth);
-	if (!synthetic_event)
-		return -1;
-
-	ret = remove_synthetic(synthetic_event);
+	ret = tracefs_dynevent_destroy(synth->dyn_event, false);
 
 	return ret ? -1 : 0;
 }
@@ -2067,7 +2047,7 @@ int tracefs_synth_show(struct trace_seq *seq,
 		       struct tracefs_instance *instance,
 		       struct tracefs_synth *synth)
 {
-	char *synthetic_event = NULL;
+	bool new_event = false;
 	char *hist = NULL;
 	char *path;
 	int ret = -1;
@@ -2082,16 +2062,19 @@ int tracefs_synth_show(struct trace_seq *seq,
 		return -1;
 	}
 
-	synthetic_event = create_synthetic_event(synth);
-	if (!synthetic_event)
-		return -1;
+	if (!synth->dyn_event) {
+		if (alloc_synthetic_event(synth))
+			return -1;
+		new_event = true;
+	}
 
 	path = trace_find_tracing_dir();
 	if (!path)
 		goto out_free;
 
-	trace_seq_printf(seq, "echo '%s' > %s/synthetic_events\n",
-			 synthetic_event, path);
+	trace_seq_printf(seq, "echo '%s%s %s' > %s/%s\n",
+			 synth->dyn_event->prefix, synth->dyn_event->event,
+			 synth->dyn_event->format, path, synth->dyn_event->trace_file);
 
 	tracefs_put_tracing_file(path);
 	path = tracefs_instance_get_dir(instance);
@@ -2116,10 +2099,18 @@ int tracefs_synth_show(struct trace_seq *seq,
 			 hist, path, synth->end_event->system,
 			 synth->end_event->name);
 
+	if (new_event) {
+		tracefs_dynevent_free(synth->dyn_event);
+		synth->dyn_event = NULL;
+	}
+
 	ret = 0;
  out_free:
-	free(synthetic_event);
 	free(hist);
 	tracefs_put_tracing_file(path);
+	if (new_event) {
+		tracefs_dynevent_free(synth->dyn_event);
+		synth->dyn_event = NULL;
+	}
 	return ret;
 }
-- 
2.31.1


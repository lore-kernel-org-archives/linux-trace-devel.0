Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F32FDC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Oct 2021 12:09:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFBA660F90
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Oct 2021 12:09:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbhJ1MLt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Oct 2021 08:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbhJ1MLt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Oct 2021 08:11:49 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74756C061570
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Oct 2021 05:09:22 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id w1so4941529edd.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Oct 2021 05:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PuD6jSrPmqYggXjSyruuq5W1e3gv/9KJaGmkfv5dVdc=;
        b=pZcE1UfP/wAXnZkJsmTT9SP5BPb59Gy0Xm651IZe24cqqtYimvP23rQgDEQGhgbRd2
         y0/aPxPKCrqty08s5w4201tYJaaau+1CUIUMi9i4migGu4SRHcXFHERE6EBx33rv1CtO
         1rncazE9aXRSIyCl4XvgJYp/bfH+D7MrcDS/lidNmf1iE9Uu+yuoY1+c7AFfNX6a/pVt
         2yCgLNtw7y3Z8JMZVXfESPArfZAV14yzXWq3JnEvqQfhO5mgV3GDE0q5GgrjvbXxavrH
         oD835K5QtdrEVG7+x4KRoNKwfs69dV4kmhq6OKBAe/rgm/gT4fdN1DFVmBZizk4Y5Ygh
         VRFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PuD6jSrPmqYggXjSyruuq5W1e3gv/9KJaGmkfv5dVdc=;
        b=UZ6MLV1D7mL5Ng9G7sKW2Z59+FVlwzxs/B9Kw0AGFUT1A2oxlemN3t14nvyMEIxKWZ
         A1l1DNKCrr+E+mW71jb5PS9qU+aaxerY+XGMX7/HN4O1zoYOz7jLNc0ms1JpHs5ta0jl
         SwxVRkhGQLS//wotlmZQpHqnwdkOxpp+ik5S+9PvQ85SrsskagzxFG1DV8BFNXfQwbKX
         dAtRzsqT35umCeqKBh7WHjz6O9evGLCNVuD5/3T/pU44N4vMdn0W38TytSYpi0IohcJ4
         pg95TXlF6qS/h3eP4grr5QP1XPSnVtc9y0X4ef3eUwaJz8EDQxW9fSOf1zeFZMnWaxd1
         M87Q==
X-Gm-Message-State: AOAM530rq5RxZGjr4LM7XOwjD9oNQMSrWOCv7XrzpDii01IuHmAokwWL
        At2U6J6SQwDE85PPc0371T/4/DAo0qcr7Q==
X-Google-Smtp-Source: ABdhPJxWGjK9uY+Q4mV5Nzwr94FL0EY6EJgL9Qdh5iftKZc6rpj+hHfDNWSTe1qiOTJEP2UZakOeIw==
X-Received: by 2002:a05:6402:158:: with SMTP id s24mr5677152edu.189.1635422961091;
        Thu, 28 Oct 2021 05:09:21 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v6sm1803003edc.52.2021.10.28.05.09.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 05:09:20 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 11/12] libtracefs: Use the internal dynamic events API when creating synthetic events
Date:   Thu, 28 Oct 2021 15:09:06 +0300
Message-Id: <20211028120907.101847-12-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211028120907.101847-1-tz.stoyanov@gmail.com>
References: <20211028120907.101847-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Synthetic events are type of ftrace dynamic events. The tracefs library
has an internal helper APIs to manage dynamic events of all types. In
order the code to be consistent, the creation of synthetic events inside
the library is reimplemented with these new dynamic events APIs.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 src/tracefs-hist.c | 88 +++++++++++++++++-----------------------------
 1 file changed, 33 insertions(+), 55 deletions(-)

diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 9009dba..7ac0023 100644
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
+	dynevent_free(synth->dyn_event);
 
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
+	synth->dyn_event = dynevent_alloc(TRACE_DYNEVENT_SYNTH, NULL,
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
+	if (!dynevent_create(synth->dyn_event))
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
+	dynevent_destroy(synth->dyn_event);
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
+	ret = dynevent_destroy(synth->dyn_event);
 
 	return ret ? -1 : 0;
 }
@@ -2067,7 +2047,6 @@ int tracefs_synth_show(struct trace_seq *seq,
 		       struct tracefs_instance *instance,
 		       struct tracefs_synth *synth)
 {
-	char *synthetic_event = NULL;
 	char *hist = NULL;
 	char *path;
 	int ret = -1;
@@ -2082,16 +2061,16 @@ int tracefs_synth_show(struct trace_seq *seq,
 		return -1;
 	}
 
-	synthetic_event = create_synthetic_event(synth);
-	if (!synthetic_event)
+	if (!synth->dyn_event && alloc_synthetic_event(synth))
 		return -1;
 
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
@@ -2118,7 +2097,6 @@ int tracefs_synth_show(struct trace_seq *seq,
 
 	ret = 0;
  out_free:
-	free(synthetic_event);
 	free(hist);
 	tracefs_put_tracing_file(path);
 	return ret;
-- 
2.31.1


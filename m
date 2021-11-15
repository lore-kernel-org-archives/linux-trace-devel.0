Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82F50C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Nov 2021 10:46:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6814661AAD
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Nov 2021 10:46:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbhKOKtR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Nov 2021 05:49:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237647AbhKOKtF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Nov 2021 05:49:05 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5695CC061766
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Nov 2021 02:46:09 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id z10so43322801edc.11
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Nov 2021 02:46:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G1vQ5g3GiREtd+cPcgSIqOvzt/C/6PyJE0cLz6AY9RQ=;
        b=ahcWQBIiqhktZW0c2EWaWwdCE8yPtSDXHQ3md3tKH5JVXagcOlvHzAELL8AfKMelhs
         eh51wZQdypBK6LMiZ7/MBUzZvKfVLZjZ1Vok1/HpqH8+/KL2QojH1CESTypUvz5Z5jfM
         uxqOpePpv7rBjzYcCnAXm1K1BAaBNrC/J5TDce+ruFrN7700j2UfCjCzATE5HvBUUS48
         3HSw69HhZN082t9ESGTJt98hVPzJLlp1fEmwl57ITQdGkYWvry3vqJ5RrHmT4GaJKd2m
         jADpySkAFN8aupU6KxFWFlczBD/YZt0GLg6gjJ7x2DLwoCazMJww/tTjGQ8gpRqm1b/V
         TVOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G1vQ5g3GiREtd+cPcgSIqOvzt/C/6PyJE0cLz6AY9RQ=;
        b=MXDqCfK1XbHaQckiUXbagPjtzBEhZyHBoHSRw99prJwdMRhSpro/dnWzuKlMrVkmYc
         A3aJko219rrE1K/p+Of5XNAmc3AeKuBdoID8boABl/LM1WjZ4seqGnbE8i5WAFAAk2HP
         7tQNMGXk87BTP6aD4PCcoOCEcVpsseSg55asUojTTC2vivegcN/VB7Ux6dKS2up6Kamv
         LtsS2hxtovRSNgA7ZCoT8UB/CVbhombzIMU0HZoSiug3mHZt/Ypjg+5CDmPuVssyb8CK
         NLVQysRs4y5ZZzCVWBm0tCIb15qzeCjI6lxiCtbz3aybm055f4oy8Ml58YtxW1zMWq9+
         ZdMw==
X-Gm-Message-State: AOAM5310IdVGYDTevUzrFTzaisrEZaEZr6nWxrpOtjVSLgIKfm12RYjx
        H1PwX2EUeLhU3andruJ3vTE=
X-Google-Smtp-Source: ABdhPJzFEPV1YJFf8bP6RzvNhwVj0r1EsxXkGY8Jeb8ctSNniTH8xQnF7FGQ8NaitEoLiCiDTB28NQ==
X-Received: by 2002:a50:d74e:: with SMTP id i14mr32133609edj.243.1636973167965;
        Mon, 15 Nov 2021 02:46:07 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e12sm6315509ejs.86.2021.11.15.02.46.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 02:46:07 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 07/15] libtracefs: Use the internal dynamic events API when creating synthetic events
Date:   Mon, 15 Nov 2021 12:45:48 +0200
Message-Id: <20211115104556.121359-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115104556.121359-1-tz.stoyanov@gmail.com>
References: <20211115104556.121359-1-tz.stoyanov@gmail.com>
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
 src/tracefs-hist.c | 105 +++++++++++++++++++++------------------------
 1 file changed, 49 insertions(+), 56 deletions(-)

diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 9009dba..2685dab 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -24,6 +24,8 @@
 #define ASCENDING ".ascending"
 #define DESCENDING ".descending"
 
+#define SYNTHETIC_GROUP "synthetic"
+
 struct tracefs_hist {
 	struct tep_handle	*tep;
 	struct tep_event	*event;
@@ -661,6 +663,7 @@ struct tracefs_synth {
 	struct tep_event	*end_event;
 	struct action		*actions;
 	struct action		**next_action;
+	struct tracefs_dynevent	*dyn_event;
 	char			*name;
 	char			**synthetic_fields;
 	char			**synthetic_args;
@@ -719,6 +722,7 @@ void tracefs_synth_free(struct tracefs_synth *synth)
 		synth->actions = action->next;
 		action_free(action);
 	}
+	tracefs_dynevent_free(synth->dyn_event);
 
 	free(synth);
 }
@@ -889,6 +893,28 @@ synth_init_from(struct tep_handle *tep, const char *start_system,
 	return synth;
 }
 
+static int alloc_synthetic_event(struct tracefs_synth *synth)
+{
+	char *format;
+	const char *field;
+	int i;
+
+	format = strdup("");
+	if (!format)
+		return -1;
+
+	for (i = 0; synth->synthetic_fields && synth->synthetic_fields[i]; i++) {
+		field = synth->synthetic_fields[i];
+		format = append_string(format, i ? " " : NULL, field);
+	}
+
+	synth->dyn_event = dynevent_alloc(TRACEFS_DYNEVENT_SYNTH, SYNTHETIC_GROUP,
+					  synth->name, NULL, format);
+	free(format);
+
+	return synth->dyn_event ? 0 : -1;
+}
+
 /**
  * tracefs_synth_alloc - create a new tracefs_synth instance
  * @tep: The tep handle that holds the events to work on
@@ -1609,38 +1635,6 @@ int tracefs_synth_save(struct tracefs_synth *synth,
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
@@ -1919,7 +1913,6 @@ tracefs_synth_get_start_hist(struct tracefs_synth *synth)
 int tracefs_synth_create(struct tracefs_instance *instance,
 			 struct tracefs_synth *synth)
 {
-	char *synthetic_event;
 	char *start_hist = NULL;
 	char *end_hist = NULL;
 	int ret;
@@ -1937,14 +1930,10 @@ int tracefs_synth_create(struct tracefs_instance *instance,
 	if (verify_state(synth) < 0)
 		return -1;
 
-	synthetic_event = create_synthetic_event(synth);
-	if (!synthetic_event)
+	if (!synth->dyn_event && alloc_synthetic_event(synth))
+		return -1;
+	if (tracefs_dynevent_create(synth->dyn_event))
 		return -1;
-
-	ret = tracefs_instance_file_append(NULL, "synthetic_events",
-					   synthetic_event);
-	if (ret < 0)
-		goto free_synthetic;
 
 	start_hist = create_hist(synth->start_keys, synth->start_vars);
 	start_hist = append_filter(start_hist, synth->start_filter,
@@ -1980,9 +1969,7 @@ int tracefs_synth_create(struct tracefs_instance *instance,
  remove_synthetic:
 	free(end_hist);
 	free(start_hist);
-	remove_synthetic(synthetic_event);
- free_synthetic:
-	free(synthetic_event);
+	tracefs_dynevent_destroy(synth->dyn_event, false);
 	return -1;
 }
 
@@ -2007,7 +1994,6 @@ int tracefs_synth_create(struct tracefs_instance *instance,
 int tracefs_synth_destroy(struct tracefs_instance *instance,
 			  struct tracefs_synth *synth)
 {
-	char *synthetic_event;
 	char *hist;
 	int ret;
 
@@ -2041,11 +2027,7 @@ int tracefs_synth_destroy(struct tracefs_instance *instance,
 	ret = remove_hist(instance, synth->start_event, hist);
 	free(hist);
 
-	synthetic_event = create_synthetic_event(synth);
-	if (!synthetic_event)
-		return -1;
-
-	ret = remove_synthetic(synthetic_event);
+	ret = tracefs_dynevent_destroy(synth->dyn_event, true);
 
 	return ret ? -1 : 0;
 }
@@ -2067,7 +2049,7 @@ int tracefs_synth_show(struct trace_seq *seq,
 		       struct tracefs_instance *instance,
 		       struct tracefs_synth *synth)
 {
-	char *synthetic_event = NULL;
+	bool new_event = false;
 	char *hist = NULL;
 	char *path;
 	int ret = -1;
@@ -2082,16 +2064,19 @@ int tracefs_synth_show(struct trace_seq *seq,
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
@@ -2116,10 +2101,18 @@ int tracefs_synth_show(struct trace_seq *seq,
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
2.33.1


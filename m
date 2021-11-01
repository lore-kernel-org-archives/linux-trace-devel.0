Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 915FEC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Nov 2021 09:09:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C31A610A8
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Nov 2021 09:09:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbhKAJLy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Nov 2021 05:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231749AbhKAJLx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Nov 2021 05:11:53 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A5FC061714
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 Nov 2021 02:09:19 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id w15so62254100edc.9
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Nov 2021 02:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PuD6jSrPmqYggXjSyruuq5W1e3gv/9KJaGmkfv5dVdc=;
        b=C2kujXwTMVjhc0QXBbALvrfC6zYhM9aBEVm06a6RiIUdK+H5xpl4U0qLmSK2loJQaN
         iDDWaTzAdMv3NXrcnDSDvooU6tLpDWZB4GZk+il5uySZx1g0dxyshObN1zBA+mnco6Nr
         wnDW5qfhgvozJ26KOB6DEQu16koNYmDgm0OpXHUZ3RstFP7SHi0/XdWUjFp1I/ZtRrsA
         jCBK9vg33OVF2ERXaCn42EdByPWUlnaVQMR0xaogUnfaXTH99JRgjfPhkb3I9a5+SCW/
         ruVf/XHTGrQw7RjNde1T4mxNRYnTCAM3Igjxumo3Qj+elCnVFWqJ7eiDGhTa5xwFfdow
         pj4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PuD6jSrPmqYggXjSyruuq5W1e3gv/9KJaGmkfv5dVdc=;
        b=aXMQ9lSRdWMhWBlXfDLaRba7pVACgro1mMzZWkpw63nM0Qq92yLN+qMnPWCXpw1qx6
         lpqqPQdoVe2t4tV0uxVdXW8TO1J4I/r3RYpdhLDJR08ZXXSSaAf+RqcbRlroRoiJLLrr
         G71257p2QwkdF9zV3lTqPepp5sUOlbYEYQdHmI1bFqQaFAeyZZ2pNd/KYqzYUDz8BhDj
         Hi8SdLH/qHOk+ZA9yvTB3OmVo1b/v02G2+jtOh/trjz++x6MhYD81JDRxwwirKqscsQW
         NAYKIgOSVqGHZ1YWprjdpYTZjqCgQeuFzpxngl8/DACUiz87XZGp6ApWYdflU5LWGlrL
         JY1g==
X-Gm-Message-State: AOAM530nA0RqoEK/a+lhGFK4h5XUpRj/q0Afnet4WbybmYyS3C2CT9IT
        rSw3BX999bgosz1xqXZAw1U=
X-Google-Smtp-Source: ABdhPJwEqZKbTAdVl1bJGgkD1ApHFsZ/qrKKpfFkri2+OkkEvVH9XmurPa930BfLeXMr72rM0d78aw==
X-Received: by 2002:a05:6402:5216:: with SMTP id s22mr3416258edd.291.1635757757605;
        Mon, 01 Nov 2021 02:09:17 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id i8sm9873222edc.10.2021.11.01.02.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 02:09:17 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 11/12] libtracefs: Use the internal dynamic events API when creating synthetic events
Date:   Mon,  1 Nov 2021 11:09:03 +0200
Message-Id: <20211101090904.81454-12-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211101090904.81454-1-tz.stoyanov@gmail.com>
References: <20211101090904.81454-1-tz.stoyanov@gmail.com>
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


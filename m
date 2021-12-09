Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 396F4C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Dec 2021 16:40:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237662AbhLIQoQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Dec 2021 11:44:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236862AbhLIQoP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Dec 2021 11:44:15 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23E17C061746
        for <linux-trace-devel@vger.kernel.org>; Thu,  9 Dec 2021 08:40:42 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id w1so21327400edc.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 09 Dec 2021 08:40:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ErIwlhS0JS+Xpn346O/fVwtQApIwuWrQmGTDO25XP1w=;
        b=Q0bCQRJuqwMMutmiky9fmXdsAThJtqAuu1uUICumrbP5FaJqNx6i5UBUJUhZSHBXLX
         +txzV29ZkFVCGitaKJdq9lCIS351Az84fER/H8UyLGnZWn8eom6CFypIvTWZRK1LtJGp
         So/xzCJuDFl0R40l04Td4emfTwaDfk9Jc6ZCe2xY5v01HBHqPOM7ekMkrFHHZSq85GQy
         OYkA2mm9SGIGyR93r3YSTc+ArXCmOFu+3hcQGFO0bfy3MRPLcdGJ2lQtAaj+8sBOzIca
         uEPqnvOJ8CiGkwGkf6P6ecU/Wqm7w7dVhqpDFygFwBLsbU2eq+ojAU/6w9UZ6fZWYCS2
         bXDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ErIwlhS0JS+Xpn346O/fVwtQApIwuWrQmGTDO25XP1w=;
        b=EtUDdWIDHof79IPYJ2rExVLLz1IMVwywSbcMaok3GDEEWvJJo8QmAf/StB6wJ3N46j
         Qbuuw1YdxA/AjJSfaImHEZRdnF+vGQ9+DikuHSNEX4OScmKqPrKDUC1WAtxUUrXGHtWJ
         so/fGX+1pXbSbjQr7n9YBry9BpZijWbprwonIADu5gkgVfLEikWt5jKIepgKGKi9YtnW
         jDXpPkR54hjMDIcFILKDyvtqBRsMAGOeNwfftpNktQ3kM4RQ3K+2R0w7y/TI/Z3ZcXsi
         pP+lE8bfxXUFcYaDfPPBmc1WeWzFzBgftI0mqLbEEO/lxAMY1jMVnjnDDWebtmRORtu9
         xCJA==
X-Gm-Message-State: AOAM53332w1mwV3RTsLBMTOF5f/89NyrDneMTisk+xBDRw4Qqjx6q332
        90kpcImRnmk6PJNR2BLwovV5utMgA58=
X-Google-Smtp-Source: ABdhPJzFTO+KzWYygi6zLmOimR1+JT/kDPXrFqSEaHqBVHFYwNeapgxfA+Dmk0KkBcukwKgHb3kLkA==
X-Received: by 2002:a05:6402:2789:: with SMTP id b9mr29667186ede.28.1639067906690;
        Thu, 09 Dec 2021 08:38:26 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id qb21sm179060ejc.78.2021.12.09.08.38.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 08:38:26 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3] libtracefs: New APIs for getting the raw format of synth event
Date:   Thu,  9 Dec 2021 18:38:15 +0200
Message-Id: <20211209163815.16769-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The following APIs are added:
int tracefs_synth_echo_fmt(struct trace_seq *, struct tracefs_synth *)
const char *tracefs_synth_show_event(struct tracefs_synth *)
const char *tracefs_synth_show_start_hist(struct tracefs_synth *)
const char *tracefs_synth_show_end_hist(struct tracefs_synth *)

The new APIs can be useful in the case whene the user wants to
check what exactly gets passed to the kernel as definition of
a synth event.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 Documentation/libtracefs-synth2.txt | 23 ++++++-
 include/tracefs.h                   |  5 ++
 src/tracefs-hist.c                  | 94 +++++++++++++++++++++++------
 3 files changed, 102 insertions(+), 20 deletions(-)

diff --git a/Documentation/libtracefs-synth2.txt b/Documentation/libtracefs-synth2.txt
index 569819a..e557bc9 100644
--- a/Documentation/libtracefs-synth2.txt
+++ b/Documentation/libtracefs-synth2.txt
@@ -5,7 +5,8 @@ NAME
 ----
 tracefs_synth_create, tracefs_synth_destroy, tracefs_synth_echo_cmd, tracefs_synth_complete,
 tracefs_synth_get_start_hist, tracefs_synth_trace, tracefs_synth_snapshot,
-tracefs_synth_get_name - Creation of synthetic events
+tracefs_synth_get_name, tracefs_synth_echo_fmt, tracefs_synth_show_event,
+tracefs_synth_show_start_hist, tracefs_synth_show_end_hist - Creation of synthetic events
 
 SYNOPSIS
 --------
@@ -27,6 +28,11 @@ int tracefs_synth_save(struct tracefs_synth pass:[*]synth,
 		       enum tracefs_synth_handler type, const char pass:[*]var,
 		       char pass:[**]save_fields);
 const char *tracefs_synth_get_name(struct tracefs_synth pass:[*]synth);
+int tracefs_synth_echo_fmt(struct trace_seq pass:[*]seq, struct tracefs_synth pass:[*]synth);
+const char *tracefs_synth_show_event(struct tracefs_synth pass:[*]synth);
+const char *tracefs_synth_show_start_hist(struct tracefs_synth pass:[*]synth);
+const char *tracefs_synth_show_end_hist(struct tracefs_synth pass:[*]synth);
+
 --
 
 DESCRIPTION
@@ -93,9 +99,22 @@ _var_ changes. _var_ must be one of the _name_ elements used in *tracefs_synth_a
 The returned string belongs to the synth event object and is freed with the event
 by *tracefs_synth_free*().
 
+*tracefs_synth_show_event*() returns the format of the dynamic event used by the synthetic
+event or NULL on error. The returned string belongs to the synth event object and is freed
+with the event by *tracefs_synth_free*().
+
+*tracefs_synth_show_start_hist*() returns the format of the start histogram used by the
+synthetic event or NULL on error. The returned string belongs to the synth event object
+and is freed with the event by *tracefs_synth_free*().
+
+*tracefs_synth_show_end_hist*() returns the format of the end histogram used by the
+synthetic event or NULL on error. The returned string belongs to the synth event object
+and is freed with the event by *tracefs_synth_free*().
+
 RETURN VALUE
 ------------
-*tracefs_synth_get_name*() returns a string owned by the synth event object.
+*tracefs_synth_get_name*(), *tracefs_synth_show_event*(), *tracefs_synth_show_start_hist*()
+and *tracefs_synth_show_end_hist*()  return a string owned by the synth event object.
 
 All other functions return zero on success or -1 on error.
 
diff --git a/include/tracefs.h b/include/tracefs.h
index 967690f..b772f5a 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -250,6 +250,7 @@ enum tracefs_dynevent_type {
 	TRACEFS_DYNEVENT_SYNTH		= 1 << 5,
 	TRACEFS_DYNEVENT_MAX		= 1 << 6,
 };
+
 int tracefs_dynevent_create(struct tracefs_dynevent *devent);
 int tracefs_dynevent_destroy(struct tracefs_dynevent *devent, bool force);
 int tracefs_dynevent_destroy_all(unsigned int types, bool force);
@@ -550,6 +551,10 @@ int tracefs_synth_create(struct tracefs_synth *synth);
 int tracefs_synth_destroy(struct tracefs_synth *synth);
 void tracefs_synth_free(struct tracefs_synth *synth);
 int tracefs_synth_echo_cmd(struct trace_seq *seq, struct tracefs_synth *synth);
+int tracefs_synth_echo_fmt(struct trace_seq *seq, struct tracefs_synth *synth);
+const char *tracefs_synth_show_event(struct tracefs_synth *synth);
+const char *tracefs_synth_show_start_hist(struct tracefs_synth *synth);
+const char *tracefs_synth_show_end_hist(struct tracefs_synth *synth);
 
 struct tracefs_synth *tracefs_sql(struct tep_handle *tep, const char *name,
 				  const char *sql_buffer, char **err);
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 6051ecc..f5359a5 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -683,6 +683,8 @@ struct tracefs_synth {
 	struct action		*actions;
 	struct action		**next_action;
 	struct tracefs_dynevent	*dyn_event;
+	char			*start_hist;
+	char			*end_hist;
 	char			*name;
 	char			**synthetic_fields;
 	char			**synthetic_args;
@@ -737,6 +739,8 @@ void tracefs_synth_free(struct tracefs_synth *synth)
 		return;
 
 	free(synth->name);
+	free(synth->start_hist);
+	free(synth->end_hist);
 	tracefs_list_free(synth->synthetic_fields);
 	tracefs_list_free(synth->synthetic_args);
 	tracefs_list_free(synth->start_keys);
@@ -1802,6 +1806,67 @@ static char *create_end_hist(struct tracefs_synth *synth)
 	return create_actions(end_hist, synth);
 }
 
+/*
+ * tracefs_synth_echo_fmt - show the raw format of a synthetic event
+ * @seq: A trace_seq to store the format string
+ * @synth: The synthetic event to read format from
+ *
+ * This shows the raw format that describes the synthetic event, including
+ * the format of the dynamic event and the start / end histograms.
+ *
+ * Returns 0 on succes -1 on error.
+ */
+int tracefs_synth_echo_fmt(struct trace_seq *seq, struct tracefs_synth *synth)
+{
+	if (!synth->dyn_event)
+		return -1;
+
+	trace_seq_printf(seq, "%s", synth->dyn_event->format);
+	trace_seq_printf(seq, "\n%s", synth->start_hist);
+	trace_seq_printf(seq, "\n%s", synth->end_hist);
+
+	return 0;
+}
+
+/*
+ * tracefs_synth_show_event - show the dynamic event used by a synth event
+ * @synth: The synthetic event to read format from
+ *
+ * This shows the raw format of the dynamic event used by the synthetic event.
+ *
+ * Returns format string owned by @synth on success, or NULL on error.
+ */
+const char *tracefs_synth_show_event(struct tracefs_synth *synth)
+{
+	return synth->dyn_event ? synth->dyn_event->format : NULL;
+}
+
+/*
+ * tracefs_synth_show_start_hist - show the start histogram used by a synth event
+ * @synth: The synthetic event to read format from
+ *
+ * This shows the raw format of the start histogram used by the synthetic event.
+ *
+ * Returns format string owned by @synth on success, or NULL on error.
+ */
+const char *tracefs_synth_show_start_hist(struct tracefs_synth *synth)
+{
+	return synth->start_hist;
+}
+
+/*
+ * tracefs_synth_show_end_hist - show the end histogram used by a synth event
+ * @synth: The synthetic event to read format from
+ *
+ * This shows the raw format of the end histogram used by the synthetic event.
+ *
+ * Returns format string owned by @synth on success, or NULL on error.
+ */
+const char *tracefs_synth_show_end_hist(struct tracefs_synth *synth)
+{
+	return synth->end_hist;
+}
+
 static char *append_filter(char *hist, char *filter, unsigned int parens)
 {
 	int i;
@@ -1940,8 +2005,6 @@ tracefs_synth_get_start_hist(struct tracefs_synth *synth)
  */
 int tracefs_synth_create(struct tracefs_synth *synth)
 {
-	char *start_hist = NULL;
-	char *end_hist = NULL;
 	int ret;
 
 	if (!synth) {
@@ -1962,40 +2025,35 @@ int tracefs_synth_create(struct tracefs_synth *synth)
 	if (tracefs_dynevent_create(synth->dyn_event))
 		return -1;
 
-	start_hist = create_hist(synth->start_keys, synth->start_vars);
-	start_hist = append_filter(start_hist, synth->start_filter,
-				   synth->start_parens);
-	if (!start_hist)
+	synth->start_hist = create_hist(synth->start_keys, synth->start_vars);
+	synth->start_hist = append_filter(synth->start_hist, synth->start_filter,
+					  synth->start_parens);
+	if (!synth->start_hist)
 		goto remove_synthetic;
 
-	end_hist = create_end_hist(synth);
-	end_hist = append_filter(end_hist, synth->end_filter,
-				   synth->end_parens);
-	if (!end_hist)
+	synth->end_hist = create_end_hist(synth);
+	synth->end_hist = append_filter(synth->end_hist, synth->end_filter,
+					synth->end_parens);
+	if (!synth->end_hist)
 		goto remove_synthetic;
 
 	ret = tracefs_event_file_append(synth->instance, synth->start_event->system,
 					synth->start_event->name,
-					"trigger", start_hist);
+					"trigger", synth->start_hist);
 	if (ret < 0)
 		goto remove_synthetic;
 
 	ret = tracefs_event_file_append(synth->instance, synth->end_event->system,
 					synth->end_event->name,
-					"trigger", end_hist);
+					"trigger", synth->end_hist);
 	if (ret < 0)
 		goto remove_start_hist;
 
-	free(start_hist);
-	free(end_hist);
-
 	return 0;
 
  remove_start_hist:
-	remove_hist(synth->instance, synth->start_event, start_hist);
+	remove_hist(synth->instance, synth->start_event, synth->start_hist);
  remove_synthetic:
-	free(end_hist);
-	free(start_hist);
 	tracefs_dynevent_destroy(synth->dyn_event, false);
 	return -1;
 }
-- 
2.32.0


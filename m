Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CD1BC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Dec 2021 14:48:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239054AbhLMOsD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Dec 2021 09:48:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbhLMOsD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Dec 2021 09:48:03 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD7BBC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Dec 2021 06:48:02 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id r25so52422430edq.7
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Dec 2021 06:48:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rn93biG3BeXnbchZJMDVPcDQ9dfsoqZ7eZapfLDXULQ=;
        b=G75GKgRrualTRO7Qwpj7LzsLb9dIJKLBmQA9AEr8kpc0AXqW16nPC6OSCa40yxDrOu
         ABrb6v4EbAgGKcX2eFcFBQzGwVx0W4liUvIxvl6cYq8pNGSieHueNXoFS0S/R5vFednh
         30zUjGOG6yakAzVOebxUz0IYEYbBLi33JvllSxBTCJkmOl5ERhWs2J+QePMONT80YFIo
         Idl6G3gqu03Z0VH9P2naDZoEdaSiL9SM2usNUPcb6DDtARDI91X1M3d4Rz51FCxdlcZT
         Py2Ap0qi2R3Q2PrxYAWZSUmaUcQ8WSY8PHxKH8kvnRkMB1OMvYxiJ5F81XEUC6gwO+Pm
         dDCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rn93biG3BeXnbchZJMDVPcDQ9dfsoqZ7eZapfLDXULQ=;
        b=egiC/Pc84YHuzOiH3fgeVEaPYnD8a2AaBIB7miaaYurCezsUSWdCz0KrWVObLvCvBk
         +Zylmn+VPz9w37a/ek4Wz4pYiD6A0YpQua70J64r5u5SFefwNVP5VurUsez+xWu5cUoO
         Yer/PMkH5NWE6BySuJaYYHXn3y61f1cpxH8mYeMfGZEk3xf44hhzoejg6JAu5tb/r0Ru
         oM/c+x9IYf0GHdFf+SEsvEPG1EGMcAZQyobTaO344guiqCpZtqF56dA+YO2ZNY68tK+D
         X6NMtX+Sd5MLUQBVGH1QpsNC62XXLwsc39nQua223mNZC8RbAqtvm6xVnIt+TWVJT5OR
         IRKA==
X-Gm-Message-State: AOAM531OrefqP70Kagw/cP0D36GsMo069eGKNn7VR5GnQ8uoReWEwcWH
        URT0Kh7MiZDc5J0CNin+u5Q=
X-Google-Smtp-Source: ABdhPJzU7+E0THMBDCBvhR30Pnf4WiyD+LxiatHkAsU2N3gB0fosEo+paVX8nfGt3qLUZ7MCjk7/Vw==
X-Received: by 2002:a17:907:c0e:: with SMTP id ga14mr44124413ejc.26.1639406879767;
        Mon, 13 Dec 2021 06:47:59 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id h10sm6447575edj.1.2021.12.13.06.47.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 06:47:59 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v4] libtracefs: New APIs for getting the raw format of synth event
Date:   Mon, 13 Dec 2021 16:47:49 +0200
Message-Id: <20211213144749.117389-1-y.karadz@gmail.com>
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

The new APIs can be useful in the case where the user wants to
check what exactly gets passed to the kernel as definition of
a synth event.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 Documentation/libtracefs-synth2.txt | 26 +++++++-
 include/tracefs.h                   |  5 ++
 src/tracefs-hist.c                  | 94 +++++++++++++++++++++++------
 3 files changed, 105 insertions(+), 20 deletions(-)

diff --git a/Documentation/libtracefs-synth2.txt b/Documentation/libtracefs-synth2.txt
index 569819a..8056ab8 100644
--- a/Documentation/libtracefs-synth2.txt
+++ b/Documentation/libtracefs-synth2.txt
@@ -5,7 +5,8 @@ NAME
 ----
 tracefs_synth_create, tracefs_synth_destroy, tracefs_synth_echo_cmd, tracefs_synth_complete,
 tracefs_synth_get_start_hist, tracefs_synth_trace, tracefs_synth_snapshot,
-tracefs_synth_get_name - Creation of synthetic events
+tracefs_synth_get_name, tracefs_synth_raw_fmt, tracefs_synth_show_event,
+tracefs_synth_show_start_hist, tracefs_synth_show_end_hist - Creation of synthetic events
 
 SYNOPSIS
 --------
@@ -27,6 +28,11 @@ int tracefs_synth_save(struct tracefs_synth pass:[*]synth,
 		       enum tracefs_synth_handler type, const char pass:[*]var,
 		       char pass:[**]save_fields);
 const char *tracefs_synth_get_name(struct tracefs_synth pass:[*]synth);
+int tracefs_synth_raw_fmt(struct trace_seq pass:[*]seq, struct tracefs_synth pass:[*]synth);
+const char *tracefs_synth_show_event(struct tracefs_synth pass:[*]synth);
+const char *tracefs_synth_show_start_hist(struct tracefs_synth pass:[*]synth);
+const char *tracefs_synth_show_end_hist(struct tracefs_synth pass:[*]synth);
+
 --
 
 DESCRIPTION
@@ -93,9 +99,25 @@ _var_ changes. _var_ must be one of the _name_ elements used in *tracefs_synth_a
 The returned string belongs to the synth event object and is freed with the event
 by *tracefs_synth_free*().
 
+*tracefs_synth_raw_fmt*() writes the raw format strings (dynamic event and histograms) of
+the synthetic event in the _seq_ given.
+
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
index 967690f..310ba9e 100644
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
+int tracefs_synth_raw_fmt(struct trace_seq *seq, struct tracefs_synth *synth);
+const char *tracefs_synth_show_event(struct tracefs_synth *synth);
+const char *tracefs_synth_show_start_hist(struct tracefs_synth *synth);
+const char *tracefs_synth_show_end_hist(struct tracefs_synth *synth);
 
 struct tracefs_synth *tracefs_sql(struct tep_handle *tep, const char *name,
 				  const char *sql_buffer, char **err);
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 6051ecc..7146fc1 100644
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
+ * tracefs_synth_raw_fmt - show the raw format of a synthetic event
+ * @seq: A trace_seq to store the format string
+ * @synth: The synthetic event to read format from
+ *
+ * This shows the raw format that describes the synthetic event, including
+ * the format of the dynamic event and the start / end histograms.
+ *
+ * Returns 0 on succes -1 on error.
+ */
+int tracefs_synth_raw_fmt(struct trace_seq *seq, struct tracefs_synth *synth)
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


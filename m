Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB863C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 Jan 2022 17:01:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236950AbiAMRBY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 13 Jan 2022 12:01:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbiAMRBX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 Jan 2022 12:01:23 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88224C061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 13 Jan 2022 09:01:23 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id c71so25477353edf.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 13 Jan 2022 09:01:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lBA9n4NsqqvvIpaeIIWgUDRalSoilI39gB0h6ILQKn0=;
        b=KoIU6aPxuVBa/qr9/QlQRTuz36io641YNTNes10U1iKnlLcizI7Q4xUA5fUfrsDOdS
         E1DUTyICM/S5jTF80+PoZdYGavvjQCUXlXsHBbboGBEEQy7HfKWmz5kz0Tqn8h/6ZOdl
         lrY5PAq8OrfvtY4uaSno86z2fpxpKh8x7E9+MksN2wGxyJep/WwhKUnguBYGFHFBXt3c
         eibuENORBkkBef7+GDI4/oiWvnVojAPpqsi9nyCfWB6Ej5dSZZxyrhQbF431dRANsz/w
         6DMgddREJe9fk97fJNt6ukBadvPRpK0MBVh8dAXJ2itB/haetrOXNiZ2C1wBla64h76V
         2QsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lBA9n4NsqqvvIpaeIIWgUDRalSoilI39gB0h6ILQKn0=;
        b=D97BFmFmXMy/I9meeBe/WNCY69EN2J6DNQQRJ7vW/Dm1656w/hbgq884p/Oe5gxu5s
         yaNyCKz3v1p2J5GPACzenUxwl5CJQs0PUjo5nOZFLn/21z7jMYYjznmtdg9Kway6fGtA
         kqxiVP4AjqaTTknQAK5qj8/xP3sHUGY+Q92B8fMCS/wHcZ6NtfK8MupoXfb41Ne4c7XR
         0SRUkbn8Ra7hjUWcTXOPvEktjYg8gTMVsaKUlKJrgcAplaY9kz6lPyBp1qQV6gT7crAg
         TgLiWInA3rLp+3q2HV84ev3eeUgV+j4BrZCxAh7arKgDauL4y2QQp1xM95bMmL51dVMI
         B9tg==
X-Gm-Message-State: AOAM532lvoEW9J/hWMTEnGSOCA5jW77luluHLPaOyPe0kfNoMv4L6K1I
        uqa/AdwplhorNJSyy02lGag=
X-Google-Smtp-Source: ABdhPJyogRS/gzb29HHb0j0pPmG3jHMDr5Lrp/ieqoYV1gDVGp9uKQFy7T9FYm00R4sfrMlQ+Z4z5g==
X-Received: by 2002:a05:6402:2696:: with SMTP id w22mr4936402edd.253.1642093281772;
        Thu, 13 Jan 2022 09:01:21 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id t20sm1361755edv.81.2022.01.13.09.01.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 09:01:21 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2] libtracefs: New API for getting synthetic event
Date:   Thu, 13 Jan 2022 19:00:59 +0200
Message-Id: <20220113170059.82747-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new API is proposed, to get tep event descriptor for given synthetic
event:

tracefs_synth_get_event ()

The API implementation gets derived from the implementation of the
existing API  tracefs_dynevent_get_event(). It can detect any newly
created or removed synthetic events.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 Documentation/libtracefs-synth2.txt | 13 +++++++++++--
 include/tracefs-local.h             |  2 ++
 include/tracefs.h                   |  2 ++
 src/tracefs-dynevents.c             | 17 +----------------
 src/tracefs-events.c                | 21 +++++++++++++++++++++
 src/tracefs-hist.c                  | 18 ++++++++++++++++++
 6 files changed, 55 insertions(+), 18 deletions(-)

diff --git a/Documentation/libtracefs-synth2.txt b/Documentation/libtracefs-synth2.txt
index 8056ab8..444318c 100644
--- a/Documentation/libtracefs-synth2.txt
+++ b/Documentation/libtracefs-synth2.txt
@@ -6,7 +6,8 @@ NAME
 tracefs_synth_create, tracefs_synth_destroy, tracefs_synth_echo_cmd, tracefs_synth_complete,
 tracefs_synth_get_start_hist, tracefs_synth_trace, tracefs_synth_snapshot,
 tracefs_synth_get_name, tracefs_synth_raw_fmt, tracefs_synth_show_event,
-tracefs_synth_show_start_hist, tracefs_synth_show_end_hist - Creation of synthetic events
+tracefs_synth_show_start_hist, tracefs_synth_show_end_hist, tracefs_synth_get_event
+- Creation of synthetic events
 
 SYNOPSIS
 --------
@@ -32,7 +33,7 @@ int tracefs_synth_raw_fmt(struct trace_seq pass:[*]seq, struct tracefs_synth pas
 const char *tracefs_synth_show_event(struct tracefs_synth pass:[*]synth);
 const char *tracefs_synth_show_start_hist(struct tracefs_synth pass:[*]synth);
 const char *tracefs_synth_show_end_hist(struct tracefs_synth pass:[*]synth);
-
+struct tep_event pass:[*]*tracefs_synth_get_event*(struct tep_handle pass:[*]_tep_, struct tracefs_synth pass:[*]_synth_);
 --
 
 DESCRIPTION
@@ -114,11 +115,19 @@ and is freed with the event by *tracefs_synth_free*().
 synthetic event or NULL on error. The returned string belongs to the synth event object
 and is freed with the event by *tracefs_synth_free*().
 
+The *tracefs_synth_get_event*() function returns a tep event, describing the given synthetic
+event. The API detects any newly created or removed dynamic events. The returned pointer to
+tep event is controlled by @tep and must not be freed.
+
 RETURN VALUE
 ------------
 *tracefs_synth_get_name*(), *tracefs_synth_show_event*(), *tracefs_synth_show_start_hist*()
 and *tracefs_synth_show_end_hist*()  return a string owned by the synth event object.
 
+The *tracefs_synth_get_event*() function returns a pointer to a tep event or NULL in case of an
+error or if the requested synthetic event is missing. The returned pointer to tep event is
+controlled by @tep and must not be freed.
+
 All other functions return zero on success or -1 on error.
 
 ERRORS
diff --git a/include/tracefs-local.h b/include/tracefs-local.h
index daea5da..bf157e1 100644
--- a/include/tracefs-local.h
+++ b/include/tracefs-local.h
@@ -116,5 +116,7 @@ int trace_load_events(struct tep_handle *tep,
 		      const char *tracing_dir, const char *system);
 int trace_rescan_events(struct tep_handle *tep,
 			const char *tracing_dir, const char *system);
+struct tep_event *get_tep_event(struct tep_handle *tep,
+				const char *system, const char *name);
 
 #endif /* _TRACE_FS_LOCAL_H */
diff --git a/include/tracefs.h b/include/tracefs.h
index bd758dc..9c53b84 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -564,5 +564,7 @@ const char *tracefs_synth_show_end_hist(struct tracefs_synth *synth);
 
 struct tracefs_synth *tracefs_sql(struct tep_handle *tep, const char *name,
 				  const char *sql_buffer, char **err);
+struct tep_event *
+tracefs_synth_get_event(struct tep_handle *tep, struct tracefs_synth *synth);
 
 #endif /* _TRACE_FS_H */
diff --git a/src/tracefs-dynevents.c b/src/tracefs-dynevents.c
index d089d02..ddebb6b 100644
--- a/src/tracefs-dynevents.c
+++ b/src/tracefs-dynevents.c
@@ -765,23 +765,8 @@ error:
 struct tep_event *
 tracefs_dynevent_get_event(struct tep_handle *tep, struct tracefs_dynevent *dynevent)
 {
-	struct tep_event *event;
-
 	if (!tep || !dynevent || !dynevent->event)
 		return NULL;
 
-	/* Check if event exists in the system */
-	if (!tracefs_event_file_exists(NULL, dynevent->system, dynevent->event, "format"))
-		return NULL;
-
-	/* If the dynamic event is already loaded in the tep, return it */
-	event = tep_find_event_by_name(tep, dynevent->system, dynevent->event);
-	if (event)
-		return event;
-
-	/* Try to load any new events from the given system */
-	if (trace_rescan_events(tep, NULL, dynevent->system))
-		return NULL;
-
-	return tep_find_event_by_name(tep, dynevent->system, dynevent->event);
+	return get_tep_event(tep, dynevent->system, dynevent->event);
 }
diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index 067f6e0..30e80ce 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -752,6 +752,27 @@ __hidden int trace_load_events(struct tep_handle *tep,
 	return load_events(tep, tracing_dir, system, false);
 }
 
+__hidden struct tep_event *get_tep_event(struct tep_handle *tep,
+					 const char *system, const char *name)
+{
+	struct tep_event *event;
+
+	/* Check if event exists in the system */
+	if (!tracefs_event_file_exists(NULL, system, name, "format"))
+		return NULL;
+
+	/* If the dynamic event is already loaded in the tep, return it */
+	event = tep_find_event_by_name(tep, system, name);
+	if (event)
+		return event;
+
+	/* Try to load any new events from the given system */
+	if (trace_rescan_events(tep, NULL, system))
+		return NULL;
+
+	return tep_find_event_by_name(tep, system, name);
+}
+
 static int read_header(struct tep_handle *tep, const char *tracing_dir)
 {
 	struct stat st;
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 7146fc1..8d99492 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -2197,3 +2197,21 @@ int tracefs_synth_echo_cmd(struct trace_seq *seq,
 	}
 	return ret;
 }
+
+/**
+ * tracefs_synth_get_event - return tep event representing the given synthetic event
+ * @tep: a handle to the trace event parser context that holds the events
+ * @synth: a synthetic event context, describing given synthetic event.
+ *
+ * Returns a pointer to a tep event describing the given synthetic event. The pointer
+ * is managed by the @tep handle and must not be freed. In case of an error, or in case
+ * the requested synthetic event is missing in the @tep handler - NULL is returned.
+ */
+struct tep_event *
+tracefs_synth_get_event(struct tep_handle *tep, struct tracefs_synth *synth)
+{
+	if (!tep || !synth || !synth->name)
+		return NULL;
+
+	return get_tep_event(tep, SYNTHETIC_GROUP, synth->name);
+}
-- 
2.32.0


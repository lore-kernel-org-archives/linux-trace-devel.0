Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB2ACC433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Jan 2022 16:36:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241248AbiALQgb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 Jan 2022 11:36:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239650AbiALQgb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 Jan 2022 11:36:31 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE30C06173F
        for <linux-trace-devel@vger.kernel.org>; Wed, 12 Jan 2022 08:36:30 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id u21so12241591edd.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 12 Jan 2022 08:36:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GMbrr4F2n5aopLI0rNn89A9cSlliMprdBafL3rf+h08=;
        b=Kz1yNRYoaXhsRi702fanrt/yP89sv4OT8hGSb6WOxvx/tEYGsRHArgYKBm4N8LRiXg
         07+y0KiGYygqEJh6ZliKegTLZaa9PYTel90y0E5tYEyaCDeFJtKKildT8T4W/fF8bgrg
         9LjnCsSv8hKNX0lpRVQmwVdO0tKePlEYL+uau+fh2+SV4bFpyuETR9BI1Hr1PMBAz0n3
         wSu7HEAvtI7XwhCFpOq1h0OucCDon4sSAWDJqJ/2rwN4kBpuwxuCswOPmLAX36ZTGmOY
         N4iBHXAJNy4CW4IElN5HTLvauFBMLeJcdtrt37k/f7fYyr1rN+xF/SB9fazowzCi4hJm
         IZJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GMbrr4F2n5aopLI0rNn89A9cSlliMprdBafL3rf+h08=;
        b=DP6cKqZtCfi3+e2HW2IFcW+GoS7nlmZ+kHeqAlIYRzIrdqATQ6H3GTh/048Ecx4h51
         0IA8+tjyE/1r7IwdSQCjPHxB4gjO4yHsNisFa0o3G2nsy8OQPTxXmHNUNsSxcb4ZMSW6
         MZiC1/orReSKfeGqn5t0NCqo3QszjeOvv1ducrYj69kiGLInim29U9jhUvyXIi4HxN21
         wDxfynKKE9xV4ovl4OTwlfR0Gv1wwkNPDB9SzEMy0rtzDCyTn+NIdKV916IZAP/dAekx
         nxndyukaTyBCcW6YOEUx1e/K4ut99wzti7YdV5QD4Yfxq9+lBZMiys5KrslUNjVSddzg
         De6w==
X-Gm-Message-State: AOAM5316EJd+tszYog7Ep1THQvo6Bu9d7m1kOkKOPof3WOtvtiiedr5M
        m6I6Bts9SdstXYS/qbYReFw=
X-Google-Smtp-Source: ABdhPJzsOfGjVI0k+E7WMGCk+2VFm+unhhvJI+YtaYrXCAI5Qc8OKUjzMlQ6ZeRSZGUIFlvbrbBWPw==
X-Received: by 2002:a17:906:1da9:: with SMTP id u9mr429276ejh.756.1642005389486;
        Wed, 12 Jan 2022 08:36:29 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id dd5sm69960ejc.99.2022.01.12.08.36.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 08:36:29 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH] libtracefs: New API for getting synthetic event
Date:   Wed, 12 Jan 2022 18:36:19 +0200
Message-Id: <20220112163619.21762-1-y.karadz@gmail.com>
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
 Documentation/libtracefs-synth2.txt | 14 ++++++++++++--
 include/tracefs-local.h             |  2 ++
 include/tracefs.h                   |  2 ++
 src/tracefs-dynevents.c             | 17 +----------------
 src/tracefs-events.c                | 21 +++++++++++++++++++++
 src/tracefs-hist.c                  | 18 ++++++++++++++++++
 6 files changed, 56 insertions(+), 18 deletions(-)

diff --git a/Documentation/libtracefs-synth2.txt b/Documentation/libtracefs-synth2.txt
index 8056ab8..fac155b 100644
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
@@ -32,7 +33,8 @@ int tracefs_synth_raw_fmt(struct trace_seq pass:[*]seq, struct tracefs_synth pas
 const char *tracefs_synth_show_event(struct tracefs_synth pass:[*]synth);
 const char *tracefs_synth_show_start_hist(struct tracefs_synth pass:[*]synth);
 const char *tracefs_synth_show_end_hist(struct tracefs_synth pass:[*]synth);
-
+tracefs_synth_get_event
+struct tep_event pass:[*]*tracefs_synth_get_event*(struct tep_handle pass:[*]_tep_, struct tracefs_synth pass:[*]_synth_);
 --
 
 DESCRIPTION
@@ -114,11 +116,19 @@ and is freed with the event by *tracefs_synth_free*().
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
index daea5da..fc0a2c5 100644
--- a/include/tracefs-local.h
+++ b/include/tracefs-local.h
@@ -116,5 +116,7 @@ int trace_load_events(struct tep_handle *tep,
 		      const char *tracing_dir, const char *system);
 int trace_rescan_events(struct tep_handle *tep,
 			const char *tracing_dir, const char *system);
+__hidden struct tep_event *get_tep_event(struct tep_handle *tep,
+					 const char *system, const char *name);
 
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


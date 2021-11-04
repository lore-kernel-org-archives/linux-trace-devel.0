Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39AD1C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 11:11:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21CCF611EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 11:11:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbhKDLNh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Nov 2021 07:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231403AbhKDLNg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Nov 2021 07:13:36 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EFEBC061714
        for <linux-trace-devel@vger.kernel.org>; Thu,  4 Nov 2021 04:10:58 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id d13so7979589wrf.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 04 Nov 2021 04:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xBZ9sYn+Agc63VpPfjAqa4yXBpXyj5VMjddks225At0=;
        b=qzeETEyIfhQ9lmuiCD8+P+tkMDbXiy+NoA4msS7hZ7NoThLvyKVoQC+HlNb+slD9LS
         UAiyKJ5f6BJG+VLaRoKqGNWdK6ANYExyTz2y9d9d2oxXuNScAdhehsuxDaG+3ykW12Mc
         MqoBXDlbv5jeyZQSEa5W1qh/VjIIGd+D8eh52qz3FWfM6bIP445IKjLqOLIc/z8A5X7+
         vpO8mu3vZ73zFToVK/yEo5tXDwkazpIon10+604otteNZn0zVPdv25wAUcWRHuqs50w3
         nSnc2DEfKw8RXB4jPpqTFqbKl2iELgKC67wdLOdf5dv9P8YKSiMy+nc7WwYrTltkTiHD
         8hkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xBZ9sYn+Agc63VpPfjAqa4yXBpXyj5VMjddks225At0=;
        b=AIBCb1tdefrVOdiVES6B7lMan4pJ767N9k9cn2tgkAVVurZGEPsSkYx1jIu3q2Wnva
         Rxi6GiY7SFPdAIfryfECXRX3qaznyxhE57/y4GjJv9Gs7bHyhBthm2QrMIT7xzgFi7UZ
         E/U9hGjqHfYv+kwY77k4nOgmPHEJAYEmajlBmCSTCOyYqgJ5B2yUoVX38lMUUaoO2Dqf
         hHp+th88c03lTITflWw4MVmin2dE7jeMBR7HQnELo6uvwgFZXRPdhnuJFTSrlpI4J+LD
         gyQ7iA3+mv0khqFSYADuFCe3Z43bPo5NgLzBE/7OPc7ZxY1d+cr6YD0DYZ2e5kfuGwHr
         nngQ==
X-Gm-Message-State: AOAM532Ue8Nz2Qvg7td6NGIc6cJUeEibGAQi6v7lqU3XvcWkpMoR3VXw
        91QPor7cy6D+RWQ6gHKEnn4=
X-Google-Smtp-Source: ABdhPJxGD3Fl7fJEvcAwFwgpq53s8GrYXziqR95gdfo4/6yHOSizktayz437V0J4v3ew/1bH5decdg==
X-Received: by 2002:adf:c514:: with SMTP id q20mr46406663wrf.420.1636024256972;
        Thu, 04 Nov 2021 04:10:56 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l18sm5080843wrt.81.2021.11.04.04.10.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 04:10:56 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 07/10] libtracefs: Rename tracefs_synth_init API
Date:   Thu,  4 Nov 2021 13:10:44 +0200
Message-Id: <20211104111047.302660-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211104111047.302660-1-tz.stoyanov@gmail.com>
References: <20211104111047.302660-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In order to be consistent with the others library APIs, the
tracefs_synth_init() is renamed to tracefs_synth_alloc().

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracefs-synth.txt  | 20 ++++++++++----------
 Documentation/libtracefs-synth2.txt | 10 +++++-----
 include/tracefs.h                   | 18 +++++++++---------
 src/tracefs-hist.c                  | 22 +++++++++++-----------
 src/tracefs-sqlhist.c               |  6 +++---
 5 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/Documentation/libtracefs-synth.txt b/Documentation/libtracefs-synth.txt
index 77076e1..2fd9019 100644
--- a/Documentation/libtracefs-synth.txt
+++ b/Documentation/libtracefs-synth.txt
@@ -3,7 +3,7 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_synth_init, tracefs_synth_add_match_field, tracefs_synth_add_compare_field, tracefs_synth_add_start_field,
+tracefs_synth_alloc, tracefs_synth_add_match_field, tracefs_synth_add_compare_field, tracefs_synth_add_start_field,
 tracefs_synth_add_end_field, tracefs_synth_append_start_filter, tracefs_synth_append_end_filter, tracefs_synth_free,
 - Creation of a synthetic event descriptor
 
@@ -13,7 +13,7 @@ SYNOPSIS
 --
 *#include <tracefs.h>*
 
-struct tracefs_synth pass:[*]tracefs_synth_init(struct tep_handle pass:[*]tep,
+struct tracefs_synth pass:[*]tracefs_synth_alloc(struct tep_handle pass:[*]tep,
 					 const char pass:[*]name,
 					 const char pass:[*]start_system,
 					 const char pass:[*]start_event,
@@ -69,7 +69,7 @@ as a field for both events to calculate the delta in nanoseconds, or use
 *TRACEFS_TIMESTAMP_USECS" as the compare fields for both events to calculate the
 delta in microseconds. This is used as the example below.
 
-*tracefs_synth_init*() allocates and initializes a synthetic event.
+*tracefs_synth_alloc*() allocates and initializes a synthetic event.
 It does not create the synthetic event, but supplies the minimal information
 to do so. See *tracefs_synth_create*(3) for how to create the synthetic
 event in the system. It requires a _tep_ handler that can be created by
@@ -156,11 +156,11 @@ _field_, _compare_, and _val_ are ignored unless _type_ is equal to
 filters on the ending event.
 
 *tracefs_synth_free*() frees the allocated descriptor returned by
-*tracefs_synth_init*().
+*tracefs_synth_alloc*().
 
 RETURN VALUE
 ------------
-*tracefs_synth_init*() returns an allocated struct tracefs_synth descriptor
+*tracefs_synth_alloc*() returns an allocated struct tracefs_synth descriptor
 on sucess or NULL on error.
 
 All other functions that return an integer returns zero on success or -1
@@ -209,11 +209,11 @@ static void make_event(void)
 	tep = tracefs_local_events(NULL);
 
 	/* Initialize the synthetic event */
-	synth = tracefs_synth_init(tep, "wakeup_lat",
-				   NULL, start_event,
-				   NULL, end_event,
-				   start_field, end_field,
-				   match_name);
+	synth = tracefs_synth_alloc(tep, "wakeup_lat",
+				    NULL, start_event,
+				    NULL, end_event,
+				    start_field, end_field,
+				    match_name);
 
 	/* The tep is no longer needed */
 	tep_free(tep);
diff --git a/Documentation/libtracefs-synth2.txt b/Documentation/libtracefs-synth2.txt
index 4c44253..f734b44 100644
--- a/Documentation/libtracefs-synth2.txt
+++ b/Documentation/libtracefs-synth2.txt
@@ -142,11 +142,11 @@ static void make_event(void)
 	tep = tracefs_local_events(NULL);
 
 	/* Initialize the synthetic event */
-	synth = tracefs_synth_init(tep, "wakeup_lat",
-				   NULL, start_event,
-				   NULL, end_event,
-				   start_field, end_field,
-				   match_name);
+	synth = tracefs_synth_alloc(tep, "wakeup_lat",
+				    NULL, start_event,
+				    NULL, end_event,
+				    start_field, end_field,
+				    match_name);
 
 	/* The tep is no longer needed */
 	tep_free(tep);
diff --git a/include/tracefs.h b/include/tracefs.h
index 8377ade..ad8a7f5 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -478,15 +478,15 @@ enum tracefs_synth_handler {
 	TRACEFS_SYNTH_HANDLE_CHANGE,
 };
 
-struct tracefs_synth *tracefs_synth_init(struct tep_handle *tep,
-					 const char *name,
-					 const char *start_system,
-					 const char *start_event,
-					 const char *end_system,
-					 const char *end_event,
-					 const char *start_match_field,
-					 const char *end_match_field,
-					 const char *match_name);
+struct tracefs_synth *tracefs_synth_alloc(struct tep_handle *tep,
+					  const char *name,
+					  const char *start_system,
+					  const char *start_event,
+					  const char *end_system,
+					  const char *end_event,
+					  const char *start_match_field,
+					  const char *end_match_field,
+					  const char *match_name);
 int tracefs_synth_add_match_field(struct tracefs_synth *synth,
 				  const char *start_match_field,
 				  const char *end_match_field,
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 27bab00..9009dba 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -692,7 +692,7 @@ static void action_free(struct action *action)
  * @synth: The tracefs_synth descriptor
  *
  * Frees the resources allocated for a @synth created with
- * tracefs_synth_init(). It does not touch the system. That is,
+ * tracefs_synth_alloc(). It does not touch the system. That is,
  * any synthetic event created, will not be destroyed by this
  * function.
  */
@@ -890,7 +890,7 @@ synth_init_from(struct tep_handle *tep, const char *start_system,
 }
 
 /**
- * tracefs_synth_init - create a new tracefs_synth instance
+ * tracefs_synth_alloc - create a new tracefs_synth instance
  * @tep: The tep handle that holds the events to work on
  * @name: The name of the synthetic event being created
  * @start_system: The name of the system of the start event (can be NULL)
@@ -933,15 +933,15 @@ synth_init_from(struct tep_handle *tep, const char *start_system,
  * event on the system is not created. That needs to be done with
  * tracefs_synth_create().
  */
-struct tracefs_synth *tracefs_synth_init(struct tep_handle *tep,
-					 const char *name,
-					 const char *start_system,
-					 const char *start_event_name,
-					 const char *end_system,
-					 const char *end_event_name,
-					 const char *start_match_field,
-					 const char *end_match_field,
-					 const char *match_name)
+struct tracefs_synth *tracefs_synth_alloc(struct tep_handle *tep,
+					  const char *name,
+					  const char *start_system,
+					  const char *start_event_name,
+					  const char *end_system,
+					  const char *end_event_name,
+					  const char *start_match_field,
+					  const char *end_match_field,
+					  const char *match_name)
 {
 	struct tep_event *end_event;
 	struct tracefs_synth *synth;
diff --git a/src/tracefs-sqlhist.c b/src/tracefs-sqlhist.c
index d77ce86..016f3eb 100644
--- a/src/tracefs-sqlhist.c
+++ b/src/tracefs-sqlhist.c
@@ -1419,9 +1419,9 @@ static struct tracefs_synth *build_synth(struct tep_handle *tep,
 	assign_match(start_system, start_event, match,
 		     &start_match, &end_match);
 
-	synth = tracefs_synth_init(tep, name, start_system,
-				   start_event, end_system, end_event,
-				   start_match, end_match, NULL);
+	synth = tracefs_synth_alloc(tep, name, start_system,
+				    start_event, end_system, end_event,
+				    start_match, end_match, NULL);
 	if (!synth)
 		return synth_init_error(tep, table);
 
-- 
2.31.1


Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2281C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Nov 2021 15:44:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AABE06023E
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Nov 2021 15:44:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbhKCPrG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 3 Nov 2021 11:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231876AbhKCPrG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Nov 2021 11:47:06 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94626C061714
        for <linux-trace-devel@vger.kernel.org>; Wed,  3 Nov 2021 08:44:29 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id f7-20020a1c1f07000000b0032ee11917ceso2211902wmf.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 03 Nov 2021 08:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M3ggEzeCUo4hp56OrMsHEbxHXlYaNvdo6FJoU+100xo=;
        b=hWtbH8FqUVTwp+3jYv0paVgifqjbK3z3D/alMXPsrxvAcIdJ+/v0q+FTC3o8q/eJKC
         ehPnlMPGHUL/c77V5lshbOjSOXfzCkWDe+iGLGvlDVC0Pkh+MmwEfmNmVk3uVm3Kj+86
         pCkajqchCuilnnRbnhpkJyr7CClq6L7cNlKaxoJU9tbn0qtrRSuKkdkZ1dCX871pdeK6
         gxCKR9kZ1T67mVAgWaEDj+HpGZByCuoBEI5kSW5z8wkrhcp0/IAk8oQEbH+eKlVWHmdg
         T4bUEl9MaUwaZDsdbte7cBf7bbYkrKOzq3/DPICb7bYvy7wlfOB4w86xKJHYMGs8g3Zs
         FMYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M3ggEzeCUo4hp56OrMsHEbxHXlYaNvdo6FJoU+100xo=;
        b=TmKloSowyvQeqqu5Jto724LZ0lrfSq8bPQAR6bl7SJ2ouJB7OMWT1qRvuHAi7559KC
         kmsshCNWxb5glLCxRvUKMB5JniQCRzvqphs0NMVrTUFYcz+q3xs/19K2PcS2mpEGmDLc
         3UEzS2sb45bIKlP2kmCkSC0hDp250W/4//pZB28Z8sTqrYL4GRAxAZZrVesP5NZpssqq
         4TRaDNJYnUjxEaD3Ck0kTV13FEAnEqeJYdoZ1zYUi9CABbP22ZzPUsZ13fgarU68d4Bd
         ipBtiHKsKKOBrfwKr2J/PwHVs395YizSNsKQcMzRJybZ4nQa11v6wXmiA7HueCDRvh+5
         HCOA==
X-Gm-Message-State: AOAM530GbZa+LxRnud4bfkTY5OCPQ11AnaJ1e56xCurUsjhl1hGWk1I8
        /zfq6zvUS/pUligPL8kHvCg=
X-Google-Smtp-Source: ABdhPJzhxwd8kE72WsE4kf0ZL4gUuSO3CCcwBP+TiLiX9+qhmeQmYdDfbgCZWSTcUcDZMJciedTLcw==
X-Received: by 2002:a1c:4e04:: with SMTP id g4mr15688742wmh.15.1635954268135;
        Wed, 03 Nov 2021 08:44:28 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p12sm2767866wrr.10.2021.11.03.08.44.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 08:44:27 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 08/11] libtracefs: Rename tracefs_synth_init API
Date:   Wed,  3 Nov 2021 17:44:14 +0200
Message-Id: <20211103154417.246999-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211103154417.246999-1-tz.stoyanov@gmail.com>
References: <20211103154417.246999-1-tz.stoyanov@gmail.com>
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
index 8ff9d12..67c7af1 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -482,15 +482,15 @@ enum tracefs_synth_handler {
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


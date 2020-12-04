Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15F2DC433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Dec 2020 08:48:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBE6F225A9
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Dec 2020 08:48:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727875AbgLDIsX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 4 Dec 2020 03:48:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbgLDIsX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Dec 2020 03:48:23 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA4B7C061A51
        for <linux-trace-devel@vger.kernel.org>; Fri,  4 Dec 2020 00:47:42 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id e25so6321122wme.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 04 Dec 2020 00:47:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nzPH7CDfA5/LehvmQvd6ASuGRUmAUBWTTV1qLByrxR0=;
        b=i/6wkGi2vnkbjHLfLZdnodDp0u1rNi9hLMl80eYWMiDHByqa/fx8UbczG+tVuDWltp
         2pnzqqXAjZmJeD43TrfE+RO46Gb91bQjBoxr8EkKVLf2L2Z888/fEafKBe5Sd5pR2uj0
         sYhDifnNFgplQLmu7mfwTBc26U0DbuQv0l9Fk765IqW0m8oLXb5KQ4LueqkpY0Wr3Xho
         GMwzrLL0Zlpc20pcn5jPWj76a3ZIecZvx/5iLSoxYh941zTCHzmpp+ENTcG2QXnq/xk6
         O65DZl+aitVf9t7roh6DVRlp0dCotrjkg+Ux4FEMOr1mi9nFMW5xVZXBQBKGvkNgcsrh
         g+Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nzPH7CDfA5/LehvmQvd6ASuGRUmAUBWTTV1qLByrxR0=;
        b=PjD8KAjYOwDAuUHQp+/ufm3OOfkGM1S4nTq/IaKyYUqRRx2GZle4CW411EzLuYYwIO
         vBPxLEd3h/uZPRZSnFmPxqVUzqVZmLcCf+4KQNG/vAmpoDehhR78bOq6/SOv72TnwSGR
         gN7K3+rGigQD/KrGI7s4k306JyHQwJjYI+fBbbO1yFoYEWQg50zuKlZWD+ZRETw1dYQT
         0D6ILY/OPRRb/w6rxEabg4lPQ2Y8ZsdU684M2O8TK6e59rctDphuUU5Z7uJA6BXoBy0I
         fSPkGYwh2vaGhespU9yF6X24DncNWWAvVmlfN7AYbFFPErR8u/YTmuDHQSt0TRjcWVZv
         MfaA==
X-Gm-Message-State: AOAM531OGSVIrPMAAE8KzMp4gHh0ViMrhGPw6rcN3TohEgfahWd/WTwr
        0I/W4PmlkLh4zEWo/MumKGp6HA1Xjb68owwL
X-Google-Smtp-Source: ABdhPJyxOaMmyIgFQpK+GupVwS37qT3NH5i2BePrc8fXgtGVn22ig32vb2tVNWkoSV46+t8s8Nh/Tg==
X-Received: by 2002:a1c:dc83:: with SMTP id t125mr2996507wmg.12.1607071661541;
        Fri, 04 Dec 2020 00:47:41 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id a15sm2756175wrn.75.2020.12.04.00.47.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 00:47:40 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] libtracefs: Extend tracefs_iterate_raw_events() to iterate per CPU
Date:   Fri,  4 Dec 2020 10:47:39 +0200
Message-Id: <20201204084739.555327-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>

There are some use cases where only raw events from particular CPUs
should be iterated. An additional parameter is added to this API which
allows only trace buffers for specified CPUs to be iterated.

Signed-off-by: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
---
 include/tracefs.h | 2 ++
 tracefs-events.c  | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/include/tracefs.h b/include/tracefs.h
index 3358e33..ce8b09c 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -6,6 +6,7 @@
 #ifndef _TRACE_FS_H
 #define _TRACE_FS_H
 
+#include <sched.h>
 #include "traceevent/event-parse.h"
 
 char *tracefs_get_tracing_file(const char *name);
@@ -44,6 +45,7 @@ char **tracefs_event_systems(const char *tracing_dir);
 char **tracefs_system_events(const char *tracing_dir, const char *system);
 int tracefs_iterate_raw_events(struct tep_handle *tep,
 				struct tracefs_instance *instance,
+				cpu_set_t *cpus, int cpu_size,
 				int (*callback)(struct tep_event *,
 						struct tep_record *,
 						int, void *),
diff --git a/tracefs-events.c b/tracefs-events.c
index ee45988..4431f77 100644
--- a/tracefs-events.c
+++ b/tracefs-events.c
@@ -117,6 +117,9 @@ get_events_in_page(struct tep_handle *tep, void *page,
  *				per CPU trace buffers
  * @tep: a handle to the trace event parser context
  * @instance: ftrace instance, can be NULL for the top instance
+ * @cpus: Iterate only through the buffers of CPUs, set in the mask.
+ *	  If NULL, iterate through all CPUs.
+ * @cpu_size: size of @cpus set
  * @callback: A user function, called for each record from the file
  * @callback_context: A custom context, passed to the user callback function
  *
@@ -127,6 +130,7 @@ get_events_in_page(struct tep_handle *tep, void *page,
  */
 int tracefs_iterate_raw_events(struct tep_handle *tep,
 				struct tracefs_instance *instance,
+				cpu_set_t *cpus, int cpu_size,
 				int (*callback)(struct tep_event *,
 						struct tep_record *,
 						int, void *),
@@ -167,6 +171,8 @@ int tracefs_iterate_raw_events(struct tep_handle *tep,
 		if (strlen(name) < 4 || strncmp(name, "cpu", 3) != 0)
 			continue;
 		cpu = atoi(name + 3);
+		if (cpus && !CPU_ISSET_S(cpu, cpu_size, cpus))
+			continue;
 		sprintf(file, "%s/%s", path, name);
 		ret = stat(file, &st);
 		if (ret < 0 || !S_ISDIR(st.st_mode))
-- 
2.28.0


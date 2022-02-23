Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38C39C433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Feb 2022 00:30:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234981AbiBWAaq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 19:30:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236186AbiBWAao (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 19:30:44 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA9555BEF
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 16:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9E8EACE1992
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Feb 2022 00:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A79C340F5;
        Wed, 23 Feb 2022 00:30:14 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nMfXp-005bGV-HS;
        Tue, 22 Feb 2022 19:30:13 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 07/11] libtracefs: Add documentation for tracefs_iterate_stop()
Date:   Tue, 22 Feb 2022 19:30:08 -0500
Message-Id: <20220223003012.1334741-8-rostedt@goodmis.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223003012.1334741-1-rostedt@goodmis.org>
References: <20220223003012.1334741-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The function tracefs_iterate_stop() is missing from the man pages.

Add it.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-events.txt | 9 +++++++--
 Documentation/libtracefs.txt        | 1 +
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/Documentation/libtracefs-events.txt b/Documentation/libtracefs-events.txt
index 3c2b95dcc762..f998c79b04ec 100644
--- a/Documentation/libtracefs-events.txt
+++ b/Documentation/libtracefs-events.txt
@@ -3,8 +3,8 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_event_systems, tracefs_system_events, tracefs_event_enable,
-tracefs_event_disable,  tracefs_iterate_raw_events - Work with trace systems and events.
+tracefs_event_systems, tracefs_system_events, tracefs_event_enable, tracefs_event_disable,
+tracefs_iterate_raw_events, tracefs_iterate_stop - Work with trace systems and events.
 
 SYNOPSIS
 --------
@@ -22,6 +22,7 @@ int *tracefs_iterate_raw_events*(struct tep_handle pass:[*]_tep_, struct tracefs
 				 cpu_set_t pass:[*]_cpus_, int _cpu_size_,
 				 int (pass:[*]_callback_)(struct tep_event pass:[*], struct tep_record pass:[*], int, void pass:[*]),
 				 void pass:[*]_callback_context_);
+void *tracefs_iterate_stop*(struct tracefs_instance pass:[*]_instance_);
 
 --
 
@@ -75,6 +76,10 @@ record is; The record representing the event; The CPU that the event
 occurred on; and a pointer to user specified _callback_context_. If the _callback_
 returns non-zero, the iteration stops.
 
+Use *tracefs_iterate_stop()* to force a executing *tracefs_iterate_raw_events()*
+to halt. This can be called from either a callback that is called by
+the iterator (even though a return of non-zero will stop it), or from another
+thread.
 
 RETURN VALUE
 ------------
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index ad4d5849954d..0e339af60f4f 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -52,6 +52,7 @@ Trace events:
 	int *tracefs_event_disable*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_system_,
                             const char pass:[*]_event_);
 	int *tracefs_iterate_raw_events*(struct tep_handle pass:[*]_tep_, struct tracefs_instance pass:[*]_instance_, cpu_set_t pass:[*]_cpus_, int _cpu_size_, int (pass:[*]_callback_)(struct tep_event pass:[*], struct tep_record pass:[*], int, void pass:[*]), void pass:[*]_callback_context_);
+	void *tracefs_iterate_stop*(struct tracefs_instance pass:[*]_instance_);
 	struct tep_handle pass:[*]*tracefs_local_events*(const char pass:[*]_tracing_dir_);
 	struct tep_handle pass:[*]*tracefs_local_events_system*(const char pass:[*]_tracing_dir_, const char pass:[*] const pass:[*]_sys_names_);
 	int *tracefs_fill_local_events*(const char pass:[*]_tracing_dir_, struct tep_handle pass:[*]_tep_, int pass:[*]_parsing_failures_);
-- 
2.34.1


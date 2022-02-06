Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35A86C433F5
	for <linux-trace-devel@archiver.kernel.org>; Sun,  6 Feb 2022 18:15:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345938AbiBFSPY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 6 Feb 2022 13:15:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345874AbiBFSPW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 6 Feb 2022 13:15:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E31CC06173B
        for <linux-trace-devel@vger.kernel.org>; Sun,  6 Feb 2022 10:15:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B906B6106D
        for <linux-trace-devel@vger.kernel.org>; Sun,  6 Feb 2022 18:15:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05B62C340E9
        for <linux-trace-devel@vger.kernel.org>; Sun,  6 Feb 2022 18:15:19 +0000 (UTC)
Date:   Sun, 6 Feb 2022 13:15:18 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Fix up man pages to display all functions
Message-ID: <20220206131518.17d54368@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

There are several functions in the man pages that are missing from being
accessed in the man pages because, although they are described in a man
page, they are not listed at the top of the man page, which means they do
not get their own man page.

Have all functions described in the man pages get their own reference, so
that people can find them easier. And one man page listed functions that
were described in another man page. Fix that too.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-dynevents.txt | 4 ++--
 Documentation/libtracefs-events.txt    | 4 ++--
 Documentation/libtracefs-filter.txt    | 2 +-
 Documentation/libtracefs-hist-cont.txt | 3 ++-
 Documentation/libtracefs-hist-mod.txt  | 2 +-
 Documentation/libtracefs-hist.txt      | 4 ++--
 6 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/Documentation/libtracefs-dynevents.txt b/Documentation/libtracefs-dynevents.txt
index b8cb8d40bf7a..2c6db4709bb2 100644
--- a/Documentation/libtracefs-dynevents.txt
+++ b/Documentation/libtracefs-dynevents.txt
@@ -4,8 +4,8 @@ libtracefs(3)
 NAME
 ----
 tracefs_dynevent_create, tracefs_dynevent_destroy, tracefs_dynevent_destroy_all,
-tracefs_dynevent_free, tracefs_dynevent_list_free, tracefs_dynevent_get_all, tracefs_dynevent_info,
-tracefs_dynevent_get_event - Create, destroy, free and get dynamic events.
+tracefs_dynevent_free, tracefs_dynevent_list_free, tracefs_dynevent_get, tracefs_dynevent_get_all,
+tracefs_dynevent_info, tracefs_dynevent_get_event - Create, destroy, free and get dynamic events.
 
 SYNOPSIS
 --------
diff --git a/Documentation/libtracefs-events.txt b/Documentation/libtracefs-events.txt
index a3d7a11acf4b..3c2b95dcc762 100644
--- a/Documentation/libtracefs-events.txt
+++ b/Documentation/libtracefs-events.txt
@@ -3,8 +3,8 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_event_systems, tracefs_system_events, tracefs_iterate_raw_events -
-Work with trace systems and events.
+tracefs_event_systems, tracefs_system_events, tracefs_event_enable,
+tracefs_event_disable,  tracefs_iterate_raw_events - Work with trace systems and events.
 
 SYNOPSIS
 --------
diff --git a/Documentation/libtracefs-filter.txt b/Documentation/libtracefs-filter.txt
index 501f093134df..12726b95ac3a 100644
--- a/Documentation/libtracefs-filter.txt
+++ b/Documentation/libtracefs-filter.txt
@@ -3,7 +3,7 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_filter_string_append, tracefs_filter_string_verify, tracefs_event_filter_apply tracefs_event_filter_clear -
+tracefs_filter_string_append, tracefs_filter_string_verify, tracefs_event_filter_apply, tracefs_event_filter_clear -
 Add, verify and apply event filters
 
 SYNOPSIS
diff --git a/Documentation/libtracefs-hist-cont.txt b/Documentation/libtracefs-hist-cont.txt
index 651aa0efe1f7..7159e274f0c9 100644
--- a/Documentation/libtracefs-hist-cont.txt
+++ b/Documentation/libtracefs-hist-cont.txt
@@ -3,7 +3,8 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_hist_pause, tracefs_hist_continue, tracefs_hist_reset - Pause, continue, or clear an existing histogram
+tracefs_hist_start, tracefs_hist_destroy, tracefs_hist_pause,
+tracefs_hist_continue, tracefs_hist_reset - Pause, continue, or clear an existing histogram
 
 SYNOPSIS
 --------
diff --git a/Documentation/libtracefs-hist-mod.txt b/Documentation/libtracefs-hist-mod.txt
index 1f4587b50903..b308c7e5e586 100644
--- a/Documentation/libtracefs-hist-mod.txt
+++ b/Documentation/libtracefs-hist-mod.txt
@@ -4,7 +4,7 @@ libtracefs(3)
 NAME
 ----
 tracefs_hist_add_sort_key, tracefs_hist_set_sort_key, tracefs_hist_sort_key_direction,
-tracefs_hist_append_filter, tracefs_hist_echo_cmd, tracefs_hist_command,
+tracefs_hist_add_name, tracefs_hist_append_filter, tracefs_hist_echo_cmd, tracefs_hist_command,
 tracefs_hist_get_name, tracefs_hist_get_event, tracefs_hist_get_system - Update and describe an event histogram
 
 SYNOPSIS
diff --git a/Documentation/libtracefs-hist.txt b/Documentation/libtracefs-hist.txt
index 858782b70dc2..3ac21cec70a2 100644
--- a/Documentation/libtracefs-hist.txt
+++ b/Documentation/libtracefs-hist.txt
@@ -3,8 +3,8 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_hist_alloc, tracefs_hist_free, tracefs_hist_add_key, tracefs_hist_add_value,
-tracefs_hist_add_name, tracefs_hist_start, tracefs_hist_destroy - Create and destroy event histograms
+tracefs_hist_alloc, tracefs_hist_alloc_2d, tracefs_hist_alloc_nd, tracefs_hist_free,
+tracefs_hist_add_key, tracefs_hist_add_value - Create and destroy event histograms
 
 SYNOPSIS
 --------
-- 
2.34.1


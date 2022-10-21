Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79A18C38A2D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 21 Oct 2022 20:38:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiJUUiw convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 21 Oct 2022 16:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiJUUiw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 21 Oct 2022 16:38:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D12FC29E9AE
        for <linux-trace-devel@vger.kernel.org>; Fri, 21 Oct 2022 13:38:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 869ADB80D4D
        for <linux-trace-devel@vger.kernel.org>; Fri, 21 Oct 2022 20:38:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EED5AC433C1
        for <linux-trace-devel@vger.kernel.org>; Fri, 21 Oct 2022 20:38:47 +0000 (UTC)
Date:   Fri, 21 Oct 2022 16:38:53 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Update documentation for
 tracefs_hist_alloc_nd_cnt()
Message-ID: <20221021163853.6f5ffb2c@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From d3dc041127eca2155169f304235667f18d6266aa Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Date: Wed, 28 Sep 2022 12:09:39 -0400
Subject: [PATCH] libtracefs: Update documentation for
 tracefs_hist_alloc_nd_cnt()

As tracefs_hist_alloc_nd_cnt() was added too, add it to the documentation
man pages, and also update the main libtracefs man page to include both:

  tracefs_hist_add_key_cnt()
  tracefs_hist_alloc_nd_cnt()

Fixes: faa0ba7f ("libtracefs: Add buckets field to tracefs_sql() function")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-hist.txt | 11 ++++++++++-
 Documentation/libtracefs.txt      |  5 +++++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/Documentation/libtracefs-hist.txt b/Documentation/libtracefs-hist.txt
index 1dd5abf1cce7..7503fd0d4aec 100644
--- a/Documentation/libtracefs-hist.txt
+++ b/Documentation/libtracefs-hist.txt
@@ -3,7 +3,7 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_hist_alloc, tracefs_hist_alloc_2d, tracefs_hist_alloc_nd, tracefs_hist_free,
+tracefs_hist_alloc, tracefs_hist_alloc_2d, tracefs_hist_alloc_nd, tracefs_hist_alloc_nd_cnt, tracefs_hist_free,
 tracefs_hist_add_key, tracefs_hist_add_key_cnt, tracefs_hist_add_value - Create and destroy event histograms
 
 SYNOPSIS
@@ -39,6 +39,9 @@ struct tracefs_hist pass:[*]*tracefs_hist_alloc_2d*(struct tracefs_tep pass:[*]
 struct tracefs_hist pass:[*]*tracefs_hist_alloc_nd*(struct tracefs_tep pass:[*] _tep_,
 			const char pass:[*]_system_, const char pass:[*]_event_,
 			struct tracefs_hist_axis pass:[*]_axes_);
+struct tracefs_hist pass:[*]*tracefs_hist_alloc_nd_cnt*(struct tep_handle pass:[*]_tep_,
+			  const char pass:[*]_system_, const char pass:[*]_event_name_,
+			  struct tracefs_hist_axis_cnt pass:[*]_axes_);
 void *tracefs_hist_free*(struct tracefs_hist pass:[*]_hist_);
 
 int *tracefs_hist_add_key*(struct tracefs_hist pass:[*]_hist_, const char pass:[*]_key_,
@@ -80,6 +83,12 @@ _system_ and _event_ that the histogram will be attached to. The _system_ is the
 system or group of the event. The _event_ is the event to attach the histogram to.
 The _axes_ is an array of _key_ / _type_ pairs, defining the dimensions of the histogram.
 
+*tracefs_hist_alloc_nd_cnt*() will initialize a histogram descriptor that will be attached to
+the _system_/_event_. This only initializes the descriptor with the given _axes_ keys as primaries.
+This only initializes the descriptor, it does not start the histogram in the kernel.
+The difference between this and *tracefs_hist_alloc_nd()* is that the _axes_ parameter
+is of type *struct tracefs_hist_axis_cnt* and not *struct tracefs_hist_axis*.
+
 *tracefs_hist_free*() frees the _tracefs_hist_ descriptor. Note, it does not stop
 or disable the running histogram if it was started. *tracefs_hist_destroy*() needs
 to be called to do so.
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index f588ac26f9d4..b81c0301c27a 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -230,9 +230,14 @@ Histograms:
 	struct tracefs_hist pass:[*]*tracefs_hist_alloc_nd*(struct tracefs_tep pass:[*] _tep_,
 				const char pass:[*]_system_, const char pass:[*]_event_,
 				struct tracefs_hist_axis pass:[*]_axes_);
+	struct tracefs_hist pass:[*]*tracefs_hist_alloc_nd_cnt*(struct tep_handle pass:[*]_tep_,
+				  const char pass:[*]_system_, const char pass:[*]_event_name_,
+				  struct tracefs_hist_axis_cnt pass:[*]_axes_);
 	void *tracefs_hist_free*(struct tracefs_hist pass:[*]_hist_);
 	int *tracefs_hist_add_key*(struct tracefs_hist pass:[*]_hist_, const char pass:[*]_key_,
 				 enum tracefs_hist_key_type _type_);
+	int *tracefs_hist_add_key_cnt*(struct tracefs_hist pass:[*]_hist_, const char pass:[*]_key_,
+				 enum tracefs_hist_key_type _type_, int _cnt_);
 	int *tracefs_hist_add_value*(struct tracefs_hist pass:[*]_hist_, const char pass:[*]_value_);
 	int *tracefs_hist_add_sort_key*(struct tracefs_hist pass:[*]_hist_,
 				      const char pass:[*]_sort_key_);
-- 
2.35.1


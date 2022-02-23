Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F0BEC433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Feb 2022 00:30:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236205AbiBWAap (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 19:30:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235397AbiBWAan (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 19:30:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38EDE55BE4
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 16:30:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCA8BB81D91
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Feb 2022 00:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CCD7C340F4;
        Wed, 23 Feb 2022 00:30:14 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nMfXp-005bGR-Gc;
        Tue, 22 Feb 2022 19:30:13 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 06/11] libtracefs: Add documentation for tracefs_list_add/size()
Date:   Tue, 22 Feb 2022 19:30:07 -0500
Message-Id: <20220223003012.1334741-7-rostedt@goodmis.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223003012.1334741-1-rostedt@goodmis.org>
References: <20220223003012.1334741-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The functions tracefs_list_add() and tracefs_list_size() are missing from
the man pages.

Add them.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-utils.txt | 28 ++++++++++++++++++++++++++--
 Documentation/libtracefs.txt       |  2 ++
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/Documentation/libtracefs-utils.txt b/Documentation/libtracefs-utils.txt
index 9478911afbae..ddbd6759bb1b 100644
--- a/Documentation/libtracefs-utils.txt
+++ b/Documentation/libtracefs-utils.txt
@@ -3,8 +3,8 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_tracers, tracefs_get_clock, tracefs_list_free -
-Helper functions for working with trace file system.
+tracefs_tracers, tracefs_get_clock, tracefs_list_free, tracefs_list_add,
+tracefs_list_size - Helper functions for working with trace file system.
 
 SYNOPSIS
 --------
@@ -15,6 +15,8 @@ SYNOPSIS
 char pass:[*]pass:[*]*tracefs_tracers*(const char pass:[*]_tracing_dir_);
 char pass:[*]*tracefs_get_clock*(struct tracefs_instance pass:[*]_instance_);
 void *tracefs_list_free*(char pass:[*]pass:[*]_list_);
+char pass:[**]*tracefs_list_add*(char **_list_, const char *_string_);
+int *tracefs_list_size*(char pass:[**]_list_);
 --
 
 DESCRIPTION
@@ -36,6 +38,18 @@ The *tracefs_list_free()* function frees an array of strings, returned by
 *tracefs_event_systems()*, *tracefs_system_events()* and *tracefs_tracers()*
 APIs.
 
+The *tracefs_list_add()* function adds _string_ to the string _list_. If
+_list_ is NULL, then a new list is created with the first element a copy
+of _string_, and the second element will be a NULL pointer.  If _list_ is
+not NULL, then it is reallocated to include a new element and a NULL terminator,
+and the new allocated array is returned. The list passed in should be ignored,
+as it wil be freed if a new one was allocated.
+
+The *tracefs_list_size()* is a fast way to find out the number of elements
+in a string array that is to be freed with *tracefs_list_free()*. Note, this
+depends on meta data that is created for these lists and will not work on
+normal string arrays like argv.
+
 RETURN VALUE
 ------------
 The *tracefs_tracers()* returns array of strings. The last element in that
@@ -45,6 +59,16 @@ In case of an error, NULL is returned.
 The *tracefs_get_clock()* returns string, that must be freed with free(), or NULL
 in case of an error.
 
+The *tracefs_list_add()* returns an allocated string array that must be freed
+with *tracefs_list_free()* on success or NULL on error. If NULL is returned,
+then the passed in _list_ is untouched. Thus, *tracefs_list_add()* should be
+treated similarly to *realloc*(3).
+
+The *tracefs_list_size()* returns the number of strings in the _list_. The
+passed in list must be one that is to be freed with *tracefs_list_free()*
+as the list has meta data that is used to determine the size and this does
+not work on any normal string array like argv.
+
 EXAMPLE
 -------
 [source,c]
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index 5864a5de61e6..ad4d5849954d 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -72,6 +72,8 @@ Function filters:
 
 Trace helper functions:
 	void *tracefs_list_free*(char pass:[*]pass:[*]_list_);
+	char pass:[**]*tracefs_list_add*(char **_list_, const char *_string_);
+	int *tracefs_list_size*(char pass:[**]_list_);
 	char pass:[*]*tracefs_get_clock*(struct tracefs_instance pass:[*]_instance_);
 	int *tracefs_trace_is_on*(struct tracefs_instance pass:[*]_instance_);
 	int *tracefs_trace_on*(struct tracefs_instance pass:[*]_instance_);
-- 
2.34.1


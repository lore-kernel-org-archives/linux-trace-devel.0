Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3500C43217
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Feb 2022 00:30:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232970AbiBWAan (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 19:30:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234685AbiBWAam (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 19:30:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8431955BEA
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 16:30:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D6B96130A
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Feb 2022 00:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B80FC340F1;
        Wed, 23 Feb 2022 00:30:14 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nMfXp-005bGG-Eu;
        Tue, 22 Feb 2022 19:30:13 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 04/11] libtracefs: Add documentation for tracefs_instances()
Date:   Tue, 22 Feb 2022 19:30:05 -0500
Message-Id: <20220223003012.1334741-5-rostedt@goodmis.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223003012.1334741-1-rostedt@goodmis.org>
References: <20220223003012.1334741-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The function tracefs_instances() is missing from the man pages.

Add it.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-instances-manage.txt | 14 +++++++++++++-
 Documentation/libtracefs.txt                  |  1 +
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/Documentation/libtracefs-instances-manage.txt b/Documentation/libtracefs-instances-manage.txt
index 31e77a39c594..c03a272c18f0 100644
--- a/Documentation/libtracefs-instances-manage.txt
+++ b/Documentation/libtracefs-instances-manage.txt
@@ -4,7 +4,7 @@ libtracefs(3)
 NAME
 ----
 tracefs_instance_create, tracefs_instance_destroy, tracefs_instance_alloc, tracefs_instance_free,
-tracefs_instance_is_new - Manage trace instances.
+tracefs_instance_is_new, tracefs_instances - Manage trace instances.
 
 SYNOPSIS
 --------
@@ -17,6 +17,7 @@ int *tracefs_instance_destroy*(struct tracefs_instance pass:[*]_instance_);
 struct tracefs_instance pass:[*]*tracefs_instance_alloc*(const char pass:[*]_tracing_dir_, const char pass:[*]_name_);
 void *tracefs_instance_free*(struct tracefs_instance pass:[*]_instance_);
 bool *tracefs_instance_is_new*(struct tracefs_instance pass:[*]_instance_);
+char pass:[**]*tracefs_instances*(const char pass:[*]_regex_);
 
 --
 
@@ -53,6 +54,12 @@ The *tracefs_instance_is_new()* function checks if the given _instance_ is
 newly created by *tracefs_instance_create()*, or it has been in the system
 before that.
 
+The *tracefs_instances*() function returns a list of instances that exist in
+the system that match the regular expression _regex_. If _regex_ is NULL, then
+it will match all instances that exist. The returned list must be freed with
+*tracefs_list_free*(3). Note, if no instances are found an empty list is returned
+and that too needs to be free with *tracefs_list_free*(3).
+
 RETURN VALUE
 ------------
 The *tracefs_instance_create()* and *tracefs_instance_alloc()* functions return a pointer to
@@ -68,6 +75,11 @@ trace instance in the system, or false if the trace instance already
 existed in the system when _instance_ was allocated by
 *tracefs_instance_create()* or *tracefs_instance_alloc()*.
 
+The *tracefs_instances()* returns a list of instance names that exist on the system.
+The list must be freed with *tracefs_list_free*(3). An empty list is returned if
+no instance exists that matches _regex_, and this needs to be freed with
+*tracefs_list_free*(3) as well. NULL is returned on error.
+
 EXAMPLE
 -------
 [source,c]
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index 12df3ce3b7af..5864a5de61e6 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -21,6 +21,7 @@ Trace instances:
 	int *tracefs_instance_destroy*(struct tracefs_instance pass:[*]_instance_);
 	struct tracefs_instance pass:[*]*tracefs_instance_alloc*(const char pass:[*]_tracing_dir_, const char pass:[*]_name_);
 	void *tracefs_instance_free*(struct tracefs_instance pass:[*]_instance_);
+	char pass:[**]*tracefs_instances*(const char pass:[*]_regex_);
 	bool *tracefs_instance_is_new*(struct tracefs_instance pass:[*]_instance_);
 	bool *tracefs_file_exists*(struct tracefs_instance pass:[*]_instance_, char pass:[*]_name_);
 	bool *tracefs_dir_exists*(struct tracefs_instance pass:[*]_instance_, char pass:[*]_name_);
-- 
2.34.1


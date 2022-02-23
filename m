Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0C35C4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Feb 2022 00:30:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233002AbiBWAap (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 19:30:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235105AbiBWAam (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 19:30:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 682C855BCF
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 16:30:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA963612FE
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Feb 2022 00:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88160C340F7;
        Wed, 23 Feb 2022 00:30:14 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nMfXp-005bGZ-IJ;
        Tue, 22 Feb 2022 19:30:13 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 08/11] libtracefs: Add documentation for tracefs_option_id()
Date:   Tue, 22 Feb 2022 19:30:09 -0500
Message-Id: <20220223003012.1334741-9-rostedt@goodmis.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223003012.1334741-1-rostedt@goodmis.org>
References: <20220223003012.1334741-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The function tracefs_option_id() is missing from the man pages.

Add it.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-option-get.txt | 11 +++++++++--
 Documentation/libtracefs.txt            |  1 +
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/Documentation/libtracefs-option-get.txt b/Documentation/libtracefs-option-get.txt
index dce5afab4894..8a688a7dd8f2 100644
--- a/Documentation/libtracefs-option-get.txt
+++ b/Documentation/libtracefs-option-get.txt
@@ -3,8 +3,8 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_options_get_supported, tracefs_option_is_supported,
-tracefs_options_get_enabled, tracefs_option_is_enabled, tracefs_option_mask_is_set
+tracefs_options_get_supported, tracefs_option_is_supported, tracefs_options_get_enabled,
+tracefs_option_is_enabled, tracefs_option_mask_is_set, tracefs_option_id
 - Get and check ftrace options.
 
 SYNOPSIS
@@ -18,6 +18,7 @@ bool *tracefs_option_is_supported*(struct tracefs_instance pass:[*]_instance_, e
 const struct tracefs_options_mask pass:[*]*tracefs_options_get_enabled*(struct tracefs_instance pass:[*]_instance_);
 bool *tracefs_option_is_enabled*(struct tracefs_instance pass:[*]_instance_, enum tracefs_option_id _id_);
 bool *tracefs_option_mask_is_set*(const struct tracefs_options_mask *options, enum tracefs_option_id id);
+enum tracefs_option_id *tracefs_option_id*(const char pass:[*]_name_);
 --
 
 DESCRIPTION
@@ -43,6 +44,9 @@ given _instance_. If _instance_ is NULL, the top trace instance is used.
 The *tracefs_option_mask_is_set()* function checks if the bit, corresponding to the option with _id_ is
 set in the _options_ bitmask returned from *tracefs_option_get_enabled()* and *tracefs_option_is_supported()*.
 
+The *tracefs_option_id()* converts an option _name_ into its corresponding id, if it is found.
+This allows to find the option _id_ to use in the other functions if only the _name_ is known.
+
 RETURN VALUE
 ------------
 The *tracefs_options_get_supported()* and *tracefs_options_get_enabled()* functions, on success,
@@ -56,6 +60,9 @@ option in supported / enabled, or false otherwise.
 The *tracefs_option_mask_is_set()* returns true if the corresponding option is set in the mask
 or false otherwise.
 
+The *tracefs_option_id()* returns the corresponding id defined by *tracefs_options*(3) from
+the given _name_. If the _name_ can not be found, then TRACEFS_OPTION_INVALID is returned.
+
 EXAMPLE
 -------
 [source,c]
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index 0e339af60f4f..44629e32d202 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -97,6 +97,7 @@ Trace options:
 	int *tracefs_option_enable*(struct tracefs_instance pass:[*]_instance_, enum tracefs_option_id _id_);
 	int *tracefs_option_disable*(struct tracefs_instance pass:[*]_instance_, enum tracefs_option_id _id_);
 	const char pass:[*]*tracefs_option_name*(enum tracefs_option_id _id_);
+	enum tracefs_option_id *tracefs_option_id*(const char pass:[*]_name_);
 
 Ftrace tracers:
 	char pass:[*]pass:[*]*tracefs_tracers*(const char pass:[*]_tracing_dir_);
-- 
2.34.1


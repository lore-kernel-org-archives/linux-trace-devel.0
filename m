Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCBB7C433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 15:56:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6002610D1
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 15:56:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233038AbhDIP4R (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Apr 2021 11:56:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:46772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233019AbhDIP4Q (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Apr 2021 11:56:16 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 854C161042;
        Fri,  9 Apr 2021 15:56:03 +0000 (UTC)
Date:   Fri, 9 Apr 2021 11:56:02 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH] libtracefs: Remove tracefs_option_set/clear() from man page
Message-ID: <20210409115602.3b74bf66@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Since the functions tracefs_option_set() and tracefs_option_clear() is no
longer part of the API, remove it from the man page.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-option-bits.txt | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/Documentation/libtracefs-option-bits.txt b/Documentation/libtracefs-option-bits.txt
index d713a5e..132bc13 100644
--- a/Documentation/libtracefs-option-bits.txt
+++ b/Documentation/libtracefs-option-bits.txt
@@ -3,8 +3,7 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_option_set, tracefs_option_clear, tracefs_option_is_set -
-Set, clear, check option in a bitmask.
+tracefs_option_is_set - Check if an option is set.
 
 SYNOPSIS
 --------
@@ -12,20 +11,11 @@ SYNOPSIS
 --
 *#include <tracefs.h>*
 
-void *tracefs_option_set*(struct tracefs_options_mask pass:[*]_options_, enum tracefs_option_id _id_);
-void *tracefs_option_clear*(struct tracefs_options_mask pass:[*]_options_, enum tracefs_option_id _id_);
 bool *tracefs_option_is_set*(struct tracefs_options_mask _options_, enum tracefs_option_id _id_);
 --
 
 DESCRIPTION
 -----------
-This set of APIs can be used to manipulate a bitmask with option IDs.
-
-The _tracefs_option_set()_ function sets the bit, corresponding to the option with _id_ in the
-_options_ bitmask.
-
-The _tracefs_option_clear()_ function clears the bit, corresponding to the option with _id_ in the
-_options_ bitmask.
 
 The _tracefs_option_is_set()_ function checks if the bit, corresponding to the option with _id_ is
 set in the _options_ bitmask.
@@ -43,10 +33,8 @@ EXAMPLE
 struct tracefs_options_mask options;
 memset(&options, 0, sizeof(options));
 ...
-tracefs_option_set(&options, TRACEFS_OPTION_EVENT_FORK | TRACEFS_OPTION_FUNCTION_FORK);
-...
 if (tracefs_option_is_set(options, TRACEFS_OPTION_EVENT_FORK))
-	tracefs_option_clear(&options, TRACEFS_OPTION_EVENT_FORK);
+	enable_fork_code();
 ...
 --
 FILES
-- 
2.29.2


Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB0C9C43461
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 18:49:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70B326113A
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 18:49:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234375AbhDIStt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Apr 2021 14:49:49 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:50160 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234313AbhDIStt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Apr 2021 14:49:49 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 9 Apr 2021 11:49:31 -0700
Received: from vypre.com (unknown [10.21.244.131])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 3B8EE2107D;
        Fri,  9 Apr 2021 11:49:35 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     Yordan Karadzhov <y.karadz@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v2 2/2] libtracefs: Document tracefs_option_mask_is_set() with the other option functions
Date:   Fri, 9 Apr 2021 14:49:30 -0400
Message-ID: <20210409184930.2241303-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210409184930.2241303-1-rostedt@goodmis.org>
References: <20210409184930.2241303-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-002.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

As tracefs_option_is_set() was renamed to tracefs_option_mask_is_set() and
is tightly coupled with the tracefs_option_get_*() functions, remove its
man page and document it along with the other tracefs_option_*()
functions.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-option-bits.txt | 90 ------------------------
 Documentation/libtracefs-option-get.txt  | 13 +++-
 2 files changed, 12 insertions(+), 91 deletions(-)
 delete mode 100644 Documentation/libtracefs-option-bits.txt

diff --git a/Documentation/libtracefs-option-bits.txt b/Documentation/libtracefs-option-bits.txt
deleted file mode 100644
index 10e832e..0000000
--- a/Documentation/libtracefs-option-bits.txt
+++ /dev/null
@@ -1,90 +0,0 @@
-libtracefs(3)
-=============
-
-NAME
-----
-tracefs_option_set, tracefs_option_clear, tracefs_option_mask_is_set -
-Set, clear, check option in a bitmask.
-
-SYNOPSIS
---------
-[verse]
---
-*#include <tracefs.h>*
-
-void *tracefs_option_set*(struct tracefs_options_mask pass:[*]_options_, enum tracefs_option_id _id_);
-void *tracefs_option_clear*(struct tracefs_options_mask pass:[*]_options_, enum tracefs_option_id _id_);
-bool *tracefs_option_mask_is_set*(struct tracefs_options_mask _options_, enum tracefs_option_id _id_);
---
-
-DESCRIPTION
------------
-This set of APIs can be used to manipulate a bitmask with option IDs.
-
-The _tracefs_option_set()_ function sets the bit, corresponding to the option with _id_ in the
-_options_ bitmask.
-
-The _tracefs_option_clear()_ function clears the bit, corresponding to the option with _id_ in the
-_options_ bitmask.
-
-The _tracefs_option_mask_is_set()_ function checks if the bit, corresponding to the option with _id_ is
-set in the _options_ bitmask.
-
-RETURN VALUE
-------------
-The _tracefs_option_mask_is_set()_ function returns true if the bit is set, false otherwise.
-
-EXAMPLE
--------
-[source,c]
---
-#include <tracefs.h>
-...
-struct tracefs_options_mask options;
-memset(&options, 0, sizeof(options));
-...
-tracefs_option_set(&options, TRACEFS_OPTION_EVENT_FORK | TRACEFS_OPTION_FUNCTION_FORK);
-...
-if (tracefs_option_mask_is_set(options, TRACEFS_OPTION_EVENT_FORK))
-	tracefs_option_clear(&options, TRACEFS_OPTION_EVENT_FORK);
-...
---
-FILES
------
-[verse]
---
-*tracefs.h*
-	Header file to include in order to have access to the library APIs.
-*-ltracefs*
-	Linker switch to add when building a program that uses the library.
---
-
-SEE ALSO
---------
-_libtracefs(3)_,
-_libtraceevent(3)_,
-_trace-cmd(1)_
-
-AUTHOR
-------
-[verse]
---
-*Steven Rostedt* <rostedt@goodmis.org>
-*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>
---
-REPORTING BUGS
---------------
-Report bugs to  <linux-trace-devel@vger.kernel.org>
-
-LICENSE
--------
-libtracefs is Free Software licensed under the GNU LGPL 2.1
-
-RESOURCES
----------
-https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
-
-COPYING
--------
-Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
diff --git a/Documentation/libtracefs-option-get.txt b/Documentation/libtracefs-option-get.txt
index f1c3502..ea5e21b 100644
--- a/Documentation/libtracefs-option-get.txt
+++ b/Documentation/libtracefs-option-get.txt
@@ -4,7 +4,8 @@ libtracefs(3)
 NAME
 ----
 tracefs_options_get_supported, tracefs_option_is_supported,
-tracefs_options_get_enabled, tracefs_option_is_enabled - Get and check ftrace options.
+tracefs_options_get_enabled, tracefs_option_is_enabled, tracefs_option_mask_is_set
+- Get and check ftrace options.
 
 SYNOPSIS
 --------
@@ -16,6 +17,7 @@ const struct tracefs_options_mask pass:[*]*tracefs_options_get_supported*(struct
 bool *tracefs_option_is_supported*(struct tracefs_instance pass:[*]_instance_, enum tracefs_option_id _id_);
 const struct tracefs_options_mask pass:[*]*tracefs_options_get_enabled*(struct tracefs_instance pass:[*]_instance_);
 bool *tracefs_option_is_enabled*(struct tracefs_instance pass:[*]_instance_, enum tracefs_option_id _id_);
+bool *tracefs_option_mask_is_set*(const struct tracefs_options_mask *options, enum tracefs_option_id id);
 --
 
 DESCRIPTION
@@ -38,6 +40,9 @@ the given _instance_. If _instance_ is NULL, enabled options of the top trace in
 The _tracefs_option_is_enabled()_ function checks if the option with given _id_ is enabled in the
 given _instance_. If _instance_ is NULL, the top trace instance is used.
 
+The _tracefs_option_mask_is_set()_ function checks if the bit, corresponding to the option with _id_ is
+set in the _options_ bitmask returned from _tracefs_option_get_enabled()_ and _tracefs_option_is_supported()_.
+
 RETURN VALUE
 ------------
 The _tracefs_options_get_supported()_ and _tracefs_options_get_enabled()_ functions, on success,
@@ -48,6 +53,9 @@ global variable) and must not be freed or modified.
 The _tracefs_option_is_supported()_ and _tracefs_option_is_enabled()_ functions return true if the
 option in supported / enabled, or false otherwise.
 
+The _tracefs_option_mask_is_set()_ returns true if the corresponding option is set in the mask
+or false otherwise.
+
 EXAMPLE
 -------
 [source,c]
@@ -69,6 +77,9 @@ if (!options) {
 } else {
 	...
 }
+if (tracefs_options_mask_is_set(options, TRACEFS_OPTION_LATENCY_FORMAT)) {
+	...
+}
 ...
 
 if (tracefs_option_is_supported(NULL, TRACEFS_OPTION_LATENCY_FORMAT)) {
-- 
2.29.2


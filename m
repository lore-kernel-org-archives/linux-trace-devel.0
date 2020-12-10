Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C4B5C4361B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Dec 2020 19:58:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC9A722571
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Dec 2020 19:58:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404286AbgLJT5x (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Dec 2020 14:57:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:60382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393366AbgLJT5t (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Dec 2020 14:57:49 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3000522E00
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Dec 2020 19:57:09 +0000 (UTC)
Date:   Thu, 10 Dec 2020 14:57:07 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Add missing SPDX headers
Message-ID: <20201210145707.5b34b035@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Some files in the directory were missing the necessary SPDX headers to
describe what license the file is under. These were added.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 features.mk                                   | 1 +
 include/linux/time64.h                        | 2 ++
 lib/trace-cmd/Makefile                        | 2 +-
 lib/trace-cmd/include/private/trace-msg.h     | 1 +
 lib/traceevent/Makefile                       | 2 +-
 lib/traceevent/plugins/Makefile               | 2 ++
 lib/traceevent/plugins/plugin_python_loader.c | 1 +
 lib/tracefs/Makefile                          | 2 +-
 python/Makefile                               | 2 ++
 scripts/utils.mk                              | 1 +
 tracecmd/Makefile                             | 1 +
 tracecmd/include/bug.h                        | 1 +
 tracecmd/trace-usage.c                        | 1 +
 utest/Makefile                                | 1 +
 14 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/features.mk b/features.mk
index 9c9d63c1..53f35fd4 100644
--- a/features.mk
+++ b/features.mk
@@ -1,3 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0
 
 # taken from perf which was based on Linux Kbuild
 # try-cc
diff --git a/include/linux/time64.h b/include/linux/time64.h
index df926548..3961589e 100644
--- a/include/linux/time64.h
+++ b/include/linux/time64.h
@@ -1,3 +1,5 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
 #ifndef _TOOLS_LINUX_TIME64_H
 #define _TOOLS_LINUX_TIME64_H
 
diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index 666a1ebf..a3a1075a 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -1,4 +1,4 @@
-
+# SPDX-License-Identifier: GPL-2.0
 
 include $(src)/scripts/utils.mk
 
diff --git a/lib/trace-cmd/include/private/trace-msg.h
b/lib/trace-cmd/include/private/trace-msg.h index aab8a693..cfcf9615 100644
--- a/lib/trace-cmd/include/private/trace-msg.h
+++ b/lib/trace-cmd/include/private/trace-msg.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
 #ifndef _TRACE_MSG_H_
 #define _TRACE_MSG_H_
 
diff --git a/lib/traceevent/Makefile b/lib/traceevent/Makefile
index c7f7cda0..0f9e5db8 100644
--- a/lib/traceevent/Makefile
+++ b/lib/traceevent/Makefile
@@ -1,4 +1,4 @@
-
+# SPDX-License-Identifier: GPL-2.0
 
 include $(src)/scripts/utils.mk
 
diff --git a/lib/traceevent/plugins/Makefile
b/lib/traceevent/plugins/Makefile index 21e933af..d0afb590 100644
--- a/lib/traceevent/plugins/Makefile
+++ b/lib/traceevent/plugins/Makefile
@@ -1,3 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+
 include $(src)/scripts/utils.mk
 
 bdir:=$(obj)/lib/traceevent/plugins
diff --git a/lib/traceevent/plugins/plugin_python_loader.c
b/lib/traceevent/plugins/plugin_python_loader.c index 01bdfad3..c9a88e4f
100644 --- a/lib/traceevent/plugins/plugin_python_loader.c
+++ b/lib/traceevent/plugins/plugin_python_loader.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: LGPL-2.1
 #include <Python.h>
 #include <stdio.h>
 #include "event-parse.h"
diff --git a/lib/tracefs/Makefile b/lib/tracefs/Makefile
index 89519517..590a0ffe 100644
--- a/lib/tracefs/Makefile
+++ b/lib/tracefs/Makefile
@@ -1,4 +1,4 @@
-
+# SPDX-License-Identifier: LGPL-2.1
 
 include $(src)/scripts/utils.mk
 
diff --git a/python/Makefile b/python/Makefile
index deaa83ee..d2906c4f 100644
--- a/python/Makefile
+++ b/python/Makefile
@@ -1,3 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+
 include $(src)/scripts/utils.mk
 
 ifdef BUILD_PYTHON_WORKS
diff --git a/scripts/utils.mk b/scripts/utils.mk
index ccd4840f..5c47cb42 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -1,3 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0
 
 # Utils
 
diff --git a/tracecmd/Makefile b/tracecmd/Makefile
index de14176e..c02851a8 100644
--- a/tracecmd/Makefile
+++ b/tracecmd/Makefile
@@ -1,3 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0
 
 VERSION := $(TC_VERSION)
 PATCHLEVEL := $(TC_PATCHLEVEL)
diff --git a/tracecmd/include/bug.h b/tracecmd/include/bug.h
index 5d5ef9f0..9222f935 100644
--- a/tracecmd/include/bug.h
+++ b/tracecmd/include/bug.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
 #ifndef __TRACE_CMD_BUG
 #define __TRACE_CMD_BUG
 
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 0a338ed7..1a7abd58 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
diff --git a/utest/Makefile b/utest/Makefile
index 55828abb..2cf99745 100644
--- a/utest/Makefile
+++ b/utest/Makefile
@@ -1,3 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0
 
 include $(src)/scripts/utils.mk
 
-- 
2.25.4


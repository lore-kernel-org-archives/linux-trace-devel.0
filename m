Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AC46C4361B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 18:57:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D350823F29
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 18:57:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394580AbgLKRLW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Dec 2020 12:11:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:44498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392395AbgLKRLA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Dec 2020 12:11:00 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C3F723DE3
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 17:10:14 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1knlvp-000Hcz-3x
        for linux-trace-devel@vger.kernel.org; Fri, 11 Dec 2020 12:10:13 -0500
Message-ID: <20201211171012.973902180@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 11 Dec 2020 12:08:43 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 01/13] trace-cmd: Add missing SPDX headers
References: <20201211170842.611554918@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
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
index 9c9d63c13a23..53f35fd4ed17 100644
--- a/features.mk
+++ b/features.mk
@@ -1,3 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0
 
 # taken from perf which was based on Linux Kbuild
 # try-cc
diff --git a/include/linux/time64.h b/include/linux/time64.h
index df9265483d65..3961589e7d51 100644
--- a/include/linux/time64.h
+++ b/include/linux/time64.h
@@ -1,3 +1,5 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
 #ifndef _TOOLS_LINUX_TIME64_H
 #define _TOOLS_LINUX_TIME64_H
 
diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index 666a1ebf1c19..a3a1075a7ebd 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -1,4 +1,4 @@
-
+# SPDX-License-Identifier: GPL-2.0
 
 include $(src)/scripts/utils.mk
 
diff --git a/lib/trace-cmd/include/private/trace-msg.h b/lib/trace-cmd/include/private/trace-msg.h
index aab8a69381e1..cfcf9615958c 100644
--- a/lib/trace-cmd/include/private/trace-msg.h
+++ b/lib/trace-cmd/include/private/trace-msg.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
 #ifndef _TRACE_MSG_H_
 #define _TRACE_MSG_H_
 
diff --git a/lib/traceevent/Makefile b/lib/traceevent/Makefile
index c7f7cda07c91..0f9e5db8f7df 100644
--- a/lib/traceevent/Makefile
+++ b/lib/traceevent/Makefile
@@ -1,4 +1,4 @@
-
+# SPDX-License-Identifier: GPL-2.0
 
 include $(src)/scripts/utils.mk
 
diff --git a/lib/traceevent/plugins/Makefile b/lib/traceevent/plugins/Makefile
index 21e933affb12..d0afb590675a 100644
--- a/lib/traceevent/plugins/Makefile
+++ b/lib/traceevent/plugins/Makefile
@@ -1,3 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+
 include $(src)/scripts/utils.mk
 
 bdir:=$(obj)/lib/traceevent/plugins
diff --git a/lib/traceevent/plugins/plugin_python_loader.c b/lib/traceevent/plugins/plugin_python_loader.c
index 01bdfad341a3..c9a88e4ff44f 100644
--- a/lib/traceevent/plugins/plugin_python_loader.c
+++ b/lib/traceevent/plugins/plugin_python_loader.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: LGPL-2.1
 #include <Python.h>
 #include <stdio.h>
 #include "event-parse.h"
diff --git a/lib/tracefs/Makefile b/lib/tracefs/Makefile
index 895195172ffe..590a0ffed91a 100644
--- a/lib/tracefs/Makefile
+++ b/lib/tracefs/Makefile
@@ -1,4 +1,4 @@
-
+# SPDX-License-Identifier: LGPL-2.1
 
 include $(src)/scripts/utils.mk
 
diff --git a/python/Makefile b/python/Makefile
index deaa83ee94cc..d2906c4fd1c4 100644
--- a/python/Makefile
+++ b/python/Makefile
@@ -1,3 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+
 include $(src)/scripts/utils.mk
 
 ifdef BUILD_PYTHON_WORKS
diff --git a/scripts/utils.mk b/scripts/utils.mk
index ccd4840f9364..5c47cb420af0 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -1,3 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0
 
 # Utils
 
diff --git a/tracecmd/Makefile b/tracecmd/Makefile
index de14176e2654..c02851a88f3e 100644
--- a/tracecmd/Makefile
+++ b/tracecmd/Makefile
@@ -1,3 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0
 
 VERSION := $(TC_VERSION)
 PATCHLEVEL := $(TC_PATCHLEVEL)
diff --git a/tracecmd/include/bug.h b/tracecmd/include/bug.h
index 5d5ef9f0f570..9222f935c5c0 100644
--- a/tracecmd/include/bug.h
+++ b/tracecmd/include/bug.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
 #ifndef __TRACE_CMD_BUG
 #define __TRACE_CMD_BUG
 
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 0a338ed7d19c..1a7abd5887c1 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
diff --git a/utest/Makefile b/utest/Makefile
index 55828abb59e3..2cf9974591d8 100644
--- a/utest/Makefile
+++ b/utest/Makefile
@@ -1,3 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0
 
 include $(src)/scripts/utils.mk
 
-- 
2.29.2



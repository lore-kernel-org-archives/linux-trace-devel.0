Return-Path: <SRS0=aTL9=JH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:42520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933365AbeFUPrX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Jun 2018 11:47:23 -0400
Message-Id: <20180621154721.908511632@goodmis.org>
Date: Thu, 21 Jun 2018 11:43:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH 1/5] kernelshark: Change the license of trace-filter-hash.[ch] for LPGL
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0001-kernelshark-Change-the-license-of-trace-filter-hash..patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

trace-filter-hash.h was only licensed as GPL because it include
trace-hash-local.h, which included an algorithm that was licensed as GPL.
Now that trace-filter-hash.h has removed that code, it can go to the
originally intended LGPL license.

By doing this, we can then move the trace-filter-hash.o into libtracecmd
which is LGPL.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel-shark/include/trace-filter-hash.h | 15 ++++++++-------
 kernel-shark/trace-filter-hash.c         | 15 ++++++++-------
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/kernel-shark/include/trace-filter-hash.h b/kernel-shark/include/trace-filter-hash.h
index 98c9ab33647a..e5b940750a00 100644
--- a/kernel-shark/include/trace-filter-hash.h
+++ b/kernel-shark/include/trace-filter-hash.h
@@ -1,19 +1,20 @@
 /*
  * Copyright (C) 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
+ * Copyright (C) 2018 VMware Inc, Steven Rostedt <rostedt@goodmis.org>
  *
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; version 2 of the License (not later!)
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Lesser General Public
+ * License as published by the Free Software Foundation;
+ * version 2.1 of the License (not later!)
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
+ * GNU Lesser General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not,  see <http://www.gnu.org/licenses>
+ * You should have received a copy of the GNU Lesser General Public
+ * License along with this program; if not,  see <http://www.gnu.org/licenses>
  *
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
diff --git a/kernel-shark/trace-filter-hash.c b/kernel-shark/trace-filter-hash.c
index 703109c50f6d..57029ae91c7b 100644
--- a/kernel-shark/trace-filter-hash.c
+++ b/kernel-shark/trace-filter-hash.c
@@ -1,19 +1,20 @@
 /*
  * Copyright (C) 2009, Steven Rostedt <srostedt@redhat.com>
+ * Copyright (C) 2018 VMware Inc, Steven Rostedt <rostedt@goodmis.org>
  *
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; version 2 of the License (not later!)
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Lesser General Public
+ * License as published by the Free Software Foundation;
+ * version 2.1 of the License (not later!)
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
+ * GNU Lesser General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not,  see <http://www.gnu.org/licenses>
+ * You should have received a copy of the GNU Lesser General Public
+ * License along with this program; if not,  see <http://www.gnu.org/licenses>
  *
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
-- 
2.17.1

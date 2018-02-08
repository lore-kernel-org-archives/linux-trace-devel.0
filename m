Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-wm0-f67.google.com ([74.125.82.67]:37838 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751075AbeBHJSU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Feb 2018 04:18:20 -0500
From: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        y.karadz@gmail.com,
        "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Subject: [PATCH] trace-cmd: Make the build messages to show only file names
Date: Thu,  8 Feb 2018 11:18:20 +0200
Message-Id: <20180208091820.4920-1-vladislav.valtchev@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Currently, the typical trace-cmd build messages like "COMPILE <file>" and
"BUILD STATIC LIB <file>" show file's full path, instead of just the file
name, as it used to happen before the full support for out-of-tree builds.
This simple patch makes the build messages to look exactly like in the past
by stripping the directory part of each file path, before printing the
message.

Signed-off-by: Vladislav Valtchev (VMware) <vladislav.valtchev@gmail.com>
---
 scripts/utils.mk | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/scripts/utils.mk b/scripts/utils.mk
index 06e8dc3..ad31f6e 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -3,14 +3,14 @@
 
 ifeq ($(BUILDGUI), 1)
   GUI		= 'GUI '
-  GOBJ		= $@
   GSPACE	=
 else
   GUI		=
   GSPACE	= "    "
-  GOBJ		= $(GSPACE)$@
 endif
 
+ GOBJ		= $(GSPACE)$(notdir $(strip $@))
+
 
 ifeq ($(VERBOSE),1)
   Q =
@@ -81,22 +81,22 @@ define make_version.h
 endef
 
 define update_version.h
-	($(call make_version.h, $@.tmp);		\
-	if [ -r $@ ] && cmp -s $@ $@.tmp; then		\
-		rm -f $@.tmp;				\
-	else						\
-		echo '  UPDATE                 $@';	\
-		mv -f $@.tmp $@;			\
+	($(call make_version.h, $@.tmp);				\
+	if [ -r $@ ] && cmp -s $@ $@.tmp; then				\
+		rm -f $@.tmp;						\
+	else								\
+		echo '  UPDATE                 '$(notdir $(strip $@));	\
+		mv -f $@.tmp $@;					\
 	fi);
 endef
 
 define update_dir
 	(echo $1 > $@.tmp;	\
-	if [ -r $@ ] && cmp -s $@ $@.tmp; then		\
-		rm -f $@.tmp;				\
-	else						\
-		echo '  UPDATE                 $@';	\
-		mv -f $@.tmp $@;			\
+	if [ -r $@ ] && cmp -s $@ $@.tmp; then				\
+		rm -f $@.tmp;						\
+	else								\
+		echo '  UPDATE                 '$(notdir $(strip $@));	\
+		mv -f $@.tmp $@;					\
 	fi);
 endef
 
-- 
2.14.1

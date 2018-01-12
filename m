Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:49920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964988AbeALSJc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Jan 2018 13:09:32 -0500
Message-Id: <20180112180930.593490856@goodmis.org>
Date: Fri, 12 Jan 2018 13:08:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Vladislav Valtchev <vladislav.valtchev@gmail.com>,
        Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH 3/3] trace-cmd TAGS: Fix tags to not parse .pc directory of patch
References: <20180112180847.372748598@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0003-trace-cmd-TAGS-Fix-tags-to-not-parse-.pc-directory-o.patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

When working on some code, I use quilt to develop to save off patchs to push
and pop my current work. quilt will create a .pc directory to store the
original files that are being worked on. Unfortunately, the current code
that creates TAGS will decend into this directory and include it when doing
code searching via emacs or vim. If one is not careful, they can end up
editing the saved quilt original file and not the file they should be
editing.

Add a find_tag_files define that limits the scope of where TAGS will get its
code to examine.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index b7bb3cce1258..e620d578140b 100644
--- a/Makefile
+++ b/Makefile
@@ -537,17 +537,22 @@ show_gui_done:
 
 PHONY += show_gui_make
 
+define find_tag_files
+	find . -name '\.pc' -prune -o -name '*\.[ch]' \
+		! -name '\.#' -print
+endef
+
 tags:	force
 	$(RM) tags
-	find . -name '*.[ch]' | xargs ctags --extra=+f --c-kinds=+px
+	$(call find_tag_files) | xargs ctags --extra=+f --c-kinds=+px
 
 TAGS:	force
 	$(RM) TAGS
-	find . -name '*.[ch]' | xargs etags
+	$(call find_tag_files) | xargs etags
 
 cscope: force
 	$(RM) cscope*
-	find . -name '*.[ch]' | cscope -b -q
+	$(call find_tag_files) | cscope -b -q
 
 PLUGINS_INSTALL = $(subst .so,.install,$(PLUGINS)) $(subst .so,.install,$(PYTHON_PLUGINS))
 
-- 
2.13.2

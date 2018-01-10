Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:48204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753299AbeAJGr5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Jan 2018 01:47:57 -0500
Date: Wed, 10 Jan 2018 01:47:54 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org,
        Vladislav Valtchev <vladislav.valtchev@gmail.com>
Subject: [PATCH] trace-cmd TAGS: Fix tags to not parse .pc directory of
 patch
Message-ID: <20180110014754.61598eaa@vmware.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>


[ Vlad, this patch does touch the Makefile. How will it affect you? ]

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
index 5871fd5..c78db04 100644
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
2.15.1

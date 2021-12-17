Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F1F0C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Dec 2021 05:50:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbhLQFuv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Dec 2021 00:50:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233093AbhLQFut (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Dec 2021 00:50:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F688C06173E
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Dec 2021 21:50:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CDEA2B8273C
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Dec 2021 05:50:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9403BC36AEE;
        Fri, 17 Dec 2021 05:50:44 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1my68h-00056b-Bu;
        Fri, 17 Dec 2021 00:50:43 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v2 02/15] libtracefs: Have make tags and TAGS honor O= build directory
Date:   Fri, 17 Dec 2021 00:50:28 -0500
Message-Id: <20211217055041.19559-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211217055041.19559-1-rostedt@goodmis.org>
References: <20211217055041.19559-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Currently if one does a "make O=/tmp/build tags" the tags are still built
in the source directory. Although this is uncommon to do, the tags (and
TAGS) target should still honor the build directory.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/Makefile b/Makefile
index 85b3c39a867c..4910ebe140b9 100644
--- a/Makefile
+++ b/Makefile
@@ -207,7 +207,7 @@ endif
 		$(src)/$(UTEST_DIR)/$(UTEST_BINARY)
 
 define find_tag_files
-	find . -name '\.pc' -prune -o -name '*\.[ch]' -print -o -name '*\.[ch]pp' \
+	find $(src) -name '\.pc' -prune -o -name '*\.[ch]' -print -o -name '*\.[ch]pp' \
 		! -name '\.#' -print
 endef
 
@@ -230,18 +230,26 @@ $(BUILD_PREFIX): force
 $(PKG_CONFIG_FILE) : ${PKG_CONFIG_SOURCE_FILE}.template $(BUILD_PREFIX) $(VERSION_FILE)
 	$(Q) $(call do_make_pkgconfig_file,$(prefix))
 
-tags:	force
-	$(RM) tags
-	$(call find_tag_files) | xargs ctags --extra=+f --c-kinds=+px
+VIM_TAGS = $(obj)/tags
+EMACS_TAGS = $(obj)/TAGS
+CSCOPE_TAGS = $(obj)/cscope
 
-TAGS:	force
-	$(RM) TAGS
-	$(call find_tag_files) | xargs etags
+$(VIM_TAGS): force
+	$(RM) $@
+	$(call find_tag_files) | (cd $(obj) && xargs ctags --extra=+f --c-kinds=+px)
 
-cscope: force
-	$(RM) cscope*
+$(EMACS_TAGS): force
+	$(RM) $@
+	$(call find_tag_files) | (cd $(obj) && xargs etags)
+
+$(CSCOPE_TAGS): force
+	$(RM) $(obj)/cscope*
 	$(call find_tag_files) | cscope -b -q
 
+tags: $(VIM_TAGS)
+TAGS: $(EMACS_TAGS)
+cscope: $(CSCOPE_TAGS)
+
 ifeq ("$(DESTDIR)", "")
 # If DESTDIR is not defined, then test if after installing the library
 # and running ldconfig, if the library is visible by ld.so.
-- 
2.33.0


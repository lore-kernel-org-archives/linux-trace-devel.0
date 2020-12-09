Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CCBFC2BBCA
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 04:22:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D83602389E
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 04:22:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgLIEWC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Dec 2020 23:22:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:38976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727068AbgLIEWC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Dec 2020 23:22:02 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C628D23B23
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Dec 2020 04:21:21 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kmqye-00030Y-R5
        for linux-trace-devel@vger.kernel.org; Tue, 08 Dec 2020 23:21:20 -0500
Message-ID: <20201209042120.699002789@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 08 Dec 2020 23:19:50 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 4/6] libtraceevent: Have make clean honor the output (O=foo) directory
References: <20201209041946.131377586@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

If "make O=/some/dir clean" is performed, the O=/some/dir is not honored,
and the clean is performed on the current directory. If O= is specified on
the command line, then the clean should perform the cleaning to that
directory.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile         | 4 ++--
 plugins/Makefile | 5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index 3f96c1c7b4d6..330c8339f023 100644
--- a/Makefile
+++ b/Makefile
@@ -255,8 +255,8 @@ install: install_lib
 
 clean: clean_plugins
 	$(call QUIET_CLEAN, libtraceevent) \
-		$(RM) *.o *~ $(TARGETS) *.a *.so $(VERSION_FILES) .*.d .*.cmd; \
-		$(RM) TRACEEVENT-CFLAGS tags TAGS; \
+		$(RM) $(OUTPUT)*.o $(OUTPUT)*~ $(TARGETS) $(OUTPUT)*.a $(OUTPUT)*.so $(VERSION_FILES) $(OUTPUT).*.d $(OUTPUT).*.cmd; \
+		$(RM) TRACEEVENT-CFLAGS $(OUTPUT)tags $(OUTPUT)TAGS; \
 		$(RM) $(PKG_CONFIG_FILE)
 
 PHONY += doc
diff --git a/plugins/Makefile b/plugins/Makefile
index 8ae3882f9051..a8868d01b09b 100644
--- a/plugins/Makefile
+++ b/plugins/Makefile
@@ -210,8 +210,9 @@ install: $(PLUGINS)
 
 clean:
 	$(call QUIET_CLEAN, trace_plugins) \
-		$(RM) *.o *~ $(TARGETS) *.a *.so $(VERSION_FILES) .*.d .*.cmd; \
-		$(RM) $(OUTPUT)libtraceevent-dynamic-list \
+		$(RM) $(OUTPUT)*.o $(OUTPUT)*~ $(TARGETS) $(OUTPUT)*.a $(OUTPUT)*.so $(VERSION_FILES) .*.d .*.cmd; \
+		$(RM) $(OUTPUT)libtraceevent-dynamic-list; \
+		$(RM) $(PLUGINS); \
 		$(RM) TRACEEVENT-CFLAGS tags TAGS;
 
 PHONY += force plugins
-- 
2.29.2



Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E53BC433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 19:30:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AF4B610E6
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 19:30:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbhDHTaW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Apr 2021 15:30:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:50158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231420AbhDHTaW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Apr 2021 15:30:22 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59F3D61008
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Apr 2021 19:30:10 +0000 (UTC)
Date:   Thu, 8 Apr 2021 15:30:08 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtraceevent: Fix dependencies in Documentation Makefile
Message-ID: <20210408153008.39fb3b91@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Modify the Documentation Makefile to only rebuild the man pages when their
source has been modified.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/Makefile | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/Documentation/Makefile b/Documentation/Makefile
index 21bcd5e..ede2930 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -11,7 +11,7 @@ MAN3_TXT= \
 MAN_TXT = $(MAN3_TXT)
 _MAN_XML=$(patsubst %.txt,%.xml,$(MAN_TXT))
 _MAN_HTML=$(patsubst %.txt,%.html,$(MAN_TXT))
-_DOC_MAN3=$(patsubst %.txt,%.3,$(MAN3_TXT))
+_DOC_MAN3=$(patsubst %.txt,%.m,$(MAN3_TXT))
 
 MAN_XML=$(addprefix $(OUTPUT),$(_MAN_XML))
 MAN_HTML=$(addprefix $(OUTPUT),$(_MAN_HTML))
@@ -154,17 +154,22 @@ ifdef missing_tools
 	$(error "You need to install $(missing_tools) for man pages")
 endif
 
-do-install-man: man
+install-%.3: $(OUTPUT)%.3
 	$(call QUIET_INSTALL, Documentation-man) \
 		$(INSTALL) -d -m 755 $(DESTDIR)$(man3dir); \
-		$(INSTALL) -m 644 $(OUTPUT)*.3 $(DESTDIR)$(man3dir);
+		$(INSTALL) -m 644 $< $(DESTDIR)$(man3dir);
 
-install-man: check-man-tools man do-install-man
+do-install-man: man $(addprefix install-,$(wildcard $(OUTPUT)*.3))
 
-do-install-html: html
+install-man: check-man-tools man
+	$(Q)$(MAKE) -C . do-install-man
+
+install-%.txt: $(OUTPUT)%.html
 	$(call QUIET_INSTALL, Documentation-html) \
 		$(INSTALL) -d -m 755 $(DESTDIR)$(htmldir); \
-		$(INSTALL) -m 644 $(OUTPUT)*.html $(DESTDIR)$(htmldir);
+		$(INSTALL) -m 644 $< $(DESTDIR)$(htmldir);
+
+do-install-html: html $(addprefix install-,$(wildcard *.txt))
 
 install-html: check-man-tools html do-install-html
 
@@ -187,7 +192,7 @@ endif
 CLEAN_FILES =					\
 	$(MAN_XML) $(addsuffix +,$(MAN_XML))	\
 	$(MAN_HTML) $(addsuffix +,$(MAN_HTML))	\
-	$(DOC_MAN3) *.3
+	$(DOC_MAN3) *.3 *.m
 
 clean:
 	$(call QUIET_CLEAN, Documentation) $(RM) $(CLEAN_FILES)
@@ -200,9 +205,10 @@ $(OUTPUT)%.3 : $(OUTPUT)%.txt
 	mv $@+ $@
 endif
 
-$(OUTPUT)%.3 : $(OUTPUT)%.xml
+$(OUTPUT)%.m : $(OUTPUT)%.xml
 	$(QUIET_XMLTO)$(RM) $@ && \
-	$(XMLTO) -o $(OUTPUT). -m $(MANPAGE_XSL) $(XMLTO_EXTRA) man $<
+	$(XMLTO) -o $(OUTPUT). -m $(MANPAGE_XSL) $(XMLTO_EXTRA) man $<; \
+	touch $@
 
 $(OUTPUT)%.xml : %.txt
 	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
-- 
2.29.2


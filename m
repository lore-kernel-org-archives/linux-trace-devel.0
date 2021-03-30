Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 591D8C433DB
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 00:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09EAC61987
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 00:31:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbhC3AbL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 29 Mar 2021 20:31:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:53656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229971AbhC3Aat (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 29 Mar 2021 20:30:49 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1528A61987
        for <linux-trace-devel@vger.kernel.org>; Tue, 30 Mar 2021 00:30:49 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1lR2HQ-003TM1-04
        for linux-trace-devel@vger.kernel.org; Mon, 29 Mar 2021 20:30:48 -0400
Message-ID: <20210330003047.886878895@goodmis.org>
User-Agent: quilt/0.66
Date:   Mon, 29 Mar 2021 20:30:27 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/2] libtracefs: Fix dependencies in Documentation Makefile
References: <20210330003026.434340915@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index badd80e03b65..efe7b09d4e68 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -13,7 +13,7 @@ MAN3_TXT= \
 MAN_TXT = $(MAN3_TXT)
 _MAN_XML=$(patsubst %.txt,%.xml,$(MAN_TXT))
 _MAN_HTML=$(patsubst %.txt,%.html,$(MAN_TXT))
-_DOC_MAN3=$(patsubst %.txt,%.3,$(MAN3_TXT))
+_DOC_MAN3=$(patsubst %.txt,%.m,$(MAN3_TXT))
 
 MAN_XML=$(addprefix $(OUTPUT),$(_MAN_XML))
 MAN_HTML=$(addprefix $(OUTPUT),$(_MAN_HTML))
@@ -145,13 +145,18 @@ ifdef missing_tools
 	$(error "You need to install $(missing_tools) for man pages")
 endif
 
-do-install-man: man
-	$(Q)$(call do_install,$(OUTPUT)*.3,$(man3dir),644);
+install-%.3: $(OUTPUT)%.3
+	$(Q)$(call do_install,$<,$(man3dir),644);
 
-install-man: man do-install-man
+do-install-man: man $(addprefix install-,$(wildcard $(OUTPUT)*.3))
 
-do-install-html: html
-	$(Q)$(call do_install,$(OUTPUT)*.html,$(htmldir),644);
+install-man: man
+	$(Q)$(MAKE) -C . do-install-man
+
+install-%.txt: $(OUTPUT)%.html
+	$(Q)$(call do_install,$<,$(htmldir),644);
+
+do-install-html: html $(addprefix install-,$(wildcard *.txt))
 
 install-html: html do-install-html
 
@@ -172,7 +177,7 @@ endif
 CLEAN_FILES =					\
 	$(MAN_XML) $(addsuffix +,$(MAN_XML))	\
 	$(MAN_HTML) $(addsuffix +,$(MAN_HTML))	\
-	$(DOC_MAN3) *.3
+	$(DOC_MAN3) *.3 *.m
 
 clean:
 	$(Q) $(RM) $(CLEAN_FILES)
@@ -185,9 +190,10 @@ $(OUTPUT)%.3 : $(OUTPUT)%.txt
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
2.30.1



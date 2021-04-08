Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06C89C43462
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 21:42:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFD5F610E6
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 21:42:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232544AbhDHVmQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Apr 2021 17:42:16 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:11122 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232426AbhDHVmQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Apr 2021 17:42:16 -0400
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Thu, 8 Apr 2021 14:42:01 -0700
Received: from vypre.com (unknown [10.21.244.31])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id 973DA212DB;
        Thu,  8 Apr 2021 14:42:04 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v3 2/5] libtraceevent: Fix dependencies in Documentation Makefile
Date:   Thu, 8 Apr 2021 17:41:57 -0400
Message-ID: <20210408214200.2063946-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210408214200.2063946-1-rostedt@goodmis.org>
References: <20210408214200.2063946-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-001.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Modify the Documentation Makefile to only rebuild the man pages when their
source has been modified.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/Makefile | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/Documentation/Makefile b/Documentation/Makefile
index 21bcd5e..73dbe2a 100644
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
-	$(call QUIET_INSTALL, Documentation-man) \
+install-%.3: $(OUTPUT)%.3
+	$(call QUIET_INSTALL, $<) \
 		$(INSTALL) -d -m 755 $(DESTDIR)$(man3dir); \
-		$(INSTALL) -m 644 $(OUTPUT)*.3 $(DESTDIR)$(man3dir);
+		$(INSTALL) -m 644 $< $(DESTDIR)$(man3dir);
 
-install-man: check-man-tools man do-install-man
+do-install-man: man $(addprefix install-,$(wildcard $(OUTPUT)*.3))
 
-do-install-html: html
-	$(call QUIET_INSTALL, Documentation-html) \
+install-man: check-man-tools man
+	$(Q)$(MAKE) -C . do-install-man
+
+install-%.txt: $(OUTPUT)%.html
+	$(call QUIET_INSTALL, $<) \
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


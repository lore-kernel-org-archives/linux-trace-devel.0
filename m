Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A279C433ED
	for <linux-trace-devel@archiver.kernel.org>; Sat, 10 Apr 2021 03:37:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03EB1610C7
	for <linux-trace-devel@archiver.kernel.org>; Sat, 10 Apr 2021 03:37:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbhDJDiH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Apr 2021 23:38:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:57094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229665AbhDJDiG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Apr 2021 23:38:06 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C30C8610C7
        for <linux-trace-devel@vger.kernel.org>; Sat, 10 Apr 2021 03:37:52 +0000 (UTC)
Date:   Fri, 9 Apr 2021 23:37:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd libtracecmd: Fix the man page building and
 installing
Message-ID: <20210409233750.3778b5d4@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

When trying to do a make install_doc, the make hung due to the hacky way
of searching for the docbook.xsl on the system. As libtracecmd (and
libtracefs and libtraceevent) have a better way of creating and installing
the documentation, update the trace-cmd documentation to do the same. In
the mean time, also consolidate some of the build of the libtracecmd with
trace-cmd man pages.

Also fixed some leftover references to libtracefs.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/Makefile                        |  92 +++++++++++-
 Documentation/{libtracecmd => }/asciidoc.conf |   0
 Documentation/libtracecmd/Makefile            |  92 +-----------
 .../{libtracecmd => }/manpage-1.72.xsl        |   0
 .../{libtracecmd => }/manpage-base.xsl        |   0
 .../manpage-bold-literal.xsl                  |   0
 .../{libtracecmd => }/manpage-normal.xsl      |   0
 .../{libtracecmd => }/manpage-suppress-sp.xsl |   0
 Documentation/trace-cmd/Makefile              | 142 ++++++++++++++----
 scripts/utils.mk                              |  22 +--
 10 files changed, 215 insertions(+), 133 deletions(-)
 rename Documentation/{libtracecmd => }/asciidoc.conf (100%)
 rename Documentation/{libtracecmd => }/manpage-1.72.xsl (100%)
 rename Documentation/{libtracecmd => }/manpage-base.xsl (100%)
 rename Documentation/{libtracecmd => }/manpage-bold-literal.xsl (100%)
 rename Documentation/{libtracecmd => }/manpage-normal.xsl (100%)
 rename Documentation/{libtracecmd => }/manpage-suppress-sp.xsl (100%)

diff --git a/Documentation/Makefile b/Documentation/Makefile
index 8e979ece..ec364916 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -1,21 +1,97 @@
 # SPDX-License-Identifier: GPL-2.0
 
-# Most likely a docbook.xsl is already installed on the users system
-# instead of creating a new wheel, lets reuse what's already there.
-#
-FIND_MANPAGE_DOCBOOK_XSL :=  $(shell find /usr -name docbook.xsl 2>/dev/null | grep manpages | head -1)
-
-MANPAGE_DOCBOOK_XSL ?= ${FIND_MANPAGE_DOCBOOK_XSL}
-
 doc_dir:=$(src)/Documentation
 
-export MANPAGE_DOCBOOK_XSL doc_dir
+export doc_dir
 
 SUBDIR += trace-cmd
 SUBDIR += libtracecmd
 
 .PHONY: $(SUBDIR)
 
+DOCDIR = $(src)/Documentation
+ASCIIDOC=asciidoc
+ASCIIDOC_CONF	 =  $(DOCDIR)/asciidoc.conf
+ASCIIDOC_EXTRA = --unsafe -f $(ASCIIDOC_CONF)
+ASCIIDOC_HTML = xhtml11
+MANPAGE_XSL = $(DOCDIR)/manpage-normal.xsl
+XMLTO_EXTRA =
+INSTALL?=install
+RM ?= rm -f
+
+ASCIIDOC_INSTALLED := $(shell command -v $(ASCIIDOC) 2> /dev/null)
+ifndef ASCIIDOC_INSTALLED
+	missing_tools += $(ASCIIDOC)
+endif
+
+XMLTO=xmlto
+XMLTO_INSTALLED := $(shell command -v $(XMLTO) 2> /dev/null)
+ifndef XMLTO_INSTALLED
+	missing_tools += $(XMLTO)
+endif
+
+#
+# For asciidoc ...
+#	-7.1.2,	no extra settings are needed.
+#	8.0-,	set ASCIIDOC8.
+#
+
+#
+# For docbook-xsl ...
+#	-1.68.1,	set ASCIIDOC_NO_ROFF? (based on changelog from 1.73.0)
+#	1.69.0,		no extra settings are needed?
+#	1.69.1-1.71.0,	set DOCBOOK_SUPPRESS_SP?
+#	1.71.1,		no extra settings are needed?
+#	1.72.0,		set DOCBOOK_XSL_172.
+#	1.73.0-,	set ASCIIDOC_NO_ROFF
+#
+
+#
+# If you had been using DOCBOOK_XSL_172 in an attempt to get rid
+# of 'the ".ft C" problem' in your generated manpages, and you
+# instead ended up with weird characters around callouts, try
+# using ASCIIDOC_NO_ROFF instead (it works fine with ASCIIDOC8).
+#
+
+ifdef ASCIIDOC8
+ASCIIDOC_EXTRA += -a asciidoc7compatible
+endif
+ifdef DOCBOOK_XSL_172
+ASCIIDOC_EXTRA += -a libtracecmd-asciidoc-no-roff
+MANPAGE_XSL = $(DOCDIR)/manpage-1.72.xsl
+else
+	ifdef ASCIIDOC_NO_ROFF
+	# docbook-xsl after 1.72 needs the regular XSL, but will not
+	# pass-thru raw roff codes from asciidoc.conf, so turn them off.
+	ASCIIDOC_EXTRA += -a libtracecmd-asciidoc-no-roff
+	endif
+endif
+ifdef MAN_BOLD_LITERAL
+XMLTO_EXTRA += -m $(DOCDIR)/manpage-bold-literal.xsl
+endif
+ifdef DOCBOOK_SUPPRESS_SP
+XMLTO_EXTRA += -m $(DOCDIR)/manpage-suppress-sp.xsl
+endif
+
+ifdef USE_ASCIIDOCTOR
+ASCIIDOC = asciidoctor
+ASCIIDOC_EXTRA = -a compat-mode
+ASCIIDOC_EXTRA += -I. -rasciidoctor-extensions
+ASCIIDOC_HTML = xhtml5
+endif
+
+ifneq ($(findstring $(MAKEFLAGS),w),w)
+PRINT_DIR = --no-print-directory
+else # "make -w"
+NO_SUBDIR = :
+endif
+
+export ASCIIDOC ASCIIDOC_CONF ASCIIDOC_EXTRA ASCIIDOC_HTML
+export MANPAGE_XSL
+export XMLTO XMLTO_INSTALLED XMLTO_EXTRA
+export  missing_tools
+export RM
+
 all: $(SUBDIR)
 clean: $(SUBDIR)
 install: $(SUBDIR)
diff --git a/Documentation/libtracecmd/asciidoc.conf b/Documentation/asciidoc.conf
similarity index 100%
rename from Documentation/libtracecmd/asciidoc.conf
rename to Documentation/asciidoc.conf
diff --git a/Documentation/libtracecmd/Makefile b/Documentation/libtracecmd/Makefile
index 840f8851..48334525 100644
--- a/Documentation/libtracecmd/Makefile
+++ b/Documentation/libtracecmd/Makefile
@@ -29,92 +29,8 @@ pdfdir?=$(prefix)/share/doc/libtracecmd-doc
 mandir?=$(prefix)/share/man
 man3dir=$(mandir)/man3
 
-ASCIIDOC=asciidoc
-ASCIIDOC_EXTRA = --unsafe -f asciidoc.conf
-ASCIIDOC_HTML = xhtml11
-MANPAGE_XSL = manpage-normal.xsl
-XMLTO_EXTRA =
-INSTALL?=install
-RM ?= rm -f
-
 ifdef USE_ASCIIDOCTOR
-ASCIIDOC = asciidoctor
-ASCIIDOC_EXTRA = -a compat-mode
-ASCIIDOC_EXTRA += -I. -rasciidoctor-extensions
 ASCIIDOC_EXTRA += -a mansource="libtracecmd" -a manmanual="libtracecmd Manual"
-ASCIIDOC_HTML = xhtml5
-endif
-
-ASCIIDOC_INSTALLED := $(shell command -v $(ASCIIDOC) 2> /dev/null)
-ifndef ASCIIDOC_INSTALLED
-	missing_tools += $(ASCIIDOC)
-endif
-
-XMLTO=xmlto
-XMLTO_INSTALLED := $(shell command -v $(XMLTO) 2> /dev/null)
-ifndef XMLTO_INSTALLED
-	missing_tools += $(XMLTO)
-endif
-
-#
-# For asciidoc ...
-#	-7.1.2,	no extra settings are needed.
-#	8.0-,	set ASCIIDOC8.
-#
-
-#
-# For docbook-xsl ...
-#	-1.68.1,	set ASCIIDOC_NO_ROFF? (based on changelog from 1.73.0)
-#	1.69.0,		no extra settings are needed?
-#	1.69.1-1.71.0,	set DOCBOOK_SUPPRESS_SP?
-#	1.71.1,		no extra settings are needed?
-#	1.72.0,		set DOCBOOK_XSL_172.
-#	1.73.0-,	set ASCIIDOC_NO_ROFF
-#
-
-#
-# If you had been using DOCBOOK_XSL_172 in an attempt to get rid
-# of 'the ".ft C" problem' in your generated manpages, and you
-# instead ended up with weird characters around callouts, try
-# using ASCIIDOC_NO_ROFF instead (it works fine with ASCIIDOC8).
-#
-
-ifdef ASCIIDOC8
-ASCIIDOC_EXTRA += -a asciidoc7compatible
-endif
-ifdef DOCBOOK_XSL_172
-ASCIIDOC_EXTRA += -a libtracecmd-asciidoc-no-roff
-MANPAGE_XSL = manpage-1.72.xsl
-else
-	ifdef ASCIIDOC_NO_ROFF
-	# docbook-xsl after 1.72 needs the regular XSL, but will not
-	# pass-thru raw roff codes from asciidoc.conf, so turn them off.
-	ASCIIDOC_EXTRA += -a libtracecmd-asciidoc-no-roff
-	endif
-endif
-ifdef MAN_BOLD_LITERAL
-XMLTO_EXTRA += -m manpage-bold-literal.xsl
-endif
-ifdef DOCBOOK_SUPPRESS_SP
-XMLTO_EXTRA += -m manpage-suppress-sp.xsl
-endif
-
-ifneq ($(findstring $(MAKEFLAGS),w),w)
-PRINT_DIR = --no-print-directory
-else # "make -w"
-NO_SUBDIR = :
-endif
-
-ifneq ($(findstring $(MAKEFLAGS),s),s)
-ifneq ($(V),1)
-	QUIET_ASCIIDOC	= @echo '  ASCIIDOC '$@;
-	QUIET_XMLTO	= @echo '  XMLTO    '$@;
-	QUIET_SUBDIR0	= +@subdir=
-	QUIET_SUBDIR1	= ;$(NO_SUBDIR) \
-			   echo '  SUBDIR   ' $$subdir; \
-			  $(MAKE) $(PRINT_DIR) -C $$subdir
-	export V
-endif
 endif
 
 all: check-man-tools html man
@@ -124,7 +40,7 @@ man3: $(DOC_MAN3)
 
 html: $(MAN_HTML)
 
-$(MAN_HTML) $(DOC_MAN3): asciidoc.conf
+$(MAN_HTML) $(DOC_MAN3): $(ASCIIDOC_CONF)
 
 install: check-man-tools install-man install-html
 
@@ -174,7 +90,7 @@ ifdef USE_ASCIIDOCTOR
 $(OUTPUT)%.m : $(OUTPUT)%.txt
 	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
 	$(ASCIIDOC) -b manpage -d manpage \
-		$(ASCIIDOC_EXTRA) -alibtracecmd_version=$(TRACEFS_VERSION) -o $@+ $< && \
+		$(ASCIIDOC_EXTRA) -alibtracecmd_version=$(LIBTRACECMD_VERSION) -o $@+ $< && \
 	mv $@+ $@
 endif
 
@@ -186,11 +102,11 @@ $(OUTPUT)%.m : $(OUTPUT)%.xml
 $(OUTPUT)%.xml : %.txt
 	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
 	$(ASCIIDOC) -b docbook -d manpage \
-		$(ASCIIDOC_EXTRA) -alibtracecmd_version=$(TRACEFS_VERSION) -o $@+ $< && \
+		$(ASCIIDOC_EXTRA) -alibtracecmd_version=$(LIBTRACECMD_VERSION) -o $@+ $< && \
 	mv $@+ $@
 
 $(MAN_HTML): $(OUTPUT)%.html : %.txt
 	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
 	$(ASCIIDOC) -b $(ASCIIDOC_HTML) -d manpage \
-		$(ASCIIDOC_EXTRA) -alibtracecmd_version=$(TRACEFS_VERSION) -o $@+ $< && \
+		$(ASCIIDOC_EXTRA) -alibtracecmd_version=$(LIBTRACECMD_VERSION) -o $@+ $< && \
 	mv $@+ $@
diff --git a/Documentation/libtracecmd/manpage-1.72.xsl b/Documentation/manpage-1.72.xsl
similarity index 100%
rename from Documentation/libtracecmd/manpage-1.72.xsl
rename to Documentation/manpage-1.72.xsl
diff --git a/Documentation/libtracecmd/manpage-base.xsl b/Documentation/manpage-base.xsl
similarity index 100%
rename from Documentation/libtracecmd/manpage-base.xsl
rename to Documentation/manpage-base.xsl
diff --git a/Documentation/libtracecmd/manpage-bold-literal.xsl b/Documentation/manpage-bold-literal.xsl
similarity index 100%
rename from Documentation/libtracecmd/manpage-bold-literal.xsl
rename to Documentation/manpage-bold-literal.xsl
diff --git a/Documentation/libtracecmd/manpage-normal.xsl b/Documentation/manpage-normal.xsl
similarity index 100%
rename from Documentation/libtracecmd/manpage-normal.xsl
rename to Documentation/manpage-normal.xsl
diff --git a/Documentation/libtracecmd/manpage-suppress-sp.xsl b/Documentation/manpage-suppress-sp.xsl
similarity index 100%
rename from Documentation/libtracecmd/manpage-suppress-sp.xsl
rename to Documentation/manpage-suppress-sp.xsl
diff --git a/Documentation/trace-cmd/Makefile b/Documentation/trace-cmd/Makefile
index 3f28d39c..1568af53 100644
--- a/Documentation/trace-cmd/Makefile
+++ b/Documentation/trace-cmd/Makefile
@@ -3,42 +3,130 @@
 # Include the utils
 include $(src)/scripts/utils.mk
 
-bdir:=$(doc_dir)/trace-cmd
+# This Makefile and manpage XSL files were taken from libtracefs
+# and modified for libtracecmd
 
-$(bdir)/%.xsl: $(bdir)/%.txt
-	$(Q)mkdir -p $(bdir)
-	$(Q)$(do_asciidoc_build)
+MAN1_TXT= \
+	$(wildcard trace-cmd*.1.txt)
 
+MAN5_TXT= \
+	$(wildcard trace-cmd*.5.txt)
 
-$(bdir)/%.1: $(bdir)/%.1.xsl
-	@$(call manpage.xsl)
-	$(Q)$(do_xsltproc_build)
+MAN_TXT = $(MAN1_TXT) $(MAN5_TXT)
+_MAN_XML=$(patsubst %.txt,%.xml,$(MAN_TXT))
+_MAN_HTML=$(patsubst %.txt,%.html,$(MAN_TXT))
+_DOC_MAN1=$(patsubst %.1.txt,%.1,$(MAN1_TXT))
+_DOC_MAN5=$(patsubst %.5.txt,%.5,$(MAN5_TXT))
 
-$(bdir)/%.5: $(bdir)/%.5.xsl
-	@$(call manpage.xsl)
-	$(Q)$(do_xsltproc_build)
-	$(Q)$(call remove_synopsis, $@)
+MAN_XML=$(addprefix $(OUTPUT),$(_MAN_XML))
+MAN_HTML=$(addprefix $(OUTPUT),$(_MAN_HTML))
+DOC_MAN1=$(addprefix $(OUTPUT),$(_DOC_MAN1))
+DOC_MAN5=$(addprefix $(OUTPUT),$(_DOC_MAN5))
 
- TEXT1 = $(wildcard $(bdir)/*.1.txt)
- MAN1 = $(patsubst $(bdir)/%.1.txt,$(bdir)/%.1, ${TEXT1})
- TEXT5 = $(wildcard $(bdir)/*.5.txt)
- MAN5 = $(patsubst $(bdir)/%.5.txt,$(bdir)/%.5, ${TEXT5})
+# Make the path relative to DESTDIR, not prefix
+ifndef DESTDIR
+prefix?=$(HOME)
+endif
+bindir?=$(prefix)/bin
+htmldir?=$(prefix)/share/doc/trace-cmd
+pdfdir?=$(prefix)/share/doc/trace-cmd
+mandir?=$(prefix)/share/man
+man1dir=$(mandir)/man1
+man5dir=$(mandir)/man5
 
-all: $(MAN1) $(MAN5)
+ifdef USE_ASCIIDOCTOR
+ASCIIDOC_EXTRA += -a mansource="libtracecmd" -a manmanual="libtracecmd Manual"
+endif
 
-MAN1_INSTALL = $(MAN1:%.1=%.1.install)
-MAN5_INSTALL = $(MAN5:%.5=%.5.install)
+all: check-man-tools html man
 
-$(MAN1_INSTALL): %.1.install : %.1 force
-	$(Q)$(call do_install_docs,$<,$(man_dir_SQ)/man1)
-$(MAN5_INSTALL): %.5.install : %.5 force
-	$(Q)$(call do_install_docs,$<,$(man_dir_SQ)/man5)
+man: man1 man5
+man1: $(DOC_MAN1)
+man5: $(DOC_MAN5)
 
-install: $(MAN1_INSTALL) $(MAN5_INSTALL)
+html: $(MAN_HTML)
+
+$(MAN_HTML) $(DOC_MAN1) $(DOC_MAN5): $(ASCIIDOC_CONF)
+
+install: check-man-tools install-man install-html
+
+check-man-tools:
+ifdef missing_tools
+	$(error "You need to install $(missing_tools) for man pages")
+endif
+
+install-%.1: $(OUTPUT)%.1
+	$(Q)$(call do_install_docs,$<,$(man1dir),644);
+
+install-%.5: $(OUTPUT)%.5
+	$(Q)$(call do_install_docs,$<,$(man5dir),644);
+
+do-install-man: man $(addprefix install-,$(wildcard $(OUTPUT)*.1)) \
+	$(addprefix install-,$(wildcard $(OUTPUT)*.5))
+
+install-man: man
+	$(Q)$(MAKE) -C . do-install-man
+
+install-%.txt: $(OUTPUT)%.html
+	$(Q)$(call do_install_docs,$<,$(htmldir),644);
+
+do-install-html: html $(addprefix install-,$(wildcard *.txt))
+
+install-html: html do-install-html
+
+uninstall: uninstall-man uninstall-html
+
+uninstall-man:
+	$(Q)$(RM) $(addprefix $(DESTDIR)$(man1dir)/,$(DOC_MAN1))
+	$(Q)$(RM) $(addprefix $(DESTDIR)$(man5dir)/,$(DOC_MAN5))
+
+uninstall-html:
+	$(Q)$(RM) $(addprefix $(DESTDIR)$(htmldir)/,$(MAN_HTML))
+
+ifdef missing_tools
+  DO_INSTALL_MAN = $(warning Please install $(missing_tools) to have the man pages installed)
+else
+  DO_INSTALL_MAN = do-install-man
+endif
+
+CLEAN_FILES =					\
+	$(MAN_XML) $(addsuffix +,$(MAN_XML))	\
+	$(MAN_HTML) $(addsuffix +,$(MAN_HTML))	\
+	$(DOC_MAN1) $(DOC_MAN5) *.1 *.5
 
 clean:
-	$(Q)(cd $(bdir); \
-		$(RM) *.xml *.xsl *.1 *.5)
+	$(Q) $(RM) $(CLEAN_FILES)
+
+ifdef USE_ASCIIDOCTOR
+$(OUTPUT)%.1 : $(OUTPUT)%.1.txt
+	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
+	$(ASCIIDOC) -b manpage -d manpage \
+		$(ASCIIDOC_EXTRA) -atracecmd_version=$(TRACECMD_VERSION) -o $@+ $< && \
+	mv $@+ $@
+
+$(OUTPUT)%.5 : $(OUTPUT)%.5.txt
+	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
+	$(ASCIIDOC) -b manpage -d manpage \
+		$(ASCIIDOC_EXTRA) -atracecmd_version=$(TRACECMD_VERSION) -o $@+ $< && \
+	mv $@+ $@
+endif
+
+$(OUTPUT)%.1 : $(OUTPUT)%.1.xml
+	$(QUIET_XMLTO)$(RM) $@ && \
+	$(XMLTO) -o $(OUTPUT). -m $(MANPAGE_XSL) $(XMLTO_EXTRA) man $<; \
+
+$(OUTPUT)%.5 : $(OUTPUT)%.5.xml
+	$(QUIET_XMLTO)$(RM) $@ && \
+	$(XMLTO) -o $(OUTPUT). -m $(MANPAGE_XSL) $(XMLTO_EXTRA) man $<; \
+
+$(OUTPUT)%.xml : %.txt
+	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
+	$(ASCIIDOC) -b docbook -d manpage \
+		$(ASCIIDOC_EXTRA) -atracecmd_version=$(TRACECMD_VERSION) -o $@+ $< && \
+	mv $@+ $@
 
-.PHONE: force
-force:
+$(MAN_HTML): $(OUTPUT)%.html : %.txt
+	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
+	$(ASCIIDOC) -b $(ASCIIDOC_HTML) -d manpage \
+		$(ASCIIDOC_EXTRA) -atracecmd_version=$(TRACECMD_VERSION) -o $@+ $< && \
+	mv $@+ $@
diff --git a/scripts/utils.mk b/scripts/utils.mk
index ae8c9e77..237b2fc9 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -172,16 +172,6 @@ define do_make_pkgconfig_file
 	sed -i "s|HEADER_DIR|$(includedir)/trace-cmd|g" ${PKG_CONFIG_FILE};
 endef
 
-define manpage.xsl
-	if [ -z ${MANPAGE_DOCBOOK_XSL} ]; then 			\
-		echo "*********************************";	\
-		echo "** No docbook.xsl is installed **";	\
-		echo "** Can't make man pages        **";	\
-		echo "*********************************";	\
-		exit 1;						\
-	fi
-endef
-
 do_asciidoc_build =				\
 	($(print_asciidoc)			\
 	 asciidoc -d manpage -b docbook -o $@ $<)
@@ -205,3 +195,15 @@ define do_install_docs
 	fi;						\
 	$(INSTALL) -m 644 $1 '$(DESTDIR_SQ)$2'
 endef
+
+ifneq ($(findstring $(MAKEFLAGS),s),s)
+ifneq ($(V),1)
+	QUIET_ASCIIDOC	= @echo '  ASCIIDOC  '$@;
+	QUIET_XMLTO	= @echo '  XMLTO    '$@;
+	QUIET_SUBDIR0	= +@subdir=
+	QUIET_SUBDIR1	= ;$(NO_SUBDIR) \
+			   echo '  SUBDIR   ' $$subdir; \
+			  $(MAKE) $(PRINT_DIR) -C $$subdir
+	export V
+endif
+endif
-- 
2.29.2


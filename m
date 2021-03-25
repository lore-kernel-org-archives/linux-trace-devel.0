Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55F6BC433C1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 18:04:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0786E61A2E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 18:04:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbhCYSDy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 14:03:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:52230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229581AbhCYSDb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 14:03:31 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C662761A2E
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Mar 2021 18:03:30 +0000 (UTC)
Date:   Thu, 25 Mar 2021 14:03:28 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracecmd: Rewrite Makefile for Documentation directory
Message-ID: <20210325140328.7215cec7@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The installation for libtracecmd documents was not working properly. The
libtracefs Documentation Makefile was copied over and modified for
libtracecmd. It was also updated to show each file being installed, and the
dependencies were fixed to not recreate the man pages every time it was
built.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracecmd/.gitignore          |   2 +
 Documentation/libtracecmd/Makefile            | 198 ++++++++++++++++--
 Documentation/libtracecmd/asciidoc.conf       | 120 +++++++++++
 ...ecmd-files.3.txt => libtracecmd-files.txt} |   0
 ...tances.3.txt => libtracecmd-instances.txt} |   0
 ...acecmd-peer.3.txt => libtracecmd-peer.txt} |   0
 ...md-record.3.txt => libtracecmd-record.txt} |   0
 .../{libtracecmd.3.txt => libtracecmd.txt}    |   0
 Documentation/libtracecmd/manpage-1.72.xsl    |  14 ++
 Documentation/libtracecmd/manpage-base.xsl    |  35 ++++
 .../libtracecmd/manpage-bold-literal.xsl      |  17 ++
 Documentation/libtracecmd/manpage-normal.xsl  |  13 ++
 .../libtracecmd/manpage-suppress-sp.xsl       |  21 ++
 13 files changed, 402 insertions(+), 18 deletions(-)
 create mode 100644 Documentation/libtracecmd/.gitignore
 create mode 100644 Documentation/libtracecmd/asciidoc.conf
 rename Documentation/libtracecmd/{libtracecmd-files.3.txt =>
libtracecmd-files.txt} (100%) rename
Documentation/libtracecmd/{libtracecmd-instances.3.txt =>
libtracecmd-instances.txt} (100%) rename
Documentation/libtracecmd/{libtracecmd-peer.3.txt => libtracecmd-peer.txt}
(100%) rename Documentation/libtracecmd/{libtracecmd-record.3.txt =>
libtracecmd-record.txt} (100%) rename
Documentation/libtracecmd/{libtracecmd.3.txt => libtracecmd.txt} (100%)
create mode 100644 Documentation/libtracecmd/manpage-1.72.xsl create mode
100644 Documentation/libtracecmd/manpage-base.xsl create mode 100644
Documentation/libtracecmd/manpage-bold-literal.xsl create mode 100644
Documentation/libtracecmd/manpage-normal.xsl create mode 100644
Documentation/libtracecmd/manpage-suppress-sp.xsl

diff --git a/Documentation/libtracecmd/.gitignore
b/Documentation/libtracecmd/.gitignore new file mode 100644
index 00000000..89b40e42
--- /dev/null
+++ b/Documentation/libtracecmd/.gitignore
@@ -0,0 +1,2 @@
+*.m
+*.html
diff --git a/Documentation/libtracecmd/Makefile
b/Documentation/libtracecmd/Makefile index 196cac7c..840f8851 100644
--- a/Documentation/libtracecmd/Makefile
+++ b/Documentation/libtracecmd/Makefile
@@ -3,32 +3,194 @@
 # Include the utils
 include $(src)/scripts/utils.mk
 
-bdir:=$(doc_dir)/libtracecmd
+# This Makefile and manpage XSL files were taken from libtracefs
+# and modified for libtracecmd
 
-$(bdir)/%.xsl: $(bdir)/%.txt
-	$(Q)mkdir -p $(bdir)
-	$(Q)$(do_asciidoc_build)
+MAN3_TXT= \
+	$(wildcard libtracecmd-*.txt) \
+	libtracecmd.txt
 
+MAN_TXT = $(MAN3_TXT)
+_MAN_XML=$(patsubst %.txt,%.xml,$(MAN_TXT))
+_MAN_HTML=$(patsubst %.txt,%.html,$(MAN_TXT))
+_DOC_MAN3=$(patsubst %.txt,%.m,$(MAN3_TXT))
 
-$(bdir)/%.3: $(bdir)/%.3.xsl
-	@$(call manpage.xsl)
-	$(Q)$(do_xsltproc_build)
+MAN_XML=$(addprefix $(OUTPUT),$(_MAN_XML))
+MAN_HTML=$(addprefix $(OUTPUT),$(_MAN_HTML))
+DOC_MAN3=$(addprefix $(OUTPUT),$(_DOC_MAN3))
 
-TEXT3 = $(wildcard $(bdir)/*.3.txt)
-MAN3 = $(patsubst $(bdir)/%.3.txt,$(bdir)/%.3, ${TEXT3})
+# Make the path relative to DESTDIR, not prefix
+ifndef DESTDIR
+prefix?=$(HOME)
+endif
+bindir?=$(prefix)/bin
+htmldir?=$(prefix)/share/doc/libtracecmd-doc
+pdfdir?=$(prefix)/share/doc/libtracecmd-doc
+mandir?=$(prefix)/share/man
+man3dir=$(mandir)/man3
 
-all: $(MAN3)
+ASCIIDOC=asciidoc
+ASCIIDOC_EXTRA = --unsafe -f asciidoc.conf
+ASCIIDOC_HTML = xhtml11
+MANPAGE_XSL = manpage-normal.xsl
+XMLTO_EXTRA =
+INSTALL?=install
+RM ?= rm -f
 
-MAN3_INSTALL = $(MAN3:%.3=%.3.install)
+ifdef USE_ASCIIDOCTOR
+ASCIIDOC = asciidoctor
+ASCIIDOC_EXTRA = -a compat-mode
+ASCIIDOC_EXTRA += -I. -rasciidoctor-extensions
+ASCIIDOC_EXTRA += -a mansource="libtracecmd" -a manmanual="libtracecmd
Manual" +ASCIIDOC_HTML = xhtml5
+endif
 
-$(MAN3_INSTALL): %.3.install : %.3 force
-	$(Q)$(call do_install_docs,$<,$(man_dir_SQ)/man3)
+ASCIIDOC_INSTALLED := $(shell command -v $(ASCIIDOC) 2> /dev/null)
+ifndef ASCIIDOC_INSTALLED
+	missing_tools += $(ASCIIDOC)
+endif
 
-install: $(MAN3_INSTALL)
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
+#	-1.68.1,	set ASCIIDOC_NO_ROFF? (based on changelog from
1.73.0) +#	1.69.0,		no extra settings are needed?
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
+MANPAGE_XSL = manpage-1.72.xsl
+else
+	ifdef ASCIIDOC_NO_ROFF
+	# docbook-xsl after 1.72 needs the regular XSL, but will not
+	# pass-thru raw roff codes from asciidoc.conf, so turn them off.
+	ASCIIDOC_EXTRA += -a libtracecmd-asciidoc-no-roff
+	endif
+endif
+ifdef MAN_BOLD_LITERAL
+XMLTO_EXTRA += -m manpage-bold-literal.xsl
+endif
+ifdef DOCBOOK_SUPPRESS_SP
+XMLTO_EXTRA += -m manpage-suppress-sp.xsl
+endif
+
+ifneq ($(findstring $(MAKEFLAGS),w),w)
+PRINT_DIR = --no-print-directory
+else # "make -w"
+NO_SUBDIR = :
+endif
+
+ifneq ($(findstring $(MAKEFLAGS),s),s)
+ifneq ($(V),1)
+	QUIET_ASCIIDOC	= @echo '  ASCIIDOC '$@;
+	QUIET_XMLTO	= @echo '  XMLTO    '$@;
+	QUIET_SUBDIR0	= +@subdir=
+	QUIET_SUBDIR1	= ;$(NO_SUBDIR) \
+			   echo '  SUBDIR   ' $$subdir; \
+			  $(MAKE) $(PRINT_DIR) -C $$subdir
+	export V
+endif
+endif
+
+all: check-man-tools html man
+
+man: man3
+man3: $(DOC_MAN3)
+
+html: $(MAN_HTML)
+
+$(MAN_HTML) $(DOC_MAN3): asciidoc.conf
+
+install: check-man-tools install-man install-html
+
+check-man-tools:
+ifdef missing_tools
+	$(error "You need to install $(missing_tools) for man pages")
+endif
+
+install-%.3: $(OUTPUT)%.3
+	$(Q)$(call do_install_docs,$<,$(man3dir),644);
+
+do-install-man: man $(addprefix install-,$(wildcard $(OUTPUT)*.3))
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
+	$(Q)$(RM) $(addprefix $(DESTDIR)$(man3dir)/,$(DOC_MAN3))
+
+uninstall-html:
+	$(Q)$(RM) $(addprefix $(DESTDIR)$(htmldir)/,$(MAN_HTML))
+
+ifdef missing_tools
+  DO_INSTALL_MAN = $(warning Please install $(missing_tools) to have the
man pages installed) +else
+  DO_INSTALL_MAN = do-install-man
+endif
+
+CLEAN_FILES =					\
+	$(MAN_XML) $(addsuffix +,$(MAN_XML))	\
+	$(MAN_HTML) $(addsuffix +,$(MAN_HTML))	\
+	$(DOC_MAN3) *.3 *.m
 
 clean:
-	$(Q)(cd $(bdir); \
-		$(RM) *.xml *.xsl *.3)
+	$(Q) $(RM) $(CLEAN_FILES)
+
+ifdef USE_ASCIIDOCTOR
+$(OUTPUT)%.m : $(OUTPUT)%.txt
+	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
+	$(ASCIIDOC) -b manpage -d manpage \
+		$(ASCIIDOC_EXTRA) -alibtracecmd_version=$(TRACEFS_VERSION)
-o $@+ $< && \
+	mv $@+ $@
+endif
+
+$(OUTPUT)%.m : $(OUTPUT)%.xml
+	$(QUIET_XMLTO)$(RM) $@ && \
+	$(XMLTO) -o $(OUTPUT). -m $(MANPAGE_XSL) $(XMLTO_EXTRA) man $<; \
+	touch $@
+
+$(OUTPUT)%.xml : %.txt
+	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
+	$(ASCIIDOC) -b docbook -d manpage \
+		$(ASCIIDOC_EXTRA) -alibtracecmd_version=$(TRACEFS_VERSION)
-o $@+ $< && \
+	mv $@+ $@
 
-.PHONE: force
-force:
+$(MAN_HTML): $(OUTPUT)%.html : %.txt
+	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
+	$(ASCIIDOC) -b $(ASCIIDOC_HTML) -d manpage \
+		$(ASCIIDOC_EXTRA) -alibtracecmd_version=$(TRACEFS_VERSION)
-o $@+ $< && \
+	mv $@+ $@
diff --git a/Documentation/libtracecmd/asciidoc.conf
b/Documentation/libtracecmd/asciidoc.conf new file mode 100644
index 00000000..c15aa13b
--- /dev/null
+++ b/Documentation/libtracecmd/asciidoc.conf
@@ -0,0 +1,120 @@
+## linktep: macro
+#
+# Usage: linktep:command[manpage-section]
+#
+# Note, {0} is the manpage section, while {target} is the command.
+#
+# Show TEP link as: <command>(<section>); if section is defined, else just
show +# the command.
+
+[macros]
+(?su)[\\]?(?P<name>linktep):(?P<target>\S*?)\[(?P<attrlist>.*?)\]=
+
+[attributes]
+asterisk=&#42;
+plus=&#43;
+caret=&#94;
+startsb=&#91;
+endsb=&#93;
+tilde=&#126;
+
+ifdef::backend-docbook[]
+[linktep-inlinemacro]
+{0%{target}}
+{0#<citerefentry>}
+{0#<refentrytitle>{target}</refentrytitle><manvolnum>{0}</manvolnum>}
+{0#</citerefentry>}
+endif::backend-docbook[]
+
+ifdef::backend-docbook[]
+ifndef::tep-asciidoc-no-roff[]
+# "unbreak" docbook-xsl v1.68 for manpages. v1.69 works with or without
this. +# v1.72 breaks with this because it replaces dots not in roff
requests. +[listingblock]
+<example><title>{title}</title>
+<literallayout>
+ifdef::doctype-manpage[]
+&#10;.ft C&#10;
+endif::doctype-manpage[]
+|
+ifdef::doctype-manpage[]
+&#10;.ft&#10;
+endif::doctype-manpage[]
+</literallayout>
+{title#}</example>
+endif::tep-asciidoc-no-roff[]
+
+ifdef::tep-asciidoc-no-roff[]
+ifdef::doctype-manpage[]
+# The following two small workarounds insert a simple paragraph after
screen +[listingblock]
+<example><title>{title}</title>
+<literallayout>
+|
+</literallayout><simpara></simpara>
+{title#}</example>
+
+[verseblock]
+<formalpara{id? id="{id}"}><title>{title}</title><para>
+{title%}<literallayout{id? id="{id}"}>
+{title#}<literallayout>
+|
+</literallayout>
+{title#}</para></formalpara>
+{title%}<simpara></simpara>
+endif::doctype-manpage[]
+endif::tep-asciidoc-no-roff[]
+endif::backend-docbook[]
+
+ifdef::doctype-manpage[]
+ifdef::backend-docbook[]
+[header]
+template::[header-declarations]
+<refentry>
+<refmeta>
+<refentrytitle>{mantitle}</refentrytitle>
+<manvolnum>{manvolnum}</manvolnum>
+<refmiscinfo class="source">libtracefs</refmiscinfo>
+<refmiscinfo class="version">{libtracefs_version}</refmiscinfo>
+<refmiscinfo class="manual">libtracefs Manual</refmiscinfo>
+</refmeta>
+<refnamediv>
+  <refname>{manname1}</refname>
+  <refname>{manname2}</refname>
+  <refname>{manname3}</refname>
+  <refname>{manname4}</refname>
+  <refname>{manname5}</refname>
+  <refname>{manname6}</refname>
+  <refname>{manname7}</refname>
+  <refname>{manname8}</refname>
+  <refname>{manname9}</refname>
+  <refname>{manname10}</refname>
+  <refname>{manname11}</refname>
+  <refname>{manname12}</refname>
+  <refname>{manname13}</refname>
+  <refname>{manname14}</refname>
+  <refname>{manname15}</refname>
+  <refname>{manname16}</refname>
+  <refname>{manname17}</refname>
+  <refname>{manname18}</refname>
+  <refname>{manname19}</refname>
+  <refname>{manname20}</refname>
+  <refname>{manname21}</refname>
+  <refname>{manname22}</refname>
+  <refname>{manname23}</refname>
+  <refname>{manname24}</refname>
+  <refname>{manname25}</refname>
+  <refname>{manname26}</refname>
+  <refname>{manname27}</refname>
+  <refname>{manname28}</refname>
+  <refname>{manname29}</refname>
+  <refname>{manname30}</refname>
+  <refpurpose>{manpurpose}</refpurpose>
+</refnamediv>
+endif::backend-docbook[]
+endif::doctype-manpage[]
+
+ifdef::backend-xhtml11[]
+[linktep-inlinemacro]
+<a href="{target}.html">{target}{0?({0})}</a>
+endif::backend-xhtml11[]
diff --git a/Documentation/libtracecmd/libtracecmd-files.3.txt
b/Documentation/libtracecmd/libtracecmd-files.txt similarity index 100%
rename from Documentation/libtracecmd/libtracecmd-files.3.txt
rename to Documentation/libtracecmd/libtracecmd-files.txt
diff --git a/Documentation/libtracecmd/libtracecmd-instances.3.txt
b/Documentation/libtracecmd/libtracecmd-instances.txt similarity index 100%
rename from Documentation/libtracecmd/libtracecmd-instances.3.txt
rename to Documentation/libtracecmd/libtracecmd-instances.txt
diff --git a/Documentation/libtracecmd/libtracecmd-peer.3.txt
b/Documentation/libtracecmd/libtracecmd-peer.txt similarity index 100%
rename from Documentation/libtracecmd/libtracecmd-peer.3.txt
rename to Documentation/libtracecmd/libtracecmd-peer.txt
diff --git a/Documentation/libtracecmd/libtracecmd-record.3.txt
b/Documentation/libtracecmd/libtracecmd-record.txt similarity index 100%
rename from Documentation/libtracecmd/libtracecmd-record.3.txt
rename to Documentation/libtracecmd/libtracecmd-record.txt
diff --git a/Documentation/libtracecmd/libtracecmd.3.txt
b/Documentation/libtracecmd/libtracecmd.txt similarity index 100%
rename from Documentation/libtracecmd/libtracecmd.3.txt
rename to Documentation/libtracecmd/libtracecmd.txt
diff --git a/Documentation/libtracecmd/manpage-1.72.xsl
b/Documentation/libtracecmd/manpage-1.72.xsl new file mode 100644
index 00000000..b4d315cb
--- /dev/null
+++ b/Documentation/libtracecmd/manpage-1.72.xsl
@@ -0,0 +1,14 @@
+<!-- manpage-1.72.xsl:
+     special settings for manpages rendered from asciidoc+docbook
+     handles peculiarities in docbook-xsl 1.72.0 -->
+<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
+		version="1.0">
+
+<xsl:import href="manpage-base.xsl"/>
+
+<!-- these are the special values for the roff control characters
+     needed for docbook-xsl 1.72.0 -->
+<xsl:param name="git.docbook.backslash">&#x2593;</xsl:param>
+<xsl:param name="git.docbook.dot"      >&#x2302;</xsl:param>
+
+</xsl:stylesheet>
diff --git a/Documentation/libtracecmd/manpage-base.xsl
b/Documentation/libtracecmd/manpage-base.xsl new file mode 100644
index 00000000..a264fa61
--- /dev/null
+++ b/Documentation/libtracecmd/manpage-base.xsl
@@ -0,0 +1,35 @@
+<!-- manpage-base.xsl:
+     special formatting for manpages rendered from asciidoc+docbook -->
+<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
+		version="1.0">
+
+<!-- these params silence some output from xmlto -->
+<xsl:param name="man.output.quietly" select="1"/>
+<xsl:param name="refentry.meta.get.quietly" select="1"/>
+
+<!-- convert asciidoc callouts to man page format;
+     git.docbook.backslash and git.docbook.dot params
+     must be supplied by another XSL file or other means -->
+<xsl:template match="co">
+	<xsl:value-of select="concat(
+			      $git.docbook.backslash,'fB(',
+			      substring-after(@id,'-'),')',
+			      $git.docbook.backslash,'fR')"/>
+</xsl:template>
+<xsl:template match="calloutlist">
+	<xsl:value-of select="$git.docbook.dot"/>
+	<xsl:text>sp&#10;</xsl:text>
+	<xsl:apply-templates/>
+	<xsl:text>&#10;</xsl:text>
+</xsl:template>
+<xsl:template match="callout">
+	<xsl:value-of select="concat(
+			      $git.docbook.backslash,'fB',
+			      substring-after(@arearefs,'-'),
+			      '. ',$git.docbook.backslash,'fR')"/>
+	<xsl:apply-templates/>
+	<xsl:value-of select="$git.docbook.dot"/>
+	<xsl:text>br&#10;</xsl:text>
+</xsl:template>
+
+</xsl:stylesheet>
diff --git a/Documentation/libtracecmd/manpage-bold-literal.xsl
b/Documentation/libtracecmd/manpage-bold-literal.xsl new file mode 100644
index 00000000..608eb5df
--- /dev/null
+++ b/Documentation/libtracecmd/manpage-bold-literal.xsl
@@ -0,0 +1,17 @@
+<!-- manpage-bold-literal.xsl:
+     special formatting for manpages rendered from asciidoc+docbook -->
+<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
+		version="1.0">
+
+<!-- render literal text as bold (instead of plain or monospace);
+     this makes literal text easier to distinguish in manpages
+     viewed on a tty -->
+<xsl:template match="literal">
+	<xsl:value-of select="$git.docbook.backslash"/>
+	<xsl:text>fB</xsl:text>
+	<xsl:apply-templates/>
+	<xsl:value-of select="$git.docbook.backslash"/>
+	<xsl:text>fR</xsl:text>
+</xsl:template>
+
+</xsl:stylesheet>
diff --git a/Documentation/libtracecmd/manpage-normal.xsl
b/Documentation/libtracecmd/manpage-normal.xsl new file mode 100644
index 00000000..a48f5b11
--- /dev/null
+++ b/Documentation/libtracecmd/manpage-normal.xsl
@@ -0,0 +1,13 @@
+<!-- manpage-normal.xsl:
+     special settings for manpages rendered from asciidoc+docbook
+     handles anything we want to keep away from docbook-xsl 1.72.0 -->
+<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
+		version="1.0">
+
+<xsl:import href="manpage-base.xsl"/>
+
+<!-- these are the normal values for the roff control characters -->
+<xsl:param name="git.docbook.backslash">\</xsl:param>
+<xsl:param name="git.docbook.dot"	>.</xsl:param>
+
+</xsl:stylesheet>
diff --git a/Documentation/libtracecmd/manpage-suppress-sp.xsl
b/Documentation/libtracecmd/manpage-suppress-sp.xsl new file mode 100644
index 00000000..a63c7632
--- /dev/null
+++ b/Documentation/libtracecmd/manpage-suppress-sp.xsl
@@ -0,0 +1,21 @@
+<!-- manpage-suppress-sp.xsl:
+     special settings for manpages rendered from asciidoc+docbook
+     handles erroneous, inline .sp in manpage output of some
+     versions of docbook-xsl -->
+<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
+		version="1.0">
+
+<!-- attempt to work around spurious .sp at the tail of the line
+     that some versions of docbook stylesheets seem to add -->
+<xsl:template match="simpara">
+  <xsl:variable name="content">
+    <xsl:apply-templates/>
+  </xsl:variable>
+  <xsl:value-of select="normalize-space($content)"/>
+  <xsl:if test="not(ancestor::authorblurb) and
+                not(ancestor::personblurb)">
+    <xsl:text>&#10;&#10;</xsl:text>
+  </xsl:if>
+</xsl:template>
+
+</xsl:stylesheet>
-- 
2.29.2


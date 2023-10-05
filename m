Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3BE43ABB
	for <linux-trace-devel@vger.kernel.org>; Thu,  5 Oct 2023 23:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C6FC433CB;
	Thu,  5 Oct 2023 23:23:41 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1qoXi7-005VCR-2e;
	Thu, 05 Oct 2023 19:24:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Ross Zwisler <zwisler@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/5] libtraceeval: Start creating the documentation man pages
Date: Thu,  5 Oct 2023 19:24:46 -0400
Message-Id: <20231005232450.1311519-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231005232450.1311519-1-rostedt@goodmis.org>
References: <20231005232450.1311519-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Create a Documentation directory and start adding man pages for the
libtraceeval functions.

This just adds the infrastructure for the man pages. The man pages
themselves will come later.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/.gitignore               |   4 +
 Documentation/Makefile                 | 245 +++++++++++++++++++++++++
 Documentation/asciidoc.conf            | 120 ++++++++++++
 Documentation/libtraceeval.txt         |  55 ++++++
 Documentation/manpage-1.72.xsl         |  14 ++
 Documentation/manpage-base.xsl         |  35 ++++
 Documentation/manpage-bold-literal.xsl |  17 ++
 Documentation/manpage-normal.xsl       |  13 ++
 Documentation/manpage-suppress-sp.xsl  |  21 +++
 check-manpages.sh                      |  63 +++++++
 10 files changed, 587 insertions(+)
 create mode 100644 Documentation/.gitignore
 create mode 100644 Documentation/Makefile
 create mode 100644 Documentation/asciidoc.conf
 create mode 100644 Documentation/libtraceeval.txt
 create mode 100644 Documentation/manpage-1.72.xsl
 create mode 100644 Documentation/manpage-base.xsl
 create mode 100644 Documentation/manpage-bold-literal.xsl
 create mode 100644 Documentation/manpage-normal.xsl
 create mode 100644 Documentation/manpage-suppress-sp.xsl
 create mode 100755 check-manpages.sh

diff --git a/Documentation/.gitignore b/Documentation/.gitignore
new file mode 100644
index 000000000000..747b2584d55b
--- /dev/null
+++ b/Documentation/.gitignore
@@ -0,0 +1,4 @@
+*.3
+*.m
+*.xml
+*.html
diff --git a/Documentation/Makefile b/Documentation/Makefile
new file mode 100644
index 000000000000..3540440e1dae
--- /dev/null
+++ b/Documentation/Makefile
@@ -0,0 +1,245 @@
+# SPDX-License-Identifier: LGPL-2.1
+
+include $(src)/scripts/utils.mk
+
+
+# This Makefile and manpage XSL files were taken from libtracefs
+# and modified for libtraceeval
+
+MAN3_TXT= \
+	libtraceeval.txt
+
+MAN1_TEXT=
+
+MAN_TXT = $(MAN3_TXT)
+_MAN_XML=$(patsubst %.txt,%.xml,$(MAN_TXT))
+_MAN_HTML=$(patsubst %.txt,%.html,$(MAN_TXT))
+_DOC_MAN3=$(patsubst %.txt,%.m,$(MAN3_TXT))
+
+MAN_XML=$(addprefix $(OUTPUT),$(_MAN_XML))
+MAN_HTML=$(addprefix $(OUTPUT),$(_MAN_HTML))
+DOC_MAN3=$(addprefix $(OUTPUT),$(_DOC_MAN3))
+
+_MAN1_XML=$(patsubst %.txt.1,%.xml,$(MAN1_TEXT))
+_MAN1_HTML=$(patsubst %.txt.1,%.html,$(MAN1_TEXT))
+_DOC_MAN1=$(patsubst %.txt.1,%.m,$(MAN1_TEXT))
+
+MAN1_XML=$(addprefix $(OUTPUT),$(_MAN1_XML))
+MAN1_HTML=$(addprefix $(OUTPUT),$(_MAN1_HTML))
+DOC_MAN1=$(addprefix $(OUTPUT),$(_DOC_MAN1))
+
+
+# Make the path relative to DESTDIR, not prefix
+ifndef DESTDIR
+prefix?=$(HOME)
+endif
+bindir?=$(prefix)/bin
+htmldir?=$(prefix)/share/doc/libtraceeval-doc
+pdfdir?=$(prefix)/share/doc/libtraceeval-doc
+mandir?=$(prefix)/share/man
+man3dir=$(mandir)/man3
+man1dir=$(mandir)/man1
+
+ASCIIDOC=asciidoc
+ASCIIDOC_EXTRA = --unsafe -f asciidoc.conf
+ASCIIDOC_HTML = xhtml11
+MANPAGE_XSL = manpage-normal.xsl
+XMLTO_EXTRA =
+INSTALL?=install
+RM ?= rm -f
+
+ifdef USE_ASCIIDOCTOR
+ASCIIDOC = asciidoctor
+ASCIIDOC_EXTRA = -a compat-mode
+ASCIIDOC_EXTRA += -I. -rasciidoctor-extensions
+ASCIIDOC_EXTRA += -a mansource="libtraceeval" -a manmanual="libtraceeval Manual"
+ASCIIDOC_HTML = xhtml5
+endif
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
+ASCIIDOC_EXTRA += -a libtraceeval-asciidoc-no-roff
+MANPAGE_XSL = manpage-1.72.xsl
+else
+	ifdef ASCIIDOC_NO_ROFF
+	# docbook-xsl after 1.72 needs the regular XSL, but will not
+	# pass-thru raw roff codes from asciidoc.conf, so turn them off.
+	ASCIIDOC_EXTRA += -a libtraceeval-asciidoc-no-roff
+	endif
+endif
+ifdef MAN_BOLD_LITERAL
+XMLTO_EXTRA += -m manpage-bold-literal.xsl
+endif
+ifdef DOCBOOK_SUPPRESS_SP
+XMLTO_EXTRA += -m manpage-suppress-sp.xsl
+endif
+
+SHELL_PATH ?= $(SHELL)
+# Shell quote;
+SHELL_PATH_SQ = $(subst ','\'',$(SHELL_PATH))
+
+DESTDIR ?=
+DESTDIR_SQ = '$(subst ','\'',$(DESTDIR))'
+
+export DESTDIR DESTDIR_SQ
+
+QUIET_SUBDIR0  = +$(MAKE) -C # space to separate -C and subdir
+QUIET_SUBDIR1  =
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
+man: man3 man1
+man3: $(DOC_MAN3)
+man1: $(DOC_MAN1)
+
+html: $(MAN_HTML) $(MAN1_HTML)
+
+$(MAN_HTML) $(MAN1_HTML) $(DOC_MAN3) $(DOC_MAN1): asciidoc.conf
+
+install: check-man-tools install-man install-html
+
+check-man-tools:
+ifdef missing_tools
+	$(error "You need to install $(missing_tools) for man pages")
+endif
+
+install-%.3: $(OUTPUT)%.3
+	$(Q)$(call do_install,$<,$(man3dir),644);
+
+install-%.1: $(OUTPUT)%.1
+	$(Q)$(call do_install,$<,$(man1dir),644);
+
+do-install-man: man $(addprefix install-,$(wildcard $(OUTPUT)*.3)) $(addprefix install-,$(wildcard $(OUTPUT)*.1))
+
+install-man: man
+	$(Q)$(MAKE) -C . do-install-man
+
+install-%.txt: $(OUTPUT)%.html
+	$(Q)$(call do_install,$<,$(htmldir),644);
+
+install-%.txt.1: $(OUTPUT)%.html
+	$(Q)$(call do_install,$<,$(htmldir),644);
+
+do-install-html: html $(addprefix install-,$(wildcard *.txt)) $(addprefix install-,$(wildcard *.txt.1))
+
+install-html: html do-install-html
+
+uninstall: uninstall-man uninstall-html
+
+uninstall-man:
+	$(Q)$(RM) $(addprefix $(DESTDIR)$(man3dir)/,$(DOC_MAN3)) $(addprefix $(DESTDIR)$(man1dir)/,$(DOC_MAN1))
+
+uninstall-html:
+	$(Q)$(RM) $(addprefix $(DESTDIR)$(htmldir)/,$(MAN_HTML)) $(addprefix $(DESTDIR)$(htmldir)/,$(MAN1_HTML))
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
+	$(MAN1_HTML) $(addsuffix +,$(MAN1_HTML))	\
+	$(filter-out $(MAN1_TEXT),$(wildcard *.1)) \
+	$(DOC_MAN3) *.3 *.m
+
+clean:
+	$(Q) $(RM) $(CLEAN_FILES)
+
+ifdef USE_ASCIIDOCTOR
+$(OUTPUT)%.3 : $(OUTPUT)%.txt
+	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
+	$(ASCIIDOC) -b manpage -d manpage \
+		$(ASCIIDOC_EXTRA) -alibtraceeval_version=$(TRACEEVAL_VERSION) -o $@+ $< && \
+	mv $@+ $@
+$(OUTPUT)%.1 : $(OUTPUT)%.txt.1
+	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
+	$(ASCIIDOC) -b manpage -d manpage \
+		$(ASCIIDOC_EXTRA) -alibtraceeval_version=$(TRACEEVAL_VERSION) -o $@+ $< && \
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
+		$(ASCIIDOC_EXTRA) -alibtraceeval_version=$(TRACEEVAL_VERSION) -o $@+ $< && \
+	mv $@+ $@
+
+$(OUTPUT)%.xml : %.txt.1
+	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
+	$(ASCIIDOC) -b docbook -d manpage \
+		$(ASCIIDOC_EXTRA) -alibtraceeval_version=$(TRACEEVAL_VERSION) -o $@+ $< && \
+	mv $@+ $@
+
+$(MAN_HTML): $(OUTPUT)%.html : %.txt
+	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
+	$(ASCIIDOC) -b $(ASCIIDOC_HTML) -d manpage \
+		$(ASCIIDOC_EXTRA) -alibtraceeval_version=$(TRACEEVAL_VERSION) -o $@+ $< && \
+	mv $@+ $@
+
+$(MAN1_HTML): $(OUTPUT)%.html : %.txt.1
+	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
+	$(ASCIIDOC) -b $(ASCIIDOC_HTML) -d manpage \
+		$(ASCIIDOC_EXTRA) -alibtraceeval_version=$(TRACEEVAL_VERSION) -o $@+ $< && \
+	mv $@+ $@
diff --git a/Documentation/asciidoc.conf b/Documentation/asciidoc.conf
new file mode 100644
index 000000000000..c15aa13b21ef
--- /dev/null
+++ b/Documentation/asciidoc.conf
@@ -0,0 +1,120 @@
+## linktep: macro
+#
+# Usage: linktep:command[manpage-section]
+#
+# Note, {0} is the manpage section, while {target} is the command.
+#
+# Show TEP link as: <command>(<section>); if section is defined, else just show
+# the command.
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
+# "unbreak" docbook-xsl v1.68 for manpages. v1.69 works with or without this.
+# v1.72 breaks with this because it replaces dots not in roff requests.
+[listingblock]
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
+# The following two small workarounds insert a simple paragraph after screen
+[listingblock]
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
diff --git a/Documentation/libtraceeval.txt b/Documentation/libtraceeval.txt
new file mode 100644
index 000000000000..d3b97805d6ca
--- /dev/null
+++ b/Documentation/libtraceeval.txt
@@ -0,0 +1,55 @@
+libtraceeval(3)
+===============
+
+NAME
+----
+libtraceeval - A trace evaluation helper library
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <traceeval.h>*
+
+--
+
+DESCRIPTION
+-----------
+The libtracefs(3) library provides APIs to access kernel trace file system.
+
+FILES
+-----
+[verse]
+--
+*traceeval.h*
+	Header file to include in order to have access to the library APIs.
+*-ltraceeval*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+*libtracecmd*
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>
+--
+
+REPORTING BUGS
+--------------
+Report bugs to  <linux-trace-devel@vger.kernel.org>
+
+LICENSE
+-------
+TBD
+
+RESOURCES
+---------
+TBD
+
+COPYING
+-------
+Copyright \(C) 2023 Google, llc.
diff --git a/Documentation/manpage-1.72.xsl b/Documentation/manpage-1.72.xsl
new file mode 100644
index 000000000000..b4d315cb8c47
--- /dev/null
+++ b/Documentation/manpage-1.72.xsl
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
diff --git a/Documentation/manpage-base.xsl b/Documentation/manpage-base.xsl
new file mode 100644
index 000000000000..a264fa616093
--- /dev/null
+++ b/Documentation/manpage-base.xsl
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
diff --git a/Documentation/manpage-bold-literal.xsl b/Documentation/manpage-bold-literal.xsl
new file mode 100644
index 000000000000..608eb5df6281
--- /dev/null
+++ b/Documentation/manpage-bold-literal.xsl
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
diff --git a/Documentation/manpage-normal.xsl b/Documentation/manpage-normal.xsl
new file mode 100644
index 000000000000..a48f5b11f3dc
--- /dev/null
+++ b/Documentation/manpage-normal.xsl
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
diff --git a/Documentation/manpage-suppress-sp.xsl b/Documentation/manpage-suppress-sp.xsl
new file mode 100644
index 000000000000..a63c7632a87d
--- /dev/null
+++ b/Documentation/manpage-suppress-sp.xsl
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
diff --git a/check-manpages.sh b/check-manpages.sh
new file mode 100755
index 000000000000..07acc12ecbc4
--- /dev/null
+++ b/check-manpages.sh
@@ -0,0 +1,63 @@
+#!/bin/bash
+# SPDX-License-Identifier: LGPL-2.1
+# Copyright (C) 2022, Google Inc, Steven Rostedt <rostedt@goodmis.org>
+#
+# This checks if any function is listed in a man page that is not listed
+# in the main man page.
+
+if [ $# -lt 1 ]; then
+	echo "usage: check-manpages man-page-path"
+	exit 1
+fi
+
+cd $1
+
+MAIN=libtraceeval
+MAIN_FILE=${MAIN}.txt
+
+PROCESSED=""
+
+# Ignore man pages that do not contain functions
+IGNORE=""
+
+for man in ${MAIN}-*.txt; do
+
+	for a in `sed -ne '/^NAME/,/^SYNOP/{/^[a-z]/{s/, *$//;s/,/\n/g;s/ //g;s/-.*$/-/;/-/{s/-//p;q};p}}' $man`; do
+		if [ "${PROCESSED/:${a} /}" != "${PROCESSED}" ]; then
+			P="${PROCESSED/:${a} */}"
+			echo "Found ${a} in ${man} and in ${P/* /}"
+		fi
+		PROCESSED="${man}:${a} ${PROCESSED}"
+		if [ "${IGNORE/$man/}" != "${IGNORE}" ]; then
+			continue
+		fi
+		if ! grep -q '\*'${a}'\*' $MAIN_FILE; then
+			if [ "$last" == "" ]; then
+				echo
+			fi
+			if [ "$last" != "$man" ]; then
+				echo "Missing functions from $MAIN_FILE that are in $man"
+				last=$man
+			fi
+			echo "   ${a}"
+		fi
+	done
+done
+
+# traceeval_init_data_size is not deprecated, but users shouldn't be using it directly.
+DEPRECATED="*traceeval_init_data_size*"
+
+last=""
+sed -ne 's/^[a-z].*[ \*]\([a-z_][a-z_]*\)(.*/\1/p' -e 's/^\([a-z_][a-z_]*\)(.*/\1/p' ../include/traceeval.h | while read f; do
+	if ! grep -q '\*'${f}'\*' $MAIN_FILE; then
+		if [ "${DEPRECATED/\*$f\*/}" != "${DEPRECATED}" ]; then
+			continue;
+		fi
+		if [ "$last" == "" ]; then
+			echo
+			echo "Missing functions from $MAIN_FILE that are in traceeval.h"
+			last=$f
+		fi
+		echo "   ${f}"
+	fi
+done
-- 
2.40.1


Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD78FC4167E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Sep 2021 15:46:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A86D4611C4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Sep 2021 15:46:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241728AbhIQPr7 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Sep 2021 11:47:59 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:56514 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241196AbhIQPr4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Sep 2021 11:47:56 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-Moyt8JmRP6uP6dfX3tX9XA-1; Fri, 17 Sep 2021 11:46:32 -0400
X-MC-Unique: Moyt8JmRP6uP6dfX3tX9XA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C092E835DE3;
        Fri, 17 Sep 2021 15:46:30 +0000 (UTC)
Received: from x1.bristot.me.homenet.telecomitalia.it (unknown [10.22.17.200])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E22495D9C6;
        Fri, 17 Sep 2021 15:46:27 +0000 (UTC)
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Jonathan Corbet <corbet@lwn.net>, Kate Carcia <kcarcia@redhat.com>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 13/19] rtla: Add Documentation
Date:   Fri, 17 Sep 2021 17:43:56 +0200
Message-Id: <397ebb9ec8440b9bb1b16184e975e46f95138f3a.1631889858.git.bristot@kernel.org>
In-Reply-To: <cover.1631889858.git.bristot@kernel.org>
References: <cover.1631889858.git.bristot@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=bristot@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Adds the basis for rtla documentation. It is based on libtracefs
Documentation as suggested by Steven Rostedt. This patch also
includes the rtla(1) man page.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Tom Zanussi <zanussi@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Clark Williams <williams@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
Cc: linux-rt-users@vger.kernel.org
Cc: linux-trace-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
---
 tools/tracing/rtla/Documentation/Makefile     | 223 ++++++++++++++++++
 .../tracing/rtla/Documentation/asciidoc.conf  | 118 +++++++++
 .../rtla/Documentation/manpage-base.xsl       |  35 +++
 .../rtla/Documentation/manpage-normal.xsl     |  13 +
 tools/tracing/rtla/Documentation/rtla.txt     |  56 +++++
 tools/tracing/rtla/Documentation/utils.mk     | 144 +++++++++++
 tools/tracing/rtla/Makefile                   |  20 +-
 7 files changed, 604 insertions(+), 5 deletions(-)
 create mode 100644 tools/tracing/rtla/Documentation/Makefile
 create mode 100644 tools/tracing/rtla/Documentation/asciidoc.conf
 create mode 100644 tools/tracing/rtla/Documentation/manpage-base.xsl
 create mode 100644 tools/tracing/rtla/Documentation/manpage-normal.xsl
 create mode 100644 tools/tracing/rtla/Documentation/rtla.txt
 create mode 100644 tools/tracing/rtla/Documentation/utils.mk

diff --git a/tools/tracing/rtla/Documentation/Makefile b/tools/tracing/rtla/Documentation/Makefile
new file mode 100644
index 000000000000..790e5c1afaeb
--- /dev/null
+++ b/tools/tracing/rtla/Documentation/Makefile
@@ -0,0 +1,223 @@
+# SPDX-License-Identifier: LGPL-2.1
+
+include utils.mk
+
+# This Makefile and manpage XSL files were taken from libtracefs
+# and modified
+
+
+MAN1_TXT= \
+	$(wildcard rtla-*.txt) \
+	rtla.txt
+
+MAN_TXT = $(MAN1_TXT)
+_MAN_XML=$(patsubst %.txt,%.xml,$(MAN_TXT))
+_MAN_HTML=$(patsubst %.txt,%.html,$(MAN_TXT))
+_DOC_MAN1=$(patsubst %.txt,%.m,$(MAN1_TXT))
+
+MAN_XML=$(addprefix $(OUTPUT),$(_MAN_XML))
+MAN_HTML=$(addprefix $(OUTPUT),$(_MAN_HTML))
+DOC_MAN1=$(addprefix $(OUTPUT),$(_DOC_MAN1))
+
+# Make the path relative to DESTDIR, not prefix
+ifndef DESTDIR
+prefix?=$(HOME)
+endif
+bindir?=$(prefix)/bin
+htmldir?=$(prefix)/share/doc/rtla-doc
+pdfdir?=$(prefix)/share/doc/rtla-doc
+mandir?=$(prefix)/share/man
+man1dir=$(mandir)/man1
+
+ASCIIDOC=asciidoc
+ASCIIDOC_EXTRA = --unsafe -f asciidoc.conf
+ASCIIDOC_HTML = xhtml11
+MANPAGE_XSL = manpage-normal.xsl
+XMLTO_EXTRA = --skip-validation
+INSTALL?=install
+RM ?= rm -f
+
+ifdef USE_ASCIIDOCTOR
+ASCIIDOC = asciidoctor
+ASCIIDOC_EXTRA = -a compat-mode
+ASCIIDOC_EXTRA += -I. -rasciidoctor-extensions
+ASCIIDOC_EXTRA += -a mansource="rtla" -a manmanual="rtla Manual"
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
+ASCIIDOC_EXTRA += -a rtla-asciidoc-no-roff
+MANPAGE_XSL = manpage-1.72.xsl
+else
+	ifdef ASCIIDOC_NO_ROFF
+	# docbook-xsl after 1.72 needs the regular XSL, but will not
+	# pass-thru raw roff codes from asciidoc.conf, so turn them off.
+	ASCIIDOC_EXTRA += -a rtla-asciidoc-no-roff
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
+all: check-man-tools html man1
+
+man: man1
+man1: $(DOC_MAN1)
+
+html: $(MAN_HTML) $(MAN1_HTML)
+
+$(MAN_HTML) $(MAN1_HTML) $(DOC_MAN1): asciidoc.conf
+
+install: check-man-tools install-man install-html
+
+check-man-tools:
+ifdef missing_tools
+	$(error "You need to install $(missing_tools) for man pages")
+endif
+
+install-%.1: $(OUTPUT)%.1
+	$(Q)$(call do_install,$<,$(man1dir),644);
+
+do-install-man: man $(addprefix install-,$(wildcard $(OUTPUT)*.1))
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
+	$(Q)$(RM) $(addprefix $(DESTDIR)$(man1dir)/,$(DOC_MAN1))
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
+	$(DOC_MAN1) *.1 *.m
+
+clean:
+	$(Q) $(RM) $(CLEAN_FILES)
+
+ifdef USE_ASCIIDOCTOR
+$(OUTPUT)%.1 : $(OUTPUT)%.txt.1
+	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
+	$(ASCIIDOC) -b manpage -d manpage \
+		$(ASCIIDOC_EXTRA) -artla_version=$(TRACEFS_VERSION) -o $@+ $< && \
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
+		$(ASCIIDOC_EXTRA) -artla_version=$(TRACEFS_VERSION) -o $@+ $< && \
+	mv $@+ $@
+
+$(OUTPUT)%.xml : %.txt.1
+	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
+	$(ASCIIDOC) -b docbook -d manpage \
+		$(ASCIIDOC_EXTRA) -artla_version=$(TRACEFS_VERSION) -o $@+ $< && \
+	mv $@+ $@
+
+$(MAN_HTML): $(OUTPUT)%.html : %.txt
+	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
+	$(ASCIIDOC) -b $(ASCIIDOC_HTML) -d manpage \
+		$(ASCIIDOC_EXTRA) -artla_version=$(TRACEFS_VERSION) -o $@+ $< && \
+	mv $@+ $@
+
+$(MAN1_HTML): $(OUTPUT)%.html : %.txt.1
+	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
+	$(ASCIIDOC) -b $(ASCIIDOC_HTML) -d manpage \
+		$(ASCIIDOC_EXTRA) -artla_version=$(TRACEFS_VERSION) -o $@+ $< && \
+	mv $@+ $@
diff --git a/tools/tracing/rtla/Documentation/asciidoc.conf b/tools/tracing/rtla/Documentation/asciidoc.conf
new file mode 100644
index 000000000000..40678f1ab901
--- /dev/null
+++ b/tools/tracing/rtla/Documentation/asciidoc.conf
@@ -0,0 +1,118 @@
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
+endif::doctype-manpage[]
+|
+ifdef::doctype-manpage[]
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
+<refmiscinfo class="source">rtla</refmiscinfo>
+<refmiscinfo class="version">{rtla_version}</refmiscinfo>
+<refmiscinfo class="manual">RTLA Manual</refmiscinfo>
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
diff --git a/tools/tracing/rtla/Documentation/manpage-base.xsl b/tools/tracing/rtla/Documentation/manpage-base.xsl
new file mode 100644
index 000000000000..a264fa616093
--- /dev/null
+++ b/tools/tracing/rtla/Documentation/manpage-base.xsl
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
diff --git a/tools/tracing/rtla/Documentation/manpage-normal.xsl b/tools/tracing/rtla/Documentation/manpage-normal.xsl
new file mode 100644
index 000000000000..a48f5b11f3dc
--- /dev/null
+++ b/tools/tracing/rtla/Documentation/manpage-normal.xsl
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
diff --git a/tools/tracing/rtla/Documentation/rtla.txt b/tools/tracing/rtla/Documentation/rtla.txt
new file mode 100644
index 000000000000..bc02aeb35d04
--- /dev/null
+++ b/tools/tracing/rtla/Documentation/rtla.txt
@@ -0,0 +1,56 @@
+rtla(1)
+=======
+
+NAME
+----
+rtla - Real-time Linux Analysis tool
+
+SYNOPSIS
+--------
+*rtla* COMMAND [OPTIONS]
+
+DESCRIPTION
+-----------
+The rtla(1) is a meta-tool that includes a set of commands that aims to
+analyze the real-time properties of Linux. But instead of testing Linux
+as a black box, rtla leverages kernel tracing capabilities to provide
+precise information about the properties and root causes of unexpected
+results.
+
+COMMANDS
+--------
+*osnoise*::
+Gives information about the operating system noise (osnoise).
+*timerlat*::
+Measures the irq and thread timerlat latency.
+
+OPTIONS
+-------
+*-h*, --help
+	Display the help text.
+
+For other options, see the man page for the corresponding command.
+
+SEE ALSO
+--------
+_rtla-osnoise(1)_, _rtla-timerlat(1)_.
+
+AUTHOR
+------
+Daniel Bristot de Oliveira <bristot@kernel.org>.
+
+REPORTING BUGS
+--------------
+Report bugs to <lkml@vger.kernel.org>.
+
+LICENSE
+-------
+rtla is Free Software licensed under the GNU GPLv2.
+
+RESOURCES
+---------
+
+COPYING
+-------
+Copyright \(C) 2021 Red Hat, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
diff --git a/tools/tracing/rtla/Documentation/utils.mk b/tools/tracing/rtla/Documentation/utils.mk
new file mode 100644
index 000000000000..32a9b3c5b0e2
--- /dev/null
+++ b/tools/tracing/rtla/Documentation/utils.mk
@@ -0,0 +1,144 @@
+# SPDX-License-Identifier: LGPL-2.1
+
+# Utils
+
+ GOBJ		= $(notdir $(strip $@))
+
+
+ifeq ($(VERBOSE),1)
+  Q =
+  S =
+else
+  Q = @
+  S = -s
+endif
+
+# Use empty print_* macros if either SILENT or VERBOSE.
+ifeq ($(findstring 1,$(SILENT)$(VERBOSE)),1)
+  print_compile =
+  print_app_build =
+  print_fpic_compile =
+  print_shared_lib_compile =
+  print_plugin_obj_compile =
+  print_plugin_build =
+  print_install =
+  print_uninstall =
+  print_update =
+else
+  print_compile =		echo '  COMPILE            '$(GOBJ);
+  print_app_build =		echo '  BUILD              '$(GOBJ);
+  print_fpic_compile =		echo '  COMPILE FPIC       '$(GOBJ);
+  print_shared_lib_compile =	echo '  COMPILE SHARED LIB '$(GOBJ);
+  print_plugin_obj_compile =	echo '  COMPILE PLUGIN OBJ '$(GOBJ);
+  print_plugin_build =		echo '  BUILD PLUGIN       '$(GOBJ);
+  print_static_lib_build =	echo '  BUILD STATIC LIB   '$(GOBJ);
+  print_install =		echo '  INSTALL     '$1'	to	$(DESTDIR_SQ)$2';
+  print_uninstall =		echo '  UNINSTALL     $(DESTDIR_SQ)$1';
+  print_update =		echo '  UPDATE             '$(GOBJ);
+endif
+
+do_fpic_compile =					\
+	($(print_fpic_compile)				\
+	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(EXT) -fPIC $< -o $@)
+
+do_compile =							\
+	($(if $(GENERATE_PIC), $(do_fpic_compile),		\
+	 $(print_compile)					\
+	 $(CC) -c $(CPPFLAGS) $(CFLAGS) $(EXT) $< -o $@))
+
+do_app_build =						\
+	($(print_app_build)				\
+	$(CC) $^ -rdynamic -o $@ $(LDFLAGS) $(CONFIG_LIBS) $(LIBS))
+
+do_build_static_lib =				\
+	($(print_static_lib_build)		\
+	$(RM) $@;  $(AR) rcs $@ $^)
+
+do_compile_shared_library =			\
+	($(print_shared_lib_compile)		\
+	$(CC) --shared $^ '-Wl,-soname,$(1),-rpath=$$ORIGIN' -o $@ $(LIBS))
+
+do_compile_plugin_obj =				\
+	($(print_plugin_obj_compile)		\
+	$(CC) -c $(CPPFLAGS) $(CFLAGS) -fPIC -o $@ $<)
+
+do_plugin_build =				\
+	($(print_plugin_build)			\
+	$(CC) $(CFLAGS) $(LDFLAGS) -shared -nostartfiles -o $@ $<)
+
+do_compile_python_plugin_obj =			\
+	($(print_plugin_obj_compile)		\
+	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(PYTHON_DIR_SQ) $(PYTHON_INCLUDES) -fPIC -o $@ $<)
+
+do_python_plugin_build =			\
+	($(print_plugin_build)			\
+	$(CC) $< -shared $(LDFLAGS) $(PYTHON_LDFLAGS) -o $@)
+
+define make_version.h
+	(echo '/* This file is automatically generated. Do not modify. */';		\
+	echo \#define VERSION_CODE $(shell						\
+	expr $(VERSION) \* 256 + $(PATCHLEVEL));					\
+	echo '#define EXTRAVERSION ' $(EXTRAVERSION);					\
+	echo '#define VERSION_STRING "'$(VERSION).$(PATCHLEVEL).$(EXTRAVERSION)'"';	\
+	echo '#define FILE_VERSION '$(FILE_VERSION);					\
+	if [ -d $(src)/.git ]; then							\
+	  d=`git diff`;									\
+	  x="";										\
+	  if [ ! -z "$$d" ]; then x="+"; fi;						\
+	  echo '#define VERSION_GIT "'$(shell 						\
+		git log -1 --pretty=format:"%H" 2>/dev/null)$$x'"';			\
+	else										\
+	  echo '#define VERSION_GIT "not-a-git-repo"';					\
+	fi										\
+	) > $1
+endef
+
+define update_version.h
+	($(call make_version.h, $@.tmp);				\
+	if [ -r $@ ] && cmp -s $@ $@.tmp; then				\
+		rm -f $@.tmp;						\
+	else								\
+		$(print_update)						\
+		mv -f $@.tmp $@;					\
+	fi);
+endef
+
+define update_dir
+	(echo $1 > $@.tmp;	\
+	if [ -r $@ ] && cmp -s $@ $@.tmp; then				\
+		rm -f $@.tmp;						\
+	else								\
+		$(print_update)						\
+		mv -f $@.tmp $@;					\
+	fi);
+endef
+
+define build_prefix
+	(echo $1 > $@.tmp;	\
+	if [ -r $@ ] && cmp -s $@ $@.tmp; then				\
+		rm -f $@.tmp;						\
+	else								\
+		$(print_update)						\
+		mv -f $@.tmp $@;					\
+	fi);
+endef
+
+define do_install_mkdir
+	if [ ! -d '$(DESTDIR_SQ)$1' ]; then		\
+		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$1';	\
+	fi
+endef
+
+define do_install
+	$(print_install)				\
+	$(call do_install_mkdir,$2);			\
+	$(INSTALL) $(if $3,-m $3,) $1 '$(DESTDIR_SQ)$2'
+endef
+
+define do_install_pkgconfig_file
+	if [ -n "${pkgconfig_dir}" ]; then 					\
+		$(call do_install,$(PKG_CONFIG_FILE),$(pkgconfig_dir),644); 	\
+	else 									\
+		(echo Failed to locate pkg-config directory) 1>&2;		\
+	fi
+endef
diff --git a/tools/tracing/rtla/Makefile b/tools/tracing/rtla/Makefile
index 580a33db6645..9a914391e507 100644
--- a/tools/tracing/rtla/Makefile
+++ b/tools/tracing/rtla/Makefile
@@ -17,7 +17,7 @@ LIBS	:=	-ltracefs -ltraceevent -lpthread -lprocps
 SRC	:=	$(wildcard src/*.c)
 HDR	:=	$(wildcard src/*.h)
 OBJ	:=	$(SRC:.c=.o)
-DIRS	:=	src
+DIRS	:=	src Documentation
 FILES	:=	Makefile
 CEXT	:=	bz2
 TARBALL	:=	$(NAME)-$(VERSION).tar.$(CEXT)
@@ -27,19 +27,20 @@ DATADIR	:=	/usr/share
 DOCDIR	:=	$(DATADIR)/doc
 MANDIR	:=	$(DATADIR)/man
 LICDIR	:=	$(DATADIR)/licenses
+SRCTREE	:=	$(if $(BUILD_SRC),$(BUILD_SRC),$(CURDIR))
 
 .PHONY:	all tests
 
 all:	rtla
 
-rtla: $(OBJ)
+rtla: $(OBJ) doc
 	$(CC) -o rtla $(LDFLAGS) $(OBJ) $(LIBS)
 
 static: $(OBJ)
 	$(CC) -o rtla-static $(LDFLAGS) --static $(OBJ) $(LIBS) -lpthread -ldl
 
 .PHONY: install
-install:
+install: doc_install
 	$(INSTALL) rtla -m 755 $(DESTDIR)$(BINDIR)
 	@test ! -f $(DESTDIR)$(BINDIR)/osnoise || rm $(DESTDIR)$(BINDIR)/osnoise
 	ln -s $(DESTDIR)$(BINDIR)/rtla $(DESTDIR)$(BINDIR)/osnoise
@@ -47,15 +48,24 @@ install:
 	ln -s $(DESTDIR)$(BINDIR)/rtla $(DESTDIR)$(BINDIR)/timerlat
 
 .PHONY: clean tarball push
-clean:
+clean: doc_clean
 	@test ! -f rtla || rm rtla
 	@test ! -f rtla-static || rm rtla-static
 	@test ! -f src/rtla.o || rm src/rtla.o
 	@test ! -f $(TARBALL) || rm -f $(TARBALL)
 	@rm -rf *~ $(OBJ) *.tar.$(CEXT)
 
-tarball:  clean
+tarball: clean
 	rm -rf $(NAME)-$(VERSION) && mkdir $(NAME)-$(VERSION)
 	cp -r $(DIRS) $(FILES) $(NAME)-$(VERSION)
 	tar $(TAROPTS) --exclude='*~' $(NAME)-$(VERSION)
 	rm -rf $(NAME)-$(VERSION)
+
+doc:
+	$(MAKE) -C $(SRCTREE)/Documentation all
+
+doc_clean:
+	$(MAKE) -C $(SRCTREE)/Documentation clean
+
+doc_install:
+	$(MAKE) -C $(SRCTREE)/Documentation install
-- 
2.31.1


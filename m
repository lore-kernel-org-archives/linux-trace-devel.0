Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CC5BC2BB40
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Dec 2020 09:47:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C21472360D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Dec 2020 09:47:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727767AbgLQJrN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Dec 2020 04:47:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727739AbgLQJrM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Dec 2020 04:47:12 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20DEFC061257
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Dec 2020 01:46:32 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id 3so5100641wmg.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Dec 2020 01:46:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VFdNetmN7ITxyWUYJyx0xsFQ+qKI6Dx3bamkH9fsy/Y=;
        b=Sd5JlK1IGnsM+/DKDTIuAQhwy44V7tSqc8+tkizAHtvVJR1h3AOSqsXiskpTLXtFl8
         6g33xCE4icDsyl17yQyztnq3REMo/Hp8o+nSUQXM6/8jy5a9XOvwN0p6rUip6w30IXVz
         Gb1WsdQc6yrcxW7liF+SX5DoRThhnHZggQM7HAB/fgGGv3jhuUfSBMnLpUMyeLdjEycf
         HTK4VBQpiohTkrySczkd13eGSzoqxcJ+tH0ydtr8HOqSSHO8hIoCSkrR4xQ9rnqQK3tZ
         Snmddab8mc4cTB/GDc26yX45J5EINI+v0NrFZzbeOHVF8xp66sRtrpPoRuw9upLIqbk2
         pS7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VFdNetmN7ITxyWUYJyx0xsFQ+qKI6Dx3bamkH9fsy/Y=;
        b=gM7IMEjjkqFkhgElFmmM66NYFnpIV5EX6UD2uNIVONqLUfKU0S6bcAZDgcQwQNN92C
         KxJohMnoDXojd6uzgWhT24nV4pYvZO6vho8ucLfYaZkRsT0aqXRHENYH1ux/5mzFRJmH
         gW/cehr/AJrk5AQKAiAxy/nhPUgSS8fXAabkAA0kMQNL1o+npmSmUyz6PqeDKMDGs2t9
         rUdWQr4bf/otHW0phuYVS4S4rk/cgs/Sl9LvKH3ZFsvxHtl//nsUAmP3JlNUz2PTzsWA
         x7JqyUwrIOpHifcfInDWPTF8G+VNfI81xeoOpLrjc2Iydfg3u6yAO19z3U+TN4QZ4E7z
         yQ/g==
X-Gm-Message-State: AOAM532yHydTHobJz6SXSlwFG3uwpVI4K7BgyEAS1Xgz4oJ+yUUCyIML
        wBxGUkfcDx5skECbO69hIqM=
X-Google-Smtp-Source: ABdhPJwvNU6d7W4/NoiqV6uCbR+5O7H8XPb0tQM/wBsK8TQjCNSPBulV6EkFERKSqFx9Gxw/sID6tQ==
X-Received: by 2002:a1c:4e0a:: with SMTP id g10mr7544727wmh.88.1608198390751;
        Thu, 17 Dec 2020 01:46:30 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id o125sm6773164wmo.30.2020.12.17.01.46.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Dec 2020 01:46:30 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/9] libtracefs: Initial support for man pages
Date:   Thu, 17 Dec 2020 11:46:19 +0200
Message-Id: <20201217094626.1402191-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201217094626.1402191-1-tz.stoyanov@gmail.com>
References: <20201217094626.1402191-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Basic infrastructure for libtracefs man pages and the first man page:
 man libtracefs
with list of all library APIs.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/Makefile                 | 211 +++++++++++++++++++++++++
 Documentation/asciidoc.conf            | 120 ++++++++++++++
 Documentation/libtracefs.txt           |  86 ++++++++++
 Documentation/manpage-1.72.xsl         |  14 ++
 Documentation/manpage-base.xsl         |  35 ++++
 Documentation/manpage-bold-literal.xsl |  17 ++
 Documentation/manpage-normal.xsl       |  13 ++
 Documentation/manpage-suppress-sp.xsl  |  21 +++
 8 files changed, 517 insertions(+)
 create mode 100644 Documentation/Makefile
 create mode 100644 Documentation/asciidoc.conf
 create mode 100644 Documentation/libtracefs.txt
 create mode 100644 Documentation/manpage-1.72.xsl
 create mode 100644 Documentation/manpage-base.xsl
 create mode 100644 Documentation/manpage-bold-literal.xsl
 create mode 100644 Documentation/manpage-normal.xsl
 create mode 100644 Documentation/manpage-suppress-sp.xsl

diff --git a/Documentation/Makefile b/Documentation/Makefile
new file mode 100644
index 0000000..e9212df
--- /dev/null
+++ b/Documentation/Makefile
@@ -0,0 +1,211 @@
+# SPDX-License-Identifier: LGPL-2.1
+
+include $(src)/scripts/utils.mk
+
+
+# This Makefile and manpage XSL files were taken from libtraceevent
+# and modified for libtracefs.
+
+MAN3_TXT= \
+	$(wildcard libtracefs-*.txt) \
+	libtracefs.txt
+
+MAN_TXT = $(MAN3_TXT)
+_MAN_XML=$(patsubst %.txt,%.xml,$(MAN_TXT))
+_MAN_HTML=$(patsubst %.txt,%.html,$(MAN_TXT))
+_DOC_MAN3=$(patsubst %.txt,%.3,$(MAN3_TXT))
+
+MAN_XML=$(addprefix $(OUTPUT),$(_MAN_XML))
+MAN_HTML=$(addprefix $(OUTPUT),$(_MAN_HTML))
+DOC_MAN3=$(addprefix $(OUTPUT),$(_DOC_MAN3))
+
+# Make the path relative to DESTDIR, not prefix
+ifndef DESTDIR
+prefix?=$(HOME)
+endif
+bindir?=$(prefix)/bin
+htmldir?=$(prefix)/share/doc/libtracefs-doc
+pdfdir?=$(prefix)/share/doc/libtracefs-doc
+mandir?=$(prefix)/share/man
+man3dir=$(mandir)/man3
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
+ASCIIDOC_EXTRA += -a mansource="libtracefs" -a manmanual="libtracefs Manual"
+ASCIIDOC_HTML = xhtml5
+endif
+
+XMLTO=xmlto
+
+_tmp_tool_path := $(call get-executable,$(ASCIIDOC))
+ifeq ($(_tmp_tool_path),)
+	missing_tools = $(ASCIIDOC)
+endif
+
+ifndef USE_ASCIIDOCTOR
+_tmp_tool_path := $(call get-executable,$(XMLTO))
+ifeq ($(_tmp_tool_path),)
+	missing_tools += $(XMLTO)
+endif
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
+ASCIIDOC_EXTRA += -a libtracefs-asciidoc-no-roff
+MANPAGE_XSL = manpage-1.72.xsl
+else
+	ifdef ASCIIDOC_NO_ROFF
+	# docbook-xsl after 1.72 needs the regular XSL, but will not
+	# pass-thru raw roff codes from asciidoc.conf, so turn them off.
+	ASCIIDOC_EXTRA += -a libtracefs-asciidoc-no-roff
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
+all: html man
+
+man: man3
+man3: $(DOC_MAN3)
+
+html: $(MAN_HTML)
+
+$(MAN_HTML) $(DOC_MAN3): asciidoc.conf
+
+install: install-man install-html
+
+check-man-tools:
+ifdef missing_tools
+	$(error "You need to install $(missing_tools) for man pages")
+endif
+
+do-install-man: man
+	$(call QUIET_INSTALL, Documentation-man) \
+		$(INSTALL) -d -m 755 $(DESTDIR)$(man3dir); \
+		$(INSTALL) -m 644 $(OUTPUT)*.3 $(DESTDIR)$(man3dir);
+
+install-man: check-man-tools man do-install-man
+
+do-install-html: html
+	$(call QUIET_INSTALL, Documentation-html) \
+		$(INSTALL) -d -m 755 $(DESTDIR)$(htmldir); \
+		$(INSTALL) -m 644 $(OUTPUT)*.html $(DESTDIR)$(htmldir);
+
+install-html: check-man-tools html do-install-html
+
+uninstall: uninstall-man uninstall-html
+
+uninstall-man:
+	$(call QUIET_UNINST, Documentation-man) \
+		$(Q)$(RM) $(addprefix $(DESTDIR)$(man3dir)/,$(DOC_MAN3))
+
+uninstall-html:
+	$(call QUIET_UNINST, Documentation-html) \
+		$(Q)$(RM) $(addprefix $(DESTDIR)$(htmldir)/,$(MAN_HTML))
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
+	$(DOC_MAN3) *.3
+
+clean:
+	$(call QUIET_CLEAN, Documentation) $(RM) $(CLEAN_FILES)
+
+ifdef USE_ASCIIDOCTOR
+$(OUTPUT)%.3 : $(OUTPUT)%.txt
+	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
+	$(ASCIIDOC) -b manpage -d manpage \
+		$(ASCIIDOC_EXTRA) -alibtraceevent_version=$(EVENT_PARSE_VERSION) -o $@+ $< && \
+	mv $@+ $@
+endif
+
+$(OUTPUT)%.3 : $(OUTPUT)%.xml
+	$(QUIET_XMLTO)$(RM) $@ && \
+	$(XMLTO) -o $(OUTPUT). -m $(MANPAGE_XSL) $(XMLTO_EXTRA) man $<
+
+$(OUTPUT)%.xml : %.txt
+	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
+	$(ASCIIDOC) -b docbook -d manpage \
+		$(ASCIIDOC_EXTRA) -alibtraceevent_version=$(EVENT_PARSE_VERSION) -o $@+ $< && \
+	mv $@+ $@
+
+$(MAN_HTML): $(OUTPUT)%.html : %.txt
+	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
+	$(ASCIIDOC) -b $(ASCIIDOC_HTML) -d manpage \
+		$(ASCIIDOC_EXTRA) -aperf_version=$(EVENT_PARSE_VERSION) -o $@+ $< && \
+	mv $@+ $@
diff --git a/Documentation/asciidoc.conf b/Documentation/asciidoc.conf
new file mode 100644
index 0000000..0759571
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
+<refmiscinfo class="source">libtraceevent</refmiscinfo>
+<refmiscinfo class="version">{libtraceevent_version}</refmiscinfo>
+<refmiscinfo class="manual">libtraceevent Manual</refmiscinfo>
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
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
new file mode 100644
index 0000000..c7a4d54
--- /dev/null
+++ b/Documentation/libtracefs.txt
@@ -0,0 +1,86 @@
+libtracefs(3)
+=============
+
+NAME
+----
+libtracefs - Linux kernel trace file system library
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+*#include <event-parse.h>*
+
+Locations of tracing files and directories:
+	char pass:[*]*tracefs_get_tracing_file*(const char pass:[*]_name_);
+	void *tracefs_put_tracing_file*(char pass:[*]_name_);
+	const char pass:[*]*tracefs_get_tracing_dir*(void);
+	char pass:[*]*tracefs_find_tracing_dir*(void);
+
+Trace instances:
+	struct tracefs_instance pass:[*]*tracefs_instance_create*(const char pass:[*]_name_);
+	int *tracefs_instance_destroy*(struct tracefs_instance pass:[*]_instance_);
+	void *tracefs_instance_free*(struct tracefs_instance pass:[*]_instance_);
+	bool *tracefs_instance_is_new*(struct tracefs_instance pass:[*]_instance_);
+	bool *tracefs_file_exists*(struct tracefs_instance pass:[*]_instance_, char pass:[*]_name_);
+	bool *tracefs_dir_exists*(struct tracefs_instance pass:[*]_instance_, char pass:[*]_name_);
+	char pass:[*]*tracefs_instance_get_file*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_);
+	char pass:[*]*tracefs_instance_get_dir*(struct tracefs_instance pass:[*]_instance_);
+	int *tracefs_instance_file_write*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_, const char pass:[*]_str_);
+	char pass:[*]*tracefs_instance_file_read*(struct tracefs_instance pass:[*]_instance_, char pass:[*]_file_, int pass:[*]_psize_);
+	const char pass:[*]*tracefs_instance_get_name*(struct tracefs_instance pass:[*]_instance_);
+	int *tracefs_instances_walk*(int (pass:[*]_callback_)(const char pass:[*], void pass:[*]), void pass:[*]_context)_;
+	bool *tracefs_instance_exists*(const char pass:[*]_name_);
+
+Trace events:
+	char pass:[*]pass:[*]*tracefs_event_systems*(const char pass:[*]_tracing_dir_);
+	char pass:[*]pass:[*]*tracefs_system_events*(const char pass:[*]_tracing_dir_, const char pass:[*]_system_);
+	int *tracefs_iterate_raw_events*(struct tep_handle pass:[*]_tep_, struct tracefs_instance pass:[*]_instance_, cpu_set_t pass:[*]_cpus_, int _cpu_size_, int (pass:[*]_callback_)(struct tep_event pass:[*], struct tep_record pass:[*], int, void pass:[*]), void pass:[*]_callback_context_);
+	struct tep_handle pass:[*]*tracefs_local_events*(const char pass:[*]_tracing_dir_);
+	struct tep_handle pass:[*]*tracefs_local_events_system*(const char pass:[*]_tracing_dir_, const char pass:[*] const pass:[*]_sys_names_);
+	int *tracefs_fill_local_events*(const char pass:[*]_tracing_dir_, struct tep_handle pass:[*]_tep_, int pass:[*]_parsing_failures_);
+
+Trace helper functions:
+	void *tracefs_list_free*(char pass:[*]pass:[*]_list_);
+	char pass:[*]pass:[*]*tracefs_tracers*(const char pass:[*]_tracing_dir_);
+	char pass:[*]*tracefs_get_clock*(struct tracefs_instance pass:[*]_instance_);
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
+*tracefs.h*
+	Header file to include in order to have access to the library APIs.
+*-ltracefs*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+_libtraceevent(3)_
+_trace-cmd(1)_
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>
+*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>
+--
+REPORTING BUGS
+--------------
+Report bugs to  <linux-trace-devel@vger.kernel.org>
+
+LICENSE
+-------
+libtracefs is Free Software licensed under the GNU LGPL 2.1
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
\ No newline at end of file
diff --git a/Documentation/manpage-1.72.xsl b/Documentation/manpage-1.72.xsl
new file mode 100644
index 0000000..b4d315c
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
index 0000000..a264fa6
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
index 0000000..608eb5d
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
index 0000000..a48f5b1
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
index 0000000..a63c763
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
-- 
2.28.0


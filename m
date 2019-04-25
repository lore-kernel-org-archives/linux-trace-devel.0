Return-Path: <SRS0=Y1eu=S3=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4419C43218
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Apr 2019 14:47:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4EE3204FD
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Apr 2019 14:47:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbfDYOrT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Apr 2019 10:47:19 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34245 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbfDYOrS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Apr 2019 10:47:18 -0400
Received: by mail-wr1-f67.google.com with SMTP id c6so25027764wrm.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Apr 2019 07:47:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DsrHFtQz2DN7dtg23ov/puOMDJbjGJjEFsSAebcSuqQ=;
        b=LEAnLJT4ogvBJPrnMnxiLLc6+c+UsIRIF4OTQ/66irGDDYyNGl1+ReHkY7jjeuJeuL
         cM4dLF1YScyMCbzqOdmhR73RlvVnwVA32VkIs5dRAlDPUjmZqx6OOaLFqrOUQS/STA6v
         GPMku3nFuQgCEowKJv/p/vbgRXq0dCGcGB26b28jP0TbPqL2fT0a7BpA1EmjQWo6I8VP
         MsVplNgu3GSjJZSct08su1dudixItpji2tn66BqV0obo7sIz6WdsHgM4TV+sL4HAZBfw
         eyrR+8hIQ/IIzwoB17KsknkRYidBIg/B34OX996U0NeaQh92xRwGSaTqeeIwZjbfTikl
         mGmw==
X-Gm-Message-State: APjAAAUHrhIDtO+Tlmlh5dKIcmeNr2hVTD4lQ2yeVhiHQGJjQ0BAgdBg
        UVGD2QGr8r/f5GBX3R48LQjTDhqI
X-Google-Smtp-Source: APXvYqxEWrTZWw8fTjoViIlVSFj/0Vk7pQr7YPPzTXvHWXIZBQ2tWvyr/HScnx6CxoiF6/EVmsuRRQ==
X-Received: by 2002:adf:ed4c:: with SMTP id u12mr877540wro.245.1556203634266;
        Thu, 25 Apr 2019 07:47:14 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 6sm13723879wra.85.2019.04.25.07.47.13
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 25 Apr 2019 07:47:13 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6] tools/lib/traceevent: Implement libtraceevent man pages
Date:   Thu, 25 Apr 2019 17:47:12 +0300
Message-Id: <20190425144712.21098-1-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190424162700.11318f32@gandalf.local.home>
References: <20190424162700.11318f32@gandalf.local.home>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Initial support for libtraceevent man pages - Documentation directory,
templates, configurations, Makefiles. The first man page is also part
of the patch - summary of the library and all its APIs. Building of
the documentation is integrated into the libtraceevent build process,
new targets are added to its Makefile:
make help
make doc
make doc-clean
make doc-install
make doc-uninstall

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tools/lib/traceevent/Documentation/Makefile   | 208 ++++++++++++++++++
 .../traceevent/Documentation/asciidoc.conf    |  91 ++++++++
 .../Documentation/libtraceevent.txt           | 203 +++++++++++++++++
 .../traceevent/Documentation/manpage-1.72.xsl |  14 ++
 .../traceevent/Documentation/manpage-base.xsl |  35 +++
 .../Documentation/manpage-bold-literal.xsl    |  17 ++
 .../Documentation/manpage-normal.xsl          |  13 ++
 .../Documentation/manpage-suppress-sp.xsl     |  21 ++
 tools/lib/traceevent/Makefile                 |  33 +++
 9 files changed, 635 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/Makefile
 create mode 100644 tools/lib/traceevent/Documentation/asciidoc.conf
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent.txt
 create mode 100644 tools/lib/traceevent/Documentation/manpage-1.72.xsl
 create mode 100644 tools/lib/traceevent/Documentation/manpage-base.xsl
 create mode 100644 tools/lib/traceevent/Documentation/manpage-bold-literal.xsl
 create mode 100644 tools/lib/traceevent/Documentation/manpage-normal.xsl
 create mode 100644 tools/lib/traceevent/Documentation/manpage-suppress-sp.xsl

diff --git a/tools/lib/traceevent/Documentation/Makefile b/tools/lib/traceevent/Documentation/Makefile
new file mode 100644
index 000000000000..680a9771067f
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/Makefile
@@ -0,0 +1,208 @@
+include ../../../scripts/Makefile.include
+include ../../../scripts/utilities.mak
+
+# This Makefile and manpage XSL files were taken from tools/perf/Documentation
+# and modified for libtraceevent.
+
+MAN3_TXT= \
+	$(wildcard libtraceevent-*.txt) \
+	libtraceevent.txt
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
+htmldir?=$(prefix)/share/doc/libtraceevent-doc
+pdfdir?=$(prefix)/share/doc/libtraceevent-doc
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
+ASCIIDOC_EXTRA += -a mansource="libtraceevent" -a manmanual="libtraceevent Manual"
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
+ASCIIDOC_EXTRA += -a libtraceevent-asciidoc-no-roff
+MANPAGE_XSL = manpage-1.72.xsl
+else
+	ifdef ASCIIDOC_NO_ROFF
+	# docbook-xsl after 1.72 needs the regular XSL, but will not
+	# pass-thru raw roff codes from asciidoc.conf, so turn them off.
+	ASCIIDOC_EXTRA += -a libtraceevent-asciidoc-no-roff
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
+#
+# Please note that there is a minor bug in asciidoc.
+# The version after 6.0.3 _will_ include the patch found here:
+#   http://marc.theaimsgroup.com/?l=libtraceevent&m=111558757202243&w=2
+#
+# Until that version is released you may have to apply the patch
+# yourself - yes, all 6 characters of it!
+#
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
+install: install-man
+
+check-man-tools:
+ifdef missing_tools
+	$(error "You need to install $(missing_tools) for man pages")
+endif
+
+do-install-man: man
+	$(call QUIET_INSTALL, Documentation-man) \
+		$(INSTALL) -d -m 755 $(DESTDIR)$(man3dir); \
+		$(INSTALL) -m 644 $(DOC_MAN3) $(DESTDIR)$(man3dir);
+
+install-man: check-man-tools man do-install-man
+
+uninstall: uninstall-man
+
+uninstall-man:
+	$(call QUIET_UNINST, Documentation-man) \
+		$(Q)$(RM) $(addprefix $(DESTDIR)$(man3dir)/,$(DOC_MAN3))
+
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
+
diff --git a/tools/lib/traceevent/Documentation/asciidoc.conf b/tools/lib/traceevent/Documentation/asciidoc.conf
new file mode 100644
index 000000000000..1b03c63fb73a
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/asciidoc.conf
@@ -0,0 +1,91 @@
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
+<refmiscinfo class="source">trace-cmd</refmiscinfo>
+<refmiscinfo class="version">{libtraceevent_version}</refmiscinfo>
+<refmiscinfo class="manual">trace-cmd Manual</refmiscinfo>
+</refmeta>
+<refnamediv>
+  <refname>{manname}</refname>
+  <refpurpose>{manpurpose}</refpurpose>
+</refnamediv>
+endif::backend-docbook[]
+endif::doctype-manpage[]
+
+ifdef::backend-xhtml11[]
+[linktep-inlinemacro]
+<a href="{target}.html">{target}{0?({0})}</a>
+endif::backend-xhtml11[]
diff --git a/tools/lib/traceevent/Documentation/libtraceevent.txt b/tools/lib/traceevent/Documentation/libtraceevent.txt
new file mode 100644
index 000000000000..d71fc61ea759
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent.txt
@@ -0,0 +1,203 @@
+libtraceevent(3)
+================
+
+NAME
+----
+libtraceevent - Linux kernel trace event library
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+Management of tep handler data structure and access of its members:
+	struct tep_handle pass:[*]*tep_alloc*(void);
+	void *tep_free*(struct tep_handle pass:[*]_tep_);
+	void *tep_ref*(struct tep_handle pass:[*]_tep_);
+	void *tep_unref*(struct tep_handle pass:[*]_tep_);
+	int *tep_ref_get*(struct tep_handle pass:[*]_tep_);
+	void *tep_set_flag*(struct tep_handle pass:[*]_tep_, enum tep_flag _flag_);
+	void *tep_clear_flag*(struct tep_handle pass:[*]_tep_, enum tep_flag _flag_);
+	bool *tep_test_flag*(struct tep_handle pass:[*]_tep_, enum tep_flag _flags_);
+	int *tep_get_cpus*(struct tep_handle pass:[*]_tep_);
+	void *tep_set_cpus*(struct tep_handle pass:[*]_tep_, int _cpus_);
+	int *tep_get_long_size*(strucqt tep_handle pass:[*]_tep_);
+	void *tep_set_long_size*(struct tep_handle pass:[*]_tep_, int _long_size_);
+	int *tep_get_page_size*(struct tep_handle pass:[*]_tep_);
+	void *tep_set_page_size*(struct tep_handle pass:[*]_tep_, int _page_size_);
+	bool *tep_is_latency_format*(struct tep_handle pass:[*]_tep_);
+	void *tep_set_latency_format*(struct tep_handle pass:[*]_tep_, int _lat_);
+	int *tep_get_header_page_size*(struct tep_handle pass:[*]_tep_);
+	int *tep_get_header_timestamp_size*(struct tep_handle pass:[*]_tep_);
+	bool *tep_is_old_format*(struct tep_handle pass:[*]_tep_);
+	int *tep_strerror*(struct tep_handle pass:[*]_tep_, enum tep_errno _errnum_, char pass:[*]_buf_, size_t _buflen_);
+
+Register / unregister APIs:
+	int *tep_register_trace_clock*(struct tep_handle pass:[*]_tep_, const char pass:[*]_trace_clock_);
+	int *tep_register_function*(struct tep_handle pass:[*]_tep_, char pass:[*]_name_, unsigned long long _addr_, char pass:[*]_mod_);
+	int *tep_register_event_handler*(struct tep_handle pass:[*]_tep_, int _id_, const char pass:[*]_sys_name_, const char pass:[*]_event_name_, tep_event_handler_func _func_, void pass:[*]_context_);
+	int *tep_unregister_event_handler*(struct tep_handle pass:[*]tep, int id, const char pass:[*]sys_name, const char pass:[*]event_name, tep_event_handler_func func, void pass:[*]_context_);
+	int *tep_register_print_string*(struct tep_handle pass:[*]_tep_, const char pass:[*]_fmt_, unsigned long long _addr_);
+	int *tep_register_print_function*(struct tep_handle pass:[*]_tep_, tep_func_handler _func_, enum tep_func_arg_type _ret_type_, char pass:[*]_name_, _..._);
+	int *tep_unregister_print_function*(struct tep_handle pass:[*]_tep_, tep_func_handler _func_, char pass:[*]_name_);
+
+Plugins management:
+	struct tep_plugin_list pass:[*]*tep_load_plugins*(struct tep_handle pass:[*]_tep_);
+	void *tep_unload_plugins*(struct tep_plugin_list pass:[*]_plugin_list_, struct tep_handle pass:[*]_tep_);
+	char pass:[*]pass:[*]*tep_plugin_list_options*(void);
+	void *tep_plugin_free_options_list*(char pass:[*]pass:[*]_list_);
+	int *tep_plugin_add_options*(const char pass:[*]_name_, struct tep_plugin_option pass:[*]_options_);
+	void *tep_plugin_remove_options*(struct tep_plugin_option pass:[*]_options_);
+	void *tep_print_plugins*(struct trace_seq pass:[*]_s_, const char pass:[*]_prefix_, const char pass:[*]_suffix_, const struct tep_plugin_list pass:[*]_list_);
+
+Event related APIs:
+	struct tep_event pass:[*]*tep_get_event*(struct tep_handle pass:[*]_tep_, int _index_);
+	struct tep_event pass:[*]*tep_get_first_event*(struct tep_handle pass:[*]_tep_);
+	int *tep_get_events_count*(struct tep_handle pass:[*]_tep_);
+	struct tep_event pass:[*]pass:[*]*tep_list_events*(struct tep_handle pass:[*]_tep_, enum tep_event_sort_type _sort_type_);
+	struct tep_event pass:[*]pass:[*]*tep_list_events_copy*(struct tep_handle pass:[*]_tep_, enum tep_event_sort_type _sort_type_);
+
+Event printing:
+	void *tep_print_event*(struct tep_handle pass:[*]_tep_, struct trace_seq pass:[*]_s_, struct tep_record pass:[*]_record_, bool _use_trace_clock_);
+	void *tep_print_event_data*(struct tep_handle pass:[*]_tep_, struct trace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, struct tep_record pass:[*]_record_);
+	void *tep_event_info*(struct trace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, struct tep_record pass:[*]_record_);
+	void *tep_print_event_task*(struct tep_handle pass:[*]_tep_, struct trace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, struct tep_record pass:[*]_record_);
+	void *tep_print_event_time*(struct tep_handle pass:[*]_tep_, struct trace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, struct tep_record pass:[*]record, bool _use_trace_clock_);
+	void *tep_set_print_raw*(struct tep_handle pass:[*]_tep_, int _print_raw_);
+
+Event finding:
+	struct tep_event pass:[*]*tep_find_event*(struct tep_handle pass:[*]_tep_, int _id_);
+	struct tep_event pass:[*]*tep_find_event_by_name*(struct tep_handle pass:[*]_tep_, const char pass:[*]_sys_, const char pass:[*]_name_);
+	struct tep_event pass:[*]*tep_find_event_by_record*(struct tep_handle pass:[*]_tep_, struct tep_record pass:[*]_record_);
+
+Parsing of event files:
+	int *tep_parse_header_page*(struct tep_handle pass:[*]_tep_, char pass:[*]_buf_, unsigned long _size_, int _long_size_);
+	enum tep_errno *tep_parse_event*(struct tep_handle pass:[*]_tep_, const char pass:[*]_buf_, unsigned long _size_, const char pass:[*]_sys_);
+	enum tep_errno *tep_parse_format*(struct tep_handle pass:[*]_tep_, struct tep_event pass:[*]pass:[*]_eventp_, const char pass:[*]_buf_, unsigned long _size_, const char pass:[*]_sys_);
+
+APIs related to fields from event's format files:
+	struct tep_format_field pass:[*]pass:[*]*tep_event_common_fields*(struct tep_event pass:[*]_event_);
+	struct tep_format_field pass:[*]pass:[*]*tep_event_fields*(struct tep_event pass:[*]_event_);
+	void pass:[*]*tep_get_field_raw*(struct trace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_record_, int pass:[*]_len_, int _err_);
+	int *tep_get_field_val*(struct trace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_record_, unsigned long long pass:[*]_val_, int _err_);
+	int *tep_get_common_field_val*(struct trace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_record_, unsigned long long pass:[*]_val_, int _err_);
+	int *tep_get_any_field_val*(struct trace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_record_, unsigned long long pass:[*]_val_, int _err_);
+	int *tep_read_number_field*(struct tep_format_field pass:[*]_field_, const void pass:[*]_data_, unsigned long long pass:[*]_value_);
+
+Event fields printing:
+	void *tep_print_field*(struct trace_seq pass:[*]_s_, void pass:[*]_data_, struct tep_format_field pass:[*]_field_);
+	void *tep_print_fields*(struct trace_seq pass:[*]_s_, void pass:[*]_data_, int _size_, struct tep_event pass:[*]_event_);
+	int *tep_print_num_field*(struct trace_seq pass:[*]_s_, const char pass:[*]_fmt_, struct tep_event pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_record_, int _err_);
+	int *tep_print_func_field*(struct trace_seq pass:[*]_s_, const char pass:[*]_fmt_, struct tep_event pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_record_, int _err_);
+
+Event fields finding:
+	struct tep_format_field pass:[*]*tep_find_common_field*(struct tep_event pass:[*]_event_, const char pass:[*]_name_);
+	struct tep_format_field pass:[*]*tep_find_field*(struct tep_event_ormat pass:[*]_event_, const char pass:[*]_name_);
+	struct tep_format_field pass:[*]*tep_find_any_field*(struct tep_event pass:[*]_event_, const char pass:[*]_name_);
+
+Functions resolver:
+	int *tep_set_function_resolver*(struct tep_handle pass:[*]_tep_, tep_func_resolver_t pass:[*]_func_, void pass:[*]_priv_);
+	void *tep_reset_function_resolver*(struct tep_handle pass:[*]_tep_);
+	const char pass:[*]*tep_find_function*(struct tep_handle pass:[*]_tep_, unsigned long long _addr_);
+	unsigned long long *tep_find_function_address*(struct tep_handle pass:[*]_tep_, unsigned long long _addr_);
+
+Filter management:
+	struct tep_event_filter pass:[*]*tep_filter_alloc*(struct tep_handle pass:[*]_tep_);
+	enum tep_errno *tep_filter_add_filter_str*(struct tep_event_filter pass:[*]_filter_, const char pass:[*]_filter_str_);
+	enum tep_errno *tep_filter_match*(struct tep_event_filter pass:[*]_filter_, struct tep_record pass:[*]_record_);
+	int *tep_filter_strerror*(struct tep_event_filter pass:[*]_filter_, enum tep_errno _err_, char pass:[*]buf, size_t _buflen_);
+	int *tep_event_filtered*(struct tep_event_filter pass:[*]_filter_, int _event_id_);
+	void *tep_filter_reset*(struct tep_event_filter pass:[*]_filter_);
+	void *tep_filter_free*(struct tep_event_filter pass:[*]_filter_);
+	char pass:[*]*tep_filter_make_string*(struct tep_event_filter pass:[*]_filter_, int _event_id_);
+	int *tep_filter_remove_event*(struct tep_event_filter pass:[*]_filter_, int _event_id_);
+	int *tep_filter_copy*(struct tep_event_filter pass:[*]_dest_, struct tep_event_filter pass:[*]_source_);
+	int *tep_filter_compare*(struct tep_event_filter pass:[*]_filter1_, struct tep_event_filter pass:[*]_filter2_);
+
+Parsing various data from the records:
+	void *tep_data_latency_format*(struct tep_handle pass:[*]_tep_, struct trace_seq pass:[*]_s_, struct tep_record pass:[*]_record_);
+	int *tep_data_type*(struct tep_handle pass:[*]_tep_, struct tep_record pass:[*]_rec_);
+	int *tep_data_pid*(struct tep_handle pass:[*]_tep_, struct tep_record pass:[*]_rec_);
+	int *tep_data_preempt_count*(struct tep_handle pass:[*]_tep_, struct tep_record pass:[*]_rec_);
+	int *tep_data_flags*(struct tep_handle pass:[*]_tep_, struct tep_record pass:[*]_rec_);
+
+Command and task related APIs:
+	const char pass:[*]*tep_data_comm_from_pid*(struct tep_handle pass:[*]_tep_, int _pid_);
+	struct cmdline pass:[*]*tep_data_pid_from_comm*(struct tep_handle pass:[*]_tep_, const char pass:[*]_comm_, struct cmdline pass:[*]_next_);
+	int *tep_register_comm*(struct tep_handle pass:[*]_tep_, const char pass:[*]_comm_, int _pid_);
+	int *tep_override_comm*(struct tep_handle pass:[*]_tep_, const char pass:[*]_comm_, int _pid_);
+	bool *tep_is_pid_registered*(struct tep_handle pass:[*]_tep_, int _pid_);
+	int *tep_cmdline_pid*(struct tep_handle pass:[*]_tep_, struct cmdline pass:[*]_cmdline_);
+
+Endian related APIs:
+	int *tep_is_bigendian*(void);
+	unsigned long long *tep_read_number*(struct tep_handle pass:[*]_tep_, const void pass:[*]_ptr_, int _size_);
+	bool *tep_is_file_bigendian*(struct tep_handle pass:[*]_tep_);
+	void *tep_set_file_bigendian*(struct tep_handle pass:[*]_tep_, enum tep_endian _endian_);
+	bool *tep_is_local_bigendian*(struct tep_handle pass:[*]_tep_);
+	void *tep_set_local_bigendian*(struct tep_handle pass:[*]_tep_, enum tep_endian _endian_);
+
+Trace sequences:
+*#include <trace-seq.h>*
+	void *trace_seq_init*(struct trace_seq pass:[*]_s_);
+	void *trace_seq_reset*(struct trace_seq pass:[*]_s_);
+	void *trace_seq_destroy*(struct trace_seq pass:[*]_s_);
+	int *trace_seq_printf*(struct trace_seq pass:[*]_s_, const char pass:[*]_fmt_, ...);
+	int *trace_seq_vprintf*(struct trace_seq pass:[*]_s_, const char pass:[*]_fmt_, va_list _args_);
+	int *trace_seq_puts*(struct trace_seq pass:[*]_s_, const char pass:[*]_str_);
+	int *trace_seq_putc*(struct trace_seq pass:[*]_s_, unsigned char _c_);
+	void *trace_seq_terminate*(struct trace_seq pass:[*]_s_);
+	int *trace_seq_do_fprintf*(struct trace_seq pass:[*]_s_, FILE pass:[*]_fp_);
+	int *trace_seq_do_printf*(struct trace_seq pass:[*]_s_);
+--
+
+DESCRIPTION
+-----------
+The libtraceevent(3) library provides APIs to access kernel tracepoint events,
+located in the tracefs file system under the tracing/events directory.
+
+ENVIRONMENT
+-----------
+[verse]
+--
+TRACEEVENT_PLUGIN_DIR
+	Additional plugin directory. All shared object files, located in this directory will be loaded as traceevent plugins.
+--
+
+FILES
+-----
+[verse]
+--
+*event-parse.h*
+	Header file to include in order to have access to the library APIs.
+*trace-seq.h*
+	Header file to include in order to have access to trace sequences related APIs.
+	Trace sequences are used to allow a function to call several other functions
+	to create a string of data to use.
+*-ltraceevent*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+_trace-cmd(1)_
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>, author of *libtraceevent*.
+*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>, author of this man page.
+--
+REPORTING BUGS
+--------------
+Report bugs to  <linux-trace-devel@vger.kernel.org>
+
+LICENSE
+-------
+libtraceevent is Free Software licensed under the GNU LGPL 2.1
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
diff --git a/tools/lib/traceevent/Documentation/manpage-1.72.xsl b/tools/lib/traceevent/Documentation/manpage-1.72.xsl
new file mode 100644
index 000000000000..b4d315cb8c47
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/manpage-1.72.xsl
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
diff --git a/tools/lib/traceevent/Documentation/manpage-base.xsl b/tools/lib/traceevent/Documentation/manpage-base.xsl
new file mode 100644
index 000000000000..a264fa616093
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/manpage-base.xsl
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
diff --git a/tools/lib/traceevent/Documentation/manpage-bold-literal.xsl b/tools/lib/traceevent/Documentation/manpage-bold-literal.xsl
new file mode 100644
index 000000000000..608eb5df6281
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/manpage-bold-literal.xsl
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
diff --git a/tools/lib/traceevent/Documentation/manpage-normal.xsl b/tools/lib/traceevent/Documentation/manpage-normal.xsl
new file mode 100644
index 000000000000..a48f5b11f3dc
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/manpage-normal.xsl
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
diff --git a/tools/lib/traceevent/Documentation/manpage-suppress-sp.xsl b/tools/lib/traceevent/Documentation/manpage-suppress-sp.xsl
new file mode 100644
index 000000000000..a63c7632a87d
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/manpage-suppress-sp.xsl
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
diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index f65243137d6d..e73a0f2aea24 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -53,6 +53,7 @@ pkgconfig_dir ?= $(word 1,$(shell $(PKG_CONFIG) 		\
 
 export man_dir man_dir_SQ INSTALL
 export DESTDIR DESTDIR_SQ
+export EVENT_PARSE_VERSION
 
 set_plugin_dir := 1
 
@@ -313,6 +314,38 @@ clean:
 		$(RM) TRACEEVENT-CFLAGS tags TAGS; \
 		$(RM) $(PKG_CONFIG_FILE)
 
+PHONY += doc
+doc:
+	$(call descend,Documentation)
+
+PHONY += doc-clean
+doc-clean:
+	$(call descend,Documentation,clean)
+
+PHONY += doc-install
+doc-install:
+	$(call descend,Documentation,install)
+
+PHONY += doc-uninstall
+doc-uninstall:
+	$(call descend,Documentation,uninstall)
+
+PHONY += help
+help:
+	@echo 'Possible targets:'
+	@echo''
+	@echo '  all                 - default, compile the library and the'\
+	 			      'plugins'
+	@echo '  plugins             - compile the plugins'
+	@echo '  install             - install the library, the plugins,'\
+					'the header and pkgconfig files'
+	@echo '  clean               - clean the library and the plugins object files'
+	@echo '  doc                 - compile the documentation files - man'\
+					'and html pages, in the Documentation directory'
+	@echo '  doc-clean           - clean the documentation files'
+	@echo '  doc-install         - install the man pages'
+	@echo '  doc-uninstall       - uninstall the man pages'
+	@echo''
 PHONY += force plugins
 force:
 
-- 
2.20.1


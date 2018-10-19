Return-Path: <SRS0=XbHK=M7=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-bn3nam01on0043.outbound.protection.outlook.com ([104.47.33.43]:39712
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726399AbeJSRVJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Oct 2018 13:21:09 -0400
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v2] tools/lib/traceevent: Implement libtraceevent man pages
Date: Fri, 19 Oct 2018 09:15:45 +0000
Message-ID: <20181019091533.13210-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch adds initial support for libtraceevent man pages -
Documentation directory, templates, configurations, Makefiles.
The first man page is also part of the patch - summary of the
library and all its APIs. Building of the documentation is
integrated into the libtraceevent build process, new targets are
added to its Makefile:
make doc
make doc-clean
make doc-install
make doc-uninstall

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tools/lib/traceevent/Documentation/Makefile   | 205 ++++++++++++++++++
 .../traceevent/Documentation/asciidoc.conf    |  91 ++++++++
 .../Documentation/libtraceevent.txt           | 202 +++++++++++++++++
 .../traceevent/Documentation/manpage-1.72.xsl |  14 ++
 .../traceevent/Documentation/manpage-base.xsl |  35 +++
 .../Documentation/manpage-bold-literal.xsl    |  17 ++
 .../Documentation/manpage-normal.xsl          |  13 ++
 .../Documentation/manpage-suppress-sp.xsl     |  21 ++
 tools/lib/traceevent/Makefile                 |  13 ++
 9 files changed, 611 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/Makefile
 create mode 100644 tools/lib/traceevent/Documentation/asciidoc.conf
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent.txt
 create mode 100644 tools/lib/traceevent/Documentation/manpage-1.72.xsl
 create mode 100644 tools/lib/traceevent/Documentation/manpage-base.xsl
 create mode 100644 tools/lib/traceevent/Documentation/manpage-bold-literal=
.xsl
 create mode 100644 tools/lib/traceevent/Documentation/manpage-normal.xsl
 create mode 100644 tools/lib/traceevent/Documentation/manpage-suppress-sp.=
xsl

diff --git a/tools/lib/traceevent/Documentation/Makefile b/tools/lib/tracee=
vent/Documentation/Makefile
new file mode 100644
index 000000000000..b975080a6705
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/Makefile
@@ -0,0 +1,205 @@
+include ../../../scripts/Makefile.include
+include ../../../scripts/utilities.mak
+
+MAN3_TXT=3D \
+	$(wildcard libtraceevent-*.txt) \
+	libtraceevent.txt
+
+MAN_TXT =3D $(MAN3_TXT)
+_MAN_XML=3D$(patsubst %.txt,%.xml,$(MAN_TXT))
+_MAN_HTML=3D$(patsubst %.txt,%.html,$(MAN_TXT))
+_DOC_MAN3=3D$(patsubst %.txt,%.3,$(MAN3_TXT))
+
+MAN_XML=3D$(addprefix $(OUTPUT),$(_MAN_XML))
+MAN_HTML=3D$(addprefix $(OUTPUT),$(_MAN_HTML))
+DOC_MAN3=3D$(addprefix $(OUTPUT),$(_DOC_MAN3))
+
+# Make the path relative to DESTDIR, not prefix
+ifndef DESTDIR
+prefix?=3D$(HOME)
+endif
+bindir?=3D$(prefix)/bin
+htmldir?=3D$(prefix)/share/doc/libtraceevent-doc
+pdfdir?=3D$(prefix)/share/doc/libtraceevent-doc
+mandir?=3D$(prefix)/share/man
+man3dir=3D$(mandir)/man3
+
+ASCIIDOC=3Dasciidoc
+ASCIIDOC_EXTRA =3D --unsafe -f asciidoc.conf
+ASCIIDOC_HTML =3D xhtml11
+MANPAGE_XSL =3D manpage-normal.xsl
+XMLTO_EXTRA =3D
+INSTALL?=3Dinstall
+RM ?=3D rm -f
+
+ifdef USE_ASCIIDOCTOR
+ASCIIDOC =3D asciidoctor
+ASCIIDOC_EXTRA =3D -a compat-mode
+ASCIIDOC_EXTRA +=3D -I. -rasciidoctor-extensions
+ASCIIDOC_EXTRA +=3D -a mansource=3D"libtraceevent" -a manmanual=3D"libtrac=
eevent Manual"
+ASCIIDOC_HTML =3D xhtml5
+endif
+
+XMLTO=3Dxmlto
+
+_tmp_tool_path :=3D $(call get-executable,$(ASCIIDOC))
+ifeq ($(_tmp_tool_path),)
+	missing_tools =3D $(ASCIIDOC)
+endif
+
+ifndef USE_ASCIIDOCTOR
+_tmp_tool_path :=3D $(call get-executable,$(XMLTO))
+ifeq ($(_tmp_tool_path),)
+	missing_tools +=3D $(XMLTO)
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
+ASCIIDOC_EXTRA +=3D -a asciidoc7compatible
+endif
+ifdef DOCBOOK_XSL_172
+ASCIIDOC_EXTRA +=3D -a libtraceevent-asciidoc-no-roff
+MANPAGE_XSL =3D manpage-1.72.xsl
+else
+	ifdef ASCIIDOC_NO_ROFF
+	# docbook-xsl after 1.72 needs the regular XSL, but will not
+	# pass-thru raw roff codes from asciidoc.conf, so turn them off.
+	ASCIIDOC_EXTRA +=3D -a libtraceevent-asciidoc-no-roff
+	endif
+endif
+ifdef MAN_BOLD_LITERAL
+XMLTO_EXTRA +=3D -m manpage-bold-literal.xsl
+endif
+ifdef DOCBOOK_SUPPRESS_SP
+XMLTO_EXTRA +=3D -m manpage-suppress-sp.xsl
+endif
+
+SHELL_PATH ?=3D $(SHELL)
+# Shell quote;
+SHELL_PATH_SQ =3D $(subst ','\'',$(SHELL_PATH))
+
+DESTDIR ?=3D
+DESTDIR_SQ =3D '$(subst ','\'',$(DESTDIR))'
+
+export DESTDIR DESTDIR_SQ
+
+#
+# Please note that there is a minor bug in asciidoc.
+# The version after 6.0.3 _will_ include the patch found here:
+#   http://marc.theaimsgroup.com/?l=3Dlibtraceevent&m=3D111558757202243&w=
=3D2
+#
+# Until that version is released you may have to apply the patch
+# yourself - yes, all 6 characters of it!
+#
+QUIET_SUBDIR0  =3D +$(MAKE) -C # space to separate -C and subdir
+QUIET_SUBDIR1  =3D
+
+ifneq ($(findstring $(MAKEFLAGS),w),w)
+PRINT_DIR =3D --no-print-directory
+else # "make -w"
+NO_SUBDIR =3D :
+endif
+
+ifneq ($(findstring $(MAKEFLAGS),s),s)
+ifneq ($(V),1)
+	QUIET_ASCIIDOC	=3D @echo '  ASCIIDOC '$@;
+	QUIET_XMLTO	=3D @echo '  XMLTO    '$@;
+	QUIET_SUBDIR0	=3D +@subdir=3D
+	QUIET_SUBDIR1	=3D ;$(NO_SUBDIR) \
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
+		$(INSTALL) -m 644 $(DOC_MAN3) $(DESTDIR)$(man3dir);=20
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
+  DO_INSTALL_MAN =3D $(warning Please install $(missing_tools) to have the=
 man pages installed)
+else
+  DO_INSTALL_MAN =3D do-install-man
+endif
+
+CLEAN_FILES =3D					\
+	$(MAN_XML) $(addsuffix +,$(MAN_XML))	\
+	$(MAN_HTML) $(addsuffix +,$(MAN_HTML))	\
+	$(DOC_MAN3)
+
+clean:
+	$(call QUIET_CLEAN, Documentation) $(RM) $(CLEAN_FILES)
+
+ifdef USE_ASCIIDOCTOR
+$(OUTPUT)%.3 : $(OUTPUT)%.txt
+	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
+	$(ASCIIDOC) -b manpage -d manpage \
+		$(ASCIIDOC_EXTRA) -alibtraceevent_version=3D$(EVENT_PARSE_VERSION) -o $@=
+ $< && \
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
+		$(ASCIIDOC_EXTRA) -alibtraceevent_version=3D$(EVENT_PARSE_VERSION) -o $@=
+ $< && \
+	mv $@+ $@
+=09
+$(MAN_HTML): $(OUTPUT)%.html : %.txt
+	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
+	$(ASCIIDOC) -b $(ASCIIDOC_HTML) -d manpage \
+		$(ASCIIDOC_EXTRA) -aperf_version=3D$(EVENT_PARSE_VERSION) -o $@+ $< && \
+	mv $@+ $@
+
diff --git a/tools/lib/traceevent/Documentation/asciidoc.conf b/tools/lib/t=
raceevent/Documentation/asciidoc.conf
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
+# Show TEP link as: <command>(<section>); if section is defined, else just=
 show
+# the command.
+
+[macros]
+(?su)[\\]?(?P<name>linktep):(?P<target>\S*?)\[(?P<attrlist>.*?)\]=3D
+
+[attributes]
+asterisk=3D&#42;
+plus=3D&#43;
+caret=3D&#94;
+startsb=3D&#91;
+endsb=3D&#93;
+tilde=3D&#126;
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
+# "unbreak" docbook-xsl v1.68 for manpages. v1.69 works with or without th=
is.
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
+# The following two small workarounds insert a simple paragraph after scre=
en
+[listingblock]
+<example><title>{title}</title>
+<literallayout>
+|
+</literallayout><simpara></simpara>
+{title#}</example>
+
+[verseblock]
+<formalpara{id? id=3D"{id}"}><title>{title}</title><para>
+{title%}<literallayout{id? id=3D"{id}"}>
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
+<refmiscinfo class=3D"source">trace-cmd</refmiscinfo>
+<refmiscinfo class=3D"version">{libtraceevent_version}</refmiscinfo>
+<refmiscinfo class=3D"manual">trace-cmd Manual</refmiscinfo>
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
+<a href=3D"{target}.html">{target}{0?({0})}</a>
+endif::backend-xhtml11[]
diff --git a/tools/lib/traceevent/Documentation/libtraceevent.txt b/tools/l=
ib/traceevent/Documentation/libtraceevent.txt
new file mode 100644
index 000000000000..bc3d77934ab8
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent.txt
@@ -0,0 +1,202 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
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
+	void *tep_free*(struct tep_handle pass:[*]_pevent_);
+	void *tep_ref*(struct tep_handle pass:[*]_pevent_);
+	void *tep_unref*(struct tep_handle pass:[*]_pevent_);
+	int *tep_ref_get*(struct tep_handle pass:[*]_pevent_);
+	void *tep_set_flag*(struct tep_handle pass:[*]_tep_, int _flag_);
+	int *tep_get_cpus*(struct tep_handle pass:[*]_pevent_);
+	void *tep_set_cpus*(struct tep_handle pass:[*]_pevent_, int _cpus_);
+	int *tep_get_long_size*(strucqt tep_handle pass:[*]_pevent_);
+	void *tep_set_long_size*(struct tep_handle pass:[*]_pevent_, int _long_si=
ze_);
+	int *tep_get_page_size*(struct tep_handle pass:[*]_pevent_);
+	void *tep_set_page_size*(struct tep_handle pass:[*]_pevent_, int _page_si=
ze_);
+	int *tep_is_file_bigendian*(struct tep_handle pass:[*]_pevent_);
+	void *tep_set_file_bigendian*(struct tep_handle pass:[*]_pevent_, enum te=
p_endian _endian_);
+	int *tep_is_host_bigendian*(struct tep_handle pass:[*]_pevent_);
+	void *tep_set_host_bigendian*(struct tep_handle pass:[*]_pevent_, enum te=
p_endian _endian_);
+	int *tep_is_latency_format*(struct tep_handle pass:[*]_pevent_);
+	void *tep_set_latency_format*(struct tep_handle pass:[*]_pevent_, int _la=
t_);
+	int *tep_get_header_page_size*(struct tep_handle pass:[*]_pevent_);
+	int *tep_strerror*(struct tep_handle pass:[*]_pevent_, enum tep_errno _er=
rnum_, char pass:[*]_buf_, size_t _buflen_);
+
+Register / unregister APIs:
+	int *tep_register_trace_clock*(struct tep_handle pass:[*]_pevent_, const =
char pass:[*]_trace_clock_);
+	int *tep_register_function*(struct tep_handle pass:[*]_pevent_, char pass=
:[*]_name_, unsigned long long _addr_, char pass:[*]_mod_);
+	int *tep_register_event_handler*(struct tep_handle pass:[*]_pevent_, int =
_id_, const char pass:[*]_sys_name_, const char pass:[*]_event_name_, tep_e=
vent_handler_func _func_, void pass:[*]_context_);
+	int *tep_unregister_event_handler*(struct tep_handle pass:[*]pevent, int =
id, const char pass:[*]sys_name, const char pass:[*]event_name, tep_event_h=
andler_func func, void pass:[*]_context_);
+	int *tep_register_print_string*(struct tep_handle pass:[*]_pevent_, const=
 char pass:[*]_fmt_, unsigned long long _addr_);
+	int *tep_register_print_function*(struct tep_handle pass:[*]_pevent_, tep=
_func_handler _func_, enum tep_func_arg_type _ret_type_, char pass:[*]_name=
_, _..._);
+	int *tep_unregister_print_function*(struct tep_handle pass:[*]_pevent_, t=
ep_func_handler _func_, char pass:[*]_name_);
+
+Plugins management:=20
+	struct tep_plugin_list pass:[*]*tep_load_plugins*(struct tep_handle pass:=
[*]_pevent_);
+	void *tep_unload_plugins*(struct tep_plugin_list pass:[*]_plugin_list_, s=
truct tep_handle pass:[*]_pevent_);
+	char pass:[*]pass:[*]*tep_plugin_list_options*(void);
+	void *tep_plugin_free_options_list*(char pass:[*]pass:[*]_list_);
+	int *tep_plugin_add_options*(const char pass:[*]_name_, struct tep_plugin=
_option pass:[*]_options_);
+	void *tep_plugin_remove_options*(struct tep_plugin_option pass:[*]_option=
s_);
+	void *tep_print_plugins*(struct trace_seq pass:[*]_s_, const char pass:[*=
]_prefix_, const char pass:[*]_suffix_, const struct tep_plugin_list pass:[=
*]_list_);
+
+Event related APIs:
+	struct tep_event pass:[*]*tep_get_first_event*(struct tep_handle pass:[*]=
_tep_);
+	int *tep_get_events_count*(struct tep_handle pass:[*]_tep_);
+	void *tep_free_event*(struct tep_event pass:[*]_event_);
+	struct tep_event pass:[*]pass:[*]*tep_list_events*(struct tep_handle pass=
:[*]_pevent_, enum tep_event_sort_type _sort_type_);
+	void *tep_event_info*(struct trace_seq pass:[*]_s_, struct tep_event pass=
:[*]_event_, struct tep_record pass:[*]_record_);
+
+Event printing:
+	void *tep_print_event_task*(struct tep_handle pass:[*]_pevent_, struct tr=
ace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, struct tep_record pa=
ss:[*]_record_);
+	void *tep_print_event_time*(struct tep_handle pass:[*]_pevent_, struct tr=
ace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, struct tep_record pa=
ss:[*]record, bool _use_trace_clock_);
+	void *tep_print_event_data*(struct tep_handle pass:[*]_pevent_, struct tr=
ace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, struct tep_record pa=
ss:[*]_record_);
+	void *tep_print_event*(struct tep_handle pass:[*]_pevent_, struct trace_s=
eq pass:[*]_s_, struct tep_record pass:[*]_record_, bool _use_trace_clock_)=
;
+
+Event finding:
+	struct tep_event pass:[*]*tep_find_event*(struct tep_handle pass:[*]_peve=
nt_, int _id_);
+	struct tep_event pass:[*]*tep_find_event_by_name*(struct tep_handle pass:=
[*]_pevent_, const char pass:[*]_sys_, const char pass:[*]_name_);
+	struct tep_event pass:[*]*tep_find_event_by_record*(struct tep_handle pas=
s:[*]_pevent_, struct tep_record pass:[*]_record_);
+	struct tep_event pass:[*]*tep_data_event_from_type*(struct tep_handle pas=
s:[*]_pevent_, int _type_);
+
+Parsing of event files:
+	int *tep_parse_header_page*(struct tep_handle pass:[*]_pevent_, char pass=
:[*]_buf_, unsigned long _size_, int _long_size_);
+	enum *tep_errno tep_parse_event*(struct tep_handle pass:[*]_pevent_, cons=
t char pass:[*]_buf_, unsigned long _size_, const char pass:[*]_sys_);
+	enum *tep_errno tep_parse_format*(struct tep_handle pass:[*]_pevent_, str=
uct tep_event pass:[*]pass:[*]_eventp_, const char pass:[*]_buf_, unsigned =
long _size_, const char pass:[*]_sys_);
+
+APIs related to fields from event's format files:
+	void *tep_free_format_field*(struct tep_format_field pass:[*]_field_);
+	struct tep_format_field pass:[*]pass:[*]*tep_event_common_fields*(struct =
tep_event pass:[*]_event_);
+	struct tep_format_field pass:[*]pass:[*]*tep_event_fields*(struct tep_eve=
nt pass:[*]_event_);
+	void pass:[*]*tep_get_field_raw*(struct trace_seq pass:[*]_s_, struct tep=
_event pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[=
*]_record_, int pass:[*]_len_, int _err_);
+	int *tep_get_field_val*(struct trace_seq pass:[*]_s_, struct tep_event pa=
ss:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_record=
_, unsigned long long pass:[*]_val_, int _err_);
+	int *tep_get_common_field_val*(struct trace_seq pass:[*]_s_, struct tep_e=
vent pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]=
_record_, unsigned long long pass:[*]_val_, int _err_);
+	int *tep_get_any_field_val*(struct trace_seq pass:[*]_s_, struct tep_even=
t pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_re=
cord_, unsigned long long pass:[*]_val_, int _err_);=09
+	void *tep_print_field*(struct trace_seq pass:[*]_s_, void pass:[*]_data_,=
 struct tep_format_field pass:[*]_field_);
+	void *tep_print_fields*(struct trace_seq pass:[*]_s_, void pass:[*]_data_=
, int _size_, struct tep_event pass:[*]_event_);
+	int *tep_print_num_field*(struct trace_seq pass:[*]_s_, const char pass:[=
*]_fmt_, struct tep_event pass:[*]_event_, const char pass:[*]_name_, struc=
t tep_record pass:[*]_record_, int _err_);
+	int *tep_print_func_field*(struct trace_seq pass:[*]_s_, const char pass:=
[*]_fmt_, struct tep_event pass:[*]_event_, const char pass:[*]_name_, stru=
ct tep_record pass:[*]_record_, int _err_);
+	int *tep_read_number_field*(struct tep_format_field pass:[*]_field_, cons=
t void pass:[*]_data_, unsigned long long pass:[*]_value_);
+=09
+Event fileds finding:
+	struct tep_format_field pass:[*]*tep_find_common_field*(struct tep_event =
pass:[*]_event_, const char pass:[*]_name_);
+	struct tep_format_field pass:[*]*tep_find_field*(struct tep_event_ormat p=
ass:[*]_event_, const char pass:[*]_name_);
+	struct tep_format_field pass:[*]*tep_find_any_field*(struct tep_event pas=
s:[*]_event_, const char pass:[*]_name_);
+
+Functions resolver:
+	int *tep_set_function_resolver*(struct tep_handle pass:[*]_pevent_, tep_f=
unc_resolver_t pass:[*]_func_, void pass:[*]_priv_);
+	void *tep_reset_function_resolver*(struct tep_handle pass:[*]_pevent_);
+	const char pass:[*]*tep_find_function*(struct tep_handle pass:[*]_pevent_=
, unsigned long long _addr_);
+	unsigned long long *tep_find_function_address*(struct tep_handle pass:[*]=
_pevent_, unsigned long long _addr_);
+
+Filter management:
+	struct tep_event_filter pass:[*]*tep_filter_alloc*(struct tep_handle pass=
:[*]_pevent_);
+	enum tep_errno *tep_filter_add_filter_str*(struct tep_event_filter pass:[=
*]_filter_, const char pass:[*]_filter_str_);
+	enum tep_errno *tep_filter_match*(struct tep_event_filter pass:[*]_filter=
_, struct tep_record pass:[*]_record_);
+	int *tep_filter_strerror*(struct tep_event_filter pass:[*]_filter_, enum =
tep_errno _err_, char pass:[*]buf, size_t _buflen_);
+	int *tep_event_filtered*(struct tep_event_filter pass:[*]_filter_, int _e=
vent_id_);
+	void *tep_filter_reset*(struct tep_event_filter pass:[*]_filter_);
+	int *tep_filter_clear_trivial*(struct tep_event_filter pass:[*]_filter_, =
enum tep_filter_trivial_type _type_);
+	void *tep_filter_free*(struct tep_event_filter pass:[*]_filter_);
+	char pass:[*]*tep_filter_make_string*(struct tep_event_filter pass:[*]_fi=
lter_, int _event_id_);
+	int *tep_filter_remove_event*(struct tep_event_filter pass:[*]filter, int=
 _event_id_);
+	int *tep_filter_event_has_trivial*(struct tep_event_filter pass:[*]_filte=
r_, int _event_id_, enum tep_filter_trivial_type _type_);
+	int *tep_filter_copy*(struct tep_event_filter pass:[*]_dest_, struct tep_=
event_filter pass:[*]_source_);
+	int *tep_update_trivial*(struct tep_event_filter pass:[*]_dest_, struct t=
ep_event_filter pass:[*]_source_, enum tep_filter_trivial_type _type_);
+	int *tep_filter_compare*(struct tep_event_filter pass:[*]_filter1_, struc=
t tep_event_filter pass:[*]_filter2_);
+
+Parsing various data from the records:
+	void *tep_data_lat_fmt*(struct tep_handle pass:[*]_pevent_, struct trace_=
seq pass:[*]_s_, struct tep_record pass:[*]_record_);
+	int *tep_data_type*(struct tep_handle pass:[*]_pevent_, struct tep_record=
 pass:[*]_rec_);
+	int *tep_data_pid*(struct tep_handle pass:[*]_pevent_, struct tep_record =
pass:[*]_rec_);
+	int *tep_data_preempt_count*(struct tep_handle pass:[*]_pevent_, struct t=
ep_record pass:[*]_rec_);
+	int *tep_data_flags*(struct tep_handle pass:[*]_pevent_, struct tep_recor=
d pass:[*]_rec_);
+	const char pass:[*]*tep_data_comm_from_pid*(struct tep_handle pass:[*]_pe=
vent_, int _pid_);
+	struct cmdline pass:[*]*tep_data_pid_from_comm*(struct tep_handle pass:[*=
]_pevent_, const char pass:[*]_comm_, struct cmdline pass:[*]_next_);
+=09
+Command and task related APIs:
+	int *tep_register_comm*(struct tep_handle pass:[*]_pevent_, const char pa=
ss:[*]_comm_, int _pid_);
+	int *tep_pid_is_registered*(struct tep_handle pass:[*]_pevent_, int _pid_=
);
+	int *tep_cmdline_pid*(struct tep_handle pass:[*]_pevent_, struct cmdline =
pass:[*]_cmdline_);
+
+Endian related APIs:
+	unsigned short *tep_data2host2*(struct tep_handle pass:[*]_pevent_, unsig=
ned short _data_);
+	unsigned int *tep_data2host4*(struct tep_handle pass:[*]_pevent_, unsigne=
d int _data_);
+	unsigned long long *tep_data2host8*(struct tep_handle pass:[*]_pevent_, u=
nsigned long long _data_);
+	int *tep_host_bigendian*(void);
+	unsigned long long *tep_read_number*(struct tep_handle pass:[*]_pevent_, =
const void pass:[*]_ptr_, int _size_);
+
+Trace sequences:
+*#include <trace-seq.h>*
+	void *trace_seq_init*(struct trace_seq pass:[*]_s_);
+	void *trace_seq_reset*(struct trace_seq pass:[*]_s_);
+	void *trace_seq_destroy*(struct trace_seq pass:[*]_s_);
+	int *trace_seq_printf*(struct trace_seq pass:[*]_s_, const char pass:[*]_=
fmt_, ...);
+	int *trace_seq_vprintf*(struct trace_seq pass:[*]_s_, const char pass:[*]=
_fmt_, va_list _args_);
+	int *trace_seq_puts*(struct trace_seq pass:[*]_s_, const char pass:[*]_st=
r_);
+	int *trace_seq_putc*(struct trace_seq pass:[*]_s_, unsigned char _c_);
+	void *trace_seq_terminate*(struct trace_seq pass:[*]_s_);
+	int *trace_seq_do_fprintf*(struct trace_seq pass:[*]_s_, FILE pass:[*]_fp=
_);
+	int *trace_seq_do_printf*(struct trace_seq pass:[*]_s_);
+--
+
+DESCRIPTION
+-----------
+The libtraceevent(3) library provides APIs to access kernel tracepoint eve=
nts,
+located in the debugfs file system under the tracing/events directory.
+
+ENVIRONMENT
+-----------
+[verse]
+--
+TRACEEVENT_PLUGIN_DIR
+	Additional plugin directory. All shared object files, located in this dir=
ectory will be loaded as traceevent plugins.
+--
+
+FILES
+-----
+[verse]
+--
+event-parse.h
+	Header file to include in order to have access to the library APIs.
+trace-seq.h
+	Header file to include in order to have access to trace sequences related=
 APIs.
+	Trace sequences are used to allow a function to call several other functi=
ons=20
+	to create a string of data to use.
+-ltraceevent
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
diff --git a/tools/lib/traceevent/Documentation/manpage-1.72.xsl b/tools/li=
b/traceevent/Documentation/manpage-1.72.xsl
new file mode 100644
index 000000000000..b4d315cb8c47
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/manpage-1.72.xsl
@@ -0,0 +1,14 @@
+<!-- manpage-1.72.xsl:
+     special settings for manpages rendered from asciidoc+docbook
+     handles peculiarities in docbook-xsl 1.72.0 -->
+<xsl:stylesheet xmlns:xsl=3D"http://www.w3.org/1999/XSL/Transform"
+		version=3D"1.0">
+
+<xsl:import href=3D"manpage-base.xsl"/>
+
+<!-- these are the special values for the roff control characters
+     needed for docbook-xsl 1.72.0 -->
+<xsl:param name=3D"git.docbook.backslash">&#x2593;</xsl:param>
+<xsl:param name=3D"git.docbook.dot"      >&#x2302;</xsl:param>
+
+</xsl:stylesheet>
diff --git a/tools/lib/traceevent/Documentation/manpage-base.xsl b/tools/li=
b/traceevent/Documentation/manpage-base.xsl
new file mode 100644
index 000000000000..a264fa616093
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/manpage-base.xsl
@@ -0,0 +1,35 @@
+<!-- manpage-base.xsl:
+     special formatting for manpages rendered from asciidoc+docbook -->
+<xsl:stylesheet xmlns:xsl=3D"http://www.w3.org/1999/XSL/Transform"
+		version=3D"1.0">
+
+<!-- these params silence some output from xmlto -->
+<xsl:param name=3D"man.output.quietly" select=3D"1"/>
+<xsl:param name=3D"refentry.meta.get.quietly" select=3D"1"/>
+
+<!-- convert asciidoc callouts to man page format;
+     git.docbook.backslash and git.docbook.dot params
+     must be supplied by another XSL file or other means -->
+<xsl:template match=3D"co">
+	<xsl:value-of select=3D"concat(
+			      $git.docbook.backslash,'fB(',
+			      substring-after(@id,'-'),')',
+			      $git.docbook.backslash,'fR')"/>
+</xsl:template>
+<xsl:template match=3D"calloutlist">
+	<xsl:value-of select=3D"$git.docbook.dot"/>
+	<xsl:text>sp&#10;</xsl:text>
+	<xsl:apply-templates/>
+	<xsl:text>&#10;</xsl:text>
+</xsl:template>
+<xsl:template match=3D"callout">
+	<xsl:value-of select=3D"concat(
+			      $git.docbook.backslash,'fB',
+			      substring-after(@arearefs,'-'),
+			      '. ',$git.docbook.backslash,'fR')"/>
+	<xsl:apply-templates/>
+	<xsl:value-of select=3D"$git.docbook.dot"/>
+	<xsl:text>br&#10;</xsl:text>
+</xsl:template>
+
+</xsl:stylesheet>
diff --git a/tools/lib/traceevent/Documentation/manpage-bold-literal.xsl b/=
tools/lib/traceevent/Documentation/manpage-bold-literal.xsl
new file mode 100644
index 000000000000..608eb5df6281
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/manpage-bold-literal.xsl
@@ -0,0 +1,17 @@
+<!-- manpage-bold-literal.xsl:
+     special formatting for manpages rendered from asciidoc+docbook -->
+<xsl:stylesheet xmlns:xsl=3D"http://www.w3.org/1999/XSL/Transform"
+		version=3D"1.0">
+
+<!-- render literal text as bold (instead of plain or monospace);
+     this makes literal text easier to distinguish in manpages
+     viewed on a tty -->
+<xsl:template match=3D"literal">
+	<xsl:value-of select=3D"$git.docbook.backslash"/>
+	<xsl:text>fB</xsl:text>
+	<xsl:apply-templates/>
+	<xsl:value-of select=3D"$git.docbook.backslash"/>
+	<xsl:text>fR</xsl:text>
+</xsl:template>
+
+</xsl:stylesheet>
diff --git a/tools/lib/traceevent/Documentation/manpage-normal.xsl b/tools/=
lib/traceevent/Documentation/manpage-normal.xsl
new file mode 100644
index 000000000000..a48f5b11f3dc
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/manpage-normal.xsl
@@ -0,0 +1,13 @@
+<!-- manpage-normal.xsl:
+     special settings for manpages rendered from asciidoc+docbook
+     handles anything we want to keep away from docbook-xsl 1.72.0 -->
+<xsl:stylesheet xmlns:xsl=3D"http://www.w3.org/1999/XSL/Transform"
+		version=3D"1.0">
+
+<xsl:import href=3D"manpage-base.xsl"/>
+
+<!-- these are the normal values for the roff control characters -->
+<xsl:param name=3D"git.docbook.backslash">\</xsl:param>
+<xsl:param name=3D"git.docbook.dot"	>.</xsl:param>
+
+</xsl:stylesheet>
diff --git a/tools/lib/traceevent/Documentation/manpage-suppress-sp.xsl b/t=
ools/lib/traceevent/Documentation/manpage-suppress-sp.xsl
new file mode 100644
index 000000000000..a63c7632a87d
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/manpage-suppress-sp.xsl
@@ -0,0 +1,21 @@
+<!-- manpage-suppress-sp.xsl:
+     special settings for manpages rendered from asciidoc+docbook
+     handles erroneous, inline .sp in manpage output of some
+     versions of docbook-xsl -->
+<xsl:stylesheet xmlns:xsl=3D"http://www.w3.org/1999/XSL/Transform"
+		version=3D"1.0">
+
+<!-- attempt to work around spurious .sp at the tail of the line
+     that some versions of docbook stylesheets seem to add -->
+<xsl:template match=3D"simpara">
+  <xsl:variable name=3D"content">
+    <xsl:apply-templates/>
+  </xsl:variable>
+  <xsl:value-of select=3D"normalize-space($content)"/>
+  <xsl:if test=3D"not(ancestor::authorblurb) and
+                not(ancestor::personblurb)">
+    <xsl:text>&#10;&#10;</xsl:text>
+  </xsl:if>
+</xsl:template>
+
+</xsl:stylesheet>
diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index f65243137d6d..3764e003d1cc 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -53,6 +53,7 @@ pkgconfig_dir ?=3D $(word 1,$(shell $(PKG_CONFIG) 		\
=20
 export man_dir man_dir_SQ INSTALL
 export DESTDIR DESTDIR_SQ
+export EVENT_PARSE_VERSION
=20
 set_plugin_dir :=3D 1
=20
@@ -313,6 +314,18 @@ clean:
 		$(RM) TRACEEVENT-CFLAGS tags TAGS; \
 		$(RM) $(PKG_CONFIG_FILE)
=20
+doc:
+	$(call descend,Documentation)
+
+doc-clean:
+	$(call descend,Documentation,clean)
+
+doc-install:
+	$(call descend,Documentation,install)
+
+doc-uninstall:
+	$(call descend,Documentation,uninstall)
+
 PHONY +=3D force plugins
 force:
=20
--=20
2.17.2

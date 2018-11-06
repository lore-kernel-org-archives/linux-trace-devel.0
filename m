Return-Path: <SRS0=lo60=NR=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:46590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726403AbeKGIke (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Nov 2018 03:40:34 -0500
Date: Tue, 6 Nov 2018 18:12:54 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2] tools/lib/traceevent: Implement libtraceevent man
 pages
Message-ID: <20181106181254.03c3e637@gandalf.local.home>
In-Reply-To: <20181019091533.13210-1-tstoyanov@vmware.com>
References: <20181019091533.13210-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>


I noticed that your other patches are based off of this one, so I'm
assuming that this is the one you want to add.

I'm getting a lot of patches in my inbox from you that are not applied
yet. It may be a good idea to just include all the patches that should
be applied into one patch series, as, I have no idea which patch needs
to be applied, or which ones to just ignore.


On Fri, 19 Oct 2018 09:15:45 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> This patch adds initial support for libtraceevent man pages -
> Documentation directory, templates, configurations, Makefiles.
> The first man page is also part of the patch - summary of the

The first man page will now have functions that are no longer going to
be part of the API. This is fine, as long as the patches that remove
them remove them from this man page too.


> library and all its APIs. Building of the documentation is
> integrated into the libtraceevent build process, new targets are
> added to its Makefile:
> make doc
> make doc-clean
> make doc-install
> make doc-uninstall
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  tools/lib/traceevent/Documentation/Makefile   | 205 ++++++++++++++++++
>  .../traceevent/Documentation/asciidoc.conf    |  91 ++++++++
>  .../Documentation/libtraceevent.txt           | 202 +++++++++++++++++
>  .../traceevent/Documentation/manpage-1.72.xsl |  14 ++
>  .../traceevent/Documentation/manpage-base.xsl |  35 +++
>  .../Documentation/manpage-bold-literal.xsl    |  17 ++
>  .../Documentation/manpage-normal.xsl          |  13 ++
>  .../Documentation/manpage-suppress-sp.xsl     |  21 ++
>  tools/lib/traceevent/Makefile                 |  13 ++
>  9 files changed, 611 insertions(+)
>  create mode 100644 tools/lib/traceevent/Documentation/Makefile
>  create mode 100644 tools/lib/traceevent/Documentation/asciidoc.conf
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent.txt
>  create mode 100644 tools/lib/traceevent/Documentation/manpage-1.72.xsl
>  create mode 100644 tools/lib/traceevent/Documentation/manpage-base.xsl
>  create mode 100644 tools/lib/traceevent/Documentation/manpage-bold-literal.xsl
>  create mode 100644 tools/lib/traceevent/Documentation/manpage-normal.xsl
>  create mode 100644 tools/lib/traceevent/Documentation/manpage-suppress-sp.xsl
> 
> diff --git a/tools/lib/traceevent/Documentation/Makefile b/tools/lib/traceevent/Documentation/Makefile
> new file mode 100644
> index 000000000000..b975080a6705
> --- /dev/null
> +++ b/tools/lib/traceevent/Documentation/Makefile
> @@ -0,0 +1,205 @@
> +include ../../../scripts/Makefile.include
> +include ../../../scripts/utilities.mak
> +
> +MAN3_TXT= \
> +	$(wildcard libtraceevent-*.txt) \
> +	libtraceevent.txt
> +
> +MAN_TXT = $(MAN3_TXT)
> +_MAN_XML=$(patsubst %.txt,%.xml,$(MAN_TXT))
> +_MAN_HTML=$(patsubst %.txt,%.html,$(MAN_TXT))
> +_DOC_MAN3=$(patsubst %.txt,%.3,$(MAN3_TXT))
> +
> +MAN_XML=$(addprefix $(OUTPUT),$(_MAN_XML))
> +MAN_HTML=$(addprefix $(OUTPUT),$(_MAN_HTML))
> +DOC_MAN3=$(addprefix $(OUTPUT),$(_DOC_MAN3))
> +
> +# Make the path relative to DESTDIR, not prefix
> +ifndef DESTDIR
> +prefix?=$(HOME)
> +endif
> +bindir?=$(prefix)/bin
> +htmldir?=$(prefix)/share/doc/libtraceevent-doc
> +pdfdir?=$(prefix)/share/doc/libtraceevent-doc
> +mandir?=$(prefix)/share/man
> +man3dir=$(mandir)/man3
> +
> +ASCIIDOC=asciidoc
> +ASCIIDOC_EXTRA = --unsafe -f asciidoc.conf
> +ASCIIDOC_HTML = xhtml11
> +MANPAGE_XSL = manpage-normal.xsl
> +XMLTO_EXTRA =
> +INSTALL?=install
> +RM ?= rm -f
> +
> +ifdef USE_ASCIIDOCTOR
> +ASCIIDOC = asciidoctor
> +ASCIIDOC_EXTRA = -a compat-mode
> +ASCIIDOC_EXTRA += -I. -rasciidoctor-extensions
> +ASCIIDOC_EXTRA += -a mansource="libtraceevent" -a manmanual="libtraceevent Manual"
> +ASCIIDOC_HTML = xhtml5
> +endif
> +
> +XMLTO=xmlto
> +
> +_tmp_tool_path := $(call get-executable,$(ASCIIDOC))
> +ifeq ($(_tmp_tool_path),)
> +	missing_tools = $(ASCIIDOC)
> +endif
> +
> +ifndef USE_ASCIIDOCTOR
> +_tmp_tool_path := $(call get-executable,$(XMLTO))
> +ifeq ($(_tmp_tool_path),)
> +	missing_tools += $(XMLTO)
> +endif
> +endif
> +
> +#
> +# For asciidoc ...
> +#	-7.1.2,	no extra settings are needed.
> +#	8.0-,	set ASCIIDOC8.
> +#
> +
> +#
> +# For docbook-xsl ...
> +#	-1.68.1,	set ASCIIDOC_NO_ROFF? (based on changelog from 1.73.0)
> +#	1.69.0,		no extra settings are needed?
> +#	1.69.1-1.71.0,	set DOCBOOK_SUPPRESS_SP?
> +#	1.71.1,		no extra settings are needed?
> +#	1.72.0,		set DOCBOOK_XSL_172.
> +#	1.73.0-,	set ASCIIDOC_NO_ROFF
> +#
> +
> +#
> +# If you had been using DOCBOOK_XSL_172 in an attempt to get rid
> +# of 'the ".ft C" problem' in your generated manpages, and you
> +# instead ended up with weird characters around callouts, try
> +# using ASCIIDOC_NO_ROFF instead (it works fine with ASCIIDOC8).
> +#
> +

Looks like this was copied from the perf documentation make files, we
need to state that somewhere. like at the top of this file:

# This was taken from tools/perf/Documentation and modified for
# libtraceevent.

Always state where code or text came from when copied.


> +ifdef ASCIIDOC8
> +ASCIIDOC_EXTRA += -a asciidoc7compatible
> +endif
> +ifdef DOCBOOK_XSL_172
> +ASCIIDOC_EXTRA += -a libtraceevent-asciidoc-no-roff
> +MANPAGE_XSL = manpage-1.72.xsl
> +else
> +	ifdef ASCIIDOC_NO_ROFF
> +	# docbook-xsl after 1.72 needs the regular XSL, but will not
> +	# pass-thru raw roff codes from asciidoc.conf, so turn them off.
> +	ASCIIDOC_EXTRA += -a libtraceevent-asciidoc-no-roff
> +	endif
> +endif
> +ifdef MAN_BOLD_LITERAL
> +XMLTO_EXTRA += -m manpage-bold-literal.xsl
> +endif
> +ifdef DOCBOOK_SUPPRESS_SP
> +XMLTO_EXTRA += -m manpage-suppress-sp.xsl
> +endif
> +
> +SHELL_PATH ?= $(SHELL)
> +# Shell quote;
> +SHELL_PATH_SQ = $(subst ','\'',$(SHELL_PATH))
> +
> +DESTDIR ?=
> +DESTDIR_SQ = '$(subst ','\'',$(DESTDIR))'
> +
> +export DESTDIR DESTDIR_SQ
> +


[...]

> diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
> index f65243137d6d..3764e003d1cc 100644
> --- a/tools/lib/traceevent/Makefile
> +++ b/tools/lib/traceevent/Makefile
> @@ -53,6 +53,7 @@ pkgconfig_dir ?= $(word 1,$(shell $(PKG_CONFIG) 		\
>  
>  export man_dir man_dir_SQ INSTALL
>  export DESTDIR DESTDIR_SQ
> +export EVENT_PARSE_VERSION
>  
>  set_plugin_dir := 1
>  
> @@ -313,6 +314,18 @@ clean:
>  		$(RM) TRACEEVENT-CFLAGS tags TAGS; \
>  		$(RM) $(PKG_CONFIG_FILE)
>  
> +doc:
> +	$(call descend,Documentation)
> +
> +doc-clean:
> +	$(call descend,Documentation,clean)
> +
> +doc-install:
> +	$(call descend,Documentation,install)
> +
> +doc-uninstall:
> +	$(call descend,Documentation,uninstall)
> +

We probably should add a "make help" here too, that describes all this.

-- Steve

>  PHONY += force plugins
>  force:
>  

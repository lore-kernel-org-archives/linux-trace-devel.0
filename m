Return-Path: <SRS0=SJyJ=7R=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F28A7C433DF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Jun 2020 19:20:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8C0D206E6
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Jun 2020 19:20:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbgFDTUQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Jun 2020 15:20:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:35464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbgFDTUQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Jun 2020 15:20:16 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 175BD206E6;
        Thu,  4 Jun 2020 19:20:15 +0000 (UTC)
Date:   Thu, 4 Jun 2020 15:20:13 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: [POC] Add APIs for extracting DWARF
 information from a file
Message-ID: <20200604152013.248629a5@oasis.local.home>
In-Reply-To: <20200521105519.31391-1-tz.stoyanov@gmail.com>
References: <20200521105519.31391-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 21 May 2020 13:55:19 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:


Hi Tzvetomir,

Thanks for doing this.

> Added initial infrastructure and trace-cmd library APIs for working with
> DWARF debug information:
>  trace_obj_debug_create()
>  trace_obj_debug_destroy()
>  trace_obj_debug_get_fileoffset()
> These APIs utilize libdwarf and libbfd for parsing ELF and DWARF headers
> of the files. The trace_obj_debug_get_fileoffset() API retrieves the
> offset in the file of the given functions. These offsets can be used to
> set a uprobes to the functions.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  Makefile                        |  12 ++
>  include/trace-cmd/trace-cmd.h   |  14 ++
>  lib/trace-cmd/Makefile          |  17 ++
>  lib/trace-cmd/trace-obj-debug.c | 340 ++++++++++++++++++++++++++++++++
>  4 files changed, 383 insertions(+)
>  create mode 100644 lib/trace-cmd/trace-obj-debug.c
> 
> diff --git a/Makefile b/Makefile
> index 2f9620e4..d737b588 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -243,6 +243,18 @@ endif
>  CUNIT_INSTALLED := $(shell if (echo -e "\#include <CUnit/Basic.h>\n void main(){CU_initialize_registry();}" | $(CC) -x c -lcunit - >/dev/null 2>&1) ; then echo 1; else echo 0 ; fi)
>  export CUNIT_INSTALLED
>  
> +DWARF_INSTALLED := $(shell if (echo -e "\#include <libdwarf/libdwarf.h>\n void main(){dwarf_init(-1, 0, 0, 0, 0, 0);}" | $(CC) -xc - -ldwarf >/dev/null 2>&1) ; then echo 1; else echo 0 ; fi)
> +export DWARF_INSTALLED
> +BFD_INSTALLED := $(shell if (echo -e "\#include <bfd.h>\n void main(){bfd_init();}" | $(CC) -xc  - -lbfd >/dev/null 2>&1) ; then echo 1; else echo 0 ; fi)
> +export BFD_INSTALLED
> +
> +ifeq ($(BFD_INSTALLED), 1)
> +LIBS += -lbfd
> +endif
> +ifeq ($(DWARF_INSTALLED), 1)
> +LIBS += -ldwarf
> +endif
> +
>  export CFLAGS
>  export INCLUDES
>  
> diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
> index f3c95f30..5ad75b30 100644
> --- a/include/trace-cmd/trace-cmd.h
> +++ b/include/trace-cmd/trace-cmd.h
> @@ -483,6 +483,20 @@ void tracecmd_plog(const char *fmt, ...);
>  void tracecmd_plog_error(const char *fmt, ...);
>  int tracecmd_set_logfile(char *logfile);
>  
> +/* --- Object debug --- */
> +struct trace_obj_debug;

Add a space here. It's fine to butt single lines declarations together,
but lets keep full struct declarations separated.

> +struct trace_obj_symbols {
> +	struct trace_obj_symbols *next;
> +	char *name;	/* symbol name */
> +	unsigned long long vma; /* symbol virtual memory address */
> +	unsigned long long foffset; /* symbol file offset */
> +};
> +
> +struct trace_obj_debug *trace_obj_debug_create(char *file);
> +void trace_obj_debug_destroy(struct trace_obj_debug *obj);
> +int trace_obj_debug_get_fileoffset(struct trace_obj_debug *obj,
> +				   struct trace_obj_symbols *symbols);

Are these something we want in the tracecmd library? If so they should
have a "tracecmd_" prefix and not "trace_". We use the "trace_" prefix
for internal functions that are not part of the libraries API.

> +
>  /* --- System --- */
>  unsigned long long tracecmd_generate_traceid(void);
>  int tracecmd_count_cpus(void);
> diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
> index ab7440ac..72d3864a 100644
> --- a/lib/trace-cmd/Makefile
> +++ b/lib/trace-cmd/Makefile
> @@ -22,6 +22,16 @@ OBJS += trace-timesync.o
>  OBJS += trace-blk-hack.o
>  OBJS += trace-ftrace.o
>  
> +ifeq ($(BFD_INSTALLED), 1)
> +ifeq ($(DWARF_INSTALLED), 1)
> +OBJS += trace-obj-debug.o
> +else
> +$(warning libdwarf is not installed)
> +endif
> +else
> +$(warning libbfd is not installed)
> +endif
> +
>  OBJS := $(OBJS:%.o=$(bdir)/%.o)
>  DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
>  
> @@ -38,6 +48,13 @@ $(bdir)/libtracecmd.a: $(OBJS)
>  
>  LIBS = -L$(obj)/lib/traceevent -ltraceevent
>  
> +ifeq ($(BFD_INSTALLED), 1)
> +LIBS += -lbfd
> +endif
> +ifeq ($(DWARF_INSTALLED), 1)
> +LIBS += -ldwarf
> +endif
> +
>  $(bdir)/libtracecmd.so: $(OBJS)
>  	$(Q)$(call do_compile_shared_library)
>  
> diff --git a/lib/trace-cmd/trace-obj-debug.c b/lib/trace-cmd/trace-obj-debug.c
> new file mode 100644
> index 00000000..e98185a4
> --- /dev/null
> +++ b/lib/trace-cmd/trace-obj-debug.c
> @@ -0,0 +1,340 @@
> +// SPDX-License-Identifier: LGPL-2.1
> +/*
> + * Copyright (C) 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>

This file looks completely written by you. You can remove my name from it.

> + * Copyright (C) 2020, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
> + *
> + */
> +#include <stdlib.h>
> +#include <stdio.h>
> +#include <string.h>
> +#include <dwarf.h>
> +#include <libdwarf/libdwarf.h>
> +#include <bfd.h>
> +#include "trace-cmd-local.h"
> +#include "trace-cmd.h"
> +
> +struct trace_obj_debug {
> +	Dwarf_Debug dwarf;
> +	bfd *bfd;
> +};
> +
> +static void dwarf_error_handler(Dwarf_Error error, Dwarf_Ptr errarg)
> +{
> +	warning("\nlibdwarf error detected: 0x%" DW_PR_DUx " %s\n",
> +		dwarf_errno(error), dwarf_errmsg(error));
> +}
> +
> +static void get_addr(Dwarf_Attribute attr, Dwarf_Addr *val)
> +{
> +	Dwarf_Error error = 0;
> +	Dwarf_Addr uval = 0;
> +	int res;
> +
> +	res = dwarf_formaddr(attr, &uval, &error);
> +	if (res == DW_DLV_OK)
> +		*val = uval;

Hmm, shouldn't this function return a success or failure? Or does it
not matter?

> +}
> +
> +static void dwarf_get_subprog(Dwarf_Debug dbg, Dwarf_Die die,
> +			      struct trace_obj_symbols *data, const char *name)
> +{
> +	Dwarf_Attribute *attrbuf = 0;
> +	Dwarf_Signed attrcount = 0;
> +	Dwarf_Error error = 0;
> +	Dwarf_Addr lowpc = 0;
> +	Dwarf_Half aform;
> +	Dwarf_Signed i;
> +	int res;
> +
> +	res = dwarf_attrlist(die, &attrbuf, &attrcount, &error);
> +	if (res != DW_DLV_OK)
> +		return;

This function should probably return success or failure.


> +	for (i = 0; i < attrcount ; ++i) {
> +		res = dwarf_whatattr(attrbuf[i], &aform, &error);
> +		if (res == DW_DLV_OK) {
> +			if (aform == DW_AT_low_pc)
> +				get_addr(attrbuf[i], &lowpc);

Hmm, what if we get more than one match? Should we break out of the
loop on a match?

> +		}
> +		dwarf_dealloc(dbg, attrbuf[i], DW_DLA_ATTR);
> +	}
> +
> +	while (data) {
> +		if (lowpc && !strcmp(name, data->name))
> +			data->vma = lowpc;

Is it possible to have more than one match here too?

> +		data = data->next;
> +	}
> +
> +	dwarf_dealloc(dbg, attrbuf, DW_DLA_LIST);
> +}
> +
> +
> +static void dwarf_get_die_data(Dwarf_Debug dbg, Dwarf_Die die,
> +			       struct trace_obj_symbols *data)

This should probably return a status as well.

> +{
> +	const char *formname = 0;
> +	Dwarf_Attribute attr = 0;
> +	const char *tagname = 0;
> +	Dwarf_Half formnum = 0;
> +	Dwarf_Error error = 0;
> +	Dwarf_Half tag = 0;
> +	char *name = 0;

Pointers should be assigned to NULL not 0.

> +	int res = 0;
> +
> +	res = dwarf_diename(die, &name, &error);
> +	if (res == DW_DLV_ERROR) {
> +		warning("Error in dwarf_diename: %s\n", dwarf_errmsg(error));
> +		return;
> +	}
> +	if (res == DW_DLV_NO_ENTRY)
> +		name = "<no DW_AT_name attr>";
> +
> +	res = dwarf_tag(die, &tag, &error);
> +	if (res != DW_DLV_OK) {
> +		warning("Error in dwarf_tag: %s n", dwarf_errmsg(error));
> +		return;
> +	}
> +	res = dwarf_get_TAG_name(tag, &tagname);
> +	if (res != DW_DLV_OK) {
> +		warning("Error in dwarf_get_TAG_name: %s\n", dwarf_errmsg(error));
> +		return;
> +	}
> +
> +	res = dwarf_attr(die, DW_AT_name, &attr, &error);
> +	if (res == DW_DLV_OK) {
> +		res = dwarf_whatform(attr, &formnum, &error);
> +		if (res != DW_DLV_OK) {
> +			warning("Error in dwarf_whatform: %s\n",
> +				dwarf_errmsg(error));
> +			return;
> +		}
> +		formname = "form-name-unavailable";
> +		res = dwarf_get_FORM_name(formnum, &formname);
> +		if (res != DW_DLV_OK)
> +			formname = "UNKNoWn FORM!";
> +		dwarf_dealloc(dbg, attr, DW_DLA_ATTR);
> +	}
> +
> +	if (tag == DW_TAG_subprogram)
> +		dwarf_get_subprog(dbg, die, data, name);
> +}

The rest looks good. I'll play a little more with it.

-- Steve

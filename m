Return-Path: <SRS0=TigW=C2=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C53BDC433E2
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Sep 2020 13:51:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6518B21582
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Sep 2020 13:51:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgIQNuv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Sep 2020 09:50:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:50216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726794AbgIQNus (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Sep 2020 09:50:48 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B461B2076D;
        Thu, 17 Sep 2020 13:42:36 +0000 (UTC)
Date:   Thu, 17 Sep 2020 09:42:35 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] trace-cmd: New internal APIs for reading ELF
 header
Message-ID: <20200917094235.05098d69@gandalf.local.home>
In-Reply-To: <20200916114709.291533-3-tz.stoyanov@gmail.com>
References: <20200916114709.291533-1-tz.stoyanov@gmail.com>
        <20200916114709.291533-3-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 16 Sep 2020 14:47:08 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +#define RESOLVE_NAME		(1 << 0)
> +#define RESOLVE_VMA		(1 << 1)
> +#define RESOLVE_FOFFSET		(1 << 2)
> +struct trace_obj_job {
> +	unsigned int flags;
> +	unsigned long long addr_offset;
> +	struct debug_symbols *symbols;
> +};
> +
> +struct dwarf_bfd_context {
> +	asymbol **table;
> +	struct trace_obj_job *job;
> +};
> +
> +static void bfd_dwarf_section(bfd *abfd, asection *section, void *param)

Another small comment. Do not name any function that starts with "bfd_" as
that makes it hard to know the difference between these functions and
functions from the bfd library. The only functions that should have bfd_ as
the start are those in the library.

Could call this: dwarf_bfd_section()?


> +{
> +	struct dwarf_bfd_context *context = (struct dwarf_bfd_context *)param;
> +	unsigned int discriminator;
> +	const char *functionname;
> +	struct debug_symbols *s;
> +	unsigned long long vma;
> +	const char *filename;
> +	unsigned int line;
> +	bfd_boolean found;
> +
> +	if (!(section->flags & SEC_CODE))
> +		return;
> +
> +	for (s = context->job->symbols; s; s = s->next) {
> +		if (s->symbol.vma_near)
> +			vma = s->symbol.vma_near;
> +		else if (s->symbol.vma_start)
> +			vma = s->symbol.vma_start;
> +		else
> +			continue;
> +
> +		if (abfd->flags & DYNAMIC)
> +			vma -=  context->job->addr_offset;
> +		if (vma && section->vma <= vma &&
> +		    (section->vma + section->size) > vma) {
> +			if (!s->symbol.fname)
> +				s->symbol.fname = strdup(abfd->filename);
> +			if (context->job->flags & RESOLVE_FOFFSET)
> +				s->symbol.foffset = section->filepos + (vma - section->vma);
> +			if (!s->symbol.name && (context->job->flags & RESOLVE_NAME)) {
> +				found = bfd_find_nearest_line_discriminator(abfd, section, context->table,
> +									    vma - section->vma, &filename,
> +									    &functionname, &line, &discriminator);
> +				if (found)
> +					s->symbol.name = strdup(functionname);
> +			}
> +		}
> +	}
> +}
> +
> +static asymbol **get_sym_table(bfd *handle)
> +{
> +	bfd_boolean dyn = FALSE;
> +	asymbol **symtable;
> +	long count;
> +	long size;
> +
> +	if ((bfd_get_file_flags(handle) & HAS_SYMS) == 0)
> +		return NULL;
> +	size = bfd_get_symtab_upper_bound(handle);
> +	if (size == 0) {
> +		size = bfd_get_dynamic_symtab_upper_bound(handle);
> +		dyn = TRUE;
> +	}
> +	if (size <= 0)
> +		return NULL;
> +
> +	symtable = (asymbol **) calloc(1, size);
> +	if (!symtable)
> +		return NULL;
> +	if (dyn)
> +		count = bfd_canonicalize_dynamic_symtab(handle, symtable);
> +	else
> +		count = bfd_canonicalize_symtab(handle, symtable);
> +	if (count <= 0) {
> +		free(symtable);
> +		return NULL;
> +	}
> +/*
> + *	 alloc = bfd_demangle(cur_bfd, name, demangle_flags);
> + */
> +
> +	return symtable;
> +}
> +
> +static int sym_match(char *pattern, regex_t *regex, const char *symbol)
> +{
> +	if (strlen(pattern) == strlen(symbol) &&
> +	    !strcmp(pattern, symbol))
> +		return 0;
> +	if (regex && !regexec(regex, symbol, 0, NULL, 0))
> +		return 1;
> +
> +	return -1;
> +}
> +
> +static int bfd_symlookup(struct dwarf_bfd_context *context)

Same here: lookup_bfd_sym()?

> +{
> +	struct debug_symbols *s, *last = NULL;
> +	struct debug_symbols *new, *new_list = NULL;
> +	unsigned long long vma;
> +	asymbol **sp;
> +	int res = 0;
> +	int ret;
> +
> +	for (sp = context->table; *sp != NULL; sp++) {
> +		if (!((*sp)->flags & BSF_FUNCTION))
> +			continue;
> +		for (s = context->job->symbols; s; s = s->next) {
> +			last = s;
> +			ret = sym_match(s->symbol.name, s->regex, (*sp)->name);
> +			if (ret < 0)
> +				continue;
> +			vma = (*sp)->value + (*sp)->section->vma;
> +			if ((*sp)->the_bfd->flags & DYNAMIC)
> +				vma += context->job->addr_offset;
> +			if (ret == 0) { /* exact match */
> +				s->symbol.vma_start = vma;
> +			} else { /* regex pattern match */
> +				new = calloc(1, sizeof(struct debug_symbols));
> +				if (!new)
> +					break;
> +				new->symbol.name = strdup((*sp)->name);
> +				new->symbol.vma_start = vma;
> +				new->symbol.vma_near = s->symbol.vma_near;
> +				new->symbol.foffset = s->symbol.foffset;
> +				if (s->symbol.fname)
> +					new->symbol.fname = strdup(s->symbol.fname);
> +				new->next = new_list;
> +				new_list = new;
> +			}
> +			res++;
> +		}
> +	}
> +	if (last && !last->next)
> +		last->next = new_list;
> +
> +	return res;
> +}
> +
> +static int bfd_process_object(bfd *abfd, struct trace_obj_job *job)

find_bfd_process_object()?

> +{
> +	struct dwarf_bfd_context context;
> +	int ret = 0;
> +
> +	memset(&context, 0, sizeof(context));
> +	context.job = job;
> +
> +	if (bfd_check_format_matches(abfd, bfd_object, NULL) ||
> +	    bfd_check_format_matches(abfd, bfd_core, NULL)) {
> +		context.table = get_sym_table(abfd);
> +		if (job->flags & RESOLVE_VMA)
> +			bfd_symlookup(&context);
> +		if ((job->flags & RESOLVE_NAME) || (job->flags & RESOLVE_FOFFSET))
> +			bfd_map_over_sections(abfd, bfd_dwarf_section, &context);
> +		free(context.table);
> +	} else {
> +		ret = -1;
> +	}
> +
> +	return ret;
> +}
> +
> +static int bfd_read_all(bfd *abfd, struct trace_obj_job *job)

  read_all_bfd()?

-- Steve

> +{
> +	bfd *last_arfile = NULL;
> +	bfd *arfile = NULL;
> +	int ret = 0;
> +
> +	if (bfd_check_format(abfd, bfd_archive)) {
> +		for (;;) {
> +			bfd_set_error(bfd_error_no_error);
> +			arfile = bfd_openr_next_archived_file(abfd, arfile);
> +			if (!arfile) {
> +				if (bfd_get_error() != bfd_error_no_more_archived_files)
> +					break;
> +			}
> +			ret = bfd_read_all(arfile, job);
> +			if (last_arfile)
> +				bfd_close(last_arfile);
> +			last_arfile = arfile;
> +		}
> +		if (last_arfile)
> +			bfd_close(last_arfile);
> +	} else
> +		ret = bfd_process_object(abfd, job);
> +
> +	return ret;
> +}
> +

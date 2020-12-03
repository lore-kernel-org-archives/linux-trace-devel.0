Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFE95C71156
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Dec 2020 06:03:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D79F205ED
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Dec 2020 06:03:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728474AbgLCGDU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 3 Dec 2020 01:03:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbgLCGDU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 3 Dec 2020 01:03:20 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF7EC061A52
        for <linux-trace-devel@vger.kernel.org>; Wed,  2 Dec 2020 22:02:33 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id a16so1698309ejj.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 02 Dec 2020 22:02:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7pS8BVEtemntjq38FeleENrPpILc5kzKJk/KYM2scYk=;
        b=gEvsAesiqfWcMNxZmxQ9GVBobykxVMw2xHN7FucKOk8zEaSf9kl4rtCpg3l396FdbM
         1p7TNhySPobMR0aKRd6mpxEKDCrqkBmi3oLx2/v/oKJWlNyoLi3YpuZAIplotG3UivNm
         WX4Dtrw9S+wyKBr3pBoXsevLVCajjgOn49aU6jc2yYAOR15mra4w3RKDDz40r8ErHIDg
         YoEHpIv41GelBFUCqpDPftrtbtnNF+8btC28t4vcsuHtCo1Ue5bbs6DF9d8clI8nWdtZ
         Mb+LEi069x2iIm/ptHURyyfQIR1TNdd2qJw2sJCwyBSK0/gOh6IAJ5fEqJZEIpNattkn
         /+ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7pS8BVEtemntjq38FeleENrPpILc5kzKJk/KYM2scYk=;
        b=kOdYbJPp5btsZ1sH6oKNfN5vgYdzkdYQGWsDstgbIkVB+iRkEEx3ZqbsTA+06mlP9m
         zHfhS4U1bE0rZNQg3V6rSn09lJ/A3a9ub7Kg7ej65KZInmrn8hgu4fzNxY+BV7HBmXNx
         WR0lpSlgYC3YMOHiQ93oYK2APE7GJtlcYeNtx9XkJ09NZU4Zo2k6ib0ywQUuOySSCFxg
         oa9euu7dKrvxNST2EBXyhrxkki45sqgSmPGoP9CPMhfPRLXM5uh3WUOvIlxnzGUi2W7e
         tMLU/snHUJ1/0dJaukKTrgenYVPsVrMRdih2yEYDa3VHqbgTjrEE3hBqnge/cE2edLRN
         pWdA==
X-Gm-Message-State: AOAM532qCpZMwldYwRMnA9W2pkSMMtPk1CHMMxR7fP9wQ+VVA9ABzgqI
        br0X0F+2uDh+nk4nczrcVUM=
X-Google-Smtp-Source: ABdhPJziVrvjzRVCeS3agZIsxW6SwiYcCfqfAAsF/Hjsrm/xlW8PcvOI1XK7oemziaRA0xzl/dIwMA==
X-Received: by 2002:a17:906:7f13:: with SMTP id d19mr1206193ejr.54.1606975352375;
        Wed, 02 Dec 2020 22:02:32 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d9sm388629edk.86.2020.12.02.22.02.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 22:02:31 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/5] trace-cmd: New internal APIs for reading ELF header
Date:   Thu,  3 Dec 2020 08:02:24 +0200
Message-Id: <20201203060226.476475-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201203060226.476475-1-tz.stoyanov@gmail.com>
References: <20201203060226.476475-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Implemented new trace-cmd internal APIs for parsing ELF header and
resolving VMA to function name and function name to VMA and file offset.
The bfd library is used to read and parse the binary file. The new APIs
are part of trace-cmd application and are visible only inside its
context.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Makefile                       |  10 +
 tracecmd/include/trace-local.h |  24 +
 tracecmd/trace-obj-debug.c     | 769 +++++++++++++++++++++++++++++++++
 3 files changed, 803 insertions(+)

diff --git a/Makefile b/Makefile
index 8626b91b..1ca933a7 100644
--- a/Makefile
+++ b/Makefile
@@ -246,6 +246,16 @@ endif
 CUNIT_INSTALLED := $(shell if (printf "$(pound)include <CUnit/Basic.h>\n void main(){CU_initialize_registry();}" | $(CC) -x c - -lcunit >/dev/null 2>&1) ; then echo 1; else echo 0 ; fi)
 export CUNIT_INSTALLED
 
+BFD_INSTALLED := $(shell if (echo -e "$(pound)include <bfd.h>\n void main(){bfd_init();}" | $(CC) -o /dev/null -xc  - -lbfd >/dev/null 2>&1) ; then echo 1; else echo 0 ; fi)
+
+export BFD_INSTALLED
+ifeq ($(BFD_INSTALLED), 1)
+CFLAGS += -DBFD_INSTALLED
+LIBS += -lbfd
+else
+$(warning libbfd is not installed)
+endif
+
 export CFLAGS
 export INCLUDES
 
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 109c3328..cd2d34a4 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -318,5 +318,29 @@ struct pid_addr_maps {
 int trace_debug_get_filemap(struct pid_addr_maps **file_maps, int pid);
 void trace_debug_free_filemap(struct pid_addr_maps *maps);
 
+struct tracecmd_debug_symbols {
+	char *name;			/* symbol's name */
+	char *fname;			/* symbol's file */
+	unsigned long long vma_start;	/* symbol's start VMA */
+	unsigned long long vma_near;	/* symbol's requested VMA */
+	unsigned long long foffset;	/* symbol's offset in the binary file*/
+};
+struct trace_debug_object;
+struct trace_debug_object *trace_debug_obj_create_file(char *file, bool libs);
+struct trace_debug_object *trace_debug_obj_create_pid(int pid);
+void trace_debug_obj_destroy(struct trace_debug_object *debug);
+int trace_debug_obj_add_file(struct trace_debug_object *dbg, char *file_name,
+			     unsigned long long vmem_start,
+			     unsigned long long vmem_end,
+			     unsigned long long pgoff);
+
+int trace_debug_resolve_symbols(struct trace_debug_object *obj);
+int trace_debug_add_resolve_symbol(struct trace_debug_object *obj,
+				   unsigned long long vma, char *name);
+
+void trace_debug_walk_resolved_symbols(struct trace_debug_object *obj,
+				       int (*callback)(struct tracecmd_debug_symbols *, void *),
+				       void *context);
+
 int trace_read_file_string(int fd, char *dst, int len);
 #endif /* __TRACE_LOCAL_H */
diff --git a/tracecmd/trace-obj-debug.c b/tracecmd/trace-obj-debug.c
index 9aa9baae..6a4ae1da 100644
--- a/tracecmd/trace-obj-debug.c
+++ b/tracecmd/trace-obj-debug.c
@@ -4,10 +4,779 @@
  *
  */
 #include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <limits.h>
 #include <errno.h>
+#include <bfd.h>
 #include <unistd.h>
+#include <dlfcn.h>
+#include <fnmatch.h>
 
 #include "trace-local.h"
+#include "trace-cmd.h"
+
+//#define DEBUG_INTERNALS
+
+#ifdef BFD_INSTALLED
+
+struct trace_debug_handle {
+	bfd *bfd;
+	unsigned long long addr_offset;
+};
+
+enum match_type {
+	MATCH_EXACT	= 0,
+	MATH_WILDCARD	= 1,
+};
+struct debug_symbols {
+	struct debug_symbols		*next;
+	struct tracecmd_debug_symbols	symbol;
+	enum match_type			match;
+};
+
+struct trace_debug_file {
+	struct trace_debug_file		*next;
+	char				*file_name;
+	unsigned long long		vmem_start;
+	unsigned long long		vmem_end;
+	struct trace_debug_handle	*dbg;
+	int				sym_count;
+	struct debug_symbols		*sym; /* symbols to resolve,
+					       * look in this file only
+					       */
+};
+
+struct trace_debug_object {
+	int				pid;
+	char				*fname;
+	struct pid_addr_maps		*fmaps;
+	int				sym_count;
+	struct debug_symbols		*sym;	/* symbols to resolve,
+						 * look into all files
+						 */
+	struct trace_debug_file		*files;
+};
+
+#define RESOLVE_NAME		(1 << 0)
+#define RESOLVE_VMA		(1 << 1)
+#define RESOLVE_FOFFSET		(1 << 2)
+struct trace_obj_job {
+	unsigned int flags;
+	unsigned long long addr_offset;
+	struct debug_symbols *symbols;
+};
+
+struct dwarf_bfd_context {
+	asymbol **table;
+	struct trace_obj_job *job;
+};
+
+static void process_bfd_section(bfd *abfd, asection *section, void *param)
+{
+	struct dwarf_bfd_context *context = (struct dwarf_bfd_context *)param;
+	unsigned int discriminator;
+	const char *functionname;
+	struct debug_symbols *s;
+	unsigned long long vma;
+	const char *filename;
+	unsigned int line;
+	bfd_boolean found;
+
+	if (!(section->flags & SEC_CODE))
+		return;
+
+	for (s = context->job->symbols; s; s = s->next) {
+		if (s->symbol.vma_near)
+			vma = s->symbol.vma_near;
+		else if (s->symbol.vma_start)
+			vma = s->symbol.vma_start;
+		else
+			continue;
+
+		if (abfd->flags & DYNAMIC)
+			vma -=  context->job->addr_offset;
+		if (vma && section->vma <= vma &&
+		    (section->vma + section->size) > vma) {
+			if (!s->symbol.fname)
+				s->symbol.fname = strdup(abfd->filename);
+			if (context->job->flags & RESOLVE_FOFFSET)
+				s->symbol.foffset = section->filepos + (vma - section->vma);
+			if (!s->symbol.name && (context->job->flags & RESOLVE_NAME)) {
+				found = bfd_find_nearest_line_discriminator(abfd, section, context->table,
+									    vma - section->vma, &filename,
+									    &functionname, &line, &discriminator);
+				if (found)
+					s->symbol.name = strdup(functionname);
+			}
+		}
+	}
+}
+
+static asymbol **get_sym_table(bfd *handle)
+{
+	bfd_boolean dyn = FALSE;
+	asymbol **symtable;
+	long count;
+	long size;
+
+	if ((bfd_get_file_flags(handle) & HAS_SYMS) == 0)
+		return NULL;
+	size = bfd_get_symtab_upper_bound(handle);
+	if (size == 0) {
+		size = bfd_get_dynamic_symtab_upper_bound(handle);
+		dyn = TRUE;
+	}
+	if (size <= 0)
+		return NULL;
+
+	symtable = (asymbol **) calloc(1, size);
+	if (!symtable)
+		return NULL;
+	if (dyn)
+		count = bfd_canonicalize_dynamic_symtab(handle, symtable);
+	else
+		count = bfd_canonicalize_symtab(handle, symtable);
+	if (count <= 0) {
+		free(symtable);
+		return NULL;
+	}
+/*
+ *	 alloc = bfd_demangle(cur_bfd, name, demangle_flags);
+ */
+
+	return symtable;
+}
+
+static bool sym_match(char *pattern, enum match_type match, const char *symbol)
+{
+	bool ret = false;
+
+	switch (match) {
+	case MATCH_EXACT:
+		if (strlen(pattern) == strlen(symbol) &&
+		    !strcmp(pattern, symbol))
+			ret = true;
+		break;
+	case MATH_WILDCARD:
+		if (!fnmatch(pattern, symbol, 0))
+			ret = true;
+		break;
+	}
+
+	return ret;
+}
+
+static int lookup_bfd_sym(struct dwarf_bfd_context *context)
+{
+	struct debug_symbols *s, *last = NULL;
+	struct debug_symbols *new, *new_list = NULL;
+	unsigned long long vma;
+	asymbol **sp;
+	int res = 0;
+
+	for (sp = context->table; *sp != NULL; sp++) {
+		if (!((*sp)->flags & BSF_FUNCTION))
+			continue;
+		for (s = context->job->symbols; s; s = s->next) {
+			if (!s->symbol.name)
+				continue;
+			last = s;
+			if (!sym_match(s->symbol.name, s->match, (*sp)->name))
+				continue;
+#ifdef DEBUG_INTERNALS
+			printf("Matched %s, pattern %s\n\r", (*sp)->name, s->symbol.name);
+#endif
+			vma = (*sp)->value + (*sp)->section->vma;
+			if ((*sp)->the_bfd->flags & DYNAMIC)
+				vma += context->job->addr_offset;
+			if (s->match == MATCH_EXACT) { /* exact match */
+				s->symbol.vma_start = vma;
+			} else if (s->match == MATH_WILDCARD) { /* wildcard pattern match */
+				new = calloc(1, sizeof(struct debug_symbols));
+				if (!new)
+					break;
+				new->symbol.name = strdup((*sp)->name);
+				new->symbol.vma_start = vma;
+				new->symbol.vma_near = s->symbol.vma_near;
+				new->symbol.foffset = s->symbol.foffset;
+				if (s->symbol.fname)
+					new->symbol.fname = strdup(s->symbol.fname);
+				new->next = new_list;
+				new_list = new;
+			}
+			res++;
+		}
+	}
+	if (last && !last->next)
+		last->next = new_list;
+
+	return res;
+}
+
+static int process_bfd_object(bfd *abfd, struct trace_obj_job *job)
+{
+	struct dwarf_bfd_context context;
+	int ret = 0;
+
+	memset(&context, 0, sizeof(context));
+	context.job = job;
+
+	if (bfd_check_format_matches(abfd, bfd_object, NULL) ||
+	    bfd_check_format_matches(abfd, bfd_core, NULL)) {
+		context.table = get_sym_table(abfd);
+		if (!context.table)
+			return -1;
+		if (job->flags & RESOLVE_VMA)
+			lookup_bfd_sym(&context);
+		if ((job->flags & RESOLVE_NAME) || (job->flags & RESOLVE_FOFFSET))
+			bfd_map_over_sections(abfd, process_bfd_section, &context);
+		free(context.table);
+	} else {
+		ret = -1;
+	}
+
+	return ret;
+}
+
+static int read_all_bfd(bfd *abfd, struct trace_obj_job *job)
+{
+	bfd *last_arfile = NULL;
+	bfd *arfile = NULL;
+	int ret = 0;
+
+	if (bfd_check_format(abfd, bfd_archive)) {
+		for (;;) {
+			bfd_set_error(bfd_error_no_error);
+			arfile = bfd_openr_next_archived_file(abfd, arfile);
+			if (!arfile) {
+				if (bfd_get_error() != bfd_error_no_more_archived_files)
+					break;
+			}
+			ret = read_all_bfd(arfile, job);
+			if (last_arfile)
+				bfd_close(last_arfile);
+			last_arfile = arfile;
+		}
+		if (last_arfile)
+			bfd_close(last_arfile);
+	} else
+		ret = process_bfd_object(abfd, job);
+
+	return ret;
+}
+
+/**
+ * resolve_symbol_vma - name -> (vma, file offset) resolving
+ * @obj - pointer to object, returned by trace_obj_debug_create()
+ * @symbols - link list with desired symbols, with given name
+ *
+ * Get VMA and file offset of the symbols with given name
+ * Return 0 on success, -1 on error
+ */
+static int resolve_symbol_vma(struct trace_debug_handle *obj,
+			      struct debug_symbols *symbols)
+{
+	struct trace_obj_job job;
+	int ret;
+
+	memset(&job, 0, sizeof(job));
+	job.flags |= RESOLVE_VMA;
+	job.flags |= RESOLVE_FOFFSET;
+	job.symbols = symbols;
+	job.addr_offset = obj->addr_offset;
+	ret = read_all_bfd(obj->bfd, &job);
+
+	return ret;
+}
+
+/**
+ * resolve_symbol_name - vma -> name resolving
+ * @obj - pointer to object, returned by trace_obj_debug_create()
+ * @symbols - link list with desired symbols, with given VMA
+ *
+ * Get names of the symbols with given VMA, look for nearest symbol to that VMA
+ * Return 0 on success, -1 on error
+ */
+static int resolve_symbol_name(struct trace_debug_handle *obj,
+			       struct debug_symbols *symbols)
+{
+	struct trace_obj_job job;
+
+	if (!obj || !obj->bfd)
+		return -1;
+	memset(&job, 0, sizeof(job));
+	job.flags |= RESOLVE_NAME;
+	job.addr_offset = obj->addr_offset;
+	job.symbols = symbols;
+	return read_all_bfd(obj->bfd, &job);
+}
+
+/**
+ * debug_handle_destroy - Close file opened with trace_obj_debug_create()
+ * @obj - pointer to object, returned by trace_obj_debug_create()
+ *
+ * Close the file and free any allocated resources, related to file's debug
+ * information
+ */
+static void debug_handle_destroy(struct trace_debug_handle *obj)
+{
+	if (obj && obj->bfd)
+		bfd_close(obj->bfd);
+	free(obj);
+}
+
+/**
+ * debug_handle_create - Open binary file for parsing ELF and DWARF information
+ * @name: Name of the binary ELF file.
+ *
+ * Return pointer to trace_obj_debug structure, that can be passed to other APIs
+ * for extracting debug information from the file. NULL in case of an error.
+ */
+static struct trace_debug_handle *debug_handle_create(char *file)
+{
+	struct trace_debug_handle *obj = NULL;
+
+	obj = calloc(1, sizeof(*obj));
+	if (!obj)
+		return NULL;
+
+	bfd_init();
+	obj->bfd = bfd_openr(file, NULL);
+	if (!obj->bfd)
+		goto error;
+	obj->bfd->flags |= BFD_DECOMPRESS;
+
+	return obj;
+
+error:
+	debug_handle_destroy(obj);
+	return NULL;
+}
+
+static void set_vma_offset(struct trace_debug_handle *obj,
+				unsigned long long addr_offset)
+{
+	if (obj)
+		obj->addr_offset = addr_offset;
+}
+
+static char *get_full_name(int pid)
+{
+	char mapname[PATH_MAX+1];
+	char fname[PATH_MAX+1];
+	int ret;
+
+	sprintf(fname, "/proc/%d/exe", pid);
+	ret = readlink(fname, mapname, PATH_MAX);
+	if (ret >= PATH_MAX || ret < 0)
+		return NULL;
+	mapname[ret] = 0;
+
+	return strdup(mapname);
+}
+
+static struct trace_debug_file *get_mapped_file(struct trace_debug_object *dbg,
+						char *fname,
+						unsigned long long vmem_start)
+{
+	struct trace_debug_file *file = dbg->files;
+
+	while (file) {
+		if (!strcmp(fname, file->file_name) &&
+		    vmem_start && file->vmem_end == vmem_start)
+			break;
+		file = file->next;
+	}
+	if (file)
+		return file;
+
+	file = calloc(1, sizeof(*file));
+	if (!file)
+		return NULL;
+	file->file_name = strdup(fname);
+	file->dbg = debug_handle_create(fname);
+	file->next = dbg->files;
+	dbg->files = file;
+	return file;
+}
+
+void trace_debug_obj_destroy(struct trace_debug_object *dbg)
+{
+	struct trace_debug_file *fdel;
+	struct debug_symbols *sdel;
+
+	while (dbg->sym) {
+		sdel = dbg->sym;
+		dbg->sym = dbg->sym->next;
+		free(sdel->symbol.name);
+		free(sdel->symbol.fname);
+		free(sdel);
+	}
+	while (dbg->files) {
+		fdel = dbg->files;
+		dbg->files = dbg->files->next;
+		debug_handle_destroy(fdel->dbg);
+		while (fdel->sym) {
+			sdel = fdel->sym;
+			fdel->sym = fdel->sym->next;
+			free(sdel->symbol.name);
+			free(sdel->symbol.fname);
+			free(sdel);
+		}
+		free(fdel);
+	}
+
+	free(dbg->fname);
+	trace_debug_free_filemap(dbg->fmaps);
+	free(dbg);
+}
+
+int trace_debug_obj_add_file(struct trace_debug_object *dbg, char *file_name,
+			     unsigned long long vmem_start,
+			     unsigned long long vmem_end,
+			     unsigned long long pgoff)
+{
+	struct trace_debug_file *file;
+
+	file = get_mapped_file(dbg, file_name, vmem_start);
+	if (!file)
+		return -1;
+	if (file->vmem_end == vmem_start) {
+		file->vmem_end = vmem_end;
+	} else {
+		file->vmem_start = vmem_start;
+		file->vmem_end = vmem_end;
+		set_vma_offset(file->dbg, vmem_start - pgoff);
+	}
+
+	return 0;
+}
+
+struct trace_debug_object *trace_debug_obj_create_pid(int pid)
+{
+	struct trace_debug_object *dbg;
+	int i;
+
+	dbg = calloc(1, sizeof(*dbg));
+	if (!dbg)
+		return NULL;
+
+	dbg->pid = pid;
+	dbg->fname = get_full_name(pid);
+	if (!dbg->fname)
+		return NULL;
+	trace_debug_get_filemap(&dbg->fmaps, pid);
+
+	for (i = 0; i < dbg->fmaps->nr_lib_maps; i++) {
+		if (trace_debug_obj_add_file(dbg, dbg->fmaps->lib_maps[i].lib_name,
+				dbg->fmaps->lib_maps[i].start,
+				dbg->fmaps->lib_maps[i].end, 0) < 0)
+			break;
+	}
+	if (i < dbg->fmaps->nr_lib_maps)
+		goto error;
+
+	return dbg;
+
+error:
+	trace_debug_obj_destroy(dbg);
+	return NULL;
+}
+
+static char *get_lib_full_path(char *libname)
+{
+	void *h = dlmopen(LM_ID_NEWLM, libname, RTLD_LAZY);
+	char dldir[PATH_MAX+1];
+	char *fname = NULL;
+	int ret;
+
+	if (!h)
+		return NULL;
+	ret = dlinfo(h, RTLD_DI_ORIGIN, dldir);
+	dlclose(h);
+
+	if (!ret) {
+		ret = asprintf(&fname, "%s/%s", dldir, libname);
+		if (ret > 0)
+			return fname;
+	}
+
+	free(fname);
+	return NULL;
+
+
+}
+
+static int debug_obj_file_add_libs(struct trace_debug_object *dbg,
+				   struct trace_debug_file *file)
+{
+	char line[PATH_MAX];
+	char *libname;
+	char *trimmed;
+	char *fullname;
+	char *cmd = NULL;
+	FILE *fp = NULL;
+	int ret = -1;
+
+	if (asprintf(&cmd, "LD_TRACE_LOADED_OBJECTS=1 %s", file->file_name) < 0)
+		return -1;
+	fp = popen(cmd, "r");
+	if (!fp)
+		goto out;
+
+	while (fgets(line, sizeof(line), fp) != NULL) {
+		libname = strchr(line, ' ');
+		trimmed = line;
+		if (libname) {
+			*libname = '\0';
+			while (isspace(*trimmed))
+				trimmed++;
+			if (*trimmed != '/') {
+				fullname = get_lib_full_path(trimmed);
+				if (fullname) {
+					get_mapped_file(dbg, fullname, 0);
+					free(fullname);
+				}
+			} else {
+				get_mapped_file(dbg, trimmed, 0);
+			}
+		}
+	}
+
+out:
+	if (fp)
+		pclose(fp);
+	free(cmd);
+	return ret;
+}
+
+struct trace_debug_object *trace_debug_obj_create_file(char *fname, bool libs)
+{
+	struct trace_debug_object *dbg;
+	struct trace_debug_file *file;
+
+	dbg = calloc(1, sizeof(*dbg));
+	if (!dbg)
+		return NULL;
+
+	dbg->fname = strdup(fname);
+	file = get_mapped_file(dbg, fname, 0);
+	if (!file)
+		goto error;
+	if (libs)
+		debug_obj_file_add_libs(dbg, file);
+
+#ifdef DEBUG_INTERNALS
+	printf("Created debug object for %s:\n\r", dbg->fname);
+	file = dbg->files;
+	while (file) {
+		printf("\t%s\n\r", file->file_name);
+		file = file->next;
+	}
+#endif
+	return dbg;
+
+error:
+	trace_debug_obj_destroy(dbg);
+	return NULL;
+}
+
+static void set_unknown(struct debug_symbols *sym, char *file)
+{
+	while (sym) {
+		if (!sym->symbol.fname)
+			sym->symbol.fname = strdup(file);
+		sym = sym->next;
+	}
+}
+
+int trace_debug_resolve_symbols(struct trace_debug_object *obj)
+{
+	struct trace_debug_file *file;
+
+	for (file = obj->files; file; file = file->next) {
+		if (!file->dbg) {
+			set_unknown(file->sym, file->file_name);
+			continue;
+		}
+		/* near VMA -> name resolving */
+		resolve_symbol_name(file->dbg, file->sym);
+		/* name -> exact VMA resolving */
+		resolve_symbol_vma(file->dbg, file->sym);
+		resolve_symbol_vma(file->dbg, obj->sym);
+	}
+
+	return 0;
+}
+
+static int add_resolve_vma2name(struct trace_debug_object *obj,
+				unsigned long long vma)
+{
+	struct debug_symbols *s = NULL;
+	struct trace_debug_file *file;
+
+	file = obj->files;
+	while (file) {
+		if (vma >= file->vmem_start && vma <= file->vmem_end)
+			break;
+		file = file->next;
+	}
+	if (file) {
+		s = file->sym;
+		while (s) {
+			if (s->symbol.vma_near == vma)
+				break;
+			s = s->next;
+		}
+		if (!s) {
+			s = calloc(1, sizeof(*s));
+			if (!s)
+				return -1;
+			s->symbol.vma_near = vma;
+			s->symbol.fname = strdup(file->file_name);
+			s->next = file->sym;
+			file->sym = s;
+			file->sym_count++;
+		}
+	}
+
+	if (s)
+		return 0;
+	return -1;
+}
+
+static int add_resolve_name2vma(struct trace_debug_object *obj, char *name)
+{
+	struct debug_symbols *s = NULL;
+
+	s = obj->sym;
+	while (s) {
+		if (s->symbol.name && !strcmp(name, s->symbol.name))
+			break;
+		s = s->next;
+	}
+	if (!s) {
+		s = calloc(1, sizeof(*s));
+		if (!s)
+			return -1;
+		s->symbol.name = strdup(name);
+		if (!s->symbol.name)
+			goto error;
+		if (strchr(name, '*') || strchr(name, '?'))
+			s->match = MATH_WILDCARD;
+
+		s->next = obj->sym;
+		obj->sym = s;
+		obj->sym_count++;
+	}
+
+	return 0;
+
+error:
+	if (s) {
+		free(s->symbol.name);
+		free(s);
+	}
+	return -1;
+}
+
+int trace_debug_add_resolve_symbol(struct trace_debug_object *obj,
+				   unsigned long long vma, char *name)
+{
+	int ret = -1;
+
+	if (!obj)
+		return -1;
+
+	if (!name && vma) /* vma -> name resolving */
+		ret = add_resolve_vma2name(obj, vma);
+	else if (name) /* name -> vma resolving */
+		ret = add_resolve_name2vma(obj, name);
+	return ret;
+}
+
+static int walk_symbols(struct debug_symbols *sym,
+			int (*callback)(struct tracecmd_debug_symbols *, void *),
+			void *context)
+{
+	while (sym) {
+		if (callback(&sym->symbol, context))
+			return -1;
+		sym = sym->next;
+	}
+
+	return 0;
+}
+
+void trace_debug_walk_resolved_symbols(struct trace_debug_object *obj,
+				       int (*callback)(struct tracecmd_debug_symbols *, void *),
+				       void *context)
+{
+	struct trace_debug_file *file;
+
+	walk_symbols(obj->sym, callback, context);
+	file = obj->files;
+	while (file) {
+		walk_symbols(file->sym, callback, context);
+		file = file->next;
+	}
+}
+
+
+void trace_debug_free_symbols(struct tracecmd_debug_symbols *symbols, int count)
+{
+	int i;
+
+	if (!symbols)
+		return;
+
+	for (i = 0; i < count; i++) {
+		free(symbols[i].name);
+		free(symbols[i].fname);
+	}
+	free(symbols);
+
+}
+#else
+int trace_debug_resolve_symbols(struct trace_debug_object *obj)
+{
+	return -1;
+}
+
+int trace_debug_add_resolve_symbol(struct trace_debug_object *obj,
+				   unsigned long long vma, char *name)
+{
+	return -1;
+}
+
+void trace_debug_walk_resolved_symbols(struct trace_debug_object *obj,
+				       int (*callback)(struct tracecmd_debug_symbols *, void *),
+				       void *context)
+{
+
+}
+
+void trace_debug_free_symbols(struct tracecmd_debug_symbols *symbols, int count)
+{
+
+}
+
+void trace_debug_obj_destroy(struct trace_debug_object *debug)
+{
+
+}
+
+struct trace_debug_object *trace_debug_obj_create_file(char *file, bool libs)
+{
+	return NULL;
+}
+struct trace_debug_object *trace_debug_obj_create_pid(int pid)
+{
+	return NULL;
+}
+
+#endif
 
 #define _STRINGIFY(x) #x
 #define STRINGIFY(x) _STRINGIFY(x)
-- 
2.28.0


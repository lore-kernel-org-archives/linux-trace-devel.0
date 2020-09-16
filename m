Return-Path: <SRS0=0H5Y=CZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 780F3C433E2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Sep 2020 20:23:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E8E721973
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Sep 2020 20:23:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qv00ylbg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbgIPUWs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Sep 2020 16:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbgIPR2m (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Sep 2020 13:28:42 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BDB1C0698DC
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Sep 2020 04:47:15 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id d4so2455821wmd.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Sep 2020 04:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cB31PXnp1dMe1lx2Ke5NZb/vAdHJ5Zt7D9UrkOzDAyg=;
        b=Qv00ylbgJ2S7W3GYuhP5ZRxcsNPiJq7qD9DXuce6Ku5QC7hIPvxZfwIehoX/kXNmhu
         wT98O99yXJsAU1WZL9FYskaYUtgIyplAG4WZDNx1cd0Tf+eLt+q+c6HKl9WID4OusGdC
         DT4zx/DoImrKgkQBFOlocwF8BvWqM6O+gCz9aZf2M2xz+sbAzvTIhqSQNFPDrobnkBh0
         i8gYCtaZSDIVtH0UeLnlMR67iqZhCqVJ1V7NaIA1YYO556DrqpjvFfK4HW76vpalNMHT
         gU4jt/pD/TARbr6o71mbwOt3SqhErzxdGGSUiP4qKmE6n0OSKjr9i+RNjESS5no2KN11
         ZFuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cB31PXnp1dMe1lx2Ke5NZb/vAdHJ5Zt7D9UrkOzDAyg=;
        b=YFNAEb0m2D0qTRI1kAmVqW8c3NN6agy3V7Kpx6F0rIoEaEJqK+JyXMABIbISHQW5S7
         pAxn1bPIgDKMzI3Jsn2qjsZ/OMrTrVTGuNCNx26+KQehU+M+KfTzTJKIZ5UF8sF8ChVd
         6D0sDYeo8Jf/s5H3nkZzK8cLqcWzcCV8XZF4aDqustbr/Camao4UNOQ0LO2FMOhI5kP8
         CIzCsKIz2ejzlkYcT8d3i40DZ9dQMsC7YEbeO7CcYA+eupgraTr3B54bBBUw2YcuaE6J
         nrofIMVzjT1tXcIncBxhFdJIYZkt7h1deCbcCUe57gxkWIGyxSWqzTLeP40B9OXZc8yn
         HtuQ==
X-Gm-Message-State: AOAM530RVyngwDEsqXZKhyWBOp/d8e1g4Y6ch2/foE8nEqtINBOWqnii
        Xn5Ka9YH9WImSqtpjPAL8N4=
X-Google-Smtp-Source: ABdhPJzanR+2RGpBZZLATo1F0JrxKGLxjsWAGNKRA7dajNJpEMW/Iz8ObTx15l5ekWyrnYh3n69ZgA==
X-Received: by 2002:a1c:3bd7:: with SMTP id i206mr4351268wma.162.1600256833699;
        Wed, 16 Sep 2020 04:47:13 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z13sm32042040wro.97.2020.09.16.04.47.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 04:47:12 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 2/3] trace-cmd: New internal APIs for reading ELF header
Date:   Wed, 16 Sep 2020 14:47:08 +0300
Message-Id: <20200916114709.291533-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200916114709.291533-1-tz.stoyanov@gmail.com>
References: <20200916114709.291533-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
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
 include/trace-cmd/trace-cmd.h  |   8 +
 tracecmd/include/trace-local.h |  12 +
 tracecmd/trace-obj-debug.c     | 685 +++++++++++++++++++++++++++++++++
 4 files changed, 715 insertions(+)

diff --git a/Makefile b/Makefile
index b0340427..0d657969 100644
--- a/Makefile
+++ b/Makefile
@@ -245,6 +245,16 @@ endif
 CUNIT_INSTALLED := $(shell if (printf "$(pound)include <CUnit/Basic.h>\n void main(){CU_initialize_registry();}" | $(CC) -x c - -lcunit >/dev/null 2>&1) ; then echo 1; else echo 0 ; fi)
 export CUNIT_INSTALLED
 
+BFD_INSTALLED := $(shell if (echo -e "\#include <bfd.h>\n void main(){bfd_init();}" | $(CC) -xc  - -lbfd >/dev/null 2>&1) ; then echo 1; else echo 0 ; fi)
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
 
diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index f3c95f30..5ebd076e 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -135,6 +135,14 @@ struct tracecmd_proc_addr_map {
 	char			*lib_name;
 };
 
+struct tracecmd_debug_symbols {
+	char *name;			/* symbol's name */
+	char *fname;			/* symbol's file */
+	unsigned long long vma_start;	/* symbol's start VMA */
+	unsigned long long vma_near;	/* symbol's requested VMA */
+	unsigned long long foffset;	/* symbol's offset in the binary file*/
+};
+
 typedef void (*tracecmd_show_data_func)(struct tracecmd_input *handle,
 					struct tep_record *record);
 typedef void (*tracecmd_handle_init_func)(struct tracecmd_input *handle,
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index c5c225e0..ccae61d4 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -317,4 +317,16 @@ struct pid_addr_maps {
 int trace_debug_get_filemap(struct pid_addr_maps **file_maps, int pid);
 void trace_debug_free_filemap(struct pid_addr_maps *maps);
 
+struct trace_debug_object;
+struct trace_debug_object *trace_debug_obj_create_file(char *file);
+struct trace_debug_object *trace_debug_obj_create_pid(int pid);
+void trace_debug_obj_destroy(struct trace_debug_object *debug);
+
+int trace_debug_resolve_symbols(struct trace_debug_object *obj);
+int trace_debug_add_resolve_symbol(struct trace_debug_object *obj,
+				   unsigned long long vma, char *name);
+
+void trace_debug_walk_resolved_symbols(struct trace_debug_object *obj,
+				       int (*callback)(struct tracecmd_debug_symbols *, void *),
+				       void *context);
 #endif /* __TRACE_LOCAL_H */
diff --git a/tracecmd/trace-obj-debug.c b/tracecmd/trace-obj-debug.c
index 9aa9baae..93b0dfee 100644
--- a/tracecmd/trace-obj-debug.c
+++ b/tracecmd/trace-obj-debug.c
@@ -4,10 +4,695 @@
  *
  */
 #include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <limits.h>
 #include <errno.h>
+#include <bfd.h>
 #include <unistd.h>
 
 #include "trace-local.h"
+#include "trace-cmd.h"
+
+#ifdef BFD_INSTALLED
+
+struct trace_debug_handle {
+	bfd *bfd;
+	unsigned long long addr_offset;
+};
+
+struct trace_debug_vmem_range {
+	struct trace_debug_vmem_range	*next;
+	unsigned long long		start;
+	unsigned long long		end;
+};
+
+struct debug_symbols {
+	struct debug_symbols		*next;
+	regex_t				*regex;
+	struct tracecmd_debug_symbols	symbol;
+};
+
+struct trace_debug_file {
+	struct trace_debug_file		*next;
+	char				*file_name;
+	struct trace_debug_vmem_range	*vmem;
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
+static void bfd_dwarf_section(bfd *abfd, asection *section, void *param)
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
+static int sym_match(char *pattern, regex_t *regex, const char *symbol)
+{
+	if (strlen(pattern) == strlen(symbol) &&
+	    !strcmp(pattern, symbol))
+		return 0;
+	if (regex && !regexec(regex, symbol, 0, NULL, 0))
+		return 1;
+
+	return -1;
+}
+
+static int bfd_symlookup(struct dwarf_bfd_context *context)
+{
+	struct debug_symbols *s, *last = NULL;
+	struct debug_symbols *new, *new_list = NULL;
+	unsigned long long vma;
+	asymbol **sp;
+	int res = 0;
+	int ret;
+
+	for (sp = context->table; *sp != NULL; sp++) {
+		if (!((*sp)->flags & BSF_FUNCTION))
+			continue;
+		for (s = context->job->symbols; s; s = s->next) {
+			last = s;
+			ret = sym_match(s->symbol.name, s->regex, (*sp)->name);
+			if (ret < 0)
+				continue;
+			vma = (*sp)->value + (*sp)->section->vma;
+			if ((*sp)->the_bfd->flags & DYNAMIC)
+				vma += context->job->addr_offset;
+			if (ret == 0) { /* exact match */
+				s->symbol.vma_start = vma;
+			} else { /* regex pattern match */
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
+static int bfd_process_object(bfd *abfd, struct trace_obj_job *job)
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
+		if (job->flags & RESOLVE_VMA)
+			bfd_symlookup(&context);
+		if ((job->flags & RESOLVE_NAME) || (job->flags & RESOLVE_FOFFSET))
+			bfd_map_over_sections(abfd, bfd_dwarf_section, &context);
+		free(context.table);
+	} else {
+		ret = -1;
+	}
+
+	return ret;
+}
+
+static int bfd_read_all(bfd *abfd, struct trace_obj_job *job)
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
+			ret = bfd_read_all(arfile, job);
+			if (last_arfile)
+				bfd_close(last_arfile);
+			last_arfile = arfile;
+		}
+		if (last_arfile)
+			bfd_close(last_arfile);
+	} else
+		ret = bfd_process_object(abfd, job);
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
+	ret = bfd_read_all(obj->bfd, &job);
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
+	return bfd_read_all(obj->bfd, &job);
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
+static struct trace_debug_file *get_mapped_file(struct trace_debug_object *dbg, char *fname)
+{
+	struct trace_debug_file *file = dbg->files;
+
+	while (file) {
+		if (!strcmp(fname, file->file_name))
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
+	struct trace_debug_vmem_range *mdel;
+	struct trace_debug_file *fdel;
+	struct debug_symbols *sdel;
+
+	while (dbg->sym) {
+		sdel = dbg->sym;
+		dbg->sym = dbg->sym->next;
+		if (sdel->regex) {
+			regfree(sdel->regex);
+			free(sdel->regex);
+		}
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
+		while (fdel->vmem) {
+			mdel = fdel->vmem;
+			fdel->vmem = fdel->vmem->next;
+			free(mdel);
+		}
+		free(fdel);
+	}
+
+	free(dbg->fname);
+	trace_debug_free_filemap(dbg->fmaps);
+	free(dbg);
+}
+
+struct trace_debug_object *trace_debug_obj_create_pid(int pid)
+{
+	struct trace_debug_vmem_range *mem;
+	struct trace_debug_object *dbg;
+	struct trace_debug_file *file;
+	int i;
+
+	dbg = calloc(1, sizeof(*dbg));
+	if (!dbg)
+		return NULL;
+
+	dbg->pid = pid;
+	dbg->fname = get_full_name(pid);
+	trace_debug_get_filemap(&dbg->fmaps, pid);
+
+	for (i = 0; i < dbg->fmaps->nr_lib_maps; i++) {
+		file = get_mapped_file(dbg, dbg->fmaps->lib_maps[i].lib_name);
+		if (!file)
+			goto error;
+		if (file->vmem && file->vmem->end == dbg->fmaps->lib_maps[i].start) {
+			file->vmem->end = dbg->fmaps->lib_maps[i].end;
+		} else {
+			mem = calloc(1, sizeof(*mem));
+			if (!mem)
+				goto error;
+			mem->start = dbg->fmaps->lib_maps[i].start;
+			mem->end = dbg->fmaps->lib_maps[i].end;
+			mem->next = file->vmem;
+			file->vmem = mem;
+			set_vma_offset(file->dbg, mem->start);
+		}
+	}
+	return dbg;
+
+error:
+	trace_debug_obj_destroy(dbg);
+	return NULL;
+}
+
+struct trace_debug_object *trace_debug_obj_create_file(char *fname)
+{
+	struct trace_debug_object *dbg;
+	struct trace_debug_file *file;
+
+	dbg = calloc(1, sizeof(*dbg));
+	if (!dbg)
+		return NULL;
+
+	dbg->fname = strdup(fname);
+	file = get_mapped_file(dbg, fname);
+	if (!file)
+		goto error;
+
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
+	struct trace_debug_vmem_range *vmem;
+	struct debug_symbols *s = NULL;
+	struct trace_debug_file *file;
+
+	file = obj->files;
+	while (file) {
+		if (!file->vmem)
+			break;
+		vmem = file->vmem;
+		while (vmem) {
+			if (vma >= vmem->start && vma <= vmem->end)
+				break;
+			vmem = vmem->next;
+		}
+		if (vmem)
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
+		s->regex = calloc(1, sizeof(regex_t));
+		if (!s->regex)
+			goto error;
+		if (regcomp(s->regex, name, REG_NOSUB) < 0)
+			goto error;
+		s->next = obj->sym;
+		obj->sym = s;
+		obj->sym_count++;
+	}
+
+	return 0;
+
+error:
+	if (s) {
+		if (s->regex) {
+			regfree(s->regex);
+			free(s->regex);
+		}
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
+
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
+struct trace_debug_object *trace_debug_obj_create_file(char *file)
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
2.26.2


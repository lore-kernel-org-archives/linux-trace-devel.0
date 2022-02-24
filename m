Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CF14C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Feb 2022 16:37:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbiBXQht (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 24 Feb 2022 11:37:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiBXQht (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 24 Feb 2022 11:37:49 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55BF0392;
        Thu, 24 Feb 2022 08:37:17 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id s1so3615656edd.13;
        Thu, 24 Feb 2022 08:37:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VmpHsZZKapOjxQ2jp88/pSWnNMNHDwgAUAbl7Ogmm/g=;
        b=Ffl2JMpNyfFw7I1bx52qbvok05N2XBZyb2ytJYvW6ra2iEz8PNoi8uzJoMb/q5PVQ7
         eCWtXnRxCurqvy8d7koRv4YCIQPUazbnSFt3JLnKHsqO7lrIe79JzSGFdCLeh5K87qiu
         CQqA37EE2SL75+K1/YkkhdWreEB5ZqKWJdowiy87BVuG46+z8C4pgEHgCmv2W9giikxX
         dRZxja83+NwEl/MwlhdtY/PX/U11rtGbVFEFLswHPCASKjretJiCxysmrcWuk+EDR/XF
         7qRCSGuQ+eBkgUtKTmEmxXBRZjfVb3BsLETVE5Atf6Qustgqkz27xCli3epswQ9D9Ztd
         ukPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VmpHsZZKapOjxQ2jp88/pSWnNMNHDwgAUAbl7Ogmm/g=;
        b=1HWlz/dApCjUbsDemrvkSNJApwXDpsgG9mM/osMb+Tm/vce0vM1tSTIMTe6dF5f8CP
         3UrPgDIFLeHzp4dbQ392+hnajTq2i2HL37QUsOBj3D9ujAl5qXY8NBckBNALP96TVygQ
         GzMJz1z/7UFbDezbZIADZ/vXx1a7bgT1tsJElS+Nf2/V51SrueY4ERbgQvdsb60EEbA0
         0d9BWHljkMNM6uo2MSKDG3kwbw6FnxPGvsO+VnTYwRFxJJJHtRqB7rcO2xIBA6OqsOZC
         M1Gv13y2FLjMptR0G3kHj3cj4/eLSOqGnwWgBbJHBENJIAs2IzNFOXWD/ywnbVT0xrT/
         WaMw==
X-Gm-Message-State: AOAM533fYlgmgwF2GE3bGBk5q1r9jztxvj7mw0Zjt4H1sf2F7flGCPYr
        sM9c596hI7PMA9U5Sku2T8LONIqx9fw=
X-Google-Smtp-Source: ABdhPJxiUmfio8ifUbpOzE1o3Fa43UV3SX78O+9I9WgMnST9zhtYV+ZW6f2rkPeIYvnSdmyrHKm+Sg==
X-Received: by 2002:a05:6402:17d4:b0:413:2f6b:23c1 with SMTP id s20-20020a05640217d400b004132f6b23c1mr3084498edy.377.1645720635623;
        Thu, 24 Feb 2022 08:37:15 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id o10sm1579690ejj.6.2022.02.24.08.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 08:37:15 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     y.karadz@gmail.com, acme@kernel.org, olsajiri@gmail.com,
        irogers@google.com
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org,
        linux-perf-users@vger.kernel.org
Subject: [RFC PATCH 1/3] trace-cruncher: Logic for resolving address to function name
Date:   Thu, 24 Feb 2022 18:37:09 +0200
Message-Id: <20220224163711.185308-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220224163711.185308-1-tz.stoyanov@gmail.com>
References: <20220224163711.185308-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Resolving virtual address to function name and vise versa is useful
functionality for a trace application. Trace-cruncher can use it in two
use cases:
 - Resolving VMA to function name, when collecting user application
   performance traces with perf.
 - Resolving function name to VMA, when using ftarce uprobe dynamic
   events.

Proposed implementation uses the bfd library to parse the binary files
and read the symbol table. This information is available only if the
files are not stripped.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 src/trace-obj-debug.c | 873 ++++++++++++++++++++++++++++++++++++++++++
 src/trace-obj-debug.h |  52 +++
 2 files changed, 925 insertions(+)
 create mode 100644 src/trace-obj-debug.c
 create mode 100644 src/trace-obj-debug.h

diff --git a/src/trace-obj-debug.c b/src/trace-obj-debug.c
new file mode 100644
index 0000000..0d1015a
--- /dev/null
+++ b/src/trace-obj-debug.c
@@ -0,0 +1,873 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2020, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
+ *
+ */
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <limits.h>
+#include <errno.h>
+#include <bfd.h>
+#include <demangle.h>
+#include <unistd.h>
+#include <dlfcn.h>
+#include <fnmatch.h>
+#include <ctype.h>
+
+#include "trace-obj-debug.h"
+
+//#define DEBUG_INTERNALS
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
+#ifdef DEBUG_INTERNALS
+				printf("\n\r Find addr near 0x%X, offset 0x%X - > vma - 0x%X in %s, found %s \n\r",
+					s->symbol.vma_near, context->job->addr_offset, vma, abfd->filename,
+					found ? functionname : "NA");
+#endif
+				if (found) {
+					s->symbol.name = bfd_demangle(abfd, functionname, DMGL_AUTO);
+					if (!s->symbol.name)
+						s->symbol.name = strdup(functionname);
+				}
+			}
+		}
+	}
+}
+
+static asymbol **get_sym_table(bfd *handle)
+{
+	long size, ssize, dsize;
+	asymbol **symtable;
+	long count;
+
+	if ((bfd_get_file_flags(handle) & HAS_SYMS) == 0)
+		return NULL;
+
+	dsize = bfd_get_dynamic_symtab_upper_bound(handle);
+	size = dsize > 0 ? dsize : 0;
+
+	ssize = bfd_get_symtab_upper_bound(handle);
+	size += ssize > 0 ? ssize : 0;
+
+	if (size <= 0)
+		return NULL;
+
+	symtable = (asymbol **) calloc(1, size);
+	if (!symtable)
+		return NULL;
+
+	count = bfd_canonicalize_symtab(handle, symtable);
+	count += bfd_canonicalize_dynamic_symtab(handle, symtable + count);
+	if (count <= 0) {
+		free(symtable);
+		return NULL;
+	}
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
+	unsigned int i;
+	int ret;
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
+		ret = trace_debug_obj_add_file(dbg, dbg->fmaps->lib_maps[i].lib_name,
+					       dbg->fmaps->lib_maps[i].start,
+					       dbg->fmaps->lib_maps[i].end, 0);
+		if (ret < 0)
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
+
+#define _STRINGIFY(x) #x
+#define STRINGIFY(x) _STRINGIFY(x)
+int trace_debug_get_filemap(struct pid_addr_maps **pid_maps, int pid)
+{
+	struct pid_addr_maps *maps = *pid_maps;
+	struct tracecmd_proc_addr_map *map;
+	unsigned long long begin, end;
+	struct pid_addr_maps *m;
+	char mapname[PATH_MAX+1];
+	char fname[PATH_MAX+1];
+	char buf[PATH_MAX+100];
+	unsigned int i;
+	FILE *f;
+	int ret;
+	int res;
+
+	sprintf(fname, "/proc/%d/exe", pid);
+	ret = readlink(fname, mapname, PATH_MAX);
+	if (ret >= PATH_MAX || ret < 0)
+		return -ENOENT;
+	mapname[ret] = 0;
+
+	sprintf(fname, "/proc/%d/maps", pid);
+	f = fopen(fname, "r");
+	if (!f)
+		return -ENOENT;
+
+	while (maps) {
+		if (pid == maps->pid)
+			break;
+		maps = maps->next;
+	}
+
+	ret = -ENOMEM;
+	if (!maps) {
+		maps = calloc(1, sizeof(*maps));
+		if (!maps)
+			goto out_fail;
+		maps->pid = pid;
+		maps->next = *pid_maps;
+		*pid_maps = maps;
+	} else {
+		for (i = 0; i < maps->nr_lib_maps; i++)
+			free(maps->lib_maps[i].lib_name);
+		free(maps->lib_maps);
+		maps->lib_maps = NULL;
+		maps->nr_lib_maps = 0;
+		free(maps->proc_name);
+	}
+
+	maps->proc_name = strdup(mapname);
+	if (!maps->proc_name)
+		goto out;
+
+	while (fgets(buf, sizeof(buf), f)) {
+		mapname[0] = '\0';
+		res = sscanf(buf, "%llx-%llx %*s %*x %*s %*d %"STRINGIFY(PATH_MAX)"s",
+			     &begin, &end, mapname);
+		if (res == 3 && mapname[0] != '\0') {
+			map = realloc(maps->lib_maps,
+				      (maps->nr_lib_maps + 1) * sizeof(*map));
+			if (!map)
+				goto out_fail;
+			map[maps->nr_lib_maps].end = end;
+			map[maps->nr_lib_maps].start = begin;
+			map[maps->nr_lib_maps].lib_name = strdup(mapname);
+			if (!map[maps->nr_lib_maps].lib_name)
+				goto out_fail;
+			maps->lib_maps = map;
+			maps->nr_lib_maps++;
+		}
+	}
+out:
+	fclose(f);
+	return 0;
+
+out_fail:
+	fclose(f);
+	if (maps) {
+		for (i = 0; i < maps->nr_lib_maps; i++)
+			free(maps->lib_maps[i].lib_name);
+		if (*pid_maps != maps) {
+			m = *pid_maps;
+			while (m) {
+				if (m->next == maps) {
+					m->next = maps->next;
+					break;
+				}
+				m = m->next;
+			}
+		} else
+			*pid_maps = maps->next;
+		free(maps->lib_maps);
+		maps->lib_maps = NULL;
+		maps->nr_lib_maps = 0;
+		free(maps->proc_name);
+		maps->proc_name = NULL;
+		free(maps);
+	}
+	return ret;
+}
+
+static void procmap_free(struct pid_addr_maps *maps)
+{
+	unsigned int i;
+
+	if (!maps)
+		return;
+	if (maps->lib_maps) {
+		for (i = 0; i < maps->nr_lib_maps; i++)
+			free(maps->lib_maps[i].lib_name);
+		free(maps->lib_maps);
+	}
+	free(maps->proc_name);
+	free(maps);
+}
+
+void trace_debug_free_filemap(struct pid_addr_maps *maps)
+{
+	struct pid_addr_maps *del;
+
+	while (maps) {
+		del = maps;
+		maps = maps->next;
+		procmap_free(del);
+	}
+}
diff --git a/src/trace-obj-debug.h b/src/trace-obj-debug.h
new file mode 100644
index 0000000..4040f93
--- /dev/null
+++ b/src/trace-obj-debug.h
@@ -0,0 +1,52 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+
+/*
+ * Copyright 2022 VMware Inc, Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
+ */
+
+#ifndef _TC_TRACE_DEBUG_UTILS_
+#define _TC_TRACE_DEBUG_UTILS_
+
+/* --- Debug symbols--- */
+struct pid_addr_maps {
+	struct pid_addr_maps	*next;
+	struct tracecmd_proc_addr_map	*lib_maps;
+	unsigned int			nr_lib_maps;
+	char				*proc_name;
+	int				pid;
+};
+int trace_debug_get_filemap(struct pid_addr_maps **file_maps, int pid);
+void trace_debug_free_filemap(struct pid_addr_maps *maps);
+
+struct tracecmd_debug_symbols {
+	char *name;			/* symbol's name */
+	char *fname;			/* symbol's file */
+	unsigned long long vma_start;	/* symbol's start VMA */
+	unsigned long long vma_near;	/* symbol's requested VMA */
+	unsigned long long foffset;	/* symbol's offset in the binary file*/
+};
+
+struct tracecmd_proc_addr_map {
+	unsigned long long	start;
+	unsigned long long	end;
+	char			*lib_name;
+};
+
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
+#endif /* _TC_TRACE_DEBUG_UTILS_ */
-- 
2.34.1


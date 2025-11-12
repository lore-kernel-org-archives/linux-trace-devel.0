Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D87A2C15B4
	for <linux-trace-devel@vger.kernel.org>; Wed, 12 Nov 2025 21:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762984158; cv=none; b=WFPhBO2F70rgkMHtwElY4IrWuNHK+Bu+7WZ+gSbFS2TgpfJ3zKSwdW29RI4mBFoQFkRGK3WhYgJekplFO9E7+28DZBPN1onMCEWm3xU+KFXeecFrW3o55WVRmYIEJzIqb44R7b7USgxLfHcK3QmpcO3yrqVtL1J4tu4VLWThgb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762984158; c=relaxed/simple;
	bh=Xx3KUYInIA7qRDjQKVZYkbNrxNoN+H0Dc6AiAAEWS+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hOthUvZ+L16vCzZpqbTJm7JA4SgDIcsl7VQOiKGDy/SArKkYmrVbnt/kMPfpv1Lg3Oj65qWIIWENN77/sIluCUgcN9NJlbhlwOls20b8LmsjONUOIWPnjhXycII/OoNMdID1UHsVDQm5mVWWhfIViF8qHR5GPT0KHLg7mlcVyPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB9A2C19422;
	Wed, 12 Nov 2025 21:49:16 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1vJIiY-00000001DhX-30kM;
	Wed, 12 Nov 2025 16:49:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Douglas Raillard <douglas.raillard@arm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Takaya Saeki <takayas@google.com>,
	Ian Rogers <irogers@google.com>,
	aahringo@redhat.com,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v3 1/4] libtraceevent: Add loading of BTF to the tep handle
Date: Wed, 12 Nov 2025 16:42:35 -0500
Message-ID: <20251112214929.290686-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251112214929.290686-1-rostedt@goodmis.org>
References: <20251112214929.290686-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add loading of the BTF file /sys/kernel/btf/vmlinux into the tep_handler and
then use it to format the function tracer if it has arguments:

    cat-33501 [005] ..... 136155.767950: function:             __x64_sys_execve(regs=0xffffc9000e3eff58)
    cat-33501 [005] ..... 136155.767951: function:                getname_flags(filename=0x7ffe7d33f3d0, flags=0)
    cat-33501 [005] ..... 136155.767951: function:                getname_flags.part.0(7ffe7d33f3d0, 0, 0, 0, 0, 0)
    cat-33501 [005] ..... 136155.767951: function:                   kmem_cache_alloc_noprof(s=0xffff8881001d3800, gfpflags=0xcc0)
    cat-33501 [005] ..... 136155.767951: function:                      fs_reclaim_acquire(gfp_mask=0xcc0)
    cat-33501 [005] ..... 136155.767952: function:                      fs_reclaim_release(gfp_mask=0xcc0)
    cat-33501 [005] ..... 136155.767953: function:                      kmemleak_alloc(ptr=0xffff8881114a0000, size=0x1000, min_count=1, gfp=0xcc0)
    cat-33501 [005] ..... 136155.767953: function:                      __create_object(ptr=0xffff8881114a0000, size=0x1000, min_count=1, gfp=0xcc0, objflags=0x0)
    cat-33501 [005] ..... 136155.767954: function:                         __alloc_object(gfp=0xcc0)
    cat-33501 [005] ..... 136155.767954: function:                            kmem_cache_alloc_noprof(s=0xffff888100045700, gfpflags=0x92cc0)
    cat-33501 [005] ..... 136155.767954: function:                      fs_reclaim_acquire(gfp_mask=0x92cc0)
    cat-33501 [005] ..... 136155.767955: function:                      fs_reclaim_release(gfp_mask=0x92cc0)

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
Changes since v2: https://lore.kernel.org/20250802024035.1893851-2-rostedt@goodmis.org

- Removed debug print statement

- Replaced some printf() with tep_warning()

- Added trace-btf.c to meson build

- Added reference to BTF document: https://docs.kernel.org/bpf/btf.html

- Do not free btf->strings as that wasn't allocated.

- Fail to load if BTF endianess is different than the running machine.
  We can add support for that later.

- Make sure the raw data of str_hdr is valid (Douglas Raillard)

- Rename tep_btf_init() and tep_btf_free() to btf_init() and btf_free()
  as they no longer need to be unique as they are not exported.

- Have btf->raw_data allocated and not expect the caller to give up
  ownership of the raw_data. This allows the raw data passed in to simply
  be memory mapped.

 include/traceevent/event-parse.h |   5 +
 plugins/plugin_function.c        |  15 +-
 src/Makefile                     |   1 +
 src/event-parse-local.h          |   6 +
 src/event-parse.c                |   2 +
 src/meson.build                  |   1 +
 src/trace-btf.c                  | 457 +++++++++++++++++++++++++++++++
 7 files changed, 477 insertions(+), 10 deletions(-)
 create mode 100644 src/trace-btf.c

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index d3ce0a43a8fc..ebfc2c7abac2 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -580,6 +580,11 @@ int tep_get_ref(struct tep_handle *tep);
 
 struct kbuffer *tep_kbuffer(struct tep_handle *tep);
 
+/* BTF */
+int tep_load_btf(struct tep_handle *tep, void *raw_data, size_t data_size);
+int tep_btf_print_args(struct tep_handle *tep, struct trace_seq *s, void *args,
+		       int nmem, int size, const char *func);
+
 /* for debugging */
 void tep_print_funcs(struct tep_handle *tep);
 void tep_print_printk(struct tep_handle *tep);
diff --git a/plugins/plugin_function.c b/plugins/plugin_function.c
index a337446e3462..379fc3ad0ffd 100644
--- a/plugins/plugin_function.c
+++ b/plugins/plugin_function.c
@@ -135,10 +135,9 @@ static void show_function(struct trace_seq *s, struct tep_handle *tep,
 
 /* Returns true if it printed args, otherwise it returns false */
 static bool print_args(struct trace_seq *s, struct tep_event *event,
-		       struct tep_record *record)
+		       struct tep_record *record, const char *func)
 {
 	struct tep_format_field *field;
-	unsigned long arg;
 	void *args;
 	int len;
 
@@ -156,12 +155,8 @@ static bool print_args(struct trace_seq *s, struct tep_event *event,
 
 	trace_seq_putc(s, '(');
 
-	for (int i = 0; i < len; i += sizeof(long), args += sizeof(long)) {
-		memcpy(&arg, args, sizeof(long));
-		trace_seq_printf(s, "%lx", arg);
-		if (i + sizeof(long) < len)
-			trace_seq_puts(s, ", ");
-	}
+	tep_btf_print_args(event->tep, s, args, len / sizeof(long), sizeof(long), func);
+
 	trace_seq_putc(s, ')');
 	return true;
 }
@@ -196,7 +191,7 @@ static int function_handler(struct trace_seq *s, struct tep_record *record,
 	else
 		trace_seq_printf(s, "0x%llx", function);
 
-	print_args(s, event, record);
+	print_args(s, event, record, func);
 
 	if (ftrace_parent->set) {
 		trace_seq_printf(s, " <-- ");
@@ -281,7 +276,7 @@ trace_stack_handler(struct trace_seq *s, struct tep_record *record,
 
 static int
 trace_raw_data_handler(struct trace_seq *s, struct tep_record *record,
-		    struct tep_event *event, void *context)
+		       struct tep_event *event, void *context)
 {
 	struct tep_format_field *field;
 	unsigned long long id;
diff --git a/src/Makefile b/src/Makefile
index 169bc6af1cbc..4f16b81bb989 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -11,6 +11,7 @@ OBJS += parse-filter.o
 OBJS += parse-utils.o
 OBJS += tep_strerror.o
 OBJS += trace-seq.o
+OBJS += trace-btf.o
 
 OBJS := $(OBJS:%.o=$(bdir)/%.o)
 DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
diff --git a/src/event-parse-local.h b/src/event-parse-local.h
index c6bfc611bfbd..8fdb2141d48e 100644
--- a/src/event-parse-local.h
+++ b/src/event-parse-local.h
@@ -14,6 +14,7 @@ struct func_list;
 struct event_handler;
 struct func_resolver;
 struct tep_plugins_dir;
+struct tep_btf;
 
 #define __hidden __attribute__((visibility ("hidden")))
 
@@ -89,6 +90,8 @@ struct tep_handle {
 	const char *input_buf;
 	unsigned long long input_buf_ptr;
 	unsigned long long input_buf_siz;
+
+	struct tep_btf *btf;
 };
 
 enum tep_print_parse_type {
@@ -124,4 +127,7 @@ const char *get_input_buf(struct tep_handle *tep);
 enum tep_event_type read_token(struct tep_handle *tep, char **tok);
 void free_token(char *tok);
 
+/* BTF routines */
+void btf_free(struct tep_btf *btf);
+
 #endif /* _PARSE_EVENTS_INT_H */
diff --git a/src/event-parse.c b/src/event-parse.c
index 8daf91d8be83..939b0a8fbdf2 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -8726,6 +8726,8 @@ void tep_free(struct tep_handle *tep)
 	free(tep->func_resolver);
 	free_tep_plugin_paths(tep);
 
+	btf_free(tep->btf);
+
 	free(tep);
 }
 
diff --git a/src/meson.build b/src/meson.build
index cd48de719266..3a7a08206a5a 100644
--- a/src/meson.build
+++ b/src/meson.build
@@ -11,6 +11,7 @@ sources= [
    'parse-utils.c',
    'tep_strerror.c',
    'trace-seq.c',
+   'trace-btf.c',
 ]
 
 cc = meson.get_compiler('c')
diff --git a/src/trace-btf.c b/src/trace-btf.c
new file mode 100644
index 000000000000..12dc49447027
--- /dev/null
+++ b/src/trace-btf.c
@@ -0,0 +1,457 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2025 Google, Steven Rostedt <rostedt@goodmis.org>
+ *
+ * Reference: https://docs.kernel.org/bpf/btf.html
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdbool.h>
+
+#include <linux/btf.h>
+
+#include "event-parse.h"
+#include "event-utils.h"
+#include "event-parse-local.h"
+
+struct btf_header;
+struct btf_type;
+
+struct tep_btf {
+	struct btf_header	*hdr;
+	const char		*strings;
+	struct btf_type		**types;
+	unsigned long		nr_types;
+	struct btf_type		**funcs;
+	unsigned long		nr_funcs;
+	void			*data;
+	size_t			raw_size;
+	void			*raw_data;
+};
+
+#define REALLOC_SIZE (1 << 10)
+#define REALLOC_MASK (REALLOC_SIZE - 1)
+
+static const char *btf_name(struct tep_btf *btf, int off)
+{
+	if (off < btf->hdr->str_len)
+		return btf->strings + off;
+	return "";
+}
+
+/* List taken from the Linux kernel */
+static const char * const btf_kind_str[NR_BTF_KINDS] = {
+	[BTF_KIND_UNKN]		= "UNKNOWN",
+	[BTF_KIND_INT]		= "INT",
+	[BTF_KIND_PTR]		= "PTR",
+	[BTF_KIND_ARRAY]	= "ARRAY",
+	[BTF_KIND_STRUCT]	= "STRUCT",
+	[BTF_KIND_UNION]	= "UNION",
+	[BTF_KIND_ENUM]		= "ENUM",
+	[BTF_KIND_FWD]		= "FWD",
+	[BTF_KIND_TYPEDEF]	= "TYPEDEF",
+	[BTF_KIND_VOLATILE]	= "VOLATILE",
+	[BTF_KIND_CONST]	= "CONST",
+	[BTF_KIND_RESTRICT]	= "RESTRICT",
+	[BTF_KIND_FUNC]		= "FUNC",
+	[BTF_KIND_FUNC_PROTO]	= "FUNC_PROTO",
+	[BTF_KIND_VAR]		= "VAR",
+	[BTF_KIND_DATASEC]	= "DATASEC",
+	[BTF_KIND_FLOAT]	= "FLOAT",
+	[BTF_KIND_DECL_TAG]	= "DECL_TAG",
+	[BTF_KIND_TYPE_TAG]	= "TYPE_TAG",
+	[BTF_KIND_ENUM64]	= "ENUM64",
+};
+
+static const char *btf_type_str(const struct btf_type *t)
+{
+	return btf_kind_str[BTF_INFO_KIND(t->info)];
+}
+
+static int insert_type(struct btf_type ***types, unsigned long *cnt, struct btf_type *type)
+{
+	unsigned long nr_types = *cnt;
+        struct btf_type **array = *types;
+
+        if (!(nr_types & REALLOC_MASK)) {
+                int size = nr_types + REALLOC_SIZE;
+
+                array = realloc(array, sizeof(struct btf_type *) * size);
+                if (!array) {
+			tep_warning("Failed to alloct memory for new type");
+			return -1;
+		}
+                *types = array;
+        }
+
+        array[nr_types++] = type;
+	*cnt = nr_types;
+	return 0;
+}
+
+static int add_type(struct tep_btf *btf, struct btf_type *type)
+{
+	return insert_type(&btf->types, &btf->nr_types, type);
+}
+
+static int add_func(struct tep_btf *btf, struct btf_type *type)
+{
+	return insert_type(&btf->funcs, &btf->nr_funcs, type);
+}
+
+static int btf_type_size(struct btf_type *type)
+{
+	int kind = BTF_INFO_KIND(type->info);
+	int size = sizeof(*type);
+
+	switch (kind) {
+	case BTF_KIND_INT:
+		return size + sizeof(int);
+	case BTF_KIND_VAR:
+		return size + sizeof(struct btf_var);
+	case BTF_KIND_ARRAY:
+		return size + sizeof(struct btf_array);
+	case BTF_KIND_DECL_TAG:
+		return size + sizeof(struct btf_decl_tag);
+	case BTF_KIND_ENUM:
+		return size + sizeof(struct btf_enum) * BTF_INFO_VLEN(type->info);
+	case BTF_KIND_ENUM64:
+		return size + sizeof(struct btf_enum64) * BTF_INFO_VLEN(type->info);
+	case BTF_KIND_STRUCT:
+	case BTF_KIND_UNION:
+		return size + sizeof(struct btf_member) * BTF_INFO_VLEN(type->info);
+	case BTF_KIND_FUNC_PROTO:
+		return size + sizeof(struct btf_param) * BTF_INFO_VLEN(type->info);
+	case BTF_KIND_DATASEC:
+		return size + sizeof(struct btf_var_secinfo) * BTF_INFO_VLEN(type->info);
+	case BTF_KIND_PTR:
+	case BTF_KIND_FWD:
+	case BTF_KIND_TYPEDEF:
+	case BTF_KIND_VOLATILE:
+	case BTF_KIND_CONST:
+	case BTF_KIND_RESTRICT:
+	case BTF_KIND_TYPE_TAG:
+	case BTF_KIND_FUNC:
+	case BTF_KIND_FLOAT:
+		return size;
+	}
+	return -1;
+}
+
+static int cmp_funcs(const void *A, const void *B, void *data)
+{
+	struct tep_btf *btf = data;
+	const struct btf_type *a = *(const struct btf_type **)A;
+	const struct btf_type *b = *(const struct btf_type **)B;
+	const char *name_a = btf_name(btf, a->name_off);
+	const char *name_b = btf_name(btf, b->name_off);
+
+	return strcmp(name_a, name_b);
+}
+
+struct tcmd_search {
+	struct tep_btf		*btf;
+	const char		*name;
+};
+
+static int cmp_key_func(const void *A, const void *B)
+{
+	const struct tcmd_search *key = A;
+	const struct btf_type *b = *(const struct btf_type **)B;
+	const char *name_b = btf_name(key->btf, b->name_off);
+
+	return strcmp(key->name, name_b);
+}
+
+static struct btf_type *tep_btf_find_func(struct tep_btf *btf, const char *name)
+{
+	struct tcmd_search tsearch;
+	struct btf_type **t;
+
+	if (!btf || !name)
+		return NULL;
+
+	tsearch.btf = btf;
+	tsearch.name = name;
+
+	t = bsearch(&tsearch, btf->funcs, btf->nr_funcs, sizeof(btf->funcs[0]),
+		    cmp_key_func);
+
+	return t ? *t : NULL;
+}
+
+static int load_types(struct tep_btf *btf)
+{
+	struct btf_type *type;
+	void *start, *end;
+	int size;
+
+	start = btf->data + btf->hdr->type_off;
+	end = start + btf->hdr->type_len;
+
+	if (end > btf->raw_data + btf->raw_size)
+		return -1;
+
+	for (type = start; (void *)type < end;) {
+		if (add_type(btf, type))
+			return -1;
+		if (BTF_INFO_KIND(type->info) == BTF_KIND_FUNC) {
+			if (add_func(btf, type))
+				return -1;
+		}
+		size = btf_type_size(type);
+		if (size < 0) {
+			tep_warning("Invalid type %d\n", BTF_INFO_KIND(type->info));
+			return -1;
+		}
+		type = (void *)type + size;
+	}
+
+	qsort_r(btf->funcs, btf->nr_funcs, sizeof(btf->funcs[0]), cmp_funcs, btf);
+	return 0;
+}
+
+__hidden void btf_free(struct tep_btf *btf)
+{
+	if (!btf)
+		return;
+
+	free(btf->types);
+	free(btf->funcs);
+	free(btf->raw_data);
+}
+
+static struct tep_btf *btf_init(void *raw_data, size_t data_size)
+{
+	struct tep_btf *btf;
+
+	btf = calloc(1, sizeof(*btf));
+	if (!btf)
+		return NULL;
+
+	btf->raw_data = malloc(data_size);
+	if (!btf->raw_data)
+		goto fail;
+
+	memcpy(btf->raw_data, raw_data, data_size);
+
+	btf->raw_size = data_size;
+	btf->hdr = btf->raw_data;
+
+	/* Currently only same endianess is supported */
+	if (btf->hdr->magic != 0xeb9f) {
+		if (btf->hdr->magic != 0x9feb)
+			tep_warning("BTF does not match endianess of this machine");
+		else
+			tep_warning("Invalid BTF header");
+		goto fail;
+	}
+
+	if (btf->hdr->hdr_len < sizeof(*btf->hdr)) {
+		tep_warning("Header (%d) smaller than expected header %zd",
+			    btf->hdr->hdr_len, sizeof(*btf->hdr));
+		goto fail;
+	}
+
+	if (btf->hdr->str_off > data_size) {
+		tep_warning("String header (%d) greater than data size %zd",
+			    btf->hdr->str_len, data_size);
+		goto fail;
+	}
+
+	btf->data = btf->raw_data + btf->hdr->hdr_len;
+
+	btf->strings = btf->data + btf->hdr->str_off;
+
+	if (load_types(btf) < 0)
+		goto fail;
+
+	return btf;
+ fail:
+	btf_free(btf);
+	return NULL;
+}
+
+/**
+ * tep_load_btf - Load BTF information into a tep handle
+ * @tep: The tep handle to load the BTF info into
+ * @raw_data: The raw data containing the BTF file
+ * @data_size: The amount of data in @raw_data
+ *
+ * Initializes BTF into the @tep handle. If it had already had BTF
+ * loaded, it will free the previous BTF and recreate it from @raw_data.
+ *
+ * Returns: 0 on success and -1 on failure.
+ */
+int tep_load_btf(struct tep_handle *tep, void *raw_data, size_t data_size)
+{
+	/* If btf was already loaded, free it */
+	btf_free(tep->btf);
+
+	tep->btf = btf_init(raw_data, data_size);
+	if (!tep->btf)
+		return -1;
+	return 0;
+}
+
+static struct btf_type *btf_get_type(struct tep_btf *btf, int id)
+{
+	if (!id || id > btf->nr_types)
+		return NULL;
+
+	return btf->types[id - 1];
+}
+
+static struct btf_type *btf_skip_modifiers(struct tep_btf *btf, int id)
+{
+	struct btf_type *t = btf_get_type(btf, id);
+
+	for (;;) {
+		switch (BTF_INFO_KIND(t->info)) {
+		case BTF_KIND_TYPEDEF:
+		case BTF_KIND_VOLATILE:
+		case BTF_KIND_CONST:
+		case BTF_KIND_RESTRICT:
+		case BTF_KIND_TYPE_TAG:
+			id = t->type;
+			t = btf_get_type(btf, t->type);
+			continue;
+		}
+		break;
+	}
+
+	return t;
+}
+
+static void assign_arg(unsigned long long *arg, void *args, int size, int a)
+{
+	*arg = size == 4 ?
+		*(unsigned int *)(args + a * sizeof(int)) :
+		*(unsigned long long *)(args + a * sizeof(long long));
+}
+
+/**
+ * tep_btf_print_args - Print function arguments from BTF info
+ * @tep: The tep descriptor to use
+ * @s: The trace_seq to write the arguments into
+ * @args: The array that holds the arguments
+ * @nmem: The number of arguments
+ * @size: The size of each item in args (4 or 8).
+ * @func: The name of the function.
+ *
+ * Loads up the @s with a list of arguments for the function based on
+ * the @args.
+ *
+ * If there's no BTF loaded or @func is not found, then it just writes
+ * the @args as raw numbers. Otherwise it will pretty print the
+ * arguments based on the function info in BTF.
+ *
+ * Returns: 0 on success and -1 on failure.
+ */
+int tep_btf_print_args(struct tep_handle *tep, struct trace_seq *s, void *args,
+		       int nmem, int size, const char *func)
+{
+	struct tep_btf *btf = tep->btf;
+	struct btf_type *type = tep_btf_find_func(btf, func);
+	struct btf_param *param;
+	unsigned long long arg;
+	unsigned int encode;
+	const char *param_name;
+	int a, p, x, nr;
+
+	if (size != 4 && size != 8)
+		return -1;
+
+	if (!type) {
+		for (int i = 0; i < nmem; i++) {
+			assign_arg(&arg, args, size, i);
+			trace_seq_printf(s, "%llx", arg);
+			if (i + 1 < nmem)
+				trace_seq_puts(s, ", ");
+		}
+		return 0;
+	}
+
+	if (BTF_INFO_KIND(type->info) != BTF_KIND_FUNC) {
+		tep_warning("Invalid func type %d %s for function %s\n",
+			    BTF_INFO_KIND(type->info),
+			    btf_type_str(type), func);
+		return -1;
+	}
+
+	/* Get the function proto */
+	type = btf_get_type(btf, type->type);
+
+	/* No proto means "()" ? */
+	if (!type)
+		return 0;
+
+	if (BTF_INFO_KIND(type->info) != BTF_KIND_FUNC_PROTO) {
+		tep_warning("Invalid func proto type %d %s for function %s\n",
+			    BTF_INFO_KIND(type->info),
+			    btf_type_str(type), func);
+		return -1;
+	}
+
+	/* Get the number of parameters */
+	nr = BTF_INFO_VLEN(type->info);
+
+	/* The parameters are right after the FUNC_PROTO type */
+	param = ((void *)type) + sizeof(*type);
+
+	for (a = 0, p = 0; p < nr; a++, p++) {
+		struct btf_type *t;
+
+		if (p)
+			trace_seq_puts(s, ", ");
+
+		if (a == nmem) {
+			trace_seq_puts(s, "...");
+			break;
+		}
+
+		assign_arg(&arg, args, size, a);
+
+		param_name = btf_name(btf, param[p].name_off);
+		if (param_name)
+			trace_seq_printf(s, "%s=", param_name);
+
+		t = btf_skip_modifiers(btf, param[p].type);
+
+		switch (t ? BTF_INFO_KIND(t->info) : BTF_KIND_UNKN) {
+		case BTF_KIND_UNKN:
+			trace_seq_putc(s, '?');
+			/* Still print unknown type values */
+			/* fallthough */
+		case BTF_KIND_PTR:
+			trace_seq_printf(s, "0x%llx", arg);
+			break;
+		case BTF_KIND_INT:
+			encode = *(int *)((void *)t + sizeof(*t));
+			/* Print unsigned ints as hex */
+			if (BTF_INT_ENCODING(encode) & BTF_INT_SIGNED)
+				trace_seq_printf(s, "%lld", arg);
+			else
+				trace_seq_printf(s, "0x%llx", arg);
+			break;
+		case BTF_KIND_ENUM:
+			trace_seq_printf(s, "%lld", arg);
+			break;
+		default:
+			/* This does not handle complex arguments */
+			trace_seq_printf(s, "(%s)[0x%llx", btf_type_str(t), arg);
+			for (x = sizeof(long); x < t->size; x += sizeof(long)) {
+				trace_seq_putc(s, ':');
+				if (++a == nmem) {
+					trace_seq_puts(s, "...]");
+					return 0;
+				}
+				assign_arg(&arg, args, size, a);
+				trace_seq_printf(s, "0x%llx", arg);
+			}
+			trace_seq_putc(s, ']');
+			break;
+		}
+	}
+	return 0;
+}
-- 
2.51.0


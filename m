Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9153C2FFDF4
	for <linux-trace-devel@vger.kernel.org>; Tue,  3 Feb 2026 23:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770160478; cv=none; b=MVzhwh2aZjgl+VmzmsaE9gw8P1O4qUmWe6VnjWMk30+0x4Jb3z/La9kWVc5Plvr7ovzw3+eNT2v4Kz+XUwOsHxRFdZ2aOVD86Zfg7+62F/822iOoUAia4E8TwhkrjiHaBKDt4fxCQhXFiiC7W9TyAUNGz8h0+YghF9J7x6peITk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770160478; c=relaxed/simple;
	bh=8qhot9c9Tn4oCPADWcxi9VU+P9DHRYTHOA7wASl1XAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FM282fQ4CrNctkvzGAiNbMajC1A/aye+sTqDZREagm0kpQzgSnpoShFTaeTWfypm4UzZCOaJOHlqV3Xfuhg9fUFLcv5Jj3TcYF6pq2rinmmkjlZqGsopiuAs6BkK+GuUHdbgejvS4S3lUx/pSfzF8DezSMcfa71Pttf88v/dbqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 612DAC19425;
	Tue,  3 Feb 2026 23:14:38 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.99.1)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1vnPbw-00000008swK-0IgJ;
	Tue, 03 Feb 2026 18:15:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/2] libtraceevent: Add tep_parse_last_boot_info()
Date: Tue,  3 Feb 2026 18:12:25 -0500
Message-ID: <20260203231507.2117658-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260203231507.2117658-1-rostedt@goodmis.org>
References: <20260203231507.2117658-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add tep_parse_last_boot_info() API to load the tep handler with a persistent
ring buffer's last_boot_info file. This is used to map the new boot's
kallsyms with the boot from the persistent ring buffer kallsyms.

Note, currently only kernel addresses are supported. Module offsets will
come later.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtraceevent-parse-files.txt |  17 ++-
 Documentation/libtraceevent.txt             |   1 +
 include/traceevent/event-parse.h            |   1 +
 src/event-parse-local.h                     |   6 +
 src/event-parse.c                           | 138 +++++++++++++++++++-
 src/trace-btf.c                             |   6 +
 6 files changed, 165 insertions(+), 4 deletions(-)

diff --git a/Documentation/libtraceevent-parse-files.txt b/Documentation/libtraceevent-parse-files.txt
index bb2facb44a40..65270b2be9ec 100644
--- a/Documentation/libtraceevent-parse-files.txt
+++ b/Documentation/libtraceevent-parse-files.txt
@@ -3,8 +3,8 @@ libtraceevent(3)
 
 NAME
 ----
-tep_parse_saved_cmdlines, tep_parse_printk_formats, tep_parse_kallsyms
-- Parsing functions to load mappings
+tep_parse_saved_cmdlines, tep_parse_printk_formats, tep_parse_kallsyms,
+tep_parse_last_boot_info - Parsing functions to load mappings
 
 SYNOPSIS
 --------
@@ -15,6 +15,7 @@ SYNOPSIS
 int *tep_parse_saved_cmdlines*(struct tep_handle pass:[*]_tep_, const char pass:[*]_buf_);
 int *tep_parse_printk_formats*(struct tep_handle pass:[*]_tep_, const char pass:[*]_buf_);
 int *tep_parse_kallsyms*(struct tep_handle pass:[*]_tep_, const char pass:[*]_buf_);
+int *tep_parse_last_boot_info*(struct tep_handle pass:[*]_tep_, const char pass:[*]_lbi_);
 --
 
 DESCRIPTION
@@ -40,6 +41,15 @@ _tep_ handler such that function IP addresses can be mapped to their name when
 parsing events with %pS in the print format field. It parses the string _buf_ that
 holds the content of /proc/kallsyms and ends with a nul character ('\0').
 
+*tep_parse_last_boot_info()* loads information from the last_boot_info file of
+a persistent ring buffer instance. If a tracefs instance is declared as a
+persistent ring buffer and contains data from a previous boot, the last_boot_info
+file will have the addresses of the kernel as well as modules. It will use
+this information to base the function offsets in the binary buffer to match
+the function offsets in the kallsyms (loaded by *tep_parse_kallsyms()*)
+into the _tep_ handler. The _lbi_ is a nul terminated string that contains
+the content of the last_boot_info file from the persistent ring buffer instance.
+
 RETURN VALUE
 ------------
 The *tep_parse_saved_cmdlines*() function returns 0 in case of success, or -1
@@ -51,6 +61,9 @@ in case of an error.
 The *tep_parse_kallsyms*() function returns 0 in case of success, or -1
 in case of an error.
 
+The *tep_parse_last_boot_info*() function retuns 0 in case of success, or -1
+in case of error.
+
 EXAMPLE
 -------
 [source,c]
diff --git a/Documentation/libtraceevent.txt b/Documentation/libtraceevent.txt
index 6e5fdbc6e886..bc40b2309e28 100644
--- a/Documentation/libtraceevent.txt
+++ b/Documentation/libtraceevent.txt
@@ -55,6 +55,7 @@ Meta data parsing:
 	int *tep_parse_saved_cmdlines*(struct tep_handle pass:[*]_tep_, const char pass:[*]_buf_);
 	int *tep_parse_printk_formats*(struct tep_handle pass:[*]_tep_, const char pass:[*]_buf_);
 	int *tep_parse_kallsyms*(struct tep_handle pass:[*]_tep_, const char pass:[*]_buf_);
+	int *tep_parse_last_boot_info*(struct tep_handle pass:[*]_tep_, const char pass:[*]_lbi_);
 
 Plugins management:
 	struct tep_plugin_list pass:[*]*tep_load_plugins*(struct tep_handle pass:[*]_tep_);
diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 0070e21eb952..ea90986b21b2 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -428,6 +428,7 @@ int tep_register_comm(struct tep_handle *tep, const char *comm, int pid);
 int tep_override_comm(struct tep_handle *tep, const char *comm, int pid);
 int tep_parse_saved_cmdlines(struct tep_handle *tep, const char *buf);
 int tep_parse_kallsyms(struct tep_handle *tep, const char *kallsyms);
+int tep_parse_last_boot_info(struct tep_handle *tep, const char *lbi);
 int tep_register_function(struct tep_handle *tep, char *name,
 			  unsigned long long addr, char *mod);
 int tep_parse_printk_formats(struct tep_handle *tep, const char *buf);
diff --git a/src/event-parse-local.h b/src/event-parse-local.h
index 8fdb2141d48e..5df83e1d13f7 100644
--- a/src/event-parse-local.h
+++ b/src/event-parse-local.h
@@ -15,6 +15,7 @@ struct event_handler;
 struct func_resolver;
 struct tep_plugins_dir;
 struct tep_btf;
+struct tep_mod_addr;
 
 #define __hidden __attribute__((visibility ("hidden")))
 
@@ -46,6 +47,11 @@ struct tep_handle {
 	struct func_resolver *func_resolver;
 	struct func_list *funclist;
 	unsigned int func_count;
+	unsigned long long func_offset;
+	unsigned long long _text_addr;
+	struct tep_mod_addr *mod_addrs;
+	int nr_mod_addrs;
+
 
 	struct printk_map *printk_map;
 	struct printk_list *printklist;
diff --git a/src/event-parse.c b/src/event-parse.c
index 09d9092d9d20..168379257364 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -99,6 +99,11 @@ struct tep_function_handler {
 	int				nr_args;
 };
 
+struct tep_mod_addr {
+	unsigned long long		addr;
+	char				*mod;
+};
+
 static unsigned long long
 process_defined_func(struct trace_seq *s, void *data, int size,
 		     struct tep_event *event, struct tep_print_arg *arg);
@@ -535,6 +540,8 @@ __find_func(struct tep_handle *tep, unsigned long long addr)
 	struct func_map *func;
 	struct func_map key;
 
+	addr += tep->func_offset;
+
 	if (!tep->func_map)
 		func_map_init(tep);
 
@@ -610,6 +617,15 @@ find_func(struct tep_handle *tep, unsigned long long addr)
 	return map;
 }
 
+static unsigned long long addr_offset(struct tep_handle *tep, struct func_map *map)
+{
+	/* We don't handle mods yet */
+	if (!tep->mod_addrs || map->mod)
+		return map->addr;
+
+	return map->addr - tep->func_offset;
+}
+
 /**
  * tep_find_function_info - find a function by a given address
  * @tep: a handle to the trace event parser context
@@ -636,7 +652,7 @@ int tep_find_function_info(struct tep_handle *tep, unsigned long long addr,
 	if (name)
 		*name = map->func;
 	if (start)
-		*start = map->addr;
+		*start = addr_offset(tep, map);
 	if (size) {
 		if (!tep->func_resolver)
 			*size = map[1].addr - map->addr;
@@ -688,6 +704,23 @@ tep_find_function_address(struct tep_handle *tep, unsigned long long addr)
 	return map->addr;
 }
 
+static void set_func_offset(struct tep_handle *tep)
+{
+	unsigned long long old_addr = 0;
+	int a;
+
+	for (a = 0; a < tep->nr_mod_addrs; a++) {
+		if (strncmp(tep->mod_addrs[a].mod, "[kernel]", 8) == 0) {
+			old_addr = tep->mod_addrs[a].addr;
+			break;
+		}
+	}
+	if (!old_addr)
+		return;
+
+	tep->func_offset = tep->_text_addr - old_addr;
+}
+
 /**
  * tep_register_function - register a function with a given address
  * @tep: a handle to the trace event parser context
@@ -719,6 +752,11 @@ int tep_register_function(struct tep_handle *tep, char *func,
 		item->mod = NULL;
 	item->addr = addr;
 
+	if (!mod && strcmp(func, "_text") == 0) {
+		tep->_text_addr = addr;
+		set_func_offset(tep);
+	}
+
 	tep->funclist = item;
 	tep->func_count++;
 
@@ -733,6 +771,101 @@ out_free:
 	return -1;
 }
 
+static int cmp_addrs(const void *A, const void *B)
+{
+	const struct tep_mod_addr *a = A;
+	const struct tep_mod_addr *b = B;
+
+	if (a->addr < b->addr)
+		return -1;
+
+	return a->addr > b->addr;
+}
+
+/**
+ * tep_parse_last_boot_info - read the last_boot_info file
+ * @tep: a handle to the trace event parser
+ * @lbi: A string that holds the last_boot_info file contents
+ *
+ * The persistent ring buffer instance has a last_boot_info file that holds
+ * the offsets of the kernel as well as modules of the boot that
+ * the persistent instanse recorded.
+ *
+ * By passing in the contents of this file, it will be used to modify
+ * the kallsyms addresses used for finding functions.
+ *
+ * Returns 0 on success, and -1 on error.
+ */
+int tep_parse_last_boot_info(struct tep_handle *tep, const char *lbi)
+{
+	struct tep_mod_addr *addrs = NULL;
+	unsigned long long addr;
+	char *copy;
+	char *line;
+	char *next = NULL;
+	char *mod;
+	int lines;
+	char *p;
+	int a;
+	int ret = -1;
+
+	if (!lbi)
+		return -1;
+
+	/* The current buffer has no offset changes */
+	if (strncmp(lbi, "# Current", 9) == 0)
+		return 0;
+
+	copy = strdup(lbi);
+	if (!copy)
+		return -1;
+
+	for (p = copy, lines = 0; p; p = strchr(p + 1, '\n'), lines++)
+		;
+
+	addrs = calloc(lines, sizeof(*addrs));
+	if (!addrs)
+		goto out;
+
+	line = strtok_r(copy, "\n", &next);
+	for (a = 0; line; a++) {
+		int n;
+
+		mod = NULL;
+		errno = 0;
+		n = sscanf(line, "%16llx %ms", &addr, &mod);
+		if (errno)
+			goto out;
+
+		if (n != 2) {
+			tep_warning("Failed to parse last_boot_info");
+			goto out;
+		}
+
+		addrs[a].mod = mod;
+		addrs[a].addr = addr;
+
+		line = strtok_r(NULL, "\n", &next);
+	}
+	ret = 0;
+
+	qsort(addrs, a, sizeof(*addrs), cmp_addrs);
+
+	tep->nr_mod_addrs = a;
+	tep->mod_addrs = addrs;
+
+	/* Allow to free on error handling too */
+	addrs = NULL;
+
+	if (tep->_text_addr)
+		set_func_offset(tep);
+
+ out:
+	free(copy);
+	free(addrs);
+	return ret;
+}
+
 /**
  * tep_parse_kallsyms - load functions from a read of /proc/kallsyms
  * @tep: a handle to the trace event parser
@@ -797,7 +930,6 @@ int tep_parse_kallsyms(struct tep_handle *tep, const char *kallsyms)
 
 		line = strtok_r(NULL, "\n", &next);
 	}
-	free(line);
 	ret = 0;
  out:
 	free(copy);
@@ -8769,6 +8901,8 @@ void tep_free(struct tep_handle *tep)
 		funclist = funcnext;
 	}
 
+	free(tep->mod_addrs);
+
 	while (tep->func_handlers) {
 		func_handler = tep->func_handlers;
 		tep->func_handlers = func_handler->next;
diff --git a/src/trace-btf.c b/src/trace-btf.c
index cf5a9780ab8e..859b0860ce2a 100644
--- a/src/trace-btf.c
+++ b/src/trace-btf.c
@@ -551,6 +551,9 @@ int tep_btf_print_args(struct tep_handle *tep, struct trace_seq *s, void *args,
 	const char *param_name;
 	int a, p, x, nr;
 
+	if (!func)
+		return -1;
+
 	if (init_btf_func(btf, s, args, nmem, size, func, &type) < 0)
 		return -1;
 
@@ -597,6 +600,9 @@ int tep_btf_print_args(struct tep_handle *tep, struct trace_seq *s, void *args,
 		if (param_name)
 			trace_seq_printf(s, "%s=", param_name);
 
+		if (!param[p].type)
+			continue;
+
 		t = btf_skip_modifiers(btf, param[p].type);
 
 		switch (t ? BTF_INFO_KIND(t->info) : BTF_KIND_UNKN) {
-- 
2.51.0


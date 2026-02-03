Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9142B2EE608
	for <linux-trace-devel@vger.kernel.org>; Tue,  3 Feb 2026 23:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770160478; cv=none; b=bVM8MiaDG68ju/YdzfHcg31q47k9X5mlrulS2PCF3smXnr7YfW30X3gXYn1ULSXZKiPQ1YAhkBXl4Qv1Z/0A/e9AHVQFxCIMR0m/xGreRJr813uzhJAzFsUPJFun6dxCkNiCzym4FsrbWPnVVrHWocZ9cQm4yWKZ6FzaN9sL4zU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770160478; c=relaxed/simple;
	bh=uq9/J224Bi1fZsIbZ8FP5QX0f/ZCL4ZgUTvfaNbFRoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IY53Z+jUxeDDDn6sPr5LGkOCus14xx0X93sHQnKllJ3H9KJKFd7Y9bVihNEhXEnADZYD5uUsPmfCBV8iqDoKpE++8g9m21TWSzTmSp+ZPxggCyIFdBzZULsCaMZw4Zy/3i84YF9ClsEJmQ0VgflH77hlT713ph94zGJL7E4qwIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E5B8C116D0;
	Tue,  3 Feb 2026 23:14:38 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.99.1)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1vnPbw-00000008swN-0Q2x;
	Tue, 03 Feb 2026 18:15:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/2] libtraceevent: Add tep_load_modules() API
Date: Tue,  3 Feb 2026 18:12:26 -0500
Message-ID: <20260203231507.2117658-3-rostedt@goodmis.org>
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

When the last_boot_info is loaded by tep_parse_last_boot_info(), the
offset between the last boot core functions can be calculated by the _text
address of kallsyms of the current boot. But the module functions need to
be calculated by where the modules are loaded. This can be found by the
/proc/modules file.

Add tep_load_modules() to read the /proc/modules file and this will be
used to calculate the offsets from a buffer from a previous boot and from
the module functions in kallsyms of the current boot.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtraceevent-parse-files.txt |  65 ++++++--
 Documentation/libtraceevent.txt             |   1 +
 include/traceevent/event-parse.h            |   1 +
 src/event-parse-local.h                     |   3 +
 src/event-parse.c                           | 158 +++++++++++++++++++-
 5 files changed, 216 insertions(+), 12 deletions(-)

diff --git a/Documentation/libtraceevent-parse-files.txt b/Documentation/libtraceevent-parse-files.txt
index 65270b2be9ec..b1dd36f68bc2 100644
--- a/Documentation/libtraceevent-parse-files.txt
+++ b/Documentation/libtraceevent-parse-files.txt
@@ -4,7 +4,7 @@ libtraceevent(3)
 NAME
 ----
 tep_parse_saved_cmdlines, tep_parse_printk_formats, tep_parse_kallsyms,
-tep_parse_last_boot_info - Parsing functions to load mappings
+tep_parse_last_boot_info, tep_load_modules - Parsing functions to load mappings
 
 SYNOPSIS
 --------
@@ -16,6 +16,7 @@ int *tep_parse_saved_cmdlines*(struct tep_handle pass:[*]_tep_, const char pass:
 int *tep_parse_printk_formats*(struct tep_handle pass:[*]_tep_, const char pass:[*]_buf_);
 int *tep_parse_kallsyms*(struct tep_handle pass:[*]_tep_, const char pass:[*]_buf_);
 int *tep_parse_last_boot_info*(struct tep_handle pass:[*]_tep_, const char pass:[*]_lbi_);
+int *tep_load_modules*(struct tep_handle pass:[*]_tep_, char pass:[*]_modules_, size_t _size_);
 --
 
 DESCRIPTION
@@ -50,6 +51,14 @@ the function offsets in the kallsyms (loaded by *tep_parse_kallsyms()*)
 into the _tep_ handler. The _lbi_ is a nul terminated string that contains
 the content of the last_boot_info file from the persistent ring buffer instance.
 
+*tep_load_modules()* loads the contents of the file /proc/modules into the _tep_
+handler. This will be used to match the modules found in the last_boot_info (loaded
+by *tep_parse_last_boot_info()*) to match the offsets of the binary data in
+in a persistent ring buffer that matches the address of a module from the previous
+boot to a module address found in _modules_. The _modules_ parameter does not need
+to be nul terminated, but _size_ is used to denote the size of the _modules_ string.
+This function is useless if *tep_parse_last_boot_info()* isnt used.
+
 RETURN VALUE
 ------------
 The *tep_parse_saved_cmdlines*() function returns 0 in case of success, or -1
@@ -64,6 +73,9 @@ in case of an error.
 The *tep_parse_last_boot_info*() function retuns 0 in case of success, or -1
 in case of error.
 
+The *tep_load_modules*() function returns 0 in case of success, or -1
+in case of error.
+
 EXAMPLE
 -------
 [source,c]
@@ -99,16 +111,16 @@ int load_print_strings(struct tep_handle *tep)
         return r;
 }
 
-int load_kallsyms(struct tep_handle *tep)
+static char *read_file(const char *file, size_t *size)
 {
-        char *line = NULL;
-        char *buf = NULL;
-        size_t sz = 0;
         FILE *fp;
-        int len = 0;
-        int r;
+	char *line = NULL;
+	char *buf = NULL;
+	size_t sz = 0;
+        size_t len = 0;
+	int r;
 
-        fp = fopen("/proc/kallsyms", "r");
+        fp = fopen(file, "r");
         while ((r = getline(&line, &sz, fp)) >= 0) {
                 buf = realloc(buf, len + r + 1);
                 memcpy(buf + len, line, r);
@@ -117,9 +129,44 @@ int load_kallsyms(struct tep_handle *tep)
         free(line);
         fclose(fp);
         if (!buf)
-                return -1;
+                return NULL;
         buf[len] = 0;
+	*size = len;
+	return buf;
+}
+
+int load_kallsyms(struct tep_handle *tep)
+{
+        char *buf;
+        size_t sz;
+        int r;
+
+	buf = read_file("/proc/kallsyms", &sz);
+	if (!buf)
+		return -1;
+        r = tep_parse_kallsyms(tep, buf);
+        free(buf);
+        return r;
+}
+
+int load_last_boot(struct tep_handle *tep, struct tracefs_instance *instance)
+{
+        char *buf;
+        size_t sz;
+        int r;
+
+	buf = tracefs_instance_file_read(instance, "last_boot_info", NULL);
+	if (!buf)
+		return 0;
+
+	r = tep_parse_last_boot_info(tep, buf);
+	free(buf);
+	if (r < 0)
+		return r;
 
+	buf = read_file("/proc/modules", &sz);
+	if (!buf)
+		return -1;
         r = tep_parse_kallsyms(tep, buf);
         free(buf);
         return r;
diff --git a/Documentation/libtraceevent.txt b/Documentation/libtraceevent.txt
index bc40b2309e28..fba027e55467 100644
--- a/Documentation/libtraceevent.txt
+++ b/Documentation/libtraceevent.txt
@@ -56,6 +56,7 @@ Meta data parsing:
 	int *tep_parse_printk_formats*(struct tep_handle pass:[*]_tep_, const char pass:[*]_buf_);
 	int *tep_parse_kallsyms*(struct tep_handle pass:[*]_tep_, const char pass:[*]_buf_);
 	int *tep_parse_last_boot_info*(struct tep_handle pass:[*]_tep_, const char pass:[*]_lbi_);
+	int *tep_load_modules*(struct tep_handle pass:[*]_tep_, char pass:[*]_modules_, size_t _size_);
 
 Plugins management:
 	struct tep_plugin_list pass:[*]*tep_load_plugins*(struct tep_handle pass:[*]_tep_);
diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index ea90986b21b2..3ec151ab634c 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -429,6 +429,7 @@ int tep_override_comm(struct tep_handle *tep, const char *comm, int pid);
 int tep_parse_saved_cmdlines(struct tep_handle *tep, const char *buf);
 int tep_parse_kallsyms(struct tep_handle *tep, const char *kallsyms);
 int tep_parse_last_boot_info(struct tep_handle *tep, const char *lbi);
+int tep_load_modules(struct tep_handle *tep, char *modules, size_t size);
 int tep_register_function(struct tep_handle *tep, char *name,
 			  unsigned long long addr, char *mod);
 int tep_parse_printk_formats(struct tep_handle *tep, const char *buf);
diff --git a/src/event-parse-local.h b/src/event-parse-local.h
index 5df83e1d13f7..d3d6ef402476 100644
--- a/src/event-parse-local.h
+++ b/src/event-parse-local.h
@@ -48,9 +48,12 @@ struct tep_handle {
 	struct func_list *funclist;
 	unsigned int func_count;
 	unsigned long long func_offset;
+	unsigned long long mod_addr;
 	unsigned long long _text_addr;
 	struct tep_mod_addr *mod_addrs;
+	struct tep_mod_addr *proc_mods;
 	int nr_mod_addrs;
+	int nr_proc_mods;
 
 
 	struct printk_map *printk_map;
diff --git a/src/event-parse.c b/src/event-parse.c
index 168379257364..fee0f91c554e 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -534,13 +534,51 @@ static int func_map_init(struct tep_handle *tep)
 	return 0;
 }
 
+static int cmp_mod_addrs(const void *A, const void *B)
+{
+	const struct tep_mod_addr *a = A;
+	const struct tep_mod_addr *b = B;
+
+	if (a->addr < b->addr)
+		return -1;
+
+	return b[1].addr && a->addr >= b[1].addr;
+}
+
+static int cmp_mods(const void *A, const void *B)
+{
+	const struct tep_mod_addr *a = A;
+	const struct tep_mod_addr *b = B;
+
+	return strcmp(a->mod, b->mod);
+}
+
+static unsigned long long mod_addr_offset(struct tep_handle *tep, unsigned long long addr)
+{
+	struct tep_mod_addr key = { .addr = addr };
+	struct tep_mod_addr *mod;
+
+	if (!tep->mod_addr || addr < tep->mod_addr)
+		return tep->func_offset;
+
+	mod = bsearch(&key, tep->mod_addrs, tep->nr_mod_addrs,
+		      sizeof(key), cmp_mod_addrs);
+	if (!mod)
+		return 0;
+
+	mod = bsearch(mod, tep->proc_mods, tep->nr_proc_mods,
+		      sizeof(key), cmp_mods);
+
+	return mod ? mod->addr : 0;
+}
+
 static struct func_map *
 __find_func(struct tep_handle *tep, unsigned long long addr)
 {
 	struct func_map *func;
 	struct func_map key;
 
-	addr += tep->func_offset;
+	addr += mod_addr_offset(tep, addr);
 
 	if (!tep->func_map)
 		func_map_init(tep);
@@ -623,7 +661,7 @@ static unsigned long long addr_offset(struct tep_handle *tep, struct func_map *m
 	if (!tep->mod_addrs || map->mod)
 		return map->addr;
 
-	return map->addr - tep->func_offset;
+	return map->addr - mod_addr_offset(tep, map->addr);
 }
 
 /**
@@ -782,6 +820,35 @@ static int cmp_addrs(const void *A, const void *B)
 	return a->addr > b->addr;
 }
 
+static void update_mod(struct tep_handle *tep, const struct tep_mod_addr *key)
+{
+	struct tep_mod_addr *addr;
+
+	addr = bsearch(key, tep->proc_mods, tep->nr_proc_mods, sizeof(*addr), cmp_mods);
+	if (!addr)
+		return;
+
+	addr->addr -= key->addr;
+}
+
+static void set_func_mods(struct tep_handle *tep)
+{
+	int a;
+
+	if (!tep->proc_mods || !tep->mod_addrs)
+		return;
+
+	for (a = 0; a < tep->nr_mod_addrs; a++) {
+		if (strncmp(tep->mod_addrs[a].mod, "[kernel]", 8) == 0)
+			continue;
+
+		if (!tep->mod_addr)
+			tep->mod_addr = tep->mod_addrs[a].addr;
+
+		update_mod(tep, &tep->mod_addrs[a]);
+	}
+}
+
 /**
  * tep_parse_last_boot_info - read the last_boot_info file
  * @tep: a handle to the trace event parser
@@ -823,7 +890,7 @@ int tep_parse_last_boot_info(struct tep_handle *tep, const char *lbi)
 	for (p = copy, lines = 0; p; p = strchr(p + 1, '\n'), lines++)
 		;
 
-	addrs = calloc(lines, sizeof(*addrs));
+	addrs = calloc(lines + 1, sizeof(*addrs));
 	if (!addrs)
 		goto out;
 
@@ -860,12 +927,96 @@ int tep_parse_last_boot_info(struct tep_handle *tep, const char *lbi)
 	if (tep->_text_addr)
 		set_func_offset(tep);
 
+	if (tep->proc_mods)
+		set_func_mods(tep);
+
  out:
 	free(copy);
 	free(addrs);
 	return ret;
 }
 
+/**
+ * tep_load_modules - Load module information into a tep handle
+ * @tep: The tep handle to load the module info into
+ * @modules: A string containing the content of /proc/modules
+ * @size: The size of the modules string
+ *
+ * Saves the locations of where the modules are loaded. This is useful
+ * with tep_parse_last_boot_info() as it will be used to calculate the
+ * offsets between the current module locations and the one from the
+ * previous boot.
+ *
+ * Returns: 0 on success and -1 on failure.
+ */
+int tep_load_modules(struct tep_handle *tep, char *modules, size_t size)
+{
+	struct tep_mod_addr *mods = NULL;
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
+	if (!modules)
+		return -1;
+
+	copy = malloc(size + 1);
+	if (!copy)
+		return -1;
+	strncpy(copy, modules, size);
+	copy[size] = '\0';
+
+	for (p = copy, lines = 0; p; p = strchr(p + 1, '\n'), lines++)
+		;
+
+	mods = calloc(lines, sizeof(*mods));
+	if (!mods)
+		goto out;
+
+	line = strtok_r(copy, "\n", &next);
+	for (a = 0; line; a++) {
+		int n;
+
+		mod = NULL;
+		errno = 0;
+		n = sscanf(line, "%ms %*s %*s %*s %*s %18llx", &mod, &addr);
+		if (errno)
+			goto out;
+
+		if (n != 2) {
+			tep_warning("Failed to parse /proc/modules");
+			goto out;
+		}
+
+		mods[a].mod = mod;
+		mods[a].addr = addr;
+
+		line = strtok_r(NULL, "\n", &next);
+	}
+	ret = 0;
+
+	qsort(mods, a, sizeof(*mods), cmp_mods);
+
+	tep->nr_proc_mods = a;
+	tep->proc_mods = mods;
+
+	/* Allow to free on error handling too */
+	mods = NULL;
+
+	if (tep->mod_addrs)
+		set_func_mods(tep);
+
+ out:
+	free(copy);
+	free(mods);
+	return ret;
+}
+
 /**
  * tep_parse_kallsyms - load functions from a read of /proc/kallsyms
  * @tep: a handle to the trace event parser
@@ -8902,6 +9053,7 @@ void tep_free(struct tep_handle *tep)
 	}
 
 	free(tep->mod_addrs);
+	free(tep->proc_mods);
 
 	while (tep->func_handlers) {
 		func_handler = tep->func_handlers;
-- 
2.51.0


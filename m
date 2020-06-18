Return-Path: <SRS0=0fRq=77=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DC2AC433DF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Jun 2020 08:54:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0387E2186A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Jun 2020 08:54:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DBQ8AJR6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbgFRIx6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 18 Jun 2020 04:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728925AbgFRIxl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 Jun 2020 04:53:41 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F946C0613EE
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 Jun 2020 01:53:40 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id d128so4785799wmc.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 Jun 2020 01:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kKry9wzRFNwkL16HJcUXYukjOIk7wuaQ2A9Ckp/eLGw=;
        b=DBQ8AJR65aPuZ1LFfTRxvwy4UjsSkfenv7Xe9l4zHMYfgjrG1vYwIaXDG6nEtHfQO7
         /eX9/d9Qccsi11dwCYfWyXeU5ONsHGP3CiSblhJV4PNfcKFiIVkQZjlZJgzTWI5UuSin
         LdAv//guCQxm8LKOVebjMy8LnuEu8KyqPlyrUVh0ZAslIHW6RGcwAdIVkL/W1rsYPa69
         YnDoOIMj4FLdFHhjJrQr/RtQZ7Xykhz6kji6Nqp0YLI7bU+GRN63F3m6vYMEc4/V6Y0Q
         hTI/BBuiA3auqoz9PDI1iYYaCfbyud9BI+kX5CxSfWkVLX9QAUJ7GOvMb1mqwH8hKlGx
         Jg6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kKry9wzRFNwkL16HJcUXYukjOIk7wuaQ2A9Ckp/eLGw=;
        b=QzgKeaBNocbQa53cfiQ+LoYAXLnd/cqIydPOYOal0cJYf8LobFJI2oUDkz/YWcPUH5
         +yUIz/9YdxX2LuqQ++c0BzLLbPNSI7Xtq9ohNgXBN3gDFDN0VCoB1M4tC/TlZr6GMmLT
         1KV6d6GLFildfc/dPqLiAbyWIAPZWys4VPY6vGDfDKoY2tlaEWopz01c0ZYViemVHD78
         78HsKispMUcoTguog0aLeVOUFcNnWw8MI9o0KCqdJv3TM9qjjr4ZucynjCd7EmRLWz0F
         LkXr22ZVq3SZXx7G7OUSkmY9FKr7714pkyW8C+7LS9gD1msekQc0wEiWy6QUzi/BJWFr
         r9vw==
X-Gm-Message-State: AOAM533iPQ25vXgAXU2we4LOMkIBu96OsMDmwcvMyBOtcBFp6Go/Pg+B
        /3OhhAcL0yW360NTnhn2rqEFFR71o1k=
X-Google-Smtp-Source: ABdhPJyKeZNkxl3dm5PJVnqoIs5vcr+QCzE4RnocZU/4VSaEqVlx6RXd94d/KFsXO/2WxtOapncGRQ==
X-Received: by 2002:a7b:c5c7:: with SMTP id n7mr2912674wmk.77.1592470418955;
        Thu, 18 Jun 2020 01:53:38 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id a1sm2808231wmd.28.2020.06.18.01.53.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 01:53:38 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 2/2] trace-cmd: [POC] Add support for uprobes
Date:   Thu, 18 Jun 2020 11:53:33 +0300
Message-Id: <20200618085333.164150-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200618085333.164150-1-tz.stoyanov@gmail.com>
References: <20200618085333.164150-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Initial implementaton of trace-cmd support for ftrace uprobes.
Two new trace-cmd record / set argumemnts are introduced:
 --uprobe file:function
 --uprobe-ret file:function
The ftrace (return) probe is set on given function from the file.
Note: the file must contain debug DWARF information.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Makefile                       |  15 +-
 include/trace-cmd/trace-cmd.h  |  24 ++
 lib/trace-cmd/Makefile         |   9 +-
 lib/trace-cmd/trace-uprobes.c  | 390 +++++++++++++++++++++++++++++++++
 tracecmd/include/trace-local.h |   2 +
 tracecmd/trace-record.c        |  79 ++++++-
 tracecmd/trace-usage.c         |   4 +
 7 files changed, 511 insertions(+), 12 deletions(-)
 create mode 100644 lib/trace-cmd/trace-uprobes.c

diff --git a/Makefile b/Makefile
index d737b588..10effd57 100644
--- a/Makefile
+++ b/Makefile
@@ -244,16 +244,23 @@ CUNIT_INSTALLED := $(shell if (echo -e "\#include <CUnit/Basic.h>\n void main(){
 export CUNIT_INSTALLED
 
 DWARF_INSTALLED := $(shell if (echo -e "\#include <libdwarf/libdwarf.h>\n void main(){dwarf_init(-1, 0, 0, 0, 0, 0);}" | $(CC) -xc - -ldwarf >/dev/null 2>&1) ; then echo 1; else echo 0 ; fi)
-export DWARF_INSTALLED
 BFD_INSTALLED := $(shell if (echo -e "\#include <bfd.h>\n void main(){bfd_init();}" | $(CC) -xc  - -lbfd >/dev/null 2>&1) ; then echo 1; else echo 0 ; fi)
-export BFD_INSTALLED
 
+OBJECT_DEBUG=0
 ifeq ($(BFD_INSTALLED), 1)
-LIBS += -lbfd
-endif
 ifeq ($(DWARF_INSTALLED), 1)
+OBJECT_DEBUG=1
+CFLAGS += -DOBJECT_DEBUG
+LIBS += -lbfd
 LIBS += -ldwarf
+else
+$(warning libdwarf is not installed, no uprobes support)
 endif
+else
+$(warning libbfd is not installed, no uprobes support)
+endif
+
+export OBJECT_DEBUG
 
 export CFLAGS
 export INCLUDES
diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index f3c95f30..6ac00006 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -7,6 +7,7 @@
 #define _TRACE_CMD_H
 
 #include "traceevent/event-parse.h"
+#include "tracefs.h"
 
 #define TRACECMD_MAGIC { 23, 8, 68 }
 
@@ -483,6 +484,29 @@ void tracecmd_plog(const char *fmt, ...);
 void tracecmd_plog_error(const char *fmt, ...);
 int tracecmd_set_logfile(char *logfile);
 
+/* --- Uprobes --- */
+struct tracecmd_uprobe;
+int tracecmd_uprobe_new(struct tracecmd_uprobe **list,
+			char *file, char *func, bool pret);
+int tracecmd_uprobe_create(struct tracecmd_uprobe *probes);
+int tracecmd_uprobe_remove(struct tracecmd_uprobe *probes);
+void tracecmd_uprobe_free(struct tracecmd_uprobe *probes);
+int tracecmd_uprobe_enable(struct tracefs_instance *instance,
+			   struct tracecmd_uprobe *probes);
+int tracecmd_uprobe_disable(struct tracefs_instance *instance,
+			    struct tracecmd_uprobe *probes);
+
+struct tracecmd_uprobe_desc {
+	struct tracecmd_uprobe_desc *next;
+	int active;	/* is the probe configured */
+	char *file;	/* executable file that will be traced */
+	char *symbol;	/* symbol from the file, set as uprobe */
+	char *event;	/* name of the created event for this uprobe */
+};
+struct tracecmd_uprobe_desc *
+tracecmd_uprobes_get_list(struct tracecmd_uprobe *probes);
+void tracecmd_uprobes_free_list(struct tracecmd_uprobe_desc *list);
+
 /* --- System --- */
 unsigned long long tracecmd_generate_traceid(void);
 int tracecmd_count_cpus(void);
diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index f8fb8390..5375a76d 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -16,6 +16,7 @@ OBJS += trace-util.o
 OBJS += trace-filter-hash.o
 OBJS += trace-msg.o
 OBJS += trace-plugin.o
+OBJS += trace-uprobes.o
 ifeq ($(VSOCK_DEFINED), 1)
 OBJS += trace-timesync.o
 endif
@@ -24,14 +25,8 @@ endif
 OBJS += trace-blk-hack.o
 OBJS += trace-ftrace.o
 
-ifeq ($(BFD_INSTALLED), 1)
-ifeq ($(DWARF_INSTALLED), 1)
+ifeq ($(OBJECT_DEBUG), 1)
 OBJS += trace-obj-debug.o
-else
-$(warning libdwarf is not installed)
-endif
-else
-$(warning libbfd is not installed)
 endif
 
 OBJS := $(OBJS:%.o=$(bdir)/%.o)
diff --git a/lib/trace-cmd/trace-uprobes.c b/lib/trace-cmd/trace-uprobes.c
new file mode 100644
index 00000000..48d9ac6e
--- /dev/null
+++ b/lib/trace-cmd/trace-uprobes.c
@@ -0,0 +1,390 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2020, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
+ *
+ */
+#include <stdlib.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <linux/limits.h>
+#include <ctype.h>
+
+#include "tracefs.h"
+#include "trace-cmd-local.h"
+#include "trace-cmd.h"
+
+#ifdef OBJECT_DEBUG
+
+#define UPROBE_FILE "uprobe_events"
+
+struct trace_uprobe_symbols {
+	struct trace_uprobe_symbols *next;
+	char *event;
+	bool ret_probe;
+	struct trace_obj_symbols debug;
+};
+
+struct tracecmd_uprobe {
+	struct tracecmd_uprobe *next;
+
+	char *file;
+	struct trace_obj_debug *debug;
+	struct trace_uprobe_symbols *symbols;
+};
+
+static char *uprobe_event_name(char *file, char *func, bool pret)
+{
+	char *event = NULL;
+	char *fname;
+	char name[10];
+	int len;
+
+	fname = strrchr(file, '/');
+	if (fname)
+		fname++;
+	if (!fname || *fname == '\0')
+		fname = file;
+	strncpy(name, fname, 10);
+	for (len = 0; len < 10 && name[len]; len++) {
+		if (!isalpha(name[len]))
+			name[len] = '_';
+	}
+
+	asprintf(&event, "%c_%.*s_%.10s", pret ? 'r':'p', len, name, func);
+	return event;
+}
+
+/**
+ * tracecmd_uprobe_new - Add new uprobe in the uprobe list
+ * @list - list with uprobes, the new one will be added in this list
+ * @file - executable file that will be traced
+ * @func - function from @file
+ * @pret - indicate if this is return probe (true for return uprobe)
+ *
+ * Returns 0 on success or -1 on failure
+ */
+int tracecmd_uprobe_new(struct tracecmd_uprobe **list,
+			char *file, char *func, bool pret)
+{
+	struct trace_uprobe_symbols *pfunc = NULL;
+	struct tracecmd_uprobe *probe = *list;
+	bool new_file = false;
+
+	while (probe) {
+		if (!strcmp(probe->file, file))
+			break;
+		probe = probe->next;
+	}
+
+	if (!probe) {
+		probe = calloc(1, sizeof(*probe));
+		if (!probe)
+			return -1;
+
+		probe->file = strdup(file);
+		probe->next = *list;
+		new_file = true;
+	}
+
+	pfunc = probe->symbols;
+	while (pfunc) {
+		if (!strcmp(func, pfunc->debug.name) && pret == pfunc->ret_probe)
+			break;
+		pfunc = pfunc->next;
+	}
+
+	if (!pfunc) {
+		pfunc = calloc(1, sizeof(*pfunc));
+		if (!pfunc)
+			goto error;
+		pfunc->debug.name = strdup(func);
+		pfunc->ret_probe = pret;
+		pfunc->event = uprobe_event_name(file, func, pret);
+		pfunc->next = probe->symbols;
+		probe->symbols = pfunc;
+	}
+
+	if (new_file)
+		*list = probe;
+
+	return 0;
+
+error:
+	if (new_file)
+		free(probe);
+
+	return -1;
+}
+
+static void uprobe_symbols_free(struct trace_uprobe_symbols *symbols)
+{
+	struct trace_uprobe_symbols *del;
+
+	while (symbols) {
+		del = symbols;
+		symbols = symbols->next;
+		free(del->debug.name);
+		free(del->event);
+		free(del);
+	}
+}
+
+/**
+ * tracecmd_uprobe_free - Free uprobe list
+ * @list - list with uprobes, that wil be freed
+ *
+ */
+void tracecmd_uprobe_free(struct tracecmd_uprobe *probes)
+{
+	struct tracecmd_uprobe *del;
+
+	while (probes) {
+		del = probes;
+		probes = probes->next;
+		trace_obj_debug_destroy(del->debug);
+		uprobe_symbols_free(del->symbols);
+		free(del->file);
+		free(del);
+	}
+}
+
+static void uprobe_resolve(struct tracecmd_uprobe *probes)
+{
+	while (probes) {
+		if (!probes->debug)
+			probes->debug = trace_obj_debug_create(probes->file);
+		if (probes->debug)
+			trace_obj_debug_get_fileoffset(probes->debug,
+						       &probes->symbols->debug);
+		probes = probes->next;
+	}
+}
+
+static int uprobe_symbols(int fd, char *file, bool add,
+			  struct trace_uprobe_symbols *symbols)
+{
+	char probe_str[BUFSIZ];
+
+	for (; symbols; symbols = symbols->next) {
+		if (add) {
+			if (!symbols->debug.foffset || !symbols->event)
+				continue;
+			snprintf(probe_str, BUFSIZ,
+				 "%c:%s %s:0x%llx", symbols->ret_probe?'r':'p',
+				 symbols->event, file, symbols->debug.foffset);
+		} else {
+			if (!symbols->event)
+				continue;
+			snprintf(probe_str, BUFSIZ,
+				 "-:%s", symbols->event);
+		}
+		write(fd, probe_str, strlen(probe_str));
+	}
+
+	return 0;
+}
+
+static int uprobe_modify(struct tracecmd_uprobe *probes, bool add)
+{
+	char *ufile = tracefs_instance_get_file(NULL, UPROBE_FILE);
+	int fd = -1;
+
+	if (!ufile)
+		return -1;
+	fd = open(ufile, O_WRONLY | O_APPEND);
+	tracefs_put_tracing_file(ufile);
+	if (fd < 0)
+		return -1;
+
+	for (; probes; probes = probes->next) {
+		if (!probes->debug)
+			continue;
+		uprobe_symbols(fd, probes->file, add, probes->symbols);
+	}
+
+	close(fd);
+	return 0;
+}
+
+/**
+ * tracecmd_uprobe_create - Create uprobes in ftrace
+ * @list - list with uprobes, that will be created
+ *
+ * Returns 0 on success or -1 on failure
+ */
+int tracecmd_uprobe_create(struct tracecmd_uprobe *probes)
+{
+	uprobe_resolve(probes);
+	return uprobe_modify(probes, true);
+}
+
+/**
+ * tracecmd_uprobe_remove - Remove uprobes from ftrace
+ * @list - list with uprobes, that will be removed
+ *
+ * Returns 0 on success or -1 on failure
+ */
+int tracecmd_uprobe_remove(struct tracecmd_uprobe *probes)
+{
+	return uprobe_modify(probes, false);
+}
+
+static int uprobe_config(struct tracefs_instance *instance,
+			 struct tracecmd_uprobe *probes, bool enable)
+{
+	struct trace_uprobe_symbols *symb;
+	char event[PATH_MAX];
+
+	for (symb = probes->symbols; symb; symb = symb->next) {
+		if (!symb->event)
+			continue;
+		snprintf(event, PATH_MAX, "events/uprobes/%s/enable", symb->event);
+		tracefs_instance_file_write(instance, event, enable?"1":"0");
+	}
+
+	return 0;
+}
+
+/**
+ * tracecmd_uprobe_enable - Enable uprobes for tracing
+ * @instance - Ftrace instance in which scope the uprobes will be enabled
+ * @list - list with uprobes, that will be enabled
+ *
+ * Returns 0 on success or -1 on failure
+ */
+int tracecmd_uprobe_enable(struct tracefs_instance *instance,
+			   struct tracecmd_uprobe *probes)
+{
+	return uprobe_config(instance, probes, true);
+}
+
+/**
+ * tracecmd_uprobe_disable - Disable uprobes for tracing
+ * @instance - Ftrace instance in which scope the uprobes are enabled
+ * @list - list with uprobes, that will be disabled
+ *
+ * Returns 0 on success or -1 on failure
+ */
+int tracecmd_uprobe_disable(struct tracefs_instance *instance,
+			    struct tracecmd_uprobe *probes)
+{
+	return uprobe_config(instance, probes, false);
+}
+
+/**
+ * tracecmd_uprobes_free_list - Free list with uprobes description
+ * @list - list with uprobes descriptions, that will be freed
+ *
+ * Frees @list returned by tracecmd_uprobes_get_list()
+ * Returns 0 on success or -1 on failure
+ */
+void tracecmd_uprobes_free_list(struct tracecmd_uprobe_desc *list)
+{
+	struct tracecmd_uprobe_desc *del;
+
+	while (list) {
+		del = list;
+		list = list->next;
+		free(del->event);
+		free(del->symbol);
+		free(del->file);
+		free(del);
+	}
+}
+
+/**
+ * tracecmd_uprobes_get_list - Get list with uprobes description
+ * @list - list with configured uprobes
+ *
+ * The returned list should be freed by tracecmd_uprobes_free_list()
+ * Returns pointer to newly allocated list with uprobes description
+ * on success or NULL on failure.
+ */
+struct tracecmd_uprobe_desc *
+tracecmd_uprobes_get_list(struct tracecmd_uprobe *probes)
+{
+	struct trace_uprobe_symbols *s;
+	struct tracecmd_uprobe_desc *desc, *list = NULL;
+
+	for (; probes; probes = probes->next) {
+		for (s = probes->symbols; s; s = s->next) {
+			if (!s->event)
+				continue;
+			desc = calloc(1, sizeof(*desc));
+			if (!desc)
+				goto error;
+			desc->next = list;
+			list = desc;
+			desc->event = strdup(s->event);
+			if (!desc->event)
+				goto error;
+			desc->file = strdup(probes->file);
+			if (!desc->file)
+				goto error;
+			desc->symbol = strdup(s->debug.name);
+			if (!desc->symbol)
+				goto error;
+			if (s->debug.foffset)
+				desc->active = 1;
+		}
+	}
+
+	return list;
+error:
+	tracecmd_uprobes_free_list(list);
+	return NULL;
+}
+
+#else /* !OBJECT_DEBUG */
+
+int tracecmd_uprobe_new(struct tracecmd_uprobe **list,
+			char *file, char *func, bool pret)
+{
+	return -1;
+}
+
+void tracecmd_uprobe_resolve(struct tracecmd_uprobe *probes)
+{
+
+}
+
+int tracecmd_uprobe_create(struct tracecmd_uprobe *probes)
+{
+	return -1;
+}
+
+int tracecmd_uprobe_remove(struct tracecmd_uprobe *probes)
+{
+	return -1;
+}
+
+void tracecmd_uprobe_free(struct tracecmd_uprobe *probes)
+{
+
+}
+
+int tracecmd_uprobe_enable(struct tracefs_instance *instance,
+			   struct tracecmd_uprobe *probes)
+{
+	return -1;
+}
+
+int tracecmd_uprobe_disable(struct tracefs_instance *instance,
+			    struct tracecmd_uprobe *probes)
+{
+	return -1;
+}
+
+struct tracecmd_uprobe_desc *
+tracecmd_uprobes_get_list(struct tracecmd_uprobe *probes)
+{
+	return NULL;
+}
+
+void tracecmd_uprobes_free_list(struct tracecmd_uprobe_desc *list)
+{
+
+}
+
+#endif /* OBJECT_DEBUG */
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index d148aa16..2a476d8a 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -216,6 +216,8 @@ struct buffer_instance {
 	struct func_list	*filter_funcs;
 	struct func_list	*notrace_funcs;
 
+	struct tracecmd_uprobe	*uprobes;
+
 	struct opt_list		*options;
 	struct filter_pids	*filter_pids;
 	struct filter_pids	*process_pids;
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index bd004574..828d7d6f 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -5126,7 +5126,8 @@ static void check_function_plugin(void)
 static int __check_doing_something(struct buffer_instance *instance)
 {
 	return is_guest(instance) || (instance->flags & BUFFER_FL_PROFILE) ||
-		instance->plugin || instance->events || instance->get_procmap;
+		instance->plugin || instance->events || instance->get_procmap ||
+		instance->uprobes;
 }
 
 static void check_doing_something(void)
@@ -5541,6 +5542,8 @@ void init_top_instance(void)
 }
 
 enum {
+	OPT_retuprobe		= 239,
+	OPT_uprobe		= 240,
 	OPT_fork		= 241,
 	OPT_tsyncinterval	= 242,
 	OPT_user		= 243,
@@ -5730,6 +5733,22 @@ void trace_reset(int argc, char **argv)
 	exit(0);
 }
 
+static int
+uprobe_param(struct buffer_instance *instance, char *param, bool pret)
+{
+	char *str, *file, *func;
+
+	if (!param)
+		return -1;
+
+	file = strtok_r(param, ":", &str);
+	func = strtok_r(NULL, ":", &str);
+
+	if (!file || !func)
+		return -1;
+	return tracecmd_uprobe_new(&instance->uprobes, file, func, pret);
+}
+
 static void init_common_record_context(struct common_record_context *ctx,
 				       enum trace_cmd curr_cmd)
 {
@@ -5884,6 +5903,8 @@ static void parse_record_options(int argc,
 			{"module", required_argument, NULL, OPT_module},
 			{"tsync-interval", required_argument, NULL, OPT_tsyncinterval},
 			{"fork", no_argument, NULL, OPT_fork},
+			{"uprobe", required_argument, NULL, OPT_uprobe},
+			{"uprobe-ret", required_argument, NULL, OPT_retuprobe},
 			{NULL, 0, NULL, 0}
 		};
 
@@ -6283,6 +6304,14 @@ static void parse_record_options(int argc,
 				die("--fork option used for 'start' command only");
 			fork_process = true;
 			break;
+		case OPT_uprobe:
+			check_instance_die(ctx->instance, "--uprobe");
+			uprobe_param(ctx->instance, optarg, false);
+			break;
+		case OPT_retuprobe:
+			check_instance_die(ctx->instance, "--uprobe-ret");
+			uprobe_param(ctx->instance, optarg, true);
+			break;
 		case OPT_quiet:
 		case 'q':
 			quiet = true;
@@ -6394,6 +6423,13 @@ static void finalize_record_trace(struct common_record_context *ctx)
 
 	set_plugin("nop");
 
+	for_all_instances(instance) {
+		if (instance->uprobes) {
+			tracecmd_uprobe_remove(instance->uprobes);
+			tracecmd_uprobe_free(instance->uprobes);
+		}
+	}
+
 	tracecmd_remove_instances();
 
 	/* If tracing_on was enabled before we started, set it on now */
@@ -6425,6 +6461,42 @@ static bool has_local_instances(void)
 	return false;
 }
 
+static int uprobes_set(struct buffer_instance *instance)
+{
+	struct tracecmd_uprobe_desc *probes, *list;
+	struct event_list *event;
+	int ret;
+
+	ret = tracecmd_uprobe_create(instance->uprobes);
+	if (ret < 0)
+		return ret;
+	probes = tracecmd_uprobes_get_list(instance->uprobes);
+	if (!probes)
+		return -1;
+	ret = 0;
+	for (list = probes; list; list = list->next) {
+		if (!list->active) {
+			warning("Failed to set %s:%s uprobe",
+				list->file, list->symbol);
+			continue;
+		}
+		event = calloc(1, sizeof(*event));
+		if (!event) {
+			ret = -1;
+			goto out;
+		}
+		event->event = strdup(list->event);
+		add_event(instance, event);
+
+		if (!recording_all_events())
+			list_event(event->event);
+	}
+
+out:
+	tracecmd_uprobes_free_list(probes);
+	return ret;
+}
+
 /*
  * This function contains common code for the following commands:
  * record, start, stream, profile.
@@ -6468,6 +6540,11 @@ static void record_trace(int argc, char **argv,
 		/* Some instances may not be created yet */
 		if (instance->tracing_on_init_val < 0)
 			instance->tracing_on_init_val = 1;
+		if (instance->uprobes) {
+			ctx->events = 1;
+			if (uprobes_set(instance) < 0)
+				die("Failed to set uprobes");
+		}
 	}
 
 	if (ctx->events)
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index ada44c68..4a13af19 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -65,6 +65,8 @@ static struct usage_help usage_help[] = {
 		"               If a negative number is specified, timestamps synchronization is disabled"
 		"               If 0 is specified, no loop is performed - timestamps offset is calculated only twice,"
 		"                                                         at the beginnig and at the end of the trace\n"
+		"          --uprobe set the specified [file:function] as uprobe\n"
+		"          --uprobe-ret set the specified [file:function] as return uprobe\n"
 	},
 	{
 		"set",
@@ -101,6 +103,8 @@ static struct usage_help usage_help[] = {
 		"          --cmdlines-size change kernel saved_cmdlines_size\n"
 		"          --user execute the specified [command ...] as given user\n"
 		"          --fork return immediately if a command is specified\n"
+		"          --uprobe set the specified [file:function] as uprobe\n"
+		"          --uprobe-ret set the specified [file:function] as return uprobe\n"
 	},
 	{
 		"start",
-- 
2.26.2


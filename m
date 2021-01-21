Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30A12C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Jan 2021 07:46:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C228F221F7
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Jan 2021 07:46:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbhAUHqX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 21 Jan 2021 02:46:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbhAUHpo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Jan 2021 02:45:44 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C64B6C0613D6
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Jan 2021 23:45:03 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id a9so734648wrt.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Jan 2021 23:45:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wgevKZfb15xf4/LJlhb5nwre71B5N+KJ1ksRt7FyyG0=;
        b=oCoIybg/CCXQ9NPp6rHDOoCbQJMsWnjyN1PxVgugizD+mu7qhlbNyljBSOf1Z0Viet
         qdK9eK9EOCtJu9QYf9lyeU1DUd+kv28B57szYYKLUqYuBgr8ZCNHSHckl9QB5rAXeHpb
         sBePlX/lBBEM98Y+2RTvoQOw70V1bxn32TqLzEjoAesyWt0M4jKP7d9zi56ShWmY69JQ
         sIfy2wiALF5Pe49xHmUhRBktLRmk6b/QbpujN+hefyoPA4C3jGxNZ2nwOEtKxH/aKrWg
         ccLQmYQQcjjLIYjxQ2gY9JCK7MkZohjo2JE1JO+o095lshHmIivDJqkobuBfHTsC9eGG
         3G0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wgevKZfb15xf4/LJlhb5nwre71B5N+KJ1ksRt7FyyG0=;
        b=qJ9U+U7xeVkhSq693niYcoy8MNtBJgXUr9ASmdAHXUDK6ISFqM5wcORFeyFjPr/9be
         b0SfsYBaW4oAsPe7MVo4suxLS4bPQa4NIkWH8GQvgdc6IG0D1HrRK/SA1sXNUeLYclul
         M/2GX2eMLij2dY088JDFY5cEmSz6gNkT4xcJh+QrZAaGBVbWsHVqchESGz+nAjAXPqx7
         G+je6Cj7c6Wsqhd0ChrdjgeAwBJNertyevS7CWlhTkYOwDSkD1Cp87fADV5c/bLaMdyb
         cDxTZEILbrVULIUpobVQhjyjG+PGC4k3xr88ZSalR9+kIQAFQjooKeMyurhQfCu5GfD1
         wbdQ==
X-Gm-Message-State: AOAM53214WfMiJSRcEWdXkmrMM9dYJS3z0A00tFD5rGDy3KXZEJCOgRe
        DjF3nLMr8fDrWW23s/pGmgI=
X-Google-Smtp-Source: ABdhPJwiYPSPa0hur5V3CNZmshLZRL52KOWV12yT+1sg6fZ+a/UKtbDmsdbBxSC8E7+nKf6K4LEBCw==
X-Received: by 2002:adf:eb05:: with SMTP id s5mr12778514wrn.333.1611215102527;
        Wed, 20 Jan 2021 23:45:02 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q6sm6788474wmj.32.2021.01.20.23.45.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 23:45:01 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v26 03/15] trace-cmd: Move VM related logic in a separate file
Date:   Thu, 21 Jan 2021 09:44:44 +0200
Message-Id: <20210121074456.157658-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210121074456.157658-1-tz.stoyanov@gmail.com>
References: <20210121074456.157658-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

All trace-cmd internal functions related to VM / guest resolving and
mappings are moved from trace-record.c to trace-vm.c. Internal APIs are
added to access the guest database, so this functionality can be used by
other logic, internally in the trace-cmd context.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/Makefile              |   1 +
 tracecmd/include/trace-local.h |  20 +++
 tracecmd/trace-record.c        | 232 +++------------------------------
 tracecmd/trace-vm.c            | 214 ++++++++++++++++++++++++++++++
 4 files changed, 250 insertions(+), 217 deletions(-)
 create mode 100644 tracecmd/trace-vm.c

diff --git a/tracecmd/Makefile b/tracecmd/Makefile
index c02851a8..2b14284b 100644
--- a/tracecmd/Makefile
+++ b/tracecmd/Makefile
@@ -35,6 +35,7 @@ TRACE_CMD_OBJS += trace-list.o
 TRACE_CMD_OBJS += trace-usage.o
 TRACE_CMD_OBJS += trace-dump.o
 TRACE_CMD_OBJS += trace-clear.o
+TRACE_CMD_OBJS += trace-vm.o
 ifeq ($(VSOCK_DEFINED), 1)
 TRACE_CMD_OBJS += trace-tsync.o
 endif
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 4089de4e..7b14c68a 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -8,6 +8,7 @@
 
 #include <sys/types.h>
 #include <dirent.h>	/* for DIR */
+#include <ctype.h>	/* for isdigit() */
 #include <limits.h>
 
 #include "trace-cmd-private.h"
@@ -285,6 +286,17 @@ void update_first_instance(struct buffer_instance *instance, int topt);
 
 void show_instance_file(struct buffer_instance *instance, const char *name);
 
+struct trace_guest {
+	char *name;
+	int cid;
+	int pid;
+	int cpu_max;
+	int *cpu_pid;
+};
+struct trace_guest *get_guest_by_cid(unsigned int guest_cid);
+struct trace_guest *get_guest_by_name(char *name);
+void read_qemu_guests(void);
+int get_guest_pid(unsigned int guest_cid);
 int get_guest_vcpu_pid(unsigned int guest_cid, unsigned int guest_vcpu);
 
 /* moved from trace-cmd.h */
@@ -315,4 +327,12 @@ void *malloc_or_die(unsigned int size); /* Can be overridden */
 void __noreturn __die(const char *fmt, ...);
 void __noreturn _vdie(const char *fmt, va_list ap);
 
+static inline bool is_digits(const char *s)
+{
+	for (; *s; s++)
+		if (!isdigit(*s))
+			return false;
+	return true;
+}
+
 #endif /* __TRACE_LOCAL_H */
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 9316bbde..a0e128d6 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3183,239 +3183,37 @@ static int do_accept(int sd)
 	return -1;
 }
 
-static bool is_digits(const char *s)
+static char *parse_guest_name(char *gname, int *cid, int *port)
 {
-	for (; *s; s++)
-		if (!isdigit(*s))
-			return false;
-	return true;
-}
-
-struct guest {
-	char *name;
-	int cid;
-	int pid;
-	int cpu_max;
-	int *cpu_pid;
-};
-
-static struct guest *guests;
-static size_t guests_len;
-
-static int set_vcpu_pid_mapping(struct guest *guest, int cpu, int pid)
-{
-	int *cpu_pid;
-	int i;
-
-	if (cpu >= guest->cpu_max) {
-		cpu_pid = realloc(guest->cpu_pid, (cpu + 1) * sizeof(int));
-		if (!cpu_pid)
-			return -1;
-		/* Handle sparse CPU numbers */
-		for (i = guest->cpu_max; i < cpu; i++)
-			cpu_pid[i] = -1;
-		guest->cpu_max = cpu + 1;
-		guest->cpu_pid = cpu_pid;
-	}
-	guest->cpu_pid[cpu] = pid;
-	return 0;
-}
-
-static struct guest *get_guest_info(unsigned int guest_cid)
-{
-	int i;
-
-	if (!guests)
-		return NULL;
-
-	for (i = 0; i < guests_len; i++)
-		if (guest_cid == guests[i].cid)
-			return guests + i;
-	return NULL;
-}
-
-static char *get_qemu_guest_name(char *arg)
-{
-	char *tok, *end = arg;
-
-	while ((tok = strsep(&end, ","))) {
-		if (strncmp(tok, "guest=", 6) == 0)
-			return tok + 6;
-	}
-
-	return arg;
-}
-
-static int read_qemu_guests_pids(char *guest_task, struct guest *guest)
-{
-	struct dirent *entry;
-	char path[PATH_MAX];
-	char *buf = NULL;
-	size_t n = 0;
-	int ret = 0;
-	long vcpu;
-	long pid;
-	DIR *dir;
-	FILE *f;
-
-	snprintf(path, sizeof(path), "/proc/%s/task", guest_task);
-	dir = opendir(path);
-	if (!dir)
-		return -1;
-
-	while (!ret && (entry = readdir(dir))) {
-		if (!(entry->d_type == DT_DIR && is_digits(entry->d_name)))
-			continue;
-
-		snprintf(path, sizeof(path), "/proc/%s/task/%s/comm",
-			 guest_task, entry->d_name);
-		f = fopen(path, "r");
-		if (!f)
-			continue;
-
-		if (getline(&buf, &n, f) >= 0 &&
-		    strncmp(buf, "CPU ", 4) == 0) {
-			vcpu = strtol(buf + 4, NULL, 10);
-			pid = strtol(entry->d_name, NULL, 10);
-			if (vcpu < INT_MAX && pid < INT_MAX &&
-			    vcpu >= 0 && pid >= 0) {
-				if (set_vcpu_pid_mapping(guest, vcpu, pid))
-					ret = -1;
-			}
-		}
-
-		fclose(f);
-	}
-	free(buf);
-	return ret;
-}
-
-static void read_qemu_guests(void)
-{
-	static bool initialized;
-	struct dirent *entry;
-	char path[PATH_MAX];
-	DIR *dir;
-
-	if (initialized)
-		return;
-
-	initialized = true;
-	dir = opendir("/proc");
-	if (!dir)
-		die("Can not open /proc");
-
-	while ((entry = readdir(dir))) {
-		bool is_qemu = false, last_was_name = false;
-		struct guest guest = {};
-		char *p, *arg = NULL;
-		size_t arg_size = 0;
-		FILE *f;
-
-		if (!(entry->d_type == DT_DIR && is_digits(entry->d_name)))
-			continue;
-
-		guest.pid = atoi(entry->d_name);
-		snprintf(path, sizeof(path), "/proc/%s/cmdline", entry->d_name);
-		f = fopen(path, "r");
-		if (!f)
-			continue;
-
-		while (getdelim(&arg, &arg_size, 0, f) != -1) {
-			if (!is_qemu && strstr(arg, "qemu-system-")) {
-				is_qemu = true;
-				continue;
-			}
-
-			if (!is_qemu)
-				continue;
-
-			if (strcmp(arg, "-name") == 0) {
-				last_was_name = true;
-				continue;
-			}
-
-			if (last_was_name) {
-				guest.name = strdup(get_qemu_guest_name(arg));
-				if (!guest.name)
-					die("allocating guest name");
-				last_was_name = false;
-				continue;
-			}
-
-			p = strstr(arg, "guest-cid=");
-			if (p) {
-				guest.cid = atoi(p + 10);
-				continue;
-			}
-		}
-
-		if (!is_qemu)
-			goto next;
-
-		if (read_qemu_guests_pids(entry->d_name, &guest))
-			warning("Failed to retrieve VPCU - PID mapping for guest %s",
-					guest.name ? guest.name : "Unknown");
-
-		guests = realloc(guests, (guests_len + 1) * sizeof(*guests));
-		if (!guests)
-			die("Can not allocate guest buffer");
-		guests[guests_len++] = guest;
-
-next:
-		free(arg);
-		fclose(f);
-	}
-
-	closedir(dir);
-}
-
-static char *parse_guest_name(char *guest, int *cid, int *port)
-{
-	size_t i;
+	struct trace_guest *guest;
 	char *p;
 
 	*port = -1;
-	p = strrchr(guest, ':');
+	p = strrchr(gname, ':');
 	if (p) {
 		*p = '\0';
 		*port = atoi(p + 1);
 	}
 
 	*cid = -1;
-	p = strrchr(guest, '@');
+	p = strrchr(gname, '@');
 	if (p) {
 		*p = '\0';
 		*cid = atoi(p + 1);
-	} else if (is_digits(guest))
-		*cid = atoi(guest);
+	} else if (is_digits(gname))
+		*cid = atoi(gname);
 
 	read_qemu_guests();
-	for (i = 0; i < guests_len; i++) {
-		if ((*cid > 0 && *cid == guests[i].cid) ||
-		    strcmp(guest, guests[i].name) == 0) {
-			*cid = guests[i].cid;
-			return guests[i].name;
-		}
+	if (*cid > 0)
+		guest = get_guest_by_cid(*cid);
+	else
+		guest = get_guest_by_name(gname);
+	if (guest) {
+		*cid = guest->cid;
+		return guest->name;
 	}
 
-	return guest;
-}
-
-int get_guest_vcpu_pid(unsigned int guest_cid, unsigned int guest_vcpu)
-{
-	int i;
-
-	if (!guests)
-		return -1;
-
-	for (i = 0; i < guests_len; i++) {
-		if (guests[i].cpu_pid < 0 || guest_vcpu >= guests[i].cpu_max)
-			continue;
-		if (guest_cid == guests[i].cid)
-			return guests[i].cpu_pid[guest_vcpu];
-	}
-	return -1;
+	return gname;
 }
 
 static void set_prio(int prio)
@@ -4091,7 +3889,7 @@ static void append_buffer(struct tracecmd_output *handle,
 static void
 add_guest_info(struct tracecmd_output *handle, struct buffer_instance *instance)
 {
-	struct guest *guest = get_guest_info(instance->cid);
+	struct trace_guest *guest = get_guest_by_cid(instance->cid);
 	char *buf, *p;
 	int size;
 	int i;
diff --git a/tracecmd/trace-vm.c b/tracecmd/trace-vm.c
new file mode 100644
index 00000000..c8924ece
--- /dev/null
+++ b/tracecmd/trace-vm.c
@@ -0,0 +1,214 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2008, 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
+ * Copyright (C) 2020, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/types.h>
+#include <dirent.h>
+#include <limits.h>
+
+#include "trace-local.h"
+#include "trace-msg.h"
+
+static struct trace_guest *guests;
+static size_t guests_len;
+
+static int set_vcpu_pid_mapping(struct trace_guest *guest, int cpu, int pid)
+{
+	int *cpu_pid;
+	int i;
+
+	if (cpu >= guest->cpu_max) {
+		cpu_pid = realloc(guest->cpu_pid, (cpu + 1) * sizeof(int));
+		if (!cpu_pid)
+			return -1;
+		/* Handle sparse CPU numbers */
+		for (i = guest->cpu_max; i < cpu; i++)
+			cpu_pid[i] = -1;
+		guest->cpu_max = cpu + 1;
+		guest->cpu_pid = cpu_pid;
+	}
+	guest->cpu_pid[cpu] = pid;
+	return 0;
+}
+
+struct trace_guest *get_guest_by_cid(unsigned int guest_cid)
+{
+	int i;
+
+	if (!guests)
+		return NULL;
+
+	for (i = 0; i < guests_len; i++)
+		if (guest_cid == guests[i].cid)
+			return guests + i;
+	return NULL;
+}
+
+struct trace_guest *get_guest_by_name(char *name)
+{
+	int i;
+
+	if (!guests)
+		return NULL;
+
+	for (i = 0; i < guests_len; i++)
+		if (strcmp(name, guests[i].name) == 0)
+			return guests + i;
+	return NULL;
+}
+
+static char *get_qemu_guest_name(char *arg)
+{
+	char *tok, *end = arg;
+
+	while ((tok = strsep(&end, ","))) {
+		if (strncmp(tok, "guest=", 6) == 0)
+			return tok + 6;
+	}
+
+	return arg;
+}
+
+static int read_qemu_guests_pids(char *guest_task, struct trace_guest *guest)
+{
+	struct dirent *entry;
+	char path[PATH_MAX];
+	char *buf = NULL;
+	size_t n = 0;
+	int ret = 0;
+	long vcpu;
+	long pid;
+	DIR *dir;
+	FILE *f;
+
+	snprintf(path, sizeof(path), "/proc/%s/task", guest_task);
+	dir = opendir(path);
+	if (!dir)
+		return -1;
+
+	while (!ret && (entry = readdir(dir))) {
+		if (!(entry->d_type == DT_DIR && is_digits(entry->d_name)))
+			continue;
+
+		snprintf(path, sizeof(path), "/proc/%s/task/%s/comm",
+			 guest_task, entry->d_name);
+		f = fopen(path, "r");
+		if (!f)
+			continue;
+
+		if (getline(&buf, &n, f) >= 0 &&
+		    strncmp(buf, "CPU ", 4) == 0) {
+			vcpu = strtol(buf + 4, NULL, 10);
+			pid = strtol(entry->d_name, NULL, 10);
+			if (vcpu < INT_MAX && pid < INT_MAX &&
+			    vcpu >= 0 && pid >= 0) {
+				if (set_vcpu_pid_mapping(guest, vcpu, pid))
+					ret = -1;
+			}
+		}
+
+		fclose(f);
+	}
+	free(buf);
+	return ret;
+}
+
+void read_qemu_guests(void)
+{
+	static bool initialized;
+	struct dirent *entry;
+	char path[PATH_MAX];
+	DIR *dir;
+
+	if (initialized)
+		return;
+
+	initialized = true;
+	dir = opendir("/proc");
+	if (!dir)
+		die("Can not open /proc");
+
+	while ((entry = readdir(dir))) {
+		bool is_qemu = false, last_was_name = false;
+		struct trace_guest guest = {};
+		char *p, *arg = NULL;
+		size_t arg_size = 0;
+		FILE *f;
+
+		if (!(entry->d_type == DT_DIR && is_digits(entry->d_name)))
+			continue;
+
+		guest.pid = atoi(entry->d_name);
+		snprintf(path, sizeof(path), "/proc/%s/cmdline", entry->d_name);
+		f = fopen(path, "r");
+		if (!f)
+			continue;
+
+		while (getdelim(&arg, &arg_size, 0, f) != -1) {
+			if (!is_qemu && strstr(arg, "qemu-system-")) {
+				is_qemu = true;
+				continue;
+			}
+
+			if (!is_qemu)
+				continue;
+
+			if (strcmp(arg, "-name") == 0) {
+				last_was_name = true;
+				continue;
+			}
+
+			if (last_was_name) {
+				guest.name = strdup(get_qemu_guest_name(arg));
+				if (!guest.name)
+					die("allocating guest name");
+				last_was_name = false;
+				continue;
+			}
+
+			p = strstr(arg, "guest-cid=");
+			if (p) {
+				guest.cid = atoi(p + 10);
+				continue;
+			}
+		}
+
+		if (!is_qemu)
+			goto next;
+
+		if (read_qemu_guests_pids(entry->d_name, &guest))
+			warning("Failed to retrieve VPCU - PID mapping for guest %s",
+					guest.name ? guest.name : "Unknown");
+
+		guests = realloc(guests, (guests_len + 1) * sizeof(*guests));
+		if (!guests)
+			die("Can not allocate guest buffer");
+		guests[guests_len++] = guest;
+
+next:
+		free(arg);
+		fclose(f);
+	}
+
+	closedir(dir);
+}
+
+int get_guest_vcpu_pid(unsigned int guest_cid, unsigned int guest_vcpu)
+{
+	int i;
+
+	if (!guests)
+		return -1;
+
+	for (i = 0; i < guests_len; i++) {
+		if (guests[i].cpu_pid < 0 || guest_vcpu >= guests[i].cpu_max)
+			continue;
+		if (guest_cid == guests[i].cid)
+			return guests[i].cpu_pid[guest_vcpu];
+	}
+	return -1;
+}
-- 
2.29.2


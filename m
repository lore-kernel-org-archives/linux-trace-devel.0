Return-Path: <SRS0=rOCb=DQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FCE6C433DF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Oct 2020 14:03:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C05B222C3
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Oct 2020 14:03:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G7twjeNY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732056AbgJIODv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Oct 2020 10:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729045AbgJIODu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Oct 2020 10:03:50 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753BCC0613D2
        for <linux-trace-devel@vger.kernel.org>; Fri,  9 Oct 2020 07:03:50 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id dg9so7102156edb.12
        for <linux-trace-devel@vger.kernel.org>; Fri, 09 Oct 2020 07:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rRQTF3eUoU19lJsDrokJs39TubLwCMj/oIO8QFo8TUE=;
        b=G7twjeNYMGIbb0HrHJ6kS/PfjMKEFJsVm8GMT0RgO3AgMqGOfrjUf9LVa3BwdNf6dW
         l+6J0QUO31tEhE5DeDW46pioz70YNqfmB19BWxJ+djjW/j7nqNESCCNGXKR/XbGrXA0u
         PDqwxdHglDvBkvcKo5z9yqFnE+0+ihT1lrPmE98HvpdL8W1SW481fsI57JrjLFWB97At
         rfjJgxWgU97uXfMcw24i3nYjSd80zvowohbfYcGFXCZl/YABpyZ9+Ybszck8BN2qMKK7
         k5hleM16DfecDEYIAAROcM9oKsRNAOCY7vD1yrIIn7LuHV/yY379hpDENKGQGaq6S9sP
         1TcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rRQTF3eUoU19lJsDrokJs39TubLwCMj/oIO8QFo8TUE=;
        b=tYEYYkqkjDWEkXFd9zFIsQ1vGYU1nO887N4ddAp4pVqFgFzVr07b52H+IN1bI0nxGq
         wFVQbPiFP/Nj4/lb546EpNERXPpRJV9OoaJYlfzpjXAjH/Brg1Xq1rjYE+BoUSQ01rkn
         RT6A2+PF+r1c67WUt4WfVP7F6ijXAG7vUP4tcJSRIgqsegvvp4T+I31LjBJY3yfiUlM1
         QeA3WKP5BaHkJc+1wqNgcEaiQIcHnVzSUCSD3e7MgMkZxtSIw+gBsnYBjlBWEcHHY2Jj
         vnhSCnBQnSHOfeH6KnPtRwzoDRVC8gQGxoazNeUDrZXa0lDWMcI3xhtvkZ1EQRlxKxJG
         hUKA==
X-Gm-Message-State: AOAM5326cEIr3NRbOoTSWAKJhuufn67i9zao00QK+x98wWo6IANlw/NJ
        qc0YmNIQrYteLdYzafYqv2Y1ky049a/qKLPm
X-Google-Smtp-Source: ABdhPJwZj7OaQ4xMxO32PVQ5wHi3Ik4yHK+nJlWFu6qUYThfWHjgPVaU6Yni5Y/5e8lx/U2722c8fQ==
X-Received: by 2002:a50:e40b:: with SMTP id d11mr14760967edm.198.1602252228831;
        Fri, 09 Oct 2020 07:03:48 -0700 (PDT)
Received: from localhost.localdomain ([151.251.253.218])
        by smtp.gmail.com with ESMTPSA id ck19sm6362483ejb.99.2020.10.09.07.03.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 07:03:48 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v24 04/10] trace-cmd: Move VM related logic in a separate file
Date:   Fri,  9 Oct 2020 17:03:32 +0300
Message-Id: <20201009140338.25260-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201009140338.25260-1-tz.stoyanov@gmail.com>
References: <20201009140338.25260-1-tz.stoyanov@gmail.com>
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
index 5e59adf8..09f13cf9 100644
--- a/tracecmd/Makefile
+++ b/tracecmd/Makefile
@@ -31,6 +31,7 @@ TRACE_CMD_OBJS += trace-show.o
 TRACE_CMD_OBJS += trace-list.o
 TRACE_CMD_OBJS += trace-usage.o
 TRACE_CMD_OBJS += trace-dump.o
+TRACE_CMD_OBJS += trace-vm.o
 ifeq ($(VSOCK_DEFINED), 1)
 TRACE_CMD_OBJS += trace-tsync.o
 endif
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index d148aa16..49549f87 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -8,6 +8,7 @@
 
 #include <sys/types.h>
 #include <dirent.h>	/* for DIR */
+#include <ctype.h>	/* for isdigit() */
 
 #include "trace-cmd.h"
 #include "event-utils.h"
@@ -283,6 +284,17 @@ void update_first_instance(struct buffer_instance *instance, int topt);
 
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
@@ -314,4 +326,12 @@ void *malloc_or_die(unsigned int size); /* Can be overridden */
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
index f72dfaaf..9149cf76 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3190,239 +3190,37 @@ static int do_accept(int sd)
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
@@ -4088,7 +3886,7 @@ static void append_buffer(struct tracecmd_output *handle,
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
2.26.2


Return-Path: <SRS0=entZ=EE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 312E9C55179
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Oct 2020 11:18:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC68220791
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Oct 2020 11:18:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lTQhVNy/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbgJ2LSY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Oct 2020 07:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgJ2LSX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Oct 2020 07:18:23 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 745C7C0613D2
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Oct 2020 04:18:23 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id p22so936693wmg.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Oct 2020 04:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1ehHLU07jCsXSog0LqVlf0iLrb/h1YMmu23Yzmtk510=;
        b=lTQhVNy/TbfTiYywlDONOZr+y7mUPZZBGP6QwFUPHelg6ugJv1lWEyJZQt6s+Xp2Vb
         bS3nsHQoSk7lO11Xq7xIKvUlnJvaISS18AXrx/OKO2rHCXzMumsMrz+1nOEE++ud8vzo
         CfK/3ucvR+phxPyUJwNe6rmuUHYZOyAfLp4psngxQtqnY1cWhkDAe0esmXCDES393S7I
         yQZq53TORG6zMRtyyEfqaoGQcWMlgsuazcV4ZA0h5grc2D4rkkbWqm6lb1PWTak05J0B
         SB6ltttHmsYfm+7G5VLtoi5vA4X3pgl37B1EysTuJxTdnOqIcxTITKsAx3zZ8BwaoDKl
         1F5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1ehHLU07jCsXSog0LqVlf0iLrb/h1YMmu23Yzmtk510=;
        b=P9rr1nnQLK/qPZmIKCoADkCqiboORT0JCZ67To0vwTTQRH41OoPR0FaZj51rZ6j3FL
         XLCFMB/9X11/5/VXC8FMFEll6R55OWbJoAePVXGCHPZrVjC8NtuZrnAkQL5yKxOnqDr9
         QQSNBGONwJhvE6R//sfxXjU4SGLVHKsavBVYFQsbpgO5J9ODb4vd/Aj1QFQ2AqOQIkMC
         0oNqFueeVDRCBs2FhcBE5IvKl2ooh6uF5EspWnkfYtq1JdjMedNsJYe22xql+u3kNJlz
         VkBvwbLZAakrf3pZRpi57pmA/1bmQ5ATWWeZR75+GFkjY23SBO//61/Wk0SafMhWuPvk
         /weA==
X-Gm-Message-State: AOAM530qicBEERH7W07KPqUpG2ZEBK5ilOoqQiPJU3APwkCziPwLOkh4
        gbebqJ9W9ZJ3COWNrPrs9+8HcrX4eRVREYcS
X-Google-Smtp-Source: ABdhPJwk1cN2M8b7LTV/VOUEDwhjI+xcP09aOfkJ1s4b4RyHZdf38Y1pAjC+JOG7p92W6jcIPCbseQ==
X-Received: by 2002:a1c:99d3:: with SMTP id b202mr3796780wme.0.1603970302161;
        Thu, 29 Oct 2020 04:18:22 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id a199sm4308067wmd.8.2020.10.29.04.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 04:18:21 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v25 03/16] trace-cmd: Move VM related logic in a separate file
Date:   Thu, 29 Oct 2020 13:18:03 +0200
Message-Id: <20201029111816.247241-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201029111816.247241-1-tz.stoyanov@gmail.com>
References: <20201029111816.247241-1-tz.stoyanov@gmail.com>
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
index 13fd60a9..aab2abe7 100644
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
@@ -313,4 +325,12 @@ void *malloc_or_die(unsigned int size); /* Can be overridden */
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
index 76dcaa2b..1149aaaa 100644
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
@@ -4089,7 +3887,7 @@ static void append_buffer(struct tracecmd_output *handle,
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


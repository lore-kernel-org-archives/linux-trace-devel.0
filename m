Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 624FBC43461
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 03:41:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B2A06141E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 03:41:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbhENDmO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 13 May 2021 23:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbhENDmN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 May 2021 23:42:13 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98B0C061756
        for <linux-trace-devel@vger.kernel.org>; Thu, 13 May 2021 20:41:01 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id b25so42670241eju.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 13 May 2021 20:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=420Q3Bk8atBb3041YH29BzLsjxGBbcJgp+Ae5yDpbyY=;
        b=fS16F3lh4g1f/in1IUZfCDHMrkMJltEgV9S9PewF+E0z6xSqi5el2syowrQvoieDBC
         ECxmFS2lwzlv+TJjhkgg5hHQ6LFsUPRALXtuRA34h8kzNXQlmtAgkBbO1XpLHhyi1MBo
         2dY94fwK1VOp0BJBSzQqyzNhOpbCQOMv8KuXrFkrLOJmLgQUDh69xrYHI4pVk9zKwvZH
         ZG+LHiwBH7J8yjwHBAyOkyC1IqZvH9fm26bAMIdSaiYBGISF+zpSwtq0zIIU2jF2vlkc
         oIOIB+tBBYcVDW2iFPRALaNPHbgCJPW4wOwGn4XbVeI9gkHfMp/H1X+gnnRjFZ2ncWws
         qsMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=420Q3Bk8atBb3041YH29BzLsjxGBbcJgp+Ae5yDpbyY=;
        b=qE8Pho1CNk3AhaqvhfEYfMbcmgUenfyhp4mDOcvMEuvfBIa9ucR5XHkK+g2+2UJhXb
         MYNe2lwppg9fV1Vgy3LNGcts9TITi/gzj1ekEkUHAnVS5/8Z/6/7Nivo6za2gKtSIgaf
         n07r7ABnU1yDWbeyVyGwAOuDh4mzgpdIdlOrrj/e+U1BaHnSjnJ/LuRUOc/nSQNc99JC
         70io4L5421V8uML9JGzaE5x/O9gCxGxxwmMiVMNAsDIgu5nHnsdK1Gn48aoJhcUtOhoT
         o/TSKIJIpz7Oo+7ODG+u76omIduA1cT2ZHL3ktCzsp3zHOfbvOxBd9/oh/LEsAnhyPK4
         gNag==
X-Gm-Message-State: AOAM533/Jsj1f6etqki7Vs/phLQ9jDBrFDmkgcrEKUOvPiDUYc7hFRT3
        lHA6BABZ6Xeqwo4rbRGRmO67KRt/D8VEFg==
X-Google-Smtp-Source: ABdhPJzSPxIJSG4SJvZI8wcTNiJ4V6D5fY/yKl9H4JNKXjU6+ITo+bNA4qfrcHHZ0e1UANx/ypXMow==
X-Received: by 2002:a17:906:6789:: with SMTP id q9mr47119573ejp.295.1620963660552;
        Thu, 13 May 2021 20:41:00 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k26sm2899649eje.67.2021.05.13.20.40.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 20:40:59 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Auto discover running KVM VMs using virsh
Date:   Fri, 14 May 2021 06:40:58 +0300
Message-Id: <20210514034058.37612-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The "trace-cmd record -A <guest>" option, used for guest tracing,
accepts VM name as parameter. But trace-cmd needs cid of that VM, in
order to perform the tracing. The old logic searches for a process with
name "qemu-system-" and parses its command line, to get guest name to
cid relation. Using a hardcoded process name and relying on specific
process command line arguments is not reliable way.
There is no API to get VM name to cid relation, but virsh can be used
instead of the old logic. As virsh is the official user interface to
libvirt, it should be more reliable than the old approach.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---

This patch depends on patch set:
"[PATCH v3 0/2] trace-cmd: Use vsock tracing to find cids and threads"
https://lore.kernel.org/linux-trace-devel/20210513204315.1206204-1-rostedt@goodmis.org/

 tracecmd/trace-vm.c | 179 +++++++++++---------------------------------
 1 file changed, 43 insertions(+), 136 deletions(-)

diff --git a/tracecmd/trace-vm.c b/tracecmd/trace-vm.c
index d3a37eee..b3921fb0 100644
--- a/tracecmd/trace-vm.c
+++ b/tracecmd/trace-vm.c
@@ -10,6 +10,7 @@
 #include <dirent.h>
 #include <limits.h>
 #include <unistd.h>
+#include <errno.h>
 
 #include "trace-local.h"
 #include "trace-msg.h"
@@ -17,25 +18,6 @@
 static struct trace_guest *guests;
 static size_t guests_len;
 
-static int set_vcpu_pid_mapping(struct trace_guest *guest, int cpu, int pid)
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
 static struct trace_guest *get_guest_by_cid(unsigned int guest_cid)
 {
 	int i;
@@ -330,140 +312,65 @@ struct trace_guest *trace_get_guest(unsigned int cid, const char *name)
 	return guest;
 }
 
-static char *get_qemu_guest_name(char *arg)
+#define VM_CID_CMD	"virsh dumpxml"
+#define VM_CID_LINE	"<cid auto="
+#define VM_CID_ID	"address='"
+static void read_guest_cid(char *name)
 {
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
-static int read_qemu_guests_pids(char *guest_task, struct trace_guest *guest)
-{
-	struct dirent *entry;
-	char path[PATH_MAX];
-	char *buf = NULL;
-	size_t n = 0;
-	int ret = 0;
-	long vcpu;
-	long pid;
-	DIR *dir;
+	struct trace_guest *guest;
+	char *cmd = NULL;
+	char line[512];
+	char *cid;
+	unsigned int cid_id = 0;
 	FILE *f;
 
-	snprintf(path, sizeof(path), "/proc/%s/task", guest_task);
-	dir = opendir(path);
-	if (!dir)
-		return -1;
+	asprintf(&cmd, "%s %s", VM_CID_CMD, name);
+	f = popen(cmd, "r");
+	free(cmd);
+	if (f == NULL)
+		return;
 
-	while (!ret && (entry = readdir(dir))) {
-		if (!(entry->d_type == DT_DIR && is_digits(entry->d_name)))
+	while (fgets(line, sizeof(line), f) != NULL) {
+		if (!strstr(line, VM_CID_LINE))
 			continue;
-
-		snprintf(path, sizeof(path), "/proc/%s/task/%s/comm",
-			 guest_task, entry->d_name);
-		f = fopen(path, "r");
-		if (!f)
+		cid = strstr(line, VM_CID_ID);
+		if (!cid)
 			continue;
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
+		cid_id = strtol(cid + strlen(VM_CID_ID), NULL, 10);
+		if ((cid_id == LONG_MIN || cid_id == LONG_MAX) && errno == ERANGE)
+			continue;
+		guest = add_guest(cid_id, name);
+		if (guest)
+			find_pid_by_cid(guest);
+		break;
 	}
-	free(buf);
-	return ret;
+
+	/* close */
+	pclose(f);
 }
 
+#define VM_NAME_CMD	"virsh list --name"
 void read_qemu_guests(void)
 {
-	static bool initialized;
-	struct dirent *entry;
-	char path[PATH_MAX];
-	DIR *dir;
+	char name[256];
+	FILE *f;
 
-	if (initialized)
+	f = popen(VM_NAME_CMD, "r");
+	if (f == NULL) {
+		die("Failed to get VM names\n");
 		return;
+	}
 
-	initialized = true;
-	dir = opendir("/proc");
-	if (!dir)
-		die("Can not open /proc");
-
-	while ((entry = readdir(dir))) {
-		bool is_qemu = false, last_was_name = false;
-		struct trace_guest guest = {};
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
+	while (fgets(name, sizeof(name), f) != NULL) {
+		if (name[0] == '\n')
 			continue;
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
+		if (name[strlen(name) - 1] == '\n')
+			name[strlen(name) - 1] = '\0';
+		read_guest_cid(name);
 	}
 
-	closedir(dir);
+	/* close */
+	pclose(f);
 }
 
 int get_guest_vcpu_pid(unsigned int guest_cid, unsigned int guest_vcpu)
-- 
2.31.1


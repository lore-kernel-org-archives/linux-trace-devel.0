Return-Path: <SRS0=s7zG=UR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3262EC31E5D
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:40:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 088E621479
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:40:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RUmyHAAW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728572AbfFROkT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 10:40:19 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34058 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbfFROkT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 10:40:19 -0400
Received: by mail-wr1-f67.google.com with SMTP id k11so14307002wrl.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 18 Jun 2019 07:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lTsQwcQ9zxDSxAxhw/DojYbvncZ+2fQLbOSfTsDR3hc=;
        b=RUmyHAAWznNYdac3/9jo3fRIGnNuoZY1yXb8j+MUzOAOYEoTKgdp8Xv/1EFB1QZk3P
         heyAv84BacxMuzHjDEG0gZgajvcqRXcYvJCwcCdPTZxnoi0un3xLFu5K5ybJNOcL3wkH
         ng/IOcJIo/Kx4naPUKO33vzDEX2TLD64eTuJMi9xK5Xs9qHrVK4MswSy+CErF8/D73gT
         RHIm0+l0/2+rqWhMVUd52UNjod73jLv8ufWSbtlr6J5DkkynuC/5PT8SzGVocAwDUWlq
         FY/4M5rjbqt9mib1L+j/oR2dEL8vBEYtxsq9iYnOqb9cQh7kpL7lWJquP6fmXFZ0+t7K
         TK+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lTsQwcQ9zxDSxAxhw/DojYbvncZ+2fQLbOSfTsDR3hc=;
        b=And8BX63G+tbA7I38rbdxUFha7KycveSbevuUFcdLMAKQUN62e+mNPikxaKPyYHqW9
         RzW9dzBpHO4xPr5T44mCdp+/2C6Yua3nyQEFTLVFF7ZeGtNQC6p7uiU3iIu68mbGzOYW
         8nE9N4TOknI10NiXril4NN8dMFlZaopL8uooq3I1dOPtM69SZwNQzwjPcgnUHRDij/tl
         X4oLKrX+RsTXZj7/HbuiLoFvKQDT7Rh2fz24uoxWVDkm6vorz8ZsH2XEMtghTXogsV3y
         OXOzJ2rlciLjcViMlyGPUMbvk+QfZSn2N3AC6hGhtbi40qOZl3+zrhF0LBYaE0JZ2akz
         a1DQ==
X-Gm-Message-State: APjAAAUyRBRS6Vs6xZIBz3UgbQ16OXRYMllSKhdPanTP/RlQlmxXCR4b
        dJcsuD2MZSLSIiAvslJ/H4y6Kl4=
X-Google-Smtp-Source: APXvYqz0ep6U8WI7OsqSBZStPg+0a7lNjDEumyL9SPlAwe3LIBhEY7J9Ih8UvhcAGY7llcJw0sWp1A==
X-Received: by 2002:a5d:5702:: with SMTP id a2mr39334559wrv.89.1560868816545;
        Tue, 18 Jun 2019 07:40:16 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id y1sm2411808wma.32.2019.06.18.07.40.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 07:40:15 -0700 (PDT)
From:   "Slavomir Kaslev (VMware)" <slavomir.kaslev@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v11 09/13] trace-cmd: Add `trace-cmd setup-guest` command
Date:   Tue, 18 Jun 2019 17:39:54 +0300
Message-Id: <20190618143958.2865-10-slavomir.kaslev@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190618143958.2865-1-slavomir.kaslev@gmail.com>
References: <20190618143958.2865-1-slavomir.kaslev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Slavomir Kaslev <kaslevs@vmware.com>

Add `trace-cmd setup-guest` command that creates the necessary FIFOs for tracing
a guest over FIFOs instead of vsockets.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
Signed-off-by: Slavomir Kaslev (VMware) <slavomir.kaslev@gmail.com>
---
 tracecmd/Makefile              |   1 +
 tracecmd/include/trace-local.h |   6 ++
 tracecmd/trace-cmd.c           |   1 +
 tracecmd/trace-setup-guest.c   | 178 +++++++++++++++++++++++++++++++++
 tracecmd/trace-usage.c         |   8 ++
 5 files changed, 194 insertions(+)
 create mode 100644 tracecmd/trace-setup-guest.c

diff --git a/tracecmd/Makefile b/tracecmd/Makefile
index a2c0a76..46af5cc 100644
--- a/tracecmd/Makefile
+++ b/tracecmd/Makefile
@@ -35,6 +35,7 @@ TRACE_CMD_OBJS += trace-msg.o
 
 ifeq ($(VSOCK_DEFINED), 1)
 TRACE_CMD_OBJS += trace-agent.o
+TRACE_CMD_OBJS += trace-setup-guest.o
 endif
 
 ALL_OBJS := $(TRACE_CMD_OBJS:%.o=$(bdir)/%.o)
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 2872747..93da7da 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -14,6 +14,10 @@
 
 #define TRACE_AGENT_DEFAULT_PORT	823
 
+#define GUEST_PIPE_NAME		"trace-pipe-cpu"
+#define GUEST_DIR_FMT		"/var/lib/trace-cmd/virt/%s"
+#define GUEST_FIFO_FMT		GUEST_DIR_FMT "/" GUEST_PIPE_NAME "%d"
+
 extern int debug;
 extern int quiet;
 
@@ -68,6 +72,8 @@ void trace_listen(int argc, char **argv);
 
 void trace_agent(int argc, char **argv);
 
+void trace_setup_guest(int argc, char **argv);
+
 void trace_restore(int argc, char **argv);
 
 void trace_clear(int argc, char **argv);
diff --git a/tracecmd/trace-cmd.c b/tracecmd/trace-cmd.c
index 3ae5e2e..4da82b4 100644
--- a/tracecmd/trace-cmd.c
+++ b/tracecmd/trace-cmd.c
@@ -85,6 +85,7 @@ struct command commands[] = {
 	{"listen", trace_listen},
 #ifdef VSOCK
 	{"agent", trace_agent},
+	{"setup-guest", trace_setup_guest},
 #endif
 	{"split", trace_split},
 	{"restore", trace_restore},
diff --git a/tracecmd/trace-setup-guest.c b/tracecmd/trace-setup-guest.c
new file mode 100644
index 0000000..a6f58dc
--- /dev/null
+++ b/tracecmd/trace-setup-guest.c
@@ -0,0 +1,178 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 VMware Inc, Slavomir Kaslev <kaslevs@vmware.com>
+ *
+ */
+
+#include <errno.h>
+#include <fcntl.h>
+#include <getopt.h>
+#include <grp.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/stat.h>
+#include <unistd.h>
+
+#include "trace-local.h"
+#include "trace-msg.h"
+
+static int make_dir(const char *path, mode_t mode)
+{
+	char buf[PATH_MAX+2], *p;
+
+	strncpy(buf, path, sizeof(buf));
+	if (buf[PATH_MAX])
+		return -E2BIG;
+
+	for (p = buf; *p; p++) {
+		p += strspn(p, "/");
+		p += strcspn(p, "/");
+		*p = '\0';
+		if (mkdir(buf, mode) < 0 && errno != EEXIST)
+			return -errno;
+		*p = '/';
+	}
+
+	return 0;
+}
+
+static int make_fifo(const char *path, mode_t mode)
+{
+	struct stat st;
+
+	if (!stat(path, &st)) {
+		if (S_ISFIFO(st.st_mode))
+			return 0;
+		return -EEXIST;
+	}
+
+	if (mkfifo(path, mode))
+		return -errno;
+	return 0;
+}
+
+static int make_guest_dir(const char *guest)
+{
+	char path[PATH_MAX];
+
+	snprintf(path, sizeof(path), GUEST_DIR_FMT, guest);
+	return make_dir(path, 0750);
+}
+
+static int make_guest_fifo(const char *guest, int cpu, mode_t mode)
+{
+	static const char *exts[] = {".in", ".out"};
+	char path[PATH_MAX];
+	int i, ret = 0;
+
+	for (i = 0; i < ARRAY_SIZE(exts); i++) {
+		snprintf(path, sizeof(path), GUEST_FIFO_FMT "%s",
+			 guest, cpu, exts[i]);
+		ret = make_fifo(path, mode);
+		if (ret < 0)
+			break;
+	}
+
+	return ret;
+}
+
+static int make_guest_fifos(const char *guest, int nr_cpus, mode_t mode)
+{
+	int i, ret = 0;
+	mode_t mask;
+
+	mask = umask(0);
+	for (i = 0; i < nr_cpus; i++) {
+		ret = make_guest_fifo(guest, i, mode);
+		if (ret < 0)
+			break;
+	}
+	umask(mask);
+
+	return ret;
+}
+
+static void do_setup_guest(const char *guest, int nr_cpus, mode_t mode, gid_t gid)
+{
+	gid_t save_egid;
+	int ret;
+
+	if (gid != -1) {
+		save_egid = getegid();
+		ret = setegid(gid);
+		if (ret < 0)
+			pdie("failed to set effective group ID");
+	}
+
+	ret = make_guest_dir(guest);
+	if (ret < 0)
+		pdie("failed to create guest directory for %s", guest);
+
+	ret = make_guest_fifos(guest, nr_cpus, mode);
+	if (ret < 0)
+		pdie("failed to create FIFOs for %s", guest);
+
+	if (gid != -1) {
+		ret = setegid(save_egid);
+		if (ret < 0)
+			pdie("failed to restore effective group ID");
+	}
+}
+
+void trace_setup_guest(int argc, char **argv)
+{
+	struct group *group;
+	mode_t mode = 0660;
+	int nr_cpus = -1;
+	gid_t gid = -1;
+	char *guest;
+
+	if (argc < 2)
+		usage(argv);
+
+	if (strcmp(argv[1], "setup-guest") != 0)
+		usage(argv);
+
+	for (;;) {
+		int c, option_index = 0;
+		static struct option long_options[] = {
+			{"help", no_argument, NULL, '?'},
+			{NULL, 0, NULL, 0}
+		};
+
+		c = getopt_long(argc-1, argv+1, "+hc:p:g:",
+				long_options, &option_index);
+		if (c == -1)
+			break;
+		switch (c) {
+		case 'h':
+			usage(argv);
+			break;
+		case 'c':
+			nr_cpus = atoi(optarg);
+			break;
+		case 'p':
+			mode = strtol(optarg, NULL, 8);
+			break;
+		case 'g':
+			group = getgrnam(optarg);
+			if (!group)
+				pdie("group %s does not exist", optarg);
+			gid = group->gr_gid;
+			break;
+		default:
+			usage(argv);
+		}
+	}
+
+	if (optind != argc-2)
+		usage(argv);
+
+	guest = argv[optind+1];
+
+	if (nr_cpus <= 0)
+		pdie("invalid number of cpus for guest %s", guest);
+
+	do_setup_guest(guest, nr_cpus, mode, gid);
+}
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index da34ea2..0d1b58e 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -248,6 +248,14 @@ static struct usage_help usage_help[] = {
 		"          -p port number to listen on.\n"
 		"          -D run in daemon mode.\n"
 	},
+	{
+		"setup-guest",
+		"create FIFOs for tracing guest VMs",
+		" %s setup-guest -c cpus[-p perm][-g group] guest\n"
+		"          -c number of guest virtual CPUs\n"
+		"          -p FIFOs permissions (default: 0660)\n"
+		"          -g FIFOs group owner\n"
+	},
 #endif
 	{
 		"list",
-- 
2.20.1


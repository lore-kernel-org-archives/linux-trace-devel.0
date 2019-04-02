Return-Path: <SRS0=t+9I=SE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB2CBC4360F
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Apr 2019 13:45:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A2922133D
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Apr 2019 13:45:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731990AbfDBNp4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Apr 2019 09:45:56 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40526 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731818AbfDBNp4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Apr 2019 09:45:56 -0400
Received: by mail-wr1-f67.google.com with SMTP id h4so16715606wre.7
        for <linux-trace-devel@vger.kernel.org>; Tue, 02 Apr 2019 06:45:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0a7gIALhhxU1fh2WoTbKDkB7fSOAZCCtoJCD3lSIXrI=;
        b=eyo/EXo4MjGSjy+1PpGZ2Mzv/NqFAR7PK/EyhTzjcVT+gXD9Q+mebB6tJ3Gu8ithKQ
         MMUrU6J4zLsS9q51Q1UmN5DYaKtug62p/IOX5ib0PZTg2HTJQ0aUkmQ37/OGa6CDdaWi
         vPIwsx5qXdTYGOVa8K38CwuINZS5oInny93+L56f9tniAyZG+Ll6mDj7eNEqEogNua5l
         zEJhfLi5vBiyD/T0QRoK0HZl/84rrnRt8+1qZrRSHPSJMtYOBPcogvq9fKNDybHbGZzM
         wXJPzuFEMEUYAvbMBjUfbSuzcFNbL6kNGuiH8y4Gdl66d6RLdPYen6yAFBmofhP7kcEE
         4ZMA==
X-Gm-Message-State: APjAAAUYwckJtblK3lfrR8D4iLC8gwJp8fDCKJo3UAhzAPO8248Y5eKA
        2SC2wWl5P/aNiFdI8awBQw==
X-Google-Smtp-Source: APXvYqzTkwIPKLIRY2xl72Qbhrq/FsqiQD7jtFGC35BvlVux2UuRDoFOM1uALSLMTjGULGkdhWPPpw==
X-Received: by 2002:adf:ec87:: with SMTP id z7mr45120757wrn.44.1554212754298;
        Tue, 02 Apr 2019 06:45:54 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 17sm1765336wmk.39.2019.04.02.06.45.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Apr 2019 06:45:53 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: [RFC PATCH v9 08/11] trace-cmd: Add `trace-cmd setup-guest` command
Date:   Tue,  2 Apr 2019 16:45:37 +0300
Message-Id: <20190402134540.32321-9-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190402134540.32321-1-kaslevs@vmware.com>
References: <20190402134540.32321-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add `trace-cmd setup-guest` command that creates the necessary FIFOs for tracing
a guest over FIFOs instead of vsockets.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 tracecmd/Makefile              |   1 +
 tracecmd/include/trace-local.h |   6 ++
 tracecmd/trace-cmd.c           |   1 +
 tracecmd/trace-setup-guest.c   | 178 +++++++++++++++++++++++++++++++++
 tracecmd/trace-usage.c         |   8 ++
 5 files changed, 194 insertions(+)
 create mode 100644 tracecmd/trace-setup-guest.c

diff --git a/tracecmd/Makefile b/tracecmd/Makefile
index 865b1c6..d3e3080 100644
--- a/tracecmd/Makefile
+++ b/tracecmd/Makefile
@@ -35,6 +35,7 @@ TRACE_CMD_OBJS += trace-msg.o
 
 ifeq ($(VSOCK_DEFINED), 1)
 TRACE_CMD_OBJS += trace-agent.o
+TRACE_CMD_OBJS += trace-setup-guest.o
 endif
 
 ALL_OBJS := $(TRACE_CMD_OBJS:%.o=$(bdir)/%.o)
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index edcfee0..dd203b2 100644
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
index e845f50..7a8002f 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -246,6 +246,14 @@ static struct usage_help usage_help[] = {
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
2.19.1


Return-Path: <SRS0=aZMu=6W=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB8F8C47257
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 May 2020 09:45:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85D74208CA
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 May 2020 09:45:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C60/OImL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgEHJpM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 May 2020 05:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbgEHJpM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 May 2020 05:45:12 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5586C05BD43
        for <linux-trace-devel@vger.kernel.org>; Fri,  8 May 2020 02:45:11 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id f11so1016383ljp.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 May 2020 02:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+IdxwYD0WVDlaRrDPslfOFBKQSPAtuSOnSRgXtZ5mHw=;
        b=C60/OImL/WicbOrXF3Ptu7GagVMLeFiPenrWbabmcOoshpRtI+4RvgmqHEooyImhW+
         P+gBP+Pg3/uazohCiAtbKQJPiSRF749AxFkVxPmTAMJmakf0GPYRFOz/Xq6dmwdXQiiy
         gRd72gGueYOgpkDc/1+A0th3nih3BRDtUrX6XdIO85tynIRP2J0Q5I7USDSkJHHmr3uG
         sX+SUI25V6yOZ08IY320x02TKURyCElsC42hO7VVrG1wuqyOT3QhKyNNsVE8teax31iT
         GIBIMyGAfZ2cQMMBj/oF2cOQ0cZBuI4I4O0syqzzwKdnoOzryZPy9INQ5YXvArJNy+A6
         AJBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+IdxwYD0WVDlaRrDPslfOFBKQSPAtuSOnSRgXtZ5mHw=;
        b=AciH0/Iy5UJtyYM4CnFlDNVdAp1+UgFdvBxdLfZye2J1MB2saYb0pS7aWuxA04llDt
         BBVzvQwpmi7ZrqerFj98MYmrlcDtk7VQG+NQVLjLs88eOjB/RLaWciE7r9hweRBmIH0u
         TBQ3dG96Yy5KRsvN7YSpZP9XeXQvswA8aJxdMQnXBDfPoiXkruef4ZqE8ZuWG1SH8MN0
         9MpLvqmQVXsU32yc44VGjD5pA+7n5WL9kumVQHj1x+WAJsZm+RE99d3YHjrzYq7l6mZ+
         32ecVPwRrJB4KwXG7gNWd2f2DyTCCTSAuAt6sQhccux0rwPd4AHu19X36RCTdme8w6MX
         BCDw==
X-Gm-Message-State: AOAM5339YVASA2p5FoMuncQ1neOzDhQk1EXfztCXwj9odo8ji6wGOa4A
        a+BKPR2TgFSGCn0ka/QIFOcYMNVUJ/k=
X-Google-Smtp-Source: ABdhPJxpfI44/6IvCDIuRMoMWsPjHI2ZecZOF5AMJtHRuqu3j5VyfhmIxiMhwzMCeDM+g6o32134Ow==
X-Received: by 2002:a2e:8686:: with SMTP id l6mr1143854lji.152.1588931110013;
        Fri, 08 May 2020 02:45:10 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z8sm787239lfb.44.2020.05.08.02.45.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 02:45:09 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/2] trace-cmd: [POC] Add command for container tracing
Date:   Fri,  8 May 2020 12:45:04 +0300
Message-Id: <20200508094504.2419540-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508094504.2419540-1-tz.stoyanov@gmail.com>
References: <20200508094504.2419540-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new command "--container <container-id>" is added to "trace-cmd record"
sub command. It creates a ftrace instance and runs the tracing of
container's PIDs into it. Multiple "--container" options can be
specified, to trace multiple containers at the same time. The new option
behaves as "-B": all trace-cmd options specified after "--container"
affect only the tracing related to this container.
The patch is a POC, it introduces the infrastructure and helper
functions for container tracing.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h    |   3 +
 lib/trace-cmd/Makefile           |   1 +
 lib/trace-cmd/trace-containers.c | 141 +++++++++++++++++++++++++++++++
 tracecmd/include/trace-local.h   |   1 +
 tracecmd/trace-record.c          |  59 ++++++++++---
 5 files changed, 192 insertions(+), 13 deletions(-)
 create mode 100644 lib/trace-cmd/trace-containers.c

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index f3c95f30..6db719e6 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -501,4 +501,7 @@ void *tracecmd_record_page(struct tracecmd_input *handle,
 void *tracecmd_record_offset(struct tracecmd_input *handle,
 			     struct tep_record *record);
 
+/* --- Containers --- */
+int tracecmd_get_container_pids(char *cont_id, int **pids, int *pids_count);
+
 #endif /* _TRACE_CMD_H */
diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index ab7440ac..b68334b3 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -17,6 +17,7 @@ OBJS += trace-filter-hash.o
 OBJS += trace-msg.o
 OBJS += trace-plugin.o
 OBJS += trace-timesync.o
+OBJS += trace-containers.o
 
 # Additional util objects
 OBJS += trace-blk-hack.o
diff --git a/lib/trace-cmd/trace-containers.c b/lib/trace-cmd/trace-containers.c
new file mode 100644
index 00000000..f082a921
--- /dev/null
+++ b/lib/trace-cmd/trace-containers.c
@@ -0,0 +1,141 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2008, 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
+ *
+ * Updates:
+ * Copyright (C) 2020, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
+ *
+ */
+
+#include <stdlib.h>
+#include <stdio.h>
+#include <fcntl.h>
+#include <string.h>
+#include <sys/types.h>
+#include <dirent.h>
+#include <unistd.h>
+
+#include "trace-cmd-local.h"
+
+#define CGROUPV1_CPUSET_DOCKER "/sys/fs/cgroup/cpuset/docker/"
+#define CGROUPV1_PID_FILE	"cgroup.procs"
+
+static char *read_text_file(char *file)
+{
+	char stbuf[BUFSIZ];
+	char *buf = NULL;
+	int size = 0;
+	int fd = -1;
+
+	fd = open(file, O_RDONLY);
+	if (fd < 0)
+		goto out;
+
+	size = read(fd, stbuf, BUFSIZ);
+	if (size <= 0)
+		goto out;
+	buf = malloc(size + 1);
+	if (!buf)
+		goto out;
+	memcpy(buf, stbuf, size);
+	buf[size] = '\0';
+
+out:
+	if (fd >= 0)
+		close(fd);
+
+	return buf;
+}
+
+static char *match_in_dir(char *path, char *match)
+{
+	char *match_path = NULL;
+	struct dirent *dent;
+	char *name = NULL;
+	DIR *dir;
+
+	dir = opendir(path);
+	if (!dir)
+		return NULL;
+
+	while ((dent = readdir(dir))) {
+		name = dent->d_name;
+
+		if (!strncmp(name, match, strlen(match)))
+			break;
+		name = NULL;
+	}
+
+	closedir(dir);
+	if (name)
+		asprintf(&match_path, "%s/%s", path, name);
+
+	return match_path;
+}
+
+static int get_v1_docker_pids(char *cont_id, int **pids, int *pids_count)
+{
+	char *cont_dir = NULL;
+	char *pid_file = NULL;
+	char *pid_buf = NULL;
+	int *pid_array = NULL;
+	char *savestr;
+	char *pid_str;
+	int pcount = 0;
+	int ret = -1;
+
+	cont_dir = match_in_dir(CGROUPV1_CPUSET_DOCKER, cont_id);
+	if (!cont_dir)
+		goto out;
+	if (asprintf(&pid_file, "%s/%s", cont_dir, CGROUPV1_PID_FILE) < 0)
+		goto out;
+	pid_buf = read_text_file(pid_file);
+	if (!pid_buf)
+		goto out;
+
+	*pids = NULL;
+	*pids_count = 0;
+	pid_str = strtok_r(pid_buf, " \t\r\n\v\f", &savestr);
+	while (pid_str) {
+		pid_array = realloc(pid_array, (pcount + 1) * sizeof(int));
+		if (!pid_array)
+			break;
+		pid_array[pcount++] = atoi(pid_str);
+		pid_str = strtok_r(NULL, " \t\r\n\v\f", &savestr);
+	}
+
+	if (!pid_str) {
+		*pids = pid_array;
+		*pids_count = pcount;
+		ret = 0;
+	} else
+		free(pid_array);
+
+out:
+	free(cont_dir);
+	free(pid_file);
+	free(pid_buf);
+
+	return ret;
+}
+
+/*
+ * tracecmd_get_container_pids - Get PIDs associated with a given container
+ *
+ *@cont_id - container identifier
+ *@pids - returns allocated array of size @pids_count with PIDs
+ *@pids_count - size of returned array @pids
+ *
+ * Returns -1 in case of an error, 0 otherwise
+ * In case of success, returned array @pids must be freed by free()
+ */
+int tracecmd_get_container_pids(char *cont_id, int **pids, int *pids_count)
+{
+	int ret;
+
+	ret = get_v1_docker_pids(cont_id, pids, pids_count);
+	if (!ret)
+		return ret;
+
+	return -1;
+}
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 4c6a63d0..13e5afc6 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -168,6 +168,7 @@ enum buffer_instance_flags {
 	BUFFER_FL_GUEST		= 1 << 2,
 	BUFFER_FL_AGENT		= 1 << 3,
 	BUFFER_FL_HAS_CLOCK	= 1 << 4,
+	BUFFER_FL_CONTAINER	= 1 << 5,
 };
 
 struct func_list {
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index d0619ba6..219cebb7 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -5442,6 +5442,7 @@ void init_top_instance(void)
 }
 
 enum {
+	OPT_container		= 241,
 	OPT_tsyncinterval	= 242,
 	OPT_user		= 243,
 	OPT_procmap		= 244,
@@ -5705,6 +5706,46 @@ static void add_arg(struct buffer_instance *instance,
 	/* Not found? */
 }
 
+static void set_trace_child(struct buffer_instance *instance)
+{
+	test_set_event_pid(instance);
+	if (!instance->have_event_fork) {
+#ifdef NO_PTRACE
+		die("trace child: ptrace not supported");
+#endif
+		instance->ptrace_child = 1;
+		do_ptrace = 1;
+	} else {
+		save_option(instance, "event-fork");
+	}
+	if (instance->have_func_fork)
+		save_option(instance, "function-fork");
+}
+
+static struct buffer_instance *parse_container(char *container)
+{
+	struct buffer_instance *instance;
+	int pids_count = 0;
+	int *pids = NULL;
+	int ret;
+
+	ret = tracecmd_get_container_pids(container, &pids, &pids_count);
+	if (ret < 0 || !pids_count)
+		die("Failed to get container %s PIDs", container);
+
+	instance = create_instance(container);
+	if (!instance)
+		die("Failed to create instance %s", container);
+	add_instance(instance, local_cpu_count);
+	instance->flags |= BUFFER_FL_CONTAINER;
+	set_trace_child(instance);
+	for (int i = 0; i < pids_count; i++)
+		add_filter_pid(instance, pids[i], 0);
+
+	free(pids);
+	return instance;
+}
+
 static void parse_record_options(int argc,
 				 char **argv,
 				 enum trace_cmd curr_cmd,
@@ -5750,6 +5791,7 @@ static void parse_record_options(int argc,
 			{"user", required_argument, NULL, OPT_user},
 			{"module", required_argument, NULL, OPT_module},
 			{"tsync-interval", required_argument, NULL, OPT_tsyncinterval},
+			{"container", required_argument, NULL, OPT_container},
 			{NULL, 0, NULL, 0}
 		};
 
@@ -5870,20 +5912,8 @@ static void parse_record_options(int argc,
 			free(pids);
 			break;
 		case 'c':
-			test_set_event_pid(ctx->instance);
+			set_trace_child(ctx->instance);
 			do_children = 1;
-			if (!ctx->instance->have_event_fork) {
-#ifdef NO_PTRACE
-				die("-c invalid: ptrace not supported");
-#endif
-				do_ptrace = 1;
-				ctx->instance->ptrace_child = 1;
-
-			} else {
-				save_option(ctx->instance, "event-fork");
-			}
-			if (ctx->instance->have_func_fork)
-				save_option(ctx->instance, "function-fork");
 			break;
 		case 'C':
 			ctx->instance->clock = optarg;
@@ -6100,6 +6130,9 @@ static void parse_record_options(int argc,
 			top_instance.tsync.loop_interval = atoi(optarg);
 			guest_sync_set = true;
 			break;
+		case OPT_container:
+			ctx->instance = parse_container(optarg);
+			break;
 		case OPT_quiet:
 		case 'q':
 			quiet = true;
-- 
2.26.2


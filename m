Return-Path: <SRS0=0H5Y=CZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 713F2C35257
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Sep 2020 20:23:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14A3221D1B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Sep 2020 20:23:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nHl9kzI5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgIPUXR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Sep 2020 16:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727014AbgIPR2l (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Sep 2020 13:28:41 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C18B9C0698DB
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Sep 2020 04:47:13 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id o5so6506137wrn.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Sep 2020 04:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K1LxnU4cr6aLmAi3RhI/qP8LAQIoAZ1xGQJUGPlZEiI=;
        b=nHl9kzI5Hp5URwdLjrYqe49WyyN41pLgiRYCeNAs7rVpb7X7hHZzbVtadfcAN699UD
         PEa7fm/tMuXRP7biGIeKj0OdyCUQw5Lo6N6cxi28opRU8jm/uWDyZdesVcOF8WINyUsa
         s9jEHCk1SfS3ZjRJGnwtCljE5v1FgbJHn3UGQeIOollqkv7E8CXfDHMIVVDRBYV/b6KV
         9G5x0KnJ43h7NpBmCbV/+T5HtPv+UymMryMvRsXR7BMDY7DBiE8ix8zgQpqlGr0j+jc3
         wo2jpZzjRnRDr+hiWPvEDhPeQDd8eMDTcKHtL6h3UoIyJX5HMpbnr3EKyxDMnfAFEoIL
         LP2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K1LxnU4cr6aLmAi3RhI/qP8LAQIoAZ1xGQJUGPlZEiI=;
        b=T+CqTdk0djoia7l9eyoA9YgwDCqubVriU2MD22sQy3iD1eV9orIW1s4sOchJ1cx+Qa
         PLpSzVr1jgODjDDCRxNQcxH8xO8ezhL5C+7xipn9DUK9OzE4M9FrM7CAZiRKB9dqrUZS
         ausWr1qgwRhnFF29cvx6hE6Ko/+Mz2rttH6+fBLyvv1qaRHmKaVuMrFQzMAHNF2I8lNk
         3YHDKkpSvBas9D9CI2X8gpUXQqDHmSAyHJ6DrApU5brzz5kk9Y5rYjJwfQpWBg/PJv+/
         4haDHYlVSk5MWdwtJ70CpE7I5f6NHro0NNyPPt/aSbxf5kccsICmOc+TjMtV+zyVhWfK
         cTvQ==
X-Gm-Message-State: AOAM5329Z/Gr/WSA9t77toHns4Jt2TMvKQr4YVcrnFGf1204PgArgdyX
        /Q1y5vWhAkGcaEdC0JnxksBrwLTOUl1Qgg==
X-Google-Smtp-Source: ABdhPJyB1ciE37ENcXg7xsg90Osi5JDHQkS9iY61es+mV7s2Pj1s/WTLMK2q2Yr7Uva4dYOh1DoLRw==
X-Received: by 2002:a5d:6552:: with SMTP id z18mr1701760wrv.32.1600256832277;
        Wed, 16 Sep 2020 04:47:12 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z13sm32042040wro.97.2020.09.16.04.47.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 04:47:11 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 1/3] trace-cmd: Internal refactoring of pid address map logic
Date:   Wed, 16 Sep 2020 14:47:07 +0300
Message-Id: <20200916114709.291533-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200916114709.291533-1-tz.stoyanov@gmail.com>
References: <20200916114709.291533-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Make functions for collecting file to memory map of a PID non static,
so they can be reused in the trace-cmd application context. Created new
file trace-obj-debug.c with these functions.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/Makefile              |   1 +
 tracecmd/include/trace-local.h |  19 +++--
 tracecmd/trace-obj-debug.c     | 138 +++++++++++++++++++++++++++++++++
 tracecmd/trace-record.c        | 107 +------------------------
 4 files changed, 152 insertions(+), 113 deletions(-)
 create mode 100644 tracecmd/trace-obj-debug.c

diff --git a/tracecmd/Makefile b/tracecmd/Makefile
index 5e59adf8..f9435558 100644
--- a/tracecmd/Makefile
+++ b/tracecmd/Makefile
@@ -31,6 +31,7 @@ TRACE_CMD_OBJS += trace-show.o
 TRACE_CMD_OBJS += trace-list.o
 TRACE_CMD_OBJS += trace-usage.o
 TRACE_CMD_OBJS += trace-dump.o
+TRACE_CMD_OBJS += trace-obj-debug.o
 ifeq ($(VSOCK_DEFINED), 1)
 TRACE_CMD_OBJS += trace-tsync.o
 endif
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index d148aa16..c5c225e0 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -178,14 +178,6 @@ struct func_list {
 	const char *mod;
 };
 
-struct pid_addr_maps {
-	struct pid_addr_maps		*next;
-	struct tracecmd_proc_addr_map	*lib_maps;
-	unsigned int			nr_lib_maps;
-	char				*proc_name;
-	int				pid;
-};
-
 struct opt_list {
 	struct opt_list *next;
 	const char	*option;
@@ -314,4 +306,15 @@ void *malloc_or_die(unsigned int size); /* Can be overridden */
 void __noreturn __die(const char *fmt, ...);
 void __noreturn _vdie(const char *fmt, va_list ap);
 
+/* --- Debug symbols--- */
+struct pid_addr_maps {
+	struct pid_addr_maps	*next;
+	struct tracecmd_proc_addr_map	*lib_maps;
+	unsigned int			nr_lib_maps;
+	char				*proc_name;
+	int				pid;
+};
+int trace_debug_get_filemap(struct pid_addr_maps **file_maps, int pid);
+void trace_debug_free_filemap(struct pid_addr_maps *maps);
+
 #endif /* __TRACE_LOCAL_H */
diff --git a/tracecmd/trace-obj-debug.c b/tracecmd/trace-obj-debug.c
new file mode 100644
index 00000000..9aa9baae
--- /dev/null
+++ b/tracecmd/trace-obj-debug.c
@@ -0,0 +1,138 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2020, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
+ *
+ */
+#include <stdlib.h>
+#include <errno.h>
+#include <unistd.h>
+
+#include "trace-local.h"
+
+#define _STRINGIFY(x) #x
+#define STRINGIFY(x) _STRINGIFY(x)
+int trace_debug_get_filemap(struct pid_addr_maps **pid_maps, int pid)
+{
+	struct pid_addr_maps *maps = *pid_maps;
+	struct tracecmd_proc_addr_map *map;
+	unsigned long long begin, end;
+	struct pid_addr_maps *m;
+	char mapname[PATH_MAX+1];
+	char fname[PATH_MAX+1];
+	char buf[PATH_MAX+100];
+	FILE *f;
+	int ret;
+	int res;
+	int i;
+
+	sprintf(fname, "/proc/%d/exe", pid);
+	ret = readlink(fname, mapname, PATH_MAX);
+	if (ret >= PATH_MAX || ret < 0)
+		return -ENOENT;
+	mapname[ret] = 0;
+
+	sprintf(fname, "/proc/%d/maps", pid);
+	f = fopen(fname, "r");
+	if (!f)
+		return -ENOENT;
+
+	while (maps) {
+		if (pid == maps->pid)
+			break;
+		maps = maps->next;
+	}
+
+	ret = -ENOMEM;
+	if (!maps) {
+		maps = calloc(1, sizeof(*maps));
+		if (!maps)
+			goto out_fail;
+		maps->pid = pid;
+		maps->next = *pid_maps;
+		*pid_maps = maps;
+	} else {
+		for (i = 0; i < maps->nr_lib_maps; i++)
+			free(maps->lib_maps[i].lib_name);
+		free(maps->lib_maps);
+		maps->lib_maps = NULL;
+		maps->nr_lib_maps = 0;
+		free(maps->proc_name);
+	}
+
+	maps->proc_name = strdup(mapname);
+	if (!maps->proc_name)
+		goto out;
+
+	while (fgets(buf, sizeof(buf), f)) {
+		mapname[0] = '\0';
+		res = sscanf(buf, "%llx-%llx %*s %*x %*s %*d %"STRINGIFY(PATH_MAX)"s",
+			     &begin, &end, mapname);
+		if (res == 3 && mapname[0] != '\0') {
+			map = realloc(maps->lib_maps,
+				      (maps->nr_lib_maps + 1) * sizeof(*map));
+			if (!map)
+				goto out_fail;
+			map[maps->nr_lib_maps].end = end;
+			map[maps->nr_lib_maps].start = begin;
+			map[maps->nr_lib_maps].lib_name = strdup(mapname);
+			if (!map[maps->nr_lib_maps].lib_name)
+				goto out_fail;
+			maps->lib_maps = map;
+			maps->nr_lib_maps++;
+		}
+	}
+out:
+	fclose(f);
+	return 0;
+
+out_fail:
+	fclose(f);
+	if (maps) {
+		for (i = 0; i < maps->nr_lib_maps; i++)
+			free(maps->lib_maps[i].lib_name);
+		if (*pid_maps != maps) {
+			m = *pid_maps;
+			while (m) {
+				if (m->next == maps) {
+					m->next = maps->next;
+					break;
+				}
+				m = m->next;
+			}
+		} else
+			*pid_maps = maps->next;
+		free(maps->lib_maps);
+		maps->lib_maps = NULL;
+		maps->nr_lib_maps = 0;
+		free(maps->proc_name);
+		maps->proc_name = NULL;
+		free(maps);
+	}
+	return ret;
+}
+
+static void procmap_free(struct pid_addr_maps *maps)
+{
+	int i;
+
+	if (!maps)
+		return;
+	if (maps->lib_maps) {
+		for (i = 0; i < maps->nr_lib_maps; i++)
+			free(maps->lib_maps[i].lib_name);
+		free(maps->lib_maps);
+	}
+	free(maps->proc_name);
+	free(maps);
+}
+
+void trace_debug_free_filemap(struct pid_addr_maps *maps)
+{
+	struct pid_addr_maps *del;
+
+	while (maps) {
+		del = maps;
+		maps = maps->next;
+		procmap_free(del);
+	}
+}
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index bd004574..a48475b3 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -1080,109 +1080,6 @@ static char *make_pid_filter(struct buffer_instance *instance,
 	return filter;
 }
 
-#define _STRINGIFY(x) #x
-#define STRINGIFY(x) _STRINGIFY(x)
-
-static int get_pid_addr_maps(struct buffer_instance *instance, int pid)
-{
-	struct pid_addr_maps *maps = instance->pid_maps;
-	struct tracecmd_proc_addr_map *map;
-	unsigned long long begin, end;
-	struct pid_addr_maps *m;
-	char mapname[PATH_MAX+1];
-	char fname[PATH_MAX+1];
-	char buf[PATH_MAX+100];
-	FILE *f;
-	int ret;
-	int res;
-	int i;
-
-	sprintf(fname, "/proc/%d/exe", pid);
-	ret = readlink(fname, mapname, PATH_MAX);
-	if (ret >= PATH_MAX || ret < 0)
-		return -ENOENT;
-	mapname[ret] = 0;
-
-	sprintf(fname, "/proc/%d/maps", pid);
-	f = fopen(fname, "r");
-	if (!f)
-		return -ENOENT;
-
-	while (maps) {
-		if (pid == maps->pid)
-			break;
-		maps = maps->next;
-	}
-
-	ret = -ENOMEM;
-	if (!maps) {
-		maps = calloc(1, sizeof(*maps));
-		if (!maps)
-			goto out_fail;
-		maps->pid = pid;
-		maps->next = instance->pid_maps;
-		instance->pid_maps = maps;
-	} else {
-		for (i = 0; i < maps->nr_lib_maps; i++)
-			free(maps->lib_maps[i].lib_name);
-		free(maps->lib_maps);
-		maps->lib_maps = NULL;
-		maps->nr_lib_maps = 0;
-		free(maps->proc_name);
-	}
-
-	maps->proc_name = strdup(mapname);
-	if (!maps->proc_name)
-		goto out;
-
-	while (fgets(buf, sizeof(buf), f)) {
-		mapname[0] = '\0';
-		res = sscanf(buf, "%llx-%llx %*s %*x %*s %*d %"STRINGIFY(PATH_MAX)"s",
-			     &begin, &end, mapname);
-		if (res == 3 && mapname[0] != '\0') {
-			map = realloc(maps->lib_maps,
-				      (maps->nr_lib_maps + 1) * sizeof(*map));
-			if (!map)
-				goto out_fail;
-			map[maps->nr_lib_maps].end = end;
-			map[maps->nr_lib_maps].start = begin;
-			map[maps->nr_lib_maps].lib_name = strdup(mapname);
-			if (!map[maps->nr_lib_maps].lib_name)
-				goto out_fail;
-			maps->lib_maps = map;
-			maps->nr_lib_maps++;
-		}
-	}
-out:
-	fclose(f);
-	return 0;
-
-out_fail:
-	fclose(f);
-	if (maps) {
-		for (i = 0; i < maps->nr_lib_maps; i++)
-			free(maps->lib_maps[i].lib_name);
-		if (instance->pid_maps != maps) {
-			m = instance->pid_maps;
-			while (m) {
-				if (m->next == maps) {
-					m->next = maps->next;
-					break;
-				}
-				m = m->next;
-			}
-		} else
-			instance->pid_maps = maps->next;
-		free(maps->lib_maps);
-		maps->lib_maps = NULL;
-		maps->nr_lib_maps = 0;
-		free(maps->proc_name);
-		maps->proc_name = NULL;
-		free(maps);
-	}
-	return ret;
-}
-
 static void get_filter_pid_maps(void)
 {
 	struct buffer_instance *instance;
@@ -1194,7 +1091,7 @@ static void get_filter_pid_maps(void)
 		for (p = instance->filter_pids; p; p = p->next) {
 			if (p->exclude)
 				continue;
-			get_pid_addr_maps(instance, p->pid);
+			trace_debug_get_filemap(&instance->pid_maps, p->pid);
 		}
 	}
 }
@@ -1524,7 +1421,7 @@ static void ptrace_wait(enum trace_type type)
 			case PTRACE_EVENT_EXIT:
 				instance = get_intance_fpid(pid);
 				if (instance && instance->get_procmap)
-					get_pid_addr_maps(instance, pid);
+					trace_debug_get_filemap(&instance->pid_maps, pid);
 				ptrace(PTRACE_GETEVENTMSG, pid, NULL, &cstatus);
 				ptrace(PTRACE_DETACH, pid, NULL, NULL);
 				break;
-- 
2.26.2


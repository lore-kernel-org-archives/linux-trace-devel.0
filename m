Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72650C71155
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Dec 2020 06:03:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1474A20643
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Dec 2020 06:03:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbgLCGDL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 3 Dec 2020 01:03:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbgLCGDL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 3 Dec 2020 01:03:11 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB96C061A4F
        for <linux-trace-devel@vger.kernel.org>; Wed,  2 Dec 2020 22:02:31 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id f23so1669048ejt.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 02 Dec 2020 22:02:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QgYUmGpqlm7Z7kW4Nx2qCnwyRCb2tXTKzlTEmo1MTbw=;
        b=CYx755cOfNv+G7qCCbnEH25KOA0WpxQPTcCIkVf8bQOl1ch6bmnJzzPWSI/zuh7r9O
         +fwD//OEWye5n0OGLhCKFzEjY5mLRkrRMqjpuMAO6kHM7tREN42ukO4eUUdbE4m69Kez
         G4dK4Zpy2qns1iuxhmOevyY+HUW29/5kTy3NMlr9TLWpJcFbxz5xboeSMLejh3TBaOqr
         b2wUm03ZFkT6wPA4uvcCAbX78GDhEIXvmJZb58VQXZ0MtRRwfTO0klj0CUCd821IVCuY
         4jPMiJ3KtjecJEhuQxUXU5dLVAPV1hhTEuwiXHNbBzHE8e/tBDe33BWnFnoB8ly2WDtP
         Kh6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QgYUmGpqlm7Z7kW4Nx2qCnwyRCb2tXTKzlTEmo1MTbw=;
        b=X4ZQEo7u52Tbxbatm4QZfSAsRfeegeiI42Ki7wvXLzSRB0wXRcyZYgnVEmEEJQ2h04
         3EsNC29/2jVL/l00Xm0CFyyolyjgLPqPIT9l8hsx2+EwYm48krtR4l0T+iu2h8uf0QpA
         TyPz21Tk9wi+qEL31ReYvZkht/SEcqUQAvgXdVG3TQtjK+wn3JIoeN+lG22C8YaQBdiE
         lFqXLUMQvBQ6JC7SNrVOdcPdDE3TQ7YXUxseigOBYhyVUXFojo217BGmzk0kSF1BYsRq
         kolteS2aFjo3FzqeiIgNNbbn2/B0jmQJgemyCkjD9kzfn02kKgm+Y5Rhew5jYXqYrF7b
         0Y8Q==
X-Gm-Message-State: AOAM533R/02uiU/nOPw9BGMqNN7ctnxsgOiEUdyZc+FzpBumP6nx9UPP
        qfcGujvNBa1nsVrgoSlQoYMUzDXLQSsz31M+
X-Google-Smtp-Source: ABdhPJwgMywXB8LGqRCcI3NCcNPA7jh5aryrxWbUy9ifo41FxNUnzJzhSRBU/D6pzsCjEXgjKXjy4Q==
X-Received: by 2002:a17:907:20cc:: with SMTP id qq12mr1212376ejb.316.1606975349575;
        Wed, 02 Dec 2020 22:02:29 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d9sm388629edk.86.2020.12.02.22.02.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 22:02:28 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/5] trace-cmd: Internal refactoring of pid address map logic
Date:   Thu,  3 Dec 2020 08:02:22 +0200
Message-Id: <20201203060226.476475-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201203060226.476475-1-tz.stoyanov@gmail.com>
References: <20201203060226.476475-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index 01f36c61..5a16a5e5 100644
--- a/tracecmd/Makefile
+++ b/tracecmd/Makefile
@@ -32,6 +32,7 @@ TRACE_CMD_OBJS += trace-list.o
 TRACE_CMD_OBJS += trace-usage.o
 TRACE_CMD_OBJS += trace-dump.o
 TRACE_CMD_OBJS += trace-clear.o
+TRACE_CMD_OBJS += trace-obj-debug.o
 ifeq ($(VSOCK_DEFINED), 1)
 TRACE_CMD_OBJS += trace-tsync.o
 endif
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 85c7e03e..8b2d4c21 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -179,14 +179,6 @@ struct func_list {
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
@@ -315,4 +307,15 @@ void *malloc_or_die(unsigned int size); /* Can be overridden */
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
index 3a63f1bd..17d5474c 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -1075,109 +1075,6 @@ static char *make_pid_filter(struct buffer_instance *instance,
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
@@ -1189,7 +1086,7 @@ static void get_filter_pid_maps(void)
 		for (p = instance->filter_pids; p; p = p->next) {
 			if (p->exclude)
 				continue;
-			get_pid_addr_maps(instance, p->pid);
+			trace_debug_get_filemap(&instance->pid_maps, p->pid);
 		}
 	}
 }
@@ -1519,7 +1416,7 @@ static void ptrace_wait(enum trace_type type)
 			case PTRACE_EVENT_EXIT:
 				instance = get_intance_fpid(pid);
 				if (instance && instance->get_procmap)
-					get_pid_addr_maps(instance, pid);
+					trace_debug_get_filemap(&instance->pid_maps, pid);
 				ptrace(PTRACE_GETEVENTMSG, pid, NULL, &cstatus);
 				ptrace(PTRACE_DETACH, pid, NULL, NULL);
 				break;
-- 
2.28.0


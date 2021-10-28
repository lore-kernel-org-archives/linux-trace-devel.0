Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18485C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Oct 2021 12:09:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED3AE610F8
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Oct 2021 12:09:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbhJ1MLk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Oct 2021 08:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbhJ1MLj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Oct 2021 08:11:39 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C8DC061570
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Oct 2021 05:09:12 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id w1so4939778edd.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Oct 2021 05:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3XhVp4JSBUV8SttFoyd78ipydqoXFBMe4lekUcLa+WI=;
        b=q0zlotN7kvA2aDpK1XVgJHCajTQS9gpK1QNErliHh9wYWrXq8NxSMvH+sy0QHWnKCr
         ArJDlxNk1534CioxHmSEsVM8alP5ARG4UXpKLCiIxA5AZ0XdaXyaCLgqDusZy6v1j/DP
         jcYgt846Hz4mdRVMHGFtO0XspqDsCUCHhhtQMCZBFRFx89bREO33QJTa4VrYYqk45B5T
         O6NS3T9MRPQrGGZ0KCBJEv7LnfJllZ8aT+Zp+U8AJ+xdDhqsAJTXFx5LfXFCf2ZYfVGH
         WwR+n/zIPdp2xHaF38Dpdtc6S0PtOyDGxWVB6KneTEpXuPgD5s2RWrlvjp8vU7qIl+e+
         wcYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3XhVp4JSBUV8SttFoyd78ipydqoXFBMe4lekUcLa+WI=;
        b=V1JCgq3VZVspnWykboysK20Ulu+IIKJbo5VJI3cGRgvO53WNpCwq0ZjeetYz/YYkkA
         MIhBXaUXv3JDgxk0Kl3Vq7ZuSjUU5BCzJ8s3hWHQyOsQf8WvRAJtdOQoS0CH+dnJPe/H
         lsGkEY9qyh1psnRtlYiOWs9l8Xy/uSXeJVwEYUPVToze1sE5Y7d/GizLAkrL406cP8En
         9unK5XZnB5tNU3d5eCpHBTw2/oTZZcN5wgjzsZA7hQndELmokXhHov7QPAuMyN9qxQYM
         DHhx4NfyjytdF317AR1wq/+KjvCC6cs5t+/41R/oDy3TNIzDGmLfV7l+UJSzjoecskkZ
         DxFg==
X-Gm-Message-State: AOAM532XLkYqLRZZDOcTVXGHNqyDj5D1Xy5ig/km86/2D4+QyS9JDPBG
        /jqXdo1eKdYEkiYHF4IG+KUQE7x6wXcFjg==
X-Google-Smtp-Source: ABdhPJxX8lAX9IPg8PFekRaijxOUEccQKTYh1oRUFxnMrI1ENx9wEU/rfhHf2XSP9x3h6UlJ4qKZUg==
X-Received: by 2002:a50:d802:: with SMTP id o2mr5299690edj.331.1635422951251;
        Thu, 28 Oct 2021 05:09:11 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v6sm1803003edc.52.2021.10.28.05.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 05:09:10 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 01/12] libtracefs: Add new internal APIs for dynamic events
Date:   Thu, 28 Oct 2021 15:08:56 +0300
Message-Id: <20211028120907.101847-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211028120907.101847-1-tz.stoyanov@gmail.com>
References: <20211028120907.101847-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Ftrace supports dynamic events, created by the user - kprobes, uprobes,
eprobes and synthetic events. There are two interfaces for managing
these events - new common "dynamic_events" file and event specific
"kprobe_events", "uprobe_events", "synthetic_events" files. The
configuration syntax for all dynamic events is almost the same.
To simplify support of dynamic events in thw tracefs library, a new
internal helper layer is implemented. It handles both configuration
interfaces - the common "dynamic_events" file is preferred, if
available. On the old kernels, where this file is missing, the event
specific files are used. The new helper layer can be used to create,
delete and get ftrace dynamic events form any type. Most of the APIs
are internal, not exposed to the library users. Only one API is exposed
publicly:
 tracefs_dynevent_list_free()
This new logic is designed to be used internally within the library,
from the APIs that implement kprobes, uprobes, eprobes and synthetic
events support.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs-local.h |  34 +++
 include/tracefs.h       |   3 +
 src/Makefile            |   1 +
 src/tracefs-dynevents.c | 463 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 501 insertions(+)
 create mode 100644 src/tracefs-dynevents.c

diff --git a/include/tracefs-local.h b/include/tracefs-local.h
index 684eccf..f15896f 100644
--- a/include/tracefs-local.h
+++ b/include/tracefs-local.h
@@ -94,4 +94,38 @@ int synth_add_start_field(struct tracefs_synth *synth,
 			  const char *start_field,
 			  const char *name,
 			  enum tracefs_hist_key_type type);
+
+/* Internal interface for ftrace dynamic events */
+#define DYNEVENT_ADD_BIT(M, B)		((M) |= (1ULL<<(B)))
+#define DYNEVENT_CHECK_BIT(M, B)	((M)&(1ULL<<(B)))
+
+enum trace_dynevent_type {
+	TRACE_DYNEVENT_KPROBE = 0,
+	TRACE_DYNEVENT_KRETPROBE,
+	TRACE_DYNEVENT_UPROBE,
+	TRACE_DYNEVENT_URETPROBE,
+	TRACE_DYNEVENT_EPROBE,
+	TRACE_DYNEVENT_SYNTH,
+	TRACE_DYNEVENT_MAX,
+};
+
+struct tracefs_dynevent {
+	char *trace_file;
+	char *prefix;
+	char *system;
+	char *event;
+	char *address;
+	char *format;
+	enum trace_dynevent_type type;
+};
+
+struct tracefs_dynevent *
+dynevent_alloc(enum trace_dynevent_type type, const char *system,
+	       const char *event, const char *address, const char *format);
+void dynevent_free(struct tracefs_dynevent *devent);
+int dynevent_create(struct tracefs_dynevent *devent);
+int dynevent_destroy(struct tracefs_dynevent *devent);
+int dynevent_get_all(unsigned long type_mask, const char *system,
+		     struct tracefs_dynevent ***ret_events);
+
 #endif /* _TRACE_FS_LOCAL_H */
diff --git a/include/tracefs.h b/include/tracefs.h
index a2cda30..4020551 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -238,6 +238,9 @@ ssize_t tracefs_trace_pipe_stream(int fd, struct tracefs_instance *instance, int
 ssize_t tracefs_trace_pipe_print(struct tracefs_instance *instance, int flags);
 void tracefs_trace_pipe_stop(struct tracefs_instance *instance);
 
+struct tracefs_dynevent;
+void tracefs_dynevent_list_free(struct tracefs_dynevent ***events);
+
 enum tracefs_kprobe_type {
 	TRACEFS_ALL_KPROBES,
 	TRACEFS_KPROBE,
diff --git a/src/Makefile b/src/Makefile
index 4e38d98..99cd7da 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -11,6 +11,7 @@ OBJS += tracefs-marker.o
 OBJS += tracefs-kprobes.o
 OBJS += tracefs-hist.o
 OBJS += tracefs-filter.o
+OBJS += tracefs-dynevents.o
 
 # Order matters for the the three below
 OBJS += sqlhist-lex.o
diff --git a/src/tracefs-dynevents.c b/src/tracefs-dynevents.c
new file mode 100644
index 0000000..68ee95a
--- /dev/null
+++ b/src/tracefs-dynevents.c
@@ -0,0 +1,463 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2021 VMware Inc, Steven Rostedt <rostedt@goodmis.org>
+ *
+ * Updates:
+ * Copyright (C) 2021, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
+ *
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <dirent.h>
+#include <unistd.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <limits.h>
+
+#include "tracefs.h"
+#include "tracefs-local.h"
+
+#define DYNEVENTS_EVENTS "dynamic_events"
+#define KPROBE_EVENTS "kprobe_events"
+#define UPROBE_EVENTS "uprobe_events"
+#define SYNTH_EVENTS "synthetic_events"
+#define DYNEVENTS_DEFAULT_GROUP "dynamic"
+#define RETPROBE_DEFAUL_PREFIX	"r:"
+
+struct dyn_events_desc;
+static int dyn_generic_parse(struct dyn_events_desc *,
+			     const char *, char *, struct tracefs_dynevent **);
+static int dyn_synth_parse(struct dyn_events_desc *,
+			   const char *, char *, struct tracefs_dynevent **);
+static int dyn_generic_del(struct dyn_events_desc *, struct tracefs_dynevent *);
+static int dyn_synth_del(struct dyn_events_desc *, struct tracefs_dynevent *);
+
+struct dyn_events_desc {
+	enum trace_dynevent_type type;
+	const char *file;
+	const char *prefix;
+	int (*dyn_events_del)(struct dyn_events_desc *desc, struct tracefs_dynevent *dyn);
+	int (*dyn_events_parse)(struct dyn_events_desc *desc, const char *group,
+				char *line, struct tracefs_dynevent **ret_dyn);
+} dynevents[TRACE_DYNEVENT_MAX] = {
+	{TRACE_DYNEVENT_KPROBE, NULL, "p:", dyn_generic_del, dyn_generic_parse},
+	{TRACE_DYNEVENT_KRETPROBE, NULL, "r", dyn_generic_del, dyn_generic_parse},
+	{TRACE_DYNEVENT_UPROBE, NULL, "p:", dyn_generic_del, dyn_generic_parse},
+	{TRACE_DYNEVENT_URETPROBE, NULL, "r", dyn_generic_del, dyn_generic_parse},
+	{TRACE_DYNEVENT_EPROBE, NULL, "e:", dyn_generic_del, dyn_generic_parse},
+	{TRACE_DYNEVENT_SYNTH, NULL, "s:", dyn_synth_del, dyn_synth_parse},
+};
+
+int dyn_generic_del(struct dyn_events_desc *desc, struct tracefs_dynevent *dyn)
+{
+	char *str;
+	int ret;
+
+	if (dyn->system)
+		ret = asprintf(&str, "-:%s/%s", dyn->system, dyn->event);
+	else
+		ret = asprintf(&str, "-:%s", dyn->event);
+
+	if (ret < 0)
+		return -1;
+
+	ret = tracefs_instance_file_append(NULL, desc->file, str);
+	free(str);
+
+	return ret < 0 ? ret : 0;
+}
+
+__hidden void dynevent_free(struct tracefs_dynevent *devent)
+{
+	if (!devent)
+		return;
+	free(devent->system);
+	free(devent->event);
+	free(devent->address);
+	free(devent->format);
+	free(devent->prefix);
+	free(devent->trace_file);
+	free(devent);
+}
+
+static int dyn_generic_parse(struct dyn_events_desc *desc, const char *group,
+			     char *line, struct tracefs_dynevent **ret_dyn)
+{
+	struct tracefs_dynevent *dyn;
+	char *address;
+	char *system;
+	char *format;
+	char *event;
+
+	if (strncmp(line, desc->prefix, strlen(desc->prefix)))
+		return -1;
+
+	system = strchr(line, ':');
+	if (!system)
+		return -1;
+	event = strchr(line, '/');
+	if (!event)
+		return -1;
+	address = strchr(line, ' ');
+	if (!address)
+		return -1;
+	format = strchr(address+1, ' ');
+
+	*address = '\0';
+	*event = '\0';
+
+	/* KPROBEs and UPROBEs share the same prefix, check the format */
+	if (desc->type == TRACE_DYNEVENT_UPROBE || desc->type == TRACE_DYNEVENT_URETPROBE) {
+		if (!strchr(format, '/'))
+			return -1;
+	}
+	if (group && strcmp(group, system+1) != 0)
+		return -1;
+
+	if (!ret_dyn)
+		return 0;
+
+	dyn = calloc(1, sizeof(*dyn));
+	if (!dyn)
+		return -1;
+	dyn->type = desc->type;
+	dyn->trace_file = strdup(desc->file);
+	if (!dyn->trace_file)
+		goto error;
+	dyn->system = strdup(system+1);
+	if (!dyn->system)
+		goto error;
+	*(system+1) = '\0';
+	/* Prefix of KRETPROBE can contain MAXACTIVE integer */
+	dyn->prefix = strdup(line);
+	if (!dyn->prefix)
+		goto error;
+	dyn->event = strdup(event+1);
+	if (!dyn->event)
+		goto error;
+	if (desc->type == TRACE_DYNEVENT_SYNTH) {
+		/* Synthetic events have no address */
+		dyn->format = strdup(address+1);
+		if (!dyn->format)
+			goto error;
+	} else {
+		if (format)
+			*format = '\0';
+		dyn->address = strdup(address+1);
+		if (!dyn->address)
+			goto error;
+		if (format) {
+			dyn->format = strdup(format+1);
+			if (!dyn->format)
+				goto error;
+		}
+	}
+	*ret_dyn = dyn;
+	return 0;
+error:
+	dynevent_free(dyn);
+	return -1;
+}
+
+int dyn_synth_del(struct dyn_events_desc *desc, struct tracefs_dynevent *dyn)
+{
+	char *str;
+	int ret;
+
+	if (strcmp(desc->file, DYNEVENTS_EVENTS))
+		return dyn_generic_del(desc, dyn);
+
+	ret = asprintf(&str, "!%s", dyn->event);
+	if (ret < 0)
+		return -1;
+
+	ret = tracefs_instance_file_append(NULL, desc->file, str);
+	free(str);
+
+	return ret < 0 ? ret : 0;
+}
+
+static int dyn_synth_parse(struct dyn_events_desc *desc, const char *group,
+			   char *line, struct tracefs_dynevent **ret_dyn)
+{
+	struct tracefs_dynevent *dyn;
+	char *format;
+
+	if (strcmp(desc->file, DYNEVENTS_EVENTS))
+		return dyn_generic_parse(desc, group, line, ret_dyn);
+
+	/* synthetic_events file has slightly different syntax */
+	format = strchr(line, ' ');
+	if (!format)
+		return -1;
+	if (!ret_dyn)
+		return 0;
+
+	*format = '\0';
+	dyn = calloc(1, sizeof(*dyn));
+	if (!dyn)
+		return -1;
+	dyn->type = desc->type;
+	dyn->trace_file = strdup(desc->file);
+	if (!dyn->trace_file)
+		goto error;
+
+	dyn->event = strdup(line);
+	if (!dyn->event)
+		goto error;
+	dyn->format = strdup(format+1);
+	if (!dyn->format)
+		goto error;
+
+	*ret_dyn = dyn;
+	return 0;
+error:
+	dynevent_free(dyn);
+	return -1;
+}
+
+static struct dyn_events_desc *get_devent_desc(enum trace_dynevent_type type)
+{
+	static bool init;
+	int i;
+
+	if (init)
+		goto out;
+
+	init = true;
+	/* Use  ftrace dynamic_events, if available */
+	if (tracefs_file_exists(NULL, DYNEVENTS_EVENTS)) {
+		for (i = 0; i < TRACE_DYNEVENT_MAX; i++)
+			dynevents[i].file = DYNEVENTS_EVENTS;
+		goto out;
+	}
+
+	if (tracefs_file_exists(NULL, KPROBE_EVENTS)) {
+		dynevents[TRACE_DYNEVENT_KPROBE].file = KPROBE_EVENTS;
+		dynevents[TRACE_DYNEVENT_KRETPROBE].file = KPROBE_EVENTS;
+	}
+	if (tracefs_file_exists(NULL, UPROBE_EVENTS)) {
+		dynevents[TRACE_DYNEVENT_UPROBE].file = UPROBE_EVENTS;
+		dynevents[TRACE_DYNEVENT_URETPROBE].file = UPROBE_EVENTS;
+	}
+	if (tracefs_file_exists(NULL, SYNTH_EVENTS)) {
+		dynevents[TRACE_DYNEVENT_SYNTH].file = SYNTH_EVENTS;
+		dynevents[TRACE_DYNEVENT_SYNTH].prefix = "";
+	}
+
+out:
+	return &dynevents[type];
+}
+
+__hidden struct tracefs_dynevent *
+dynevent_alloc(enum trace_dynevent_type type, const char *system,
+	       const char *event, const char *address, const char *format)
+{
+	struct tracefs_dynevent *devent;
+	struct dyn_events_desc *desc;
+
+	if (!event) {
+		errno = EINVAL;
+		return NULL;
+	}
+
+	desc = get_devent_desc(type);
+	if (!desc || !desc->file) {
+		errno = ENOTSUP;
+		return NULL;
+	}
+
+	devent = calloc(1, sizeof(*devent));
+	if (!devent)
+		return NULL;
+
+	devent->type = type;
+	devent->trace_file = strdup(desc->file);
+	if (!devent->trace_file)
+		goto err;
+	if (!system)
+		system = DYNEVENTS_DEFAULT_GROUP;
+	devent->system = strdup(system);
+	if (!devent->system)
+		goto err;
+	devent->event = strdup(event);
+	if (!devent->event)
+		goto err;
+	if (type == TRACE_DYNEVENT_KRETPROBE || type == TRACE_DYNEVENT_URETPROBE)
+		devent->prefix = strdup(RETPROBE_DEFAUL_PREFIX);
+	else
+		devent->prefix = strdup(desc->prefix);
+
+	if (!devent->prefix)
+		goto err;
+	if (address) {
+		devent->address = strdup(address);
+		if (!devent->address)
+			goto err;
+	}
+	if (format) {
+		devent->format = strdup(format);
+		if (!devent->format)
+			goto err;
+	}
+
+	return devent;
+err:
+	dynevent_free(devent);
+	return NULL;
+}
+
+__hidden int dynevent_create(struct tracefs_dynevent *devent)
+{
+	char *str;
+	int ret;
+
+	if (!devent)
+		return -1;
+	if (devent->system && devent->system[0])
+		ret = asprintf(&str, "%s%s/%s %s %s\n",
+				devent->prefix, devent->system, devent->event,
+				devent->address?devent->address:"",
+				devent->format?devent->format:"");
+	else
+		ret = asprintf(&str, "%s%s %s %s\n",
+				devent->prefix, devent->event,
+				devent->address?devent->address:"",
+				devent->format?devent->format:"");
+	if (ret < 0)
+		return -1;
+	ret = tracefs_instance_file_append(NULL, devent->trace_file, str);
+	free(str);
+
+	return ret < 0 ? ret : 0;
+}
+
+__hidden int dynevent_destroy(struct tracefs_dynevent *devent)
+{
+	struct dyn_events_desc *desc;
+
+	if (!devent)
+		return -1;
+	desc = get_devent_desc(devent->type);
+	if (!desc)
+		return -1;
+	return desc->dyn_events_del(desc, devent);
+}
+
+static int get_all_type(enum trace_dynevent_type type, const char *system,
+			struct tracefs_dynevent ***ret_all)
+{
+	struct dyn_events_desc *desc;
+	struct tracefs_dynevent *devent, **tmp, **all = NULL;
+	char *content;
+	int count = 0;
+	char *line;
+	char *next;
+	int ret;
+
+	desc = get_devent_desc(type);
+	if (!desc)
+		return -1;
+
+	content = tracefs_instance_file_read(NULL, desc->file, NULL);
+	if (!content)
+		return -1;
+	line = content;
+	do {
+		next = strchr(line, '\n');
+		if (next)
+			*next = '\0';
+		ret = desc->dyn_events_parse(desc, system, line, ret_all ? &devent : NULL);
+		if (!ret) {
+			if (ret_all) {
+				tmp = realloc(all, (count+1)*sizeof(struct tracefs_dynevent *));
+				if (!tmp)
+					goto error;
+				all = tmp;
+				all[count] = devent;
+			}
+			count++;
+		}
+		line = next + 1;
+	} while (next);
+
+	free(content);
+	if (ret_all)
+		*ret_all = all;
+	return count;
+
+error:
+	free(content);
+	free(all);
+	return -1;
+}
+
+/**
+ * tracefs_dynevent_list_free - Deletes an array of pointers to dynamic event contexts
+ * @events: An array of pointers to dynamic event contexts. The last element of the array
+ *	    must be a NULL pointer.
+ */
+void tracefs_dynevent_list_free(struct tracefs_dynevent ***events)
+{
+	struct tracefs_dynevent **devent;
+	int i = 0;
+
+	if (!events || !(*events))
+		return;
+
+	devent = *events;
+	while (devent[i])
+		dynevent_free(devent[i++]);
+
+	free(*events);
+}
+
+__hidden int dynevent_get_all(unsigned long type_mask, const char *system,
+			      struct tracefs_dynevent ***ret_events)
+{
+	struct tracefs_dynevent **events, **tmp, **all_events = NULL;
+	int count, all = 0;
+	int i;
+
+	for (i = 0; i < TRACE_DYNEVENT_MAX; i++) {
+		if (!DYNEVENT_CHECK_BIT(type_mask, i))
+			continue;
+		count = get_all_type(i, system, ret_events ? &events : NULL);
+		if (count > 0) {
+			if (ret_events) {
+				tmp = realloc(all_events,
+					     (all + count)*sizeof(struct tracefs_dynevent *));
+				if (!tmp)
+					goto error;
+				all_events = tmp;
+				memcpy(all_events + all, events,
+				       count*sizeof(struct tracefs_dynevent *));
+			}
+			all += count;
+		}
+
+	}
+
+	if (ret_events) {
+		/* Add a NULL pointer at the end */
+		if (all > 0) {
+			tmp = realloc(all_events,
+				     (all + 1)*sizeof(struct tracefs_dynevent *));
+			if (!tmp)
+				goto error;
+			all_events = tmp;
+			all_events[all] = NULL;
+		}
+		*ret_events = all_events;
+	}
+
+	return all;
+
+error:
+	if (all_events) {
+		for (i = 0; i < all; i++)
+			free(all_events[i]);
+		free(all_events);
+	}
+	return -1;
+}
-- 
2.31.1


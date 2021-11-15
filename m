Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA027C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Nov 2021 10:46:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE363630EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Nov 2021 10:46:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbhKOKtN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Nov 2021 05:49:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237552AbhKOKs5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Nov 2021 05:48:57 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38610C061767
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Nov 2021 02:46:01 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id m14so70079303edd.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Nov 2021 02:46:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hHZSvWEMZvBGFSSKfwugmOq0OTi4IzuSUBBm/nGt270=;
        b=DJ95xjGWXC+/HFVN0W5/I/EmVp8wDCxNlC3EEn+2LZLFtVLQCC61cQUEaK4Hw4r1dR
         9/v7c28SvKWSv6bzMbR6/zPVGdizj5SdmUjLrcPm4/MISxGWmouMLOZbUyo6kBJxkWqt
         lpD6+M3tESjfLRPcoivUBo4TqlJVM6cmmuY+sSanOtqSNHiMK8TFkNwY1dOVkR5V9HSq
         P5hVInfTTBhM8a86Iy8bLkqliPfFRszTAtQcQRnBmCE28wTWQW5K84H3Sj6zSEA46pYR
         MpYjdDm84CLrP7PhA/tCIUbDVsn7okHFM4/LY0yIN2IVsfff+B2z1Rkx2ADM4aos6azi
         KoCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hHZSvWEMZvBGFSSKfwugmOq0OTi4IzuSUBBm/nGt270=;
        b=aLatcGBe78dtzd9tjRfXLuVEqI/Zo6emZLQ/snNGWJxmlJ6wRWY9AExbhB5H+XAVGJ
         sJv5VL7YNhIsvoqkDYTfZ8ReyxYb+zlwyceCJlKcRb23Mdys+PD9bopN2QKcNT3qpX8o
         1XVecikyUnHZWOy5k26yJ/1pjZfJcztyQDMFdOC+qRaCApAnGaxGKU7UgCC43+/DGZ9H
         3MU9TpouvTmjGldZrfb76BMOhtD+FhEtRgmUB6xhMQpc/OZ31CIABBQKzQgBXekGjpZz
         EVLD+4oiTs54rhgsTUPxnSgBVdPqCDp3YSzoLxp9/sPB2CdbJqfUkNjJygARR92GPRcG
         fUYA==
X-Gm-Message-State: AOAM5301lOvCgPeRWwy2DpdoYpEv35eB7zvdnzGNEVsB0Q+4AK1WEB9x
        v3uzjEylFZzJHw8IP5gRCpA=
X-Google-Smtp-Source: ABdhPJyM05RgKga5+QvgcMBbMVxd+8OQh2o/9BGowMuEj5/JHpgnHrykV5sJwUjbbXw1KAIpz2lhCQ==
X-Received: by 2002:a50:cd87:: with SMTP id p7mr54140658edi.205.1636973159635;
        Mon, 15 Nov 2021 02:45:59 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e12sm6315509ejs.86.2021.11.15.02.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 02:45:59 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 01/15] libtracefs: New APIs for dynamic events
Date:   Mon, 15 Nov 2021 12:45:42 +0200
Message-Id: <20211115104556.121359-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115104556.121359-1-tz.stoyanov@gmail.com>
References: <20211115104556.121359-1-tz.stoyanov@gmail.com>
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
To simplify support of dynamic events in the tracefs library, new
APIs are introduced. They handle both configuration interfaces -
the common "dynamic_events" file is preferred, if available.
On the old kernels, where this file is missing, the event
specific files are used. The new APIs can be used to create,
delete and get ftrace dynamic events from any type:

 enum tracefs_dynevent_type;
 tracefs_dynevent_create();
 tracefs_dynevent_destroy();
 tracefs_dynevent_destroy_all();
 tracefs_dynevent_free();
 tracefs_dynevent_list_free();
 tracefs_dynevent_get_all();

There is no public API for allocation of a new dynamic event, as that
logic is specific for each dynamic event type.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs-local.h |  18 +
 include/tracefs.h       |  23 ++
 src/Makefile            |   1 +
 src/tracefs-dynevents.c | 709 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 751 insertions(+)
 create mode 100644 src/tracefs-dynevents.c

diff --git a/include/tracefs-local.h b/include/tracefs-local.h
index 684eccf..a59e806 100644
--- a/include/tracefs-local.h
+++ b/include/tracefs-local.h
@@ -94,4 +94,22 @@ int synth_add_start_field(struct tracefs_synth *synth,
 			  const char *start_field,
 			  const char *name,
 			  enum tracefs_hist_key_type type);
+
+/* Internal interface for ftrace dynamic events */
+
+struct tracefs_dynevent {
+	char *trace_file;
+	char *prefix;
+	char *system;
+	char *event;
+	char *address;
+	char *format;
+	enum tracefs_dynevent_type type;
+};
+
+struct tracefs_dynevent *
+dynevent_alloc(enum tracefs_dynevent_type type, const char *system,
+	       const char *event, const char *address, const char *format);
+int dynevent_get_count(unsigned int types, const char *system);
+
 #endif /* _TRACE_FS_LOCAL_H */
diff --git a/include/tracefs.h b/include/tracefs.h
index a2cda30..eceb1f5 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -238,6 +238,29 @@ ssize_t tracefs_trace_pipe_stream(int fd, struct tracefs_instance *instance, int
 ssize_t tracefs_trace_pipe_print(struct tracefs_instance *instance, int flags);
 void tracefs_trace_pipe_stop(struct tracefs_instance *instance);
 
+/* Dynamic events */
+struct tracefs_dynevent;
+enum tracefs_dynevent_type {
+	TRACEFS_DYNEVENT_UNKNOWN	= 0,
+	TRACEFS_DYNEVENT_KPROBE		= 1 << 0,
+	TRACEFS_DYNEVENT_KRETPROBE	= 1 << 1,
+	TRACEFS_DYNEVENT_UPROBE		= 1 << 2,
+	TRACEFS_DYNEVENT_URETPROBE	= 1 << 3,
+	TRACEFS_DYNEVENT_EPROBE		= 1 << 4,
+	TRACEFS_DYNEVENT_SYNTH		= 1 << 5,
+	TRACEFS_DYNEVENT_MAX		= 1 << 6,
+};
+int tracefs_dynevent_create(struct tracefs_dynevent *devent);
+int tracefs_dynevent_destroy(struct tracefs_dynevent *devent, bool force);
+int tracefs_dynevent_destroy_all(unsigned int types, bool force);
+void tracefs_dynevent_free(struct tracefs_dynevent *devent);
+void tracefs_dynevent_list_free(struct tracefs_dynevent **events);
+struct tracefs_dynevent **
+tracefs_dynevent_get_all(unsigned int types, const char *system);
+enum tracefs_dynevent_type
+tracefs_dynevent_info(struct tracefs_dynevent *dynevent, char **system,
+		      char **event, char **prefix, char **addr, char **format);
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
index 0000000..0f7cccd
--- /dev/null
+++ b/src/tracefs-dynevents.c
@@ -0,0 +1,709 @@
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
+
+#define EVENT_INDEX(B)	(ffs(B) - 1)
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
+	enum tracefs_dynevent_type type;
+	const char *file;
+	const char *prefix;
+	int (*del)(struct dyn_events_desc *desc, struct tracefs_dynevent *dyn);
+	int (*parse)(struct dyn_events_desc *desc, const char *group,
+				char *line, struct tracefs_dynevent **ret_dyn);
+} dynevents[] = {
+	{TRACEFS_DYNEVENT_KPROBE, KPROBE_EVENTS, "p", dyn_generic_del, dyn_generic_parse},
+	{TRACEFS_DYNEVENT_KRETPROBE, KPROBE_EVENTS, "r", dyn_generic_del, dyn_generic_parse},
+	{TRACEFS_DYNEVENT_UPROBE, UPROBE_EVENTS, "p", dyn_generic_del, dyn_generic_parse},
+	{TRACEFS_DYNEVENT_URETPROBE, UPROBE_EVENTS, "r", dyn_generic_del, dyn_generic_parse},
+	{TRACEFS_DYNEVENT_EPROBE, "", "e", dyn_generic_del, dyn_generic_parse},
+	{TRACEFS_DYNEVENT_SYNTH, SYNTH_EVENTS, "", dyn_synth_del, dyn_synth_parse},
+};
+
+
+
+static int dyn_generic_del(struct dyn_events_desc *desc, struct tracefs_dynevent *dyn)
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
+/**
+ * tracefs_dynevent_free - Free a dynamic event context
+ * @devent: Pointer to a dynamic event context
+ *
+ * The dynamic event, described by this context, is not
+ * removed from the system by this API. It only frees the memory.
+ */
+void tracefs_dynevent_free(struct tracefs_dynevent *devent)
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
+static void parse_prefix(char *word, char **prefix, char **system, char **name)
+{
+	char *sav;
+
+	*prefix = NULL;
+	*system = NULL;
+	*name = NULL;
+
+	*prefix = strtok_r(word, ":", &sav);
+	*system = strtok_r(NULL, "/", &sav);
+	if (!(*system))
+		return;
+
+	*name = strtok_r(NULL, " \t", &sav);
+	if (!(*name)) {
+		*name = *system;
+		*system = NULL;
+	}
+}
+
+/*
+ * Parse lines from dynamic_events, kprobe_events and uprobe_events files
+ * PREFIX[:[SYSTEM/]EVENT] [ADDRSS] [FORMAT]
+ */
+static int dyn_generic_parse(struct dyn_events_desc *desc, const char *group,
+			     char *line, struct tracefs_dynevent **ret_dyn)
+{
+	struct tracefs_dynevent *dyn;
+	char *word;
+	char *format = NULL;
+	char *address;
+	char *system;
+	char *prefix;
+	char *event;
+	char *sav;
+
+	if (strncmp(line, desc->prefix, strlen(desc->prefix)))
+		return -1;
+
+	word = strtok_r(line, " \t", &sav);
+	if (!word || *word == '\0')
+		return -1;
+
+	parse_prefix(word, &prefix, &system, &event);
+	if (!prefix)
+		return -1;
+
+	if (desc->type != TRACEFS_DYNEVENT_SYNTH) {
+		address = strtok_r(NULL, " \t", &sav);
+		if (!address || *address == '\0')
+			return -1;
+	}
+
+	format = strtok_r(NULL, "", &sav);
+
+	/* KPROBEs and UPROBEs share the same prefix, check the format */
+	if (desc->type & (TRACEFS_DYNEVENT_UPROBE | TRACEFS_DYNEVENT_URETPROBE)) {
+		if (!strchr(address, '/'))
+			return -1;
+	}
+
+	if (group && (!system || strcmp(group, system) != 0))
+		return -1;
+
+	if (!ret_dyn)
+		return 0;
+
+	dyn = calloc(1, sizeof(*dyn));
+	if (!dyn)
+		return -1;
+
+	dyn->type = desc->type;
+	dyn->trace_file = strdup(desc->file);
+	if (!dyn->trace_file)
+		goto error;
+
+	dyn->prefix = strdup(prefix);
+	if (!dyn->prefix)
+		goto error;
+
+	if (system) {
+		dyn->system = strdup(system);
+		if (!dyn->system)
+			goto error;
+	}
+
+	if (event) {
+		dyn->event = strdup(event);
+		if (!dyn->event)
+			goto error;
+	}
+
+	if (address) {
+		dyn->address = strdup(address);
+		if (!dyn->address)
+			goto error;
+	}
+
+	if (format) {
+		dyn->format = strdup(format);
+		if (!dyn->format)
+			goto error;
+	}
+
+	*ret_dyn = dyn;
+	return 0;
+error:
+	tracefs_dynevent_free(dyn);
+	return -1;
+}
+
+static int dyn_synth_del(struct dyn_events_desc *desc, struct tracefs_dynevent *dyn)
+{
+	char *str;
+	int ret;
+
+	if (!strcmp(desc->file, DYNEVENTS_EVENTS))
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
+/*
+ * Parse lines from synthetic_events file
+ * EVENT ARG [ARG]
+ */
+static int dyn_synth_parse(struct dyn_events_desc *desc, const char *group,
+			   char *line, struct tracefs_dynevent **ret_dyn)
+{
+	struct tracefs_dynevent *dyn;
+	char *format;
+	char *event;
+	char *sav;
+
+	if (!strcmp(desc->file, DYNEVENTS_EVENTS))
+		return dyn_generic_parse(desc, group, line, ret_dyn);
+
+	/* synthetic_events file has slightly different syntax */
+	event = strtok_r(line, " \t", &sav);
+	if (!event || *event == '\0')
+		return -1;
+
+	format = strtok_r(NULL, "", &sav);
+	if (!format || *format == '\0')
+		return -1;
+
+	if (!ret_dyn)
+		return 0;
+
+	dyn = calloc(1, sizeof(*dyn));
+	if (!dyn)
+		return -1;
+
+	dyn->type = desc->type;
+	dyn->trace_file = strdup(desc->file);
+	if (!dyn->trace_file)
+		goto error;
+
+	dyn->event = strdup(event);
+	if (!dyn->event)
+		goto error;
+
+	dyn->format = strdup(format+1);
+	if (!dyn->format)
+		goto error;
+
+	*ret_dyn = dyn;
+	return 0;
+error:
+	tracefs_dynevent_free(dyn);
+	return -1;
+}
+
+static void init_devent_desc(void)
+{
+	int i;
+
+	BUILD_BUG_ON(ARRAY_SIZE(dynevents) != EVENT_INDEX(TRACEFS_DYNEVENT_MAX));
+
+	if (!tracefs_file_exists(NULL, DYNEVENTS_EVENTS))
+		return;
+
+	/* Use  ftrace dynamic_events, if available */
+	for (i = 0; i < EVENT_INDEX(TRACEFS_DYNEVENT_MAX); i++)
+		dynevents[i].file = DYNEVENTS_EVENTS;
+
+	dynevents[EVENT_INDEX(TRACEFS_DYNEVENT_SYNTH)].prefix = "s";
+}
+
+static struct dyn_events_desc *get_devent_desc(enum tracefs_dynevent_type type)
+{
+
+	static bool init;
+
+	if (type >= TRACEFS_DYNEVENT_MAX)
+		return NULL;
+
+	if (!init) {
+		init_devent_desc();
+		init = true;
+	}
+
+	return &dynevents[EVENT_INDEX(type)];
+}
+
+/**
+ * dynevent_alloc - Allocate new dynamic event
+ * @type: Type of the dynamic event
+ * @system: The system name (NULL for the default dynamic)
+ * @event: Name of the event
+ * @addr: The function and offset (or address) to insert the probe
+ * @format: The format string to define the probe.
+ *
+ * Allocate a dynamic event context that will be in the @system group
+ * (or dynamic if @system is NULL). Have the name of @event and
+ * will be associated to @addr, if applicable for that event type
+ * (function name, with or without offset, or a address). And the @format will
+ * define the format of the kprobe.
+ * The dynamic event is not created in the system.
+ *
+ * Return a pointer to a dynamic event context on success, or NULL on error.
+ * The returned pointer must be freed with tracefs_dynevent_free()
+ *
+ * errno will be set to EINVAL if event is NULL.
+ */
+__hidden struct tracefs_dynevent *
+dynevent_alloc(enum tracefs_dynevent_type type, const char *system,
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
+
+	if (!system)
+		system = DYNEVENTS_DEFAULT_GROUP;
+	devent->system = strdup(system);
+	if (!devent->system)
+		goto err;
+
+	devent->event = strdup(event);
+	if (!devent->event)
+		goto err;
+
+	devent->prefix = strdup(desc->prefix);
+	if (!devent->prefix)
+		goto err;
+
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
+	tracefs_dynevent_free(devent);
+	return NULL;
+}
+
+/**
+ * tracefs_dynevent_create - Create a dynamic event in the system
+ * @devent: Pointer to a dynamic event context, describing the event
+ *
+ * Return 0 on success, or -1 on error.
+ */
+int tracefs_dynevent_create(struct tracefs_dynevent *devent)
+{
+	char *str;
+	int ret;
+
+	if (!devent)
+		return -1;
+
+	if (devent->system && devent->system[0])
+		ret = asprintf(&str, "%s%s%s/%s %s %s\n",
+				devent->prefix, strlen(devent->prefix) ? ":" : "",
+				devent->system, devent->event,
+				devent->address ? devent->address : "",
+				devent->format ? devent->format : "");
+	else
+		ret = asprintf(&str, "%s%s%s %s %s\n",
+				devent->prefix, strlen(devent->prefix) ? ":" : "",
+				devent->event,
+				devent->address ? devent->address : "",
+				devent->format ? devent->format : "");
+	if (ret < 0)
+		return -1;
+
+	ret = tracefs_instance_file_append(NULL, devent->trace_file, str);
+	free(str);
+
+	return ret < 0 ? ret : 0;
+}
+
+static void disable_events(const char *system, const char *event,
+			   char **list)
+{
+	struct tracefs_instance *instance;
+	int i;
+
+	/*
+	 * Note, this will not fail even on error.
+	 * That is because even if something fails, it may still
+	 * work enough to clear the kprobes. If that's the case
+	 * the clearing after the loop will succeed and the function
+	 * is a success, even though other parts had failed. If
+	 * one of the kprobe events is enabled in one of the
+	 * instances that fail, then the clearing will fail too
+	 * and the function will return an error.
+	 */
+
+	tracefs_event_disable(NULL, system, event);
+	/* No need to test results */
+
+	if (!list)
+		return;
+
+	for (i = 0; list[i]; i++) {
+		instance = tracefs_instance_alloc(NULL, list[i]);
+		/* If this fails, try the next one */
+		if (!instance)
+			continue;
+		tracefs_event_disable(instance, system, event);
+		tracefs_instance_free(instance);
+	}
+}
+
+/**
+ * tracefs_dynevent_destroy - Remove a dynamic event from the system
+ * @devent: A dynamic event context, describing the dynamic event that will be deleted.
+ * @force: Will attempt to disable all events before removing them.
+ *
+ * The dynamic event context is not freed by this API. It only removes the event from the system.
+ * If there are any enabled events, and @force is not set, then it will error with -1 and errno
+ * to be EBUSY.
+ *
+ * Return 0 on success, or -1 on error.
+ */
+int tracefs_dynevent_destroy(struct tracefs_dynevent *devent, bool force)
+{
+	struct dyn_events_desc *desc;
+	char **instance_list;
+
+	if (!devent)
+		return -1;
+
+	if (force) {
+		instance_list = tracefs_instances(NULL);
+		disable_events(devent->system, devent->event, instance_list);
+		tracefs_list_free(instance_list);
+	}
+
+	desc = get_devent_desc(devent->type);
+	if (!desc)
+		return -1;
+
+	return desc->del(desc, devent);
+}
+
+static int get_all_dynevents(enum tracefs_dynevent_type type, const char *system,
+			     struct tracefs_dynevent ***ret_all)
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
+
+	line = content;
+	do {
+		next = strchr(line, '\n');
+		if (next)
+			*next = '\0';
+		ret = desc->parse(desc, system, line, ret_all ? &devent : NULL);
+		if (!ret) {
+			if (ret_all) {
+				tmp = realloc(all, (count + 1) * sizeof(*tmp));
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
+void tracefs_dynevent_list_free(struct tracefs_dynevent **events)
+{
+	int i;
+
+	if (!events)
+		return;
+
+	for (i = 0; events[i]; i++)
+		tracefs_dynevent_free(events[i]);
+
+	free(events);
+}
+
+/**
+ * tracefs_dynevent_get_all - return an array of pointers to dynamic events of given types
+ * @types: Dynamic event type, or bitmask of dynamic event types. If 0 is passed, all types
+ *	   are considered.
+ * @system: Get events from that system only. If @system is NULL, events from all systems
+ *	    are returned.
+ *
+ * Returns an array of pointers to dynamic events of given types that exist in the system.
+ * The array must be freed with tracefs_dynevent_list_free(). If there are no events a NULL
+ * pointer is returned.
+ */
+struct tracefs_dynevent **
+tracefs_dynevent_get_all(unsigned int types, const char *system)
+{
+	struct tracefs_dynevent **events, **tmp, **all_events = NULL;
+	int count, all = 0;
+	int i;
+
+	for (i = 1; i < TRACEFS_DYNEVENT_MAX; i <<= 1) {
+		if (types) {
+			if (i > types)
+				break;
+			if (!(types & i))
+				continue;
+		}
+		count = get_all_dynevents(i, system, &events);
+		if (count > 0) {
+			tmp = realloc(all_events, (all + count + 1) * sizeof(*tmp));
+			if (!tmp)
+				goto error;
+			all_events = tmp;
+			memcpy(all_events + all, events, count * sizeof(*events));
+			all += count;
+			/* Add a NULL pointer at the end */
+			all_events[all] = NULL;
+		}
+	}
+
+	return all_events;
+
+error:
+	if (all_events) {
+		for (i = 0; i < all; i++)
+			free(all_events[i]);
+		free(all_events);
+	}
+	return NULL;
+}
+
+/**
+ * tracefs_dynevent_destroy_all - removes all dynamic events of given types from the system
+ * @types: Dynamic event type, or bitmask of dynamic event types. If 0 is passed, all types
+ *	   are considered.
+ * @force: Will attempt to disable all events before removing them.
+ *
+ * Will remove all dynamic events of the given types from the system. If there are any enabled
+ * events, and @force is not set, then the removal of these will fail. If @force is set, then
+ * it will attempt to disable all the events in all instances before removing them.
+ *
+ * Returns zero if all requested events are removed successfully, or -1 if some of them are not
+ * removed.
+ */
+int tracefs_dynevent_destroy_all(unsigned int types, bool force)
+{
+	struct tracefs_dynevent **all;
+	int ret = 0;
+	int i;
+
+	all = tracefs_dynevent_get_all(types, NULL);
+	if (!all)
+		return 0;
+
+	for (i = 0; all[i]; i++) {
+		if (tracefs_dynevent_destroy(all[i], force))
+			ret = -1;
+	}
+
+	tracefs_dynevent_list_free(all);
+
+	return ret;
+}
+
+/**
+ * dynevent_get_count - Count dynamic events of given types and system
+ * @types: Dynamic event type, or bitmask of dynamic event types. If 0 is passed, all types
+ *	   are considered.
+ * @system: Count events from that system only. If @system is NULL, events from all systems
+ *	    are counted.
+ *
+ * Return the count of requested dynamic events
+ */
+__hidden int dynevent_get_count(unsigned int types, const char *system)
+{
+	int count, all = 0;
+	int i;
+
+	for (i = 1; i < TRACEFS_DYNEVENT_MAX; i <<= 1) {
+		if (types) {
+			if (i > types)
+				break;
+			if (!(types & i))
+				continue;
+		}
+		count = get_all_dynevents(i, system, NULL);
+		if (count > 0)
+			all += count;
+	}
+
+	return all;
+}
+
+/**
+ * tracefs_dynevent_info - return details of a dynamic event
+ * @dynevent: A dynamic event context, describing given dynamic event.
+ * @group: return, group in which the dynamic event is configured
+ * @event: return, name of the dynamic event
+ * @prefix: return, prefix string of the dynamic event
+ * @addr: return, the function and offset (or address) of the dynamic event
+ * @format: return, the format string of the dynamic event
+ *
+ * Returns the type of the dynamic event, or TRACEFS_DYNEVENT_UNKNOWN in case of an error.
+ * Any of the @group, @event, @prefix, @addr and @format parameters are optional.
+ * If a valid pointer is passed, in case of success - a string is allocated and returned.
+ * These strings must be freed with free().
+ */
+
+enum tracefs_dynevent_type
+tracefs_dynevent_info(struct tracefs_dynevent *dynevent, char **system,
+		      char **event, char **prefix, char **addr, char **format)
+{
+	char **lv[] = { system, event, prefix, addr, format };
+	char **rv[] = { &dynevent->system, &dynevent->event, &dynevent->prefix,
+			&dynevent->address, &dynevent->format };
+	int i;
+
+	if (!dynevent)
+		return TRACEFS_DYNEVENT_UNKNOWN;
+
+	for (i = 0; i < ARRAY_SIZE(lv); i++) {
+		if (lv[i]) {
+			if (*rv[i]) {
+				*lv[i] = strdup(*rv[i]);
+				if (!*lv[i])
+					goto error;
+			} else {
+				*lv[i] = NULL;
+			}
+		}
+	}
+
+	return dynevent->type;
+
+error:
+	for (i--; i >= 0; i--) {
+		if (lv[i])
+			free(*lv[i]);
+	}
+
+	return TRACEFS_DYNEVENT_UNKNOWN;
+}
-- 
2.33.1


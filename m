Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C823C4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Nov 2021 15:44:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45D916109F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Nov 2021 15:44:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbhKCPrB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 3 Nov 2021 11:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231843AbhKCPrA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Nov 2021 11:47:00 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88CBBC061714
        for <linux-trace-devel@vger.kernel.org>; Wed,  3 Nov 2021 08:44:23 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id d27so4243282wrb.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 03 Nov 2021 08:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6h1vJDYTBvV2ieEmEn+9t7HgisiwS1MOI2iEPcBsu0w=;
        b=LNnGfS9tfAZxKF3OHEf8oR3IFcBK0HdP3AuvOnhTMogE+truL9ll3kgEGRxu4iOb2s
         Bw0CEA68Rh6Dd8SBEntgVKTMEq91cJc5G6FdIb0HTCf+iaYcUx9aamh27QPq9TkYU5vR
         S3YVzLs6FWanWKCpbTLu95n5uS8zPnzhEJFbE098Y25l2Kyr2zHxma6Yc3ksj6uCf8Sf
         ucac0GA2a0gu4W9eOlPAZsR5klr66MGMYBScXVMmalQRxlnDk1sPbJOlTwOKawH/x/1e
         z+0+U75OjMueWgojgw1CwAmZxaKF711phxyYV1thHPd8nbaTXapuFBz1eXiVI55n+dl5
         rbkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6h1vJDYTBvV2ieEmEn+9t7HgisiwS1MOI2iEPcBsu0w=;
        b=YbJoc35XLnehvVHQ3vqP8pnZ23lHEiFU/4BDnyyINRA7qeVBUo8a2bHKqlyMZooUaZ
         V0C/giI/+TH76FgaP/RVJr+47x87W9tB8tnXkI7fwJptMgh5FOVwGZHhDleg0K5KXEkp
         jnXI4N9dXepLbIbY5lerFShW0mHBxcqhFCulpeQDzCZEtN6qIhOhzshvTu73ntQda5qw
         oCLvTQRCW+meS4UeRstK4uvPWjBO1VJTHTOOkz0ll2mK41p1ikCpGWd1UczRlrzex13r
         oCYifXZN85gXlJ5GuKpskl5BJNjwOnVAfsvP10YbvS37pBge6kL7O4bu3PYa7zBrKIJY
         lTrw==
X-Gm-Message-State: AOAM5309jSVuxZTEIPK9IZA7zDRTChVanrqTQIolK4a1BDsOTvSKC7JS
        kVSrdcQOmN3tNyEJMX9TC8g=
X-Google-Smtp-Source: ABdhPJxkj3QGNEDLxNtjv59i7QW/MSNjuTtz1x806Ow61CPuMDAsL2PC4eg4KtxBoY5DkUZ1V3gYcQ==
X-Received: by 2002:a05:6000:1a88:: with SMTP id f8mr5870764wry.54.1635954262019;
        Wed, 03 Nov 2021 08:44:22 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p12sm2767866wrr.10.2021.11.03.08.44.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 08:44:21 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 02/11] libtracefs: New APIs for dynamic events
Date:   Wed,  3 Nov 2021 17:44:08 +0200
Message-Id: <20211103154417.246999-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211103154417.246999-1-tz.stoyanov@gmail.com>
References: <20211103154417.246999-1-tz.stoyanov@gmail.com>
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
 include/tracefs-local.h |  18 ++
 include/tracefs.h       |  19 ++
 src/Makefile            |   1 +
 src/tracefs-dynevents.c | 601 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 639 insertions(+)
 create mode 100644 src/tracefs-dynevents.c

diff --git a/include/tracefs-local.h b/include/tracefs-local.h
index 684eccf..4d64ad4 100644
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
+int dynevent_get_count(unsigned long type_mask, const char *system);
+
 #endif /* _TRACE_FS_LOCAL_H */
diff --git a/include/tracefs.h b/include/tracefs.h
index fa7f316..470234d 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -242,6 +242,25 @@ ssize_t tracefs_trace_pipe_stream(int fd, struct tracefs_instance *instance, int
 ssize_t tracefs_trace_pipe_print(struct tracefs_instance *instance, int flags);
 void tracefs_trace_pipe_stop(struct tracefs_instance *instance);
 
+/* Dynamic events */
+struct tracefs_dynevent;
+enum tracefs_dynevent_type {
+	TRACEFS_DYNEVENT_KPROBE = 0,
+	TRACEFS_DYNEVENT_KRETPROBE,
+	TRACEFS_DYNEVENT_UPROBE,
+	TRACEFS_DYNEVENT_URETPROBE,
+	TRACEFS_DYNEVENT_EPROBE,
+	TRACEFS_DYNEVENT_SYNTH,
+	TRACEFS_DYNEVENT_MAX,
+};
+int tracefs_dynevent_create(struct tracefs_dynevent *devent);
+int tracefs_dynevent_destroy(struct tracefs_dynevent *devent, bool force);
+int tracefs_dynevent_destroy_all(unsigned long type_mask, bool force);
+void tracefs_dynevent_free(struct tracefs_dynevent *devent);
+void tracefs_dynevent_list_free(struct tracefs_dynevent **events);
+struct tracefs_dynevent **
+tracefs_dynevent_get_all(unsigned long type_mask, const char *system);
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
index 0000000..be2a7a0
--- /dev/null
+++ b/src/tracefs-dynevents.c
@@ -0,0 +1,601 @@
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
+	int (*dyn_events_del)(struct dyn_events_desc *desc, struct tracefs_dynevent *dyn);
+	int (*dyn_events_parse)(struct dyn_events_desc *desc, const char *group,
+				char *line, struct tracefs_dynevent **ret_dyn);
+} dynevents[] = {
+	{TRACEFS_DYNEVENT_KPROBE, NULL, "p", dyn_generic_del, dyn_generic_parse},
+	{TRACEFS_DYNEVENT_KRETPROBE, NULL, "r", dyn_generic_del, dyn_generic_parse},
+	{TRACEFS_DYNEVENT_UPROBE, NULL, "p", dyn_generic_del, dyn_generic_parse},
+	{TRACEFS_DYNEVENT_URETPROBE, NULL, "r", dyn_generic_del, dyn_generic_parse},
+	{TRACEFS_DYNEVENT_EPROBE, NULL, "e", dyn_generic_del, dyn_generic_parse},
+	{TRACEFS_DYNEVENT_SYNTH, NULL, "s", dyn_synth_del, dyn_synth_parse},
+};
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
+static int dyn_generic_parse(struct dyn_events_desc *desc, const char *group,
+			     char *line, struct tracefs_dynevent **ret_dyn)
+{
+	struct tracefs_dynevent *dyn;
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
+	prefix = strtok_r(line, ":", &sav);
+	if (!prefix)
+		return -1;
+	system = strtok_r(NULL, "/", &sav);
+	if (!system)
+		return -1;
+	event = strtok_r(NULL, " ", &sav);
+	if (!event)
+		return -1;
+	address = strtok_r(NULL, " ", &sav);
+	if (!address)
+		address = event + strlen(event) + 1;
+	else
+		format = address + strlen(address) + 1;
+
+	/* KPROBEs and UPROBEs share the same prefix, check the format */
+	if (desc->type == TRACEFS_DYNEVENT_UPROBE || desc->type == TRACEFS_DYNEVENT_URETPROBE) {
+		if (!strchr(address, '/'))
+			return -1;
+	}
+	if (group && strcmp(group, system) != 0)
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
+	dyn->system = strdup(system);
+	if (!dyn->system)
+		goto error;
+	/* Prefix of KRETPROBE can contain MAXACTIVE integer */
+	dyn->prefix = strdup(prefix);
+	if (!dyn->prefix)
+		goto error;
+	dyn->event = strdup(event);
+	if (!dyn->event)
+		goto error;
+	if (desc->type == TRACEFS_DYNEVENT_SYNTH) {
+		/* Synthetic events have no address */
+		dyn->format = strdup(address);
+		if (!dyn->format)
+			goto error;
+	} else {
+		dyn->address = strdup(address);
+		if (!dyn->address)
+			goto error;
+		if (*format != '\0') {
+			dyn->format = strdup(format);
+			if (!dyn->format)
+				goto error;
+		}
+	}
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
+	char *event;
+	char *sav;
+
+	if (strcmp(desc->file, DYNEVENTS_EVENTS))
+		return dyn_generic_parse(desc, group, line, ret_dyn);
+
+	/* synthetic_events file has slightly different syntax */
+	event = strtok_r(line, " ", &sav);
+	if (!event)
+		return -1;
+
+	format = event + strlen(event) + 1;
+	if (*format == '\0')
+		return -1;
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
+
+	dyn->event = strdup(event);
+	if (!dyn->event)
+		goto error;
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
+	BUILD_BUG_ON(ARRAY_SIZE(dynevents) != TRACEFS_DYNEVENT_MAX);
+
+	/* Use  ftrace dynamic_events, if available */
+	if (tracefs_file_exists(NULL, DYNEVENTS_EVENTS)) {
+		for (i = 0; i < TRACEFS_DYNEVENT_MAX; i++)
+			dynevents[i].file = DYNEVENTS_EVENTS;
+		return;
+	}
+
+	if (tracefs_file_exists(NULL, KPROBE_EVENTS)) {
+		dynevents[TRACEFS_DYNEVENT_KPROBE].file = KPROBE_EVENTS;
+		dynevents[TRACEFS_DYNEVENT_KRETPROBE].file = KPROBE_EVENTS;
+	}
+	if (tracefs_file_exists(NULL, UPROBE_EVENTS)) {
+		dynevents[TRACEFS_DYNEVENT_UPROBE].file = UPROBE_EVENTS;
+		dynevents[TRACEFS_DYNEVENT_URETPROBE].file = UPROBE_EVENTS;
+	}
+	if (tracefs_file_exists(NULL, SYNTH_EVENTS)) {
+		dynevents[TRACEFS_DYNEVENT_SYNTH].file = SYNTH_EVENTS;
+		dynevents[TRACEFS_DYNEVENT_SYNTH].prefix = "";
+	}
+
+}
+
+static struct dyn_events_desc *get_devent_desc(enum tracefs_dynevent_type type)
+{
+	static bool init;
+
+	if (!init) {
+		init_devent_desc();
+		init = true;
+	}
+
+	return &dynevents[type];
+}
+
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
+				devent->prefix, strlen(devent->prefix) > 0 ? ":" : "",
+				devent->system, devent->event,
+				devent->address ? devent->address : "",
+				devent->format ? devent->format : "");
+	else
+		ret = asprintf(&str, "%s%s%s %s %s\n",
+				devent->prefix, strlen(devent->prefix) > 0 ? ":" : "",
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
+	return desc->dyn_events_del(desc, devent);
+}
+
+static int get_all_type(enum tracefs_dynevent_type type, const char *system,
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
+
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
+void tracefs_dynevent_list_free(struct tracefs_dynevent **events)
+{
+	int i = 0;
+
+	if (!events)
+		return;
+
+	while (events[i])
+		tracefs_dynevent_free(events[i++]);
+
+	free(events);
+}
+
+/**
+ * tracefs_dynevent_get_all - return an array of pointers to dynamic events of given types
+ * @type_mask: Bitmask of tracefs_dynevent_type values. The TRACEFS_BIT_SET macro can be used
+ *	       to set the bits of the desired types in the mask. If mask is 0, events from all
+ *	       types will be returned.
+ * @system: Get events from that system only. If @system is NULL, events from all systems
+ *	    are returned.
+ *
+ * Returns an array of pointers to dynamic events of given types that exist in the system.
+ * The array must be freed with tracefs_dynevent_list_free(). If there are no events a NULL
+ * pointer is returned.
+ */
+struct tracefs_dynevent **
+tracefs_dynevent_get_all(unsigned long type_mask, const char *system)
+{
+	struct tracefs_dynevent **events, **tmp, **all_events = NULL;
+	int count, all = 0;
+	int i;
+
+	for (i = 0; i < TRACEFS_DYNEVENT_MAX; i++) {
+		if (type_mask && !TRACEFS_BIT_TEST(type_mask, i))
+			continue;
+		count = get_all_type(i, system, &events);
+		if (count > 0) {
+			tmp = realloc(all_events,
+				     (all + count)*sizeof(struct tracefs_dynevent *));
+			if (!tmp)
+				goto error;
+			all_events = tmp;
+			memcpy(all_events + all, events,
+			       count*sizeof(struct tracefs_dynevent *));
+			all += count;
+		}
+
+	}
+
+	/* Add a NULL pointer at the end */
+	if (all > 0) {
+		tmp = realloc(all_events,
+			     (all + 1)*sizeof(struct tracefs_dynevent *));
+		if (!tmp)
+			goto error;
+
+		all_events = tmp;
+		all_events[all] = NULL;
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
+ * @type_mask: Bitmask of tracefs_dynevent_type values. The TRACEFS_BIT_SET macro can be used
+ *	       to set the bits of the desired types in the mask. If mask is 0, events from all
+ *	       types will be destroyed.
+ * @force: Will attempt to disable all events before removing them.
+ *
+ * Will remove all dynamic events of the given types from the system. If there are any enabled
+ * events, and @force is not set, then the removal of these will fail. If @force is set, then
+ * it will attempt to disable all the events in all instances before removing them.
+ *
+ * Returns zero if all requested events are removed successfully, or -1 if some of them are not
+ * removed.
+ */
+int tracefs_dynevent_destroy_all(unsigned long type_mask, bool force)
+{
+	struct tracefs_dynevent **all;
+	int i = 0;
+	int ret = 0;
+
+	all = tracefs_dynevent_get_all(type_mask, NULL);
+	if (!all)
+		return 0;
+	while (all[i]) {
+		if (tracefs_dynevent_destroy(all[i], force))
+			ret = -1;
+		i++;
+	}
+	tracefs_dynevent_list_free(all);
+
+	return ret;
+}
+
+__hidden int dynevent_get_count(unsigned long type_mask, const char *system)
+{
+	int count, all = 0;
+	int i;
+
+	for (i = 0; i < TRACEFS_DYNEVENT_MAX; i++) {
+		if (!TRACEFS_BIT_TEST(type_mask, i))
+			continue;
+		count = get_all_type(i, system, NULL);
+		if (count > 0)
+			all += count;
+	}
+
+	return all;
+}
-- 
2.31.1


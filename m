Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B069EC77B60
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Apr 2023 04:11:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239168AbjDZELc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Apr 2023 00:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239034AbjDZELb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Apr 2023 00:11:31 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C394DE4E
        for <linux-trace-devel@vger.kernel.org>; Tue, 25 Apr 2023 21:11:29 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3f199696149so28481265e9.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 25 Apr 2023 21:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682482288; x=1685074288;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6IKmn/5HIcqgUNOg33rzqTGpxgxCRBh+q9beHG4w2KM=;
        b=JpDY+2Hx3XUOsD5p93y5U0jqWg/1R30RhzprYlXr/wfZgDdQbRhm+W27yseljsBINk
         +9c1r94veyM5wa+Mf+YglGBu7Doe9eNHHP4UHINNT0X35FahMcl4KkrfO5gZ+8LDvP0y
         wDOOqm4Q7aLUqwj6Cuxyl4iu80LLo7inVeOUGvOXaFPg6VFOwlHK3X8FZMwvekUZIRt5
         lX/pb1nNKXeMYJsAJ+ZO40QGMKEfnwluybsNfwhRJdz68jf2pO2uedun7c0hRdg7g2y5
         orORn7+x3Msh++d73R0FvM5pAl74UsCU7/yMlJLlxEDUnvTXRM109U8sWctjuy5/QvZk
         9KkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682482288; x=1685074288;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6IKmn/5HIcqgUNOg33rzqTGpxgxCRBh+q9beHG4w2KM=;
        b=ByXqs7ZbbFBvB07ZzXol59GeG/5v+R/kxAcVHjBWItkLZ8bl0/2bhp7yrStppkdgLV
         NMv7oNPmd7LAyGhal1Xwc5pbIk4R7s99IJFhcumE1hG1JCCpzBsaeGY//xu84i6B/fPz
         2SrnuO2eUTpKHC6nGNGKnyRY2OerM+p0Gh70tG7vkLP/ZM6tFbbUwE1S18M66SRGd8Qp
         ouOkXaAvbQzTZj0ipdPJWvUP482yEKDt17WvFYdnjYLuiAEMAHIbgzRi60VyBLAhmvjs
         ij6okePCq6MvnhNz/r/Hbd676m7U+2w5gNXTfV+9vTH2V5qM3zRHYPpa+adW6inlWDkS
         B20A==
X-Gm-Message-State: AAQBX9eenxu/iAJxNBbzlgqXSh2FVYd7mauPsuYxVqD8Bu8dxcKqSFkE
        uxhk7Y39x4igE5SH0N+GIEszdqQWGoE1zA==
X-Google-Smtp-Source: AKy350Yr1yk2qdFgd324FfIrbRHpzteV6qMMHOghyIZdEbFWeOUJxkxW3QAD+fpDu91ZvWxa4FM3rg==
X-Received: by 2002:a1c:c907:0:b0:3ed:3d89:1b4b with SMTP id f7-20020a1cc907000000b003ed3d891b4bmr12757057wmb.8.1682482288025;
        Tue, 25 Apr 2023 21:11:28 -0700 (PDT)
Received: from oberon.zico.biz (77-85-190-39.ip.btc-net.bg. [77.85.190.39])
        by smtp.gmail.com with ESMTPSA id m5-20020a5d6a05000000b002f01e181c4asm14648107wru.5.2023.04.25.21.11.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 21:11:27 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 1/3] libtracefs: New API to reset ftrace instance
Date:   Wed, 26 Apr 2023 07:11:22 +0300
Message-Id: <20230426041124.69544-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230426041124.69544-1-tz.stoyanov@gmail.com>
References: <20230426041124.69544-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Resetting a ftrace instance to its default state is not a trivial task.
A lot of trace files have to be modified, with different syntaxes and
in strict order. Although there is such functionality in "trace-cmd
reset" command, it will be good to have it in the tracefs library as
well.
A new API tracefs_instance_reset() is introduced, which resets given
ftrace instance to its default state. The logic and most of the helper
functions from "trace-cmd reset" command are copied in the tracefs
library.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs-local.h |   1 +
 include/tracefs.h       |   1 +
 src/tracefs-instance.c  | 207 ++++++++++++++++++++++++++++++++++++++++
 src/tracefs-utils.c     |  20 ++++
 4 files changed, 229 insertions(+)

diff --git a/include/tracefs-local.h b/include/tracefs-local.h
index 2007d26..da99a30 100644
--- a/include/tracefs-local.h
+++ b/include/tracefs-local.h
@@ -64,6 +64,7 @@ int trace_get_instance(struct tracefs_instance *instance);
 /* Can be overridden */
 void tracefs_warning(const char *fmt, ...);
 
+char *strstrip(char *str);
 int str_read_file(const char *file, char **buffer, bool warn);
 char *trace_append_file(const char *dir, const char *name);
 char *trace_find_tracing_dir(bool debugfs);
diff --git a/include/tracefs.h b/include/tracefs.h
index 3547b5a..5e9d84b 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -23,6 +23,7 @@ int tracefs_tracing_dir_is_mounted(bool mount, const char **path);
 struct tracefs_instance;
 
 void tracefs_instance_free(struct tracefs_instance *instance);
+void tracefs_instance_reset(struct tracefs_instance *instance);
 struct tracefs_instance *tracefs_instance_create(const char *name);
 struct tracefs_instance *tracefs_instance_alloc(const char *tracing_dir,
 						const char *name);
diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index 57f5c7f..b3ed983 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -1239,3 +1239,210 @@ char *tracefs_instance_get_affinity(struct tracefs_instance *instance)
 
 	return set;
 }
+
+static int clear_trigger(const char *file)
+{
+	char trigger[BUFSIZ];
+	char *save = NULL;
+	char *line;
+	char *buf;
+	int size;
+	int len;
+	int ret;
+
+	size = str_read_file(file, &buf, true);
+	if (size < 1)
+		return 0;
+
+	trigger[0] = '!';
+
+	for (line = strtok_r(buf, "\n", &save); line; line = strtok_r(NULL, "\n", &save)) {
+		if (line[0] == '#')
+			continue;
+		len = strlen(line);
+		if (len > BUFSIZ - 2)
+			len = BUFSIZ - 2;
+		strncpy(trigger + 1, line, len);
+		trigger[len + 1] = '\0';
+		/* We don't want any filters or extra on the line */
+		strtok(trigger, " ");
+		write_file(file, trigger, O_WRONLY);
+	}
+
+	free(buf);
+
+	/*
+	 * Some triggers have an order in removing them.
+	 * They will not be removed if done in the wrong order.
+	 */
+	size = str_read_file(file, &buf, true);
+	if (size < 1)
+		return 0;
+
+	ret = 0;
+	for (line = strtok(buf, "\n"); line; line = strtok(NULL, "\n")) {
+		if (line[0] == '#')
+			continue;
+		ret = 1;
+		break;
+	}
+	free(buf);
+	return ret;
+}
+
+static void disable_func_stack_trace_instance(struct tracefs_instance *instance)
+{
+	char *content;
+	char *cond;
+	int size;
+
+	content = tracefs_instance_file_read(instance, "current_tracer", &size);
+	if (!content)
+		return;
+	cond = strstrip(content);
+	if (memcmp(cond, "function", size - (cond - content)) != 0)
+		goto out;
+
+	tracefs_option_disable(instance, TRACEFS_OPTION_FUNC_STACKTRACE);
+ out:
+	free(content);
+}
+
+static void reset_cpu_mask(struct tracefs_instance *instance)
+{
+	int cpus = sysconf(_SC_NPROCESSORS_CONF);
+	int fullwords = (cpus - 1) / 32;
+	int bits = (cpus - 1) % 32 + 1;
+	int len = (fullwords + 1) * 9;
+	char buf[len + 1];
+
+	buf[0] = '\0';
+	sprintf(buf, "%x", (unsigned int)((1ULL << bits) - 1));
+	while (fullwords-- > 0)
+		strcat(buf, ",ffffffff");
+
+	tracefs_instance_file_write(instance, "tracing_cpumask", buf);
+}
+
+static void clear_func_filter(struct tracefs_instance *instance, const char *file)
+{
+	char filter[BUFSIZ];
+	char *line;
+	char *buf;
+	char *p;
+	int len;
+
+	buf = tracefs_instance_file_read(instance, file, NULL);
+	if (!buf)
+		return;
+
+	/* Now remove filters */
+	filter[0] = '!';
+
+	/*
+	 * To delete a filter, we need to write a '!filter'
+	 * to the file for each filter.
+	 */
+	for (line = strtok(buf, "\n"); line; line = strtok(NULL, "\n")) {
+		if (line[0] == '#')
+			continue;
+		len = strlen(line);
+		if (len > BUFSIZ - 2)
+			len = BUFSIZ - 2;
+
+		strncpy(filter + 1, line, len);
+		filter[len + 1] = '\0';
+		/*
+		 * To remove "unlimited" filters, we must remove
+		 * the ":unlimited" from what we write.
+		 */
+		p = strstr(filter, ":unlimited");
+		if (p) {
+			*p = '\0';
+			len = p - filter;
+		}
+		/*
+		 * The write to this file expects white space
+		 * at the end :-p
+		 */
+		filter[len] = '\n';
+		filter[len+1] = '\0';
+		tracefs_instance_file_append(instance, file, filter);
+	}
+}
+
+static void clear_func_filters(struct tracefs_instance *instance)
+{
+	int i;
+	const char * const files[] = { "set_ftrace_filter",
+				       "set_ftrace_notrace",
+				       "set_graph_function",
+				       "set_graph_notrace",
+				       "stack_trace_filter",
+				       NULL };
+
+	for (i = 0; files[i]; i++)
+		clear_func_filter(instance, files[i]);
+}
+
+/**
+ * tracefs_instance_reset - Reset a ftrace instance to its default state
+ * @instance - a ftrace instance to be reseted
+ *
+ * The main logic and the helper functions are copied from
+ * trace-cmd/tracecmd/trace-record.c, trace_reset()
+ */
+void tracefs_instance_reset(struct tracefs_instance *instance)
+{
+	int has_trigger = -1;
+	char **systems;
+	struct stat st;
+	char **events;
+	char *file;
+	int i, j;
+
+	tracefs_trace_off(instance);
+	disable_func_stack_trace_instance(instance);
+	tracefs_tracer_clear(instance);
+	tracefs_instance_file_write(instance, "events/enable", "0");
+	tracefs_instance_file_write(instance, "set_ftrace_pid", "");
+	tracefs_instance_file_clear(instance, "trace");
+
+	systems = tracefs_event_systems(NULL);
+	if (systems) {
+		for (i = 0; systems[i]; i++) {
+			events = tracefs_system_events(NULL, systems[i]);
+			if (!events)
+				continue;
+			for (j = 0; events[j]; j++) {
+				file = tracefs_event_get_file(instance, systems[i],
+							      events[j], "filter");
+				write_file(file, "0", O_WRONLY | O_TRUNC);
+				tracefs_put_tracing_file(file);
+
+				file = tracefs_event_get_file(instance, systems[i],
+							      events[j], "trigger");
+				if (has_trigger < 0) {
+					/* Check if the kernel is configured with triggers */
+					if (stat(file, &st) < 0)
+						has_trigger = 0;
+					else
+						has_trigger = 1;
+				}
+				if (has_trigger)
+					clear_trigger(file);
+				tracefs_put_tracing_file(file);
+			}
+			tracefs_list_free(events);
+		}
+		tracefs_list_free(systems);
+	}
+
+	tracefs_instance_file_write(instance, "error_log", " ");
+	tracefs_instance_file_write(instance, "trace_clock", "local");
+	tracefs_instance_file_write(instance, "set_event_pid", "");
+	reset_cpu_mask(instance);
+	clear_func_filters(instance);
+	tracefs_instance_file_write(instance, "tracing_max_latency", "0");
+	tracefs_trace_on(instance);
+}
diff --git a/src/tracefs-utils.c b/src/tracefs-utils.c
index 9acf2ad..ef90677 100644
--- a/src/tracefs-utils.c
+++ b/src/tracefs-utils.c
@@ -319,6 +319,26 @@ void tracefs_put_tracing_file(char *name)
 	free(name);
 }
 
+/* The function is copied from trace-cmd */
+__hidden char *strstrip(char *str)
+{
+	char *s;
+
+	if (!str)
+		return NULL;
+
+	s = str + strlen(str) - 1;
+	while (s >= str && isspace(*s))
+		s--;
+	s++;
+	*s = '\0';
+
+	for (s = str; *s && isspace(*s); s++)
+		;
+
+	return s;
+}
+
 __hidden int str_read_file(const char *file, char **buffer, bool warn)
 {
 	char stbuf[BUFSIZ];
-- 
2.39.2


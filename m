Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60483C76196
	for <linux-trace-devel@archiver.kernel.org>; Tue, 28 Mar 2023 15:04:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233796AbjC1PEf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 28 Mar 2023 11:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233743AbjC1PEf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 28 Mar 2023 11:04:35 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543BDDBEA
        for <linux-trace-devel@vger.kernel.org>; Tue, 28 Mar 2023 08:03:19 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id h8so50971493ede.8
        for <linux-trace-devel@vger.kernel.org>; Tue, 28 Mar 2023 08:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680015791;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q8bLivOTPs2tsjv2TR/DkvnkEdgWPkfjQLIyu9xdNlo=;
        b=FCHyzYfYoSMU5EPURZMaxif0sfS1dcfTL3bPE/a7137gzAJrSWS7uPqgECG+++p8wy
         Y8qriLWbYlTd6R7R+Q6hg70U7UcI4xXeHbE9SMqHiX42mrfshz9MeOiyYzXkCmzhy3TB
         qHp23/wi25TcZdqsTv0Rgvw1L6+37bW1HVEPVD8Wyo9OWkDU06R7hJaThvlRTpJFsD7g
         bzxgIOAY2A/X7slD5K6MarELm8ZpEk57U21xcB4SZk5+LJjKPsOadUnvrpWpB4hlWhMO
         izcwMfqMHVbRFWwPYX7DFK1K4u7XxCd5gSvp10D+hEhXEtdFPgECw3QImURUVuoPVUR4
         vacQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680015791;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q8bLivOTPs2tsjv2TR/DkvnkEdgWPkfjQLIyu9xdNlo=;
        b=tqN/kLbZwVbiUvSgtsajv9Fz0dIi+S3VoOslsKtLHKI3NcAH6InigrU9H6uzLErzHU
         oyY6HVdOd+zn8YJLcqRatFEnb2TPHHrP8RrFwaHJnDnrupplvZqczbKUjWeBuzFD5yJa
         Sz0HDvGfg43WkkPSoqCDHhTcSFFgOLNmmUd6EeymFWi5eqMPdHM/CRotomSnHOYr7YRE
         3xXXMXXeyNX1HXMW5MkPRIRFUfsHBQ7/hKPRAbGexsVbR22jQ2br2S2g2+Lx//k+RESp
         Y20KhoeyT+6GBEB7aGb98UG235RJNguutL5KCcgdqotpEaQzyKPa2O/QcrN4nQVl8BvG
         jysg==
X-Gm-Message-State: AAQBX9d3e+0P0wO1dtRQDp/n5zuQJj7Lp7CC6jW+JakYOT5sfaDB+ACK
        Ao4RseBRUf0jQlQV2i7NP3boMjTCKdk=
X-Google-Smtp-Source: AKy350Z7yU06V64dm6lRe2gmpsevdJJe5I7H3VFzAhhzpOimUGadCJE7UI421yUhFle7G0g/x4QuZg==
X-Received: by 2002:a17:906:7243:b0:932:4cbf:5bbb with SMTP id n3-20020a170906724300b009324cbf5bbbmr17108414ejk.19.1680015791495;
        Tue, 28 Mar 2023 08:03:11 -0700 (PDT)
Received: from oberon.zico.biz (77-85-190-39.ip.btc-net.bg. [77.85.190.39])
        by smtp.gmail.com with ESMTPSA id c16-20020a170906925000b009327f9a397csm14799009ejx.145.2023.03.28.08.03.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 08:03:10 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/3] libtracefs: New API to reset ftrace instance
Date:   Tue, 28 Mar 2023 18:03:06 +0300
Message-Id: <20230328150308.34783-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230328150308.34783-1-tz.stoyanov@gmail.com>
References: <20230328150308.34783-1-tz.stoyanov@gmail.com>
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
 src/tracefs-instance.c  | 196 ++++++++++++++++++++++++++++++++++++++++
 src/tracefs-utils.c     |  20 ++++
 4 files changed, 218 insertions(+)

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
index 57f5c7f..d3c6581 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -1239,3 +1239,199 @@ char *tracefs_instance_get_affinity(struct tracefs_instance *instance)
 
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
+	char **systems;
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
+				clear_trigger(file);
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


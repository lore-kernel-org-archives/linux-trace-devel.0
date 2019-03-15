Return-Path: <SRS0=0lml=RS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F654C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Mar 2019 08:38:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7016921872
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Mar 2019 08:38:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbfCOIiE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 Mar 2019 04:38:04 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40147 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727058AbfCOIiE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 Mar 2019 04:38:04 -0400
Received: by mail-wr1-f68.google.com with SMTP id t5so8630156wri.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 15 Mar 2019 01:38:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1mKApxI7kawm9QL1wqZ1c9itYK2/mW362scd4gL+P/k=;
        b=G3K98luK2R4bRZ0CrS7YrAOBkxPD5kdaNJ3NL3Id0u5/y95NpG83Mqxwo6szK79te8
         B4nB2JqmNQpkk33KnyUM1TcD+MkwVtq5PZNpKzUfNBAS5bb4bzuN2Gpczf6w8WyRgoow
         +n1qLSFGgdWTXhXVbLO//n+wmySSdRx42ZcvJtAQA2h/kYGr3q2KsT5akD1WzyegpP1I
         yV+32gCM4SziXzYosCNamgmre0hpW25o4U+yErxYAupbLMYdf+TkYqO5osuKJuXTUxdY
         zf/FFA640H61EFnHbQNu9y7nRBHJQN7X5I/mVKiZo4QJ7p4THSSsa6psLxFRgGYNEvlQ
         E9MQ==
X-Gm-Message-State: APjAAAUlKKHx0YkpEwRnuzbZq5W+VKHSyWiZAjpi18OHL90VJZJOQmnn
        JC1JISVkU/pVDXYrf1J1xMvY2LTl
X-Google-Smtp-Source: APXvYqy9DeYgB4CqBlt1YxhrRviBmDtPGQKAripKuiwBMFvNEVvAgM2Ou2MwuulEAjIyaq8qTiWQjA==
X-Received: by 2002:a5d:4608:: with SMTP id t8mr1600638wrq.186.1552639081562;
        Fri, 15 Mar 2019 01:38:01 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id o5sm979395wmh.12.2019.03.15.01.38.00
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 15 Mar 2019 01:38:00 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 5/9] trace-cmd: Refactored few functions in trace-record.c
Date:   Fri, 15 Mar 2019 10:37:50 +0200
Message-Id: <20190315083754.27532-6-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190315083754.27532-1-tstoyanov@vmware.com>
References: <20190315083754.27532-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In order to reuse the code inside the trace-cmd application, few
functions from trace-record.c are refactored:
  - make_instances() and tracecmd_remove_instances() are splited.
New ones are created: tracecmd_make_instance() and tracecmd_remove_instance(),
which are visible outside the trace-record.c
  - Following functions are made non-static: tracecmd_init_instance()
get_instance_dir(), write_instance_file(), write_tracing_on(),
tracecmd_set_clock()
  - New function is implemented: tracecmd_local_cpu_count(), an internal
API to get local_cpu_count.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tracecmd/include/trace-local.h |  9 ++++
 tracecmd/trace-record.c        | 87 +++++++++++++++++++---------------
 2 files changed, 58 insertions(+), 38 deletions(-)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index d7bdb1f..8413054 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -235,6 +235,15 @@ void update_first_instance(struct buffer_instance *instance, int topt);
 void show_instance_file(struct buffer_instance *instance, const char *name);
 
 int count_cpus(void);
+void write_tracing_on(struct buffer_instance *instance, int on);
+char *get_instance_dir(struct buffer_instance *instance);
+int write_instance_file(struct buffer_instance *instance,
+			const char *file, const char *str, const char *type);
+void tracecmd_init_instance(struct buffer_instance *instance);
+void tracecmd_make_instance(struct buffer_instance *instance);
+int tracecmd_local_cpu_count(void);
+void tracecmd_set_clock(struct buffer_instance *instance);
+void tracecmd_remove_instance(struct buffer_instance *instance);
 
 /* No longer in event-utils.h */
 void __noreturn die(const char *fmt, ...); /* Can be overriden */
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 177060d..3950242 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -184,7 +184,7 @@ static inline int no_top_instance(void)
 	return first_instance != &top_instance;
 }
 
-static void init_instance(struct buffer_instance *instance)
+void tracecmd_init_instance(struct buffer_instance *instance)
 {
 	instance->event_next = &instance->events;
 }
@@ -308,7 +308,7 @@ static void reset_save_file_cond(const char *file, int prio,
  */
 void add_instance(struct buffer_instance *instance, int cpu_count)
 {
-	init_instance(instance);
+	tracecmd_init_instance(instance);
 	instance->next = buffer_instances;
 	if (first_instance == buffer_instances)
 		first_instance = instance;
@@ -495,7 +495,7 @@ static void add_event(struct buffer_instance *instance, struct event_list *event
 static void reset_event_list(struct buffer_instance *instance)
 {
 	instance->events = NULL;
-	init_instance(instance);
+	tracecmd_init_instance(instance);
 }
 
 static char *get_temp_file(struct buffer_instance *instance, int cpu)
@@ -791,8 +791,7 @@ get_instance_file(struct buffer_instance *instance, const char *file)
 	return path;
 }
 
-static char *
-get_instance_dir(struct buffer_instance *instance)
+char *get_instance_dir(struct buffer_instance *instance)
 {
 	char *buf;
 	char *path;
@@ -1668,9 +1667,8 @@ static int write_file(const char *file, const char *str, const char *type)
 	return ret;
 }
 
-static int
-write_instance_file(struct buffer_instance *instance,
-		    const char *file, const char *str, const char *type)
+int write_instance_file(struct buffer_instance *instance,
+			const char *file, const char *str, const char *type)
 {
 	char *path;
 	int ret;
@@ -1946,7 +1944,7 @@ static int open_tracing_on(struct buffer_instance *instance)
 	return fd;
 }
 
-static void write_tracing_on(struct buffer_instance *instance, int on)
+void write_tracing_on(struct buffer_instance *instance, int on)
 {
 	int ret;
 	int fd;
@@ -2262,7 +2260,7 @@ void tracecmd_enable_events(void)
 	enable_events(first_instance);
 }
 
-static void set_clock(struct buffer_instance *instance)
+void tracecmd_set_clock(struct buffer_instance *instance)
 {
 	char *path;
 	char *content;
@@ -4316,49 +4314,57 @@ static void clear_func_filters(void)
 	}
 }
 
-static void make_instances(void)
+void tracecmd_make_instance(struct buffer_instance *instance)
 {
-	struct buffer_instance *instance;
 	struct stat st;
 	char *path;
 	int ret;
 
+	path = get_instance_dir(instance);
+	ret = stat(path, &st);
+	if (ret < 0) {
+		ret = mkdir(path, 0777);
+		if (ret < 0)
+			die("mkdir %s", path);
+	} else
+		/* Don't delete instances that already exist */
+		instance->flags |= BUFFER_FL_KEEP;
+	tracecmd_put_tracing_file(path);
+
+}
+
+static void make_instances(void)
+{
+	struct buffer_instance *instance;
+
 	for_each_instance(instance) {
 		if (is_guest(instance))
 			continue;
+		tracecmd_make_instance(instance);
+	}
+}
 
-		path = get_instance_dir(instance);
-		ret = stat(path, &st);
-		if (ret < 0) {
-			ret = mkdir(path, 0777);
-			if (ret < 0)
-				die("mkdir %s", path);
-		} else
-			/* Don't delete instances that already exist */
-			instance->flags |= BUFFER_FL_KEEP;
-		tracecmd_put_tracing_file(path);
+void tracecmd_remove_instance(struct buffer_instance *instance)
+{
+	char *path;
+
+	if (instance->tracing_on_fd > 0) {
+		close(instance->tracing_on_fd);
+		instance->tracing_on_fd = 0;
 	}
+	path = get_instance_dir(instance);
+	tracecmd_put_tracing_file(path);
 }
 
 void tracecmd_remove_instances(void)
 {
 	struct buffer_instance *instance;
-	char *path;
-	int ret;
 
 	for_each_instance(instance) {
 		/* Only delete what we created */
 		if (is_guest(instance) || (instance->flags & BUFFER_FL_KEEP))
 			continue;
-		if (instance->tracing_on_fd > 0) {
-			close(instance->tracing_on_fd);
-			instance->tracing_on_fd = 0;
-		}
-		path = get_instance_dir(instance);
-		ret = rmdir(path);
-		if (ret < 0)
-			die("rmdir %s", path);
-		tracecmd_put_tracing_file(path);
+		tracecmd_remove_instance(instance);
 	}
 }
 
@@ -4853,7 +4859,7 @@ void trace_stop(int argc, char **argv)
 	int topt = 0;
 	struct buffer_instance *instance = &top_instance;
 
-	init_instance(instance);
+	tracecmd_init_instance(instance);
 
 	for (;;) {
 		int c;
@@ -4894,7 +4900,7 @@ void trace_restart(int argc, char **argv)
 	int topt = 0;
 	struct buffer_instance *instance = &top_instance;
 
-	init_instance(instance);
+	tracecmd_init_instance(instance);
 
 	for (;;) {
 		int c;
@@ -4936,7 +4942,7 @@ void trace_reset(int argc, char **argv)
 	int topt = 0;
 	struct buffer_instance *instance = &top_instance;
 
-	init_instance(instance);
+	tracecmd_init_instance(instance);
 
 	/* if last arg is -a, then -b and -d apply to all instances */
 	int last_specified_all = 0;
@@ -5014,11 +5020,16 @@ static void init_common_record_context(struct common_record_context *ctx,
 	memset(ctx, 0, sizeof(*ctx));
 	ctx->instance = &top_instance;
 	ctx->curr_cmd = curr_cmd;
-	init_instance(ctx->instance);
+	tracecmd_init_instance(ctx->instance);
 	local_cpu_count = count_cpus();
 	ctx->instance->cpu_count = local_cpu_count;
 }
 
+int tracecmd_local_cpu_count(void)
+{
+	return local_cpu_count;
+}
+
 #define IS_EXTRACT(ctx) ((ctx)->curr_cmd == CMD_extract)
 #define IS_START(ctx) ((ctx)->curr_cmd == CMD_start)
 #define IS_STREAM(ctx) ((ctx)->curr_cmd == CMD_stream)
@@ -5589,7 +5600,7 @@ static void record_trace(int argc, char **argv,
 	tracecmd_disable_all_tracing(1);
 
 	for_all_instances(instance)
-		set_clock(instance);
+		tracecmd_set_clock(instance);
 
 	/* Record records the date first */
 	if (ctx->date &&
-- 
2.20.1


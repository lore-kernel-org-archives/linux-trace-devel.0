Return-Path: <SRS0=s7zG=UR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E917C31E5D
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:45:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF1AF20B1F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:45:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IxzHV4yf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729167AbfFROpK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 10:45:10 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54959 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729102AbfFROpK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 10:45:10 -0400
Received: by mail-wm1-f66.google.com with SMTP id g135so3601092wme.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 18 Jun 2019 07:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BgZe1OxjMcddE7ee3UJkKutmHEc9o+n89dWadY2uo2o=;
        b=IxzHV4yf5uvftbDTathbejoGZEHKM+ZrzfE/ad4oS4kKB6kEowHJKLWOO/m9gsg/b8
         7t2mVR1yC5cETaSD5DYPs+4GLgi70je/cn79wNDWv5o3plFZKxMTI0kiYQxCEpQeU/QO
         O+yKV+VRO3sEIseD4hPXacS5IReUZE6rZH9rUGV18wTxyd+H2bGHag7Fs0fUT4nXi4NO
         GR2Xp0ebrbM3qsq2UzavSLy72WzPn1ntvdSB8J/FTy4zhB4kYa4rKvTaSp3fLhPJi7ZD
         3jvTJb1oFteSJLp/Jm9GcFs0SdUejH+DXIwebisrSeEip7BUCSXitMKwiX/kxCtV8Pff
         610g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BgZe1OxjMcddE7ee3UJkKutmHEc9o+n89dWadY2uo2o=;
        b=ipHPvJ+yBl9ibrEMZArNAD8vv1heE0lkOp9CL7zgzSgCHiTzLQbS6fvwHZXS0h3sAJ
         uiZ4d2dZHLF29DZGiWsfTfLnhMxxtpXSw62786hO1dqzrDQez4vTg/R3D+HOa7SZt5XA
         SfkKTr5pTfDgR4xUFinvnNmeoR1hBMQa+z+XwRP+l+RaS7uuV1jw1L/TEfzflll9164p
         CWyuQFW2HDuKqZb7JGPQGvZifbKBonDn65pjvwuVjC7AykWvVwMNsqJRNF9OAHKNT9cB
         g1ZHa4aRKip3Tx1zJNiv2MEiEjTxEbO+sh18YoGitK48xQBXwhF/whFJw8YUJHU4Ug0U
         WaeA==
X-Gm-Message-State: APjAAAUFio99Si9gTYvnyQUGh2jLaM3XSCtgeuJi42ZzuQ/q1TxlKZWn
        TNLOPqu7cngdUNmX1qpC7SRUta4=
X-Google-Smtp-Source: APXvYqwTqUq74AaH8zEwAuDLKq7T/NBANpzdoxAI52b5IbZLmOapG4fw+GS/U5gGMa0XmHc05hllRw==
X-Received: by 2002:a1c:f116:: with SMTP id p22mr3967490wmh.70.1560869107285;
        Tue, 18 Jun 2019 07:45:07 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id r3sm17686071wrr.61.2019.06.18.07.45.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 07:45:06 -0700 (PDT)
From:   "Slavomir Kaslev (VMware)" <slavomir.kaslev@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v12 05/13] trace-cmd: Add buffer instance flags for tracing in guest and agent context
Date:   Tue, 18 Jun 2019 17:44:47 +0300
Message-Id: <20190618144455.3954-6-slavomir.kaslev@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190618144455.3954-1-slavomir.kaslev@gmail.com>
References: <20190618144455.3954-1-slavomir.kaslev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Slavomir Kaslev <kaslevs@vmware.com>

Add BUFFER_FL_GUEST and BUFFER_FL_AGENT flags to differentiate when
trace-record.c is being called to trace guest or the VM tracing agent.

Also disable functions talking to the local tracefs when called in recording
guest instances context.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 tracecmd/include/trace-local.h |  5 +++
 tracecmd/trace-record.c        | 58 ++++++++++++++++++++++++++++++++--
 2 files changed, 61 insertions(+), 2 deletions(-)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 1cad3cc..302f749 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -149,6 +149,8 @@ char *strstrip(char *str);
 enum buffer_instance_flags {
 	BUFFER_FL_KEEP		= 1 << 0,
 	BUFFER_FL_PROFILE	= 1 << 1,
+	BUFFER_FL_GUEST		= 1 << 2,
+	BUFFER_FL_AGENT		= 1 << 3,
 };
 
 struct func_list {
@@ -200,6 +202,9 @@ extern struct buffer_instance *first_instance;
 #define for_all_instances(i) for (i = first_instance; i; \
 				  i = i == &top_instance ? buffer_instances : (i)->next)
 
+#define is_agent(instance)	((instance)->flags & BUFFER_FL_AGENT)
+#define is_guest(instance)	((instance)->flags & BUFFER_FL_GUEST)
+
 struct buffer_instance *create_instance(const char *name);
 void add_instance(struct buffer_instance *instance, int cpu_count);
 char *get_instance_file(struct buffer_instance *instance, const char *file);
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 5dc6f17..4198db7 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -822,6 +822,9 @@ static void __clear_trace(struct buffer_instance *instance)
 	FILE *fp;
 	char *path;
 
+	if (is_guest(instance))
+		return;
+
 	/* reset the trace */
 	path = get_instance_file(instance, "trace");
 	fp = fopen(path, "w");
@@ -1339,6 +1342,9 @@ set_plugin_instance(struct buffer_instance *instance, const char *name)
 	char *path;
 	char zero = '0';
 
+	if (is_guest(instance))
+		return;
+
 	path = get_instance_file(instance, "current_tracer");
 	fp = fopen(path, "w");
 	if (!fp) {
@@ -1435,6 +1441,9 @@ static void disable_func_stack_trace_instance(struct buffer_instance *instance)
 	int size;
 	int ret;
 
+	if (is_guest(instance))
+		return;
+
 	path = get_instance_file(instance, "current_tracer");
 	ret = stat(path, &st);
 	tracecmd_put_tracing_file(path);
@@ -1628,6 +1637,9 @@ reset_events_instance(struct buffer_instance *instance)
 	int i;
 	int ret;
 
+	if (is_guest(instance))
+		return;
+
 	if (use_old_event_method()) {
 		/* old way only had top instance */
 		if (!is_top_instance(instance))
@@ -1940,6 +1952,9 @@ static void write_tracing_on(struct buffer_instance *instance, int on)
 	int ret;
 	int fd;
 
+	if (is_guest(instance))
+		return;
+
 	fd = open_tracing_on(instance);
 	if (fd < 0)
 		return;
@@ -1959,6 +1974,9 @@ static int read_tracing_on(struct buffer_instance *instance)
 	char buf[10];
 	int ret;
 
+	if (is_guest(instance))
+		return -1;
+
 	fd = open_tracing_on(instance);
 	if (fd < 0)
 		return fd;
@@ -2105,6 +2123,9 @@ static void update_pid_filters(struct buffer_instance *instance)
 	int ret;
 	int fd;
 
+	if (is_guest(instance))
+		return;
+
 	fd = open_instance_fd(instance, "set_event_pid",
 			      O_WRONLY | O_CLOEXEC | O_TRUNC);
 	if (fd < 0)
@@ -2200,6 +2221,9 @@ static void set_mask(struct buffer_instance *instance)
 	int fd;
 	int ret;
 
+	if (is_guest(instance))
+		return;
+
 	if (!instance->cpumask)
 		return;
 
@@ -2230,6 +2254,9 @@ static void enable_events(struct buffer_instance *instance)
 {
 	struct event_list *event;
 
+	if (is_guest(instance))
+		return;
+
 	for (event = instance->events; event; event = event->next) {
 		if (!event->neg)
 			update_event(event, event->filter, 0, '1');
@@ -2253,6 +2280,9 @@ static void set_clock(struct buffer_instance *instance)
 	char *content;
 	char *str;
 
+	if (is_guest(instance))
+		return;
+
 	if (!instance->clock)
 		return;
 
@@ -2282,6 +2312,9 @@ static void set_max_graph_depth(struct buffer_instance *instance, char *max_grap
 	char *path;
 	int ret;
 
+	if (is_guest(instance))
+		return;
+
 	path = get_instance_file(instance, "max_graph_depth");
 	reset_save_file(path, RESET_DEFAULT_PRIO);
 	tracecmd_put_tracing_file(path);
@@ -2507,6 +2540,9 @@ static void expand_event_instance(struct buffer_instance *instance)
 	struct event_list *compressed_list = instance->events;
 	struct event_list *event;
 
+	if (is_guest(instance))
+		return;
+
 	reset_event_list(instance);
 
 	while (compressed_list) {
@@ -3394,6 +3430,9 @@ static void set_funcs(struct buffer_instance *instance)
 	int set_notrace = 0;
 	int ret;
 
+	if (is_guest(instance))
+		return;
+
 	ret = write_func_file(instance, "set_ftrace_filter", &instance->filter_funcs);
 	if (ret < 0)
 		die("set_ftrace_filter does not exist. Can not filter functions");
@@ -3690,6 +3729,9 @@ static void set_buffer_size_instance(struct buffer_instance *instance)
 	int ret;
 	int fd;
 
+	if (is_guest(instance))
+		return;
+
 	if (!buffer_size)
 		return;
 
@@ -3900,6 +3942,9 @@ static void make_instances(void)
 	int ret;
 
 	for_each_instance(instance) {
+		if (is_guest(instance))
+			continue;
+
 		path = get_instance_dir(instance);
 		ret = stat(path, &st);
 		if (ret < 0) {
@@ -3921,7 +3966,7 @@ void tracecmd_remove_instances(void)
 
 	for_each_instance(instance) {
 		/* Only delete what we created */
-		if (instance->flags & BUFFER_FL_KEEP)
+		if (is_guest(instance) || (instance->flags & BUFFER_FL_KEEP))
 			continue;
 		if (instance->tracing_on_fd > 0) {
 			close(instance->tracing_on_fd);
@@ -4003,7 +4048,7 @@ static void check_function_plugin(void)
 
 static int __check_doing_something(struct buffer_instance *instance)
 {
-	return (instance->flags & BUFFER_FL_PROFILE) ||
+	return is_guest(instance) || (instance->flags & BUFFER_FL_PROFILE) ||
 		instance->plugin || instance->events;
 }
 
@@ -4025,6 +4070,9 @@ update_plugin_instance(struct buffer_instance *instance,
 {
 	const char *plugin = instance->plugin;
 
+	if (is_guest(instance))
+		return;
+
 	if (!plugin)
 		return;
 
@@ -4124,6 +4172,9 @@ static void record_stats(void)
 	int cpu;
 
 	for_all_instances(instance) {
+		if (is_guest(instance))
+			continue;
+
 		s_save = instance->s_save;
 		s_print = instance->s_print;
 		for (cpu = 0; cpu < instance->cpu_count; cpu++) {
@@ -4150,6 +4201,9 @@ static void destroy_stats(void)
 	int cpu;
 
 	for_all_instances(instance) {
+		if (is_guest(instance))
+			continue;
+
 		for (cpu = 0; cpu < instance->cpu_count; cpu++) {
 			trace_seq_destroy(&instance->s_save[cpu]);
 			trace_seq_destroy(&instance->s_print[cpu]);
-- 
2.20.1


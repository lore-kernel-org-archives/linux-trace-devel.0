Return-Path: <SRS0=t+9I=SE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37D1CC10F13
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Apr 2019 13:42:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 092232147C
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Apr 2019 13:42:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731874AbfDBNmu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Apr 2019 09:42:50 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39990 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731863AbfDBNmt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Apr 2019 09:42:49 -0400
Received: by mail-wr1-f67.google.com with SMTP id h4so16700654wre.7
        for <linux-trace-devel@vger.kernel.org>; Tue, 02 Apr 2019 06:42:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RAwv8eMlrDGrOUGRfiNCeHTq3nq7jbl5+RyQvNL086w=;
        b=Vpyynv63p/Sc/lTuk4KFe25WbjnMqnMWtTpJbkXOhjgPqQfRziPVteFrR3MbB5Kp29
         znkljab2/wqgXmUDHYw12hxz+FG6dLsJm2TQjYfu/t07J26ipPVUtsW9S8jr/GHrwCDQ
         3Cd8EkTvUy7FXQgkRMV7RT/TQLiG5qcYLnL/tnILg6dlDqP6E/g4amXmIkdfVh7Uht4O
         9ChuwOpoNJ1g6sfQxdrRuFblcElZJ7w3XceidnXjjUVIwyA9B7VPiM3tmPpahzt5qPTJ
         rBLWNpSxx86hOcyTQdezPon3UZWQszU4fzgkT3I81s9YEpP1sTszCJEHE3ItH6FrejoI
         dJgA==
X-Gm-Message-State: APjAAAXPmwVhE0/CC7nzx9uK7MVAAFRjy8ijVoQueXICd26aGCsiR64h
        qUUPAf1AubX+JzM4dkYpCg==
X-Google-Smtp-Source: APXvYqwPay3ZtzcahQLEgJAuJcR988pjVTmsZpBQXyo9igm+8nvUQk7rAqt3ATkP+MkwdBQULzOjVQ==
X-Received: by 2002:a5d:6a4f:: with SMTP id t15mr45374484wrw.156.1554212567742;
        Tue, 02 Apr 2019 06:42:47 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id h84sm19207083wmf.15.2019.04.02.06.42.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Apr 2019 06:42:47 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: [RFC PATCH v8 05/11] trace-cmd: Add buffer instance flags for tracing in guest and agent context
Date:   Tue,  2 Apr 2019 16:42:16 +0300
Message-Id: <20190402134230.30988-11-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190402134230.30988-1-kaslevs@vmware.com>
References: <20190402134230.30988-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add BUFFER_FL_GUEST and BUFFER_FL_AGENT flags to differentiate when
trace-record.c is being called to trace guest or the VM tracing agent.

Also disable functions talking to the local tracefs when called in recording
guest instances context.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 tracecmd/include/trace-local.h |  5 ++++
 tracecmd/trace-record.c        | 55 ++++++++++++++++++++++++++++++++--
 2 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index a1a06e9..f43c9d8 100644
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
@@ -198,6 +200,9 @@ extern struct buffer_instance *first_instance;
 #define for_all_instances(i) for (i = first_instance; i; \
 				  i = i == &top_instance ? buffer_instances : (i)->next)
 
+#define is_agent(instance)	((instance)->flags & BUFFER_FL_AGENT)
+#define is_guest(instance)	((instance)->flags & BUFFER_FL_GUEST)
+
 struct buffer_instance *create_instance(const char *name);
 void add_instance(struct buffer_instance *instance, int cpu_count);
 char *get_instance_file(struct buffer_instance *instance, const char *file);
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 76ca92d..97df7f9 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -820,6 +820,9 @@ static void __clear_trace(struct buffer_instance *instance)
 	FILE *fp;
 	char *path;
 
+	if (is_guest(instance))
+		return;
+
 	/* reset the trace */
 	path = get_instance_file(instance, "trace");
 	fp = fopen(path, "w");
@@ -1289,6 +1292,9 @@ set_plugin_instance(struct buffer_instance *instance, const char *name)
 	char *path;
 	char zero = '0';
 
+	if (is_guest(instance))
+		return;
+
 	path = get_instance_file(instance, "current_tracer");
 	fp = fopen(path, "w");
 	if (!fp) {
@@ -1385,6 +1391,9 @@ static void disable_func_stack_trace_instance(struct buffer_instance *instance)
 	int size;
 	int ret;
 
+	if (is_guest(instance))
+		return;
+
 	path = get_instance_file(instance, "current_tracer");
 	ret = stat(path, &st);
 	tracecmd_put_tracing_file(path);
@@ -1578,6 +1587,9 @@ reset_events_instance(struct buffer_instance *instance)
 	int i;
 	int ret;
 
+	if (is_guest(instance))
+		return;
+
 	if (use_old_event_method()) {
 		/* old way only had top instance */
 		if (!is_top_instance(instance))
@@ -1890,6 +1902,9 @@ static void write_tracing_on(struct buffer_instance *instance, int on)
 	int ret;
 	int fd;
 
+	if (is_guest(instance))
+		return;
+
 	fd = open_tracing_on(instance);
 	if (fd < 0)
 		return;
@@ -1909,6 +1924,9 @@ static int read_tracing_on(struct buffer_instance *instance)
 	char buf[10];
 	int ret;
 
+	if (is_guest(instance))
+		return -1;
+
 	fd = open_tracing_on(instance);
 	if (fd < 0)
 		return fd;
@@ -2150,6 +2168,9 @@ static void set_mask(struct buffer_instance *instance)
 	int fd;
 	int ret;
 
+	if (is_guest(instance))
+		return;
+
 	if (!instance->cpumask)
 		return;
 
@@ -2180,6 +2201,9 @@ static void enable_events(struct buffer_instance *instance)
 {
 	struct event_list *event;
 
+	if (is_guest(instance))
+		return;
+
 	for (event = instance->events; event; event = event->next) {
 		if (!event->neg)
 			update_event(event, event->filter, 0, '1');
@@ -2203,6 +2227,9 @@ static void set_clock(struct buffer_instance *instance)
 	char *content;
 	char *str;
 
+	if (is_guest(instance))
+		return;
+
 	if (!instance->clock)
 		return;
 
@@ -2232,6 +2259,9 @@ static void set_max_graph_depth(struct buffer_instance *instance, char *max_grap
 	char *path;
 	int ret;
 
+	if (is_guest(instance))
+		return;
+
 	path = get_instance_file(instance, "max_graph_depth");
 	reset_save_file(path, RESET_DEFAULT_PRIO);
 	tracecmd_put_tracing_file(path);
@@ -2457,6 +2487,9 @@ static void expand_event_instance(struct buffer_instance *instance)
 	struct event_list *compressed_list = instance->events;
 	struct event_list *event;
 
+	if (is_guest(instance))
+		return;
+
 	reset_event_list(instance);
 
 	while (compressed_list) {
@@ -3331,6 +3364,9 @@ static void set_funcs(struct buffer_instance *instance)
 	int set_notrace = 0;
 	int ret;
 
+	if (is_guest(instance))
+		return;
+
 	ret = write_func_file(instance, "set_ftrace_filter", &instance->filter_funcs);
 	if (ret < 0)
 		die("set_ftrace_filter does not exist. Can not filter functions");
@@ -3627,6 +3663,9 @@ static void set_buffer_size_instance(struct buffer_instance *instance)
 	int ret;
 	int fd;
 
+	if (is_guest(instance))
+		return;
+
 	if (!buffer_size)
 		return;
 
@@ -3837,6 +3876,9 @@ static void make_instances(void)
 	int ret;
 
 	for_each_instance(instance) {
+		if (is_guest(instance))
+			continue;
+
 		path = get_instance_dir(instance);
 		ret = stat(path, &st);
 		if (ret < 0) {
@@ -3858,7 +3900,7 @@ void tracecmd_remove_instances(void)
 
 	for_each_instance(instance) {
 		/* Only delete what we created */
-		if (instance->flags & BUFFER_FL_KEEP)
+		if (is_guest(instance) || (instance->flags & BUFFER_FL_KEEP))
 			continue;
 		if (instance->tracing_on_fd > 0) {
 			close(instance->tracing_on_fd);
@@ -3940,7 +3982,7 @@ static void check_function_plugin(void)
 
 static int __check_doing_something(struct buffer_instance *instance)
 {
-	return (instance->flags & BUFFER_FL_PROFILE) ||
+	return is_guest(instance) || (instance->flags & BUFFER_FL_PROFILE) ||
 		instance->plugin || instance->events;
 }
 
@@ -3962,6 +4004,9 @@ update_plugin_instance(struct buffer_instance *instance,
 {
 	const char *plugin = instance->plugin;
 
+	if (is_guest(instance))
+		return;
+
 	if (!plugin)
 		return;
 
@@ -4061,6 +4106,9 @@ static void record_stats(void)
 	int cpu;
 
 	for_all_instances(instance) {
+		if (is_guest(instance))
+			continue;
+
 		s_save = instance->s_save;
 		s_print = instance->s_print;
 		for (cpu = 0; cpu < instance->cpu_count; cpu++) {
@@ -4087,6 +4135,9 @@ static void destroy_stats(void)
 	int cpu;
 
 	for_all_instances(instance) {
+		if (is_guest(instance))
+			continue;
+
 		for (cpu = 0; cpu < instance->cpu_count; cpu++) {
 			trace_seq_destroy(&instance->s_save[cpu]);
 			trace_seq_destroy(&instance->s_print[cpu]);
-- 
2.19.1


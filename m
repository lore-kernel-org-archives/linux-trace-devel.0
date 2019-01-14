Return-Path: <SRS0=K4HJ=PW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13813C43387
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jan 2019 15:28:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8E5520657
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jan 2019 15:28:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbfANP2Q (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Jan 2019 10:28:16 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39391 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbfANP2Q (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Jan 2019 10:28:16 -0500
Received: by mail-wr1-f68.google.com with SMTP id t27so23331527wra.6
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jan 2019 07:28:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4xlJLWnVkFiQUgqDxbUOWPJQ1o558CWybQYnhioPDxo=;
        b=NmJhabVq2RnyeXRdadz4qeFvAm0HpxRGPiSB99hZm3dCAxMuf/wCdoPsLkU02ul8k9
         o0zfw6hE3eiJypBwHa8bTmJRLoln6BSoz96IdAy0Q4kaDN4eozVFiM+7FNycrmyEefQd
         WzLc3Mo/500QzMtwND0o0RSwY5xoZQT/GB0kH6NBKEOFy9WXYhnYzdr5srHvq4wMm9C6
         lXC25qZZV6AoSen/lOGRQKZSB/uNnqf5O4Hj1vY6YYnCvGL1JZDvFFiUgzOAAIGkBnOj
         0hLQo2ybCHUlGOqwMa8h/7KHRntZCj0uABPFu3Jt4vSrRMs7qBzSwoO4xN2laqbaC0wg
         2EgQ==
X-Gm-Message-State: AJcUukcBkMIgNWHRGtfrX4QpyHPFCOpgToyupevak9pNsXP93DZrGjEN
        zenYhKQ3jYs5Def2fkYakghr3owWP1Cr
X-Google-Smtp-Source: ALg8bN7b4abZf2lz9FpG1Ig87rYsUlh+UtBMFdSoc5qoEEONty8G4fIGHQpJu1Wh4tsxze4udzYSWA==
X-Received: by 2002:adf:d4c9:: with SMTP id w9mr12744871wrk.119.1547479693474;
        Mon, 14 Jan 2019 07:28:13 -0800 (PST)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id a132sm34784167wmh.5.2019.01.14.07.28.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Jan 2019 07:28:12 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, ykaradzhov@vmware.com, tstoyanov@vmware.com
Subject: [PATCH v3 5/6] trace-cmd: Add buffer instance flags for tracing in guest and agent context
Date:   Mon, 14 Jan 2019 17:27:59 +0200
Message-Id: <20190114152800.31060-6-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190114152800.31060-1-kaslevs@vmware.com>
References: <20190114152800.31060-1-kaslevs@vmware.com>
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
 tracecmd/include/trace-local.h |  2 ++
 tracecmd/trace-record.c        | 55 ++++++++++++++++++++++++++++++++--
 2 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index a1a06e9..f19c8bb 100644
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
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index a8c3464..012371c 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -781,6 +781,9 @@ static void __clear_trace(struct buffer_instance *instance)
 	FILE *fp;
 	char *path;
 
+	if (instance->flags & BUFFER_FL_GUEST)
+		return;
+
 	/* reset the trace */
 	path = get_instance_file(instance, "trace");
 	fp = fopen(path, "w");
@@ -1264,6 +1267,9 @@ set_plugin_instance(struct buffer_instance *instance, const char *name)
 	char *path;
 	char zero = '0';
 
+	if (instance->flags & BUFFER_FL_GUEST)
+		return;
+
 	path = get_instance_file(instance, "current_tracer");
 	fp = fopen(path, "w");
 	if (!fp) {
@@ -1360,6 +1366,9 @@ static void disable_func_stack_trace_instance(struct buffer_instance *instance)
 	int size;
 	int ret;
 
+	if (instance->flags & BUFFER_FL_GUEST)
+		return;
+
 	path = get_instance_file(instance, "current_tracer");
 	ret = stat(path, &st);
 	tracecmd_put_tracing_file(path);
@@ -1553,6 +1562,9 @@ reset_events_instance(struct buffer_instance *instance)
 	int i;
 	int ret;
 
+	if (instance->flags & BUFFER_FL_GUEST)
+		return;
+
 	if (use_old_event_method()) {
 		/* old way only had top instance */
 		if (!is_top_instance(instance))
@@ -1904,6 +1916,9 @@ static void write_tracing_on(struct buffer_instance *instance, int on)
 	int ret;
 	int fd;
 
+	if (instance->flags & BUFFER_FL_GUEST)
+		return;
+
 	fd = open_tracing_on(instance);
 	if (fd < 0)
 		return;
@@ -1923,6 +1938,9 @@ static int read_tracing_on(struct buffer_instance *instance)
 	char buf[10];
 	int ret;
 
+	if (instance->flags & BUFFER_FL_GUEST)
+		return -1;
+
 	fd = open_tracing_on(instance);
 	if (fd < 0)
 		return fd;
@@ -2156,6 +2174,9 @@ static void set_mask(struct buffer_instance *instance)
 	int fd;
 	int ret;
 
+	if (instance->flags & BUFFER_FL_GUEST)
+		return;
+
 	if (!instance->cpumask)
 		return;
 
@@ -2186,6 +2207,9 @@ static void enable_events(struct buffer_instance *instance)
 {
 	struct event_list *event;
 
+	if (instance->flags & BUFFER_FL_GUEST)
+		return;
+
 	for (event = instance->events; event; event = event->next) {
 		if (!event->neg)
 			update_event(event, event->filter, 0, '1');
@@ -2209,6 +2233,9 @@ static void set_clock(struct buffer_instance *instance)
 	char *content;
 	char *str;
 
+	if (instance->flags & BUFFER_FL_GUEST)
+		return;
+
 	if (!instance->clock)
 		return;
 
@@ -2238,6 +2265,9 @@ static void set_max_graph_depth(struct buffer_instance *instance, char *max_grap
 	char *path;
 	int ret;
 
+	if (instance->flags & BUFFER_FL_GUEST)
+		return;
+
 	path = get_instance_file(instance, "max_graph_depth");
 	reset_save_file(path, RESET_DEFAULT_PRIO);
 	tracecmd_put_tracing_file(path);
@@ -2463,6 +2493,9 @@ static void expand_event_instance(struct buffer_instance *instance)
 	struct event_list *compressed_list = instance->events;
 	struct event_list *event;
 
+	if (instance->flags & BUFFER_FL_GUEST)
+		return;
+
 	reset_event_list(instance);
 
 	while (compressed_list) {
@@ -3336,6 +3369,9 @@ static void set_funcs(struct buffer_instance *instance)
 	int set_notrace = 0;
 	int ret;
 
+	if (instance->flags & BUFFER_FL_GUEST)
+		return;
+
 	ret = write_func_file(instance, "set_ftrace_filter", &instance->filter_funcs);
 	if (ret < 0)
 		die("set_ftrace_filter does not exist. Can not filter functions");
@@ -3632,6 +3668,9 @@ static void set_buffer_size_instance(struct buffer_instance *instance)
 	int ret;
 	int fd;
 
+	if (instance->flags & BUFFER_FL_GUEST)
+		return;
+
 	if (!buffer_size)
 		return;
 
@@ -3829,6 +3868,9 @@ static void make_instances(void)
 	int ret;
 
 	for_each_instance(instance) {
+		if (instance->flags & BUFFER_FL_GUEST)
+			continue;
+
 		path = get_instance_dir(instance);
 		ret = stat(path, &st);
 		if (ret < 0) {
@@ -3850,7 +3892,7 @@ void tracecmd_remove_instances(void)
 
 	for_each_instance(instance) {
 		/* Only delete what we created */
-		if (instance->flags & BUFFER_FL_KEEP)
+		if (instance->flags & (BUFFER_FL_KEEP | BUFFER_FL_GUEST))
 			continue;
 		if (instance->tracing_on_fd > 0) {
 			close(instance->tracing_on_fd);
@@ -3932,7 +3974,7 @@ static void check_function_plugin(void)
 
 static int __check_doing_something(struct buffer_instance *instance)
 {
-	return (instance->flags & BUFFER_FL_PROFILE) ||
+	return (instance->flags & (BUFFER_FL_PROFILE | BUFFER_FL_GUEST)) ||
 		instance->plugin || instance->events;
 }
 
@@ -3954,6 +3996,9 @@ update_plugin_instance(struct buffer_instance *instance,
 {
 	const char *plugin = instance->plugin;
 
+	if (instance->flags & BUFFER_FL_GUEST)
+		return;
+
 	if (!plugin)
 		return;
 
@@ -4053,6 +4098,9 @@ static void record_stats(void)
 	int cpu;
 
 	for_all_instances(instance) {
+		if (instance->flags & BUFFER_FL_GUEST)
+			continue;
+
 		s_save = instance->s_save;
 		s_print = instance->s_print;
 		for (cpu = 0; cpu < instance->cpu_count; cpu++) {
@@ -4079,6 +4127,9 @@ static void destroy_stats(void)
 	int cpu;
 
 	for_all_instances(instance) {
+		if (instance->flags & BUFFER_FL_GUEST)
+			continue;
+
 		for (cpu = 0; cpu < instance->cpu_count; cpu++) {
 			trace_seq_destroy(&instance->s_save[cpu]);
 			trace_seq_destroy(&instance->s_print[cpu]);
-- 
2.19.1


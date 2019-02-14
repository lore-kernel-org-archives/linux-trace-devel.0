Return-Path: <SRS0=y1VY=QV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5448EC43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Feb 2019 14:13:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25170222B6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Feb 2019 14:13:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404711AbfBNON5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Feb 2019 09:13:57 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35301 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404695AbfBNON4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Feb 2019 09:13:56 -0500
Received: by mail-wr1-f68.google.com with SMTP id t18so6676335wrx.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Feb 2019 06:13:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y+fPL/gZQ4nsGqUOMq6iCbIlAtw4iIqDA5HDbEznW4o=;
        b=leGRTnRAh/dwUyl8y76Z2ij+9AMUqjzPfoBm53NyJAJr2q4S0kvTBhyrgmL/1+TRwC
         NQOmP0pJVKkDUfGUDQwIwys0tZ6ykORYUIqqNNWvhJhj3I/8KKaF82t3JqM8N9C0lptm
         IlsXxJ1D7JkQWT7XIBajH4SGaZjJm6T5UATdB35cQa37+WYvih2xfFc3lcqJnK8fVBQD
         pRzXY/18cbITzl+CKhU9g3mk8K0nNGqlcHJI3CNLUonc76q8WAKiRtoxsTvmbu6EhugO
         vVLWhhGQMgutAom7+FHL2SGFoMpyeHebbUw/qbLQ7v4JcKOzKqKBy0WAAAMhnQKB8SbW
         em7A==
X-Gm-Message-State: AHQUAuavtZJs/KSGm/xhg2S2QBlUZcCKDv+3BTqvaXDZIQb42az/qQRh
        TKXoT+KQXIsPTZ/QYhF+dA==
X-Google-Smtp-Source: AHgI3IYUesy51KJqycvXiPYJ3Q5pEfpq7Fr7yEOelX6rvkEphLzbWMdzKptD3DlrsC++N93XyUUZlQ==
X-Received: by 2002:a5d:528d:: with SMTP id c13mr3122863wrv.153.1550153634227;
        Thu, 14 Feb 2019 06:13:54 -0800 (PST)
Received: from localhost.localdomain ([213.145.108.55])
        by smtp.gmail.com with ESMTPSA id m4sm1844840wml.2.2019.02.14.06.13.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 06:13:53 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: [RFC PATCH v6 04/11] trace-cmd: Add buffer instance flags for tracing in guest and agent context
Date:   Thu, 14 Feb 2019 16:13:28 +0200
Message-Id: <20190214141335.28144-5-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190214141335.28144-1-kaslevs@vmware.com>
References: <20190214141335.28144-1-kaslevs@vmware.com>
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
index 8beefab..107d3d1 100644
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


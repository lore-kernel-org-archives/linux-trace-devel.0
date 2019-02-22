Return-Path: <SRS0=rw6q=Q5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A6AFC10F00
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Feb 2019 18:05:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B2D62075C
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Feb 2019 18:05:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbfBVSF4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Feb 2019 13:05:56 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34934 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727046AbfBVSF4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Feb 2019 13:05:56 -0500
Received: by mail-wr1-f68.google.com with SMTP id t18so3347979wrx.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 22 Feb 2019 10:05:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bNhbI8A5zOJsUo1DBRgcSYQnXoPahguhhLm9/ue9CDA=;
        b=elaHRfnxE7xU25nwSwoZoWI0SQkaJG8WWf5b3aAnAcLtpXXRP1gk4MOplSn+2r8Hcs
         ODgD/hOJOdujaK9Bm9NquRzHEjrxl6bo5jwHPArFxyFXORlBPLgQuL7NS6/cwW1BHJbg
         KngaVeahX09mk8d+fspqbo/8w1J9wonNb00F6MdNnrp9JjvM1S1AmvZF1Tg6jyjuYcFe
         ZDBtZ24hnfrTO2NO64hPK2YvCBU9suXfcUeQvOBHS6mXDsPRyxyJ6u+je84Lf6Uzo2FV
         EEfF6bk44atp1ucK4mO9dLtIax6N+fH7cTT347FyhAeUTtI15mKobIm5XbOauP94VnQn
         KOrw==
X-Gm-Message-State: AHQUAuaq6ekjzsB94qlsfE8HFBeT5e+n5U6TE/Wn7EpdpIdmvfM+7IA4
        z2oxTRWUQZosX99cwSHjOhMkY0g=
X-Google-Smtp-Source: AHgI3IaxUZU6TKp39kkmva24Z+KcTw7xtHs5vqYmiGNv4+vFlWS2bTSFfHoK6JFg/UUH2IUG6wM6eg==
X-Received: by 2002:adf:fc12:: with SMTP id i18mr3814779wrr.201.1550858753493;
        Fri, 22 Feb 2019 10:05:53 -0800 (PST)
Received: from localhost.localdomain ([146.247.46.6])
        by smtp.gmail.com with ESMTPSA id c18sm1320678wre.32.2019.02.22.10.05.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Feb 2019 10:05:52 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, slavomir.kaslev@gmail.com
Subject: [RFC PATCH v8 06/13] trace-cmd: Add buffer instance flags for tracing in guest and agent context
Date:   Fri, 22 Feb 2019 20:05:32 +0200
Message-Id: <20190222180539.27439-7-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190222180539.27439-1-kaslevs@vmware.com>
References: <20190222180539.27439-1-kaslevs@vmware.com>
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
index 88b4a55..69c8d67 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -781,6 +781,9 @@ static void __clear_trace(struct buffer_instance *instance)
 	FILE *fp;
 	char *path;
 
+	if (is_guest(instance))
+		return;
+
 	/* reset the trace */
 	path = get_instance_file(instance, "trace");
 	fp = fopen(path, "w");
@@ -1264,6 +1267,9 @@ set_plugin_instance(struct buffer_instance *instance, const char *name)
 	char *path;
 	char zero = '0';
 
+	if (is_guest(instance))
+		return;
+
 	path = get_instance_file(instance, "current_tracer");
 	fp = fopen(path, "w");
 	if (!fp) {
@@ -1360,6 +1366,9 @@ static void disable_func_stack_trace_instance(struct buffer_instance *instance)
 	int size;
 	int ret;
 
+	if (is_guest(instance))
+		return;
+
 	path = get_instance_file(instance, "current_tracer");
 	ret = stat(path, &st);
 	tracecmd_put_tracing_file(path);
@@ -1553,6 +1562,9 @@ reset_events_instance(struct buffer_instance *instance)
 	int i;
 	int ret;
 
+	if (is_guest(instance))
+		return;
+
 	if (use_old_event_method()) {
 		/* old way only had top instance */
 		if (!is_top_instance(instance))
@@ -1904,6 +1916,9 @@ static void write_tracing_on(struct buffer_instance *instance, int on)
 	int ret;
 	int fd;
 
+	if (is_guest(instance))
+		return;
+
 	fd = open_tracing_on(instance);
 	if (fd < 0)
 		return;
@@ -1923,6 +1938,9 @@ static int read_tracing_on(struct buffer_instance *instance)
 	char buf[10];
 	int ret;
 
+	if (is_guest(instance))
+		return -1;
+
 	fd = open_tracing_on(instance);
 	if (fd < 0)
 		return fd;
@@ -2156,6 +2174,9 @@ static void set_mask(struct buffer_instance *instance)
 	int fd;
 	int ret;
 
+	if (is_guest(instance))
+		return;
+
 	if (!instance->cpumask)
 		return;
 
@@ -2186,6 +2207,9 @@ static void enable_events(struct buffer_instance *instance)
 {
 	struct event_list *event;
 
+	if (is_guest(instance))
+		return;
+
 	for (event = instance->events; event; event = event->next) {
 		if (!event->neg)
 			update_event(event, event->filter, 0, '1');
@@ -2209,6 +2233,9 @@ static void set_clock(struct buffer_instance *instance)
 	char *content;
 	char *str;
 
+	if (is_guest(instance))
+		return;
+
 	if (!instance->clock)
 		return;
 
@@ -2238,6 +2265,9 @@ static void set_max_graph_depth(struct buffer_instance *instance, char *max_grap
 	char *path;
 	int ret;
 
+	if (is_guest(instance))
+		return;
+
 	path = get_instance_file(instance, "max_graph_depth");
 	reset_save_file(path, RESET_DEFAULT_PRIO);
 	tracecmd_put_tracing_file(path);
@@ -2463,6 +2493,9 @@ static void expand_event_instance(struct buffer_instance *instance)
 	struct event_list *compressed_list = instance->events;
 	struct event_list *event;
 
+	if (is_guest(instance))
+		return;
+
 	reset_event_list(instance);
 
 	while (compressed_list) {
@@ -3337,6 +3370,9 @@ static void set_funcs(struct buffer_instance *instance)
 	int set_notrace = 0;
 	int ret;
 
+	if (is_guest(instance))
+		return;
+
 	ret = write_func_file(instance, "set_ftrace_filter", &instance->filter_funcs);
 	if (ret < 0)
 		die("set_ftrace_filter does not exist. Can not filter functions");
@@ -3633,6 +3669,9 @@ static void set_buffer_size_instance(struct buffer_instance *instance)
 	int ret;
 	int fd;
 
+	if (is_guest(instance))
+		return;
+
 	if (!buffer_size)
 		return;
 
@@ -3830,6 +3869,9 @@ static void make_instances(void)
 	int ret;
 
 	for_each_instance(instance) {
+		if (is_guest(instance))
+			continue;
+
 		path = get_instance_dir(instance);
 		ret = stat(path, &st);
 		if (ret < 0) {
@@ -3851,7 +3893,7 @@ void tracecmd_remove_instances(void)
 
 	for_each_instance(instance) {
 		/* Only delete what we created */
-		if (instance->flags & BUFFER_FL_KEEP)
+		if (is_guest(instance) || (instance->flags & BUFFER_FL_KEEP))
 			continue;
 		if (instance->tracing_on_fd > 0) {
 			close(instance->tracing_on_fd);
@@ -3933,7 +3975,7 @@ static void check_function_plugin(void)
 
 static int __check_doing_something(struct buffer_instance *instance)
 {
-	return (instance->flags & BUFFER_FL_PROFILE) ||
+	return is_guest(instance) || (instance->flags & BUFFER_FL_PROFILE) ||
 		instance->plugin || instance->events;
 }
 
@@ -3955,6 +3997,9 @@ update_plugin_instance(struct buffer_instance *instance,
 {
 	const char *plugin = instance->plugin;
 
+	if (is_guest(instance))
+		return;
+
 	if (!plugin)
 		return;
 
@@ -4054,6 +4099,9 @@ static void record_stats(void)
 	int cpu;
 
 	for_all_instances(instance) {
+		if (is_guest(instance))
+			continue;
+
 		s_save = instance->s_save;
 		s_print = instance->s_print;
 		for (cpu = 0; cpu < instance->cpu_count; cpu++) {
@@ -4080,6 +4128,9 @@ static void destroy_stats(void)
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


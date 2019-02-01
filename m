Return-Path: <SRS0=aEXj=QI=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91601C282D8
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Feb 2019 13:45:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 613982084C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Feb 2019 13:45:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730190AbfBANpm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 1 Feb 2019 08:45:42 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34108 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726737AbfBANpm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 1 Feb 2019 08:45:42 -0500
Received: by mail-wm1-f66.google.com with SMTP id y185so4588795wmd.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 01 Feb 2019 05:45:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JT5rbIQqpYdFcMWwkumlch2I9FC5yN/EOExqR0k59BE=;
        b=cE/kYhvFUBRQg8fKgZeyXmO1gRNt++5yxsmNl3IYzEEw82Zw8KrfNU1XQdVd3N9eJC
         eAASTzjzz0Ad71JzHRC/OJtcL15qfvTtE7nDoLHhz4cJvRPEKWRX9xXMD2EH/RkYW/Xj
         atlsu5f0SqDZRi2G82DU8KzJL0yrd0ZtPH5fQJOuIc4PQ4RHq25sIcnozkO5EFft7PLE
         W0OVPAUppfN1IwyJZfar0nLDWsuL3R4Zs0GGZLXaG+JsjrTW7CoPy/LapJruZ402nXeA
         XfsmVXe0/cfOV+rTt/53nhud5YAxyKpQWcigypFLEs07XAozRcBjnKTaRK8wz0ElcJCD
         OhpA==
X-Gm-Message-State: AHQUAubqefzCgNGg4KygbB8COo1Sy/eybTdB2n186WizgKJDA2AtUZUl
        5jpzbZFuiU3O4udHjEdAqWmWgO0L
X-Google-Smtp-Source: AHgI3IZvLF9Y3ui+AQahgTZI+Fwna5YhAB+BAblcBWSl/zpsI1vppBlzh/4vY7xGfhzHb34KJDPXxw==
X-Received: by 2002:a1c:47:: with SMTP id 68mr2394913wma.89.1549028739523;
        Fri, 01 Feb 2019 05:45:39 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v26sm1468732wrv.78.2019.02.01.05.45.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 01 Feb 2019 05:45:38 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 2/6] trace-cmd: Added support for negative time offsets in trace.dat file
Date:   Fri,  1 Feb 2019 15:45:31 +0200
Message-Id: <20190201134535.2979-3-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190201134535.2979-1-tstoyanov@vmware.com>
References: <20190201134535.2979-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When synchronizing timestamps between different machines, there are cases
when the time offset is negative. This patch changes the way time offset is
written and read from trace.dat file - as signed decimal, instead of hex.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 include/trace-cmd/trace-cmd.h |   2 +-
 lib/trace-cmd/trace-input.c   |   6 +-
 tracecmd/trace-read.c         |   4 +-
 tracecmd/trace-record.c       | 120 +++++++++++++++++-----------------
 4 files changed, 66 insertions(+), 66 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 86de654..da225b4 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -126,7 +126,7 @@ int tracecmd_is_buffer_instance(struct tracecmd_input *handle);
 void tracecmd_create_top_instance(char *name);
 void tracecmd_remove_instances(void);
 
-void tracecmd_set_ts_offset(struct tracecmd_input *handle, unsigned long long offset);
+void tracecmd_set_ts_offset(struct tracecmd_input *handle, long long offset);
 void tracecmd_set_ts2secs(struct tracecmd_input *handle, unsigned long long hz);
 
 void tracecmd_print_events(struct tracecmd_input *handle, const char *regex);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index b628570..33ad7d1 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -100,7 +100,7 @@ struct tracecmd_input {
 	bool			read_page;
 	bool			use_pipe;
 	struct cpu_data 	*cpu_data;
-	unsigned long long	ts_offset;
+	long long		ts_offset;
 	double			ts2secs;
 	char *			cpustats;
 	char *			uname;
@@ -2091,7 +2091,7 @@ static int init_cpu(struct tracecmd_input *handle, int cpu)
 }
 
 void tracecmd_set_ts_offset(struct tracecmd_input *handle,
-			    unsigned long long offset)
+			    long long offset)
 {
 	handle->ts_offset = offset;
 }
@@ -2108,7 +2108,7 @@ void tracecmd_set_ts2secs(struct tracecmd_input *handle,
 
 static int handle_options(struct tracecmd_input *handle)
 {
-	unsigned long long offset;
+	long long offset;
 	unsigned short option;
 	unsigned int size;
 	char *cpustats = NULL;
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 804022a..e309672 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -58,7 +58,7 @@ static struct list_head handle_list;
 struct input_files {
 	struct list_head	list;
 	const char		*file;
-	unsigned long long	tsoffset;
+	long long		tsoffset;
 	unsigned long long	ts2secs;
 };
 static struct list_head input_files;
@@ -1413,7 +1413,7 @@ void trace_report (int argc, char **argv)
 	struct input_files *inputs;
 	struct handle_list *handles;
 	enum output_type otype;
-	unsigned long long tsoffset = 0;
+	long long tsoffset = 0;
 	unsigned long long ts2secs = 0;
 	unsigned long long ts2sc;
 	int show_stat = 0;
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index cd80462..5b763ad 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -201,6 +201,12 @@ enum trace_cmd {
 	CMD_record_agent,
 };
 
+enum {
+	DATA_FL_NONE		= 0,
+	DATA_FL_DATE		= 1,
+	DATA_FL_OFFSET		= 2,
+};
+
 struct common_record_context {
 	enum trace_cmd curr_cmd;
 	struct buffer_instance *instance;
@@ -3230,7 +3236,60 @@ again:
 	return msg_handle;
 }
 
-static void add_options(struct tracecmd_output *handle, struct common_record_context *ctx);
+static void add_option_hooks(struct tracecmd_output *handle)
+{
+	struct hook_list *hook;
+	int len;
+
+	for (hook = hooks; hook; hook = hook->next) {
+		len = strlen(hook->hook);
+		tracecmd_add_option(handle, TRACECMD_OPTION_HOOK,
+				    len + 1, hook->hook);
+	}
+}
+
+static void add_uname(struct tracecmd_output *handle)
+{
+	struct utsname buf;
+	char *str;
+	int len;
+	int ret;
+
+	ret = uname(&buf);
+	/* if this fails for some reason, just ignore it */
+	if (ret < 0)
+		return;
+
+	len = strlen(buf.sysname) + strlen(buf.nodename) +
+		strlen(buf.release) + strlen(buf.machine) + 4;
+	str = malloc(len);
+	if (!str)
+		return;
+	sprintf(str, "%s %s %s %s", buf.sysname, buf.nodename, buf.release, buf.machine);
+	tracecmd_add_option(handle, TRACECMD_OPTION_UNAME, len, str);
+	free(str);
+}
+
+static void add_options(struct tracecmd_output *handle,
+			struct common_record_context *ctx)
+{
+	int type = 0;
+
+	if (ctx->date2ts) {
+		if (ctx->data_flags & DATA_FL_DATE)
+			type = TRACECMD_OPTION_DATE;
+		else if (ctx->data_flags & DATA_FL_OFFSET)
+			type = TRACECMD_OPTION_OFFSET;
+	}
+
+	if (type)
+		tracecmd_add_option(handle, type,
+				    strlen(ctx->date2ts)+1, ctx->date2ts);
+
+	tracecmd_add_option(handle, TRACECMD_OPTION_TRACECLOCK, 0, NULL);
+	add_option_hooks(handle);
+	add_uname(handle);
+}
 
 static struct tracecmd_msg_handle *
 setup_connection(struct buffer_instance *instance, struct common_record_context *ctx)
@@ -3457,40 +3516,6 @@ add_buffer_stat(struct tracecmd_output *handle, struct buffer_instance *instance
 				    instance->s_save[i].buffer);
 }
 
-static void add_option_hooks(struct tracecmd_output *handle)
-{
-	struct hook_list *hook;
-	int len;
-
-	for (hook = hooks; hook; hook = hook->next) {
-		len = strlen(hook->hook);
-		tracecmd_add_option(handle, TRACECMD_OPTION_HOOK,
-				    len + 1, hook->hook);
-	}
-}
-
-static void add_uname(struct tracecmd_output *handle)
-{
-	struct utsname buf;
-	char *str;
-	int len;
-	int ret;
-
-	ret = uname(&buf);
-	/* if this fails for some reason, just ignore it */
-	if (ret < 0)
-		return;
-
-	len = strlen(buf.sysname) + strlen(buf.nodename) +
-		strlen(buf.release) + strlen(buf.machine) + 4;
-	str = malloc(len);
-	if (!str)
-		return;
-	sprintf(str, "%s %s %s %s", buf.sysname, buf.nodename, buf.release, buf.machine);
-	tracecmd_add_option(handle, TRACECMD_OPTION_UNAME, len, str);
-	free(str);
-}
-
 static void print_stat(struct buffer_instance *instance)
 {
 	int cpu;
@@ -3505,31 +3530,6 @@ static void print_stat(struct buffer_instance *instance)
 		trace_seq_do_printf(&instance->s_print[cpu]);
 }
 
-enum {
-	DATA_FL_NONE		= 0,
-	DATA_FL_DATE		= 1,
-	DATA_FL_OFFSET		= 2,
-};
-
-static void add_options(struct tracecmd_output *handle, struct common_record_context *ctx)
-{
-	int type = 0;
-
-	if (ctx->date2ts) {
-		if (ctx->data_flags & DATA_FL_DATE)
-			type = TRACECMD_OPTION_DATE;
-		else if (ctx->data_flags & DATA_FL_OFFSET)
-			type = TRACECMD_OPTION_OFFSET;
-	}
-
-	if (type)
-		tracecmd_add_option(handle, type, strlen(ctx->date2ts)+1, ctx->date2ts);
-
-	tracecmd_add_option(handle, TRACECMD_OPTION_TRACECLOCK, 0, NULL);
-	add_option_hooks(handle);
-	add_uname(handle);
-}
-
 static void write_guest_file(struct buffer_instance *instance)
 {
 	struct tracecmd_output *handle;
-- 
2.20.1


Return-Path: <SRS0=eJz3=7Q=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAA53C433E2
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Jun 2020 12:15:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A578206A2
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Jun 2020 12:15:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KQX4fsn9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbgFCMPQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 3 Jun 2020 08:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbgFCMPP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jun 2020 08:15:15 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0186AC08C5C0
        for <linux-trace-devel@vger.kernel.org>; Wed,  3 Jun 2020 05:15:15 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id k26so1800702wmi.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 03 Jun 2020 05:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X77pVfnQfxk8jwVhme3isU2BXnW8UBv5iFVdIwihdmo=;
        b=KQX4fsn9GA5+9VVsjTzbwTzo1nBqNICZU704anGKB4saaPlRIfdU+D+WJ6r2GV4heP
         u41A6iwbN3Y6yicRaTQHVboZFPtihukJAp0RTS3SljW6hdeqY9PZVrsaJlf+mzCAaJm4
         2zldfpLkfh8MQ3Vkt0i5EuokJTKOBC2TkMxCi2U71iJnrh3UTe/X3c0TZ9asyESCKq8/
         S9wI9ShCEJWI5P/AB1FgQ5s8zOJgVAQfmCoHOw9jgBzQ4t+oqalNxtOMXJ90Q2mWGE/7
         oTfZVAnHHSM7Th9d+wP4nNzzZgJAULpNEYLLfjKOU81n/zNuOCUVWW2fjrk/Z5cURrJP
         3soA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X77pVfnQfxk8jwVhme3isU2BXnW8UBv5iFVdIwihdmo=;
        b=OlaUr0jejC3oz+77p9lxYnUMKuKXI+zSmnxPetRlBGdRP+QWyxPAUXUavft95ND6A0
         wYsWCe/3w2ZuewRyZz1DDnh75FKvhz58uaGs63CWX5Lw9/PGvfMTICG+rqDwBwu5kh7D
         g/Zp9y1uUMHzOZm0K4PYgdDyC83EiZjQeuEOE9xMDe3XMl8sTogie+WDUS3kRfEth56o
         DeEIEqNN8eTgpdvROkO7Oc2qBRGVEPweiQDLevJtqTHfLQZqg5FB5WHgNeFXLmKYwG/B
         bbQ3bxeOxfWtB1T8O1dRNixYa5xJb9rrfxtYXOPF7c45l88gypHAJtsOC2CWzPeGcK16
         audA==
X-Gm-Message-State: AOAM533n71R936d5pmUmR7gJTj3XL3E/TIcaG5tLqxQi2CN5dtDPaki0
        1wlSOzXUCggvermqYnvrCNyVsAxCW+o=
X-Google-Smtp-Source: ABdhPJxRMhBTvaAGLfbsiplJG/1fVQ9Mx5LvNcCBG8FzWhsCbp+RhOn+Ku6GV3LYud3ezXGr7V6yBw==
X-Received: by 2002:a7b:c761:: with SMTP id x1mr8987199wmk.90.1591186513588;
        Wed, 03 Jun 2020 05:15:13 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u3sm2657042wmg.38.2020.06.03.05.15.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 05:15:12 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 4/5] trace-cmd: Extend option "-v" to delete an ftrace instance
Date:   Wed,  3 Jun 2020 15:15:05 +0300
Message-Id: <20200603121506.49992-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200603121506.49992-1-tz.stoyanov@gmail.com>
References: <20200603121506.49992-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Extended the "trace-cmd set" option "-v" to delete the instance specified
after it on the command line with "-B". For example:
 trace-cmd set -v -B bar -B foo
will delete instance bar and create a new instance foo.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/trace-cmd-set.1.txt | 19 +++++++----
 tracecmd/include/trace-local.h    |  1 +
 tracecmd/trace-record.c           | 55 ++++++++++++++++++++++++++++---
 tracecmd/trace-usage.c            |  4 +--
 4 files changed, 65 insertions(+), 14 deletions(-)

diff --git a/Documentation/trace-cmd-set.1.txt b/Documentation/trace-cmd-set.1.txt
index faf0b740..af1f69c6 100644
--- a/Documentation/trace-cmd-set.1.txt
+++ b/Documentation/trace-cmd-set.1.txt
@@ -77,15 +77,20 @@ OPTIONS
     information on triggers.
 
 *-v*::
-    This will cause all events specified after it on the command line to not
-    be traced. This is useful for selecting a subsystem to be traced but to
-    leave out various events. For Example: "-e sched -v -e "\*stat\*"" will
-    enable all events in the sched subsystem except those that have "stat" in
-    their names.
-
+    This will negate options specified after it on the command line. It affects:
+[verse]
+--
+     *-e*: Causes all specified events to not be traced. This is useful for
+           selecting a subsystem to be traced but to leave out various events.
+           For example: "-e sched -v -e "\*stat\*"" will enable all events in
+           the sched subsystem except those that have "stat" in their names.
+     *-B*: Deletes the specified ftrace instance. There must be no
+           configuration options related to this instance in the command line.
+           For example: "-v -B bar -B foo" will delete instance bar and create
+           a new instance foo.
     Note: the *-v* option was taken from the way grep(1) inverts the following
     matches.
-
+--
 *-P* 'pid'::
     This will filter only the specified process IDs. Using *-P* will let you
     trace only events that are caused by the process.
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 5ec05149..d148aa16 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -205,6 +205,7 @@ struct buffer_instance {
 	char			*output_file;
 	struct event_list	*events;
 	struct event_list	**event_next;
+	bool			delete;
 
 	struct event_list	*sched_switch_event;
 	struct event_list	*sched_wakeup_event;
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index d5515c52..ab085f80 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -5797,6 +5797,27 @@ static inline void cmd_check_die(struct common_record_context *ctx,
 		    "Did you mean 'record'?", param, cmd);
 }
 
+static inline void remove_instances(struct buffer_instance *instances)
+{
+	struct buffer_instance *del;
+
+	while (instances) {
+		del = instances;
+		instances = instances->next;
+		tracefs_instance_destroy(del->tracefs);
+		tracefs_instance_free(del->tracefs);
+		free(del);
+	}
+}
+
+static inline void
+check_instance_die(struct buffer_instance *instance, char *param)
+{
+	if (instance->delete)
+		die("Instance %s is marked for deletion, invalid option %s",
+		    tracefs_instance_get_name(instance->tracefs), param);
+}
+
 static void parse_record_options(int argc,
 				 char **argv,
 				 enum trace_cmd curr_cmd,
@@ -5810,8 +5831,8 @@ static void parse_record_options(int argc,
 	char *pid;
 	char *sav;
 	int name_counter = 0;
-	int neg_event = 0;
-	struct buffer_instance *instance;
+	int negative = 0;
+	struct buffer_instance *instance, *del_list = NULL;
 	bool guest_sync_set = false;
 	int do_children = 0;
 	int fpids_count = 0;
@@ -5881,6 +5902,7 @@ static void parse_record_options(int argc,
 			}
 			break;
 		case 'e':
+			check_instance_die(ctx->instance, "-e");
 			ctx->events = 1;
 			event = malloc(sizeof(*event));
 			if (!event)
@@ -5888,7 +5910,7 @@ static void parse_record_options(int argc,
 			memset(event, 0, sizeof(*event));
 			event->event = optarg;
 			add_event(ctx->instance, event);
-			event->neg = neg_event;
+			event->neg = negative;
 			event->filter = NULL;
 			last_event = event;
 
@@ -5954,6 +5976,7 @@ static void parse_record_options(int argc,
 			ctx->global = 1;
 			break;
 		case 'P':
+			check_instance_die(ctx->instance, "-P");
 			test_set_event_pid(ctx->instance);
 			pids = strdup(optarg);
 			if (!pids)
@@ -5969,6 +5992,7 @@ static void parse_record_options(int argc,
 			free(pids);
 			break;
 		case 'c':
+			check_instance_die(ctx->instance, "-c");
 			test_set_event_pid(ctx->instance);
 			do_children = 1;
 			if (!ctx->instance->have_event_fork) {
@@ -5985,13 +6009,14 @@ static void parse_record_options(int argc,
 				save_option(ctx->instance, "function-fork");
 			break;
 		case 'C':
+			check_instance_die(ctx->instance, "-C");
 			ctx->instance->clock = optarg;
 			ctx->instance->flags |= BUFFER_FL_HAS_CLOCK;
 			if (is_top_instance(ctx->instance))
 				guest_sync_set = true;
 			break;
 		case 'v':
-			neg_event = 1;
+			negative = 1;
 			break;
 		case 'l':
 			add_func(&ctx->instance->filter_funcs,
@@ -5999,15 +6024,18 @@ static void parse_record_options(int argc,
 			ctx->filtered = 1;
 			break;
 		case 'n':
+			check_instance_die(ctx->instance, "-n");
 			add_func(&ctx->instance->notrace_funcs,
 				 ctx->instance->filter_mod, optarg);
 			ctx->filtered = 1;
 			break;
 		case 'g':
+			check_instance_die(ctx->instance, "-g");
 			add_func(&graph_funcs, ctx->instance->filter_mod, optarg);
 			ctx->filtered = 1;
 			break;
 		case 'p':
+			check_instance_die(ctx->instance, "-p");
 			if (ctx->instance->plugin)
 				die("only one plugin allowed");
 			for (plugin = optarg; isspace(*plugin); plugin++)
@@ -6057,14 +6085,17 @@ static void parse_record_options(int argc,
 			}
 			break;
 		case 'O':
+			check_instance_die(ctx->instance, "-O");
 			option = optarg;
 			save_option(ctx->instance, option);
 			break;
 		case 'T':
+			check_instance_die(ctx->instance, "-T");
 			save_option(ctx->instance, "stacktrace");
 			break;
 		case 'H':
 			cmd_check_die(ctx, CMD_set, *(argv+1), "-H");
+			check_instance_die(ctx->instance, "-H");
 			add_hook(ctx->instance, optarg);
 			ctx->events = 1;
 			break;
@@ -6109,6 +6140,7 @@ static void parse_record_options(int argc,
 			max_kb = atoi(optarg);
 			break;
 		case 'M':
+			check_instance_die(ctx->instance, "-M");
 			ctx->instance->cpumask = alloc_mask_from_hex(ctx->instance, optarg);
 			break;
 		case 't':
@@ -6119,13 +6151,20 @@ static void parse_record_options(int argc,
 				use_tcp = 1;
 			break;
 		case 'b':
+			check_instance_die(ctx->instance, "-b");
 			ctx->instance->buffer_size = atoi(optarg);
 			break;
 		case 'B':
 			ctx->instance = create_instance(optarg);
 			if (!ctx->instance)
 				die("Failed to create instance");
-			add_instance(ctx->instance, local_cpu_count);
+			ctx->instance->delete = negative;
+			negative = 0;
+			if (ctx->instance->delete) {
+				ctx->instance->next = del_list;
+				del_list = ctx->instance;
+			} else
+				add_instance(ctx->instance, local_cpu_count);
 			if (IS_PROFILE(ctx))
 				ctx->instance->flags |= BUFFER_FL_PROFILE;
 			break;
@@ -6144,6 +6183,7 @@ static void parse_record_options(int argc,
 		case OPT_procmap:
 			cmd_check_die(ctx, CMD_start, *(argv+1), "--proc-map");
 			cmd_check_die(ctx, CMD_set, *(argv+1), "--proc-map");
+			check_instance_die(ctx->instance, "--proc-map");
 			ctx->instance->get_procmap = 1;
 			break;
 		case OPT_date:
@@ -6166,6 +6206,7 @@ static void parse_record_options(int argc,
 			break;
 		case OPT_profile:
 			cmd_check_die(ctx, CMD_set, *(argv+1), "--profile");
+			check_instance_die(ctx->instance, "--profile");
 			handle_init = trace_init_profile;
 			ctx->instance->flags |= BUFFER_FL_PROFILE;
 			ctx->events = 1;
@@ -6190,6 +6231,7 @@ static void parse_record_options(int argc,
 			ctx->data_flags |= DATA_FL_OFFSET;
 			break;
 		case OPT_max_graph_depth:
+			check_instance_die(ctx->instance, "--max-graph-depth");
 			free(ctx->instance->max_graph_depth);
 			ctx->instance->max_graph_depth = strdup(optarg);
 			if (!ctx->instance->max_graph_depth)
@@ -6206,6 +6248,7 @@ static void parse_record_options(int argc,
 			tracecmd_set_debug(true);
 			break;
 		case OPT_module:
+			check_instance_die(ctx->instance, "--module");
 			if (ctx->instance->filter_mod)
 				add_func(&ctx->instance->filter_funcs,
 					 ctx->instance->filter_mod, "*");
@@ -6226,6 +6269,8 @@ static void parse_record_options(int argc,
 		}
 	}
 
+	remove_instances(del_list);
+
 	/* If --date is specified, prepend it to all guest VM flags */
 	if (ctx->date) {
 		struct buffer_instance *instance;
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 0c0e12f4..96647a1e 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -34,7 +34,7 @@ static struct usage_help usage_help[] = {
 		"          -n do not trace function\n"
 		"          -m max size per CPU in kilobytes\n"
 		"          -M set CPU mask to trace\n"
-		"          -v will negate all -e after it (disable those events)\n"
+		"          -v will negate all -e (disable those events) and -B (delete those instances) after it\n"
 		"          -d disable function tracer when running\n"
 		"          -D Full disable of function tracing (for all users)\n"
 		"          -o data output file [default trace.dat]\n"
@@ -84,7 +84,7 @@ static struct usage_help usage_help[] = {
 		"          -n do not trace function\n"
 		"          -m max size per CPU in kilobytes\n"
 		"          -M set CPU mask to trace\n"
-		"          -v will negate all -e after it (disable those events)\n"
+		"          -v will negate all -e (disable those events) and -B (delete those instances) after it\n"
 		"          -d disable function tracer when running\n"
 		"          -D Full disable of function tracing (for all users)\n"
 		"          -O option to enable (or disable)\n"
-- 
2.26.2


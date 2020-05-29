Return-Path: <SRS0=SVAg=7L=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58CD0C433DF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 May 2020 07:02:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B0252074D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 May 2020 07:02:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="u8A46eL5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725768AbgE2HC0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 29 May 2020 03:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgE2HCZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 29 May 2020 03:02:25 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA73C03E969
        for <linux-trace-devel@vger.kernel.org>; Fri, 29 May 2020 00:02:23 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id n5so2066333wmd.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 29 May 2020 00:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G10UxRT7uCEYuIPx4uDuNha9kU5525ApKqSpuO2/eng=;
        b=u8A46eL5pHCEAaKyANgKmJ+EQEQLvK+vkhmLLqHNNScnMUmyW4bDsLtMiP8Q1VtgB8
         3omVTcGfseMYlOgtJu8pXPA8zurxzOL5XRDk3drL/FWgh6mj9Eo4trs0zhvQIxr1BdSO
         9+vss2EWfvy3qpFM+Lk27U7mjIlAtcOsEvQThDAiMICF4R7YEL6ZlVlSiStD9Vf+bEGq
         aJsUXu2Mf73Ym6UfPg5puIkDrTXH0REjsqfSftX+GYehzbBCKqf2NKuShYv6ZmZUsqzi
         uoyok+0POKu+oXetBUd47u6rdxBIpuMS0STdNjGzcA1GDCPk2j2Y1HSCNEqfTcqUB3gB
         Y7UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G10UxRT7uCEYuIPx4uDuNha9kU5525ApKqSpuO2/eng=;
        b=jdtiofnok03HTpTMNF1snhpYmAsL2zas0wbbgiYPR4tY/pdqx14uFo7y83XLh/3/iL
         JTXXm/ZfYD7TPT4/to7+J69+Za31LZqKfhnsD9sQq+rGFnxOAzVzVc1FHYX+jZLgL7IM
         zWz67dnc0DRU7NVZDwZkX+3X5TugNt0pOF8/blaEfSq8ezCGCtZmrW/7ewtCK+OUDr3f
         3uIiRwweJSWWv5lrKkH1G83OzSYNZ/7wOfRESF0wA1Tbi915Y5VglPUU5Evk4jDDGHct
         caD9FiEXrJLt5IAQR655HIvK/8LFYGW297oUw1JYBBWMSIbydupxygDAJAF3JGEWqbc3
         omPA==
X-Gm-Message-State: AOAM532fMjntfy8kKTpjLyyfYx/rJ1lsojvvcMhVw6ZprlC9+3wZYGij
        /Kmg9xGkzklqdqIJR0wGVpPzt3Uj1j4=
X-Google-Smtp-Source: ABdhPJwFpMgLEFLpk2uuOzj9FGkWtSy9IIqhOCL+TXAieocQqH+V6eR962Kdl7lsw+Ys0kQZLnVwJg==
X-Received: by 2002:a7b:cb47:: with SMTP id v7mr7223476wmj.34.1590735742302;
        Fri, 29 May 2020 00:02:22 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q13sm3440294wro.5.2020.05.29.00.02.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 00:02:21 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/2] trace-cmd: Add new subcommand "set"
Date:   Fri, 29 May 2020 10:02:19 +0300
Message-Id: <20200529070220.482278-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The command "set" configures various ftarce parameters, like "record"
and "start" commands, but does not reset ftrace state on exit.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=207781
Reported-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/include/trace-local.h |  2 ++
 tracecmd/trace-cmd.c           |  1 +
 tracecmd/trace-record.c        | 64 ++++++++++++++++++++++++++++++----
 tracecmd/trace-usage.c         | 33 ++++++++++++++++++
 4 files changed, 93 insertions(+), 7 deletions(-)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 5d585509..5ec05149 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -57,6 +57,8 @@ void trace_reset(int argc, char **argv);
 
 void trace_start(int argc, char **argv);
 
+void trace_set(int argc, char **argv);
+
 void trace_extract(int argc, char **argv);
 
 void trace_stream(int argc, char **argv);
diff --git a/tracecmd/trace-cmd.c b/tracecmd/trace-cmd.c
index dbfcc974..7376c5a5 100644
--- a/tracecmd/trace-cmd.c
+++ b/tracecmd/trace-cmd.c
@@ -90,6 +90,7 @@ struct command commands[] = {
 	{"check-events", trace_check_events},
 	{"record", trace_record},
 	{"start", trace_start},
+	{"set", trace_set},
 	{"extract", trace_extract},
 	{"stop", trace_stop},
 	{"stream", trace_stream},
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 3242368e..03c31b2b 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -63,6 +63,7 @@ enum trace_type {
 	TRACE_TYPE_START	= (1 << 1),
 	TRACE_TYPE_STREAM	= (1 << 2),
 	TRACE_TYPE_EXTRACT	= (1 << 3),
+	TRACE_TYPE_SET		= (1 << 4),
 };
 
 static tracecmd_handle_init_func handle_init = NULL;
@@ -185,6 +186,7 @@ enum trace_cmd {
 	CMD_profile,
 	CMD_record,
 	CMD_record_agent,
+	CMD_set,
 };
 
 struct common_record_context {
@@ -5719,6 +5721,7 @@ static void init_common_record_context(struct common_record_context *ctx,
 
 #define IS_EXTRACT(ctx) ((ctx)->curr_cmd == CMD_extract)
 #define IS_START(ctx) ((ctx)->curr_cmd == CMD_start)
+#define IS_CMDSET(ctx) ((ctx)->curr_cmd == CMD_set)
 #define IS_STREAM(ctx) ((ctx)->curr_cmd == CMD_stream)
 #define IS_PROFILE(ctx) ((ctx)->curr_cmd == CMD_profile)
 #define IS_RECORD(ctx) ((ctx)->curr_cmd == CMD_record)
@@ -5782,6 +5785,14 @@ static void add_arg(struct buffer_instance *instance,
 	/* Not found? */
 }
 
+static void set_cmd_check(struct common_record_context *ctx, char *param)
+{
+	if (IS_CMDSET(ctx)) {
+		die("%s has no effect with set command\n"
+		    "Did you mean 'record'?", param);
+	}
+}
+
 static void parse_record_options(int argc,
 				 char **argv,
 				 enum trace_cmd curr_cmd,
@@ -5803,6 +5814,9 @@ static void parse_record_options(int argc,
 
 	init_common_record_context(ctx, curr_cmd);
 
+	if (IS_CMDSET(ctx))
+		keep = 1;
+
 	for (;;) {
 		int option_index = 0;
 		int ret;
@@ -5854,6 +5868,7 @@ static void parse_record_options(int argc,
 			usage(argv);
 			break;
 		case 'a':
+			set_cmd_check(ctx, "-a");
 			if (IS_EXTRACT(ctx)) {
 				add_all_instances();
 			} else {
@@ -5927,10 +5942,12 @@ static void parse_record_options(int argc,
 			break;
 		}
 		case 'F':
+			set_cmd_check(ctx, "-F");
 			test_set_event_pid(ctx->instance);
 			filter_task = 1;
 			break;
 		case 'G':
+			set_cmd_check(ctx, "-G");
 			ctx->global = 1;
 			break;
 		case 'P':
@@ -6006,6 +6023,7 @@ static void parse_record_options(int argc,
 			ctx->disable = 1;
 			break;
 		case 'o':
+			set_cmd_check(ctx, "-o");
 			if (IS_RECORD_AGENT(ctx))
 				die("-o incompatible with agent recording");
 			if (host)
@@ -6043,10 +6061,12 @@ static void parse_record_options(int argc,
 			save_option(ctx->instance, "stacktrace");
 			break;
 		case 'H':
+			set_cmd_check(ctx, "-H");
 			add_hook(ctx->instance, optarg);
 			ctx->events = 1;
 			break;
 		case 's':
+			set_cmd_check(ctx, "-s");
 			if (IS_EXTRACT(ctx)) {
 				if (optarg)
 					usage(argv);
@@ -6058,15 +6078,18 @@ static void parse_record_options(int argc,
 			sleep_time = atoi(optarg);
 			break;
 		case 'S':
+			set_cmd_check(ctx, "-S");
 			ctx->manual = 1;
 			/* User sets events for profiling */
 			if (!event)
 				ctx->events = 0;
 			break;
 		case 'r':
+			set_cmd_check(ctx, "-r");
 			rt_prio = atoi(optarg);
 			break;
 		case 'N':
+			set_cmd_check(ctx, "-N");
 			if (!IS_RECORD(ctx))
 				die("-N only available with record");
 			if (IS_RECORD_AGENT(ctx))
@@ -6086,6 +6109,7 @@ static void parse_record_options(int argc,
 			ctx->instance->cpumask = alloc_mask_from_hex(ctx->instance, optarg);
 			break;
 		case 't':
+			set_cmd_check(ctx, "-t");
 			if (IS_EXTRACT(ctx))
 				ctx->topt = 1; /* Extract top instance also */
 			else
@@ -6103,20 +6127,24 @@ static void parse_record_options(int argc,
 				ctx->instance->flags |= BUFFER_FL_PROFILE;
 			break;
 		case 'k':
+			set_cmd_check(ctx, "-k");
 			keep = 1;
 			break;
 		case 'i':
 			ignore_event_not_found = 1;
 			break;
 		case OPT_user:
+			set_cmd_check(ctx, "--user");
 			ctx->user = strdup(optarg);
 			if (!ctx->user)
 				die("Failed to allocate user name");
 			break;
 		case OPT_procmap:
+			set_cmd_check(ctx, "--proc-map");
 			ctx->instance->get_procmap = 1;
 			break;
 		case OPT_date:
+			set_cmd_check(ctx, "--date");
 			ctx->date = 1;
 			if (ctx->data_flags & DATA_FL_OFFSET)
 				die("Can not use both --date and --ts-offset");
@@ -6126,12 +6154,15 @@ static void parse_record_options(int argc,
 			func_stack = 1;
 			break;
 		case OPT_nosplice:
+			set_cmd_check(ctx, "--nosplice");
 			recorder_flags |= TRACECMD_RECORD_NOSPLICE;
 			break;
 		case OPT_nofifos:
+			set_cmd_check(ctx, "--nofifos");
 			no_fifos = true;
 			break;
 		case OPT_profile:
+			set_cmd_check(ctx, "--profile");
 			handle_init = trace_init_profile;
 			ctx->instance->flags |= BUFFER_FL_PROFILE;
 			ctx->events = 1;
@@ -6145,9 +6176,11 @@ static void parse_record_options(int argc,
 			dup2(2, 1);
 			break;
 		case OPT_bycomm:
+			set_cmd_check(ctx, "--by-comm");
 			trace_profile_set_merge_like_comms();
 			break;
 		case OPT_tsoffset:
+			set_cmd_check(ctx, "--ts-offset");
 			ctx->date2ts = strdup(optarg);
 			if (ctx->data_flags & DATA_FL_DATE)
 				die("Can not use both --date and --ts-offset");
@@ -6160,9 +6193,11 @@ static void parse_record_options(int argc,
 				die("Could not allocate option");
 			break;
 		case OPT_cmdlines_size:
+			set_cmd_check(ctx, "--cmdlines-size");
 			ctx->saved_cmdlines_size = atoi(optarg);
 			break;
 		case OPT_no_filter:
+			set_cmd_check(ctx, "--no-filter");
 			no_filter = true;
 			break;
 		case OPT_debug:
@@ -6176,6 +6211,7 @@ static void parse_record_options(int argc,
 			ctx->filtered = 0;
 			break;
 		case OPT_tsyncinterval:
+			set_cmd_check(ctx, "--tsync-interval");
 			top_instance.tsync.loop_interval = atoi(optarg);
 			guest_sync_set = true;
 			break;
@@ -6221,8 +6257,8 @@ static void parse_record_options(int argc,
 		die(" -c can only be used with -F (or -P with event-fork support)");
 
 	if ((argc - optind) >= 2) {
-		if (IS_START(ctx))
-			die("Command start does not take any commands\n"
+		if (IS_START(ctx) || IS_CMDSET(ctx))
+			die("Commands start and set do not take any commands\n"
 			    "Did you mean 'record'?");
 		if (IS_EXTRACT(ctx))
 			die("Command extract does not take any commands\n"
@@ -6265,7 +6301,8 @@ static enum trace_type get_trace_cmd_type(enum trace_cmd cmd)
 		{CMD_extract, TRACE_TYPE_EXTRACT},
 		{CMD_profile, TRACE_TYPE_STREAM},
 		{CMD_start, TRACE_TYPE_START},
-		{CMD_record_agent, TRACE_TYPE_RECORD}
+		{CMD_record_agent, TRACE_TYPE_RECORD},
+		{CMD_set, TRACE_TYPE_SET}
 	};
 
 	for (int i = 0; i < ARRAY_SIZE(trace_type_per_command); i++) {
@@ -6342,8 +6379,10 @@ static void record_trace(int argc, char **argv,
 		ctx->topt = 1;
 
 	update_first_instance(ctx->instance, ctx->topt);
-	check_doing_something();
-	check_function_plugin();
+	if (!IS_CMDSET(ctx)) {
+		check_doing_something();
+		check_function_plugin();
+	}
 
 	if (!ctx->output)
 		ctx->output = DEFAULT_INPUT_FILE;
@@ -6371,7 +6410,8 @@ static void record_trace(int argc, char **argv,
 
 	if (!is_guest(ctx->instance))
 		fset = set_ftrace(!ctx->disable, ctx->total_disable);
-	tracecmd_disable_all_tracing(1);
+	if (!IS_CMDSET(ctx))
+		tracecmd_disable_all_tracing(1);
 
 	for_all_instances(instance)
 		set_clock(instance);
@@ -6412,7 +6452,8 @@ static void record_trace(int argc, char **argv,
 			start_threads(type, ctx);
 	} else {
 		update_task_filter();
-		tracecmd_enable_tracing();
+		if (!IS_CMDSET(ctx))
+			tracecmd_enable_tracing();
 		exit(0);
 	}
 
@@ -6486,6 +6527,15 @@ void trace_start(int argc, char **argv)
 	exit(0);
 }
 
+void trace_set(int argc, char **argv)
+{
+	struct common_record_context ctx;
+
+	parse_record_options(argc, argv, CMD_set, &ctx);
+	record_trace(argc, argv, &ctx);
+	exit(0);
+}
+
 void trace_extract(int argc, char **argv)
 {
 	struct common_record_context ctx;
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index d43ca490..83b0dc57 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -65,6 +65,39 @@ static struct usage_help usage_help[] = {
 		"               If 0 is specified, no loop is performed - timestamps offset is calculated only twice,"
 		"                                                         at the beginnig and at the end of the trace\n"
 	},
+	{
+		"set",
+		"set a ftarce configuration parameter",
+		" %s set [-v][-e event [-f filter]][-p plugin][-d][-D] \\\n"
+		"           [-q][-s usecs][-O option ][-l func][-g func][-n func] \\\n"
+		"           [-P pid][-b size][-B buf][-m max][-C clock]\n"
+		"          -e enable event\n"
+		"          -f filter for previous -e event\n"
+		"          -R trigger for previous -e event\n"
+		"          -p set ftrace plugin\n"
+		"          -P set PIDs to be traced\n"
+		"          -c also trace the children of -P, if kernel supports it\n"
+		"          -C set the trace clock\n"
+		"          -T do a stacktrace on all events\n"
+		"          -l filter function name\n"
+		"          -g set graph function\n"
+		"          -n do not trace function\n"
+		"          -m max size per CPU in kilobytes\n"
+		"          -M set CPU mask to trace\n"
+		"          -v will negate all -e after it (disable those events)\n"
+		"          -d disable function tracer when running\n"
+		"          -D Full disable of function tracing (for all users)\n"
+		"          -O option to enable (or disable)\n"
+		"          -b change kernel buffersize (in kilobytes per CPU)\n"
+		"          -B create sub buffer and following events will be enabled here\n"
+		"          -i do not fail if an event is not found\n"
+		"          -q print no output to the screen\n"
+		"          --quiet print no output to the screen\n"
+		"          --module filter module name\n"
+		"          --func-stack perform a stack trace for function tracer\n"
+		"             (use with caution)\n"
+		"          --max-graph-depth limit function_graph depth\n"
+	},
 	{
 		"start",
 		"start tracing without recording into a file",
-- 
2.26.2


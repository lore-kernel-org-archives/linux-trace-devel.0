Return-Path: <SRS0=8+AL=7P=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8576EC433E1
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Jun 2020 14:09:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C7A7206E2
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Jun 2020 14:09:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r836OEo+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbgFBOJU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Jun 2020 10:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbgFBOJU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Jun 2020 10:09:20 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83AA2C08C5C0
        for <linux-trace-devel@vger.kernel.org>; Tue,  2 Jun 2020 07:09:19 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id v19so3087496wmj.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 02 Jun 2020 07:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AsL63vTHYo7MoccUS6BbmgMiws0ppX4pyfdzbqmX5y8=;
        b=r836OEo+gEEEDe56EaA269uM8CC2+fhqBAVYWIbBNIaePVMErO6SG4r/4l57a4RwIv
         4ufR8xpMWke5YPnxAYfUwTiE/s+8fmjDx6aLbIlS6vN7pdGjOIQzl1B8OPyw89eABOzn
         XYO47RmeXtWhJk7DhPtR/wekmxUA6nBxF9B97/fq0dRGc2+pDpNX2RH3UyovIUyIejcf
         w91XAReeYWpjhK/0Kd1cHDtj4XDQOUe374pq4/CVFUhuMcd0nG4e2/rDyfu33rpD9Gd7
         Mzd3JhBcm3iMjOWiIIylf84CYM1lUVlr427sDeRVEW1e6Ffn2xTkNbnnWY9bjK0qUeZ+
         yA+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AsL63vTHYo7MoccUS6BbmgMiws0ppX4pyfdzbqmX5y8=;
        b=g2RpUHOUeChhfZc3iJTnW+i5Cc6Ylin3zMq3xBofBuC6WN2WRZXFBrPNaAQ0Xh/jYq
         ZwQNs4DRrrzG4pbDghSkHcOOt3WLCaaCEPMTLOSHE/+oU4pSSQhVBxq86IGvpGnQfLlj
         toS+9MdlYr5apmZqRqaLS68AavYEEZrVpALNOs0MRQMxQOQGOXDjeavTGvJ+2df9lXv/
         uAZBUnE0KtFuPb5uA2mg8WrZ5sAizvxd66i4WXaJeeF+leda1VN9QUqcgTuIfgt+o82b
         QAadMklOsJw7YIOPp1Hi5sTxAcotRoM2TYFIYvxaeeIWYM3EbRRcvZ2exUaZP/Eu0apA
         EJzg==
X-Gm-Message-State: AOAM5302KFvXXqunQEQcPFsgz+oXpOdUvqw0KQCsx9n6o4lu0m5VMy+T
        iHbAC8uDTBquql45smKrp0m1uSHz09M=
X-Google-Smtp-Source: ABdhPJyyf993a6d18k9RlCYSEIQhJ8QSSEz7WQjgS51z35ENMrLPJ3HbJpUOHmjiQws+3zx5uy7gEw==
X-Received: by 2002:a1c:a74f:: with SMTP id q76mr4589815wme.65.1591106958055;
        Tue, 02 Jun 2020 07:09:18 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w3sm3849551wmg.44.2020.06.02.07.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 07:09:17 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 2/3] trace-cmd: Add new subcommand "set"
Date:   Tue,  2 Jun 2020 17:09:11 +0300
Message-Id: <20200602140912.78031-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200602140912.78031-1-tz.stoyanov@gmail.com>
References: <20200602140912.78031-1-tz.stoyanov@gmail.com>
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
 tracecmd/trace-record.c        | 61 ++++++++++++++++++++++++++++------
 tracecmd/trace-usage.c         | 35 +++++++++++++++++++
 4 files changed, 89 insertions(+), 10 deletions(-)

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
index f345c6d6..d5515c52 100644
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
@@ -1598,7 +1600,8 @@ static void run_cmd(enum trace_type type, const char *user, int argc, char **arg
 		/* child */
 		update_task_filter();
 		tracecmd_enable_tracing();
-		if (type != TRACE_TYPE_START)
+		if (type != TRACE_TYPE_START &&
+		    type != TRACE_TYPE_SET)
 			enable_ptrace();
 		/*
 		 * If we are using stderr for stdout, switch
@@ -1620,7 +1623,7 @@ static void run_cmd(enum trace_type type, const char *user, int argc, char **arg
 			die("Failed to exec %s", argv[0]);
 		}
 	}
-	if (type & TRACE_TYPE_START)
+	if (type & (TRACE_TYPE_START | TRACE_TYPE_SET))
 		exit(0);
 	if (do_ptrace) {
 		ptrace_attach(NULL, pid);
@@ -5722,6 +5725,7 @@ static void init_common_record_context(struct common_record_context *ctx,
 
 #define IS_EXTRACT(ctx) ((ctx)->curr_cmd == CMD_extract)
 #define IS_START(ctx) ((ctx)->curr_cmd == CMD_start)
+#define IS_CMDSET(ctx) ((ctx)->curr_cmd == CMD_set)
 #define IS_STREAM(ctx) ((ctx)->curr_cmd == CMD_stream)
 #define IS_PROFILE(ctx) ((ctx)->curr_cmd == CMD_profile)
 #define IS_RECORD(ctx) ((ctx)->curr_cmd == CMD_record)
@@ -5814,6 +5818,9 @@ static void parse_record_options(int argc,
 
 	init_common_record_context(ctx, curr_cmd);
 
+	if (IS_CMDSET(ctx))
+		keep = 1;
+
 	for (;;) {
 		int option_index = 0;
 		int ret;
@@ -5865,6 +5872,7 @@ static void parse_record_options(int argc,
 			usage(argv);
 			break;
 		case 'a':
+			cmd_check_die(ctx, CMD_set, *(argv+1), "-a");
 			if (IS_EXTRACT(ctx)) {
 				add_all_instances();
 			} else {
@@ -5942,6 +5950,7 @@ static void parse_record_options(int argc,
 			filter_task = 1;
 			break;
 		case 'G':
+			cmd_check_die(ctx, CMD_set, *(argv+1), "-G");
 			ctx->global = 1;
 			break;
 		case 'P':
@@ -6017,6 +6026,7 @@ static void parse_record_options(int argc,
 			ctx->disable = 1;
 			break;
 		case 'o':
+			cmd_check_die(ctx, CMD_set, *(argv+1), "-o");
 			if (IS_RECORD_AGENT(ctx))
 				die("-o incompatible with agent recording");
 			if (host)
@@ -6054,10 +6064,12 @@ static void parse_record_options(int argc,
 			save_option(ctx->instance, "stacktrace");
 			break;
 		case 'H':
+			cmd_check_die(ctx, CMD_set, *(argv+1), "-H");
 			add_hook(ctx->instance, optarg);
 			ctx->events = 1;
 			break;
 		case 's':
+			cmd_check_die(ctx, CMD_set, *(argv+1), "-s");
 			if (IS_EXTRACT(ctx)) {
 				if (optarg)
 					usage(argv);
@@ -6069,15 +6081,18 @@ static void parse_record_options(int argc,
 			sleep_time = atoi(optarg);
 			break;
 		case 'S':
+			cmd_check_die(ctx, CMD_set, *(argv+1), "-S");
 			ctx->manual = 1;
 			/* User sets events for profiling */
 			if (!event)
 				ctx->events = 0;
 			break;
 		case 'r':
+			cmd_check_die(ctx, CMD_set, *(argv+1), "-r");
 			rt_prio = atoi(optarg);
 			break;
 		case 'N':
+			cmd_check_die(ctx, CMD_set, *(argv+1), "-N");
 			if (!IS_RECORD(ctx))
 				die("-N only available with record");
 			if (IS_RECORD_AGENT(ctx))
@@ -6097,6 +6112,7 @@ static void parse_record_options(int argc,
 			ctx->instance->cpumask = alloc_mask_from_hex(ctx->instance, optarg);
 			break;
 		case 't':
+			cmd_check_die(ctx, CMD_set, *(argv+1), "-t");
 			if (IS_EXTRACT(ctx))
 				ctx->topt = 1; /* Extract top instance also */
 			else
@@ -6114,6 +6130,7 @@ static void parse_record_options(int argc,
 				ctx->instance->flags |= BUFFER_FL_PROFILE;
 			break;
 		case 'k':
+			cmd_check_die(ctx, CMD_set, *(argv+1), "-k");
 			keep = 1;
 			break;
 		case 'i':
@@ -6126,9 +6143,11 @@ static void parse_record_options(int argc,
 			break;
 		case OPT_procmap:
 			cmd_check_die(ctx, CMD_start, *(argv+1), "--proc-map");
+			cmd_check_die(ctx, CMD_set, *(argv+1), "--proc-map");
 			ctx->instance->get_procmap = 1;
 			break;
 		case OPT_date:
+			cmd_check_die(ctx, CMD_set, *(argv+1), "--date");
 			ctx->date = 1;
 			if (ctx->data_flags & DATA_FL_OFFSET)
 				die("Can not use both --date and --ts-offset");
@@ -6138,12 +6157,15 @@ static void parse_record_options(int argc,
 			func_stack = 1;
 			break;
 		case OPT_nosplice:
+			cmd_check_die(ctx, CMD_set, *(argv+1), "--nosplice");
 			recorder_flags |= TRACECMD_RECORD_NOSPLICE;
 			break;
 		case OPT_nofifos:
+			cmd_check_die(ctx, CMD_set, *(argv+1), "--nofifos");
 			no_fifos = true;
 			break;
 		case OPT_profile:
+			cmd_check_die(ctx, CMD_set, *(argv+1), "--profile");
 			handle_init = trace_init_profile;
 			ctx->instance->flags |= BUFFER_FL_PROFILE;
 			ctx->events = 1;
@@ -6157,9 +6179,11 @@ static void parse_record_options(int argc,
 			dup2(2, 1);
 			break;
 		case OPT_bycomm:
+			cmd_check_die(ctx, CMD_set, *(argv+1), "--by-comm");
 			trace_profile_set_merge_like_comms();
 			break;
 		case OPT_tsoffset:
+			cmd_check_die(ctx, CMD_set, *(argv+1), "--ts-offset");
 			ctx->date2ts = strdup(optarg);
 			if (ctx->data_flags & DATA_FL_DATE)
 				die("Can not use both --date and --ts-offset");
@@ -6175,6 +6199,7 @@ static void parse_record_options(int argc,
 			ctx->saved_cmdlines_size = atoi(optarg);
 			break;
 		case OPT_no_filter:
+			cmd_check_die(ctx, CMD_set, *(argv+1), "--no-filter");
 			no_filter = true;
 			break;
 		case OPT_debug:
@@ -6188,6 +6213,7 @@ static void parse_record_options(int argc,
 			ctx->filtered = 0;
 			break;
 		case OPT_tsyncinterval:
+			cmd_check_die(ctx, CMD_set, *(argv+1), "--tsync-interval");
 			top_instance.tsync.loop_interval = atoi(optarg);
 			guest_sync_set = true;
 			break;
@@ -6253,8 +6279,8 @@ static void parse_record_options(int argc,
 		}
 	}
 
-	if (do_ptrace && IS_START(ctx))
-		die("ptrace not supported with command start");
+	if (do_ptrace && (IS_START(ctx) || IS_CMDSET(ctx)))
+		die("ptrace not supported with command %s", *(argv+1));
 
 	for_all_instances(instance) {
 		if (instance->get_procmap && !instance->nr_filter_pids) {
@@ -6277,7 +6303,8 @@ static enum trace_type get_trace_cmd_type(enum trace_cmd cmd)
 		{CMD_extract, TRACE_TYPE_EXTRACT},
 		{CMD_profile, TRACE_TYPE_STREAM},
 		{CMD_start, TRACE_TYPE_START},
-		{CMD_record_agent, TRACE_TYPE_RECORD}
+		{CMD_record_agent, TRACE_TYPE_RECORD},
+		{CMD_set, TRACE_TYPE_SET}
 	};
 
 	for (int i = 0; i < ARRAY_SIZE(trace_type_per_command); i++) {
@@ -6354,8 +6381,10 @@ static void record_trace(int argc, char **argv,
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
@@ -6383,7 +6412,8 @@ static void record_trace(int argc, char **argv,
 
 	if (!is_guest(ctx->instance))
 		fset = set_ftrace(!ctx->disable, ctx->total_disable);
-	tracecmd_disable_all_tracing(1);
+	if (!IS_CMDSET(ctx))
+		tracecmd_disable_all_tracing(1);
 
 	for_all_instances(instance)
 		set_clock(instance);
@@ -6435,9 +6465,11 @@ static void record_trace(int argc, char **argv,
 		bool wait_indefinitely = false;
 
 		update_task_filter();
-		tracecmd_enable_tracing();
 
-		if (type & TRACE_TYPE_START)
+		if (!IS_CMDSET(ctx))
+			tracecmd_enable_tracing();
+
+		if (type & (TRACE_TYPE_START | TRACE_TYPE_SET))
 			exit(0);
 
 		/* We don't ptrace ourself */
@@ -6498,6 +6530,15 @@ void trace_start(int argc, char **argv)
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
index 58bca9e4..0c0e12f4 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -65,6 +65,41 @@ static struct usage_help usage_help[] = {
 		"               If 0 is specified, no loop is performed - timestamps offset is calculated only twice,"
 		"                                                         at the beginnig and at the end of the trace\n"
 	},
+	{
+		"set",
+		"set a ftarce configuration parameter",
+		" %s set [-v][-e event [-f filter]][-p plugin][-F][-d][-D] \\\n"
+		"           [-q][-s usecs][-O option ][-l func][-g func][-n func] \\\n"
+		"           [-P pid][-b size][-B buf][-m max][-C clock][command ...]\n"
+		"          -e enable event\n"
+		"          -f filter for previous -e event\n"
+		"          -R trigger for previous -e event\n"
+		"          -p set ftrace plugin\n"
+		"          -P set PIDs to be traced\n"
+		"          -c also trace the children of -F (or -P if kernel supports it)\n"
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
+		"          --cmdlines-size change kernel saved_cmdlines_size\n"
+		"          --user execute the specified [command ...] as given user\n"
+	},
 	{
 		"start",
 		"start tracing without recording into a file",
-- 
2.26.2


Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79BDEC433E3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6721761A2D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbhCYGlg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 02:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbhCYGlE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 02:41:04 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8522BC06174A
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:41:04 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id b9so1087963wrt.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oQOA0gjf35WeJ2NhvqG2ZfoRPZU5Ku7HjPjiQZ6qxMk=;
        b=ev38YBL4Wgr69/uGpDshi9F1ibZ810yNFjQnluuQRCA8XXh7XOFc4AEtzqBj8lw+3c
         2bOy9xq8PbK8URkMvxKkSRdTkEgl1tbLlrkN+ws1DuUxhn8ZYMdOo3v+ASPn91dfZwbT
         BU/5t9DsOiIo7FICh7NGIHJ+OaZDj38P0OHGDC554pp/+UPzww51Q2uDRyXLtghC1jz+
         O5gNeuNZQEP53u0+z3WOY8jWifTQ1y3XYbiTc0CV08JDv4gtgcgdEbhphfoR6/VS0PWl
         w1oK2gR/fcpP2FIECC0c9bXgPTGzEYSQovv6Jq7r/3U9qwv3daD4VcVfsqUNIAHCh7QA
         zHnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oQOA0gjf35WeJ2NhvqG2ZfoRPZU5Ku7HjPjiQZ6qxMk=;
        b=flxMYAtDek2YKgtB73c3YjkUMrd05qrmsOefjgUy6zCN6LO95WXMteYnQhzMqyWjDP
         i/5RUQUS9m0I97VppYYdT470B70x9qcmOBszFd1XH06Vd2Wz7Jj+EFFuYNrwqDT3Eo3p
         /JDoA7p9TnJmvs7l9wByBfZi3YTJ9rWghyUm5or5b2icwOWgR7Xomrp607FlfMoGQUc3
         1ah8IFa6MjdxtLCFZWsZT3wH8cx86LwhVqTJ8D1wGKWutBsuWnq2bNInzBcj+aAadPNA
         Noouf89oaFPQHPmmtZ2e31Y9SrimjyQnL56aTZ6sA9L1cUqa+rBiIrbFQ4p6oWGmk8xV
         Ju+w==
X-Gm-Message-State: AOAM533ktlMVkYGRpDEZ/QcdGiy51eTAPWVFNLsGe+yCFlPN8mHEqNqM
        aN6J6YpEtjDf2Dh9cJaobrRIbJhv3y6R3A==
X-Google-Smtp-Source: ABdhPJzdABES/T34lnHezvX0fKTBzCy/pPtevKwDzOlhkeM7Bvnf8T6wGD5TV5vj0dLs38/RwQlKyg==
X-Received: by 2002:adf:e7c2:: with SMTP id e2mr7427377wrn.338.1616654463317;
        Wed, 24 Mar 2021 23:41:03 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e17sm6403259wra.65.2021.03.24.23.41.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 23:41:02 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 06/23] trace-cmd: Add new trace-cmd clock tsc2nsec
Date:   Thu, 25 Mar 2021 08:40:38 +0200
Message-Id: <20210325064055.539554-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325064055.539554-1-tz.stoyanov@gmail.com>
References: <20210325064055.539554-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new clock is added to "trace-cmd record" command:
 trace-cmd record -C tsc2nsec ...
which uses x86-tsc ftrace clock and converts the timestamps from tsc to
nanoseconds, using data from perf kernel interface.
A new options is added also:
 trace-cmd record --tsc2nsec ...
which does not change the current trace clock, just convert whatever it
is to nanoseconds, using the same data from perf kernel interface.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/include/trace-local.h |   7 ++
 tracecmd/trace-record.c        | 152 ++++++++++++++++++++++++++++++++-
 2 files changed, 155 insertions(+), 4 deletions(-)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 6e39d27d..7773e9fc 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -172,6 +172,7 @@ enum buffer_instance_flags {
 	BUFFER_FL_GUEST		= 1 << 2,
 	BUFFER_FL_AGENT		= 1 << 3,
 	BUFFER_FL_HAS_CLOCK	= 1 << 4,
+	BUFFER_FL_TSC2NSEC	= 1 << 5,
 };
 
 struct func_list {
@@ -199,6 +200,12 @@ struct filter_pids {
 	int exclude;
 };
 
+struct tsc_nsec {
+	int mult;
+	int shift;
+	unsigned long long offset;
+};
+
 struct buffer_instance {
 	struct buffer_instance	*next;
 	char			*name;
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index c7197ba0..49fa46d9 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -57,6 +57,8 @@
 #define MAX_LATENCY	"tracing_max_latency"
 #define STAMP		"stamp"
 #define FUNC_STACK_TRACE "func_stack_trace"
+#define TSC_CLOCK	"x86-tsc"
+#define TSCNSEC_CLOCK	"tsc2nsec"
 
 enum trace_type {
 	TRACE_TYPE_RECORD	= 1,
@@ -197,6 +199,7 @@ struct common_record_context {
 	const char *output;
 	char *date2ts;
 	char *user;
+	struct tsc_nsec tsc2nsec;
 	int data_flags;
 
 	int record_all;
@@ -4443,11 +4446,12 @@ static int find_ts(struct tep_event *event, struct tep_record *record,
 	return 0;
 }
 
-static unsigned long long find_time_stamp(struct tep_handle *tep)
+static unsigned long long find_time_stamp(struct tep_handle *tep,
+					  struct tracefs_instance *instance)
 {
 	unsigned long long ts = 0;
 
-	if (!tracefs_iterate_raw_events(tep, NULL, NULL, 0, find_ts, &ts))
+	if (!tracefs_iterate_raw_events(tep, instance, NULL, 0, find_ts, &ts))
 		return ts;
 
 	return 0;
@@ -4527,7 +4531,7 @@ static char *get_date_to_ts(void)
 		clock_gettime(CLOCK_REALTIME, &end);
 
 		tracecmd_disable_tracing();
-		ts = find_time_stamp(tep);
+		ts = find_time_stamp(tep, NULL);
 		if (!ts)
 			continue;
 
@@ -5388,6 +5392,7 @@ void init_top_instance(void)
 }
 
 enum {
+	OPT_tsc2nsec		= 240,
 	OPT_fork		= 241,
 	OPT_tsyncinterval	= 242,
 	OPT_user		= 243,
@@ -5711,6 +5716,61 @@ static bool clock_is_supported(struct tracefs_instance *instance, const char *cl
 	return ret != NULL;
 }
 
+#ifdef PERF
+static int get_tsc_nsec(int *shift, int *mult)
+{
+	static int cpu_shift, cpu_mult;
+	static int supported;
+	int cpus = tracecmd_count_cpus();
+	struct trace_perf perf;
+	int i;
+
+	if (supported)
+		goto out;
+
+	supported = -1;
+	if (trace_perf_init(&perf, 1, 0, getpid()))
+		return -1;
+	if (trace_perf_open(&perf))
+		return -1;
+	cpu_shift = perf.mmap->time_shift;
+	cpu_mult = perf.mmap->time_mult;
+	for (i = 1; i < cpus; i++) {
+		trace_perf_close(&perf);
+		if (trace_perf_init(&perf, 1, i, getpid()))
+			break;
+		if (trace_perf_open(&perf))
+			break;
+		if (perf.mmap->time_shift != cpu_shift ||
+		    perf.mmap->time_mult != cpu_mult) {
+			warning("Found different TSC multiplier and shift for CPU %d: %d;%d instead of %d;%d",
+				i, perf.mmap->time_mult, perf.mmap->time_shift, cpu_mult, cpu_shift);
+			break;
+		}
+	}
+	trace_perf_close(&perf);
+	if (i < cpus)
+		return -1;
+
+	supported = 1;
+out:
+	if (supported < 0)
+		return -1;
+
+	if (shift)
+		*shift = cpu_shift;
+	if (mult)
+		*mult = cpu_mult;
+
+	return 0;
+}
+#else
+static int get_tsc_nsec(int *shift, int *mult)
+{
+	return -1;
+}
+#endif
+
 static void parse_record_options(int argc,
 				 char **argv,
 				 enum trace_cmd curr_cmd,
@@ -5760,6 +5820,7 @@ static void parse_record_options(int argc,
 			{"module", required_argument, NULL, OPT_module},
 			{"tsync-interval", required_argument, NULL, OPT_tsyncinterval},
 			{"fork", no_argument, NULL, OPT_fork},
+			{"tsc2nsec", no_argument, NULL, OPT_tsc2nsec},
 			{NULL, 0, NULL, 0}
 		};
 
@@ -5905,7 +5966,21 @@ static void parse_record_options(int argc,
 			break;
 		case 'C':
 			check_instance_die(ctx->instance, "-C");
-			ctx->instance->clock = optarg;
+			if (strcmp(optarg, TSCNSEC_CLOCK) == 0) {
+				ret = get_tsc_nsec(&ctx->tsc2nsec.shift,
+						   &ctx->tsc2nsec.mult);
+				if (ret)
+					die("TSC to nanosecond is not supported");
+				ctx->instance->flags |= BUFFER_FL_TSC2NSEC;
+				ctx->instance->clock = TSC_CLOCK;
+			} else {
+				ctx->instance->clock = optarg;
+			}
+			if (!clock_is_supported(NULL, ctx->instance->clock))
+				die("Clock %s is not supported", ctx->instance->clock);
+			ctx->instance->clock = strdup(ctx->instance->clock);
+			if (!ctx->instance->clock)
+				die("Failed allocation");
 			ctx->instance->flags |= BUFFER_FL_HAS_CLOCK;
 			if (is_top_instance(ctx->instance))
 				guest_sync_set = true;
@@ -6160,6 +6235,13 @@ static void parse_record_options(int argc,
 				die("--fork option used for 'start' command only");
 			fork_process = true;
 			break;
+		case OPT_tsc2nsec:
+			ret = get_tsc_nsec(&ctx->tsc2nsec.shift,
+					   &ctx->tsc2nsec.mult);
+			if (ret)
+				die("TSC to nanosecond is not supported");
+			ctx->instance->flags |= BUFFER_FL_TSC2NSEC;
+			break;
 		case OPT_quiet:
 		case 'q':
 			quiet = true;
@@ -6307,6 +6389,65 @@ static bool has_local_instances(void)
 	return false;
 }
 
+/*
+ * Get the current clock value
+ */
+#define CLOCK_INST_NAME	"_clock_instance_"
+static unsigned long long get_clock_now(const char *clock)
+{
+	struct tracefs_instance *ts_instance = NULL;
+	unsigned long long ts = 0;
+	struct tep_handle *tep;
+	int tfd;
+	int ret;
+
+	/* Set up a tep to read the raw format */
+	tep = get_ftrace_tep();
+	if (!tep)
+		return 0;
+	ts_instance = tracefs_instance_create(CLOCK_INST_NAME);
+	if (!ts_instance)
+		goto out;
+	if (clock) {
+		ret = tracefs_instance_file_write(ts_instance, "trace_clock", clock);
+		if (ret < strlen(clock))
+			goto out;
+	}
+	tfd = tracefs_instance_file_open(ts_instance, "trace_marker", O_WRONLY);
+	if (tfd < 0)
+		goto out;
+	tracefs_trace_on(ts_instance);
+	ret = write(tfd, STAMP, 5);
+	tracefs_trace_off(ts_instance);
+	ts = find_time_stamp(tep, ts_instance);
+	close(tfd);
+
+out:
+	if (ts_instance) {
+		if (tracefs_instance_is_new(ts_instance))
+			tracefs_instance_destroy(ts_instance);
+		tracefs_instance_free(ts_instance);
+	}
+	tep_free(tep);
+
+	return ts;
+}
+
+static void get_tsc_offset(struct common_record_context *ctx)
+{
+	struct buffer_instance *instance;
+
+	for_all_instances(instance) {
+		if (is_guest(instance) || !instance->clock)
+			continue;
+
+		ctx->tsc2nsec.offset = get_clock_now(instance->clock);
+		return;
+	}
+
+	ctx->tsc2nsec.offset = get_clock_now(NULL);
+}
+
 /*
  * This function contains common code for the following commands:
  * record, start, stream, profile.
@@ -6365,6 +6506,9 @@ static void record_trace(int argc, char **argv,
 	for_all_instances(instance)
 		set_clock(instance);
 
+	if (ctx->tsc2nsec.mult)
+		get_tsc_offset(ctx);
+
 	/* Record records the date first */
 	if (ctx->date &&
 	    ((IS_RECORD(ctx) && has_local_instances()) || IS_RECORD_AGENT(ctx)))
-- 
2.30.2


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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85D87C433E4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 13:05:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 675CE619E5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 13:05:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234152AbhCXNEf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 09:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234190AbhCXNE3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 09:04:29 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C79C061763
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 06:04:28 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id x16so24366051wrn.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 06:04:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K2T4uniV500/F11/PZ5OwvG4e2YWyyjPFFVXLLHfb4s=;
        b=L9jH6AKzc/4dAQnN0vInu2Z5yJfjm4FSJTzeQuGGOiWWDHicmr+fxgnKcRgFSob05D
         4eIEKm5RehM5qSbI5SzHkD6JSvkqLwInRocGCcQXEFr2O/FDfnu+HhfWGWlPFfZZgo4o
         DD0C979d8BdkvEPFHjORtRkQ1ym03Ot55VMC//RpVETIj3YqTAU0pIcc7/Adzwp5YvDF
         zfLm8kgXuC5R6rCQTpcRu7+W9IdM2OMFWuUbhxQXWebzLRdGtMXkFUZ+yv8ZkHEqkae3
         DzgPc0LksABCCHWpG9SnWImLWU+Rrq389EnJVvNIrCaE0vJVcloUNtpnxKHgZx4zJ9Mx
         UhlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K2T4uniV500/F11/PZ5OwvG4e2YWyyjPFFVXLLHfb4s=;
        b=pKLw8Cm4tfbuWb+3YiNnX5Q1L1ePMLACBkaQgClfRYcl1RQWSwiuSQNRRzM25YtCCJ
         0rCXI36TjvXctwNxp4bXT/9L1ogG0Q46fTZzdk01y0YP1ZMvkGWcR7QaX8AF06Du6cIG
         15Xu0QqPvttlp4XxfJ0qIgZPp8ry8b3iya7oOczpgP08Sj8yCMcDU/3oUbaWwGt2/Mly
         S3xaS3g5uaO1LV9B6qerKoopKOFCTSjcYH0rYXVBLicMYfFOsOpoHKXsO/s8hjghzsjp
         eBBteu4VUhQVHuzI5OurxaKlVAX5IVQiM6HB7OrTc9V7hd6+xuNk8Bxxjdt6C9eJPqy/
         oOQA==
X-Gm-Message-State: AOAM532GJOhsO+q41kKMFb/teiRuQpXBiuwg62/Kzo/2ZTWsuPApFJQP
        ciN1q9+O5JzqiBBmkPqJyKg=
X-Google-Smtp-Source: ABdhPJwjNSgXngV2NJyi6Ys6nI3UZJAchxe5RjN57ILflAQ8qx8HjjsLHPI9KBdphwjCtqZD8l+e8w==
X-Received: by 2002:adf:e5c8:: with SMTP id a8mr3459303wrn.352.1616591067262;
        Wed, 24 Mar 2021 06:04:27 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w11sm3034919wrv.88.2021.03.24.06.04.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 06:04:26 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 06/23] trace-cmd: Add new trace-cmd clock tsc2nsec
Date:   Wed, 24 Mar 2021 15:04:01 +0200
Message-Id: <20210324130418.436206-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210324130418.436206-1-tz.stoyanov@gmail.com>
References: <20210324130418.436206-1-tz.stoyanov@gmail.com>
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
 tracecmd/trace-record.c        | 146 ++++++++++++++++++++++++++++++++-
 2 files changed, 149 insertions(+), 4 deletions(-)

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
index 5f7f5b3d..2a594736 100644
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
@@ -198,6 +200,7 @@ struct common_record_context {
 	char *date2ts;
 	char *user;
 	int data_flags;
+	struct tsc_nsec tsc2nsec;
 
 	int record_all;
 	int total_disable;
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
@@ -5710,6 +5715,61 @@ static bool clock_is_supported(struct tracefs_instance *instance, char *clock)
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
@@ -5759,6 +5819,7 @@ static void parse_record_options(int argc,
 			{"module", required_argument, NULL, OPT_module},
 			{"tsync-interval", required_argument, NULL, OPT_tsyncinterval},
 			{"fork", no_argument, NULL, OPT_fork},
+			{"tsc2nsec", no_argument, NULL, OPT_tsc2nsec},
 			{NULL, 0, NULL, 0}
 		};
 
@@ -5904,7 +5965,15 @@ static void parse_record_options(int argc,
 			break;
 		case 'C':
 			check_instance_die(ctx->instance, "-C");
-			ctx->instance->clock = optarg;
+			if (!strncmp(optarg, TSCNSEC_CLOCK, strlen(TSCNSEC_CLOCK))) {
+				ret = get_tsc_nsec(&ctx->tsc2nsec.shift,
+						   &ctx->tsc2nsec.mult);
+				if (ret || !clock_is_supported(NULL, TSC_CLOCK))
+					die("Clock %s is not supported", optarg);
+				ctx->instance->flags |= BUFFER_FL_TSC2NSEC;
+				ctx->instance->clock = strdup(TSC_CLOCK);
+			} else
+				ctx->instance->clock = optarg;
 			ctx->instance->flags |= BUFFER_FL_HAS_CLOCK;
 			if (is_top_instance(ctx->instance))
 				guest_sync_set = true;
@@ -6159,6 +6228,13 @@ static void parse_record_options(int argc,
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
@@ -6306,6 +6382,65 @@ static bool has_local_instances(void)
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
+			return;
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
@@ -6364,6 +6499,9 @@ static void record_trace(int argc, char **argv,
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


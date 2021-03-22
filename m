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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE49FC433DB
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 10:00:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E6EA61974
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 10:00:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhCVJ75 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Mar 2021 05:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbhCVJ7w (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Mar 2021 05:59:52 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7164DC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Mar 2021 02:59:52 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id kt15so10700202ejb.12
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Mar 2021 02:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jXq6CuA445tJvG+aV9fh8vmPxfC4nEbNk5861K8zwck=;
        b=FLpubd8aedv6Ud0v6AVY/oQeMCsGb613KUjDxazRMmyh8e2j2cs+6LGlkGI9picF/M
         rLA8y1UMZEUTHyXsHHMZlZi84SHw412DhY0nmaASDKjUKZTDDlv5vWTjGC1wbOyZmNq6
         q5SHiAnOaYBjJDrhCV2qmJbokPt41WfDufLSY2wz2AW1k+hP2WoSVFJDruyTUb2YvzI6
         sTggMuRHFxX4fV3eeshCIR+BvoY8/C0ctE7v4ZKPFDbhGvU2f+mj/Yz73CsJxe+s6p7F
         8uPh26HcYXzGScW/wdRN7ujCyZTSh4mG+MFShMSl81l2d+JpLjgAN29JbEiyJkHSNFxv
         mK1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jXq6CuA445tJvG+aV9fh8vmPxfC4nEbNk5861K8zwck=;
        b=LfeyZODT13GGDFP9YqMmyUnLFZb0dAn7BQDCoQl+aPQuZNrRu7w/gXh1nABVWpY8wy
         ZVq620HQ/TeoL9Fw9NsqF3JaRJzmU+gGhnXqlMcvbK/WqfmdvzENzgkAs/Usmb73x94f
         ntTMyD/pwLhDSrS0MNtNWe/QwnqgnnNSPEjQmUrIVw2cQ1OGxMbawA5P8vzNAjldCPu/
         eHbSG3yjHw7D8l/9EDynkQvjZVqjeAwHmUQliRipjQJ05zY7YCflQhNXOaeiD3ON+1Ej
         wTkjVxq1Gq0TTaJEZx1a7hCl74SIa2541rY0lqt89yQ8ZWB1mx4mO6ccQ0G9GFD6XDnk
         +5Yw==
X-Gm-Message-State: AOAM532TQYCtQNhkQu4O38TGHDXsLJvYjc+I9awITfjDRsq1RnNKHS2A
        Jmdep/0wXHhh/IX7HHHXhos=
X-Google-Smtp-Source: ABdhPJyoYyUTPakyME0xTttim4kjsojRuQAjvi3iniS1uq2y4WhoIB29K/yob82Wsxj1hS4+OZtmIA==
X-Received: by 2002:a17:906:2551:: with SMTP id j17mr18441992ejb.441.1616407191186;
        Mon, 22 Mar 2021 02:59:51 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g26sm9288424ejz.70.2021.03.22.02.59.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 02:59:50 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 04/18] trace-cmd: Add new trace-cmd clock tsc2nsec
Date:   Mon, 22 Mar 2021 11:59:31 +0200
Message-Id: <20210322095945.259300-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210322095945.259300-1-tz.stoyanov@gmail.com>
References: <20210322095945.259300-1-tz.stoyanov@gmail.com>
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
 tracecmd/trace-record.c        | 217 +++++++++++++++++++++++++++++----
 2 files changed, 197 insertions(+), 27 deletions(-)

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
index a0eb0385..38edea2c 100644
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
@@ -4459,52 +4463,59 @@ static char *read_top_file(char *file, int *psize)
 	return tracefs_instance_file_read(top_instance.tracefs, file, psize);
 }
 
+static struct tep_handle *get_ftrace_tep(void)
+{
+	const char *systems[] = {"ftrace", NULL};
+	struct tep_handle *tep;
+	char *buf;
+	int size;
+	int ret;
+
+	tep = tracefs_local_events_system(NULL, systems);
+	if (!tep)
+		return NULL;
+	tep_set_file_bigendian(tep, tracecmd_host_bigendian());
+	buf = read_top_file("events/header_page", &size);
+	if (!buf)
+		goto error;
+	ret = tep_parse_header_page(tep, buf, size, sizeof(unsigned long));
+	free(buf);
+	if (ret < 0)
+		goto error;
+
+	return tep;
+
+error:
+	tep_free(tep);
+	return NULL;
+}
+
 /*
  * Try to write the date into the ftrace buffer and then
  * read it back, mapping the timestamp to the date.
  */
 static char *get_date_to_ts(void)
 {
-	const char *systems[] = {"ftrace", NULL};
+	struct tep_handle *tep;
 	unsigned long long min = -1ULL;
 	unsigned long long diff;
 	unsigned long long stamp;
 	unsigned long long min_stamp;
 	unsigned long long min_ts;
 	unsigned long long ts;
-	struct tep_handle *tep;
 	struct timespec start;
 	struct timespec end;
 	char *date2ts = NULL;
-	char *path;
-	char *buf;
-	int size;
 	int tfd;
-	int ret;
 	int i;
 
 	/* Set up a tep to read the raw format */
-	tep = tracefs_local_events_system(NULL, systems);
+	tep = get_ftrace_tep();
 	if (!tep) {
 		warning("failed to alloc tep, --date ignored");
 		return NULL;
 	}
-
-	tep_set_file_bigendian(tep, tracecmd_host_bigendian());
-
-	buf = read_top_file("events/header_page", &size);
-	if (!buf)
-		goto out_pevent;
-	ret = tep_parse_header_page(tep, buf, size, sizeof(unsigned long));
-	free(buf);
-	if (ret < 0) {
-		warning("Can't parse header page, --date ignored");
-		goto out_pevent;
-	}
-
-	path = tracefs_get_tracing_file("trace_marker");
-	tfd = open(path, O_WRONLY);
-	tracefs_put_tracing_file(path);
+	tfd = tracefs_instance_file_open(NULL, "trace_marker", O_WRONLY);
 	if (tfd < 0) {
 		warning("Can not open 'trace_marker', --date ignored");
 		goto out_pevent;
@@ -4520,7 +4531,7 @@ static char *get_date_to_ts(void)
 		clock_gettime(CLOCK_REALTIME, &end);
 
 		tracecmd_disable_tracing();
-		ts = find_time_stamp(tep);
+		ts = find_time_stamp(tep, NULL);
 		if (!ts)
 			continue;
 
@@ -5381,6 +5392,7 @@ void init_top_instance(void)
 }
 
 enum {
+	OPT_tsc2nsec		= 240,
 	OPT_fork		= 241,
 	OPT_tsyncinterval	= 242,
 	OPT_user		= 243,
@@ -5676,6 +5688,78 @@ check_instance_die(struct buffer_instance *instance, char *param)
 		    tracefs_instance_get_name(instance->tracefs), param);
 }
 
+static bool clock_is_supported(struct tracefs_instance *instance, char *clock)
+{
+	char *all_clocks = NULL;
+	char *ret = NULL;
+
+	all_clocks  = tracefs_instance_file_read(instance, "trace_clock", NULL);
+	if (!all_clocks)
+		return false;
+
+	ret = strstr(all_clocks, clock);
+	free(all_clocks);
+
+	if (ret)
+		return true;
+	return false;
+}
+
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
@@ -5725,6 +5809,7 @@ static void parse_record_options(int argc,
 			{"module", required_argument, NULL, OPT_module},
 			{"tsync-interval", required_argument, NULL, OPT_tsyncinterval},
 			{"fork", no_argument, NULL, OPT_fork},
+			{"tsc2nsec", no_argument, NULL, OPT_tsc2nsec},
 			{NULL, 0, NULL, 0}
 		};
 
@@ -5870,7 +5955,15 @@ static void parse_record_options(int argc,
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
@@ -6125,6 +6218,13 @@ static void parse_record_options(int argc,
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
@@ -6272,6 +6372,66 @@ static bool has_local_instances(void)
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
+	int tfd = -1;
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
+
+out:
+	if (tfd >= 0)
+		close(tfd);
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
@@ -6330,6 +6490,9 @@ static void record_trace(int argc, char **argv,
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


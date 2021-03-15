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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16329C433DB
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Mar 2021 06:19:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D273264E4A
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Mar 2021 06:19:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbhCOGS6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Mar 2021 02:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbhCOGSj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Mar 2021 02:18:39 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07568C061574
        for <linux-trace-devel@vger.kernel.org>; Sun, 14 Mar 2021 23:18:39 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id si25so8489878ejb.1
        for <linux-trace-devel@vger.kernel.org>; Sun, 14 Mar 2021 23:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fdjwE63HOvlmwb4iDR+pNauZbEE7zxvJz6kg+fL8rAM=;
        b=gBsVxsEEPHWlyHkth5bOmt3u1ZL7b+SVmcV1fHhLv/R/D5irYAetGZfwwdfk5l5ZCZ
         pHE4ZRANwn94shZFszYm4HFDrG0h3ClWQ91HtEb7KvdEeefuxNkgqf6xi1VKmuvIb34h
         rv+HUnxpYGwQLs/OtkYgpxWCAfQ4uqXxzbq6qRdDNEx7iUiZePqNxf3PWhw9duTaTK2v
         IAbtgPAPh4aoHpt8fB1aw3mcZx04kG9AJbijs7bp1vZCcbRMvHiuh73mkI4UZ90DuOAG
         weJiBSyvw/yH96BCSWGiFPUj5/6Iup10f/p7HOSk61mb74RzRXseg60M8N/BA5ys710J
         Wu3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fdjwE63HOvlmwb4iDR+pNauZbEE7zxvJz6kg+fL8rAM=;
        b=XKWonQf9e92bRpxMeVqH95i1JFqJxYJEHqzPQfow9oAGOby+IrxO12xL1xottVGWkX
         y7qbOIyocebrypKiRYm01617XwQFwbtR742DYX36ymkYaz7bXHjOCgT+Yn/4XT4mEg3w
         grSGZA2deDdsCt+OwvN4TTE9QOtD1HzHIdUhxZiCK21Fn2p5mEYR67hlyHMMUkEsBrvs
         Gzzak8Il0BGWx3GalMfxlnb7E9XjNrrcHGvx+q3ko7D/hqG5BymDAmoxvjRdAH2E+5RB
         rFKv6tgqayC6GepPkCT24iglxQ/QfJYJ/JM5sW5+gOeTzA2iJWdXcckAHyo0nyVEK53L
         nqzA==
X-Gm-Message-State: AOAM531MN75vzTxvF+IuJbjvaYEIAME1NUMkF//ySEbrkV/g5WH8KOjl
        kv1QuSvaw7Nb29VojvkBqOI=
X-Google-Smtp-Source: ABdhPJw4oY+YCSHw1NJzbDk0mBCv3oQf/3bDOPCIQmITn8k64fPWFlgoLRVcVL9msL72KhmQH19NjQ==
X-Received: by 2002:a17:906:414e:: with SMTP id l14mr21011556ejk.406.1615789117827;
        Sun, 14 Mar 2021 23:18:37 -0700 (PDT)
Received: from localhost.localdomain ([130.185.229.134])
        by smtp.gmail.com with ESMTPSA id t6sm7468478edq.48.2021.03.14.23.18.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 23:18:37 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 02/12] trace-cmd: Add logic for TSC to nanosecond conversion
Date:   Mon, 15 Mar 2021 08:18:22 +0200
Message-Id: <20210315061832.168495-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210315061832.168495-1-tz.stoyanov@gmail.com>
References: <20210315061832.168495-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added new logic to get multiplier and shift for converting TSC trace clock
to nanoseconds, using perf kernel interface. The new logic is used only in
host - guest tracing use case, when the user did not specify any tracing
clock and KVM time sync plugin is available. Then the x86-tsc clock is
auto selected for the current tracing session. There is one limitation -
per CPU multiplier or shift is not supported.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/include/trace-local.h |   7 ++
 tracecmd/trace-record.c        | 124 ++++++++++++++++++++++++++-------
 2 files changed, 107 insertions(+), 24 deletions(-)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 6e39d27d..8a88ab9c 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -199,6 +199,12 @@ struct filter_pids {
 	int exclude;
 };
 
+struct tsc_nsec {
+	int mult;
+	int shift;
+	int offset;
+};
+
 struct buffer_instance {
 	struct buffer_instance	*next;
 	char			*name;
@@ -234,6 +240,7 @@ struct buffer_instance {
 	int			get_procmap;
 
 	const char		*clock;
+	struct tsc_nsec		tsc2nsec;
 	unsigned int		*client_ports;
 
 	struct trace_seq	*s_save;
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index a0eb0385..117e4f17 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -57,6 +57,7 @@
 #define MAX_LATENCY	"tracing_max_latency"
 #define STAMP		"stamp"
 #define FUNC_STACK_TRACE "func_stack_trace"
+#define TSC_CLOCK	"x86-tsc"
 
 enum trace_type {
 	TRACE_TYPE_RECORD	= 1,
@@ -4104,6 +4105,7 @@ enum {
 	DATA_FL_NONE		= 0,
 	DATA_FL_DATE		= 1,
 	DATA_FL_OFFSET		= 2,
+	DATA_FL_GUEST		= 4,
 };
 
 static void add_options(struct tracecmd_output *handle, struct common_record_context *ctx)
@@ -5676,6 +5678,100 @@ check_instance_die(struct buffer_instance *instance, char *param)
 		    tracefs_instance_get_name(instance->tracefs), param);
 }
 
+static int get_tsc_nsec(int *shift, int *mult, int *offset)
+{
+	int cpus = tracecmd_count_cpus();
+	int cpu_shift, cpu_mult, cpu_offset;
+	struct trace_perf perf;
+	int ret;
+	int i;
+
+	ret = trace_perf_init(&perf, 1, 0, getpid());
+	if (!ret)
+		ret = trace_perf_open(&perf);
+	if (ret)
+		return ret;
+	cpu_shift = perf.mmap->time_shift;
+	cpu_mult = perf.mmap->time_mult;
+	/* ToDo set the offset, should we use perf.mmap->time_offset ? */
+	cpu_offset = 0;
+	for (i = 1; i < cpus; i++) {
+		trace_perf_close(&perf);
+		ret = trace_perf_init(&perf, 1, i, getpid());
+		if (!ret)
+			ret = trace_perf_open(&perf);
+		if (ret)
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
+	*shift = cpu_shift;
+	*mult = cpu_mult;
+	*offset = cpu_offset;
+
+	return 0;
+}
+
+static void set_vsync_clock(void)
+{
+	const char *clock = top_instance.clock;
+	struct buffer_instance *instance;
+	bool tsc2nsec = false;
+	int shift, mult, offset;
+
+	/*
+	 * If no clock is specified for the top trace instance AND
+	 * KVM time sync protocol is available AND
+	 * TSC to nsec multiplier and shift are available:
+	 * force using the x86-tsc clock for this host-guest tracing session
+	 * and store TSC to nsec multiplier and shift.
+	 */
+	if (!clock && tsync_proto_is_supported("kvm") &&
+	    !get_tsc_nsec(&shift, &mult, &offset) && mult) {
+		top_instance.clock = strdup(TSC_CLOCK);
+		if (!top_instance.clock)
+			die("Could not allocate top instance clock");
+		clock = top_instance.clock;
+		top_instance.tsc2nsec.mult = mult;
+		top_instance.tsc2nsec.shift = shift;
+		top_instance.tsc2nsec.offset = offset;
+		tsc2nsec = true;
+	}
+
+	if (!clock && !top_instance.tsync_loop_interval)
+		return;
+	for_all_instances(instance) {
+		if (clock) {
+			/* use the same clock in all tracing peers */
+			if (is_guest(instance) &&
+			    !(instance->flags & BUFFER_FL_HAS_CLOCK)) {
+				add_argv(instance,
+					 (char *)top_instance.clock, true);
+				add_argv(instance, "-C", true);
+				if (!instance->clock) {
+					instance->clock = strdup((char *)top_instance.clock);
+					if (!instance->clock)
+						die("Could not allocate instance clock");
+				}
+				if (tsc2nsec) {
+					instance->tsc2nsec.mult = mult;
+					instance->tsc2nsec.shift = shift;
+					instance->tsc2nsec.offset = offset;
+				}
+			}
+		}
+		instance->tsync_loop_interval = top_instance.tsync_loop_interval;
+	}
+}
+
 static void parse_record_options(int argc,
 				 char **argv,
 				 enum trace_cmd curr_cmd,
@@ -5691,7 +5787,6 @@ static void parse_record_options(int argc,
 	int name_counter = 0;
 	int negative = 0;
 	struct buffer_instance *instance, *del_list = NULL;
-	bool guest_sync_set = false;
 	int do_children = 0;
 	int fpids_count = 0;
 
@@ -5825,6 +5920,7 @@ static void parse_record_options(int argc,
 			ctx->instance->port = port;
 			ctx->instance->name = name;
 			add_instance(ctx->instance, 0);
+			ctx->data_flags |= DATA_FL_GUEST;
 			break;
 		}
 		case 'F':
@@ -5872,8 +5968,6 @@ static void parse_record_options(int argc,
 			check_instance_die(ctx->instance, "-C");
 			ctx->instance->clock = optarg;
 			ctx->instance->flags |= BUFFER_FL_HAS_CLOCK;
-			if (is_top_instance(ctx->instance))
-				guest_sync_set = true;
 			break;
 		case 'v':
 			negative = 1;
@@ -6118,7 +6212,6 @@ static void parse_record_options(int argc,
 		case OPT_tsyncinterval:
 			cmd_check_die(ctx, CMD_set, *(argv+1), "--tsync-interval");
 			top_instance.tsync_loop_interval = atoi(optarg);
-			guest_sync_set = true;
 			break;
 		case OPT_fork:
 			if (!IS_START(ctx))
@@ -6145,26 +6238,6 @@ static void parse_record_options(int argc,
 				add_argv(instance, "--date", true);
 		}
 	}
-	if (guest_sync_set) {
-	/* If -C is specified, prepend clock to all guest VM flags */
-		for_all_instances(instance) {
-			if (top_instance.clock) {
-				if (is_guest(instance) &&
-				    !(instance->flags & BUFFER_FL_HAS_CLOCK)) {
-					add_argv(instance,
-						 (char *)top_instance.clock,
-						 true);
-					add_argv(instance, "-C", true);
-					if (!instance->clock) {
-						instance->clock = strdup((char *)top_instance.clock);
-						if (!instance->clock)
-							die("Could not allocate instance clock");
-					}
-				}
-			}
-			instance->tsync_loop_interval = top_instance.tsync_loop_interval;
-		}
-	}
 
 	if (!ctx->filtered && ctx->instance->filter_mod)
 		add_func(&ctx->instance->filter_funcs,
@@ -6301,6 +6374,9 @@ static void record_trace(int argc, char **argv,
 	if (!ctx->output)
 		ctx->output = DEFAULT_INPUT_FILE;
 
+	if (ctx->data_flags & DATA_FL_GUEST)
+		set_vsync_clock();
+
 	make_instances();
 
 	/* Save the state of tracing_on before starting */
-- 
2.29.2


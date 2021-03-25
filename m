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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79F18C433FC
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6069A61A28
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbhCYGlk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 02:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbhCYGlS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 02:41:18 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C33DEC06174A
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:41:17 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id j18so1125532wra.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nNSwgCWuMgOgj9roqKuvWrIb08sQVoQ8atUL8Pp8HDc=;
        b=TSNMacAN8ynwBgGKK2Er7DmzqnFBoCMA9M9BfiN52rYPa7zi20YgrPs/cRiCdIrin5
         yfoUpjps6SAkinBfNBYxP+vVv6t6vPMsXXPqCwQ7SxoJJ07mNgMnFhtwLn2IEbJ8rqGy
         tGFKXiNu+IZfL1X0J4VHaUI2/H7ra39dfQ5zZIgn4MCxywfMJ1YFyhEkwyu3szXDbAgg
         MP9zVE/A1esHxKD65gW4d3S8DZ1h1wcHGvzExPGPU+SYV/wPM8kCBU+Srjk/BhP2hX8u
         6QvJrRXjBmAHgoFjlquTdR71w9WgBjj+dGjCJrN95I/Vzpf88EKBjGw43vexLX8pvt0k
         fCAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nNSwgCWuMgOgj9roqKuvWrIb08sQVoQ8atUL8Pp8HDc=;
        b=fGMTVmR7NLXQc39YEMiazeBVpL7Pyjeyvl/OdJ81+wP65rRkRjOlqD5IrtesG8MgmI
         p8dKTHzdS6BaViwbDZ6qp40ZiuPujrbnXKQnrK/JPfCF+0Zw9N0ddW/9JScYO/Z1/vaK
         B8yEVjP7XsEx+yUIL3d5TmtFEJ1kIvtcFqD5eVYYiLoHYdlzJtiz3tF9li99btxQ/r/x
         HlBoWwinRxowVVLb1xjTYSwZNufIUSyXQ2iMfjbYx+OHjYAw/u1EsXWCD2KG9/ZMmoEO
         mzr+Ei2xcUw3c98CGXVmixR7n9zX9mBjVd7HoPbwi7YWpwi+KuUxMIxbrXT6rXO3KIQk
         8iZw==
X-Gm-Message-State: AOAM532xkA2Az4IgR/fGS2PxBBpHsojqaOkssCnVdV32g0GxPZ7DbsFH
        6LzZPH/czJVjc8f4gWpc/Ao=
X-Google-Smtp-Source: ABdhPJztsV6dGtRMY3yIEBcSMQke6fnijKyrITU2bdhiKKYmSGkg7Y1qiVynWTLEBEvKtExBUj5a5w==
X-Received: by 2002:adf:edc3:: with SMTP id v3mr6870442wro.79.1616654476585;
        Wed, 24 Mar 2021 23:41:16 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e17sm6403259wra.65.2021.03.24.23.41.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 23:41:16 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 20/23] trace-cmd: Use tsc clock for host-guest tracing, if available
Date:   Thu, 25 Mar 2021 08:40:52 +0200
Message-Id: <20210325064055.539554-21-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325064055.539554-1-tz.stoyanov@gmail.com>
References: <20210325064055.539554-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In a host-guest tracing session, if there is no user configured tracing
clock, use TSC by default if following conditions are met:
  - tsc-x86 trace clock is available on the host
  - params for tsc to nanosecond conversion can be retrieved using
    perf interface of the Liunx kernel - miltiplier and shift

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 97 ++++++++++++++++++++++++++++-------------
 1 file changed, 67 insertions(+), 30 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 4e4ad127..d794f1af 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -198,8 +198,10 @@ struct common_record_context {
 	const char *output;
 	char *date2ts;
 	char *user;
+	const char *clock;
 	struct tsc_nsec tsc2nsec;
 	int data_flags;
+	int tsync_loop_interval;
 
 	int record_all;
 	int total_disable;
@@ -3708,7 +3710,8 @@ static int open_guest_fifos(const char *guest, int **fds)
 	return i;
 }
 
-static int host_tsync(struct buffer_instance *instance,
+static int host_tsync(struct common_record_context *ctx,
+		      struct buffer_instance *instance,
 		      unsigned int tsync_port, char *proto)
 {
 	struct trace_guest *guest;
@@ -3723,14 +3726,15 @@ static int host_tsync(struct buffer_instance *instance,
 						    instance->tsync_loop_interval,
 						    instance->cid, tsync_port,
 						    guest->pid, guest->cpu_max,
-						    proto, top_instance.clock);
+						    proto, ctx->clock);
 	if (!instance->tsync)
 		return -1;
 
 	return 0;
 }
 
-static void connect_to_agent(struct buffer_instance *instance)
+static void connect_to_agent(struct common_record_context *ctx,
+			     struct buffer_instance *instance)
 {
 	struct tracecmd_tsync_protos *protos = NULL;
 	int sd, ret, nr_fifos, nr_cpus, page_size;
@@ -3783,7 +3787,7 @@ static void connect_to_agent(struct buffer_instance *instance)
 			printf("Negotiated %s time sync protocol with guest %s\n",
 				tsync_protos_reply,
 				instance->name);
-			host_tsync(instance, tsync_port, tsync_protos_reply);
+			host_tsync(ctx, instance, tsync_port, tsync_protos_reply);
 		} else
 			warning("Failed to negotiate timestamps synchronization with the guest");
 	}
@@ -3862,7 +3866,7 @@ void start_threads(enum trace_type type, struct common_record_context *ctx)
 	for_all_instances(instance) {
 		/* Start the connection now to find out how many CPUs we need */
 		if (is_guest(instance))
-			connect_to_agent(instance);
+			connect_to_agent(ctx, instance);
 		total_cpu_count += instance->cpu_count;
 	}
 
@@ -4128,6 +4132,7 @@ enum {
 	DATA_FL_NONE		= 0,
 	DATA_FL_DATE		= 1,
 	DATA_FL_OFFSET		= 2,
+	DATA_FL_GUEST		= 4,
 };
 
 static void add_options(struct tracecmd_output *handle, struct common_record_context *ctx)
@@ -5812,7 +5817,6 @@ static void parse_record_options(int argc,
 	int name_counter = 0;
 	int negative = 0;
 	struct buffer_instance *instance, *del_list = NULL;
-	bool guest_sync_set = false;
 	int do_children = 0;
 	int fpids_count = 0;
 
@@ -5947,6 +5951,7 @@ static void parse_record_options(int argc,
 			ctx->instance->port = port;
 			ctx->instance->name = name;
 			add_instance(ctx->instance, 0);
+			ctx->data_flags |= DATA_FL_GUEST;
 			break;
 		}
 		case 'F':
@@ -6008,8 +6013,8 @@ static void parse_record_options(int argc,
 			if (!ctx->instance->clock)
 				die("Failed allocation");
 			ctx->instance->flags |= BUFFER_FL_HAS_CLOCK;
-			if (is_top_instance(ctx->instance))
-				guest_sync_set = true;
+			if (!ctx->clock && !is_guest(ctx->instance))
+				ctx->clock = ctx->instance->clock;
 			break;
 		case 'v':
 			negative = 1;
@@ -6253,8 +6258,7 @@ static void parse_record_options(int argc,
 			break;
 		case OPT_tsyncinterval:
 			cmd_check_die(ctx, CMD_set, *(argv+1), "--tsync-interval");
-			top_instance.tsync_loop_interval = atoi(optarg);
-			guest_sync_set = true;
+			ctx->tsync_loop_interval = atoi(optarg);
 			break;
 		case OPT_fork:
 			if (!IS_START(ctx))
@@ -6288,26 +6292,6 @@ static void parse_record_options(int argc,
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
@@ -6474,6 +6458,56 @@ static void get_tsc_offset(struct common_record_context *ctx)
 	ctx->tsc2nsec.offset = get_clock_now(NULL);
 }
 
+static void set_tsync_params(struct common_record_context *ctx)
+{
+	const char *clock = ctx->clock;
+	struct buffer_instance *instance;
+	int shift, mult;
+	bool force_tsc = false;
+
+	/*
+	 * If no clock is configured &&
+	 * KVM time sync protocol is available &&
+	 * tsc-x86 clock is supported &&
+	 * TSC to nsec multiplier and shift are available:
+	 * force using the x86-tsc clock for this host-guest tracing session
+	 * and store TSC to nsec multiplier and shift.
+	 */
+	if (!clock && tsync_proto_is_supported("kvm") &&
+	    clock_is_supported(NULL, TSC_CLOCK) &&
+	    !get_tsc_nsec(&shift, &mult) && mult) {
+		clock = TSC_CLOCK;
+		ctx->tsc2nsec.mult = mult;
+		ctx->tsc2nsec.shift = shift;
+		ctx->tsc2nsec.offset = get_clock_now(TSC_CLOCK);
+		force_tsc = true;
+	}
+
+	if (!clock && !ctx->tsync_loop_interval)
+		return;
+	for_all_instances(instance) {
+		if (clock && !(instance->flags & BUFFER_FL_HAS_CLOCK)) {
+			/* use the same clock in all tracing peers */
+			if (is_guest(instance)) {
+				if (!instance->clock) {
+					instance->clock = strdup(clock);
+					if (!instance->clock)
+						die("Can not allocate instance clock");
+				}
+				add_argv(instance, (char *)instance->clock, true);
+				add_argv(instance, "-C", true);
+				if (ctx->tsc2nsec.mult)
+					instance->flags |= BUFFER_FL_TSC2NSEC;
+			} else if (force_tsc && !instance->clock) {
+				instance->clock = strdup(clock);
+				if (!instance->clock)
+					die("Can not allocate instance clock");
+			}
+		}
+		instance->tsync_loop_interval = ctx->tsync_loop_interval;
+	}
+}
+
 /*
  * This function contains common code for the following commands:
  * record, start, stream, profile.
@@ -6503,6 +6537,9 @@ static void record_trace(int argc, char **argv,
 	if (!ctx->output)
 		ctx->output = DEFAULT_INPUT_FILE;
 
+	if (ctx->data_flags & DATA_FL_GUEST)
+		set_tsync_params(ctx);
+
 	make_instances();
 
 	/* Save the state of tracing_on before starting */
-- 
2.30.2


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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 433B1C433ED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 13:05:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26AED61A0F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 13:05:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234494AbhCXNFe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 09:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234574AbhCXNEt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 09:04:49 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09305C0613DE
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 06:04:49 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id x13so24359353wrs.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 06:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0TgkhQR/si8LpboHmBV6OZDJCOZs/LOloLhndbHX8HA=;
        b=nWvOaSKP+GBpb7b7BShZknJaH59yDCPQ9fpQA5KOktyUROcc1Za4Dx6gtHCZ9eRESd
         fygp4/aimYtV7n4rysEKFyamfdheL69YhrkKmFtJU4x9UzuUkSFOTP8eZpa7FNz+7m51
         0/arBhwgznKfNxg9/CysmVuvE9bKrqdNNSzoiDFuelV2C97tCenV9VTxOyp6SZAHv+Ni
         ORH28gABjxZCs1MsgOy9chAKrQu2HcGgZ0lZKuvYPuUA4WZwXk5XNKpJS/qbKDLojNHx
         hzKx/p/jPJyK05Eh7JGLYJzaV4h3qhT5T8MsAea69d5DSvN8upWCX8BFMR5BbLoYkADD
         6XdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0TgkhQR/si8LpboHmBV6OZDJCOZs/LOloLhndbHX8HA=;
        b=s+woAg8qhKVdStOeMpaq683WkzTi1Mw7PoT0061+ISJ94R4Ww/V7y4zrbGyezbPei+
         xCGGvUmfUIPudcs+7P8zbRmFiLGSNkjmfcRnjiA/85El28+izEqehazuYmtEfd+Nb0Yi
         wFEeBaBOk2E7M1BBF7OMlgAB6RrU2vhguqHezDMDWqrIa4P1LHAoaqyhLtDVtXZQV9Ap
         XavKNDCcCRiIELMKxV9okknfUQo0um5RO1XL1qmkMlMgiMGl5aThrlOlfrns0QGbrpIh
         FTTWLyUnFUOQkP20nnSCTckhA3g2Hvmj5dwPa1lXv5vLMnJZ5y9b+vjKdgvp00MKV/Wc
         N06Q==
X-Gm-Message-State: AOAM533YjIsHTD/PppRf6vsX/l3Bso8zh84G7TKEQdEKKx2jeBNeLpki
        B5/okV64fpAW53JD/2jkS7E=
X-Google-Smtp-Source: ABdhPJwNRribhoTDvRWt9TTmYt28IQhrmImQrkycBxxzbiP1txNXP3doBdUocDk746sbclCZYJFrXg==
X-Received: by 2002:a5d:6c6a:: with SMTP id r10mr3466266wrz.42.1616591087717;
        Wed, 24 Mar 2021 06:04:47 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w11sm3034919wrv.88.2021.03.24.06.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 06:04:47 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 20/23] trace-cmd: Use tsc clock for host-guest tracing, if available
Date:   Wed, 24 Mar 2021 15:04:15 +0200
Message-Id: <20210324130418.436206-21-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210324130418.436206-1-tz.stoyanov@gmail.com>
References: <20210324130418.436206-1-tz.stoyanov@gmail.com>
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
 tracecmd/trace-record.c | 99 ++++++++++++++++++++++++++++-------------
 1 file changed, 69 insertions(+), 30 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 00fd4a1d..f90fdbe4 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -198,8 +198,10 @@ struct common_record_context {
 	const char *output;
 	char *date2ts;
 	char *user;
+	const char *clock;
 	int data_flags;
 	struct tsc_nsec tsc2nsec;
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
@@ -5811,7 +5816,6 @@ static void parse_record_options(int argc,
 	int name_counter = 0;
 	int negative = 0;
 	struct buffer_instance *instance, *del_list = NULL;
-	bool guest_sync_set = false;
 	int do_children = 0;
 	int fpids_count = 0;
 
@@ -5946,6 +5950,7 @@ static void parse_record_options(int argc,
 			ctx->instance->port = port;
 			ctx->instance->name = name;
 			add_instance(ctx->instance, 0);
+			ctx->data_flags |= DATA_FL_GUEST;
 			break;
 		}
 		case 'F':
@@ -5998,11 +6003,13 @@ static void parse_record_options(int argc,
 					die("Clock %s is not supported", optarg);
 				ctx->instance->flags |= BUFFER_FL_TSC2NSEC;
 				ctx->instance->clock = strdup(TSC_CLOCK);
+				if (!ctx->instance->clock)
+					die("Cannot allocate instance clock");
 			} else
 				ctx->instance->clock = optarg;
 			ctx->instance->flags |= BUFFER_FL_HAS_CLOCK;
-			if (is_top_instance(ctx->instance))
-				guest_sync_set = true;
+			if (!ctx->clock && !is_guest(ctx->instance))
+				ctx->clock = ctx->instance->clock;
 			break;
 		case 'v':
 			negative = 1;
@@ -6246,8 +6253,7 @@ static void parse_record_options(int argc,
 			break;
 		case OPT_tsyncinterval:
 			cmd_check_die(ctx, CMD_set, *(argv+1), "--tsync-interval");
-			top_instance.tsync_loop_interval = atoi(optarg);
-			guest_sync_set = true;
+			ctx->tsync_loop_interval = atoi(optarg);
 			break;
 		case OPT_fork:
 			if (!IS_START(ctx))
@@ -6281,26 +6287,6 @@ static void parse_record_options(int argc,
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
@@ -6467,6 +6453,56 @@ static void get_tsc_offset(struct common_record_context *ctx)
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
@@ -6496,6 +6532,9 @@ static void record_trace(int argc, char **argv,
 	if (!ctx->output)
 		ctx->output = DEFAULT_INPUT_FILE;
 
+	if (ctx->data_flags & DATA_FL_GUEST)
+		set_tsync_params(ctx);
+
 	make_instances();
 
 	/* Save the state of tracing_on before starting */
-- 
2.30.2


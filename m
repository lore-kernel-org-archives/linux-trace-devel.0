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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52FBCC433DF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Jun 2020 12:15:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B38620679
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Jun 2020 12:15:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OfXnMJat"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbgFCMPP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 3 Jun 2020 08:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726117AbgFCMPL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jun 2020 08:15:11 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 209FEC08C5C1
        for <linux-trace-devel@vger.kernel.org>; Wed,  3 Jun 2020 05:15:11 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id r15so1796400wmh.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 03 Jun 2020 05:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9meH8CcSFQi57o0eaneyG/UmrbmUef4XJx6okk637lk=;
        b=OfXnMJat09eMNo6BKIt92VuGK57GhDCZ7akLR1J0qgMUYXsmd+j5Yi1mmNk8rY3Xg/
         MN1ii3hSw9feJ9V89MEnCjSG3Jg77Kl9pfTJIvZNPhRH7xJ6u8hkOadjFLCHyXtD2nr0
         0ANfaS+3kBlDHyt9+qL9zvhUQXPf43U8uNAPo9fcLRDU4YzcKjeU7/d33qgg2QJBFgK2
         hPeMPV5WaUOGCTVF9MvMgVcKsMtFy4LvNwNV64iWBLWeA2CwgZgBHIdr4hUEREiG1n+P
         FclqNoB8HNyPzZbn9a6Gs4tcfdApVk16K1VJKScA8oaLVL1bql/oE9/ndkABm+iZ6HHY
         IQDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9meH8CcSFQi57o0eaneyG/UmrbmUef4XJx6okk637lk=;
        b=n5VFK/fX6ZtrE5ocL6SzUbaXDaKGjInGvcC2B7VbIRMr/vIomuenoMPJ6puZPq5RDV
         aEaAMnEWMIzFjOWiJzIhR+Pcu6/EQYJ/WsSCyWaf9a9PMMP9PDFcLLNF6JEYI1f4hqun
         zVi9lKHW0MmujbGHozgNR2L9ENCE+v+0chmvR5UyfgCOoRpCRrmhNFks0AizKT6ZEbta
         sQMoKDpxWzitIenmgKaCpsMmr88WB9UzOlmsBEA/1Rc1EmJGzqfKz6ONmm9V2aLpauy/
         HpGq2tKL3IPXfA60x+vxeLmr9YlmkDKWzbagfVZ56eQJd2wrlRiT18CR3W5nk/vyf0XM
         0brA==
X-Gm-Message-State: AOAM531klBq77WDxtTyOPoQOdbEKFIby5OqI4bnTJDY6QKBXJS89n+TV
        Ba90gfVtK3CJ4vCTnMJebhZx9cprsa4=
X-Google-Smtp-Source: ABdhPJwRVONSboes5VDf36Jze5F3V3HX8gEu4dh8Hp2J60CIjimacnFgpsy3PQgfpHGrLts47Wc/XA==
X-Received: by 2002:a1c:a505:: with SMTP id o5mr8663971wme.143.1591186509800;
        Wed, 03 Jun 2020 05:15:09 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u3sm2657042wmg.38.2020.06.03.05.15.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 05:15:09 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 1/5] trace-cmd: Enable "trace-cmd start" to run a command
Date:   Wed,  3 Jun 2020 15:15:02 +0300
Message-Id: <20200603121506.49992-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200603121506.49992-1-tz.stoyanov@gmail.com>
References: <20200603121506.49992-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

There is a resrtiction of "trace-cmd start" which does not allow it to
run a command, specified by "-F" option or at the end of the command
line. However, there are use cases where this is useful.
The resrtiction is removed, it allows "trace-cmd start" to run commands
just like "trace-cmd record".

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/trace-cmd-start.1.txt |  2 +-
 tracecmd/trace-record.c             | 28 ++++++++++++++++++++--------
 tracecmd/trace-usage.c              |  2 +-
 3 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/Documentation/trace-cmd-start.1.txt b/Documentation/trace-cmd-start.1.txt
index 2b027b01..63d2034c 100644
--- a/Documentation/trace-cmd-start.1.txt
+++ b/Documentation/trace-cmd-start.1.txt
@@ -21,7 +21,7 @@ system or can be extracted with trace-cmd-extract(1).
 OPTIONS
 -------
 The options are the same as 'trace-cmd-record(1)', except that it does not
-take options specific to recording (*-s*, *-o*, *-F*, *-N*, and *-t*).
+take options specific to recording (*-s*, *-o*, *-N*, and *-t*).
 
 SEE ALSO
 --------
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 3242368e..f345c6d6 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -1598,7 +1598,8 @@ static void run_cmd(enum trace_type type, const char *user, int argc, char **arg
 		/* child */
 		update_task_filter();
 		tracecmd_enable_tracing();
-		enable_ptrace();
+		if (type != TRACE_TYPE_START)
+			enable_ptrace();
 		/*
 		 * If we are using stderr for stdout, switch
 		 * it back to the saved stdout for the code we run.
@@ -1619,6 +1620,8 @@ static void run_cmd(enum trace_type type, const char *user, int argc, char **arg
 			die("Failed to exec %s", argv[0]);
 		}
 	}
+	if (type & TRACE_TYPE_START)
+		exit(0);
 	if (do_ptrace) {
 		ptrace_attach(NULL, pid);
 		ptrace_wait(type);
@@ -5782,6 +5785,14 @@ static void add_arg(struct buffer_instance *instance,
 	/* Not found? */
 }
 
+static inline void cmd_check_die(struct common_record_context *ctx,
+				 enum trace_cmd id, char *cmd, char *param)
+{
+	if (ctx->curr_cmd == id)
+		die("%s has no effect with the command %s\n"
+		    "Did you mean 'record'?", param, cmd);
+}
+
 static void parse_record_options(int argc,
 				 char **argv,
 				 enum trace_cmd curr_cmd,
@@ -6114,6 +6125,7 @@ static void parse_record_options(int argc,
 				die("Failed to allocate user name");
 			break;
 		case OPT_procmap:
+			cmd_check_die(ctx, CMD_start, *(argv+1), "--proc-map");
 			ctx->instance->get_procmap = 1;
 			break;
 		case OPT_date:
@@ -6221,9 +6233,6 @@ static void parse_record_options(int argc,
 		die(" -c can only be used with -F (or -P with event-fork support)");
 
 	if ((argc - optind) >= 2) {
-		if (IS_START(ctx))
-			die("Command start does not take any commands\n"
-			    "Did you mean 'record'?");
 		if (IS_EXTRACT(ctx))
 			die("Command extract does not take any commands\n"
 			    "Did you mean 'record'?");
@@ -6244,6 +6253,9 @@ static void parse_record_options(int argc,
 		}
 	}
 
+	if (do_ptrace && IS_START(ctx))
+		die("ptrace not supported with command start");
+
 	for_all_instances(instance) {
 		if (instance->get_procmap && !instance->nr_filter_pids) {
 			warning("--proc-map is ignored for instance %s, "
@@ -6410,10 +6422,6 @@ static void record_trace(int argc, char **argv,
 		signal(SIGINT, finish);
 		if (!latency)
 			start_threads(type, ctx);
-	} else {
-		update_task_filter();
-		tracecmd_enable_tracing();
-		exit(0);
 	}
 
 	if (ctx->run_command) {
@@ -6428,6 +6436,10 @@ static void record_trace(int argc, char **argv,
 
 		update_task_filter();
 		tracecmd_enable_tracing();
+
+		if (type & TRACE_TYPE_START)
+			exit(0);
+
 		/* We don't ptrace ourself */
 		if (do_ptrace) {
 			for_all_instances(instance) {
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index d43ca490..58bca9e4 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -69,7 +69,7 @@ static struct usage_help usage_help[] = {
 		"start",
 		"start tracing without recording into a file",
 		" %s start [-e event][-p plugin][-d][-O option ][-P pid]\n"
-		"          Uses same options as record, but does not run a command.\n"
+		"          Uses same options as record.\n"
 		"          It only enables the tracing and exits\n"
 	},
 	{
-- 
2.26.2


Return-Path: <SRS0=8+AL=7P=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEF00C433E0
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Jun 2020 14:09:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBEE420772
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Jun 2020 14:09:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LdWXddnw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725958AbgFBOJS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Jun 2020 10:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbgFBOJS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Jun 2020 10:09:18 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D209C08C5C1
        for <linux-trace-devel@vger.kernel.org>; Tue,  2 Jun 2020 07:09:18 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id e1so3573352wrt.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 02 Jun 2020 07:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9meH8CcSFQi57o0eaneyG/UmrbmUef4XJx6okk637lk=;
        b=LdWXddnw2lP7TKrJvMf0Alk/TxKu287me0OqcWVm7KIeek2cyZl6/g5w4JoQjunjA+
         7+Zx35uKoFIGhyyf1L9vakX9RC4fJd+WoHefeZwxD6f3bkQdmLAJQycdUsfJVxFxubH7
         NBmwlURIocAaXVb5Jc0ThOYFFxf4SuXZ2Tzk9dHmE7y1RuspWyKZ/W5u+yf+jseacM0u
         FdN2+4XruBTYHzVpSKqqoLBQegJoH1vNG6iCS8yq9PmP/PoTtMDpWAIPsaeNHGfoDHne
         2HwWD/EMwublpzAP/a1QUkmzJqTxa3otG4XVCLjbVD+hYs3XQEIDfuQysoKBmy7dFFon
         o/2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9meH8CcSFQi57o0eaneyG/UmrbmUef4XJx6okk637lk=;
        b=NmsE7T29i9itFh4ENZkg7TntzgXGgkkn4ole3PMCAnfNIaa5aTvCTOJaf8QnpKFzWk
         PeHoMExJBQwuhDHdQ/be4wqVhGcJiW5eWgY1XqGYYbF6DdtHbCLEv7TIZaL1BNBdih5v
         WDtuwffAvkm1UegV5YV6G0P+T6MlHg3PFsQg9pfemuSEgCKcZPG99BBUfH93qzPdGDyh
         3YureBIzy0gsH6ZPHHImNklriEVBBASCx619Snkw8fwF5NKrkzzoMvG2rCTlZ7JmhKcO
         lSWnL1qYtXB1cXq1s2ordFaljPlvXXvV7l82ATqIhb/umMUS6kJ6wB5Y0q/uRm+Wn9ow
         UF5A==
X-Gm-Message-State: AOAM531MwynZOJfrSjq1z+yyP7dMwSJeE++9BlS2AFdLFSzI6ZVcENe6
        bu7/xil0SSliZCiUCQagq3g=
X-Google-Smtp-Source: ABdhPJz2qmPBEq9HARr32zWPUrlph1c5D5fGtGadxdzqWb9DTOVKyExguFO9cZpcc8FhX6ru/NvSvw==
X-Received: by 2002:adf:9c12:: with SMTP id f18mr10581185wrc.105.1591106956704;
        Tue, 02 Jun 2020 07:09:16 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w3sm3849551wmg.44.2020.06.02.07.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 07:09:16 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 1/3] trace-cmd: Enable "trace-cmd start" to run a command
Date:   Tue,  2 Jun 2020 17:09:10 +0300
Message-Id: <20200602140912.78031-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200602140912.78031-1-tz.stoyanov@gmail.com>
References: <20200602140912.78031-1-tz.stoyanov@gmail.com>
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


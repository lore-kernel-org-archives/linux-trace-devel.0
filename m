Return-Path: <SRS0=byw1=VC=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB17DC46499
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Jul 2019 13:53:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95FED218CA
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Jul 2019 13:53:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K2Cl01ce"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbfGENxh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Jul 2019 09:53:37 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46493 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbfGENxg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Jul 2019 09:53:36 -0400
Received: by mail-wr1-f67.google.com with SMTP id z1so5404588wru.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Jul 2019 06:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hd/Rgp7fd8bWHfQjFyROmQ1L3L7UX5dpNs2xxHTGwto=;
        b=K2Cl01ce1a0g9KVuJzgg1Lm8HkRBd+G9ayJRMa5wVh4zv2I/YCmciBV2TO2AJs5Ybh
         xj3PB4ueawkaUK7a9m2M9vTwq7YfKCAy/4uIXlh1pfO41w4ZmbGV0fZQts7NU/E65T0w
         6TzKrWwF5Yz2TPxLMAMh68MEsG9bgZH+E04JeqsERvtFW3wi2/KjDaQflOdPA1EoXcRt
         sUGA9/WodN17nd4rB1a8+VxLvTVtheIcQN254dJyYHBq6K62eudr3PEPCRP8HLAy76u4
         uTDGnMY2cjwNSRRT1SdyhoQemoWZ9DQ8y1kV34ByGKO+LD+y7s8jpYCfAaCi9+4m8/k6
         6VlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hd/Rgp7fd8bWHfQjFyROmQ1L3L7UX5dpNs2xxHTGwto=;
        b=bhGbiUPlEIXi7xLrK65i+C07hJNZf9wI556Yw92RfttGQK1wMLkpKVvOesg59ueUco
         AdPCUtljMQIcM+yzqdMZ7Ibzb4HHIpvvR9zA0YlhTsLvv/DEOAe/OXhMI4iZOHNifxND
         ra/bJFaI2VUldltoQBgcQa/ecz8qC12ADNK8DxIS8v3EgIzWtIi9ePklrpYPSNpE95Ov
         m0Mq2RGN/UKVILev6DnJKn8ia1mnny0RAlMVVeummyb8B/DglYD2b0i9vRNgvNaWICpy
         zksDB5zFLxcVTWPbZoz4BBz8ECAfyN+36tc6p4FlOuGU/OXXM05GgeBrmzyEgA8rB55t
         bc6A==
X-Gm-Message-State: APjAAAXLFFSHtETnE3i7DBCoZb6GuqDG5GmtuzmUHiFE0rLdXqQa0OwA
        mIGpMUX/Zt1s+Jyi+JnjwUdMD6yd
X-Google-Smtp-Source: APXvYqw5DBKJ000/w0gY2LYZ2nTDpBASDS0jVWZeUfGeVM5M5f0tS+Tked9GMt2SycR5FLFdyiKNZQ==
X-Received: by 2002:a5d:4107:: with SMTP id l7mr1503084wrp.191.1562334813814;
        Fri, 05 Jul 2019 06:53:33 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id y1sm6906481wma.32.2019.07.05.06.53.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 05 Jul 2019 06:53:32 -0700 (PDT)
From:   tz.stoyanov@gmail.com
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2] trace-cmd: Add option to execute traced process as given user
Date:   Fri,  5 Jul 2019 16:53:31 +0300
Message-Id: <20190705135331.20705-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

A new trace-cmd record option is added: "--user". When it is set with
combination of option -F, the traced process is executed in the context
of the specified user.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Suggested-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
[
  Should be applied on top of patch "trace-cmd: Save the tracee memory map
into the trace.dat file."
  
  v2 changes:
     - Check for errors in change_user(). If an error occurs while
       changing the user, the message is printed and the traced 
       process is not executed.
]

 Documentation/trace-cmd-record.1.txt |  4 +++
 tracecmd/trace-record.c              | 47 ++++++++++++++++++++++++++--
 tracecmd/trace-usage.c               |  1 +
 3 files changed, 49 insertions(+), 3 deletions(-)

diff --git a/Documentation/trace-cmd-record.1.txt b/Documentation/trace-cmd-record.1.txt
index 4a59de9..df92354 100644
--- a/Documentation/trace-cmd-record.1.txt
+++ b/Documentation/trace-cmd-record.1.txt
@@ -122,6 +122,10 @@ OPTIONS
 *--mmap*::
      Used with either *-F* or *-P*, save the traced process memory map into
      the trace.dat file.
+
+*--user*::
+     Used with -F, execute the traced process as given user.
+
 *-C* 'clock'::
      Set the trace clock to "clock".
 
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 48081d4..3a37cc2 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -33,6 +33,8 @@
 #include <errno.h>
 #include <limits.h>
 #include <libgen.h>
+#include <pwd.h>
+#include <grp.h>
 
 #include "version.h"
 #include "trace-local.h"
@@ -208,6 +210,7 @@ struct common_record_context {
 	struct buffer_instance *instance;
 	const char *output;
 	char *date2ts;
+	char *user;
 	int data_flags;
 
 	int record_all;
@@ -1417,7 +1420,34 @@ static void trace_or_sleep(enum trace_type type)
 		sleep(10);
 }
 
-static void run_cmd(enum trace_type type, int argc, char **argv)
+static int change_user(char *user)
+{
+	struct passwd *pwd;
+
+	if (!user)
+		return -1;
+
+	pwd = getpwnam(user);
+	if (!pwd)
+		return -1;
+	if (initgroups(user, pwd->pw_gid) < 0)
+		return -1;
+	if (setgid(pwd->pw_gid) < 0)
+		return -1;
+	if (setuid(pwd->pw_uid) < 0)
+		return -1;
+
+	if (setenv("HOME", pwd->pw_dir, 1) < 0)
+		return -1;
+	if (setenv("USER", pwd->pw_name, 1) < 0)
+		return -1;
+	if (setenv("LOGNAME", pwd->pw_name, 1) < 0)
+		return -1;
+
+	return 0;
+}
+
+static void run_cmd(enum trace_type type, char *user, int argc, char **argv)
 {
 	int status;
 	int pid;
@@ -1438,6 +1468,10 @@ static void run_cmd(enum trace_type type, int argc, char **argv)
 			dup2(save_stdout, 1);
 			close(save_stdout);
 		}
+
+		if (user && change_user(user) < 0)
+			die("Failed to change user to %s", user);
+
 		if (execvp(argv[0], argv)) {
 			fprintf(stderr, "\n********************\n");
 			fprintf(stderr, " Unable to exec %s\n", argv[0]);
@@ -4548,6 +4582,7 @@ void update_first_instance(struct buffer_instance *instance, int topt)
 }
 
 enum {
+	OPT_user		= 243,
 	OPT_mmap		= 244,
 	OPT_quiet		= 245,
 	OPT_debug		= 246,
@@ -4780,6 +4815,7 @@ static void parse_record_options(int argc,
 			{"quiet", no_argument, NULL, OPT_quiet},
 			{"help", no_argument, NULL, '?'},
 			{"mmap", no_argument, NULL, OPT_mmap},
+			{"user", required_argument, NULL, OPT_user},
 			{"module", required_argument, NULL, OPT_module},
 			{NULL, 0, NULL, 0}
 		};
@@ -5011,6 +5047,9 @@ static void parse_record_options(int argc,
 		case 'i':
 			ignore_event_not_found = 1;
 			break;
+		case OPT_user:
+			ctx->user = strdup(optarg);
+			break;
 		case OPT_mmap:
 			get_mmap = 1;
 			break;
@@ -5079,7 +5118,9 @@ static void parse_record_options(int argc,
 	if (!ctx->filtered && ctx->instance->filter_mod)
 		add_func(&ctx->instance->filter_funcs,
 			 ctx->instance->filter_mod, "*");
-
+	if (ctx->user && !filter_task)
+		warning("--user %s is ignored, no traced process is specified",
+			ctx->user);
 	if (filter_task && get_mmap)
 		do_ptrace = 1;
 
@@ -5237,7 +5278,7 @@ static void record_trace(int argc, char **argv,
 	}
 
 	if (ctx->run_command)
-		run_cmd(type, (argc - optind) - 1, &argv[optind + 1]);
+		run_cmd(type, ctx->user, (argc - optind) - 1, &argv[optind + 1]);
 	else {
 		update_task_filter();
 		tracecmd_enable_tracing();
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index c658ede..fcc314e 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -58,6 +58,7 @@ static struct usage_help usage_help[] = {
 		"          --max-graph-depth limit function_graph depth\n"
 		"          --no-filter include trace-cmd threads in the trace\n"
 		"          --mmap used with -F or -P, save the traced process memory map into the trace.dat file\n"
+		"          --user used with -F, execute the traced process as given user\n"
 	},
 	{
 		"start",
-- 
2.21.0


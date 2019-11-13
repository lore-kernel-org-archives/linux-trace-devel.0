Return-Path: <SRS0=x7pb=ZF=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDD71C17442
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Nov 2019 12:14:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C09A32084E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Nov 2019 12:14:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfKMMO3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Nov 2019 07:14:29 -0500
Received: from foss.arm.com ([217.140.110.172]:51458 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725908AbfKMMO3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Nov 2019 07:14:29 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 201C7C8F;
        Wed, 13 Nov 2019 04:14:29 -0800 (PST)
Received: from e120877-lin.cambridge.arm.com (e120877-lin.cambridge.arm.com [10.1.194.81])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A4E993F6C4;
        Wed, 13 Nov 2019 04:14:28 -0800 (PST)
From:   vincent.donnefort@arm.com
To:     linux-trace-devel@vger.kernel.org
Cc:     Vincent Donnefort <vincent.donnefort@arm.com>
Subject: [PATCH v2 2/2] trace-cmd: Add an option to set saved_cmdlines_size
Date:   Wed, 13 Nov 2019 12:14:17 +0000
Message-Id: <1573647257-317361-2-git-send-email-vincent.donnefort@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573647257-317361-1-git-send-email-vincent.donnefort@arm.com>
References: <20191112140920.6bbed145@gandalf.local.home>
 <1573647257-317361-1-git-send-email-vincent.donnefort@arm.com>
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Vincent Donnefort <vincent.donnefort@arm.com>

The tracing file saved_cmdlines_size allows setting the number of entries
that saved_cmdlines will contain. The latter is then dumped into the
trace.dat file to map PIDs with comm. The default value is 128.

Signed-off-by: Vincent Donnefort <vincent.donnefort@arm.com>

diff --git a/Documentation/trace-cmd-record.1.txt b/Documentation/trace-cmd-record.1.txt
index bb18e88..0d75e43 100644
--- a/Documentation/trace-cmd-record.1.txt
+++ b/Documentation/trace-cmd-record.1.txt
@@ -280,6 +280,12 @@ OPTIONS
     A value of one will only show where userspace enters the kernel but not any
     functions called in the kernel. The default is zero, which means no limit.
 
+*--cmdlines-size* 'size'::
+    Set the number of entries the kernel tracing file "saved_cmdlines" can
+    contain. This file is a circular buffer which stores the mapping between
+    cmdlines and PIDs. If full, it leads to unresolved cmdlines ("<...>") within
+    the trace. The kernel default value is 128.
+
 *--module* 'module'::
     Filter a module's name in function tracing. It is equivalent to adding
     ':mod:module' after all other functions being filtered. If no other function
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 7260d27..8fbfa35 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -229,6 +229,7 @@ struct common_record_context {
 	int topt;
 	int do_child;
 	int run_command;
+	int saved_cmdlines_size;
 };
 
 static void add_reset_file(const char *file, const char *val, int prio)
@@ -1810,6 +1811,39 @@ static void set_options(void)
 	}
 }
 
+static void set_saved_cmdlines_size(struct common_record_context *ctx)
+{
+	int fd, len, ret = -1;
+	char *path, *str;
+
+	if (!ctx->saved_cmdlines_size)
+		return;
+
+	path = tracecmd_get_tracing_file("saved_cmdlines_size");
+	if (!path)
+		goto err;
+
+	reset_save_file(path, RESET_DEFAULT_PRIO);
+
+	fd = open(path, O_WRONLY);
+	tracecmd_put_tracing_file(path);
+	if (fd < 0)
+		goto err;
+
+	len = asprintf(&str, "%d", ctx->saved_cmdlines_size);
+	if (len < 0)
+		die("%s couldn't allocate memory", __func__);
+
+	if (write(fd, str, len) > 0)
+		ret = 0;
+
+	close(fd);
+	free(str);
+err:
+	if (ret)
+		warning("Couldn't set saved_cmdlines_size");
+}
+
 static int trace_check_file_exists(struct buffer_instance *instance, char *file)
 {
 	struct stat st;
@@ -5190,6 +5224,7 @@ enum {
 	OPT_date		= 255,
 	OPT_module		= 256,
 	OPT_nofifos		= 257,
+	OPT_cmdlines_size	= 258,
 };
 
 void trace_stop(int argc, char **argv)
@@ -5467,6 +5502,7 @@ static void parse_record_options(int argc,
 			{"by-comm", no_argument, NULL, OPT_bycomm},
 			{"ts-offset", required_argument, NULL, OPT_tsoffset},
 			{"max-graph-depth", required_argument, NULL, OPT_max_graph_depth},
+			{"cmdlines-size", required_argument, NULL, OPT_cmdlines_size},
 			{"no-filter", no_argument, NULL, OPT_no_filter},
 			{"debug", no_argument, NULL, OPT_debug},
 			{"quiet", no_argument, NULL, OPT_quiet},
@@ -5795,6 +5831,9 @@ static void parse_record_options(int argc,
 			if (!ctx->instance->max_graph_depth)
 				die("Could not allocate option");
 			break;
+		case OPT_cmdlines_size:
+			ctx->saved_cmdlines_size = atoi(optarg);
+			break;
 		case OPT_no_filter:
 			no_filter = true;
 			break;
@@ -5990,6 +6029,7 @@ static void record_trace(int argc, char **argv,
 			enable_events(instance);
 	}
 
+	set_saved_cmdlines_size(ctx);
 	set_buffer_size();
 	update_plugins(type);
 	set_options();
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index b5788f7..05ec021 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -56,6 +56,7 @@ static struct usage_help usage_help[] = {
 		"          --func-stack perform a stack trace for function tracer\n"
 		"             (use with caution)\n"
 		"          --max-graph-depth limit function_graph depth\n"
+		"          --cmdlines-size change kernel saved_cmdlines_size\n"
 		"          --no-filter include trace-cmd threads in the trace\n"
 		"          --proc-map save the traced processes address map into the trace.dat file\n"
 		"          --user execute the specified [command ...] as given user\n"
-- 
2.7.4


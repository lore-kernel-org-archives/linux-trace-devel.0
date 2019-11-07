Return-Path: <SRS0=IVdt=Y7=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 176A0C5DF60
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Nov 2019 10:51:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4BDF214D8
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Nov 2019 10:51:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388112AbfKGKvP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Nov 2019 05:51:15 -0500
Received: from foss.arm.com ([217.140.110.172]:54072 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727528AbfKGKvP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Nov 2019 05:51:15 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 899B17CD;
        Thu,  7 Nov 2019 02:51:14 -0800 (PST)
Received: from e120877-lin.cambridge.arm.com (unknown [10.1.195.69])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1A27F3F6C4;
        Thu,  7 Nov 2019 02:51:13 -0800 (PST)
From:   vincent.donnefort@arm.com
To:     linux-trace-devel@vger.kernel.org
Cc:     Vincent Donnefort <vincent.donnefort@arm.com>
Subject: [PATCH 2/2] trace-cmd: Add an option to set saved_cmdlines_size
Date:   Thu,  7 Nov 2019 10:51:06 +0000
Message-Id: <1573123866-348262-2-git-send-email-vincent.donnefort@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573123866-348262-1-git-send-email-vincent.donnefort@arm.com>
References: <1573123866-348262-1-git-send-email-vincent.donnefort@arm.com>
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Vincent Donnefort <vincent.donnefort@arm.com>

The tracing file saved_cmdlines_size allows setting the number of entries
that saved_cmdlines will contain. The latter is then dumped into the
trace.dat file to map PIDs with comm. The default value is 128.

Signed-off-by: Vincent Donnefort <vincent.donnefort@arm.com>

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 7260d27..a4e10a4 100644
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
+	char *path, *str;
+	int fd, len, ret;
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
@@ -5480,7 +5514,7 @@ static void parse_record_options(int argc,
 		if (IS_EXTRACT(ctx))
 			opts = "+haf:Fp:co:O:sr:g:l:n:P:N:tb:B:ksiT";
 		else
-			opts = "+hae:f:FA:p:cC:dDGo:O:s:r:vg:l:n:P:N:tb:R:B:ksSiTm:M:H:q";
+			opts = "+hae:f:FA:p:cC:dDGo:O:s:r:vg:l:n:P:N:tb:R:B:kK:sSiTm:M:H:qK";
 		c = getopt_long (argc-1, argv+1, opts, long_options, &option_index);
 		if (c == -1)
 			break;
@@ -5741,6 +5775,9 @@ static void parse_record_options(int argc,
 		case 'k':
 			keep = 1;
 			break;
+		case 'K':
+			ctx->saved_cmdlines_size = atoi(optarg);
+			break;
 		case 'i':
 			ignore_event_not_found = 1;
 			break;
@@ -5990,6 +6027,7 @@ static void record_trace(int argc, char **argv,
 			enable_events(instance);
 	}
 
+	set_saved_cmdlines_size(ctx);
 	set_buffer_size();
 	update_plugins(type);
 	set_options();
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index b5788f7..ddfb480 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -47,6 +47,7 @@ static struct usage_help usage_help[] = {
 		"          -b change kernel buffersize (in kilobytes per CPU)\n"
 		"          -B create sub buffer and following events will be enabled here\n"
 		"          -k do not reset the buffers after tracing.\n"
+		"          -K change kernel saved_cmdlines_size\n"
 		"          -i do not fail if an event is not found\n"
 		"          -q print no output to the screen\n"
 		"          --quiet print no output to the screen\n"
-- 
2.7.4


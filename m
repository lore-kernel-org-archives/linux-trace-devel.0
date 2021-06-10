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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2617DC48BDF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:35:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EB50613FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:35:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbhFJLhK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Jun 2021 07:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbhFJLhE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Jun 2021 07:37:04 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2860BC0613A2
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:35:07 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id h22-20020a05600c3516b02901a826f84095so6196942wmq.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RtMwJbKncg4ckpg5SIUP3kDSQFOXLgYoO4/UYSv1wIw=;
        b=JUHpeMtdBZqYcr5EfCk/uQkvK/LuLXJ89L36i43G611PEMg0aqueZ6zaSmGFBu9kjg
         hfiixhqqE6eZJXqfLCFfA7Rc+2acCDwwdEl80PkHqeWgXzGcAK+SgzM3Omffa1CZagrg
         Bt2OVtBf9q5XuczVLcksd32UWAZtfN2c/4UDI3/jEfQKcMJYJ+j2q6UMsxZF8F5B6hTp
         4f0qDu4PyShuo2OpktC/baVsap9g3Gnc+jl/qPmYoyki55/IUuhw6djaIk3bHKJEgNef
         5kwadc4X+/lO5chU/xzs334tnBBX4thxoA63mcwVAWciC1rWfWFEdgp8UXS5TckmH3by
         Gh+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RtMwJbKncg4ckpg5SIUP3kDSQFOXLgYoO4/UYSv1wIw=;
        b=k1LS1iMvt9fTm+axOnhki9vvJ9/7qSdRGFdfKh7T5/AUJiZilhDueu+8svyG83IwUB
         SbSq/a4uhme58VIFtsV7AWDfCpoHIWYUlvSiyEdftN92B1Xjhse4nm/Cg9DpTydCCU5p
         hzuXgahqwmW+pv8xr7q+TyjY+eMlledcEimqw+3OlVIgI0HuGbtm7SAiJy6LloR3xnPp
         CTS1ECvphvrx8CDtpO6cdQ7QvOUhxH9YUyIkDjGbQ/Ny0AkD35CoIPxD30BmuGDrzA3m
         f93dw/BzjC/eF/AmFybnp4NtLHbPtpsjQ57+7aheZ5jbo85S+q7+9pYFTTKljqZakzcT
         Dxow==
X-Gm-Message-State: AOAM530BbE6EKbPEuHROyV6b/6WkbnAX3243yAay97gYGw2AtJ2+xJMM
        Nv01nPDK6ZY2cqf/hX7N5GaUPCl38SGQQA==
X-Google-Smtp-Source: ABdhPJzCwqTWVn1WPj8sDA0eB+RIhP4az4vTzF5nYAF/6HWDnRupJ+L/+ex5rD1z4d7PB3ZjmmEIaA==
X-Received: by 2002:a05:600c:35c1:: with SMTP id r1mr14469341wmq.181.1623324905737;
        Thu, 10 Jun 2021 04:35:05 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n42sm8898391wms.29.2021.06.10.04.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 04:35:05 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 40/40] trace-cmd: Add new command "trace-cmd convert"
Date:   Thu, 10 Jun 2021 14:34:26 +0300
Message-Id: <20210610113426.257931-41-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610113426.257931-1-tz.stoyanov@gmail.com>
References: <20210610113426.257931-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new trace-cmd subcommand is added, used to convert trace files:

trace-cmd convert -i <input file> -o <output file> --compression
<out file compression>

The command reads the given input trace file and creates output trace
file with given compression. The --compression parameter is optional:
 - no --compression parameter: the output file inherits the compression
   from the input file.
 --compression none - the output file is not compressed.
 --compression any  - use the best available compression algorithm to
   compress the output file
 --compression <algorithm> - use the specified compression algorithm, if
   available, to compress the output file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/Makefile              |  1 +
 tracecmd/include/trace-local.h |  2 +
 tracecmd/trace-cmd.c           |  1 +
 tracecmd/trace-convert.c       | 93 ++++++++++++++++++++++++++++++++++
 tracecmd/trace-usage.c         | 12 +++++
 5 files changed, 109 insertions(+)
 create mode 100644 tracecmd/trace-convert.c

diff --git a/tracecmd/Makefile b/tracecmd/Makefile
index 80c69bbb..35086b71 100644
--- a/tracecmd/Makefile
+++ b/tracecmd/Makefile
@@ -36,6 +36,7 @@ TRACE_CMD_OBJS += trace-usage.o
 TRACE_CMD_OBJS += trace-dump.o
 TRACE_CMD_OBJS += trace-clear.o
 TRACE_CMD_OBJS += trace-vm.o
+TRACE_CMD_OBJS += trace-convert.o
 
 ifeq ($(VSOCK_DEFINED), 1)
 TRACE_CMD_OBJS += trace-agent.o
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index e9a0aea8..13dab44c 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -110,6 +110,8 @@ void trace_usage(int argc, char **argv);
 
 void trace_dump(int argc, char **argv);
 
+void trace_convert(int argc, char **argv);
+
 int trace_record_agent(struct tracecmd_msg_handle *msg_handle,
 		       int cpus, int *fds,
 		       int argc, char **argv, bool use_fifos,
diff --git a/tracecmd/trace-cmd.c b/tracecmd/trace-cmd.c
index 71c8f6d6..e6274c35 100644
--- a/tracecmd/trace-cmd.c
+++ b/tracecmd/trace-cmd.c
@@ -130,6 +130,7 @@ struct command commands[] = {
 	{"list", trace_list},
 	{"help", trace_usage},
 	{"dump", trace_dump},
+	{"convert", trace_convert},
 	{"-h", trace_usage},
 };
 
diff --git a/tracecmd/trace-convert.c b/tracecmd/trace-convert.c
new file mode 100644
index 00000000..d75859c1
--- /dev/null
+++ b/tracecmd/trace-convert.c
@@ -0,0 +1,93 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2021, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
+ */
+#include <stdlib.h>
+#include <unistd.h>
+#include <getopt.h>
+#include <fcntl.h>
+#include <errno.h>
+
+#include "trace-local.h"
+#include "trace-cmd.h"
+#include "trace-cmd-private.h"
+
+static void convert_file(const char *in, const char *out, char *compr)
+{
+	struct tracecmd_input *ihandle;
+	struct tracecmd_output *ohandle;
+
+	ihandle = tracecmd_open(in, 0);
+	if (!ihandle)
+		die("error reading %s", in);
+
+	ohandle = tracecmd_copy(ihandle, out, TRACECMD_FILE_CPU_FLYRECORD, compr);
+	if (!ohandle)
+		die("error writing %s", out);
+	tracecmd_output_close(ohandle);
+}
+
+enum {
+	OPT_comporession	= 255,
+};
+
+void trace_convert(int argc, char **argv)
+{
+	char *input_file = NULL;
+	char *output_file = NULL;
+	char *compression = NULL;
+	int c;
+
+	if (argc < 2)
+		usage(argv);
+
+	if (strcmp(argv[1], "convert") != 0)
+		usage(argv);
+	for (;;) {
+		int option_index = 0;
+		static struct option long_options[] = {
+			{"compression", required_argument, NULL, OPT_comporession},
+			{"help", no_argument, NULL, '?'},
+			{NULL, 0, NULL, 0}
+		};
+
+		c = getopt_long (argc-1, argv+1, "+hi:o:", long_options, &option_index);
+		if (c == -1)
+			break;
+		switch (c) {
+		case 'i':
+			if (input_file)
+				die("Only one input file is supported, %s already set", input_file);
+			input_file = optarg;
+			break;
+		case 'o':
+			if (output_file)
+				die("Only one output file is supported, %s already set", output_file);
+			output_file = optarg;
+			break;
+		case OPT_comporession:
+			if (strcmp(optarg, "any") && strcmp(optarg, "none") &&
+			    !tracecmd_compress_is_supported(optarg, NULL))
+				die("Compression algorithm  %s is not supported", optarg);
+			compression = optarg;
+			break;
+		case 'h':
+		case '?':
+		default:
+			usage(argv);
+		}
+	}
+
+	if ((argc - optind) >= 2) {
+		if (output_file)
+			usage(argv);
+		output_file = argv[optind + 1];
+	}
+
+	if (!input_file)
+		input_file = DEFAULT_INPUT_FILE;
+	if (!output_file)
+		usage(argv);
+
+	convert_file(input_file, output_file, compression);
+}
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index c70f9919..d0d12e87 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -392,6 +392,18 @@ static struct usage_help usage_help[] = {
 		"          --clock trace clock, saved in the file\n"
 		"          -h, --help show usage information\n"
 	},
+	{
+		"convert",
+		"convert trace file to different version",
+		" %s convert [options]\n"
+		"          -i input file, default is trace.dat\n"
+		"          -o output file, mandatory parameter.\n"
+		"             The output file can be specified also as last argument of the command\n"
+		"          --compression compress the trace output file, one of these strings can be passed:\n"
+		"                            any  - auto select the best available compression algorithm\n"
+		"                            none - do not compress the trace file\n"
+		"                            name - the name of the desired compression algorithms\n"
+		"                        available algorithms can be listed with trace-cmd list -c\n"	},
 	{
 		NULL, NULL, NULL
 	}
-- 
2.31.1


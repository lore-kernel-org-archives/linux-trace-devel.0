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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A97FC48BE8
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:52:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37E2361357
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:52:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232642AbhFNHyY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 03:54:24 -0400
Received: from mail-ej1-f41.google.com ([209.85.218.41]:45707 "EHLO
        mail-ej1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232636AbhFNHyX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 03:54:23 -0400
Received: by mail-ej1-f41.google.com with SMTP id k7so15034156ejv.12
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dpwXI5URK9HmN13gX7A6+hGktVkSdJlOwZaZ0ky6UkA=;
        b=lLLXmkpTIXzNnZo5TtaeBCEucOYurjv1vQa4UajGN/OzaWzH7pfHCWJU2tz5d4AdOs
         2FGrx7F+BAPmuz3hnslLYGsCLZqoPmXS0y5B/4ogzs2R0Ka8u0vS2nZXYmbp8n1Qn+kr
         NzG4m06hJme3JUim96RNtKi0Qe+iAvv0JfTLaKPW1DXAoQdEyKGViQTDHQeaGdWw+yDa
         ZyMzUX/oZqBE6lXyMwHhYMpFiIHRt43phFJuMmkNldSteoopVygHaKL0hA44zjDn5x3t
         YigmWx0l66WWe6yL8lc+YNpiCXs7vCOoCOjWqow4jpqzUF/sqr8ZvJLDWkjYhJRkWcod
         bcGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dpwXI5URK9HmN13gX7A6+hGktVkSdJlOwZaZ0ky6UkA=;
        b=pNZeTYeq4G1rvGFcZpSMCYVKkXvjusfeoOPgyGUaI1hWOuKnmaqizfpBsbjO/gYDSX
         LfhT9PyZE8QsWitlllnrrQ1IbSfb3U625dvocnAQDI7lfewi52Gzq5PtZA8JjjQebvD3
         TgOoBxGVh9debFDzlUFKK8Am9vIoCruqFEx6JiO+6Ne8JYpy6+GvNLbaLKdAydky6eVa
         uYIKTf4L6po88DjN5myAiui5jM5cGrM8owfZibzJdyJJMrWcMDz+eZBPuZZFWWrWCplD
         5hpIlAolK8T19gpGk4I4uHp9bVih/9txVUlmL7YTRO3doBgSuHYnK10hGOxzaShb7ubO
         7xkQ==
X-Gm-Message-State: AOAM532dU6Teiopg+MyWPzBxY2jfgzSGoGK7moGzf53/jWrzAYyRcrUZ
        aot3KpnUqYaY0LsJXLkXQfM=
X-Google-Smtp-Source: ABdhPJwPrOIJzelTAlZNmvrm15CxroEnOAT7wLQHEVvwBapa5IZ51H0iVSKGby+aQFGZIUP8BxkoPQ==
X-Received: by 2002:a17:906:3d9:: with SMTP id c25mr14392535eja.63.1623657069842;
        Mon, 14 Jun 2021 00:51:09 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f6sm6536444eja.108.2021.06.14.00.51.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 00:51:09 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 40/45] trace-cmd: Add new command "trace-cmd convert"
Date:   Mon, 14 Jun 2021 10:50:24 +0300
Message-Id: <20210614075029.598048-41-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210614075029.598048-1-tz.stoyanov@gmail.com>
References: <20210614075029.598048-1-tz.stoyanov@gmail.com>
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
 tracecmd/trace-convert.c       | 94 ++++++++++++++++++++++++++++++++++
 tracecmd/trace-usage.c         | 12 +++++
 5 files changed, 110 insertions(+)
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
index 00000000..555e0c0a
--- /dev/null
+++ b/tracecmd/trace-convert.c
@@ -0,0 +1,94 @@
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
+	tracecmd_close(ihandle);
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


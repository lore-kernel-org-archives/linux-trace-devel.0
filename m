Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6DF2C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:19:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9033B610A6
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:19:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233105AbhINNUu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbhINNUt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:20:49 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5999EC061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:19:32 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id q11so20154607wrr.9
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1fqdWuvMaHgw48cIfIMXHNlhX0xndP0gWQV3+EcLyFg=;
        b=nkvP5HL2+x/60c4IsRDdlTzvEdEGpVaopGXYyO+djfOgvrz5o6dva8ngeXzJ853CGW
         zIAGcNwsHaPrIw/lfGg/FseHlnBMW/SZWypxSIwPlIuswLbpqDdCN+sFFuam0B5Jl1TL
         GYhkg/GN/BM0Rne7qKTDAUW28r8YPLM/fAsy10wyTKtrJQKejJtV5r2el5eVqq3Dufbf
         UqwnBaJH+dx0v6X4pW52zG9WC403psGYdo/s+/wOjRlTJ6+vim7lRK7lwg1bkExCjVcC
         im5MDhWhThFPjfzRrTlq3t4/YVPdTZk7poCnM4wEVC7eqhJpSVfGnlbp2ddvVyoTnHj7
         CWZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1fqdWuvMaHgw48cIfIMXHNlhX0xndP0gWQV3+EcLyFg=;
        b=z/L3xuuy4vK2sUKv+vfuaswQdIfcrSgboVOv3TJ3sdPSxqB0GJm22wXBQoDRM1cx0A
         DSQBFnRpXRQwvtBsDFDQK73s3Vthl6KVKNOlvbsTVck9lcjSe20Evr7q19wGPtcUiKy7
         CdgVIzcWtTYk508sBBf4GpUg334j1+CshTjg3MKxHF1y0mKvCcINAC1PJOr7xmPxYV4C
         6ddjJrC3vc/ef/2gJ3OnEAggm90ZglYu8XBN01luXgF7ZrSryU1pNsv9Ll8APYwSz/no
         dWWi56KBIuv1/zLZJvUzn4yRgvZKFDJTZD4eeDnyuNfBstLDjQFR8XprZ5B6yU2w9mvE
         fm5Q==
X-Gm-Message-State: AOAM531PQVq2pLfm9qNU0me9b50YW32+kbmYQxBs4E4yayftLxmk6Sdr
        T0QT0e1ob307bxNUDZ5fgP3APskAosM=
X-Google-Smtp-Source: ABdhPJwb/wzWu5qu4RfLQLSsTkaYuH4ujgc1mXlpZyyg8RZ409jy8bQxRDqx8fz4vTlZ8CrCzsnLVg==
X-Received: by 2002:a5d:4d4f:: with SMTP id a15mr18972153wru.210.1631625570923;
        Tue, 14 Sep 2021 06:19:30 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f18sm4545302wrw.63.2021.09.14.06.19.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:19:30 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 8/8] trace-cmd: Add new subcommand "convert"
Date:   Tue, 14 Sep 2021 16:19:21 +0300
Message-Id: <20210914131921.3967421-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131921.3967421-1-tz.stoyanov@gmail.com>
References: <20210914131921.3967421-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

There is a need to convert trace files between different versions. A new
"trace-cmd convert" subcommand is introduced, which reads an input
trace file and copies to an output trace file. Both files can be from
different versions.
 trace-cmd convert -i <input file> -o <output file> --file-version <ver>
--compression <compression>

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/Makefile              |   1 +
 tracecmd/include/trace-local.h |   2 +
 tracecmd/trace-cmd.c           |   1 +
 tracecmd/trace-convert.c       | 106 +++++++++++++++++++++++++++++++++
 tracecmd/trace-usage.c         |  13 ++++
 5 files changed, 123 insertions(+)
 create mode 100644 tracecmd/trace-convert.c

diff --git a/tracecmd/Makefile b/tracecmd/Makefile
index b7a23dc4..56742f0a 100644
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
index 9fc126e4..a83a8d0b 100644
--- a/tracecmd/trace-cmd.c
+++ b/tracecmd/trace-cmd.c
@@ -133,6 +133,7 @@ struct command commands[] = {
 	{"list", trace_list},
 	{"help", trace_usage},
 	{"dump", trace_dump},
+	{"convert", trace_convert},
 	{"-h", trace_usage},
 };
 
diff --git a/tracecmd/trace-convert.c b/tracecmd/trace-convert.c
new file mode 100644
index 00000000..c3b2c1d7
--- /dev/null
+++ b/tracecmd/trace-convert.c
@@ -0,0 +1,106 @@
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
+static void convert_file(const char *in, const char *out, int file_version, char *compr)
+{
+	struct tracecmd_input *ihandle;
+	struct tracecmd_output *ohandle;
+
+	ihandle = tracecmd_open_head(in, 0);
+	if (!ihandle)
+		die("error reading %s", in);
+	ohandle = tracecmd_copy(ihandle, out, TRACECMD_FILE_CPU_FLYRECORD, file_version, compr);
+	if (!ohandle)
+		die("error writing %s", out);
+	tracecmd_output_close(ohandle);
+	tracecmd_close(ihandle);
+}
+
+enum {
+	OPT_file_version	= 254,
+	OPT_compression		= 255,
+};
+
+void trace_convert(int argc, char **argv)
+{
+	char *input_file = NULL;
+	char *output_file = NULL;
+	char *compression = NULL;
+	int file_version = FILE_VERSION_DEFAULT;
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
+			{"compression", required_argument, NULL, OPT_compression},
+			{"file-version", required_argument, NULL, OPT_file_version},
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
+				die("Only one input file is supported, %s already set",
+				    input_file);
+			input_file = optarg;
+			break;
+		case 'o':
+			if (output_file)
+				die("Only one output file is supported, %s already set",
+				    output_file);
+			output_file = optarg;
+			break;
+		case OPT_compression:
+			if (strcmp(optarg, "any") && strcmp(optarg, "none") &&
+			    !tracecmd_compress_is_supported(optarg, NULL))
+				die("Compression algorithm  %s is not supported", optarg);
+			compression = optarg;
+			break;
+		case OPT_file_version:
+			file_version = atoi(optarg);
+			if (file_version < FILE_VERSION_MIN || file_version > FILE_VERSION_MAX)
+				die("Unsupported file version %d, "
+				    "supported versions are from %d to %d",
+				    file_version, FILE_VERSION_MIN, FILE_VERSION_MAX);
+
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
+	convert_file(input_file, output_file, file_version, compression);
+}
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 77898c1c..ec0af46f 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -412,6 +412,19 @@ static struct usage_help usage_help[] = {
 		"          -h, --help show usage information\n"
 		"          --verbose 'level' Set the desired log level\n"
 	},
+	{
+		"convert",
+		"convert trace file to different version",
+		" %s convert [options]\n"
+		"          -i input file, default is trace.dat\n"
+		"          -o output file, mandatory parameter.\n"
+		"             The output file can be specified also as last argument of the command\n"
+		"          --file-version set the desired trace file version\n"
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


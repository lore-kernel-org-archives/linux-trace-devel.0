Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6825C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:27:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241205AbhLBMbB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:31:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346749AbhLBMa7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:30:59 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 189FFC061758
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:27:36 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id x6so114958570edr.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:27:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z0N+74W9DmP3ClcW+4Tenz8qOB7sCLlV0uvial0H8Bw=;
        b=OVkuEgg0fvA9J+asTOb5KZlpFfXDCNB/ga/Y7zmaB9jKRcVsXjClquJd8/dWZRbyRD
         QaO4A+Z11G22WXO18g3tQxycyUafS7/wKAcV+sbVbkJR+jnGUjuu5akYRraHLVjsOeXx
         /qY6+6uRiChAAKQMJkOHH66YNxMgyRXENMXy+FvUQoUjnu6UPBgThpVJIW7V/yS2E0nq
         umM9CrB10BHSDhMPUmrW7tZLeoKn9sr/JLja6Iq2Q/pRfvOiZIlhBMJLSS0cktS1FJjX
         mau7v5FWUOlM22A6FSODNhPb1pDm1gvN+wE3SvFbrctFOQC6KyCWU7prUHvqh1RBpveh
         k6QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z0N+74W9DmP3ClcW+4Tenz8qOB7sCLlV0uvial0H8Bw=;
        b=MInIYlbd6f3qpIfyO8ZLrt/WeSilbeGzY0QMqTva4WOR4Ma27YzB75PNaLdB9XG/7z
         ywpcoJ7Bf8OT5f5QpAxZRyENgRJQVBnXMNQOoDSBPKKDsWAKDfWLVt1G3rcQK1bayRCe
         9St5iwitdSmXLxRGykCyEdNqvoOSwOqxZWZFMN58YJKX315KfP+9qz6NyTcRx4iXS5jp
         tgGcDgu0CSbwgkpbu3Amcy+FVqWG5DL1Rn7ZdxZiPHYEyq2B50uBfznd1+VXbPILsava
         tU882KRUvVGuhNM4UtTvOJEhWAHYvSoO6PEPCsXeaJnoZjcnOyFnfo5lq80DZosx3b/e
         YmIw==
X-Gm-Message-State: AOAM5322xZmCDG3YsyYJiRkfOdBB7QOKqANTPP3hNL9NBK4KUqFSEivN
        ko7paz48/fqHjBJQ80b7U+2tQq0F9WTyKA==
X-Google-Smtp-Source: ABdhPJwUkgXq478pkSHCdaAAuq9u69FOU++2gkXNAvhHSSO77Jjt6moo4XvD0eMT1xiizXGF9ddBew==
X-Received: by 2002:aa7:dd47:: with SMTP id o7mr17331215edw.34.1638448055432;
        Thu, 02 Dec 2021 04:27:35 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u16sm2073403edr.43.2021.12.02.04.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:27:35 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 8/8] trace-cmd: Add new subcommand "convert"
Date:   Thu,  2 Dec 2021 14:27:26 +0200
Message-Id: <20211202122726.43775-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122726.43775-1-tz.stoyanov@gmail.com>
References: <20211202122726.43775-1-tz.stoyanov@gmail.com>
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
index 00000000..fc012af8
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
+	int file_version = tracecmd_default_file_version();
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
2.33.1


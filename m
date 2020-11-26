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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 617F8C56202
	for <linux-trace-devel@archiver.kernel.org>; Thu, 26 Nov 2020 07:37:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5D692075A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 26 Nov 2020 07:37:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="icwCh3VL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730788AbgKZHhJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 26 Nov 2020 02:37:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730641AbgKZHhJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 26 Nov 2020 02:37:09 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F991C0613D4
        for <linux-trace-devel@vger.kernel.org>; Wed, 25 Nov 2020 23:37:09 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id k14so1041549wrn.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 25 Nov 2020 23:37:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NHLMidEyzdMVeiqp0doN0UhjRgj0ncwXQngTZtz86r8=;
        b=icwCh3VLfYHI8Q3/Rhk/yE179wsp1rKC1yfdaCHx6HvBNrykIjI+mj2/pqLO1thwlq
         fkHNM0zryaiTaNZNnwAvrxD+iixWpiSDj6QWX2y/ZGDzpxHX583/jVg4EMRgjXUuqBpL
         ZFqBOlwbGIizahuHfov0FqoWWVUV2xP5vM3vjM0AHCftKbidni92dWJFaXvgYE7eUNDT
         T8G5miQFsLpvP7kzW5x60ialMTqO46uzLNEE4wS+D2xwzszfrfVCwY4zue+x/2rtTVss
         HF9E0fK4gec6FQvYAhh1Ct7d08FrhfLMNC+usWY7CfpXoxT7VW24uu8e+TnBfwaTtgdu
         uY/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NHLMidEyzdMVeiqp0doN0UhjRgj0ncwXQngTZtz86r8=;
        b=rF6Vc6lLtUogfcg6FJKMKTpxZIsXxeLDi+ixxGfG4wB11VsPlhYw92nE3VmXPCqeyb
         Ovg8YyDxIZV49XZZQxPBz+jMxnqitoJOrQS8VHq8MUiRvPPNXiBShhRCK9z59LHWD58j
         c2nov3asoQ1QZcWhs1XnW3LLabpapyPT6O1v1vPj2vqgJp0BhISODxZ9poyKRn2TI6/R
         atlyKImvJ+iAi9FBCVziEc2xSByA9aucFqDaTwDdJZhlJdJ8cKSK9ZZBdzWtjYXD2Glg
         dgTFz/DoOpJcEabctt193iuACyHS+8qxXESjs5xr3VH9Ee4EKBCIjh3EX2o7mIW9tYwO
         rayw==
X-Gm-Message-State: AOAM533vYhWmJkDenX9PQlhAqaRr9aAGtc2i6BahZU7iM3g+55hXctko
        JtcyEJSXtTobpk6Ajd/RyFZANeutraUyjTpd
X-Google-Smtp-Source: ABdhPJx03frEo7seImZay9LTycDJCPMWEUDHdEQwK0QNzd8pKA4r+Nda5JqmRpvga43XTkki8iFPtw==
X-Received: by 2002:adf:fd03:: with SMTP id e3mr2069660wrr.303.1606376227727;
        Wed, 25 Nov 2020 23:37:07 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s8sm7963435wrn.33.2020.11.25.23.37.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 23:37:06 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2] trace-cmd: Enhance "trace-cmd clear" to be instance aware
Date:   Thu, 26 Nov 2020 09:37:05 +0200
Message-Id: <20201126073705.907666-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added new options "trace-cmd clear -B <name> -a" which allow the command
to work per ftrace instance:
-B clear the given buffer (may specify multiple -B)
-a clear all existing buffers, including the top level one

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
v2 changes:
 - Changed the implementation to use the latest libtracefs APIs. 

 Documentation/trace-cmd-clear.1.txt |  13 ++-
 tracecmd/Makefile                   |   1 +
 tracecmd/trace-clear.c              | 126 ++++++++++++++++++++++++++++
 tracecmd/trace-record.c             |  24 ------
 tracecmd/trace-usage.c              |   4 +-
 5 files changed, 142 insertions(+), 26 deletions(-)
 create mode 100644 tracecmd/trace-clear.c

diff --git a/Documentation/trace-cmd-clear.1.txt b/Documentation/trace-cmd-clear.1.txt
index 67e5851a..a0ae36e9 100644
--- a/Documentation/trace-cmd-clear.1.txt
+++ b/Documentation/trace-cmd-clear.1.txt
@@ -7,12 +7,23 @@ trace-cmd-clear - clear the Ftrace buffer.
 
 SYNOPSIS
 --------
-*trace-cmd clear*
+*trace-cmd clear* ['OPTIONS']
 
 DESCRIPTION
 -----------
 The *trace-cmd(1) clear* clears the content of the Ftrace ring buffer.
 
+OPTIONS
+-------
+*-B* 'buffer-name'::
+    If the kernel supports multiple buffers, this will clear only the given
+    buffer. It does not affect any other buffers. This may be used multiple
+    times to specify different buffers. The top level buffer will not be
+    clearded if this option is given.
+
+*-a*::
+    Clear all existing buffers, including the top level one.
+
 SEE ALSO
 --------
 trace-cmd(1), trace-cmd-record(1), trace-cmd-report(1), trace-cmd-start(1),
diff --git a/tracecmd/Makefile b/tracecmd/Makefile
index 5e59adf8..01f36c61 100644
--- a/tracecmd/Makefile
+++ b/tracecmd/Makefile
@@ -31,6 +31,7 @@ TRACE_CMD_OBJS += trace-show.o
 TRACE_CMD_OBJS += trace-list.o
 TRACE_CMD_OBJS += trace-usage.o
 TRACE_CMD_OBJS += trace-dump.o
+TRACE_CMD_OBJS += trace-clear.o
 ifeq ($(VSOCK_DEFINED), 1)
 TRACE_CMD_OBJS += trace-tsync.o
 endif
diff --git a/tracecmd/trace-clear.c b/tracecmd/trace-clear.c
new file mode 100644
index 00000000..608b9598
--- /dev/null
+++ b/tracecmd/trace-clear.c
@@ -0,0 +1,126 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2008, 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
+ *
+ * Updates:
+ * Copyright (C) 2020, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
+ *
+ */
+#include <stdlib.h>
+#include <unistd.h>
+#include <getopt.h>
+
+#include "tracefs.h"
+#include "trace-local.h"
+
+struct instances_list {
+	struct instances_list *next;
+	struct tracefs_instance *instance;
+};
+
+static int add_new_instance(struct instances_list **list, char *name)
+{
+	struct instances_list *new;
+
+	if (!tracefs_instance_exists(name))
+		return -1;
+	new = calloc(1, sizeof(*new));
+	if (!new)
+		return -1;
+	new->instance = tracefs_instance_create(name);
+	if (!new->instance) {
+		free(new);
+		return -1;
+	}
+
+	new->next = *list;
+	*list = new;
+	return 0;
+}
+
+static int add_instance_walk(const char *name, void *data)
+{
+	return add_new_instance((struct instances_list **)data, (char *)name);
+}
+
+static void clear_list(struct instances_list *list)
+{
+	struct instances_list *del;
+
+	while (list) {
+		del = list;
+		list = list->next;
+		tracefs_instance_free(del->instance);
+		free(del);
+	}
+}
+
+static void clear_instance_trace(struct tracefs_instance *instance)
+{
+	FILE *fp;
+	char *path;
+
+	/* reset the trace */
+	path = tracefs_instance_get_file(instance, "trace");
+	fp = fopen(path, "w");
+	if (!fp)
+		die("writing to '%s'", path);
+	tracefs_put_tracing_file(path);
+	fwrite("0", 1, 1, fp);
+	fclose(fp);
+}
+
+static void clear_trace(struct instances_list *instances)
+{
+	if (instances) {
+		while (instances) {
+			clear_instance_trace(instances->instance);
+			instances = instances->next;
+		}
+	} else
+		clear_instance_trace(NULL);
+}
+
+void trace_clear(int argc, char **argv)
+{
+	struct instances_list *instances = NULL;
+	bool all = false;
+	int c;
+
+	for (;;) {
+		int option_index = 0;
+		static struct option long_options[] = {
+			{"all", no_argument, NULL, 'a'},
+			{"help", no_argument, NULL, '?'},
+			{NULL, 0, NULL, 0}
+		};
+
+		c = getopt_long (argc-1, argv+1, "+haB:",
+				 long_options, &option_index);
+		if (c == -1)
+			break;
+		switch (c) {
+		case 'B':
+			if (add_new_instance(&instances, optarg))
+				die("Failed to allocate instance %s", optarg);
+			break;
+		case 'a':
+			all = true;
+			if (tracefs_instances_walk(add_instance_walk, &instances))
+				die("Failed to add all instances");
+			break;
+		case 'h':
+		case '?':
+		default:
+			usage(argv);
+			break;
+		}
+	}
+
+	clear_trace(instances);
+	if (all)
+		clear_trace(NULL);
+	clear_list(instances);
+	exit(0);
+}
+
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 908adb93..3a63f1bd 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -845,21 +845,6 @@ static void clear_trace_instances(void)
 		__clear_trace(instance);
 }
 
-static void clear_trace(void)
-{
-	FILE *fp;
-	char *path;
-
-	/* reset the trace */
-	path = tracefs_get_tracing_file("trace");
-	fp = fopen(path, "w");
-	if (!fp)
-		die("writing to '%s'", path);
-	tracefs_put_tracing_file(path);
-	fwrite("0", 1, 1, fp);
-	fclose(fp);
-}
-
 static void reset_max_latency(struct buffer_instance *instance)
 {
 	tracefs_instance_file_write(instance->tracefs,
@@ -6701,15 +6686,6 @@ void trace_profile(int argc, char **argv)
 	exit(0);
 }
 
-void trace_clear(int argc, char **argv)
-{
-	if (argc > 2)
-		usage(argv);
-	else
-		clear_trace();
-	exit(0);
-}
-
 void trace_record(int argc, char **argv)
 {
 	struct common_record_context ctx;
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 3f0b2d07..79610bd3 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -180,7 +180,9 @@ static struct usage_help usage_help[] = {
 	{
 		"clear",
 		"clear the trace buffers",
-		" %s clear\n"
+		" %s clear [-B buf][-a]\n"
+		"          -B clear the given buffer (may specify multiple -B)\n"
+		"          -a clear all existing buffers, including the top level one\n"
 	},
 	{
 		"report",
-- 
2.28.0


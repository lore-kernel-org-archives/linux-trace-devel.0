Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF796C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Feb 2022 20:25:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiBUU0J (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Feb 2022 15:26:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232386AbiBUU0J (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Feb 2022 15:26:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A0322BFF
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Feb 2022 12:25:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2766B8179C
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Feb 2022 20:25:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C40BC340E9
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Feb 2022 20:25:41 +0000 (UTC)
Date:   Mon, 21 Feb 2022 15:25:39 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtraceevent: Add sample program to test events
Message-ID: <20220221152539.6671a413@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add a samples directory and the program test-event that can be used to
parse a given event. I found that when an event fails in trace-cmd, it
can be a burden to try to debug it as you may need to go through all the
events to get to the buggy event.

The test-event will let you simply copy and paste the event format into
a file, and read it and it will parse it, giving any errors that it
finds. This makes running the parser under gdb much easier.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Makefile             |   3 +
 samples/Makefile     |  26 ++++++++
 samples/test-event.c | 154 +++++++++++++++++++++++++++++++++++++++++++
 scripts/utils.mk     |   8 +++
 4 files changed, 191 insertions(+)
 create mode 100644 samples/Makefile
 create mode 100644 samples/test-event.c

diff --git a/Makefile b/Makefile
index 85855b0..94e8de4 100644
--- a/Makefile
+++ b/Makefile
@@ -419,6 +419,9 @@ PHONY += install_plugins
 install_plugins: plugins
 	$(Q)$(call descend,plugins,install)
 
+samples: libtraceevent.a force
+	$(Q)$(call descend,$(src)/samples,all)
+
 PHONY += clean_plugins
 clean_plugins:
 	$(Q)$(call descend_clean,plugins)
diff --git a/samples/Makefile b/samples/Makefile
new file mode 100644
index 0000000..2962611
--- /dev/null
+++ b/samples/Makefile
@@ -0,0 +1,26 @@
+# SPDX-License-Identifier: LGPL-2.1
+
+include $(src)/scripts/utils.mk
+
+TARGETS :=
+TARGETS += test-event
+
+sdir := $(obj)/samples
+
+TARGETS := $(patsubst %,$(sdir)/%,$(TARGETS))
+
+all: $(TARGETS)
+
+$(sdir):
+	@mkdir -p $(sdir)
+
+$(TARGETS): $(sdir) $(LIBTRACEEVENT_STATIC)
+
+$(sdir)/%: $(bdir)/%.o
+	$(call do_sample_build,$@,$<)
+
+$(bdir)/%.o: $(bdir)/%.c
+	$(Q)$(CC) -o $@ -c $< $(CFLAGS) $(INCLUDES)
+
+clean:
+	$(Q)$(call do_clean,$(sdir)/*)
diff --git a/samples/test-event.c b/samples/test-event.c
new file mode 100644
index 0000000..b25da1e
--- /dev/null
+++ b/samples/test-event.c
@@ -0,0 +1,154 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2022 Google Inc, Steven Rostedt <rostedt@goodmis.org>
+ */
+#include <stdlib.h>
+#include <stdarg.h>
+#include <string.h>
+#include <stdio.h>
+#include <errno.h>
+#include <getopt.h>
+#include <event-parse.h>
+
+static char *argv0;
+
+static char *get_this_name(void)
+{
+	static char *this_name;
+	char *arg;
+	char *p;
+
+	if (this_name)
+		return this_name;
+
+	arg = argv0;
+	p = arg+strlen(arg);
+
+	while (p >= arg && *p != '/')
+		p--;
+	p++;
+
+	this_name = p;
+	return p;
+}
+
+static void usage(void)
+{
+	char *p = get_this_name();
+
+	printf("usage: %s [options]\n"
+	       " -h : this message\n"
+	       " -s system : the system for the event\n"
+	       " -e format : the event format file\n"
+	       " -f file : file to read the event from\n"
+	       "      otherwise, reads from stdin\n"
+	       "\n",p);
+	exit(-1);
+}
+
+static void __vdie(const char *fmt, va_list ap, int err)
+{
+	int ret = errno;
+	char *p = get_this_name();
+
+	if (err && errno)
+		perror(p);
+	else
+		ret = -1;
+
+	fprintf(stderr, "  ");
+	vfprintf(stderr, fmt, ap);
+
+	fprintf(stderr, "\n");
+	exit(ret);
+}
+
+void die(const char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	__vdie(fmt, ap, 0);
+	va_end(ap);
+}
+
+void pdie(const char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	__vdie(fmt, ap, 1);
+	va_end(ap);
+}
+
+/* Must be a power of two */
+#define BUFALLOC	1024
+#define BUFMASK		(~(BUFALLOC - 1))
+
+int main(int argc, char **argv)
+{
+	struct tep_handle *tep;
+	struct tep_event *event;
+	FILE *file = stdin;
+	FILE *fp = NULL;
+	char *system = NULL;
+	char *event_buf = NULL;
+	int esize = 0;
+	int c;
+
+	argv0 = argv[0];
+
+	while ((c = getopt(argc, argv, "hs:e:f:")) >= 0) {
+		switch (c) {
+		case 's':
+			system = optarg;
+			break;
+		case 'e':
+			event_buf = optarg;
+			file = NULL;
+			break;
+		case 'f':
+			fp = fopen(optarg, "r");
+			if (!fp)
+				pdie("%s", optarg);
+			file = fp;
+			break;
+		case 'h':
+			usage();
+		}
+	}
+	if (file) {
+		char *line = NULL;
+		size_t n = 0;
+		int len;
+
+		while (getline(&line, &n, file) > 0) {
+			len = strlen(line) + 1;
+
+			if (((esize - 1) & BUFMASK) < ((esize + len) & BUFMASK)) {
+				int a;
+
+				a = (esize + len + BUFALLOC - 1) & BUFMASK;
+				event_buf = realloc(event_buf, a);
+				if (!event_buf)
+					pdie("allocating event");
+			}
+			strcpy(event_buf + esize, line);
+			esize += len - 1;
+		}
+		free(line);
+	}
+
+	tep = tep_alloc();
+	if (!tep)
+		pdie("Allocating tep handle");
+
+	tep_set_loglevel(TEP_LOG_ALL);
+
+	if (!system)
+		system = "test";
+
+	if (tep_parse_format(tep, &event, event_buf, esize, system))
+		die("Failed to parse event");
+
+}
diff --git a/scripts/utils.mk b/scripts/utils.mk
index e33a817..7139088 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -91,6 +91,14 @@ do_clean =					\
 	($(print_clean)				\
 	$(RM) $1)
 
+do_sample_build =							\
+	$(Q)($(print_sample_build)					\
+	$(CC) -o $1 $2 $(CFLAGS) $(LIBTRACEEVENT_STATIC) -ldl)
+
+do_sample_obj =									\
+	$(Q)($(print_sample_obj)						\
+	$(CC) -g -Wall -c $(CFLAGS) -o $1 $2 -I../include/)
+
 #
 # Define a callable command for descending to a new directory
 #
-- 
2.34.1


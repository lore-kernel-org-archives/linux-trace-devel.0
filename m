Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B0DEC64E7B
	for <linux-trace-devel@archiver.kernel.org>; Tue,  1 Dec 2020 21:07:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00DF920665
	for <linux-trace-devel@archiver.kernel.org>; Tue,  1 Dec 2020 21:07:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387691AbgLAVHl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 1 Dec 2020 16:07:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:42946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387547AbgLAVHk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 1 Dec 2020 16:07:40 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E85CB2065C;
        Tue,  1 Dec 2020 21:06:57 +0000 (UTC)
Date:   Tue, 1 Dec 2020 16:06:56 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [RFC][PATCH] ftrace/selftests: Add binary test to verify ring
 buffer timestamps
Message-ID: <20201201160656.7cc6a5e8@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

A bug was reported about the ftrace ring buffer going backwards:

Link: https://lore.kernel.org/r/20201124223917.795844-1-elavila@google.com

In debugging this code, I wrote a C program that uses libtracefs to enable
all events and function tracing (if it exits), and then read the raw ring
buffer binary data and make sure that all the events never go backwards. If
they do, then it does a dump of the ring buffer sub buffer page and shows
the layout of the events and their deltas.

This was a very useful tool, and can be used to make sure that the ring
buffer's timestamps are consistently monotonic.

Adding this to the ftrace selftests seems to be a way that this can be
tested more often. But this would introduce the first binary code to the
ftracetests.

To make sure that the tests still work on embedded devices (where a
compiler may not even exist), and also since this binary incorporates the
yet-to-be-released libtracefs library, if the make fails, the test exits
with UNTESTED. The UNTESTED is documented as being a place holder which
this would be if the make does not work.

Thoughts?

Soon-to-be-signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
diff --git a/tools/testing/selftests/ftrace/test-ring-buffer/Makefile b/tools/testing/selftests/ftrace/test-ring-buffer/Makefile
new file mode 100644
index 000000000000..86f96b6fed9f
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test-ring-buffer/Makefile
@@ -0,0 +1,32 @@
+
+LD_PATH := -L/usr/local/lib/tracefs/ -L/usr/local/lib/traceevent
+
+TARGETS = test-ring-buffer
+
+PKG_CONFIG = pkg-config
+TRACEFS_INCLUDES = $(shell $(PKG_CONFIG) --cflags libtracefs 2>/dev/null)
+TRACEFS_LIBS = $(shell $(PKG_CONFIG) --libs libtracefs 2>/dev/null)
+
+TRACEEVENT_INCLUDES = $(shell $(PKG_CONFIG) --cflags libtraceevent 2>/dev/null)
+TRACEEVENT_LIBS = $(shell $(PKG_CONFIG) --libs libtraceevent 2>/dev/null)
+
+ifeq ("$(TRACEFS_INCLUDES)","")
+$(error no libtracefs found)
+endif
+
+ifeq ("$(TRACEEVENT_INCLUDES)","")
+$(error no libtraceevent found)
+endif
+
+LIBS = $(TRACEFS_LIBS) $(TRACEEVENT_LIBS) -ldl
+
+CFLAGS := $(TRACEFS_INCLUDES) $(TRACEEVENT_INCLUDES)
+
+all: $(TARGETS)
+
+test-ring-buffer: test-ring-buffer.c
+	gcc -g -Wall -o $@ $(CFLAGS) $^ $(LIBS)
+
+clean:
+	$(RM) $(TARGETS) *.o
+
diff --git a/tools/testing/selftests/ftrace/test-ring-buffer/test-ring-buffer.c b/tools/testing/selftests/ftrace/test-ring-buffer/test-ring-buffer.c
new file mode 100644
index 000000000000..af823e2102ff
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test-ring-buffer/test-ring-buffer.c
@@ -0,0 +1,399 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdarg.h>
+#include <string.h>
+#include <errno.h>
+#include <unistd.h>
+#include <signal.h>
+#include <stdbool.h>
+#include <sys/types.h>
+#include <fcntl.h>
+
+#include <tracefs.h>
+#include <kbuffer.h>
+
+typedef long long u64;
+
+static char *THIS_NAME;
+static struct tep_handle *tep;
+
+static void __vdie(const char *fmt, va_list ap, int err)
+{
+	int ret = errno;
+
+	if (err && errno)
+		perror(THIS_NAME);
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
+static void usage(char **argv)
+{
+	char *arg = argv[0];
+	char *p = arg+strlen(arg);
+
+	while (p >= arg && *p != '/')
+		p--;
+	p++;
+
+	printf("\nusage: %s timeout\n"
+	       "\n",p);
+	exit(-1);
+}
+
+static int tfd;
+static int result;
+static int done = 1;
+
+static void stop(int sig)
+{
+	write(tfd, "0", 1);
+	done = 0;
+}
+
+static struct last_info {
+	u64			timestamp;
+	void 			*content;
+	void 			*content_next;
+	unsigned long		page;
+	int			index;
+	int			irq;
+	int			sirq;
+} *info;
+
+static int page_size;
+
+static void *get_meta_data(struct tep_record *record)
+{
+	void *p = record->data;
+	int type_len;
+
+	if (record->size > 120) {
+		int size;
+
+		p -= 4;
+		size = *(unsigned int *)p;
+		p -= 4;
+		type_len = *(unsigned int *)p;
+		if (size != record->size + 4)
+			die("Expected size %d but found %d (%d)\n",
+			    record->size + 4,
+			    size, type_len);
+	} else
+		p -= 4;
+
+	return p;
+}
+
+static void init_content(struct last_info *info, int cpu,
+			 struct tep_record *record)
+{
+	int type_len;
+	void *p;
+
+	p = get_meta_data(record);
+	p -= 8;
+
+	type_len = *(unsigned int *)p;
+	/* FIXME for big endian */
+	type_len = type_len & ((1 << 5) - 1);
+	switch (type_len) {
+	case KBUFFER_TYPE_TIME_EXTEND:
+	case KBUFFER_TYPE_TIME_STAMP:
+		p -= 8;
+		break;
+	}
+	p -= sizeof(long);
+	memcpy(info[cpu].content, p, (record->data - p) + record->size);
+	info[cpu].page = (unsigned long)p;
+	info[cpu].content_next = record->data + record->size;
+}
+
+static void update_content(struct last_info *info, int cpu,
+			   struct tep_record *record)
+{
+	int size = (record->data + record->size) - info[cpu].content_next;
+	int start = info[cpu].content_next - (void *)info[cpu].page;
+
+	memcpy(info[cpu].content + start, (void *)info[cpu].page + start, size);
+	info[cpu].content_next = record->data + record->size;
+}
+
+static int read_kbuf_record(struct kbuffer *kbuf, struct tep_record *record)
+{
+	unsigned long long ts;
+	void *ptr;
+
+	ptr = kbuffer_read_event(kbuf, &ts);
+	if (!ptr || !record)
+		return -1;
+
+	memset(record, 0, sizeof(*record));
+	record->ts = ts;
+	record->size = kbuffer_event_size(kbuf);
+	record->record_size = kbuffer_curr_size(kbuf);
+	record->cpu = 0;
+	record->data = ptr;
+	record->ref_count = 1;
+
+	kbuffer_next_event(kbuf, NULL);
+
+	return 0;
+}
+
+static unsigned get_delta(void *p)
+{
+	return (*(unsigned *)p & ((1<<27)-1) << 5) >> 5;
+}
+
+static unsigned long long get_extend_delta(void *p)
+{
+	unsigned long long delta;
+	unsigned long long extend;
+
+	delta = get_delta(p);
+	p += 4;
+	extend = *(unsigned *)p;
+
+	return (extend << 27) + delta;
+}
+
+static void check_meta(void *p, bool show)
+{
+	int type_len;
+
+	type_len = *(unsigned *)p & ((1<<5)-1);
+	if (show)
+		printf(" type_len=%d\n", type_len);
+	switch (type_len) {
+	case KBUFFER_TYPE_TIME_EXTEND:
+		printf("   TIME_EXTEND: delta: %lld\n", get_extend_delta(p));
+		break;
+	case KBUFFER_TYPE_TIME_STAMP:
+		printf("   TIME_STAMP: stamp: %lld\n", get_extend_delta(p));
+		break;
+	}
+}
+
+static void dump_content(struct last_info *info, int cpu,
+			 struct tep_record *this_record)
+{
+	struct tep_record record;
+	struct kbuffer *kbuf;
+	enum kbuffer_long_size kls;
+	int last = info[cpu].content_next - (void *)info[cpu].page;
+	int ret;
+	void *p;
+
+	switch (sizeof(long)) {
+	case 4:
+		kls = KBUFFER_LSIZE_4;
+		break;
+	default:
+		kls = KBUFFER_LSIZE_8;
+		break;
+	}
+
+
+	kbuf = kbuffer_alloc(kls, KBUFFER_ENDIAN_LITTLE);
+	if (!kbuf)
+		die("Allocating kbuffer");
+	kbuffer_load_subbuffer(kbuf, info[cpu].content);
+
+	p = info[cpu].content;
+
+	printf(" [%lld] PAGE TIME STAMP\n", *(unsigned long long *)p);
+
+	p += 8 + sizeof(long);
+	check_meta(p, true);
+
+	while (!(ret = read_kbuf_record(kbuf, &record))) {
+		struct tep_event *event;
+		int id;
+
+		id = tep_data_type(tep, &record);
+		event = tep_find_event(tep, id);
+		if (!event) {
+			printf("Failed to find event!\n");
+			continue;
+		}
+
+		p = get_meta_data(&record);
+
+		printf(" [%lld] delta:%d (%d)\n", record.ts, get_delta(p), record.size);
+
+		if (info[cpu].content + last == record.data + record.size)
+			break;
+
+		check_meta(record.data + record.size, false);
+	}
+	kbuffer_free(kbuf);
+
+	if (!this_record)
+		return;
+
+	printf("\nDumping record buffer:\n");
+
+	init_content(info, cpu, this_record);
+	dump_content(info, cpu, NULL);
+}
+
+static int callback(struct tep_event *event,
+		    struct tep_record *record,
+		    int cpu, void *context)
+{
+	static int done;
+	int index;
+	int irq, sirq;
+	int flags;
+
+	if (done)
+		return 1;
+
+	if (!info[cpu].content) {
+		info[cpu].content = calloc(1, page_size);
+		if (!info[cpu].content)
+			die("Allocating content");
+	}
+	if (!info[cpu].page)
+		init_content(info, cpu, record);
+
+	index = (unsigned long)record->data - info[cpu].page;
+
+	if (index < 0) {
+		printf("HERE!\n");
+		info[cpu].page = (unsigned long)record->data;
+		info[cpu].index += index;
+		index = 0;
+	}
+
+	flags = tep_data_flags(event->tep, record);
+	irq = !!(flags & TRACE_FLAG_HARDIRQ);
+	sirq = !!(flags & TRACE_FLAG_SOFTIRQ);
+
+	if (info[cpu].timestamp > record->ts) {
+		stop(0);
+		printf("Record on cpu %d went backwards: %lld to %lld\n"
+		       "  last index = %d : this index = %d\n"
+		       "  last softirq = %d : last hardirq = %d\n",
+		       cpu, info[cpu].timestamp, record->ts,
+		       info[cpu].index, index, info[cpu].sirq, info[cpu].irq);
+		dump_content(info, cpu, record);
+		done = 1;
+		result = -1;
+		return 1;
+	}
+
+	if (info[cpu].content_next > record->data)
+		init_content(info, cpu, record);
+	else
+		update_content(info, cpu, record);
+
+	info[cpu].timestamp = record->ts;
+	if (info[cpu].index > index) {
+		info[cpu].sirq = sirq;
+		info[cpu].irq = irq;
+	} else {
+		info[cpu].sirq |= sirq;
+		info[cpu].irq |= irq;
+	}
+	info[cpu].index = index;
+	return 0;
+}
+
+static void test_buffer(struct tep_handle *tep, int timeout)
+{
+	signal(SIGALRM, stop);
+	alarm(timeout);
+
+	tracefs_iterate_raw_events(tep, NULL, callback, NULL);
+}
+
+int main (int argc, char **argv)
+{
+	char *current_tracer;
+	char *events_enable;
+	char *tracing_on;
+	int time;
+	int cpus;
+	int efd;
+	int cfd;
+
+	THIS_NAME = argv[0];
+
+	if (argc < 2)
+		usage(argv);
+
+	page_size = getpagesize();
+
+	time = atoi(argv[1]);
+	if (time <= 0)
+		usage(argv);
+
+	tep = tracefs_local_events(NULL);
+	if (!tep)
+		pdie("Error loading events");
+
+	events_enable = tracefs_instance_get_file(NULL, "events/enable");
+	current_tracer = tracefs_instance_get_file(NULL, "current_tracer");
+	tracing_on = tracefs_instance_get_file(NULL, "tracing_on");
+
+	if (!events_enable || !current_tracer || !tracing_on)
+		pdie("Allocating strings");
+
+	cpus = sysconf(_SC_NPROCESSORS_CONF);
+
+	info = calloc(cpus, sizeof(*info));
+	if (!info)
+		pdie("Allocating per cpu info");
+
+	efd = open(events_enable, O_WRONLY);
+	if (efd < 0)
+		pdie(events_enable);
+
+	cfd = open(current_tracer, O_WRONLY);
+	if (cfd < 0)
+		pdie(current_tracer);
+
+	tfd = open(tracing_on, O_WRONLY);
+	if (tfd < 0)
+		pdie(current_tracer);
+
+	write(efd, "1", 1);
+	write(cfd, "function", 8);
+
+	test_buffer(tep, time);
+
+	write(efd, "0", 1);
+	write(cfd, "nop", 3);
+	write(tfd, "1", 1);
+
+	close(efd);
+	close(cfd);
+	close(tfd);
+	exit(result);
+}
diff --git a/tools/testing/selftests/ftrace/test.d/ftrace/ring-buffer.tc b/tools/testing/selftests/ftrace/test.d/ftrace/ring-buffer.tc
new file mode 100644
index 000000000000..05f628124774
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/ftrace/ring-buffer.tc
@@ -0,0 +1,16 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+# description: ftrace - test ring buffer timestamps
+
+cd $TOP_DIR/test-ring-buffer
+if ! make ; then
+	cd $TRACING_DIR
+	exit_untested
+fi
+
+./test-ring-buffer 10
+
+make clean
+
+cd $TRACING_DIR
+

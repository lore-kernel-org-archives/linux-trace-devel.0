Return-Path: <SRS0=s3Jp=26=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7719C32771
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Jan 2020 12:21:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 818DA2067D
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Jan 2020 12:21:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iANENz/6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730346AbgAIMVE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Jan 2020 07:21:04 -0500
Received: from mail-lf1-f54.google.com ([209.85.167.54]:41507 "EHLO
        mail-lf1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730254AbgAIMVE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Jan 2020 07:21:04 -0500
Received: by mail-lf1-f54.google.com with SMTP id m30so5035495lfp.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 09 Jan 2020 04:21:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/6GPYFGg+7W43t//Q3W1Ru68Aqp8YD0yE0OMtDoMLMw=;
        b=iANENz/6O0r1vX3kG6aWu7SM5OpvhvJVRJRFkVApahV93McYLwue6tt2ymwouhDAlo
         lKeY3RogW0784aDacQLAS4x5iY29BFATpAXwGdbzR+wNHfzq4OOmmDZd1PnqConXGDOK
         N95Qfwx80XlQ6aBqRCfTawXDAlV19o8aazkTVPEicEnu15Ut9Dyq+g9yGqf9jXLMfNec
         L/ee9xDjy1peOqGN4RrZMpWhKKO36H9Mu2Ov4OSFM3kUrrbIvjOOzOpp2EFygcOtZY/9
         zxPVI36lBchSxMedBvCmpcSJ367/bdyjRPCBX0/p2mspPzFuNfgGHxFLtBgE+Xm8z3sz
         sv6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/6GPYFGg+7W43t//Q3W1Ru68Aqp8YD0yE0OMtDoMLMw=;
        b=Obdy0Dh605gef6FZ6aFHehnrdKypCXnEBregonecWadu23A0IdaOU2X2+Yt6WvDF3j
         5Pt1GfFQuC1qkNGQWV50B+cEuGO0LCLvBmQHymm9RHuYz9UwMEAGKfs3gqhbo0mGJY05
         ozpJb/fjx+EIKngJKsOFODrWsxOi3GE/miSYOCPg/Y4ElZmEl3dRACPYJYRNB0ZZD+bA
         fuRPdLItYYZd4/pwFIGMQgU6AuNrI2hCYGiMDhcd/Sct5wSbwZNzYT2YDZhUJa2Tfc9i
         /MArDShHalBuK3G8lQI3z1UjH0UEJ2jxn/wIbXIDF2N7bWBJgLyDTpVH+PlN+RWrGwXe
         B9dQ==
X-Gm-Message-State: APjAAAV/mXDtP2R3Y1XbaSSauTKhMR19/qJEsiM8q6IS5NNfX+op5ueI
        WOqsKv2DI+GCWhC4mg0Ge8Q=
X-Google-Smtp-Source: APXvYqylEnnpwcqLlqTMm6e5LohfipRG2L63y93U1l9WDj7mNV6CtLD1bwTfDaLrWiDjNI3lbQgVQA==
X-Received: by 2002:ac2:59dd:: with SMTP id x29mr5887168lfn.95.1578572459828;
        Thu, 09 Jan 2020 04:20:59 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id f16sm2877251ljn.17.2020.01.09.04.20.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 04:20:59 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/3] trace-cmd: Implement new sub-command "dump"
Date:   Thu,  9 Jan 2020 14:20:53 +0200
Message-Id: <20200109122055.286290-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200109122055.286290-1-tz.stoyanov@gmail.com>
References: <20200109122055.286290-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The new trace-cmd sub-command "dump" prints all meta data
information, stored in a trace file. It also can be used
to check if a file is a valid trace file, created by trace-cmd.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/Makefile              |   1 +
 tracecmd/include/trace-local.h |   2 +
 tracecmd/trace-cmd.c           |   2 +
 tracecmd/trace-dump.c          | 615 +++++++++++++++++++++++++++++++++
 tracecmd/trace-usage.c         |  20 ++
 5 files changed, 640 insertions(+)
 create mode 100644 tracecmd/trace-dump.c

diff --git a/tracecmd/Makefile b/tracecmd/Makefile
index 29a623b..bacbd0d 100644
--- a/tracecmd/Makefile
+++ b/tracecmd/Makefile
@@ -30,6 +30,7 @@ TRACE_CMD_OBJS += trace-check-events.o
 TRACE_CMD_OBJS += trace-show.o
 TRACE_CMD_OBJS += trace-list.o
 TRACE_CMD_OBJS += trace-usage.o
+TRACE_CMD_OBJS += trace-dump.o
 
 ifeq ($(VSOCK_DEFINED), 1)
 TRACE_CMD_OBJS += trace-agent.o
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index fedc0b7..0658115 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -96,6 +96,8 @@ void trace_list(int argc, char **argv);
 
 void trace_usage(int argc, char **argv);
 
+void trace_dump(int argc, char **argv);
+
 int trace_record_agent(struct tracecmd_msg_handle *msg_handle,
 		       int cpus, int *fds,
 		       int argc, char **argv, bool use_fifos);
diff --git a/tracecmd/trace-cmd.c b/tracecmd/trace-cmd.c
index 9cbfce0..4e670f1 100644
--- a/tracecmd/trace-cmd.c
+++ b/tracecmd/trace-cmd.c
@@ -101,7 +101,9 @@ struct command commands[] = {
 	{"options", trace_option},
 	{"show", trace_show},
 	{"list", trace_list},
+	{"list", trace_list},
 	{"help", trace_usage},
+	{"dump", trace_dump},
 	{"-h", trace_usage},
 };
 
diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
new file mode 100644
index 0000000..d95b34c
--- /dev/null
+++ b/tracecmd/trace-dump.c
@@ -0,0 +1,615 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
+ *
+ * Updates:
+ * Copyright (C) 2019, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
+ */
+#include <stdlib.h>
+#include <unistd.h>
+#include <getopt.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+
+#include "trace-local.h"
+
+#define DEF_INPUT_FILE	"trace.dat"
+#define MAGIC_HEAD	{ 0x17, 0x08, 0x44 }
+#define TRACING_STR	"tracing"
+#define HEAD_PAGE_STR	"header_page"
+#define HEAD_PAGE_EVENT	"header_event"
+#define HEAD_OPTIONS	"options  "
+#define HEAD_LATENCY	"latency  "
+#define HEAD_FLYRECORD	"flyrecord"
+
+#define DUMP_SIZE	1024
+
+static struct tep_handle *tep;
+static unsigned int trace_cpus;
+
+enum dump_items {
+	SUMMARY		= (1 << 0),
+	HEAD_PAGE	= (1 << 1),
+	HEAD_EVENT	= (1 << 2),
+	FTRACE_FORMAT	= (1 << 3),
+	EVENT_SYSTEMS	= (1 << 4),
+	EVENT_FORMAT	= (1 << 5),
+	KALLSYMS	= (1 << 6),
+	TRACE_PRINTK	= (1 << 7),
+	CMDLINES	= (1 << 8),
+	OPTIONS		= (1 << 9),
+	FLYRECORD	= (1 << 10),
+};
+
+enum dump_items verbosity;
+
+#define DUMP_CHECK(X) ((X) & verbosity)
+
+#define do_print(ids, fmt, ...)					\
+	do {							\
+		if (!(ids) || DUMP_CHECK(ids))			\
+			tracecmd_plog(fmt, ##__VA_ARGS__);	\
+	} while (0)
+
+static int read_file_string(int fd, char *dst, int len)
+{
+	size_t size = 0;
+	int r;
+
+	do {
+		r = read(fd, dst+size, 1);
+		if (r > 0) {
+			size++;
+			len--;
+		} else
+			break;
+		if (!dst[size - 1])
+			break;
+	} while (r > 0 && len);
+
+	if (!size || dst[size - 1])
+		return -1;
+	return 0;
+}
+
+static int read_file_bytes(int fd, char *dst, int len)
+{
+	size_t size = 0;
+	int r;
+
+	do {
+		r = read(fd, dst+size, len);
+		if (r > 0) {
+			size += r;
+			len -= r;
+		} else
+			break;
+	} while (r > 0);
+
+	if (len)
+		return -1;
+	return 0;
+}
+
+static void read_dump_string(int fd, int size, enum dump_items id)
+{
+	char buf[DUMP_SIZE];
+	int lsize;
+
+	while (size) {
+		lsize = (size < DUMP_SIZE) ? size : DUMP_SIZE - 1;
+		if (read_file_bytes(fd, buf, lsize))
+			die("cannot read %d bytes", lsize);
+		buf[lsize] = 0;
+		do_print(id, "%s", buf);
+		size -= lsize;
+	}
+
+	do_print(id, "\n");
+}
+
+static int read_file_number(int fd, void *digit, int size)
+{
+	unsigned long long val;
+	char buf[8];
+
+	if (size > 8)
+		return -1;
+
+	if (read_file_bytes(fd, buf, size))
+		return -1;
+
+	val = tep_read_number(tep, buf, size);
+	switch (size) {
+	case 1:
+		*((char *)digit) = val;
+		break;
+	case 2:
+		*((unsigned short *)digit) = val;
+		break;
+	case 4:
+		*((unsigned int *)digit) = val;
+		break;
+	case 8:
+		*((unsigned long long *)digit) = val;
+		break;
+	default:
+		return -1;
+	}
+
+	return 0;
+}
+
+static void dump_initial_format(int fd)
+{
+	char magic[] = MAGIC_HEAD;
+	char buf[DUMP_SIZE];
+	int val4;
+
+	do_print(SUMMARY, "\t[Initial format]\n");
+
+	/* check initial bytes */
+	if (read_file_bytes(fd, buf, sizeof(magic)))
+		die("cannot read %d bytes magic", sizeof(magic));
+	if (memcmp(buf, magic, sizeof(magic)) != 0)
+		die("wrong file magic");
+
+	/* check initial tracing string */
+	if (read_file_bytes(fd, buf, strlen(TRACING_STR)))
+		die("cannot read %d bytes tracing string", strlen(TRACING_STR));
+	buf[strlen(TRACING_STR)] = 0;
+	if (strncmp(buf, TRACING_STR, strlen(TRACING_STR)) != 0)
+		die("wrong tracing string: %s", buf);
+
+	/* get file version */
+	if (read_file_string(fd, buf, DUMP_SIZE))
+		die("no version string");
+
+	do_print(SUMMARY, "\t\t%s\t[Version]\n", buf);
+
+	/* get file endianness*/
+	if (read_file_bytes(fd, buf, 1))
+		die("cannot read file endianness");
+	do_print(SUMMARY, "\t\t%d\t[%s endian]\n", buf[0], buf[0]?"Big":"Little");
+
+	tep_set_file_bigendian(tep, buf[0]);
+	tep_set_local_bigendian(tep, tracecmd_host_bigendian());
+
+	/* get file bytes per long*/
+	if (read_file_bytes(fd, buf, 1))
+		die("cannot read file bytes per long");
+	do_print(SUMMARY, "\t\t%d\t[Bytes in a long]\n", buf[0]);
+
+	if (read_file_number(fd, &val4, 4))
+		die("cannot read file page size");
+	do_print(SUMMARY, "\t\t%d\t[Page size, bytes]\n", val4);
+}
+
+static void dump_header_page(int fd)
+{
+	unsigned long long size;
+	char buf[DUMP_SIZE];
+
+	do_print((SUMMARY | HEAD_PAGE), "\t[Header page, ");
+
+	/* check header string */
+	if (read_file_bytes(fd, buf, strlen(HEAD_PAGE_STR) + 1))
+		die("cannot read %d bytes header string", strlen(HEAD_PAGE_STR));
+	if (strncmp(buf, HEAD_PAGE_STR, strlen(HEAD_PAGE_STR)) != 0)
+		die("wrong header string: %s", buf);
+
+	if (read_file_number(fd, &size, 8))
+		die("cannot read the size of the page header information");
+
+	do_print((SUMMARY | HEAD_PAGE), "%lld bytes]\n", size);
+
+	read_dump_string(fd, size, HEAD_PAGE);
+}
+
+static void dump_header_event(int fd)
+{
+	unsigned long long size;
+	char buf[DUMP_SIZE];
+
+	do_print((SUMMARY | HEAD_EVENT), "\t[Header event, ");
+
+	/* check header string */
+	if (read_file_bytes(fd, buf, strlen(HEAD_PAGE_EVENT) + 1))
+		die("cannot read %d bytes header string", strlen(HEAD_PAGE_EVENT));
+	if (strncmp(buf, HEAD_PAGE_EVENT, strlen(HEAD_PAGE_EVENT)) != 0)
+		die("wrong header string: %s", buf);
+
+	if (read_file_number(fd, &size, 8))
+		die("cannot read the size of the page header information");
+
+	do_print((SUMMARY | HEAD_EVENT), "%lld bytes]\n", size);
+
+	read_dump_string(fd, size, HEAD_EVENT);
+}
+
+static void dump_ftrace_events_format(int fd)
+{
+	unsigned long long size;
+	unsigned int count;
+
+	do_print((SUMMARY | FTRACE_FORMAT), "\t[Ftrace format, ");
+	if (read_file_number(fd, &count, 4))
+		die("cannot read the count of the ftrace events");
+
+	do_print((SUMMARY | FTRACE_FORMAT), "%d events]\n", count);
+
+	while (count) {
+		if (read_file_number(fd, &size, 8))
+			die("cannot read the size of the %d ftrace event", count);
+		read_dump_string(fd, size, FTRACE_FORMAT);
+		count--;
+	}
+}
+
+static void dump_events_format(int fd)
+{
+	unsigned long long size;
+	unsigned int systems;
+	unsigned int events;
+	char buf[DUMP_SIZE];
+
+	do_print((SUMMARY | EVENT_FORMAT | EVENT_SYSTEMS), "\t[Events format, ");
+
+	if (read_file_number(fd, &systems, 4))
+		die("cannot read the count of the event systems");
+
+	do_print((SUMMARY | EVENT_FORMAT | EVENT_SYSTEMS), "%d systems]\n", systems);
+
+	while (systems) {
+
+		if (read_file_string(fd, buf, DUMP_SIZE))
+			die("cannot read the name of the $dth system", systems);
+		if (read_file_number(fd, &events, 4))
+			die("cannot read the count of the events in system %s",
+			     buf);
+		do_print(EVENT_SYSTEMS, "\t\t%s %d [system, events]\n", buf, events);
+		while (events) {
+			if (read_file_number(fd, &size, 8))
+				die("cannot read the format size of the %dth event from system %s",
+				    events, buf);
+			read_dump_string(fd, size, EVENT_FORMAT);
+			events--;
+		}
+		systems--;
+	}
+}
+
+static void dump_kallsyms(int fd)
+{
+	unsigned int size;
+
+	do_print((SUMMARY | KALLSYMS), "\t[Kallsyms, ");
+
+	if (read_file_number(fd, &size, 4))
+		die("cannot read the size of the kallsyms");
+
+	do_print((SUMMARY | KALLSYMS), "%d bytes]\n", size);
+
+	read_dump_string(fd, size, KALLSYMS);
+}
+
+static void dump_printk(int fd)
+{
+	unsigned int size;
+
+	do_print((SUMMARY | TRACE_PRINTK), "\t[Trace printk, ");
+
+	if (read_file_number(fd, &size, 4))
+		die("cannot read the size of the trace printk");
+
+	do_print((SUMMARY | TRACE_PRINTK), "%d bytes]\n", size);
+
+	read_dump_string(fd, size, TRACE_PRINTK);
+}
+
+static void dump_cmdlines(int fd)
+{
+	unsigned long long size;
+
+	do_print((SUMMARY | CMDLINES), "\t[Saved command lines, ");
+
+	if (read_file_number(fd, &size, 8))
+		die("cannot read the size of the saved command lines");
+
+	do_print((SUMMARY | CMDLINES), "%d bytes]\n", size);
+
+	read_dump_string(fd, size, CMDLINES);
+}
+
+static void dump_cpus_count(int fd)
+{
+	if (read_file_number(fd, &trace_cpus, 4))
+		die("cannot read the cpu count");
+
+	do_print(SUMMARY, "\t%d [CPUs with tracing data]\n", trace_cpus);
+}
+
+static void dump_option_string(int fd, int size, char *desc)
+{
+	do_print(OPTIONS, "\t\t[Option %s, %d bytes]\n", desc, size);
+	if (size)
+		read_dump_string(fd, size, OPTIONS);
+}
+
+static void dump_option_buffer(int fd, int size)
+{
+	unsigned long long offset;
+
+	if (size < 8)
+		die("broken buffer option with size %d", size);
+
+	if (read_file_number(fd, &offset, 8))
+		die("cannot read the offset of the buffer option");
+
+	do_print(OPTIONS, "\t\t[Option BUFFER, %d bytes]\n", size);
+	do_print(OPTIONS, "%lld [offset]\n", offset);
+	read_dump_string(fd, size - 8, OPTIONS);
+}
+
+static void dump_option_int(int fd, int size, char *desc)
+{
+	int val;
+
+	do_print(OPTIONS, "\t\t[Option %s, %d bytes]\n", desc, size);
+	read_file_number(fd, &val, size);
+	do_print(OPTIONS, "%d\n", val);
+}
+
+static void dump_options(int fd)
+{
+	unsigned short option;
+	unsigned int size;
+	int count = 0;
+
+	for (;;) {
+		if (read_file_number(fd, &option, 2))
+			die("cannot read the option id");
+		if (!option)
+			break;
+		if (read_file_number(fd, &size, 4))
+			die("cannot read the option size");
+
+		count++;
+		if (!DUMP_CHECK(OPTIONS)) {
+			lseek64(fd, size, SEEK_CUR);
+			continue;
+		}
+		switch (option) {
+		case TRACECMD_OPTION_DATE:
+			dump_option_string(fd, size, "DATE");
+			break;
+		case TRACECMD_OPTION_CPUSTAT:
+			dump_option_string(fd, size, "CPUSTAT");
+			break;
+		case TRACECMD_OPTION_BUFFER:
+			dump_option_buffer(fd, size);
+			break;
+		case TRACECMD_OPTION_TRACECLOCK:
+			dump_option_string(fd, size, "TRACECLOCK");
+			break;
+		case TRACECMD_OPTION_UNAME:
+			dump_option_string(fd, size, "UNAME");
+			break;
+		case TRACECMD_OPTION_HOOK:
+			dump_option_string(fd, size, "HOOK");
+			break;
+		case TRACECMD_OPTION_OFFSET:
+			dump_option_string(fd, size, "OFFSET");
+			break;
+		case TRACECMD_OPTION_CPUCOUNT:
+			dump_option_int(fd, size, "CPUCOUNT");
+			break;
+		case TRACECMD_OPTION_VERSION:
+			dump_option_string(fd, size, "VERSION");
+			break;
+		case TRACECMD_OPTION_PROCMAPS:
+			dump_option_string(fd, size, "PROCMAPS");
+			break;
+		default:
+			do_print(OPTIONS, " %d %d\t[Unknown option, size - skipping]\n",
+				 option, size);
+			lseek64(fd, size, SEEK_CUR);
+			break;
+		}
+	}
+	do_print(SUMMARY, "\t[%d options]\n", count);
+
+}
+
+static void dump_latency(int fd)
+{
+	do_print(SUMMARY, "\t[Latency tracing data]\n");
+}
+
+static void dump_flyrecord(int fd)
+{
+	long long cpu_offset;
+	long long cpu_size;
+	int i;
+
+	do_print((SUMMARY | FLYRECORD), "\t[Flyrecord tracing data]\n");
+
+	for (i = 0; i < trace_cpus; i++) {
+		if (read_file_number(fd, &cpu_offset, 8))
+			die("cannot read the cpu %d offset", i);
+		if (read_file_number(fd, &cpu_size, 8))
+			die("cannot read the cpu %d size", i);
+		do_print(FLYRECORD, "\t\t %lld %lld\t[offset, size of cpu %d]\n",
+			 cpu_offset, cpu_size, i);
+	}
+}
+
+static void dump_therest(int fd)
+{
+	char str[10];
+
+	for (;;) {
+		if (read_file_bytes(fd, str, 10))
+			die("cannot read the rest of the header");
+
+		if (strncmp(str, HEAD_OPTIONS, 10) == 0)
+			dump_options(fd);
+		else if (strncmp(str, HEAD_LATENCY, 10) == 0)
+			dump_latency(fd);
+		else if (strncmp(str, HEAD_FLYRECORD, 10) == 0)
+			dump_flyrecord(fd);
+		else {
+			lseek64(fd, -10, SEEK_CUR);
+			break;
+		}
+	}
+}
+
+static void dump_file(const char *file)
+{
+	int fd;
+
+	tep = tep_alloc();
+	if (!tep)
+		return;
+
+	fd = open(file, O_RDONLY);
+	if (fd < 0)
+		die("cannot open '%s'\n", file);
+
+	do_print(SUMMARY, "\n Tracing meta data in file %s:\n", file);
+
+	dump_initial_format(fd);
+	dump_header_page(fd);
+	dump_header_event(fd);
+	dump_ftrace_events_format(fd);
+	dump_events_format(fd);
+	dump_kallsyms(fd);
+	dump_printk(fd);
+	dump_cmdlines(fd);
+	dump_cpus_count(fd);
+	dump_therest(fd);
+
+	tep_free(tep);
+	tep = NULL;
+	close(fd);
+}
+
+enum {
+	OPT_all		= 244,
+	OPT_summary	= 245,
+	OPT_flyrecord	= 246,
+	OPT_options	= 247,
+	OPT_cmd_lines	= 248,
+	OPT_printk	= 249,
+	OPT_kallsyms	= 250,
+	OPT_events	= 251,
+	OPT_systems	= 252,
+	OPT_ftrace	= 253,
+	OPT_head_event	= 254,
+	OPT_head_page	= 255,
+};
+
+void trace_dump(int argc, char **argv)
+{
+	char *input_file = NULL;
+	bool validate = false;
+	int c;
+
+	if (argc < 2)
+		usage(argv);
+
+	if (strcmp(argv[1], "dump") != 0)
+		usage(argv);
+	for (;;) {
+		int option_index = 0;
+		static struct option long_options[] = {
+			{"all", no_argument, NULL, OPT_all},
+			{"summary", no_argument, NULL, OPT_summary},
+			{"head-page", no_argument, NULL, OPT_head_page},
+			{"head-event", no_argument, NULL, OPT_head_event},
+			{"ftrace-events", no_argument, NULL, OPT_ftrace},
+			{"systems", no_argument, NULL, OPT_systems},
+			{"events", no_argument, NULL, OPT_events},
+			{"kallsyms", no_argument, NULL, OPT_kallsyms},
+			{"printk", no_argument, NULL, OPT_printk},
+			{"cmd-lines", no_argument, NULL, OPT_cmd_lines},
+			{"options", no_argument, NULL, OPT_options},
+			{"flyrecord", no_argument, NULL, OPT_flyrecord},
+			{"validate", no_argument, NULL, 'v'},
+			{"help", no_argument, NULL, '?'},
+			{NULL, 0, NULL, 0}
+		};
+
+		c = getopt_long (argc-1, argv+1, "+hvai:",
+				long_options, &option_index);
+		if (c == -1)
+			break;
+		switch (c) {
+		case 'h':
+			usage(argv);
+			break;
+		case 'i':
+			input_file = optarg;
+			break;
+		case 'v':
+			validate = true;
+			break;
+		case OPT_all:
+			verbosity = 0xFFFFFFFF;
+			break;
+		case OPT_summary:
+			verbosity |= SUMMARY;
+			break;
+		case OPT_flyrecord:
+			verbosity |= FLYRECORD;
+			break;
+		case OPT_options:
+			verbosity |= OPTIONS;
+			break;
+		case OPT_cmd_lines:
+			verbosity |= CMDLINES;
+			break;
+		case OPT_printk:
+			verbosity |= TRACE_PRINTK;
+			break;
+		case OPT_kallsyms:
+			verbosity |= KALLSYMS;
+			break;
+		case OPT_events:
+			verbosity |= EVENT_FORMAT;
+			break;
+		case OPT_systems:
+			verbosity |= EVENT_SYSTEMS;
+			break;
+		case OPT_ftrace:
+			verbosity |= FTRACE_FORMAT;
+			break;
+		case OPT_head_event:
+			verbosity |= HEAD_EVENT;
+			break;
+		case OPT_head_page:
+			verbosity |= HEAD_PAGE;
+			break;
+		default:
+			usage(argv);
+		}
+	}
+
+	if ((argc - optind) >= 2) {
+		if (input_file)
+			usage(argv);
+		input_file = argv[optind + 1];
+	}
+
+	if (!input_file)
+		input_file = DEF_INPUT_FILE;
+
+	if (!verbosity && !validate)
+		verbosity = SUMMARY;
+
+	dump_file(input_file);
+
+	if (validate)
+		tracecmd_plog("File %s is a valid trace-cmd file\n", input_file);
+}
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 05ec021..502a410 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -310,6 +310,26 @@ static struct usage_help usage_help[] = {
 		" %s check-events [-N]\n"
 		"          -N do not load any plugins\n"
 	},
+	{
+		"dump",
+		"read out the meta data from a trace file",
+		" %s dump [options]\n"
+		"          -i input file, default is trace.dat\n"
+		"          -v validate a trace file\n"
+		"          --all print all meta data from a trace file\n"
+		"          --summary print a meta data summary\n"
+		"          --head-page print header page information\n"
+		"          --head-event print header event information\n"
+		"          --ftrace-events print ftrace events format\n"
+		"          --systems print recorded event systems\n"
+		"          --events print format of recorded events\n"
+		"          --kallsyms print information of the mapping of function addresses to the function names\n"
+		"          --printk print trace_printk() format strings\n"
+		"          --cmd-lines print information mapping a PID to a process name\n"
+		"          --options print options\n"
+		"          --flyrecord information of offset and count of recorded events per CPU\n"
+		"          -h, --help show usage information\n"
+	},
 	{
 		NULL, NULL, NULL
 	}
-- 
2.24.1


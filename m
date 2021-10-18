Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33B44C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Oct 2021 16:49:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C84D61279
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Oct 2021 16:49:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233945AbhJRQvz convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 18 Oct 2021 12:51:55 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:46469 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233966AbhJRQvl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 18 Oct 2021 12:51:41 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-314-nHnKIDZ2Pbiwu1Odx9PAOw-1; Mon, 18 Oct 2021 12:49:26 -0400
X-MC-Unique: nHnKIDZ2Pbiwu1Odx9PAOw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 557881006AA2;
        Mon, 18 Oct 2021 16:49:25 +0000 (UTC)
Received: from x1.com (unknown [10.22.18.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF3D010016F4;
        Mon, 18 Oct 2021 16:49:17 +0000 (UTC)
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Daniel Bristot de Oliveira <bristot@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        John Kacur <jkacur@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V3 08/19] rtla: Add osnoise tool
Date:   Mon, 18 Oct 2021 18:48:21 +0200
Message-Id: <4d51190616c2c1957aa59f4032affc2d79642630.1634574261.git.bristot@kernel.org>
In-Reply-To: <cover.1634574261.git.bristot@kernel.org>
References: <cover.1634574261.git.bristot@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=bristot@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The osnoise tool is the interface for the osnoise tracer. The osnoise
tool will have multiple "modes" with different outputs. At this point,
no mode is included.

The osnoise.c includes the osnoise_context abstraction. It serves to
read-save-change-restore the default values from tracing/osnoise/
directory. When the context is deleted, the default values are restored.

It also includes some other helper functions for managing osnoise
tracer sessions.

With these bits and pieces in place, we can start adding some
functionality to rtla.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Tom Zanussi <zanussi@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Clark Williams <williams@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
Cc: linux-rt-users@vger.kernel.org
Cc: linux-trace-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
---
 tools/tracing/rtla/src/osnoise.c | 815 +++++++++++++++++++++++++++++++
 tools/tracing/rtla/src/osnoise.h |  85 ++++
 tools/tracing/rtla/src/rtla.c    |  10 +
 3 files changed, 910 insertions(+)
 create mode 100644 tools/tracing/rtla/src/osnoise.c
 create mode 100644 tools/tracing/rtla/src/osnoise.h

diff --git a/tools/tracing/rtla/src/osnoise.c b/tools/tracing/rtla/src/osnoise.c
new file mode 100644
index 000000000000..fa3786c4aedc
--- /dev/null
+++ b/tools/tracing/rtla/src/osnoise.c
@@ -0,0 +1,815 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2021 Red Hat Inc, Daniel Bristot de Oliveira <bristot@kernel.org>
+ */
+
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <pthread.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <stdio.h>
+
+#include "osnoise.h"
+#include "utils.h"
+
+/*
+ * osnoise_set_cpus - configure osnoise to run on *cpus
+ *
+ * "osnoise/cpus" file is used to set the cpus in which osnoise/timerlat
+ * will run. This function opens this file, saves the current value,
+ * and set the cpus passed as argument.
+ */
+int osnoise_set_cpus(struct osnoise_context *context, char *cpus)
+{
+	char *osnoise_cpus = tracefs_get_tracing_file("osnoise/cpus");
+	char curr_cpus[1024];
+	int retval;
+
+	context->cpus_fd = open(osnoise_cpus, O_RDWR);
+	if (!context->cpus_fd)
+		goto out_err;
+
+	retval = read(context->cpus_fd, &curr_cpus, sizeof(curr_cpus));
+	if (!retval)
+		goto out_close;
+
+	context->orig_cpus = strdup(curr_cpus);
+	if (!context->orig_cpus)
+		goto out_err;
+
+	retval = write(context->cpus_fd, cpus, strlen(cpus) + 1);
+	if (!retval)
+		goto out_err;
+
+	tracefs_put_tracing_file(osnoise_cpus);
+
+	return 0;
+
+out_close:
+	close(context->cpus_fd);
+	context->cpus_fd = -1;
+out_err:
+	tracefs_put_tracing_file(osnoise_cpus);
+	return 1;
+}
+
+/*
+ * osnoise_restore_cpus - restore the original "osnoise/cpus"
+ *
+ * osnoise_set_cpus() saves the original data for the "osnoise/cpus"
+ * file. This function restore the original config it was previously
+ * modified.
+ */
+void osnoise_restore_cpus(struct osnoise_context *context)
+{
+	int retval;
+
+	if (!context->orig_cpus)
+		return;
+
+	retval = write(context->cpus_fd, context->orig_cpus, strlen(context->orig_cpus));
+	if (!retval)
+		err_msg("could not restore original osnoise cpus\n");
+
+	free(context->orig_cpus);
+}
+
+/*
+ * osnoise_get_runtime - return the original "osnoise/runtime_us" value
+ *
+ * It also saves the value to be restored.
+ */
+unsigned long long osnoise_get_runtime(struct osnoise_context *context)
+{
+	char buffer[BUFF_U64_STR_SIZE];
+	char *runtime_path;
+	int retval;
+
+	if (context->runtime_us)
+		return context->runtime_us;
+
+	runtime_path = tracefs_get_tracing_file("osnoise/runtime_us");
+
+	context->runtime_fd = open(runtime_path, O_RDWR);
+	if (!context->runtime_fd)
+		goto out_err;
+
+	retval = read(context->runtime_fd, &buffer, sizeof(buffer));
+	if (!retval)
+		goto out_close;
+
+	context->runtime_us = get_long_from_str(buffer);
+	if (!context->runtime_us)
+		goto out_close;
+
+	context->orig_runtime_us = context->runtime_us;
+
+	tracefs_put_tracing_file(runtime_path);
+
+	return context->runtime_us;
+
+out_close:
+	close(context->runtime_fd);
+	context->runtime_fd = -1;
+out_err:
+	tracefs_put_tracing_file(runtime_path);
+	return 0;
+}
+
+/*
+ * osnoise_get_period - return the original "osnoise/period_us" value
+ *
+ * It also saves the value to be restored.
+ */
+unsigned long long osnoise_get_period(struct osnoise_context *context)
+{
+	char buffer[BUFF_U64_STR_SIZE];
+	char *period_path;
+	int retval;
+
+	if (context->period_us)
+		return context->period_us;
+
+	period_path = tracefs_get_tracing_file("osnoise/period_us");
+
+	context->period_fd = open(period_path, O_RDWR);
+	if (!context->period_fd)
+		goto out_err;
+
+	retval = read(context->period_fd, &buffer, sizeof(buffer));
+	if (!retval)
+		goto out_close;
+
+	context->period_us = get_long_from_str(buffer);
+	if (!context->period_us)
+		goto out_close;
+
+	context->orig_period_us = context->period_us;
+
+	tracefs_put_tracing_file(period_path);
+
+	return context->period_us;
+
+out_close:
+	close(context->period_fd);
+	context->period_fd = -1;
+out_err:
+	tracefs_put_tracing_file(period_path);
+	return 0;
+}
+
+static int __osnoise_write_runtime(struct osnoise_context *context,
+				   unsigned long long runtime)
+{
+	char buffer[BUFF_U64_STR_SIZE];
+	int retval;
+
+	if (context->runtime_fd == -1) {
+		err_msg("tried to write osnoise runtime before getting it\n");
+		return 0;
+	}
+
+	snprintf(buffer, sizeof(buffer), "%llu\n", runtime);
+
+	retval = write(context->runtime_fd, buffer, strlen(buffer) + 1);
+	if (retval < 0)
+		return -1;
+
+	context->runtime_us = runtime;
+	return 0;
+}
+
+static int __osnoise_write_period(struct osnoise_context *context,
+				  unsigned long long period)
+{
+	char buffer[BUFF_U64_STR_SIZE];
+	int retval;
+
+	if (context->period_fd == -1)
+		return 0;
+
+	snprintf(buffer, sizeof(buffer), "%llu\n", period);
+
+	retval = write(context->period_fd, buffer, strlen(buffer) + 1);
+	if (retval < 0)
+		return -1;
+
+	context->period_us = period;
+	return 0;
+}
+
+/*
+ * osnoise_set_runtime_period - set osnoise runtime and period
+ *
+ * Osnoise's runtime and period are related as runtime <= period.
+ * Thus, this function saves the original values, and then tries
+ * to set the runtime and period if they are != 0.
+ */
+int osnoise_set_runtime_period(struct osnoise_context *context,
+			       unsigned long long runtime,
+			       unsigned long long period)
+{
+	unsigned long long curr_runtime_us;
+	unsigned long long curr_period_us;
+	int retval;
+
+	if (!period && !runtime)
+		return 0;
+
+	curr_runtime_us = osnoise_get_runtime(context);
+	curr_period_us = osnoise_get_period(context);
+
+	if (!curr_period_us || !curr_runtime_us)
+		return -1;
+
+	if (!period) {
+		if (runtime > curr_period_us)
+			return -1;
+		return __osnoise_write_runtime(context, runtime);
+	} else if (!runtime) {
+		if (period < curr_runtime_us)
+			return -1;
+		return __osnoise_write_period(context, period);
+	}
+
+	if (runtime > curr_period_us) {
+		retval = __osnoise_write_period(context, period);
+		if (retval)
+			return -1;
+		retval = __osnoise_write_runtime(context, runtime);
+		if (retval)
+			return -1;
+	} else {
+		retval = __osnoise_write_runtime(context, runtime);
+		if (retval)
+			return -1;
+		retval = __osnoise_write_period(context, period);
+		if (retval)
+			return -1;
+	}
+
+	return 0;
+}
+
+/*
+ * osnoise_restore_runtime_period - restore the original runtime and period
+ */
+void osnoise_restore_runtime_period(struct osnoise_context *context)
+{
+	unsigned long long runtime = context->orig_runtime_us;
+	unsigned long long period = context->orig_period_us;
+	int retval;
+
+	if (context->runtime_fd < 0 && context->period_fd < 0)
+		return;
+
+	retval = osnoise_set_runtime_period(context, runtime, period);
+	if (retval)
+		err_msg("Could not restore original osnoise runtime/period\n");
+}
+
+/*
+ * osnoise_get_stop_us - read and save the original "stop_tracing_us"
+ */
+static long long
+osnoise_get_stop_us(struct osnoise_context *context)
+{
+	char buffer[BUFF_U64_STR_SIZE];
+	char *stop_path;
+	int retval;
+
+	if (context->stop_us_fd > 0)
+		return context->stop_us;
+
+	stop_path = tracefs_get_tracing_file("osnoise/stop_tracing_us");
+
+	context->stop_us_fd = open(stop_path, O_RDWR);
+	if (!context->stop_us_fd)
+		goto out_err;
+
+	retval = read(context->stop_us_fd, &buffer, sizeof(buffer));
+	if (!retval)
+		goto out_close;
+
+	context->stop_us = get_long_from_str(buffer);
+	context->orig_stop_us = context->stop_us;
+
+	tracefs_put_tracing_file(stop_path);
+
+	return context->stop_us;
+
+out_close:
+	close(context->stop_us_fd);
+	context->stop_us_fd = -1;
+out_err:
+	tracefs_put_tracing_file(stop_path);
+	return -1;
+}
+
+/*
+ * osnoise_set_stop_us - set "stop_tracing_us"
+ */
+int osnoise_set_stop_us(struct osnoise_context *context, long long stop_us)
+{
+	long long curr_stop_us = osnoise_get_stop_us(context);
+	char buffer[BUFF_U64_STR_SIZE];
+	int retval;
+
+	if (curr_stop_us < 0)
+		return -1;
+
+	snprintf(buffer, BUFF_U64_STR_SIZE, "%lld\n", stop_us);
+
+	retval = write(context->stop_us_fd, buffer, strlen(buffer) + 1);
+	if (retval < 0)
+		return -1;
+
+	context->stop_us = stop_us;
+
+	return 0;
+}
+
+/*
+ * osnoise_restore_stop_us - restore the original stop_tracing_us
+ */
+void osnoise_restore_stop_us(struct osnoise_context *context)
+{
+	char buffer[BUFF_U64_STR_SIZE];
+	int retval;
+
+	if (context->stop_us_fd < 0)
+		return;
+
+	if (context->orig_stop_us == context->stop_us)
+		return;
+
+	snprintf(buffer, BUFF_U64_STR_SIZE, "%lld\n", context->orig_stop_us);
+
+	retval = write(context->stop_us_fd, buffer, strlen(buffer) + 1);
+	if (retval < 0)
+		err_msg("Could not restore original osnoise stop_us\n");
+}
+
+/*
+ * osnoise_get_stop_us - read and save the original "stop_tracing_total_us"
+ */
+static long long
+osnoise_get_stop_total_us(struct osnoise_context *context)
+{
+	char buffer[BUFF_U64_STR_SIZE];
+	char *stop_path;
+	int retval;
+
+	if (context->stop_total_us_fd > 0)
+		return context->stop_total_us;
+
+	stop_path = tracefs_get_tracing_file("osnoise/stop_tracing_total_us");
+
+	context->stop_total_us_fd = open(stop_path, O_RDWR);
+	if (!context->stop_total_us_fd)
+		goto out_err;
+
+	retval = read(context->stop_total_us_fd, &buffer, sizeof(buffer));
+	if (!retval)
+		goto out_close;
+
+	context->stop_total_us = get_long_from_str(buffer);
+	context->orig_stop_total_us = context->stop_total_us;
+
+	tracefs_put_tracing_file(stop_path);
+
+	return context->stop_total_us;
+
+out_close:
+	close(context->stop_total_us_fd);
+	context->stop_total_us_fd = -1;
+out_err:
+	tracefs_put_tracing_file(stop_path);
+	return -1;
+}
+
+/*
+ * osnoise_set_stop_us - set "stop_tracing_total_us"
+ */
+int osnoise_set_stop_total_us(struct osnoise_context *context, long long stop_total_us)
+{
+	long long curr_stop_total_us = osnoise_get_stop_total_us(context);
+	char buffer[BUFF_U64_STR_SIZE];
+	int retval;
+
+	if (curr_stop_total_us < 0)
+		return -1;
+
+	snprintf(buffer, BUFF_U64_STR_SIZE, "%lld\n", stop_total_us);
+
+	retval = write(context->stop_total_us_fd, buffer, strlen(buffer) + 1);
+	if (retval < 0)
+		return -1;
+
+	context->stop_total_us = stop_total_us;
+
+	return 0;
+}
+
+/*
+ * osnoise_restore_stop_us - restore the original stop_tracing_us
+ */
+void osnoise_restore_stop_total_us(struct osnoise_context *context)
+{
+	char buffer[BUFF_U64_STR_SIZE];
+	int retval;
+
+	if (context->stop_total_us_fd < 0)
+		return;
+
+	if (context->orig_stop_total_us == context->stop_total_us)
+		return;
+
+	snprintf(buffer, BUFF_U64_STR_SIZE, "%lld\n", context->orig_stop_total_us);
+
+	retval = write(context->stop_total_us_fd, buffer, strlen(buffer) + 1);
+	if (retval < 0)
+		err_msg("Could not restore original osnoise stop_total_us\n");
+}
+
+/*
+ * osnoise_get_timerlat_period_us - read and save the original "timerlat_period_us"
+ */
+static long long
+osnoise_get_timerlat_period_us(struct osnoise_context *context)
+{
+	char buffer[BUFF_U64_STR_SIZE];
+	char *stop_path;
+	int retval;
+
+	if (context->timerlat_period_us_fd > 0)
+		return context->timerlat_period_us;
+
+	stop_path = tracefs_get_tracing_file("osnoise/timerlat_period_us");
+
+	context->timerlat_period_us_fd = open(stop_path, O_RDWR);
+	if (!context->timerlat_period_us_fd)
+		goto out_err;
+
+	retval = read(context->timerlat_period_us_fd, &buffer, sizeof(buffer));
+	if (!retval)
+		goto out_close;
+
+	context->timerlat_period_us = get_long_from_str(buffer);
+	context->orig_timerlat_period_us = context->timerlat_period_us;
+
+	tracefs_put_tracing_file(stop_path);
+
+	return context->timerlat_period_us;
+
+out_close:
+	close(context->timerlat_period_us_fd);
+	context->timerlat_period_us_fd = -1;
+out_err:
+	tracefs_put_tracing_file(stop_path);
+	return -1;
+}
+
+/*
+ * osnoise_set_timerlat_period_us - set "timerlat_period_us"
+ */
+int osnoise_set_timerlat_period_us(struct osnoise_context *context, long long timerlat_period_us)
+{
+	long long curr_timerlat_period_us = osnoise_get_timerlat_period_us(context);
+	char buffer[BUFF_U64_STR_SIZE];
+	int retval;
+
+	if (curr_timerlat_period_us < 0)
+		return -1;
+
+	snprintf(buffer, BUFF_U64_STR_SIZE, "%lld\n", timerlat_period_us);
+
+	retval = write(context->timerlat_period_us_fd, buffer, strlen(buffer) + 1);
+	if (retval < 0)
+		return -1;
+
+	context->timerlat_period_us = timerlat_period_us;
+
+	return 0;
+}
+
+/*
+ * osnoise_restore_timerlat_period_us - restore "timerlat_period_us"
+ */
+void osnoise_restore_timerlat_period_us(struct osnoise_context *context)
+{
+	char buffer[BUFF_U64_STR_SIZE];
+	int retval;
+
+	if (context->timerlat_period_us_fd < 0)
+		return;
+
+	if (context->orig_timerlat_period_us == context->timerlat_period_us)
+		return;
+
+	snprintf(buffer, BUFF_U64_STR_SIZE, "%lld\n", context->orig_timerlat_period_us);
+
+	retval = write(context->timerlat_period_us_fd, buffer, strlen(buffer) + 1);
+	if (retval < 0)
+		err_msg("Could not restore original osnoise timerlat_period_us\n");
+}
+
+/*
+ * osnoise_get_print_stack - read and save the original "print_stack"
+ */
+static long long
+osnoise_get_print_stack(struct osnoise_context *context)
+{
+	char buffer[BUFF_U64_STR_SIZE];
+	char *stop_path;
+	int retval;
+
+	if (context->print_stack_fd > 0)
+		return context->print_stack;
+
+	stop_path = tracefs_get_tracing_file("osnoise/print_stack");
+
+	context->print_stack_fd = open(stop_path, O_RDWR);
+	if (!context->print_stack_fd)
+		goto out_err;
+
+	retval = read(context->print_stack_fd, &buffer, sizeof(buffer));
+	if (!retval)
+		goto out_close;
+
+	context->print_stack = get_long_from_str(buffer);
+	context->orig_print_stack = context->print_stack;
+
+	tracefs_put_tracing_file(stop_path);
+
+	return context->print_stack;
+
+out_close:
+	close(context->print_stack_fd);
+	context->print_stack_fd = -1;
+out_err:
+	tracefs_put_tracing_file(stop_path);
+	return -1;
+}
+
+/*
+ * osnoise_set_print_stack - set "print_stack"
+ */
+int osnoise_set_print_stack(struct osnoise_context *context, long long print_stack)
+{
+	long long curr_print_stack = osnoise_get_print_stack(context);
+	char buffer[BUFF_U64_STR_SIZE];
+	int retval;
+
+	if (curr_print_stack < 0)
+		return -1;
+
+	snprintf(buffer, BUFF_U64_STR_SIZE, "%lld\n", print_stack);
+
+	retval = write(context->print_stack_fd, buffer, strlen(buffer) + 1);
+	if (retval < 0)
+		return -1;
+
+	context->print_stack = print_stack;
+
+	return 0;
+}
+
+/*
+ * osnoise_restore_print_stack - restore the original "print_stack"
+ */
+void osnoise_restore_print_stack(struct osnoise_context *context)
+{
+	char buffer[BUFF_U64_STR_SIZE];
+	int retval;
+
+	if (context->print_stack_fd < 0)
+		return;
+
+	if (context->orig_print_stack == context->print_stack)
+		return;
+
+	snprintf(buffer, BUFF_U64_STR_SIZE, "%lld\n", context->orig_print_stack);
+
+	retval = write(context->print_stack_fd, buffer, strlen(buffer) + 1);
+	if (retval < 0)
+		err_msg("Could not restore original osnoise print_stack\n");
+}
+
+/*
+ * enable_osnoise - enable osnoise tracer in the trace_instance
+ */
+int enable_osnoise(struct trace_instance *trace)
+{
+	return enable_tracer_by_name(trace->inst, "osnoise");
+}
+
+/*
+ * enable_timerlat - enable timerlat tracer in the trace_instance
+ */
+int enable_timerlat(struct trace_instance *trace)
+{
+	return enable_tracer_by_name(trace->inst, "timerlat");
+}
+
+enum {
+	FLAG_CONTEXT_NEWLY_CREATED	= (1 << 0),
+	FLAG_CONTEXT_DELETED		= (1 << 1),
+};
+
+/*
+ * osnoise_get_context - increase the usage of a context and return it
+ */
+int osnoise_get_context(struct osnoise_context *context)
+{
+	int ret;
+
+	pthread_mutex_lock(&context->lock);
+	if (context->flags & FLAG_CONTEXT_DELETED) {
+		ret = -1;
+	} else {
+		context->ref++;
+		ret = 0;
+	}
+	pthread_mutex_unlock(&context->lock);
+
+	return ret;
+}
+
+/*
+ * osnoise_context_alloc - alloc an osnoise_context
+ *
+ * The osnoise context contains the information of the "osnoise/" configs.
+ * It is used to set and restore the config.
+ */
+struct osnoise_context *osnoise_context_alloc(void)
+{
+	struct osnoise_context *context;
+
+	context = calloc(1, sizeof(*context));
+	if (!context)
+		goto out_err;
+
+	if (pthread_mutex_init(&context->lock, NULL) < 0)
+		goto out_err;
+
+	context->cpus_fd = -1;
+	context->runtime_fd = -1;
+	context->period_fd = -1;
+	context->stop_us_fd = -1;
+	context->stop_total_us_fd = -1;
+
+	osnoise_get_context(context);
+
+	return context;
+out_err:
+	if (context)
+		free(context);
+	return NULL;
+}
+
+/*
+ * osnoise_put_context - put the osnoise_put_context
+ *
+ * If there is no other user for the context, the original data
+ * is restored.
+ */
+void osnoise_put_context(struct osnoise_context *context)
+{
+	pthread_mutex_lock(&context->lock);
+	if (--context->ref < 1)
+		context->flags |= FLAG_CONTEXT_DELETED;
+	pthread_mutex_unlock(&context->lock);
+
+	if (!(context->flags & FLAG_CONTEXT_DELETED))
+		return;
+
+	osnoise_restore_cpus(context);
+	if (context->cpus_fd >= 0)
+		close(context->cpus_fd);
+
+	osnoise_restore_runtime_period(context);
+	if (context->runtime_fd >= 0)
+		close(context->runtime_fd);
+	if (context->period_fd >= 0)
+		close(context->period_fd);
+
+	osnoise_restore_stop_us(context);
+	osnoise_restore_stop_total_us(context);
+	osnoise_restore_print_stack(context);
+	osnoise_restore_timerlat_period_us(context);
+
+	pthread_mutex_destroy(&context->lock);
+	free(context);
+}
+
+/*
+ * osnoise_destroy_tool - disable trace, restore configs and free data
+ */
+void osnoise_destroy_tool(struct osnoise_tool *top)
+{
+	trace_instance_destroy(&top->trace);
+
+	if (top->context)
+		osnoise_put_context(top->context);
+
+	free(top);
+}
+
+/*
+ * osnoise_init_tool - init an osnoise tool
+ *
+ * It allocs data, create a context to store data and
+ * creates a new trace instance for the tool.
+ */
+struct osnoise_tool *osnoise_init_tool(char *tool_name)
+{
+	struct osnoise_tool *top;
+	int retval;
+
+	top = calloc(1, sizeof(*top));
+	if (!top)
+		return NULL;
+
+	top->context = osnoise_context_alloc();
+	if (!top->context)
+		goto out_err;
+
+	retval = trace_instance_init(&top->trace, tool_name);
+	if (retval)
+		goto out_err;
+
+	return top;
+out_err:
+	osnoise_destroy_tool(top);
+	return NULL;
+}
+
+/*
+ * osnoise_init_trace_tool - init a tracer instance to trace osnoise events
+ */
+struct osnoise_tool *osnoise_init_trace_tool(char *tracer)
+{
+	struct osnoise_tool *trace;
+	int retval;
+
+	trace = osnoise_init_tool("osnoise_trace");
+	if (!trace)
+		return NULL;
+
+	retval = tracefs_event_enable(trace->trace.inst, "osnoise", NULL);
+	if (retval < 0 && !errno) {
+		err_msg("Could not find osnoise events\n");
+		goto out_err;
+	}
+
+	retval = enable_tracer_by_name(trace->trace.inst, tracer);
+	if (retval) {
+		err_msg("Could not enable osnoiser tracer for tracing\n");
+		goto out_err;
+	}
+
+	return trace;
+out_err:
+	osnoise_destroy_tool(trace);
+	return NULL;
+}
+
+static void osnoise_usage(void)
+{
+	int i;
+
+	static const char * const msg[] = {
+		"",
+		"osnoise version " VERSION,
+		"",
+		"  usage: [rtla] osnoise [MODE] ...",
+		"",
+		"  modes:",
+		"",
+		NULL,
+	};
+
+	for (i = 0; msg[i]; i++)
+		fprintf(stderr, "%s\n", msg[i]);
+	exit(1);
+}
+
+int osnoise_main(int argc, char *argv[])
+{
+	if (argc <= 1)
+		goto usage;
+
+	if ((strcmp(argv[1], "-h") == 0) || (strcmp(argv[1], "--help") == 0)) {
+		osnoise_usage();
+		exit(0);
+	}
+
+usage:
+	osnoise_usage();
+	exit(1);
+}
diff --git a/tools/tracing/rtla/src/osnoise.h b/tools/tracing/rtla/src/osnoise.h
new file mode 100644
index 000000000000..c8db59e7c337
--- /dev/null
+++ b/tools/tracing/rtla/src/osnoise.h
@@ -0,0 +1,85 @@
+// SPDX-License-Identifier: GPL-2.0
+#include "trace.h"
+
+/*
+ * osnoise_context - read, store, write, restore osnoise configs.
+ */
+struct osnoise_context {
+	int			flags;
+	int			ref;
+	pthread_mutex_t		lock;
+
+	int			cpus_fd;
+	int			runtime_fd;
+	int			period_fd;
+	int			stop_us_fd;
+	int			stop_total_us_fd;
+	int			timerlat_period_us_fd;
+	int			print_stack_fd;
+
+	char			*curr_cpus;
+	char			*orig_cpus;
+
+	unsigned long long	orig_runtime_us;
+	unsigned long long	runtime_us;
+
+	unsigned long long	orig_period_us;
+	unsigned long long	period_us;
+
+	long long		orig_stop_us;
+	long long		stop_us;
+
+	long long		orig_stop_total_us;
+	long long		stop_total_us;
+
+	long long		orig_timerlat_period_us;
+	long long		timerlat_period_us;
+
+	long long		orig_print_stack;
+	long long		print_stack;
+};
+
+struct osnoise_context *osnoise_context_alloc(void);
+int osnoise_get_context(struct osnoise_context *context);
+void osnoise_put_context(struct osnoise_context *context);
+
+int osnoise_set_cpus(struct osnoise_context *context, char *cpus);
+void osnoise_restore_cpus(struct osnoise_context *context);
+
+int osnoise_set_runtime_period(struct osnoise_context *context,
+			       unsigned long long runtime,
+			       unsigned long long period);
+void osnoise_restore_runtime_period(struct osnoise_context *context);
+
+int osnoise_set_stop_us(struct osnoise_context *context,
+			long long stop_us);
+void osnoise_restore_stop_us(struct osnoise_context *context);
+
+int osnoise_set_stop_total_us(struct osnoise_context *context,
+			      long long stop_total_us);
+void osnoise_restore_stop_total_us(struct osnoise_context *context);
+
+int osnoise_set_timerlat_period_us(struct osnoise_context *context,
+				   long long timerlat_period_us);
+void osnoise_restore_timerlat_period_us(struct osnoise_context *context);
+
+void osnoise_restore_print_stack(struct osnoise_context *context);
+int osnoise_set_print_stack(struct osnoise_context *context,
+			    long long print_stack);
+
+/*
+ * osnoise_tool -  osnoise based tool definition.
+ */
+struct osnoise_tool {
+	struct trace_instance		trace;
+	struct osnoise_context		*context;
+	void				*data;
+	void				*params;
+	time_t				start_time;
+};
+
+void osnoise_destroy_tool(struct osnoise_tool *top);
+struct osnoise_tool *osnoise_init_tool(char *tool_name);
+struct osnoise_tool *osnoise_init_trace_tool(char *tracer);
+
+int osnoise_main(int argc, char **argv);
diff --git a/tools/tracing/rtla/src/rtla.c b/tools/tracing/rtla/src/rtla.c
index 5ae2664ed47d..669b9750b3b3 100644
--- a/tools/tracing/rtla/src/rtla.c
+++ b/tools/tracing/rtla/src/rtla.c
@@ -8,6 +8,8 @@
 #include <string.h>
 #include <stdio.h>
 
+#include "osnoise.h"
+
 /*
  * rtla_usage - print rtla usage
  */
@@ -22,6 +24,7 @@ static void rtla_usage(void)
 		"  usage: rtla COMMAND ...",
 		"",
 		"  commands:",
+		"     osnoise  - gives information about the operating system noise (osnoise)",
 		"",
 		NULL,
 	};
@@ -39,7 +42,14 @@ static void rtla_usage(void)
  */
 int run_command(int argc, char **argv, int start_position)
 {
+	if (strcmp(argv[start_position], "osnoise") == 0) {
+		osnoise_main(argc-start_position, &argv[start_position]);
+		goto ran;
+	}
+
 	return 0;
+ran:
+	return 1;
 }
 
 int main(int argc, char *argv[])
-- 
2.31.1


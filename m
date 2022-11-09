Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED1C3C4167B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Nov 2022 23:51:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbiKIXvr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Nov 2022 18:51:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231992AbiKIXvp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Nov 2022 18:51:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72705DEDF
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Nov 2022 15:51:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04E48B82056
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Nov 2022 23:51:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D9A1C433B5;
        Wed,  9 Nov 2022 23:51:41 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1osurg-009C6O-14;
        Wed, 09 Nov 2022 18:52:16 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v3 5/8] libtracefs: Add unit tests for tracefs_cpu functions
Date:   Wed,  9 Nov 2022 18:52:11 -0500
Message-Id: <20221109235214.2191393-6-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221109235214.2191393-1-rostedt@goodmis.org>
References: <20221109235214.2191393-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add unit tests to test the following functions:

  tracefs_cpu_open()
  tracefs_cpu_close()
  tracefs_cpu_read_size();
  tracefs_cpu_read()
  tracefs_cpu_write()
  tracefs_cpu_flush_write()
  tracefs_cpu_stop()

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-record.c  |  57 +++++---
 utest/tracefs-utest.c | 323 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 361 insertions(+), 19 deletions(-)

diff --git a/src/tracefs-record.c b/src/tracefs-record.c
index f5a72a08877d..dbe0e9f01aad 100644
--- a/src/tracefs-record.c
+++ b/src/tracefs-record.c
@@ -19,8 +19,9 @@
 #include "tracefs-local.h"
 
 enum {
-	TC_STOP		= 1 << 0,	/* Stop reading */
-	TC_NONBLOCK	= 1 << 1,	/* read is non blocking */
+	TC_STOP			= 1 << 0,   /* Stop reading */
+	TC_PERM_NONBLOCK	= 1 << 1,   /* read is always non blocking */
+	TC_NONBLOCK		= 1 << 2,   /* read is non blocking */
 };
 
 struct tracefs_cpu {
@@ -59,7 +60,7 @@ tracefs_cpu_alloc_fd(int fd, int subbuf_size, bool nonblock)
 
 	if (nonblock) {
 		mode |= O_NONBLOCK;
-		tcpu->flags |= TC_NONBLOCK;
+		tcpu->flags |= TC_NONBLOCK | TC_PERM_NONBLOCK;
 	}
 
 	tcpu->splice_pipe[0] = -1;
@@ -69,7 +70,7 @@ tracefs_cpu_alloc_fd(int fd, int subbuf_size, bool nonblock)
 
 	tcpu->subbuf_size = subbuf_size;
 
-	if (tcpu->flags & TC_NONBLOCK) {
+	if (tcpu->flags & TC_PERM_NONBLOCK) {
 		tcpu->ctrl_pipe[0] = -1;
 		tcpu->ctrl_pipe[1] = -1;
 	} else {
@@ -210,11 +211,27 @@ static void set_nonblock(struct tracefs_cpu *tcpu)
 {
 	long flags;
 
+	if (tcpu->flags & TC_NONBLOCK)
+		return;
+
 	flags = fcntl(tcpu->fd, F_GETFL);
 	fcntl(tcpu->fd, F_SETFL, flags | O_NONBLOCK);
 	tcpu->flags |= TC_NONBLOCK;
 }
 
+static void unset_nonblock(struct tracefs_cpu *tcpu)
+{
+	long flags;
+
+	if (!(tcpu->flags & TC_NONBLOCK))
+		return;
+
+	flags = fcntl(tcpu->fd, F_GETFL);
+	flags &= ~O_NONBLOCK;
+	fcntl(tcpu->fd, F_SETFL, flags);
+	tcpu->flags &= ~TC_NONBLOCK;
+}
+
 /*
  * If set to blocking mode, block until the watermark has been
  * reached, or the control has said to stop. If the contol is
@@ -222,24 +239,24 @@ static void set_nonblock(struct tracefs_cpu *tcpu)
  */
 static int wait_on_input(struct tracefs_cpu *tcpu, bool nonblock)
 {
-	struct timeval tv, *ptv = NULL;
 	fd_set rfds;
 	int ret;
 
-	if (tcpu->flags & TC_NONBLOCK)
+	if (tcpu->flags & TC_PERM_NONBLOCK)
 		return 1;
 
 	if (nonblock) {
-		tv.tv_sec = 0;
-		tv.tv_usec = 0;
-		ptv = &tv;
+		set_nonblock(tcpu);
+		return 1;
+	} else {
+		unset_nonblock(tcpu);
 	}
 
 	FD_ZERO(&rfds);
 	FD_SET(tcpu->fd, &rfds);
 	FD_SET(tcpu->ctrl_pipe[0], &rfds);
 
-	ret = select(tcpu->nfds, &rfds, NULL, NULL, ptv);
+	ret = select(tcpu->nfds, &rfds, NULL, NULL, NULL);
 
 	/* Let the application decide what to do with signals and such */
 	if (ret < 0)
@@ -251,6 +268,8 @@ static int wait_on_input(struct tracefs_cpu *tcpu, bool nonblock)
 
 		/* Make nonblock as it is now stopped */
 		set_nonblock(tcpu);
+		/* Permanently set unblock */
+		tcpu->flags |= TC_PERM_NONBLOCK;
 	}
 
 	return FD_ISSET(tcpu->fd, &rfds);
@@ -275,8 +294,6 @@ static int wait_on_input(struct tracefs_cpu *tcpu, bool nonblock)
  */
 int tracefs_cpu_read(struct tracefs_cpu *tcpu, void *buffer, bool nonblock)
 {
-	bool orig_nonblock = nonblock;
-	long flags = 0;
 	int ret;
 
 	/*
@@ -290,8 +307,9 @@ int tracefs_cpu_read(struct tracefs_cpu *tcpu, void *buffer, bool nonblock)
 
 	ret = read(tcpu->fd, buffer, tcpu->subbuf_size);
 
-	if (nonblock != orig_nonblock && !(tcpu->flags & TC_NONBLOCK))
-		fcntl(tcpu->fd, F_SETFL, flags);
+	/* It's OK if there's no data to read */
+	if (ret < 0 && errno == EAGAIN)
+		ret = 0;
 
 	return ret;
 }
@@ -360,7 +378,7 @@ int tracefs_cpu_buffered_read(struct tracefs_cpu *tcpu, void *buffer, bool nonbl
 	if (ret <= 0)
 		return ret;
 
-	if (nonblock || tcpu->flags & TC_NONBLOCK)
+	if (tcpu->flags & TC_NONBLOCK)
 		mode |= SPLICE_F_NONBLOCK;
 
 	ret = init_splice(tcpu);
@@ -414,6 +432,8 @@ int tracefs_cpu_stop(struct tracefs_cpu *tcpu)
 	else
 		ret = 0;
 
+	set_nonblock(tcpu);
+
 	return ret;
 }
 
@@ -436,8 +456,7 @@ int tracefs_cpu_flush(struct tracefs_cpu *tcpu, void *buffer)
 	int ret;
 
 	/* Make sure that reading is now non blocking */
-	if (!(tcpu->flags & TC_NONBLOCK))
-		set_nonblock(tcpu);
+	set_nonblock(tcpu);
 
 	if (tcpu->buffered < 0)
 		tcpu->buffered = 0;
@@ -505,7 +524,7 @@ int tracefs_cpu_write(struct tracefs_cpu *tcpu, int wfd, bool nonblock)
 	if (ret <= 0)
 		return ret;
 
-	if (nonblock || tcpu->flags & TC_NONBLOCK)
+	if (tcpu->flags & TC_NONBLOCK)
 		mode |= SPLICE_F_NONBLOCK;
 
 	ret = init_splice(tcpu);
@@ -570,7 +589,7 @@ int tracefs_cpu_pipe(struct tracefs_cpu *tcpu, int wfd, bool nonblock)
 	if (ret <= 0)
 		return ret;
 
-	if (nonblock || tcpu->flags & TC_NONBLOCK)
+	if (tcpu->flags & TC_NONBLOCK)
 		mode |= SPLICE_F_NONBLOCK;
 
 	ret = splice(tcpu->fd, NULL, wfd, NULL,
diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index ef59e10431a4..2c9b267ea427 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -12,6 +12,8 @@
 #include <dirent.h>
 #include <ftw.h>
 #include <libgen.h>
+#include <kbuffer.h>
+#include <pthread.h>
 
 #include <CUnit/CUnit.h>
 #include <CUnit/Basic.h>
@@ -98,10 +100,16 @@ static void save_affinity(void)
 	cpus = sysconf(_SC_NPROCESSORS_CONF);
 	cpuset_save = CPU_ALLOC(cpus);
 	cpuset = CPU_ALLOC(cpus);
+	cpu_size = CPU_ALLOC_SIZE(cpus);
 	CU_TEST(cpuset_save != NULL && cpuset != NULL);
 	CU_TEST(sched_getaffinity(0, cpu_size, cpuset_save) == 0);
 }
 
+static void thread_affinity(void)
+{
+	sched_setaffinity(0, cpu_size, cpuset_save);
+}
+
 static void reset_affinity(void)
 {
 	sched_setaffinity(0, cpu_size, cpuset_save);
@@ -404,6 +412,317 @@ static void test_trace_sql(void)
 	test_instance_trace_sql(test_instance);
 }
 
+struct test_cpu_data {
+	struct tracefs_instance		*instance;
+	struct tracefs_cpu		*tcpu;
+	struct kbuffer			*kbuf;
+	struct tep_handle		*tep;
+	unsigned long long		missed_events;
+	void				*buf;
+	int				events_per_buf;
+	int				bufsize;
+	int				data_size;
+	int				this_pid;
+	int				fd;
+	bool				done;
+};
+
+static void cleanup_trace_cpu(struct test_cpu_data *data)
+{
+	close(data->fd);
+	tep_free(data->tep);
+	tracefs_cpu_close(data->tcpu);
+	free(data->buf);
+	kbuffer_free(data->kbuf);
+}
+
+#define EVENT_SYSTEM "syscalls"
+#define EVENT_NAME  "sys_enter_getppid"
+
+static int setup_trace_cpu(struct tracefs_instance *instance, struct test_cpu_data *data)
+{
+	struct tep_format_field **fields;
+	struct tep_event *event;
+	char tmpfile[] = "/tmp/utest-libtracefsXXXXXX";
+	int max = 0;
+	int ret;
+	int i;
+
+	/* Make sure tracing is on */
+	tracefs_trace_on(instance);
+
+	memset (data, 0, sizeof(*data));
+
+	data->instance = instance;
+
+	data->fd = mkstemp(tmpfile);
+	CU_TEST(data->fd >= 0);
+	unlink(tmpfile);
+	if (data->fd < 0)
+		return -1;
+
+	data->tep = tracefs_local_events(NULL);
+	CU_TEST(data->tep != NULL);
+	if (!data->tep)
+		goto fail;
+
+	data->tcpu = tracefs_cpu_open(instance, 0, true);
+	CU_TEST(data->tcpu != NULL);
+	if (!data->tcpu)
+		goto fail;
+
+	data->bufsize = tracefs_cpu_read_size(data->tcpu);
+
+	data->buf = calloc(1, data->bufsize);
+	CU_TEST(data->buf != NULL);
+	if (!data->buf)
+		goto fail;
+
+	data->kbuf = kbuffer_alloc(sizeof(long) == 8, !tep_is_bigendian());
+	CU_TEST(data->kbuf != NULL);
+	if (!data->kbuf)
+		goto fail;
+
+	data->data_size = data->bufsize - kbuffer_start_of_data(data->kbuf);
+
+	tracefs_instance_file_clear(instance, "trace");
+
+	event = tep_find_event_by_name(data->tep, EVENT_SYSTEM, EVENT_NAME);
+	CU_TEST(event != NULL);
+	if (!event)
+		goto fail;
+
+	fields = tep_event_fields(event);
+	CU_TEST(fields != NULL);
+	if (!fields)
+		goto fail;
+
+	for (i = 0; fields[i]; i++) {
+		int end = fields[i]->offset + fields[i]->size;
+		if (end > max)
+			max = end;
+	}
+	free(fields);
+
+	CU_TEST(max != 0);
+	if (!max)
+		goto fail;
+
+	data->events_per_buf = data->data_size / max;
+
+	data->this_pid = getpid();
+	ret = tracefs_event_enable(instance, EVENT_SYSTEM, EVENT_NAME);
+	CU_TEST(ret == 0);
+	if (ret)
+		goto fail;
+
+
+	save_affinity();
+	set_affinity(0);
+
+	return 0;
+ fail:
+	cleanup_trace_cpu(data);
+	return -1;
+}
+
+static void shutdown_trace_cpu(struct test_cpu_data *data)
+{
+	struct tracefs_instance *instance = data->instance;
+	int ret;
+
+	reset_affinity();
+
+	ret = tracefs_event_disable(instance, EVENT_SYSTEM, EVENT_NAME);
+	CU_TEST(ret == 0);
+
+	cleanup_trace_cpu(data);
+}
+
+static void call_getppid(int cnt)
+{
+	int i;
+
+	for (i = 0; i < cnt; i++)
+		getppid();
+}
+
+static void test_cpu_read(struct test_cpu_data *data, int expect)
+{
+	struct tracefs_cpu *tcpu = data->tcpu;
+	struct kbuffer *kbuf = data->kbuf;
+	struct tep_record record;
+	void *buf = data->buf;
+	unsigned long long ts;
+	bool first = true;
+	int pid;
+	int ret;
+	int cnt = 0;
+
+	call_getppid(expect);
+
+	for (;;) {
+		ret = tracefs_cpu_read(tcpu, buf, false);
+		CU_TEST(ret > 0 || !first);
+		if (ret <= 0)
+			break;
+		first = false;
+		ret = kbuffer_load_subbuffer(kbuf, buf);
+		CU_TEST(ret == 0);
+		for (;;) {
+			record.data = kbuffer_read_event(kbuf, &ts);
+			if (!record.data)
+				break;
+			record.ts = ts;
+			pid = tep_data_pid(data->tep, &record);
+			if (pid == data->this_pid)
+				cnt++;
+			kbuffer_next_event(kbuf, NULL);
+		}
+	}
+	CU_TEST(cnt == expect);
+}
+
+static void test_instance_trace_cpu_read(struct tracefs_instance *instance)
+{
+	struct test_cpu_data data;
+
+	if (setup_trace_cpu(instance, &data))
+		return;
+
+	test_cpu_read(&data, 1);
+	test_cpu_read(&data, data.events_per_buf / 2);
+	test_cpu_read(&data, data.events_per_buf);
+	test_cpu_read(&data, data.events_per_buf + 1);
+	test_cpu_read(&data, data.events_per_buf * 50);
+
+	shutdown_trace_cpu(&data);
+}
+
+static void test_trace_cpu_read(void)
+{
+	test_instance_trace_cpu_read(NULL);
+	test_instance_trace_cpu_read(test_instance);
+}
+
+static int read_trace_cpu_file(struct test_cpu_data *data)
+{
+	unsigned long long ts;
+	struct tep_record record;
+	struct kbuffer *kbuf = data->kbuf;
+	void *buf = data->buf;
+	bool first = true;
+	int bufsize = data->bufsize;
+	int fd = data->fd;
+	int missed;
+	int pid;
+	int ret;
+	int cnt = 0;
+
+	ret = lseek64(fd, 0, SEEK_SET);
+	CU_TEST(ret == 0);
+	if (ret)
+		return -1;
+
+	for (;;) {
+		ret = read(fd, buf, bufsize);
+		CU_TEST(ret > 0 || !first);
+		if (ret <= 0)
+			break;
+		first = false;
+
+		ret = kbuffer_load_subbuffer(kbuf, buf);
+		CU_TEST(ret == 0);
+		missed = kbuffer_missed_events(kbuf);
+		if (missed)
+			printf("missed events %d\n", missed);
+		for (;;) {
+			record.data = kbuffer_read_event(kbuf, &ts);
+			if (!record.data)
+				break;
+			record.ts = ts;
+			pid = tep_data_pid(data->tep, &record);
+			if (pid == data->this_pid)
+				cnt++;
+			kbuffer_next_event(kbuf, NULL);
+		}
+	}
+	return ret == 0 ? cnt : ret;
+}
+
+static void *trace_cpu_thread(void *arg)
+{
+	struct test_cpu_data *data = arg;
+	struct tracefs_cpu *tcpu = data->tcpu;
+	int fd = data->fd;
+	long ret = 0;
+
+	thread_affinity();
+
+	while (!data->done && ret >= 0) {
+		ret = tracefs_cpu_write(tcpu, fd, false);
+		if (ret < 0 && errno == EAGAIN)
+			ret = 0;
+	}
+	if (ret >= 0 || errno == EAGAIN) {
+		do {
+			ret = tracefs_cpu_flush_write(tcpu, fd);
+		} while (ret > 0);
+	}
+
+	return (void *)ret;
+}
+
+static void test_cpu_pipe(struct test_cpu_data *data, int expect)
+{
+	pthread_t thread;
+	void *retval;
+	long ret;
+	int cnt;
+
+	tracefs_instance_file_clear(data->instance, "trace");
+	ftruncate(data->fd, 0);
+
+	data->done = false;
+
+	pthread_create(&thread, NULL, trace_cpu_thread, data);
+	sleep(1);
+
+	call_getppid(expect);
+
+	data->done = true;
+	tracefs_cpu_stop(data->tcpu);
+	pthread_join(thread, &retval);
+	ret = (long)retval;
+	CU_TEST(ret >= 0);
+
+	cnt = read_trace_cpu_file(data);
+
+	CU_TEST(cnt == expect);
+}
+
+static void test_instance_trace_cpu_pipe(struct tracefs_instance *instance)
+{
+	struct test_cpu_data data;
+
+	if (setup_trace_cpu(instance, &data))
+		return;
+
+	test_cpu_pipe(&data, 1);
+	test_cpu_pipe(&data, data.events_per_buf / 2);
+	test_cpu_pipe(&data, data.events_per_buf);
+	test_cpu_pipe(&data, data.events_per_buf + 1);
+	test_cpu_pipe(&data, data.events_per_buf * 1000);
+
+	shutdown_trace_cpu(&data);
+}
+
+static void test_trace_cpu_pipe(void)
+{
+	test_instance_trace_cpu_pipe(NULL);
+	test_instance_trace_cpu_pipe(test_instance);
+}
+
 static struct tracefs_dynevent **get_dynevents_check(enum tracefs_dynevent_type types, int count)
 {
 	struct tracefs_dynevent **devents;
@@ -1794,6 +2113,10 @@ void test_tracefs_lib(void)
 		fprintf(stderr, "Suite \"%s\" cannot be ceated\n", TRACEFS_SUITE);
 		return;
 	}
+	CU_add_test(suite, "trace cpu read",
+		    test_trace_cpu_read);
+	CU_add_test(suite, "trace cpu pipe",
+		    test_trace_cpu_pipe);
 	CU_add_test(suite, "trace sql",
 		    test_trace_sql);
 	CU_add_test(suite, "tracing file / directory APIs",
-- 
2.35.1


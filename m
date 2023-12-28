Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949CD107A3
	for <linux-trace-devel@vger.kernel.org>; Thu, 28 Dec 2023 20:36:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23F8AC433AB;
	Thu, 28 Dec 2023 20:36:26 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rIx7z-00000000DtQ-3ilH;
	Thu, 28 Dec 2023 15:37:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 14/23] libtracefs utest: Add test to test tracefs_instance_set/get_buffer_percent()
Date: Thu, 28 Dec 2023 15:35:36 -0500
Message-ID: <20231228203714.53294-15-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231228203714.53294-1-rostedt@goodmis.org>
References: <20231228203714.53294-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add a utest that tests different "buffer_percent" values using the
tracefs_instance_set_buffer_percent() API. It also will test the
tracefs_instance_get_buffer_percent().

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 utest/tracefs-utest.c | 163 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 154 insertions(+), 9 deletions(-)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 98cfd322b171..6a817125419f 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -53,6 +53,8 @@
 #define TRACEFS_DEFAULT_PATH "/sys/kernel/tracing"
 #define TRACEFS_DEFAULT2_PATH "/sys/kernel/debug/tracing"
 
+static pthread_barrier_t trace_barrier;
+
 static struct tracefs_instance *test_instance;
 static struct tep_handle *test_tep;
 struct test_sample {
@@ -435,6 +437,7 @@ struct test_cpu_data {
 	void				*buf;
 	int				events_per_buf;
 	int				bufsize;
+	int				nr_subbufs;
 	int				data_size;
 	int				this_pid;
 	int				fd;
@@ -452,11 +455,21 @@ static void cleanup_trace_cpu(struct test_cpu_data *data)
 #define EVENT_SYSTEM "syscalls"
 #define EVENT_NAME  "sys_enter_getppid"
 
-static int setup_trace_cpu(struct tracefs_instance *instance, struct test_cpu_data *data)
+static int make_trace_temp_file(void)
+{
+	char tmpfile[] = "/tmp/utest-libtracefsXXXXXX";
+	int fd;
+
+	fd = mkstemp(tmpfile);
+	unlink(tmpfile);
+	return fd;
+}
+
+static int setup_trace_cpu(struct tracefs_instance *instance, struct test_cpu_data *data, bool nonblock)
 {
 	struct tep_format_field **fields;
 	struct tep_event *event;
-	char tmpfile[] = "/tmp/utest-libtracefsXXXXXX";
+	ssize_t buffer_size;
 	int max = 0;
 	int ret;
 	int i;
@@ -468,20 +481,26 @@ static int setup_trace_cpu(struct tracefs_instance *instance, struct test_cpu_da
 
 	data->instance = instance;
 
-	data->fd = mkstemp(tmpfile);
+	data->fd = make_trace_temp_file();
 	CU_TEST(data->fd >= 0);
-	unlink(tmpfile);
 	if (data->fd < 0)
 		return -1;
 
 	data->tep = test_tep;
 
-	data->tcpu = tracefs_cpu_open(instance, 0, true);
+	data->tcpu = tracefs_cpu_open(instance, 0, nonblock);
 	CU_TEST(data->tcpu != NULL);
 	if (!data->tcpu)
 		goto fail;
 
 	data->bufsize = tracefs_cpu_read_size(data->tcpu);
+	CU_TEST(data->bufsize > 0);
+
+	data->data_size = tep_get_sub_buffer_data_size(data->tep);
+	CU_TEST(data->data_size > 0);
+
+	buffer_size = tracefs_instance_get_buffer_size(instance, 0) * 1024;
+	data->nr_subbufs = buffer_size/ data->data_size;
 
 	data->buf = calloc(1, data->bufsize);
 	CU_TEST(data->buf != NULL);
@@ -493,8 +512,6 @@ static int setup_trace_cpu(struct tracefs_instance *instance, struct test_cpu_da
 	if (!data->kbuf)
 		goto fail;
 
-	data->data_size = data->bufsize - kbuffer_start_of_data(data->kbuf);
-
 	tracefs_instance_file_clear(instance, "trace");
 
 	event = tep_find_event_by_name(data->tep, EVENT_SYSTEM, EVENT_NAME);
@@ -518,6 +535,12 @@ static int setup_trace_cpu(struct tracefs_instance *instance, struct test_cpu_da
 	if (!max)
 		goto fail;
 
+	/* round up to long size alignment */
+	max = ((max + sizeof(long) - 1)) & ~(sizeof(long) - 1);
+
+	/* Add meta header */
+	max += 4;
+
 	data->events_per_buf = data->data_size / max;
 
 	data->this_pid = getpid();
@@ -549,6 +572,17 @@ static void shutdown_trace_cpu(struct test_cpu_data *data)
 	cleanup_trace_cpu(data);
 }
 
+static void reset_trace_cpu(struct test_cpu_data *data, bool nonblock)
+{
+	close(data->fd);
+	tracefs_cpu_close(data->tcpu);
+
+	data->fd = make_trace_temp_file();
+	CU_TEST(data->fd >= 0);
+	data->tcpu = tracefs_cpu_open(data->instance, 0, nonblock);
+	CU_TEST(data->tcpu != NULL);
+}
+
 static void call_getppid(int cnt)
 {
 	int i;
@@ -597,7 +631,7 @@ static void test_instance_trace_cpu_read(struct tracefs_instance *instance)
 {
 	struct test_cpu_data data;
 
-	if (setup_trace_cpu(instance, &data))
+	if (setup_trace_cpu(instance, &data, true))
 		return;
 
 	test_cpu_read(&data, 1);
@@ -615,6 +649,115 @@ static void test_trace_cpu_read(void)
 	test_instance_trace_cpu_read(test_instance);
 }
 
+static void *trace_cpu_read_thread(void *arg)
+{
+	struct test_cpu_data *data = arg;
+	struct tracefs_cpu *tcpu = data->tcpu;
+	struct kbuffer *kbuf;
+	long ret = 0;
+
+	pthread_barrier_wait(&trace_barrier);
+
+	kbuf = tracefs_cpu_read_buf(tcpu, false);
+	CU_TEST(kbuf != NULL);
+	data->done = true;
+
+	return (void *)ret;
+}
+
+static void test_cpu_read_buf_percent(struct test_cpu_data *data, int percent)
+{
+	pthread_t thread;
+	int save_percent;
+	ssize_t expect;
+	int ret;
+
+	tracefs_instance_clear(data->instance);
+
+	save_percent = tracefs_instance_get_buffer_percent(data->instance);
+	CU_TEST(save_percent >= 0);
+
+	ret = tracefs_instance_set_buffer_percent(data->instance, percent);
+	CU_TEST(ret == 0);
+
+	data->done = false;
+
+	pthread_barrier_init(&trace_barrier, NULL, 2);
+
+	pthread_create(&thread, NULL, trace_cpu_read_thread, data);
+
+	pthread_barrier_wait(&trace_barrier);
+
+	msleep(100);
+
+	CU_TEST(data->done == false);
+
+	/* For percent == 0, just test for any data */
+	if (percent) {
+		expect = data->nr_subbufs * data->events_per_buf * percent / 100;
+
+		/* Add just under the percent */
+		expect -= data->events_per_buf;
+		CU_TEST(expect > 0);
+
+		call_getppid(expect);
+
+		msleep(100);
+
+		CU_TEST(data->done == false);
+
+		/* Add just over the percent */
+		expect = data->events_per_buf * 2;
+	} else {
+		expect = data->events_per_buf;
+	}
+
+	call_getppid(expect);
+
+	msleep(100);
+
+	CU_TEST(data->done == true);
+
+	while (tracefs_cpu_flush_buf(data->tcpu))
+		;
+
+	tracefs_cpu_stop(data->tcpu);
+	pthread_join(thread, NULL);
+
+	ret = tracefs_instance_set_buffer_percent(data->instance, save_percent);
+	CU_TEST(ret == 0);
+}
+
+static void test_instance_trace_cpu_read_buf_percent(struct tracefs_instance *instance)
+{
+	struct test_cpu_data data;
+
+	if (setup_trace_cpu(instance, &data, false))
+		return;
+
+	test_cpu_read_buf_percent(&data, 0);
+
+	reset_trace_cpu(&data, false);
+
+	test_cpu_read_buf_percent(&data, 1);
+
+	reset_trace_cpu(&data, false);
+
+	test_cpu_read_buf_percent(&data, 50);
+
+	reset_trace_cpu(&data, false);
+
+	test_cpu_read_buf_percent(&data, 100);
+
+	shutdown_trace_cpu(&data);
+}
+
+static void test_trace_cpu_read_buf_percent(void)
+{
+	test_instance_trace_cpu_read_buf_percent(NULL);
+	test_instance_trace_cpu_read_buf_percent(test_instance);
+}
+
 struct follow_data {
 	struct tep_event *sched_switch;
 	struct tep_event *sched_waking;
@@ -1152,7 +1295,7 @@ static void test_instance_trace_cpu_pipe(struct tracefs_instance *instance)
 {
 	struct test_cpu_data data;
 
-	if (setup_trace_cpu(instance, &data))
+	if (setup_trace_cpu(instance, &data, true))
 		return;
 
 	test_cpu_pipe(&data, 1);
@@ -2808,6 +2951,8 @@ void test_tracefs_lib(void)
 	CU_add_test(suite, "Test tracefs/debugfs mounting", test_mounting);
 	CU_add_test(suite, "trace cpu read",
 		    test_trace_cpu_read);
+	CU_add_test(suite, "trace cpu read_buf_percent",
+		    test_trace_cpu_read_buf_percent);
 	CU_add_test(suite, "trace cpu pipe",
 		    test_trace_cpu_pipe);
 	CU_add_test(suite, "trace sql",
-- 
2.42.0


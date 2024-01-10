Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93DA1FA6
	for <linux-trace-devel@vger.kernel.org>; Wed, 10 Jan 2024 03:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B315C433A6;
	Wed, 10 Jan 2024 03:00:18 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rNOqD-00000000LM0-2ytX;
	Tue, 09 Jan 2024 22:01:17 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Vincent Donnefort <vdonnefort@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 7/7] libtracefs utest: Add tests to use mapping if supported
Date: Tue,  9 Jan 2024 21:51:51 -0500
Message-ID: <20240110030116.81837-8-rostedt@goodmis.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240110030116.81837-1-rostedt@goodmis.org>
References: <20240110030116.81837-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If the memory mapping of the ring buffer is supported, run the tests that do
tracefs_cpu_open() also with tracefs_cpu_open_mapped().

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 utest/tracefs-utest.c | 69 ++++++++++++++++++++++++++++++-------------
 1 file changed, 49 insertions(+), 20 deletions(-)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index f5afec0e338a..963fac70846d 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -122,6 +122,8 @@ static struct test_sample test_array[TEST_ARRAY_SIZE];
 static int test_found;
 static unsigned long long last_ts;
 
+static bool mapping_is_supported;
+
 static void msleep(int ms)
 {
 	struct timespec tspec;
@@ -1098,7 +1100,7 @@ static int make_trace_temp_file(void)
 	return fd;
 }
 
-static int setup_trace_cpu(struct tracefs_instance *instance, struct test_cpu_data *data, bool nonblock)
+static int setup_trace_cpu(struct tracefs_instance *instance, struct test_cpu_data *data, bool nonblock, bool map)
 {
 	struct tep_format_field **fields;
 	struct tep_event *event;
@@ -1121,7 +1123,11 @@ static int setup_trace_cpu(struct tracefs_instance *instance, struct test_cpu_da
 
 	data->tep = test_tep;
 
-	data->tcpu = tracefs_cpu_open(instance, 0, nonblock);
+	if (map)
+		data->tcpu = tracefs_cpu_open_mapped(instance, 0, nonblock);
+	else
+		data->tcpu = tracefs_cpu_open(instance, 0, nonblock);
+
 	CU_TEST(data->tcpu != NULL);
 	if (!data->tcpu)
 		goto fail;
@@ -1205,14 +1211,17 @@ static void shutdown_trace_cpu(struct test_cpu_data *data)
 	cleanup_trace_cpu(data);
 }
 
-static void reset_trace_cpu(struct test_cpu_data *data, bool nonblock)
+static void reset_trace_cpu(struct test_cpu_data *data, bool nonblock, bool map)
 {
 	close(data->fd);
 	tracefs_cpu_close(data->tcpu);
 
 	data->fd = make_trace_temp_file();
 	CU_TEST(data->fd >= 0);
-	data->tcpu = tracefs_cpu_open(data->instance, 0, nonblock);
+	if (map)
+		data->tcpu = tracefs_cpu_open_mapped(data->instance, 0, nonblock);
+	else
+		data->tcpu = tracefs_cpu_open(data->instance, 0, nonblock);
 	CU_TEST(data->tcpu != NULL);
 }
 
@@ -1252,11 +1261,11 @@ static void test_cpu_read(struct test_cpu_data *data, int expect)
 	CU_TEST(cnt == expect);
 }
 
-static void test_instance_trace_cpu_read(struct tracefs_instance *instance)
+static void test_instance_trace_cpu_read(struct tracefs_instance *instance, bool map)
 {
 	struct test_cpu_data data;
 
-	if (setup_trace_cpu(instance, &data, true))
+	if (setup_trace_cpu(instance, &data, true, map))
 		return;
 
 	test_cpu_read(&data, 1);
@@ -1270,8 +1279,13 @@ static void test_instance_trace_cpu_read(struct tracefs_instance *instance)
 
 static void test_trace_cpu_read(void)
 {
-	test_instance_trace_cpu_read(NULL);
-	test_instance_trace_cpu_read(test_instance);
+	test_instance_trace_cpu_read(NULL, false);
+	if (mapping_is_supported)
+		test_instance_trace_cpu_read(NULL, true);
+
+	test_instance_trace_cpu_read(test_instance, false);
+	if (mapping_is_supported)
+		test_instance_trace_cpu_read(test_instance, true);
 }
 
 static void *trace_cpu_read_thread(void *arg)
@@ -1292,6 +1306,7 @@ static void *trace_cpu_read_thread(void *arg)
 
 static void test_cpu_read_buf_percent(struct test_cpu_data *data, int percent)
 {
+	char buffer[tracefs_cpu_read_size(data->tcpu)];
 	pthread_t thread;
 	int save_percent;
 	ssize_t expect;
@@ -1343,7 +1358,7 @@ static void test_cpu_read_buf_percent(struct test_cpu_data *data, int percent)
 
 	CU_TEST(data->done == true);
 
-	while (tracefs_cpu_flush_buf(data->tcpu))
+	while (tracefs_cpu_flush(data->tcpu, buffer))
 		;
 
 	tracefs_cpu_stop(data->tcpu);
@@ -1353,24 +1368,24 @@ static void test_cpu_read_buf_percent(struct test_cpu_data *data, int percent)
 	CU_TEST(ret == 0);
 }
 
-static void test_instance_trace_cpu_read_buf_percent(struct tracefs_instance *instance)
+static void test_instance_trace_cpu_read_buf_percent(struct tracefs_instance *instance, bool map)
 {
 	struct test_cpu_data data;
 
-	if (setup_trace_cpu(instance, &data, false))
+	if (setup_trace_cpu(instance, &data, false, map))
 		return;
 
 	test_cpu_read_buf_percent(&data, 0);
 
-	reset_trace_cpu(&data, false);
+	reset_trace_cpu(&data, false, map);
 
 	test_cpu_read_buf_percent(&data, 1);
 
-	reset_trace_cpu(&data, false);
+	reset_trace_cpu(&data, false, map);
 
 	test_cpu_read_buf_percent(&data, 50);
 
-	reset_trace_cpu(&data, false);
+	reset_trace_cpu(&data, false, map);
 
 	test_cpu_read_buf_percent(&data, 100);
 
@@ -1379,8 +1394,12 @@ static void test_instance_trace_cpu_read_buf_percent(struct tracefs_instance *in
 
 static void test_trace_cpu_read_buf_percent(void)
 {
-	test_instance_trace_cpu_read_buf_percent(NULL);
-	test_instance_trace_cpu_read_buf_percent(test_instance);
+	test_instance_trace_cpu_read_buf_percent(NULL, false);
+	if (mapping_is_supported)
+		test_instance_trace_cpu_read_buf_percent(NULL, true);
+	test_instance_trace_cpu_read_buf_percent(test_instance, false);
+	if (mapping_is_supported)
+		test_instance_trace_cpu_read_buf_percent(test_instance, true);
 }
 
 struct follow_data {
@@ -1916,11 +1935,11 @@ static void test_cpu_pipe(struct test_cpu_data *data, int expect)
 	CU_TEST(cnt == expect);
 }
 
-static void test_instance_trace_cpu_pipe(struct tracefs_instance *instance)
+static void test_instance_trace_cpu_pipe(struct tracefs_instance *instance, bool map)
 {
 	struct test_cpu_data data;
 
-	if (setup_trace_cpu(instance, &data, true))
+	if (setup_trace_cpu(instance, &data, true, map))
 		return;
 
 	test_cpu_pipe(&data, 1);
@@ -1934,8 +1953,12 @@ static void test_instance_trace_cpu_pipe(struct tracefs_instance *instance)
 
 static void test_trace_cpu_pipe(void)
 {
-	test_instance_trace_cpu_pipe(NULL);
-	test_instance_trace_cpu_pipe(test_instance);
+	test_instance_trace_cpu_pipe(NULL, false);
+	if (mapping_is_supported)
+		test_instance_trace_cpu_pipe(NULL, true);
+	test_instance_trace_cpu_pipe(test_instance, false);
+	if (mapping_is_supported)
+		test_instance_trace_cpu_pipe(test_instance, true);
 }
 
 static struct tracefs_dynevent **get_dynevents_check(enum tracefs_dynevent_type types, int count)
@@ -3557,6 +3580,12 @@ static int test_suite_init(void)
 	if (!test_instance)
 		return 1;
 
+	mapping_is_supported = tracefs_mapped_is_supported();
+	if (mapping_is_supported)
+		printf("Testing mmapped buffers too\n");
+	else
+		printf("Memory mapped buffers not supported\n");
+
 	/* Start with a new slate */
 	tracefs_instance_reset(NULL);
 
-- 
2.43.0


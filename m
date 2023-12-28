Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77ACF101F8
	for <linux-trace-devel@vger.kernel.org>; Thu, 28 Dec 2023 20:36:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6BE6C433CB;
	Thu, 28 Dec 2023 20:36:25 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rIx7z-00000000Dsd-2QlL;
	Thu, 28 Dec 2023 15:37:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 02/23] libtracefs testing: Use one tep handle for most tests
Date: Thu, 28 Dec 2023 15:35:24 -0500
Message-ID: <20231228203714.53294-3-rostedt@goodmis.org>
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

Creating a tep handle with all events takes a bit of time. Instead of
recreating one for every test, have the main test_tep handle load all events
and use that for all tests that do not need to add special events (like the
dynamic event tests).

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 utest/tracefs-utest.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 398c94368e66..5ce4bafbfda5 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -366,8 +366,7 @@ static void test_instance_trace_sql(struct tracefs_instance *instance)
 	struct tep_event *event;
 	int ret;
 
-	tep = tracefs_local_events(NULL);
-	CU_TEST(tep != NULL);
+	tep = test_tep;
 
 	trace_seq_init(&seq);
 
@@ -409,7 +408,6 @@ static void test_instance_trace_sql(struct tracefs_instance *instance)
 		trace_seq_reset(&seq);
 	}
 
-	tep_free(tep);
 	trace_seq_destroy(&seq);
 }
 
@@ -436,7 +434,6 @@ struct test_cpu_data {
 static void cleanup_trace_cpu(struct test_cpu_data *data)
 {
 	close(data->fd);
-	tep_free(data->tep);
 	tracefs_cpu_close(data->tcpu);
 	free(data->buf);
 	kbuffer_free(data->kbuf);
@@ -467,10 +464,7 @@ static int setup_trace_cpu(struct tracefs_instance *instance, struct test_cpu_da
 	if (data->fd < 0)
 		return -1;
 
-	data->tep = tracefs_local_events(NULL);
-	CU_TEST(data->tep != NULL);
-	if (!data->tep)
-		goto fail;
+	data->tep = test_tep;
 
 	data->tcpu = tracefs_cpu_open(instance, 0, true);
 	CU_TEST(data->tcpu != NULL);
@@ -685,10 +679,7 @@ static void test_instance_follow_events(struct tracefs_instance *instance)
 
 	memset(&fdata, 0, sizeof(fdata));
 
-	tep = tracefs_local_events(NULL);
-	CU_TEST(tep != NULL);
-	if (!tep)
-		return;
+	tep = test_tep;
 
 	fdata.sched_switch = tep_find_event_by_name(tep, "sched", "sched_switch");
 	CU_TEST(fdata.sched_switch != NULL);
@@ -2529,9 +2520,7 @@ static int test_suite_destroy(void)
 
 static int test_suite_init(void)
 {
-	const char *systems[] = {"ftrace", NULL};
-
-	test_tep = tracefs_local_events_system(NULL, systems);
+	test_tep = tracefs_local_events(NULL);
 	if (test_tep == NULL)
 		return 1;
 	test_instance = tracefs_instance_create(TEST_INSTANCE_NAME);
-- 
2.42.0


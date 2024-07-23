Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0954C145A0F
	for <linux-trace-devel@vger.kernel.org>; Tue, 23 Jul 2024 22:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721772518; cv=none; b=js1jY3hV1ZMYne/shBxDIRoOdSLJFf8Dh5bGptxdcD8uspxPHzaHLGx0wPPF1DFAQqBsZ8rHNA1MyFQ5tq4ceSPTSxPf0PXnNxf2rsAs1S8BANiMLLc9ZlN1g9ZVGM7XUAJwNfm7QrAOcGH/YUHCpIRlMwJt87MMpIrVCKHq2P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721772518; c=relaxed/simple;
	bh=dtBLdVSzJpLi/+M+5PbcpG0LVHsfLgEiy1w6nfQOc6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mQtpXrLxo6crzlRD31mpopYvyWZYiXsnfSoEJToG0yK5XCZhnhRw1/P3bStPT5nffpQbIhIRuZBO+f3ypJqgYF4m/TR/uuoGWDQLUTZim/hmYYbAElFnZbo6cD+RW/hLuRwjL4DIl+2DHNmUQ0rBg1JgCSLK7yxl9OGFAreFzUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE033C4AF09;
	Tue, 23 Jul 2024 22:08:37 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1sWNgk-000000023G4-3BNq;
	Tue, 23 Jul 2024 18:08:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 3/3] libtracefs utest: Add better logic to cause missed events
Date: Tue, 23 Jul 2024 18:07:25 -0400
Message-ID: <20240723220853.489058-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240723220853.489058-1-rostedt@goodmis.org>
References: <20240723220853.489058-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

When the system is running without much debug, it is possible to run the
function tracer without triggering missed events. As the tests are expecting
to have missed events to test the missed events handler, it gfails the test
because no missed events happen, and the missed events handler is correctly
not called. But the tests expect it to be called.

Add more logic to force missed events.

 * Shrink the buffer to just 4 pages.
 * Run "ls -l /usr/bin > /dev/null" instead of sleep().

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 utest/tracefs-utest.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 737e54a4f7fe..b29525335116 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -1576,6 +1576,8 @@ static void test_instance_follow_events_clear(struct tracefs_instance *instance)
 {
 	struct follow_data fdata;
 	struct tep_handle *tep;
+	unsigned long page_size;
+	size_t save_size;
 	char **list;
 	int ret;
 
@@ -1671,7 +1673,7 @@ static void test_instance_follow_events_clear(struct tracefs_instance *instance)
 
 	tracefs_trace_on(instance);
 	call_getppid(100);
-	msleep(100);
+	system("ls -l /usr/bin > /dev/null");
 	tracefs_trace_off(instance);
 
 	ret = tracefs_iterate_raw_events(tep, instance, NULL, 0, NULL, &fdata);
@@ -1695,17 +1697,26 @@ static void test_instance_follow_events_clear(struct tracefs_instance *instance)
 	if (!fdata.function)
 		return;
 
+	/* Shrink the buffer to make sure we have missed events */
+	page_size = getpagesize();
+	save_size = tracefs_instance_get_buffer_size(instance, 0);
+	ret = tracefs_instance_set_buffer_size(instance, page_size * 4, 0);
+	CU_TEST(ret == 0);
+
 	tracefs_trace_on(instance);
 	call_getppid(100);
 	/* Stir the kernel a bit */
 	list = tracefs_event_systems(NULL);
 	tracefs_list_free(list);
-	sleep(1);
+	system("ls -l /usr/bin > /dev/null");
 	tracefs_trace_off(instance);
 
 	ret = tracefs_iterate_raw_events(tep, instance, NULL, 0, NULL, &fdata);
 	CU_TEST(ret == 0);
 
+	ret = tracefs_instance_set_buffer_size(instance, save_size, 0);
+	CU_TEST(ret == 0);
+
 	/* Nothing should have been hit */
 	CU_TEST(fdata.switch_hit == 0);
 	CU_TEST(fdata.waking_hit == 0);
-- 
2.43.0


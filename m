Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B68227BAE
	for <linux-trace-devel@vger.kernel.org>; Thu, 17 Oct 2024 20:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729195546; cv=none; b=Q5mLxDjUU/MwxGFyYex6utjcTDjKHW5icCtpugqJrSRA/OrgTM/ndyM07BNBQ1nhBSXdvyMHDnE746msoUrnjQdRv5LZwDTDNdJNg0VhyRIwhBb/CbL/x2QIFeMSTJvtV+jxWe1+g29UsEnx8xZ9J0paXCCqiOJlP+Pf+prLD30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729195546; c=relaxed/simple;
	bh=mRvYD46HogsseOblnw3hLrunIP1w2ubXtC5e8MdXrDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eLZPzYodL9WvnoaFnLNGkKC3M9x8I5wlDU4m+SrR8g0OGZBFArpcM39XR0LR7zpj10yujqAQ12mCS7QLwbvLHf/+9YyxrJv5AV9+TKlyZYvd+wb7uVoW6fXdYgDhjxVnQVvUxbQ0GfEu96vpaJgalvshNkwjpZkSKdqCBgk5bIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED859C4CED2;
	Thu, 17 Oct 2024 20:05:45 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1t1Wl8-00000003uhG-2Lr7;
	Thu, 17 Oct 2024 16:06:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Adrien Nader <adrien@notk.org>
Subject: [PATCH 3/3] libtracefs utest: Do not test more events than what the ring buffer can hold
Date: Thu, 17 Oct 2024 16:03:24 -0400
Message-ID: <20241017200609.932728-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241017200609.932728-1-rostedt@goodmis.org>
References: <20241017200609.932728-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The test_instance_cpu_read() will test events_per_buf * 50 events. But on
PowerPC64 which has 64K size subbuffers, there may not be 50 subbuffers in
a per CPU ring buffer. That means the test will overflow and it will read
less events than expected.

Check to make sure that the number to test is not going to add more events
than what a single ring buffer can hold.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=219358
Reported-by: Adrien Nader <adrien@notk.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 utest/tracefs-utest.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index b5095a18bb16..46fa31c88cf6 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -1270,6 +1270,8 @@ static void test_cpu_read(struct test_cpu_data *data, int expect)
 static void test_instance_trace_cpu_read(struct tracefs_instance *instance, bool map)
 {
 	struct test_cpu_data data;
+	size_t buffer_size;
+	int big_num = 50;
 
 	if (setup_trace_cpu(instance, &data, true, map))
 		return;
@@ -1278,7 +1280,14 @@ static void test_instance_trace_cpu_read(struct tracefs_instance *instance, bool
 	test_cpu_read(&data, data.events_per_buf / 2);
 	test_cpu_read(&data, data.events_per_buf);
 	test_cpu_read(&data, data.events_per_buf + 1);
-	test_cpu_read(&data, data.events_per_buf * 50);
+
+	buffer_size = tracefs_instance_get_buffer_size(instance, 0) * 1024;
+	if (data.events_per_buf * big_num > (buffer_size - data.events_per_buf)) {
+		big_num = (buffer_size / data.events_per_buf);
+		big_num -= data.events_per_buf * 2;
+		CU_TEST(big_num > 0);
+	}
+	test_cpu_read(&data, data.events_per_buf * big_num);
 
 	shutdown_trace_cpu(&data);
 }
-- 
2.45.2


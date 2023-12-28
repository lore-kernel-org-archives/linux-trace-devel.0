Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9436710795
	for <linux-trace-devel@vger.kernel.org>; Thu, 28 Dec 2023 20:36:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026CFC43391;
	Thu, 28 Dec 2023 20:36:26 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rIx7z-00000000Dsy-2we4;
	Thu, 28 Dec 2023 15:37:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 07/23] libtracefs: Reset tracing before and after unit tests
Date: Thu, 28 Dec 2023 15:35:29 -0500
Message-ID: <20231228203714.53294-8-rostedt@goodmis.org>
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

After having tests constantly fail because of some left over tracing that
was still enabled before the test started, call tracefs_instance_reset()
before and after the unit tests to make sure it starts with a clean slate
and does not fail due to residual tracing that was from an external event.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 utest/tracefs-utest.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 28960c191581..183f37cd133a 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -2516,6 +2516,7 @@ static void test_custom_trace_dir(void)
 
 static int test_suite_destroy(void)
 {
+	tracefs_instance_reset(NULL);
 	tracefs_instance_destroy(test_instance);
 	tracefs_instance_free(test_instance);
 	tep_free(test_tep);
@@ -2531,6 +2532,9 @@ static int test_suite_init(void)
 	if (!test_instance)
 		return 1;
 
+	/* Start with a new slate */
+	tracefs_instance_reset(NULL);
+
 	return 0;
 }
 
-- 
2.42.0


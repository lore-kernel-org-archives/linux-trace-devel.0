Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7104B10968
	for <linux-trace-devel@vger.kernel.org>; Thu, 28 Dec 2023 21:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00BD8C433D9;
	Thu, 28 Dec 2023 21:53:45 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rIyKo-00000000EIz-3iZQ;
	Thu, 28 Dec 2023 16:54:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 06/22] libtracefs: Free dynamic event list in utest
Date: Thu, 28 Dec 2023 16:52:01 -0500
Message-ID: <20231228215433.54854-7-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231228215433.54854-1-rostedt@goodmis.org>
References: <20231228215433.54854-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

When adding the tests for the tracefs_kprobe_destroy() API, the call to
get_dynevents_check() did not save the results and free it. This check can
only be ignored if the expected result is zero (passed in as the second
parameter), as in that case, the return would be NULL.

Fixes: 18ede68f ("libtracefs: Add tracefs_kprobe_destory() API")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 utest/tracefs-utest.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 5ce4bafbfda5..28960c191581 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -1364,7 +1364,9 @@ static void test_kprobes_instance(struct tracefs_instance *instance)
 		ret = tracefs_kprobe_destroy(ktests[i].system, ktests[i].event,
 					     ktests[i].address, ktests[i].format, true);
 		CU_TEST(ret == 0);
-		get_dynevents_check(TRACEFS_DYNEVENT_KPROBE, kprobe_count - (i + 1));
+		devents = get_dynevents_check(TRACEFS_DYNEVENT_KPROBE,
+					      kprobe_count - (i + 1));
+		tracefs_dynevent_list_free(devents);
 	}
 	get_dynevents_check(TRACEFS_DYNEVENT_KPROBE, 0);
 
@@ -1372,7 +1374,9 @@ static void test_kprobes_instance(struct tracefs_instance *instance)
 		ret = tracefs_kprobe_destroy(kretests[i].system, kretests[i].event,
 					     kretests[i].address, kretests[i].format, true);
 		CU_TEST(ret == 0);
-		get_dynevents_check(TRACEFS_DYNEVENT_KRETPROBE, kretprobe_count - (i + 1));
+		devents = get_dynevents_check(TRACEFS_DYNEVENT_KRETPROBE,
+					      kretprobe_count - (i + 1));
+		tracefs_dynevent_list_free(devents);
 	}
 	get_dynevents_check(TRACEFS_DYNEVENT_KRETPROBE, 0);
 
-- 
2.42.0


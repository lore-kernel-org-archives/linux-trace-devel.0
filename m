Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2CF331AF14
	for <linux-trace-devel@vger.kernel.org>; Thu, 23 Apr 2026 20:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776975727; cv=none; b=cWutDgv1qoA3XaWpyZy5kPvl+snTY76biyVFAJk1wsBy6PMh2JnjYIKlkEZeC18bsnzyVGyj1KvffJJITB13zSp0mUYHT/MVV/7o3dYFQ35/pwOzGKyJde6QVP4Cm0azNyDRCLgKWjEs8RuGGf0lZrRln/whzsBYGbp+LecIbdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776975727; c=relaxed/simple;
	bh=nSWGrJYEty3jbeuTnSM+muXNX9D6AwVa9XMWiDNqWBU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=AAHzMo6HvuGdiw1yrxlFLPNIyVWyYf+HngFE1V5Gv/CrjF2PEsvgufR+e6Xy3O32AIRqkGubk76BmMt352rlsf0jomJ9NKpzBKuUZ6eG08omNIOZwrA/UdNV2x2FzYJ7Nu71L9dAXHqaO1WL5l66Vic0NLs3QyWG+IEYzTneOKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf09.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D964C40119;
	Thu, 23 Apr 2026 20:22:04 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf09.hostedemail.com (Postfix) with ESMTPA id 83F832002A;
	Thu, 23 Apr 2026 20:22:03 +0000 (UTC)
Date: Thu, 23 Apr 2026 16:22:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Metin Kaya <metin.kaya@arm.com>
Subject: [PATCH] tracefs: Add tests for clearing kprobes with 
 tracefs_dynevent_destroy_all()
Message-ID: <20260423162207.5a888de0@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: a76kfs6rpfkhyr7t9an4hg1xo4cci7gn
X-Rspamd-Server: rspamout08
X-Rspamd-Queue-Id: 83F832002A
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/Z/ApbId4+wZ5+zHMexds9QHKc5tv/LLc=
X-HE-Tag: 1776975723-821864
X-HE-Meta: U2FsdGVkX1/PtDzMuG9wVre5hKGKdik+hoFZwjktHrirVPSF5XxoB1qc1DvSRHQ/fGF9Q9BGCJs4A3qHkiS3XXMQil+4B+dR7jOLslrrIlyejmLZFKeYQDgVIdEgW1P0oxapp4pfq0eFrglFeBVFidmk5u7Ne/brsbhMveGkMqLAJOOg7aEBlGLloa5Hrl/Kkq+kZK/OaGt9+R5D25B/n+p8b1e8FRZr8hdbN6U4xui/q9e7yDoHFj468c8jSihdLhLr4l3f5SmLUrMdMPvK4eHLpNUfB00XRBZXSNSH9gO+IRWqzx/LBf9E7xMHsGr9EKPPVlRsTCWTorbS01+4J5mm2rpyuMqoCdZR39GqBLTMjxk1H/IkJu4QoA0jS3PAGLNkehQIHFR49+a8g9PjZUSDDcoZXzqbdREHiJAl+U/ktFeBzPpng4CJ18HqPit6Zz5BA9o6lxY=

From: Steven Rostedt <rostedt@goodmis.org>

There was a regression with the use of tracefs_dynevent_destroy_all() where
it wasn't resetting kprobe events. Add testing of that function in the utest
for kprobe events.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221395
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 utest/tracefs-utest.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 353b3cbee199..7ec7b42eebb0 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -2330,6 +2330,7 @@ static void test_kprobes_instance(struct tracefs_instance *instance)
 	/* kprobes APIs */
 	destroy_dynevents(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE);
 
+	/* Allocate first */
 	for (i = 0; i < kprobe_count; i++) {
 		dkprobe[i] = tracefs_kprobe_alloc(ktests[i].system, ktests[i].event,
 						  ktests[i].address, ktests[i].format);
@@ -2348,6 +2349,7 @@ static void test_kprobes_instance(struct tracefs_instance *instance)
 	get_dynevents_check(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE, 0);
 	CU_TEST(check_probes(kretests, kretprobe_count, dkretprobe, false, instance, tep));
 
+	/* Create the kprobes */
 	for (i = 0; i < kprobe_count; i++) {
 		CU_TEST(tracefs_dynevent_create(dkprobe[i]) == 0);
 	}
@@ -2387,6 +2389,27 @@ static void test_kprobes_instance(struct tracefs_instance *instance)
 	tracefs_dynevent_list_free(devents);
 	devents = NULL;
 
+	/* Recreate both types, and destroy with tracefs_dynevent_destroy_all() */
+	for (i = 0; i < kretprobe_count; i++) {
+		CU_TEST(tracefs_dynevent_create(dkretprobe[i]) == 0);
+	}
+	for (i = 0; i < kprobe_count; i++) {
+		CU_TEST(tracefs_dynevent_create(dkprobe[i]) == 0);
+	}
+	devents = get_dynevents_check(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE,
+				    kprobe_count + kretprobe_count);
+	CU_TEST(check_probes(ktests, kprobe_count, devents, true, instance, tep));
+	CU_TEST(check_probes(kretests, kretprobe_count, dkretprobe, true, instance, tep));
+	tracefs_dynevent_list_free(devents);
+	devents = NULL;
+
+	CU_TEST(tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_ALL, true) == 0);
+
+	get_dynevents_check(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE, 0);
+	CU_TEST(check_probes(ktests, kprobe_count, dkprobe, false, instance, tep));
+	CU_TEST(check_probes(kretests, kretprobe_count, dkretprobe, false, instance, tep))
+
+	/* Free the dynamic events */
 	for (i = 0; i < kprobe_count; i++)
 		tracefs_dynevent_free(dkprobe[i]);
 	for (i = 0; i < kretprobe_count; i++)
@@ -3966,7 +3989,8 @@ void test_tracefs_lib(void)
 		fprintf(stderr, "Suite \"%s\" cannot be ceated\n", TRACEFS_SUITE);
 		return;
 	}
-
+	CU_add_test(suite, "kprobes", test_kprobes);
+	return;
 	CU_add_test(suite, "Test tracefs/debugfs mounting", test_mounting);
 	CU_add_test(suite, "trace cpu read",
 		    test_trace_cpu_read);
@@ -4032,7 +4056,6 @@ void test_tracefs_lib(void)
 		    test_custom_trace_dir);
 	CU_add_test(suite, "ftrace marker",
 		    test_ftrace_marker);
-	CU_add_test(suite, "kprobes", test_kprobes);
 	CU_add_test(suite, "synthetic events", test_synthetic);
 	CU_add_test(suite, "eprobes", test_eprobes);
 	CU_add_test(suite, "uprobes", test_uprobes);
-- 
2.53.0


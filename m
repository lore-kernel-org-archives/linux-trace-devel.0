Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A313F7869
	for <linux-trace-devel@vger.kernel.org>; Fri, 24 Apr 2026 18:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777056519; cv=none; b=pG8bNW+/eZQsKQTnczJE/UCGUhzDhePRbweyTB42kvr3SeSnwX9ygx9tPp7bcOTBXbDQUph6WLUHWTiPTUoeUS23pyat3r4jqawAQ9ALtziPrPQuhjaCd10JD+9S+4GPyNk3v+Lx+wSRDzQCttN7TPIgAT57kR+hwLXAhR79sfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777056519; c=relaxed/simple;
	bh=wFyrG06pvA8+ODAefV82du6maLbHObuttGpnCiQf8es=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=Qc2CVr5pzKFcTHTwX73zeh45b6RtTHyZQtpSf2NKtvsdhUhAaJLk+4pq6ovUzBeq1890UH2cq3i/aOTAsYsvjOgZvJJNdzg1h8Ckt7V7yViEpA3jCfeUxr1F7wEQqhrjwptY22ZPC01dfzncrwtwxgVRz8r5X64U3MH6AKTkELo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf16.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1873A1C02AF;
	Fri, 24 Apr 2026 18:48:35 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf16.hostedemail.com (Postfix) with ESMTPA id B516A2000F;
	Fri, 24 Apr 2026 18:48:33 +0000 (UTC)
Date: Fri, 24 Apr 2026 14:48:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Metin Kaya <metin.kaya@arm.com>
Subject: [PATCH v2] tracefs: Add tests for clearing kprobes with
 tracefs_dynevent_destroy_all()
Message-ID: <20260424144839.36b51d90@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mxazmkju71ozzihesaopf81wh44eaz4t
X-Rspamd-Server: rspamout08
X-Rspamd-Queue-Id: B516A2000F
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18X6VWHHZZkX57Z49nBlzJJdmyypd2ifQQ=
X-HE-Tag: 1777056513-366136
X-HE-Meta: U2FsdGVkX1+8jmy6J9Jc947Nch78gJvGVWD0xBvrJCKJAUPGhVMSfvLKaGemLVgrH+3p78SlThdCFJA9eCa+ieA9ffYXjvaXDJrjRvY9rICV9l+GnoseQiweENcooTEKe9MXz7TLrqmhLTYMtSqCIvQuQs0gctoJWppFQNhgE6LNCGcbTXMmeVX0Q0L/Y6wZRwvIRqyFl7z1Es0nhf4rdVUXI5TNk6NbaFuYJZIC1a+7XclbFxRIKb6LzMnLqN//OmfE6eKSV+5tg7ClKGd1KPrzmtzWPCd4J40+o4+fpKl6PKhnED3c+kFbh+A0FXwNViFWPtZ2Ecd+9uBuModaQXNsVBFPkwGb6QQme1C++HJcn3i16Swfm4+Hf48eYVQXBLyTYeCMIZl/oqUVisNiFvO07ls4xWlj5uoKlNttMRI+o/wAv0StrCWWddt2bIv+ejyqYv9hgkI=

From: Steven Rostedt <rostedt@goodmis.org>

There was a regression with the use of tracefs_dynevent_destroy_all() where
it wasn't resetting kprobe events. Add testing of that function in the utest
for kprobe events.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221395
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
Changes since v1: https://lore.kernel.org/20260423162207.5a888de0@gandalf.local.home

- Remove leftover debugging (had kprobe test first followed by a return).
   (Metin Kaya)

 utest/tracefs-utest.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 97a91dfcdb2c..e3ff2151796b 100644
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
-- 
2.53.0


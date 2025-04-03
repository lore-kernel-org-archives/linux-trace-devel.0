Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543042528EC
	for <linux-trace-devel@vger.kernel.org>; Thu,  3 Apr 2025 17:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743702563; cv=none; b=Yf3k2pRiuiG7Lk/m/3I4FaMJSDD0KVArdE/unPe1nGym3NQdmY8MR9uZ4sP3Sb+HbaRIlknCqfHw44tZWbQHt+nMRfMbKGd4tH7VzEes1GMOHfhMFr73aYDdUOcakrtfjtig1HKQrIZE/KQTR/DgFFO6jny83O3mmRaI9l4SPX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743702563; c=relaxed/simple;
	bh=SIixfYqXagu/ZOPSQtgsPtf9ThKj/SOD20Ttuzh/2Hw=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=AUObz1UtKxIGcvkcK68hYkyua6Kn/rECX+PSu5qmALok7jDb1p7JH06Gm/5+h2O8LU1j1p6cHew79ueTTOw/HzfVHtJlRwOzusC/WryGx+pe5AL7DCExhs43bdwVaF+xUtIQumZRi0XfQjheOZTgBacGj3XomucK1h6FP5QX7Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D77EC4CEE8
	for <linux-trace-devel@vger.kernel.org>; Thu,  3 Apr 2025 17:49:22 +0000 (UTC)
Date: Thu, 3 Apr 2025 13:50:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: utest: Do not fail if uprobes are not supported
  by kernel
Message-ID: <20250403135027.31a27ee5@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If the kernel does not support uprobes, do not fail the unit tests, but report
that the kernel does not support it.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 utest/tracefs-utest.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 8c9aab4..cc7e689 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -2206,6 +2206,7 @@ static bool check_probes(struct probe_test *probes, int count,
 {
 	enum tracefs_dynevent_type type;
 	struct tep_event *tevent;
+	bool uprobes_supported = true;
 	char *ename;
 	char *address;
 	char *event;
@@ -2240,6 +2241,15 @@ static bool check_probes(struct probe_test *probes, int count,
 			}
 			ret = tracefs_event_enable(instance, system, event);
 			if (in_system) {
+				/* ENOTSUPP is 524 */
+				if (ret && errno == 524) {
+					if (uprobes_supported)
+						printf("[KERNEL DOES NOT HAVE UPROBE EVENTS] ...");
+					uprobes_supported = false;
+					/* Count it as passed */
+					found++;
+					break;
+				}
 				CU_TEST(ret == 0);
 			} else {
 				CU_TEST(ret != 0);
-- 
2.47.2


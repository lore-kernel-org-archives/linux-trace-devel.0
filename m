Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0B745008
	for <linux-trace-devel@vger.kernel.org>; Tue, 20 Aug 2024 21:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724190290; cv=none; b=L5OW2o0xPnwRMrvyWiq3ZPuB6cjNfBtwLSuki4uPeNx51TZA+pId/e15Kz0NWk1X3liVeotztsJMKHFqRHSDHSottNPwrPpQTTIy0npPnyxPTswXnk/tp3XSvFdcCy6T4+ZuVXLrSL72W630Mu6M9OEwB0phkYHFrj4qM+QBqEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724190290; c=relaxed/simple;
	bh=i6gaVEr+68kSwV77dMSUW2d9fBXFD4iVQAP9fc5+/YE=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=iFksWYDT635J3ITfasuNrEeYao7AI93j8WYCSHlM3TkprkswDQ2THqvF6oFF2h5ZLB8EjFC2wN78mWivtAR5nkU35SqIdbggXbqkTNzjK10sgZTtw1gm942GZfEVKARWdmj4Rkzyb+mgwtSDF7viSoniuWqZVlF1aPPy8PQmVyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21C41C4AF0E
	for <linux-trace-devel@vger.kernel.org>; Tue, 20 Aug 2024 21:44:50 +0000 (UTC)
Date: Tue, 20 Aug 2024 17:45:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs utest: Do not test kprobe interface if there's
 no kprobes
Message-ID: <20240820174517.152e4404@gandalf.local.home>
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

If the kernel does not support kprobes, do not bother testing the kprobe
interface.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 utest/tracefs-utest.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index b295253..5bfd665 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -2280,6 +2280,11 @@ static void test_kprobes_instance(struct tracefs_instance *instance)
 	int ret;
 	int i;
 
+	if (!tracefs_file_exists(NULL, "kprobe_events")) {
+		printf("[KERNEL DOES NOT HAVE KPROBE EVENTS] ...");
+		return;
+	}
+
 	tep = tep_alloc();
 	CU_TEST(tep != NULL);
 
-- 
2.43.0


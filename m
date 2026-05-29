Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42671BBBFC
	for <linux-trace-devel@vger.kernel.org>; Fri, 29 May 2026 19:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780083028; cv=none; b=f/C6hiMqQ9CW5atkXVnmRgBby5oovFcs6a6+l+4tKLbGbXX0KfLzvky6IyR408bubYRR0L5fLo2uAJqvm8uS/n34GEbjjmJtPT8nPfaJlyTyZYvNls4UFOndWjqvhkbEZqlpFdQAuFclFjRY04b9TLyBwt1kIbd6F0SWDX5Smis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780083028; c=relaxed/simple;
	bh=Ynn5hMBmplQyrLNHfbL84Fs1eF9jO+zgqtvPbKEoRUg=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=g1HxWmhU7kPorHY4yClyzX/4kLWZDu61D5hZ6tjepI7IyV2oKw/fX5EvuKw5fCX04oJDRwRG1OoMNdBwbftxxYiCoRiPsWxIHy9S6Zef2A6tuQ7LMTYmEsmpib921F3F+Dpo49tYoyJ6sFNVjZXtG8PEYEivcqkYqI2KPwCB0I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 942BAA014F
	for <linux-trace-devel@vger.kernel.org>; Fri, 29 May 2026 19:30:25 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf15.hostedemail.com (Postfix) with ESMTPA id 5F0EE1A
	for <linux-trace-devel@vger.kernel.org>; Fri, 29 May 2026 19:30:24 +0000 (UTC)
Date: Fri, 29 May 2026 15:30:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs utest: Update kprobe test to use
 filename_mkdirat
Message-ID: <20260529153023.440b966c@fedora>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout07
X-Rspamd-Queue-Id: 5F0EE1A
X-Stat-Signature: a9n61oukiwwk5piy6ds9md3bsd87cjd3
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+Z4UzmrWilD87+FxK1FyTCDVUya8tYRO4=
X-HE-Tag: 1780083024-837681
X-HE-Meta: U2FsdGVkX18GTdAXRGAyn07T1n5A9fQL7GBIf3vj4zPgz+YKU1HxMpzBg9lPfLARyZFxBoSYRpTpZ5iNkCBSdM8AlBrFq6dJI2UfOYjssCmCWGeaR8/3CQBopnPb9h6r/JJHBk4V0YGijMRbFOoKTSujFZQFfrDlypQWxuoaURPCExSpfgSqJ5yawgmLNYwgIOT+GF/zG0nc7Zog/RoEebA1SoQXg7bQCeroE5o4t0kDF2LhloDrHj6xR8A3yGqr5Qyq53VNbgv0vkNmRz45L6MCZjONdqhHMiUgbjHEIm10mkn/SngP75+md/kWx1rYmGEuW0N+mUpZFwZpRHJIw+P7AZFxnqjnhytN0xaTRTmkzBkq/E+O+tyqOrS2XSQD

From: Steven Rostedt <rostedt@goodmis.org>

The function do_mkdirat was renamed to filename_mkdirat. Ideally, this would
check if the filename_mkdirat exists and if not, fallback to do_mkdirat. But
that would just add complexity to a test that should be called on the most
recent kernels anyway. If it does become an issue, we can add the
complexity and make it more robust.

Perhaps a check should be done to make sure each function exists before
testing it.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 utest/tracefs-utest.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index e3ff215..05cbc95 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -2289,7 +2289,7 @@ static bool check_probes(struct probe_test *probes, int count,
 static void test_kprobes_instance(struct tracefs_instance *instance)
 {
 	struct probe_test ktests[] = {
-		{ TRACEFS_DYNEVENT_KPROBE, "p", NULL, "mkdir", "do_mkdirat", "path=+u0($arg2):ustring" },
+		{ TRACEFS_DYNEVENT_KPROBE, "p", NULL, "mkdir", "filename_mkdirat", "path=+u0($arg2):ustring" },
 		{ TRACEFS_DYNEVENT_KPROBE, "p", NULL, "close", "close_fd", NULL },
 		{ TRACEFS_DYNEVENT_KPROBE, "p", "ptest", "open2", "do_sys_openat2",
 				  "file=+u0($arg2):ustring flags=+0($arg3):x64" },
@@ -2634,7 +2634,7 @@ static void test_multi_probes_instance(struct tracefs_instance *instance)
 					   "file=+0($filename):ustring" },
 		{ TRACEFS_DYNEVENT_EPROBE, "e", "etest", "sopen_out", "syscalls.sys_exit_openat",
 					   "res=$ret:u64" },
-		{ TRACEFS_DYNEVENT_KPROBE, "p", NULL, "mkdir", "do_mkdirat", "path=+u0($arg2):ustring" },
+		{ TRACEFS_DYNEVENT_KPROBE, "p", NULL, "mkdir", "filename_mkdirat", "path=+u0($arg2):ustring" },
 		{ TRACEFS_DYNEVENT_KPROBE, "p", NULL, "close", "close_fd", NULL },
 		{ TRACEFS_DYNEVENT_KPROBE, "p", "ptest", "open2", "do_sys_openat2",
 				  "file=+u0($arg2):ustring flags=+0($arg3):x64" },
-- 
2.51.0


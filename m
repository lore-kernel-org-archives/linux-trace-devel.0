Received: from smtp.forwardemail.net (smtp.forwardemail.net [121.127.44.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956B53E558D
	for <linux-trace-devel@vger.kernel.org>; Mon, 15 Jun 2026 13:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=121.127.44.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781528526; cv=none; b=ljli6jGtfZ1Ckz5zqtIkvw5lMVx4X4JKvPvc8OJ1j0y91zZeOjF+I3GzmdBd4/i38xGOBjc2SZFnHEWZ7xZXzAE/tD8QxQQg6xB/dWqszq9bMj971AAJFUtoglIXr8m752E7x+MvN7zNtXXwdO2TJDLeKBtUp7URqAy5u0uj8RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781528526; c=relaxed/simple;
	bh=nbLB4VP1ruaMG89GAkgzWUd2PtYVK38Zi+PKAnDkOSU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LTntd2nc8x6/84MjXZbW0VyB4iBuSsKXbyGh27iD0TVrPkTBzKsWlBivBO1ZbnUNAtn4/iF6BuM8Lxk2Y61xTCn3+wFHZrHAGSd0qjaSB6CNx68zHz9Wh3nXxrUay2x3q+m9KxoS8S0UT5CUqtpMIQ48ikOvWlsU6HeZVaH7Z5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ubuntu.com; spf=pass smtp.mailfrom=fe-bounces.ubuntu.com; dkim=pass (2048-bit key) header.d=ubuntu.com header.i=@ubuntu.com header.b=Z/4tX/rH; arc=none smtp.client-ip=121.127.44.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ubuntu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fe-bounces.ubuntu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ubuntu.com header.i=@ubuntu.com header.b="Z/4tX/rH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ubuntu.com;
 h=Content-Transfer-Encoding: MIME-Version: Message-ID: Date: Subject: Cc:
 To: From; q=dns/txt; s=fe-953a8a3ca9; t=1781528517;
 bh=U46gy1r8MTaSS8DEAhg8He3DF549oGzvTs19HEKzI4E=;
 b=Z/4tX/rHC4V0oIVVBGMowkJnlhLJzFwVBepO/iQm5yPBLEqWR8xWq/HQ1OWHB9XC1yW/rARhG
 /qGWJR+ZVU31uqlulH4Ozpi8e2yqmDXR8QOf6tG+EETFIldILWqnrK3R/LvtZxTuFVOvV1bBWd3
 mlICv328p9OHjiAerH8HO306RiZq6D3ZdcPskOA4D0MYm7HgntOAyRLSFItttvqMj+XpZG3XoLB
 K97XpmgbYs/j50y7D8olZskTSQ6ELVvy7VGJ709sTdDGdZ+FPUFgR8f4ZcAT+3wCBqICesDbq1e
 S+63RbPN6kCh2vt5glxu/g6lFbb7gUT8KTrPvaH5NsgQ==
X-Forward-Email-ID: 6a2ff7c4f986d8811e9fa399
X-Forward-Email-Sender: rfc822; enr0n@ubuntu.com, smtp.forwardemail.net,
 121.127.44.73
X-Forward-Email-Version: 2.8.26
X-Forward-Email-Website: https://forwardemail.net
X-Complaints-To: abuse@forwardemail.net
X-Report-Abuse: abuse@forwardemail.net
X-Report-Abuse-To: abuse@forwardemail.net
From: Nick Rosbrook <enr0n@ubuntu.com>
To: linux-trace-devel@vger.kernel.org
Cc: Nick Rosbrook <enr0n@ubuntu.com>
Subject: [PATCH] trace-utest: return non-zero when tests have failed
Date: Mon, 15 Jun 2026 09:01:44 -0400
Message-ID: <20260615130144.171714-1-enr0n@ubuntu.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Otherwise, the exit code cannot be used to catch test failures.

Signed-off-by: Nick Rosbrook <enr0n@ubuntu.com>
---
 utest/trace-utest.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/utest/trace-utest.c b/utest/trace-utest.c
index 6bb190ee..cef8bb25 100644
--- a/utest/trace-utest.c
+++ b/utest/trace-utest.c
@@ -37,6 +37,7 @@ int main(int argc, char **argv)
 {
 	CU_BasicRunMode verbose = CU_BRM_VERBOSE;
 	enum unit_tests tests = RUN_NONE;
+	bool tests_failed = false;
 
 	argv0 = argv[0];
 
@@ -88,6 +89,7 @@ int main(int argc, char **argv)
 
 	CU_basic_set_mode(verbose);
 	CU_basic_run_tests();
+	tests_failed = CU_get_number_of_tests_failed() != 0;
 	CU_cleanup_registry();
-	return 0;
+	return tests_failed ? -1 : 0;
 }
-- 
2.53.0


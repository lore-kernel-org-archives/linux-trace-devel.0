Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84C23EA98
	for <linux-trace-devel@vger.kernel.org>; Tue,  2 Apr 2024 08:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712047314; cv=none; b=hy43dGPHi2QxB6avrfIpIUzwvQCqOP8e2E0tHrpTKbXVd6YV+WbPEpySttxZjRzTYQcMlKxBa8kujWxETIhFsZBI5DWopqkUMZBormB4eabFvH7/q4XcVd8iGgLbNCEL2Q1ckwUUh0yGpeaCDoZgXleMUdxNNuvptJcDqbeIW5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712047314; c=relaxed/simple;
	bh=A+4VQ9Zf/U1VAtxFjtBUdn7usW8T4aroIHM60vGPhrM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=acSTSJNnchreRNUKWti3pcE8Vhfz//pHdgdXEAKGoXJJVxylSmA+NtdZeXU47gRlO2zXAHN0BBoMGgcGwdpMc1a+tDQfzm09AXElcxvC9gHnKZWnmsIf1qwBRWOvf7KpTZxUV5/WqmpEmxjJiSsqj5V+tCa+ewM+Lp4l8GCk9j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=PJV9Eb9r; arc=none smtp.client-ip=185.125.188.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="PJV9Eb9r"
Received: from t14.. (unknown [82.66.221.119])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id CA4E74095B;
	Tue,  2 Apr 2024 08:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1712047309;
	bh=X84pUkrFO3ZdnAPOAu4nAaUsBJqNWSg/CrI1SVC9TV4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version;
	b=PJV9Eb9rD2m0GyJkKAz53Sg4Y/2xnmBDk4Fa3yh56aHyuA0TGmVjpFfljsUVDBVj4
	 bo8ZGjhAkHp+uFNVDxZDnqVg/zJ99fnIg11xYzPYZmIgxtkgBaZbZQ6vU1y0VNq861
	 u9T2iakedko+Hl/VcpkxU7hBtdZbJIyX9U2x7DSl4W5ZgJsW3R2HM3eClzi2eQGsIy
	 32wKvmqCdo9OV73VQnLccfLSNiCzR7nFK1vC0fEzrLpwCNbBBmqY5KCGnLbnIafqSp
	 kNolOOB7lQPY+3c+xrXSantm1eldqRHKNvCMaMGUSzRPADive2G9sgD3JXfmitISJW
	 RL6tXabej2GIA==
From: Paul Mars <paul.mars@canonical.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
	paul.mars@canonical.com,
	Mate Kukri <mate.kukri@canonical.com>
Subject: Re: [PATCH] Fix tests running on big endian arch
Date: Tue,  2 Apr 2024 10:34:38 +0200
Message-Id: <20240402083436.285536-1-paul.mars@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240329125811.07648f7d@gandalf.local.home>
References: <20240329125811.07648f7d@gandalf.local.home>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Can you add a signed-off-by please.

Sure, see the updated patch below.

I also added the Suggested-by header as suggested, thanks!

I am not sure if I should send the full updated patch again or not, so here
it is below.


Tests running on big endian arch (tested on s390x) where failing due to:

- a typo in CPUMASK_BYTEPN.
- a missing call to tep_set_file_bigendian when initializing the test
  suite.

Suggested-by: Mate Kukri <mate.kukri@canonical.com>
Signed-off-by: Paul Mars <paul.mars@canonical.com>
---
 utest/traceevent-utest.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/utest/traceevent-utest.c b/utest/traceevent-utest.c
index 041843e..b95e478 100644
--- a/utest/traceevent-utest.c
+++ b/utest/traceevent-utest.c
@@ -216,7 +216,7 @@ DECL_CPUMASK_EVENT_DATA(bytep2, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x00, 0x01);
 #define CPUMASK_BYTEP2_FMT "cpumask=0,23"
 
 DECL_CPUMASK_EVENT_DATA(bytepn, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01);
-#define CPUMASK_BYTEPN     "ARRAY[80, 00, 00, 00, 00, 00, 80, 01]"
+#define CPUMASK_BYTEPN     "ARRAY[80, 00, 00, 00, 00, 00, 00, 01]"
 #define CPUMASK_BYTEPN_FMT "cpumask=0,63"
 #endif
 
@@ -392,6 +392,9 @@ static int test_suite_init(void)
 	test_tep = tep_alloc();
 	if (!test_tep)
 		return 1;
+#if __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
+	tep_set_file_bigendian(test_tep, TEP_BIG_ENDIAN);
+#endif
 	return 0;
 }
 
-- 
2.34.1


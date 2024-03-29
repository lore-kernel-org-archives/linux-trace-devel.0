Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC74C1C0DF1
	for <linux-trace-devel@vger.kernel.org>; Fri, 29 Mar 2024 13:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711720440; cv=none; b=uiRk/yYSdprYHgTJn69boBOVboz0L+A2GDgxUoLq7ujvrHYKihNFBlJdN7USg91Fxmtnod4X0GPJ5Bc/7Po7C0ys5vGxWG/gMOPD2uxkqt8DsO39xbNZqDSHQK3M3N3TPPEdetobTyyGc2hFpPTYWXY/QfXDmI30TDkwJQyQy0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711720440; c=relaxed/simple;
	bh=zBA9QUYxR0X5gUeLape+DOcPhadGm5qdTNJgDF60n04=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=miGxMlgZUF/1o7ttaYfI9wThHoB1VvuWvbXYtC2y+YJOfoeUphwt99qu6kgTcOQ6ZmQ5Ob1CHlsbR58mFPrL8AgFS6/0mH4xE8Ex+MOeBtXHr/htyQEE8IZi68RleTptZIQBBe2jcYow4J4h0Uk9M9YQqJAeZo3wKpzyMZQi1S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=H2qNJYAN; arc=none smtp.client-ip=185.125.188.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="H2qNJYAN"
Received: from t14.. (unknown [82.66.221.119])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 13C464001E;
	Fri, 29 Mar 2024 13:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1711720430;
	bh=YquP0tGjaXgBBdcgBP2U2Os07l9hewUUN1zx6b8Zvtg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
	b=H2qNJYANHj/9tRlJ+pc5egVMBhdPXxzISKF/iplViTMGrahNBO/Xi6RPbKxKnIauD
	 bPtblMJTyDcw/jiRfXamk8kWjVFE9V9PuTpp31EYvUboI6BCeybcYwNENpkR2hKh7+
	 UAoF2Gkgfj6jR27OukHpDhV8kKTpOkKgVjxcLUA/I1V35WsbyFjhOMr0xTLnjDTb+L
	 rS7Ed30yA3f3mI4fjKERvkxXMG8/WZJGRpJnmMI0D1cs/H7HNMe66UDAkOJHySs8Fl
	 9YhEAuYcGStJBti/m6td9Qc0UXhkvA8OHmq/StEOin2GjR8HtoqYcmp7mI957+/2re
	 JvtP2mpziAe7g==
From: Paul Mars <paul.mars@canonical.com>
To: linux-trace-devel@vger.kernel.org
Cc: Paul Mars <paul.mars@canonical.com>
Subject: [PATCH] libtraceevent: Make sure unit test binary fails when tests fail
Date: Fri, 29 Mar 2024 14:53:32 +0100
Message-Id: <20240329135331.784707-1-paul.mars@canonical.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If tests in the trace-utest binary fails, it returns 0 anyway.

So now make sure failing tests will be easily detected by returning 1.
---
 utest/trace-utest.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/utest/trace-utest.c b/utest/trace-utest.c
index a26e42e..a0a45db 100644
--- a/utest/trace-utest.c
+++ b/utest/trace-utest.c
@@ -82,6 +82,10 @@ int main(int argc, char **argv)
 
 	CU_basic_set_mode(verbose);
 	CU_basic_run_tests();
+	int failed_tests = CU_get_number_of_tests_failed();
 	CU_cleanup_registry();
+	if (failed_tests != 0){
+		return 1;
+	}
 	return 0;
 }
-- 
2.34.1


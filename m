Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8F369DF4
	for <linux-trace-devel@vger.kernel.org>; Fri, 29 Mar 2024 14:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711722409; cv=none; b=dy9orIhCyrHTzsCxqo76kpm7zgGU8XV7VaGd5rxoYORCI7TaANAOi9pE9hotg1jaaJHlwiIETb7hSJPcYstYl041M3bXKmkgoZhDuv7iOrgay6Edtk8fEotatMjjCHpd/g9o5p6YM/9ysWzMcW5h1ZumWoqAZ0LrHq1gg/dQwDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711722409; c=relaxed/simple;
	bh=tztx5YyBfw/ruNumCVfVQLfxQiWYrVFfbTvSwpkKi/k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=L1bicebpCdxOluVSUSdRr1GlfNxzS0Xe3tRSItD9f1shbOWehf0F4QISDgDsu1axcvhEcvc6hVITQBO+67nuukAHxWz3viDFXhOkMhrpwMCNa69PbSb6llp60S3PqRxziY2lFJz7AfjiM/sE9p+74gGKl2EgKSrbOzpy6+Z5krM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=lbsUWyoQ; arc=none smtp.client-ip=185.125.188.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="lbsUWyoQ"
Received: from t14.. (unknown [82.66.221.119])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 909C53F305;
	Fri, 29 Mar 2024 14:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1711722405;
	bh=vhxMmfzlejL/BJcJ55+UzHexOfTzT/2XdIXH5ELLlZ8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
	b=lbsUWyoQyhRJAf8s/0tvWm7rxTzFSNC16c1N03p5oVNoxpbWulpoDLVqrUORgPxhj
	 JNrYJ3EnWQ+5nANKbaOU5yVFJi7De0yBf3eGsMDnm5Re6FhBJ+IlFVPIrc7koJH9gy
	 0ixRd4rHHv1teQmu6IVsAcZQQv5/0KQuR1io9M24IxDojQttkCKebcTg9LFlsHpWsw
	 p6yORUJG2zNjhe5g5Px8TmYVv9mMoN/C0R7w3B46m+I3uZhVBisfBNkr77ZCJrsf85
	 9AQkhHo22luIOSItHvkFsdW2ciZ0qAMV96+v5NrI1w4WPwUuwX+tDYkdJyNSmDSN+Z
	 ts1fg1zTyLebw==
From: Paul Mars <paul.mars@canonical.com>
To: linux-trace-devel@vger.kernel.org
Cc: Paul Mars <paul.mars@canonical.com>
Subject: [PATCH] libtraceevent: Fix tests running on big endian arch
Date: Fri, 29 Mar 2024 15:25:45 +0100
Message-Id: <20240329142544.845408-1-paul.mars@canonical.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Tests running on big endian arch (tested on s390x) where failing due to:

- a typo in CPUMASK_BYTEPN.
- a missing call to tep_set_file_bigendian when initializing the test
  suite.

Thanks to Mate Kukri <mate.kukri@canonical.com>.

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


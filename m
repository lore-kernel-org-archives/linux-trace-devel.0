Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CD53DD84C
	for <linux-trace-devel@vger.kernel.org>; Fri,  5 Jun 2026 14:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780671219; cv=none; b=OGZn5IJBEnG9GgVTTqsOdo3dqBIztqGJ7m7A4i1qq90BCgxyrihS2ZHrbd3yjcdCSiYlbmsBa9esdEomAOdMPe8uabFGck64dEcJFHN+JecxK8LfRXvMLtwc36XQ5vAV8xzy+sXL07Xwm0o02JqjFqezNswSDXaD7YX6XKgdbQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780671219; c=relaxed/simple;
	bh=7fb+34avlASG1Qxzkq7A0xI7yr+KlrI8nZM/8yDSjAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZdB5eXLPBDqO3KqXxhDJo/D5AhLWxA1BkZMRs2mqQPLKdRAzmqJ5AMn8TAdVpMg45EwFeNABT+1hSHAJp5B9AWQ2K4Zb3RWKwMtE0Qx33+uCF7WgdnPb3/x2A/XXJFbBZD8aU5Kk1c2fdltY3d6Bw5cMuXwceIh0E6dxkk/QTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=posteo.de; arc=none smtp.client-ip=185.67.36.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.de
Received: from submission (posteo.de [185.67.36.169]) 
	by mout01.posteo.de (Postfix) with ESMTPS id A4BEC240027
	for <linux-trace-devel@vger.kernel.org>; Fri,  5 Jun 2026 16:53:35 +0200 (CEST)
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4gX4FC1kvTz6tsb;
	Fri,  5 Jun 2026 16:53:35 +0200 (CEST)
From: Benjamin Drung <benjamin.drung@canonical.com>
To: linux-trace-devel@vger.kernel.org
Cc: Benjamin Drung <benjamin.drung@canonical.com>
Subject: [PATCH 2/2] libtracefs: Support EXTRA_LIBS for utest
Date: Fri, 05 Jun 2026 14:53:35 +0000
Message-ID: <20260605145309.2586533-2-benjamin.drung@canonical.com>
In-Reply-To: <20260605145309.2586533-1-benjamin.drung@canonical.com>
References: <20260605145309.2586533-1-benjamin.drung@canonical.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow building the utest against the system installed libtracefs library
by tweaking the make variables:

```
make LIBTRACEFS_STATIC= EXTRA_LIBS=-ltracefs test
```

Note: This still requires making `tfs_find_debug_tracing_dir` available.
---
 utest/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/utest/Makefile b/utest/Makefile
index 9bd3dea..bcb87b6 100644
--- a/utest/Makefile
+++ b/utest/Makefile
@@ -14,7 +14,8 @@ LIBTRACEFS_STATIC ?= $(obj)/lib/libtracefs.a
 
 LIBS += -lcunit				\
 	-ldl				\
-	$(LIBTRACEFS_STATIC)
+	$(LIBTRACEFS_STATIC)		\
+	$(EXTRA_LIBS)
 
 OBJS := $(OBJS:%.o=$(bdir)/%.o)
 
-- 
2.53.0


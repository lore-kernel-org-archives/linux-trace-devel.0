Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1685183068;
	Wed, 17 Jul 2024 17:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.211.166.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721238465; cv=none; b=SSELQQs9qdvq70/dQErHahX/VSAH1Gy8fwlUU/S9BD+ypLUOiCMB+M3/Us30ixBSSA/qlVZKuFf53EZMVjrfy9u2u7c0qfRM4jS1OMeyb/XbZUvUL4zLn7PCS4Y/zL/l28cFvro2P3EDECJGKH2SGk5+jcjOpz5DZ9Pd+RUBMbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721238465; c=relaxed/simple;
	bh=6/SwzYneDqAqtHBAhM6STX6T4kayzevAfpGlR0GaVNI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WiTXsIuLiFls0iTv1k5ZmvQuxUjrnScR1c5ARvDW96ktD6/P9THap2rhuuYzSPFxTvRgAKWjSUh4GLJMTOQsCe5eRQQ0A+lLriludj9UQ37xkjq38LBISr8sPptxQRDT7ZAgF/opwOJEPPNQsyWJTEMQBSwoGYo8idwXqLdJR0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org; spf=pass smtp.mailfrom=gentoo.org; arc=none smtp.client-ip=140.211.166.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
From: Guilherme Amadio <amadio@gentoo.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ian Rogers <irogers@google.com>,
	Thorsten Leemhuis <linux@leemhuis.info>,
	Leo Yan <leo.yan@arm.com>,
	linux-perf-users@vger.kernel.org,
	linux-trace-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/5] tools/verification: Use pkg-config in lib_setup of Makefile.config
Date: Wed, 17 Jul 2024 19:47:37 +0200
Message-Id: <20240717174739.186988-4-amadio@gentoo.org>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240717174739.186988-1-amadio@gentoo.org>
References: <20240717123147.17169873@rorschach.local.home>
 <20240717174739.186988-1-amadio@gentoo.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This allows to build against libtraceevent and libtracefs installed
in non-standard locations.

Signed-off-by: Guilherme Amadio <amadio@gentoo.org>
---
 tools/verification/rv/Makefile.config | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/verification/rv/Makefile.config b/tools/verification/rv/Makefile.config
index 6d4ba77847b6..066302230eb2 100644
--- a/tools/verification/rv/Makefile.config
+++ b/tools/verification/rv/Makefile.config
@@ -7,7 +7,8 @@ LIBTRACEFS_MIN_VERSION = 1.3
 
 define lib_setup
   $(eval LIB_INCLUDES += $(shell sh -c "$(PKG_CONFIG) --cflags lib$(1)"))
-  $(eval EXTLIBS += -l$(1))
+  $(eval LDFLAGS += $(shell sh -c "$(PKG_CONFIG) --libs-only-L lib$(1)"))
+  $(eval EXTLIBS += $(shell sh -c "$(PKG_CONFIG) --libs-only-l lib$(1)"))
 endef
 
 $(call feature_check,libtraceevent)
-- 
2.39.3


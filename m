Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9BC18307E;
	Wed, 17 Jul 2024 17:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.211.166.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721238470; cv=none; b=PaCKtcfIJw7sp4a+xUPmRvAwXkENv0pxIcPQm4PDr9J00Qx6v085O0gGNOrcUiAP/TIKE7LnF6VorFRs0mF6UJBHqjT6fjEM6VxH/k0ZBC9LHMY9saxg/pVnP92pM+3V/FKA+zjPOuW1oz0xiSRVM+gDKyi9gLiwnBcz30wI8vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721238470; c=relaxed/simple;
	bh=cent/n7Mw+o9U9YiXp/nqx+p32wB8mggolpZnMWrh6U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aLKOxCG903kyIyE+zgkZw32VgURYU9kTZUV3aoO6V5/9KACn4F0ZHt57sXb5LYmgmKAB3HjqV9wFeTp+YpLm3Xdo2dMkKk12WklRPh5cl9tRli6csjxBnBSIjcGgjUrb66xs+IoqOtCn82D5Y4A919W2yuVKLFInSHVstfKemGE=
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
Subject: [PATCH v3 4/5] tools/rtla: Use pkg-config in lib_setup of Makefile.config
Date: Wed, 17 Jul 2024 19:47:38 +0200
Message-Id: <20240717174739.186988-5-amadio@gentoo.org>
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
 tools/tracing/rtla/Makefile.config | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/tracing/rtla/Makefile.config b/tools/tracing/rtla/Makefile.config
index 0b7ecfb30d19..5f8c286712d4 100644
--- a/tools/tracing/rtla/Makefile.config
+++ b/tools/tracing/rtla/Makefile.config
@@ -7,7 +7,8 @@ LIBTRACEFS_MIN_VERSION = 1.6
 
 define lib_setup
   $(eval LIB_INCLUDES += $(shell sh -c "$(PKG_CONFIG) --cflags lib$(1)"))
-  $(eval EXTLIBS += -l$(1))
+  $(eval LDFLAGS += $(shell sh -c "$(PKG_CONFIG) --libs-only-L lib$(1)"))
+  $(eval EXTLIBS += $(shell sh -c "$(PKG_CONFIG) --libs-only-l lib$(1)"))
 endef
 
 $(call feature_check,libtraceevent)
-- 
2.39.3


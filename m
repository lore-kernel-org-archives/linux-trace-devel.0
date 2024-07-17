Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D88184F;
	Wed, 17 Jul 2024 17:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.211.166.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721238455; cv=none; b=NFK2e1lwXdbP+R6crByvGWw8qbOLmHlff7oZ1nzzND17jftVykzFFRcCNAlOJTbgltybPXY+DDduW4UtBfmrEqQ8cEV3xG5Un8Mf1y8ouClsKKkv4pCo4eOBODgwVoPt1zggNfG5sHHUn6ZPQpgC4HqNOEHQO7Kwlfwq3R/3h1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721238455; c=relaxed/simple;
	bh=XKhi33Gj+rTeznBbcTvdphoSH65g3sdeypaiVMD2GmM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=r8UCiLIVZD/PHlTA77xC7ubFi6b3UaqN+grzN8+qo0A7IcHsh0xBPQrUC3UD2povh8tdgjG+7QQqNbe1huVeG7LwZVMXNNcLgt7/TOLhxdKrvUSmdGVNfl7zSbECxrXGYKk7Jv/YCFyGqBooDp/EQP9A3NSJDO3gpuxs2gO9PHE=
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
Subject: [PATCH v3 1/5] perf build: Warn if libtracefs is not found
Date: Wed, 17 Jul 2024 19:47:35 +0200
Message-Id: <20240717174739.186988-2-amadio@gentoo.org>
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

Signed-off-by: Guilherme Amadio <amadio@gentoo.org>
---
 tools/perf/Makefile.config | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
index a4829b6532d8..44f010b9f562 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -1206,6 +1206,8 @@ ifneq ($(NO_LIBTRACEEVENT),1)
     LIBTRACEFS_VERSION_3 := $(word 3, $(subst ., ,$(LIBTRACEFS_VERSION)))
     LIBTRACEFS_VERSION_CPP := $(shell expr $(LIBTRACEFS_VERSION_1) \* 255 \* 255 + $(LIBTRACEFS_VERSION_2) \* 255 + $(LIBTRACEFS_VERSION_3))
     CFLAGS += -DLIBTRACEFS_VERSION=$(LIBTRACEFS_VERSION_CPP)
+  else
+    $(warning libtracefs is missing. Please install libtracefs-dev/libtracefs-devel)
   endif
 endif
 
-- 
2.39.3


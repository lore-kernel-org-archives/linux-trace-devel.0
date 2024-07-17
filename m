Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232C4184F;
	Wed, 17 Jul 2024 17:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.211.166.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721238460; cv=none; b=jWfUxTIe2nrp/9+Sv6h38tcCUvzXjhfVdOFkq0KKH9rQuDUCW9J7jhOun4FGGFTSEcpaMm/W41oNi+uan0c3eJhaJg+j0TfiRK9A5nyU2XKtEwvY2QEb4MR8MUUNUIv5V9/i2ypIBjCS9JxJZ02OPgCeyTfwWbONA9vIKIF1e28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721238460; c=relaxed/simple;
	bh=REOSf7/rugtH2yYk+s2F5MVinrpY3CBfXRrXHiL+0CU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eFehMSHyIgi70czPizF0Tqsd2dV0USnweo6WszopPqUyD0puA0x1dRfHHeu89sIC0CSlJRZLo+0AZ+ZGpqKDV9eNjuhpqccwLy1ju0+bKFVdK0ef6MluhkM2Ge6ka0Esf0VSne3ZscZawTRY+71nzNR00Z9WuMMMaoQkZ7TZiMU=
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
Subject: [PATCH v3 2/5] tools: Make pkg-config dependency checks usable by other tools
Date: Wed, 17 Jul 2024 19:47:36 +0200
Message-Id: <20240717174739.186988-3-amadio@gentoo.org>
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

Other tools, in tools/verification and tools/tracing, make use of
libtraceevent and libtracefs as dependencies. This allows setting
up the feature check flags for them as well.

Signed-off-by: Guilherme Amadio <amadio@gentoo.org>
---
 tools/build/Makefile.feature | 18 ++++++++++++++++++
 tools/perf/Makefile.config   | 11 +++--------
 2 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/tools/build/Makefile.feature b/tools/build/Makefile.feature
index 1e2ab148d5db..e1900abd44f6 100644
--- a/tools/build/Makefile.feature
+++ b/tools/build/Makefile.feature
@@ -149,6 +149,24 @@ FEATURE_DISPLAY ?=              \
 #
 FEATURE_GROUP_MEMBERS-libbfd = libbfd-liberty libbfd-liberty-z
 
+#
+# Declare list of feature dependency packages that provide pkg-config files.
+#
+FEATURE_PKG_CONFIG ?=           \
+         libtraceevent          \
+         libtracefs
+
+feature_pkg_config = $(eval $(feature_pkg_config_code))
+define feature_pkg_config_code
+  FEATURE_CHECK_CFLAGS-$(1) := $(shell $(PKG_CONFIG) --cflags $(1) 2>/dev/null)
+  FEATURE_CHECK_LDFLAGS-$(1) := $(shell $(PKG_CONFIG) --libs $(1) 2>/dev/null)
+endef
+
+# Set FEATURE_CHECK_(C|LD)FLAGS-$(package) for packages using pkg-config.
+ifneq ($(PKG_CONFIG),)
+  $(foreach package,$(FEATURE_PKG_CONFIG),$(call feature_pkg_config,$(package)))
+endif
+
 # Set FEATURE_CHECK_(C|LD)FLAGS-all for all FEATURE_TESTS features.
 # If in the future we need per-feature checks/flags for features not
 # mentioned in this list we need to refactor this ;-).
diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
index 44f010b9f562..c896babf7a74 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -182,20 +182,15 @@ endif
 FEATURE_CHECK_CFLAGS-libzstd := $(LIBZSTD_CFLAGS)
 FEATURE_CHECK_LDFLAGS-libzstd := $(LIBZSTD_LDFLAGS)
 
+# for linking with debug library, run like:
+# make DEBUG=1 PKG_CONFIG_PATH=/opt/libtraceevent/(lib|lib64)/pkgconfig
+
 ifneq ($(NO_LIBTRACEEVENT),1)
   ifeq ($(call get-executable,$(PKG_CONFIG)),)
     $(error Error: $(PKG_CONFIG) needed by libtraceevent is missing on this system, please install it)
   endif
 endif
 
-# for linking with debug library, run like:
-# make DEBUG=1 PKG_CONFIG_PATH=/opt/libtraceevent/(lib|lib64)/pkgconfig
-FEATURE_CHECK_CFLAGS-libtraceevent := $(shell $(PKG_CONFIG) --cflags libtraceevent 2>/dev/null)
-FEATURE_CHECK_LDFLAGS-libtraceevent := $(shell $(PKG_CONFIG) --libs libtraceevent 2>/dev/null)
-
-FEATURE_CHECK_CFLAGS-libtracefs := $(shell $(PKG_CONFIG) --cflags libtracefs 2>/dev/null)
-FEATURE_CHECK_LDFLAGS-libtracefs := $(shell $(PKG_CONFIG) --libs libtracefs 2>/dev/null)
-
 FEATURE_CHECK_CFLAGS-bpf = -I. -I$(srctree)/tools/include -I$(srctree)/tools/arch/$(SRCARCH)/include/uapi -I$(srctree)/tools/include/uapi
 # include ARCH specific config
 -include $(src-perf)/arch/$(SRCARCH)/Makefile
-- 
2.39.3


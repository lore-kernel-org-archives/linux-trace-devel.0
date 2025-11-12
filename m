Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0F5339717
	for <linux-trace-devel@vger.kernel.org>; Wed, 12 Nov 2025 14:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762958964; cv=none; b=LaoWDSCsS/4XJIlLUl5dGmqC1n3WnyRtIpWjVR22mQ4ReIjw48fuc4A5n7yAQSCPd9pMpH/QKGhqj3YnTKgL/qaOQbzU+tfgIH5Ble+xka/ceDqBPHsAfxuPzDUoQ/oLYmmF4/3ZlB+5xHvh8eqm4Hh40tyuNXEXnJioG/ZPPGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762958964; c=relaxed/simple;
	bh=AaJ6Xbu01vZ8bMSEqFtpGTP2KiCJOiOs150V4x1gAK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nm6gjzo+KjLzuLYtT7mp3fPg5DlDWqr+PvzDb6SIR7/L7WNAnpicTcTH/gFontbq5JAhbcdtuZJxYFI3to+40hGfwpyunATWhin3rwm/frxBtqPpRSS17z2Cm2JfU4Wejhm+hUEEF7t8fG/sjECYfjEiZZBf9AlmZjauZWeyxbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9CA3C19422;
	Wed, 12 Nov 2025 14:49:23 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1vJCAD-000000017qi-1MPe;
	Wed, 12 Nov 2025 09:49:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Douglas Raillard <douglas.raillard@arm.com>,
	Metin Kaya <metin.kaya@arm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 2/2] libtraceevent: Have meson build rename hidden global functions
Date: Wed, 12 Nov 2025 09:45:07 -0500
Message-ID: <20251112144912.268258-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251112144912.268258-1-rostedt@goodmis.org>
References: <20251112144912.268258-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The meson build needs to perform the same operation as the normal make
build with respect to global hidden functions within the static library.

Move the redefine_local function to utils.mk and have it take a parameter
for what shared library it will read to find the global functions with.
Then separate out a target in Makefile.meson for the static library to use
this helper function to rename the non "tep_*" global functions to have a
"_tep_local_*" prefix.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Makefile.meson   | 15 +++++++++++++--
 scripts/utils.mk |  5 +++++
 src/Makefile     |  7 +------
 3 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/Makefile.meson b/Makefile.meson
index 71d6bf36c654..28c307ff6d9f 100644
--- a/Makefile.meson
+++ b/Makefile.meson
@@ -16,17 +16,28 @@ endef
 $(call allow-override,MESON,meson)
 $(call allow-override,MESON_BUILD_DIR,build)
 
+include $(src)/scripts/utils.mk
 
-all: compile
+LIBTRACEEVENT_SHARED_MESON = $(srctree)/build/src/libtraceevent.so
+LIBTRACEEVENT_STATIC_MESON = $(srctree)/build/src/libtraceevent.a
+TEMP_MESON = $(srctree)/build/src/.tmp.libtraceevent.a
+
+all: $(LIBTRACEEVENT_STATIC_MESON) $(LIBTRACEEVENT_SHARED_MESON)
 
 PHONY += compile
 compile: $(MESON_BUILD_DIR) force
 	$(MESON) compile -C $(MESON_BUILD_DIR)
 
+$(LIBTRACEEVENT_SHARED_MESON): compile
+
+$(LIBTRACEEVENT_STATIC_MESON): $(LIBTRACEEVENT_SHARED_MESON)
+	$(Q)objcopy $(call redefine_local,$(LIBTRACEEVENT_SHARED_MESON)) $(LIBTRACEEVENT_STATIC_MESON) $(TEMP_MESON)
+	mv $(TEMP_MESON) $(LIBTRACEEVENT_STATIC_MESON)
+
 $(MESON_BUILD_DIR):
 	$(MESON) setup --prefix=$(prefix) $(MESON_BUILD_DIR)
 
-install: compile
+install: $(LIBTRACEEVENT_STATIC_MESON)
 	$(MESON) install -C $(MESON_BUILD_DIR)
 
 docs: $(MESON_BUILD_DIR)
diff --git a/scripts/utils.mk b/scripts/utils.mk
index 7139088fbec2..7cd7355b811f 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -180,3 +180,8 @@ define do_install_pkgconfig_file
 		(echo Failed to locate pkg-config directory) 1>&2;		\
 	fi
 endef
+
+# Make all global functions that do not start with "tep_" have a unique name.
+redefine_local = \
+	$(shell for f in a `nm $(1) 2>/dev/null | grep ' t ' | cut -d' ' -f3 | sort -u`;  do \
+	 if [ "$${f#tep_}" = "$$f" ]; then echo --redefine-sym $$f=_tep_local_$$f; fi; done)
diff --git a/src/Makefile b/src/Makefile
index c9e8498c2d05..169bc6af1cbc 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -18,13 +18,8 @@ DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
 $(bdir)/%.o: %.c
 	$(Q)$(call do_fpic_compile)
 
-# Make all global functions that do not start with "tep_" have a unique name.
-redefine_local = \
-	$(shell for f in a `nm ${LIBTRACEEVENT_SHARED} | grep ' t ' | cut -d' ' -f3 | sort -u`;  do \
-	 if [ "$${f#tep_}" = "$$f" ]; then echo --redefine-sym $$f=_tep_local_$$f; fi; done)
-
 $(LIBTRACEEVENT_STATIC): $(bdir)/.tmp.libtraceevent.a $(LIBTRACEEVENT_SHARED)
-	$(Q)objcopy $(call redefine_local) $< $@
+	$(Q)objcopy $(call redefine_local,${LIBTRACEEVENT_SHARED}) $< $@
 
 $(bdir)/.tmp.libtraceevent.a: $(OBJS)
 	$(Q)$(call do_build_static_lib)
-- 
2.51.0


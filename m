Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABB417C4
	for <linux-trace-devel@vger.kernel.org>; Fri, 29 Dec 2023 02:51:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D796C433C8;
	Fri, 29 Dec 2023 02:51:24 +0000 (UTC)
Date: Thu, 28 Dec 2023 21:51:22 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Daniel Wagner <wagi@monom.org>
Subject: [RFC][PATCH] libtraceevent: Add meson build targets to Makefile
Message-ID: <20231228215122.48c933ba@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add make targets for building with meson:

  make meson
  make meson_install
  make meson_docs

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Makefile       | 15 ++++++++++++++-
 Makefile.meson | 40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+), 1 deletion(-)
 create mode 100644 Makefile.meson

diff --git a/Makefile b/Makefile
index 4051ef8dae84..250a69844b2b 100644
--- a/Makefile
+++ b/Makefile
@@ -352,7 +352,7 @@ install_headers:
 
 install: install_libs
 
-clean: clean_plugins clean_src
+clean: clean_plugins clean_src clean_meson
 	$(Q)$(call do_clean,\
 	    $(VERSION_FILE) $(obj)/tags $(obj)/TAGS $(PKG_CONFIG_FILE) \
 	    $(LIBTRACEEVENT_STATIC) $(LIBTRACEEVENT_SHARED) \
@@ -436,6 +436,19 @@ PHONY += clean_src
 clean_src:
 	$(Q)$(call descend_clean,src)
 
+meson:
+	$(MAKE) -f Makefile.meson
+
+meson_install:
+	$(MAKE) -f Makefile.meson install
+
+meson_docs:
+	$(MAKE) -f Makefile.meson docs
+
+PHONY += clean_meson
+clean_meson:
+	$(Q)$(MAKE) -f Makefile.meson $@
+
 force:
 
 # Declare the contents of the .PHONY variable as phony.  We keep that
diff --git a/Makefile.meson b/Makefile.meson
new file mode 100644
index 000000000000..9e94c28b98b9
--- /dev/null
+++ b/Makefile.meson
@@ -0,0 +1,40 @@
+# SPDX-License-Identifier: GPL-2.0
+
+undefine CFLAGS
+
+# Makefiles suck: This macro sets a default value of $(2) for the
+# variable named by $(1), unless the variable has been set by
+# environment or command line. This is necessary for CC and AR
+# because make sets default values, so the simpler ?= approach
+# won't work as expected.
+define allow-override
+  $(if $(or $(findstring environment,$(origin $(1))),\
+            $(findstring command line,$(origin $(1)))),,\
+    $(eval $(1) = $(2)))
+endef
+
+$(call allow-override,MESON,meson)
+$(call allow-override,MESON_BUILD_DIR,build)
+
+
+all: compile
+
+PHONY += compile
+compile: $(MESON_BUILD_DIR) force
+	$(MESON) compile -C $(MESON_BUILD_DIR)
+
+$(MESON_BUILD_DIR):
+	$(MESON) --prefix=$(prefix) $(MESON_BUILD_DIR)
+
+install: compile
+	$(MESON) install -C $(MESON_BUILD_DIR)
+
+docs: $(MESON_BUILD_DIR)
+	$(MESON) compile -C build docs
+
+PHONY += clean_meson
+clean_meson:
+	$(Q)$(RM) -rf $(MESON_BUILD_DIR)
+
+PHONY += force
+force:
-- 
2.42.0


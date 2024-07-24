Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5678115B10D
	for <linux-trace-devel@vger.kernel.org>; Wed, 24 Jul 2024 17:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721843250; cv=none; b=BGgcWibr4iEvhXJui33QClVmQ8v10qsiZDag9yJWAeMKJ1BEC6cGs+Anw7sk/xRo3LQ8sKfv52laHPK+MeL1awfa9O5OX6BBKKuuZC0K49unAzc5S2BBputsIrurZkuNiyVgLgAZqtgRoJBXVvzL8r4XyLHDmCEA6pR31PRqbvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721843250; c=relaxed/simple;
	bh=6u6TkXkDLYADRbkx2CoweX8miCf0PXvMMeqTtwu5e78=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=j1tVoNSn4zD3jp52oTQdINj/vRtwFcYVA2m5JlZMhNQWGU8qMVBtMKZy0w1nV+iBb/n9YhVTSos25fkKHPszl+NnoupWdJVU6JcTC5/QM8Vm51o/dM00ui1U4u6HRWo0qWlgaGWwgll/S4A3HoCUssL5flB1QjA7SIu/Du8p9fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E83C32781;
	Wed, 24 Jul 2024 17:47:29 +0000 (UTC)
Date: Wed, 24 Jul 2024 13:47:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Daniel Wagner <wagi@monom.org>
Subject: [PATCH] libtracefs: Add meson build targets to Makefile
Message-ID: <20240724134748.52c18018@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
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
index 7f4f5c3f752c..b0553c341c93 100644
--- a/Makefile
+++ b/Makefile
@@ -400,7 +400,7 @@ sqlhist: samples/sqlhist
 samples: libtracefs.a force
 	$(Q)$(call descend,$(src)/samples,all)
 
-clean:
+clean: clean_meson
 	$(Q)$(call descend_clean,utest)
 	$(Q)$(call descend_clean,src)
 	$(Q)$(call descend_clean,samples)
@@ -410,6 +410,19 @@ clean:
 	  $(VERSION_FILE) \
 	  $(BUILD_PREFIX))
 
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
 .PHONY: clean
 
 # libtracefs.a and libtracefs.so would concurrently enter the same directory -
diff --git a/Makefile.meson b/Makefile.meson
new file mode 100644
index 000000000000..71d6bf36c654
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
+	$(MESON) setup --prefix=$(prefix) $(MESON_BUILD_DIR)
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
2.43.0


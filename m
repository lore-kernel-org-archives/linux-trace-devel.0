Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406EA200B7
	for <linux-trace-devel@vger.kernel.org>; Wed, 24 Jul 2024 17:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721841975; cv=none; b=Dz7noePEh7mq94czs/Sdrz/o3ksnTYvu6uQh/TC/gHLpYEKVok8CZQIkZm+zpCg1tMk4eAGk9ywLQaOFC42Qjj2HevakdVLYM3ZmUkOa62hxmtfHYcqVGmvukwLlOTY6GhQzJ605w5r32PttOYHRxVhUXjx4+B5U+f0+XX+Mfr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721841975; c=relaxed/simple;
	bh=Y4RA6rthxLwQAG2Omq6fIsQzXYwiEHLBYWRZ8isGbBo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=GB7YVn+4YZ6Ty8eSYu87oLhZvqDHHeW37PBOIH7/K1jVx+76sj0U++QXR+cJIal5P2zQQSOx13qCfBnbHlmXRdvqU/ZBlRLGmzV8FUJIpjqnRfEeZRmxfpezPpJZfQskP9eRP/Rbx4oR38JhAM/pffUZpfbdumivMKmqWStvbug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72509C32781;
	Wed, 24 Jul 2024 17:26:14 +0000 (UTC)
Date: Wed, 24 Jul 2024 13:26:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Daniel Wagner <wagi@monom.org>
Subject: [PATCH v2] libtraceevent: Add meson build targets to Makefile
Message-ID: <20240724132632.33d49bc2@gandalf.local.home>
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
Changes since v1: https://lore.kernel.org/all/20231228215122.48c933ba@rorschach.local.home/

- use "meson setup [options]" instead of deprecated "meson [options]"

 Makefile       | 15 ++++++++++++++-
 Makefile.meson | 40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+), 1 deletion(-)
 create mode 100644 Makefile.meson

diff --git a/Makefile b/Makefile
index 0ff8e9c3d981..fbb4422e4b3b 100644
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


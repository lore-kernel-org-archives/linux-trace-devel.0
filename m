Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B36A4C62A
	for <linux-trace-devel@vger.kernel.org>; Wed, 24 Jul 2024 19:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721850327; cv=none; b=QT1sK9tFWbSI9kiy1T+GGwUV/CsauFDg0X8PBTh9TSc6dGvv9dv/Af7S4WCk8u4oaLOOTarBWbbTxbULm8mIFWL2BflS+9CspsSP2+1HlIpCDsWnnRQnBKLzDcGkL6OLiw4JYTtlmmfPgZzGYBYzUOpx3ECyfC8b3PxNMehO+tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721850327; c=relaxed/simple;
	bh=RGMuvHJD5IuJiqh+nQhvvXUQqjzzrT8quoKs8CDBGrk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=b8SUSCVH4oicy+RzFCD9x1HtZl7ObbAWLSB1CkQtP3iefPTEEoArYs7d7UZR6tQlij/iTiTnqEZFajX1+YkXOiefgs5baJkaN38YmPZhpcQFE+6o8ZURzR9pnFG+0ZJhjb4t6/G2vWaiyKDUaFdgrS5/m6PP+xYlR2h0asCxyM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 732C0C32781;
	Wed, 24 Jul 2024 19:45:26 +0000 (UTC)
Date: Wed, 24 Jul 2024 15:45:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Daniel Wagner <wagi@monom.org>
Subject: [PATCH] trace-cmd: Add meson build targets to Makefile
Message-ID: <20240724154545.7a536a44@gandalf.local.home>
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
 Makefile       | 14 +++++++++++++-
 Makefile.meson | 40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+), 1 deletion(-)
 create mode 100644 Makefile.meson

diff --git a/Makefile b/Makefile
index 6a30eaf0a330..897c972ff9b7 100644
--- a/Makefile
+++ b/Makefile
@@ -527,7 +527,7 @@ install_doc:
 check_doc: force
 	$(Q)$(src)/check-manpages.sh $(src)/Documentation/libtracecmd
 
-clean:
+clean: clean_meson
 	$(RM) *.o *~ *.a *.so .*.d
 	$(RM) tags TAGS cscope* $(PKG_CONFIG_SOURCE_FILE) $(VERSION_FILE)
 	$(MAKE) -C $(src)/lib/trace-cmd clean
@@ -598,6 +598,18 @@ ctracecmd.so: force $(LIBTRACECMD_STATIC)
 PHONY += python
 python: $(PYTHON)
 
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
 
 dist:
 	git archive --format=tar --prefix=trace-cmd-$(TRACECMD_VERSION)/ HEAD \
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


Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7017CC2BBCA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 04:43:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4844E2313B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 04:43:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725788AbgLPEnT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:43:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:48932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725771AbgLPEnS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Dec 2020 23:43:18 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D865C2313B
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Dec 2020 04:42:14 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kpOdh-000qzn-SV
        for linux-trace-devel@vger.kernel.org; Tue, 15 Dec 2020 23:42:13 -0500
Message-ID: <20201216044213.730082526@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 15 Dec 2020 23:41:55 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 05/12] libtracecmd: Update ld.so.conf.d/trace.conf if needed
References: <20201216044150.375001748@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

If DESTDIR is not defined (building for the current machine) check if after
installing libtracecmd, if it is in the ld.so path by building a test
program and running it, and making sure that the dynamic linker works, and
if not, then update /etc/ld.so.conf.d/trace.conf to include the path to
libtracecmd.so.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile               |  6 +++++-
 lib/trace-cmd/Makefile | 26 ++++++++++++++++++++++++++
 lib/trace-cmd/test.c   |  7 +++++++
 3 files changed, 38 insertions(+), 1 deletion(-)
 create mode 100644 lib/trace-cmd/test.c

diff --git a/Makefile b/Makefile
index e956a2e6e8b6..101820733862 100644
--- a/Makefile
+++ b/Makefile
@@ -37,6 +37,10 @@ endef
 $(call allow-override,CC,$(CROSS_COMPILE)gcc)
 $(call allow-override,AR,$(CROSS_COMPILE)ar)
 $(call allow-override,PKG_CONFIG,pkg-config)
+$(call allow-override,LD_SO_CONF_PATH,/etc/ld.so.conf.d/)
+$(call allow-override,LDCONFIG,ldconfig)
+
+export LD_SO_CONF_PATH LDCONFIG
 
 EXT = -std=gnu99
 INSTALL = install
@@ -76,7 +80,7 @@ etcdir ?= /etc
 etcdir_SQ = '$(subst ','\'',$(etcdir))'
 
 export man_dir man_dir_SQ html_install html_install_SQ INSTALL
-export img_install img_install_SQ libdir_SQ includedir_SQ
+export img_install img_install_SQ libdir libdir_SQ includedir_SQ
 export DESTDIR DESTDIR_SQ
 
 ifeq ($(prefix),$(HOME))
diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index 75e4fea4e3e0..a26b989a2c82 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -3,6 +3,7 @@
 include $(src)/scripts/utils.mk
 
 bdir:=$(obj)/lib/trace-cmd
+ldir:=$(src)/lib/trace-cmd
 
 DEFAULT_TARGET = $(LIBTRACECMD_STATIC)
 
@@ -59,11 +60,36 @@ $(DEPS): $(bdir)/.%.d: %.c
 
 $(OBJS): $(bdir)/%.o : $(bdir)/.%.d
 
+ifeq ("$(DESTDIR)", "")
+# If DESTDIR is not defined, then test if after installing the library
+# and running ldconfig, if the library is visible by ld.so.
+# If not, add the path to /etc/ld.so.conf.d/trace.conf and run ldconfig again.
+define install_ld_config
+	$(LDCONFIG); \
+	if ! grep "^$(libdir)$$" $(LD_SO_CONF_PATH)/* &> /dev/null ; then \
+		$(CC) -o $(bdir)/test $(ldir)/test.c -I $(includedir_SQ) \
+			-L $(libdir_SQ) -ltracecmd > /dev/null; \
+		if ! $(bdir)/test &> /dev/null; then \
+			$(call print_install,trace.conf,$(LD_SO_CONF_PATH)) \
+			echo $(libdir_SQ) >> $(LD_SO_CONF_PATH)/trace.conf; \
+			$(LDCONFIG); \
+		fi; \
+		$(RM) $(bdir)/test; \
+	fi
+endef
+else
+# If installing to a location for another machine or package, do not bother
+# with running ldconfig.
+define install_ld_config
+endef
+endif # DESTDIR = ""
+
 install_libs:
 	$(Q)$(call do_install,$(LIBTRACECMD_SHARED),$(libdir_SQ))
 	cp -fpR $(LIBTRACECMD_SHARED_VERSION) $(DESTDIR)$(libdir_SQ)
 	cp -fpR $(LIBTRACECMD_SHARED_SO) $(DESTDIR)$(libdir_SQ)
 	$(Q)$(call do_install,$(src)/include/trace-cmd/trace-cmd.h,$(includedir_SQ)/trace-cmd)
+	$(Q)$(call install_ld_config)
 
 dep_includes := $(wildcard $(DEPS))
 
diff --git a/lib/trace-cmd/test.c b/lib/trace-cmd/test.c
new file mode 100644
index 000000000000..5622d79c86c5
--- /dev/null
+++ b/lib/trace-cmd/test.c
@@ -0,0 +1,7 @@
+#include <trace-cmd/trace-cmd.h>
+
+int main()
+{
+	tracecmd_open_head("trace.dat");
+	return 0;
+}
-- 
2.29.2



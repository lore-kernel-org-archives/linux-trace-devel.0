Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 554CCC4361B
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Dec 2020 21:27:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 113602076D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Dec 2020 21:27:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503444AbgLNV1s (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Dec 2020 16:27:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:43772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503589AbgLNV1s (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Dec 2020 16:27:48 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C435820732
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Dec 2020 21:27:07 +0000 (UTC)
Date:   Mon, 14 Dec 2020 16:27:06 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Add trace.conf for ld.so if needed
Message-ID: <20201214162559.685f65ba@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

It cannot be guaranteed that the system the library is being installed on
has ld.so set to search the location of where libtracefs.so is installed.

During the install process, check if the path is found in ld.so.conf.d/ and
if not, test if an executable can be built and find the library. If it can
not, then add the path to ld.so.conf.d/trace.conf, and run ldconfig again.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile | 26 ++++++++++++++++++++++++++
 test.c   |  7 +++++++
 2 files changed, 33 insertions(+)
 create mode 100644 test.c

diff --git a/Makefile b/Makefile
index b4d0a72..5a3cd04 100644
--- a/Makefile
+++ b/Makefile
@@ -28,6 +28,8 @@ endef
 $(call allow-override,CC,$(CROSS_COMPILE)gcc)
 $(call allow-override,AR,$(CROSS_COMPILE)ar)
 $(call allow-override,PKG_CONFIG,pkg-config)
+$(call allow-override,LD_SO_CONF_PATH,/etc/ld.so.conf.d/)
+$(call allow-override,LDCONFIG,ldconfig)
 
 EXT = -std=gnu99
 INSTALL = install
@@ -235,11 +237,35 @@ cscope: force
 	$(RM) cscope*
 	$(call find_tag_files) | cscope -b -q
 
+ifeq ("$(DESTDIR)", "")
+# If DESTDIR is not defined, then test if after installing the library
+# and running ldconfig, if the library is visible by ld.so.
+# If not, add the path to /etc/ld.so.conf.d/trace.conf and run ldconfig again.
+define install_ld_config
+	$(LDCONFIG); \
+	if ! grep "^$(libdir)$$" $(LD_SO_CONF_PATH)/* &> /dev/null ; then \
+		$(CC) -o $(OUTPUT)test $(srctree)/test.c -I $(includedir_SQ) \
+			-L $(libdir_SQ) -ltracefs; \
+		if ! $(OUTPUT)test > /dev/null; then \
+			echo $(libdir_SQ) >> $(LD_SO_CONF_PATH)/trace.conf; \
+			$(LDCONFIG); \
+		fi; \
+		echo $(RM) $(OUTPUT)test; \
+	fi
+endef
+else
+# If installing to a location for another machine or package, do not bother
+# with running ldconfig.
+define install_ld_config
+endef
+endif # DESTDIR = ""
+
 install_libs: libs install_pkgconfig
 	$(Q)$(call do_install,$(LIBTRACEFS_SHARED),$(libdir_SQ)); \
 		cp -fpR $(LIB_INSTALL) $(DESTDIR)$(libdir_SQ)
 	$(Q)$(call do_install,$(src)/include/tracefs.h,$(includedir_SQ))
 	$(Q)$(call do_install_ld,$(TRACE_LD_FILE),$(LD_SO_CONF_DIR),$(libdir_SQ))
+	$(Q)$(call install_ld_config)
 
 install: install_libs
 
diff --git a/test.c b/test.c
new file mode 100644
index 0000000..daf99d6
--- /dev/null
+++ b/test.c
@@ -0,0 +1,7 @@
+#include <tracefs.h>
+
+int main()
+{
+	tracefs_get_tracing_dir();
+	return 0;
+}
-- 
2.25.4


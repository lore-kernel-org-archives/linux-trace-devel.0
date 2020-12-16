Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7162CC3526A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 04:43:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3095323159
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 04:43:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725804AbgLPEnf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:43:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:49144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbgLPEnf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Dec 2020 23:43:35 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7E4B2332A
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Dec 2020 04:42:15 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kpOdi-000r1j-L1
        for linux-trace-devel@vger.kernel.org; Tue, 15 Dec 2020 23:42:14 -0500
Message-ID: <20201216044214.498297897@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 15 Dec 2020 23:41:59 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 09/12] libtracecmd: Install libtracecmd.pc when installing libs
References: <20201216044150.375001748@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Instead of installing libtracecmd.pc when doing the install of the
executable, install it durin "make install_libs". Also do some clean ups
around the building and installin gof libtracecmd.pc.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile               | 8 +++-----
 lib/trace-cmd/Makefile | 5 ++++-
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/Makefile b/Makefile
index 038276b67464..c1192da4f049 100644
--- a/Makefile
+++ b/Makefile
@@ -207,6 +207,8 @@ obj		:= $(objtree)
 PKG_CONFIG_SOURCE_FILE = libtracecmd.pc
 PKG_CONFIG_FILE := $(addprefix $(BUILD_OUTPUT)/,$(PKG_CONFIG_SOURCE_FILE))
 
+export pkgconfig_dir PKG_CONFIG_FILE
+
 kshark-dir	= $(src)/kernel-shark
 
 export prefix bindir src obj kshark-dir
@@ -439,7 +441,7 @@ install_python: force
 install_bash_completion: force
 	$(Q)$(call do_install_data,$(src)/tracecmd/trace-cmd.bash,$(BASH_COMPLETE_DIR))
 
-install_cmd: all_cmd install_plugins install_python install_bash_completion install_pkgconfig
+install_cmd: all_cmd install_plugins install_python install_bash_completion
 	$(Q)$(call do_install,$(obj)/tracecmd/trace-cmd,$(bindir_SQ))
 
 install: install_cmd
@@ -468,10 +470,6 @@ install_doc:
 install_doc_gui:
 	$(MAKE) -C $(kshark-dir)/Documentation install
 
-install_pkgconfig: $(PKG_CONFIG_FILE)
-	$(Q)$(call , $(PKG_CONFIG_FILE)) \
-		$(call do_install_pkgconfig_file,$(prefix))
-
 clean:
 	$(RM) *.o *~ *.a *.so .*.d
 	$(RM) tags TAGS cscope* $(PKG_CONFIG_SOURCE_FILE)
diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index 3b8087f66db5..ec6ab29923db 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -84,7 +84,10 @@ define install_ld_config
 endef
 endif # DESTDIR = ""
 
-install_libs:
+install_pkgconfig: $(PKG_CONFIG_FILE)
+	$(Q)$(call do_install_pkgconfig_file,$(prefix))
+
+install_libs: install_pkgconfig
 	$(Q)$(call do_install,$(LIBTRACECMD_SHARED),$(libdir_SQ))
 	$(Q)$(call print_install,$(LIBTRACECMD_SHARED_VERSION),$(DESTDIR)$(libdir_SQ))
 	$(Q)cp -fpR $(LIBTRACECMD_SHARED_VERSION) $(DESTDIR)$(libdir_SQ)
-- 
2.29.2



Return-Path: <SRS0=9Wso=3L=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9422C3F68F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jan 2020 17:13:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FA012465B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jan 2020 17:13:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbgAVRNb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 22 Jan 2020 12:13:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:49364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726004AbgAVRNb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 22 Jan 2020 12:13:31 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F4202465B;
        Wed, 22 Jan 2020 17:13:30 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1iuJZJ-000hqM-Ef; Wed, 22 Jan 2020 12:13:29 -0500
Message-Id: <20200122171329.340613663@goodmis.org>
User-Agent: quilt/0.65
Date:   Wed, 22 Jan 2020 12:12:53 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 3/5] trace-cmd: Add installation of ld.conf.d file for library paths
References: <20200122171250.252248737@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

As just installing the shared libraries is not enough to have them accessed
by the applications, ldconfig needs to also be run. To find the location of
the libraries, their paths need to be added to ld.conf.d directory
configuration file.

Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile         | 4 ++++
 scripts/utils.mk | 8 ++++++++
 2 files changed, 12 insertions(+)

diff --git a/Makefile b/Makefile
index efd9ed4b296e..c22aa7847b51 100644
--- a/Makefile
+++ b/Makefile
@@ -88,6 +88,8 @@ HELP_DIR_SQ = '$(subst ','\'',$(HELP_DIR))'
 #' emacs highlighting gets confused by the above escaped quote.
 
 BASH_COMPLETE_DIR ?= /etc/bash_completion.d
+LD_SO_CONF_DIR ?= /etc/ld.so.conf.d
+TRACE_LD_FILE ?= trace.conf
 
 export PLUGIN_DIR_TRACEEVENT
 export PLUGIN_DIR_TRACECMD
@@ -380,6 +382,8 @@ install_libs: libs
 	$(Q)$(call do_install,$(src)/include/traceevent/trace-seq.h,$(includedir_SQ)/traceevent)
 	$(Q)$(call do_install,$(src)/include/trace-cmd/trace-cmd.h,$(includedir_SQ)/trace-cmd)
 	$(Q)$(call do_install,$(src)/include/trace-cmd/trace-filter-hash.h,$(includedir_SQ)/trace-cmd)
+	$(Q)$(call do_install_ld,$(TRACE_LD_FILE),$(LD_SO_CONF_DIR),$(libdir_SQ)/trace-cmd)
+	$(Q)$(call do_install_ld,$(TRACE_LD_FILE),$(LD_SO_CONF_DIR),$(libdir_SQ)/traceevent)
 
 doc:
 	$(MAKE) -C $(src)/Documentation all
diff --git a/scripts/utils.mk b/scripts/utils.mk
index d1d5135063fc..4da8829159a0 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -133,3 +133,11 @@ define do_install_data
 	fi;						\
 	$(INSTALL) -m 644 $1 '$(DESTDIR_SQ)$2'
 endef
+
+define do_install_ld
+	$(print_install)				\
+	if [ -d '$(DESTDIR_SQ)$2' ]; then		\
+		echo '$3' >> $(DESTDIR_SQ)$2/$1;	\
+		ldconfig;				\
+	fi
+endef
-- 
2.24.1



Return-Path: <SRS0=9Wso=3L=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38C75C47409
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jan 2020 17:13:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 106A22467E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jan 2020 17:13:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725802AbgAVRNb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 22 Jan 2020 12:13:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:49376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726005AbgAVRNb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 22 Jan 2020 12:13:31 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A640924673
        for <linux-trace-devel@vger.kernel.org>; Wed, 22 Jan 2020 17:13:30 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1iuJZJ-000hqq-JE
        for linux-trace-devel@vger.kernel.org; Wed, 22 Jan 2020 12:13:29 -0500
Message-Id: <20200122171329.476181697@goodmis.org>
User-Agent: quilt/0.65
Date:   Wed, 22 Jan 2020 12:12:54 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 4/5] trace-cmd: Have libtracecmd.so include libtraceevent
References: <20200122171250.252248737@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Was getting errors with loading libtracecmd.so with undefined symbols
from libtraceevent. Add it to the build process to include what it uses
as well.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile               |  2 +-
 lib/trace-cmd/Makefile |  2 ++
 scripts/utils.mk       | 12 +++++++-----
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/Makefile b/Makefile
index c22aa7847b51..9c74268eddd5 100644
--- a/Makefile
+++ b/Makefile
@@ -301,7 +301,7 @@ $(LIBTRACEEVENT_STATIC): force $(obj)/lib/traceevent/plugins/trace_python_dir \
 $(LIBTRACECMD_STATIC): force
 	$(Q)$(MAKE) -C $(src)/lib/trace-cmd $@
 
-$(LIBTRACECMD_SHARED): force
+$(LIBTRACECMD_SHARED): force $(LIBTRACEEVENT_SHARED)
 	$(Q)$(MAKE) -C $(src)/lib/trace-cmd $@
 
 libtraceevent.so: $(LIBTRACEEVENT_SHARED)
diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index 6f3e6b1bf935..29c36ca195d0 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -35,6 +35,8 @@ $(DEPS): | $(bdir)
 $(bdir)/libtracecmd.a: $(OBJS)
 	$(Q)$(call do_build_static_lib)
 
+LIBS = -L$(obj)/lib/traceevent -ltraceevent
+
 $(bdir)/libtracecmd.so: $(OBJS)
 	$(Q)$(call do_compile_shared_library)
 
diff --git a/scripts/utils.mk b/scripts/utils.mk
index 4da8829159a0..28dcd7b44061 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -61,7 +61,7 @@ do_build_static_lib =				\
 
 do_compile_shared_library =			\
 	($(print_shared_lib_compile)		\
-	$(CC) --shared $^ -Wl,-soname,$(@F) -o $@)
+	$(CC) --shared $^ $(LIBS) -Wl,-soname,$(@F) -o $@)
 
 do_compile_plugin_obj =				\
 	($(print_plugin_obj_compile)		\
@@ -135,9 +135,11 @@ define do_install_data
 endef
 
 define do_install_ld
-	$(print_install)				\
-	if [ -d '$(DESTDIR_SQ)$2' ]; then		\
-		echo '$3' >> $(DESTDIR_SQ)$2/$1;	\
-		ldconfig;				\
+	$(print_install)						\
+	if [ -d '$(DESTDIR_SQ)$2' ]; then				\
+		if ! grep -q $3 $(DESTDIR_SQ)$2/$1 2>/dev/null; then	\
+			echo '$3' >> $(DESTDIR_SQ)$2/$1;		\
+			ldconfig;					\
+		fi							\
 	fi
 endef
-- 
2.24.1



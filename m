Return-Path: <SRS0=TfJx=VR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD694C76197
	for <linux-trace-devel@archiver.kernel.org>; Sat, 20 Jul 2019 03:03:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 961562082F
	for <linux-trace-devel@archiver.kernel.org>; Sat, 20 Jul 2019 03:03:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390431AbfGTDD5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Jul 2019 23:03:57 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39664 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728058AbfGTDD5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Jul 2019 23:03:57 -0400
Received: from chiana.gaikai.org (unknown [100.42.98.196])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: chutzpah)
        by smtp.gentoo.org (Postfix) with ESMTPSA id 81B6F34812A
        for <linux-trace-devel@vger.kernel.org>; Sat, 20 Jul 2019 03:03:56 +0000 (UTC)
From:   Patrick McLean <chutzpah@gentoo.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/4] trace-cmd: Install all headers needed by kernelshark to proper paths
Date:   Fri, 19 Jul 2019 20:03:43 -0700
Message-Id: <20190720030344.1991393-4-chutzpah@gentoo.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190720030344.1991393-1-chutzpah@gentoo.org>
References: <20190720030344.1991393-1-chutzpah@gentoo.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Patrick McLean <patrick.mclean@sony.com>

The trace-cmd build system installs headers for building kernelshark,
but it is missing trace-seq.h and trace-filter-hash.h.

It additionally installs event-parse.h to the toplevel "trace-cmd"
include directory, but the generated header includes it as
"traceevent/event-parse.h" so the kernelshark build fails.

This patch installs all the headers needed to build kernelshark to the
appropiate directories.

Signed-off-by: Patrick McLean <patrick.mclean@sony.com>
---
 Makefile | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 6b85e21..3bab851 100644
--- a/Makefile
+++ b/Makefile
@@ -345,8 +345,10 @@ install_gui: install_cmd gui
 install_libs: libs
 	$(Q)$(call do_install,$(LIBTRACECMD_SHARED),$(libdir_SQ))
 	$(Q)$(call do_install,$(LIBTRACEEVENT_SHARED),$(libdir_SQ))
-	$(Q)$(call do_install,$(src)/include/traceevent/event-parse.h,$(includedir_SQ))
+	$(Q)$(call do_install,$(src)/include/traceevent/event-parse.h,$(includedir_SQ)/traceevent)
+	$(Q)$(call do_install,$(src)/include/traceevent/trace-seq.h,$(includedir_SQ)/traceevent)
 	$(Q)$(call do_install,$(src)/include/trace-cmd/trace-cmd.h,$(includedir_SQ))
+	$(Q)$(call do_install,$(src)/include/trace-cmd/trace-filter-hash.h,$(includedir_SQ))
 
 doc:
 	$(MAKE) -C $(src)/Documentation all
-- 
2.22.0


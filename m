Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB532C4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Dec 2021 05:50:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233102AbhLQFuz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Dec 2021 00:50:55 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60350 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233092AbhLQFux (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Dec 2021 00:50:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0344AB82736
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Dec 2021 05:50:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD4CC36AEC;
        Fri, 17 Dec 2021 05:50:49 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1my68h-00057E-KH;
        Fri, 17 Dec 2021 00:50:43 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v2 15/15] libtracefs: Remove build_prefix file on make clean
Date:   Fri, 17 Dec 2021 00:50:41 -0500
Message-Id: <20211217055041.19559-16-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211217055041.19559-1-rostedt@goodmis.org>
References: <20211217055041.19559-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The files "build_prefix" is used to help know if the libtracefs.pc file
needs to be updated or not. If a remote directory is used, it is built in
that directory. It should also be cleaned if a make clean is done on that
directory as well. Currently deleting that file is missing from the make
clean.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index cd7cf28a2acd..544684c1c37c 100644
--- a/Makefile
+++ b/Makefile
@@ -381,6 +381,7 @@ clean:
 	$(Q)$(call do_clean, \
 	  $(TARGETS) $(bdir)/*.a $(bdir)/*.so $(bdir)/*.so.* $(bdir)/*.o $(bdir)/.*.d \
 	  $(PKG_CONFIG_FILE) \
-	  $(VERSION_FILE))
+	  $(VERSION_FILE) \
+	  $(BUILD_PREFIX))
 
 .PHONY: clean
-- 
2.33.0


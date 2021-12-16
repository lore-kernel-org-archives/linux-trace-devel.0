Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95406C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Dec 2021 21:40:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241241AbhLPVkA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Dec 2021 16:40:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241042AbhLPVj7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Dec 2021 16:39:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A24C06173E
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Dec 2021 13:39:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6575461F9B
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Dec 2021 21:39:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA23C36AEA;
        Thu, 16 Dec 2021 21:39:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mxyTl-0003dH-PA;
        Thu, 16 Dec 2021 16:39:57 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 01/10] libtraceevent: Fix installing of man pages in remote directory
Date:   Thu, 16 Dec 2021 16:39:47 -0500
Message-Id: <20211216213956.13934-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211216213956.13934-1-rostedt@goodmis.org>
References: <20211216213956.13934-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

When the building of the man pages is done in a directory other than the
repo directory (with the O= option), the intermediate build file name
incorrectly appends a "install-" prefix to the path and not to the file,
causing the installation to fail.

Fix it by using patsubst instead of addprefix to append the "install-"
name to the intermediate files for the installation.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/Makefile b/Documentation/Makefile
index 73dbe2ae4d43..af124572c863 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -154,12 +154,12 @@ ifdef missing_tools
 	$(error "You need to install $(missing_tools) for man pages")
 endif
 
-install-%.3: $(OUTPUT)%.3
+$(OUTPUT)install-%.3: $(OUTPUT)%.3
 	$(call QUIET_INSTALL, $<) \
 		$(INSTALL) -d -m 755 $(DESTDIR)$(man3dir); \
 		$(INSTALL) -m 644 $< $(DESTDIR)$(man3dir);
 
-do-install-man: man $(addprefix install-,$(wildcard $(OUTPUT)*.3))
+do-install-man: man $(patsubst $(OUTPUT)%,$(OUTPUT)install-%,$(wildcard $(OUTPUT)*.3))
 
 install-man: check-man-tools man
 	$(Q)$(MAKE) -C . do-install-man
-- 
2.33.0


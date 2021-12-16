Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B34AC43219
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Dec 2021 21:40:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241111AbhLPVkB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Dec 2021 16:40:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241298AbhLPVkB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Dec 2021 16:40:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E14C061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Dec 2021 13:40:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A4CAB8264D
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Dec 2021 21:40:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C24C6C36AE8;
        Thu, 16 Dec 2021 21:39:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mxyTl-0003dN-Qa;
        Thu, 16 Dec 2021 16:39:57 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 03/10] libtraceevent: Have make tags and TAGS honor O= build directory
Date:   Thu, 16 Dec 2021 16:39:49 -0500
Message-Id: <20211216213956.13934-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211216213956.13934-1-rostedt@goodmis.org>
References: <20211216213956.13934-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Currently if one does a "make O=/tmp/build tags" the tags are still built
in the source directory. Although this is uncommon to do, the tags (and
TAGS) target should still honor the build directory.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/Makefile b/Makefile
index 4363e9b73dc3..8b3b5cc1ea35 100644
--- a/Makefile
+++ b/Makefile
@@ -246,15 +246,22 @@ define update_dir
    fi);
 endef
 
-tags:	force
-	$(RM) tags
-	find . -name '*.[ch]' | xargs ctags --extra=+f --c-kinds=+px \
-	--regex-c++='/_PE\(([^,)]*).*/TEP_ERRNO__\1/'
-
-TAGS:	force
-	$(RM) TAGS
-	find . -name '*.[ch]' | xargs etags \
-	--regex='/_PE(\([^,)]*\).*/TEP_ERRNO__\1/'
+VIM_TAGS = $(obj)/tags
+EMACS_TAGS = $(obj)/TAGS
+
+$(VIM_TAGS): force
+	$(RM) $(VIM_TAGS)
+	find $(src) -name '*.[ch]' | (cd $(obj) && xargs ctags --extra=+f --c-kinds=+px \
+	--regex-c++='/_PE\(([^,)]*).*/TEP_ERRNO__\1/')
+
+tags: $(VIM_TAGS)
+
+$(EMACS_TAGS): force
+	$(RM) $(EMACS_TAGS)
+	find $(src) -name '*.[ch]' | (cd $(obj) && xargs etags \
+	--regex='/_PE(\([^,)]*\).*/TEP_ERRNO__\1/')
+
+TAGS: $(EMACS_TAGS)
 
 define build_prefix
 	(echo $1 > $@.tmp;	\
-- 
2.33.0


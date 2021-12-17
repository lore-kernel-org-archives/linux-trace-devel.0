Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40CAFC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Dec 2021 05:34:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhLQFes (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Dec 2021 00:34:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbhLQFes (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Dec 2021 00:34:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F3D8C061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Dec 2021 21:34:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09B9762005
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Dec 2021 05:34:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DDF6C36AE1
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Dec 2021 05:34:47 +0000 (UTC)
Date:   Fri, 17 Dec 2021 00:34:45 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtraceevent: Remove *.3 and *.m documentation files from
  build directory
Message-ID: <20211217003445.7d4c9025@oasis.local.home>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The clean target in the make file for the documentation used just *.3 and
*.m to remove the temporary files. These files are built in the build
directory, and the clean does not affect them if a remote directory is
used to build the documentation.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/Makefile b/Documentation/Makefile
index 5904b79..39f2be4 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -190,7 +190,7 @@ endif
 CLEAN_FILES =					\
 	$(MAN_XML) $(addsuffix +,$(MAN_XML))	\
 	$(MAN_HTML) $(addsuffix +,$(MAN_HTML))	\
-	$(DOC_MAN3) *.3 *.m
+	$(DOC_MAN3) $(OUTPUT)*.3 $(OUTPUT)*.m
 
 clean:
 	$(call QUIET_CLEAN, Documentation) $(RM) $(CLEAN_FILES)
-- 
2.31.1


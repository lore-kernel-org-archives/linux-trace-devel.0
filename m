Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27A4FC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Feb 2022 20:09:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344107AbiBJUJD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Feb 2022 15:09:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237548AbiBJUJC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Feb 2022 15:09:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE9F2734;
        Thu, 10 Feb 2022 12:09:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E00261873;
        Thu, 10 Feb 2022 20:09:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8A6C340EE;
        Thu, 10 Feb 2022 20:09:01 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@goodmis.org>)
        id 1nIFkS-002zJS-Sj;
        Thu, 10 Feb 2022 15:09:00 -0500
Message-ID: <20220210200900.724873802@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 10 Feb 2022 15:05:10 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        linux-trace-devel@vger.kernel.org
Subject: [for-linus][PATCH 1/6] rtla: Follow kernel version
References: <20220210200509.089236997@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Daniel Bristot de Oliveira <bristot@kernel.org>

To avoid having commits with new version, it is just easier to follow
kernel version.

Link: https://lkml.kernel.org/r/9c2df0d1de65cea96c7d731fe64781a2bb90c5b3.1643990447.git.bristot@kernel.org

Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-trace-devel@vger.kernel.org
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tools/tracing/rtla/Makefile | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/tracing/rtla/Makefile b/tools/tracing/rtla/Makefile
index 7c39728d08de..5a1eda617992 100644
--- a/tools/tracing/rtla/Makefile
+++ b/tools/tracing/rtla/Makefile
@@ -1,5 +1,6 @@
 NAME	:=	rtla
-VERSION	:=	0.5
+# Follow the kernel version
+VERSION :=	$(shell cat VERSION 2> /dev/null || make -sC ../../.. kernelversion)
 
 # From libtracefs:
 # Makefiles suck: This macro sets a default value of $(2) for the
@@ -85,6 +86,7 @@ clean: doc_clean
 
 tarball: clean
 	rm -rf $(NAME)-$(VERSION) && mkdir $(NAME)-$(VERSION)
+	echo $(VERSION) > $(NAME)-$(VERSION)/VERSION
 	cp -r $(DIRS) $(FILES) $(NAME)-$(VERSION)
 	mkdir $(NAME)-$(VERSION)/Documentation/
 	cp -rp $(SRCTREE)/../../../Documentation/tools/rtla/* $(NAME)-$(VERSION)/Documentation/
-- 
2.34.1

Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88E7BC4332F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Nov 2022 20:11:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbiKOULW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Nov 2022 15:11:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbiKOULV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Nov 2022 15:11:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C2C017E11
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Nov 2022 12:11:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38934B81B50
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Nov 2022 20:11:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B82DC433D6
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Nov 2022 20:11:17 +0000 (UTC)
Date:   Tue, 15 Nov 2022 15:12:00 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Make the unit test depend on the static library
Message-ID: <20221115151200.7c60d0e3@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Several times I've been confused that the unit test was not working after
I had fixed some of the library code. The reason is that the unit test
binary does not have a dependency on the static library. Even though the
library is updated, the unit test will not reflect the changes because it
was not rebuilt against the updated static library.

Add a dependency to the static library to the unit test binary.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 utest/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utest/Makefile b/utest/Makefile
index ee0020a68cc1..f10b709addce 100644
--- a/utest/Makefile
+++ b/utest/Makefile
@@ -21,7 +21,7 @@ $(bdir):
 
 $(OBJS): | $(bdir)
 
-$(bdir)/trace-utest: $(OBJS)
+$(bdir)/trace-utest: $(OBJS) $(obj)/lib/libtracefs.a
 	$(Q)$(do_app_build)
 
 $(bdir)/%.o: %.c
-- 
2.35.1


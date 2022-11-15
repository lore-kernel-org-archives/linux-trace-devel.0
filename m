Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F858C4332F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Nov 2022 20:53:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238559AbiKOUxi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Nov 2022 15:53:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238570AbiKOUxQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Nov 2022 15:53:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 995FE2CE32
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Nov 2022 12:53:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44B32B81A1C
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Nov 2022 20:53:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00FE9C433D6;
        Tue, 15 Nov 2022 20:53:12 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1ov2wO-00ApFR-0I;
        Tue, 15 Nov 2022 15:53:56 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/4] trace-cmd: Make the unit test depend on the static library
Date:   Tue, 15 Nov 2022 15:53:52 -0500
Message-Id: <20221115205355.2580214-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221115205355.2580214-1-rostedt@goodmis.org>
References: <20221115205355.2580214-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index d475bad5a0f9..337db9bf24a1 100644
--- a/utest/Makefile
+++ b/utest/Makefile
@@ -23,7 +23,7 @@ $(bdir):
 $(OBJS): | $(bdir)
 $(DEPS): | $(bdir)
 
-$(bdir)/trace-utest: $(OBJS)
+$(bdir)/trace-utest: $(OBJS) $(LIBTRACECMD_STATIC)
 	$(Q)$(do_app_build)
 
 $(bdir)/%.o: %.c
-- 
2.35.1


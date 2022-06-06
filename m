Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF840C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jun 2022 19:30:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232093AbiFFTaG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 6 Jun 2022 15:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232395AbiFFT35 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Jun 2022 15:29:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6CDDCB
        for <linux-trace-devel@vger.kernel.org>; Mon,  6 Jun 2022 12:29:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB5B8614A0
        for <linux-trace-devel@vger.kernel.org>; Mon,  6 Jun 2022 19:29:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F62C34119;
        Mon,  6 Jun 2022 19:29:55 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nyIQE-001Oyp-4P;
        Mon, 06 Jun 2022 15:29:54 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Harald Seiler <hws@denx.de>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/6] libtracefs: Fix make sqlhist when built again
Date:   Mon,  6 Jun 2022 15:29:48 -0400
Message-Id: <20220606192953.334315-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220606192953.334315-1-rostedt@goodmis.org>
References: <20220606192953.334315-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

"make sqlhist" currently only works after a "make clean". That is because
the sqlhist.c is extracted from the man page and left there after the
first build. On the second build, the sqlhist.c still exists and the
target for "sqlhist" runs the default build as it has nothing to build
with, which fails to build as the default does not work with it.

Add the sqlhist target to .PHONY to tell make that it is not a real target
and it should not try to build it using the default methods.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 samples/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/samples/Makefile b/samples/Makefile
index 97a570d6c956..c1392fbbb12b 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -67,3 +67,5 @@ $(bdir)/%.o: $(bdir)/%.c
 
 clean:
 	$(Q)$(call do_clean,$(sdir)/* $(bdir)/sqlhist.c $(bdir)/sqlhist.o)
+
+.PHONY: sqlhist
-- 
2.35.1


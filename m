Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BFB4C433F5
	for <linux-trace-devel@archiver.kernel.org>; Sat, 14 May 2022 02:55:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbiENCzn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 May 2022 22:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbiENCzh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 May 2022 22:55:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDF6E34990F
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 May 2022 19:47:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1538261DFC
        for <linux-trace-devel@vger.kernel.org>; Sat, 14 May 2022 02:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74AA6C34116;
        Sat, 14 May 2022 02:47:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nphoz-005XMH-DE;
        Fri, 13 May 2022 22:47:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: [PATCH 07/26] trace-cmd Makefile: Change test-build to link as well
Date:   Fri, 13 May 2022 22:47:37 -0400
Message-Id: <20220514024756.1319681-8-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220514024756.1319681-1-rostedt@goodmis.org>
References: <20220514024756.1319681-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Remove the '-c' option from the test-build macro build. To test if a
function exists, it needs to go through the link phase, otherwise it can
pass with an undefined symbol.

Link: https://lore.kernel.org/linux-trace-devel/20220428174949.797657-2-rostedt@goodmis.org

Cc: Joel Fernandes <joel@joelfernandes.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 982514baad01..9fbc6de25d05 100644
--- a/Makefile
+++ b/Makefile
@@ -163,7 +163,7 @@ export NO_PYTHON
 # $(call test-build, snippet, ret) -> ret if snippet compiles
 #                                  -> empty otherwise
 test-build = $(if $(shell sh -c 'echo "$(1)" | \
-	$(CC) -o /dev/null -c -x c - > /dev/null 2>&1 && echo y'), $2)
+	$(CC) -o /dev/null -x c - > /dev/null 2>&1 && echo y'), $2)
 
 UDIS86_AVAILABLE := $(call test-build,\#include <udis86.h>, y)
 ifneq ($(strip $(UDIS86_AVAILABLE)), y)
-- 
2.35.1


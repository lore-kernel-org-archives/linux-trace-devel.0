Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D86CCC43219
	for <linux-trace-devel@archiver.kernel.org>; Sun, 17 Apr 2022 18:22:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234757AbiDQSYf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 17 Apr 2022 14:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234759AbiDQSYe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 17 Apr 2022 14:24:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0BF95FD0
        for <linux-trace-devel@vger.kernel.org>; Sun, 17 Apr 2022 11:21:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82CD3B8037A
        for <linux-trace-devel@vger.kernel.org>; Sun, 17 Apr 2022 18:21:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6DEC385A7;
        Sun, 17 Apr 2022 18:21:56 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1ng9X1-004Mz6-7S;
        Sun, 17 Apr 2022 14:21:55 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 1/7] trace-cmd: Add NO_VSOCK make option to force vsock code off
Date:   Sun, 17 Apr 2022 14:21:48 -0400
Message-Id: <20220417182154.1041513-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220417182154.1041513-1-rostedt@goodmis.org>
References: <20220417182154.1041513-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add "make NO_VSOCK=1" to disable building with vsocket code. It is
equivalent to not having vsocket support on the system.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Makefile b/Makefile
index 9ccaaa61fecb..982514baad01 100644
--- a/Makefile
+++ b/Makefile
@@ -287,7 +287,11 @@ CFLAGS ?= -g -Wall
 CPPFLAGS ?=
 LDFLAGS ?=
 
+ifndef NO_VSOCK
 VSOCK_DEFINED := $(shell if (echo "$(pound)include <linux/vm_sockets.h>" | $(CC) -E - >/dev/null 2>&1) ; then echo 1; else echo 0 ; fi)
+else
+VSOCK_DEFINED := 0
+endif
 
 export VSOCK_DEFINED
 ifeq ($(VSOCK_DEFINED), 1)
-- 
2.35.1


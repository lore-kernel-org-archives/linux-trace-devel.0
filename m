Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B96CEC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Apr 2022 01:00:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244661AbiDOBC6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Apr 2022 21:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348323AbiDOBCi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Apr 2022 21:02:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A50F2ED75
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Apr 2022 18:00:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AEAB621FD
        for <linux-trace-devel@vger.kernel.org>; Fri, 15 Apr 2022 01:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E06C385AB;
        Fri, 15 Apr 2022 01:00:09 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nfAJk-003w8U-Mk;
        Thu, 14 Apr 2022 21:00:08 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/8] trace-cmd: Add NO_VSOCK make option to force vsock code off
Date:   Thu, 14 Apr 2022 21:00:00 -0400
Message-Id: <20220415010007.938408-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220415010007.938408-1-rostedt@goodmis.org>
References: <20220415010007.938408-1-rostedt@goodmis.org>
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


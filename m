Return-Path: <SRS0=/5S9=A7=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEC88C433F1
	for <linux-trace-devel@archiver.kernel.org>; Mon, 20 Jul 2020 16:45:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1ED32070A
	for <linux-trace-devel@archiver.kernel.org>; Mon, 20 Jul 2020 16:45:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729192AbgGTQpC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 20 Jul 2020 12:45:02 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:46652 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729219AbgGTQpB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 20 Jul 2020 12:45:01 -0400
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 6AE7672CCF0;
        Mon, 20 Jul 2020 19:44:59 +0300 (MSK)
Received: from beacon.altlinux.org (unknown [83.220.44.62])
        by imap.altlinux.org (Postfix) with ESMTPSA id 465404A4AEE;
        Mon, 20 Jul 2020 19:44:59 +0300 (MSK)
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
Cc:     Vitaly Chikunov <vt@altlinux.org>,
        "Dmitry V . Levin" <ldv@altlinux.org>
Subject: [PATCH 2/2] Makefile: Fix build of utest on systems with --as-needed enabled
Date:   Mon, 20 Jul 2020 19:44:53 +0300
Message-Id: <20200720164453.5161-2-vt@altlinux.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200720164453.5161-1-vt@altlinux.org>
References: <20200720164453.5161-1-vt@altlinux.org>
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On systems (such as ALT Linux) where `--as-needed' is passed to ld by
default, building tests fail due to CUNIT_INSTALLED test failure to link
with libcunit, becasue `-lcunit' is passed before input file (which is
`-'). Move `-lcunit' after '-' to link it properly.

To reproduce `make CC='gcc -Wl,--as-needed' test`. Error message:

  Makefile:344: *** CUnit framework not installed, cannot build unit tests.  Stop.

Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
Cc: Dmitry V. Levin <ldv@altlinux.org>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 6b606da..83e5646 100644
--- a/Makefile
+++ b/Makefile
@@ -242,7 +242,7 @@ ifeq ($(VSOCK_DEFINED), 1)
 CFLAGS += -DVSOCK
 endif
 
-CUNIT_INSTALLED := $(shell if (printf "$(pound)include <CUnit/Basic.h>\n void main(){CU_initialize_registry();}" | $(CC) -x c -lcunit - >/dev/null 2>&1) ; then echo 1; else echo 0 ; fi)
+CUNIT_INSTALLED := $(shell if (printf "$(pound)include <CUnit/Basic.h>\n void main(){CU_initialize_registry();}" | $(CC) -x c - -lcunit >/dev/null 2>&1) ; then echo 1; else echo 0 ; fi)
 export CUNIT_INSTALLED
 
 export CFLAGS
-- 
2.11.0


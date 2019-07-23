Return-Path: <SRS0=P3iB=VU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4081AC76190
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Jul 2019 22:52:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2296C21926
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Jul 2019 22:52:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392323AbfGWWwl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Jul 2019 18:52:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:56686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392358AbfGWWwk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Jul 2019 18:52:40 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D01F5227BF;
        Tue, 23 Jul 2019 22:52:39 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1hq3eA-000806-VM; Tue, 23 Jul 2019 18:52:38 -0400
Message-Id: <20190723225238.859019956@goodmis.org>
User-Agent: quilt/0.65
Date:   Tue, 23 Jul 2019 18:50:46 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH 2/2] kernel-shark: Set the DISPLAY environment for pkexec kshark-record
References: <20190723225044.576298160@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

When running a fresh install, I hit this:

 ERROR:  Capture process failed:
 Unknown errorqt.qpa.screen: QXcbConnection: Could not connect to display
 Could not connect to any X display.

This was due to pkexec not saving the DISPLAY environment variable. To solve
this, pass that variable as one of the environment variables to pkexec.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel-shark/bin/kshark-su-record | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel-shark/bin/kshark-su-record b/kernel-shark/bin/kshark-su-record
index 7faff1cb3339..8c9fbd02a351 100755
--- a/kernel-shark/bin/kshark-su-record
+++ b/kernel-shark/bin/kshark-su-record
@@ -6,4 +6,4 @@ then
 fi
 
 THIS_DIR=`dirname $0`
-pkexec ${THIS_DIR}/kshark-record -o ${PWD}/trace.dat
+pkexec env DISPLAY=${DISPLAY} ${THIS_DIR}/kshark-record -o ${PWD}/trace.dat
-- 
2.20.1



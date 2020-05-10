Return-Path: <SRS0=2y7b=6Y=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F906C38A2A
	for <linux-trace-devel@archiver.kernel.org>; Sun, 10 May 2020 15:17:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FE9D20735
	for <linux-trace-devel@archiver.kernel.org>; Sun, 10 May 2020 15:17:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728621AbgEJPRW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 10 May 2020 11:17:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:59472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728360AbgEJPRW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 10 May 2020 11:17:22 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8842920725;
        Sun, 10 May 2020 15:17:21 +0000 (UTC)
Date:   Sun, 10 May 2020 11:17:20 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Cc:     Yordan Karadzhov <y.karadz@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH] kernelshark: Make fontHeight() and stringWidth() static
Message-ID: <20200510111720.2e041431@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Gcc 10 is much more picky about globals being defined in multiple objects
even if they are the same function. The functions fontHeight() and
stringWidth() are defined in a header file which places them in multiple
objects. They need to be static otherwise gcc 10 will not be able to build.

Link: https://lore.kernel.org/linux-trace-devel/CADVatmN=Z0ASVXUBTyAu6F_TWoWiKiKsgm404rOx7Oh-a6LiQg@mail.gmail.com/

Reported-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel-shark/src/KsUtils.hpp | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel-shark/src/KsUtils.hpp b/kernel-shark/src/KsUtils.hpp
index f44139bb..272a27d1 100644
--- a/kernel-shark/src/KsUtils.hpp
+++ b/kernel-shark/src/KsUtils.hpp
@@ -32,7 +32,7 @@
 
 //! @cond Doxygen_Suppress
 
-auto fontHeight = []()
+static auto fontHeight = []()
 {
 	QFont font;
 	QFontMetrics fm(font);
@@ -40,7 +40,7 @@ auto fontHeight = []()
 	return fm.height();
 };
 
-auto stringWidth = [](QString s)
+static auto stringWidth = [](QString s)
 {
 	QFont font;
 	QFontMetrics fm(font);
-- 
2.20.1


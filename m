Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 330F3C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Dec 2021 05:20:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232981AbhLQFUT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Dec 2021 00:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232847AbhLQFUT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Dec 2021 00:20:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D047C061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Dec 2021 21:20:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0DAF62044
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Dec 2021 05:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B474BC36AE1
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Dec 2021 05:20:17 +0000 (UTC)
Date:   Fri, 17 Dec 2021 00:20:15 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtraceevent: Export LIBS variable in Makefile
Message-ID: <20211217002015.28d80525@oasis.local.home>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The rewrite of the Makefile left out exporting LIBS and this caused the
libraries not to include the -ldl library, which would have unresolved
symbols for code that included it (like ldopen() and friends)

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile b/Makefile
index b26b0d5..80b3107 100644
--- a/Makefile
+++ b/Makefile
@@ -131,6 +131,7 @@ else
 endif
 
 LIBS = -ldl
+export LIBS
 
 set_plugin_dir := 1
 
-- 
2.31.1


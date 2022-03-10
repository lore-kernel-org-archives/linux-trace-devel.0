Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4DAAC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Mar 2022 15:20:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238059AbiCJPVX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Mar 2022 10:21:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236036AbiCJPVR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Mar 2022 10:21:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB0470CEB
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Mar 2022 07:20:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C09A06146C
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Mar 2022 15:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB5D2C340E8
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Mar 2022 15:20:12 +0000 (UTC)
Date:   Thu, 10 Mar 2022 10:20:11 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Up min libtraceevent version to 1.5
Message-ID: <20220310102011.0866b8ba@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

trace-cmd now uses tep_get_sub_buffer_size() which was added in
libtraceevent 1.5.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 3be6ac34d8e8..5d33e3583c44 100644
--- a/Makefile
+++ b/Makefile
@@ -22,7 +22,7 @@ export LIBTRACECMD_VERSION
 
 VERSION_FILE = ltc_version.h
 
-LIBTRACEEVENT_MIN_VERSION = 1.3
+LIBTRACEEVENT_MIN_VERSION = 1.5
 LIBTRACEFS_MIN_VERSION = 1.3
 
 MAKEFLAGS += --no-print-directory
-- 
2.34.1


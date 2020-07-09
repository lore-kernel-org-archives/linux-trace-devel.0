Return-Path: <SRS0=/aBd=AU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 217D7C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Jul 2020 19:13:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED977207DD
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Jul 2020 19:13:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgGITNy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Jul 2020 15:13:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726213AbgGITNy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Jul 2020 15:13:54 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1072E20767
        for <linux-trace-devel@vger.kernel.org>; Thu,  9 Jul 2020 19:13:53 +0000 (UTC)
Date:   Thu, 9 Jul 2020 15:13:52 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Have libtracefs depend on libtraceevent and not
 libtracecmd
Message-ID: <20200709151352.6af5309b@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The tracefs library does not depend on libtracecmd, but it does depend on
libtraceevent. Change the Makefile to reflect that.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 lib/tracefs/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/tracefs/Makefile b/lib/tracefs/Makefile
index b810bbf4..cbcce362 100644
--- a/lib/tracefs/Makefile
+++ b/lib/tracefs/Makefile
@@ -22,7 +22,7 @@ $(bdir):
 $(OBJS): | $(bdir)
 $(DEPS): | $(bdir)
 
-LIBS = -L$(obj)/lib/trace-cmd -ltracecmd
+LIBS = -L$(obj)/lib/traceevent -ltraceevent
 
 $(bdir)/libtracefs.a: $(OBJS)
 	$(Q)$(call do_build_static_lib)
-- 
2.25.4


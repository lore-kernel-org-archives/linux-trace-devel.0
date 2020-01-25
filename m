Return-Path: <SRS0=v841=3O=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAE6EC3F68F
	for <linux-trace-devel@archiver.kernel.org>; Sat, 25 Jan 2020 02:50:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C90A5222C2
	for <linux-trace-devel@archiver.kernel.org>; Sat, 25 Jan 2020 02:50:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387716AbgAYCue (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 24 Jan 2020 21:50:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:44672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387699AbgAYCue (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 24 Jan 2020 21:50:34 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71FF82073B
        for <linux-trace-devel@vger.kernel.org>; Sat, 25 Jan 2020 02:50:33 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1ivBWq-000toT-Bq
        for linux-trace-devel@vger.kernel.org; Fri, 24 Jan 2020 21:50:32 -0500
Message-Id: <20200125025032.246345729@goodmis.org>
User-Agent: quilt/0.65
Date:   Fri, 24 Jan 2020 21:50:09 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/3] tracefs: Include -ltracecmd to libtracefs.so build
References: <20200125025008.757057369@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

There's functions that libtracefs.so uses that require libtracecmd.so
compiled as well. Instead of requiring applicatons that use -ltracefs to
also include -ltracecmd, simply add it to the build of libtracefs.so.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 lib/tracefs/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/tracefs/Makefile b/lib/tracefs/Makefile
index 5763e06d0326..f6d93ec84236 100644
--- a/lib/tracefs/Makefile
+++ b/lib/tracefs/Makefile
@@ -22,6 +22,8 @@ $(bdir):
 $(OBJS): | $(bdir)
 $(DEPS): | $(bdir)
 
+LIBS = -L$(obj)/lib/trace-cmd -ltracecmd
+
 $(bdir)/libtracefs.a: $(OBJS)
 	$(Q)$(call do_build_static_lib)
 
-- 
2.24.1



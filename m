Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED1C0C4361B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 04:43:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFEC523139
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 04:43:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725796AbgLPEnS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:43:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:48930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725788AbgLPEnS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Dec 2020 23:43:18 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A328823139
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Dec 2020 04:42:14 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kpOdh-000qzJ-MT
        for linux-trace-devel@vger.kernel.org; Tue, 15 Dec 2020 23:42:13 -0500
Message-ID: <20201216044213.537553785@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 15 Dec 2020 23:41:54 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 04/12] trace-cmd: Use the LIBTRACE{EVENT,FS}_LIBS for building
 libtracecmd.so
References: <20201216044150.375001748@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Currently the path of the libtraceevent library is hardcoded when building
libtracecmd.so, and libtracefs is not even specified. In order to use
libtracecmd.so without needing to add -ltraceevent or -ltracefs, use the
defined LIBTRACEVENT_LIBS and LIBTRACEFS_LIBS for the LIBS macro to build
libtracecmd.so.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 lib/trace-cmd/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index 838a59ddf332..75e4fea4e3e0 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -38,7 +38,7 @@ $(DEPS): | $(bdir)
 $(LIBTRACECMD_STATIC): $(OBJS)
 	$(Q)$(call do_build_static_lib)
 
-LIBS = -L$(obj)/lib/traceevent -ltraceevent
+LIBS = $(LIBTRACEEVENT_LDLAGS) $(LIBTRACEFS_LDLAGS)
 
 $(LIBTRACECMD_SHARED_VERSION): $(LIBTRACECMD_SHARED)
 	@ln -sf $(<F) $@
-- 
2.29.2



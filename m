Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D17AEC433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 00:50:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A95A961105
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 00:50:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232996AbhDIAuw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Apr 2021 20:50:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:45538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232984AbhDIAuv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Apr 2021 20:50:51 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82523610D0
        for <linux-trace-devel@vger.kernel.org>; Fri,  9 Apr 2021 00:50:39 +0000 (UTC)
Date:   Thu, 8 Apr 2021 20:50:37 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracecmd: Add -lpthread to build libtracecmd
Message-ID: <20210408205037.4f871cda@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

On Debian, the following error occurred on installing the library.

/usr/bin/ld: /usr/local/lib64/libtracecmd.so: undefined reference to `pthread_barrier_init'
/usr/bin/ld: /usr/local/lib64/libtracecmd.so: undefined reference to `pthread_barrier_wait'
/usr/bin/ld: /usr/local/lib64/libtracecmd.so: undefined reference to `pthread_join'
/usr/bin/ld: /usr/local/lib64/libtracecmd.so: undefined reference to `pthread_getaffinity_np'
/usr/bin/ld: /usr/local/lib64/libtracecmd.so: undefined reference to `pthread_create'
/usr/bin/ld: /usr/local/lib64/libtracecmd.so: undefined reference to `pthread_barrier_destroy'
/usr/bin/ld: /usr/local/lib64/libtracecmd.so: undefined reference to `pthread_setaffinity_np'
collect2: error: ld returned 1 exit status

Include -lpthread to libtracecmd to allow it to use the pthread functions.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 lib/trace-cmd/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index afd74e1d..9bba5a21 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -44,7 +44,7 @@ $(DEPS): | $(bdir)
 $(LIBTRACECMD_STATIC): $(OBJS)
 	$(Q)$(call do_build_static_lib)
 
-LIBS = $(LIBTRACEEVENT_LDLAGS) $(LIBTRACEFS_LDLAGS)
+LIBS = $(LIBTRACEEVENT_LDLAGS) $(LIBTRACEFS_LDLAGS) -lpthread
 
 $(LIBTRACECMD_SHARED_VERSION): $(LIBTRACECMD_SHARED)
 	@ln -sf $(<F) $@
-- 
2.29.2


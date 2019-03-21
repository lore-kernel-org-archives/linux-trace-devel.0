Return-Path: <SRS0=gVBF=RY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B73C1C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Mar 2019 23:46:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87AB12190A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Mar 2019 23:46:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbfCUXqh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 21 Mar 2019 19:46:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:48178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726374AbfCUXqh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Mar 2019 19:46:37 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 756E22190A
        for <linux-trace-devel@vger.kernel.org>; Thu, 21 Mar 2019 23:46:36 +0000 (UTC)
Date:   Thu, 21 Mar 2019 19:46:35 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Add -lrt to building trace-record.c
Message-ID: <20190321194635.46c45b93@gandalf.local.home>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>


clock_gettime() requires -lrt for glibc < 2.17. Add it so older systems can
still build.

Fixes: 42e33cf0e53b ("trace-cmd: improve the accuracy of date to ts mapping")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/Makefile b/tracecmd/Makefile
index 3a11024f817b..93b373d58155 100644
--- a/tracecmd/Makefile
+++ b/tracecmd/Makefile
@@ -39,7 +39,7 @@ all_objs := $(sort $(ALL_OBJS))
 all_deps := $(all_objs:$(bdir)/%.o=$(bdir)/.%.d)
 
 CONFIG_INCLUDES =
-CONFIG_LIBS	=
+CONFIG_LIBS	= -lrt
 CONFIG_FLAGS	=
 
 all: $(TARGETS)
-- 
2.20.1


Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC887C0018C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 23:22:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 916202389A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 23:22:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbgLPXW1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Dec 2020 18:22:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:59548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727902AbgLPXW0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Dec 2020 18:22:26 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E65423976;
        Wed, 16 Dec 2020 23:21:46 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kpg77-000xGr-C9; Wed, 16 Dec 2020 18:21:45 -0500
Message-ID: <20201216232145.219821698@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 16 Dec 2020 18:19:44 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/6 v2] trace-cmd: Add #include <fcntl.h> to trace-cmd-private.h
References: <20201216231942.127326802@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Getting the following warning in the build:

lib/trace-cmd/include/private/trace-cmd-private.h:276:41: warning: `struct iovec` declared inside parameter list will not be visible outside of this definition or declaration
  276 |         unsigned short id, const struct iovec *vector, int count);
      |                                         ^~~~~

The file trace-cmd-private.h needs to include fcntl.h to get the iovec structure
definition.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 lib/trace-cmd/include/private/trace-cmd-private.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index a0dac5da14d6..6494581527a3 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -6,6 +6,7 @@
 #ifndef _TRACE_CMD_PRIVATE_H
 #define _TRACE_CMD_PRIVATE_H
 
+#include <fcntl.h> /* for iovec */
 #include <sys/types.h>
 #include "traceevent/event-parse.h"
 #include "trace-cmd/trace-cmd.h"
-- 
2.29.2



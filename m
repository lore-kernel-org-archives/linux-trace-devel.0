Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94704C433B4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 20:15:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 593F4610FC
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 20:15:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233917AbhDIUPe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Apr 2021 16:15:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:46216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233824AbhDIUPe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Apr 2021 16:15:34 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B599601FE;
        Fri,  9 Apr 2021 20:15:20 +0000 (UTC)
Date:   Fri, 9 Apr 2021 16:15:19 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH] libtracefs: Have trace_get_options() use trace_get_lock()
 helper
Message-ID: <20210409161519.6155c5ea@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Instead of having trace_get_options() figure out what lock it needs to
use, have it use the trace_get_lock() helper instead.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/tracefs-tools.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index fa09da5..6ef17f6 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -211,7 +211,7 @@ enum tracefs_option_id tracefs_option_id(const char *name)
 const static struct tracefs_options_mask *
 trace_get_options(struct tracefs_instance *instance, bool enabled)
 {
-	pthread_mutex_t *lock = instance ? &instance->lock : &toplevel_lock;
+	pthread_mutex_t *lock = trace_get_lock(instance);
 	struct tracefs_options_mask *bitmask;
 	enum tracefs_option_id id;
 	unsigned long long set;
-- 
2.29.2


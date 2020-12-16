Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E609C4361B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 20:12:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 441802368A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 20:12:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbgLPUMP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Dec 2020 15:12:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:35158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727409AbgLPUMP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Dec 2020 15:12:15 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1164D23600
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Dec 2020 20:11:35 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kpd94-000vtZ-3g
        for linux-trace-devel@vger.kernel.org; Wed, 16 Dec 2020 15:11:34 -0500
Message-ID: <20201216201133.937274493@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 16 Dec 2020 15:11:07 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/8] libtracefs: Clean up tracefs.h
References: <20201216201106.170659791@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Fix a typo, and use <traceevent/event-parse.h> instead of
"traceevent/event-parse.h" for the include name.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/tracefs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index ce8b09ca5bd0..5cbe8982d1bc 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -6,8 +6,8 @@
 #ifndef _TRACE_FS_H
 #define _TRACE_FS_H
 
+#include <traceevent/event-parse.h>
 #include <sched.h>
-#include "traceevent/event-parse.h"
 
 char *tracefs_get_tracing_file(const char *name);
 void tracefs_put_tracing_file(char *name);
@@ -18,7 +18,7 @@ const char *tracefs_get_tracing_dir(void);
 /* tracefs_find_tracing_dir must be freed */
 char *tracefs_find_tracing_dir(void);
 
-/* ftarce instances */
+/* ftrace instances */
 struct tracefs_instance;
 
 void tracefs_instance_free(struct tracefs_instance *instance);
-- 
2.29.2



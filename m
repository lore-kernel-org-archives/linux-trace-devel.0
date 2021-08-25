Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97A5EC432BE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 25 Aug 2021 23:45:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 795C260FBF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 25 Aug 2021 23:45:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233361AbhHYXqd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 25 Aug 2021 19:46:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:42228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231535AbhHYXqc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 25 Aug 2021 19:46:32 -0400
Received: from rorschach.local.home (unknown [24.94.146.150])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F21AB61042
        for <linux-trace-devel@vger.kernel.org>; Wed, 25 Aug 2021 23:45:45 +0000 (UTC)
Date:   Wed, 25 Aug 2021 19:45:43 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Define gettid() when not defined
Message-ID: <20210825194543.34de6c3f@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Steven Rostedt <rostedt@rorschach.local.home>

tracefs-hist.c uses the gettid() system call, but older glibcs do not
define it. Define the system call when it is not already defined.

Signed-off-by: Steven Rostedt <rostedt@rorschach.local.home>
---
 src/tracefs-hist.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 003715f..c0d3049 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -24,6 +24,11 @@
 #define ASCENDING ".ascending"
 #define DESCENDING ".descending"
 
+#ifndef gettid
+# include <sys/syscall.h>
+# define gettid() syscall(__NR_gettid)
+#endif
+
 struct tracefs_hist {
 	struct tep_handle	*tep;
 	struct tep_event	*event;
-- 
2.30.2


Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A24B8C4338F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 03:53:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 827A460F9D
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 03:53:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233481AbhG1Dx5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 27 Jul 2021 23:53:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:52552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233437AbhG1Dx5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Jul 2021 23:53:57 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53BB660F9B;
        Wed, 28 Jul 2021 03:53:56 +0000 (UTC)
Date:   Tue, 27 Jul 2021 23:53:48 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Cc:     Daniel Bristot de Oliveira <bristot@redhat.com>
Subject: [PATCH] libtracefs: Rename GR and NQ to GT and NE respectively
Message-ID: <20210727235348.0faf542e@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

When writing the sqlhist interface, I found that calling ">" GT and "!="
NE were more sensible than calling them GR and NQ, as we already have LT
as "less than" why not use GT as "greater than". As well as EQ for
"equal", it seems more appropriate to have NE be "not equal".

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/tracefs.h  | 4 ++--
 src/tracefs-hist.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index 25d99f8..445c96f 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -315,8 +315,8 @@ enum tracefs_synth_calc {
 
 enum tracefs_synth_compare {
 	TRACEFS_COMPARE_EQ,
-	TRACEFS_COMPARE_NQ,
-	TRACEFS_COMPARE_GR,
+	TRACEFS_COMPARE_NE,
+	TRACEFS_COMPARE_GT,
 	TRACEFS_COMPARE_GE,
 	TRACEFS_COMPARE_LT,
 	TRACEFS_COMPARE_LE,
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 969944a..8178725 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -1201,7 +1201,7 @@ static int add_synth_filter(char **filter, const char *field,
 
 	switch (compare) {
 	case TRACEFS_COMPARE_EQ: trace_seq_puts(&seq, " == "); break;
-	case TRACEFS_COMPARE_NQ: trace_seq_puts(&seq, " != "); break;
+	case TRACEFS_COMPARE_NE: trace_seq_puts(&seq, " != "); break;
 	case TRACEFS_COMPARE_RE:
 		if (!is_string)
 			goto inval;
@@ -1213,7 +1213,7 @@ static int add_synth_filter(char **filter, const char *field,
 	}
 
 	switch (compare) {
-	case TRACEFS_COMPARE_GR: trace_seq_puts(&seq, " > "); break;
+	case TRACEFS_COMPARE_GT: trace_seq_puts(&seq, " > "); break;
 	case TRACEFS_COMPARE_GE: trace_seq_puts(&seq, " >= "); break;
 	case TRACEFS_COMPARE_LT: trace_seq_puts(&seq, " < "); break;
 	case TRACEFS_COMPARE_LE: trace_seq_puts(&seq, " <= "); break;
-- 
2.31.1


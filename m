Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E79A1C4338F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Aug 2021 01:39:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C66B5610A8
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Aug 2021 01:39:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238172AbhHMBj1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Aug 2021 21:39:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:51022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238130AbhHMBj0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Aug 2021 21:39:26 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F83060FBF
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 Aug 2021 01:39:00 +0000 (UTC)
Date:   Thu, 12 Aug 2021 21:38:53 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Fix SYM-OFFSET in tracefs_sql()
Message-ID: <20210812213853.77183026@oasis.local.home>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The lexical for SYM-OFFSET would break it up into SYM '-' OFFSET and that
would not be parsed properly.

Let the "SYM-OFFSET' be its own lexical operator, to fix it.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/sqlhist.l | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/src/sqlhist.l b/src/sqlhist.l
index db0ae11..4df475a 100644
--- a/src/sqlhist.l
+++ b/src/sqlhist.l
@@ -40,6 +40,12 @@ on { HANDLE_COLUMN; return ON; }
 where { HANDLE_COLUMN; return WHERE; }
 cast { HANDLE_COLUMN; return CAST; }
 
+sym-offset {
+	HANDLE_COLUMN;
+	yylval->string = store_str(TRACE_SB, yyg->yytext_r);
+	return FIELD;
+}
+
 {qstring} {
 	HANDLE_COLUMN;
 	yylval->string = store_str(TRACE_SB, yyg->yytext_r);
-- 
2.31.1


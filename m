Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18C92C00143
	for <linux-trace-devel@archiver.kernel.org>; Fri, 30 Jul 2021 22:18:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0028061055
	for <linux-trace-devel@archiver.kernel.org>; Fri, 30 Jul 2021 22:18:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233243AbhG3WSl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 30 Jul 2021 18:18:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232589AbhG3WSj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 30 Jul 2021 18:18:39 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DC6A61040;
        Fri, 30 Jul 2021 22:18:34 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1m9apt-002V1V-JQ; Fri, 30 Jul 2021 18:18:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 09/17] libtracefs: Add line number and index to expr structure
Date:   Fri, 30 Jul 2021 18:18:16 -0400
Message-Id: <20210730221824.595597-10-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210730221824.595597-1-rostedt@goodmis.org>
References: <20210730221824.595597-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

In order to have better error messages, record the line number and index
when an expr structure is created. Then this can be used to show where in
the SQL sequence a problem was found if the building of the synth event
has issues.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/tracefs-sqlhist.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/tracefs-sqlhist.c b/src/tracefs-sqlhist.c
index 933b3609733b..887c2441a39e 100644
--- a/src/tracefs-sqlhist.c
+++ b/src/tracefs-sqlhist.c
@@ -72,6 +72,8 @@ struct expr {
 	struct expr		*free_list;
 	struct expr		*next;
 	enum expr_type		type;
+	int			line;
+	int			idx;
 	union {
 		struct field	field;
 		struct filter	filter;
@@ -300,6 +302,8 @@ static void *create_expr(struct sqlhist_bison *sb,
 	sb->table->exprs = expr;
 
 	expr->type = type;
+	expr->line = sb->line_no;
+	expr->idx = sb->line_idx;
 
 	switch (type) {
 	case EXPR_FIELD:	return &expr->field;
-- 
2.30.2


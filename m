Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6695C4338F
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 04:24:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBE0761155
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 04:24:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233768AbhHCEYK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Aug 2021 00:24:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:57170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232694AbhHCEYH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Aug 2021 00:24:07 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04CAA61078;
        Tue,  3 Aug 2021 04:23:56 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mAly7-002qnU-Ue; Tue, 03 Aug 2021 00:23:55 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v2 10/21] libtracefs: Add error message when match fields are not FROM and JOIN events
Date:   Tue,  3 Aug 2021 00:23:36 -0400
Message-Id: <20210803042347.679499-11-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210803042347.679499-1-rostedt@goodmis.org>
References: <20210803042347.679499-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

It is required that the "match" content (the ON portion of the SQL
sequence) has a field from the FROM event and a field from the JOIN event.

If they do not, then give a better message about what went wrong.

To simplify addition of future errors, also add a parse_error() that calls into
sql_parse_error() with the appropriate "ap" argument. That is, parse_error()
takes a normal printf() form and then translates it to the vprintf from of
sql_parse_error.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/tracefs-sqlhist.c | 43 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 41 insertions(+), 2 deletions(-)

diff --git a/src/tracefs-sqlhist.c b/src/tracefs-sqlhist.c
index 887c2441a39e..0489657bea03 100644
--- a/src/tracefs-sqlhist.c
+++ b/src/tracefs-sqlhist.c
@@ -8,6 +8,7 @@
  */
 #include <trace-seq.h>
 #include <stdlib.h>
+#include <stdarg.h>
 #include <errno.h>
 
 #include "tracefs.h"
@@ -153,6 +154,16 @@ __hidden void sql_parse_error(struct sqlhist_bison *sb, const char *text,
 	trace_seq_destroy(&s);
 }
 
+static void parse_error(struct sqlhist_bison *sb, const char *text,
+			const char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	sql_parse_error(sb, text, fmt, ap);
+	va_end(ap);
+}
+
 static inline unsigned int quick_hash(const char *str)
 {
 	unsigned int val = 0;
@@ -582,6 +593,34 @@ static int update_vars(struct sql_table *table, struct field *event)
 	return 0;
 }
 
+static int match_error(struct sqlhist_bison *sb, struct match *match,
+		       struct field *lmatch, struct field *rmatch)
+{
+	struct field *lval = &match->lval->field;
+	struct field *rval = &match->rval->field;
+	struct field *field;
+	struct expr *expr;
+
+	if (lval->system != lmatch->system ||
+	    lval->event != lmatch->event) {
+		expr = match->lval;
+		field = lval;
+	} else {
+		expr = match->rval;
+		field = rval;
+	}
+
+	sb->line_no = expr->line;
+	sb->line_idx = expr->idx;
+
+	parse_error(sb, field->raw,
+		    "'%s' and '%s' must be a field for each event: '%s' and '%s'\n",
+		    lval->raw, rval->raw, sb->table->to->field.raw,
+		    sb->table->from->field.raw);
+
+	return -1;
+}
+
 static int test_match(struct sql_table *table, struct match *match)
 {
 	struct field *lval, *rval;
@@ -613,13 +652,13 @@ static int test_match(struct sql_table *table, struct match *match)
 		    (rval->event != to->event) ||
 		    (lval->system != from->system) ||
 		    (lval->event != from->event))
-			return -1;
+			return match_error(table->sb, match, from, to);
 	} else {
 		if ((rval->system != from->system) ||
 		    (rval->event != from->event) ||
 		    (lval->system != to->system) ||
 		    (lval->event != to->event))
-			return -1;
+			return match_error(table->sb, match, to, from);
 	}
 	return 0;
 }
-- 
2.30.2


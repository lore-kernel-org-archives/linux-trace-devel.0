Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D13B2C19F31
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 17:06:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE34861029
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 17:06:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237553AbhHCRGs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Aug 2021 13:06:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:38756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237537AbhHCRGU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Aug 2021 13:06:20 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0630461176;
        Tue,  3 Aug 2021 17:06:08 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mAxrj-002uc5-Uj; Tue, 03 Aug 2021 13:06:07 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v3 15/22] libtracefs: Add error message for bad filters in SQL statement
Date:   Tue,  3 Aug 2021 13:05:59 -0400
Message-Id: <20210803170606.694085-16-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210803170606.694085-1-rostedt@goodmis.org>
References: <20210803170606.694085-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

If a filter has a bad event, or incompatibility with the value assigned to
it, have the error message display it.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/tracefs-sqlhist.c | 80 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 74 insertions(+), 6 deletions(-)

diff --git a/src/tracefs-sqlhist.c b/src/tracefs-sqlhist.c
index a0d934b4cd68..d7829d4804b1 100644
--- a/src/tracefs-sqlhist.c
+++ b/src/tracefs-sqlhist.c
@@ -879,14 +879,80 @@ static int verify_filter(struct sqlhist_bison *sb, struct filter *filter,
 	}
 }
 
-static int build_filter(struct tracefs_synth *synth,
-			bool start, struct filter *filter, bool *started)
+static int test_field_exists(struct tep_handle *tep, struct sqlhist_bison *sb,
+			     struct expr *expr);
+
+static void filter_compare_error(struct tep_handle *tep,
+				 struct sqlhist_bison *sb,
+				 struct expr *expr)
+{
+	struct field *field = &expr->field;
+
+	switch (errno) {
+	case ENODEV:
+	case EBADE:
+		break;
+	case EINVAL:
+		parse_error(sb, field->raw, "Invalid compare\n");
+		break;
+	default:
+		parse_error(sb, field->raw, "System error?\n");
+		return;
+	}
+
+	/* ENODEV means that an event or field does not exist */
+	if (errno == ENODEV) {
+		if (test_field_exists(tep, sb, expr))
+			return;
+		if (test_field_exists(tep, sb, expr))
+			return;
+		return;
+	}
+
+	/* fields exist, but values are not compatible */
+	sb->line_no = expr->line;
+	sb->line_idx = expr->idx;
+
+	parse_error(sb, field->raw,
+		    "Field '%s' is not compatible to be compared with the given value\n",
+		    field->field);
+}
+
+static void filter_error(struct tep_handle *tep,
+			 struct sqlhist_bison *sb, struct expr *expr)
+{
+	struct filter *filter = &expr->filter;
+
+	sb->line_no = expr->line;
+	sb->line_idx = expr->idx;
+
+	switch (filter->type) {
+	case FILTER_NOT_GROUP:
+	case FILTER_GROUP:
+	case FILTER_OR:
+	case FILTER_AND:
+		break;
+	default:
+		filter_compare_error(tep, sb, filter->lval);
+		return;
+	}
+
+	sb->line_no = expr->line;
+	sb->line_idx = expr->idx;
+
+	parse_error(sb, "", "Problem with filter entry?\n");
+}
+
+static int build_filter(struct tep_handle *tep, struct sqlhist_bison *sb,
+			struct tracefs_synth *synth,
+			bool start, struct expr *expr, bool *started)
 {
 	int (*append_filter)(struct tracefs_synth *synth,
 			     enum tracefs_filter type,
 			     const char *field,
 			     enum tracefs_compare compare,
 			     const char *val);
+	struct filter *filter = &expr->filter;
 	enum tracefs_compare cmp;
 	const char *val;
 	int and_or = TRACEFS_FILTER_AND;
@@ -916,7 +982,7 @@ static int build_filter(struct tracefs_synth *synth,
 				    NULL, 0, NULL);
 		if (ret < 0)
 			goto out;
-		ret = build_filter(synth, start, &filter->lval->filter, NULL);
+		ret = build_filter(tep, sb, synth, start, filter->lval, NULL);
 		if (ret < 0)
 			goto out;
 		ret = append_filter(synth, TRACEFS_FILTER_CLOSE_PAREN,
@@ -927,14 +993,14 @@ static int build_filter(struct tracefs_synth *synth,
 		and_or = TRACEFS_FILTER_OR;
 		/* Fall through */
 	case FILTER_AND:
-		ret = build_filter(synth, start, &filter->lval->filter, NULL);
+		ret = build_filter(tep, sb, synth, start, filter->lval, NULL);
 		if (ret < 0)
 			goto out;
 		ret = append_filter(synth, and_or, NULL, 0, NULL);
 
 		if (ret)
 			goto out;
-		ret = build_filter(synth, start, &filter->rval->filter, NULL);
+		ret = build_filter(tep, sb, synth, start, filter->rval, NULL);
 		goto out;
 	default:
 		break;
@@ -968,6 +1034,8 @@ static int build_filter(struct tracefs_synth *synth,
 	ret = append_filter(synth, TRACEFS_FILTER_COMPARE,
 			    filter->lval->field.field, cmp, val);
 
+	if (ret)
+		filter_error(tep, sb, expr);
  out:
 	if (!ret && started) {
 		if (*started)
@@ -1193,7 +1261,7 @@ static struct tracefs_synth *build_synth(struct tep_handle *tep,
 		else
 			started = &started_end;
 
-		ret = build_filter(synth, start, &expr->filter, started);
+		ret = build_filter(tep, table->sb, synth, start, expr, started);
 		if (ret < 0)
 			goto free;
 	}
-- 
2.30.2


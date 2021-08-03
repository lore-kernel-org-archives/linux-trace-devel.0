Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4E4BC19F38
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 17:06:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF6E760EB9
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 17:06:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237575AbhHCRGZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Aug 2021 13:06:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:38752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237531AbhHCRGU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Aug 2021 13:06:20 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFA196112E;
        Tue,  3 Aug 2021 17:06:08 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mAxrj-002ubt-RE; Tue, 03 Aug 2021 13:06:07 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v3 11/22] libtracefs: Add error message when match or init fails from bad events
Date:   Tue,  3 Aug 2021 13:05:55 -0400
Message-Id: <20210803170606.694085-12-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210803170606.694085-1-rostedt@goodmis.org>
References: <20210803170606.694085-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

If the tracefs_synth_init() or the matching fails due to events that do
not exist, or if the match fields are not compatible with each other. Add
an error message that reports this and where the problem is.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/tracefs-sqlhist.c | 98 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 89 insertions(+), 9 deletions(-)

diff --git a/src/tracefs-sqlhist.c b/src/tracefs-sqlhist.c
index da4668f53ea1..ab190d123800 100644
--- a/src/tracefs-sqlhist.c
+++ b/src/tracefs-sqlhist.c
@@ -507,6 +507,7 @@ __hidden int table_start(struct sqlhist_bison *sb)
 }
 
 static int test_event_exists(struct tep_handle *tep,
+			     struct sqlhist_bison *sb,
 			     struct expr *expr, struct tep_event **pevent)
 {
 	struct field *field = &expr->field;
@@ -517,18 +518,30 @@ static int test_event_exists(struct tep_handle *tep,
 		field->event = tep_find_event_by_name(tep, system, event);
 	if (pevent)
 		*pevent = field->event;
-	return field->event != NULL ? 0 : -1;
+
+	if (field->event)
+		return 0;
+
+	sb->line_no = expr->line;
+	sb->line_idx = expr->idx;
+
+	parse_error(sb, field->raw, "event not found\n");
+	return -1;
 }
 
-static int test_field_exists(struct expr *expr)
+static int test_field_exists(struct tep_handle *tep,
+			     struct sqlhist_bison *sb,
+			     struct expr *expr)
 {
 	struct field *field = &expr->field;
 	struct tep_format_field *tfield;
 	char *field_name;
 	const char *p;
 
-	if (!field->event)
-		return -1;
+	if (!field->event) {
+		if (test_event_exists(tep, sb, expr, NULL))
+			return -1;
+	}
 
 	/* The field could have a conversion */
 	p = strchr(field->field, '.');
@@ -547,7 +560,16 @@ static int test_field_exists(struct expr *expr)
 		tfield = tep_find_any_field(field->event, field_name);
 	free(field_name);
 
-	return tfield != NULL ? 0 : -1;
+	if (tfield)
+		return 0;
+
+	sb->line_no = expr->line;
+	sb->line_idx = expr->idx;
+
+	parse_error(sb, field->raw,
+		    "Field '%s' not part of event %s\n",
+		    field->field, field->event_name);
+	return -1;
 }
 
 static int update_vars(struct tep_handle *tep,
@@ -585,7 +607,7 @@ static int update_vars(struct tep_handle *tep,
 	if (!event_field->event_name)
 		return -1;
 
-	if (test_event_exists(tep, expr, &event))
+	if (test_event_exists(tep, sb, expr, &event))
 		return -1;
 
 	if (!event_field->system)
@@ -651,7 +673,7 @@ static int update_vars(struct tep_handle *tep,
 			field->field = store_str(sb, TRACEFS_TIMESTAMP);
 		if (!strcmp(field->field, "TIMESTAMP_USECS"))
 			field->field = store_str(sb, TRACEFS_TIMESTAMP_USECS);
-		if (test_field_exists(expr))
+		if (test_field_exists(tep, sb, expr))
 			return -1;
 	}
 
@@ -941,6 +963,62 @@ static int build_filter(struct tracefs_synth *synth,
 	return ret;
 }
 
+static void *field_match_error(struct tep_handle *tep, struct sqlhist_bison *sb,
+			       struct match *match)
+{
+	switch (errno) {
+	case ENODEV:
+	case EBADE:
+		break;
+	default:
+		/* System error */
+		return NULL;
+	}
+
+	/* ENODEV means that an event or field does not exist */
+	if (errno == ENODEV) {
+		if (test_field_exists(tep, sb, match->lval))
+			return NULL;
+		if (test_field_exists(tep, sb, match->rval))
+			return NULL;
+		return NULL;
+	}
+
+	/* fields exist, but values are not compatible */
+	sb->line_no = match->lval->line;
+	sb->line_idx = match->lval->idx;
+
+	parse_error(sb, match->lval->field.raw,
+		    "Field '%s' is not compatible to match field '%s'\n",
+		    match->lval->field.raw, match->rval->field.raw);
+	return NULL;
+}
+
+static void *synth_init_error(struct tep_handle *tep, struct sql_table *table)
+{
+	struct sqlhist_bison *sb = table->sb;
+	struct match *match = table->matches;
+
+	switch (errno) {
+	case ENODEV:
+	case EBADE:
+		break;
+	default:
+		/* System error */
+		return NULL;
+	}
+
+	/* ENODEV could mean that start or end events do not exist */
+	if (errno == ENODEV) {
+		if (test_event_exists(tep, sb, table->from, NULL))
+			return NULL;
+		if (test_event_exists(tep, sb, table->to, NULL))
+			return NULL;
+	}
+
+	return field_match_error(tep, sb, match);
+}
+
 static struct tracefs_synth *build_synth(struct tep_handle *tep,
 					 const char *name,
 					 struct sql_table *table)
@@ -991,7 +1069,7 @@ static struct tracefs_synth *build_synth(struct tep_handle *tep,
 				   start_event, end_system, end_event,
 				   start_match, end_match, NULL);
 	if (!synth)
-		return NULL;
+		return synth_init_error(tep, table);
 
 	for (match = match->next; match; match = match->next) {
 		ret = test_match(table, match);
@@ -1004,8 +1082,10 @@ static struct tracefs_synth *build_synth(struct tep_handle *tep,
 		ret = tracefs_synth_add_match_field(synth,
 						    start_match,
 						    end_match, NULL);
-		if (ret < 0)
+		if (ret < 0) {
+			field_match_error(tep, table->sb, match);
 			goto free;
+		}
 	}
 
 	for (expr = table->selections; expr; expr = expr->next) {
-- 
2.30.2


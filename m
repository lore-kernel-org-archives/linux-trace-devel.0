Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94195C41537
	for <linux-trace-devel@archiver.kernel.org>; Fri, 30 Jul 2021 22:18:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 687806112D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 30 Jul 2021 22:18:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233584AbhG3WSs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 30 Jul 2021 18:18:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:51316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233099AbhG3WSk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 30 Jul 2021 18:18:40 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C59956109F;
        Fri, 30 Jul 2021 22:18:34 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1m9apt-002V1n-OY; Fri, 30 Jul 2021 18:18:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 15/17] libtracefs: Add error message for grouping events in SQL filter
Date:   Fri, 30 Jul 2021 18:18:22 -0400
Message-Id: <20210730221824.595597-16-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210730221824.595597-1-rostedt@goodmis.org>
References: <20210730221824.595597-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

One requirement for the SQL filter in tracefs_sql() is that the WHERE
clause (filter) can only filter the FROM and JOIN events with "&&".

That is, you can not have:

  sched_switch.next_pid == 0 || sched_waking.pid == 0

As the filtering one event stops the synthetic event, having an ||
conjunction makes no sense.

Add an error message that explains this when it is found.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/tracefs-sqlhist.c | 35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/src/tracefs-sqlhist.c b/src/tracefs-sqlhist.c
index ff0869232a9e..1767c33d77d0 100644
--- a/src/tracefs-sqlhist.c
+++ b/src/tracefs-sqlhist.c
@@ -715,21 +715,36 @@ static int build_compare(struct tracefs_synth *synth,
 	return ret;
 }
 
-static int do_verify_filter(struct filter *filter,
+static int verify_filter_error(struct sqlhist_bison *sb, struct expr *expr,
+			       const char *event)
+{
+	struct field *field = &expr->field;
+
+	sb->line_no = expr->line;
+	sb->line_idx = expr->idx;
+
+	parse_error(sb, field->raw,
+		    "event '%s' can not be grouped or '||' together with '%s'\n"
+		    "All filters between '&&' must be for the same event\n",
+		    field->event, event);
+	return -1;
+}
+
+static int do_verify_filter(struct sqlhist_bison *sb, struct filter *filter,
 			    const char **system, const char **event)
 {
 	int ret;
 
 	if (filter->type == FILTER_OR ||
 	    filter->type == FILTER_AND) {
-		ret = do_verify_filter(&filter->lval->filter, system, event);
+		ret = do_verify_filter(sb, &filter->lval->filter, system, event);
 		if (ret)
 			return ret;
-		return do_verify_filter(&filter->rval->filter, system, event);
+		return do_verify_filter(sb, &filter->rval->filter, system, event);
 	}
 	if (filter->type == FILTER_GROUP ||
 	    filter->type == FILTER_NOT_GROUP) {
-		return do_verify_filter(&filter->lval->filter, system, event);
+		return do_verify_filter(sb, &filter->lval->filter, system, event);
 	}
 
 	/*
@@ -744,12 +759,12 @@ static int do_verify_filter(struct filter *filter,
 
 	if (filter->lval->field.system != *system ||
 	    filter->lval->field.event != *event)
-		return -1;
+		return verify_filter_error(sb, filter->lval, *event);
 
 	return 0;
 }
 
-static int verify_filter(struct filter *filter,
+static int verify_filter(struct sqlhist_bison *sb, struct filter *filter,
 			 const char **system, const char **event)
 {
 	int ret;
@@ -761,17 +776,17 @@ static int verify_filter(struct filter *filter,
 	case FILTER_NOT_GROUP:
 		break;
 	default:
-		return do_verify_filter(filter, system, event);
+		return do_verify_filter(sb, filter, system, event);
 	}
 
-	ret = do_verify_filter(&filter->lval->filter, system, event);
+	ret = do_verify_filter(sb, &filter->lval->filter, system, event);
 	if (ret)
 		return ret;
 
 	switch (filter->type) {
 	case FILTER_OR:
 	case FILTER_AND:
-		return do_verify_filter(&filter->rval->filter, system, event);
+		return do_verify_filter(sb, &filter->rval->filter, system, event);
 	default:
 		return 0;
 	}
@@ -1117,7 +1132,7 @@ static struct tracefs_synth *build_synth(struct tep_handle *tep,
 		bool *started;
 		bool start;
 
-		ret = verify_filter(&expr->filter, &filter_system,
+		ret = verify_filter(table->sb, &expr->filter, &filter_system,
 				    &filter_event);
 		if (ret < 0)
 			goto free;
-- 
2.30.2


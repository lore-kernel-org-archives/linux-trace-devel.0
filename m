Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46B8BCCA482
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jun 2022 19:30:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232249AbiFFTaI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 6 Jun 2022 15:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232417AbiFFT35 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Jun 2022 15:29:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2531C19C
        for <linux-trace-devel@vger.kernel.org>; Mon,  6 Jun 2022 12:29:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B967B6147E
        for <linux-trace-devel@vger.kernel.org>; Mon,  6 Jun 2022 19:29:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3178BC34115;
        Mon,  6 Jun 2022 19:29:55 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nyIQE-001Oz1-75;
        Mon, 06 Jun 2022 15:29:54 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Harald Seiler <hws@denx.de>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5/6] libtracefs: Differentiate WHERE clause when FROM and TO events are the same
Date:   Mon,  6 Jun 2022 15:29:52 -0400
Message-Id: <20220606192953.334315-6-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220606192953.334315-1-rostedt@goodmis.org>
References: <20220606192953.334315-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

With "FROM sched_switch as start JOIN sched_switch AS end" and then
filtering with "WHERE start.prev_state = 2 && end.next_prio < 100" the
parser gets confused and uses the "start.next_prio" instead of the
"end.next_prio", making the filter only on the start event and not on the
end event as expected.

Fix it by testing the field type (FIELD_TO/FIELD_FROM) as well as the
system and event of the field when selecting which event the field is a
part of.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-sqlhist.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/src/tracefs-sqlhist.c b/src/tracefs-sqlhist.c
index 22e4b652e48b..5205356356a5 100644
--- a/src/tracefs-sqlhist.c
+++ b/src/tracefs-sqlhist.c
@@ -904,20 +904,21 @@ static int verify_filter_error(struct sqlhist_bison *sb, struct expr *expr,
 }
 
 static int do_verify_filter(struct sqlhist_bison *sb, struct filter *filter,
-			    const char **system, const char **event)
+			    const char **system, const char **event,
+			    enum field_type *ftype)
 {
 	int ret;
 
 	if (filter->type == FILTER_OR ||
 	    filter->type == FILTER_AND) {
-		ret = do_verify_filter(sb, &filter->lval->filter, system, event);
+		ret = do_verify_filter(sb, &filter->lval->filter, system, event, ftype);
 		if (ret)
 			return ret;
-		return do_verify_filter(sb, &filter->rval->filter, system, event);
+		return do_verify_filter(sb, &filter->rval->filter, system, event, ftype);
 	}
 	if (filter->type == FILTER_GROUP ||
 	    filter->type == FILTER_NOT_GROUP) {
-		return do_verify_filter(sb, &filter->lval->filter, system, event);
+		return do_verify_filter(sb, &filter->lval->filter, system, event, ftype);
 	}
 
 	/*
@@ -927,6 +928,7 @@ static int do_verify_filter(struct sqlhist_bison *sb, struct filter *filter,
 	if (!*system && !*event) {
 		*system = filter->lval->field.system;
 		*event = filter->lval->field.event_name;
+		*ftype = filter->lval->field.ftype;
 		return 0;
 	}
 
@@ -938,7 +940,8 @@ static int do_verify_filter(struct sqlhist_bison *sb, struct filter *filter,
 }
 
 static int verify_filter(struct sqlhist_bison *sb, struct filter *filter,
-			 const char **system, const char **event)
+			 const char **system, const char **event,
+			 enum field_type *ftype)
 {
 	int ret;
 
@@ -949,17 +952,17 @@ static int verify_filter(struct sqlhist_bison *sb, struct filter *filter,
 	case FILTER_NOT_GROUP:
 		break;
 	default:
-		return do_verify_filter(sb, filter, system, event);
+		return do_verify_filter(sb, filter, system, event, ftype);
 	}
 
-	ret = do_verify_filter(sb, &filter->lval->filter, system, event);
+	ret = do_verify_filter(sb, &filter->lval->filter, system, event, ftype);
 	if (ret)
 		return ret;
 
 	switch (filter->type) {
 	case FILTER_OR:
 	case FILTER_AND:
-		return do_verify_filter(sb, &filter->rval->filter, system, event);
+		return do_verify_filter(sb, &filter->rval->filter, system, event, ftype);
 	default:
 		return 0;
 	}
@@ -1516,16 +1519,18 @@ static struct tracefs_synth *build_synth(struct tep_handle *tep,
 	for (expr = table->where; expr; expr = expr->next) {
 		const char *filter_system = NULL;
 		const char *filter_event = NULL;
+		enum field_type ftype = FIELD_NONE;
 		bool *started;
 		bool start;
 
 		ret = verify_filter(table->sb, &expr->filter, &filter_system,
-				    &filter_event);
+				    &filter_event, &ftype);
 		if (ret < 0)
 			goto free;
 
 		start = filter_system == start_system &&
-			filter_event == start_event;
+			filter_event == start_event &&
+			ftype != FIELD_TO;
 
 		if (start)
 			started = &started_start;
-- 
2.35.1


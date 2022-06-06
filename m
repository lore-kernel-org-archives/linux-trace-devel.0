Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70616CCA473
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jun 2022 19:30:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232339AbiFFTaH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 6 Jun 2022 15:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232427AbiFFT35 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Jun 2022 15:29:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3EB560FA
        for <linux-trace-devel@vger.kernel.org>; Mon,  6 Jun 2022 12:29:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4146A6149B
        for <linux-trace-devel@vger.kernel.org>; Mon,  6 Jun 2022 19:29:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD84C341C5;
        Mon,  6 Jun 2022 19:29:55 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nyIQE-001Oyv-5e;
        Mon, 06 Jun 2022 15:29:54 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Harald Seiler <hws@denx.de>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 3/6] libtracefs: Differentiate FROM and JOIN events if they are the same event
Date:   Mon,  6 Jun 2022 15:29:50 -0400
Message-Id: <20220606192953.334315-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220606192953.334315-1-rostedt@goodmis.org>
References: <20220606192953.334315-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If both the FROM and the JOIN event are the same, the fields get
confusing due to the way tracefs_sql() does not distinguish the events
when transforming the variable names, and it may process the JOIN fields
as the FROM fields, and the wrong field gets passed to the synthetic
event.

Add a new FIELD_TYPE enum and set the fields to FROM or TO to know which
event the field belongs to, and use that to avoid picking the field for
the wrong event.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-sqlhist.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/src/tracefs-sqlhist.c b/src/tracefs-sqlhist.c
index caf927fd5e1c..d854f7b54344 100644
--- a/src/tracefs-sqlhist.c
+++ b/src/tracefs-sqlhist.c
@@ -30,6 +30,12 @@ enum alias_type {
 	ALIAS_FIELD,
 };
 
+enum field_type {
+	FIELD_NONE,
+	FIELD_FROM,
+	FIELD_TO,
+};
+
 #define for_each_field(expr, field, table) \
 	for (expr = (table)->fields; expr; expr = (field)->next)
 
@@ -42,6 +48,7 @@ struct field {
 	const char		*label;
 	const char		*field;
 	const char		*type;
+	enum field_type		ftype;
 };
 
 struct filter {
@@ -583,6 +590,7 @@ static int update_vars(struct tep_handle *tep,
 {
 	struct sqlhist_bison *sb = table->sb;
 	struct field *event_field = &expr->field;
+	enum field_type ftype = FIELD_NONE;
 	struct tep_event *event;
 	struct field *field;
 	const char *label;
@@ -592,6 +600,11 @@ static int update_vars(struct tep_handle *tep,
 	const char *p;
 	int label_len = 0, event_len, system_len;
 
+	if (expr == table->to)
+		ftype = FIELD_TO;
+	else if (expr == table->from)
+		ftype = FIELD_FROM;
+
 	p = strchr(raw, '.');
 	if (p) {
 		char *str;
@@ -673,6 +686,7 @@ static int update_vars(struct tep_handle *tep,
 		field->event_name = event_name;
 		field->event = event;
 		field->field = raw + len + 1;
+		field->ftype = ftype;
 
 		if (!strcmp(field->field, "TIMESTAMP"))
 			field->field = store_str(sb, TRACEFS_TIMESTAMP);
@@ -1452,7 +1466,8 @@ static struct tracefs_synth *build_synth(struct tep_handle *tep,
 		if (expr->type == EXPR_FIELD) {
 			ret = -1;
 			field = &expr->field;
-			if (field->system == start_system &&
+			if (field->ftype != FIELD_TO &&
+			    field->system == start_system &&
 			    field->event_name == start_event) {
 				int type;
 				type = verify_field_type(tep, table->sb, expr);
-- 
2.35.1


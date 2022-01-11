Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0582AC433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 11 Jan 2022 00:17:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345844AbiAKARJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 10 Jan 2022 19:17:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345622AbiAKARJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 10 Jan 2022 19:17:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D523FC06173F
        for <linux-trace-devel@vger.kernel.org>; Mon, 10 Jan 2022 16:17:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7598C614BB
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 Jan 2022 00:17:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6153C36AE5;
        Tue, 11 Jan 2022 00:17:07 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1n74qY-002uDm-W4;
        Mon, 10 Jan 2022 19:17:06 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 1/2] libtraceevent: Do not fail field parsing if field has typecast
Date:   Mon, 10 Jan 2022 19:17:04 -0500
Message-Id: <20220111001705.692692-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220111001705.692692-1-rostedt@goodmis.org>
References: <20220111001705.692692-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

If a field is expected for a printk format but is typecasted, it could
fail the parsing where the error is a "helpful":

  ARG TYPE NOT FIELD BUT 7

Add a check before each of these to see if it is a typecast, and use the
arg that the typecast is for.

Link: https://lore.kernel.org/all/164182978641.8391.8277203495236105391.stgit@bazille.1015granger.net/

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 src/event-parse.c | 31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index 9bd605d74b1f..5f3e2d8a6421 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -4834,6 +4834,10 @@ static int print_mac_arg(struct trace_seq *s, const char *format,
 		return 0;
 	}
 
+	/* evaluate if the arg has a type cast */
+	while (arg->type == TEP_PRINT_TYPE)
+		arg = arg->typecast.item;
+
 	if (arg->type != TEP_PRINT_FIELD) {
 		trace_seq_printf(s, "ARG TYPE NOT FIELD BUT %d",
 				 arg->type);
@@ -5042,6 +5046,10 @@ static int print_ipv4_arg(struct trace_seq *s, const char *ptr, char i,
 		return ret;
 	}
 
+	/* evaluate if the arg has a type cast */
+	while (arg->type == TEP_PRINT_TYPE)
+		arg = arg->typecast.item;
+
 	if (arg->type != TEP_PRINT_FIELD) {
 		trace_seq_printf(s, "ARG TYPE NOT FIELD BUT %d", arg->type);
 		return ret;
@@ -5089,6 +5097,10 @@ static int print_ipv6_arg(struct trace_seq *s, const char *ptr, char i,
 		return rc;
 	}
 
+	/* evaluate if the arg has a type cast */
+	while (arg->type == TEP_PRINT_TYPE)
+		arg = arg->typecast.item;
+
 	if (arg->type != TEP_PRINT_FIELD) {
 		trace_seq_printf(s, "ARG TYPE NOT FIELD BUT %d", arg->type);
 		return rc;
@@ -5152,6 +5164,10 @@ static int print_ipsa_arg(struct trace_seq *s, const char *ptr, char i,
 		return rc;
 	}
 
+	/* evaluate if the arg has a type cast */
+	while (arg->type == TEP_PRINT_TYPE)
+		arg = arg->typecast.item;
+
 	if (arg->type != TEP_PRINT_FIELD) {
 		trace_seq_printf(s, "ARG TYPE NOT FIELD BUT %d", arg->type);
 		return rc;
@@ -5267,6 +5283,10 @@ static int print_uuid_arg(struct trace_seq *s, const char *ptr,
 		return ret;
 	}
 
+	/* evaluate if the arg has a type cast */
+	while (arg->type == TEP_PRINT_TYPE)
+		arg = arg->typecast.item;
+
 	if (arg->type != TEP_PRINT_FIELD) {
 		trace_seq_printf(s, "ARG TYPE NOT FIELD BUT %d", arg->type);
 		return ret;
@@ -5440,6 +5460,7 @@ static inline void print_field(struct trace_seq *s, void *data, int size,
 	struct tep_event *event = field->event;
 	struct tep_print_parse *start_parse;
 	struct tep_print_parse *parse;
+	struct tep_print_arg *arg;
 	bool has_0x;
 
 	parse = parse_ptr ? *parse_ptr : event->print_fmt.print_cache;
@@ -5464,9 +5485,13 @@ static inline void print_field(struct trace_seq *s, void *data, int size,
 			goto next;
 		}
 
-		if (!parse->arg ||
-		    parse->arg->type != TEP_PRINT_FIELD ||
-		    parse->arg->field.field != field) {
+		arg = parse->arg;
+
+		while (arg && arg->type == TEP_PRINT_TYPE)
+			arg = arg->typecast.item;
+
+		if (!arg || arg->type != TEP_PRINT_FIELD ||
+		    arg->field.field != field) {
 			has_0x = false;
 			goto next;
 		}
-- 
2.33.0


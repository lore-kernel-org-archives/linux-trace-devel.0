Return-Path: <SRS0=gJTR=AT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86FA8C433E2
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Jul 2020 20:30:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 656A1207DF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Jul 2020 20:30:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgGHUaU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 8 Jul 2020 16:30:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725964AbgGHUaS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 Jul 2020 16:30:18 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6949A20772
        for <linux-trace-devel@vger.kernel.org>; Wed,  8 Jul 2020 20:30:18 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jtGht-004NOe-E0
        for linux-trace-devel@vger.kernel.org; Wed, 08 Jul 2020 16:30:17 -0400
Message-ID: <20200708203017.319177062@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 08 Jul 2020 16:28:54 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 4/5] tools lib traceevent: Let function symbols be used in operations
References: <20200708202850.764168067@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The preemptirq events records only 32 bits for the locations of where the
events occur. It records the offset from _stext to do so. But the
libtraceevent does not handle function names in operations to add offsets
to.

Have the eval_num_arg() check if the value found is zero and then check if
it is a string. If it is a string value, check if that string matches any
function. If it does, then evaluate the function symbol and replace the
value with the actual number to complete the calculation.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=205953
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 lib/traceevent/event-parse.c | 49 +++++++++++++++++++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)

diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index ee16be96697b..77c3249220d3 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -3649,6 +3649,50 @@ tep_find_event_by_name(struct tep_handle *tep,
 	return event;
 }
 
+static unsigned long long test_for_symbol(struct tep_handle *tep,
+					  struct tep_print_arg *arg)
+{
+	unsigned long long val = 0;
+	struct func_list *item = tep->funclist;
+	char *func;
+	int i;
+
+	if (isdigit(arg->atom.atom[0]))
+		return 0;
+
+	/* Linear search but only happens once (see after the loop) */
+	for (i = 0; i < (int)tep->func_count; i++) {
+		unsigned long long addr;
+		const char *name;
+
+		if (tep->func_map) {
+			addr = tep->func_map[i].addr;
+			name = tep->func_map[i].func;
+		} else if (item) {
+			addr = item->addr;
+			name = item->func;
+			item = item->next;
+		} else
+			break;
+
+		if (strcmp(arg->atom.atom, name) == 0) {
+			val = addr;
+			break;
+		}
+	}
+
+	/*
+	 * This modifies the arg to hardcode the value
+	 * and will not loop again.
+	 */
+	func = realloc(arg->atom.atom, 32);
+	if (func) {
+		snprintf(func, 32, "%lld", val);
+		arg->atom.atom = func;
+	}
+	return val;
+}
+
 static unsigned long long
 eval_num_arg(void *data, int size, struct tep_event *event, struct tep_print_arg *arg)
 {
@@ -3665,7 +3709,10 @@ eval_num_arg(void *data, int size, struct tep_event *event, struct tep_print_arg
 		/* ?? */
 		return 0;
 	case TEP_PRINT_ATOM:
-		return strtoull(arg->atom.atom, NULL, 0);
+		val = strtoull(arg->atom.atom, NULL, 0);
+		if (!val)
+			val = test_for_symbol(tep, arg);
+		return val;
 	case TEP_PRINT_FIELD:
 		if (!arg->field.field) {
 			arg->field.field = tep_find_any_field(event, arg->field.name);
-- 
2.26.2



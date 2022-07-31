Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FBA4C00140
	for <linux-trace-devel@archiver.kernel.org>; Sun, 31 Jul 2022 16:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237475AbiGaQC6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 31 Jul 2022 12:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237472AbiGaQC5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 31 Jul 2022 12:02:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89AEEFD10
        for <linux-trace-devel@vger.kernel.org>; Sun, 31 Jul 2022 09:02:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 285C760EB5
        for <linux-trace-devel@vger.kernel.org>; Sun, 31 Jul 2022 16:02:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 742B8C433C1
        for <linux-trace-devel@vger.kernel.org>; Sun, 31 Jul 2022 16:02:54 +0000 (UTC)
Date:   Sun, 31 Jul 2022 12:02:47 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtraceevent: Add warnings if fields are outside the event
Message-ID: <20220731120247.71528711@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If a field is referenced outside of the event that is being processed,
do not access that field and warn about it.

This was triggered when there was a bug in the kernel that showed the
wrong offset to the fields that were outside the size of the event. When
trace-cmd used this library to get a field of an event that was at the
end of a sub buffer, it read past the page that was not allocated and
crashed.

Not only warn when this happens, but also just return a zero value and
not read past the event.

Link: https://lore.kernel.org/all/20220731015928.7ab3a154@rorschach.local.home/

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/event-parse.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/src/event-parse.c b/src/event-parse.c
index b252c4d..b3caff6 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -4084,6 +4084,18 @@ static inline void dynamic_offset_field(struct tep_handle *tep,
 		*offset += field->offset + field->size;
 }
 
+static bool check_data_offset_size(struct tep_event *event, const char *field_name,
+				    int data_size, int field_offset, int field_size)
+{
+	/* Check to make sure the field is within the data */
+	if (field_offset + field_size <= data_size)
+		return false;
+
+	tep_warning("Event '%s' field '%s' goes beyond the size of the event (%d > %d)",
+		    event->name, field_name, field_offset + field_size, data_size);
+	return true;
+}
+
 static unsigned long long
 eval_num_arg(void *data, int size, struct tep_event *event, struct tep_print_arg *arg)
 {
@@ -4110,6 +4122,12 @@ eval_num_arg(void *data, int size, struct tep_event *event, struct tep_print_arg
 			if (!arg->field.field)
 				goto out_warning_field;
 		}
+		if (check_data_offset_size(event, arg->field.name, size,
+					   arg->field.field->offset,
+					   arg->field.field->size)) {
+			val = 0;
+			break;
+		}
 		/* must be a number */
 		val = tep_read_number(tep, data + arg->field.field->offset,
 				      arg->field.field->size);
@@ -4177,6 +4195,11 @@ eval_num_arg(void *data, int size, struct tep_event *event, struct tep_print_arg
 			default:
 				goto default_op; /* oops, all bets off */
 			}
+			if (check_data_offset_size(event, arg->field.name, size,
+						   offset, field_size)) {
+				val = 0;
+				break;
+			}
 			val = tep_read_number(tep,
 					      data + offset, field_size);
 			if (typearg)
@@ -4286,6 +4309,11 @@ eval_num_arg(void *data, int size, struct tep_event *event, struct tep_print_arg
 		/* Without [], we pass the address to the dynamic data */
 		dynamic_offset_field(tep, arg->dynarray.field, data, size,
 				     &offset, NULL);
+		if (check_data_offset_size(event, arg->field.name, size,
+					   offset, field_size)) {
+			val = (unsigned long)data;
+			break;
+		}
 		val = (unsigned long long)((unsigned long)data + offset);
 		val = (unsigned long)data + offset;
 		break;
-- 
2.35.1


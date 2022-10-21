Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CA8AC38A2D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 21 Oct 2022 18:58:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiJUS61 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 21 Oct 2022 14:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbiJUS60 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 21 Oct 2022 14:58:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9FD132E8B
        for <linux-trace-devel@vger.kernel.org>; Fri, 21 Oct 2022 11:58:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 568CDB82D19
        for <linux-trace-devel@vger.kernel.org>; Fri, 21 Oct 2022 18:58:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A17C433D6
        for <linux-trace-devel@vger.kernel.org>; Fri, 21 Oct 2022 18:58:22 +0000 (UTC)
Date:   Fri, 21 Oct 2022 14:58:28 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v2] libtracefs: Allow filters to use "COMM"
Message-ID: <20221021145828.68d05371@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

COMM is a legitimate filter for events, histograms and synthetic events.
Allow it to be used in tracefs_sql().

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
Changes since v1: https://lore.kernel.org/all/20221020193336.3070b37e@gandalf.local.home/

 - Removed "breakpoint()" call that was left over from debugging

 src/tracefs-filter.c  | 14 +++++++++++++-
 src/tracefs-sqlhist.c |  3 +++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/src/tracefs-filter.c b/src/tracefs-filter.c
index b16dfadb3aa9..a3dd77b7c82c 100644
--- a/src/tracefs-filter.c
+++ b/src/tracefs-filter.c
@@ -35,6 +35,12 @@ static const struct tep_format_field common_timestamp_usecs = {
 	.size			= 8,
 };
 
+static const struct tep_format_field common_comm = {
+	.type			= "char *",
+	.name			= "common_comm",
+	.size			= 16,
+};
+
 /*
  * This also must be able to accept fields that are OK via the histograms,
  * such as common_timestamp.
@@ -42,13 +48,19 @@ static const struct tep_format_field common_timestamp_usecs = {
 static const struct tep_format_field *get_event_field(struct tep_event *event,
 					 const char *field_name)
 {
+	const struct tep_format_field *field;
+
 	if (!strcmp(field_name, TRACEFS_TIMESTAMP))
 		return &common_timestamp;
 
 	if (!strcmp(field_name, TRACEFS_TIMESTAMP_USECS))
 		return &common_timestamp_usecs;
 
-	return tep_find_any_field(event, field_name);
+	field = tep_find_any_field(event, field_name);
+	if (!field && (!strcmp(field_name, "COMM") || !strcmp(field_name, "comm")))
+		return &common_comm;
+
+	return field;
 }
 
 __hidden bool
diff --git a/src/tracefs-sqlhist.c b/src/tracefs-sqlhist.c
index fd0a4b390855..3f571b7fa86a 100644
--- a/src/tracefs-sqlhist.c
+++ b/src/tracefs-sqlhist.c
@@ -572,6 +572,9 @@ static int test_field_exists(struct tep_handle *tep,
 		tfield = tep_find_any_field(field->event, field_name);
 	free(field_name);
 
+	if (!tfield && (!strcmp(field->field, "COMM") || !strcmp(field->field, "comm")))
+		tfield = (void *)1L;
+
 	if (tfield)
 		return 0;
 
-- 
2.35.1


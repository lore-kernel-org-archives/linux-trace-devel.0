Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44ACBC4320A
	for <linux-trace-devel@archiver.kernel.org>; Fri, 30 Jul 2021 03:03:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CD5660FE7
	for <linux-trace-devel@archiver.kernel.org>; Fri, 30 Jul 2021 03:03:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234495AbhG3DDT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 23:03:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:35176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234520AbhG3DDP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 23:03:15 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 769246103B;
        Fri, 30 Jul 2021 03:03:11 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1m9Inm-002PQz-4d; Thu, 29 Jul 2021 23:03:10 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4/6] libtracefs: Add kerneldoc comments to the remaining synth functions
Date:   Thu, 29 Jul 2021 23:03:05 -0400
Message-Id: <20210730030307.574270-5-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210730030307.574270-1-rostedt@goodmis.org>
References: <20210730030307.574270-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Added kerneldoc comments to:

  tracefs_synth_show()
  tracefs_synth_append_start_filter()
  tracefs_synth_append_end_filter();

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/tracefs-hist.c | 69 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index d518ae77fe72..8a0d43fafb7e 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -580,6 +580,15 @@ static const struct tep_format_field common_timestamp_usecs = {
 	.size			= 8,
 };
 
+/**
+ * tracefs_synth_free - free the resources alloced to a synth
+ * @synth: The tracefs_synth descriptor
+ *
+ * Frees the resources allocated for a @synth created with
+ * tracefs_synth_init(). It does not touch the system. That is,
+ * any synthetic event created, will not be destroyed by this
+ * function.
+ */
 void tracefs_synth_free(struct tracefs_synth *synth)
 {
 	if (!synth)
@@ -1354,6 +1363,55 @@ inval:
 	return -1;
 }
 
+/**
+ * tracefs_synth_append_start_filter - create or append a filter
+ * @synth: The tracefs_synth descriptor
+ * @type: The type of element to add to the filter
+ * @field: For @type == TRACEFS_FILTER_COMPARE, the field to compare
+ * @compare: For @type == TRACEFS_FILTER_COMPARE, how to compare @field to @val
+ * @val: For @type == TRACEFS_FILTER_COMPARE, what value @field is to be
+ *
+ * This will put together a filter string for the starting event
+ * of @synth. It check to make sure that what is added is correct compared
+ * to the filter that is already built.
+ *
+ * @type can be:
+ *     TRACEFS_FILTER_COMPARE:        See below
+ *     TRACEFS_FILTER_AND:            Append "&&" to the filter
+ *     TRACEFS_FILTER_OR:             Append "||" to the filter
+ *     TRACEFS_FILTER_NOT:            Append "!" to the filter
+ *     TRACEFS_FILTER_OPEN_PAREN:     Append "(" to the filter
+ *     TRACEFS_FILTER_CLOSE_PAREN:    Append ")" to the filter
+ *
+ * For all types except TRACEFS_FILTER_COMPARE, the @field, @compare,
+ * and @val are ignored.
+ *
+ * For @type == TRACEFS_FILTER_COMPARE.
+ *
+ *  @field is the name of the field for the start event to compare.
+ *         If it is not a field for the start event, this return an
+ *         error.
+ *
+ *  @compare can be one of:
+ *     TRACEFS_COMPARE_EQ:       Test @field == @val
+ *     TRACEFS_COMPARE_NE:       Test @field != @val
+ *     TRACEFS_COMPARE_GT:       Test @field > @val
+ *     TRACEFS_COMPARE_GE:       Test @field >= @val
+ *     TRACEFS_COMPARE_LT:       Test @field < @val
+ *     TRACEFS_COMPARE_LE:       Test @field <= @val
+ *     TRACEFS_COMPARE_RE:       Test @field ~ @val
+ *     TRACEFS_COMPARE_AND:      Test @field & @val
+ *
+ * If the @field is of type string, and @compare is not
+ *   TRACEFS_COMPARE_EQ, TRACEFS_COMPARE_NE or TRACEFS_COMPARE_RE,
+ *   then this will return an error.
+ *
+ * Various other checks are made, for instance, if more CLOSE_PARENs
+ * are added than existing OPEN_PARENs. Or if AND is added after an
+ * OPEN_PAREN or another AND or an OR or a NOT.
+ *
+ * Returns 0 on success and -1 on failure.
+ */
 int tracefs_synth_append_start_filter(struct tracefs_synth *synth,
 				      enum tracefs_filter type,
 				      const char *field,
@@ -1366,6 +1424,17 @@ int tracefs_synth_append_start_filter(struct tracefs_synth *synth,
 				   type, field, compare, val);
 }
 
+/**
+ * tracefs_synth_append_end_filter - create or append a filter
+ * @synth: The tracefs_synth descriptor
+ * @type: The type of element to add to the filter
+ * @field: For @type == TRACEFS_FILTER_COMPARE, the field to compare
+ * @compare: For @type == TRACEFS_FILTER_COMPARE, how to compare @field to @val
+ * @val: For @type == TRACEFS_FILTER_COMPARE, what value @field is to be
+ *
+ * Performs the same thing as tracefs_synth_append_start_filter() but
+ * for the @synth end event.
+ */
 int tracefs_synth_append_end_filter(struct tracefs_synth *synth,
 				    enum tracefs_filter type,
 				    const char *field,
-- 
2.30.2


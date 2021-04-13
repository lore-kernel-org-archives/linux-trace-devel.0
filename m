Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42117C433B4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 13 Apr 2021 21:14:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20B49611AD
	for <linux-trace-devel@archiver.kernel.org>; Tue, 13 Apr 2021 21:14:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344575AbhDMVOr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 13 Apr 2021 17:14:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:37206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244727AbhDMVOr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 13 Apr 2021 17:14:47 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C740A61176;
        Tue, 13 Apr 2021 21:14:26 +0000 (UTC)
Date:   Tue, 13 Apr 2021 17:14:25 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Yordan Karadzhov <y.karadz@gmail.com>
Subject: trace-cmd report: Update tep_func_repeat_format to match ts
Message-ID: <20210413171425.5879f8c5@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

With the new func_repeats event coming to the kernel, libtraceevent is
adding a way to process that event, and will display the timestamp of the
last function that repeated.

To make sure the displaying of that format matches the displaying of the
timestamps generated, update the tep_func_repeat_format variable to keep it
the same.

As the tep_func_repeat_format is a weak variable in the function plugin of
libtraceevent, it only needs to be defined to update it. Defining the
variable will not limit trace-cmd from using older libtraceevent libraries
that do not yet have this support.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index d962b671..b2c473d1 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -26,6 +26,14 @@
 #include "kbuffer.h"
 #include "list.h"
 
+/*
+ * tep_func_repeat_format is defined as a weak variable in the
+ * libtraceevent library function plugin, to allow applications
+ * to override the format of the timestamp it prints for the
+ * last function that repeated.
+ */
+const char *tep_func_repeat_format;
+
 static struct filter_str {
 	struct filter_str	*next;
 	char			*filter;
@@ -1875,6 +1883,18 @@ void trace_report (int argc, char **argv)
 
 	otype = OUTPUT_NORMAL;
 
+	if (tracecmd_get_flags(handle) & TRACECMD_FL_RAW_TS) {
+		tep_func_repeat_format = "%d";
+	} else if (tracecmd_get_flags(handle) & TRACECMD_FL_IN_USECS) {
+		if (tep_test_flag(tracecmd_get_tep(handle), TEP_NSEC_OUTPUT))
+			tep_func_repeat_format = "%9.1d";
+		else
+			tep_func_repeat_format = "%6.1000d";
+	} else {
+		tep_func_repeat_format = "%12d";
+	}
+
+
 	if (show_stat)
 		otype = OUTPUT_STAT_ONLY;
 	/* yeah yeah, uname overrides stat */

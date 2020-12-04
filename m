Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E973C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Dec 2020 22:02:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D62DD22CA0
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Dec 2020 22:02:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726041AbgLDWCC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 4 Dec 2020 17:02:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:56878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbgLDWCC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Dec 2020 17:02:02 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98CC722CA0
        for <linux-trace-devel@vger.kernel.org>; Fri,  4 Dec 2020 22:01:21 +0000 (UTC)
Date:   Fri, 4 Dec 2020 17:01:19 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Load ftrace events in
 fill_local_events_systems()
Message-ID: <20201204170119.220692d8@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

While writing some code that used tracefs to access the tracefs directory,
and to load the tep events, I found that it was missing the ftrace events. I
enabled the userstacktrace option, but found that the tep handler returned
by tracefs_local_events_system() did not contain any ftrace event, and thus
I could not parse the user_stack events.

This was due to the fill_local_events_systems() checking against the list of
system names returned by tracefs_event_systems(), which returns the names of
all the system directories that have an "enable" file in them. As ftrace
events are special, and the directory is only for parsing purposes (not to
enable events), it was skipped due to the lack of an "enable" file.

Instead, after processing all the systems returned by tracefs_event_systems(),
check if the sys_names is NULL or matches "ftrace", and if it does, add the
ftrace events as well.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracefs-events.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tracefs-events.c b/tracefs-events.c
index a792aeb..e2928d9 100644
--- a/tracefs-events.c
+++ b/tracefs-events.c
@@ -564,6 +564,11 @@ static int fill_local_events_system(const char *tracing_dir,
 		if (ret && parsing_failures)
 			(*parsing_failures)++;
 	}
+
+	/* Include ftrace, as it is excluded for not having "enable" file */
+	if (!sys_names || contains("ftrace", sys_names))
+		load_events(tep, tracing_dir, "ftrace");
+
 	/* always succeed because parsing failures are not critical */
 	ret = 0;
 out:
-- 
2.25.4


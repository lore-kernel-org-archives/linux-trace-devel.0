Return-Path: <SRS0=sbuk=WY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C39C5C3A5A6
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Aug 2019 19:18:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A242A214DA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Aug 2019 19:18:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbfH1TS1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Aug 2019 15:18:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:56098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727020AbfH1TSW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Aug 2019 15:18:22 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BD112341E;
        Wed, 28 Aug 2019 19:18:21 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1i33SW-0007ew-7r; Wed, 28 Aug 2019 15:18:20 -0400
Message-Id: <20190828191820.127233764@goodmis.org>
User-Agent: quilt/0.65
Date:   Wed, 28 Aug 2019 15:05:29 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] tools lib traceevent: Remove unneeded qsort and uses memmove instead
References: <20190828190527.680021737@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

While reading a trace data file that had 100,000s of tasks, the process took
an extremely long time. I profiled it down to add_new_comm(), which was
doing a qsort() call on an array that was pretty much already sorted (all
but the last element. qsort() isn't very efficient when dealing with mostly
sorted arrays, and this definitely showed its issues.

When adding a new task to the task list, instead of using qsort(), do
another bsearch() with a function that will find the element before where
the new task will be inserted in. Then simply shift the rest of the array,
and insert the task where it belongs.

Fixes: f7d82350e597d ("tools/events: Add files to create libtraceevent.a")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-parse.c | 55 ++++++++++++++++++++++++++----
 1 file changed, 49 insertions(+), 6 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 13fd9fdf91e0..3e83636076b2 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -142,6 +142,25 @@ static int cmdline_cmp(const void *a, const void *b)
 	return 0;
 }
 
+/* Looking for where to place the key */
+static int cmdline_slot_cmp(const void *a, const void *b)
+{
+	const struct tep_cmdline *ca = a;
+	const struct tep_cmdline *cb = b;
+	const struct tep_cmdline *cb1 = cb + 1;
+
+	if (ca->pid < cb->pid)
+		return -1;
+
+	if (ca->pid > cb->pid) {
+		if (ca->pid <= cb1->pid)
+			return 0;
+		return 1;
+	}
+
+	return 0;
+}
+
 struct cmdline_list {
 	struct cmdline_list	*next;
 	char			*comm;
@@ -239,6 +258,7 @@ static int add_new_comm(struct tep_handle *tep,
 	struct tep_cmdline *cmdline;
 	struct tep_cmdline key;
 	char *new_comm;
+	int cnt;
 
 	if (!pid)
 		return 0;
@@ -271,18 +291,41 @@ static int add_new_comm(struct tep_handle *tep,
 	}
 	tep->cmdlines = cmdlines;
 
-	cmdlines[tep->cmdline_count].comm = strdup(comm);
-	if (!cmdlines[tep->cmdline_count].comm) {
+	key.comm = strdup(comm);
+	if (!key.comm) {
 		errno = ENOMEM;
 		return -1;
 	}
 
-	cmdlines[tep->cmdline_count].pid = pid;
-		
-	if (cmdlines[tep->cmdline_count].comm)
+	if (!tep->cmdline_count) {
+		/* no entries yet */
+		tep->cmdlines[0] = key;
 		tep->cmdline_count++;
+		return 0;
+	}
 
-	qsort(cmdlines, tep->cmdline_count, sizeof(*cmdlines), cmdline_cmp);
+	/* Now find where we want to store the new cmdline */
+	cmdline = bsearch(&key, tep->cmdlines, tep->cmdline_count - 1,
+			  sizeof(*tep->cmdlines), cmdline_slot_cmp);
+
+	cnt = tep->cmdline_count;
+	if (cmdline) {
+		/* cmdline points to the one before the spot we want */
+		cmdline++;
+		cnt -= cmdline - tep->cmdlines;
+
+	} else {
+		/* The new entry is either before or after the list */
+		if (key.pid > tep->cmdlines[tep->cmdline_count - 1].pid) {
+			tep->cmdlines[tep->cmdline_count++] = key;
+			return 0;
+		}
+		cmdline = &tep->cmdlines[0];
+	}
+	memmove(cmdline + 1, cmdline, (cnt * sizeof(*cmdline)));
+	*cmdline = key;
+
+	tep->cmdline_count++;
 
 	return 0;
 }
-- 
2.20.1



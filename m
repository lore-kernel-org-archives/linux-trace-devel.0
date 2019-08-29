Return-Path: <SRS0=kCFW=WZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A791C3A5A3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Aug 2019 19:02:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 484F522CEA
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Aug 2019 19:02:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728465AbfH2TCY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Aug 2019 15:02:24 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:51565 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728968AbfH2TCU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Aug 2019 15:02:20 -0400
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1i3PgQ-0005IK-2G; Thu, 29 Aug 2019 21:02:10 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id D02FF1C0DE7;
        Thu, 29 Aug 2019 21:02:03 +0200 (CEST)
Date:   Thu, 29 Aug 2019 19:02:03 -0000
From:   "tip-bot2 for Steven Rostedt (VMware)" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/core] tools lib traceevent: Remove unneeded qsort and uses
 memmove instead
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20190828191820.127233764@goodmis.org>
References: <20190828191820.127233764@goodmis.org>
MIME-Version: 1.0
Message-ID: <156710532375.10619.16987688702890392152.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The following commit has been merged into the perf/core branch of tip:

Commit-ID:     301011ba622513cb41ced59973972204e0da2f71
Gitweb:        https://git.kernel.org/tip/301011ba622513cb41ced59973972204e0da2f71
Author:        Steven Rostedt (VMware) <rostedt@goodmis.org>
AuthorDate:    Wed, 28 Aug 2019 15:05:29 -04:00
Committer:     Arnaldo Carvalho de Melo <acme@redhat.com>
CommitterDate: Thu, 29 Aug 2019 08:36:12 -03:00

tools lib traceevent: Remove unneeded qsort and uses memmove instead

While reading a trace data file that had 100,000s of tasks, the process
took an extremely long time. I profiled it down to add_new_comm(), which
was doing a qsort() call on an array that was pretty much already sorted
(all but the last element. qsort() isn't very efficient when dealing
with mostly sorted arrays, and this definitely showed its issues.

When adding a new task to the task list, instead of using qsort(), do
another bsearch() with a function that will find the element before
where the new task will be inserted in. Then simply shift the rest of
the array, and insert the task where it belongs.

Fixes: f7d82350e597d ("tools/events: Add files to create libtraceevent.a")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lkml.kernel.org/r/20190828191820.127233764@goodmis.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c | 55 +++++++++++++++++++++++++----
 1 file changed, 49 insertions(+), 6 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 13fd9fd..3e83636 100644
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

Return-Path: <SRS0=kCFW=WZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94AD3C3A5A7
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Aug 2019 14:41:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6960E233FF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Aug 2019 14:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1567089699;
	bh=Rl4XbFyRViu/USV4WYZjGpFynrzr4r1x2PDJ2aDtMDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Nn4yLin27CfN9UbdpK64pPBRemvlY8qq6OXNOcBMaBYsHGbOdfXSZAQOnMwjBOjTu
	 yylBOzaas8fKy7wGWU6Y+iuxKb+dLVcns+h254Le9EvWH6CZ7RCM/WJOOYYiA1lv+c
	 i1EqSmEucQxJqG3El9nA+78RNtSNbhoGGdv381L8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728256AbfH2Oli (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Aug 2019 10:41:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:45632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728923AbfH2Olh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Aug 2019 10:41:37 -0400
Received: from quaco.ghostprotocols.net (unknown [179.97.35.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0034C2342B;
        Thu, 29 Aug 2019 14:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567089696;
        bh=Rl4XbFyRViu/USV4WYZjGpFynrzr4r1x2PDJ2aDtMDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dJNEn2Eg8+4Sm0DvfORgmUOjLB+ZhJnB5WAspysfZgbS+YuDiCiEw1Uw2tB4rKYBn
         d2BxaHPN2jolA9N07z3lCNDMtaevolCGrLprMYbjgSchSJQC1f3revolCdw+FVZbfG
         iRl1axHCBrc1sl7LN4Qs7PZd30+7HazpzGrB+z3Y=
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Clark Williams <williams@redhat.com>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>,
        linux-trace-devel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 37/37] tools lib traceevent: Remove unneeded qsort and uses memmove instead
Date:   Thu, 29 Aug 2019 11:39:17 -0300
Message-Id: <20190829143917.29745-38-acme@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190829143917.29745-1-acme@kernel.org>
References: <20190829143917.29745-1-acme@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

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
2.21.0


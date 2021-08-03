Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41FF8C43214
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 16:48:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B5DD6109F
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 16:48:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237224AbhHCQs0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Aug 2021 12:48:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:60586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237234AbhHCQsZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Aug 2021 12:48:25 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C26861037;
        Tue,  3 Aug 2021 16:48:14 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mAxaP-002uUs-4H; Tue, 03 Aug 2021 12:48:13 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v2 7/7] libtracefs: Add API tracefs_synth_complete()
Date:   Tue,  3 Aug 2021 12:48:11 -0400
Message-Id: <20210803164811.693731-8-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210803164811.693731-1-rostedt@goodmis.org>
References: <20210803164811.693731-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add tracefs_synth_complete() to tell if the synthetic event is a full
synthetic event (can create a synthetic event) or not, where it has only
enough information to create the starting histogram.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-synth2.txt |  4 ++++
 include/tracefs.h                   |  1 +
 src/tracefs-hist.c                  | 13 +++++++++++++
 3 files changed, 18 insertions(+)

diff --git a/Documentation/libtracefs-synth2.txt b/Documentation/libtracefs-synth2.txt
index 5d34c4f60469..44693b394f29 100644
--- a/Documentation/libtracefs-synth2.txt
+++ b/Documentation/libtracefs-synth2.txt
@@ -17,6 +17,7 @@ int tracefs_synth_destroy(struct tracefs_instance pass:[*]instance,
 			  struct tracefs_synth pass:[*]synth);
 int tracefs_synth_show(struct trace_seq pass:[*]seq, struct tracefs_instance pass:[*]instance,
 		       struct tracefs_synth pass:[*]synth);
+bool tracefs_synth_complete(struct tracefs_synth pass:[*]synth);
 struct tracefs_hist pass:[*]tracefs_synth_get_start_hist(struct tracefs_synth pass:[*]synth);
 
 --
@@ -53,6 +54,9 @@ this may fail as busy.
 the synthetic event in the given _instance_, it will write the echo commands to
 manually create it in the _seq_ given.
 
+*tracefs_synth_complete*() returns true if the synthetic event _synth_ has both
+a starting and ending event.
+
 *tracefs_synth_get_start_hist*() returns a struct tracefs_hist descriptor describing
 the histogram used to create the synthetic event.
 
diff --git a/include/tracefs.h b/include/tracefs.h
index 8148bd57224b..55f82392b004 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -467,6 +467,7 @@ int tracefs_synth_append_end_filter(struct tracefs_synth *synth,
 				    const char *field,
 				    enum tracefs_compare compare,
 				    const char *val);
+bool tracefs_synth_complete(struct tracefs_synth *synth);
 struct tracefs_hist *tracefs_synth_get_start_hist(struct tracefs_synth *synth);
 int tracefs_synth_create(struct tracefs_instance *instance,
 			 struct tracefs_synth *synth);
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 379f75c7de24..305e3e720341 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -1354,6 +1354,19 @@ static int verify_state(struct tracefs_synth *synth)
 	return 0;
 }
 
+/**
+ * tracefs_synth_complete - tell if the tracefs_synth is complete or not
+ * @synth: The synthetic event to get the start hist from.
+ *
+ * Retruns true if the synthetic event @synth has both a start and
+ * end event (ie. a synthetic event, or just a histogram), and
+ * false otherwise.
+ */
+bool tracefs_synth_complete(struct tracefs_synth *synth)
+{
+	return synth && synth->start_event && synth->end_event;
+}
+
 /**
  * tracefs_synth_get_start_hist - Return the histogram of the start event
  * @synth: The synthetic event to get the start hist from.
-- 
2.30.2


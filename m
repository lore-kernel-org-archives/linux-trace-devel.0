Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC7CCC43214
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Aug 2021 02:17:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9D1F61101
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Aug 2021 02:17:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238106AbhHMCR4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Aug 2021 22:17:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:44518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237262AbhHMCRw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Aug 2021 22:17:52 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30A1D610A5;
        Fri, 13 Aug 2021 02:17:26 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mEMlA-003wVs-Qh; Thu, 12 Aug 2021 22:17:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 1/7] libtracefs: Move creating of onmatch handler and trace action into helper functions
Date:   Thu, 12 Aug 2021 22:16:49 -0400
Message-Id: <20210813021655.939819-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210813021655.939819-1-rostedt@goodmis.org>
References: <20210813021655.939819-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Have the creation of the onmatch handler and the trace action both be in
their own helper function. This will help when adding other handlers
like onmax and onchange as well as other actions like snapshot and save.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/tracefs-hist.c | 38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index fefe251995ba..7fffa6cc653d 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -1378,28 +1378,40 @@ static char *create_hist(char **keys, char **vars)
 	return hist;
 }
 
-static char *create_end_hist(struct tracefs_synth *synth)
+static char *create_onmatch(char *hist, struct tracefs_synth *synth)
 {
-	const char *name;
-	char *end_hist;
+	hist = append_string(hist, NULL, ":onmatch(");
+	hist = append_string(hist, NULL, synth->start_event->system);
+	hist = append_string(hist, NULL, ".");
+	hist = append_string(hist, NULL, synth->start_event->name);
+	return append_string(hist, NULL, ")");
+}
+
+static char *create_trace(char *hist, struct tracefs_synth *synth)
+{
+	char *name;
 	int i;
 
-	end_hist = create_hist(synth->end_keys, synth->end_vars);
-	end_hist = append_string(end_hist, NULL, ":onmatch(");
-	end_hist = append_string(end_hist, NULL, synth->start_event->system);
-	end_hist = append_string(end_hist, NULL, ".");
-	end_hist = append_string(end_hist, NULL, synth->start_event->name);
-	end_hist = append_string(end_hist, NULL, ").trace(");
-	end_hist = append_string(end_hist, NULL, synth->name);
+	hist = append_string(hist, NULL, ".trace(");
+	hist = append_string(hist, NULL, synth->name);
 
 	for (i = 0; synth->synthetic_args && synth->synthetic_args[i]; i++) {
 		name = synth->synthetic_args[i];
 
-		end_hist = append_string(end_hist, NULL, ",");
-		end_hist = append_string(end_hist, NULL, name);
+		hist = append_string(hist, NULL, ",");
+		hist = append_string(hist, NULL, name);
 	}
 
-	return append_string(end_hist, NULL, ")");
+	return append_string(hist, NULL, ")");
+}
+
+static char *create_end_hist(struct tracefs_synth *synth)
+{
+	char *end_hist;
+
+	end_hist = create_hist(synth->end_keys, synth->end_vars);
+	end_hist = create_onmatch(end_hist, synth);
+	return create_trace(end_hist, synth);
 }
 
 static char *append_filter(char *hist, char *filter, unsigned int parens)
-- 
2.30.2


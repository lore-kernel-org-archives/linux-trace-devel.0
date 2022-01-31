Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61D34C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 31 Jan 2022 16:36:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380512AbiAaQgs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 31 Jan 2022 11:36:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46956 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349716AbiAaQgs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 31 Jan 2022 11:36:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 623F4608C1
        for <linux-trace-devel@vger.kernel.org>; Mon, 31 Jan 2022 16:36:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1208C340EE;
        Mon, 31 Jan 2022 16:36:47 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nEZfa-00BYap-Ra;
        Mon, 31 Jan 2022 11:36:46 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 3/4] libtracefs: Check README to know if we should do old onmatch format
Date:   Mon, 31 Jan 2022 11:36:41 -0500
Message-Id: <20220131163642.2754485-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220131163642.2754485-1-rostedt@goodmis.org>
References: <20220131163642.2754485-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Older kernels use:

  onmatch(..).synth_event(...)

Where the "synth_event" is the synthetic event that was created. The new
format uses:

  onmatch(..).trace(synth_event,...)

Where it uses the new "trace" command and the synthetic event is the first
parameter.

The tracefs README can determine which format is used. Search the README
and if the string "trace(<synthetic_event>,param list)" is found, then we
know that the kernel uses the new format. Yes, the README in the tracefs
file system *is* an ABI.

Fixes: 7c9000c7495b9 ("libtracefs: Create a way to create a synthetic event")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-hist.c | 38 +++++++++++++++++++++++++++++++++++---
 1 file changed, 35 insertions(+), 3 deletions(-)

diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 622fe5c98c41..ec63b88a0bca 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -674,6 +674,7 @@ struct action {
  * @end_filters: The fields in the end event to record
  * @start_parens: Current parenthesis level for start event
  * @end_parens: Current parenthesis level for end event
+ * @new_format: onmatch().trace(synth_event,..) or onmatch().synth_event(...)
  */
 struct tracefs_synth {
 	struct tracefs_instance *instance;
@@ -702,6 +703,7 @@ struct tracefs_synth {
 	int			*start_type;
 	char			arg_name[16];
 	int			arg_cnt;
+	bool			new_format;
 };
 
  /*
@@ -949,6 +951,26 @@ static int alloc_synthetic_event(struct tracefs_synth *synth)
 	return synth->dyn_event ? 0 : -1;
 }
 
+/*
+ * See if it is onmatch().trace(synth_event,...) or
+ *   onmatch().synth_event(...)
+ */
+static bool has_new_format()
+{
+	char *readme;
+	char *p;
+	int size;
+
+	readme = tracefs_instance_file_read(NULL, "README", &size);
+	if (!readme)
+		return false;
+
+	p = strstr(readme, "trace(<synthetic_event>,param list)");
+	free(readme);
+
+	return p != NULL;
+}
+
 /**
  * tracefs_synth_alloc - create a new tracefs_synth instance
  * @tep: The tep handle that holds the events to work on
@@ -1037,6 +1059,8 @@ struct tracefs_synth *tracefs_synth_alloc(struct tep_handle *tep,
 		synth = NULL;
 	}
 
+	synth->new_format = has_new_format();
+
 	return synth;
 }
 
@@ -1730,13 +1754,21 @@ static char *create_trace(char *hist, struct tracefs_synth *synth)
 	char *name;
 	int i;
 
-	hist = append_string(hist, NULL, ".trace(");
-	hist = append_string(hist, NULL, synth->name);
+	if (synth->new_format) {
+		hist = append_string(hist, NULL, ".trace(");
+		hist = append_string(hist, NULL, synth->name);
+		hist = append_string(hist, NULL, ",");
+	} else {
+		hist = append_string(hist, NULL, ".");
+		hist = append_string(hist, NULL, synth->name);
+		hist = append_string(hist, NULL, "(");
+	}
 
 	for (i = 0; synth->synthetic_args && synth->synthetic_args[i]; i++) {
 		name = synth->synthetic_args[i];
 
-		hist = append_string(hist, NULL, ",");
+		if (i)
+			hist = append_string(hist, NULL, ",");
 		hist = append_string(hist, NULL, name);
 	}
 
-- 
2.33.0


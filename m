Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F259C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  1 Feb 2022 22:29:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236026AbiBAW3U (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 1 Feb 2022 17:29:20 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56546 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234338AbiBAW3T (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 1 Feb 2022 17:29:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5055A60EDB
        for <linux-trace-devel@vger.kernel.org>; Tue,  1 Feb 2022 22:29:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BECEC340EB;
        Tue,  1 Feb 2022 22:29:18 +0000 (UTC)
Date:   Tue, 1 Feb 2022 17:29:17 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Have echo command concatenate
Message-ID: <20220201172917.580b9a4f@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Currently, tracefs_synth_echo_cmd() does a truncate of the file with the
'>'. This can cause issues if the current files have something already in
it, and could even error with EBUSY if the items can not be deleted.

Use the safer concatenate '>>' instead.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-hist.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index e7dd279ae3f9..aec61ad52e72 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -2196,7 +2196,7 @@ int tracefs_synth_echo_cmd(struct trace_seq *seq,
 	if (!path)
 		goto out_free;
 
-	trace_seq_printf(seq, "echo '%s%s%s %s' > %s/%s\n",
+	trace_seq_printf(seq, "echo '%s%s%s %s' >> %s/%s\n",
 			 synth->dyn_event->prefix,
 			 strlen(synth->dyn_event->prefix) ? ":" : "",
 			 synth->dyn_event->event,
@@ -2211,7 +2211,7 @@ int tracefs_synth_echo_cmd(struct trace_seq *seq,
 	if (!hist)
 		goto out_free;
 
-	trace_seq_printf(seq, "echo '%s' > %s/events/%s/%s/trigger\n",
+	trace_seq_printf(seq, "echo '%s' >> %s/events/%s/%s/trigger\n",
 			 hist, path, synth->start_event->system,
 			 synth->start_event->name);
 	free(hist);
@@ -2221,7 +2221,7 @@ int tracefs_synth_echo_cmd(struct trace_seq *seq,
 	if (!hist)
 		goto out_free;
 
-	trace_seq_printf(seq, "echo '%s' > %s/events/%s/%s/trigger\n",
+	trace_seq_printf(seq, "echo '%s' >> %s/events/%s/%s/trigger\n",
 			 hist, path, synth->end_event->system,
 			 synth->end_event->name);
 
-- 
2.33.0


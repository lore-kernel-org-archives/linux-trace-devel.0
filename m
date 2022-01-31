Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72E59C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 31 Jan 2022 16:36:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380523AbiAaQgu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 31 Jan 2022 11:36:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349716AbiAaQgu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 31 Jan 2022 11:36:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED16C061714
        for <linux-trace-devel@vger.kernel.org>; Mon, 31 Jan 2022 08:36:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BAC54B82B88
        for <linux-trace-devel@vger.kernel.org>; Mon, 31 Jan 2022 16:36:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93575C340E8;
        Mon, 31 Jan 2022 16:36:47 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nEZfa-00BYam-Qy;
        Mon, 31 Jan 2022 11:36:46 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/4] libtracefs: Fix tracefs_synth_echo_cmd()
Date:   Mon, 31 Jan 2022 11:36:40 -0500
Message-Id: <20220131163642.2754485-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220131163642.2754485-1-rostedt@goodmis.org>
References: <20220131163642.2754485-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The update to use dynamic_events instead of synthetic_events for echoing
the synthetic event missed out on adding the colon, and made the output
incorrect for the new format.

Fixes: d7c5dbb7a231e ("libtracefs: Use the internal dynamic events API when creating synthetic events")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-hist.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 8d99492c84a7..622fe5c98c41 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -2155,8 +2155,10 @@ int tracefs_synth_echo_cmd(struct trace_seq *seq,
 	if (!path)
 		goto out_free;
 
-	trace_seq_printf(seq, "echo '%s%s %s' > %s/%s\n",
-			 synth->dyn_event->prefix, synth->dyn_event->event,
+	trace_seq_printf(seq, "echo '%s%s%s %s' > %s/%s\n",
+			 synth->dyn_event->prefix,
+			 strlen(synth->dyn_event->prefix) ? ":" : "",
+			 synth->dyn_event->event,
 			 synth->dyn_event->format, path, synth->dyn_event->trace_file);
 
 	tracefs_put_tracing_file(path);
-- 
2.33.0


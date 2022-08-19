Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB75CC28B2B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Aug 2022 02:03:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240319AbiHSCDn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 18 Aug 2022 22:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241413AbiHSCDk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 Aug 2022 22:03:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A37E75723B
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 Aug 2022 19:03:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EF8D6143D
        for <linux-trace-devel@vger.kernel.org>; Fri, 19 Aug 2022 02:03:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9211C433D7;
        Fri, 19 Aug 2022 02:03:38 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1oOrMU-0038Rr-08;
        Thu, 18 Aug 2022 22:03:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/3] libtracefs: Remove double free attempt of new_event in tracefs_synth_echo_cmd()
Date:   Thu, 18 Aug 2022 22:03:48 -0400
Message-Id: <20220819020349.747429-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220819020349.747429-1-rostedt@goodmis.org>
References: <20220819020349.747429-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The "out_free" path frees the synth->dyn_event if new_event is set, but it
is also freed in the success path (that falls through into the out_free
path). The only reason this did not crash is because both cases set the
"synth->dyn_event" to NULL, where the second attempt to free it does
nothing. But this is still a bug.

Fixes: d7c5dbb7a231e ("libtracefs: Use the internal dynamic events API when creating synthetic events")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-hist.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 6f7d657bd404..302b9a75e6ee 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -2311,11 +2311,6 @@ int tracefs_synth_echo_cmd(struct trace_seq *seq,
 			 hist, path, synth->end_event->system,
 			 synth->end_event->name);
 
-	if (new_event) {
-		tracefs_dynevent_free(synth->dyn_event);
-		synth->dyn_event = NULL;
-	}
-
 	ret = 0;
  out_free:
 	free(hist);
-- 
2.35.1


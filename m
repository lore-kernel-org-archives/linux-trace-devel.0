Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 488DEC32774
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Aug 2022 02:03:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236015AbiHSCDo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 18 Aug 2022 22:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243176AbiHSCDn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 Aug 2022 22:03:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B5735AC71
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 Aug 2022 19:03:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D7BFB82557
        for <linux-trace-devel@vger.kernel.org>; Fri, 19 Aug 2022 02:03:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB47DC433B5;
        Fri, 19 Aug 2022 02:03:38 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1oOrMU-0038Ro-04;
        Thu, 18 Aug 2022 22:03:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/3] libtracefs: Fix use after free in tracefs_synth_alloc()
Date:   Thu, 18 Aug 2022 22:03:47 -0400
Message-Id: <20220819020349.747429-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220819020349.747429-1-rostedt@goodmis.org>
References: <20220819020349.747429-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The synth new_format is set after the error condition is checked and the
synth is freed (on error), causing a SIGSEV when that occurs.

Fixes: 74a6754b9e67b ("libtracefs: Check README to know if we should do old onmatch format")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-hist.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 2f12cc471294..6f7d657bd404 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -1091,9 +1091,8 @@ struct tracefs_synth *tracefs_synth_alloc(struct tep_handle *tep,
 	if (!synth->name || !synth->start_keys || !synth->end_keys || ret) {
 		tracefs_synth_free(synth);
 		synth = NULL;
-	}
-
-	synth->new_format = has_new_format();
+	} else
+		synth->new_format = has_new_format();
 
 	return synth;
 }
-- 
2.35.1


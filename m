Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E652C54EE9
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Sep 2022 15:43:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231528AbiIVPnO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Sep 2022 11:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbiIVPnM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Sep 2022 11:43:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0387BFCA64
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 08:43:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BD4263641
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 15:43:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED51CC43147;
        Thu, 22 Sep 2022 15:43:10 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1obON3-00Dztj-2m;
        Thu, 22 Sep 2022 11:44:13 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/2] libtracefs: Add tracefs_u{ret}probe_alloc to generic man page
Date:   Thu, 22 Sep 2022 11:44:12 -0400
Message-Id: <20220922154412.3336173-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220922154412.3336173-1-rostedt@goodmis.org>
References: <20220922154412.3336173-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The functions tracefs_uprobe_alloc()) and tracefs_uretprobe_alloc() were
missing from the generic libtracefs man page. Add them.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs.txt | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index 470813d5cb40..f588ac26f9d4 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -147,11 +147,15 @@ Dynamic event generic APIs:
 Even probes (eprobes):
 	struct tracefs_dynevent pass:[*] *tracefs_eprobe_alloc*(const char pass:[*]_system_, const char pass:[*]_event_, const char pass:[*]_target_system_, const char pass:[*]_target_event_, const char pass:[*]_fetchargs_);
 
-Kprobes and Kretprobes:
+Uprobes, Kprobes and Kretprobes:
 	struct tracefs_dynevent pass:[*] *tracefs_kprobe_alloc*(const char pass:[*]_system_, const char pass:[*]_event_, const char pass:[*]_addr_, const char pass:[*]_format_);
 	struct tracefs_dynevent pass:[*] *tracefs_kretprobe_alloc*(const char pass:[*]_system_, const char pass:[*]_event_, const char pass:[*]_addr_, const char pass:[*]_format_, unsigned int _max_);
 	int *tracefs_kprobe_raw*(const char pass:[*]_system_, const char pass:[*]_event_, const char pass:[*]_addr_, const char pass:[*]_format_);
 	int *tracefs_kretprobe_raw*(const char pass:[*]_system_, const char pass:[*]_event_, const char pass:[*]_addr_, const char pass:[*]_format_);
+	*tracefs_uprobe_alloc*(const char pass:[*]_system_, const char pass:[*]_event_,
+		     const char pass:[*]_file_, unsigned long long _offset_, const char pass:[*]_fetchargs_)
+	*tracefs_uretprobe_alloc*(const char pass:[*]_system_, const char pass:[*]_event_,
+		     const char pass:[*]_file_, unsigned long long _offset_, const char pass:[*]_fetchargs_);
 
 Synthetic events:
 	struct tracefs_synth pass:[*]*tracefs_sql*(struct tep_handle pass:[*]_tep_, const char pass:[*]_name_,
-- 
2.35.1


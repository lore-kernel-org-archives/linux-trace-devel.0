Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 144F5C87FDD
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jun 2023 18:36:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjFGSg5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Jun 2023 14:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232874AbjFGSgu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Jun 2023 14:36:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7249926A3
        for <linux-trace-devel@vger.kernel.org>; Wed,  7 Jun 2023 11:36:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E14863CAE
        for <linux-trace-devel@vger.kernel.org>; Wed,  7 Jun 2023 18:36:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D678C433EF
        for <linux-trace-devel@vger.kernel.org>; Wed,  7 Jun 2023 18:36:30 +0000 (UTC)
Date:   Wed, 7 Jun 2023 14:36:28 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtarcefs doc: Add tracefs_kprobe_destroy() to index man
 page
Message-ID: <20230607143628.64a6da9a@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The "libtracefs" man page needs to have a list of all APIs from all the
other man pages. tracefs_kprobe_destroy() is missing. Add it.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index 1ab7419e6d04..787636a32965 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -174,6 +174,8 @@ Uprobes, Kprobes and Kretprobes:
 		     const char pass:[*]_file_, unsigned long long _offset_, const char pass:[*]_fetchargs_)
 	*tracefs_uretprobe_alloc*(const char pass:[*]_system_, const char pass:[*]_event_,
 		     const char pass:[*]_file_, unsigned long long _offset_, const char pass:[*]_fetchargs_);
+	int *tracefs_kprobe_destroy*(const char pass:[*]_system_, const char pass:[*]_event_,
+			   const char pass:[*]_addr_, const char pass:[*]_format_, bool _force_);
 
 Synthetic events:
 	struct tracefs_synth pass:[*]*tracefs_sql*(struct tep_handle pass:[*]_tep_, const char pass:[*]_name_,
-- 
2.39.2


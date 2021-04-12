Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3C77C433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Apr 2021 14:44:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95B086128E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Apr 2021 14:44:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242763AbhDLOoa convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Apr 2021 10:44:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:59536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238015AbhDLOoI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Apr 2021 10:44:08 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A77660551
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Apr 2021 14:43:50 +0000 (UTC)
Date:   Mon, 12 Apr 2021 10:43:49 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Update tracing_dir in loading mapping files
Message-ID: <20210412104349.4d8f83b8@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From 7209fe6bc43f79cb8d900ddb801050ff20e9b5a0 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Date: Mon, 12 Apr 2021 10:37:49 -0400
Subject: [PATCH] libtracefs: Update tracing_dir in loading mapping files

If tracing_dir is not a path to a tracing dir or simply NULL, then
load_saved_cmdlines() and load_printk_formats() will fail to load any
mappings.

Add a check for tracing_dir in the callers of those functions
(load_mappings() and tracefs_load_cmdlines()) to update tracing_dir to the
appropriate directory.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/tracefs-events.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index 3a6196b..2d90739 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -661,12 +661,27 @@ static void load_mappings(const char *tracing_dir,
 			  struct tep_handle *tep)
 {
 	load_kallsyms(tep);
+
+	/* If there's no tracing_dir no reason to go further */
+	if (!tracing_dir)
+		tracing_dir = tracefs_tracing_dir();
+
+	if (!tracing_dir)
+		return;
+
 	load_saved_cmdlines(tracing_dir, tep, false);
 	load_printk_formats(tracing_dir, tep);
 }
 
 int tracefs_load_cmdlines(const char *tracing_dir, struct tep_handle *tep)
 {
+
+	if (!tracing_dir)
+		tracing_dir = tracefs_tracing_dir();
+
+	if (!tracing_dir)
+		return -1;
+
 	return load_saved_cmdlines(tracing_dir, tep, true);
 }
 
-- 
2.29.2


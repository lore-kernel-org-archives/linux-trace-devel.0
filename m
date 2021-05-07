Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C34BC433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 13:38:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 445FF61019
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 13:38:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237287AbhEGNjv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 7 May 2021 09:39:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237286AbhEGNjv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 7 May 2021 09:39:51 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6F7B61019;
        Fri,  7 May 2021 13:38:50 +0000 (UTC)
Date:   Fri, 7 May 2021 09:38:48 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] kernel-shark: Add check for return of
 ksmodel_get_cpu_front()
Message-ID: <20210507093848.72bf0bed@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

When I loaded two trace.dat files (host and guest), but the mapping of
which host thread is associated to which guest vCPU was missing from the
file, it caused a SEGFAULT. That's because in fillTaskGraph(), the
lamGetPidCPU() calls ksmodule_get_cpu_front() which returns a negative
number and does not set index. But the next line checks data[index] where
index is some random number, and the application crashes.

By checking the return of ksmodule_get_cpu_front(), and if it is negative
do not reference data[index] and just let eFront be nullptr, the
application shows no mapping, but at least it does not crash.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
You can reproduce this with:

   http://rostedt.org/private/trace-no-map.tar.bz2

diff --git a/src/KsPlotTools.cpp b/src/KsPlotTools.cpp
index 225dc34..abef5f8 100644
--- a/src/KsPlotTools.cpp
+++ b/src/KsPlotTools.cpp
@@ -1280,7 +1280,7 @@ void Graph::fillTaskGraph(int sd, int pid)
 						 false,
 						 _collectionPtr,
 						 &index);
-		if (index >= 0)
+		if (cpuFront >= 0 && index >= 0)
 			eFront = _histoPtr->data[index];
 
 		cpuBack = ksmodel_get_cpu_back(_histoPtr, bin,

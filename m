Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39E75C433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Nov 2021 16:17:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1ACF760E8D
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Nov 2021 16:17:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239557AbhKIQTz convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Nov 2021 11:19:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:50620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239499AbhKIQTz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Nov 2021 11:19:55 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF482604D7;
        Tue,  9 Nov 2021 16:17:08 +0000 (UTC)
Date:   Tue, 9 Nov 2021 11:17:07 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: [PATCH] trace-cmd dump: Free frac field of cpus_data
Message-ID: <20211109111707.250adb93@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From 82a8d3e1f66454aabb640f165f4b4f4346cd5bf1 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Date: Tue, 9 Nov 2021 11:09:59 -0500
Subject: [PATCH] trace-cmd dump: Free frac field of cpus_data

Fix the memory leak of the frac field.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
Based on top of:
  https://lore.kernel.org/all/20211014150204.2485499-1-tz.stoyanov@gmail.com/

 tracecmd/trace-dump.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index ed97bd3f..b19ce89a 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -477,6 +477,7 @@ out:
 		free(cpus_data[j].times);
 		free(cpus_data[j].offsets);
 		free(cpus_data[j].scalings);
+		free(cpus_data[j].frac);
 	}
 	free(cpus_data);
 }
-- 
2.31.1


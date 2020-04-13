Return-Path: <SRS0=pFV5=55=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54EFEC2BBC7
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Apr 2020 20:55:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BBE520732
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Apr 2020 20:55:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388526AbgDMUzX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Apr 2020 16:55:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:35718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388620AbgDMUzW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Apr 2020 16:55:22 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7671D20663
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Apr 2020 20:55:22 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jO66z-004Epg-CE
        for linux-trace-devel@vger.kernel.org; Mon, 13 Apr 2020 16:55:21 -0400
Message-Id: <20200413205521.252964374@goodmis.org>
User-Agent: quilt/0.65
Date:   Mon, 13 Apr 2020 16:53:47 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/2] trace-cmd: Fix cut and paste header comment of tracecmd_unpair_peer()
References: <20200413205346.028742220@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The comment describing tracecmd_unpair_peer() is the same as the comment for
tracecmd_pair_peer(). Update it to describe the unpair function.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-input.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index c19aa4005767..50d52f49a8f0 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3233,9 +3233,8 @@ fail:
 }
 
 /**
- * tracecmd_unpair_peer - Link a tracing peer to this handle
+ * tracecmd_unpair_peer - Remove the linked tracing peer of this handle
  * @handle: input handle for the trace.dat file
- * @peer: input handle for the tracing peer
  *
  * When tracing host and one or more guest machines at the same time,
  * guest and host are tracing peers. There is information in both trace
@@ -3244,7 +3243,7 @@ fail:
  * merging the events. When the host is set as a tracing peer to the guest, then
  * the timestamps of guest's events are recalculated to match the host event's time
  *
- * Returns 1, if a peer is already paired, -1 in case of an error or 0 otherwise
+ * This removes any peer that is linked to the  @handle.
  */
 int tracecmd_unpair_peer(struct tracecmd_input *handle)
 {
-- 
2.25.1



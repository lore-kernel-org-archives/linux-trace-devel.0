Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F4ACC4360C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 31 Mar 2021 23:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CAF461077
	for <linux-trace-devel@archiver.kernel.org>; Wed, 31 Mar 2021 23:08:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbhCaXHn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 31 Mar 2021 19:07:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:51094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232109AbhCaXH3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 31 Mar 2021 19:07:29 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3028E61056
        for <linux-trace-devel@vger.kernel.org>; Wed, 31 Mar 2021 23:07:29 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1lRjvs-003g5d-64
        for linux-trace-devel@vger.kernel.org; Wed, 31 Mar 2021 19:07:28 -0400
Message-ID: <20210331230728.042865031@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 31 Mar 2021 19:06:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/3] trace-cmd agent: Clean up tsync_agent_thread() and
 tsync_host_thread()
References: <20210331230610.035418770@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

There's no reason to assign tsync to NULL nor add a typecast to data, as
void pointers naturally can be converted to any type.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-timesync.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index ad73f08f7070..4ed283eb1fb8 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -697,9 +697,8 @@ static int tsync_with_guest(struct tracecmd_time_sync *tsync)
 
 static void *tsync_host_thread(void *data)
 {
-	struct tracecmd_time_sync *tsync = NULL;
+	struct tracecmd_time_sync *tsync = data;
 
-	tsync = (struct tracecmd_time_sync *)data;
 	tsync_with_guest(tsync);
 	tracecmd_msg_handle_close(tsync->msg_handle);
 	tsync->msg_handle = NULL;
@@ -865,11 +864,9 @@ int tracecmd_tsync_with_guest_stop(struct tracecmd_time_sync *tsync)
 
 static void *tsync_agent_thread(void *data)
 {
-	struct tracecmd_time_sync *tsync = NULL;
+	struct tracecmd_time_sync *tsync = data;
 	int sd;
 
-	tsync = (struct tracecmd_time_sync *)data;
-
 	while (true) {
 		sd = accept(tsync->msg_handle->fd, NULL, NULL);
 		if (sd < 0) {
-- 
2.30.1



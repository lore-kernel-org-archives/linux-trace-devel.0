Return-Path: <SRS0=pFV5=55=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CF88C2BBFD
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Apr 2020 20:55:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62E6420732
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Apr 2020 20:55:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388620AbgDMUzY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Apr 2020 16:55:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388621AbgDMUzW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Apr 2020 16:55:22 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9001920732
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Apr 2020 20:55:22 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jO66z-004EqD-Gr
        for linux-trace-devel@vger.kernel.org; Mon, 13 Apr 2020 16:55:21 -0400
Message-Id: <20200413205521.400302580@goodmis.org>
User-Agent: quilt/0.65
Date:   Mon, 13 Apr 2020 16:53:48 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/2] trace-cmd: Make tracecmd_unpair_peer() return void
References: <20200413205346.028742220@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The return value of tracecmd_unpair_peer() is useless. Just make it a void
function call.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/trace-cmd/trace-cmd.h | 2 +-
 lib/trace-cmd/trace-input.c   | 6 ++----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 76fcffaea235..f3c95f3087a2 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -147,7 +147,7 @@ struct tracecmd_input *tracecmd_open_head(const char *file);
 struct tracecmd_input *tracecmd_open_fd(int fd);
 int tracecmd_pair_peer(struct tracecmd_input *handle,
 		       struct tracecmd_input *peer);
-int tracecmd_unpair_peer(struct tracecmd_input *handle);
+void tracecmd_unpair_peer(struct tracecmd_input *handle);
 void tracecmd_ref(struct tracecmd_input *handle);
 void tracecmd_close(struct tracecmd_input *handle);
 int tracecmd_read_headers(struct tracecmd_input *handle);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 50d52f49a8f0..55c3d80a6057 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3245,18 +3245,16 @@ fail:
  *
  * This removes any peer that is linked to the  @handle.
  */
-int tracecmd_unpair_peer(struct tracecmd_input *handle)
+void tracecmd_unpair_peer(struct tracecmd_input *handle)
 {
 	if (!handle)
-		return -1;
+		return;
 
 	if (handle->host.peer_data) {
 		tracecmd_close(handle->host.peer_data);
 		handle->host.peer_data = NULL;
 		tsync_check_enable(handle);
 	}
-
-	return 0;
 }
 
 /**
-- 
2.25.1



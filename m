Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF556C4332F
	for <linux-trace-devel@archiver.kernel.org>; Sun, 22 May 2022 00:39:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239316AbiEVAjn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 21 May 2022 20:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240763AbiEVAjm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 21 May 2022 20:39:42 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9D994665F
        for <linux-trace-devel@vger.kernel.org>; Sat, 21 May 2022 17:39:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4D4E5CE0ADC
        for <linux-trace-devel@vger.kernel.org>; Sun, 22 May 2022 00:39:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9922C385B8;
        Sun, 22 May 2022 00:39:37 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nsZdA-000p8s-RN;
        Sat, 21 May 2022 20:39:36 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 3/4] trace-cmd record: Set the proper role when connected to a proxy
Date:   Sat, 21 May 2022 20:39:34 -0400
Message-Id: <20220522003935.196466-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220522003935.196466-1-rostedt@goodmis.org>
References: <20220522003935.196466-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

When a guest uses trace-cmd record to connect to the agent proxy on the
host, it needs to set its role to "GUEST" when initializing the time
synchronization protocols.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index b43f3272dfc6..ce20402af7c2 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3905,7 +3905,11 @@ static void connect_to_agent(struct common_record_context *ctx,
 			die("Failed to connect to host %s:%u",
 			    instance->name, instance->port);
 	} else {
-		role = TRACECMD_TIME_SYNC_ROLE_HOST;
+		/* If connecting to a proxy, then this is the guest */
+		if (is_proxy(ctx->instance))
+			role = TRACECMD_TIME_SYNC_ROLE_GUEST;
+		else
+			role = TRACECMD_TIME_SYNC_ROLE_HOST;
 		sd = trace_vsock_open(instance->cid, instance->port);
 		if (sd < 0)
 			die("Failed to connect to vsocket @%u:%u",
-- 
2.35.1


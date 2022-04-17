Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 776B2C4332F
	for <linux-trace-devel@archiver.kernel.org>; Sun, 17 Apr 2022 01:20:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbiDQBWi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 16 Apr 2022 21:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231734AbiDQBWh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 16 Apr 2022 21:22:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E5325595
        for <linux-trace-devel@vger.kernel.org>; Sat, 16 Apr 2022 18:20:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2664B80A6C
        for <linux-trace-devel@vger.kernel.org>; Sun, 17 Apr 2022 01:20:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74956C385AB;
        Sun, 17 Apr 2022 01:20:01 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nfta4-004FiS-4d;
        Sat, 16 Apr 2022 21:20:00 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/8] trace-cmd library: Add network roles for time sync
Date:   Sat, 16 Apr 2022 21:19:52 -0400
Message-Id: <20220417011958.1013591-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220417011958.1013591-1-rostedt@goodmis.org>
References: <20220417011958.1013591-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add TRACECMD_TIME_SYNC_ROLE_CLIENT and SERVER to distringuish from
guest/host to client/server.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/include/private/trace-cmd-private.h | 2 ++
 lib/trace-cmd/trace-timesync-ptp.c                | 4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index f68d17bb8e1d..6e7b346cda07 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -480,6 +480,8 @@ enum{
 enum tracecmd_time_sync_role {
 	TRACECMD_TIME_SYNC_ROLE_HOST	= (1 << 0),
 	TRACECMD_TIME_SYNC_ROLE_GUEST	= (1 << 1),
+	TRACECMD_TIME_SYNC_ROLE_CLIENT	= (1 << 2),
+	TRACECMD_TIME_SYNC_ROLE_SERVER	= (1 << 3),
 };
 
 /* Timestamp synchronization flags */
diff --git a/lib/trace-cmd/trace-timesync-ptp.c b/lib/trace-cmd/trace-timesync-ptp.c
index 653d176e2e79..20e6e6f1ab59 100644
--- a/lib/trace-cmd/trace-timesync-ptp.c
+++ b/lib/trace-cmd/trace-timesync-ptp.c
@@ -702,7 +702,9 @@ int ptp_clock_sync_register(void)
 {
 	return tracecmd_tsync_proto_register(PTP_NAME, PTP_ACCURACY,
 					     TRACECMD_TIME_SYNC_ROLE_GUEST |
-					     TRACECMD_TIME_SYNC_ROLE_HOST,
+					     TRACECMD_TIME_SYNC_ROLE_HOST |
+					     TRACECMD_TIME_SYNC_ROLE_CLIENT |
+					     TRACECMD_TIME_SYNC_ROLE_SERVER,
 					     0, TRACECMD_TSYNC_FLAG_INTERPOLATE,
 					     ptp_clock_sync_init,
 					     ptp_clock_sync_free,
-- 
2.35.1


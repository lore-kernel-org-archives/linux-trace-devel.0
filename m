Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19B70C54EBC
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Jan 2023 21:54:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235562AbjAEVxp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 5 Jan 2023 16:53:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235664AbjAEVw6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Jan 2023 16:52:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51093676FB
        for <linux-trace-devel@vger.kernel.org>; Thu,  5 Jan 2023 13:52:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1287FB81C07
        for <linux-trace-devel@vger.kernel.org>; Thu,  5 Jan 2023 21:52:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2AA3C433F1;
        Thu,  5 Jan 2023 21:52:54 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1pDYAP-000wIp-1R;
        Thu, 05 Jan 2023 16:52:53 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/2] libtracefs: Have tracefs_cpu_stop() always suggesting nudging
Date:   Thu,  5 Jan 2023 16:52:52 -0500
Message-Id: <20230105215252.224044-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230105215252.224044-1-rostedt@goodmis.org>
References: <20230105215252.224044-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The man page of tracefs_cpu_stop() states that if it returns 0 that it
guaranteed to wake up a reader. Well, that doesn't appear to always be the
case. Return 1 until we can figure it out.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-record.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/src/tracefs-record.c b/src/tracefs-record.c
index f998883134b8..9baec6780974 100644
--- a/src/tracefs-record.c
+++ b/src/tracefs-record.c
@@ -429,15 +429,11 @@ int tracefs_cpu_stop(struct tracefs_cpu *tcpu)
 		return ret;
 
 	/* Calling ioctl() on recent kernels will wake up the waiters */
-	ret = ioctl(tcpu->fd, 0);
-	if (ret < 0)
-		ret = 1;
-	else
-		ret = 0;
+	ioctl(tcpu->fd, 0);
 
 	set_nonblock(tcpu);
 
-	return ret;
+	return 1;
 }
 
 /**
-- 
2.35.1


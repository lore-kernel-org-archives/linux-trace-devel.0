Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96AF5C433FE
	for <linux-trace-devel@archiver.kernel.org>; Sat, 14 May 2022 02:55:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbiENCz0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 May 2022 22:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbiENCzU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 May 2022 22:55:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD0D34A378
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 May 2022 19:48:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA0CC61E0E
        for <linux-trace-devel@vger.kernel.org>; Sat, 14 May 2022 02:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A65F2C3411E;
        Sat, 14 May 2022 02:47:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nphoz-005XMh-GZ;
        Fri, 13 May 2022 22:47:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 12/26] trace-cmd: Have get_vsocket_params() cid and rcid parameters be optional
Date:   Fri, 13 May 2022 22:47:42 -0400
Message-Id: <20220514024756.1319681-13-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220514024756.1319681-1-rostedt@goodmis.org>
References: <20220514024756.1319681-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

In order to retrieve just the remote cid that the agent proxy will need to
do, make the parameters to get_vsocket_params() optional, where a NULL can
be passed in and it will only update the non-NULL parameters.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-vsock.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/tracecmd/trace-vsock.c b/tracecmd/trace-vsock.c
index 39294e7a2a3c..3bad9efad39a 100644
--- a/tracecmd/trace-vsock.c
+++ b/tracecmd/trace-vsock.c
@@ -76,20 +76,24 @@ int get_vsocket_params(int fd, unsigned int *lcid, unsigned int *rcid)
 	struct sockaddr_vm addr;
 	socklen_t addr_len = sizeof(addr);
 
-	memset(&addr, 0, sizeof(addr));
-	if (getsockname(fd, (struct sockaddr *)&addr, &addr_len))
-		return -1;
-	if (addr.svm_family != AF_VSOCK)
-		return -1;
-	*lcid = addr.svm_cid;
-
-	memset(&addr, 0, sizeof(addr));
-	addr_len = sizeof(addr);
-	if (getpeername(fd, (struct sockaddr *)&addr, &addr_len))
-		return -1;
-	if (addr.svm_family != AF_VSOCK)
-		return -1;
-	*rcid = addr.svm_cid;
+	if (lcid) {
+		memset(&addr, 0, sizeof(addr));
+		if (getsockname(fd, (struct sockaddr *)&addr, &addr_len))
+			return -1;
+		if (addr.svm_family != AF_VSOCK)
+			return -1;
+		*lcid = addr.svm_cid;
+	}
+
+	if (rcid) {
+		memset(&addr, 0, sizeof(addr));
+		addr_len = sizeof(addr);
+		if (getpeername(fd, (struct sockaddr *)&addr, &addr_len))
+			return -1;
+		if (addr.svm_family != AF_VSOCK)
+			return -1;
+		*rcid = addr.svm_cid;
+	}
 
 	return 0;
 }
-- 
2.35.1


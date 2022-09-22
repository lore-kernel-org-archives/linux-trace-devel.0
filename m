Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 934ADC6FA92
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Sep 2022 00:22:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbiIVAWx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 21 Sep 2022 20:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiIVAWw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Sep 2022 20:22:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB699F772
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Sep 2022 17:22:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 387D8B824EE
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 00:22:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DE24C433D7;
        Thu, 22 Sep 2022 00:22:49 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1obA0M-00Dr3I-2a;
        Wed, 21 Sep 2022 20:23:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/3] trace-cmd: Close socket descriptor on failed connection
Date:   Wed, 21 Sep 2022 20:23:47 -0400
Message-Id: <20220922002348.3302169-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220922002348.3302169-1-rostedt@goodmis.org>
References: <20220922002348.3302169-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

In trace_vsock_open(), if the connection fails, the sd file descriptor
still needs to be closed.

Fixes: 76aaeb474 ("trace-cmd: Add VM kernel tracing over vsockets transport")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-vsock.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-vsock.c b/tracecmd/trace-vsock.c
index 3bad9efad39a..baa310f7586b 100644
--- a/tracecmd/trace-vsock.c
+++ b/tracecmd/trace-vsock.c
@@ -19,8 +19,10 @@ int __hidden trace_vsock_open(unsigned int cid, unsigned int port)
 	if (sd < 0)
 		return -errno;
 
-	if (connect(sd, (struct sockaddr *)&addr, sizeof(addr)))
+	if (connect(sd, (struct sockaddr *)&addr, sizeof(addr))) {
+		close(sd);
 		return -errno;
+	}
 
 	return sd;
 }
-- 
2.35.1


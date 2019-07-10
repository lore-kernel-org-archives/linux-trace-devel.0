Return-Path: <SRS0=fQJa=VH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F2C1C74A27
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Jul 2019 13:47:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDEB6214AF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Jul 2019 13:47:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727626AbfGJNr1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Jul 2019 09:47:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:56228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727325AbfGJNr1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Jul 2019 09:47:27 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59EDF2087F;
        Wed, 10 Jul 2019 13:47:26 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1hlCwP-0002p4-Cz; Wed, 10 Jul 2019 09:47:25 -0400
Message-Id: <20190710134725.284088060@goodmis.org>
User-Agent: quilt/0.65
Date:   Wed, 10 Jul 2019 09:46:38 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH 2/4] kernel-shark: Remove the "make install" suggestion for capture errors
References: <20190710134636.116362181@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>

The message is not appropriate, although it is most likely that the
error occurs because the user didn't install KernelShark and it runs
the executable from its build location.

[ Steve: Although I hit this warning without needing a make install ;-) ]

Link: http://lore.kernel.org/linux-trace-devel/20190709155650.2345-7-y.karadz@gmail.com

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
[ Removed "duplicate" print of it as well ]
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel-shark/src/KsMainWindow.cpp | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index 198b410480a1..13b50795340c 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -1179,7 +1179,6 @@ void KsMainWindow::_captureFinished(int ret, QProcess::ExitStatus st)
 		QString message = "Capture process failed:<br>";
 
 		message += capture->errorString();
-		message += "<br>Try doing:<br> sudo make install";
 
 		_error(message, "captureFinishedErr", false, false);
 	}
@@ -1191,8 +1190,6 @@ void KsMainWindow::_captureError(QProcess::ProcessError error)
 	QString message = "Capture process failed:<br>";
 
 	message += capture->errorString();
-	message += "<br>Try doing:<br> sudo make install";
-
 	_error(message, "captureFinishedErr", false, false);
 }
 
-- 
2.20.1



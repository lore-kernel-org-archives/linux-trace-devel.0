Return-Path: <SRS0=fQJa=VH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C858C74A21
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Jul 2019 13:47:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 764CC214AF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Jul 2019 13:47:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbfGJNr1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Jul 2019 09:47:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:56242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727602AbfGJNr0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Jul 2019 09:47:26 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66785208C4;
        Wed, 10 Jul 2019 13:47:26 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1hlCwP-0002pX-Hu; Wed, 10 Jul 2019 09:47:25 -0400
Message-Id: <20190710134725.436998774@goodmis.org>
User-Agent: quilt/0.65
Date:   Wed, 10 Jul 2019 09:46:39 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH 3/4] kernel-shark: Show the standard error of kshark-record
References: <20190710134636.116362181@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

When kshark-record fails, report the standard error which can be very useful
for debugging the issue that when wrong. For example, after removing the
kshark lib functions, instead of just having "Unknow error" print when
kshark-record dialog fails, I now get:

  /usr/local/bin/kshark-record: error while loading shared libraries: libkshark-gui.so.0.9.8: cannot open shared object file: No such file or directory

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel-shark/src/KsMainWindow.cpp | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index 13b50795340c..54aa6d782ad1 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -1179,7 +1179,7 @@ void KsMainWindow::_captureFinished(int ret, QProcess::ExitStatus st)
 		QString message = "Capture process failed:<br>";
 
 		message += capture->errorString();
-
+		message += capture->readAllStandardError();
 		_error(message, "captureFinishedErr", false, false);
 	}
 }
@@ -1190,6 +1190,7 @@ void KsMainWindow::_captureError(QProcess::ProcessError error)
 	QString message = "Capture process failed:<br>";
 
 	message += capture->errorString();
+	message += capture->readAllStandardError();
 	_error(message, "captureFinishedErr", false, false);
 }
 
-- 
2.20.1



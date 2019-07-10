Return-Path: <SRS0=fQJa=VH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 743CEC74A23
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Jul 2019 13:47:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52CBA208E4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Jul 2019 13:47:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727627AbfGJNr1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Jul 2019 09:47:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:56232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727250AbfGJNr0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Jul 2019 09:47:26 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 588122084B;
        Wed, 10 Jul 2019 13:47:26 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1hlCwP-0002oa-8H; Wed, 10 Jul 2019 09:47:25 -0400
Message-Id: <20190710134725.144595473@goodmis.org>
User-Agent: quilt/0.65
Date:   Wed, 10 Jul 2019 09:46:37 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH 1/4] revert: "kernel-shark: Remove a duplicate error message"
References: <20190710134636.116362181@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

It turns out that if the kshark-record dialog does not show up for some
reason, then without this "duplicate" message, the user gets no message at
all to why the dialog did not appear.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel-shark/src/KsMainWindow.cpp | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index 8826cf5cf8b2..198b410480a1 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -1154,9 +1154,35 @@ void KsMainWindow::_captureStarted()
 	_captureLocalServer.listen("KSCapture");
 }
 
+/**
+ * If the authorization could not be obtained because the user dismissed
+ * the authentication dialog (clicked Cancel), pkexec exits with a return
+ * value of 126.
+ */
+#define PKEXEC_DISMISS_RET	126
+
 void KsMainWindow::_captureFinished(int ret, QProcess::ExitStatus st)
 {
+	QProcess *capture = (QProcess *)sender();
+
 	_captureLocalServer.close();
+
+	if (ret == PKEXEC_DISMISS_RET) {
+		/*
+		 * Authorization could not be obtained because the user
+		 * dismissed the authentication dialog.
+		 */
+		return;
+	}
+
+	if (ret != 0 || st != QProcess::NormalExit) {
+		QString message = "Capture process failed:<br>";
+
+		message += capture->errorString();
+		message += "<br>Try doing:<br> sudo make install";
+
+		_error(message, "captureFinishedErr", false, false);
+	}
 }
 
 void KsMainWindow::_captureError(QProcess::ProcessError error)
-- 
2.20.1



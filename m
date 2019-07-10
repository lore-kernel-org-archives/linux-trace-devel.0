Return-Path: <SRS0=fQJa=VH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7F15C74A26
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Jul 2019 13:47:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2AE8208E4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Jul 2019 13:47:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727539AbfGJNr1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Jul 2019 09:47:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:56248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727626AbfGJNr1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Jul 2019 09:47:27 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9633C20651;
        Wed, 10 Jul 2019 13:47:26 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1hlCwP-0002q4-Mm; Wed, 10 Jul 2019 09:47:25 -0400
Message-Id: <20190710134725.599995325@goodmis.org>
User-Agent: quilt/0.65
Date:   Wed, 10 Jul 2019 09:46:40 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH 4/4] kernel-shark: Use <br> for dialog and \n for console error
 messages
References: <20190710134636.116362181@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The Qt dialog boxes require '<br>' to print a new line but consoles require
a '\n'. Instead of printing '<br>' to the console or '\n' to the dialog,
always have the '\n' turn into '<br>' for the dialog and all '<br>' turn
into '\n' for the console.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel-shark/src/KsMainWindow.cpp | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index 54aa6d782ad1..29d44d9a9230 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -1028,10 +1028,12 @@ void KsMainWindow::loadDataFile(const QString& fileName)
 	}
 }
 
-void KsMainWindow::_error(const QString &text, const QString &errCode,
+void KsMainWindow::_error(const QString &mesg, const QString &errCode,
 			  bool resize, bool unloadPlugins)
 {
 	QErrorMessage *em = new QErrorMessage(this);
+	QString text = mesg;
+	QString html = mesg;
 
 	if (resize)
 		_resizeEmpty();
@@ -1039,8 +1041,11 @@ void KsMainWindow::_error(const QString &text, const QString &errCode,
 	if (unloadPlugins)
 		_plugins.unloadAll();
 
+	text.replace("<br>", "\n", Qt::CaseInsensitive);
+	html.replace("\n", "<br>", Qt::CaseInsensitive);
+
 	qCritical().noquote() << "ERROR: " << text;
-	em->showMessage(text, errCode);
+	em->showMessage(html, errCode);
 	em->exec();
 }
 
-- 
2.20.1



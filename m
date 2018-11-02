Return-Path: <SRS0=Mn5y=NN=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:57900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730441AbeKCECF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 3 Nov 2018 00:02:05 -0400
Date: Fri, 2 Nov 2018 14:53:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <y.karadz@gmail.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] kernel-shark-qt: Fix typo in menu "Restor Last Session"
Message-ID: <20181102145347.308c9296@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>


[ Yordan, this is just an FYI that I added this patch ]

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Fix "Restor" to "Restore" in menu option.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel-shark-qt/src/KsMainWindow.cpp | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel-shark-qt/src/KsMainWindow.cpp b/kernel-shark-qt/src/KsMainWindow.cpp
index 4f9a6e2e..871990dd 100644
--- a/kernel-shark-qt/src/KsMainWindow.cpp
+++ b/kernel-shark-qt/src/KsMainWindow.cpp
@@ -43,7 +43,7 @@ KsMainWindow::KsMainWindow(QWidget *parent)
   _capture(this),
   _captureLocalServer(this),
   _openAction("Open", this),
-  _restorSessionAction("Restor Last Session", this),
+  _restorSessionAction("Restore Last Session", this),
   _importSessionAction("Import Session", this),
   _exportSessionAction("Export Sassion", this),
   _quitAction("Quit", this),
-- 
2.13.6

Return-Path: <SRS0=uJAW=VG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13626C73C53
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Jul 2019 15:57:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E026D216C4
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Jul 2019 15:57:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Uh9Kl2hw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726241AbfGIP50 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Jul 2019 11:57:26 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36465 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbfGIP50 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Jul 2019 11:57:26 -0400
Received: by mail-wr1-f68.google.com with SMTP id n4so21653905wrs.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 09 Jul 2019 08:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H/nK5illKgnQiy6dXA6lfChEZ8E9xkUC5KDq1Ibm3nE=;
        b=Uh9Kl2hwYpRRrdHqHIZUkGXlGLfi40hbd3H3Z4/rLhQ2jTjLSRECG6uV9/2/u70nhB
         75P0+PjCh8w76Z9riMPcoA5csB3BC5xZg/o97mUf8I2GtkzCS632VXIQP7uRXg158HAn
         UflYPeINBN289YD0IWHZY1Jz8je0t2MhZ7S81HteIqX1Zb74sBkocdBZgFh9T0JduJNH
         P+ZogL50TJ/7F1xhZyQuLdbOzTxAMsQu5MX9THom/oJ8JybXz2U5b4GySyJ5W8YZmLfo
         FeQVkd4Dz3yMpAI25evfY7gYM8Iq1/tXQfAt4OAO7+nJOdv+6hQfNjqbVdTI2iR39PhE
         lBcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H/nK5illKgnQiy6dXA6lfChEZ8E9xkUC5KDq1Ibm3nE=;
        b=MLhaaMBiXX3l9yoXYSXiNYoafe/8JZkfWyaQLSjboyT8zm3PB5zo8Q0RmXYAtC88GI
         dBLfZ+a9w5/yL7kzUV3M7azu6VfXCurzXvKx2JB2TjhYOj1hBpSshqPD6s2BrhphtWhb
         tgmPMG4MtIQijrde48G0sN3cscps6mdnlchbYutBrsk8S3zEvAVhrSHnVWQmB/AIgSlq
         lwXEMp5wvdBgdxgdRg0PRYTwb3tlifxsRO20da4oFGzpYZWncCJjd6WbE11QGyH+eabe
         9qFQVa9SnSrc0HYhHKRkYfya6J1dt/Q5HP4hstfzmxdYoXzCZLR5vh5aplHXYWQeKBN4
         pPfA==
X-Gm-Message-State: APjAAAUg1PeyDo7CEjIycmn1kNyGA8F0g7bIZV+dSk1Bxl9fLYICyvQe
        WSKyjtLKclNtaez4FL1Qgk4=
X-Google-Smtp-Source: APXvYqycXhh0qDuNdKv+LnunfBz1qs2jyA/0AbyGg8NPSR9gS2LqPs+0vvbNel6aPxECrZxlz59vfw==
X-Received: by 2002:adf:eccd:: with SMTP id s13mr17278838wro.193.1562687844866;
        Tue, 09 Jul 2019 08:57:24 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id v5sm24313746wre.50.2019.07.09.08.57.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 08:57:24 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 4/8] kernel-shark: Don't try to open data file if recording failed
Date:   Tue,  9 Jul 2019 18:56:46 +0300
Message-Id: <20190709155650.2345-5-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190709155650.2345-1-y.karadz@gmail.com>
References: <20190709155650.2345-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In the case when the recording process failed, the Capture dialog should
not send a signal to the KernelShark GUI to open a new tracing data file.

Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsCaptureDialog.cpp | 10 +++++++++-
 kernel-shark/src/KsCaptureDialog.hpp |  2 ++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/kernel-shark/src/KsCaptureDialog.cpp b/kernel-shark/src/KsCaptureDialog.cpp
index 7da6c08..c877094 100644
--- a/kernel-shark/src/KsCaptureDialog.cpp
+++ b/kernel-shark/src/KsCaptureDialog.cpp
@@ -314,6 +314,7 @@ KsCaptureMonitor::KsCaptureMonitor(QWidget *parent)
 : QWidget(parent),
   _mergedChannels(false),
   _argsModified(false),
+  _captureStatus(false),
   _panel(this),
   _name("Output display", this),
   _space("max size ", this),
@@ -448,6 +449,9 @@ void KsCaptureMonitor::_captureFinished(int exit, QProcess::ExitStatus status)
 		_consolOutput.appendPlainText(errMessage);
 
 		QCoreApplication::processEvents();
+		_captureStatus = false;
+	} else {
+		_captureStatus = true;
 	}
 }
 
@@ -531,8 +535,12 @@ void KsCaptureDialog::_setChannelMode(int state)
 
 void KsCaptureDialog::_sendOpenReq(const QString &fileName)
 {
-	QLocalSocket *socket = new QLocalSocket(this);
+	QLocalSocket *socket;
+
+	if (!_captureMon._captureStatus)
+		return;
 
+	socket = new QLocalSocket(this);
 	socket->connectToServer("KSCapture", QIODevice::WriteOnly);
 	if (socket->waitForConnected()) {
 		QByteArray block;
diff --git a/kernel-shark/src/KsCaptureDialog.hpp b/kernel-shark/src/KsCaptureDialog.hpp
index 2265704..b168a2b 100644
--- a/kernel-shark/src/KsCaptureDialog.hpp
+++ b/kernel-shark/src/KsCaptureDialog.hpp
@@ -119,6 +119,8 @@ public:
 	 */
 	bool		_argsModified;
 
+	bool		_captureStatus;
+
 private:
 	QVBoxLayout	_layout;
 
-- 
2.20.1


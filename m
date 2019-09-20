Return-Path: <SRS0=kuh0=XP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F739C4CEC9
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 10:48:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4483A208C0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 10:48:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o7Ni0aQs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408703AbfITKsp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Sep 2019 06:48:45 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45374 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408705AbfITKso (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Sep 2019 06:48:44 -0400
Received: by mail-wr1-f68.google.com with SMTP id r5so6220989wrm.12
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Sep 2019 03:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bmieVqoAI4vnXNAnQZ/eFO/Jqd9blps4NInRwrQZ9KA=;
        b=o7Ni0aQseCTv2BTCZyUOyg5OSodajbmygiKqZdJd607u98pKQ2YSSeQtVOM8PJh6Kd
         V8qZvuDFH/W23eVOCH44uMDFkrpnLAy6iunZhKGzs33cTAxgY4XOcv+tby2GK5yovuy4
         tvXtv5gb7CVLjd3KK9VgaK/olYJj6eiH+7OVAbkv2SoeqrDxcMVoC0cN6wF+Q+4lWiQD
         QEJef8rVBxQTyxkErej+BtvZExFPALF8FIXdDg/22++4fxiNRBZ40zIZsllWSIMiEPhT
         cv64GWB6Esqd06oQxMYCKZ7XJupoiQQRf4DDDgCikjmdCEHhnn+bc1SkuMbTer6Xb0s+
         YlXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bmieVqoAI4vnXNAnQZ/eFO/Jqd9blps4NInRwrQZ9KA=;
        b=AtIY+flWH3RBUHsuz55HEBdXX/wKNa9fGs/RydGiI8eFq/Y6iBBirkm0UpoPu0V4Uv
         py5E0cAYGLYLlboIe9nPs604fUCwqkDVOUVyf6H6iL7glLNgji6zC7fACT/AxI8NSl23
         Br7Wc6tt7k+VDJRrlwn9W/xz6WAE7aV6FU6YENosGjmcQXQG+NleC9MFK9rw7jcU3uym
         BBL4qC7dh/Wmil1V0+aT9SRWeSdBAKFC2ZNOILpdWk5X063AQCpFDdIk3B9/70FsJvKL
         Lo+VcLIAb1oGd7PnF+JVK+w1L2tOBN+ubfgkP7btbcfHa/HIso7Cz9lEkel4qHXU/Nsx
         uGlQ==
X-Gm-Message-State: APjAAAV3TCa2Nxggdgo/G5vRE8HsyV5JFL0uR+3AxBcF1T9IqCEsJhTa
        8Z6IhZOX/dxFtbB6shjmOzY=
X-Google-Smtp-Source: APXvYqz9xYqK4sUbxhghHFnPnDuzr9yEbfFUSOzXaH3zUQ0slcDxSOhsbVS8X/fMQfGh3A4RUAbbuQ==
X-Received: by 2002:a5d:4350:: with SMTP id u16mr10835649wrr.289.1568976522992;
        Fri, 20 Sep 2019 03:48:42 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t14sm1641978wrs.6.2019.09.20.03.48.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2019 03:48:42 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 4/4] kernel-shark: Cleanup in KsCaptureDialog
Date:   Fri, 20 Sep 2019 13:48:31 +0300
Message-Id: <20190920104831.23475-5-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190920104831.23475-1-y.karadz@gmail.com>
References: <20190920104831.23475-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

My original intend was to fix a Doxygen warning complaining about a data
member of a class not being documented. However, when I tried to write
explanation for this data member (KsCaptureMonitor::_captureStatus),
I realized that it is completely useless and that it actually violates
the encapsulation principle, since it holds the return status of the
capture process, but the capture process itself is owned by another
class (KsCaptureDialog).

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsCaptureDialog.cpp | 21 +++++++++++----------
 kernel-shark/src/KsCaptureDialog.hpp |  2 --
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/kernel-shark/src/KsCaptureDialog.cpp b/kernel-shark/src/KsCaptureDialog.cpp
index fff42aa..ad05917 100644
--- a/kernel-shark/src/KsCaptureDialog.cpp
+++ b/kernel-shark/src/KsCaptureDialog.cpp
@@ -385,7 +385,6 @@ KsCaptureMonitor::KsCaptureMonitor(QWidget *parent)
 : QWidget(parent),
   _mergedChannels(false),
   _argsModified(false),
-  _captureStatus(false),
   _panel(this),
   _name("Output display", this),
   _space("max size ", this),
@@ -523,9 +522,6 @@ void KsCaptureMonitor::_captureFinished(int exit, QProcess::ExitStatus status)
 		_consolOutput.appendPlainText(errMessage);
 
 		QCoreApplication::processEvents();
-		_captureStatus = false;
-	} else {
-		_captureStatus = true;
 	}
 }
 
@@ -585,6 +581,17 @@ void KsCaptureDialog::_capture()
 	_captureProc.start();
 	_captureProc.waitForFinished();
 
+	/* Reset the _argsModified flag. */
+	_captureMon._argsModified = false;
+
+	if (_captureProc.exitCode() != 0 ||
+	    _captureProc.exitStatus() != QProcess::NormalExit)
+		return;
+
+	/*
+	 * Capture finished successfully. Open the produced tracing data file
+	 * in KernelShark.
+	 */
 	argc = argv.count();
 	for (int i = 0; i < argc; ++i) {
 		if (argv[i] == "-o") {
@@ -592,9 +599,6 @@ void KsCaptureDialog::_capture()
 			break;
 		}
 	}
-
-	/* Reset the _argsModified flag. */
-	_captureMon._argsModified = false;
 }
 
 void KsCaptureDialog::_setChannelMode(int state)
@@ -610,9 +614,6 @@ void KsCaptureDialog::_sendOpenReq(const QString &fileName)
 {
 	QLocalSocket *socket;
 
-	if (!_captureMon._captureStatus)
-		return;
-
 	socket = new QLocalSocket(this);
 	socket->connectToServer("KSCapture", QIODevice::WriteOnly);
 	if (socket->waitForConnected()) {
diff --git a/kernel-shark/src/KsCaptureDialog.hpp b/kernel-shark/src/KsCaptureDialog.hpp
index 612080c..3fd3d8d 100644
--- a/kernel-shark/src/KsCaptureDialog.hpp
+++ b/kernel-shark/src/KsCaptureDialog.hpp
@@ -141,8 +141,6 @@ public:
 	 */
 	bool		_argsModified;
 
-	bool		_captureStatus;
-
 private:
 	QVBoxLayout	_layout;
 
-- 
2.20.1


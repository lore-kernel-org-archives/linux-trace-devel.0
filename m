Return-Path: <SRS0=87e6=WW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDBB6C3A59F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Aug 2019 15:58:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C45B1217F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Aug 2019 15:58:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rt0SDzkw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731863AbfHZP6k (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Aug 2019 11:58:40 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34859 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730995AbfHZP6j (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Aug 2019 11:58:39 -0400
Received: by mail-wr1-f65.google.com with SMTP id k2so15857513wrq.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Aug 2019 08:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9LzchsrFO+iJC3qHpx3kwMRiGxsuCBQRvPsAQe+kHoM=;
        b=Rt0SDzkw2ZDrYTTNdUGek/3LWziLq1yG5nQVolceGZGef5S0gFrzNAd4yQmhB0AiSF
         U4cpqEzgsxcxxNbheCs1PxBo9aFYsl5SjaFKqwvH8ic5JIM0cKzCoaLxGU7VOecSOJja
         qDc47mnc1qpLYMGJFNNfU/IG7Dfiqu59xjJMzSDA/8/dlrdGu4MZ8S7aHkL7g8zQfXMO
         /fPUqo+NntvbODr8HlcXJ6MIpC+DqKSgbH5Ui8GgFCrBNPyGJQ4OY/p6XSlHfSULeaX0
         6Z1x0Or5d61NdW38eHXKyVRVpSeE2esDo75Zm154SDERsrdy1W+mNzFjsacmiOvFj5MJ
         vyIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9LzchsrFO+iJC3qHpx3kwMRiGxsuCBQRvPsAQe+kHoM=;
        b=liXWKPoBQP2bPFvQC7pJKcWy0/12OqUhlHtUyMEuc8ijUfkyG4xiVGwZ5vLcEGvkpc
         GHr6vXDjkEoWHnWmOeVlUisPoFKuqNyD5Oli4GAY8UwooCdWywjHT57XmykFaMvlNq13
         vsxuNkFDtmANOBW/WiNj/OpDiwEFsJ0ndBDrn5Pg0Xv1cNYC6KfOURDAaCyn3MJQOyce
         xcyqoensFgYVfyh83AWsGwSmEm4B4NG+qbRUGKpJEd0Umkn9ouJDUemSEw5iOqNJrKif
         SKcLbX0yRaHRfKXr7K8oHw9KXcKSrvgHPPnlVq+M/o4RD0gYbxn3J8awvi9ekKh0VpWC
         W73Q==
X-Gm-Message-State: APjAAAWkvurothi01tJsy5Rfc+HCwWHM1MG0jHnG1QD6pXZHGEIPQysp
        /cipKqDVlhtb1HSA1P4KIOw=
X-Google-Smtp-Source: APXvYqxInu91jLNX5yo4C/BTmbg3PpzXktP3824vKafCRY+GpdA30Ltn/yxINhwwmJI/KnwMnRH44A==
X-Received: by 2002:a05:6000:4d:: with SMTP id k13mr23407572wrx.196.1566835117118;
        Mon, 26 Aug 2019 08:58:37 -0700 (PDT)
Received: from localhost.localdomain ([84.40.85.140])
        by smtp.gmail.com with ESMTPSA id p13sm14447458wrw.90.2019.08.26.08.58.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 08:58:36 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, mike.auty@gmail.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 2/5] kernel-shark: Don't use pkexec when running as Root
Date:   Mon, 26 Aug 2019 18:58:08 +0300
Message-Id: <20190826155811.32021-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190826155811.32021-1-y.karadz@gmail.com>
References: <20190826155811.32021-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

If KernelShark GUI has been started as Root we do not need to use
"pkexec" when starting the Record dialog. Note that the actual place
where "pkexec" gets used is in the script "kshark-su-record".

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsMainWindow.cpp | 47 +++++++++++++++++++++----------
 1 file changed, 32 insertions(+), 15 deletions(-)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index 2f86517..7c18391 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -883,23 +883,26 @@ void KsMainWindow::_pluginAdd()
 
 void KsMainWindow::_record()
 {
-#ifndef DO_AS_ROOT
+	bool canDoAsRoot(false);
 
-	QErrorMessage *em = new QErrorMessage(this);
-	QString message;
-
-	message = "Record is currently not supported.";
-	message += " Install \"pkexec\" and then do:<br>";
-	message += " cd build <br> sudo ./cmake_uninstall.sh <br>";
-	message += " ./cmake_clean.sh <br> cmake .. <br> make <br>";
-	message += " sudo make install";
+#ifdef DO_AS_ROOT
+	canDoAsRoot = true;
+#endif
 
-	em->showMessage(message);
-	qCritical() << "ERROR: " << message;
+	if (geteuid() && !canDoAsRoot) {
+		QErrorMessage *em = new QErrorMessage(this);
+		QString message;
 
-	return;
+		message = "Record is currently not supported.";
+		message += " Install \"pkexec\" and then do:<br>";
+		message += " cd build <br> sudo ./cmake_uninstall.sh <br>";
+		message += " ./cmake_clean.sh <br> cmake .. <br> make <br>";
+		message += " sudo make install";
 
-#endif
+		em->showMessage(message);
+		qCritical() << "ERROR: " << message;
+		return;
+	}
 
 	_capture.start();
 }
@@ -1134,9 +1137,24 @@ void KsMainWindow::loadSession(const QString &fileName)
 
 void KsMainWindow::_initCapture()
 {
+	bool canDoAsRoot(false);
+
 #ifdef DO_AS_ROOT
+	canDoAsRoot = true;
+#endif
+
+	if (geteuid() && !canDoAsRoot)
+		return;
 
-	_capture.setProgram("kshark-su-record");
+	if (geteuid()) {
+		_capture.setProgram("kshark-su-record");
+	} else {
+		QStringList argv;
+
+		_capture.setProgram("kshark-record");
+		argv << QString("-o") << QDir::homePath() + "/trace.dat";
+		_capture.setArguments(argv);
+	}
 
 	connect(&_capture,	&QProcess::started,
 		this,		&KsMainWindow::_captureStarted);
@@ -1155,7 +1173,6 @@ void KsMainWindow::_initCapture()
 	connect(&_captureLocalServer,	&QLocalServer::newConnection,
 		this,			&KsMainWindow::_readSocket);
 
-#endif
 }
 
 void KsMainWindow::_captureStarted()
-- 
2.20.1


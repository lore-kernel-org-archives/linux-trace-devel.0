Return-Path: <SRS0=kuh0=XP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6E69C4CEC9
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 10:29:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CCAE2086A
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 10:29:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JfRDbghd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393456AbfITK3S (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Sep 2019 06:29:18 -0400
Received: from mail-wm1-f52.google.com ([209.85.128.52]:39304 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391893AbfITK3S (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Sep 2019 06:29:18 -0400
Received: by mail-wm1-f52.google.com with SMTP id v17so1752054wml.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Sep 2019 03:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NnjPVnAq8AxeT9/ZMnAyTXdNsMz9YLjzDPB+FZ1OuwY=;
        b=JfRDbghd4feNgBV0BwflwkBIXTZtWm62U/utX9FzH76DyMY4Aa75XxT9lpMwPPFspL
         w2FWAkYJyvVdJxYALqA0a/vXyjf0Z5cvb0KcMeNLGJ94sZHQgYLaBEi5ZjaTQCD5kEd9
         0XI9ijLNCS2bOkXfdl7eR4PlPqgYNGeTStxGPDZBxlJLEvCNdX1dvLfdSuaqaMwsWFkZ
         sMOkehiUJhrDP2RiVxeh8jaTWpaZAEaecqkOLCCYEU92IcuAYx76+uUJBoT7RwJ/zPwA
         rlIBpXm9pBSb93y59X6wi3qE6kkwAReTG512z2KEN7kUVv1DhNiMRXGMmgw20LbdVYT+
         lY5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NnjPVnAq8AxeT9/ZMnAyTXdNsMz9YLjzDPB+FZ1OuwY=;
        b=I5Xln338HgVjc0m3xyxJRHlpNgBUl39nTm5csZShrq0hL4vhaHXZKaB2wpZlPkz4E8
         090NifIeUWzFpVwUMDC34pbJyL1y3ZzG+BsiDYScAbg3zJtmt30O9CWOShZus6ooA/ue
         SMbVbyk6/dir1aJtGkHy8L9vEEyLljEhNpVQfloTTefvYaVWeiuGiedCEcgxun+O8PYG
         Id/vNYJBVt/PVO0qYgIPuiOfTrhLSMVcuWyvA5CqO1ikgt5y5A8MraJCZVFGEigSNLUt
         r57H9vkd0bt+zPrG0DEX51ACJ1hPDIkPyiBeojsGlC10rFpSguPZFrc3jPfP7cu9UvRn
         t5jg==
X-Gm-Message-State: APjAAAUUduSxrId/PQNMH7yQyfQT/8FEa2RV1+N1nIym6vPRSMyDLdpd
        AyPVHbPpqSETR6HKuBe0KNige7ml
X-Google-Smtp-Source: APXvYqwjl66KcL/oIbW6/jLIB8oovQxF5snrM3xIjesO9ug3gPrO7YvggH8EtNQWcgTb7z/w+8gW+w==
X-Received: by 2002:a05:600c:217:: with SMTP id 23mr3110186wmi.76.1568975356131;
        Fri, 20 Sep 2019 03:29:16 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id k26sm1480136wmj.33.2019.09.20.03.29.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2019 03:29:15 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 2/5] kernel-shark: Don't use pkexec when running as Root
Date:   Fri, 20 Sep 2019 13:28:49 +0300
Message-Id: <20190920102852.22769-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190920102852.22769-1-y.karadz@gmail.com>
References: <20190920102852.22769-1-y.karadz@gmail.com>
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
index 904d682..c220afb 100644
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


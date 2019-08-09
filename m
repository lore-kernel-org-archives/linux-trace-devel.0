Return-Path: <SRS0=Xrzw=WF=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92A20C31E40
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Aug 2019 08:06:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69BFC21783
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Aug 2019 08:06:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eNbDFdiX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbfHIIGr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Aug 2019 04:06:47 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:38770 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405567AbfHIIGr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Aug 2019 04:06:47 -0400
Received: by mail-wr1-f42.google.com with SMTP id g17so97367338wrr.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 09 Aug 2019 01:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GzZW68YpzSYG7VmGJEFcAcop1rM6UBUGQUSzvNjpV+Y=;
        b=eNbDFdiXQdayBeVcTNyBgVF0NDzhoqQP03nqMmXScf/C3LTX1J55zXnLCeHnYm3DGv
         eUdlA0ueZB47BYi05n9y5SmkLEIrEW0tGksMtC4oeujpo9LuijpNCXUVLBygViMBojPa
         MItfXDN6OEEk5SwzrZ9GLJ7BQXV7cfAHnNqdPVehU65a/Mzg98EmUIRYdPbEWeT8wsSd
         /EvQ0BdA6Wx/Gi80UGBOn9COVhpcBd8e3lXj86Ta0FSRQvsdXbUFMgtAMe71XBfJwzuC
         E5WfpAX2wjnqd/Fts1erLQXoCpjCowIM8DPUGM0O6A61H1k2RhhNM/6uYZwgYIqpdzjH
         xU+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GzZW68YpzSYG7VmGJEFcAcop1rM6UBUGQUSzvNjpV+Y=;
        b=uD0xNNslnOXmhPlkj2NkpaIaQZS7kNzxZmUbrhYI9Exc+TW+ZdNlNxQ4wG5OS+ZoUK
         OPcoFYzixf+Zk3GuuTfpdbxo8ITOorW0Ip4lZVa2OAnNzP+PLFtHJF9qGuGiB7iJa5WL
         lTd4S/v8TvZPVXDGBEs7P9ERXfEtbKl5V5kZkhSdzoizSzwD78YX+zyhXo5SB2Iyfq1O
         k9UO8Bcwxb2xY/mnvzmyBZFJvf9c4HUMwa5NfQ8Go+KB9IC8MuD3589pMpwV1RAUtxZW
         ZnI+qzySXIUCu3SlMBZEDRQieqw/Z5+noD7xVRUE0B4k0FHOzZtbXPEuc79a2+D3Vax3
         zomA==
X-Gm-Message-State: APjAAAURTb3Hq/3UJiSmaRrpcKwYjlaOSUAwZeEuYJpqOyNzwgxNA4QB
        F1tMBgsaP/bqSegtrF2EDhY6C6nbwYA=
X-Google-Smtp-Source: APXvYqxcyAJx8zxYy//x7TfX/L2EbmUJc6eaurIKrbv9/oc0Nkq0yWDTP/r5UCQpxtIFeA+3xi6YHA==
X-Received: by 2002:adf:f883:: with SMTP id u3mr22113567wrp.0.1565338004908;
        Fri, 09 Aug 2019 01:06:44 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id q124sm6964302wma.33.2019.08.09.01.06.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 01:06:44 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, mike.auty@gmail.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/3] kernel-shark: Don't use pkexec when running as Root
Date:   Fri,  9 Aug 2019 11:06:22 +0300
Message-Id: <20190809080623.7548-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190809080623.7548-1-y.karadz@gmail.com>
References: <20190809080623.7548-1-y.karadz@gmail.com>
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
index 2560bf8..e9c6d54 100644
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
+		argv << QString("-o ") + QDir::homePath();
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


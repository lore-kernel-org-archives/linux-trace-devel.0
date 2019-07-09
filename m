Return-Path: <SRS0=uJAW=VG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9708FC73C53
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Jul 2019 15:57:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 702E8216C4
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Jul 2019 15:57:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sl9Gv1KX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbfGIP5b (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Jul 2019 11:57:31 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37867 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbfGIP5b (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Jul 2019 11:57:31 -0400
Received: by mail-wr1-f67.google.com with SMTP id n9so12481439wrr.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 09 Jul 2019 08:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jyjy99QwM8/P9RxrZz9xRTDp6gY5k1+hpLrM5MKvJMg=;
        b=sl9Gv1KXMzbYSePBa+XjxzCOvMlhYxL1s0j2Px1KFKlSziO9vdaFENhEqLQaKbq13/
         XmR4mio6/gk7lmtUdOG1EjqypULQOaaMCewbsKhidp+uCbmE4Q9eMKJoh7wT7p2dEoKf
         K7tr7NYg3FMgodRUiwlcU21SpGrKvMeVHao85HrrlwZrqWEaQiNgLrz1UnJvgLIWNlFD
         4ZbOfidBRnU8IgFn9TI/ZgaEfSHhH2obZawmtELsDUI4zXq9bz63B8Ab16IhKhTMGbiV
         URGKDm+No5KL7WpFzFdSz3q3hkJ0dtYFyxuTkdgDIcM4NL0RjkmLXfoe3u2OlW50BRju
         1Kyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jyjy99QwM8/P9RxrZz9xRTDp6gY5k1+hpLrM5MKvJMg=;
        b=b5qpctGuMmlTVl4/2Wu6zCMhiK4n72rFVLb8pXNPIL+zqY9WU86UCDAeoZD0hJtrKM
         PXXU0PrSlljjMemK5WFp1i4YgKGLVj1axwZoEa0gPnjnchQD+Kxmmip+6wojIR4rQqNO
         Bx/TfTQexif9MsT4L0oD+GIfy9Yfw1SLpacYAbtl3VbDig/TqRonK5SWD9i8EfesLUqY
         MuWEut6GSXn/2VG1LtKb3+brkXt5uswepdlZpjhvsHKtI9NNB5Vadeop26TvIFJIOSCP
         Q/qDFhoCUaqTHIIWYJyDM/fUXhYmJAYaEZyzKZjfGPFlL6rBJdBbuN8k+kBvm/LqVQeU
         oXwg==
X-Gm-Message-State: APjAAAX+gmP0c2qzQsSICvAm4AKVKiw6exxcFXAle4KZoUYQyDl3TJDC
        syHNPjA/vFXRgmqGemZR2Rw=
X-Google-Smtp-Source: APXvYqx3ksLNxi388AE6AOfOGB6c1eFEnqRiByS19nC3APHYp3eo0POHVRICUpaEqjrc7HHY/wvO/A==
X-Received: by 2002:adf:f98a:: with SMTP id f10mr798449wrr.250.1562687849009;
        Tue, 09 Jul 2019 08:57:29 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id v5sm24313746wre.50.2019.07.09.08.57.28
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 08:57:28 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 7/8] kernel-shark: Disconnect "capture errors" before closing KernelShark GUI
Date:   Tue,  9 Jul 2019 18:56:49 +0300
Message-Id: <20190709155650.2345-8-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190709155650.2345-1-y.karadz@gmail.com>
References: <20190709155650.2345-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This is done because we do not want to show error messages if the Capture
dialog is not closed.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsMainWindow.cpp | 15 +++++++++++++--
 kernel-shark/src/KsMainWindow.hpp |  2 ++
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index 3f238db..55518a3 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -155,6 +155,16 @@ KsMainWindow::~KsMainWindow()
 
 	_data.clear();
 
+	/*
+	 * Do not show error messages if the "capture" process is still
+	 * running (Capture dialog is not closed).
+	 */
+	if (_capture.state() != QProcess::NotRunning) {
+		disconnect(_captureErrorConnection);
+		_capture.close();
+		_capture.waitForFinished();
+	}
+
 	if (kshark_instance(&kshark_ctx))
 		kshark_free(kshark_ctx);
 }
@@ -1129,8 +1139,9 @@ void KsMainWindow::_initCapture()
 	connect(&_capture,	SIGNAL(finished(int, QProcess::ExitStatus)),
 		this,		SLOT(_captureFinished(int, QProcess::ExitStatus)));
 
-	connect(&_capture,	&QProcess::errorOccurred,
-		this,		&KsMainWindow::_captureError);
+	_captureErrorConnection =
+		connect(&_capture,	&QProcess::errorOccurred,
+			this,		&KsMainWindow::_captureError);
 
 	connect(&_captureLocalServer,	&QLocalServer::newConnection,
 		this,			&KsMainWindow::_readSocket);
diff --git a/kernel-shark/src/KsMainWindow.hpp b/kernel-shark/src/KsMainWindow.hpp
index 22700d9..62e66a0 100644
--- a/kernel-shark/src/KsMainWindow.hpp
+++ b/kernel-shark/src/KsMainWindow.hpp
@@ -159,6 +159,8 @@ private:
 
 	QSettings	_settings;
 
+	QMetaObject::Connection		_captureErrorConnection;
+
 	void _open();
 
 	void _restoreSession();
-- 
2.20.1


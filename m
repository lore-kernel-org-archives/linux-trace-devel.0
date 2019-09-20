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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93F59C49ED7
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 10:29:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A19F2086A
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 10:29:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fH1dp4xn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405917AbfITK3V (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Sep 2019 06:29:21 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:39304 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404388AbfITK3V (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Sep 2019 06:29:21 -0400
Received: by mail-wm1-f44.google.com with SMTP id v17so1752218wml.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Sep 2019 03:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yJCC4kzPAFsdGAW7se3eARl/27wU6U02o704UjS49m0=;
        b=fH1dp4xnnMxMEAGoX2FVsF7Ei507IucxoTb7ahcHDGjkdy/OJJ5vAsQAqRnKwXdMCy
         56EsfCIiJGTmkrN0vD3xkeN66JLz18YS3U5l16+Ni1fexyO25ei6mWoMkTv8OAVAVorS
         qkOgEdxqRq57E2i1C/iBfmTBXB0BWGq0mW8h4yKmbKrs77ufLGjjLDyLDgkF2xtucUl+
         ITqSlrbuXYATXRg7hkRf26mlxoduftDj0+I2YR6Cq4vGT5pdcDPbO0UTHIcZj6Hh8WYc
         ik+gr1Lkfa+hONaviGVLwfufXjYhf8niy07f1sziRTUukTktXrzidZsLy8pNc3eWdvB6
         F66g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yJCC4kzPAFsdGAW7se3eARl/27wU6U02o704UjS49m0=;
        b=qE284Ed0uyTYbDkgw51d1za4NyIz3TfKz5+ezg5w6QBIpdH+eykHFqQtPq/ohMmwiA
         hMNw666okldpTl3vooiTk3iAciIGcKOf7aPwb/wvxSszJCWGJq0Jrwb9svW+gmuCCvJC
         FjQ3hL/YRw3ChkpLB+C673Gk3ODDFk5DwLnwsJgClWkCWonzjHsZU2xLwtAzYU+f1N6t
         5PggmPGmndoFC2kVtJECm0gRN0pDCLworiuPV0EgUh65/QXb/pVSYZfv+vEnBfNnu5ci
         9M8MUZYh45I/dba8ulWTDom2h9bKQ9eXQypZz8/zvU+4LQElj0E8mOgWdnXO8TrWQqLT
         YMEw==
X-Gm-Message-State: APjAAAX+2SdapFtvAa8zJEzPJPlz/g2C4XFqvFmoIEAJKrVc3l8kSDXR
        K8PmqN2nq1ZmyLewjMkG4oQ=
X-Google-Smtp-Source: APXvYqxM2FvC6h05PlKKXeePX3CbgdIm/OFB8NpwZpqJuec5rVGnr4g8pNmQLGXgREiqLIIFeXSJvQ==
X-Received: by 2002:a05:600c:2153:: with SMTP id v19mr2997014wml.146.1568975358903;
        Fri, 20 Sep 2019 03:29:18 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id k26sm1480136wmj.33.2019.09.20.03.29.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2019 03:29:18 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 4/5] kernel-shark: Optimize the error messages when "Record" fails to start
Date:   Fri, 20 Sep 2019 13:28:51 +0300
Message-Id: <20190920102852.22769-5-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190920102852.22769-1-y.karadz@gmail.com>
References: <20190920102852.22769-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Removing duplicate code.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsMainWindow.cpp | 14 +++++++-------
 kernel-shark/src/KsMainWindow.hpp |  2 ++
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index e24b0f5..311aa87 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -1199,18 +1199,18 @@ void KsMainWindow::_captureFinished(int ret, QProcess::ExitStatus st)
 		return;
 	}
 
-	if (ret != 0 && st == QProcess::NormalExit) {
-		QString message = "Capture process failed:<br>";
-
-		message += capture->errorString();
-		message += capture->readAllStandardError();
-		_error(message, "captureFinishedErr", false, false);
-	}
+	if (ret != 0 && st == QProcess::NormalExit)
+		_captureErrorMessage(capture);
 }
 
 void KsMainWindow::_captureError(QProcess::ProcessError error)
 {
 	QProcess *capture = (QProcess *)sender();
+	_captureErrorMessage(capture);
+}
+
+void KsMainWindow::_captureErrorMessage(QProcess *capture)
+{
 	QString message = "Capture process failed:<br>";
 
 	message += capture->errorString();
diff --git a/kernel-shark/src/KsMainWindow.hpp b/kernel-shark/src/KsMainWindow.hpp
index 4a7b8ab..eef4f96 100644
--- a/kernel-shark/src/KsMainWindow.hpp
+++ b/kernel-shark/src/KsMainWindow.hpp
@@ -215,6 +215,8 @@ private:
 
 	void _captureError(QProcess::ProcessError error);
 
+	void _captureErrorMessage(QProcess *capture);
+
 	void _readSocket();
 
 	void _splitterMoved(int pos, int index);
-- 
2.20.1


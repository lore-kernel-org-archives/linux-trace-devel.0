Return-Path: <SRS0=onCu=SZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AB62C10F14
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Apr 2019 13:28:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 320C320685
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Apr 2019 13:28:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbfDWN2J (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Apr 2019 09:28:09 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44384 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727458AbfDWN2I (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Apr 2019 09:28:08 -0400
Received: by mail-wr1-f66.google.com with SMTP id c5so11355379wrs.11
        for <linux-trace-devel@vger.kernel.org>; Tue, 23 Apr 2019 06:28:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Bd8/O3nFKfDnlyx4P3RcT9dgrqw31uFQ79XNZXVW2Ko=;
        b=Phxw44u2zcn38pPSgzY5BxNbLsa7Pzv60UjqsgL6F+nzAIUMGey/mXgBpeZ1HuOjRx
         docBX2mFDYZUeIWSY+R65xCBAcyoUPisRvHkoP28ibUG+ssk7Hm2BrBxOdBX0Hd1D4A7
         Z5apGS4RAqgMZYsMoHRIoHIeNcKPWseauv+F3ozFWPl5bPgs1PTINqsVyZqArKwvaz6w
         zEGagqO4b4fmnr9so/0XB7wm5i8rerWFO/yWam8XZADlVB8jbT3Na0Z10krI2Phg/YpJ
         OOVLhjnM+VQb2UcYp1paE3k3mvkPlLe3Bnh7DWeRlvBE558vE3ObCBqNPDtAkoh9ZaNN
         G4pA==
X-Gm-Message-State: APjAAAVlPVXCW9DERIwDlNZUWMUqXQMqT3eO0WXQbQ6LM8aO7Yu8mQ+x
        rYbgXNFQ9+fGmIddhmFW/bYkZUkg
X-Google-Smtp-Source: APXvYqwSBD+5MuEQQp1PVa9pbVhj0CbxkZcdtt3C9c+k7b8qnhCBEnJeMMYIoY8PfUzBFIX4U2z5zw==
X-Received: by 2002:adf:fe02:: with SMTP id n2mr17043237wrr.3.1556026086996;
        Tue, 23 Apr 2019 06:28:06 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id w11sm31222231wre.15.2019.04.23.06.28.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Apr 2019 06:28:06 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        Slavomir Kaslev <kaslevs@vmware.com>
Subject: [PATCH 5/5] kernel-shark: Remember the paths used by the Open-File dialogs.
Date:   Tue, 23 Apr 2019 16:27:41 +0300
Message-Id: <20190423132741.17864-6-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190423132741.17864-1-ykaradzhov@vmware.com>
References: <20190423132741.17864-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The application remember the used file paths across different executions.

Suggested-by: Slavomir Kaslev <kaslevs@vmware.com>
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/KsMainWindow.cpp | 11 ++++++++++-
 kernel-shark/src/KsMainWindow.hpp |  2 ++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index 748bacd..5f326f5 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -67,7 +67,8 @@ KsMainWindow::KsMainWindow(QWidget *parent)
   _fullScreenModeAction("Full Screen Mode", this),
   _aboutAction("About", this),
   _contentsAction("Contents", this),
-  _deselectShortcut(this)
+  _deselectShortcut(this),
+  _settings("kernelshark.org", "Kernel Shark") // organization , application
 {
 	setWindowTitle("Kernel Shark");
 	_createActions();
@@ -126,6 +127,10 @@ KsMainWindow::KsMainWindow(QWidget *parent)
 	connect(&_mState,	&KsDualMarkerSM::deselectB,
 		this,		&KsMainWindow::_deselectB);
 
+	_lastDataFilePath = _settings.value("dataPath").toString();
+	_lastConfFilePath = _settings.value("confPath").toString();
+	_lastPluginFilePath = _settings.value("pluginPath").toString();
+
 	_resizeEmpty();
 }
 
@@ -143,6 +148,10 @@ KsMainWindow::~KsMainWindow()
 					_session.getConfDocPtr());
 	}
 
+	_settings.setValue("dataPath", _lastDataFilePath);
+	_settings.setValue("confPath", _lastConfFilePath);
+	_settings.setValue("pluginPath", _lastPluginFilePath);
+
 	_data.clear();
 
 	if (kshark_instance(&kshark_ctx))
diff --git a/kernel-shark/src/KsMainWindow.hpp b/kernel-shark/src/KsMainWindow.hpp
index 2bf3285..962de2d 100644
--- a/kernel-shark/src/KsMainWindow.hpp
+++ b/kernel-shark/src/KsMainWindow.hpp
@@ -155,6 +155,8 @@ private:
 
 	QString		_lastDataFilePath, _lastConfFilePath, _lastPluginFilePath;
 
+	QSettings	_settings;
+
 	void _open();
 
 	void _restoreSession();
-- 
2.20.1


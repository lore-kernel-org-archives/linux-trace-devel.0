Return-Path: <SRS0=5+qO=TC=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81AAAC43219
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 May 2019 12:47:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59BAE2075E
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 May 2019 12:47:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbfEBMrH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 May 2019 08:47:07 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37984 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbfEBMrH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 May 2019 08:47:07 -0400
Received: by mail-wr1-f67.google.com with SMTP id k16so3179193wrn.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 May 2019 05:47:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i3nTPtDvPWQAiGaNNaCPJbhHy8PTpiKkzlb8KCTSZl8=;
        b=QV3NItv7+MlwxZVzvoS32xrwo7IU5g7QFkCW2e/rlDfvR9NthNzXRTYTNk9WwnDoMr
         BBKhpfchYcGAI0aNHoiRJ9BVETF4WWnKztNQoEG5bzFeQYpxxK7mdWFAmlA6h9iSz1EJ
         q49Cxzb4HRtD9Tw4y1hR79CGvO8MNluqso+Yfydz/nypfvbBdmbz+sxwOShObydOUhi+
         SYWitq5tY39A5QMjsdfqMZhWDVH5omlGsfgWCPu+egRaS4Uc87uwuw3PofwIdBreLiro
         vU0ljwaStwdVetbTh3fM9vBdiEZoWfsZ/1pYAWc0yJEAtARruHVfIn+7nQOfkckMkPSz
         kh5Q==
X-Gm-Message-State: APjAAAVMzHxGOrgyXltgYCwNI9XyFMo1nZx9wtWkZNKl/IyoXlTWsH8J
        hOgTPwI6w69JLY2qd8ajlws=
X-Google-Smtp-Source: APXvYqzbWPLDksOaO14n1oOwWPehVeMW4EL5eZa5/tw6RPZaYhED4XjUYXjeHYCNfIZAKYVD5GxLDQ==
X-Received: by 2002:a5d:4492:: with SMTP id j18mr2515015wrq.212.1556800837820;
        Thu, 02 May 2019 05:40:37 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id d11sm7511008wmb.39.2019.05.02.05.40.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 05:40:37 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        troyengel@gmail.com, Yordan Karadzhov <ykaradzhov@vmware.com>,
        Slavomir Kaslev <kaslevs@vmware.com>
Subject: [PATCH v2 5/8] kernel-shark: Remember the paths used by the Open-File dialogs
Date:   Thu,  2 May 2019 15:40:06 +0300
Message-Id: <20190502124009.32208-6-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190502124009.32208-1-ykaradzhov@vmware.com>
References: <20190502124009.32208-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The application will remember the used file paths across different
executions.

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


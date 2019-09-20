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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D2FAC49ED7
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 10:29:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CA352086A
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 10:29:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Eht0lqe3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393527AbfITK3S (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Sep 2019 06:29:18 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37490 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391072AbfITK3R (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Sep 2019 06:29:17 -0400
Received: by mail-wm1-f67.google.com with SMTP id f16so1761270wmb.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Sep 2019 03:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cNog/Af7FcJZ0a2Orh96TYgiVSDFDnVhu92TyKrWum4=;
        b=Eht0lqe3lMAXLaARx+QwrnhBay4OvLwi2V3NYoR86wIgKgGM/iWs9WPC5bZO6ddYGF
         qP6sve6rEPB/SXWzeMJYTDGpID5r70bSUJH/fsd3Ns8NcpZny8kyG3FvpqLRpcSzz357
         2Sn5uEO3Ku7vSTXTSvcs3HBRm7p5Et8Cx2tWEEwhVc2BxJXwr3kT7Ou4mw+np8sgZMVC
         /G4SKZFWNhdWo6Pqgvq0FZ6IqiPmbIUVU0pcZCRXhMKY9Jmlby94xzwl8Muw/ZpEmIIy
         lhCs1NPh319JdPnHyNBUo0omyWHwr5i228DB4Vebrz4if/r+zFkQtUwAHjlxyUNltHp8
         zRDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cNog/Af7FcJZ0a2Orh96TYgiVSDFDnVhu92TyKrWum4=;
        b=hqvf/ZdEpdTrBjYDBIq9ztEvH39SOvtT5Fnkxd31V5BcLI/9jYJsMZrAiARqEueJwO
         +B3kGC5rXgeVx+bSpSILK+U2MH8FnI/6uniSy49yzA/v/ck3YXslTkaAopwfcq8A7oCr
         aWfXetyK7hlGaXV6odnIGzDAF1ceX+9PBOijCiveGmTo59wHEFzxj7upVQdgpaQZFecr
         EM6IbnCCmaY/MpcpDAtd+hCqJRZ12K2tD6kbk/e5iyW7MMqDTW48z9z9dkA/dN3IKkPd
         xDcN60OSNsVq1v+GLbbN77P1Mj28M3ttPyX1W3xJY0+0wA9bjE5JRzx3Z1jPwOrUWQxu
         6Mxw==
X-Gm-Message-State: APjAAAWEoYeaJXTFDMIDyECgLIY9kfRdyXUB620/qODUHzoKy6q1xQdi
        uEgJColysFDMsOptZApQu8M=
X-Google-Smtp-Source: APXvYqyLwwO/DTnyBlcGtyeKmSqLTtdezUq1HBo7XMuqf0ZLjrZbk3l8L1KChghfSkeROq0bh46hHA==
X-Received: by 2002:a1c:a6ca:: with SMTP id p193mr2880919wme.103.1568975354085;
        Fri, 20 Sep 2019 03:29:14 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id k26sm1480136wmj.33.2019.09.20.03.29.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2019 03:29:13 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 1/5] kernel-shark: Show warning message when running as Root
Date:   Fri, 20 Sep 2019 13:28:48 +0300
Message-Id: <20190920102852.22769-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190920102852.22769-1-y.karadz@gmail.com>
References: <20190920102852.22769-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Running the KernelShark GUI with Root privileges is not recommended due
to security reasons. The user will be allowed to continue on its own risk.

Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204475
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsMainWindow.cpp | 28 ++++++++++++++++++++++++++++
 kernel-shark/src/KsMainWindow.hpp |  2 ++
 2 files changed, 30 insertions(+)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index 6439265..904d682 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -76,6 +76,9 @@ KsMainWindow::KsMainWindow(QWidget *parent)
 	_createMenus();
 	_initCapture();
 
+	if (geteuid() == 0)
+		_rootWarning();
+
 	_splitter.addWidget(&_graph);
 	_splitter.addWidget(&_view);
 	setCentralWidget(&_splitter);
@@ -1271,3 +1274,28 @@ void KsMainWindow::_deselectB()
 	_mState.updateLabels();
 	_graph.glPtr()->model()->update();
 }
+
+void KsMainWindow::_rootWarning()
+{
+	QString cbFlag("noRootWarn");
+
+	if (_settings.value(cbFlag).toBool())
+		return;
+
+	QMessageBox warn;
+	warn.setText("KernelShark is running with Root privileges.");
+	warn.setInformativeText("Continue at your own risk.");
+	warn.setIcon(QMessageBox::Warning);
+	warn.setStandardButtons(QMessageBox::Close);
+
+	QCheckBox cb("Don't show this message again.");
+
+	auto lamCbChec = [&] (int state) {
+		if (state)
+			_settings.setValue(cbFlag, true);
+	};
+
+	connect(&cb, &QCheckBox::stateChanged, lamCbChec);
+	warn.setCheckBox(&cb);
+	warn.exec();
+}
diff --git a/kernel-shark/src/KsMainWindow.hpp b/kernel-shark/src/KsMainWindow.hpp
index 62e66a0..4a7b8ab 100644
--- a/kernel-shark/src/KsMainWindow.hpp
+++ b/kernel-shark/src/KsMainWindow.hpp
@@ -238,6 +238,8 @@ private:
 
 	void _deselectB();
 
+	void _rootWarning();
+
 	void _updateFilterMenu();
 
 	void _filterSyncCBoxUpdate(kshark_context *kshark_ctx);
-- 
2.20.1


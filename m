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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F52AC433FF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Aug 2019 08:06:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 632E120B7C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Aug 2019 08:06:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lpj0+HKv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405612AbfHIIGp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Aug 2019 04:06:45 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53870 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405567AbfHIIGp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Aug 2019 04:06:45 -0400
Received: by mail-wm1-f66.google.com with SMTP id 10so4761706wmp.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 09 Aug 2019 01:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OcRJCWNzuK8DiQkEdzF/yO/qc30Q7ZChtZ7mfMlw4Zw=;
        b=lpj0+HKvT5JnYHKAkLXs1jxeoYXm9mLNyrMk0wINffBuRw2GqGPxsdqWIJx7TlOpu6
         ELMpEeJBRYQcugF3tntbbD06vvzktR03jn8hU/iQ96HdvpgC4G6TPJETZ6sfKk1dlf69
         k5/g0hriCXqqjXR+WFGkWTZYsOcYYV/GgvVyMbpFp2SAM/cw5/JWVc2ox5SahVhYPppc
         5LA8b07wx3iIYFOmwah5kc7PTZqg9GXMWIPmTxWkGFljD9GO+ltDmeXNEmCpif2XOxU0
         S/BX53C5btt0+G2b1fb/CHL6N/dFgd9Q1ktBP2eL1FNV2hwPY4tHUiGA9qR7MjT6J1/G
         M8kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OcRJCWNzuK8DiQkEdzF/yO/qc30Q7ZChtZ7mfMlw4Zw=;
        b=ChUdZ76CLE5hysoNJPIgNmlvDrseEeN035babBU+kzedDtWA3HAJYHYUU0Z3sA4ECz
         6jn4d5qYCdqbbq5fgqvWAwuhy1UZcSAcNQ7w8Z+TO2D0raC0qcM3p66Pw2XJ0QnHEKlK
         0OvCLunD4bXvfuLbX8uH821iD0H4+gexd2JtPhHaQgrO24J2f2j9/416Lm73ZN01rowF
         rSgN0CbnL7wu1qOG3xanQby7xPMEdrKowKaPaQu+iwWkV2SHpFmP31ic3jRvGAzrKkRc
         Yfst7hu3+jcE2PZIpeZ9fhrx7D/srwNF7cR7NTGnhGUWSlVfxon2Osp/YPxB+4XmzHoW
         d+jg==
X-Gm-Message-State: APjAAAWQzImi5bXd0wJYCMH7gvq11WIJF2fUb89wiHtqkxMNHvYZ1i4i
        mlH1+L89f44MNaCyYXRMTe0=
X-Google-Smtp-Source: APXvYqwKtwZeMbdaNsi43qZXLsW4/w4263xZJVF7VRMU5HMLDRccqdb3DYG6yNaDw2+vGS4qff0MTg==
X-Received: by 2002:a05:600c:2549:: with SMTP id e9mr9343959wma.46.1565338003045;
        Fri, 09 Aug 2019 01:06:43 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id q124sm6964302wma.33.2019.08.09.01.06.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 01:06:42 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, mike.auty@gmail.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/3] kernel-shark: Show warning message when running as Root
Date:   Fri,  9 Aug 2019 11:06:21 +0300
Message-Id: <20190809080623.7548-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190809080623.7548-1-y.karadz@gmail.com>
References: <20190809080623.7548-1-y.karadz@gmail.com>
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
index 6439265..2560bf8 100644
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
+	QString cbFlag("noRootWorn");
+
+	if (_settings.value(cbFlag).toBool())
+		return;
+
+	QMessageBox warn;
+	warn.setText("KernelShark will have Root privileges.");
+	warn.setInformativeText("Continue on your one risk.");
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


Return-Path: <SRS0=5+qO=TC=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CBFFC43219
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 May 2019 12:40:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44D0C2075E
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 May 2019 12:40:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbfEBMkl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 May 2019 08:40:41 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41588 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbfEBMkk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 May 2019 08:40:40 -0400
Received: by mail-wr1-f66.google.com with SMTP id c12so3136676wrt.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 May 2019 05:40:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TyZuzO2XXCXgNlhtnNYpL+H13gJK/Nod1539clmwlY0=;
        b=hhgm+dz1KhoCI9WX7PlGkBykvDlboENSi2HTSULktP0aZjc+uQJ7Q4r0Cf92KZG02L
         DCYNn0t94xCRqTl/tyQPgRKcwcMzPMtqUCdYY0OJu0CCGqmkyQ/XDEbJjmaTHev9VscH
         pZJxBtyDKdMy4pR84uTozC6gBIt6ZSOPubSTyS/tqPE6ZQT5Zwvx7JASB8rYpSmwbtHR
         Qf/RraLM9dLndZkw4eHrvBAaSAJh65ShI991vFc/EY1FU4wixV3iPIJGjZduwYnuoeYQ
         ntj3/pWwiEDg8Dr/P9baJDtGXME27kxpIYvA+lepaijfZ4oSiiRiBBbiftMEbD5CE8hX
         NX9A==
X-Gm-Message-State: APjAAAW4sRDJWGcyxVuDnoqjjcvElGfFl3fQOK3lhXg3IBlzXCi3tn53
        yfUkEZRO9ns1CQ+Nap+ceFo=
X-Google-Smtp-Source: APXvYqxsi+ite1UiIMBMQAhYnTzfHgp64Dq7RLAZzcfj7yI2KX7Cp/eFL/HrCYSB0ZWFmi5IE/KkIQ==
X-Received: by 2002:adf:ce0b:: with SMTP id p11mr2496331wrn.196.1556800839167;
        Thu, 02 May 2019 05:40:39 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id d11sm7511008wmb.39.2019.05.02.05.40.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 05:40:38 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        troyengel@gmail.com, Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH v2 6/8] kernel-shark: Add logic for selecting the trace-cmd executable used
Date:   Thu,  2 May 2019 15:40:07 +0300
Message-Id: <20190502124009.32208-7-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190502124009.32208-1-ykaradzhov@vmware.com>
References: <20190502124009.32208-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

If kshark-record has been started from its installation location it will
use the installed version of trace-cmd. Otherwise the trace-cmd executable
found by Cmake when building KernelShark (see FindTraceCmd.cmake) will be
used.

Suggested-by: Troy Engel <troyengel@gmail.com>
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/KsCaptureDialog.cpp | 7 ++++++-
 kernel-shark/src/KsUtils.cpp         | 4 ++--
 kernel-shark/src/KsUtils.hpp         | 2 ++
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/kernel-shark/src/KsCaptureDialog.cpp b/kernel-shark/src/KsCaptureDialog.cpp
index 2976a3b..b107595 100644
--- a/kernel-shark/src/KsCaptureDialog.cpp
+++ b/kernel-shark/src/KsCaptureDialog.cpp
@@ -473,7 +473,7 @@ KsCaptureDialog::KsCaptureDialog(QWidget *parent)
   _captureMon(this),
   _captureProc(this)
 {
-	QString captureExe(TRACECMD_BIN_DIR);
+	QString captureExe;
 
 	this->setWindowTitle("Capture");
 	_layout.addWidget(&_captureCtrl);
@@ -489,6 +489,11 @@ KsCaptureDialog::KsCaptureDialog(QWidget *parent)
 	connect(&_captureCtrl._closeButton,	&QPushButton::pressed,
 		this,				&KsCaptureDialog::close);
 
+	if (KsUtils::isInstalled())
+		captureExe = QString(_INSTALL_PREFIX) + QString("/bin");
+	else
+		captureExe = TRACECMD_BIN_DIR;
+
 	captureExe += "/trace-cmd";
 	_captureProc.setProgram(captureExe);
 
diff --git a/kernel-shark/src/KsUtils.cpp b/kernel-shark/src/KsUtils.cpp
index f62e53a..ee481bf 100644
--- a/kernel-shark/src/KsUtils.cpp
+++ b/kernel-shark/src/KsUtils.cpp
@@ -142,10 +142,10 @@ bool matchCPUVisible(struct kshark_context *kshark_ctx,
  */
 bool isInstalled()
 {
-	QString appPath = QCoreApplication::applicationFilePath();
+	QString appPath = QCoreApplication::applicationDirPath();
 	QString installPath(_INSTALL_PREFIX);
 
-	installPath += "/bin/kernelshark";
+	installPath += "/bin";
 	installPath = QDir::cleanPath(installPath);
 
 	return appPath == installPath;
diff --git a/kernel-shark/src/KsUtils.hpp b/kernel-shark/src/KsUtils.hpp
index 1c87271..b4663da 100644
--- a/kernel-shark/src/KsUtils.hpp
+++ b/kernel-shark/src/KsUtils.hpp
@@ -112,6 +112,8 @@ inline QString Ts2String(int64_t ts, int prec)
 bool matchCPUVisible(struct kshark_context *kshark_ctx,
 			      struct kshark_entry *e, int cpu);
 
+bool isInstalled();
+
 QString getFile(QWidget *parent,
 		const QString &windowName,
 		const QString &filter,
-- 
2.20.1


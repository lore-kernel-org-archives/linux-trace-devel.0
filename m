Return-Path: <SRS0=Pjg+=SU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EA8AC10F0E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Apr 2019 15:22:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6F8C20821
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Apr 2019 15:22:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388922AbfDRPWo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 18 Apr 2019 11:22:44 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40324 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731317AbfDRPWo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 Apr 2019 11:22:44 -0400
Received: by mail-wr1-f66.google.com with SMTP id h4so3436465wre.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 Apr 2019 08:22:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kfZ8wDWoDX973tsE2zKLIIfXEH4WHobMyRbLA/I4f0I=;
        b=jFw5tCtrVVD+wZ9AST6Ir5pAxuFLunuBZe41KJ16gfYwsH2FpOHVRYTRCblToKjBPr
         ix23HghQFkLrQlk/zNiNBqcX/vo9iP5BdeE7G0bwWJYQs1j1L8Yn3cS1MmDDuX3xlTO0
         lSjd8EBsmvxFjYTWQdydII9uG9pJu3tR0X3Om+RVtaZG7NunsSvyHqNwzyVenqr9VM+f
         VVstEJLeH7ATCop+JvecBvimGMvNXM8Uq8RJN+HHBOpY6MnGtyVRKoc6DZadXGWd4WLv
         xQpQ76d7mYqK4Ar4uXSZHXR1BmKh5Ck1bMikXChSX4+ePQuH/d1ASqcpqb7ky/5e9nmb
         YmgQ==
X-Gm-Message-State: APjAAAUlFkKgm/41u1gJDqG2HtJdiZmLcY3zr/NyMaT9c6eltX/cOwTb
        7zuTmnnMl6G0/ICcYosSuHI=
X-Google-Smtp-Source: APXvYqwI+zjs4wTFeb21AAfpxg5x7trleXyoWKKDSDYWZj6CXcEQewXxcoqPrsMlbSPU/J2SmweWEg==
X-Received: by 2002:adf:f14e:: with SMTP id y14mr62482995wro.276.1555600962768;
        Thu, 18 Apr 2019 08:22:42 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id l12sm2543698wrt.31.2019.04.18.08.22.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Apr 2019 08:22:42 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH v2 3/8] kernel-shark: Add logic for the initial path of Open-File dialogs
Date:   Thu, 18 Apr 2019 18:21:41 +0300
Message-Id: <20190418152146.27232-4-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190418152146.27232-1-ykaradzhov@vmware.com>
References: <20190418152146.27232-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

If the application has been started from the source code directory,
all OpenFile dialogs will start there. If the application has been
started from its installation location, all Open File dialogs will
start at ${HOME}.

Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/KsCaptureDialog.cpp |  6 +++---
 kernel-shark/src/KsMainWindow.cpp    | 12 ++++++------
 kernel-shark/src/KsUtils.hpp         | 15 +++++++++++++++
 3 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/kernel-shark/src/KsCaptureDialog.cpp b/kernel-shark/src/KsCaptureDialog.cpp
index 1272c2e..57bf7c7 100644
--- a/kernel-shark/src/KsCaptureDialog.cpp
+++ b/kernel-shark/src/KsCaptureDialog.cpp
@@ -208,7 +208,7 @@ void KsCaptureControl::_importSettings()
 	/* Get the configuration document. */
 	fileName = QFileDialog::getOpenFileName(this,
 						"Import from Filter",
-						KS_DIR,
+						KsUtils::dialogDir(),
 						"Kernel Shark Config files (*.json);;");
 
 	if (fileName.isEmpty())
@@ -259,7 +259,7 @@ void KsCaptureControl::_exportSettings()
 	QString fileName =
 		QFileDialog::getSaveFileName(this,
 					     "Export to File",
-					     KS_DIR,
+					     KsUtils::dialogDir(),
 					     "Kernel Shark Config files (*.json);;");
 
 	if (fileName.isEmpty())
@@ -314,7 +314,7 @@ void KsCaptureControl::_browse()
 	QString fileName =
 		QFileDialog::getSaveFileName(this,
 					     "Save File",
-					     KS_DIR,
+					     KsUtils::dialogDir(),
 					     "trace-cmd files (*.dat);;All files (*)");
 
 	if (!fileName.isEmpty())
diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index cf2db74..80bd019 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -363,7 +363,7 @@ void KsMainWindow::_open()
 	QString fileName =
 		QFileDialog::getOpenFileName(this,
 					     "Open File",
-					     KS_DIR,
+					     KsUtils::dialogDir(),
 					     "trace-cmd files (*.dat);;All files (*)");
 
 	if (!fileName.isEmpty())
@@ -432,7 +432,7 @@ void KsMainWindow::_importSession()
 	QString fileName =
 		QFileDialog::getOpenFileName(this,
 					     "Import Session",
-					     KS_DIR,
+					     KsUtils::dialogDir(),
 					     "Kernel Shark Config files (*.json);;");
 
 	if (fileName.isEmpty())
@@ -463,7 +463,7 @@ void KsMainWindow::_exportSession()
 	QString fileName =
 		QFileDialog::getSaveFileName(this,
 					     "Export Filter",
-					     KS_DIR,
+					     KsUtils::dialogDir(),
 					     "Kernel Shark Config files (*.json);;");
 
 	if (fileName.isEmpty())
@@ -512,7 +512,7 @@ void KsMainWindow::_importFilter()
 	if (!kshark_instance(&kshark_ctx))
 		return;
 
-	fileName = QFileDialog::getOpenFileName(this, "Import Filter", KS_DIR,
+	fileName = QFileDialog::getOpenFileName(this, "Import Filter", KsUtils::dialogDir(),
 						"Kernel Shark Config files (*.json);;");
 
 	if (fileName.isEmpty())
@@ -540,7 +540,7 @@ void KsMainWindow::_exportFilter()
 	if (!kshark_instance(&kshark_ctx))
 		return;
 
-	fileName = QFileDialog::getSaveFileName(this, "Export Filter", KS_DIR,
+	fileName = QFileDialog::getSaveFileName(this, "Export Filter", KsUtils::dialogDir(),
 						"Kernel Shark Config files (*.json);;");
 
 	if (fileName.isEmpty())
@@ -861,7 +861,7 @@ void KsMainWindow::_pluginAdd()
 
 	fileNames =
 		QFileDialog::getOpenFileNames(this, "Add KernelShark plugins",
-					      KS_DIR,
+					      KsUtils::dialogDir(),
 					      "KernelShark Plugins (*.so);;");
 
 	if (fileNames.isEmpty())
diff --git a/kernel-shark/src/KsUtils.hpp b/kernel-shark/src/KsUtils.hpp
index c8b5e88..877c62a 100644
--- a/kernel-shark/src/KsUtils.hpp
+++ b/kernel-shark/src/KsUtils.hpp
@@ -111,6 +111,21 @@ inline QString Ts2String(int64_t ts, int prec)
 
 bool matchCPUVisible(struct kshark_context *kshark_ctx,
 			      struct kshark_entry *e, int cpu);
+
+/**
+ * @brief Get the directory to be used when opening QFileDialog. If the
+ *	  application has been started from the source code directory, all
+ *	  Open File dialogs will start there. If the application has been
+ *	  started from its installation location, all Open File dialogs will
+ *	  start at ${HOME}.
+ */
+inline QString dialogDir()
+{
+	QString path = QCoreApplication::applicationFilePath();
+
+	return (path.contains(KS_DIR)) ? KS_DIR : QDir::homePath();
+}
+
 }; // KsUtils
 
 /** Identifier of the Dual Marker active state. */
-- 
2.19.1


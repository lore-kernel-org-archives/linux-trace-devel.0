Return-Path: <SRS0=Pjg+=SU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59D30C10F0E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Apr 2019 15:22:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3396C20821
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Apr 2019 15:22:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389005AbfDRPWi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 18 Apr 2019 11:22:38 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:53928 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731317AbfDRPWh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 Apr 2019 11:22:37 -0400
Received: by mail-wm1-f46.google.com with SMTP id q16so3195644wmj.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 Apr 2019 08:22:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LUYxWtGb9ls6Eik3Jp8WcctqJ7Usm4mPTm+QUlvksAM=;
        b=KpDMocXI/uzl+DR4JTNEQKNjUHTeYZoFkNCzKNd6+VLAuQWsYVB2xxCr/Vfbs7R9ud
         8a4CfpdXUoAcCtqVqu8SIRA15N8+aAJO7Gyw7wkCxCYP3h/NtjcECaPPCSB7gMFG8d6d
         6Ob6SAj1Ugvo8ENXVmDMs/Ia5PIH4PJSbNnviQCDWkJ7DO8nZOGlf8NJemKd4dsMONcP
         RouFybhYeNYtwY1oPPP9z3jM7SGsgdoncoLPCXEWafH4KaFqoqunL4SQJPdmwPru0Xhm
         AXsh7eaLbJT7qdAkojdkInGbJ4pGUYKHEkx79jl63iKm0XLvae7Mqc/nPAAvlovgZVud
         1UnQ==
X-Gm-Message-State: APjAAAWgCahEgQ1JFfwM3e8MCg9vMH6Z4wNAwjthYtSwkTeEhI+5qg+s
        n5SXQPE0l4JGxhot1pHocPs=
X-Google-Smtp-Source: APXvYqxBgRbGR3Q1GIgBTcevoWIsJ1Zp9sMFk/5/vqPNvGyW9Bt5Yqp91qTA/tBgGgtwQqhOfQEXWg==
X-Received: by 2002:a7b:c155:: with SMTP id z21mr3500377wmi.1.1555600956158;
        Thu, 18 Apr 2019 08:22:36 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id l12sm2543698wrt.31.2019.04.18.08.22.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Apr 2019 08:22:35 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH v2 1/8] kernel-shark: Configuration information in ${HOME}/.cache/kernelshark
Date:   Thu, 18 Apr 2019 18:21:39 +0300
Message-Id: <20190418152146.27232-2-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190418152146.27232-1-ykaradzhov@vmware.com>
References: <20190418152146.27232-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

By default the "Last session" configuration file will be saved in
${HOME}/.cache/kernelshark. If ${HOME}/.cache/kernelshark doesn't exist,
it will be created automatically. The user can select another directory
to be used to store the cached data. This can be done by setting the
environment variable KS_USER_CACHE_DIR. In this case if the path (the
value of KS_USER_CACHE_DIR) doesn't exist the user will be asked before
create it.

Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/KsMainWindow.cpp | 68 +++++++++++++++++++++++++++----
 kernel-shark/src/KsMainWindow.hpp |  4 ++
 2 files changed, 63 insertions(+), 9 deletions(-)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index 7afb721..cf2db74 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -133,13 +133,15 @@ KsMainWindow::KsMainWindow(QWidget *parent)
 KsMainWindow::~KsMainWindow()
 {
 	kshark_context *kshark_ctx(nullptr);
-	QString file = KS_CONF_DIR;
+	QString file = lastSessionFile();
 
-	file += "/lastsession.json";
+	if (!file.isEmpty()) {
+		QByteArray fileBA = file.toLocal8Bit();
 
-	_updateSession();
-	kshark_save_config_file(file.toLocal8Bit().data(),
-				_session.getConfDocPtr());
+		_updateSession();
+		kshark_save_config_file(fileBA.data(),
+					_session.getConfDocPtr());
+	}
 
 	_data.clear();
 
@@ -368,12 +370,60 @@ void KsMainWindow::_open()
 		loadDataFile(fileName);
 }
 
-void KsMainWindow::_restoreSession()
+QString KsMainWindow::_getCacheDir()
+{
+	QString dir;
+
+	auto lamMakePath = [&] (bool ask) {
+		if (ask) {
+			QMessageBox::StandardButton reply;
+			QString err("KernelShark cache directory not found!\n");
+			QString question =
+				QString("Do you want to create %1").arg(dir);
+
+			reply = QMessageBox::question(this, "KernelShark",
+						      err + question,
+						      QMessageBox::Yes |
+						      QMessageBox::No);
+
+			if (reply == QMessageBox::No) {
+				dir.clear();
+				return;
+			}
+		}
+
+		QDir().mkpath(dir);
+	};
+
+	dir = getenv("KS_USER_CACHE_DIR");
+	if (!dir.isEmpty()) {
+		if (!QDir(dir).exists())
+			lamMakePath(true);
+	} else {
+		dir = QString(getpwuid(getuid())->pw_dir) +
+		      "/.cache/kernelshark";
+		if (!QDir(dir).exists())
+			lamMakePath(false);
+	}
+
+	return dir;
+}
+
+/** Get the description file of the last session. */
+QString KsMainWindow::lastSessionFile()
 {
-	QString file = KS_CONF_DIR;
-	file += "/lastsession.json";
+	QString file;
 
-	loadSession(file);
+	file = _getCacheDir();
+	if (!file.isEmpty())
+		file += "/lastsession.json";
+
+	return file;
+}
+
+void KsMainWindow::_restoreSession()
+{
+	loadSession(lastSessionFile());
 	_graph.updateGeom();
 }
 
diff --git a/kernel-shark/src/KsMainWindow.hpp b/kernel-shark/src/KsMainWindow.hpp
index 78cd442..ec6506e 100644
--- a/kernel-shark/src/KsMainWindow.hpp
+++ b/kernel-shark/src/KsMainWindow.hpp
@@ -37,6 +37,8 @@ public:
 
 	void loadSession(const QString &fileName);
 
+	QString lastSessionFile();
+
 	/**
 	 * @brief
 	 *
@@ -230,6 +232,8 @@ private:
 
 	void _filterSyncCBoxUpdate(kshark_context *kshark_ctx);
 
+	QString _getCacheDir();
+
 private slots:
 	void _captureFinished(int, QProcess::ExitStatus);
 };
-- 
2.19.1


Return-Path: <SRS0=Fk9f=SG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E585EC10F0C
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Apr 2019 14:56:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE902205F4
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Apr 2019 14:56:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727353AbfDDO4R (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Apr 2019 10:56:17 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51717 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728842AbfDDO4R (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Apr 2019 10:56:17 -0400
Received: by mail-wm1-f65.google.com with SMTP id 4so3427479wmf.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 04 Apr 2019 07:56:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N2fxE5K/n5DZyLKzJ/jBedsWDoAi6ReXcwlWk3hK6RQ=;
        b=rV4NrkFAnz/pKk/iLVt8rFB9vg7f7dVN0fLqUWqJHYT4oMiiKf4Pn9CANXzO5gFlY5
         GzHPmdiLgbT4V+Jbs0YETfK84GRKFrmLqEVLAaUHBJJ7+FS4w66UjDirj5w2Ki/+d4Gy
         uaJHQcMcRWrMbcXL0AIZT6Wz83+bM927VPF6CzM2BVGcOtYvf/xiB9GgNMcbAkg6NvWz
         WE9z29AijzQQrlfbKvGCMfStONOLEV9hkGc2vACNSd9oIuTdzmrQPwa+N5dGGOn7fIGC
         CU+xkVU66CRKGi3Vzk6UTg06C5tP4kYCrVyhtzDzBmNEJdcMg2aD+kGl0qz0Wo8tLFo1
         GPSg==
X-Gm-Message-State: APjAAAX9f26PYVovO2N5gALLxBhpHJb0z84MiAdulLeNVg6qGEZyoFr+
        5EBHV8Ugg/IudOaK7MSgSLg=
X-Google-Smtp-Source: APXvYqzpOFEQM/3j870A9zWJPwPl0WRCnQ/WKE7r/O1pDFIxu1mwNcZwmcOUVZJCyP8mW0p7ahzTWQ==
X-Received: by 2002:a1c:6c04:: with SMTP id h4mr4480303wmc.135.1554389775783;
        Thu, 04 Apr 2019 07:56:15 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id m13sm21919883wmg.42.2019.04.04.07.56.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Apr 2019 07:56:15 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/4] kernel-shark: Set the configuration cache directory via env. variable
Date:   Thu,  4 Apr 2019 17:56:01 +0300
Message-Id: <20190404145603.13592-3-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190404145603.13592-1-ykaradzhov@vmware.com>
References: <20190404145603.13592-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The environment variable ${KS_USER_CONF_DIR} can be used to specify
the directory where the "Last session" configuration file will be
saved.

Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/KsMainWindow.cpp | 19 +++++++++++++------
 kernel-shark/src/KsMainWindow.hpp |  2 ++
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index d07a89d..39b06d6 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -133,9 +133,8 @@ KsMainWindow::KsMainWindow(QWidget *parent)
 KsMainWindow::~KsMainWindow()
 {
 	kshark_context *kshark_ctx(nullptr);
-	QString file = _KS_CACHE_DIR;
 
-	file += "/lastsession.json";
+	QString file = lastSessionFile();
 
 	_updateSession();
 	kshark_save_config_file(file.toLocal8Bit().data(),
@@ -368,12 +367,20 @@ void KsMainWindow::_open()
 		loadDataFile(fileName);
 }
 
-void KsMainWindow::_restoreSession()
+/** Get the description file of the last session. */
+QString KsMainWindow::lastSessionFile()
 {
-	QString file = _KS_CACHE_DIR;
-	file += "/lastsession.json";
+	const char *file = getenv("KS_USER_CONF_DIR");
+
+	if (!file)
+		file = _KS_CACHE_DIR;
+
+	return QString(file) +  "/lastsession.json";
+}
 
-	loadSession(file);
+void KsMainWindow::_restoreSession()
+{
+	loadSession(lastSessionFile());
 	_graph.updateGeom();
 }
 
diff --git a/kernel-shark/src/KsMainWindow.hpp b/kernel-shark/src/KsMainWindow.hpp
index 78cd442..1ecf2d8 100644
--- a/kernel-shark/src/KsMainWindow.hpp
+++ b/kernel-shark/src/KsMainWindow.hpp
@@ -37,6 +37,8 @@ public:
 
 	void loadSession(const QString &fileName);
 
+	QString lastSessionFile();
+
 	/**
 	 * @brief
 	 *
-- 
2.19.1


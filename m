Return-Path: <SRS0=BXa2=RQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F5F1C43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 15:22:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A86D20643
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 15:22:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbfCMPWx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 11:22:53 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40500 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbfCMPWx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 11:22:53 -0400
Received: by mail-wm1-f65.google.com with SMTP id g20so2278568wmh.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 13 Mar 2019 08:22:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R1tQSLUn2UAHXqEDBQ+rkzOLVKjvtqYATX6BM3OmaZ0=;
        b=RrNwbGR1NzQ7HHQXDBHPVXtCa9X08WksQ86NLt4qbdQ8saVW8Q0ToX/W7CrtbM7Kx9
         JGQZbFbTCFIn7N2rwkyvlIKpVgmUXgeXgLw/dgFL4gvJVi4b6u4QxI3Fs1lVkjR87olb
         Frvp6i94PpcKQOAQQ9uR2pxRSazR3+hb2Vv7rMYP0CENUtO7Bwb0YBxd/EPQpXkPyKxt
         6mfW0UtEcndkxgNF3OXGw+RmLNm4ihOkazAUAqpgEbA4OJpK11OfBkhS4crrKFT1RFcb
         QPZQwWzQzwUQjXkKCAhQ6+RSX4aVGvmfZcrnLTddJDrO+ZQlsctecuDCt1qsXxfn7jG6
         4V5w==
X-Gm-Message-State: APjAAAXkKKvOe3uBkj3DVw4SPhaf8VGUq6Tv8fK7KKojoj4wN0lAL9ZO
        NvuV3CDETIIAgBn0GivO0EY=
X-Google-Smtp-Source: APXvYqz/ZmSZpm/MNasm530Tj75dmOsJCCM/WJJejQZb+eoRGPF1SWhkjtSFeBdqLMydyt4KYvYrIQ==
X-Received: by 2002:a05:600c:2201:: with SMTP id z1mr2716761wml.16.1552490571376;
        Wed, 13 Mar 2019 08:22:51 -0700 (PDT)
Received: from localhost.localdomain ([95.87.198.56])
        by smtp.gmail.com with ESMTPSA id w10sm20775822wrn.32.2019.03.13.08.22.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Mar 2019 08:22:50 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH v2 3/3] kernel-shark: Set the configuration cache directory via env. variable
Date:   Wed, 13 Mar 2019 17:22:20 +0200
Message-Id: <20190313152220.22026-4-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190313152220.22026-1-ykaradzhov@vmware.com>
References: <20190313152220.22026-1-ykaradzhov@vmware.com>
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
 kernel-shark/src/KsMainWindow.cpp | 20 +++++++++++++-------
 kernel-shark/src/KsMainWindow.hpp |  2 ++
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index d832f3f..a92944e 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -133,9 +133,7 @@ KsMainWindow::KsMainWindow(QWidget *parent)
 KsMainWindow::~KsMainWindow()
 {
 	kshark_context *kshark_ctx(nullptr);
-	QString file = KS_CACHE_DIR;
-
-	file += "/lastsession.json";
+	QString file = lastSessionFile();
 
 	_updateSession();
 	kshark_save_config_file(file.toLocal8Bit().data(),
@@ -368,12 +366,20 @@ void KsMainWindow::_open()
 		loadDataFile(fileName);
 }
 
-void KsMainWindow::_restorSession()
+/** Get the description file of the last session. */
+QString KsMainWindow::lastSessionFile()
 {
-	QString file = KS_CACHE_DIR;
-	file += "/lastsession.json";
+	const char *file = getenv("KS_USER_CONF_DIR");
 
-	loadSession(file);
+	if (!file)
+		file = KS_CACHE_DIR;
+
+	return QString(file) +  "/lastsession.json";
+}
+
+void KsMainWindow::_restorSession()
+{
+	loadSession(lastSessionFile());
 	_graph.updateGeom();
 }
 
diff --git a/kernel-shark/src/KsMainWindow.hpp b/kernel-shark/src/KsMainWindow.hpp
index a93382a..c479520 100644
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


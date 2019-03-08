Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53887C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 17:15:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32F0A20851
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 17:15:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbfCHRP2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 12:15:28 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53608 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbfCHRP1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 12:15:27 -0500
Received: by mail-wm1-f67.google.com with SMTP id e74so13220287wmg.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 09:15:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=USNblWiNBIAZkGM3yvr9bbhHNl1m16LZoeASGWKLvN0=;
        b=WoZF1L2Sr1ZTq7FeFiRCKLmwKVzTO81YIFeMmpoHyTZ1aVODoRiUv/YtjB2hDNjCKf
         ocraQvF6gZXb1f4C1sSzNTemXkTlPtV/3rOckOiE6gANTaWEqze8HW2AfItowDKatpNP
         xaln6YmQQagT972b1UcadTCB4KBAT11SpdV3MsHWkBLukSJ9CQ+KOTdv0o4CB/YGEhTw
         AnUa9A3Twxt0HEVim7GpXrSvsIoiygrx3LgHLyUGcFu6vo/C2yDQ+8e9l3iRXsrTYQL5
         A9RNtWZ5MDGWYD97/cAuriTINPtGHkoDoYtfDuQmc/oQJw3bOo68APSvtDtrmBgWQfk/
         vXwQ==
X-Gm-Message-State: APjAAAWboyhXGzvGxXx+3I8XanHnkWSHEhqaYgcMt/kBcA8FrAJqNaeY
        TtUSopUD4vhyt7HAW49qan0mTy3UsIs=
X-Google-Smtp-Source: APXvYqwInCgKKMorGRI49xOJg+IlnnEK/rqzAiaqUQD6pZ+wD2uf48RZNIw4dvN7DDpXjxTtd9wbvw==
X-Received: by 2002:a1c:6042:: with SMTP id u63mr9824915wmb.92.1552065325990;
        Fri, 08 Mar 2019 09:15:25 -0800 (PST)
Received: from localhost.localdomain ([95.87.198.56])
        by smtp.gmail.com with ESMTPSA id 2sm8026978wrg.89.2019.03.08.09.15.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Mar 2019 09:15:25 -0800 (PST)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 3/3] kernel-shark: Set the location of .kshark directory via env. variable
Date:   Fri,  8 Mar 2019 19:15:12 +0200
Message-Id: <20190308171512.15372-4-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190308171512.15372-1-ykaradzhov@vmware.com>
References: <20190308171512.15372-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The environment variable ${KS_CONF_DIR} can be used to specify the
directory where the "Last session" configuration file will be saved.

Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/KsMainWindow.cpp | 19 ++++++++++++-------
 kernel-shark/src/KsMainWindow.hpp |  2 ++
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index 2d61c3f..7f39c14 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -133,9 +133,7 @@ KsMainWindow::KsMainWindow(QWidget *parent)
 KsMainWindow::~KsMainWindow()
 {
 	kshark_context *kshark_ctx(nullptr);
-	QString file = KS_CONF_DIR;
-
-	file += "/lastsession.json";
+	QString file = _getLastSessionFile();
 
 	_updateSession();
 	kshark_save_config_file(file.toLocal8Bit().data(),
@@ -368,12 +366,19 @@ void KsMainWindow::_open()
 		loadDataFile(fileName);
 }
 
-void KsMainWindow::_restorSession()
+QString KsMainWindow::_getLastSessionFile()
 {
-	QString file = KS_CONF_DIR;
-	file += "/lastsession.json";
+	const char *file = getenv("KS_CONF_DIR");
 
-	loadSession(file);
+	if (!file)
+		file = KS_CONF_DIR;
+
+	return QString(file) +  "/lastsession.json";
+}
+
+void KsMainWindow::_restorSession()
+{
+	loadSession(_getLastSessionFile());
 	_graph.updateGeom();
 }
 
diff --git a/kernel-shark/src/KsMainWindow.hpp b/kernel-shark/src/KsMainWindow.hpp
index 0727631..9b7ec6d 100644
--- a/kernel-shark/src/KsMainWindow.hpp
+++ b/kernel-shark/src/KsMainWindow.hpp
@@ -153,6 +153,8 @@ private:
 
 	void _open();
 
+	QString _getLastSessionFile();
+
 	void _restorSession();
 
 	void _importSession();
-- 
2.19.1


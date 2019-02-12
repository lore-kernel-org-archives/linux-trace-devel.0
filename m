Return-Path: <SRS0=4mzf=QT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26570C282CA
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Feb 2019 17:04:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0A3E20700
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Feb 2019 17:04:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729728AbfBLREe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 Feb 2019 12:04:34 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34900 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729700AbfBLREe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 Feb 2019 12:04:34 -0500
Received: by mail-wm1-f66.google.com with SMTP id t200so3855960wmt.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 12 Feb 2019 09:04:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=w750JyhiBEB13QK6qRQxx0rjaaookYP1EMZ1W4rlMFI=;
        b=YVi9bWd0qd8RhmdBSRU3TUgoKaUyHCio1cry1d+TM6mPTJWq+41jDE/JL3i4Dgut4D
         AaGDuJvmZcpPRQrd4xiSNqXLBooii04JOxjMYoNHnVVpBDSzXsvucSV28H9W3SfGvj2L
         Q1enibqDxa7mkYVGJhLhjMijb3GrenW9Pdock7alR7dCoTfRL8wZUWj54G1pWf+rDk2C
         hX/rvSZ3yW2qimWX3NsyUaof6wt19aG0/GhPYrQfpoI2wwIEzgfJzdbYQv9Z3sLouHQ6
         Xbtm6BzNN2DbZo645260gn4mI2KHuRI/DmgE560LjjUFUA+WXvku9QUaaWQAVPoHIlQy
         sgCg==
X-Gm-Message-State: AHQUAuaNmxxihBjXRX83LFxX3Opd88Z45a3//5zAo/74pcpeU6FQkHeI
        920o7frrlMUFipC2TdxbJoI=
X-Google-Smtp-Source: AHgI3IaMCdEQltdsqoOqtUC0q/SuOjgxewJALlFujFxHG5izsgnXQz3BCEVRfhieiSsIwDMQaWafXg==
X-Received: by 2002:a1c:4681:: with SMTP id t123mr3646691wma.24.1549991072421;
        Tue, 12 Feb 2019 09:04:32 -0800 (PST)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id c139sm5579732wmd.13.2019.02.12.09.04.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Feb 2019 09:04:31 -0800 (PST)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 5/5] kernel-shark: Rename the method for deselecting the Active marker.
Date:   Tue, 12 Feb 2019 19:04:02 +0200
Message-Id: <20190212170402.10104-6-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190212170402.10104-1-ykaradzhov@vmware.com>
References: <20190212170402.10104-1-ykaradzhov@vmware.com>
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This method deselects the Active marker regardless of its state (A or B).
The method is renamed in order to avoid confusion with the methods for
deselecting markers A and B.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=202327
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/KsMainWindow.cpp | 8 ++++----
 kernel-shark/src/KsMainWindow.hpp | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index 443b7b0..362b955 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -101,10 +101,10 @@ KsMainWindow::KsMainWindow(QWidget *parent)
 		&_view,		&KsTraceViewer::showRow);
 
 	connect(&_graph,	&KsTraceGraph::deselect,
-		this,		&KsMainWindow::_deselect);
+		this,		&KsMainWindow::_deselectActive);
 
 	connect(&_view,		&KsTraceViewer::deselect,
-		this,		&KsMainWindow::_deselect);
+		this,		&KsMainWindow::_deselectActive);
 
 	connect(&_data,		&KsDataStore::updateWidgets,
 		&_view,		&KsTraceViewer::update);
@@ -117,7 +117,7 @@ KsMainWindow::KsMainWindow(QWidget *parent)
 
 	_deselectShortcut.setKey(Qt::CTRL + Qt::Key_D);
 	connect(&_deselectShortcut,	&QShortcut::activated,
-		this,			&KsMainWindow::_deselect);
+		this,			&KsMainWindow::_deselectActive);
 
 	connect(&_mState,	&KsDualMarkerSM::deselectA,
 		this,		&KsMainWindow::_deselectA);
@@ -1136,7 +1136,7 @@ void KsMainWindow::_splitterMoved(int pos, int index)
 	_session.saveSplitterSize(_splitter);
 }
 
-void KsMainWindow::_deselect()
+void KsMainWindow::_deselectActive()
 {
 	_view.clearSelection();
 	_mState.activeMarker().remove();
diff --git a/kernel-shark/src/KsMainWindow.hpp b/kernel-shark/src/KsMainWindow.hpp
index abfe196..969b603 100644
--- a/kernel-shark/src/KsMainWindow.hpp
+++ b/kernel-shark/src/KsMainWindow.hpp
@@ -216,7 +216,7 @@ private:
 	void _error(const QString &text, const QString &errCode,
 		    bool resize, bool unloadPlugins);
 
-	void _deselect();
+	void _deselectActive();
 
 	void _deselectA();
 
-- 
2.17.1


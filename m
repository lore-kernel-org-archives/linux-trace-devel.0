Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4661C3DA78
	for <linux-trace-devel@archiver.kernel.org>; Sun, 15 Jan 2023 18:43:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231492AbjAOSnZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 15 Jan 2023 13:43:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231585AbjAOSnV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 15 Jan 2023 13:43:21 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F51412F12
        for <linux-trace-devel@vger.kernel.org>; Sun, 15 Jan 2023 10:43:17 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id v10so36844043edi.8
        for <linux-trace-devel@vger.kernel.org>; Sun, 15 Jan 2023 10:43:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DwgX/5Ja+MzuaWvrKFGGS5dRAieqTv4wY1MMrFPCotg=;
        b=o8LzfUHUPTwT9ZhnsvozpI+l+CyExWp2Sm3oWQ1E3F/HptZv7YB07yEjbucJaRHn9c
         FJ5OZfN3lN2jTX6GcMEh+iQHjc90FMMwYJyijuKTfqOnLdqgtf1OvZdToO0tPV/J9xCf
         edrW5YcW8gUqZmBuPe6HGheiyd/K3bylWMSuR2ypljqFJUOZwUMDj3dMNQlzUJUWOd8z
         vrLk111R7M4t6QPnZaayM8GtnxD9MhudOPYFKcsDgki6iEukCX4dAOt6Do8MReTfs2Q4
         ducBuOMDut548nKkGN04WqWBAw0EJpgil/+yNo7tjOI61tYw2S+m722tgNfncgEzjI91
         aXgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DwgX/5Ja+MzuaWvrKFGGS5dRAieqTv4wY1MMrFPCotg=;
        b=hEMNx9TmPNbLXLKwPmvuyWNv7hN6C8FQRKnuMxPYulY950WYTCXe/zRVqQysjcH5GR
         dnNkVoIEfwYaETdfXDNyOyvgWSOLsgtAA5FPnoWZhHKcuRy9gjdXisWPKgMIc1bRI0dM
         4rHZP+cIafX/yiMcMhfo8Ue5mtCSYZOBhXx8qfnhhgLQgY7+DW4qJKd21Gn+iO9X43qr
         LhBoShk2Dj3yragriuiiCCKLm4ScbSJyXnrWhsloj5Wf9y5QVxwv+OpcuQDKOTfvlmsL
         7YiOm0wY3JgrMaU3w3cLfOb04dcsbZTnGoCHb2+LV+qF4Zu2jvycQMfbrD7ZUQ/p9s2Y
         x3cA==
X-Gm-Message-State: AFqh2kqQ3Aowjzy4AuvWu+86wTXGC72pTuIr/4s5GGQ0lxDb1ZSWQ0ul
        6ceDNYezuT+0MkfF0GsfQtcuvPDcoQU=
X-Google-Smtp-Source: AMrXdXsUnUxAsrE3LfLU0S5l+RZFEZ6PIY0axX8IiOYlWV+IoV7nYIK1Mfx8bJEtaiTJCGkNp1kYkg==
X-Received: by 2002:aa7:d599:0:b0:496:b479:e437 with SMTP id r25-20020aa7d599000000b00496b479e437mr31078723edq.27.1673808195640;
        Sun, 15 Jan 2023 10:43:15 -0800 (PST)
Received: from belmeken.. (78-154-14-113.ip.btc-net.bg. [78.154.14.113])
        by smtp.gmail.com with ESMTPSA id b20-20020aa7c6d4000000b004610899742asm10616552eds.13.2023.01.15.10.43.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Jan 2023 10:43:15 -0800 (PST)
From:   Yordan Karadzhov <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH] kernel-shark: Show multi-line events using the dual marker
Date:   Sun, 15 Jan 2023 20:43:12 +0200
Message-Id: <20230115184312.46666-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Some events (stack traces) have multiple lines, but currently the list
view of each event is just a single line. Make sure that the cells of
the records, selected with the markers, are resized such that all lines
are shown into the table.

Signed-off-by: Yordan Karadzhov <y.karadz@gmail.com>
---
 src/KsTraceViewer.cpp | 23 ++++++++++++++++++++++-
 src/KsTraceViewer.hpp |  2 ++
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/src/KsTraceViewer.cpp b/src/KsTraceViewer.cpp
index be0a419..12a95a7 100644
--- a/src/KsTraceViewer.cpp
+++ b/src/KsTraceViewer.cpp
@@ -110,6 +110,25 @@ KsTraceViewer::KsTraceViewer(QWidget *parent)
 	connect(&_searchFSM._searchRestartButton,	&QPushButton::pressed,
 		this,				&KsTraceViewer::_searchContinue);
 
+	int defaultRowHeight = FONT_HEIGHT * 1.25;
+	auto lamSelectionChanged = [this, defaultRowHeight] (const QItemSelection &selected,
+							     const QItemSelection &deselected) {
+		if (deselected.count()) {
+			_view.verticalHeader()->resizeSection(deselected.indexes().first().row(),
+							      defaultRowHeight);
+		}
+		if (selected.count()) {
+			_view.resizeRowToContents(selected.indexes().first().row());
+		}
+
+		if (_mState->passiveMarker().isVisible()) {
+			QModelIndex index = _model.index(_mState->passiveMarker()._pos, 0);
+			_view.resizeRowToContents(_proxyModel.mapFromSource(index).row());
+		}
+	};
+	connect(&_selectionModel,	&QItemSelectionModel::selectionChanged,
+		lamSelectionChanged);
+
 	_searchFSM.placeInToolBar(&_toolbar);
 
 	/*
@@ -128,13 +147,15 @@ KsTraceViewer::KsTraceViewer(QWidget *parent)
 	_view.setEditTriggers(QAbstractItemView::NoEditTriggers);
 	_view.setSelectionBehavior(QAbstractItemView::SelectRows);
 	_view.setSelectionMode(QAbstractItemView::SingleSelection);
-	_view.verticalHeader()->setDefaultSectionSize(FONT_HEIGHT * 1.25);
+	_view.verticalHeader()->setDefaultSectionSize(defaultRowHeight);
 	_view.setFont(QFontDatabase::systemFont(QFontDatabase::FixedFont));
 	_view.horizontalHeader()->setFont(
 		QFontDatabase::systemFont(QFontDatabase::GeneralFont));
 
 	 _proxyModel.setSource(&_model);
+	_selectionModel.setModel(&_proxyModel);
 	_view.setModel(&_proxyModel);
+	_view.setSelectionModel(&_selectionModel);
 	connect(&_proxyModel, &QAbstractItemModel::modelReset,
 		this, &KsTraceViewer::_searchReset);
 
diff --git a/src/KsTraceViewer.hpp b/src/KsTraceViewer.hpp
index f3979a6..ae1929d 100644
--- a/src/KsTraceViewer.hpp
+++ b/src/KsTraceViewer.hpp
@@ -106,6 +106,8 @@ private:
 
 	KsFilterProxyModel	_proxyModel;
 
+	QItemSelectionModel 	_selectionModel;
+
 	QToolBar	_toolbar;
 
 	QLabel		_labelSearch, _labelGrFollows;
-- 
2.38.1


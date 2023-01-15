Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07D1BC3DA78
	for <linux-trace-devel@archiver.kernel.org>; Sun, 15 Jan 2023 18:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbjAOSoT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 15 Jan 2023 13:44:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231372AbjAOSoS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 15 Jan 2023 13:44:18 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13635F744
        for <linux-trace-devel@vger.kernel.org>; Sun, 15 Jan 2023 10:44:17 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id 18so38043730edw.7
        for <linux-trace-devel@vger.kernel.org>; Sun, 15 Jan 2023 10:44:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WGu6dqcCWo8A9aq3hiouuLt4xdzX01nM7tdjDxbxg18=;
        b=KFzczDuAYCjbyXrgXR8yvoemkwD39Af9iI3jOxbF+4XzVZ9AhXfxJh6Hc/meY1hLlc
         o34gAS8+qUHxj6OgZvgKVsfaN49T2x6LnsOT2UouqwpqtALNu5yPfHEK2uoB03B+O9wx
         oLZg5HbU4EN7L8BwqSazxZaYQFnqIdRwRCjP5rAX1GpbqjLO3S/skuIBgT2pL15OevG3
         ZZAHFqGWzX1W+zNxPyi63OYBMgeO1yZULYNJ4DZWLSrAqNVaozkMN1KyTT1PVzxl85TA
         DuOHPfOatFmC6aSrkzg6HIo4BtIH9Ml+ufza5Yip3EN+sGVz1vOPBH8q0tzk9+G3WuCR
         YzXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WGu6dqcCWo8A9aq3hiouuLt4xdzX01nM7tdjDxbxg18=;
        b=y3mcks/jMI2jg03seZecsiwdfhX2otDJgCxWoHV1gYZIIirDQ+a6MKzdwwk+cEaHzA
         ToypZX5wEyRC9NdhWhw0VBbM/U8INK9TjfZm1zuPaYW55VRT2Y3khcpoT444uGBVYJrg
         u/gfA8N3Z46yxbiGXLimXaHxZvuz+W2CEMt/oH64ok/ee1XuMfhkxwLdE+R6m9vpG+rf
         J7KKhEPg92KXmmcFz7kiWR0fomVJkrW50pHmAvZ1XRZ11RC3x0nUc5bWYNkHrvfJ/bSN
         owuB+waOh6lEqYo5dzUYjKpRfPjT6BKu21277RYVqMwZ99L57j3MqlV0ub2TDxB10WQn
         HXkw==
X-Gm-Message-State: AFqh2krCVFO5O6+39pknwkCYGSjRudeILTd5ZW+Sx8vjYVhoRQY49aqd
        aJ9D+NDiJNVfcLgNkIisL1IHaFeDyYo=
X-Google-Smtp-Source: AMrXdXuLYSMvWB5tu11ibpy9+G6zgXfOuHIBYOLv17Fy0neDRnC+HP4dEvjYimO6tShApbFFnUPdhA==
X-Received: by 2002:a50:fc10:0:b0:49b:5a1c:9cb5 with SMTP id i16-20020a50fc10000000b0049b5a1c9cb5mr12286419edr.16.1673808255397;
        Sun, 15 Jan 2023 10:44:15 -0800 (PST)
Received: from belmeken.. (78-154-14-113.ip.btc-net.bg. [78.154.14.113])
        by smtp.gmail.com with ESMTPSA id cx26-20020a05640222ba00b0048ec121a52fsm10664192edb.46.2023.01.15.10.44.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Jan 2023 10:44:15 -0800 (PST)
From:   Yordan Karadzhov <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH] kernel-shark: Make the text to be copyable.
Date:   Sun, 15 Jan 2023 20:44:12 +0200
Message-Id: <20230115184412.46720-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Implement an item delegate class for the Table widget. This will
make possible the text of the records to be selected and copied
so that it can be pasted into another windows.

Signed-off-by: Yordan Karadzhov <y.karadz@gmail.com>
---
 src/KsModels.cpp      | 14 ++++++++++++++
 src/KsModels.hpp      |  2 ++
 src/KsTraceViewer.cpp | 27 ++++++++++++++++++++++++---
 src/KsTraceViewer.hpp | 22 ++++++++++++++++++++++
 4 files changed, 62 insertions(+), 3 deletions(-)

diff --git a/src/KsModels.cpp b/src/KsModels.cpp
index df8373e..e10f411 100644
--- a/src/KsModels.cpp
+++ b/src/KsModels.cpp
@@ -482,6 +482,20 @@ size_t KsViewModel::search(int column,
 	return matchList->count();
 }
 
+/** @brief Reimplements handler to return a flags that enables the item
+ *	   (ItemIsEnabled) and allows it to be selecte.
+ *
+ * @param index: The index of the item.
+ *
+ * @returns Returns the item flags for the given index.
+ */
+Qt::ItemFlags KsViewModel::flags(const QModelIndex &index) const {
+	if (!index.isValid())
+	    return Qt::ItemIsEnabled;
+
+	return QAbstractItemModel::flags(index) | Qt::ItemIsEditable;
+}
+
 /** Create a default (empty) KsFilterProxyModel object. */
 KsGraphModel::KsGraphModel(QObject *parent)
 : QAbstractTableModel(parent)
diff --git a/src/KsModels.hpp b/src/KsModels.hpp
index 3a6d3f1..2883ce3 100644
--- a/src/KsModels.hpp
+++ b/src/KsModels.hpp
@@ -130,6 +130,8 @@ public:
 		TRACE_VIEW_N_COLUMNS,
 	};
 
+	Qt::ItemFlags flags(const QModelIndex &index) const;
+
 private:
 	void _updateHeader();
 
diff --git a/src/KsTraceViewer.cpp b/src/KsTraceViewer.cpp
index 12a95a7..05f5461 100644
--- a/src/KsTraceViewer.cpp
+++ b/src/KsTraceViewer.cpp
@@ -19,6 +19,26 @@
 #include "KsTraceViewer.hpp"
 #include "KsWidgetsLib.hpp"
 
+/**
+ * Reimplemented handler for creating delegate widget.
+ */
+QWidget *KsTableItemDelegate::createEditor(QWidget *parent,
+					   const QStyleOptionViewItem &option,
+					   const QModelIndex &index) const {
+	QTextEdit *edit = new QTextEdit(parent);
+	edit->setVerticalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
+	edit->setReadOnly(true);
+	return edit;
+}
+
+/**
+ * Reimplemented handler setting the data shown by the delegate widget.
+ */
+void KsTableItemDelegate::setEditorData(QWidget *editor, const QModelIndex &index) const {
+	QTextEdit *textEditor = qobject_cast<QTextEdit *>(editor);
+	textEditor->setPlainText(_model->getValueStr(index.column(), index.row()));
+}
+
 /**
  * Reimplemented handler for mouse press events. Right mouse click events will
  * be ignored. This is done because we want the Right click is being used to
@@ -47,13 +67,13 @@ void KsTableView::scrollTo(const QModelIndex &index, ScrollHint hint)
 	QTableView::scrollTo(index, hint);
 }
 
-
 /** Create a default (empty) Trace viewer widget. */
 KsTraceViewer::KsTraceViewer(QWidget *parent)
 : KsWidgetsLib::KsDataWidget(parent),
   _view(this),
   _model(this),
   _proxyModel(this),
+  _itemDelegate(&_model, this),
   _toolbar(this),
   _labelSearch("Search: Column", this),
   _labelGrFollows("Graph follows  ", this),
@@ -144,7 +164,7 @@ KsTraceViewer::KsTraceViewer(QWidget *parent)
 	/* Initialize the trace viewer. */
 	_view.horizontalHeader()->setDefaultAlignment(Qt::AlignLeft);
 	_view.verticalHeader()->setVisible(false);
-	_view.setEditTriggers(QAbstractItemView::NoEditTriggers);
+	_view.setEditTriggers(QAbstractItemView::DoubleClicked);
 	_view.setSelectionBehavior(QAbstractItemView::SelectRows);
 	_view.setSelectionMode(QAbstractItemView::SingleSelection);
 	_view.verticalHeader()->setDefaultSectionSize(defaultRowHeight);
@@ -152,7 +172,8 @@ KsTraceViewer::KsTraceViewer(QWidget *parent)
 	_view.horizontalHeader()->setFont(
 		QFontDatabase::systemFont(QFontDatabase::GeneralFont));
 
-	 _proxyModel.setSource(&_model);
+	_view.setItemDelegate(&_itemDelegate);
+	_proxyModel.setSource(&_model);
 	_selectionModel.setModel(&_proxyModel);
 	_view.setModel(&_proxyModel);
 	_view.setSelectionModel(&_selectionModel);
diff --git a/src/KsTraceViewer.hpp b/src/KsTraceViewer.hpp
index ae1929d..99e4d38 100644
--- a/src/KsTraceViewer.hpp
+++ b/src/KsTraceViewer.hpp
@@ -22,6 +22,26 @@
 #include "KsDualMarker.hpp"
 #include "KsWidgetsLib.hpp"
 
+/**
+ * Class used to customize the display of the data items from the model.
+ */
+class KsTableItemDelegate : public QItemDelegate
+{
+public:
+	/** Create KsTableItemDelegate. */
+	KsTableItemDelegate(KsViewModel *model, QWidget *parent = nullptr)
+	: QItemDelegate(parent),
+	  _model(model) {};
+
+private:
+	QWidget *createEditor(QWidget *parent, const QStyleOptionViewItem &option,
+			      const QModelIndex &index) const override;
+
+	void setEditorData(QWidget *editor, const QModelIndex &index) const override;
+
+	KsViewModel *_model;
+};
+
 /**
  * Table View class, needed in order to reimplemented the handler for mouse
  * press events.
@@ -108,6 +128,8 @@ private:
 
 	QItemSelectionModel 	_selectionModel;
 
+	KsTableItemDelegate	_itemDelegate;
+
 	QToolBar	_toolbar;
 
 	QLabel		_labelSearch, _labelGrFollows;
-- 
2.38.1


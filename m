Return-Path: <SRS0=tdNt=MX=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-sn1nam02on0057.outbound.protection.outlook.com ([104.47.36.57]:35135
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730510AbeJLAZ6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Oct 2018 20:25:58 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>,
        Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH v3 3/4] kernel-shark-qt: Add Widgets Lib
Date: Thu, 11 Oct 2018 16:57:42 +0000
Message-ID: <20181011165713.15257-4-ykaradzhov@vmware.com>
References: <20181011165713.15257-1-ykaradzhov@vmware.com>
In-Reply-To: <20181011165713.15257-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: Yordan Karadzhov (VMware) <y.karadz@gmail.com>

This patch defines various small widgets and dialogues to be used by
the KernelShark GUI.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/src/CMakeLists.txt   |   6 +-
 kernel-shark-qt/src/KsWidgetsLib.cpp | 881 +++++++++++++++++++++++++++
 kernel-shark-qt/src/KsWidgetsLib.hpp | 385 ++++++++++++
 3 files changed, 1270 insertions(+), 2 deletions(-)
 create mode 100644 kernel-shark-qt/src/KsWidgetsLib.cpp
 create mode 100644 kernel-shark-qt/src/KsWidgetsLib.hpp

diff --git a/kernel-shark-qt/src/CMakeLists.txt b/kernel-shark-qt/src/CMake=
Lists.txt
index e897e9a..2ac79ca 100644
--- a/kernel-shark-qt/src/CMakeLists.txt
+++ b/kernel-shark-qt/src/CMakeLists.txt
@@ -31,11 +31,13 @@ endif (OPENGL_FOUND AND GLUT_FOUND)
 if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
=20
     message(STATUS "libkshark-gui")
-    set (ks-guiLib_hdr  KsUtils.hpp)
+    set (ks-guiLib_hdr  KsUtils.hpp
+                        KsWidgetsLib.hpp)
=20
     QT5_WRAP_CPP(ks-guiLib_hdr_moc ${ks-guiLib_hdr})
=20
-    add_library(kshark-gui  SHARED  ${ks-guiLib_hdr_moc}    KsUtils.cpp)
+    add_library(kshark-gui  SHARED  ${ks-guiLib_hdr_moc}    KsUtils.cpp
+                                                            KsWidgetsLib.c=
pp)
=20
     target_link_libraries(kshark-gui kshark-plot
                                      ${CMAKE_DL_LIBS}
diff --git a/kernel-shark-qt/src/KsWidgetsLib.cpp b/kernel-shark-qt/src/KsW=
idgetsLib.cpp
new file mode 100644
index 0000000..f7fca09
--- /dev/null
+++ b/kernel-shark-qt/src/KsWidgetsLib.cpp
@@ -0,0 +1,881 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
+ */
+
+/**
+ *  @file    KsWidgetsLib.cpp
+ *  @brief   Defines small widgets and dialogues used by the KernelShark G=
UI.
+ */
+
+// KernelShark
+#include "libkshark.h"
+#include "KsUtils.hpp"
+#include "KsCmakeDef.hpp"
+#include "KsPlotTools.hpp"
+#include "KsWidgetsLib.hpp"
+
+/**
+ * @brief Create KsProgressBar.
+ *
+ * @param message: Text to be shown.
+ * @param parent: The parent of this widget.
+ */
+KsProgressBar::KsProgressBar(QString message, QWidget *parent)
+: QWidget(parent),
+  _sb(this),
+  _pb(&_sb) {
+	resize(KS_BROGBAR_WIDTH, KS_BROGBAR_HEIGHT);
+	setWindowTitle("KernelShark");
+	setLayout(new QVBoxLayout);
+
+	_pb.setOrientation(Qt::Horizontal);
+	_pb.setTextVisible(false);
+	_pb.setRange(0, KS_PROGRESS_BAR_MAX);
+	_pb.setValue(1);
+
+	_sb.addPermanentWidget(&_pb, 1);
+
+	layout()->addWidget(new QLabel(message));
+	layout()->addWidget(&_sb);
+
+	setWindowFlags(Qt::WindowStaysOnTopHint);
+
+	show();
+}
+
+/** @brief Set the state of the progressbar.
+ *
+ * @param i: A value ranging from 0 to KS_PROGRESS_BAR_MAX.
+ */
+void KsProgressBar::setValue(int i) {
+	_pb.setValue(i);
+	QApplication::processEvents();
+}
+
+/**
+ * @brief Create KsMessageDialog.
+ *
+ * @param message: Text to be shown.
+ * @param parent: The parent of this widget.
+ */
+KsMessageDialog::KsMessageDialog(QString message, QWidget *parent)
+: QDialog(parent),
+  _text(message, this),
+  _closeButton("Close", this)
+{
+	resize(KS_MSG_DIALOG_WIDTH, KS_MSG_DIALOG_HEIGHT);
+
+	_layout.addWidget(&_text);
+	_layout.addWidget(&_closeButton);
+
+	connect(&_closeButton,	&QPushButton::pressed,
+		this,		&QWidget::close);
+
+	this->setLayout(&_layout);
+}
+
+/**
+ * @brief Create KsCheckBoxWidget.
+ *
+ * @param name: The name of this widget.
+ * @param parent: The parent of this widget.
+ */
+KsCheckBoxWidget::KsCheckBoxWidget(const QString &name, QWidget *parent)
+: QWidget(parent),
+  _tb(this),
+  _allCb("all", &_tb),
+  _cbWidget(this),
+  _cbLayout(&_cbWidget),
+  _topLayout(this),
+  _name(name),
+  _nameLabel(name + ":  ",&_tb)
+{
+	setWindowTitle(_name);
+	setMinimumHeight(SCREEN_HEIGHT / 2);
+
+	connect(&_allCb,	&QCheckBox::clicked,
+		this,		&KsCheckBoxWidget::_checkAll);
+
+	_cbWidget.setLayout(&_cbLayout);
+
+	_tb.addWidget(&_nameLabel);
+	_tb.addWidget(&_allCb);
+	_topLayout.addWidget(&_tb);
+
+	_topLayout.addWidget(&_cbWidget);
+	_topLayout.setContentsMargins(0, 0, 0, 0);
+
+	setLayout(&_topLayout);
+	_allCb.setCheckState(Qt::Checked);
+}
+
+/**
+ * Set the default state for all checkboxes (including the "all" checkbox)=
.
+ */
+void KsCheckBoxWidget::setDefault(bool st)
+{
+	Qt::CheckState state =3D Qt::Unchecked;
+
+	if (st)
+		state =3D Qt::Checked;
+
+	_allCb.setCheckState(state);
+	_checkAll(state);
+}
+
+/** Get a vector containing the indexes of all checked boxes. */
+QVector<int> KsCheckBoxWidget::getCheckedIds()
+{
+	QVector<int> vec;
+	int n =3D _id.size();
+
+	for (int i =3D 0; i < n; ++i)
+		if (_checkState(i) =3D=3D Qt::Checked)
+			vec.append(_id[i]);
+
+	return vec;
+}
+
+/**
+ * @brief Set the state of the checkboxes.
+ *
+ * @param v: Vector containing the bool values for all checkboxes.
+ */
+void KsCheckBoxWidget::set(QVector<bool> v)
+{
+	Qt::CheckState state;
+	int nChecks;
+
+	nChecks =3D (v.size() < _id.size()) ? v.size() : _id.size();
+
+	/* Start with the "all" checkbox being checked. */
+	_allCb.setCheckState(Qt::Checked);
+	for (int i =3D 0; i < nChecks; ++i) {
+		if (v[i]) {
+			state =3D Qt::Checked;
+		} else {
+			/*
+			 * At least one checkbox is unchecked. Uncheck
+			 * "all" as well.
+			 */
+			state =3D Qt::Unchecked;
+			_allCb.setCheckState(state);
+		}
+
+		_setCheckState(i, state);
+	}
+	_verify();
+}
+
+void KsCheckBoxWidget::_checkAll(bool st)
+{
+	Qt::CheckState state =3D Qt::Unchecked;
+	int n =3D _id.size();
+
+	if (st) state =3D Qt::Checked;
+
+	for (int i =3D 0; i < n; ++i) {
+		_setCheckState(i, state);
+	}
+
+	_verify();
+}
+
+/**
+ * @brief Create KsCheckBoxDialog.
+ *
+ * @param cbw: A KsCheckBoxWidget to be nested in this dialog.
+ * @param parent: The parent of this widget.
+ */
+KsCheckBoxDialog::KsCheckBoxDialog(KsCheckBoxWidget *cbw, QWidget *parent)
+: QDialog(parent), _checkBoxWidget(cbw),
+  _applyButton("Apply", this),
+  _cancelButton("Cancel", this)
+{
+	int buttonWidth;
+
+	setWindowTitle(cbw->name());
+	_topLayout.addWidget(_checkBoxWidget);
+
+	buttonWidth =3D STRING_WIDTH("--Cancel--");
+	_applyButton.setFixedWidth(buttonWidth);
+	_cancelButton.setFixedWidth(buttonWidth);
+
+	_buttonLayout.addWidget(&_applyButton);
+	_applyButton.setAutoDefault(false);
+
+	_buttonLayout.addWidget(&_cancelButton);
+	_cancelButton.setAutoDefault(false);
+
+	_buttonLayout.setAlignment(Qt::AlignLeft);
+	_topLayout.addLayout(&_buttonLayout);
+
+	_applyButtonConnection =3D
+		connect(&_applyButton,	&QPushButton::pressed,
+			this,		&KsCheckBoxDialog::_applyPress);
+
+	connect(&_applyButton,	&QPushButton::pressed,
+		this,		&QWidget::close);
+
+	connect(&_cancelButton,	&QPushButton::pressed,
+		this,		&QWidget::close);
+
+	this->setLayout(&_topLayout);
+}
+
+void KsCheckBoxDialog::_applyPress()
+{
+	QVector<int> vec =3D _checkBoxWidget->getCheckedIds();
+	emit apply(vec);
+
+	/*
+	 * Disconnect _applyButton. This is done in order to protect
+	 * against multiple clicks.
+	 */
+	disconnect(_applyButtonConnection);
+}
+
+
+/**
+ * @brief Create KsCheckBoxTable.
+ *
+ * @param parent: The parent of this widget.
+ */
+KsCheckBoxTable::KsCheckBoxTable(QWidget *parent)
+: QTableWidget(parent)
+{
+	setShowGrid(false);
+	horizontalHeader()->setDefaultAlignment(Qt::AlignLeft);
+	horizontalHeader()->setStretchLastSection(true);
+	setSelectionBehavior(QAbstractItemView::SelectRows);
+	setEditTriggers(QAbstractItemView::NoEditTriggers);
+	setHorizontalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
+	verticalHeader()->setVisible(false);
+
+	connect(this, &QTableWidget::cellDoubleClicked,
+		this, &KsCheckBoxTable::_doubleClicked);
+}
+
+/**
+ * @brief Initialize the table.
+ *
+ * @param headers: The headers of the individual columns.
+ * @param size: The number of rows.
+ */
+void KsCheckBoxTable::init(QStringList headers, int size)
+{
+	QHBoxLayout *cbLayout;
+	QWidget *cbWidget;
+
+	setColumnCount(headers.count());
+	setRowCount(size);
+	setHorizontalHeaderLabels(headers);
+
+	_cb.resize(size);
+
+	for (int i =3D 0; i < size; ++i) {
+		cbWidget =3D new QWidget();
+		_cb[i] =3D new QCheckBox(cbWidget);
+		cbLayout =3D new QHBoxLayout(cbWidget);
+
+		cbLayout->addWidget(_cb[i]);
+		cbLayout->setAlignment(Qt::AlignCenter);
+		cbLayout->setContentsMargins(0, 0, 0, 0);
+
+		cbWidget->setLayout(cbLayout);
+		setCellWidget(i, 0, cbWidget);
+	}
+}
+
+/** Reimplemented event handler used to receive key press events. */
+void KsCheckBoxTable::keyPressEvent(QKeyEvent *event)
+{
+	if (event->key() =3D=3D Qt::Key_Return) {
+		for (auto &s: selectedItems()) {
+			if (s->column() =3D=3D 1)
+				emit changeState(s->row());
+		}
+	}
+
+	QApplication::processEvents();
+	QTableWidget::keyPressEvent(event);
+}
+
+/** Reimplemented event handler used to receive mouse press events. */
+void KsCheckBoxTable::mousePressEvent(QMouseEvent *event)
+{
+	if (event->button() =3D=3D Qt::RightButton) {
+		for (auto &i: selectedItems())
+			i->setSelected(false);
+
+		return;
+	}
+
+	QApplication::processEvents();
+	QTableWidget::mousePressEvent(event);
+}
+
+void KsCheckBoxTable::_doubleClicked(int row, int col)
+{
+	emit changeState(row);
+	for (auto &i: selectedItems())
+		i->setSelected(false);
+}
+
+/**
+ * @brief Create KsCheckBoxTableWidget.
+ *
+ * @param name: The name of this widget.
+ * @param parent: The parent of this widget.
+ */
+KsCheckBoxTableWidget::KsCheckBoxTableWidget(const QString &name,
+					     QWidget *parent)
+: KsCheckBoxWidget(name, parent),
+  _table(this)
+{
+	connect(&_table,	&KsCheckBoxTable::changeState,
+		this,		&KsCheckBoxTableWidget::_changeState);
+}
+
+/** Initialize the KsCheckBoxTable and its layout. */
+void KsCheckBoxTableWidget::_initTable(QStringList headers, int size)
+{
+	_table.init(headers, size);
+
+	for (auto const & cb: _table._cb) {
+		connect(cb,	&QCheckBox::clicked,
+			this,	&KsCheckBoxTableWidget::_update);
+	}
+
+	_cbLayout.setContentsMargins(1, 1, 1, 1);
+	_cbLayout.addWidget(&_table);
+}
+
+/** Adjust the size of this widget according to its content. */
+void KsCheckBoxTableWidget::_adjustSize()
+{
+	int width;
+
+	_table.setVisible(false);
+	_table.resizeColumnsToContents();
+	_table.setVisible(true);
+
+	width =3D _table.horizontalHeader()->length() +
+		FONT_WIDTH * 3 +
+		style()->pixelMetric(QStyle::PM_ScrollBarExtent);
+
+	_cbWidget.resize(width, _cbWidget.height());
+
+	setMinimumWidth(_cbWidget.width() +
+			_cbLayout.contentsMargins().left() +
+			_cbLayout.contentsMargins().right() +
+			_topLayout.contentsMargins().left() +
+			_topLayout.contentsMargins().right());
+}
+
+void  KsCheckBoxTableWidget::_update(bool state)
+{
+	/* If a Checkbox is being unchecked. Unchecked "all" as well. */
+	if (!state)
+		_allCb.setCheckState(Qt::Unchecked);
+}
+
+void KsCheckBoxTableWidget::_changeState(int row)
+{
+	if (_table._cb[row]->checkState() =3D=3D Qt::Checked)
+		_table._cb[row]->setCheckState(Qt::Unchecked);
+	else
+		_table._cb[row]->setCheckState(Qt::Checked);
+
+	_allCb.setCheckState(Qt::Checked);
+	for (auto &c: _table._cb) {
+		if (c->checkState() =3D=3D Qt::Unchecked) {
+			_allCb.setCheckState(Qt::Unchecked);
+			break;
+		}
+	}
+}
+
+static void update_r(QTreeWidgetItem *item, Qt::CheckState state)
+{
+	int n;
+
+	item->setCheckState(0, state);
+
+	n =3D item->childCount();
+	for (int i =3D 0; i < n; ++i)
+		update_r(item->child(i), state);
+}
+
+/**
+ * @brief Create KsCheckBoxTree.
+ *
+ * @param parent: The parent of this widget.
+ */
+KsCheckBoxTree::KsCheckBoxTree(QWidget *parent)
+: QTreeWidget(parent)
+{
+	setColumnCount(2);
+	setHeaderHidden(true);
+	setSelectionBehavior(QAbstractItemView::SelectRows);
+	setHorizontalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
+
+	connect(this, &KsCheckBoxTree::itemDoubleClicked,
+		this, &KsCheckBoxTree::_doubleClicked);
+}
+
+/** Reimplemented event handler used to receive key press events. */
+void KsCheckBoxTree::keyPressEvent(QKeyEvent *event)
+{
+	if (event->key() =3D=3D Qt::Key_Return) {
+		/* Loop over all selected child items and change
+		* there states. */
+		for (auto &s: selectedItems()) {
+			if(s->childCount()) {
+				if (s->isExpanded())
+					continue;
+			}
+
+			if (s->checkState(0) =3D=3D Qt::Unchecked)
+				s->setCheckState(0, Qt::Checked);
+			else
+				s->setCheckState(0, Qt::Unchecked);
+
+			if(s->childCount()) {
+				update_r(s, s->checkState(0));
+			}
+		}
+	}
+
+	emit verify();
+	QTreeWidget::keyPressEvent(event);
+}
+
+void KsCheckBoxTree::_doubleClicked(QTreeWidgetItem *item, int col)
+{
+	if (item->checkState(0) =3D=3D Qt::Unchecked)
+		item->setCheckState(0, Qt::Checked);
+	else
+		item->setCheckState(0, Qt::Unchecked);
+
+	for (auto &i: selectedItems())
+		i->setSelected(false);
+
+	emit itemClicked(item, col);
+}
+
+/** Reimplemented event handler used to receive mouse press events. */
+void KsCheckBoxTree::mousePressEvent(QMouseEvent *event)
+{
+	if (event->button() =3D=3D Qt::RightButton) {
+		for (auto &i: selectedItems())
+			i->setSelected(false);
+		return;
+	}
+
+	QApplication::processEvents();
+	QTreeWidget::mousePressEvent(event);
+}
+
+/**
+ * @brief Create KsCheckBoxTreeWidget.
+ *
+ * @param name: The name of this widget.
+ * @param parent: The parent of this widget.
+ */
+KsCheckBoxTreeWidget::KsCheckBoxTreeWidget(const QString &name,
+					   QWidget *parent)
+: KsCheckBoxWidget(name, parent),
+  _tree(this)
+{
+	connect(&_tree,	&KsCheckBoxTree::verify,
+		this,	&KsCheckBoxTreeWidget::_verify);
+}
+
+/** Initialize the KsCheckBoxTree and its layout. */
+void KsCheckBoxTreeWidget::_initTree()
+{
+	_tree.setSelectionMode(QAbstractItemView::MultiSelection);
+
+	connect(&_tree, &QTreeWidget::itemClicked,
+		this,	&KsCheckBoxTreeWidget::_update);
+
+	_cbLayout.setContentsMargins(1, 1, 1, 1);
+	_cbLayout.addWidget(&_tree);
+}
+
+/** Adjust the size of this widget according to its content. */
+void KsCheckBoxTreeWidget::_adjustSize()
+{
+	int width, n =3D _tree.topLevelItemCount();
+
+	if (n =3D=3D 0)
+		return;
+
+	for (int i =3D 0; i < n; ++i)
+		_tree.topLevelItem(i)->setExpanded(true);
+
+	_tree.resizeColumnToContents(0);
+	if (_tree.topLevelItem(0)->child(0)) {
+		width =3D _tree.visualItemRect(_tree.topLevelItem(0)->child(0)).width();
+	} else {
+		width =3D _tree.visualItemRect(_tree.topLevelItem(0)).width();
+	}
+
+	width +=3D FONT_WIDTH*3 + style()->pixelMetric(QStyle::PM_ScrollBarExtent=
);
+	_cbWidget.resize(width, _cbWidget.height());
+
+	for (int i =3D 0; i < n; ++i)
+		_tree.topLevelItem(i)->setExpanded(false);
+
+	setMinimumWidth(_cbWidget.width() +
+			_cbLayout.contentsMargins().left() +
+			_cbLayout.contentsMargins().right() +
+			_topLayout.contentsMargins().left() +
+			_topLayout.contentsMargins().right());
+}
+
+void KsCheckBoxTreeWidget::_update(QTreeWidgetItem *item, int column)
+{
+	/* Get the new state of the item. */
+	Qt::CheckState state =3D item->checkState(0);
+
+	/* Recursively update all items below this one. */
+	update_r(item, state);
+
+	/*
+	 * Update all items above this one including the "all"
+	 * check box.
+	 */
+	_verify();
+}
+
+void KsCheckBoxTreeWidget::_verify()
+{
+	/*
+	 * Set the state of the top level items according to the
+	 * state of the childs.
+	 */
+	QTreeWidgetItem *topItem, *childItem;
+
+	for(int t =3D 0; t < _tree.topLevelItemCount(); ++t) {
+		topItem =3D _tree.topLevelItem(t);
+		if (topItem->childCount() =3D=3D 0)
+			continue;
+
+		topItem->setCheckState(0, Qt::Checked);
+		for (int c =3D 0; c < topItem->childCount(); ++c) {
+			childItem =3D topItem->child(c);
+			if (childItem->checkState(0) =3D=3D Qt::Unchecked)
+				topItem->setCheckState(0, Qt::Unchecked);
+		}
+	}
+
+	_allCb.setCheckState(Qt::Checked);
+	for (auto &c: _cb) {
+		if (c->checkState(0) =3D=3D Qt::Unchecked) {
+			_allCb.setCheckState(Qt::Unchecked);
+			break;
+		}
+	}
+}
+
+/**
+ * @brief Create KsCPUCheckBoxWidget.
+ *
+ * @param tep: Trace event parseer.
+ * @param parent: The parent of this widget.
+ */
+KsCPUCheckBoxWidget::KsCPUCheckBoxWidget(struct tep_handle *tep,
+					 QWidget *parent)
+: KsCheckBoxTreeWidget("CPUs", parent)
+{
+	int nCPUs(0), height(FONT_HEIGHT * 1.5);
+	KsPlot::Color cpuCol;
+	QString style;
+
+	style =3D QString("QTreeView::item { height: %1 ;}").arg(height);
+	_tree.setStyleSheet(style);
+
+	_initTree();
+
+	if (tep)
+		nCPUs =3D tep_get_cpus(tep);
+
+	_id.resize(nCPUs);
+	_cb.resize(nCPUs);
+
+	for (int i =3D 0; i < nCPUs; ++i) {
+		cpuCol.setRainbowColor(i);
+		QTreeWidgetItem *cpuItem =3D new QTreeWidgetItem;
+		cpuItem->setText(0, "  ");
+		cpuItem->setText(1, QString("CPU %1").arg(i));
+		cpuItem->setCheckState(0, Qt::Checked);
+		cpuItem->setBackgroundColor(0, QColor(cpuCol.r(),
+						      cpuCol.g(),
+						      cpuCol.b()));
+		_tree.addTopLevelItem(cpuItem);
+		_id[i] =3D i;
+		_cb[i] =3D cpuItem;
+	}
+
+	_adjustSize();
+}
+
+/**
+ * @brief Create KsEventsCheckBoxWidget.
+ *
+ * @param tep: Trace event parseer.
+ * @param parent: The parent of this widget.
+ */
+KsEventsCheckBoxWidget::KsEventsCheckBoxWidget(struct tep_handle *tep,
+					       QWidget *parent)
+: KsCheckBoxTreeWidget("Events", parent)
+{
+	QTreeWidgetItem *sysItem, *evtItem;
+	tep_event_format **events(nullptr);
+	QString sysName, evtName;
+	int nEvts(0), i(0);
+
+	if (tep) {
+		nEvts =3D tep_get_events_count(tep);
+		events =3D tep_list_events(tep, TEP_EVENT_SORT_SYSTEM);
+	}
+
+	_initTree();
+	_id.resize(nEvts);
+	_cb.resize(nEvts);
+
+	while (i < nEvts) {
+		sysName =3D events[i]->system;
+		sysItem =3D new QTreeWidgetItem;
+		sysItem->setText(0, sysName);
+		sysItem->setCheckState(0, Qt::Checked);
+		_tree.addTopLevelItem(sysItem);
+
+		while (sysName =3D=3D events[i]->system) {
+			evtName =3D events[i]->name;
+			evtItem =3D new QTreeWidgetItem;
+			evtItem->setText(0, evtName);
+			evtItem->setCheckState(0, Qt::Checked);
+			evtItem->setFlags(evtItem->flags() |
+					  Qt::ItemIsUserCheckable);
+
+			sysItem->addChild(evtItem);
+
+			_id[i] =3D events[i]->id;
+			_cb[i] =3D evtItem;
+
+			if (++i =3D=3D nEvts)
+				break;
+		}
+	}
+
+	_tree.sortItems(0, Qt::AscendingOrder);
+	_adjustSize();
+}
+
+/**
+ * @brief Create KsTasksCheckBoxWidget.
+ *
+ * @param pevent: Page event used to parse the page.
+ * @param cond: If True make a "Show Task" widget. Otherwise make "Hide Ta=
sk".
+ * @param parent: The parent of this widget.
+ */
+KsTasksCheckBoxWidget::KsTasksCheckBoxWidget(struct tep_handle *pevent,
+					     bool cond, QWidget *parent)
+: KsCheckBoxTableWidget("Tasks", parent)
+{
+	kshark_context *kshark_ctx(nullptr);
+	QTableWidgetItem *pidItem, *comItem;
+	KsPlot::Color pidCol;
+	QStringList headers;
+	const char *comm;
+	int nTasks;
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	if (_cond)
+		headers << "Show" << "Pid" << "Task";
+	else
+		headers << "Hide" << "Pid" << "Task";
+
+	_id =3D KsUtils::getPidList();
+	nTasks =3D _id.count();
+	_initTable(headers, nTasks);
+
+	for (int i =3D 0; i < nTasks; ++i) {
+		pidItem	=3D new QTableWidgetItem(tr("%1").arg(_id[i]));
+		_table.setItem(i, 1, pidItem);
+
+		comm =3D tep_data_comm_from_pid(kshark_ctx->pevent, _id[i]);
+		comItem =3D new QTableWidgetItem(tr(comm));
+
+		pidItem->setBackgroundColor(QColor(pidCol.r(),
+						   pidCol.g(),
+						   pidCol.b()));
+
+		if (_id[i] =3D=3D 0)
+			pidItem->setTextColor(Qt::white);
+
+		_table.setItem(i, 2, comItem);
+
+		pidCol.setRainbowColor(i);
+	}
+
+	_adjustSize();
+}
+
+/**
+ * @brief Create KsPluginCheckBoxWidget.
+ *
+ * @param pluginList: A list of plugin names.
+ * @param parent: The parent of this widget.
+ */
+KsPluginCheckBoxWidget::KsPluginCheckBoxWidget(QStringList pluginList,
+					       QWidget *parent)
+: KsCheckBoxTableWidget("Plugins", parent)
+{
+	QTableWidgetItem *nameItem, *infoItem;
+	QStringList headers;
+	int nPlgins;
+
+	headers << "Load" << "Name" << "Info";
+
+	nPlgins =3D pluginList.count();
+	_initTable(headers, nPlgins);
+	_id.resize(nPlgins);
+
+	for (int i =3D 0; i < nPlgins; ++i) {
+		nameItem =3D new QTableWidgetItem(pluginList[i]);
+		_table.setItem(i, 1, nameItem);
+		infoItem =3D new QTableWidgetItem(" -- ");
+		_table.setItem(i, 2, infoItem);
+		_id[i] =3D i;
+	}
+
+	_adjustSize();
+}
+
+/**
+ * @brief Create KsQuickEntryMenu.
+ *
+ * @param data: Input location for the KsDataStore object.
+ * @param row: The index of the entry used to initialize the menu.
+ * @param parent: The parent of this widget.
+ */
+KsQuickEntryMenu::KsQuickEntryMenu(KsDataStore *data, size_t row,
+				   QWidget *parent)
+: QMenu("Entry menu", parent),
+  _data(data),
+  _row(row),
+  _hideTaskAction(this),
+  _showTaskAction(this),
+  _hideEventAction(this),
+  _showEventAction(this),
+  _addTaskPlotAction(this)
+{
+	QString descr;
+
+	addSection("Quick Filter menu");
+
+	descr =3D "Hide task [";
+	descr +=3D kshark_get_task_easy(_data->rows()[_row]);
+	descr +=3D "-";
+	descr +=3D QString("%1").arg(_data->rows()[_row]->pid);
+	descr +=3D "]";
+
+	_hideTaskAction.setText(descr);
+
+	connect(&_hideTaskAction,	&QAction::triggered,
+		this,			&KsQuickEntryMenu::_hideTask);
+
+	addAction(&_hideTaskAction);
+
+	descr =3D "Show task [";
+	descr +=3D kshark_get_task_easy(_data->rows()[_row]);
+	descr +=3D "-";
+	descr +=3D QString("%1").arg(_data->rows()[_row]->pid);
+	descr +=3D "] only";
+
+	_showTaskAction.setText(descr);
+
+	connect(&_showTaskAction,	&QAction::triggered,
+		this,			&KsQuickEntryMenu::_showTask);
+
+	addAction(&_showTaskAction);
+
+	descr =3D "Hide event [";
+	descr +=3D kshark_get_event_name_easy(_data->rows()[_row]);
+	descr +=3D "]";
+
+	_hideEventAction.setText(descr);
+
+	connect(&_hideEventAction,	&QAction::triggered,
+		this,			&KsQuickEntryMenu::_hideEvent);
+
+	addAction(&_hideEventAction);
+
+	descr =3D "Show event [";
+	descr +=3D kshark_get_event_name_easy(_data->rows()[_row]);
+	descr +=3D "] only";
+
+	_showEventAction.setText(descr);
+
+	connect(&_showEventAction,	&QAction::triggered,
+		this,			&KsQuickEntryMenu::_showEvent);
+
+	addAction(&_showEventAction);
+
+	addSection("Quick Plot menu");
+	descr =3D "Add [";
+	descr +=3D kshark_get_task_easy(_data->rows()[_row]);
+	descr +=3D "-";
+	descr +=3D QString("%1").arg(_data->rows()[_row]->pid);
+	descr +=3D "] plot";
+
+	_addTaskPlotAction.setText(descr);
+
+	connect(&_addTaskPlotAction,	&QAction::triggered,
+		this,			&KsQuickEntryMenu::_addTaskPlot);
+
+	addAction(&_addTaskPlotAction);
+}
+
+void KsQuickEntryMenu::_hideTask()
+{
+	int pid =3D kshark_get_pid_easy(_data->rows()[_row]);
+
+	_data->applyNegTaskFilter(QVector<int>(1, pid));
+}
+
+void KsQuickEntryMenu::_showTask()
+{
+	int pid =3D kshark_get_pid_easy(_data->rows()[_row]);
+
+	_data->applyPosTaskFilter(QVector<int>(1, pid));
+}
+
+void KsQuickEntryMenu::_hideEvent()
+{
+	int eventId =3D kshark_get_event_id_easy(_data->rows()[_row]);
+
+	_data->applyNegEventFilter(QVector<int>(1, eventId));
+}
+
+void KsQuickEntryMenu::_showEvent()
+{
+	int eventId =3D kshark_get_event_id_easy(_data->rows()[_row]);
+
+	_data->applyPosEventFilter(QVector<int>(1, eventId));
+}
+
+void KsQuickEntryMenu::_addTaskPlot()
+{
+	int pid =3D kshark_get_pid_easy(_data->rows()[_row]);
+
+	emit plotTask(pid);
+}
diff --git a/kernel-shark-qt/src/KsWidgetsLib.hpp b/kernel-shark-qt/src/KsW=
idgetsLib.hpp
new file mode 100644
index 0000000..b9ba35a
--- /dev/null
+++ b/kernel-shark-qt/src/KsWidgetsLib.hpp
@@ -0,0 +1,385 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+
+/*
+ * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
+ */
+
+ /**
+  *  @file    KsWidgetsLib.hpp
+  *  @brief   Defines small widgets and dialogues used by the KernelShark =
GUI.
+  */
+
+#ifndef _KS_WIDGETS_LIB_H
+#define _KS_WIDGETS_LIB_H
+
+// Qt
+#include <QtWidgets>
+
+/**
+ * The KsProgressBar class provides a visualization of the progress of a
+ * running job.
+ */
+class KsProgressBar : public QWidget
+{
+	Q_OBJECT
+
+	QStatusBar	_sb;
+
+	QProgressBar	_pb;
+
+public:
+	KsProgressBar(QString message, QWidget *parent =3D nullptr);
+
+	void setValue(int i);
+};
+
+/** Defines the progress bar's maximum value. */
+#define KS_PROGRESS_BAR_MAX 200
+
+/** The height of the KsProgressBar widget. */
+#define KS_BROGBAR_HEIGHT (FONT_HEIGHT * 5)
+
+/** The width of the KsProgressBar widget. */
+#define KS_BROGBAR_WIDTH  (FONT_WIDTH * 50)
+
+/**
+ * The KsMessageDialog class provides a widget showing a message and havin=
g
+ * a "Close" button.
+ */
+class KsMessageDialog : public QDialog
+{
+	QVBoxLayout	_layout;
+
+	QLabel		_text;
+
+	QPushButton	_closeButton;
+
+public:
+	explicit KsMessageDialog(QWidget *parent) =3D delete;
+
+	KsMessageDialog(QString message, QWidget *parent =3D nullptr);
+};
+
+/** The height of the KsMessageDialog widget. */
+#define KS_MSG_DIALOG_HEIGHT (FONT_HEIGHT * 8)
+
+/** The width of the KsMessageDialog widget. */
+#define KS_MSG_DIALOG_WIDTH  (SCREEN_WIDTH / 10)
+
+/**
+ * The KsCheckBoxWidget class is the base class of all CheckBox widget use=
d
+ * by KernelShark.
+ */
+class KsCheckBoxWidget : public QWidget
+{
+	Q_OBJECT
+public:
+	KsCheckBoxWidget(const QString &name =3D "",
+			 QWidget *parent =3D nullptr);
+
+	/** Get the name of the widget. */
+	QString name() const {return _name;}
+
+	/** Get the state of the "all" checkboxe. */
+	bool all() const
+	{
+		if(_allCb.checkState() =3D=3D Qt::Checked)
+			return true;
+		return false;
+	}
+
+	void setDefault(bool);
+
+	void set(QVector<bool> v);
+
+	QVector<int> getCheckedIds();
+
+private:
+	QToolBar _tb;
+
+protected:
+	/** The "all" checkboxe. */
+	QCheckBox	_allCb;
+
+	/** A vector of Id numbers coupled to each checkboxe. */
+	QVector<int>	_id;
+
+	/** A nested widget used to position the checkboxes. */
+	QWidget		_cbWidget;
+
+	/** The layout of the nested widget. */
+	QVBoxLayout	_cbLayout;
+
+	/** The top level layout of this widget. */
+	QVBoxLayout	_topLayout;
+
+	/** The name of this widget. */
+	QString		_name;
+
+	/** A label to show the name of the widget. */
+	QLabel		_nameLabel;
+
+private:
+	virtual void _setCheckState(int i, Qt::CheckState st) =3D 0;
+
+	virtual Qt::CheckState _checkState(int i) const =3D 0;
+
+	virtual void _verify() {};
+
+	void _checkAll(bool);
+};
+
+/**
+ * The KsCheckBoxDialog class is the base class of all CheckBox dialogs
+ * used by KernelShark.
+ */
+class KsCheckBoxDialog : public QDialog
+{
+	Q_OBJECT
+public:
+	KsCheckBoxDialog() =3D delete;
+
+	KsCheckBoxDialog(KsCheckBoxWidget *cbw, QWidget *parent =3D nullptr);
+
+signals:
+	/** Signal emitted when the "Apply" button is pressed. */
+	void apply(QVector<int>);
+
+private:
+	void _applyPress();
+
+	QVBoxLayout		_topLayout;
+
+	QHBoxLayout		_buttonLayout;
+
+	KsCheckBoxWidget	*_checkBoxWidget;
+
+	QPushButton		_applyButton, _cancelButton;
+
+	QMetaObject::Connection		_applyButtonConnection;
+};
+
+/** The KsCheckBoxTable class provides a table of checkboxes. */
+class KsCheckBoxTable : public QTableWidget
+{
+	Q_OBJECT
+public:
+	explicit KsCheckBoxTable(QWidget *parent =3D nullptr);
+
+	void init(QStringList headers, int size);
+
+	/** A vector of checkboxes. */
+	QVector<QCheckBox*>	_cb;
+
+signals:
+	/** Signal emitted when a checkboxes changes state. */
+	void changeState(int row);
+
+protected:
+	void keyPressEvent(QKeyEvent *event) override;
+
+	void mousePressEvent(QMouseEvent *event) override;
+
+private:
+	void _doubleClicked(int row, int col);
+};
+
+/**
+ * The KsCheckBoxTableWidget class provides a widget to hold a table of
+ * checkboxes.
+ */
+class KsCheckBoxTableWidget : public KsCheckBoxWidget
+{
+	Q_OBJECT
+public:
+	KsCheckBoxTableWidget(const QString &name =3D "",
+			      QWidget *parent =3D nullptr);
+
+protected:
+	void _adjustSize();
+
+	void _initTable(QStringList headers, int size);
+
+	/** The KsCheckBoxTable, shown by this widget. */
+	KsCheckBoxTable		_table;
+
+private:
+	void _setCheckState(int i, Qt::CheckState st) override
+	{
+		_table._cb[i]->setCheckState(st);
+	}
+
+	Qt::CheckState _checkState(int i) const override
+	{
+		return _table._cb[i]->checkState();
+	}
+
+	void _update(bool);
+
+	void _changeState(int row);
+};
+
+/** The KsCheckBoxTree class provides a tree of checkboxes. */
+class KsCheckBoxTree : public QTreeWidget
+{
+	Q_OBJECT
+public:
+	explicit KsCheckBoxTree(QWidget *parent =3D nullptr);
+
+signals:
+	/**
+	 * Signal emitted when a checkboxes of the tree changes its state
+	 * and the state of all toplevel and child checkboxes has to be
+	 * reprocesed.
+	 */
+	void verify();
+
+protected:
+	void keyPressEvent(QKeyEvent *event) override;
+
+	void mousePressEvent(QMouseEvent *event) override;
+
+private:
+	void _doubleClicked(QTreeWidgetItem *item, int col);
+};
+
+/**
+ * The KsCheckBoxTreeWidget class provides a widget to hold a tree of
+ * checkboxes.
+ */
+class KsCheckBoxTreeWidget : public KsCheckBoxWidget
+{
+	Q_OBJECT
+public:
+	KsCheckBoxTreeWidget() =3D delete;
+
+	KsCheckBoxTreeWidget(const QString &name =3D "",
+			     QWidget *parent =3D nullptr);
+
+protected:
+	void _adjustSize();
+
+	void _initTree();
+
+	/** The KsCheckBoxTree, shown by this widget. */
+	KsCheckBoxTree			_tree;
+
+	/** A vector of Tree items (checkboxes). */
+	QVector<QTreeWidgetItem*>	_cb;
+
+private:
+	void _setCheckState(int i, Qt::CheckState st) override
+	{
+		_cb[i]->setCheckState(0, st);
+	}
+
+	Qt::CheckState _checkState(int i) const override
+	{
+		return _cb[i]->checkState(0);
+	}
+
+	void _update(QTreeWidgetItem *item, int column);
+
+	void _verify();
+};
+
+/**
+ * The KsCPUCheckBoxWidget class provides a widget for selecting CPU plots=
 to
+ * show.
+ */
+struct KsCPUCheckBoxWidget : public KsCheckBoxTreeWidget
+{
+	KsCPUCheckBoxWidget() =3D delete;
+
+	KsCPUCheckBoxWidget(struct tep_handle *pe,
+			    QWidget *parent =3D nullptr);
+};
+
+/**
+ * The KsTasksCheckBoxWidget class provides a widget for selecting Tasks
+ * to show or hide.
+ */
+struct KsTasksCheckBoxWidget : public KsCheckBoxTableWidget
+{
+	KsTasksCheckBoxWidget() =3D delete;
+
+	KsTasksCheckBoxWidget(struct tep_handle *pe,
+			      bool cond =3D true,
+			      QWidget *parent =3D nullptr);
+
+private:
+	/**
+	 * A positive condition means that you want to show Tasks and
+	 * a negative condition means that you want to hide Tasks.
+	 */
+	bool		_cond;
+};
+
+/**
+ * The KsEventsCheckBoxWidget class provides a widget for selecting Trace
+ * events to show or hide.
+ */
+struct KsEventsCheckBoxWidget : public KsCheckBoxTreeWidget
+{
+	KsEventsCheckBoxWidget() =3D delete;
+
+	KsEventsCheckBoxWidget(struct tep_handle *pe,
+			       QWidget *parent =3D nullptr);
+};
+
+/**
+ * The KsPluginCheckBoxWidget class provides a widget for selecting plugin=
s.
+ */
+struct KsPluginCheckBoxWidget : public KsCheckBoxTableWidget
+{
+	KsPluginCheckBoxWidget() =3D delete;
+
+	KsPluginCheckBoxWidget(QStringList pluginList,
+			       QWidget *parent =3D nullptr);
+};
+
+class KsDataStore;
+class KsGLWidget;
+
+/**
+ * The KsQuickFilterMenu class provides a menu for easy filtering and plot=
ting.
+ * The menu is initialized from a single kshark_entry and uses the content=
 of
+ * this entry to provides quick actions for filtering and plottin.
+ */
+class KsQuickEntryMenu : public QMenu
+{
+	Q_OBJECT
+public:
+	KsQuickEntryMenu() =3D delete;
+
+	explicit KsQuickEntryMenu(KsDataStore *data,
+				  size_t row,
+				  QWidget *parent =3D nullptr);
+
+signals:
+	/** Signal to add a task plot. */
+	void plotTask(int);
+
+private:
+	void _hideTask();
+
+	void _showTask();
+
+	void _hideEvent();
+
+	void _showEvent();
+
+	void _addTaskPlot();
+
+	KsDataStore	*_data;
+
+	size_t		 _row;
+
+	QAction _hideTaskAction, _showTaskAction;
+
+	QAction _hideEventAction, _showEventAction;
+
+	QAction _addTaskPlotAction;
+};
+
+#endif
--=20
2.17.1

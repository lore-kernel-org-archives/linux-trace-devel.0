Return-Path: <SRS0=LhtG=MV=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:56928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726492AbeJJAAT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Oct 2018 20:00:19 -0400
Date: Tue, 9 Oct 2018 12:42:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: Re: [PATCH 3/4] kernel-shark-qt: Add Widgets Lib
Message-ID: <20181009124227.3cb70811@gandalf.local.home>
In-Reply-To: <20181008151629.13973-4-ykaradzhov@vmware.com>
References: <20181008151629.13973-1-ykaradzhov@vmware.com>
        <20181008151629.13973-4-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Mon,  8 Oct 2018 18:16:28 +0300
Yordan Karadzhov <y.karadz@gmail.com> wrote:

> From: Yordan Karadzhov <ykaradzhov@vmware.com>
> 
> This patch defines various small widgets and dialogues to be used by
> the KernelShark GUI.
> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  kernel-shark-qt/src/CMakeLists.txt   |   6 +-
>  kernel-shark-qt/src/KsWidgetsLib.cpp | 873 +++++++++++++++++++++++++++
>  kernel-shark-qt/src/KsWidgetsLib.hpp | 370 ++++++++++++
>  3 files changed, 1247 insertions(+), 2 deletions(-)
>  create mode 100644 kernel-shark-qt/src/KsWidgetsLib.cpp
>  create mode 100644 kernel-shark-qt/src/KsWidgetsLib.hpp
> 
> diff --git a/kernel-shark-qt/src/CMakeLists.txt b/kernel-shark-qt/src/CMakeLists.txt
> index e897e9a..2ac79ca 100644
> --- a/kernel-shark-qt/src/CMakeLists.txt
> +++ b/kernel-shark-qt/src/CMakeLists.txt
> @@ -31,11 +31,13 @@ endif (OPENGL_FOUND AND GLUT_FOUND)
>  if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
>  
>      message(STATUS "libkshark-gui")
> -    set (ks-guiLib_hdr  KsUtils.hpp)
> +    set (ks-guiLib_hdr  KsUtils.hpp
> +                        KsWidgetsLib.hpp)
>  
>      QT5_WRAP_CPP(ks-guiLib_hdr_moc ${ks-guiLib_hdr})
>  
> -    add_library(kshark-gui  SHARED  ${ks-guiLib_hdr_moc}    KsUtils.cpp)
> +    add_library(kshark-gui  SHARED  ${ks-guiLib_hdr_moc}    KsUtils.cpp
> +                                                            KsWidgetsLib.cpp)
>  
>      target_link_libraries(kshark-gui kshark-plot
>                                       ${CMAKE_DL_LIBS}
> diff --git a/kernel-shark-qt/src/KsWidgetsLib.cpp b/kernel-shark-qt/src/KsWidgetsLib.cpp
> new file mode 100644
> index 0000000..c6ae266
> --- /dev/null
> +++ b/kernel-shark-qt/src/KsWidgetsLib.cpp
> @@ -0,0 +1,873 @@
> +// SPDX-License-Identifier: LGPL-2.1
> +
> +/*
> + * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
> + */
> +
> +/**
> + *  @file    KsWidgetsLib.cpp
> + *  @brief   Defines small widgets and dialogues used by the KernelShark GUI.
> + */
> +
> +// KernelShark
> +#include "libkshark.h"
> +#include "KsUtils.hpp"
> +#include "KsCmakeDef.hpp"
> +#include "KsPlotTools.hpp"
> +#include "KsWidgetsLib.hpp"
> +
> +/**
> + * @brief Create KsProgressBar.
> + *
> + * @param message: Text to be shown.
> + * @param parent: The parent of this widget.
> + */
> +KsProgressBar::KsProgressBar(QString message, QWidget *parent)
> +: QWidget(parent),
> +  _sb(this),
> +  _pb(&_sb) {
> +	resize(FONT_WIDTH * 50, FONT_HEIGHT * 5);

Where did the magic numbers 50 and 5 come from?

Can we make them into macros that define what they are.

> +	setWindowTitle("KernelShark");
> +	setLayout(new QVBoxLayout);
> +
> +	_pb.setOrientation(Qt::Horizontal);
> +	_pb.setTextVisible(false);
> +	_pb.setRange(0, KS_PROGRESS_BAR_MAX);
> +	_pb.setValue(1);
> +
> +	_sb.addPermanentWidget(&_pb, 1);
> +
> +	layout()->addWidget(new QLabel(message));
> +	layout()->addWidget(&_sb);
> +
> +	setWindowFlags(Qt::WindowStaysOnTopHint);
> +
> +	show();
> +}
> +
> +/** @brief Set the state of the progressbar.
> + *
> + * @param i: A value ranging from 0 to KS_PROGRESS_BAR_MAX.
> + */
> +void KsProgressBar::setValue(int i) {
> +	_pb.setValue(i);
> +	QApplication::processEvents();
> +}
> +
> +/**
> + * @brief Create KsMessageDialog.
> + *
> + * @param message: Text to be shown.
> + * @param parent: The parent of this widget.
> + */
> +KsMessageDialog::KsMessageDialog(QString message, QWidget *parent)
> +: QDialog(parent),
> +  _text(message, this),
> +  _closeButton("Close", this)
> +{
> +	resize(SCREEN_WIDTH / 10, FONT_HEIGHT * 8);

Same here with 10 and 8.

> +
> +	_layout.addWidget(&_text);
> +	_layout.addWidget(&_closeButton);
> +
> +	connect(&_closeButton,	&QPushButton::pressed,
> +		this,		&QWidget::close);
> +
> +	this->setLayout(&_layout);
> +}
> +
> +/**
> + * @brief Create KsCheckBoxWidget.
> + *
> + * @param name: The name of this widget.
> + * @param parent: The parent of this widget.
> + */
> +KsCheckBoxWidget::KsCheckBoxWidget(const QString &name, QWidget *parent)
> +: QWidget(parent),
> +  _allCb("all", this),
> +  _cbWidget(this),
> +  _cbLayout(&_cbWidget),
> +  _topLayout(this),
> +  _name(name),
> +  _nameLabel(name + ":  ")
> +{
> +	setWindowTitle(_name);
> +	setMinimumHeight(SCREEN_HEIGHT / 2);
> +
> +	connect(&_allCb,	&QCheckBox::clicked,
> +		this,		&KsCheckBoxWidget::_checkAll);
> +
> +	_cbWidget.setLayout(&_cbLayout);
> +
> +	QToolBar *tb = new QToolBar(this);
> +
> +	tb->addWidget(&_nameLabel);
> +	tb->addWidget(&_allCb);
> +	_topLayout.addWidget(tb);
> +
> +	_topLayout.addWidget(&_cbWidget);
> +	_topLayout.setContentsMargins(0, 0, 0, 0);
> +
> +	setLayout(&_topLayout);
> +	_allCb.setCheckState(Qt::Checked);
> +}
> +
> +/**
> + * Set the default state for all checkboxes (including the "all" checkbox).
> + */
> +void KsCheckBoxWidget::setDefault(bool st)
> +{
> +	Qt::CheckState state = Qt::Unchecked;
> +
> +	if (st)
> +		state = Qt::Checked;
> +
> +	_allCb.setCheckState(state);
> +	_checkAll(state);
> +}
> +
> +/** Get a vector containing the indexes of all checked boxes. */
> +QVector<int> KsCheckBoxWidget::getCheckedIds()
> +{
> +	QVector<int> vec;
> +	int n = _id.size();
> +
> +	for (int i = 0; i < n; ++i)
> +		if (_checkState(i) == Qt::Checked)
> +			vec.append(_id[i]);
> +
> +	return vec;
> +}
> +
> +/**
> + * @brief Set the state of the checkboxes.
> + *
> + * @param v: Vector containing the bool values for all checkboxes.
> + */
> +void KsCheckBoxWidget::set(QVector<bool> v)
> +{
> +	Qt::CheckState state;
> +	int nChecks;
> +
> +	nChecks = (v.size() < _id.size()) ? v.size() : _id.size();
> +
> +	/* Start with the "all" checkbox being checked. */
> +	_allCb.setCheckState(Qt::Checked);
> +	for (int i = 0; i < nChecks; ++i) {
> +		if (v[i]) {
> +			state = Qt::Checked;
> +		} else {
> +			/*
> +			 * At least one checkbox is unchecked. Uncheck
> +			 * "all" as well.
> +			 */
> +			state = Qt::Unchecked;
> +			_allCb.setCheckState(state);
> +		}
> +
> +		_setCheckState(i, state);
> +	}
> +	_verify();
> +}
> +
> +void KsCheckBoxWidget::_checkAll(bool st)
> +{
> +	Qt::CheckState state = Qt::Unchecked;
> +	int n = _id.size();
> +
> +	if (st) state = Qt::Checked;
> +
> +	for (int i = 0; i < n; ++i) {
> +		_setCheckState(i, state);
> +	}
> +
> +	_verify();
> +}
> +
> +/**
> + * @brief Create KsCheckBoxDialog.
> + *
> + * @param cbw: A KsCheckBoxWidget to be nested in this dialog.
> + * @param parent: The parent of this widget.
> + */
> +KsCheckBoxDialog::KsCheckBoxDialog(KsCheckBoxWidget *cbw, QWidget *parent)
> +: QDialog(parent), _checkBoxWidget(cbw),
> +  _applyButton("Apply", this),
> +  _cancelButton("Cancel", this)
> +{
> +	int buttonWidth;
> +
> +	setWindowTitle(cbw->name());
> +	_topLayout.addWidget(_checkBoxWidget);
> +
> +	buttonWidth = STRING_WIDTH("--Cancel--");
> +	_applyButton.setFixedWidth(buttonWidth);
> +	_cancelButton.setFixedWidth(buttonWidth);
> +
> +	_buttonLayout.addWidget(&_applyButton);
> +	_applyButton.setAutoDefault(false);
> +
> +	_buttonLayout.addWidget(&_cancelButton);
> +	_cancelButton.setAutoDefault(false);
> +
> +	_buttonLayout.setAlignment(Qt::AlignLeft);
> +	_topLayout.addLayout(&_buttonLayout);
> +
> +	_applyButtonConnection =
> +		connect(&_applyButton,	&QPushButton::pressed,
> +			this,		&KsCheckBoxDialog::_applyPress);
> +
> +	connect(&_applyButton,	&QPushButton::pressed,
> +		this,		&QWidget::close);
> +
> +	connect(&_cancelButton,	&QPushButton::pressed,
> +		this,		&QWidget::close);
> +
> +	this->setLayout(&_topLayout);
> +}
> +
> +void KsCheckBoxDialog::_applyPress()
> +{
> +	QVector<int> vec = _checkBoxWidget->getCheckedIds();
> +	emit apply(vec);
> +
> +	/*
> +	 * Disconnect _applyButton. This is done in order to protect
> +	 * against multiple clicks.
> +	 */
> +	disconnect(_applyButtonConnection);
> +}
> +
> +
> +/**
> + * @brief Create KsCheckBoxTable.
> + *
> + * @param parent: The parent of this widget.
> + */
> +KsCheckBoxTable::KsCheckBoxTable(QWidget *parent)
> +: QTableWidget(parent)
> +{
> +	setShowGrid(false);
> +	horizontalHeader()->setDefaultAlignment(Qt::AlignLeft);
> +	horizontalHeader()->setStretchLastSection(true);
> +	setSelectionBehavior(QAbstractItemView::SelectRows);
> +	setEditTriggers(QAbstractItemView::NoEditTriggers);
> +	setHorizontalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
> +	verticalHeader()->setVisible(false);
> +
> +	connect(this, &QTableWidget::cellDoubleClicked,
> +		this, &KsCheckBoxTable::_doubleClicked);
> +}
> +
> +/**
> + * @brief Initialize the table.
> + *
> + * @param headers: The headers of the individual columns.
> + * @param size: The number of rows.
> + */
> +void KsCheckBoxTable::init(QStringList headers, int size)
> +{
> +	QHBoxLayout *cbLayout;
> +	QWidget *cbWidget;
> +
> +	setColumnCount(headers.count());
> +	setRowCount(size);
> +	setHorizontalHeaderLabels(headers);
> +
> +	_cb.resize(size);
> +
> +	for (int i = 0; i < size; ++i) {
> +		cbWidget = new QWidget();
> +		_cb[i] = new QCheckBox(cbWidget);
> +		cbLayout = new QHBoxLayout(cbWidget);
> +
> +		cbLayout->addWidget(_cb[i]);
> +		cbLayout->setAlignment(Qt::AlignCenter);
> +		cbLayout->setContentsMargins(0, 0, 0, 0);
> +
> +		cbWidget->setLayout(cbLayout);
> +		setCellWidget(i, 0, cbWidget);
> +	}
> +}
> +
> +/** Reimplemented event handler used to receive key press events. */
> +void KsCheckBoxTable::keyPressEvent(QKeyEvent *event)
> +{
> +	if (event->key() == Qt::Key_Return) {
> +		for (auto &s: selectedItems()) {
> +			if (s->column() == 1)
> +				emit changeState(s->row());
> +		}
> +	}
> +
> +	QApplication::processEvents();
> +	QTableWidget::keyPressEvent(event);
> +}
> +
> +/** Reimplemented event handler used to receive mouse press events. */
> +void KsCheckBoxTable::mousePressEvent(QMouseEvent *event)
> +{
> +	if (event->button() == Qt::RightButton) {
> +		for (auto &i: selectedItems())
> +			i->setSelected(false);
> +
> +		return;
> +	}
> +
> +	QApplication::processEvents();
> +	QTableWidget::mousePressEvent(event);
> +}
> +
> +void KsCheckBoxTable::_doubleClicked(int row, int col)
> +{
> +	emit changeState(row);
> +	for (auto &i: selectedItems())
> +		i->setSelected(false);
> +}
> +
> +/**
> + * @brief Create KsCheckBoxTableWidget.
> + *
> + * @param name: The name of this widget.
> + * @param parent: The parent of this widget.
> + */
> +KsCheckBoxTableWidget::KsCheckBoxTableWidget(const QString &name,
> +					     QWidget *parent)
> +: KsCheckBoxWidget(name, parent),
> +  _table(this)
> +{
> +	connect(&_table,	&KsCheckBoxTable::changeState,
> +		this,		&KsCheckBoxTableWidget::_changeState);
> +}
> +
> +/** Initialize the KsCheckBoxTable and its layout. */
> +void KsCheckBoxTableWidget::_initTable(QStringList headers, int size)
> +{
> +	_table.init(headers, size);
> +
> +	for (auto const & cb: _table._cb) {
> +		connect(cb,	&QCheckBox::clicked,
> +			this,	&KsCheckBoxTableWidget::_update);
> +	}
> +
> +	_cbLayout.setContentsMargins(1, 1, 1, 1);
> +	_cbLayout.addWidget(&_table);
> +}
> +
> +/** Adjust the size of this widget according to its content. */
> +void KsCheckBoxTableWidget::_adjustSize()
> +{
> +	int width;
> +
> +	_table.setVisible(false);
> +	_table.resizeColumnsToContents();
> +	_table.setVisible(true);
> +
> +	width = _table.horizontalHeader()->length() +
> +		FONT_WIDTH * 3 +
> +		style()->pixelMetric(QStyle::PM_ScrollBarExtent);
> +
> +	_cbWidget.resize(width, _cbWidget.height());
> +
> +	setMinimumWidth(_cbWidget.width() +
> +			_cbLayout.contentsMargins().left() +
> +			_cbLayout.contentsMargins().right() +
> +			_topLayout.contentsMargins().left() +
> +			_topLayout.contentsMargins().right());
> +}
> +
> +void  KsCheckBoxTableWidget::_update(bool state)
> +{
> +	/* If a Checkbox is being unchecked. Unchecked "all" as well. */
> +	if (!state)
> +		_allCb.setCheckState(Qt::Unchecked);
> +}
> +
> +void KsCheckBoxTableWidget::_changeState(int row)
> +{
> +	if (_table._cb[row]->checkState() == Qt::Checked)
> +		_table._cb[row]->setCheckState(Qt::Unchecked);
> +	else
> +		_table._cb[row]->setCheckState(Qt::Checked);
> +
> +	_allCb.setCheckState(Qt::Checked);
> +	for (auto &c: _table._cb) {
> +		if (c->checkState() == Qt::Unchecked) {
> +			_allCb.setCheckState(Qt::Unchecked);
> +			break;
> +		}
> +	}
> +}
> +
> +static void update_r(QTreeWidgetItem *item, Qt::CheckState state)
> +{
> +	int n;
> +
> +	item->setCheckState(0, state);
> +
> +	n = item->childCount();
> +	for (int i = 0; i < n; ++i)
> +		update_r(item->child(i), state);
> +}
> +
> +/**
> + * @brief Create KsCheckBoxTree.
> + *
> + * @param parent: The parent of this widget.
> + */
> +KsCheckBoxTree::KsCheckBoxTree(QWidget *parent)
> +: QTreeWidget(parent)
> +{
> +	setColumnCount(2);
> +	setHeaderHidden(true);
> +	setSelectionBehavior(QAbstractItemView::SelectRows);
> +	setHorizontalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
> +
> +	connect(this, &KsCheckBoxTree::itemDoubleClicked,
> +		this, &KsCheckBoxTree::_doubleClicked);
> +}
> +
> +/** Reimplemented event handler used to receive key press events. */
> +void KsCheckBoxTree::keyPressEvent(QKeyEvent *event)
> +{
> +	if (event->key() == Qt::Key_Return) {
> +		/* Loop over all selected child items and change
> +		* there states. */
> +		for (auto &s: selectedItems()) {
> +			if(s->childCount()) {
> +				if (s->isExpanded())
> +					continue;
> +			}
> +
> +			if (s->checkState(0) == Qt::Unchecked)
> +				s->setCheckState(0, Qt::Checked);
> +			else
> +				s->setCheckState(0, Qt::Unchecked);
> +
> +			if(s->childCount()) {
> +				update_r(s, s->checkState(0));
> +			}
> +		}
> +	}
> +
> +	emit verify();
> +	QTreeWidget::keyPressEvent(event);
> +}
> +
> +void KsCheckBoxTree::_doubleClicked(QTreeWidgetItem *item, int col)
> +{
> +	if (item->checkState(0) == Qt::Unchecked)
> +		item->setCheckState(0, Qt::Checked);
> +	else
> +		item->setCheckState(0, Qt::Unchecked);
> +
> +	for (auto &i: selectedItems())
> +		i->setSelected(false);
> +
> +	emit itemClicked(item, col);
> +}
> +
> +/** Reimplemented event handler used to receive mouse press events. */
> +void KsCheckBoxTree::mousePressEvent(QMouseEvent *event)
> +{
> +	if (event->button() == Qt::RightButton) {
> +		for (auto &i: selectedItems())
> +			i->setSelected(false);
> +		return;
> +	}
> +
> +	QApplication::processEvents();
> +	QTreeWidget::mousePressEvent(event);
> +}
> +
> +/**
> + * @brief Create KsCheckBoxTreeWidget.
> + *
> + * @param name: The name of this widget.
> + * @param parent: The parent of this widget.
> + */
> +KsCheckBoxTreeWidget::KsCheckBoxTreeWidget(const QString &name,
> +					   QWidget *parent)
> +: KsCheckBoxWidget(name, parent),
> +  _tree(this)
> +{
> +	connect(&_tree,	&KsCheckBoxTree::verify,
> +		this,	&KsCheckBoxTreeWidget::_verify);
> +}
> +
> +/** Initialize the KsCheckBoxTree and its layout. */
> +void KsCheckBoxTreeWidget::_initTree()
> +{
> +	_tree.setSelectionMode(QAbstractItemView::MultiSelection);
> +
> +	connect(&_tree, &QTreeWidget::itemClicked,
> +		this,	&KsCheckBoxTreeWidget::_update);
> +
> +	_cbLayout.setContentsMargins(1, 1, 1, 1);
> +	_cbLayout.addWidget(&_tree);
> +}
> +
> +/** Adjust the size of this widget according to its content. */
> +void KsCheckBoxTreeWidget::_adjustSize()
> +{
> +	int width, n = _tree.topLevelItemCount();
> +	if (n == 0)
> +		return;
> +
> +	for (int i = 0; i < n; ++i)
> +		_tree.topLevelItem(i)->setExpanded(true);
> +
> +	_tree.resizeColumnToContents(0);
> +	if (_tree.topLevelItem(0)->child(0)) {
> +		width = _tree.visualItemRect(_tree.topLevelItem(0)->child(0)).width();
> +	} else {
> +		width = _tree.visualItemRect(_tree.topLevelItem(0)).width();
> +	}
> +
> +	width += FONT_WIDTH*3 + style()->pixelMetric(QStyle::PM_ScrollBarExtent);
> +	_cbWidget.resize(width, _cbWidget.height());
> +
> +	for (int i = 0; i < n; ++i)
> +		_tree.topLevelItem(i)->setExpanded(false);
> +
> +	setMinimumWidth(_cbWidget.width() +
> +			_cbLayout.contentsMargins().left() +
> +			_cbLayout.contentsMargins().right() +
> +			_topLayout.contentsMargins().left() +
> +			_topLayout.contentsMargins().right());
> +}
> +
> +void KsCheckBoxTreeWidget::_update(QTreeWidgetItem *item, int column)
> +{
> +	/* Get the new state of the item. */
> +	Qt::CheckState state = item->checkState(0);
> +
> +	/* Recursively update all items below this one. */
> +	update_r(item, state);
> +
> +	/* Update all items above this one including the "all"
> +	 * check box. */

The above comment format needs to be fixed.

> +	_verify();
> +}
> +
> +void KsCheckBoxTreeWidget::_verify()
> +{
> +	/* Set the state of the top level items according to the
> +	* state of the childs. */

The above one too.

-- Steve

> +	QTreeWidgetItem *topItem, *childItem;
> +	for(int t = 0; t < _tree.topLevelItemCount(); ++t) {
> +		topItem = _tree.topLevelItem(t);
> +		if (topItem->childCount() == 0)
> +			continue;
> +
> +		topItem->setCheckState(0, Qt::Checked);
> +		for (int c = 0; c < topItem->childCount(); ++c) {
> +			childItem = topItem->child(c);
> +			if (childItem->checkState(0) == Qt::Unchecked)
> +				topItem->setCheckState(0, Qt::Unchecked);
> +		}
> +	}
> +
> +	_allCb.setCheckState(Qt::Checked);
> +	for (auto &c: _cb) {
> +		if (c->checkState(0) == Qt::Unchecked) {
> +			_allCb.setCheckState(Qt::Unchecked);
> +			break;
> +		}
> +	}
> +}
> +

Return-Path: <SRS0=XQBu=M4=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-sn1nam01on0073.outbound.protection.outlook.com ([104.47.32.73]:27872
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726986AbeJPXoS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Oct 2018 19:44:18 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>,
        Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH v2 04/23] kernel-shark-qt: Add Trace Viewer widget.
Date: Tue, 16 Oct 2018 15:53:01 +0000
Message-ID: <20181016155232.5257-5-ykaradzhov@vmware.com>
References: <20181016155232.5257-1-ykaradzhov@vmware.com>
In-Reply-To: <20181016155232.5257-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: Yordan Karadzhov (VMware) <y.karadz@gmail.com>

This patch defines widget for browsing in the trace data shown in a text
form. The provides a search panel and a Table view area. The panel and
the table are integrated with the Dual Marker.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/src/CMakeLists.txt    |   6 +-
 kernel-shark-qt/src/KsTraceViewer.cpp | 657 ++++++++++++++++++++++++++
 kernel-shark-qt/src/KsTraceViewer.hpp | 149 ++++++
 3 files changed, 810 insertions(+), 2 deletions(-)
 create mode 100644 kernel-shark-qt/src/KsTraceViewer.cpp
 create mode 100644 kernel-shark-qt/src/KsTraceViewer.hpp

diff --git a/kernel-shark-qt/src/CMakeLists.txt b/kernel-shark-qt/src/CMake=
Lists.txt
index 3fd518b..3f40930 100644
--- a/kernel-shark-qt/src/CMakeLists.txt
+++ b/kernel-shark-qt/src/CMakeLists.txt
@@ -34,14 +34,16 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
     set (ks-guiLib_hdr  KsUtils.hpp
                         KsModels.hpp
                         KsDualMarker.hpp
-                        KsWidgetsLib.hpp)
+                        KsWidgetsLib.hpp
+                        KsTraceViewer.hpp)
=20
     QT5_WRAP_CPP(ks-guiLib_hdr_moc ${ks-guiLib_hdr})
=20
     add_library(kshark-gui  SHARED  ${ks-guiLib_hdr_moc}    KsUtils.cpp
                                                             KsModels.cpp
                                                             KsDualMarker.c=
pp
-                                                            KsWidgetsLib.c=
pp)
+                                                            KsWidgetsLib.c=
pp
+                                                            KsTraceViewer.=
cpp)
=20
     target_link_libraries(kshark-gui kshark-plot
                                      ${CMAKE_DL_LIBS}
diff --git a/kernel-shark-qt/src/KsTraceViewer.cpp b/kernel-shark-qt/src/Ks=
TraceViewer.cpp
new file mode 100644
index 0000000..7f12365
--- /dev/null
+++ b/kernel-shark-qt/src/KsTraceViewer.cpp
@@ -0,0 +1,657 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
+ */
+
+/**
+ *  @file    KsTraceViewer.cpp
+ *  @brief   KernelShark Trace Viewer widget.
+ */
+
+// C++11
+#include <thread>
+#include <future>
+
+// KernelShark
+#include "KsTraceViewer.hpp"
+#include "KsWidgetsLib.hpp"
+
+/** Create a default (empty) Trace viewer widget. */
+KsTraceViewer::KsTraceViewer(QWidget *parent)
+: QWidget(parent),
+  _view(this),
+  _model(this),
+  _proxyModel(this),
+  _tableHeader(_model.header()),
+  _toolbar(this),
+  _labelSearch("Search: Column", this),
+  _labelGrFollows("Graph follows  ", this),
+  _columnComboBox(this),
+  _selectComboBox(this),
+  _searchLineEdit(this),
+  _prevButton("Prev", this),
+  _nextButton("Next", this),
+  _searchStopButton(QIcon::fromTheme("process-stop"), "", this),
+  _pbAction(nullptr),
+  _graphFollowsCheckBox(this),
+  _searchProgBar(this),
+  _searchCountLabel("", this),
+  _searchDone(false),
+  _graphFollows(true),
+  _mState(nullptr),
+  _data(nullptr)
+{
+	int bWidth;
+
+	this->setSizePolicy(QSizePolicy::Preferred, QSizePolicy::Maximum);
+
+	/* Make a search toolbar. */
+	_toolbar.setOrientation(Qt::Horizontal);
+	_toolbar.setMaximumHeight(FONT_HEIGHT * 1.75);
+
+	/* On the toolbar make two Combo boxes for the search settings. */
+	_toolbar.addWidget(&_labelSearch);
+	_columnComboBox.addItems(_tableHeader);
+
+	/*
+	 * Using the old Signal-Slot syntax because
+	 * QComboBox::currentIndexChanged has overloads.
+	 */
+	connect(&_columnComboBox,	SIGNAL(currentIndexChanged(int)),
+		this,			SLOT(_searchEdit(int)));
+
+	_toolbar.addWidget(&_columnComboBox);
+
+	_selectComboBox.addItem("contains");
+	_selectComboBox.addItem("full match");
+	_selectComboBox.addItem("does not have");
+
+	/*
+	 * Using the old Signal-Slot syntax because
+	 * QComboBox::currentIndexChanged has overloads.
+	 */
+	connect(&_selectComboBox,	SIGNAL(currentIndexChanged(int)),
+		this,			SLOT(_searchEdit(int)));
+
+	_toolbar.addWidget(&_selectComboBox);
+
+	/* On the toolbar, make a Line edit field for search. */
+	_searchLineEdit.setMaximumWidth(FONT_WIDTH * 20);
+
+	connect(&_searchLineEdit,	&QLineEdit::returnPressed,
+		this,			&KsTraceViewer::_search);
+
+	connect(&_searchLineEdit,	&QLineEdit::textEdited,
+		this,			&KsTraceViewer::_searchEditText);
+
+	_toolbar.addWidget(&_searchLineEdit);
+	_toolbar.addSeparator();
+
+	/* On the toolbar, add Prev & Next buttons. */
+	bWidth =3D FONT_WIDTH * 6;
+
+	_nextButton.setFixedWidth(bWidth);
+	_toolbar.addWidget(&_nextButton);
+	connect(&_nextButton,	&QPushButton::pressed,
+		this,		&KsTraceViewer::_next);
+
+	_prevButton.setFixedWidth(bWidth);
+	_toolbar.addWidget(&_prevButton);
+	connect(&_prevButton,	&QPushButton::pressed,
+		this,		&KsTraceViewer::_prev);
+
+	_toolbar.addSeparator();
+	_searchProgBar.setMaximumWidth(FONT_WIDTH * 10);
+	_searchProgBar.setRange(0, 200);
+	_pbAction =3D _toolbar.addWidget(&_searchProgBar);
+	_pbAction->setVisible(false);
+	_toolbar.addWidget(&_searchCountLabel);
+	_searchStopAction =3D _toolbar.addWidget(&_searchStopButton);
+	_searchStopAction->setVisible(false);
+	connect(&_searchStopButton,	&QPushButton::pressed,
+		this,			&KsTraceViewer::_searchStop);
+
+	/*
+	 * On the toolbar, make a Check box for connecting the search pannel
+	 * to the Graph widget.
+	 */
+	_toolbar.addSeparator();
+	_toolbar.addWidget(&_graphFollowsCheckBox);
+	_toolbar.addWidget(&_labelGrFollows);
+	_graphFollowsCheckBox.setCheckState(Qt::Checked);
+	connect(&_graphFollowsCheckBox,	&QCheckBox::stateChanged,
+		this,			&KsTraceViewer::_graphFollowsChanged);
+
+	/* Initialize the trace viewer. */
+	_view.horizontalHeader()->setDefaultAlignment(Qt::AlignLeft);
+	_view.verticalHeader()->setVisible(false);
+	_view.setEditTriggers(QAbstractItemView::NoEditTriggers);
+	_view.setSelectionBehavior(QAbstractItemView::SelectRows);
+	_view.setSelectionMode(QAbstractItemView::SingleSelection);
+	_view.verticalHeader()->setDefaultSectionSize(FONT_HEIGHT * 1.25);
+
+	 _proxyModel.setSource(&_model);
+	_view.setModel(&_proxyModel);
+	connect(&_proxyModel, &QAbstractItemModel::modelReset,
+		this, &KsTraceViewer::_searchReset);
+
+	_view.setContextMenuPolicy(Qt::CustomContextMenu);
+	connect(&_view,	&QTableView::customContextMenuRequested,
+		this,	&KsTraceViewer::_onCustomContextMenu);
+
+	connect(&_view,	&QTableView::clicked,
+		this,	&KsTraceViewer::_clicked);
+
+	/* Set the layout. */
+	_layout.addWidget(&_toolbar);
+	_layout.addWidget(&_view);
+	this->setLayout(&_layout);
+}
+
+/**
+ * @brief Load and show trace data.
+ *
+ * @param data: Input location for the KsDataStore object.
+ *	  KsDataStore::loadDataFile() must be called first.
+ */
+void KsTraceViewer::loadData(KsDataStore *data)
+{
+	_data =3D data;
+	_model.reset();
+	_proxyModel.fill(data);
+	_model.fill(data);
+	this->_resizeToContents();
+
+	this->setMinimumHeight(SCREEN_HEIGHT / 5);
+}
+
+/** Connect the QTableView widget and the State machine of the Dual marker=
. */
+void KsTraceViewer::setMarkerSM(KsDualMarkerSM *m)
+{
+	QString styleSheetA, styleSheetB;
+
+	_mState =3D m;
+	_model.setColors(_mState->markerA()._color,
+			 _mState->markerB()._color);
+
+	/*
+	 * Assign a property to State A of the Dual marker state machine. When
+	 * the marker is in State A the background color of the selected row
+	 * will be the same as the color of Marker A.
+	 */
+	styleSheetA =3D "selection-background-color : " +
+		      _mState->markerA()._color.name() + ";";
+
+	_mState->stateAPtr()->assignProperty(&_view, "styleSheet",
+						     styleSheetA);
+
+	/*
+	 * Assign a property to State B. When the marker is in State B the
+	 * background color of the selected row will be the same as the color
+	 * of Marker B.
+	 */
+	styleSheetB =3D "selection-background-color : " +
+		      _mState->markerB()._color.name() + ";";
+
+	_mState->stateBPtr()->assignProperty(&_view, "styleSheet",
+						     styleSheetB);
+}
+
+/** Reset (empty) the table. */
+void KsTraceViewer::reset()
+{
+	this->setMinimumHeight(FONT_HEIGHT * 10);
+	_model.reset();
+	_resizeToContents();
+}
+
+void KsTraceViewer::_searchReset()
+{
+	_searchProgBar.setValue(0);
+	_searchCountLabel.setText("");
+	_proxyModel.searchProgress();
+	_searchDone =3D false;
+}
+
+/** Get the index of the first (top) visible row. */
+size_t  KsTraceViewer::getTopRow() const
+{
+	return _view.indexAt(_view.rect().topLeft()).row();
+}
+
+/** Position given row at the top of the table. */
+void  KsTraceViewer::setTopRow(size_t r)
+{
+	_view.scrollTo(_proxyModel.index(r, 0),
+		       QAbstractItemView::PositionAtTop);
+}
+
+/** Update the content of the table. */
+void KsTraceViewer::update(KsDataStore *data)
+{
+	/* The Proxy model has to be updated first! */
+	_proxyModel.fill(data);
+	_model.update(data);
+	_data =3D data;
+	if (_mState->activeMarker()._isSet)
+		showRow(_mState->activeMarker()._pos, true);
+}
+
+void KsTraceViewer::_onCustomContextMenu(const QPoint &point)
+{
+	QModelIndex i =3D _view.indexAt(point);
+
+	if (i.isValid()) {
+		/*
+		 * Use the index of the proxy model to retrieve the value
+		 * of the row number in the source model.
+		 */
+		size_t row =3D _proxyModel.mapRowFromSource(i.row());
+		KsQuickEntryMenu menu(_data, row, this);
+
+		connect(&menu,	&KsQuickEntryMenu::plotTask,
+			this,	&KsTraceViewer::plotTask);
+
+		menu.exec(mapToGlobal(point));
+	}
+}
+
+void KsTraceViewer::_searchEdit(int index)
+{
+	_searchReset(); // The search has been modified.
+}
+
+void KsTraceViewer::_searchEditText(const QString &text)
+{
+	_searchReset(); // The search has been modified.
+}
+
+void KsTraceViewer::_graphFollowsChanged(int state)
+{
+	_graphFollows =3D (bool) state;
+
+	if (_graphFollows && _searchDone)
+		emit select(*_it); // Send a signal to the Graph widget.
+}
+
+static bool notHaveCond(QString searchText, QString itemText)
+{
+	return !itemText.contains(searchText, Qt::CaseInsensitive);
+}
+
+static bool containsCond(QString searchText, QString itemText)
+{
+	return itemText.contains(searchText, Qt::CaseInsensitive);
+}
+
+static bool matchCond(QString searchText, QString itemText)
+{
+	return (itemText.compare(searchText, Qt::CaseInsensitive) =3D=3D 0);
+}
+
+void KsTraceViewer::_search()
+{
+	/* Disable the user input until the search is done. */
+	_searchLineEdit.setReadOnly(true);
+	if (!_searchDone) {
+		int xColumn, xSelect;
+		QString xText;
+
+		/*
+		 * The search is not done. This means that the search settings
+		 * have been modified since the last time we searched.
+		 */
+		_matchList.clear();
+		xText =3D _searchLineEdit.text();
+		xColumn =3D _columnComboBox.currentIndex();
+		xSelect =3D _selectComboBox.currentIndex();
+
+		switch (xSelect) {
+			case Condition::Containes:
+				_searchItems(xColumn, xText, &containsCond);
+				break;
+
+			case Condition::Match:
+				_searchItems(xColumn, xText, &matchCond);
+				break;
+
+			case Condition::NotHave:
+				_searchItems(xColumn, xText, &notHaveCond);
+				break;
+
+			default:
+				break;
+		}
+
+		if (!_matchList.empty()) {
+			this->showRow(*_it, true);
+
+			if (_graphFollows)
+				emit select(*_it); // Send a signal to the Graph widget.
+		}
+	} else {
+		/*
+		 * If the search is done, pressing "Enter" is equivalent
+		 * to pressing "Next" button.
+		 */
+		this->_next();
+	}
+
+	/* Enable the user input. */
+	_searchLineEdit.setReadOnly(false);
+}
+
+void KsTraceViewer::_next()
+{
+	if (!_searchDone) {
+		_search();
+		return;
+	}
+
+	if (!_matchList.empty()) { // Items have been found.
+		++_it; // Move the iterator.
+		if (_it =3D=3D _matchList.end() ) {
+			// This is the last item of the list. Go back to the beginning.
+			_it =3D _matchList.begin();
+		}
+
+		// Select the row of the item.
+		showRow(*_it, true);
+
+		if (_graphFollows)
+			emit select(*_it); // Send a signal to the Graph widget.
+	}
+}
+
+void KsTraceViewer::_prev()
+{
+	if (!_searchDone) {
+		_search();
+		return;
+	}
+
+	if (!_matchList.empty()) { // Items have been found.
+		if (_it =3D=3D _matchList.begin()) {
+			// This is the first item of the list. Go to the last item.
+			_it =3D _matchList.end() - 1;
+		} else {
+			--_it; // Move the iterator.
+		}
+
+		// Select the row of the item.
+		showRow(*_it, true);
+
+		if (_graphFollows)
+			emit select(*_it); // Send a signal to the Graph widget.
+	}
+}
+
+void KsTraceViewer::_searchStop()
+{
+	_searchStopAction->setVisible(false);
+	_proxyModel.searchStop();
+}
+
+void KsTraceViewer::_clicked(const QModelIndex& i)
+{
+	if (_graphFollows) {
+		/*
+		 * Use the index of the proxy model to retrieve the value
+		 * of the row number in the base model.
+		 */
+		size_t row =3D _proxyModel.mapRowFromSource(i.row());
+		emit select(row); // Send a signal to the Graph widget.
+	}
+}
+
+/** Make a given row of the table visible. */
+void KsTraceViewer::showRow(size_t r, bool mark)
+{
+	/*
+	 * Use the index in the source model to retrieve the value of the row num=
ber
+	 * in the proxy model.
+	 */
+	QModelIndex index =3D _proxyModel.mapFromSource(_model.index(r, 0));
+
+	if (mark) { // The row will be selected (colored).
+		/* Get the first and the last visible rows of the table. */
+		int visiTot =3D _view.indexAt(_view.rect().topLeft()).row();
+		int visiBottom =3D _view.indexAt(_view.rect().bottomLeft()).row() - 2;
+
+		/* Scroll only if the row to be shown in not vizible. */
+		if (index.row() < visiTot || index.row() > visiBottom)
+			_view.scrollTo(index, QAbstractItemView::PositionAtCenter);
+
+		_view.selectRow(index.row());
+	} else {
+		/*
+		 * Just make sure that the row is visible. It will show up at
+		 * the top of the visible part of the table.
+		 */
+		_view.scrollTo(index, QAbstractItemView::PositionAtTop);
+	}
+}
+
+/** Deselects the selected items (row) if any. */
+void KsTraceViewer::deselect()
+{
+	_view.clearSelection();
+}
+
+/** Switch the Dual marker. */
+void KsTraceViewer::markSwitch()
+{
+	/* The state of the Dual marker has changed. Get the new active marker. *=
/
+	DualMarkerState state =3D _mState->getState();
+
+	/* First deal with the passive marker. */
+	if (_mState->getMarker(!state)._isSet) {
+		/*
+		 * The passive marker is set. Use the model to color the row of
+		 * the passive marker.
+		 */
+		_model.selectRow(!state, _mState->getMarker(!state)._pos);
+	}
+	else {
+		/*
+		 * The passive marker is not set.
+		 * Make sure that the model colors nothing.
+		 */
+		_model.selectRow(!state, -1);
+	}
+
+	/*
+	 * Now deal with the active marker. This has to be done after dealing
+	 *  with the model, because changing the model clears the selection.
+	 */
+	if (_mState->getMarker(state)._isSet) {
+		/*
+		 * The active marker is set. Use QTableView to select its row.
+		 * The index in the source model is used to retrieve the value
+		 * of the row number in the proxy model.
+		 */
+		size_t row =3D_mState->getMarker(state)._pos;
+
+		QModelIndex index =3D _proxyModel.mapFromSource(_model.index(row, 0));
+
+		/*
+		 * The row of the active marker will be colored according to
+		 * the assigned property of the current state of the Dual marker.
+		 */
+		_view.selectRow(index.row());
+	} else {
+		_view.clearSelection();
+	}
+}
+
+/**
+ * Reimplemented event handler used to update the geometry of the widget o=
n
+ * resize events.
+ */
+void KsTraceViewer::resizeEvent(QResizeEvent* event)
+{
+	int nColumns =3D _tableHeader.count();
+	int tableSize(0), viewSize, freeSpace;
+
+	for (int c =3D 0; c < nColumns; ++c) {
+		tableSize +=3D _view.columnWidth(c);
+	}
+
+	viewSize =3D _view.width() -
+		   qApp->style()->pixelMetric(QStyle::PM_ScrollBarExtent);
+
+	if ((freeSpace =3D viewSize - tableSize) > 0) {
+		_view.setColumnWidth(nColumns - 1, _view.columnWidth(nColumns - 1) +
+						   freeSpace -
+						   2); /* Just a little bit less space.
+							* This will allow the scroll bar
+							* to disappear when the widget
+							* is extended to maximum. */
+	}
+}
+
+/**
+ * Reimplemented event handler used to move the active marker.
+ */
+void KsTraceViewer::keyReleaseEvent(QKeyEvent *event)
+{
+	if (event->key() =3D=3D Qt::Key_Up || event->key() =3D=3D Qt::Key_Down) {
+		QItemSelectionModel *sm =3D _view.selectionModel();
+		if (sm->hasSelection()) {
+			/* Only one row at the time can be selected. */
+			int row =3D sm->selectedRows()[0].row();
+			emit select(row); // Send a signal to the Graph widget.
+		}
+
+		return;
+	}
+
+	QWidget::keyReleaseEvent(event);
+}
+
+void KsTraceViewer::_resizeToContents()
+{
+	int rows, columnSize;
+
+	_view.setVisible(false);
+	_view.resizeColumnsToContents();
+	_view.setVisible(true);
+
+	/*
+	 * Because of some unknown reason the first column doesn't get
+	 * resized properly by the code above. We will resize this
+	 * column by hand.
+	 */
+	rows =3D _model.rowCount({});
+	columnSize =3D STRING_WIDTH(QString("%1").arg(rows)) + FONT_WIDTH;
+	_view.setColumnWidth(0, columnSize);
+}
+
+size_t KsTraceViewer::_searchItems(int column,
+				   const QString &searchText,
+				   condition_func cond)
+{
+	int count;
+
+	_searchProgBar.show();
+	_pbAction->setVisible(true);
+
+	if (column =3D=3D KsViewModel::TRACE_VIEW_COL_INFO ||
+	    column =3D=3D KsViewModel::TRACE_VIEW_COL_LAT) {
+		_searchStopAction->setVisible(true);
+		_proxyModel.search(column, searchText, cond, &_matchList,
+				   &_searchProgBar, &_searchCountLabel);
+
+		_searchStopAction->setVisible(false);
+	} else {
+		_searchItemsMapReduce(column, searchText, cond);
+	}
+
+	count =3D _matchList.count();
+
+	_pbAction->setVisible(false);
+	_searchCountLabel.setText(QString(" %1").arg(count));
+	_searchDone =3D true;
+
+	if (count =3D=3D 0) // No items have been found. Do nothing.
+		return 0;
+
+	QItemSelectionModel *sm =3D _view.selectionModel();
+	if (sm->hasSelection()) {
+		/* Only one row at the time can be selected. */
+		int row =3D sm->selectedRows()[0].row();
+
+		_view.clearSelection();
+		_it =3D _matchList.begin();
+		/*
+		 * Move the iterator to the first element of the match list
+		 * after the selected one.
+		 */
+		while (*_it <=3D row) {
+			++_it;  // Move the iterator.
+			if (_it =3D=3D _matchList.end()) {
+				/*
+				 * This is the last item of the list. Go back
+				 * to the beginning.
+				 */
+				_it =3D _matchList.begin();
+				break;
+			}
+		}
+	} else {
+		/* Move the iterator to the beginning of the match list. */
+		_view.clearSelection();
+		_it =3D _matchList.begin();
+	}
+
+	return count;
+}
+
+void KsTraceViewer::_searchItemsMapReduce(int column,
+					  const QString &searchText,
+					  condition_func cond)
+{
+	int nThreads =3D std::thread::hardware_concurrency();
+	std::vector<QPair<int, int>> ranges(nThreads);
+	std::vector<std::future<QList<int>>> maps;
+	int i(0), nRows(_proxyModel.rowCount({}));
+	int delta(nRows / nThreads);
+
+	auto lamSearchMap =3D [&] (const QPair<int, int> &range,
+				 bool notify) {
+		return _proxyModel.searchMap(column, searchText, cond,
+					     range.first, range.second,
+					     notify);
+	};
+
+	auto lamSearchReduce =3D [&] (QList<int> &resultList,
+				  const QList<int> &mapList) {
+		resultList << mapList;
+		_searchProgBar.setValue(_searchProgBar.value() + 1);
+	};
+
+	for (auto &r: ranges) {
+		r.first =3D (i++) * delta;
+		r.second =3D r.first + delta - 1;
+	}
+
+	/*
+	 * If the range is not multiple of the number of threads, adjust
+	 * the last range interval.
+	 */
+	ranges.back().second =3D nRows - 1;
+	maps.push_back(std::async(lamSearchMap, ranges[0], true));
+	for (int r =3D 1; r < nThreads; ++r)
+		maps.push_back(std::async(lamSearchMap, ranges[r], false));
+
+	while (_proxyModel.searchProgress() < KS_PROGRESS_BAR_MAX- nThreads) {
+		std::unique_lock<std::mutex> lk(_proxyModel._mutex);
+		_proxyModel._pbCond.wait(lk);
+		_searchProgBar.setValue(_proxyModel.searchProgress());
+		QApplication::processEvents();
+	}
+
+	for (auto &m: maps)
+		lamSearchReduce(_matchList, m.get());
+}
diff --git a/kernel-shark-qt/src/KsTraceViewer.hpp b/kernel-shark-qt/src/Ks=
TraceViewer.hpp
new file mode 100644
index 0000000..2a85e4f
--- /dev/null
+++ b/kernel-shark-qt/src/KsTraceViewer.hpp
@@ -0,0 +1,149 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+
+/*
+ * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
+ */
+
+/**
+ *  @file    KsTraceViewer.hpp
+ *  @brief   KernelShark Trace Viewer widget.
+ */
+
+#ifndef _KS_TRACEVIEW_H
+#define _KS_TRACEVIEW_H
+
+// Qt
+#include <QTableView>
+
+// KernelShark
+#include "KsUtils.hpp"
+#include "KsModels.hpp"
+#include "KsDualMarker.hpp"
+
+/** Matching condition function type. To be user for searchong. */
+typedef bool (*condition_func)(QString, QString);
+
+/**
+ * The KsTraceViewer class provides a widget for browsing in the trace dat=
a
+ * shown in a text form.
+ */
+class KsTraceViewer : public QWidget
+{
+	Q_OBJECT
+public:
+	explicit KsTraceViewer(QWidget *parent =3D nullptr);
+
+	void loadData(KsDataStore *data);
+
+	void setMarkerSM(KsDualMarkerSM *m);
+
+	void reset();
+
+	size_t getTopRow() const;
+
+	void setTopRow(size_t r);
+
+	void resizeEvent(QResizeEvent* event) override;
+
+	void keyReleaseEvent(QKeyEvent *event);
+
+	void markSwitch();
+
+	void showRow(size_t r, bool mark);
+
+	void deselect();
+
+	void update(KsDataStore *data);
+
+signals:
+	/** Signal emitted when new row is selected. */
+	void select(size_t);
+
+	/**
+	 * This signal is used to re-emitted the plotTask signal of the
+	 * KsQuickEntryMenu.
+	 */
+	void plotTask(int pid);
+
+private:
+	QVBoxLayout	_layout;
+
+	QTableView	_view;
+
+	KsViewModel		_model;
+
+	KsFilterProxyModel	_proxyModel;
+
+	QStringList	_tableHeader;
+
+	QToolBar	_toolbar;
+
+	QLabel		_labelSearch, _labelGrFollows;
+
+	QComboBox	_columnComboBox;
+
+	QComboBox	_selectComboBox;
+
+	QLineEdit	_searchLineEdit;
+
+	QPushButton	_prevButton, _nextButton, _searchStopButton;
+
+	QAction		*_pbAction, *_searchStopAction;
+
+	QCheckBox	_graphFollowsCheckBox;
+
+	QProgressBar	_searchProgBar;
+
+	QLabel		_searchCountLabel;
+
+	bool		_searchDone;
+
+	bool		_graphFollows;
+
+	QList<int>		_matchList;
+
+	QList<int>::iterator	_it;
+
+	KsDualMarkerSM		*_mState;
+
+	KsDataStore		*_data;
+
+	enum Condition
+	{
+		Containes =3D 0,
+		Match =3D 1,
+		NotHave =3D 2
+	};
+
+	void _searchReset();
+
+	void _resizeToContents();
+
+	size_t _searchItems(int column, const QString &searchText,
+			    condition_func cond);
+
+	void _searchItemsMapReduce(int column, const QString &searchText,
+				   condition_func cond);
+
+	void _searchEditText(const QString &);
+
+	void _graphFollowsChanged(int);
+
+	void _search();
+
+	void _next();
+
+	void _prev();
+
+	void _searchStop();
+
+	void _clicked(const QModelIndex& i);
+
+	void _onCustomContextMenu(const QPoint &);
+
+private slots:
+
+	void _searchEdit(int);
+};
+
+#endif // _KS_TRACEVIEW_H
--=20
2.17.1

Return-Path: <linux-trace-devel-owner@vger.kernel.org>
Received: from mail-eopbgr820051.outbound.protection.outlook.com ([40.107.82.51]:56939
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725986AbfADUHK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Jan 2019 15:07:10 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 2/2] kernel-shark-qt: Implement State machine for searching in
 the data
Date: Fri, 4 Jan 2019 20:06:21 +0000
Message-ID: <20190104200559.24471-3-ykaradzhov@vmware.com>
References: <20190104200559.24471-1-ykaradzhov@vmware.com>
In-Reply-To: <20190104200559.24471-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch was originally motivated by the request to make it
possible to continue searching from the place when the search
has been stopped by the user. However because the implementation
of this feature made the original code quite messy (ugly), I
decided to reorganize the way the searching is controlled and
add a KsSearchFSM class that implements a Finite-State Machine
by following the "State" design pattern. KsSearchFSM class now
encapsulates the searching logic.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/CMakeLists.txt    |   2 +
 kernel-shark-qt/src/KsModels.cpp      |  70 +++++---
 kernel-shark-qt/src/KsModels.hpp      |  39 +++--
 kernel-shark-qt/src/KsSearchFSM.cpp   | 232 +++++++++++++++++++++++++
 kernel-shark-qt/src/KsSearchFSM.hpp   | 209 ++++++++++++++++++++++
 kernel-shark-qt/src/KsTraceViewer.cpp | 241 +++++++++-----------------
 kernel-shark-qt/src/KsTraceViewer.hpp |  32 ++--
 7 files changed, 603 insertions(+), 222 deletions(-)
 create mode 100644 kernel-shark-qt/src/KsSearchFSM.cpp
 create mode 100644 kernel-shark-qt/src/KsSearchFSM.hpp

diff --git a/kernel-shark-qt/src/CMakeLists.txt b/kernel-shark-qt/src/CMake=
Lists.txt
index 3eddaed..1e0a794 100644
--- a/kernel-shark-qt/src/CMakeLists.txt
+++ b/kernel-shark-qt/src/CMakeLists.txt
@@ -34,6 +34,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
     set (ks-guiLib_hdr  KsUtils.hpp
                         KsModels.hpp
                         KsGLWidget.hpp
+                        KsSearchFSM.hpp
                         KsDualMarker.hpp
                         KsWidgetsLib.hpp
                         KsTraceGraph.hpp
@@ -49,6 +50,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
                                                             KsModels.cpp
                                                             KsSession.cpp
                                                             KsGLWidget.cpp
+                                                            KsSearchFSM.cp=
p
                                                             KsDualMarker.c=
pp
                                                             KsWidgetsLib.c=
pp
                                                             KsTraceGraph.c=
pp
diff --git a/kernel-shark-qt/src/KsModels.cpp b/kernel-shark-qt/src/KsModel=
s.cpp
index c8cc410..1b68143 100644
--- a/kernel-shark-qt/src/KsModels.cpp
+++ b/kernel-shark-qt/src/KsModels.cpp
@@ -48,33 +48,31 @@ void KsFilterProxyModel::setSource(KsViewModel *s)
 	_source =3D s;
 }
=20
-void KsFilterProxyModel::_search(int column,
-				 const QString &searchText,
-				 condition_func cond,
-				 QList<int> *matchList,
-				 int first, int last,
-				 QProgressBar *pb,
-				 QLabel *l,
-				 bool notify)
+size_t KsFilterProxyModel::_search(int column,
+				   const QString &searchText,
+				   search_condition_func cond,
+				   QList<int> *matchList,
+				   int first, int last,
+				   QProgressBar *pb,
+				   QLabel *l,
+				   bool notify)
 {
-	int row, nRows(last - first + 1);
+	int index, row, nRows(last - first + 1);
 	int pbCount(1);
 	QString item;
=20
-	_searchProgress =3D 0;
-
 	if (nRows > KS_PROGRESS_BAR_MAX)
-		pbCount =3D nRows / KS_PROGRESS_BAR_MAX;
+		pbCount =3D nRows / (KS_PROGRESS_BAR_MAX - _searchProgress);
 	else
 		_searchProgress =3D KS_PROGRESS_BAR_MAX - nRows;
=20
 	/* Loop over the items of the proxy model. */
-	for (int r =3D first; r <=3D last; ++r) {
+	for (index =3D first; index <=3D last; ++index) {
 		/*
 		 * Use the index of the proxy model to retrieve the value
 		 * of the row number in the base model.
 		 */
-		row =3D mapRowFromSource(r);
+		row =3D mapRowFromSource(index);
 		item =3D _source->getValueStr(column, row);
 		if (cond(searchText, item))
 			matchList->append(row);
@@ -89,20 +87,25 @@ void KsFilterProxyModel::_search(int column,
 		}
=20
 		/* Deal with the Progress bar of the seatch. */
-		if ((r - first) % pbCount =3D=3D 0) {
+		if ((index - first) % pbCount =3D=3D 0) {
 			if (notify) {
 				std::lock_guard<std::mutex> lk(_mutex);
 				++_searchProgress;
 				_pbCond.notify_one();
 			} else {
-				if (pb)
+				if (pb) {
 					pb->setValue(pb->value() + 1);
+					++_searchProgress;
+				}
+
 				if (l)
 					l->setText(QString(" %1").arg(matchList->count()));
 				QApplication::processEvents();
 			}
 		}
 	}
+
+	return index;
 }
=20
 /** @brief Search the content of the table for a data satisfying an abstra=
ct
@@ -121,15 +124,40 @@ void KsFilterProxyModel::_search(int column,
  */
 size_t KsFilterProxyModel::search(int column,
 				  const QString &searchText,
-				  condition_func cond,
+				  search_condition_func cond,
 				  QList<int> *matchList,
 				  QProgressBar *pb,
 				  QLabel *l)
+{
+	int nRows =3D rowCount({});
+	_search(column, searchText, cond, matchList,
+		0, nRows - 1, pb, l, false);
+
+	return matchList->count();
+}
+
+/** @brief Search the content of the table for a data satisfying an abstra=
ct
+ *	   condition.
+ *
+ * @param sm: Input location for the Search State machine object.
+ * @param matchList: Output location for a list containing the row indexes=
 of
+ *
+ * @returns The number of cells satisfying the matching condition.
+ */
+size_t KsFilterProxyModel::search(KsSearchFSM *sm, QList<int> *matchList)
 {
 	int nRows =3D rowCount({});
=20
-	_search(column, searchText, cond, matchList, 0, nRows - 1,
-		pb, l, false);
+	sm->_lastRowSearched =3D
+		_search(sm->column(),
+			sm->searchText(),
+			sm->condition(),
+			matchList,
+			sm->_lastRowSearched + 1,
+			nRows - 1,
+			&sm->_searchProgBar,
+			&sm->_searchCountLabel,
+			false);
=20
 	return matchList->count();
 }
@@ -152,7 +180,7 @@ size_t KsFilterProxyModel::search(int column,
  */
 QList<int> KsFilterProxyModel::searchMap(int column,
 					 const QString &searchText,
-					 condition_func cond,
+					 search_condition_func cond,
 					 int first,
 					 int last,
 					 bool notify)
@@ -325,7 +353,7 @@ void KsViewModel::update(KsDataStore *data)
  */
 size_t KsViewModel::search(int column,
 			   const QString &searchText,
-			   condition_func cond,
+			   search_condition_func cond,
 			   QList<size_t> *matchList)
 {
 	int nRows =3D rowCount({});
diff --git a/kernel-shark-qt/src/KsModels.hpp b/kernel-shark-qt/src/KsModel=
s.hpp
index 08019e7..808c574 100644
--- a/kernel-shark-qt/src/KsModels.hpp
+++ b/kernel-shark-qt/src/KsModels.hpp
@@ -26,9 +26,7 @@
 // KernelShark
 #include "libkshark.h"
 #include "libkshark-model.h"
-
-/** Matching condition function type. To be user for searching. */
-typedef bool (*condition_func)(const QString &, const QString &);
+#include "KsSearchFSM.hpp"
=20
 enum class DualMarkerState;
=20
@@ -87,7 +85,7 @@ public:
=20
 	size_t search(int column,
 		      const QString &searchText,
-		      condition_func cond,
+		      search_condition_func cond,
 		      QList<size_t> *matchList);
=20
 	/** Table columns Identifiers. */
@@ -162,14 +160,16 @@ public:
=20
 	size_t search(int column,
 		      const QString &searchText,
-		      condition_func cond,
+		      search_condition_func cond,
 		      QList<int> *matchList,
 		      QProgressBar *pb =3D nullptr,
 		      QLabel *l =3D nullptr);
=20
+	size_t search(KsSearchFSM *sm, QList<int> *matchList);
+
 	QList<int> searchMap(int column,
 			     const QString  &searchText,
-			     condition_func  cond,
+			     search_condition_func  cond,
 			     int first,
 			     int last,
 			     bool notify);
@@ -183,9 +183,6 @@ public:
 		_searchStop =3D false;
 	}
=20
-	/** Stop the serch for all threads. */
-	void searchStop() {_searchStop =3D true;}
-
 	/**
 	 * Use the "row" index in the Proxy model to retrieve the "row" index
 	 * in the source model.
@@ -196,6 +193,9 @@ public:
 		return this->data(this->index(r, 0)).toInt();
 	}
=20
+	/** Get the source model. */
+	KsViewModel *source() {return _source;}
+
 	/**
 	 * A condition variable used to notify the main thread to update the
 	 * search progressbar.
@@ -205,24 +205,25 @@ public:
 	/** A mutex used by the condition variable. */
 	std::mutex		_mutex;
=20
+	/** A flag used to stop the serch for all threads. */
+	bool			_searchStop;
+
 private:
 	int			_searchProgress;
=20
-	bool			_searchStop;
-
 	/** Trace data array. */
 	kshark_entry		**_data;
=20
 	KsViewModel	 	*_source;
=20
-	void _search(int column,
-		     const QString &searchText,
-		     condition_func cond,
-		     QList<int> *matchList,
-		     int first, int last,
-		     QProgressBar *pb,
-		     QLabel *l,
-		     bool notify);
+	size_t _search(int column,
+		       const QString &searchText,
+		       search_condition_func cond,
+		       QList<int> *matchList,
+		       int first, int last,
+		       QProgressBar *pb,
+		       QLabel *l,
+		       bool notify);
 };
=20
 /**
diff --git a/kernel-shark-qt/src/KsSearchFSM.cpp b/kernel-shark-qt/src/KsSe=
archFSM.cpp
new file mode 100644
index 0000000..4f01cc8
--- /dev/null
+++ b/kernel-shark-qt/src/KsSearchFSM.cpp
@@ -0,0 +1,232 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2018 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
+ */
+
+/**
+ *  @file    KsSearchFSM.cpp
+ *  @brief   Finite-state machine for searching in trace data.
+ */
+
+// KernelShark
+#include "KsSearchFSM.hpp"
+#include "KsUtils.hpp"
+#include "KsTraceViewer.hpp"
+#include "KsWidgetsLib.hpp"
+
+static bool notHaveCond(const QString &searchText, const QString &itemText=
)
+{
+	return !itemText.contains(searchText, Qt::CaseInsensitive);
+}
+
+static bool containsCond(const QString &searchText, const QString &itemTex=
t)
+{
+	return itemText.contains(searchText, Qt::CaseInsensitive);
+}
+
+static bool matchCond(const QString &searchText, const QString &itemText)
+{
+	return (itemText.compare(searchText, Qt::CaseInsensitive) =3D=3D 0);
+}
+
+static bool noCond(const QString &searchText, const QString &itemText)
+{
+	return false;
+}
+
+/** Create a Finite-state machine for searching. */
+KsSearchFSM::KsSearchFSM(QWidget *parent)
+: _currentState(new NotDone),
+  _lastRowSearched(0),
+  _searchProgBar(parent),
+  _searchCountLabel("", parent),
+  _columnComboBox(parent),
+  _selectComboBox(parent),
+  _searchLineEdit(parent),
+  _prevButton("Prev", parent),
+  _nextButton("Next", parent),
+  _searchRestartButton(QIcon::fromTheme("media-playback-start"), "", paren=
t),
+//   _searchStopButton(QIcon::fromTheme("media-playback-pause"), "", paren=
t),
+  _searchStopButton(QIcon::fromTheme("process-stop"), "", parent),
+  _cond(nullptr),
+  _pbAction(nullptr),
+  _searchStopAction(nullptr),
+  _searchRestartAction(nullptr)
+{
+	int bWidth =3D FONT_WIDTH * 6;
+
+	_nextButton.setFixedWidth(bWidth);
+	_prevButton.setFixedWidth(bWidth);
+
+	_searchProgBar.setMaximumWidth(FONT_WIDTH * 10);
+	_searchProgBar.setRange(0, KS_PROGRESS_BAR_MAX);
+
+	_selectComboBox.addItem("contains");
+	_selectComboBox.addItem("full match");
+	_selectComboBox.addItem("does not have");
+	updateCondition();
+}
+
+/**
+ * Position all buttons and labels of the Finite-state machine for searchi=
ng
+ * in a toolbar.
+ */
+void KsSearchFSM::placeInToolBar(QToolBar *tb)
+{
+	tb->addWidget(&_columnComboBox);
+	tb->addWidget(&_selectComboBox);
+	tb->addWidget(&_searchLineEdit);
+	tb->addSeparator();
+
+	tb->addWidget(&_nextButton);
+	tb->addWidget(&_prevButton);
+	tb->addSeparator();
+
+	_pbAction =3D tb->addWidget(&_searchProgBar);
+	_pbAction->setVisible(false);
+
+	tb->addWidget(&_searchCountLabel);
+
+	_searchStopAction =3D tb->addWidget(&_searchStopButton);
+	_searchStopAction->setVisible(false);
+
+	_searchRestartAction =3D tb->addWidget(&_searchRestartButton);
+	_searchRestartAction->setVisible(false);
+	tb->addSeparator();
+}
+
+/**
+ * Update the Matching condition function of the search according to the u=
ser
+ * input.
+ */
+void KsSearchFSM::updateCondition()
+{
+	int xSelect =3D _selectComboBox.currentIndex();
+
+	switch (xSelect) {
+	case Condition::Containes:
+		_cond =3D containsCond;
+		return;
+
+	case Condition::Match:
+		_cond =3D matchCond;
+		return;
+
+	case Condition::NotHave:
+		_cond =3D notHaveCond;
+		return;
+
+	default:
+		_cond =3D noCond;
+		return;
+	}
+}
+
+void KsSearchFSM ::_lockSearchPanel(bool lock)
+{
+	_columnComboBox.setEnabled(!lock);
+	_selectComboBox.setEnabled(!lock);
+	_searchLineEdit.setReadOnly(lock);
+	_prevButton.setEnabled(!lock);
+	_nextButton.setEnabled(!lock);
+// 	_graphFollowsCheckBox.setEnabled(!lock);
+}
+
+/** Act according to the provided input. */
+void NotDone::handleInput(KsSearchFSM* sm, sm_input_t input)
+{
+	switch(input) {
+	case sm_input_t::Start:
+		sm->_lastRowSearched =3D -1;
+		sm->lockSearchPanel();
+		sm->updateCondition();
+		sm->progressBarVisible(true);
+
+		if (sm->column() =3D=3D KsViewModel::TRACE_VIEW_COL_INFO ||
+		    sm->column() =3D=3D KsViewModel::TRACE_VIEW_COL_LAT)
+			sm->searchStopVisible(true);
+
+		sm->changeState(std::shared_ptr<InProgress>(new InProgress));
+		break;
+
+	case sm_input_t::Finish:
+		sm->changeState(std::shared_ptr<Done>(new Done));
+		break;
+
+	default:
+		/* Ignore the input. */
+		break;
+	}
+}
+
+/** Act according to the provided input. */
+void Paused::handleInput(KsSearchFSM* sm, sm_input_t input)
+{
+	switch(input) {
+	case sm_input_t::Start:
+		sm->lockSearchPanel();
+		sm->searchStopVisible(true);
+		sm->searchRestartVisible(false);
+		sm->changeState(std::shared_ptr<InProgress>(new InProgress));
+		break;
+
+	case sm_input_t::Change:
+		sm->_searchProgBar.setValue(0);
+		sm->_searchCountLabel.setText("");
+		sm->progressBarVisible(false);
+		sm->searchRestartVisible(false);
+		sm->changeState(std::shared_ptr<NotDone>(new NotDone));
+		break;
+
+	default:
+		/* Ignore the input. */
+		break;
+	}
+}
+
+/** Act according to the provided input. */
+void InProgress::handleInput(KsSearchFSM* sm, sm_input_t input)
+{
+	auto lamUnlock =3D [&sm] () {
+		sm->searchStopVisible(false);
+		sm->unlockSearchPanel();
+	};
+
+	switch(input) {
+	case sm_input_t::Stop:
+		lamUnlock();
+		sm->searchRestartVisible(true);
+		sm->changeState(std::shared_ptr<Paused>(new Paused));
+		break;
+
+	case sm_input_t::Finish:
+		lamUnlock();
+		sm->progressBarVisible(false);
+		sm->changeState(std::shared_ptr<Done>(new Done));
+		break;
+
+	default:
+		/* Ignore the input. */
+		break;
+	}
+}
+
+/** Act according to the provided input. */
+void Done::handleInput(KsSearchFSM* sm, sm_input_t i)
+{
+	switch(i) {
+	case sm_input_t::Change:
+		sm->_searchProgBar.setValue(0);
+		sm->progressBarVisible(false);
+		sm->_searchCountLabel.setText("");
+		sm->searchStopVisible(false);
+		sm->searchRestartVisible(false);
+		sm->changeState(std::shared_ptr<NotDone>(new NotDone));
+		break;
+
+	default:
+		/* Ignore the input. */
+		break;
+	}
+}
diff --git a/kernel-shark-qt/src/KsSearchFSM.hpp b/kernel-shark-qt/src/KsSe=
archFSM.hpp
new file mode 100644
index 0000000..2089912
--- /dev/null
+++ b/kernel-shark-qt/src/KsSearchFSM.hpp
@@ -0,0 +1,209 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+
+/*
+ * Copyright (C) 2018 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
+ */
+
+/**
+ *  @file    KsSearchFSM.hpp
+ *  @brief   Finite-state machine for searching in trace data.
+ */
+
+#ifndef _KS_SEARCH_FSM_H
+#define _KS_SEARCH_FSM_H
+
+// C++11
+#include <memory>
+
+// Qt
+#include <QtWidgets>
+
+/** Matching condition function type. To be user for searching. */
+typedef bool (*search_condition_func)(const QString &, const QString &);
+
+/** State Identifiers of the Finite-state machine for searching. */
+enum class search_state_t
+{
+	/** Identifier of the "NotDone" state. */
+	NotDone_s =3D 0,
+
+	/** Identifier of the "InProgress" state. */
+	InProgress_s =3D 1,
+
+	/** Identifier of the "Paused" state. */
+	Paused_s =3D 2,
+
+	/** Identifier of the "Done" state. */
+	Done_s =3D 3
+};
+
+/** Inputs of the Finite-state machine for searching. */
+enum class sm_input_t
+{
+	Start =3D 0,
+	Stop =3D 1,
+	Finish =3D 2,
+	Change =3D 3
+};
+
+class KsSearchFSM;
+
+/**
+ * State provides a base class for the states of the Finite-state machine =
for
+ * searching.
+ */
+struct State
+{
+	/** Virtual destructor. */
+	virtual ~State() {}
+
+	/**
+	 * Act according to the provided input. This is a pure virtual
+	 * function.
+	 */
+	virtual void handleInput(KsSearchFSM* sm, sm_input_t i) =3D 0;
+
+	/**
+	 * Get the identifier of this state. This is a pure virtual function.
+	 */
+	virtual search_state_t id() =3D 0;
+};
+
+/** "NotDone" state. */
+struct NotDone : public State
+{
+	void handleInput(KsSearchFSM* sm, sm_input_t i) override;
+
+	search_state_t id() override {return search_state_t::NotDone_s;}
+};
+
+/** "InProgress" state. */
+struct InProgress : public State
+{
+	void handleInput(KsSearchFSM* sm, sm_input_t i) override;
+
+	/** Get the identifier of this state. */
+	search_state_t id() override {return search_state_t::InProgress_s;}
+};
+
+/** "Paused" state. */
+struct Paused : public State
+{
+	void handleInput(KsSearchFSM* sm, sm_input_t i) override;
+
+	/** Get the identifier of this state. */
+	search_state_t id() override {return search_state_t::Paused_s;}
+};
+
+/** "Done" state. */
+struct Done : public State
+{
+	void handleInput(KsSearchFSM* sm, sm_input_t i) override;
+
+	/** Get the identifier of this state. */
+	search_state_t id() override {return search_state_t::Done_s;}
+};
+
+/** Finite-state machine for searching. */
+class KsSearchFSM : public QWidget
+{
+	Q_OBJECT
+public:
+	explicit KsSearchFSM(QWidget *parent =3D nullptr);
+
+	void placeInToolBar(QToolBar *tb);
+
+	/** Act according to the provided input. */
+	void handleInput(sm_input_t input)
+	{
+		_currentState->handleInput(this, input);
+	}
+
+	/** Switch the state. */
+	void changeState(std::shared_ptr<State> newState)
+	{
+		_currentState =3D newState;
+	}
+
+	/** Get the identifier of the Current state. */
+	search_state_t getState() const {return _currentState->id();}
+
+	/** Get the data column to search in. */
+	int column() const {return _columnComboBox.currentIndex();}
+
+	/** Get the Matching condition function. */
+	search_condition_func condition() const {return _cond;}
+
+	/** Get the text to search for. */
+	QString searchText() const {return _searchLineEdit.text();}
+
+	/** Set the value of the Search Progress Bar. */
+	void setProgress(int v) {_searchProgBar.setValue(v);}
+
+	/** Increment the value of the Search Progress Bar. */
+	void incrementProgress()
+	{
+		_searchProgBar.setValue(_searchProgBar.value() + 1);
+	}
+
+	void updateCondition();
+
+	/** Disable the user searching input (lock the panel). */
+	void lockSearchPanel() {_lockSearchPanel(true);}
+
+	/** Enable the user searching input (unlock the panel). */
+	void unlockSearchPanel() {_lockSearchPanel(false);}
+
+	/** Set the visibility of the Search Progress Bar. */
+	void progressBarVisible(bool v) {_pbAction->setVisible(v);}
+
+	/** Set the visibility of the Search Stop button. */
+	void searchStopVisible(bool v) {_searchStopAction->setVisible(v);}
+
+	/** Set the visibility of the Search Restart button. */
+	void searchRestartVisible(bool v) {_searchRestartAction->setVisible(v);}
+
+	/** Current State of the Finite-state machine for searching. */
+	std::shared_ptr<State>	_currentState;
+
+	/**
+	 * Last row, tested for matching. To be used when restarting the
+	 * search.
+	 */
+	ssize_t		_lastRowSearched;
+
+//! @cond Doxygen_Suppress
+
+	QProgressBar	_searchProgBar;
+
+	QLabel		_searchCountLabel;
+
+	QComboBox	_columnComboBox;
+
+	QComboBox	_selectComboBox;
+
+	QLineEdit	_searchLineEdit;
+
+	QPushButton	_prevButton, _nextButton;
+
+	QPushButton	_searchRestartButton, _searchStopButton;
+
+//! @endcond
+
+private:
+
+	search_condition_func	_cond;
+
+	QAction		*_pbAction, *_searchStopAction, *_searchRestartAction;
+
+	void _lockSearchPanel(bool lock);
+
+	enum Condition
+	{
+		Containes =3D 0,
+		Match =3D 1,
+		NotHave =3D 2
+	};
+};
+
+#endif
diff --git a/kernel-shark-qt/src/KsTraceViewer.cpp b/kernel-shark-qt/src/Ks=
TraceViewer.cpp
index f02fbbb..369c78e 100644
--- a/kernel-shark-qt/src/KsTraceViewer.cpp
+++ b/kernel-shark-qt/src/KsTraceViewer.cpp
@@ -46,7 +46,6 @@ void KsTableView::scrollTo(const QModelIndex &index, Scro=
llHint hint)
 	QTableView::scrollTo(index, hint);
 }
=20
-
 /** Create a default (empty) Trace viewer widget. */
 KsTraceViewer::KsTraceViewer(QWidget *parent)
 : QWidget(parent),
@@ -57,23 +56,12 @@ KsTraceViewer::KsTraceViewer(QWidget *parent)
   _toolbar(this),
   _labelSearch("Search: Column", this),
   _labelGrFollows("Graph follows  ", this),
-  _columnComboBox(this),
-  _selectComboBox(this),
-  _searchLineEdit(this),
-  _prevButton("Prev", this),
-  _nextButton("Next", this),
-  _searchStopButton(QIcon::fromTheme("process-stop"), "", this),
-  _pbAction(nullptr),
+  _searchFSM(this),
   _graphFollowsCheckBox(this),
-  _searchProgBar(this),
-  _searchCountLabel("", this),
-  _searchDone(false),
   _graphFollows(true),
   _mState(nullptr),
   _data(nullptr)
 {
-	int bWidth;
-
 	this->setSizePolicy(QSizePolicy::Preferred, QSizePolicy::Maximum);
=20
 	/* Make a search toolbar. */
@@ -82,71 +70,51 @@ KsTraceViewer::KsTraceViewer(QWidget *parent)
=20
 	/* On the toolbar make two Combo boxes for the search settings. */
 	_toolbar.addWidget(&_labelSearch);
-	_columnComboBox.addItems(_tableHeader);
+	_searchFSM._columnComboBox.addItems(_tableHeader);
=20
 	/*
 	 * Using the old Signal-Slot syntax because
 	 * QComboBox::currentIndexChanged has overloads.
 	 */
-	connect(&_columnComboBox,	SIGNAL(currentIndexChanged(int)),
-		this,			SLOT(_searchEdit(int)));
-
-	_toolbar.addWidget(&_columnComboBox);
-
-	_selectComboBox.addItem("contains");
-	_selectComboBox.addItem("full match");
-	_selectComboBox.addItem("does not have");
+	connect(&_searchFSM._columnComboBox,	SIGNAL(currentIndexChanged(int)),
+		this,				SLOT(_searchEdit(int)));
=20
 	/*
 	 * Using the old Signal-Slot syntax because
 	 * QComboBox::currentIndexChanged has overloads.
 	 */
-	connect(&_selectComboBox,	SIGNAL(currentIndexChanged(int)),
-		this,			SLOT(_searchEdit(int)));
-
-	_toolbar.addWidget(&_selectComboBox);
+	connect(&_searchFSM._selectComboBox,	SIGNAL(currentIndexChanged(int)),
+		this,				SLOT(_searchEdit(int)));
=20
 	/* On the toolbar, make a Line edit field for search. */
-	_searchLineEdit.setMaximumWidth(FONT_WIDTH * 20);
-
-	connect(&_searchLineEdit,	&QLineEdit::returnPressed,
-		this,			&KsTraceViewer::_search);
+	_searchFSM._searchLineEdit.setMaximumWidth(FONT_WIDTH * 20);
=20
-	connect(&_searchLineEdit,	&QLineEdit::textEdited,
-		this,			&KsTraceViewer::_searchEditText);
+	connect(&_searchFSM._searchLineEdit,	&QLineEdit::returnPressed,
+		this,				&KsTraceViewer::_search);
=20
-	_toolbar.addWidget(&_searchLineEdit);
-	_toolbar.addSeparator();
+	connect(&_searchFSM._searchLineEdit,	&QLineEdit::textEdited,
+		this,				&KsTraceViewer::_searchEditText);
=20
 	/* On the toolbar, add Prev & Next buttons. */
-	bWidth =3D FONT_WIDTH * 6;
-
-	_nextButton.setFixedWidth(bWidth);
-	_toolbar.addWidget(&_nextButton);
-	connect(&_nextButton,	&QPushButton::pressed,
-		this,		&KsTraceViewer::_next);
-
-	_prevButton.setFixedWidth(bWidth);
-	_toolbar.addWidget(&_prevButton);
-	connect(&_prevButton,	&QPushButton::pressed,
-		this,		&KsTraceViewer::_prev);
-
-	_toolbar.addSeparator();
-	_searchProgBar.setMaximumWidth(FONT_WIDTH * 10);
-	_searchProgBar.setRange(0, 200);
-	_pbAction =3D _toolbar.addWidget(&_searchProgBar);
-	_pbAction->setVisible(false);
-	_toolbar.addWidget(&_searchCountLabel);
-	_searchStopAction =3D _toolbar.addWidget(&_searchStopButton);
-	_searchStopAction->setVisible(false);
-	connect(&_searchStopButton,	&QPushButton::pressed,
-		this,			&KsTraceViewer::_searchStop);
+	connect(&_searchFSM._nextButton,	&QPushButton::pressed,
+		this,				&KsTraceViewer::_next);
+
+	connect(&_searchFSM._prevButton,	&QPushButton::pressed,
+		this,				&KsTraceViewer::_prev);
+
+
+	connect(&_searchFSM._searchStopButton,	&QPushButton::pressed,
+		this,				&KsTraceViewer::_searchStop);
+
+	connect(&_searchFSM._searchRestartButton,	&QPushButton::pressed,
+		this,				&KsTraceViewer::_searchContinue);
+
+	_searchFSM.placeInToolBar(&_toolbar);
=20
 	/*
 	 * On the toolbar, make a Check box for connecting the search pannel
 	 * to the Graph widget.
 	 */
-	_toolbar.addSeparator();
 	_toolbar.addWidget(&_graphFollowsCheckBox);
 	_toolbar.addWidget(&_labelGrFollows);
 	_graphFollowsCheckBox.setCheckState(Qt::Checked);
@@ -238,10 +206,8 @@ void KsTraceViewer::reset()
=20
 void KsTraceViewer::_searchReset()
 {
-	_searchProgBar.setValue(0);
-	_searchCountLabel.setText("");
+	_searchFSM.handleInput(sm_input_t::Change);
 	_proxyModel.searchReset();
-	_searchDone =3D false;
 }
=20
 /** Get the index of the first (top) visible row. */
@@ -320,88 +286,26 @@ void KsTraceViewer::_graphFollowsChanged(int state)
 {
 	_graphFollows =3D (bool) state;
=20
-	if (_graphFollows && _searchDone)
+	if (_graphFollows && _searchDone())
 		emit select(*_it); // Send a signal to the Graph widget.
 }
=20
-static bool notHaveCond(const QString &searchText, const QString &itemText=
)
-{
-	return !itemText.contains(searchText, Qt::CaseInsensitive);
-}
-
-static bool containsCond(const QString &searchText, const QString &itemTex=
t)
-{
-	return itemText.contains(searchText, Qt::CaseInsensitive);
-}
-
-static bool matchCond(const QString &searchText, const QString &itemText)
-{
-	return (itemText.compare(searchText, Qt::CaseInsensitive) =3D=3D 0);
-}
-
-void KsTraceViewer::_lockSearchPanel(bool lock)
-{
-	_columnComboBox.setEnabled(!lock);
-	_selectComboBox.setEnabled(!lock);
-	_searchLineEdit.setReadOnly(lock);
-	_prevButton.setEnabled(!lock);
-	_nextButton.setEnabled(!lock);
-	_graphFollowsCheckBox.setEnabled(!lock);
-}
-
 void KsTraceViewer::_search()
 {
-	if (!_searchDone) {
+	if (!_searchDone()) {
 		/*
 		 * The search is not done. This means that the search settings
 		 * have been modified since the last time we searched.
 		 */
-		int xColumn, xSelect;
-		QString xText;
-
-		/* Disable the user input until the search is done. */
-		_lockSearchPanel(true);
-
 		_matchList.clear();
-		xText =3D _searchLineEdit.text();
-		if (xText.isEmpty()) {
-			/*
-			 * No text is provided by the user. Most probably this
-			 * is an accidental key press. Just reenable the input.
-			 */
-			_lockSearchPanel(false);
-			return;
-		}
-
-		xColumn =3D _columnComboBox.currentIndex();
-		xSelect =3D _selectComboBox.currentIndex();
-
-		switch (xSelect) {
-			case Condition::Containes:
-				_searchItems(xColumn, xText, &containsCond);
-				break;
-
-			case Condition::Match:
-				_searchItems(xColumn, xText, &matchCond);
-				break;
-
-			case Condition::NotHave:
-				_searchItems(xColumn, xText, &notHaveCond);
-				break;
-
-			default:
-				break;
-		}
+		_searchItems();
=20
 		if (!_matchList.empty()) {
-			this->showRow(*_it, true);
+			showRow(*_it, true);
=20
 			if (_graphFollows)
 				emit select(*_it); // Send a signal to the Graph widget.
 		}
-
-		/* Enable the user input. */
-		_lockSearchPanel(false);
 	} else {
 		/*
 		 * If the search is done, pressing "Enter" is equivalent
@@ -413,13 +317,13 @@ void KsTraceViewer::_search()
=20
 void KsTraceViewer::_next()
 {
-	if (!_searchDone) {
+	if (!_searchDone()) {
 		_search();
 		return;
 	}
=20
 	if (!_matchList.empty()) { // Items have been found.
-		int row =3D _getSelectedDataRow();
+		int row =3D selectedRow();
 		/*
 		 * The iterator can only be at the selected row or if the
 		 * selected row is not a match at the first matching row after
@@ -427,7 +331,7 @@ void KsTraceViewer::_next()
 		 */
 		if (*_it =3D=3D row) {
 			++_it; // Move the iterator.
-			if (_it =3D=3D _matchList.end() ) {
+			if (_it =3D=3D _matchList.end()) {
 				/*
 				 * This is the last item of the list.
 				 * Go back to the beginning.
@@ -448,7 +352,7 @@ void KsTraceViewer::_next()
=20
 void KsTraceViewer::_prev()
 {
-	if (!_searchDone) {
+	if (!_searchDone()) {
 		_search();
 		return;
 	}
@@ -474,6 +378,7 @@ void KsTraceViewer::_prev()
 void KsTraceViewer::_updateSearchCount()
 {
 	int index, total;
+	QString countText;
=20
 	if (_matchList.isEmpty())
 		return;
@@ -481,14 +386,20 @@ void KsTraceViewer::_updateSearchCount()
 	index =3D _it - _matchList.begin();
 	total =3D_matchList.count();
=20
-	_searchCountLabel.setText(QString(" %1 / %2").arg(index).arg(total));
+	countText =3D QString(" %1 / %2").arg(index + 1).arg(total);
+	_searchFSM._searchCountLabel.setText(countText);
 }
=20
 void KsTraceViewer::_searchStop()
 {
-	_searchStopAction->setVisible(false);
-	_proxyModel.searchStop();
-	_lockSearchPanel(false);
+	_proxyModel._searchStop =3D true;
+	_searchFSM.handleInput(sm_input_t::Stop);
+}
+
+void KsTraceViewer::_searchContinue()
+{
+	_proxyModel._searchStop =3D false;
+	_searchItems();
 }
=20
 void KsTraceViewer::_clicked(const QModelIndex& i)
@@ -499,7 +410,7 @@ void KsTraceViewer::_clicked(const QModelIndex& i)
 	 */
 	size_t row =3D _proxyModel.mapRowFromSource(i.row());
=20
-	if (_searchDone && _matchList.count()) {
+	if (_searchDone() && _matchList.count()) {
 		_setSearchIterator(row);
 		_updateSearchCount();
 	}
@@ -594,7 +505,7 @@ void KsTraceViewer::markSwitch()
 		_view.clearSelection();
 	}
=20
-	row =3D _getSelectedDataRow();
+	row =3D selectedRow();
 	if (row >=3D 0) {
 		_setSearchIterator(row);
 		_updateSearchCount();
@@ -634,7 +545,7 @@ void KsTraceViewer::resizeEvent(QResizeEvent* event)
 void KsTraceViewer::keyReleaseEvent(QKeyEvent *event)
 {
 	if (event->key() =3D=3D Qt::Key_Up || event->key() =3D=3D Qt::Key_Down) {
-		int row =3D _getSelectedDataRow();
+		int row =3D selectedRow();
 		if (row >=3D 0)
 			emit select(row); // Send a signal to the Graph widget.
=20
@@ -668,52 +579,52 @@ void KsTraceViewer::_resizeToContents()
=20
 //! @endcond
=20
-size_t KsTraceViewer::_searchItems(int column,
-				   const QString &searchText,
-				   condition_func cond)
+size_t KsTraceViewer::_searchItems()
 {
+	int column =3D _searchFSM._columnComboBox.currentIndex();
+	QString searchText =3D _searchFSM._searchLineEdit.text();
 	int count, dataRow;
=20
-	_pbAction->setVisible(true);
+	if (searchText.isEmpty()) {
+		/*
+		 * No text is provided by the user. Most probably this
+		 * is an accidental key press. */
+		return 0;
+	}
=20
 	if (_proxyModel.rowCount({}) < KS_SEARCH_SHOW_PROGRESS_MIN) {
 		/*
 		 * This is a small data-set. Do a single-threaded search
 		 * without showing the progress.
 		 */
-		_proxyModel.search(column, searchText, cond, &_matchList,
+		_proxyModel.search(column, searchText, _searchFSM.condition(), &_matchLi=
st,
 				   nullptr, nullptr);
 	} else {
-		_searchStopAction->setVisible(true);
+		_searchFSM.handleInput(sm_input_t::Start);
=20
 		if (column =3D=3D KsViewModel::TRACE_VIEW_COL_INFO ||
-		    column =3D=3D KsViewModel::TRACE_VIEW_COL_LAT) {
-			_proxyModel.search(column, searchText,
-					   cond, &_matchList,
-					   &_searchProgBar,
-					   &_searchCountLabel);
-		} else {
-			_searchItemsMapReduce(column, searchText, cond);
-		}
-
-		_searchStopAction->setVisible(false);
+		    column =3D=3D KsViewModel::TRACE_VIEW_COL_LAT)
+			_proxyModel.search(&_searchFSM, &_matchList);
+		else
+			_searchItemsMapReduce(column, searchText, _searchFSM.condition());
 	}
=20
 	count =3D _matchList.count();
-
-	_pbAction->setVisible(false);
-	_searchDone =3D true;
+	_searchFSM.handleInput(sm_input_t::Finish);
=20
 	if (count =3D=3D 0) // No items have been found. Do nothing.
 		return 0;
=20
-	dataRow =3D _getSelectedDataRow();
+	dataRow =3D selectedRow();
 	if (dataRow >=3D 0) {
 		_view.clearSelection();
 		_setSearchIterator(dataRow);
+		showRow(*_it, true);
+
+		if (_graphFollows)
+			emit select(*_it); // Send a signal to the Graph widget.
 	} else {
 		/* Move the iterator to the beginning of the match list. */
-		_view.clearSelection();
 		_it =3D _matchList.begin();
 	}
=20
@@ -747,7 +658,7 @@ void KsTraceViewer::_setSearchIterator(int row)
=20
 void KsTraceViewer::_searchItemsMapReduce(int column,
 					  const QString &searchText,
-					  condition_func cond)
+					  search_condition_func cond)
 {
 	int nThreads =3D std::thread::hardware_concurrency();
 	std::vector<QPair<int, int>> ranges(nThreads);
@@ -763,9 +674,9 @@ void KsTraceViewer::_searchItemsMapReduce(int column,
 	};
=20
 	auto lamSearchReduce =3D [&] (QList<int> &resultList,
-				  const QList<int> &mapList) {
+				    const QList<int> &mapList) {
 		resultList << mapList;
-		_searchProgBar.setValue(_searchProgBar.value() + 1);
+		_searchFSM.incrementProgress();
 	};
=20
 	for (auto &r: ranges) {
@@ -785,7 +696,7 @@ void KsTraceViewer::_searchItemsMapReduce(int column,
 	while (_proxyModel.searchProgress() < KS_PROGRESS_BAR_MAX - nThreads) {
 		std::unique_lock<std::mutex> lk(_proxyModel._mutex);
 		_proxyModel._pbCond.wait(lk);
-		_searchProgBar.setValue(_proxyModel.searchProgress());
+		_searchFSM.setProgress(_proxyModel.searchProgress());
 		QApplication::processEvents();
 	}
=20
@@ -793,7 +704,11 @@ void KsTraceViewer::_searchItemsMapReduce(int column,
 		lamSearchReduce(_matchList, m.get());
 }
=20
-int KsTraceViewer::_getSelectedDataRow()
+/**
+ * Get the currently selected row. If no row is selected the function
+ * returns -1.
+ */
+int KsTraceViewer::selectedRow()
 {
 	QItemSelectionModel *sm =3D _view.selectionModel();
 	int dataRow =3D -1;
diff --git a/kernel-shark-qt/src/KsTraceViewer.hpp b/kernel-shark-qt/src/Ks=
TraceViewer.hpp
index a8c1fe6..f59f5df 100644
--- a/kernel-shark-qt/src/KsTraceViewer.hpp
+++ b/kernel-shark-qt/src/KsTraceViewer.hpp
@@ -18,6 +18,7 @@
 // KernelShark
 #include "KsUtils.hpp"
 #include "KsModels.hpp"
+#include "KsSearchFSM.hpp"
 #include "KsDualMarker.hpp"
=20
 /**
@@ -67,6 +68,8 @@ public:
=20
 	void clearSelection();
=20
+	int selectedRow();
+
 	void update(KsDataStore *data);
=20
 signals:
@@ -100,24 +103,10 @@ private:
=20
 	QLabel		_labelSearch, _labelGrFollows;
=20
-	QComboBox	_columnComboBox;
-
-	QComboBox	_selectComboBox;
-
-	QLineEdit	_searchLineEdit;
-
-	QPushButton	_prevButton, _nextButton, _searchStopButton;
-
-	QAction		*_pbAction, *_searchStopAction;
+	KsSearchFSM	_searchFSM;
=20
 	QCheckBox	_graphFollowsCheckBox;
=20
-	QProgressBar	_searchProgBar;
-
-	QLabel		_searchCountLabel;
-
-	bool		_searchDone;
-
 	bool		_graphFollows;
=20
 	QList<int>		_matchList;
@@ -139,11 +128,10 @@ private:
=20
 	void _resizeToContents();
=20
-	size_t _searchItems(int column, const QString &searchText,
-			    condition_func cond);
+	size_t _searchItems();
=20
 	void _searchItemsMapReduce(int column, const QString &searchText,
-				   condition_func cond);
+				   search_condition_func cond);
=20
 	void _searchEditText(const QString &);
=20
@@ -161,13 +149,19 @@ private:
=20
 	void _searchStop();
=20
+	void _searchContinue();
+
 	void _clicked(const QModelIndex& i);
=20
 	void _onCustomContextMenu(const QPoint &);
=20
 	void _setSearchIterator(int row);
=20
-	int _getSelectedDataRow();
+	bool _searchDone()
+	{
+		return _searchFSM.getState() =3D=3D search_state_t::Done_s ||
+		       _searchFSM.getState() =3D=3D search_state_t::Paused_s;
+	}
=20
 private slots:
 	void _searchEdit(int);
--=20
2.17.1

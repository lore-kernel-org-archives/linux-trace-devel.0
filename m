Return-Path: <SRS0=pqkA=MY=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-co1nam03on0041.outbound.protection.outlook.com ([104.47.40.41]:22067
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728821AbeJLXrD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Oct 2018 19:47:03 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH 01/10] kernel-shark-qt: Add Dual Marker for KernelShark GUI.
Date: Fri, 12 Oct 2018 19:13:09 +0300
Message-Id: <20181012161318.5302-2-ykaradzhov@vmware.com>
In-Reply-To: <20181012161318.5302-1-ykaradzhov@vmware.com>
References: <20181012161318.5302-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: Yordan Karadzhov (VMware) <y.karadz@gmail.com>

This patch implements the Dual Marker used by the KernelShark GUI.
The Dual Marker uses a simple State Machine having only two states
(A and B). In the following patches the State Machine will connect
to the Table and Graph widgets (not introduced yet) and will allow
the user's actions in one of these widgets to have effect in the
other one.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/src/CMakeLists.txt   |   2 +
 kernel-shark-qt/src/KsDualMarker.cpp | 332 +++++++++++++++++++++++++++
 kernel-shark-qt/src/KsDualMarker.hpp | 188 +++++++++++++++
 3 files changed, 522 insertions(+)
 create mode 100644 kernel-shark-qt/src/KsDualMarker.cpp
 create mode 100644 kernel-shark-qt/src/KsDualMarker.hpp

diff --git a/kernel-shark-qt/src/CMakeLists.txt b/kernel-shark-qt/src/CMakeLists.txt
index 2ac79ca..dc86cdf 100644
--- a/kernel-shark-qt/src/CMakeLists.txt
+++ b/kernel-shark-qt/src/CMakeLists.txt
@@ -32,11 +32,13 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
 
     message(STATUS "libkshark-gui")
     set (ks-guiLib_hdr  KsUtils.hpp
+                        KsDualMarker.hpp
                         KsWidgetsLib.hpp)
 
     QT5_WRAP_CPP(ks-guiLib_hdr_moc ${ks-guiLib_hdr})
 
     add_library(kshark-gui  SHARED  ${ks-guiLib_hdr_moc}    KsUtils.cpp
+                                                            KsDualMarker.cpp
                                                             KsWidgetsLib.cpp)
 
     target_link_libraries(kshark-gui kshark-plot
diff --git a/kernel-shark-qt/src/KsDualMarker.cpp b/kernel-shark-qt/src/KsDualMarker.cpp
new file mode 100644
index 0000000..ae637aa
--- /dev/null
+++ b/kernel-shark-qt/src/KsDualMarker.cpp
@@ -0,0 +1,332 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
+ */
+
+/**
+ *  @file    KsDualMarker.cpp
+ *  @brief   KernelShark Dual Marker.
+ */
+
+#include "KsDualMarker.hpp"
+
+/**
+ * @brief Create KsGraphMark object.
+ *
+ * @param s: The Identifier of the marker (state A or state B).
+ */
+KsGraphMark::KsGraphMark(DualMarkerState s)
+: _color(Qt::darkGreen),
+  _state(s)
+{
+	reset();
+	_mark._color << _color;
+}
+
+/**
+ * @brief Create KsGraphMark object.
+ *
+ * @param s: The Identifier of the marker (state A or state B).
+ * @param col: The color of the marker.
+ */
+KsGraphMark::KsGraphMark(DualMarkerState s, QColor col)
+: _color(col),
+  _state(s)
+{
+	reset();
+	_mark._color << _color;
+}
+
+/** Reset the marker. */
+void KsGraphMark::reset()
+{
+	_isSet = false;
+	_bin = -1;
+	_cpu = -1;
+	_task = -1;
+	_pos = 0;
+
+	_mark._visible = false;
+}
+
+/**
+ * @brief Set the marker.
+ *
+ * @param data: Input location for the Data Store object.
+ * @param histo: Input location for the model descriptor.
+ * @param pos: The index inside the data array this marker will points to.
+ * @param cpuGraph: The index of the CPU Graph this marker points to.
+ * @param taskGraph: The index of the Task Graph this marker points to.
+ */
+bool KsGraphMark::set(const KsDataStore &data,
+		      kshark_trace_histo *histo,
+		      size_t pos, int cpuGraph, int taskGraph)
+{
+	_isSet = true;
+	_pos = pos;
+	_ts = data.rows()[_pos]->ts;
+	_cpu = cpuGraph;
+	_task = taskGraph;
+
+	if (_ts > histo->max || _ts < histo->min) {
+		_bin = -1;
+		_mark._visible = false;
+		return false;
+	}
+
+	_bin = (_ts - histo->min)/histo->bin_size;
+	setVisible(true);
+
+	return true;
+}
+
+/**
+ * @brief Use this function to update the marker when the state of the model
+ *	  has changed.
+ *
+ * @param data: Input location for the Data Store object.
+ * @param histo: Input location for the model descriptor.
+ */
+bool KsGraphMark::update(const KsDataStore &data, kshark_trace_histo *histo)
+{
+	if (!_isSet)
+		return false;
+
+	return set(data, histo, this->_pos, this->_cpu, this->_task);
+}
+
+/** Unset the Marker and make it invisible. */
+void KsGraphMark::remove()
+{
+	_isSet = false;
+	setVisible(false);
+}
+
+/** An operator for getting the opposite state of the marker identifier. */
+DualMarkerState operator!(const DualMarkerState &state)
+{
+	if (state == DualMarkerState::B)
+		return DualMarkerState::A;
+
+	return DualMarkerState::B;
+}
+
+/** @brief Create a Dual Marker State Machine. */
+KsDualMarkerSM::KsDualMarkerSM(QWidget *parent)
+: QWidget(parent),
+  _buttonA("Marker A", this),
+  _buttonB("Marker B", this),
+  _labelDeltaDescr("    A,B Delta: ", this),
+  _markA(DualMarkerState::A, Qt::darkGreen),
+  _markB(DualMarkerState::B, Qt::darkCyan),
+  _scCtrlA(this),
+  _scCtrlB(this)
+{
+	QString styleSheetA, styleSheetB;
+
+	_buttonA.setFixedWidth(STRING_WIDTH(" Marker A "));
+	_buttonB.setFixedWidth(STRING_WIDTH(" Marker B "));
+
+	for (auto const &l: {&_labelMA, &_labelMB, &_labelDelta}) {
+		l->setFrameStyle(QFrame::Panel | QFrame::Sunken);
+		l->setStyleSheet("QLabel {background-color : white;}");
+		l->setTextInteractionFlags(Qt::TextSelectableByMouse);
+		l->setFixedWidth(FONT_WIDTH * 16);
+	}
+
+	styleSheetA = "background : " +
+		      _markA._color.name() +
+		      "; color : white";
+
+	_stateA = new QState;
+	_stateA->setObjectName("A");
+	_stateA->assignProperty(&_buttonA,
+				"styleSheet",
+				styleSheetA);
+
+	_stateA->assignProperty(&_buttonB,
+				"styleSheet",
+				"color : rgb(70, 70, 70)");
+
+	styleSheetB = "background : " +
+		      _markB._color.name() +
+		      "; color : white";
+
+	_stateB = new QState;
+	_stateB->setObjectName("B");
+	_stateB->assignProperty(&_buttonA,
+				"styleSheet",
+				"color : rgb(70, 70, 70)");
+
+	_stateB->assignProperty(&_buttonB,
+				"styleSheet",
+				styleSheetB);
+
+	/* Define transitions from State A to State B. */
+	_stateA->addTransition(this,	&KsDualMarkerSM::machineToB, _stateB);
+
+	_scCtrlA.setKey(Qt::CTRL + Qt::Key_A);
+	_stateA->addTransition(&_scCtrlB, &QShortcut::activated, _stateB);
+
+	connect(&_scCtrlA,	&QShortcut::activated,
+		this,		&KsDualMarkerSM::_doStateA);
+
+	_stateA->addTransition(&_buttonB, &QPushButton::clicked, _stateB);
+
+	connect(&_buttonB,	&QPushButton::clicked,
+		this,		&KsDualMarkerSM::_doStateB);
+
+	/* Define transitions from State B to State A. */
+	_stateB->addTransition(this,	&KsDualMarkerSM::machineToA, _stateA);
+
+	_scCtrlB.setKey(Qt::CTRL + Qt::Key_B);
+	_stateB->addTransition(&_scCtrlA, &QShortcut::activated, _stateA);
+
+	connect(&_scCtrlB,	&QShortcut::activated,
+		this,		&KsDualMarkerSM::_doStateB);
+
+	_stateB->addTransition(&_buttonA, &QPushButton::clicked, _stateA);
+
+	connect(&_buttonA,	&QPushButton::clicked,
+		this,		&KsDualMarkerSM::_doStateA);
+
+	_machine.addState(_stateA);
+	_machine.addState(_stateB);
+	_machine.setInitialState(_stateA);
+	_markState = DualMarkerState::A;
+	_machine.start();
+}
+
+/**
+ * Reset the Mark A and Mark B and clear the information shown by the Marker's
+ * toolbar.
+ */
+void KsDualMarkerSM::reset()
+{
+	_markA.reset();
+	_markB.reset();
+	_labelMA.setText("");
+	_labelMB.setText("");
+	_labelDelta.setText("");
+}
+
+/** Restart the Dual Marker State Machine. */
+void KsDualMarkerSM::restart()
+{
+	_machine.stop();
+	reset();
+	_markState = DualMarkerState::A;
+	_machine.start();
+}
+
+void KsDualMarkerSM::_doStateA()
+{
+	if (_markState !=  DualMarkerState::A) {
+		_markState = DualMarkerState::A;
+		emit markSwitchForView();
+	} else if (activeMarker()._isSet) {
+		emit updateView(activeMarker()._pos, true);
+		emit updateGraph(activeMarker()._pos);
+	}
+}
+
+void KsDualMarkerSM::_doStateB()
+{
+	if (_markState !=  DualMarkerState::B) {
+		_markState = DualMarkerState::B;
+		emit markSwitchForView();
+	} else if (activeMarker()._isSet) {
+		emit updateView(activeMarker()._pos, true);
+		emit updateGraph(activeMarker()._pos);
+	}
+}
+
+/** Get the Graph marker associated with a given state. */ 
+KsGraphMark &KsDualMarkerSM::getMarker(DualMarkerState s)
+{
+	if (s == DualMarkerState::A)
+		return _markA;
+
+	return _markB;
+}
+
+/** Position all buttons and labels of the Dual Marker in a toolbar. */
+void KsDualMarkerSM::placeInToolBar(QToolBar *tb)
+{
+	tb->addWidget(new QLabel("   "));
+	tb->addWidget(&_buttonA);
+	tb->addWidget(&_labelMA);
+	tb->addSeparator();
+	tb->addWidget(new QLabel("   "));
+	tb->addWidget(&_buttonB);
+	tb->addWidget(&_labelMB);
+	tb->addSeparator();
+	tb->addWidget(&_labelDeltaDescr);
+	tb->addWidget(&_labelDelta);
+}
+
+/** Set the state of the Dual Marker State Machine. */
+void KsDualMarkerSM::setState(DualMarkerState st) {
+	if (st == _markState)
+		return;
+
+	if (st == DualMarkerState::A) {
+		emit machineToA();
+		_doStateA();
+	}
+
+	if (st == DualMarkerState::B) {
+		emit machineToB();
+		_doStateB();
+	}
+}
+
+/**
+ * @brief Use this function to update the two marker when the state of the
+ *	  model has changed.
+ *
+ * @param data: Input location for the Data Store object.
+ * @param histo: Input location for the model descriptor.
+ */
+void KsDualMarkerSM::updateMarkers(const KsDataStore &data,
+				   kshark_trace_histo *histo)
+{
+	_markA.update(data, histo);
+	_markB.update(data, histo);
+
+	updateLabels();
+}
+
+/**
+ * @brief Use this function to update the labels when the state of the model
+ *	  has changed.
+ */
+void KsDualMarkerSM::updateLabels()
+{
+	QString mark, delta;
+
+	// Marker A
+	if (_markA._isSet) {
+		mark = KsUtils::Ts2String(_markA._ts, 7);
+		_labelMA.setText(mark);
+	} else {
+		_labelMA.setText("");
+	}
+
+	// Marker B
+	if (_markB._isSet) {
+		mark = KsUtils::Ts2String(_markB._ts, 7);
+		_labelMB.setText(mark);
+	} else {
+		_labelMB.setText("");
+	}
+
+	// Delta
+	if (_markA._isSet && _markB._isSet) {
+		delta = KsUtils::Ts2String(_markB._ts - _markA._ts, 7);
+		_labelDelta.setText(delta);
+	} else {
+		_labelDelta.setText("");
+	}
+}
diff --git a/kernel-shark-qt/src/KsDualMarker.hpp b/kernel-shark-qt/src/KsDualMarker.hpp
new file mode 100644
index 0000000..401b41c
--- /dev/null
+++ b/kernel-shark-qt/src/KsDualMarker.hpp
@@ -0,0 +1,188 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+
+/*
+ * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
+ */
+
+/**
+ *  @file    KsDualMarker.hpp
+ *  @brief   KernelShark Dual Marker.
+ */
+
+#ifndef _KS_DUAL_MARKER_H
+#define _KS_DUAL_MARKER_H
+
+// Qt
+#include <QtWidgets>
+
+// KernelShark
+#include "KsUtils.hpp"
+#include "KsPlotTools.hpp"
+
+/** The KsGraphMark represents a marker for KernelShark GUI. */
+class KsGraphMark : public QObject
+{
+	Q_OBJECT
+public:
+	KsGraphMark() = delete;
+
+	KsGraphMark(DualMarkerState s);
+
+	KsGraphMark(DualMarkerState s, QColor col);
+
+	void reset();
+
+	bool set(const KsDataStore &data,
+		 kshark_trace_histo *histo,
+		 size_t pos,
+		 int cpuGraph,
+		 int taskGraph);
+
+	bool update(const KsDataStore &data, kshark_trace_histo *histo);
+
+	/** Is this marker visible. */
+	bool isVisible() const {return _mark._visible;}
+
+	/** Draw this marker. */
+	void draw() const {_mark.draw();}
+
+	/** Set the visiblity of the marker. */
+	void setVisible(bool v) {_mark._visible = v;}
+
+	void remove();
+
+public:
+	/** Is this marker set. */
+	bool		_isSet;
+
+	/** The number of the bin this marker points to. */
+	int		_bin;
+
+	/** The index of the CPU Graph this marker points to. */
+	int		_cpu;
+
+	/** The  index of the Task Graph this marker points to. */
+	int		_task;
+
+	/** The index inside the data array this marker points to. */
+	size_t		_pos;
+
+	/** The timestamp of the marker. */
+	uint64_t	_ts;
+
+	/** The RGB color of the marker. */
+	QColor		_color;
+
+	/** The Identifier of the marker (A or B). */
+	const DualMarkerState	_state;
+
+	/** The graphical element of this marker. */
+	KsPlot::Mark		_mark;
+};
+
+DualMarkerState operator !(const DualMarkerState &state);
+
+/**
+ * The DualMarkerState represents the State Machine of the KernelShark GUI
+ * Dual Marker.
+ */
+class KsDualMarkerSM : public QWidget
+{
+	Q_OBJECT
+public:
+	explicit KsDualMarkerSM(QWidget *parent = nullptr);
+
+	void reset();
+
+	void restart();
+
+	void placeInToolBar(QToolBar *tb);
+
+	/** Get the Identifier of the current state of the State Machine. */
+	DualMarkerState getState() const {return _markState;}
+
+	void setState(DualMarkerState st);
+
+	KsGraphMark &getMarker(DualMarkerState s);
+
+	/** Get the active marker. */
+	KsGraphMark &activeMarker() {return getMarker(_markState);}
+
+	/** Get the passive marker. */
+	KsGraphMark &passiveMarker() {return getMarker(!_markState);}
+
+	/** Get the marker A. */
+	KsGraphMark &markerA() {return _markA;}
+
+	/** Get the marker B. */
+	KsGraphMark &markerB() {return _markB;}
+
+	/** Get a pointer to the State A object. */
+	QState *stateAPtr() {return _stateA;}
+
+	/** Get a pointer to the State B object. */
+	QState *stateBPtr() {return _stateB;}
+
+	void updateMarkers(const KsDataStore &data,
+			   kshark_trace_histo *histo);
+
+	void updateLabels();
+
+signals:
+	/**
+	 * This signal is emitted when the Table View has to switch the color
+	 * of the selected row.
+	 */
+	void markSwitchForView();
+
+	/**
+	 * This signal is emitted when the Table View has to show a different
+	 * entry (row).
+	 */
+	void updateView(size_t pos, bool mark);
+
+	/**
+	 * This signal is emitted when the Graph mark has to show a different
+	 * entry.
+	 */
+	void updateGraph(size_t pos);
+
+	/**
+	 * This signal is emitted when the State Machine has to switch to
+	 * state A.
+	 */
+	void machineToA();
+
+	/**
+	 * This signal is emitted when the State Machine has to switch to
+	 * state B.
+	 */
+	void machineToB();
+
+private:
+	QPushButton	 _buttonA;
+
+	QPushButton	 _buttonB;
+
+	QLabel		 _labelMA, _labelMB, _labelDelta;
+
+	QLabel		 _labelDeltaDescr;
+
+	QState		*_stateA;
+
+	QState		*_stateB;
+
+	QStateMachine	 _machine;
+
+	DualMarkerState	 _markState;
+
+	KsGraphMark	 _markA, _markB;
+
+	QShortcut        _scCtrlA, _scCtrlB;
+
+	void _doStateA();
+
+	void _doStateB();
+};
+
+#endif
-- 
2.17.1

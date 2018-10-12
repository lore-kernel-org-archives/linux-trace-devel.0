Return-Path: <SRS0=pqkA=MY=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-co1nam03on0041.outbound.protection.outlook.com ([104.47.40.41]:22067
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728800AbeJLXrd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Oct 2018 19:47:33 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH 07/10] kernel-shark-qt: Add dialog for Advanced filtering.
Date: Fri, 12 Oct 2018 19:13:15 +0300
Message-Id: <20181012161318.5302-8-ykaradzhov@vmware.com>
In-Reply-To: <20181012161318.5302-1-ykaradzhov@vmware.com>
References: <20181012161318.5302-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: Yordan Karadzhov (VMware) <y.karadz@gmail.com>

This patch defines a dialog for configuring and using Advanced filtering.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/src/CMakeLists.txt           |   6 +-
 kernel-shark-qt/src/KsAdvFilteringDialog.cpp | 440 +++++++++++++++++++
 kernel-shark-qt/src/KsAdvFilteringDialog.hpp |  91 ++++
 3 files changed, 535 insertions(+), 2 deletions(-)
 create mode 100644 kernel-shark-qt/src/KsAdvFilteringDialog.cpp
 create mode 100644 kernel-shark-qt/src/KsAdvFilteringDialog.hpp

diff --git a/kernel-shark-qt/src/CMakeLists.txt b/kernel-shark-qt/src/CMakeLists.txt
index d406866..26b45f4 100644
--- a/kernel-shark-qt/src/CMakeLists.txt
+++ b/kernel-shark-qt/src/CMakeLists.txt
@@ -37,7 +37,8 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
                         KsDualMarker.hpp
                         KsWidgetsLib.hpp
                         KsTraceGraph.hpp
-                        KsTraceViewer.hpp)
+                        KsTraceViewer.hpp
+                        KsAdvFilteringDialog.hpp)
 
     QT5_WRAP_CPP(ks-guiLib_hdr_moc ${ks-guiLib_hdr})
 
@@ -47,7 +48,8 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
                                                             KsDualMarker.cpp
                                                             KsWidgetsLib.cpp
                                                             KsTraceGraph.cpp
-                                                            KsTraceViewer.cpp)
+                                                            KsTraceViewer.cpp
+                                                            KsAdvFilteringDialog.cpp)
 
     target_link_libraries(kshark-gui kshark-plot
                                      ${CMAKE_DL_LIBS}
diff --git a/kernel-shark-qt/src/KsAdvFilteringDialog.cpp b/kernel-shark-qt/src/KsAdvFilteringDialog.cpp
new file mode 100644
index 0000000..ff5a39d
--- /dev/null
+++ b/kernel-shark-qt/src/KsAdvFilteringDialog.cpp
@@ -0,0 +1,440 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
+ */
+
+/**
+ *  @file    KsAdvFilteringDialog.cpp
+ *  @brief   GUI Dialog for Advanced filtering settings.
+ */
+
+// KernelShark
+#include "KsAdvFilteringDialog.hpp"
+#include "libkshark.h"
+#include "KsUtils.hpp"
+
+/** Create dialog for Advanced Filtering. */
+KsAdvFilteringDialog::KsAdvFilteringDialog(QWidget *parent)
+: QDialog(parent),
+  _condToolBar1(this),
+  _condToolBar2(this),
+  _condToolBar3(this),
+  _descrLabel(this),
+  _sysEvLabel("System/Event: ", &_condToolBar1),
+  _opsLabel("Operator: ", this),
+  _fieldLabel("Field: ", this),
+  _systemComboBox(&_condToolBar1),
+  _eventComboBox(&_condToolBar1),
+  _opsComboBox(&_condToolBar2),
+  _fieldComboBox(&_condToolBar3),
+  _filterEdit(this),
+  _helpButton("Show Help", this),
+  _insertEvtButton("Insert", this),
+  _insertOpButton("Insert", this),
+  _insertFieldButton("Insert", this),
+  _applyButton("Apply", this),
+  _cancelButton("Cancel", this)
+{
+	struct kshark_context *kshark_ctx(NULL);
+	int buttonWidth;
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	auto lamAddLine = [&] {
+		QFrame* line = new QFrame();
+		line->setFrameShape(QFrame::HLine);
+		line->setFrameShadow(QFrame::Sunken);
+		_topLayout.addWidget(line);
+	};
+
+	setMinimumWidth(FONT_WIDTH * 80);
+
+	buttonWidth = STRING_WIDTH("--Show Help--");
+
+	_helpButton.setFixedWidth(buttonWidth);
+	_helpButton.setDefault(false);
+	_topLayout.addWidget(&_helpButton);
+
+	connect(&_helpButton,	&QPushButton::pressed,
+		this,		&KsAdvFilteringDialog::_help);
+
+	_descrLabel.setText(_description());
+	_topLayout.addWidget(&_descrLabel);
+
+	/*
+	 * For the moment do not show the syntax description. It will be shown
+	 * only if the "Show Help" button is clicked.
+	 */
+	_descrLabel.hide();
+
+	lamAddLine();
+
+	_getFilters(kshark_ctx);
+
+	if (_filters.count()) {
+		_makeFilterTable(kshark_ctx);
+		lamAddLine();
+	}
+
+	_condToolBar1.addWidget(&_sysEvLabel);
+	_condToolBar1.addWidget(&_systemComboBox);
+	_condToolBar1.addWidget(&_eventComboBox);
+
+	/*
+	 * Using the old Signal-Slot syntax because QComboBox::currentIndexChanged
+	 * has overloads.
+	 */
+	connect(&_systemComboBox,	SIGNAL(currentIndexChanged(const QString&)),
+		this,			SLOT(_systemChanged(const QString&)));
+
+	connect(&_eventComboBox,	SIGNAL(currentIndexChanged(const QString&)),
+		this,			SLOT(_eventChanged(const QString&)));
+
+	_setSystemCombo(kshark_ctx);
+
+	_condToolBar1.addSeparator();
+	_condToolBar1.addWidget(&_insertEvtButton);
+	_topLayout.addWidget(&_condToolBar1);
+
+	_opsComboBox.addItems(_operators());
+
+	_condToolBar2.addWidget(&_opsLabel);
+	_condToolBar2.addWidget(&_opsComboBox);
+
+	_condToolBar2.addSeparator();
+	_condToolBar2.addWidget(&_insertOpButton);
+	_topLayout.addWidget(&_condToolBar2);
+
+	_condToolBar3.addWidget(&_fieldLabel);
+	_condToolBar3.addWidget(&_fieldComboBox);
+
+	_condToolBar3.addSeparator();
+	_condToolBar3.addWidget(&_insertFieldButton);
+	_topLayout.addWidget(&_condToolBar3);
+
+	lamAddLine();
+
+	_filterEdit.setMinimumWidth(50 * FONT_WIDTH);
+	_topLayout.addWidget(&_filterEdit);
+	this->setLayout(&_topLayout);
+
+	buttonWidth = STRING_WIDTH("--Cancel--");
+	_applyButton.setFixedWidth(buttonWidth);
+	_applyButton.setDefault(true);
+	_cancelButton.setFixedWidth(buttonWidth);
+	_buttonLayout.addWidget(&_applyButton);
+	_buttonLayout.addWidget(&_cancelButton);
+	_buttonLayout.setAlignment(Qt::AlignLeft);
+	_topLayout.addLayout(&_buttonLayout);
+
+	connect(&_insertEvtButton,	&QPushButton::pressed,
+		this,			&KsAdvFilteringDialog::_insertEvt);
+
+	connect(&_insertOpButton,	&QPushButton::pressed,
+		this,			&KsAdvFilteringDialog::_insertOperator);
+
+	connect(&_insertFieldButton,	&QPushButton::pressed,
+		this,			&KsAdvFilteringDialog::_insertField);
+
+	_applyButtonConnection =
+		connect(&_applyButton,	&QPushButton::pressed,
+			this,		&KsAdvFilteringDialog::_applyPress);
+
+	connect(&_applyButton,		&QPushButton::pressed,
+		this,			&QWidget::close);
+
+	connect(&_cancelButton,		&QPushButton::pressed,
+		this,			&QWidget::close);
+}
+
+void KsAdvFilteringDialog::_setSystemCombo(struct kshark_context *kshark_ctx)
+{
+	tep_event_format **events;
+	QStringList sysList;
+	int i(0), nEvts(0);
+
+	if (kshark_ctx->pevent) {
+		nEvts = tep_get_events_count(kshark_ctx->pevent);
+		events = tep_list_events(kshark_ctx->pevent,
+					 TEP_EVENT_SORT_SYSTEM);
+	}
+
+	while (i < nEvts) {
+		QString sysName(events[i]->system);
+		sysList << sysName;
+		while (sysName == events[i]->system) {
+			if (++i == nEvts)
+				break;
+		}
+	}
+
+	qSort(sysList);
+	_systemComboBox.addItems(sysList);
+
+	i = _systemComboBox.findText("ftrace");
+	if (i >= 0)
+		_systemComboBox.setCurrentIndex(i);
+}
+
+QString KsAdvFilteringDialog::_description()
+{
+	QString descrText = "Usage:\n";
+	descrText += " <sys/event>[,<sys/event>] : [!][(]<field><op><val>[)]";
+	descrText += "[&&/|| [(]<field><op><val>[)]]\n\n";
+	descrText += "Examples:\n\n";
+	descrText += "   sched/sched_switch : next_prio < 100 && (prev_prio > 100";
+	descrText += "&& prev_pid != 0)\n\n";
+	descrText += "   irq.* : irq != 38\n\n";
+	descrText += "   .* : common_pid == 1234\n";
+
+	return descrText;
+}
+
+QStringList KsAdvFilteringDialog::_operators()
+{
+	QStringList OpsList;
+	OpsList << ":" << "," << "==" << "!=" << ">" << "<" << ">=" << "<=";
+	OpsList << "=~" << "!~" << "!" << "(" << ")" << "+" << "-";
+	OpsList << "*" << "/" << "<<" << ">>" << "&&" << "||" << "&";
+
+	return OpsList;
+}
+
+void KsAdvFilteringDialog::_getFilters(struct kshark_context *kshark_ctx)
+{
+	tep_event_format **events;
+	char *str;
+
+	events = tep_list_events(kshark_ctx->pevent, TEP_EVENT_SORT_SYSTEM);
+
+	for (int i = 0; events[i]; i++) {
+		str = tep_filter_make_string(kshark_ctx->advanced_event_filter,
+					     events[i]->id);
+		if (!str)
+			continue;
+
+		_filters.insert(events[i]->id,
+				QString("%1/%2:%3\n").arg(events[i]->system,
+							  events[i]->name, str));
+
+		free(str);
+	}
+}
+
+void KsAdvFilteringDialog::_makeFilterTable(struct kshark_context *kshark_ctx)
+{
+	QMapIterator<int, QString> f(_filters);
+	QTableWidgetItem *i1, *i2, *i3;
+	QStringList headers;
+	int count(0);
+
+	_table = new KsCheckBoxTable(this);
+	_table->setSelectionMode(QAbstractItemView::SingleSelection);
+	headers << "Delete" << "Event" << " Id" << "Filter";
+	_table->init(headers, _filters.count());
+
+	for(auto f : _filters.keys()) {
+		QStringList thisFilter = _filters.value(f).split(":");
+
+		i1 = new QTableWidgetItem(thisFilter[0]);
+		_table->setItem(count, 1, i1);
+
+		i2 = new QTableWidgetItem(tr("%1").arg(f));
+		_table->setItem(count, 2, i2);
+
+		i3 = new QTableWidgetItem(thisFilter[1]);
+		_table->setItem(count, 3, i3);
+
+		++count;
+	}
+
+	_table->setVisible(false);
+	_table->resizeColumnsToContents();
+	_table->setVisible(true);
+
+	_topLayout.addWidget(_table);
+}
+
+void KsAdvFilteringDialog::_help()
+{
+	if (_descrLabel.isVisible()) {
+		_descrLabel.hide();
+		QApplication::processEvents();
+
+		_helpButton.setText("Show Help");
+		resize(width(), _noHelpHeight);
+	} else {
+		_helpButton.setText("Hide Help");
+		_noHelpHeight = height();
+		_descrLabel.show();
+	}
+}
+
+void KsAdvFilteringDialog::_systemChanged(const QString &sysName)
+{
+	kshark_context *kshark_ctx(NULL);
+	tep_event_format **events;
+	QStringList evtsList;
+	int i, nEvts;
+
+	_eventComboBox.clear();
+	if (!kshark_instance(&kshark_ctx) || !kshark_ctx->pevent)
+		return;
+
+	nEvts = tep_get_events_count(kshark_ctx->pevent);
+	events = tep_list_events(kshark_ctx->pevent, TEP_EVENT_SORT_SYSTEM);
+
+	for (i = 0; i < nEvts; ++i) {
+		if (sysName == events[i]->system)
+			evtsList << events[i]->name;
+	}
+
+	qSort(evtsList);
+	_eventComboBox.addItems(evtsList);
+
+	i = _eventComboBox.findText("function");
+	if (i >= 0)
+		_eventComboBox.setCurrentIndex(i);
+}
+
+QStringList
+KsAdvFilteringDialog::_getEventFormatFields(struct tep_event_format *event)
+{
+	tep_format_field *field, **fields = tep_event_fields(event);
+	QStringList fieldList;
+
+	for (field = *fields; field; field = field->next)
+		fieldList << field->name;
+
+	free(fields);
+
+	qSort(fieldList);
+	return fieldList;
+}
+
+void KsAdvFilteringDialog::_eventChanged(const QString &evtName)
+{
+	QString sysName = _systemComboBox.currentText();
+	kshark_context *kshark_ctx(NULL);
+	tep_event_format **events;
+	QStringList fieldList;
+	int nEvts;
+
+	_fieldComboBox.clear();
+	if (!kshark_instance(&kshark_ctx) || !kshark_ctx->pevent)
+		return;
+
+	nEvts = tep_get_events_count(kshark_ctx->pevent);
+	events = tep_list_events(kshark_ctx->pevent, TEP_EVENT_SORT_SYSTEM);
+
+	for (int i = 0; i < nEvts; ++i) {
+		if (evtName == events[i]->name &&
+		    sysName == events[i]->system) {
+			fieldList = _getEventFormatFields(events[i]);
+			_fieldComboBox.addItems(fieldList);
+
+			return;
+		}
+	}
+}
+
+void KsAdvFilteringDialog::_insertEvt()
+{
+	QString text = _filterEdit.text();
+
+	auto set_evt = [&] ()
+	{
+		text += _systemComboBox.currentText();
+		text += "/";
+		text += _eventComboBox.currentText();
+	};
+
+	if (text == "") {
+		set_evt();
+		text += ":";
+	} else {
+		QString evt = text;
+		text = "";
+		set_evt();
+		text += ",";
+		text += evt;
+	}
+	_filterEdit.setText(text);
+}
+
+void KsAdvFilteringDialog::_insertOperator()
+{
+	QString text = _filterEdit.text();
+
+	text += _opsComboBox.currentText();
+	_filterEdit.setText(text);
+}
+
+void KsAdvFilteringDialog::_insertField()
+{
+	QString text = _filterEdit.text();
+
+	text += _fieldComboBox.currentText();
+	_filterEdit.setText(text);
+}
+
+void KsAdvFilteringDialog::_applyPress()
+{
+	QMapIterator<int, QString> f(_filters);
+	kshark_context *kshark_ctx(NULL);
+	const char *text;
+	tep_errno ret;
+	char *filter;
+	int i(0);
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	while (f.hasNext()) {
+		f.next();
+		if (_table->_cb[i]->checkState() == Qt::Checked) {
+			tep_filter_remove_event(kshark_ctx->advanced_event_filter,
+						f.key());
+		}
+		++i;
+	}
+
+	auto job_done = [&]() {
+		/*
+		* Disconnect Apply button. This is done in order to protect
+		* against multiple clicks.
+		*/
+		disconnect(_applyButtonConnection);
+		emit dataReload();
+	};
+
+	text = _filterEdit.text().toLocal8Bit().data();
+	if (strlen(text) == 0) {
+		job_done();
+		return;
+	}
+
+	filter = (char*) malloc(strlen(text) + 1);
+	strcpy(filter, text);
+
+	ret = tep_filter_add_filter_str(kshark_ctx->advanced_event_filter,
+					   filter);
+
+	if (ret < 0) {
+		char error_str[200];
+
+		tep_strerror(kshark_ctx->pevent, ret, error_str,
+						       sizeof(error_str));
+
+		fprintf(stderr, "filter failed due to: %s\n", error_str);
+		free(filter);
+
+		return;
+	}
+
+	free(filter);
+
+	job_done();
+}
diff --git a/kernel-shark-qt/src/KsAdvFilteringDialog.hpp b/kernel-shark-qt/src/KsAdvFilteringDialog.hpp
new file mode 100644
index 0000000..cde685c
--- /dev/null
+++ b/kernel-shark-qt/src/KsAdvFilteringDialog.hpp
@@ -0,0 +1,91 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+
+/*
+ * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
+ */
+
+/**
+ *  @file    KsAdvFilteringDialog.hpp
+ *  @brief   GUI Dialog for Advanced filtering settings.
+ */
+
+#ifndef _KS_ADV_FILTERING_DIALOG_H
+#define _KS_ADV_FILTERING_DIALOG_H
+
+// Qt
+#include <QtWidgets>
+
+// KernelShark
+#include "KsWidgetsLib.hpp"
+
+/**
+ * The KsAdvFilteringDialog class provides a dialog for Advanced filtering.
+ */
+class KsAdvFilteringDialog : public QDialog
+{
+	Q_OBJECT
+public:
+	explicit KsAdvFilteringDialog(QWidget *parent = nullptr);
+
+signals:
+	/** Signal emitted when the _apply button of the dialog is pressed. */
+	void dataReload();
+
+private:
+	int 			_noHelpHeight;
+
+	QMap<int, QString>	_filters;
+
+	KsCheckBoxTable		*_table;
+
+	QVBoxLayout	_topLayout;
+
+	QHBoxLayout	_buttonLayout;
+
+	QToolBar	_condToolBar1, _condToolBar2, _condToolBar3;
+
+	QLabel		_descrLabel, _sysEvLabel, _opsLabel, _fieldLabel;
+
+	QComboBox	_systemComboBox, _eventComboBox;
+
+	QComboBox	_opsComboBox, _fieldComboBox;
+
+	QLineEdit	_filterEdit;
+
+	QPushButton	_helpButton;
+
+	QPushButton	_insertEvtButton, _insertOpButton, _insertFieldButton;
+
+	QPushButton	_applyButton, _cancelButton;
+
+	QMetaObject::Connection		_applyButtonConnection;
+
+	void _help();
+
+	void _applyPress();
+
+	void _insertEvt();
+
+	void _insertOperator();
+
+	void _insertField();
+
+	QString _description();
+
+	QStringList _operators();
+
+	void _getFilters(struct kshark_context *kshark_ctx);
+
+	void _makeFilterTable(struct kshark_context *kshark_ctx);
+
+	QStringList _getEventFormatFields(struct tep_event_format *event);
+
+	void _setSystemCombo(struct kshark_context *kshark_ctx);
+
+private slots:
+	void _systemChanged(const QString&);
+
+	void _eventChanged(const QString&);
+};
+
+#endif // _KS_ADV_FILTERING_DIALOG_H
-- 
2.17.1

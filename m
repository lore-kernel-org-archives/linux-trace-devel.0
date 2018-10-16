Return-Path: <SRS0=XQBu=M4=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-sn1nam01on0073.outbound.protection.outlook.com ([104.47.32.73]:27872
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726778AbeJPXoO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Oct 2018 19:44:14 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>,
        Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH v2 03/23] kernel-shark-qt: Add model for showing trace data in
 a text format.
Date: Tue, 16 Oct 2018 15:52:59 +0000
Message-ID: <20181016155232.5257-4-ykaradzhov@vmware.com>
References: <20181016155232.5257-1-ykaradzhov@vmware.com>
In-Reply-To: <20181016155232.5257-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: Yordan Karadzhov (VMware) <y.karadz@gmail.com>

This patch defines the model used by the Trace Viewer widget used to
display trace data in a table-like form.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/src/CMakeLists.txt |   2 +
 kernel-shark-qt/src/KsModels.cpp   | 332 +++++++++++++++++++++++++++++
 kernel-shark-qt/src/KsModels.hpp   | 223 +++++++++++++++++++
 3 files changed, 557 insertions(+)
 create mode 100644 kernel-shark-qt/src/KsModels.cpp
 create mode 100644 kernel-shark-qt/src/KsModels.hpp

diff --git a/kernel-shark-qt/src/CMakeLists.txt b/kernel-shark-qt/src/CMake=
Lists.txt
index dc86cdf..3fd518b 100644
--- a/kernel-shark-qt/src/CMakeLists.txt
+++ b/kernel-shark-qt/src/CMakeLists.txt
@@ -32,12 +32,14 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
=20
     message(STATUS "libkshark-gui")
     set (ks-guiLib_hdr  KsUtils.hpp
+                        KsModels.hpp
                         KsDualMarker.hpp
                         KsWidgetsLib.hpp)
=20
     QT5_WRAP_CPP(ks-guiLib_hdr_moc ${ks-guiLib_hdr})
=20
     add_library(kshark-gui  SHARED  ${ks-guiLib_hdr_moc}    KsUtils.cpp
+                                                            KsModels.cpp
                                                             KsDualMarker.c=
pp
                                                             KsWidgetsLib.c=
pp)
=20
diff --git a/kernel-shark-qt/src/KsModels.cpp b/kernel-shark-qt/src/KsModel=
s.cpp
new file mode 100644
index 0000000..095e26b
--- /dev/null
+++ b/kernel-shark-qt/src/KsModels.cpp
@@ -0,0 +1,332 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
+ */
+
+/**
+ *  @file    KsModels.cpp
+ *  @brief   Models for data representation.
+ */
+
+// KernelShark
+#include "KsModels.hpp"
+#include "KsWidgetsLib.hpp"
+#include "KsUtils.hpp"
+
+/** Create a default (empty) KsFilterProxyModel object. */
+KsFilterProxyModel::KsFilterProxyModel(QObject *parent)
+: QSortFilterProxyModel(parent),
+  _searchStop(false),
+  _source(nullptr)
+{}
+
+/**
+ * Returns False if the item in the row indicated by the sourceRow and
+ * sourceParentshould be filtered out. Otherwise returns True.
+ */
+bool
+KsFilterProxyModel::filterAcceptsRow(int sourceRow,
+				     const QModelIndex &sourceParent) const
+{
+	if (_data[sourceRow]->visible & KS_TEXT_VIEW_FILTER_MASK)
+		return true;
+
+	return false;
+}
+
+/** Provide the Proxy model with data. */
+void KsFilterProxyModel::fill(KsDataStore *data)
+{
+	_data =3D data->rows();
+}
+
+/** Set the source model for this Proxy model. */
+void KsFilterProxyModel::setSource(KsViewModel *s)
+{
+	QSortFilterProxyModel::setSourceModel(s);
+	_source =3D s;
+}
+
+void KsFilterProxyModel::_search(int column,
+				 const QString &searchText,
+				 condition_func cond,
+				 QList<int> *matchList,
+				 int first, int last,
+				 QProgressBar *pb,
+				 QLabel *l,
+				 bool notify)
+{
+	int row, nRows(last - first + 1);
+	int pbCount(1);
+	QVariant item;
+	QString text;
+
+	_searchProgress =3D 0;
+
+	if (nRows > KS_PROGRESS_BAR_MAX)
+		pbCount =3D nRows / KS_PROGRESS_BAR_MAX;
+	else
+		_searchProgress =3D KS_PROGRESS_BAR_MAX - nRows;
+
+	/* Loop over the items of the proxy model. */
+	for (int r =3D first; r <=3D last; ++r) {
+		/*
+		 * Use the index of the proxy model to retrieve the value
+		 * of the row number in the base model.
+		 */
+		row =3D mapRowFromSource(r);
+		item =3D _source->getValue(column, row);
+		if (cond(searchText, item.toString())) {
+			matchList->append(row);
+		}
+
+		if (_searchStop) {
+			_searchStop =3D false;
+			break;
+		}
+
+		/* Deal with the Progress bar of the seatch. */
+		if ((r - first) % pbCount =3D=3D 0) {
+			if (notify) {
+				std::lock_guard<std::mutex> lk(_mutex);
+				++_searchProgress;
+				_pbCond.notify_one();
+			} else {
+				if (pb)
+					pb->setValue(pb->value() + 1);
+				if (l)
+					l->setText(QString(" %1").arg(matchList->count()));
+				QApplication::processEvents();
+			}
+		}
+	}
+}
+
+/** @brief Search the content of the table for a data satisfying an abstra=
ct
+ *	   condition.
+ *
+ * @param column: The number of the column to search in.
+ * @param searchText: The text to search for.
+ * @param cond: Matching condition function.
+ * @param matchList: Output location for a list containing the row indexes=
 of
+ *		     the cells satisfying matching condition.
+ * @param pb: Input location for a Progressbar used to visualize the progr=
ess
+ *	      of the search.
+ * @param l: Input location for a label used to show the number of cells f=
ound.
+ *
+ * @returns The number of cells satisfying the matching condition.
+ */
+size_t KsFilterProxyModel::search(int column,
+				  const QString &searchText,
+				  condition_func cond,
+				  QList<int> *matchList,
+				  QProgressBar *pb,
+				  QLabel *l)
+{
+	int nRows =3D rowCount({});
+
+	_search(column, searchText, cond, matchList, 0, nRows - 1,
+		pb, l, false);
+
+	return matchList->count();
+}
+
+/** @brief Search the content of the table for a data satisfying an abstra=
ct
+ *	   condition.
+ *
+ * @param column: The number of the column to search in.
+ * @param searchText: The text to search for.
+ * @param cond: Matching condition function.
+ * @param first: Row index specifying the position inside the table from
+ *		 where the search starts.
+ * @param last:  Row index specifying the position inside the table from
+ *		 where the search ends.
+ * @param notify: Input location for flag specifying if the search has to
+ *		  notify the main thread when to update the progress bar.
+ *
+ * @returns A list containing the row indexes of the cells satisfying matc=
hing
+ *	    condition.
+ */
+QList<int> KsFilterProxyModel::searchMap(int column,
+					 const QString &searchText,
+					 condition_func cond,
+					 int first,
+					 int last,
+					 bool notify)
+{
+	QList<int> matchList;
+	qInfo() << "searchMap" << first << last;
+	_search(column, searchText, cond, &matchList, first, last,
+		nullptr, nullptr, notify);
+
+	return matchList;
+}
+
+/** Create default (empty) KsViewModel object. */
+KsViewModel::KsViewModel(QObject *parent)
+: QAbstractTableModel(parent),
+  _data(nullptr),
+  _nRows(0),
+  _header({"#", "CPU", "Time Stamp", "Task", "PID",
+	   "Latency", "Event", "Info"}),
+  _markA(-1),
+  _markB(-1)
+{}
+
+/**
+ * Get the data stored under the given role for the item referred to by
+ * the index. This is an implementation of the pure virtual method of the
+ * abstract model class.
+ */
+QVariant KsViewModel::data(const QModelIndex &index, int role) const
+{
+	if (role =3D=3D Qt::ForegroundRole) {
+		if (index.row() =3D=3D _markA)
+			return QVariant::fromValue(QColor(Qt::white));
+
+		if (index.row() =3D=3D _markB)
+			return QVariant::fromValue(QColor(Qt::white));
+	}
+
+	if (role =3D=3D Qt::BackgroundRole) {
+		if (index.row() =3D=3D _markA)
+			return QVariant::fromValue(QColor(_colorMarkA));
+
+		if (index.row() =3D=3D _markB)
+			return QVariant::fromValue(QColor(_colorMarkB));
+	}
+
+	if (role =3D=3D Qt::DisplayRole)
+		return this->getValue(index.column(), index.row());
+
+	return {};
+}
+
+/** Get the data stored in a given cell of the table. */
+QVariant KsViewModel::getValue(int column, int row) const
+{
+	switch (column) {
+		case TRACE_VIEW_COL_INDEX :
+			return row;
+
+		case TRACE_VIEW_COL_CPU:
+			return _data[row]->cpu;
+
+		case TRACE_VIEW_COL_TS:
+			return KsUtils::Ts2String(_data[row]->ts, 6);
+
+		case TRACE_VIEW_COL_COMM:
+			return kshark_get_task_easy(_data[row]);
+
+		case TRACE_VIEW_COL_PID:
+			return kshark_get_pid_easy(_data[row]);
+
+		case TRACE_VIEW_COL_LAT:
+			return kshark_get_latency_easy(_data[row]);
+
+		case TRACE_VIEW_COL_EVENT:
+			return kshark_get_event_name_easy(_data[row]);
+
+		case TRACE_VIEW_COL_INFO :
+			return kshark_get_info_easy(_data[row]);
+
+		default:
+			return {};
+	}
+}
+
+/**
+ * Get the header of a column. This is an implementation of the pure virtu=
al
+ * method of the abstract model class.
+ */
+QVariant KsViewModel::headerData(int column,
+				 Qt::Orientation orientation,
+				 int role) const
+{
+	if (orientation !=3D Qt::Horizontal || role !=3D Qt::DisplayRole)
+		return {};
+
+	if (column < _header.count())
+		return _header.at(column);
+
+	return {};
+}
+
+/** Provide the model with data. */
+void KsViewModel::fill(KsDataStore *data)
+{
+	beginInsertRows(QModelIndex(), 0, data->size() - 1);
+
+	_data =3D data->rows();
+	_nRows =3D data->size();
+
+	endInsertRows();
+}
+
+/** @brief Select a row in the table.
+ *
+ * @param state: Identifier of the marker used to select the row.
+ * @param row: Row index.
+ */
+void KsViewModel::selectRow(DualMarkerState state, int row)
+{
+	if (state =3D=3D DualMarkerState::A) {
+		_markA =3D row;
+		_markB =3D -1;
+	} else {
+		_markB =3D row;
+		_markA =3D -1;
+	}
+}
+
+/** Reset the model. */
+void KsViewModel::reset()
+{
+	beginResetModel();
+
+	_data =3D nullptr;
+	_nRows =3D 0;
+
+	endResetModel();
+}
+
+/** Update the model. Use this function if the data has changed. */
+void KsViewModel::update(KsDataStore *data)
+{
+	/*
+	 * Do not try to skip the reset(). The row count has to be set to
+	 * zero before you full.
+	 */
+	reset();
+	fill(data);
+}
+
+/** @brief Search the content of the table for a data satisfying an abstra=
ct
+ *	   condition.
+ *
+ * @param column: The number of the column to search in.
+ * @param searchText: The text to search for.
+ * @param cond: Matching condition function.
+ * @param matchList: Output location for a list containing the row indexes=
 of
+ *		     the cells satisfying the matching condition.
+ *
+ * @returns The number of cells satisfying the matching condition.
+ */
+size_t KsViewModel::search(int column,
+			   const QString &searchText,
+			   condition_func cond,
+			   QList<size_t> *matchList)
+{
+	int nRows =3D rowCount({});
+	QVariant item;
+
+	for (int r =3D 0; r < nRows; ++r) {
+		item =3D getValue(r, column);
+		if (cond(searchText, item.toString())) {
+			matchList->append(r);
+		}
+	}
+
+	return matchList->count();
+}
diff --git a/kernel-shark-qt/src/KsModels.hpp b/kernel-shark-qt/src/KsModel=
s.hpp
new file mode 100644
index 0000000..8935fd4
--- /dev/null
+++ b/kernel-shark-qt/src/KsModels.hpp
@@ -0,0 +1,223 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+
+/*
+ * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
+ */
+
+/**
+ *  @file    KsModels.hpp
+ *  @brief   Models for data representation.
+ */
+
+#ifndef _KS_MODELS_H
+#define _KS_MODELS_H
+
+// C++11
+#include <mutex>
+#include <condition_variable>
+
+// Qt
+#include <QAbstractTableModel>
+#include <QSortFilterProxyModel>
+#include <QProgressBar>
+#include <QLabel>
+#include <QColor>
+
+// KernelShark
+#include "libkshark.h"
+#include "libkshark-model.h"
+
+/** Matching condition function type. To be user for searching. */
+typedef bool (*condition_func)(QString, QString);
+
+enum class DualMarkerState;
+
+class KsDataStore;
+
+/**
+ * Class KsViewModel provides models for trace data representation in a
+ * table view.
+ */
+class KsViewModel : public QAbstractTableModel
+{
+public:
+	explicit KsViewModel(QObject *parent =3D nullptr);
+
+	/** Set the colors of the two markers. */
+	void setColors(const QColor &colA, const QColor &colB) {
+		_colorMarkA =3D colA;
+		_colorMarkB =3D colB;
+	};
+
+	/**
+	 * Get the number of rows. This is an implementation of the pure
+	 * virtual method of the abstract model class.
+	 */
+	int rowCount(const QModelIndex &) const override {return _nRows;}
+
+	/**
+	 * Get the number of columns. This is an implementation of the pure
+	 * virtual method of the abstract model class.
+	 */
+	int columnCount(const QModelIndex &) const override
+	{
+		return _header.count();
+	}
+
+	QVariant headerData(int section,
+			    Qt::Orientation orientation,
+			    int role) const override;
+
+	QVariant data(const QModelIndex &index, int role) const override;
+
+	void fill(KsDataStore *data);
+
+	void selectRow(DualMarkerState state, int row);
+
+	void reset();
+
+	void update(KsDataStore *data);
+
+	/** Get the list of column's headers. */
+	QStringList header() const {return _header;}
+
+	QVariant getValue(int column, int row) const;
+
+	size_t search(int column,
+		      const QString &searchText,
+		      condition_func cond,
+		      QList<size_t> *matchList);
+
+	/** Table columns Identifiers. */
+	enum {
+		/** Identifier of the Index column. */
+		TRACE_VIEW_COL_INDEX,
+
+		/** Identifier of the CPU column. */
+		TRACE_VIEW_COL_CPU,
+
+		/** Identifier of the Timestamp column. */
+		TRACE_VIEW_COL_TS,
+
+		/** Identifier of the Task name (command) column. */
+		TRACE_VIEW_COL_COMM,
+
+		/** Identifier of the Process Id column. */
+		TRACE_VIEW_COL_PID,
+
+		/** Identifier of the Latency Id column. */
+		TRACE_VIEW_COL_LAT,
+
+		/** Identifier of the Event name Id column. */
+		TRACE_VIEW_COL_EVENT,
+
+		/** Identifier of the Event name Id column. */
+		TRACE_VIEW_COL_INFO,
+
+		/** Number of column. */
+		TRACE_VIEW_N_COLUMNS,
+	};
+
+private:
+	/** Trace data array. */
+	kshark_entry		**_data;
+
+	/** The size of the data array. */
+	size_t			_nRows;
+
+	/** The headers of the individual columns. */
+	QStringList		_header;
+
+	/** The index of marker A inside the data array. */
+	int	_markA;
+
+	/** The index of marker A inside the data array. */
+	int	_markB;
+
+	/** The color of the row selected by marker A. */
+	QColor	_colorMarkA;
+
+	/** The color of the row selected by marker B. */
+	QColor	_colorMarkB;
+};
+
+/**
+ * Class KsFilterProxyModel provides support for filtering trace data in
+ * table view.
+ */
+class KsFilterProxyModel : public QSortFilterProxyModel
+{
+	Q_OBJECT
+public:
+	explicit KsFilterProxyModel(QObject *parent =3D nullptr);
+
+	bool filterAcceptsRow(int sourceRow,
+			      const QModelIndex &sourceParent) const override;
+
+	void fill(KsDataStore *data);
+
+	void setSource(KsViewModel *s);
+
+	size_t search(int column,
+		      const QString &searchText,
+		      condition_func cond,
+		      QList<int> *matchList,
+		      QProgressBar *pb =3D nullptr,
+		      QLabel *l =3D nullptr);
+
+	QList<int> searchMap(int column,
+			     const QString  &searchText,
+			     condition_func  cond,
+			     int first,
+			     int last,
+			     bool notify);
+
+	/** Get the progress of the search. */
+	int searchProgress() const {return _searchProgress;}
+
+	/** Reset the progress value of the search. */
+	void searchReset() {_searchProgress =3D 0;}
+
+	/** Stop the serch for all threads. */
+	void searchStop() {_searchStop =3D true;}
+
+	/**
+	 * Use the "row" index in the Proxy model to retrieve the "row" index
+	 * in the source model.
+	 */
+	int mapRowFromSource(int r) const
+	{
+		/*This works because the row number is shown in column "0". */
+		return this->data(this->index(r, 0)).toInt();
+	}
+
+	/**
+	 * A condition variable used to notify the main thread to update the
+	 * search progressbar.
+	 */
+	std::condition_variable	_pbCond;
+
+	/** A mutex used by the condition variable. */
+	std::mutex		_mutex;
+
+private:
+	int			_searchProgress;
+
+	bool			_searchStop;
+
+	/** Trace data array. */
+	kshark_entry		**_data;
+
+	KsViewModel	 	*_source;
+
+	void _search(int column,
+		     const QString &searchText,
+		     condition_func cond,
+		     QList<int> *matchList,
+		     int first, int last,
+		     QProgressBar *pb,
+		     QLabel *l,
+		     bool notify);
+};
+
+#endif // _KS_MODELS_H
--=20
2.17.1

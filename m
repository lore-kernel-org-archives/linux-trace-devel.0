Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2092BC433E0
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Feb 2021 17:25:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC22D64EA9
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Feb 2021 17:25:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbhBARZj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Feb 2021 12:25:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbhBARZh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Feb 2021 12:25:37 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ACFEC061788
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 Feb 2021 09:24:20 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id d2so19816636edz.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Feb 2021 09:24:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YHv9DqnPb/dDXcIDEU5MHloGNIV4C62FNB+9Lmijnwc=;
        b=lWLOAA6o7NSTSM75mvNu2Z2Uzn6CsE30g6v1FbOUHxZCHQ0rR6uM8SWKVto8nY49pI
         XDHQaTz8233Gs7adKVrnzYK5LmmQh72UgfACB2Hpf4oHo+fPAl6szdVsRjisxOOuKfqU
         9JueD3H5PKkgV8iEdm0Hn0nmlBwtHliOKCSKZJfgeHzEPXuCw3CfQJ3mGuEv9Em/F8Ct
         9vTxq18Avo+rND1QtcuHc2DCtvhb04hZ0qU3MRlPsggTOW+eAZ84kU6lfMK6bQ4aMH0l
         BAYXk727n6thCW7Ygbj/auRB0RI/CABPygsX8HDM6PoeGKw/aXQClgMErFhMynjxGsw5
         gbwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YHv9DqnPb/dDXcIDEU5MHloGNIV4C62FNB+9Lmijnwc=;
        b=S5lw25jrdbJ5CnEEl5IHgO5KbeK5lu0UMJ/rQ+eiLmNLAnkTWhPytXUMjUjqRT6qDO
         H0XOJPlmHpFOQAg4/2bJv69pV4Opg06CYs3A3OOJE2/eJJofNbPiaFfN4GPQkma8F7bX
         c/xipnvEoQKD4xmp8Jepq6JRWQIs48EO/szxszAB4/WcGgRj0QS27tHR2SKBF1cD42yj
         eat2Jjr5/glgrG/KqcDbX1GYId6MIseB5bfnUrci1+KNlhzEbd5k09fdiGunU/cZnE39
         yhzCc6Z6aj9IId+TEWJK1kUI8FFdxe+oMGJKcD8VAiefxKnFFuUR7KS8717JNdYVn2+4
         gwJg==
X-Gm-Message-State: AOAM530vUzO4BJYPqyypMY8ffNwhBrQNn8jWpmu3Rv/iHeFOO/lTtOmG
        /JtMC9Tw54oUPYqKnDu7giLAC8mnMX4=
X-Google-Smtp-Source: ABdhPJzItx51I4CZU2wn6cIVja14INdVI24NS+Ck4MK5X0sQ4GRVDzbzcsmt3OMPDXUCKu5QppiaQQ==
X-Received: by 2002:a05:6402:6:: with SMTP id d6mr4299838edu.218.1612200258681;
        Mon, 01 Feb 2021 09:24:18 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.218])
        by smtp.gmail.com with ESMTPSA id bm9sm8312446ejb.14.2021.02.01.09.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 09:24:18 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 07/24] kernel-shark: Update KsModels and KsSearchFSM
Date:   Mon,  1 Feb 2021 19:23:41 +0200
Message-Id: <20210201172358.175407-8-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210201172358.175407-1-y.karadz@gmail.com>
References: <20210201172358.175407-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The compilation of KsModels.cpp and KsSearchFSM.cpp is re-enabled
and all functionalities are made compatible with the new version
of the C API of libkshark (KernelShark 2.0). The two source files
are updated in a single patch because of their interdependence.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/CMakeLists.txt  |  12 ++---
 src/KsModels.cpp    | 112 +++++++++++++++++++++++++++++++++++++-------
 src/KsModels.hpp    |  28 +++++++----
 src/KsSearchFSM.cpp |  12 ++++-
 4 files changed, 132 insertions(+), 32 deletions(-)

diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 5c9fe17..21d5b85 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -66,10 +66,10 @@ endif (OPENGL_FOUND)
 if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
 
     message(STATUS "libkshark-gui")
-    set (ks-guiLib_hdr  KsUtils.hpp)
-#                         KsModels.hpp
+    set (ks-guiLib_hdr  KsUtils.hpp
+                        KsModels.hpp
 #                         KsGLWidget.hpp
-#                         KsSearchFSM.hpp
+                        KsSearchFSM.hpp)
 #                         KsDualMarker.hpp
 #                         KsWidgetsLib.hpp
 #                         KsTraceGraph.hpp
@@ -81,11 +81,11 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
 
     QT5_WRAP_CPP(ks-guiLib_hdr_moc ${ks-guiLib_hdr})
 
-    add_library(kshark-gui  SHARED  ${ks-guiLib_hdr_moc}    KsUtils.cpp)
-#                                                             KsModels.cpp
+    add_library(kshark-gui  SHARED  ${ks-guiLib_hdr_moc}    KsUtils.cpp
+                                                            KsModels.cpp
 #                                                             KsSession.cpp
 #                                                             KsGLWidget.cpp
-#                                                             KsSearchFSM.cpp
+                                                            KsSearchFSM.cpp)
 #                                                             KsDualMarker.cpp
 #                                                             KsWidgetsLib.cpp
 #                                                             KsTraceGraph.cpp
diff --git a/src/KsModels.cpp b/src/KsModels.cpp
index 51a7b79..df8373e 100644
--- a/src/KsModels.cpp
+++ b/src/KsModels.cpp
@@ -227,16 +227,54 @@ QList<int> KsFilterProxyModel::searchThread(int column,
 	return matchList;
 }
 
+int KsFilterProxyModel::mapRowFromSource(int r) const
+{
+	/*
+	 * This works because the row number is shown in column
+	 * TRACE_VIEW_COL_INDEX (or TRACE_VIEW_COL_INDEX - 1 in the case when
+	 * the Stream Id column is hidden).
+	 */
+	int column = KsViewModel::TRACE_VIEW_COL_INDEX;
+
+	if(_source->singleStream())
+		column--;
+
+	return this->data(this->index(r, column)).toInt();
+}
+
 /** Create default (empty) KsViewModel object. */
 KsViewModel::KsViewModel(QObject *parent)
 : QAbstractTableModel(parent),
   _data(nullptr),
   _nRows(0),
-  _header({"#", "CPU", "Time Stamp", "Task", "PID",
-	   "Latency", "Event", "Info"}),
   _markA(KS_NO_ROW_SELECTED),
-  _markB(KS_NO_ROW_SELECTED)
-{}
+  _markB(KS_NO_ROW_SELECTED),
+  _singleStream(true)
+{
+	_updateHeader();
+}
+
+/** Update the list of table headers. */
+void KsViewModel::_updateHeader()
+{
+	beginRemoveColumns(QModelIndex(), 0, _header.count());
+	endRemoveColumns();
+
+	_header.clear();
+
+	if (KsUtils::getNStreams() > 1) {
+		_header << " >> ";
+		_singleStream = false;
+	} else {
+		_singleStream = true;
+	}
+
+	_header << "#" << "CPU" << "Time Stamp" << "Task" << "PID"
+		<< "Latency" << "Event" << "Info";
+
+	beginInsertColumns(QModelIndex(), 0, _header.count() - 1);
+	endInsertColumns();
+}
 
 /**
  * Get the data stored under the given role for the item referred to by
@@ -246,10 +284,10 @@ KsViewModel::KsViewModel(QObject *parent)
 QVariant KsViewModel::data(const QModelIndex &index, int role) const
 {
 	if (role == Qt::ForegroundRole) {
-		if (index.row() == _markA)
+		if (index.row() == _markA && index.column() != 0)
 			return QVariant::fromValue(QColor(Qt::white));
 
-		if (index.row() == _markB)
+		if (index.row() == _markB && index.column() != 0)
 			return QVariant::fromValue(QColor(Qt::white));
 	}
 
@@ -259,6 +297,15 @@ QVariant KsViewModel::data(const QModelIndex &index, int role) const
 
 		if (index.row() == _markB)
 			return QVariant::fromValue(QColor(_colorMarkB));
+
+		if (index.column() == TRACE_VIEW_COL_STREAM &&
+		    !_singleStream) {
+			int sd = _data[index.row()]->stream_id;
+			QColor col;
+			col << KsPlot::getColor(&_streamColors, sd);
+
+			return QVariant::fromValue(col);
+		}
 	}
 
 	if (role == Qt::DisplayRole)
@@ -270,9 +317,26 @@ QVariant KsViewModel::data(const QModelIndex &index, int role) const
 /** Get the string data stored in a given cell of the table. */
 QString KsViewModel::getValueStr(int column, int row) const
 {
+	char *buffer;
 	int pid;
 
+	/*
+	 * If only one Data stream (file) is loaded, the first column
+	 * (TRACE_VIEW_COL_STREAM) is not shown.
+	 */
+	if(_singleStream)
+		column++;
+
+	auto lanMakeString = [&buffer] () {
+		QString str(buffer);
+		free(buffer);
+		return str;
+	};
+
 	switch (column) {
+		case TRACE_VIEW_COL_STREAM :
+			return QString("%1").arg(_data[row]->stream_id);
+
 		case TRACE_VIEW_COL_INDEX :
 			return QString("%1").arg(row);
 
@@ -283,20 +347,24 @@ QString KsViewModel::getValueStr(int column, int row) const
 			return KsUtils::Ts2String(_data[row]->ts, 6);
 
 		case TRACE_VIEW_COL_COMM:
-			return kshark_get_task_easy(_data[row]);
+			buffer = kshark_get_task(_data[row]);
+			return lanMakeString();
 
 		case TRACE_VIEW_COL_PID:
-			pid = kshark_get_pid_easy(_data[row]);
+			pid = kshark_get_pid(_data[row]);
 			return QString("%1").arg(pid);
 
-		case TRACE_VIEW_COL_LAT:
-			return kshark_get_latency_easy(_data[row]);
+		case TRACE_VIEW_COL_AUX:
+			buffer = kshark_get_aux_info(_data[row]);
+			return lanMakeString();
 
 		case TRACE_VIEW_COL_EVENT:
-			return kshark_get_event_name_easy(_data[row]);
+			buffer = kshark_get_event_name(_data[row]);
+			return lanMakeString();
 
 		case TRACE_VIEW_COL_INFO :
-			return kshark_get_info_easy(_data[row]);
+			buffer = kshark_get_info(_data[row]);
+			return lanMakeString();
 
 		default:
 			return {};
@@ -333,8 +401,10 @@ void KsViewModel::fill(KsDataStore *data)
 
 	_data = data->rows();
 	_nRows = data->size();
+	_streamColors = KsPlot::streamColorTable();
 
 	endInsertRows();
+	_updateHeader();
 }
 
 /** @brief Select a row in the table.
@@ -375,6 +445,14 @@ void KsViewModel::update(KsDataStore *data)
 	fill(data);
 }
 
+/** Update the color scheme used by the model. */
+void KsViewModel::loadColors()
+{
+	beginResetModel();
+	_streamColors = KsPlot::streamColorTable();
+	endResetModel();
+}
+
 /** @brief Search the content of the table for a data satisfying an abstract
  *	   condition.
  *
@@ -420,12 +498,12 @@ KsGraphModel::~KsGraphModel()
 /**
  * @brief Provide the Visualization model with data. Calculate the current
  *	  state of the model.
- *
- * @param entries: Input location for the trace data.
- * @param n: Number of bins.
  */
-void KsGraphModel::fill(kshark_entry **entries, size_t n)
+void KsGraphModel::fill(KsDataStore *data)
 {
+	kshark_entry **entries = data->rows();
+	size_t n = data->size();
+
 	if (n == 0)
 		return;
 
@@ -435,7 +513,7 @@ void KsGraphModel::fill(kshark_entry **entries, size_t n)
 		ksmodel_set_bining(&_histo,
 				   KS_DEFAULT_NBUNS,
 				   entries[0]->ts,
-				   entries[n-1]->ts);
+				   entries[n - 1]->ts);
 
 	ksmodel_fill(&_histo, entries, n);
 
diff --git a/src/KsModels.hpp b/src/KsModels.hpp
index d360ad6..3a6d3f1 100644
--- a/src/KsModels.hpp
+++ b/src/KsModels.hpp
@@ -26,6 +26,7 @@
 // KernelShark
 #include "libkshark.h"
 #include "libkshark-model.h"
+#include "KsPlotTools.hpp"
 #include "KsSearchFSM.hpp"
 
 /** A negative row index, to be used for deselecting the Passive Marker. */
@@ -45,7 +46,7 @@ public:
 	explicit KsViewModel(QObject *parent = nullptr);
 
 	/** Set the colors of the two markers. */
-	void setColors(const QColor &colA, const QColor &colB) {
+	void setMarkerColors(const QColor &colA, const QColor &colB) {
 		_colorMarkA = colA;
 		_colorMarkB = colB;
 	};
@@ -91,8 +92,16 @@ public:
 		      search_condition_func cond,
 		      QList<size_t> *matchList);
 
+	void loadColors();
+
+	/** Returns True is only one Data stream is open. */
+	bool singleStream() const {return _singleStream;}
+
 	/** Table columns Identifiers. */
 	enum {
+		/** Identifier of the Data stream. */
+		TRACE_VIEW_COL_STREAM,
+
 		/** Identifier of the Index column. */
 		TRACE_VIEW_COL_INDEX,
 
@@ -109,7 +118,7 @@ public:
 		TRACE_VIEW_COL_PID,
 
 		/** Identifier of the Latency Id column. */
-		TRACE_VIEW_COL_LAT,
+		TRACE_VIEW_COL_AUX,
 
 		/** Identifier of the Event name Id column. */
 		TRACE_VIEW_COL_EVENT,
@@ -122,6 +131,8 @@ public:
 	};
 
 private:
+	void _updateHeader();
+
 	/** Trace data array. */
 	kshark_entry		**_data;
 
@@ -142,6 +153,11 @@ private:
 
 	/** The color of the row selected by marker B. */
 	QColor	_colorMarkB;
+
+	/** True if only one Data stream is open. */
+	bool	_singleStream;
+
+	KsPlot::ColorTable	_streamColors;
 };
 
 /**
@@ -192,11 +208,7 @@ public:
 	 * Use the "row" index in the Proxy model to retrieve the "row" index
 	 * in the source model.
 	 */
-	int mapRowFromSource(int r) const
-	{
-		/*This works because the row number is shown in column "0". */
-		return this->data(this->index(r, 0)).toInt();
-	}
+	int mapRowFromSource(int r) const;
 
 	/** Get the source model. */
 	KsViewModel *source() {return _source;}
@@ -272,7 +284,7 @@ public:
 	/** Get the kshark_trace_histo object. */
 	kshark_trace_histo *histo() {return &_histo;}
 
-	void fill(kshark_entry **entries, size_t n);
+	void fill(KsDataStore *data);
 
 	void shiftForward(size_t n);
 
diff --git a/src/KsSearchFSM.cpp b/src/KsSearchFSM.cpp
index 6a93ca7..a5f3682 100644
--- a/src/KsSearchFSM.cpp
+++ b/src/KsSearchFSM.cpp
@@ -136,6 +136,16 @@ void KsSearchFSM ::_lockSearchPanel(bool lock)
 /** Act according to the provided input. */
 void NotDone::handleInput(KsSearchFSM* sm, sm_input_t input)
 {
+	int column = sm->column();
+	if (sm->_columnComboBox.findText(">>", Qt::MatchContains) < 0) {
+		/*
+		 * If only one Data stream (file) is loaded, the ">>" column
+		 * (TRACE_VIEW_COL_STREAM) is not shown. The column index has
+		 * to be corrected.
+		 */
+		++column;
+	}
+
 	switch(input) {
 	case sm_input_t::Start:
 		sm->_lastRowSearched = -1;
@@ -166,7 +176,7 @@ void Paused::handleInput(KsSearchFSM* sm, sm_input_t input)
 		sm->searchRestartVisible(false);
 
 		if (sm->column() != KsViewModel::TRACE_VIEW_COL_INFO &&
-		    sm->column() != KsViewModel::TRACE_VIEW_COL_LAT)
+		    sm->column() != KsViewModel::TRACE_VIEW_COL_AUX)
 			sm->_searchCountLabel.setText("");
 
 		sm->changeState(std::shared_ptr<InProgress>(new InProgress));
-- 
2.25.1


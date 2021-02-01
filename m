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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3A67C433DB
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Feb 2021 17:26:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9409264E8F
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Feb 2021 17:26:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbhBAR00 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Feb 2021 12:26:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbhBAR0T (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Feb 2021 12:26:19 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E755C061352
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 Feb 2021 09:24:31 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id df22so3836189edb.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Feb 2021 09:24:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+gB2ykFChR518SYjaWPHdcz2CeIKMUt4KsXVzBrUMjA=;
        b=T34IqYXHk41y7YakA1jn2BUewAyyJm23TsB/3b4Wtxlr9MvCL82jy5rDWn9hyL0Nup
         xLBvQYDpbKhKXgawBX1ldUzgwaxIavn4J1t8dZ4Unq4VvNowey64XUVLVCBPVIWVrYKv
         olTO347X74o/wMNaFcJaPdSJ0Scpmtxr5EWvn9xlLEydkSr+Ux3lJod8igxUI6SigI50
         Ky309p6HNT1B5WwnNapX71KbMdYR3djZajddFNFf6umvp6FQHKntzpMNPbCyDR6ahNki
         mDZkUh2v2pvuvd0TQ71hkEVFM/vVX5CcvsYlzvEO/kWCbSrmr8mMLksd5VRCfv9w2q4G
         Cetg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+gB2ykFChR518SYjaWPHdcz2CeIKMUt4KsXVzBrUMjA=;
        b=hGpyrXYG5R57yevOjPcksU+hxr/p5dEgtLegiDYptQaKvgd04HYK/73wH0KcUQvD/f
         8nUIJmkCRITXrhi9vKhX24YRmcUa2ERTTtnn/eNlTllq7vUxvQCPoqEuXcVWeAVwhBMp
         gSdbcMTCtGuTiAF/Lk9Rau0E9tVTait8lFwkzLinYcjTZG2P0O1M8GCiGbHjo1gld0Ls
         VvZ3ZoOosTlz4Sg+4ENhiUXo/ournrE21d0WSmJuXLQMpObQmcx2jIe7FwLLPDL8dpAY
         6cXaIbOEA6YirfVg65JzGsevaQiXW3n1QIC1Fp5kXbnbEnZjErocxcscLCycQhx0S5Y/
         jISw==
X-Gm-Message-State: AOAM533oQ/h1RxD2IcLilu7643LOwHhxhymdMH4whFa/P3cr6G3Y93nm
        r632qAhRRQ495SWusWHgddA=
X-Google-Smtp-Source: ABdhPJz6w1MNdpOP7W2aYpYcJOf/SFd6WNlHM7z62YOW/+aXnGNL0yZcQeB7UD9PQNn5qXCknmUuww==
X-Received: by 2002:a50:ec06:: with SMTP id g6mr11006588edr.12.1612200270192;
        Mon, 01 Feb 2021 09:24:30 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.218])
        by smtp.gmail.com with ESMTPSA id bm9sm8312446ejb.14.2021.02.01.09.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 09:24:29 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 18/24] kernel-shark: Update KsAdvFilteringDialog
Date:   Mon,  1 Feb 2021 19:23:52 +0200
Message-Id: <20210201172358.175407-19-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210201172358.175407-1-y.karadz@gmail.com>
References: <20210201172358.175407-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The compilation ofKsAdvFilteringDialog .cpp is re-enabled and all
functionalities are made compatible with the new version of the
C API of libkshark (KernelShark 2.0).

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/CMakeLists.txt           |   8 +-
 src/KsAdvFilteringDialog.cpp | 200 ++++++++++++++++++++++-------------
 src/KsAdvFilteringDialog.hpp |  16 ++-
 3 files changed, 144 insertions(+), 80 deletions(-)

diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 209c57c..c1d98d8 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -76,8 +76,8 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
                         KsTraceViewer.hpp
 #                         KsMainWindow.hpp
 #                         KsCaptureDialog.hpp
-                        KsQuickContextMenu.hpp)
-#                         KsAdvFilteringDialog.hpp)
+                        KsQuickContextMenu.hpp
+                        KsAdvFilteringDialog.hpp)
 
     QT5_WRAP_CPP(ks-guiLib_hdr_moc ${ks-guiLib_hdr})
 
@@ -92,8 +92,8 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
                                                             KsTraceViewer.cpp
 #                                                             KsMainWindow.cpp
 #                                                             KsCaptureDialog.cpp
-                                                            KsQuickContextMenu.cpp)
-#                                                             KsAdvFilteringDialog.cpp)
+                                                            KsQuickContextMenu.cpp
+                                                            KsAdvFilteringDialog.cpp)
 
     target_link_libraries(kshark-gui kshark-plot
                                      Qt5::Widgets
diff --git a/src/KsAdvFilteringDialog.cpp b/src/KsAdvFilteringDialog.cpp
index 8dc53bb..2fdb624 100644
--- a/src/KsAdvFilteringDialog.cpp
+++ b/src/KsAdvFilteringDialog.cpp
@@ -9,10 +9,16 @@
  *  @brief   GUI Dialog for Advanced filtering settings.
  */
 
+// trace-cmd
+#include "trace-cmd/trace-cmd.h"
+
 // KernelShark
-#include "KsAdvFilteringDialog.hpp"
 #include "libkshark.h"
+#include "libkshark-tepdata.h"
 #include "KsUtils.hpp"
+#include "KsAdvFilteringDialog.hpp"
+
+using namespace KsWidgetsLib;
 
 /** Create dialog for Advanced Filtering. */
 KsAdvFilteringDialog::KsAdvFilteringDialog(QWidget *parent)
@@ -71,6 +77,9 @@ KsAdvFilteringDialog::KsAdvFilteringDialog(QWidget *parent)
 
 	lamAddLine();
 
+	_topLayout.addWidget(&_streamComboBox);
+	_getFtraceStreams(kshark_ctx);
+
 	_getFilters(kshark_ctx);
 
 	if (_filters.count()) {
@@ -149,23 +158,38 @@ KsAdvFilteringDialog::KsAdvFilteringDialog(QWidget *parent)
 		this,			&QWidget::close);
 }
 
-void KsAdvFilteringDialog::_setSystemCombo(struct kshark_context *kshark_ctx)
+kshark_data_stream *
+KsAdvFilteringDialog::_getCurrentStream(kshark_context *kshark_ctx)
 {
+	int sd = _streamComboBox.currentData().toInt();
+
+	return kshark_get_data_stream(kshark_ctx, sd);
+}
+
+void KsAdvFilteringDialog::_setSystemCombo(kshark_context *kshark_ctx)
+{
+	kshark_data_stream *stream;
+	QVector<int> eventIds;
 	QStringList sysList;
-	tep_event **events;
-	int i(0), nEvts(0);
+	int i(0);
 
-	if (kshark_ctx->pevent) {
-		nEvts = tep_get_events_count(kshark_ctx->pevent);
-		events = tep_list_events(kshark_ctx->pevent,
-					 TEP_EVENT_SORT_SYSTEM);
-	}
+	stream = _getCurrentStream(kshark_ctx);
+	if (!stream || !kshark_is_tep(stream))
+		return;
+
+	eventIds = KsUtils::getEventIdList(stream->stream_id);
+
+	auto lamGetSysName = [&stream] (int eventId) {
+		QStringList name = KsUtils::getTepEvtName(stream->stream_id,
+							  eventId);
+		return name[0];
+	};
 
-	while (i < nEvts) {
-		QString sysName(events[i]->system);
+	while (i < stream->n_events) {
+		QString sysName = lamGetSysName(eventIds[i]);
 		sysList << sysName;
-		while (sysName == events[i]->system) {
-			if (++i == nEvts)
+		while (sysName == lamGetSysName(eventIds[i])) {
+			if (++i == stream->n_events)
 				break;
 		}
 	}
@@ -202,24 +226,48 @@ QStringList KsAdvFilteringDialog::_operators()
 	return OpsList;
 }
 
-void KsAdvFilteringDialog::_getFilters(struct kshark_context *kshark_ctx)
+void KsAdvFilteringDialog::_getFtraceStreams(kshark_context *kshark_ctx)
 {
-	tep_event **events;
-	char *str;
+	kshark_data_stream *stream;
+	QVector<int> streamIds;
+
+	_streamComboBox.clear();
+	streamIds = KsUtils::getStreamIdList(kshark_ctx);
+	for (auto const &sd: streamIds) {
+		stream = kshark_ctx->stream[sd];
+		if (kshark_is_tep(stream))
+			_streamComboBox.addItem(KsUtils::streamDescription(stream), sd);
+	}
 
-	events = tep_list_events(kshark_ctx->pevent, TEP_EVENT_SORT_SYSTEM);
+	if (!_streamComboBox.count())
+		_streamComboBox.addItem("No FTRACE data loaded", -1);
+}
 
-	for (int i = 0; events[i]; i++) {
-		str = tep_filter_make_string(kshark_ctx->advanced_event_filter,
-					     events[i]->id);
-		if (!str)
+void KsAdvFilteringDialog::_getFilters(kshark_context *kshark_ctx)
+{
+	kshark_data_stream *stream;
+	QVector<int> eventIds;
+	QStringList eventName;
+	char *filterStr;
+
+	stream = _getCurrentStream(kshark_ctx);
+	if (!stream || !kshark_is_tep(stream))
+		return;
+
+	eventIds = KsUtils::getEventIdList(stream->stream_id);
+	for (int i = 0; i < stream->n_events; ++i) {
+		eventName = KsUtils::getTepEvtName(stream->stream_id, eventIds[i]);
+		filterStr = kshark_tep_filter_make_string(stream, eventIds[i]);
+		if (!filterStr)
 			continue;
 
-		_filters.insert(events[i]->id,
-				QString("%1/%2:%3").arg(events[i]->system,
-							  events[i]->name, str));
+		_filters.insert(eventIds[i],
+				QString("%1:%2/%3:%4").arg(QString::number(stream->stream_id),
+							   eventName[0],
+							   eventName[1],
+							   filterStr));
 
-		free(str);
+		free(filterStr);
 	}
 }
 
@@ -232,7 +280,7 @@ void KsAdvFilteringDialog::_makeFilterTable(struct kshark_context *kshark_ctx)
 
 	_table = new KsCheckBoxTable(this);
 	_table->setSelectionMode(QAbstractItemView::SingleSelection);
-	headers << "Delete" << "Event" << " Id" << "Filter";
+	headers << "Delete" << "Stream" << "Event" << " Id" << "Filter";
 	_table->init(headers, _filters.count());
 
 	for(auto f : _filters.keys()) {
@@ -241,11 +289,14 @@ void KsAdvFilteringDialog::_makeFilterTable(struct kshark_context *kshark_ctx)
 		i1 = new QTableWidgetItem(thisFilter[0]);
 		_table->setItem(count, 1, i1);
 
+		i1 = new QTableWidgetItem(thisFilter[1]);
+		_table->setItem(count, 2, i1);
+
 		i2 = new QTableWidgetItem(tr("%1").arg(f));
-		_table->setItem(count, 2, i2);
+		_table->setItem(count, 3, i2);
 
-		i3 = new QTableWidgetItem(thisFilter[1]);
-		_table->setItem(count, 3, i3);
+		i3 = new QTableWidgetItem(thisFilter[2]);
+		_table->setItem(count, 4, i3);
 
 		++count;
 	}
@@ -275,20 +326,25 @@ void KsAdvFilteringDialog::_help()
 void KsAdvFilteringDialog::_systemChanged(const QString &sysName)
 {
 	kshark_context *kshark_ctx(NULL);
-	QStringList evtsList;
-	tep_event **events;
-	int i, nEvts;
+	kshark_data_stream *stream;
+	QStringList evtsList, name;
+	QVector<int> eventIds;
+	int i;
 
-	_eventComboBox.clear();
-	if (!kshark_instance(&kshark_ctx) || !kshark_ctx->pevent)
+	if (!kshark_instance(&kshark_ctx))
 		return;
 
-	nEvts = tep_get_events_count(kshark_ctx->pevent);
-	events = tep_list_events(kshark_ctx->pevent, TEP_EVENT_SORT_SYSTEM);
+	_eventComboBox.clear();
+
+	stream = _getCurrentStream(kshark_ctx);
+	if (!stream || !kshark_is_tep(stream))
+		return;
 
-	for (i = 0; i < nEvts; ++i) {
-		if (sysName == events[i]->system)
-			evtsList << events[i]->name;
+	eventIds = KsUtils::getEventIdList(stream->stream_id);
+	for (i = 0; i < stream->n_events; ++i) {
+		name = KsUtils::getTepEvtName(stream->stream_id, eventIds[i]);
+		if (sysName == name[0])
+			evtsList << name[1];
 	}
 
 	std::sort(evtsList.begin(), evtsList.end());
@@ -300,15 +356,20 @@ void KsAdvFilteringDialog::_systemChanged(const QString &sysName)
 }
 
 QStringList
-KsAdvFilteringDialog::_getEventFormatFields(struct tep_event *event)
+KsAdvFilteringDialog::_getEventFields(int eventId)
 {
-	tep_format_field *field, **fields = tep_event_fields(event);
+	kshark_context *kshark_ctx(NULL);
+	kshark_data_stream *stream;
 	QStringList fieldList;
 
-	for (field = *fields; field; field = field->next)
-		fieldList << field->name;
+	if (!kshark_instance(&kshark_ctx))
+		return {};
+
+	stream = _getCurrentStream(kshark_ctx);
+	if (!stream || !kshark_is_tep(stream))
+		return {};
 
-	free(fields);
+	fieldList = KsUtils::getEventFieldsList(stream->stream_id, eventId);
 
 	std::sort(fieldList.begin(), fieldList.end());
 	return fieldList;
@@ -317,22 +378,24 @@ KsAdvFilteringDialog::_getEventFormatFields(struct tep_event *event)
 void KsAdvFilteringDialog::_eventChanged(const QString &evtName)
 {
 	QString sysName = _systemComboBox.currentText();
+	QStringList fieldList, eventName;
 	kshark_context *kshark_ctx(NULL);
-	QStringList fieldList;
-	tep_event **events;
-	int nEvts;
+	kshark_data_stream *stream;
+	QVector<int> eventIds;
 
 	_fieldComboBox.clear();
-	if (!kshark_instance(&kshark_ctx) || !kshark_ctx->pevent)
+	if (!kshark_instance(&kshark_ctx))
 		return;
 
-	nEvts = tep_get_events_count(kshark_ctx->pevent);
-	events = tep_list_events(kshark_ctx->pevent, TEP_EVENT_SORT_SYSTEM);
+	stream = _getCurrentStream(kshark_ctx);
+	if (!stream || !kshark_is_tep(stream))
+		return;
 
-	for (int i = 0; i < nEvts; ++i) {
-		if (evtName == events[i]->name &&
-		    sysName == events[i]->system) {
-			fieldList = _getEventFormatFields(events[i]);
+	eventIds = KsUtils::getEventIdList(stream->stream_id);
+	for (int i = 0; i < stream->n_events; ++i) {
+		eventName = KsUtils::getTepEvtName(stream->stream_id, eventIds[i]);
+		if (sysName == eventName[0] && evtName == eventName[1]) {
+			fieldList = _getEventFields(eventIds[i]);
 			_fieldComboBox.addItems(fieldList);
 
 			return;
@@ -384,20 +447,28 @@ void KsAdvFilteringDialog::_applyPress()
 {
 	QMapIterator<int, QString> f(_filters);
 	kshark_context *kshark_ctx(NULL);
+	kshark_data_stream *stream;
 	const char *text;
-	tep_errno ret;
 	char *filter;
 	int i(0);
 
 	if (!kshark_instance(&kshark_ctx))
 		return;
 
+	stream = _getCurrentStream(kshark_ctx);
+	if (!stream || !kshark_is_tep(stream))
+		return;
+
 	while (f.hasNext()) {
 		f.next();
 		if (_table->_cb[i]->checkState() == Qt::Checked) {
-			tep_filter_remove_event(kshark_ctx->advanced_event_filter,
-						f.key());
+			kshark_data_stream *filter_stream;
+			int sd = f.value().split(":").at(0).toInt();
+
+			filter_stream = kshark_get_data_stream(kshark_ctx, sd);
+			kshark_tep_filter_remove_event(filter_stream, f.key());
 		}
+
 		++i;
 	}
 
@@ -419,20 +490,7 @@ void KsAdvFilteringDialog::_applyPress()
 	filter = (char*) malloc(strlen(text) + 1);
 	strcpy(filter, text);
 
-	ret = tep_filter_add_filter_str(kshark_ctx->advanced_event_filter,
-					   filter);
-
-	if (ret < 0) {
-		char error_str[200];
-
-		tep_strerror(kshark_ctx->pevent, ret, error_str,
-						       sizeof(error_str));
-
-		fprintf(stderr, "filter failed due to: %s\n", error_str);
-		free(filter);
-
-		return;
-	}
+	kshark_tep_add_filter_str(stream, filter);
 
 	free(filter);
 
diff --git a/src/KsAdvFilteringDialog.hpp b/src/KsAdvFilteringDialog.hpp
index 2a534d0..a1db90b 100644
--- a/src/KsAdvFilteringDialog.hpp
+++ b/src/KsAdvFilteringDialog.hpp
@@ -36,7 +36,7 @@ private:
 
 	QMap<int, QString>	_filters;
 
-	KsCheckBoxTable		*_table;
+	KsWidgetsLib::KsCheckBoxTable	*_table;
 
 	QVBoxLayout	_topLayout;
 
@@ -46,6 +46,8 @@ private:
 
 	QLabel		_descrLabel, _sysEvLabel, _opsLabel, _fieldLabel;
 
+	QComboBox	_streamComboBox;
+
 	QComboBox	_systemComboBox, _eventComboBox;
 
 	QComboBox	_opsComboBox, _fieldComboBox;
@@ -74,13 +76,17 @@ private:
 
 	QStringList _operators();
 
-	void _getFilters(struct kshark_context *kshark_ctx);
+	void _getFtraceStreams(kshark_context *kshark_ctx);
+
+	void _getFilters(kshark_context *kshark_ctx);
+
+	void _makeFilterTable(kshark_context *kshark_ctx);
 
-	void _makeFilterTable(struct kshark_context *kshark_ctx);
+	QStringList _getEventFields(int eventId);
 
-	QStringList _getEventFormatFields(struct tep_event *event);
+	void _setSystemCombo(kshark_context *kshark_ctx);
 
-	void _setSystemCombo(struct kshark_context *kshark_ctx);
+	kshark_data_stream *_getCurrentStream(kshark_context *kshark_ctx);
 
 private slots:
 	void _systemChanged(const QString&);
-- 
2.25.1


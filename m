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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23C40C433E6
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Feb 2021 17:26:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE41A64E8F
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Feb 2021 17:26:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbhBAR02 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Feb 2021 12:26:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbhBAR0S (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Feb 2021 12:26:18 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D229DC0617AB
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 Feb 2021 09:24:29 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id y18so2465143edw.13
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Feb 2021 09:24:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=77n0VjDKz9hol2LKctAt0d46cdW57/1g5Ym3x+3aVvY=;
        b=o+ZCz7xvwx8KxrwEUoERevONSA4eM6+pHrXOxtmwfYkO9CF2FgD7gAxMiztWEUZii9
         7YJhLTMoOtZ7H1OiecQz5LBAdl5lxfhA++amd2jdAMwCLxE0MGy2Wf5mmC3DSgbmbObg
         mWw2aRblwRZFRpZbJDyZeZBekIPiq0XRhXuf9XV5oHwh+Iv8bZaUPi87JJ8CWJ65zFDX
         jDQJlB1xBYa3Oej3VabwBTJ4RBSKUByZtuzzklsJNSV2Xa2t7Qdi7hjoLCymXZDKim0b
         CaIFqViP6xCjWsU4e5VSCECMuV/FeZCMrT3vCFrar/nEtOzIzdgIMxSQ0dRQ/hBD9wao
         TVCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=77n0VjDKz9hol2LKctAt0d46cdW57/1g5Ym3x+3aVvY=;
        b=LMh1x+vitFL5R7N2TnpRRaNib8vBnkCKqH7UhjW4QPYqIQUyKMBBXylKEGotNXatOp
         KfAB7lhUicP4C0Zq1M5iU4zmUQcCAHS+PgEprrDwyJvpFd91Ooduj4CJl186aF+g1Hwx
         9dfz5DzCVMUi9jgSkbYNnIYRjY9ypCCmO1CS6GraJh3UF4Pb5FdNu8c5gB5RXw3pVNLR
         K0P6+IwjtCZTtn/CYSSWWXt73pDwaKW/1J9Edy+QagYjZPsXwA+qlicqMgZPae3gxFME
         OBhra4l3Hynj9W0fyMmr8cIoYKf7MmgecLiDENodH/ebUXixeDISz8OQRNgcDVUW0W+Q
         SAwg==
X-Gm-Message-State: AOAM530SY1KglCipsp4ZBEtUIkxtHIz/tukQilNGfJTF6+jF2qAW1bxh
        FhSjtLysBvKBZHlUIC3JvEQ=
X-Google-Smtp-Source: ABdhPJzK323trghPNwFKOfr2SrXQUQYihcvtpSyJQzHsPkahflZ6edeFoNGATQuxktAfzo6udggrOg==
X-Received: by 2002:aa7:da55:: with SMTP id w21mr1800152eds.138.1612200268101;
        Mon, 01 Feb 2021 09:24:28 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.218])
        by smtp.gmail.com with ESMTPSA id bm9sm8312446ejb.14.2021.02.01.09.24.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 09:24:27 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 16/24] kernel-shark: Update KsTraceGraph and KsQuickContextMenu
Date:   Mon,  1 Feb 2021 19:23:50 +0200
Message-Id: <20210201172358.175407-17-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210201172358.175407-1-y.karadz@gmail.com>
References: <20210201172358.175407-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The compilation of KsTraceGraph.cpp and KsQuickContextMenu.cpp is
re-enabled and all functionalities are made compatible with the new
version of the C API of libkshark (KernelShark 2.0). The two source
files are updated in a single patch because of their interdependence.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/CMakeLists.txt         |  12 +-
 src/KsQuickContextMenu.cpp | 151 +++++++++----
 src/KsQuickContextMenu.hpp |  26 ++-
 src/KsTraceGraph.cpp       | 426 ++++++++++++++++++-------------------
 src/KsTraceGraph.hpp       |  43 ++--
 5 files changed, 351 insertions(+), 307 deletions(-)

diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index fa3f529..a745757 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -71,12 +71,12 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
                         KsGLWidget.hpp
                         KsSearchFSM.hpp
                         KsDualMarker.hpp
-                        KsWidgetsLib.hpp)
-#                         KsTraceGraph.hpp
+                        KsWidgetsLib.hpp
+                        KsTraceGraph.hpp
 #                         KsTraceViewer.hpp
 #                         KsMainWindow.hpp
 #                         KsCaptureDialog.hpp
-#                         KsQuickContextMenu.hpp
+                        KsQuickContextMenu.hpp)
 #                         KsAdvFilteringDialog.hpp)
 
     QT5_WRAP_CPP(ks-guiLib_hdr_moc ${ks-guiLib_hdr})
@@ -87,12 +87,12 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
                                                             KsGLWidget.cpp
                                                             KsSearchFSM.cpp
                                                             KsDualMarker.cpp
-                                                            KsWidgetsLib.cpp)
-#                                                             KsTraceGraph.cpp
+                                                            KsWidgetsLib.cpp
+                                                            KsTraceGraph.cpp
 #                                                             KsTraceViewer.cpp
 #                                                             KsMainWindow.cpp
 #                                                             KsCaptureDialog.cpp
-#                                                             KsQuickContextMenu.cpp
+                                                            KsQuickContextMenu.cpp)
 #                                                             KsAdvFilteringDialog.cpp)
 
     target_link_libraries(kshark-gui kshark-plot
diff --git a/src/KsQuickContextMenu.cpp b/src/KsQuickContextMenu.cpp
index a84444e..6fa242d 100644
--- a/src/KsQuickContextMenu.cpp
+++ b/src/KsQuickContextMenu.cpp
@@ -39,17 +39,19 @@ KsQuickMarkerMenu::KsQuickMarkerMenu(KsDualMarkerSM *dm, QWidget *parent)
 /**
  * @brief Create KsQuickContextMenu.
  *
+ * @param dm: The State machine of the Dual marker.
  * @param data: Input location for the KsDataStore object.
  * @param row: The index of the entry used to initialize the menu.
- * @param dm: The State machine of the Dual marker.
  * @param parent: The parent of this widget.
  */
-KsQuickContextMenu::KsQuickContextMenu(KsDataStore *data, size_t row,
-				       KsDualMarkerSM *dm,
+KsQuickContextMenu::KsQuickContextMenu(KsDualMarkerSM *dm,
+				       KsDataStore *data, size_t row,
 				       QWidget *parent)
 : KsQuickMarkerMenu(dm, parent),
   _data(data),
   _row(row),
+  _rawTime(this),
+  _rawEvent(this),
   _graphSyncCBox(nullptr),
   _listSyncCBox(nullptr),
   _hideTaskAction(this),
@@ -65,16 +67,50 @@ KsQuickContextMenu::KsQuickContextMenu(KsDataStore *data, size_t row,
   _clearAllFilters(this)
 {
 	typedef void (KsQuickContextMenu::*mfp)();
-	QString taskName, parentName, descr;
+	QString time, taskName, parentName, descr;
+	kshark_entry *entry = _data->rows()[_row];
+	kshark_context *kshark_ctx(nullptr);
+	kshark_data_stream *stream;
+	QStringList eventFields;
+	int pid, cpu, sd, ret;
 	KsTraceGraph *graphs;
-	int pid, cpu;
+	int64_t fieldVal;
 
 	if (!parent || !_data)
 		return;
 
-	taskName = kshark_get_task_easy(_data->rows()[_row]);
-	pid = kshark_get_pid_easy(_data->rows()[_row]);
-	cpu = _data->rows()[_row]->cpu;
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	taskName = kshark_get_task(entry);
+	pid = kshark_get_pid(entry);
+	cpu = entry->cpu;
+	sd = entry->stream_id;
+
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!stream)
+		return;
+
+	QString evtData("\t"), val;
+	eventFields =  KsUtils::getEventFieldsList(entry->stream_id,
+						   entry->event_id);
+
+	for (auto const &field: eventFields) {
+		std::string buff = field.toStdString();
+		ret = kshark_read_event_field_int(entry, buff.c_str(), &fieldVal);
+		if (ret < 0)
+			continue;
+
+		evtData += field + ":  " + val.setNum(fieldVal) + "\n\t";
+	}
+
+	addSection("Raw event");
+	time = QString("\ttime:  %1 [ns]").arg(entry->ts);
+
+	_rawTime.setDefaultWidget(new QLabel(time));
+	addAction(&_rawTime);
+	_rawEvent.setDefaultWidget(new QLabel(evtData));
+	addAction(&_rawEvent);
 
 	auto lamAddAction = [this, &descr] (QAction *action, mfp mf) {
 		action->setText(descr);
@@ -104,12 +140,12 @@ KsQuickContextMenu::KsQuickContextMenu(KsDataStore *data, size_t row,
 	lamAddAction(&_hideTaskAction, &KsQuickContextMenu::_hideTask);
 
 	descr = "Show event [";
-	descr += kshark_get_event_name_easy(_data->rows()[_row]);
+	descr += kshark_get_event_name(entry);
 	descr += "] only";
 	lamAddAction(&_showEventAction, &KsQuickContextMenu::_showEvent);
 
 	descr = "Hide event [";
-	descr += kshark_get_event_name_easy(_data->rows()[_row]);
+	descr += kshark_get_event_name(entry);
 	descr += "]";
 	lamAddAction(&_hideEventAction, &KsQuickContextMenu::_hideEvent);
 
@@ -118,7 +154,7 @@ KsQuickContextMenu::KsQuickContextMenu(KsDataStore *data, size_t row,
 		lamAddAction(&_showCPUAction, &KsQuickContextMenu::_showCPU);
 	}
 
-	descr = QString("Hide CPU [%1]").arg(_data->rows()[_row]->cpu);
+	descr = QString("Hide CPU [%1]").arg(entry->cpu);
 	lamAddAction(&_hideCPUAction, &KsQuickContextMenu::_hideCPU);
 
 	descr = "Clear all filters";
@@ -138,7 +174,7 @@ KsQuickContextMenu::KsQuickContextMenu(KsDataStore *data, size_t row,
 
 	if (parentName == "KsTraceGraph" &&
 	    (graphs = dynamic_cast<KsTraceGraph *>(parent))) {
-		if (graphs->glPtr()->_taskList.contains(pid)) {
+		if (graphs->glPtr()->_streamPlots[sd]._taskList.contains(pid)) {
 			descr = "Remove [";
 			descr += taskName;
 			descr += "-";
@@ -156,7 +192,7 @@ KsQuickContextMenu::KsQuickContextMenu(KsDataStore *data, size_t row,
 				     &KsQuickContextMenu::_addTaskPlot);
 		}
 
-		if (graphs->glPtr()->_cpuList.contains(cpu)) {
+		if (graphs->glPtr()->_streamPlots[sd]._cpuList.contains(cpu)) {
 			descr = "Remove [CPU ";
 			descr += QString("%1").arg(cpu);
 			descr += "] plot";
@@ -174,66 +210,86 @@ KsQuickContextMenu::KsQuickContextMenu(KsDataStore *data, size_t row,
 
 void KsQuickContextMenu::_hideTask()
 {
-	int pid = kshark_get_pid_easy(_data->rows()[_row]);
+	int pid = kshark_get_pid(_data->rows()[_row]);
+	int sd = _data->rows()[_row]->stream_id;
 	kshark_context *kshark_ctx(nullptr);
+	kshark_data_stream *stream;
 	QVector<int> vec;
 
 	if (!kshark_instance(&kshark_ctx))
 		return;
 
-	vec =_getFilterVector(kshark_ctx->hide_task_filter, pid);
-	_data->applyNegTaskFilter(vec);
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!stream)
+		return;
+
+	vec =_getFilterVector(stream->hide_task_filter, pid);
+	_data->applyNegTaskFilter(sd, vec);
 }
 
 void KsQuickContextMenu::_showTask()
 {
-	int pid = kshark_get_pid_easy(_data->rows()[_row]);
-
-	_data->applyPosTaskFilter(QVector<int>(1, pid));
+	int pid = kshark_get_pid(_data->rows()[_row]);
+	int sd = _data->rows()[_row]->stream_id;
+	_data->applyPosTaskFilter(sd, QVector<int>(1, pid));
 }
 
 void KsQuickContextMenu::_hideEvent()
 {
-	int eventId = kshark_get_event_id_easy(_data->rows()[_row]);
+	int eventId = kshark_get_event_id(_data->rows()[_row]);
+	int sd = _data->rows()[_row]->stream_id;
 	kshark_context *kshark_ctx(nullptr);
+	kshark_data_stream *stream;
 	QVector<int> vec;
 
 	if (!kshark_instance(&kshark_ctx))
 		return;
 
-	vec =_getFilterVector(kshark_ctx->hide_event_filter, eventId);
-	_data->applyNegEventFilter(vec);
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!stream)
+		return;
+
+	vec =_getFilterVector(stream->hide_event_filter, eventId);
+	_data->applyNegEventFilter(sd, vec);
 }
 
 void KsQuickContextMenu::_showEvent()
 {
-	int eventId = kshark_get_event_id_easy(_data->rows()[_row]);
+	int eventId = kshark_get_event_id(_data->rows()[_row]);
+	int sd = _data->rows()[_row]->stream_id;
 
-	_data->applyPosEventFilter(QVector<int>(1, eventId));
+	_data->applyPosEventFilter(sd, QVector<int>(1, eventId));
 }
 
 void KsQuickContextMenu::_showCPU()
 {
 	int cpu = _data->rows()[_row]->cpu;
+	int sd = _data->rows()[_row]->stream_id;
 
-	_data->applyPosCPUFilter(QVector<int>(1, cpu));
+	_data->applyPosCPUFilter(sd, QVector<int>(1, cpu));
 }
 
 void KsQuickContextMenu::_hideCPU()
 {
+	int sd = _data->rows()[_row]->stream_id;
 	kshark_context *kshark_ctx(nullptr);
+	kshark_data_stream *stream;
 	QVector<int> vec;
 
 	if (!kshark_instance(&kshark_ctx))
 		return;
 
-	vec =_getFilterVector(kshark_ctx->hide_cpu_filter,
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!stream)
+		return;
+
+	vec =_getFilterVector(stream->hide_cpu_filter,
 			      _data->rows()[_row]->cpu);
 
-	_data->applyNegCPUFilter(vec);
+	_data->applyNegCPUFilter(sd, vec);
 }
 
-QVector<int> KsQuickContextMenu::_getFilterVector(tracecmd_filter_id *filter, int newId)
+QVector<int> KsQuickContextMenu::_getFilterVector(kshark_hash_id *filter, int newId)
 {
 	QVector<int> vec = KsUtils::getFilterIds(filter);
 	if (!vec.contains(newId))
@@ -244,38 +300,42 @@ QVector<int> KsQuickContextMenu::_getFilterVector(tracecmd_filter_id *filter, in
 
 void KsQuickContextMenu::_addTaskPlot()
 {
-	int pid = kshark_get_pid_easy(_data->rows()[_row]);
+	int pid = kshark_get_pid(_data->rows()[_row]);
+	int sd = _data->rows()[_row]->stream_id;
 
-	emit addTaskPlot(pid);
+	emit addTaskPlot(sd, pid);
 }
 
 void KsQuickContextMenu::_addCPUPlot()
 {
-	emit addCPUPlot(_data->rows()[_row]->cpu);
+	emit addCPUPlot(_data->rows()[_row]->stream_id, _data->rows()[_row]->cpu);
 }
 
 void KsQuickContextMenu::_removeTaskPlot()
 {
-	int pid = kshark_get_pid_easy(_data->rows()[_row]);
+	int pid = kshark_get_pid(_data->rows()[_row]);
+	int sd = _data->rows()[_row]->stream_id;
 
-	emit removeTaskPlot(pid);
+	emit removeTaskPlot(sd, pid);
 }
 
 void KsQuickContextMenu::_removeCPUPlot()
 {
-	emit removeCPUPlot(_data->rows()[_row]->cpu);
+	emit removeCPUPlot(_data->rows()[_row]->stream_id, _data->rows()[_row]->cpu);
 }
 
 /**
  * @brief Create KsRmPlotContextMenu.
  *
  * @param dm: The State machine of the Dual marker.
+ * @param sd: Data stream identifier.
  * @param parent: The parent of this widget.
  */
-KsRmPlotContextMenu::KsRmPlotContextMenu(KsDualMarkerSM *dm,
+KsRmPlotContextMenu::KsRmPlotContextMenu(KsDualMarkerSM *dm, int sd,
 					 QWidget *parent)
 : KsQuickMarkerMenu(dm, parent),
-  _removePlotAction(this)
+  _removePlotAction(this),
+  _sd(sd)
 {
 	addSection("Plots");
 
@@ -289,12 +349,13 @@ KsRmPlotContextMenu::KsRmPlotContextMenu(KsDualMarkerSM *dm,
  * @brief Create KsRmCPUPlotMenu.
  *
  * @param dm: The State machine of the Dual marker.
+ * @param sd: Data stream identifier.
  * @param cpu : CPU Id.
  * @param parent: The parent of this widget.
  */
-KsRmCPUPlotMenu::KsRmCPUPlotMenu(KsDualMarkerSM *dm, int cpu,
+KsRmCPUPlotMenu::KsRmCPUPlotMenu(KsDualMarkerSM *dm, int sd, int cpu,
 				 QWidget *parent)
-: KsRmPlotContextMenu(dm, parent)
+: KsRmPlotContextMenu(dm, sd, parent)
 {
 	_removePlotAction.setText(QString("Remove [CPU %1]").arg(cpu));
 }
@@ -303,20 +364,18 @@ KsRmCPUPlotMenu::KsRmCPUPlotMenu(KsDualMarkerSM *dm, int cpu,
  * @brief Create KsRmTaskPlotMenu.
  *
  * @param dm: The State machine of the Dual marker.
+ * @param sd: Data stream identifier.
  * @param pid: Process Id.
  * @param parent: The parent of this widget.
  */
-KsRmTaskPlotMenu::KsRmTaskPlotMenu(KsDualMarkerSM *dm, int pid,
+KsRmTaskPlotMenu::KsRmTaskPlotMenu(KsDualMarkerSM *dm, int sd, int pid,
 				   QWidget *parent)
-: KsRmPlotContextMenu(dm, parent)
+: KsRmPlotContextMenu(dm, sd, parent)
 {
-	kshark_context *kshark_ctx(nullptr);
-	QString descr("Remove [ ");
-
-	if (!kshark_instance(&kshark_ctx))
-		return;
+	QString descr;
 
-	descr += tep_data_comm_from_pid(kshark_ctx->pevent, pid);
+	descr = "Remove [ ";
+	descr += kshark_comm_from_pid(sd, pid);
 	descr += "-";
 	descr += QString("%1").arg(pid);
 	descr += "] plot";
diff --git a/src/KsQuickContextMenu.hpp b/src/KsQuickContextMenu.hpp
index df8a65b..ca0b341 100644
--- a/src/KsQuickContextMenu.hpp
+++ b/src/KsQuickContextMenu.hpp
@@ -45,22 +45,22 @@ class KsQuickContextMenu : public KsQuickMarkerMenu {
 public:
 	KsQuickContextMenu() = delete;
 
-	KsQuickContextMenu(KsDataStore *data, size_t row,
-			   KsDualMarkerSM *dm,
+	KsQuickContextMenu(KsDualMarkerSM *dm,
+			   KsDataStore *data, size_t row,
 			   QWidget *parent = nullptr);
 
 signals:
 	/** Signal to add a task plot. */
-	void addTaskPlot(int);
+	void addTaskPlot(int sd, int pid);
 
 	/** Signal to add a CPU plot. */
-	void addCPUPlot(int);
+	void addCPUPlot(int sd, int cpu);
 
 	/** Signal to remove a task plot. */
-	void removeTaskPlot(int);
+	void removeTaskPlot(int sd, int pid);
 
 	/** Signal to remove a CPU plot. */
-	void removeCPUPlot(int);
+	void removeCPUPlot(int sd, int cpu);
 
 private:
 	void _hideTask();
@@ -83,7 +83,7 @@ private:
 
 	void _removeTaskPlot();
 
-	QVector<int> _getFilterVector(tracecmd_filter_id *filter, int newId);
+	QVector<int> _getFilterVector(kshark_hash_id *filter, int newId);
 
 	void _clearFilters() {_data->clearAllFilters();}
 
@@ -91,6 +91,8 @@ private:
 
 	size_t		_row;
 
+	QWidgetAction	_rawTime, _rawEvent;
+
 	QCheckBox	*_graphSyncCBox, *_listSyncCBox;
 
 	QAction _hideTaskAction, _showTaskAction;
@@ -118,7 +120,8 @@ class KsRmPlotContextMenu : public KsQuickMarkerMenu {
 public:
 	KsRmPlotContextMenu() = delete;
 
-	KsRmPlotContextMenu(KsDualMarkerSM *dm, QWidget *parent = nullptr);
+	KsRmPlotContextMenu(KsDualMarkerSM *dm, int sd,
+			    QWidget *parent = nullptr);
 
 signals:
 	/** Signal to remove a plot. */
@@ -127,13 +130,16 @@ signals:
 protected:
 	/** Menu action. */
 	QAction _removePlotAction;
+
+	/** Data stream identifier. */
+	int _sd;
 };
 
 /**
  * The KsQuickMarkerMenu class provides CPU Plot remove menus.
  */
 struct KsRmCPUPlotMenu : public KsRmPlotContextMenu {
-	KsRmCPUPlotMenu(KsDualMarkerSM *dm, int cpu,
+	KsRmCPUPlotMenu(KsDualMarkerSM *dm, int sd, int cpu,
 			QWidget *parent = nullptr);
 };
 
@@ -141,7 +147,7 @@ struct KsRmCPUPlotMenu : public KsRmPlotContextMenu {
  * The KsQuickMarkerMenu class provides Task Plot remove menus.
  */
 struct KsRmTaskPlotMenu : public KsRmPlotContextMenu {
-	KsRmTaskPlotMenu(KsDualMarkerSM *dm, int pid,
+	KsRmTaskPlotMenu(KsDualMarkerSM *dm, int sd, int pid,
 			 QWidget *parent = nullptr);
 };
 
diff --git a/src/KsTraceGraph.cpp b/src/KsTraceGraph.cpp
index 7b656c0..fd9cfac 100644
--- a/src/KsTraceGraph.cpp
+++ b/src/KsTraceGraph.cpp
@@ -17,7 +17,7 @@
 
 /** Create a default (empty) Trace graph widget. */
 KsTraceGraph::KsTraceGraph(QWidget *parent)
-: QWidget(parent),
+: KsWidgetsLib::KsDataWidget(parent),
   _pointerBar(this),
   _navigationBar(this),
   _zoomInButton("+", this),
@@ -34,13 +34,7 @@ KsTraceGraph::KsTraceGraph(QWidget *parent)
   _labelI4("", this),
   _labelI5("", this),
   _scrollArea(this),
-  _drawWindow(&_scrollArea),
-  _legendWindow(&_drawWindow),
-  _legendAxisX(&_drawWindow),
-  _labelXMin("", &_legendAxisX),
-  _labelXMid("", &_legendAxisX),
-  _labelXMax("", &_legendAxisX),
-  _glWindow(&_drawWindow),
+  _glWindow(&_scrollArea),
   _mState(nullptr),
   _data(nullptr),
   _keyPressed(false)
@@ -62,7 +56,7 @@ KsTraceGraph::KsTraceGraph(QWidget *parent)
 
 	_pointerBar.addWidget(&_labelP1);
 	_labelP2.setFrameStyle(QFrame::Panel | QFrame::Sunken);
-	_labelP2.setStyleSheet("QLabel { background-color : white; color: black}");
+	_labelP2.setStyleSheet("QLabel {background-color : white; color: black}");
 	_labelP2.setTextInteractionFlags(Qt::TextSelectableByMouse);
 	_labelP2.setFixedWidth(FONT_WIDTH * 16);
 	_pointerBar.addWidget(&_labelP2);
@@ -84,31 +78,7 @@ KsTraceGraph::KsTraceGraph(QWidget *parent)
 	_pointerBar.addSeparator();
 	_pointerBar.addWidget(&_labelI5);
 
-	_legendAxisX.setFixedHeight(FONT_HEIGHT * 1.5);
-	_legendAxisX.setLayout(new QHBoxLayout);
-	_legendAxisX.layout()->setSpacing(0);
-	_legendAxisX.layout()->setContentsMargins(0, 0, FONT_WIDTH, 0);
-
-	_labelXMin.setAlignment(Qt::AlignLeft);
-	_labelXMid.setAlignment(Qt::AlignHCenter);
-	_labelXMax.setAlignment(Qt::AlignRight);
-
-	_legendAxisX.layout()->addWidget(&_labelXMin);
-	_legendAxisX.layout()->addWidget(&_labelXMid);
-	_legendAxisX.layout()->addWidget(&_labelXMax);
-	_legendAxisX.setStyleSheet("QLabel { background-color : white; color: black}");
-
-	_drawWindow.setMinimumSize(100, 100);
-	_drawWindow.setStyleSheet("QWidget {background-color : white;}");
-
-	_drawLayout.setContentsMargins(0, 0, 0, 0);
-	_drawLayout.setSpacing(0);
-	_drawLayout.addWidget(&_legendAxisX, 0, 1);
-	_drawLayout.addWidget(&_legendWindow, 1, 0);
-	_drawLayout.addWidget(&_glWindow, 1, 1);
-	_drawWindow.setLayout(&_drawLayout);
-
-	_drawWindow.installEventFilter(this);
+	_glWindow.installEventFilter(this);
 
 	connect(&_glWindow,	&KsGLWidget::select,
 		this,		&KsTraceGraph::markEntry);
@@ -134,15 +104,12 @@ KsTraceGraph::KsTraceGraph(QWidget *parent)
 	connect(&_glWindow,	&KsGLWidget::stopUpdating,
 		this,		&KsTraceGraph::_stopUpdating);
 
-	connect(_glWindow.model(),	&KsGraphModel::modelReset,
-		this,			&KsTraceGraph::_updateTimeLegends);
-
 	_glWindow.setContextMenuPolicy(Qt::CustomContextMenu);
 	connect(&_glWindow,	&QWidget::customContextMenuRequested,
 		this,		&KsTraceGraph::_onCustomContextMenu);
 
 	_scrollArea.setHorizontalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
-	_scrollArea.setWidget(&_drawWindow);
+	_scrollArea.setWidget(&_glWindow);
 
 	lamMakeNavButton(&_scrollLeftButton);
 	connect(&_scrollLeftButton,	&QPushButton::pressed,
@@ -187,7 +154,6 @@ void KsTraceGraph::loadData(KsDataStore *data)
 {
 	_data = data;
 	_glWindow.loadData(data);
-	_updateGraphLegends();
 	updateGeom();
 }
 
@@ -211,14 +177,10 @@ void KsTraceGraph::reset()
 		l1->setText("");
 
 	_selfUpdate();
-	for (auto l2: {&_labelXMin, &_labelXMid, &_labelXMax})
-		l2->setText("");
 }
 
 void KsTraceGraph::_selfUpdate()
 {
-	_updateGraphLegends();
-	_updateTimeLegends();
 	_markerReDraw();
 	_glWindow.model()->update();
 	updateGeom();
@@ -226,12 +188,20 @@ void KsTraceGraph::_selfUpdate()
 
 void KsTraceGraph::_zoomIn()
 {
-	_updateGraphs(GraphActions::ZoomIn);
+	KsWidgetsLib::KsDataWork action = KsWidgetsLib::KsDataWork::ZoomIn;
+
+	startOfWork(action);
+	_updateGraphs(action);
+	endOfWork(action);
 }
 
 void KsTraceGraph::_zoomOut()
 {
-	_updateGraphs(GraphActions::ZoomOut);
+	KsWidgetsLib::KsDataWork action = KsWidgetsLib::KsDataWork::ZoomOut;
+
+	startOfWork(action);
+	_updateGraphs(action);
+	endOfWork(action);
 }
 
 void KsTraceGraph::_quickZoomIn()
@@ -239,6 +209,8 @@ void KsTraceGraph::_quickZoomIn()
 	if (_glWindow.isEmpty())
 		return;
 
+	startOfWork(KsWidgetsLib::KsDataWork::QuickZoomIn);
+
 	/* Bin size will be 100 ns. */
 	_glWindow.model()->quickZoomIn(100);
 	if (_mState->activeMarker()._isSet &&
@@ -249,7 +221,10 @@ void KsTraceGraph::_quickZoomIn()
 		 */
 		uint64_t ts = _mState->activeMarker()._ts;
 		_glWindow.model()->jumpTo(ts);
+		_glWindow.render();
 	}
+
+	endOfWork(KsWidgetsLib::KsDataWork::QuickZoomIn);
 }
 
 void KsTraceGraph::_quickZoomOut()
@@ -257,17 +232,28 @@ void KsTraceGraph::_quickZoomOut()
 	if (_glWindow.isEmpty())
 		return;
 
+	startOfWork(KsWidgetsLib::KsDataWork::QuickZoomOut);
 	_glWindow.model()->quickZoomOut();
+	_glWindow.render();
+	endOfWork(KsWidgetsLib::KsDataWork::QuickZoomOut);
 }
 
 void KsTraceGraph::_scrollLeft()
 {
-	_updateGraphs(GraphActions::ScrollLeft);
+	KsWidgetsLib::KsDataWork action = KsWidgetsLib::KsDataWork::ScrollLeft;
+
+	startOfWork(action);
+	_updateGraphs(action);
+	endOfWork(action);
 }
 
 void KsTraceGraph::_scrollRight()
 {
-	_updateGraphs(GraphActions::ScrollRight);
+	KsWidgetsLib::KsDataWork action = KsWidgetsLib::KsDataWork::ScrollRight;
+
+	startOfWork(action);
+	_updateGraphs(action);
+	endOfWork(action);
 }
 
 void KsTraceGraph::_stopUpdating()
@@ -292,10 +278,18 @@ QString KsTraceGraph::_t2str(uint64_t sec, uint64_t usec) {
 	return QString::number(sec) + "." + usecStr;
 }
 
-void KsTraceGraph::_resetPointer(uint64_t ts, int cpu, int pid)
+void KsTraceGraph::_resetPointer(int64_t ts, int sd, int cpu, int pid)
 {
+	kshark_entry entry;
 	uint64_t sec, usec;
 
+	entry.cpu = cpu;
+	entry.pid = pid;
+	entry.stream_id = sd;
+
+	if (ts < 0)
+		ts = 0;
+
 	kshark_convert_nano(ts, &sec, &usec);
 	_labelP2.setText(_t2str(sec, usec));
 
@@ -305,7 +299,7 @@ void KsTraceGraph::_resetPointer(uint64_t ts, int cpu, int pid)
 		if (!kshark_instance(&kshark_ctx))
 			return;
 
-		QString comm(tep_data_comm_from_pid(kshark_ctx->pevent, pid));
+		QString comm(kshark_get_task(&entry));
 		comm.append("-");
 		comm.append(QString("%1").arg(pid));
 		_labelI1.setText(comm);
@@ -323,23 +317,30 @@ void KsTraceGraph::_resetPointer(uint64_t ts, int cpu, int pid)
 void KsTraceGraph::_setPointerInfo(size_t i)
 {
 	kshark_entry *e = _data->rows()[i];
-	QString event(kshark_get_event_name_easy(e));
-	QString lat(kshark_get_latency_easy(e));
-	QString info(kshark_get_info_easy(e));
-	QString comm(kshark_get_task_easy(e));
-	int labelWidth, width;
-	QString elidedText;
+	auto lanMakeString = [] (char *buffer) {
+		QString str(buffer);
+		free(buffer);
+		return str;
+	};
+
+	QString event(lanMakeString(kshark_get_event_name(e)));
+	QString aux(lanMakeString(kshark_get_aux_info(e)));
+	QString info(lanMakeString(kshark_get_info(e)));
+	QString comm(lanMakeString(kshark_get_task(e)));
+	QString pointer, elidedText;
+	int labelWidth;
 	uint64_t sec, usec;
 
 	kshark_convert_nano(e->ts, &sec, &usec);
-	_labelP2.setText(_t2str(sec, usec));
+	pointer.sprintf("%" PRIu64 ".%06" PRIu64 "", sec, usec);
+	_labelP2.setText(pointer);
 
 	comm.append("-");
-	comm.append(QString("%1").arg(kshark_get_pid_easy(e)));
+	comm.append(QString("%1").arg(kshark_get_pid(e)));
 
 	_labelI1.setText(comm);
 	_labelI2.setText(QString("CPU %1").arg(e->cpu));
-	_labelI3.setText(lat);
+	_labelI3.setText(aux);
 	_labelI4.setText(event);
 	_labelI5.setText(info);
 	QCoreApplication::processEvents();
@@ -353,16 +354,7 @@ void KsTraceGraph::_setPointerInfo(size_t i)
 	 * The Info string is too long and cannot be displayed on the toolbar.
 	 * Try to fit the text in the available space.
 	 */
-	QFontMetrics metrix(_labelI5.font());
-	width = labelWidth - FONT_WIDTH * 3;
-	elidedText = metrix.elidedText(info, Qt::ElideRight, width);
-
-	while(labelWidth < STRING_WIDTH(elidedText) + FONT_WIDTH * 5) {
-		width -= FONT_WIDTH * 3;
-		elidedText = metrix.elidedText(info, Qt::ElideRight, width);
-	}
-
-	_labelI5.setText(elidedText);
+	KsUtils::setElidedText(&_labelI5, info, Qt::ElideRight, labelWidth);
 	_labelI5.setVisible(true);
 	QCoreApplication::processEvents();
 }
@@ -374,127 +366,188 @@ void KsTraceGraph::_setPointerInfo(size_t i)
  */
 void KsTraceGraph::markEntry(size_t row)
 {
-	int graph, cpuGrId, taskGrId;
-
-	_glWindow.findGraphIds(*_data->rows()[row], &cpuGrId, &taskGrId);
-
-	/*
-	 * If a Task graph has been found, this Task graph will be
-	 * visible. If no Task graph has been found, make visible
-	 * the corresponding CPU graph.
-	 */
-	if (taskGrId >= 0)
-		graph = taskGrId;
-	else
-		graph = cpuGrId;
-
-	_scrollArea.ensureVisible(0,
-				  _legendAxisX.height() +
-				  _glWindow.vMargin() +
-				  KS_GRAPH_HEIGHT / 2 +
-				  graph*(KS_GRAPH_HEIGHT + _glWindow.vSpacing()),
-				  50,
-				  KS_GRAPH_HEIGHT / 2 + _glWindow.vSpacing() / 2);
+	int yPosVis(-1);
 
 	_glWindow.model()->jumpTo(_data->rows()[row]->ts);
-	_mState->activeMarker().set(*_data,
-				    _glWindow.model()->histo(),
-				    row, cpuGrId, taskGrId);
+	_mState->activeMarker().set(*_data, _glWindow.model()->histo(),
+				    row, _data->rows()[row]->stream_id);
 
 	_mState->updateMarkers(*_data, &_glWindow);
+
+	/*
+	 * If a Combo graph has been found, this Combo graph will be visible.
+	 * Else the Task graph will be shown. If no Combo and no Task graph
+	 * has been found, make visible the corresponding CPU graph.
+	 */
+	if (_mState->activeMarker()._mark.comboIsVisible())
+		yPosVis = _mState->activeMarker()._mark.comboY();
+	else if (_mState->activeMarker()._mark.taskIsVisible())
+		yPosVis = _mState->activeMarker()._mark.taskY();
+	else if (_mState->activeMarker()._mark.cpuIsVisible())
+		yPosVis = _mState->activeMarker()._mark.cpuY();
+
+	if (yPosVis > 0)
+		_scrollArea.ensureVisible(0, yPosVis);
 }
 
 void KsTraceGraph::_markerReDraw()
 {
-	int cpuGrId, taskGrId;
 	size_t row;
 
 	if (_mState->markerA()._isSet) {
 		row = _mState->markerA()._pos;
-		_glWindow.findGraphIds(*_data->rows()[row], &cpuGrId, &taskGrId);
-		_mState->markerA().set(*_data,
-				       _glWindow.model()->histo(),
-				       row, cpuGrId, taskGrId);
+		_mState->markerA().set(*_data, _glWindow.model()->histo(),
+				       row, _data->rows()[row]->stream_id);
 	}
 
 	if (_mState->markerB()._isSet) {
 		row = _mState->markerB()._pos;
-		_glWindow.findGraphIds(*_data->rows()[row], &cpuGrId, &taskGrId);
-		_mState->markerB().set(*_data,
-				       _glWindow.model()->histo(),
-				       row, cpuGrId, taskGrId);
+		_mState->markerB().set(*_data, _glWindow.model()->histo(),
+				       row, _data->rows()[row]->stream_id);
 	}
 }
 
 /**
  * @brief Redreaw all CPU graphs.
  *
+ * @param sd: Data stream identifier.
  * @param v: CPU ids to be plotted.
  */
-void KsTraceGraph::cpuReDraw(QVector<int> v)
+void KsTraceGraph::cpuReDraw(int sd, QVector<int> v)
 {
-	_glWindow._cpuList = v;
+	startOfWork(KsWidgetsLib::KsDataWork::EditPlotList);
+	if (_glWindow._streamPlots.contains(sd))
+		_glWindow._streamPlots[sd]._cpuList = v;
+
 	_selfUpdate();
+	endOfWork(KsWidgetsLib::KsDataWork::EditPlotList);
 }
 
 /**
  * @brief Redreaw all Task graphs.
  *
+ * @param sd: Data stream identifier.
  * @param v: Process ids of the tasks to be plotted.
  */
-void KsTraceGraph::taskReDraw(QVector<int> v)
+void KsTraceGraph::taskReDraw(int sd, QVector<int> v)
+{
+	startOfWork(KsWidgetsLib::KsDataWork::EditPlotList);
+	if (_glWindow._streamPlots.contains(sd))
+		_glWindow._streamPlots[sd]._taskList = v;
+
+	_selfUpdate();
+	endOfWork(KsWidgetsLib::KsDataWork::EditPlotList);
+}
+
+/**
+ * @brief Redreaw all virtCombo graphs.
+ *
+ * @param nCombos: Numver of Combo plots.
+ * @param v: Descriptor of the Combo to be plotted.
+ */
+void KsTraceGraph::comboReDraw(int nCombos, QVector<int> v)
 {
-	_glWindow._taskList = v;
+	KsComboPlot combo;
+
+	startOfWork(KsWidgetsLib::KsDataWork::EditPlotList);
+
+	_glWindow._comboPlots.clear();
+
+	for (int i = 0; i < nCombos; ++i) {
+		combo.resize(v.takeFirst());
+		for (auto &p: combo)
+			p << v;
+
+		_glWindow._comboPlots.append(combo);
+	}
+
 	_selfUpdate();
+	endOfWork(KsWidgetsLib::KsDataWork::EditPlotList);
 }
 
 /** Add (and plot) a CPU graph to the existing list of CPU graphs. */
-void KsTraceGraph::addCPUPlot(int cpu)
+void KsTraceGraph::addCPUPlot(int sd, int cpu)
 {
-	if (_glWindow._cpuList.contains(cpu))
+	startOfWork(KsWidgetsLib::KsDataWork::EditPlotList);
+	QVector<int> &list = _glWindow._streamPlots[sd]._cpuList;
+	if (list.contains(cpu))
 		return;
 
-	_glWindow._cpuList.append(cpu);
-	std::sort(_glWindow._cpuList.begin(), _glWindow._cpuList.end());
+	list.append(cpu);
+	std::sort(list.begin(), list.end());
+
 	_selfUpdate();
+	endOfWork(KsWidgetsLib::KsDataWork::EditPlotList);
 }
 
 /** Add (and plot) a Task graph to the existing list of Task graphs. */
-void KsTraceGraph::addTaskPlot(int pid)
+void KsTraceGraph::addTaskPlot(int sd, int pid)
 {
-	if (_glWindow._taskList.contains(pid))
+	startOfWork(KsWidgetsLib::KsDataWork::EditPlotList);
+	QVector<int> &list = _glWindow._streamPlots[sd]._taskList;
+	if (list.contains(pid))
 		return;
 
-	_glWindow._taskList.append(pid);
-	std::sort(_glWindow._taskList.begin(), _glWindow._taskList.end());
+	list.append(pid);
+	std::sort(list.begin(), list.end());
+
 	_selfUpdate();
+	endOfWork(KsWidgetsLib::KsDataWork::EditPlotList);
 }
 
 /** Remove a CPU graph from the existing list of CPU graphs. */
-void KsTraceGraph::removeCPUPlot(int cpu)
+void KsTraceGraph::removeCPUPlot(int sd, int cpu)
 {
-	if (!_glWindow._cpuList.contains(cpu))
+	startOfWork(KsWidgetsLib::KsDataWork::EditPlotList);
+	if (!_glWindow._streamPlots[sd]._cpuList.contains(cpu))
 		return;
 
-	_glWindow._cpuList.removeAll(cpu);
+	_glWindow._streamPlots[sd]._cpuList.removeAll(cpu);
 	_selfUpdate();
+	endOfWork(KsWidgetsLib::KsDataWork::EditPlotList);
 }
 
 /** Remove a Task graph from the existing list of Task graphs. */
-void KsTraceGraph::removeTaskPlot(int pid)
+void KsTraceGraph::removeTaskPlot(int sd, int pid)
 {
-	if (!_glWindow._taskList.contains(pid))
+	startOfWork(KsWidgetsLib::KsDataWork::EditPlotList);
+	if (!_glWindow._streamPlots[sd]._taskList.contains(pid))
 		return;
 
-	_glWindow._taskList.removeAll(pid);
+	_glWindow._streamPlots[sd]._taskList.removeAll(pid);
 	_selfUpdate();
+	endOfWork(KsWidgetsLib::KsDataWork::EditPlotList);
 }
 
 /** Update the content of all graphs. */
 void KsTraceGraph::update(KsDataStore *data)
 {
-	_glWindow.model()->update(data);
+	kshark_context *kshark_ctx(nullptr);
+	QVector<int> streamIds;
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	streamIds = KsUtils::getStreamIdList(kshark_ctx);
+	for (auto const &sd: streamIds)
+		for (auto &pid: _glWindow._streamPlots[sd]._taskList) {
+			kshark_unregister_data_collection(&kshark_ctx->collections,
+							  kshark_match_pid,
+							  sd, &pid, 1);
+		}
+
 	_selfUpdate();
+
+	streamIds = KsUtils::getStreamIdList(kshark_ctx);
+	for (auto const &sd: streamIds)
+		for (auto &pid: _glWindow._streamPlots[sd]._taskList) {
+			kshark_register_data_collection(kshark_ctx,
+							data->rows(),
+							data->size(),
+							kshark_match_pid,
+							sd, &pid, 1,
+							25);
+		}
 }
 
 /** Update the geometry of the widget. */
@@ -519,19 +572,14 @@ void KsTraceGraph::updateGeom()
 	 * of the scroll bar.
 	 */
 	dwWidth = _scrollArea.width();
-	if (_glWindow.height() + _legendAxisX.height() > _scrollArea.height())
+	if (_glWindow.height() > _scrollArea.height())
 		dwWidth -=
 			qApp->style()->pixelMetric(QStyle::PM_ScrollBarExtent);
 
-	/*
-	 * Set the height of the Draw window according to the number of
-	 * plotted graphs.
-	 */
-	_drawWindow.resize(dwWidth,
-			   _glWindow.height() + _legendAxisX.height());
+	_glWindow.resize(dwWidth, _glWindow.height());
 
 	/* Set the minimum height of the Graph widget. */
-	hMin = _drawWindow.height() +
+	hMin = _glWindow.height() +
 	       _pointerBar.height() +
 	       _navigationBar.height() +
 	       _layout.contentsMargins().top() +
@@ -546,7 +594,7 @@ void KsTraceGraph::updateGeom()
 	 * Now use the height of the Draw Window to fix the maximum height
 	 * of the Graph widget.
 	 */
-	setMaximumHeight(_drawWindow.height() +
+	setMaximumHeight(_glWindow.height() +
 			 _pointerBar.height() +
 			 _navigationBar.height() +
 			 _layout.spacing() * 2 +
@@ -560,75 +608,6 @@ void KsTraceGraph::updateGeom()
 	_glWindow.update();
 }
 
-void KsTraceGraph::_updateGraphLegends()
-{
-	QString graphLegends, graphName;
-	QVBoxLayout *layout;
-	int width = 0;
-
-	if (_legendWindow.layout()) {
-		/*
-		 * Remove and delete the existing layout of the legend window.
-		 */
-		QLayoutItem *child;
-		while ((child = _legendWindow.layout()->takeAt(0)) != 0) {
-			delete child->widget();
-			delete child;
-		}
-
-		delete _legendWindow.layout();
-	}
-
-	layout = new QVBoxLayout;
-	layout->setContentsMargins(FONT_WIDTH, 0, 0, 0);
-	layout->setSpacing(_glWindow.vSpacing());
-	layout->setAlignment(Qt::AlignTop);
-	layout->addSpacing(_glWindow.vMargin());
-
-	auto lamMakeName = [&]() {
-		QLabel *name = new QLabel(graphName);
-
-		if (width < STRING_WIDTH(graphName))
-			width = STRING_WIDTH(graphName);
-
-		name->setAlignment(Qt::AlignBottom);
-		name->setStyleSheet("QLabel {background-color : white; color : black}");
-		name->setFixedHeight(KS_GRAPH_HEIGHT);
-		layout->addWidget(name);
-	};
-
-	for (auto const &cpu: _glWindow._cpuList) {
-		graphName = QString("CPU %1").arg(cpu);
-		lamMakeName();
-	}
-
-	for (auto const &pid: _glWindow._taskList) {
-		graphName = QString(tep_data_comm_from_pid(_data->tep(),
-							   pid));
-		graphName.append(QString("-%1").arg(pid));
-		lamMakeName();
-	}
-
-	_legendWindow.setLayout(layout);
-	_legendWindow.setMaximumWidth(width + FONT_WIDTH);
-}
-
-void KsTraceGraph::_updateTimeLegends()
-{
-	uint64_t sec, usec, tsMid;
-
-	kshark_convert_nano(_glWindow.model()->histo()->min, &sec, &usec);
-	_labelXMin.setText(_t2str(sec, usec));
-
-	tsMid = (_glWindow.model()->histo()->min +
-		 _glWindow.model()->histo()->max) / 2;
-	kshark_convert_nano(tsMid, &sec, &usec);
-	_labelXMid.setText(_t2str(sec, usec));
-
-	kshark_convert_nano(_glWindow.model()->histo()->max, &sec, &usec);
-	_labelXMax.setText(_t2str(sec, usec));
-}
-
 /**
  * Reimplemented event handler used to update the geometry of the widget on
  * resize events.
@@ -646,16 +625,25 @@ void KsTraceGraph::resizeEvent(QResizeEvent* event)
  */
 bool KsTraceGraph::eventFilter(QObject* obj, QEvent* evt)
 {
-	if (obj == &_drawWindow && evt->type() == QEvent::Enter)
+	/* Desable all mouse events for the OpenGL wiget when busy. */
+	if (obj == &_glWindow && this->isBusy() &&
+	    (evt->type() == QEvent::MouseButtonDblClick ||
+	     evt->type() == QEvent::MouseButtonPress ||
+	     evt->type() == QEvent::MouseButtonRelease ||
+	     evt->type() == QEvent::MouseMove)
+	)
+		return true;
+
+	if (obj == &_glWindow && evt->type() == QEvent::Enter)
 		_glWindow.setFocus();
 
-	if (obj == &_drawWindow && evt->type() == QEvent::Leave)
+	if (obj == &_glWindow && evt->type() == QEvent::Leave)
 		_glWindow.clearFocus();
 
 	return QWidget::eventFilter(obj, evt);
 }
 
-void KsTraceGraph::_updateGraphs(GraphActions action)
+void KsTraceGraph::_updateGraphs(KsWidgetsLib::KsDataWork action)
 {
 	double k;
 	int bin;
@@ -673,7 +661,7 @@ void KsTraceGraph::_updateGraphs(GraphActions action)
 	k = .01;
 	while (_keyPressed) {
 		switch (action) {
-		case GraphActions::ZoomIn:
+		case KsWidgetsLib::KsDataWork::ZoomIn:
 			if (_mState->activeMarker()._isSet &&
 			    _mState->activeMarker().isVisible()) {
 				/*
@@ -692,7 +680,7 @@ void KsTraceGraph::_updateGraphs(GraphActions action)
 
 			break;
 
-		case GraphActions::ZoomOut:
+		case KsWidgetsLib::KsDataWork::ZoomOut:
 			if (_mState->activeMarker()._isSet &&
 			    _mState->activeMarker().isVisible()) {
 				/*
@@ -711,13 +699,16 @@ void KsTraceGraph::_updateGraphs(GraphActions action)
 
 			break;
 
-		case GraphActions::ScrollLeft:
+		case KsWidgetsLib::KsDataWork::ScrollLeft:
 			_glWindow.model()->shiftBackward(10);
 			break;
 
-		case GraphActions::ScrollRight:
+		case KsWidgetsLib::KsDataWork::ScrollRight:
 			_glWindow.model()->shiftForward(10);
 			break;
+
+		default:
+			return;
 		}
 
 		/*
@@ -729,7 +720,7 @@ void KsTraceGraph::_updateGraphs(GraphActions action)
 			k  *= 1.02;
 
 		_mState->updateMarkers(*_data, &_glWindow);
-		_updateTimeLegends();
+		_glWindow.render();
 		QCoreApplication::processEvents();
 	}
 }
@@ -737,7 +728,7 @@ void KsTraceGraph::_updateGraphs(GraphActions action)
 void KsTraceGraph::_onCustomContextMenu(const QPoint &point)
 {
 	KsQuickMarkerMenu *menu(nullptr);
-	int cpu, pid;
+	int sd, cpu, pid;
 	size_t row;
 	bool found;
 
@@ -745,8 +736,8 @@ void KsTraceGraph::_onCustomContextMenu(const QPoint &point)
 	if (found) {
 		/* KernelShark entry has been found under the cursor. */
 		KsQuickContextMenu *entryMenu;
-		menu = entryMenu = new KsQuickContextMenu(_data, row,
-							  _mState, this);
+		menu = entryMenu = new KsQuickContextMenu(_mState, _data, row,
+							  this);
 
 		connect(entryMenu,	&KsQuickContextMenu::addTaskPlot,
 			this,		&KsTraceGraph::addTaskPlot);
@@ -760,34 +751,35 @@ void KsTraceGraph::_onCustomContextMenu(const QPoint &point)
 		connect(entryMenu,	&KsQuickContextMenu::removeCPUPlot,
 			this,		&KsTraceGraph::removeCPUPlot);
 	} else {
-		cpu = _glWindow.getPlotCPU(point);
+		if (!_glWindow.getPlotInfo(point, &sd, &cpu, &pid))
+			return;
+
 		if (cpu >= 0) {
 			/*
 			 * This is a CPU plot, but we do not have an entry
 			 * under the cursor.
 			 */
 			KsRmCPUPlotMenu *rmMenu;
-			menu = rmMenu = new KsRmCPUPlotMenu(_mState, cpu, this);
+			menu = rmMenu = new KsRmCPUPlotMenu(_mState, sd, cpu, this);
 
-			auto lamRmPlot = [&cpu, this] () {
-				removeCPUPlot(cpu);
+			auto lamRmPlot = [&sd, &cpu, this] () {
+				removeCPUPlot(sd, cpu);
 			};
 
 			connect(rmMenu, &KsRmPlotContextMenu::removePlot,
 				lamRmPlot);
 		}
 
-		pid = _glWindow.getPlotPid(point);
 		if (pid >= 0) {
 			/*
 			 * This is a Task plot, but we do not have an entry
 			 * under the cursor.
 			 */
 			KsRmTaskPlotMenu *rmMenu;
-			menu = rmMenu = new KsRmTaskPlotMenu(_mState, pid, this);
+			menu = rmMenu = new KsRmTaskPlotMenu(_mState, sd, pid, this);
 
-			auto lamRmPlot = [&pid, this] () {
-				removeTaskPlot(pid);
+			auto lamRmPlot = [&sd, &pid, this] () {
+				removeTaskPlot(sd, pid);
 			};
 
 			connect(rmMenu, &KsRmPlotContextMenu::removePlot,
diff --git a/src/KsTraceGraph.hpp b/src/KsTraceGraph.hpp
index 0eeef14..0e31b88 100644
--- a/src/KsTraceGraph.hpp
+++ b/src/KsTraceGraph.hpp
@@ -12,6 +12,7 @@
 #define _KS_TRACEGRAPH_H
 
 // KernelShark
+#include "KsWidgetsLib.hpp"
 #include "KsGLWidget.hpp"
 
 /**
@@ -35,7 +36,7 @@ public:
  * The KsTraceViewer class provides a widget for interactive visualization of
  * trace data shown as time-series.
  */
-class KsTraceGraph : public QWidget
+class KsTraceGraph : public KsWidgetsLib::KsDataWidget
 {
 	Q_OBJECT
 public:
@@ -52,17 +53,19 @@ public:
 
 	void markEntry(size_t);
 
-	void cpuReDraw(QVector<int>);
+	void cpuReDraw(int sd, QVector<int> cpus);
 
-	void taskReDraw(QVector<int>);
+	void taskReDraw(int sd, QVector<int> pids);
 
-	void addCPUPlot(int);
+	void comboReDraw(int sd, QVector<int> v);
 
-	void addTaskPlot(int);
+	void addCPUPlot(int sd, int cpu);
 
-	void removeCPUPlot(int);
+	void addTaskPlot(int sd, int pid);
 
-	void removeTaskPlot(int);
+	void removeCPUPlot(int sd, int cpu);
+
+	void removeTaskPlot(int sd, int pid);
 
 	void update(KsDataStore *data);
 
@@ -96,34 +99,24 @@ private:
 
 	void _stopUpdating();
 
-	void _resetPointer(uint64_t ts, int cpu, int pid);
+	void _resetPointer(int64_t ts, int sd, int cpu, int pid);
 
 	void _setPointerInfo(size_t);
 
-	void _updateTimeLegends();
-
-	void _updateGraphLegends();
-
 	void _selfUpdate();
 
 	void _markerReDraw();
 
-	QString _t2str(uint64_t sec, uint64_t usec);
-
-	enum class GraphActions {
-		ZoomIn,
-		ZoomOut,
-		ScrollLeft,
-		ScrollRight
-	};
-
-	void _updateGraphs(GraphActions action);
+	void _updateGraphs(KsWidgetsLib::KsDataWork action);
 
 	void _onCustomContextMenu(const QPoint &point);
 
+	QString _t2str(uint64_t sec, uint64_t usec);
+
 	QToolBar	_pointerBar, _navigationBar;
 
 	QPushButton	_zoomInButton, _quickZoomInButton;
+
 	QPushButton	_zoomOutButton, _quickZoomOutButton;
 
 	QPushButton	_scrollLeftButton, _scrollRightButton;
@@ -133,14 +126,8 @@ private:
 
 	KsGraphScrollArea	_scrollArea;
 
-	QWidget		_drawWindow, _legendWindow, _legendAxisX;
-
-	QLabel		_labelXMin, _labelXMid, _labelXMax;
-
 	KsGLWidget	_glWindow;
 
-	QGridLayout	_drawLayout;
-
 	QVBoxLayout	_layout;
 
 	KsDualMarkerSM	*_mState;
-- 
2.25.1


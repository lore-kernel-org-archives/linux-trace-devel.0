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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43793C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:39:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06E9864E95
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:39:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbhBKKi7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Feb 2021 05:38:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbhBKKfv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Feb 2021 05:35:51 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C99AC061223
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:43 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id f14so9257560ejc.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7Ri1xXSmL1vhifAG+FG67oYdnXRt4tXmTmiE9SRHhws=;
        b=mEKSZJCS07nD3iFFo3VFAo3d8GLLovpY/MrC39I9ham3Bb0iebYyOvzkURG1Q3Zue0
         IzhYe4WDisVj4ru/YpYH+JKVyDHuTsZlubOOMokuCGWEfEN/OEzVHWz6SyQF3HzbXrAS
         FYAPAjYj6UqwUAzTNvxjZxRUUF4XQsqpN9g7U7SwN6VxfamvRCvX0OQlwzarCfuhMbdq
         PBjfD7Ha7ezQCfjPgHMxtR1bLXzQuB+ftPhHrEVJDXNozNbp1Lje8GC1byUetygtwNsD
         riKxMfEsEIbRtZqrXuPSYz6m2I7nBgsF7hHQaWoPXfm0zcw99/Rp2ILXASbAx8khRdr8
         klrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7Ri1xXSmL1vhifAG+FG67oYdnXRt4tXmTmiE9SRHhws=;
        b=FCK4FD9R1qgDdxF2bdyNM/lKTV9WF0K69ejy6Daanc+JqTFK7BdNtRA3i8niNPOjxP
         3dGGQ0ELLMGZrXPDxewS+K0CvarxvGWeIfep++r+2uqlFYe1xi5VK4pr8xWJyItLPtw0
         bmq/IBu40QeMbJQZ6FWO/mMJ1DkpVtG/oKh/KUGCuZ0Jd5lKH4ATGC8DHndoi6Cxo2Wk
         KAqZ/Bqpn3knaspVN2mYUCNoHBY0E/wZQ4oKVkAwh2zIPbLedAl+w0P9dseF68zPkTbP
         HAA+/HriYflOzzrktc0o0NiJKjGBN/UYy8yxOmD12aQ1yBYsQOVQfYTN7BFoN2XyygM3
         /wNQ==
X-Gm-Message-State: AOAM532h0VeTpd/6Dh7iXOFtdi6TUl8NcRdKt8Gy7cAyZ7DkZHvZfCpB
        6VG03N4EaO5jWCN3S6y7ZTw=
X-Google-Smtp-Source: ABdhPJzRAgZAwRsiCvAEl5KnCFlHK+wMf97xHI298dLYFnFJMA0epYn4YrpWSeWYacHGukleCVAgVg==
X-Received: by 2002:a17:906:f259:: with SMTP id gy25mr2352805ejb.330.1613039561878;
        Thu, 11 Feb 2021 02:32:41 -0800 (PST)
Received: from localhost.localdomain (212-39-89-223.ip.btc-net.bg. [212.39.89.223])
        by smtp.gmail.com with ESMTPSA id bd27sm3514031edb.37.2021.02.11.02.32.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 02:32:41 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 21/27] kernel-shark: Update KsSession
Date:   Thu, 11 Feb 2021 12:31:59 +0200
Message-Id: <20210211103205.418588-22-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211103205.418588-1-y.karadz@gmail.com>
References: <20210211103205.418588-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The compilation KsSession.cpp is re-enabled and all functionalities
are made compatible with the new version of the C API of libkshark
(KernelShark 2.0).

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/CMakeLists.txt |   2 +-
 src/KsSession.cpp  | 415 +++++++++++++++++++++++++++------------------
 src/KsSession.hpp  |  37 ++--
 3 files changed, 269 insertions(+), 185 deletions(-)

diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 28f44fe..5ea34ed 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -83,7 +83,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND AND TT_FONT_FILE)
 
     add_library(kshark-gui  SHARED  ${ks-guiLib_hdr_moc}    KsUtils.cpp
                                                             KsModels.cpp
-#                                                             KsSession.cpp
+                                                            KsSession.cpp
                                                             KsGLWidget.cpp
                                                             KsSearchFSM.cpp
                                                             KsDualMarker.cpp
diff --git a/src/KsSession.cpp b/src/KsSession.cpp
index a581bbf..786aa3e 100644
--- a/src/KsSession.cpp
+++ b/src/KsSession.cpp
@@ -11,14 +11,13 @@
 
 // KernelShark
 #include "libkshark.h"
+#include "libkshark-tepdata.h"
 #include "KsSession.hpp"
-#include "KsMainWindow.hpp"
 
 /** Create a KsSession object. */
 KsSession::KsSession()
 {
-	_config = kshark_config_new("kshark.config.session",
-				      KS_CONFIG_JSON);
+	_config = kshark_session_config_new(KS_CONFIG_JSON);
 }
 
 /** Destroy a KsSession object. */
@@ -79,10 +78,11 @@ void KsSession::loadVisModel(KsGraphModel *model)
 }
 
 /** Save the trace data file. */
-void KsSession::saveDataFile(QString fileName)
+void KsSession::saveDataFile(QString fileName, QString dataSetName)
 {
 	kshark_config_doc *file =
 		kshark_export_trace_file(fileName.toStdString().c_str(),
+					 dataSetName.toStdString().c_str(),
 					 KS_CONFIG_JSON);
 
 	kshark_config_doc_add(_config, "Data", file);
@@ -92,54 +92,51 @@ void KsSession::saveDataFile(QString fileName)
 QString KsSession::getDataFile(kshark_context *kshark_ctx)
 {
 	kshark_config_doc *file = kshark_config_alloc(KS_CONFIG_JSON);
-	const char *file_str;
+	int sd;
 
 	if (!kshark_config_doc_get(_config, "Data", file))
 		return QString();
 
-	file_str = kshark_import_trace_file(kshark_ctx, file);
-	if (file_str)
-		return QString(file_str);
+	sd = kshark_import_trace_file(kshark_ctx, file);
+	if (sd)
+		return QString(kshark_ctx->stream[sd]->file);
 
 	return QString();
 }
 
 /**
- * @brief Save the configuration of the filters.
+ * @brief Save the configuration information for all load Data streams.
  *
  * @param kshark_ctx: Input location for context pointer.
  */
-void KsSession::saveFilters(kshark_context *kshark_ctx)
+void KsSession::saveDataStreams(kshark_context *kshark_ctx)
 {
-	kshark_config_doc *filters =
-		kshark_export_all_filters(kshark_ctx, KS_CONFIG_JSON);
-
-	kshark_config_doc_add(_config, "Filters", filters);
+	kshark_export_all_dstreams(kshark_ctx, &_config);
 }
 
 /**
- * @brief Load the configuration of the filters and filter the data.
+ * @brief Load Data streams.
  *
  * @param kshark_ctx: Input location for context pointer.
- * @param data: Input location for KsDataStore object;
+ * @param data:  Input location for KsDataStore object;
  */
-void KsSession::loadFilters(kshark_context *kshark_ctx, KsDataStore *data)
+void KsSession::loadDataStreams(kshark_context *kshark_ctx,
+				KsDataStore *data)
 {
-	kshark_config_doc *filters = kshark_config_alloc(KS_CONFIG_JSON);
-
-	if (!kshark_config_doc_get(_config, "Filters", filters))
-		return;
+	ssize_t dataSize;
 
-	kshark_import_all_filters(kshark_ctx, filters);
+	data->unregisterCPUCollections();
 
-	if (kshark_ctx->advanced_event_filter->filters)
-		data->reload();
-	else
-		kshark_filter_entries(kshark_ctx, data->rows(), data->size());
+	dataSize = kshark_import_all_dstreams(kshark_ctx,
+					      _config,
+					      data->rows_r());
+	if (dataSize < 0) {
+		data->clear();
+		return;
+	}
 
+	data->setSize(dataSize);
 	data->registerCPUCollections();
-
-	emit data->updateWidgets(data);
 }
 
 /**
@@ -152,7 +149,7 @@ void KsSession::saveTable(const KsTraceViewer &view) {
 	int64_t r = view.getTopRow();
 
 	topRow->conf_doc = json_object_new_int64(r);
-	kshark_config_doc_add(_config, "ViewTop",topRow);
+	kshark_config_doc_add(_config, "ViewTop", topRow);
 }
 
 /**
@@ -196,39 +193,6 @@ void KsSession::saveMainWindowSize(const QMainWindow &window)
 	kshark_config_doc_add(_config, "MainWindow", windowConf);
 }
 
-/**
- * @brief Load the KernelShark Main window size.
- *
- * @param window: Input location for the KsMainWindow widget.
- */
-void KsSession::loadMainWindowSize(KsMainWindow *window)
-{
-	kshark_config_doc *windowConf = kshark_config_alloc(KS_CONFIG_JSON);
-	json_object *jwindow, *jwidth, *jheight;
-	int width, height;
-
-	if (!kshark_config_doc_get(_config, "MainWindow", windowConf))
-		return;
-
-	if (_config->format == KS_CONFIG_JSON) {
-		jwindow = KS_JSON_CAST(windowConf->conf_doc);
-		if (json_object_get_type(jwindow) == json_type_string &&
-		    QString(json_object_get_string(jwindow)) == "FullScreen") {
-			window->setFullScreenMode(true);
-			return;
-		}
-
-		jwidth = json_object_array_get_idx(jwindow, 0);
-		jheight = json_object_array_get_idx(jwindow, 1);
-
-		width = json_object_get_int(jwidth);
-		height = json_object_get_int(jheight);
-
-		window->setFullScreenMode(false);
-		window->resize(width, height);
-	}
-}
-
 /**
  * @brief Save the state of the Main window spliter.
  *
@@ -269,6 +233,7 @@ void KsSession::loadSplitterSize(QSplitter *splitter)
 
 		graphSize = json_object_get_int(jgraphsize);
 		viewSize = json_object_get_int(jviewsize);
+
 		if (graphSize == 0 && viewSize == 0) {
 			/* 0/0 spliter ratio is undefined. Make it 1/1. */
 			viewSize = graphSize = 1;
@@ -282,7 +247,7 @@ void KsSession::loadSplitterSize(QSplitter *splitter)
 /** @brief Save the Color scheme used. */
 void KsSession::saveColorScheme() {
 	kshark_config_doc *colSch = kshark_config_alloc(KS_CONFIG_JSON);
-	double s = KsPlot::Color::getRainbowFrequency();
+	double s = KsPlot::Color::rainbowFrequency();
 
 	colSch->conf_doc = json_object_new_double(s);
 	kshark_config_doc_add(_config, "ColorScheme", colSch);
@@ -307,97 +272,235 @@ float KsSession::getColorScheme() {
 /**
  * @brief Save the list of the graphs plotted.
  *
- * @param glw: Input location for the KsGLWidget widget.
+ * @param kshark_ctx: Input location for context pointer.
+ * @param graphs: Input location for the KsTraceGraph widget..
  */
-void KsSession::saveGraphs(const KsGLWidget &glw)
+void KsSession::saveGraphs(kshark_context *kshark_ctx,
+			   KsTraceGraph &graphs)
 {
-	_saveCPUPlots(glw._cpuList);
-	_saveTaskPlots(glw._taskList);
+	QVector<int> streamIds = KsUtils::getStreamIdList(kshark_ctx);
+	for (auto const &sd: streamIds) {
+		_saveCPUPlots(sd, graphs.glPtr());
+		_saveTaskPlots(sd, graphs.glPtr());
+	}
+
+	_saveComboPlots(graphs.glPtr());
 }
 
 /**
  * @brief Load the list of the graphs and plot.
  *
+ * @param kshark_ctx: Input location for context pointer.
  * @param graphs: Input location for the KsTraceGraph widget.
  */
-void KsSession::loadGraphs(KsTraceGraph *graphs)
+void KsSession::loadGraphs(kshark_context *kshark_ctx,
+			   KsTraceGraph &graphs)
 {
-	graphs->cpuReDraw(_getCPUPlots());
-	graphs->taskReDraw(_getTaskPlots());
+	QVector<int> combos, streamIds;
+	int nCombos;
+
+	streamIds = KsUtils::getStreamIdList(kshark_ctx);
+	for (auto const &sd: streamIds) {
+		graphs.cpuReDraw(sd, _getCPUPlots(sd));
+		graphs.taskReDraw(sd, _getTaskPlots(sd));
+	}
+
+	combos = _getComboPlots(&nCombos);
+	if (nCombos > 0)
+		graphs.comboReDraw(nCombos, combos);
 }
 
-void KsSession::_saveCPUPlots(const QVector<int> &cpus)
+void KsSession::_savePlots(int sd, KsGLWidget *glw, bool cpu)
 {
-	kshark_config_doc *cpuPlts = kshark_config_alloc(KS_CONFIG_JSON);
-	json_object *jcpus = json_object_new_array();
+	kshark_config_doc *streamsConf = kshark_config_alloc(KS_CONFIG_JSON);
+	json_object *jallStreams, *jstream, *jstreamId, *jplots;
+	QVector<int> plotIds;
+	int nStreams;
 
-	for (int i = 0; i < cpus.count(); ++i) {
-		json_object *jcpu = json_object_new_int(cpus[i]);
-		json_object_array_put_idx(jcpus, i, jcpu);
+	if (cpu) {
+		plotIds = glw->_streamPlots[sd]._cpuList;
+	} else {
+		plotIds = glw->_streamPlots[sd]._taskList;
 	}
 
-	cpuPlts->conf_doc = jcpus;
-	kshark_config_doc_add(_config, "CPUPlots", cpuPlts);
+	if (!kshark_config_doc_get(_config, "data streams", streamsConf) ||
+	    streamsConf->format != KS_CONFIG_JSON)
+		return;
+
+	jallStreams = KS_JSON_CAST(streamsConf->conf_doc);
+	if (json_object_get_type(jallStreams) != json_type_array)
+		return;
+
+	nStreams = json_object_array_length(jallStreams);
+	for (int i = 0; i < nStreams; ++i) {
+		jstream = json_object_array_get_idx(jallStreams, i);
+		if (json_object_object_get_ex(jstream, "stream id", &jstreamId) &&
+		    json_object_get_int(jstreamId) == sd)
+			break;
+
+		jstream = nullptr;
+	}
+
+	free(streamsConf);
+	if (!jstream)
+		return;
+
+	jplots = json_object_new_array();
+	for (int i = 0; i < plotIds.count(); ++i) {
+		json_object *jcpu = json_object_new_int(plotIds[i]);
+		json_object_array_put_idx(jplots, i, jcpu);
+	}
+
+	if (cpu)
+		json_object_object_add(jstream, "CPUPlots", jplots);
+	else
+		json_object_object_add(jstream, "TaskPlots", jplots);
 }
 
-QVector<int> KsSession::_getCPUPlots()
+void KsSession::_saveCPUPlots(int sd, KsGLWidget *glw)
 {
-	kshark_config_doc *cpuPlts = kshark_config_alloc(KS_CONFIG_JSON);
-	json_object *jcpus;
-	QVector<int> cpus;
-	size_t length;
+	_savePlots(sd, glw, true);
+}
 
-	if (!kshark_config_doc_get(_config, "CPUPlots", cpuPlts))
-		return cpus;
+void KsSession::_saveTaskPlots(int sd, KsGLWidget *glw)
+{
+	_savePlots(sd, glw, false);
+}
 
-	if (_config->format == KS_CONFIG_JSON) {
-		jcpus = KS_JSON_CAST(cpuPlts->conf_doc);
-		length = json_object_array_length(jcpus);
-		for (size_t i = 0; i < length; ++i) {
-			int cpu = json_object_get_int(json_object_array_get_idx(jcpus,
-										i));
-			cpus.append(cpu);
+void KsSession::_saveComboPlots(KsGLWidget *glw)
+{
+	kshark_config_doc *combos = kshark_config_alloc(KS_CONFIG_JSON);
+	json_object *jcombos, *jplots, *jplt;
+	int var;
+
+	jcombos = json_object_new_array();
+	for (auto const &c: glw->_comboPlots) {
+		jplots = json_object_new_array();
+		for (auto const &p: c) {
+			jplt = json_object_new_array();
+			var = p._streamId;
+			json_object_array_put_idx(jplt, 0,
+						  json_object_new_int(var));
+
+			var = p._type;
+			json_object_array_put_idx(jplt, 1,
+						  json_object_new_int(var));
+
+			var = p._id;
+			json_object_array_put_idx(jplt, 2,
+						  json_object_new_int(var));
+
+			json_object_array_add(jplots, jplt);
 		}
+
+		json_object_array_add(jcombos, jplots);
 	}
 
-	return cpus;
+	combos->conf_doc = jcombos;
+	kshark_config_doc_add(_config, "ComboPlots", combos);
 }
 
-void KsSession::_saveTaskPlots(const QVector<int> &tasks)
+QVector<int> KsSession::_getPlots(int sd, bool cpu)
 {
-	kshark_config_doc *taskPlts = kshark_config_alloc(KS_CONFIG_JSON);
-	json_object *jtasks = json_object_new_array();
+	kshark_config_doc *streamsConf = kshark_config_alloc(KS_CONFIG_JSON);
+	json_object *jallStreams, *jstream, *jstreamId, *jplots;
+	int nStreams, nPlots, id;
+	const char *plotKey;
+	QVector<int> plots;
+
+	if (!kshark_config_doc_get(_config, "data streams", streamsConf) ||
+	    streamsConf->format != KS_CONFIG_JSON)
+		return plots;
+
+	jallStreams = KS_JSON_CAST(streamsConf->conf_doc);
+	if (json_object_get_type(jallStreams) != json_type_array)
+		return plots;
+
+	nStreams = json_object_array_length(jallStreams);
+	for (int i = 0; i < nStreams; ++i) {
+		jstream = json_object_array_get_idx(jallStreams, i);
+		if (json_object_object_get_ex(jstream, "stream id", &jstreamId) &&
+		    json_object_get_int(jstreamId) == sd)
+			break;
+
+		jstream = nullptr;
+	}
+
+	if (!jstream)
+		return plots;
+
+	if (cpu)
+		plotKey = "CPUPlots";
+	else
+		plotKey = "TaskPlots";
 
-	for (int i = 0; i < tasks.count(); ++i) {
-		json_object *jtask = json_object_new_int(tasks[i]);
-		json_object_array_put_idx(jtasks, i, jtask);
+	if (!json_object_object_get_ex(jstream, plotKey, &jplots) ||
+	    json_object_get_type(jplots) != json_type_array)
+		return plots;
+
+	nPlots = json_object_array_length(jplots);
+	for (int i = 0; i < nPlots; ++i) {
+		id = json_object_get_int(json_object_array_get_idx(jplots, i));
+		plots.append(id);
 	}
 
-	taskPlts->conf_doc = jtasks;
-	kshark_config_doc_add(_config, "TaskPlots", taskPlts);
+	return plots;
+}
+
+QVector<int> KsSession::_getCPUPlots(int sd)
+{
+	return _getPlots(sd, true);
+}
+
+QVector<int> KsSession::_getTaskPlots(int sd)
+{
+	return _getPlots(sd, false);
 }
 
-QVector<int> KsSession::_getTaskPlots()
+QVector<int> KsSession::_getComboPlots(int *n)
 {
-	kshark_config_doc *taskPlts = kshark_config_alloc(KS_CONFIG_JSON);
-	json_object *jtasks;
-	QVector<int> tasks;
-	size_t length;
+	kshark_config_doc *combos = kshark_config_alloc(KS_CONFIG_JSON);
+	int nCombos, nPlots, sd, type, id;
+	json_object *jcombos, *jplots, *jplt, *jvar;
+	QVector<int> vec;
 
-	if (!kshark_config_doc_get(_config, "TaskPlots", taskPlts))
-		return tasks;
+	*n = 0;
+	if (!kshark_config_doc_get(_config, "ComboPlots", combos))
+		return {};
 
 	if (_config->format == KS_CONFIG_JSON) {
-		jtasks = KS_JSON_CAST(taskPlts->conf_doc);
-		length = json_object_array_length(jtasks);
-		for (size_t i = 0; i < length; ++i) {
-			int pid = json_object_get_int(json_object_array_get_idx(jtasks,
-										i));
-			tasks.append(pid);
+		jcombos = KS_JSON_CAST(combos->conf_doc);
+		if (json_object_get_type(jcombos) != json_type_array)
+			return {};
+
+		*n = nCombos = json_object_array_length(jcombos);
+		for (int i = 0; i < nCombos; ++i) {
+			jplots = json_object_array_get_idx(jcombos, i);
+			if (json_object_get_type(jplots) != json_type_array)
+				return {};
+
+			nPlots =  json_object_array_length(jplots);
+			vec.append(nPlots);
+			for (int j = 0; j < nPlots; ++j) {
+				jplt = json_object_array_get_idx(jplots, j);
+				if (json_object_get_type(jplt) != json_type_array)
+					return {};
+
+				jvar = json_object_array_get_idx(jplt, 0);
+				sd = json_object_get_int(jvar);
+
+				jvar = json_object_array_get_idx(jplt, 1);
+				type = json_object_get_int(jvar);
+
+				jvar = json_object_array_get_idx(jplt, 2);
+				id = json_object_get_int(jvar);
+
+				vec.append({sd, type, id});
+			}
 		}
 	}
 
-	return tasks;
+	return vec;
 }
 
 /**
@@ -407,7 +510,7 @@ QVector<int> KsSession::_getTaskPlots()
  */
 void KsSession::saveDualMarker(KsDualMarkerSM *dm)
 {
-	struct kshark_config_doc *markers =
+	kshark_config_doc *markers =
 		kshark_config_new("kshark.config.markers", KS_CONFIG_JSON);
 	json_object *jd_mark = KS_JSON_CAST(markers->conf_doc);
 
@@ -450,7 +553,7 @@ void KsSession::saveDualMarker(KsDualMarkerSM *dm)
  */
 void KsSession::loadDualMarker(KsDualMarkerSM *dm, KsTraceGraph *graphs)
 {
-	size_t pos;
+	uint64_t pos;
 
 	dm->reset();
 	dm->setState(DualMarkerState::A);
@@ -476,7 +579,7 @@ void KsSession::loadDualMarker(KsDualMarkerSM *dm, KsTraceGraph *graphs)
 
 json_object *KsSession::_getMarkerJson()
 {
-	struct kshark_config_doc *markers =
+	kshark_config_doc *markers =
 		kshark_config_alloc(KS_CONFIG_JSON);
 
 	if (!kshark_config_doc_get(_config, "Markers", markers) ||
@@ -529,33 +632,23 @@ DualMarkerState KsSession::_getMarkerState()
  *
  * @param pm: Input location for the KsPluginManager object.
  */
-void KsSession::savePlugins(const KsPluginManager &pm)
+void KsSession::saveUserPlugins(const KsPluginManager &pm)
 {
-	struct kshark_config_doc *plugins =
+	kshark_config_doc *plugins =
 		kshark_config_new("kshark.config.plugins", KS_CONFIG_JSON);
 	json_object *jplugins = KS_JSON_CAST(plugins->conf_doc);
-	const QVector<bool> &registeredPlugins = pm._registeredKsPlugins;
-	const QStringList &pluginList = pm._ksPluginList;
-	int nPlugins = pluginList.length();
-	json_object *jlist, *jpl;
-	QByteArray array;
-	char* buffer;
-	bool active;
-
-	jlist = json_object_new_array();
-	for (int i = 0; i < nPlugins; ++i) {
-		array = pluginList[i].toLocal8Bit();
-		buffer = array.data();
-		jpl = json_object_new_array();
-		json_object_array_put_idx(jpl, 0, json_object_new_string(buffer));
-
-		active = registeredPlugins[i];
-		json_object_array_put_idx(jpl, 1, json_object_new_boolean(active));
-		json_object_array_put_idx(jlist, i, jpl);
+	json_object *jplg, *jlist = json_object_new_array();
+
+	for (auto const p: pm.getUserPlugins()) {
+		kshark_config_doc *lib =
+			kshark_export_plugin_file(p, KS_CONFIG_JSON);
+		jplg = KS_JSON_CAST(lib->conf_doc);
+		json_object_array_add(jlist, jplg);
+		free(lib);
 	}
 
-	json_object_object_add(jplugins, "Plugin List", jlist);
-	kshark_config_doc_add(_config, "Plugins", plugins);
+	json_object_object_add(jplugins, "obj. files", jlist);
+	kshark_config_doc_add(_config, "User Plugins", plugins);
 }
 
 /**
@@ -564,37 +657,21 @@ void KsSession::savePlugins(const KsPluginManager &pm)
  * @param kshark_ctx: Input location for context pointer.
  * @param pm: Input location for the KsPluginManager object.
  */
-void KsSession::loadPlugins(kshark_context *kshark_ctx, KsPluginManager *pm)
+void KsSession::loadUserPlugins(kshark_context *kshark_ctx, KsPluginManager *pm)
 {
-	kshark_config_doc *plugins = kshark_config_alloc(KS_CONFIG_JSON);
-	json_object *jplugins, *jlist, *jpl;
-	const char *pluginName;
-	QVector<int> pluginIds;
-	int length, index;
-	bool loaded;
-
-	if (!kshark_config_doc_get(_config, "Plugins", plugins) ||
-	    !kshark_type_check(plugins, "kshark.config.plugins"))
+	kshark_config_doc *plugins =
+		kshark_config_alloc(KS_CONFIG_JSON);
+	kshark_plugin_list *list, **last;
+
+	if (!kshark_config_doc_get(_config, "User Plugins", plugins))
 		return;
 
-	if (plugins->format == KS_CONFIG_JSON) {
-		jplugins = KS_JSON_CAST(plugins->conf_doc);
-		json_object_object_get_ex(jplugins, "Plugin List", &jlist);
-		if (!jlist ||
-	            json_object_get_type(jlist) != json_type_array ||
-		    !json_object_array_length(jlist))
-			return;
-
-		length = json_object_array_length(jlist);
-		for (int i = 0; i < length; ++i) {
-			jpl = json_object_array_get_idx(jlist, i);
-			pluginName = json_object_get_string(json_object_array_get_idx(jpl, 0));
-			index = pm->_ksPluginList.indexOf(pluginName);
-			loaded = json_object_get_boolean(json_object_array_get_idx(jpl, 1));
-			if (index >= 0 && loaded)
-				pluginIds.append(index);
-		}
-	}
+	/* Get the list of already loaded plugins. */
+	list = kshark_ctx->plugins;
+
+	kshark_import_all_plugins(kshark_ctx, plugins);
 
-	pm->updatePlugins(pluginIds);
+	/* Loop until the beginning of the old list. */
+	for (last = &kshark_ctx->plugins; *last != list; last = &(*last)->next)
+		pm->addUserPluginToList(*last);
 }
diff --git a/src/KsSession.hpp b/src/KsSession.hpp
index b07c810..e1b7fd4 100644
--- a/src/KsSession.hpp
+++ b/src/KsSession.hpp
@@ -20,8 +20,6 @@
 #include "KsTraceGraph.hpp"
 #include "KsTraceViewer.hpp"
 
-class KsMainWindow;
-
 /**
  * The KsSession class provides instruments for importing/exporting the state
  * of the different components of the GUI from/to Json documents. These
@@ -41,7 +39,7 @@ public:
 
 	void exportToFile(QString jfileName);
 
-	void saveDataFile(QString fileName);
+	void saveDataFile(QString fileName, QString dataSetName);
 
 	QString getDataFile(kshark_context *kshark_ctx);
 
@@ -49,18 +47,19 @@ public:
 
 	void loadVisModel(KsGraphModel *model);
 
-	void saveGraphs(const KsGLWidget &glw);
+	void saveGraphs(kshark_context *kshark_ctx,
+			KsTraceGraph &graphs);
 
-	void loadGraphs(KsTraceGraph *graphs);
+	void loadGraphs(kshark_context *kshark_ctx,
+			KsTraceGraph &graphs);
 
-	void saveFilters(kshark_context *kshark_ctx);
+	void saveDataStreams(kshark_context *kshark_ctx);
 
-	void loadFilters(kshark_context *kshark_ctx, KsDataStore *data);
+	void loadDataStreams(kshark_context *kshark_ctx,
+			     KsDataStore *data);
 
 	void saveMainWindowSize(const QMainWindow &window);
 
-	void loadMainWindowSize(KsMainWindow *window);
-
 	void saveSplitterSize(const QSplitter &splitter);
 
 	void loadSplitterSize(QSplitter *splitter);
@@ -69,9 +68,9 @@ public:
 
 	void loadDualMarker(KsDualMarkerSM *dmm, KsTraceGraph *graphs);
 
-	void savePlugins(const KsPluginManager &pm);
+	void saveUserPlugins(const KsPluginManager &pm);
 
-	void loadPlugins(kshark_context *kshark_ctx, KsPluginManager *pm);
+	void loadUserPlugins(kshark_context *kshark_ctx, KsPluginManager *pm);
 
 	void saveTable(const KsTraceViewer &view);
 
@@ -86,13 +85,21 @@ private:
 
 	json_object *_getMarkerJson();
 
-	void _saveCPUPlots(const QVector<int> &cpus);
+	void _savePlots(int sd, KsGLWidget *glw, bool cpu);
+
+	QVector<int> _getPlots(int sd, bool cpu);
+
+	void _saveCPUPlots(int sd, KsGLWidget *glw);
+
+	QVector<int> _getCPUPlots(int sd);
+
+	void _saveTaskPlots(int sd, KsGLWidget *glw);
 
-	QVector<int> _getCPUPlots();
+	QVector<int> _getTaskPlots(int sd);
 
-	void _saveTaskPlots(const QVector<int> &tasks);
+	void _saveComboPlots(KsGLWidget *glw);
 
-	QVector<int> _getTaskPlots();
+	QVector<int> _getComboPlots(int *nCombos);
 
 	bool _getMarker(const char* name, size_t *pos);
 
-- 
2.25.1


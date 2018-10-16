Return-Path: <SRS0=XQBu=M4=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr710064.outbound.protection.outlook.com ([40.107.71.64]:54000
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726778AbeJPXo0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Oct 2018 19:44:26 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>,
        Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH v2 09/23] kernel-shark-qt: Add a manager class for GUI
 sessions.
Date: Tue, 16 Oct 2018 15:53:07 +0000
Message-ID: <20181016155232.5257-10-ykaradzhov@vmware.com>
References: <20181016155232.5257-1-ykaradzhov@vmware.com>
In-Reply-To: <20181016155232.5257-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: Yordan Karadzhov (VMware) <y.karadz@gmail.com>

The KsSession class provides instruments for importing/exporting
the state of the different components of the GUI from/to Json
documents. These instruments are used to save/load user session
in the GUI.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/src/CMakeLists.txt |   1 +
 kernel-shark-qt/src/KsSession.cpp  | 574 +++++++++++++++++++++++++++++
 kernel-shark-qt/src/KsSession.hpp  | 100 +++++
 3 files changed, 675 insertions(+)
 create mode 100644 kernel-shark-qt/src/KsSession.cpp
 create mode 100644 kernel-shark-qt/src/KsSession.hpp

diff --git a/kernel-shark-qt/src/CMakeLists.txt b/kernel-shark-qt/src/CMake=
Lists.txt
index 26b45f4..192cd12 100644
--- a/kernel-shark-qt/src/CMakeLists.txt
+++ b/kernel-shark-qt/src/CMakeLists.txt
@@ -44,6 +44,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
=20
     add_library(kshark-gui  SHARED  ${ks-guiLib_hdr_moc}    KsUtils.cpp
                                                             KsModels.cpp
+                                                            KsSession.cpp
                                                             KsGLWidget.cpp
                                                             KsDualMarker.c=
pp
                                                             KsWidgetsLib.c=
pp
diff --git a/kernel-shark-qt/src/KsSession.cpp b/kernel-shark-qt/src/KsSess=
ion.cpp
new file mode 100644
index 0000000..96e09f2
--- /dev/null
+++ b/kernel-shark-qt/src/KsSession.cpp
@@ -0,0 +1,574 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
+ */
+
+/**
+ *  @file    KsSession.cpp
+ *  @brief   KernelShark Session.
+ */
+
+// KernelShark
+#include "libkshark.h"
+#include "KsSession.hpp"
+
+/** Create a KsSession object. */
+KsSession::KsSession()
+{
+	_config =3D kshark_config_new("kshark.config.session",
+				      KS_CONFIG_JSON);
+}
+
+/** Destroy a KsSession object. */
+KsSession::~KsSession()
+{
+	kshark_free_config_doc(_config);
+}
+
+/** Import a user session from a Json file. */
+void KsSession::importFromFile(QString jfileName)
+{
+	if (_config)
+		kshark_free_config_doc(_config);
+
+	_config =3D kshark_open_config_file(jfileName.toStdString().c_str(),
+					  "kshark.config.session");
+}
+
+/** Export the current user session from a Json file. */
+void KsSession::exportToFile(QString jfileName)
+{
+	kshark_save_config_file(jfileName.toStdString().c_str(), _config);
+}
+
+/**
+ * @brief Save the state of the visualization model.
+ *
+ * @param histo: Input location for the model descriptor.
+ */
+void KsSession::saveVisModel(kshark_trace_histo *histo)
+{
+	kshark_config_doc *model =3D
+		kshark_export_model(histo, KS_CONFIG_JSON);
+
+	kshark_config_doc_add(_config, "Model", model);
+}
+
+/**
+ * @brief Load the state of the visualization model.
+ *
+ * @param model: Input location for the KsGraphModel object.
+ */
+void KsSession::loadVisModel(KsGraphModel *model)
+{
+	kshark_config_doc *modelConf =3D kshark_config_alloc(KS_CONFIG_JSON);
+
+	if (!kshark_config_doc_get(_config, "Model", modelConf))
+		return;
+
+	kshark_import_model(model->histo(), modelConf);
+	model->update();
+}
+
+/** Save the trace data file. */
+void KsSession::saveDataFile(QString fileName)
+{
+	kshark_config_doc *file =3D
+		kshark_export_trace_file(fileName.toStdString().c_str(),
+					 KS_CONFIG_JSON);
+
+	kshark_config_doc_add(_config, "Data", file);
+}
+
+/** Get the trace data file. */
+QString KsSession::getDataFile(kshark_context *kshark_ctx)
+{
+	kshark_config_doc *file =3D kshark_config_alloc(KS_CONFIG_JSON);
+	const char *file_str;
+
+	if (!kshark_config_doc_get(_config, "Data", file))
+		return QString();
+
+	file_str =3D kshark_import_trace_file(kshark_ctx, file);
+	if (file_str)
+		return QString(file_str);
+
+	return QString();
+}
+
+/**
+ * @brief Save the configuration of the filters.
+ *
+ * @param kshark_ctx: Input location for context pointer.
+ */
+void KsSession::saveFilters(kshark_context *kshark_ctx)
+{
+	kshark_config_doc *filters =3D
+		kshark_export_all_filters(kshark_ctx, KS_CONFIG_JSON);
+
+	kshark_config_doc_add(_config, "Filters", filters);
+}
+
+/**
+ * @brief Load the configuration of the filters and filter the data.
+ *
+ * @param kshark_ctx: Input location for context pointer.
+ * @param data: Input location for KsDataStore object;
+ */
+void KsSession::loadFilters(kshark_context *kshark_ctx, KsDataStore *data)
+{
+	kshark_config_doc *filters =3D kshark_config_alloc(KS_CONFIG_JSON);
+
+	if (!kshark_config_doc_get(_config, "Filters", filters))
+		return;
+
+	kshark_import_all_filters(kshark_ctx, filters);
+
+	if (kshark_ctx->advanced_event_filter->filters)
+		data->reload();
+	else
+		kshark_filter_entries(kshark_ctx, data->rows(), data->size());
+
+	data->registerCPUCollections();
+
+	emit data->updateWidgets(data);
+}
+
+/**
+ * @brief Save the state of the table.
+ *
+ * @param view: Input location for the KsTraceViewer widget.
+ */
+void KsSession::saveTable(const KsTraceViewer &view) {
+	kshark_config_doc *topRow =3D kshark_config_alloc(KS_CONFIG_JSON);
+	int64_t r =3D view.getTopRow();
+
+	topRow->conf_doc =3D json_object_new_int64(r);
+	kshark_config_doc_add(_config, "ViewTop",topRow);
+}
+
+/**
+ * @brief Load the state of the table.
+ *
+ * @param view: Input location for the KsTraceViewer widget.
+ */
+void KsSession::loadTable(KsTraceViewer *view) {
+	kshark_config_doc *topRow =3D kshark_config_alloc(KS_CONFIG_JSON);
+	size_t r =3D 0;
+
+	if (!kshark_config_doc_get(_config, "ViewTop", topRow))
+		return;
+
+	if (_config->format =3D=3D KS_CONFIG_JSON)
+		r =3D json_object_get_int64(KS_JSON_CAST(topRow->conf_doc));
+
+	view->setTopRow(r);
+}
+
+/**
+ * @brief Save the KernelShark Main window size.
+ *
+ * @param window: Input location for the KsMainWindow widget.
+ */
+void KsSession::saveMainWindowSize(const QMainWindow &window)
+{
+	kshark_config_doc *windowConf =3D kshark_config_alloc(KS_CONFIG_JSON);
+	int width =3D window.width(), height =3D window.height();
+	json_object *jwindow =3D json_object_new_array();
+
+	json_object_array_put_idx(jwindow, 0, json_object_new_int(width));
+	json_object_array_put_idx(jwindow, 1, json_object_new_int(height));
+
+	windowConf->conf_doc =3D jwindow;
+	kshark_config_doc_add(_config, "MainWindow", windowConf);
+}
+
+/**
+ * @brief Load the KernelShark Main window size.
+ *
+ * @param window: Input location for the KsMainWindow widget.
+ */
+void KsSession::loadMainWindowSize(QMainWindow *window)
+{
+	kshark_config_doc *windowConf =3D kshark_config_alloc(KS_CONFIG_JSON);
+	json_object *jwindow, *jwidth, *jheight;
+	int width, height;
+
+	if (!kshark_config_doc_get(_config, "MainWindow", windowConf))
+		return;
+
+	if (_config->format =3D=3D KS_CONFIG_JSON) {
+		jwindow =3D KS_JSON_CAST(windowConf->conf_doc);
+		jwidth =3D json_object_array_get_idx(jwindow, 0);
+		jheight =3D json_object_array_get_idx(jwindow, 1);
+
+		width =3D json_object_get_int(jwidth);
+		height =3D json_object_get_int(jheight);
+
+		window->resize(width, height);
+	}
+}
+
+/**
+ * @brief Save the state of the Main window spliter.
+ *
+ * @param splitter: Input location for the splitter widget.
+ */
+void KsSession::saveSplitterSize(const QSplitter &splitter)
+{
+	kshark_config_doc *spl =3D kshark_config_alloc(KS_CONFIG_JSON);
+	json_object *jspl =3D json_object_new_array();
+	QList<int> sizes =3D splitter.sizes();
+
+	json_object_array_put_idx(jspl, 0, json_object_new_int(sizes[0]));
+	json_object_array_put_idx(jspl, 1, json_object_new_int(sizes[1]));
+
+	spl->conf_doc =3D jspl;
+	kshark_config_doc_add(_config, "Splitter", spl);
+}
+
+/**
+ * @brief Load the state of the Main window spliter.
+ *
+ * @param splitter: Input location for the splitter widget.
+ */
+void KsSession::loadSplitterSize(QSplitter *splitter)
+{
+	kshark_config_doc *spl =3D kshark_config_alloc(KS_CONFIG_JSON);
+	json_object *jspl, *jgraphsize, *jviewsize;
+	int graphSize, viewSize;
+	QList<int> sizes;
+
+	if (!kshark_config_doc_get(_config, "Splitter", spl))
+		return;
+
+	if (_config->format =3D=3D KS_CONFIG_JSON) {
+		jspl =3D KS_JSON_CAST(spl->conf_doc);
+		jgraphsize =3D json_object_array_get_idx(jspl, 0);
+		jviewsize =3D json_object_array_get_idx(jspl, 1);
+
+		graphSize =3D json_object_get_int(jgraphsize);
+		viewSize =3D json_object_get_int(jviewsize);
+	}
+
+	sizes << graphSize << viewSize;
+	splitter->setSizes(sizes);
+}
+
+/** @brief Save the Color scheme used. */
+void KsSession::saveColorScheme() {
+	kshark_config_doc *colSch =3D kshark_config_alloc(KS_CONFIG_JSON);
+	double s =3D KsPlot::Color::getRainbowFrequency();
+
+	colSch->conf_doc =3D json_object_new_double(s);
+	kshark_config_doc_add(_config, "ColorScheme", colSch);
+}
+
+/** @brief Get the Color scheme used. */
+float KsSession::getColorScheme() {
+	kshark_config_doc *colSch =3D kshark_config_alloc(KS_CONFIG_JSON);
+
+	/* Default color scheme. */
+	float s =3D 0.75;
+
+	if (!kshark_config_doc_get(_config, "ColorScheme", colSch))
+		return s;
+
+	if (_config->format =3D=3D KS_CONFIG_JSON)
+		s =3D json_object_get_double(KS_JSON_CAST(colSch->conf_doc));
+
+	return s;
+}
+
+/**
+ * @brief Save the list of the graphs plotted.
+ *
+ * @param glw: Input location for the KsGLWidget widget.
+ */
+void KsSession::saveGraphs(const KsGLWidget &glw)
+{
+	_saveCPUPlots(glw._cpuList);
+	_saveTaskPlots(glw._taskList);
+}
+
+/**
+ * @brief Load the list of the graphs and plot.
+ *
+ * @param graphs: Input location for the KsTraceGraph widget.
+ */
+void KsSession::loadGraphs(KsTraceGraph *graphs)
+{
+	graphs->cpuReDraw(_getCPUPlots());
+	graphs->taskReDraw(_getTaskPlots());
+}
+
+void KsSession::_saveCPUPlots(const QVector<int> &cpus)
+{
+	kshark_config_doc *cpuPlts =3D kshark_config_alloc(KS_CONFIG_JSON);
+	json_object *jcpus =3D json_object_new_array();
+
+	for (int i =3D 0; i < cpus.count(); ++i) {
+		json_object *jcpu =3D json_object_new_int(cpus[i]);
+		json_object_array_put_idx(jcpus, i, jcpu);
+	}
+
+	cpuPlts->conf_doc =3D jcpus;
+	kshark_config_doc_add(_config, "CPUPlots", cpuPlts);
+}
+
+QVector<int> KsSession::_getCPUPlots()
+{
+	kshark_config_doc *cpuPlts =3D kshark_config_alloc(KS_CONFIG_JSON);
+	json_object *jcpus;
+	QVector<int> cpus;
+	size_t length;
+
+	if (!kshark_config_doc_get(_config, "CPUPlots", cpuPlts))
+		return cpus;
+
+	if (_config->format =3D=3D KS_CONFIG_JSON) {
+		jcpus =3D KS_JSON_CAST(cpuPlts->conf_doc);
+		length =3D json_object_array_length(jcpus);
+		for (size_t i =3D 0; i < length; ++i) {
+			int cpu =3D json_object_get_int(json_object_array_get_idx(jcpus,
+										i));
+			cpus.append(cpu);
+		}
+	}
+
+	return cpus;
+}
+
+void KsSession::_saveTaskPlots(const QVector<int> &tasks)
+{
+	kshark_config_doc *taskPlts =3D kshark_config_alloc(KS_CONFIG_JSON);
+	json_object *jtasks =3D json_object_new_array();
+
+	for (int i =3D 0; i < tasks.count(); ++i) {
+		json_object *jtask =3D json_object_new_int(tasks[i]);
+		json_object_array_put_idx(jtasks, i, jtask);
+	}
+
+	taskPlts->conf_doc =3D jtasks;
+	kshark_config_doc_add(_config, "TaskPlots", taskPlts);
+}
+
+QVector<int> KsSession::_getTaskPlots()
+{
+	kshark_config_doc *taskPlts =3D kshark_config_alloc(KS_CONFIG_JSON);
+	json_object *jtasks;
+	QVector<int> tasks;
+	size_t length;
+
+	if (!kshark_config_doc_get(_config, "TaskPlots", taskPlts))
+		return tasks;
+
+	if (_config->format =3D=3D KS_CONFIG_JSON) {
+		jtasks =3D KS_JSON_CAST(taskPlts->conf_doc);
+		length =3D json_object_array_length(jtasks);
+		for (size_t i =3D 0; i < length; ++i) {
+			int pid =3D json_object_get_int(json_object_array_get_idx(jtasks,
+										i));
+			tasks.append(pid);
+		}
+	}
+
+	return tasks;
+}
+
+/**
+ * @brief Save the state of the Dual marker.
+ *
+ * @param dm: Input location for the KsDualMarkerSM object.
+ */
+void KsSession::saveDualMarker(KsDualMarkerSM *dm)
+{
+	struct kshark_config_doc *markers =3D
+		kshark_config_new("kshark.config.markers", KS_CONFIG_JSON);
+	json_object *jd_mark =3D KS_JSON_CAST(markers->conf_doc);
+
+	auto save_mark =3D [&jd_mark] (KsGraphMark *m, const char *name)
+	{
+		json_object *jmark =3D json_object_new_object();
+
+		if (m->_isSet) {
+			json_object_object_add(jmark, "isSet",
+					       json_object_new_boolean(true));
+
+			json_object_object_add(jmark, "row",
+					       json_object_new_int(m->_pos));
+		} else {
+			json_object_object_add(jmark, "isSet",
+					       json_object_new_boolean(false));
+		}
+
+		json_object_object_add(jd_mark, name, jmark);
+	};
+
+	save_mark(&dm->markerA(), "markA");
+	save_mark(&dm->markerB(), "markB");
+
+	if (dm->getState() =3D=3D DualMarkerState::A)
+		json_object_object_add(jd_mark, "Active",
+				       json_object_new_string("A"));
+	else
+		json_object_object_add(jd_mark, "Active",
+				       json_object_new_string("B"));
+
+	kshark_config_doc_add(_config, "Markers", markers);
+}
+
+/**
+ * @brief Load the state of the Dual marker.
+ *
+ * @param dm: Input location for the KsDualMarkerSM object.
+ * @param graphs: Input location for the KsTraceGraph widget.
+ */
+void KsSession::loadDualMarker(KsDualMarkerSM *dm, KsTraceGraph *graphs)
+{
+	uint64_t pos;
+
+	dm->reset();
+	dm->setState(DualMarkerState::A);
+
+	if (_getMarker("markA", &pos)) {
+		graphs->markEntry(pos);
+	} else {
+		dm->markerA().remove();
+	}
+
+	dm->setState(DualMarkerState::B);
+	if (_getMarker("markB", &pos)) {
+		graphs->markEntry(pos);
+	} else {
+		dm->markerB().remove();
+	}
+
+	dm->setState(_getMarkerState());
+	pos =3D dm->activeMarker()._pos;
+
+	emit graphs->glPtr()->updateView(pos, true);
+}
+
+json_object *KsSession::_getMarkerJson()
+{
+	struct kshark_config_doc *markers =3D
+		kshark_config_alloc(KS_CONFIG_JSON);
+
+	if (!kshark_config_doc_get(_config, "Markers", markers) ||
+	    !kshark_type_check(markers, "kshark.config.markers"))
+		return nullptr;
+
+	return KS_JSON_CAST(markers->conf_doc);
+}
+
+bool KsSession::_getMarker(const char* name, size_t *pos)
+{
+	json_object *jd_mark, *jmark;
+
+	*pos =3D 0;
+	jd_mark =3D _getMarkerJson();
+	if (!jd_mark)
+		return false;
+
+	if (json_object_object_get_ex(jd_mark, name, &jmark)) {
+		json_object *jis_set;
+		json_object_object_get_ex(jmark, "isSet", &jis_set);
+		if (!json_object_get_boolean(jis_set))
+			return false;
+
+		json_object *jpos;
+		json_object_object_get_ex(jmark, "row", &jpos);
+		*pos =3D json_object_get_int64(jpos);
+	}
+
+	return true;
+}
+
+DualMarkerState KsSession::_getMarkerState()
+{
+	json_object *jd_mark, *jstate;
+	const char* state;
+
+	jd_mark =3D _getMarkerJson();
+	json_object_object_get_ex(jd_mark, "Active", &jstate);
+	state =3D json_object_get_string(jstate);
+
+	if (strcmp(state, "A") =3D=3D 0)
+		return DualMarkerState::A;
+
+	return DualMarkerState::B;
+}
+
+/**
+ * @brief Save the configuration of the plugins.
+ *
+ * @param pm: Input location for the KsPluginManager object.
+ */
+void KsSession::savePlugins(const KsPluginManager &pm)
+{
+	struct kshark_config_doc *plugins =3D
+		kshark_config_new("kshark.config.plugins", KS_CONFIG_JSON);
+	json_object *jplugins =3D KS_JSON_CAST(plugins->conf_doc);
+	const QVector<bool> &registeredPlugins =3D pm._registeredKsPlugins;
+	const QStringList &pluginList =3D pm._ksPluginList;
+	int nPlugins =3D pluginList.length();
+	json_object *jlist, *jpl;
+	QByteArray array;
+	char* buffer;
+	bool active;
+
+	jlist =3D json_object_new_array();
+	for (int i =3D 0; i < nPlugins; ++i) {
+		array =3D pluginList[i].toLocal8Bit();
+		buffer =3D array.data();
+		jpl =3D json_object_new_array();
+		json_object_array_put_idx(jpl, 0, json_object_new_string(buffer));
+
+		active =3D registeredPlugins[i];
+		json_object_array_put_idx(jpl, 1, json_object_new_boolean(active));
+		json_object_array_put_idx(jlist, i, jpl);
+	}
+
+	json_object_object_add(jplugins, "Plugin List", jlist);
+	kshark_config_doc_add(_config, "Plugins", plugins);
+}
+
+/**
+ * @brief Load the configuration of the plugins.
+ *
+ * @param kshark_ctx: Input location for context pointer.
+ * @param pm: Input location for the KsPluginManager object.
+ */
+void KsSession::loadPlugins(kshark_context *kshark_ctx, KsPluginManager *p=
m)
+{
+	kshark_config_doc *plugins =3D kshark_config_alloc(KS_CONFIG_JSON);
+	json_object *jplugins, *jlist, *jpl;
+	int length;
+
+	if (!kshark_config_doc_get(_config, "Plugins", plugins) ||
+	    !kshark_type_check(plugins, "kshark.config.plugins"))
+		return;
+
+	if (plugins->format =3D=3D KS_CONFIG_JSON) {
+		jplugins =3D KS_JSON_CAST(plugins->conf_doc);
+		json_object_object_get_ex(jplugins, "Plugin List", &jlist);
+		if (!jlist ||
+	            json_object_get_type(jlist) !=3D json_type_array ||
+		    !json_object_array_length(jlist))
+			return;
+
+		length =3D json_object_array_length(jlist);
+		for (int i =3D 0; i < length; ++i) {
+			jpl =3D json_object_array_get_idx(jlist, i);
+			pm->_ksPluginList[i] =3D
+				json_object_get_string(json_object_array_get_idx(jpl, 0));
+
+			pm->_registeredKsPlugins[i] =3D
+				json_object_get_boolean(json_object_array_get_idx(jpl, 1));
+		}
+	}
+
+	pm->registerFromList(kshark_ctx);
+}
diff --git a/kernel-shark-qt/src/KsSession.hpp b/kernel-shark-qt/src/KsSess=
ion.hpp
new file mode 100644
index 0000000..4f5a2c4
--- /dev/null
+++ b/kernel-shark-qt/src/KsSession.hpp
@@ -0,0 +1,100 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+
+/*
+ * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
+ */
+
+/**
+ *  @file    KsSession.hpp
+ *  @brief   KernelShark Session.
+ */
+
+#ifndef _KS_SESSION_H
+#define _KS_SESSION_H
+
+// Qt
+#include <QtWidgets>
+
+// KernelShark
+#include "KsDualMarker.hpp"
+#include "KsTraceGraph.hpp"
+#include "KsTraceViewer.hpp"
+
+/**
+ * The KsSession class provides instruments for importing/exporting the st=
ate
+ * of the different components of the GUI from/to Json documents. These
+ * instruments are used to save/load user session in the GUI.
+ */
+class KsSession
+{
+public:
+	KsSession();
+
+	virtual ~KsSession();
+
+	/** Get the configuration document object. */
+	kshark_config_doc *getConfDocPtr() const {return _config;}
+
+	void importFromFile(QString jfileName);
+
+	void exportToFile(QString jfileName);
+
+	void saveDataFile(QString fileName);
+
+	QString getDataFile(kshark_context *kshark_ctx);
+
+	void saveVisModel(kshark_trace_histo *histo);
+
+	void loadVisModel(KsGraphModel *model);
+
+	void saveGraphs(const KsGLWidget &glw);
+
+	void loadGraphs(KsTraceGraph *graphs);
+
+	void saveFilters(kshark_context *kshark_ctx);
+
+	void loadFilters(kshark_context *kshark_ctx, KsDataStore *data);
+
+	void saveMainWindowSize(const QMainWindow &window);
+
+	void loadMainWindowSize(QMainWindow *window);
+
+	void saveSplitterSize(const QSplitter &splitter);
+
+	void loadSplitterSize(QSplitter *splitter);
+
+	void saveDualMarker(KsDualMarkerSM *dm);
+
+	void loadDualMarker(KsDualMarkerSM *dmm, KsTraceGraph *graphs);
+
+	void savePlugins(const KsPluginManager &pm);
+
+	void loadPlugins(kshark_context *kshark_ctx, KsPluginManager *pm);
+
+	void saveTable(const KsTraceViewer &view);
+
+	void loadTable(KsTraceViewer *view);
+
+	void saveColorScheme();
+
+	float getColorScheme();
+
+private:
+	kshark_config_doc *_config;
+
+	json_object *_getMarkerJson();
+
+	void _saveCPUPlots(const QVector<int> &cpus);
+
+	QVector<int> _getCPUPlots();
+
+	void _saveTaskPlots(const QVector<int> &tasks);
+
+	QVector<int> _getTaskPlots();
+
+	bool _getMarker(const char* name, size_t *pos);
+
+	DualMarkerState _getMarkerState();
+};
+
+#endif
--=20
2.17.1

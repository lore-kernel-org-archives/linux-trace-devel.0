Return-Path: <SRS0=tdNt=MX=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-sn1nam02on0057.outbound.protection.outlook.com ([104.47.36.57]:35135
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730493AbeJLAZx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Oct 2018 20:25:53 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>,
        Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH v3 2/4] kernel-shark-qt: Add KernalShark Utils
Date: Thu, 11 Oct 2018 16:57:40 +0000
Message-ID: <20181011165713.15257-3-ykaradzhov@vmware.com>
References: <20181011165713.15257-1-ykaradzhov@vmware.com>
In-Reply-To: <20181011165713.15257-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: Yordan Karadzhov (VMware) <y.karadz@gmail.com>

This patch introduces the kshark-gui library and defines some basic
components, like Data Store and Plugin Manager, used under the hood
of the KernelShark GUI.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/build/deff.h.cmake |  16 +
 kernel-shark-qt/src/CMakeLists.txt |  20 +
 kernel-shark-qt/src/KsUtils.cpp    | 594 +++++++++++++++++++++++++++++
 kernel-shark-qt/src/KsUtils.hpp    | 233 +++++++++++
 4 files changed, 863 insertions(+)
 create mode 100644 kernel-shark-qt/src/KsUtils.cpp
 create mode 100644 kernel-shark-qt/src/KsUtils.hpp

diff --git a/kernel-shark-qt/build/deff.h.cmake b/kernel-shark-qt/build/def=
f.h.cmake
index 44ea08b..d1a1bb7 100644
--- a/kernel-shark-qt/build/deff.h.cmake
+++ b/kernel-shark-qt/build/deff.h.cmake
@@ -14,7 +14,23 @@
 /** KernelShark source code path. */
 #cmakedefine KS_DIR "@KS_DIR@"
=20
+/** KernelShark configuration directory path. */
+#cmakedefine KS_CONF_DIR "@KS_CONF_DIR@"
+
 /** Location of the trace-cmd executable. */
 #cmakedefine TRACECMD_BIN_DIR "@TRACECMD_BIN_DIR@"
=20
+#ifdef __cplusplus
+
+	#include <QString>
+
+	/**
+	 * String containing semicolon-separated list of plugin names.
+	 * The plugins to be loaded when KernelShark starts are tagged
+	 * with "default".
+	 */
+	const QString plugins =3D "@PLUGINS@";
+
+#endif /* __cplusplus */
+
 #endif // _KS_CONFIG_H
diff --git a/kernel-shark-qt/src/CMakeLists.txt b/kernel-shark-qt/src/CMake=
Lists.txt
index 305cea7..e897e9a 100644
--- a/kernel-shark-qt/src/CMakeLists.txt
+++ b/kernel-shark-qt/src/CMakeLists.txt
@@ -28,6 +28,26 @@ if (OPENGL_FOUND AND GLUT_FOUND)
=20
 endif (OPENGL_FOUND AND GLUT_FOUND)
=20
+if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
+
+    message(STATUS "libkshark-gui")
+    set (ks-guiLib_hdr  KsUtils.hpp)
+
+    QT5_WRAP_CPP(ks-guiLib_hdr_moc ${ks-guiLib_hdr})
+
+    add_library(kshark-gui  SHARED  ${ks-guiLib_hdr_moc}    KsUtils.cpp)
+
+    target_link_libraries(kshark-gui kshark-plot
+                                     ${CMAKE_DL_LIBS}
+                                     ${TRACEEVENT_LIBRARY}
+                                     ${TRACECMD_LIBRARY}
+                                     Qt5::Widgets
+                                     Qt5::Network)
+
+    set_target_properties(kshark-gui PROPERTIES  SUFFIX ".so.${KS_VERSION_=
STRING}")
+
+endif (Qt5Widgets_FOUND AND Qt5Network_FOUND)
+
 add_subdirectory(plugins)
=20
 configure_file( ${KS_DIR}/build/deff.h.cmake
diff --git a/kernel-shark-qt/src/KsUtils.cpp b/kernel-shark-qt/src/KsUtils.=
cpp
new file mode 100644
index 0000000..13b648e
--- /dev/null
+++ b/kernel-shark-qt/src/KsUtils.cpp
@@ -0,0 +1,594 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
+ */
+
+/**
+ *  @file    KsUtils.cpp
+ *  @brief   KernelShark Utils.
+ */
+
+// KernelShark
+#include "KsUtils.hpp"
+
+namespace KsUtils {
+
+/** @brief Get a sorted vector of Task's Pids. */
+QVector<int> getPidList()
+{
+	kshark_context *kshark_ctx(nullptr);
+	int nTasks, *tempPids;
+	QVector<int> pids;
+
+	if (!kshark_instance(&kshark_ctx))
+		return pids;
+
+	nTasks =3D kshark_get_task_pids(kshark_ctx, &tempPids);
+	for (int r =3D 0; r < nTasks; ++r) {
+		pids.append(tempPids[r]);
+	}
+
+	free(tempPids);
+
+	qSort(pids);
+
+	return pids;
+}
+
+/**
+ * Set the bit of the filter mask of the kshark session context responsibl=
e
+ * for the visibility of the events in the Table View.
+ */
+void listFilterSync(bool state)
+{
+	kshark_context *kshark_ctx(nullptr);
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	if (state) {
+		kshark_ctx->filter_mask |=3D KS_TEXT_VIEW_FILTER_MASK;
+	} else {
+		kshark_ctx->filter_mask &=3D ~KS_TEXT_VIEW_FILTER_MASK;
+	}
+}
+
+/**
+ * Set the bit of the filter mask of the kshark session context responsibl=
e
+ * for the visibility of the events in the Graph View.
+ */
+void graphFilterSync(bool state)
+{
+	kshark_context *kshark_ctx(nullptr);
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	if (state) {
+		kshark_ctx->filter_mask |=3D KS_GRAPH_VIEW_FILTER_MASK;
+	} else {
+		kshark_ctx->filter_mask &=3D ~KS_GRAPH_VIEW_FILTER_MASK;
+	}
+}
+
+/**
+ * @brief Simple CPU matching function to be user for data collections.
+ *
+ * @param kshark_ctx: Input location for the session context pointer.
+ * @param e: kshark_entry to be checked.
+ * @param cpu: Matching condition value.
+ *
+ * @returns True if the CPU of the entry matches the value of "cpu" and
+ * 	    the entry is visibility in Graph. Otherwise false.
+ */
+bool matchCPUVisible(struct kshark_context *kshark_ctx,
+		     struct kshark_entry *e, int cpu)
+{
+	return (e->cpu =3D=3D cpu && (e->visible & KS_GRAPH_VIEW_FILTER_MASK));
+}
+
+}; // KsUtils
+
+/** A stream operator for converting QColor into KsPlot::Color. */
+KsPlot::Color& operator <<(KsPlot::Color &thisColor, const QColor &c)
+{
+	thisColor.set(c.red(), c.green(), c.blue());
+
+	return thisColor;
+}
+
+/** Create a default (empty) KsDataStore. */
+KsDataStore::KsDataStore(QWidget *parent)
+: QObject(parent),
+  _tep(nullptr),
+  _rows(nullptr),
+  _dataSize(0)
+{}
+
+/** Destroy the KsDataStore object. */
+KsDataStore::~KsDataStore()
+{}
+
+/** Load trace data for file. */
+void KsDataStore::loadDataFile(const QString &file)
+{
+	kshark_context *kshark_ctx(nullptr);
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	clear();
+
+	if (!kshark_open(kshark_ctx, file.toStdString().c_str())) {
+		qCritical() << "ERROR Loading file " << file;
+		return;
+	}
+
+	_tep =3D kshark_ctx->pevent;
+
+	if (kshark_ctx->event_handlers =3D=3D nullptr)
+		kshark_handle_plugins(kshark_ctx, KSHARK_PLUGIN_INIT);
+	else
+		kshark_handle_plugins(kshark_ctx, KSHARK_PLUGIN_UPDATE);
+
+	_dataSize =3D kshark_load_data_entries(kshark_ctx, &_rows);
+}
+
+void KsDataStore::_freeData()
+{
+	if (_dataSize) {
+		for (size_t r =3D 0; r < _dataSize; ++r)
+			free(_rows[r]);
+
+		free(_rows);
+		_rows =3D nullptr;
+	}
+}
+
+/** Reload the trace data. */
+void KsDataStore::reload()
+{
+	kshark_context *kshark_ctx(nullptr);
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	_freeData();
+
+	_dataSize =3D kshark_load_data_entries(kshark_ctx, &_rows);
+	_tep =3D kshark_ctx->pevent;
+
+	emit updateWidgets(this);
+}
+
+/** Free the loaded trace data and close the file. */
+void KsDataStore::clear()
+{
+	kshark_context *kshark_ctx(nullptr);
+
+	_freeData();
+	_tep =3D nullptr;
+
+	if (kshark_instance(&kshark_ctx) && kshark_ctx->handle)
+		kshark_close(kshark_ctx);
+}
+
+/** Update the visibility of the entries (filter). */
+void KsDataStore::update()
+{
+	kshark_context *kshark_ctx(nullptr);
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	if (kshark_filter_is_set(kshark_ctx)) {
+		kshark_filter_entries(kshark_ctx, _rows, _dataSize);
+		emit updateWidgets(this);
+	}
+}
+
+/** Register a collection of visible entries for each CPU. */
+void KsDataStore::registerCPUCollections()
+{
+	kshark_context *kshark_ctx(nullptr);
+
+	if (!kshark_instance(&kshark_ctx) ||
+	    !kshark_filter_is_set(kshark_ctx))
+		return;
+
+	int nCPUs =3D tep_get_cpus(_tep);
+	for (int cpu =3D 0; cpu < nCPUs; ++cpu) {
+		kshark_register_data_collection(kshark_ctx,
+						_rows, _dataSize,
+						KsUtils::matchCPUVisible,
+						cpu,
+						0);
+	}
+}
+
+void KsDataStore::_unregisterCPUCollections()
+{
+	kshark_context *kshark_ctx(nullptr);
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	int nCPUs =3D tep_get_cpus(_tep);
+	for (int cpu =3D 0; cpu < nCPUs; ++cpu) {
+		kshark_unregister_data_collection(&kshark_ctx->collections,
+						  KsUtils::matchCPUVisible,
+						  cpu);
+	}
+}
+
+void KsDataStore::_applyIdFilter(int filterId, QVector<int> vec)
+{
+	kshark_context *kshark_ctx(nullptr);
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	switch (filterId) {
+		case KS_SHOW_EVENT_FILTER:
+		case KS_HIDE_EVENT_FILTER:
+			kshark_filter_clear(kshark_ctx, KS_SHOW_EVENT_FILTER);
+			kshark_filter_clear(kshark_ctx, KS_HIDE_EVENT_FILTER);
+			break;
+		case KS_SHOW_TASK_FILTER:
+		case KS_HIDE_TASK_FILTER:
+			kshark_filter_clear(kshark_ctx, KS_SHOW_TASK_FILTER);
+			kshark_filter_clear(kshark_ctx, KS_HIDE_TASK_FILTER);
+			break;
+		default:
+			return;
+	}
+
+	for (auto &&pid: vec)
+		kshark_filter_add_id(kshark_ctx, filterId, pid);
+
+	if (!_tep)
+		return;
+
+	_unregisterCPUCollections();
+
+	/*
+	 * If the advanced event filter is set, the data has to be reloaded,
+	 * because the advanced filter uses tep_records.
+	 */
+	if (kshark_ctx->advanced_event_filter->filters)
+		reload();
+	else
+		kshark_filter_entries(kshark_ctx, _rows, _dataSize);
+
+	registerCPUCollections();
+
+	emit updateWidgets(this);
+}
+
+/** Apply Show Task filter. */
+void KsDataStore::applyPosTaskFilter(QVector<int> vec)
+{
+	_applyIdFilter(KS_SHOW_TASK_FILTER, vec);
+}
+
+/** Apply Hide Task filter. */
+void KsDataStore::applyNegTaskFilter(QVector<int> vec)
+{
+	_applyIdFilter(KS_HIDE_TASK_FILTER, vec);
+}
+
+/** Apply Show Event filter. */
+void KsDataStore::applyPosEventFilter(QVector<int> vec)
+{
+	_applyIdFilter(KS_SHOW_EVENT_FILTER, vec);
+}
+
+/** Apply Hide Event filter. */
+void KsDataStore::applyNegEventFilter(QVector<int> vec)
+{
+	_applyIdFilter(KS_HIDE_EVENT_FILTER, vec);
+}
+
+/** Disable all filters. */
+void KsDataStore::clearAllFilters()
+{
+	kshark_context *kshark_ctx(nullptr);
+
+	if (!kshark_instance(&kshark_ctx) || !_tep)
+		return;
+
+	_unregisterCPUCollections();
+
+	kshark_filter_clear(kshark_ctx, KS_SHOW_TASK_FILTER);
+	kshark_filter_clear(kshark_ctx, KS_HIDE_TASK_FILTER);
+	kshark_filter_clear(kshark_ctx, KS_SHOW_EVENT_FILTER);
+	kshark_filter_clear(kshark_ctx, KS_HIDE_EVENT_FILTER);
+
+	tep_filter_reset(kshark_ctx->advanced_event_filter);
+	kshark_clear_all_filters(kshark_ctx, _rows, _dataSize);
+
+	emit updateWidgets(this);
+}
+
+/**
+ * @brief Create Plugin Manager. Use list of plugins declared in the
+ *	  CMake-generated header file.
+ */
+KsPluginManager::KsPluginManager(QWidget *parent)
+: QObject(parent)
+{
+	kshark_context *kshark_ctx(nullptr);
+	_parsePluginList();
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	registerFromList(kshark_ctx);
+}
+
+/** Parse the plugin list declared in the CMake-generated header file. */
+void KsPluginManager::_parsePluginList()
+{
+	_ksPluginList =3D KsUtils::getPluginList();
+	int nPlugins =3D _ksPluginList.count();
+
+	_registeredKsPlugins.resize(nPlugins);
+	for (int i =3D 0; i < nPlugins; ++i) {
+		if (_ksPluginList[i].contains(" default", Qt::CaseInsensitive)) {
+			_ksPluginList[i].remove(" default", Qt::CaseInsensitive);
+			_registeredKsPlugins[i] =3D true;
+		} else {
+			_registeredKsPlugins[i] =3D false;
+		}
+	}
+}
+
+/**
+ * Register the plugins by using the information in "_ksPluginList" and
+ * "_registeredKsPlugins".
+ */
+void KsPluginManager::registerFromList(kshark_context *kshark_ctx)
+{
+	auto lamRegBuiltIn =3D [&kshark_ctx](const QString &plugin)
+	{
+		char *lib;
+		int n;
+
+		n =3D asprintf(&lib, "%s/lib/plugin-%s.so",
+			     KS_DIR, plugin.toStdString().c_str());
+		if (n <=3D 0)
+			return;
+
+		kshark_register_plugin(kshark_ctx, lib);
+		free(lib);
+	};
+
+	auto lamRegUser =3D [&kshark_ctx](const QString &plugin)
+	{
+		const char *lib =3D plugin.toStdString().c_str();
+		kshark_register_plugin(kshark_ctx, lib);
+	};
+
+	_forEachInList(_ksPluginList,
+		       _registeredKsPlugins,
+		       lamRegBuiltIn);
+
+	_forEachInList(_userPluginList,
+		       _registeredUserPlugins,
+		       lamRegUser);
+}
+
+/**
+ * Unegister the plugins by using the information in "_ksPluginList" and
+ * "_registeredKsPlugins".
+ */
+void KsPluginManager::unregisterFromList(kshark_context *kshark_ctx)
+{
+	auto lamUregBuiltIn =3D [&kshark_ctx](const QString &plugin)
+	{
+		char *lib;
+		int n;
+
+		n =3D asprintf(&lib, "%s/lib/plugin-%s.so",
+			     KS_DIR, plugin.toStdString().c_str());
+		if (n <=3D 0)
+			return;
+
+		kshark_unregister_plugin(kshark_ctx, lib);
+		free(lib);
+	};
+
+	auto lamUregUser =3D [&kshark_ctx](const QString &plugin)
+	{
+		const char *lib =3D plugin.toStdString().c_str();
+		kshark_unregister_plugin(kshark_ctx, lib);
+	};
+
+	_forEachInList(_ksPluginList,
+		       _registeredKsPlugins,
+			lamUregBuiltIn);
+
+	_forEachInList(_userPluginList,
+		       _registeredUserPlugins,
+			lamUregUser);
+}
+
+/**
+ * @brief Register a Plugin.
+ *
+ * @param plugin: provide here the name of the plugin (as in the CMake-gen=
erated
+ *		  header file) of a name of the plugin's library file (.so).
+ */
+void KsPluginManager::registerPlugin(const QString &plugin)
+{
+	kshark_context *kshark_ctx(nullptr);
+	char *lib;
+	int n;
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	for (int i =3D 0; i < _ksPluginList.count(); ++i) {
+		if (_ksPluginList[i] =3D=3D plugin) {
+			/*
+			 * The argument is the name of the plugin. From the
+			 * name get the library .so file.
+			 */
+			n =3D asprintf(&lib, "%s/lib/plugin-%s.so",
+					KS_DIR, plugin.toStdString().c_str());
+			if (n > 0) {
+				kshark_register_plugin(kshark_ctx, lib);
+				_registeredKsPlugins[i] =3D true;
+				free(lib);
+			}
+
+			return;
+
+		} else if (plugin.contains("/lib/plugin-" + _ksPluginList[i],
+					   Qt::CaseInsensitive)) {
+			/*
+			 * The argument is the name of the library .so file.
+			 */
+			n =3D asprintf(&lib, "%s", plugin.toStdString().c_str());
+			if (n > 0) {
+				kshark_register_plugin(kshark_ctx, lib);
+				_registeredKsPlugins[i] =3D true;
+				free(lib);
+			}
+
+			return;
+		}
+	}
+
+	/* No plugin with this name in the list. Try to add it anyway. */
+	if (plugin.endsWith(".so") && QFileInfo::exists(plugin)) {
+		kshark_register_plugin(kshark_ctx,
+				       plugin.toStdString().c_str());
+
+		_userPluginList.append(plugin);
+		_registeredUserPlugins.append(true);
+	} else {
+		qCritical() << "ERROR: " << plugin << "cannot be registered!";
+	}
+}
+
+/** @brief Unregister a Built in KernelShark plugin.
+ *<br>
+ * WARNING: Do not use this function to unregister User plugins.
+ * Instead use directly kshark_unregister_plugin().
+ *
+ * @param plugin: provide here the name of the plugin (as in the CMake-gen=
erated
+ *		  header file) or a name of the plugin's library file (.so).
+ *
+ */
+void KsPluginManager::unregisterPlugin(const QString &plugin)
+{
+	kshark_context *kshark_ctx(nullptr);
+	char *lib;
+	int n;
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	for (int i =3D 0; i < _ksPluginList.count(); ++i) {
+		if (_ksPluginList[i] =3D=3D plugin) {
+			/*
+			 * The argument is the name of the plugin. From the
+			 * name get the library .so file.
+			 */
+			n =3D asprintf(&lib, "%s/lib/plugin-%s.so", KS_DIR,
+				     plugin.toStdString().c_str());
+			if (n > 0) {
+				kshark_unregister_plugin(kshark_ctx, lib);
+				_registeredKsPlugins[i] =3D false;
+				free(lib);
+			}
+
+			return;
+		} else if  (plugin.contains("/lib/plugin-" +
+			                   _ksPluginList[i], Qt::CaseInsensitive)) {
+			/*
+			 * The argument is the name of the library .so file.
+			 */
+			n =3D asprintf(&lib, "%s", plugin.toStdString().c_str());
+			if (n > 0) {
+				kshark_unregister_plugin(kshark_ctx, lib);
+				_registeredKsPlugins[i] =3D false;
+				free(lib);
+			}
+
+			return;
+		}
+	}
+}
+
+/** Unload all plugins. */
+void KsPluginManager::unloadAll()
+{
+	kshark_context *kshark_ctx(nullptr);
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	kshark_handle_plugins(kshark_ctx, KSHARK_PLUGIN_CLOSE);
+	kshark_free_plugin_list(kshark_ctx->plugins);
+	kshark_ctx->plugins =3D nullptr;
+	kshark_free_event_handler_list(kshark_ctx->event_handlers);
+
+	unregisterFromList(kshark_ctx);
+}
+
+/** @brief Update (change) the Plugins.
+ *
+ * @param pluginIds: The indexes of the plugins to be loaded.
+ */
+void KsPluginManager::updatePlugins(QVector<int> pluginIds)
+{
+	kshark_context *kshark_ctx(nullptr);
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	auto register_plugins =3D [&] (QVector<int> ids)
+	{
+		int nKsPlugins =3D _registeredKsPlugins.count();
+
+		/* First clear all registered plugins. */
+		for (auto &p: _registeredKsPlugins)
+			p =3D false;
+		for (auto &p: _registeredUserPlugins)
+			p =3D false;
+
+		/* The vector contains the indexes of those to register. */
+		for (auto const &p: ids) {
+			if (p < nKsPlugins)
+				_registeredKsPlugins[p] =3D true;
+			else
+				_registeredUserPlugins[p - nKsPlugins] =3D true;
+		}
+		registerFromList(kshark_ctx);
+	};
+
+	if (!kshark_ctx->pevent) {
+		kshark_free_plugin_list(kshark_ctx->plugins);
+		kshark_ctx->plugins =3D nullptr;
+
+		/*
+		 * No data is loaded. For the moment, just register the
+		 * plugins. Handling of the plugins will be done after
+		 * we load a data file.
+		 */
+		register_plugins(pluginIds);
+		return;
+	}
+
+	/* Clean up all old plugins first. */
+	unloadAll();
+
+	/* Now load. */
+	register_plugins(pluginIds);
+	kshark_handle_plugins(kshark_ctx, KSHARK_PLUGIN_INIT);
+
+	emit dataReload();
+}
diff --git a/kernel-shark-qt/src/KsUtils.hpp b/kernel-shark-qt/src/KsUtils.=
hpp
new file mode 100644
index 0000000..b14cd6a
--- /dev/null
+++ b/kernel-shark-qt/src/KsUtils.hpp
@@ -0,0 +1,233 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+
+/*
+ * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
+ */
+
+/**
+ *  @file    KsUtils.hpp
+ *  @brief   KernelShark Utils.
+ */
+
+#ifndef _KS_UTILS_H
+#define _KS_UTILS_H
+
+// C++ 11
+#include <chrono>
+
+// Qt
+#include <QtWidgets>
+
+// KernelShark
+#include "libkshark.h"
+#include "libkshark-model.h"
+#include "KsCmakeDef.hpp"
+#include "KsPlotTools.hpp"
+
+/** Macro providing the height of the screen in pixels. */
+#define SCREEN_HEIGHT  QApplication::desktop()->screenGeometry().height()
+
+/** Macro providing the width of the screen in pixels. */
+#define SCREEN_WIDTH   QApplication::desktop()->screenGeometry().width()
+
+//! @cond Doxygen_Suppress
+
+auto fontHeight =3D []()
+{
+	QFont font;
+	QFontMetrics fm(font);
+
+	return fm.height();
+};
+
+auto stringWidth =3D [](QString s)
+{
+	QFont font;
+	QFontMetrics fm(font);
+
+	return fm.width(s);
+};
+
+//! @endcond
+
+/** Macro providing the height of the font in pixels. */
+#define FONT_HEIGHT		fontHeight()
+
+/** Macro providing the width of the font in pixels. */
+#define FONT_WIDTH 		stringWidth("4")
+
+/** Macro providing the width of a string in pixels. */
+#define STRING_WIDTH(s)		stringWidth(s)
+
+/** Macro providing the height of the KernelShark graphs in pixels. */
+#define KS_GRAPH_HEIGHT	(FONT_HEIGHT*2)
+
+//! @cond Doxygen_Suppress
+
+#define KS_JSON_CAST(doc) \
+reinterpret_cast<json_object *>(doc)
+
+#define KS_C_STR_CAST(doc) \
+reinterpret_cast<const char *>(doc)
+
+typedef std::chrono::high_resolution_clock::time_point  hd_time;
+
+#define GET_TIME std::chrono::high_resolution_clock::now()
+
+#define GET_DURATION(t0) \
+std::chrono::duration_cast<std::chrono::duration<double>>( \
+std::chrono::high_resolution_clock::now() - t0).count()
+
+//! @endcond
+
+namespace KsUtils {
+
+QVector<int> getPidList();
+
+/** @brief Geat the list of plugins. */
+inline QStringList getPluginList() {return plugins.split(";");}
+
+void listFilterSync(bool state);
+
+void graphFilterSync(bool state);
+
+/** @brief Convert the timestamp of the trace record into a string showing
+ *	   the time in seconds.
+ *
+ * @param ts: Input location for the timestamp.
+ * @param prec: the number of digits after the decimal point in the return
+ *		string.
+ *
+ * @returns String showing the time in seconds.
+ */
+inline QString Ts2String(int64_t ts, int prec)
+{
+	return QString::number(ts * 1e-9, 'f', prec);
+}
+
+bool matchCPUVisible(struct kshark_context *kshark_ctx,
+			      struct kshark_entry *e, int cpu);
+}; // KsUtils
+
+/** Identifier of the Dual Marker active state. */
+enum class DualMarkerState {
+	A,
+	B
+};
+
+/**
+ * The KsDataStore class provides the access to trace data for all KernelS=
hark
+ * widgets.
+ */
+class KsDataStore : public QObject
+{
+	Q_OBJECT
+public:
+	explicit KsDataStore(QWidget *parent =3D nullptr);
+
+	~KsDataStore();
+
+	void loadDataFile(const QString &file);
+
+	void clear();
+
+	/** Get the trace event parser. */
+	tep_handle *tep() const {return _tep;}
+
+	/** Get the trace data array.. */
+	struct kshark_entry **rows() const {return _rows;}
+
+	/** Get the size of the data array. */
+	size_t size() const {return _dataSize;}
+
+	void reload();
+
+	void update();
+
+	void registerCPUCollections();
+
+	void applyPosTaskFilter(QVector<int>);
+
+	void applyNegTaskFilter(QVector<int>);
+
+	void applyPosEventFilter(QVector<int>);
+
+	void applyNegEventFilter(QVector<int>);
+
+	void clearAllFilters();
+
+signals:
+	/**
+	 * This signal is emitted when the data has changed and the View
+	 * widgets have to update.
+	 */
+	void updateWidgets(KsDataStore *);
+
+private:
+	/** Page event used to parse the page. */
+	tep_handle		*_tep;
+
+	/** Trace data array. */
+	struct kshark_entry	**_rows;
+
+	/** The size of the data array. */
+	size_t			_dataSize;
+
+	void _freeData();
+	void _unregisterCPUCollections();
+	void _applyIdFilter(int filterId, QVector<int> vec);
+};
+
+/** A Plugin Manage class. */
+class KsPluginManager : public QObject
+{
+	Q_OBJECT
+public:
+	explicit KsPluginManager(QWidget *parent =3D nullptr);
+
+	/** A list of available built-in plugins. */
+	QStringList	_ksPluginList;
+
+	/** A list of registered built-in plugins. */
+	QVector<bool>	_registeredKsPlugins;
+
+	/** A list of available user plugins. */
+	QStringList	_userPluginList;
+
+	/** A list of registered user plugins. */
+	QVector<bool>	_registeredUserPlugins;
+
+	void registerFromList(kshark_context *kshark_ctx);
+	void unregisterFromList(kshark_context *kshark_ctx);
+
+	void registerPlugin(const QString &plugin);
+	void unregisterPlugin(const QString &plugin);
+	void unloadAll();
+
+	void updatePlugins(QVector<int> pluginId);
+
+signals:
+	/** This signal is emitted when a plugin is loaded or unloaded. */
+	void dataReload();
+
+private:
+	void _parsePluginList();
+
+	template <class T>
+	void _forEachInList(const QStringList &pl,
+			    const QVector<bool> &reg,
+			    T action)
+	{
+		int nPlugins;
+		nPlugins =3D pl.count();
+		for (int i =3D 0; i < nPlugins; ++i) {
+			if (reg[i]) {
+				action(pl[i]);
+			}
+		}
+	}
+};
+
+KsPlot::Color& operator <<(KsPlot::Color &thisColor, const QColor &c);
+
+#endif
--=20
2.17.1

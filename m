Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDC61C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:35:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BD3E64E6F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:35:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbhBKKf0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Feb 2021 05:35:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbhBKKdL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Feb 2021 05:33:11 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E66BEC06178C
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:28 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id lg21so9280582ejb.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EUr80i8fJRsLU5UiLxhjh0gWzUYe9AbGMXYaMKCsSCg=;
        b=QXYNuoMze+J//Zhde4aA6zWstjQ5ZWnEWBxBwnVCWjOU2OIk9pl3cxcAGvnh/jQFHi
         LV0771NHZyke7o8O3/dwef0lQ8XUQ2OgDjRwmpYyR1pvoPNBRbzglz6TOmnKJVIrejxB
         PDeU/emE7YHXDWthGEobXWDBm6fBGC0AjCWAj75chpr7D/2OSYfWjfEhdt82WnZ0fZNd
         rVWaXIHTaNwcm6AW40TM7cqTni+jgVfATgKmn6YsV2uIEg0RLZOXBKmdhSCCWMM1fGyQ
         RKInu7fuLzfnDSnx7SiWbN/7G8YbJlxn/V/qfKqTfxSuyjBeRHuzfkyGJzn4t2IUmKnS
         20mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EUr80i8fJRsLU5UiLxhjh0gWzUYe9AbGMXYaMKCsSCg=;
        b=OeSuJdIQvasfnZblin+5tpkFns1YURmIeF8zfXhIRkk8RcdwDzMEVbWcxst69fqtRn
         OzmxZE1kiKSqGRYwaVRTbhzisJZLWlgKiBCVs5FPXueYttcJzqo9W40rR/9iu5fGVVE6
         cYPX5ga2iDJ3Fluy+scUcjM7HSinwDov3J/pF6ezO1ZZfpTObTvzLUHqrkivNTZERlM3
         a/Esri4Y+uViCM7Tp87fIZUxBHUeEq9InQ8rnNKw3j7e037SV31NhQ9jZucbt4h1LyM0
         pDtQv9MdZrGc0wtdRnKjssKuktIQwVtC7+bMWXTnl40IfmWpnCjVk6qrVk5RcjLVyyra
         /EsA==
X-Gm-Message-State: AOAM530+p73i5q4XwXF05jZ4FTNsuw3FscnrCktABcLMfhiO6khOMRzt
        3s1c/ww7sMhZ+3XeH25iDCM=
X-Google-Smtp-Source: ABdhPJwDkDP0fwWafF0wJ4z1chE/kin7UqnGUL4O5QPfxn0oGR21KYW6k+Hi94TNT04pTe8sXfs+9g==
X-Received: by 2002:a17:906:b50:: with SMTP id v16mr7536717ejg.298.1613039547015;
        Thu, 11 Feb 2021 02:32:27 -0800 (PST)
Received: from localhost.localdomain (212-39-89-223.ip.btc-net.bg. [212.39.89.223])
        by smtp.gmail.com with ESMTPSA id bd27sm3514031edb.37.2021.02.11.02.32.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 02:32:26 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 06/27] kernel-shark: Update KsUtils
Date:   Thu, 11 Feb 2021 12:31:44 +0200
Message-Id: <20210211103205.418588-7-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211103205.418588-1-y.karadz@gmail.com>
References: <20210211103205.418588-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The compilation of KsUtils is re-enabled and all functionalities
provided in it are made compatible with the new version of the
C API of libkshark (KernelShark 2.0).

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 CMakeLists.txt            |   10 +-
 build/deff.h.cmake        |    3 +
 src/CMakeLists.txt        |   73 +--
 src/KsUtils.cpp           | 1154 +++++++++++++++++++++++++------------
 src/KsUtils.hpp           |  181 ++++--
 tests/CMakeLists.txt      |    2 +-
 tests/libkshark-tests.cpp |    1 +
 7 files changed, 969 insertions(+), 455 deletions(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index dd62091..e013916 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -49,12 +49,18 @@ set(OpenGL_GL_PREFERENCE LEGACY)
 find_package(OpenGL)
 find_package(GLUT)
 
-# find_package(Qt5Widgets 5.7.1)
-# find_package(Qt5Network)
+find_package(Qt5Widgets 5.7.1)
+find_package(Qt5Network)
 if (Qt5Widgets_FOUND)
 
     message(STATUS "Found Qt5Widgets:  (version ${Qt5Widgets_VERSION})")
 
+    if(Qt5Widgets_VERSION VERSION_LESS "5.11")
+
+        set(QT_VERSION_LESS_5_11 TRUE)
+
+    endif()
+
 endif (Qt5Widgets_FOUND)
 
 find_package (Boost COMPONENTS unit_test_framework)
diff --git a/build/deff.h.cmake b/build/deff.h.cmake
index 868ffec..5584574 100644
--- a/build/deff.h.cmake
+++ b/build/deff.h.cmake
@@ -26,6 +26,9 @@
 /** GLUT has been found. */
 #cmakedefine GLUT_FOUND
 
+/** Qt - old version detected. */
+#cmakedefine QT_VERSION_LESS_5_11
+
 /** Semicolon-separated list of plugin names. */
 #define KS_BUILTIN_PLUGINS "@PLUGINS@"
 
diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 980e802..5c9fe17 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -66,34 +66,34 @@ endif (OPENGL_FOUND)
 if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
 
     message(STATUS "libkshark-gui")
-    set (ks-guiLib_hdr  KsUtils.hpp
-                        KsModels.hpp
-                        KsGLWidget.hpp
-                        KsSearchFSM.hpp
-                        KsDualMarker.hpp
-                        KsWidgetsLib.hpp
-                        KsTraceGraph.hpp
-                        KsTraceViewer.hpp
-                        KsMainWindow.hpp
-                        KsCaptureDialog.hpp
-                        KsQuickContextMenu.hpp
-                        KsAdvFilteringDialog.hpp)
+    set (ks-guiLib_hdr  KsUtils.hpp)
+#                         KsModels.hpp
+#                         KsGLWidget.hpp
+#                         KsSearchFSM.hpp
+#                         KsDualMarker.hpp
+#                         KsWidgetsLib.hpp
+#                         KsTraceGraph.hpp
+#                         KsTraceViewer.hpp
+#                         KsMainWindow.hpp
+#                         KsCaptureDialog.hpp
+#                         KsQuickContextMenu.hpp
+#                         KsAdvFilteringDialog.hpp)
 
     QT5_WRAP_CPP(ks-guiLib_hdr_moc ${ks-guiLib_hdr})
 
-    add_library(kshark-gui  SHARED  ${ks-guiLib_hdr_moc}    KsUtils.cpp
-                                                            KsModels.cpp
-                                                            KsSession.cpp
-                                                            KsGLWidget.cpp
-                                                            KsSearchFSM.cpp
-                                                            KsDualMarker.cpp
-                                                            KsWidgetsLib.cpp
-                                                            KsTraceGraph.cpp
-                                                            KsTraceViewer.cpp
-                                                            KsMainWindow.cpp
-                                                            KsCaptureDialog.cpp
-                                                            KsQuickContextMenu.cpp
-                                                            KsAdvFilteringDialog.cpp)
+    add_library(kshark-gui  SHARED  ${ks-guiLib_hdr_moc}    KsUtils.cpp)
+#                                                             KsModels.cpp
+#                                                             KsSession.cpp
+#                                                             KsGLWidget.cpp
+#                                                             KsSearchFSM.cpp
+#                                                             KsDualMarker.cpp
+#                                                             KsWidgetsLib.cpp
+#                                                             KsTraceGraph.cpp
+#                                                             KsTraceViewer.cpp
+#                                                             KsMainWindow.cpp
+#                                                             KsCaptureDialog.cpp
+#                                                             KsQuickContextMenu.cpp
+#                                                             KsAdvFilteringDialog.cpp)
 
     target_link_libraries(kshark-gui kshark-plot
                                      Qt5::Widgets
@@ -102,19 +102,20 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
 
     set_target_properties(kshark-gui PROPERTIES  SUFFIX ".so.${KS_VERSION_STRING}")
 
-    message(STATUS ${KS_APP_NAME})
-    add_executable(${KS_APP_NAME}          kernelshark.cpp)
-    target_link_libraries(${KS_APP_NAME}   kshark-gui)
+#     message(STATUS ${KS_APP_NAME})
+#     add_executable(${KS_APP_NAME}          kernelshark.cpp)
+#     target_link_libraries(${KS_APP_NAME}   kshark-gui)
 
-    message(STATUS "kshark-record")
-    add_executable(kshark-record        kshark-record.cpp)
-    target_link_libraries(kshark-record kshark-gui)
+#     message(STATUS "kshark-record")
+#     add_executable(kshark-record        kshark-record.cpp)
+#     target_link_libraries(kshark-record kshark-gui)
+
+#     install(TARGETS ${KS_APP_NAME} kshark-record kshark-gui
+#             RUNTIME DESTINATION       ${_INSTALL_PREFIX}/bin/
+#                 COMPONENT                 kernelshark
+#             LIBRARY DESTINATION       ${_LIBDIR}
+#                 COMPONENT                 kernelshark)
 
-    install(TARGETS ${KS_APP_NAME} kshark-record kshark-gui
-            RUNTIME DESTINATION       ${_INSTALL_PREFIX}/bin/
-                COMPONENT                 kernelshark
-            LIBRARY DESTINATION       ${_LIBDIR}
-                COMPONENT                 kernelshark)
 
     install(FILES "${KS_DIR}/${KS_APP_NAME}.desktop"
             DESTINATION ${_INSTALL_PREFIX}/share/applications/
diff --git a/src/KsUtils.cpp b/src/KsUtils.cpp
index 24f7178..36f9b25 100644
--- a/src/KsUtils.cpp
+++ b/src/KsUtils.cpp
@@ -10,90 +10,244 @@
  */
 
 // KernelShark
+#include "libkshark-plugin.h"
+#include "libkshark-tepdata.h"
 #include "KsUtils.hpp"
-#include "KsWidgetsLib.hpp"
 
 namespace KsUtils {
 
-/** @brief Get a sorted vector of CPU Ids. */
-QVector<int> getCPUList()
+/**
+ * @brief Get a sorted vector of CPU Ids associated with a given Data stream.
+ *
+ * @param sd: Data stream identifier.
+ *
+ * @returns Vector of CPU Ids on success or an empty vector on failure.
+ */
+QVector<int> getCPUList(int sd)
 {
 	kshark_context *kshark_ctx(nullptr);
-	int nCPUs;
+	kshark_data_stream *stream;
 
 	if (!kshark_instance(&kshark_ctx))
 		return {};
 
-	nCPUs = tep_get_cpus(kshark_ctx->pevent);
-	QVector<int> allCPUs = QVector<int>(nCPUs);
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!stream)
+		return {};
+
+	QVector<int> allCPUs = QVector<int>(stream->n_cpus);
 	std::iota(allCPUs.begin(), allCPUs.end(), 0);
 
 	return allCPUs;
 }
 
-/** @brief Get a sorted vector of Task's Pids. */
-QVector<int> getPidList()
+/**
+ * @brief Get a sorteg vector of Task's PIDs associated with a given Data
+ *	  stream.
+ *
+ * @param sd: Data stream identifier.
+ *
+ * @returns Vector of PIDs on success or an empty vector on failure.
+ */
+QVector<int> getPidList(int sd)
 {
 	kshark_context *kshark_ctx(nullptr);
-	int nTasks, *tempPids;
-	QVector<int> pids;
+	int nTasks, *ids;
 
 	if (!kshark_instance(&kshark_ctx))
-		return pids;
+		return {};
 
-	nTasks = kshark_get_task_pids(kshark_ctx, &tempPids);
-	for (int r = 0; r < nTasks; ++r) {
-		pids.append(tempPids[r]);
-	}
+	nTasks = kshark_get_task_pids(kshark_ctx, sd, &ids);
 
-	free(tempPids);
+	QVector<int> pids(nTasks);
+	for (int i = 0; i < nTasks; ++i)
+		pids[i] = ids[i];
 
-	std::sort(pids.begin(), pids.end());
+	free(ids);
 
 	return pids;
 }
 
 /**
- * @brief Get a sorted vector of Event Ids.
+ * @brief Get a vector of all Event Ids associated with a given Data stream.
+ *
+ * @param sd: Data stream identifier.
+ *
+ * @returns Vector of Event Ids on success or an empty vector on failure.
  */
-QVector<int> getEventIdList(tep_event_sort_type sortType)
+QVector<int> getEventIdList(int sd)
 {
 	kshark_context *kshark_ctx(nullptr);
-	tep_event **events;
-	int nEvts;
+	kshark_data_stream *stream;
+	int *ids;
 
 	if (!kshark_instance(&kshark_ctx))
 		return {};
 
-	nEvts = tep_get_events_count(kshark_ctx->pevent);
-	events = tep_list_events(kshark_ctx->pevent, sortType);
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!stream)
+		return {};
+
+	ids = kshark_get_all_event_ids(stream);
+	if (!ids)
+		return {};
 
-	QVector<int> allEvts(nEvts);
-	for (int i = 0; i < nEvts; ++i)
-		allEvts[i] = events[i]->id;
+	QVector<int> evts(stream->n_events);
+	for (int i = 0; i < stream->n_events; ++i)
+		evts[i] = ids[i];
 
-	return allEvts;
+	free(ids);
+
+	return evts;
 }
 
-/** @brief Get a sorted vector of Id values of a filter. */
-QVector<int> getFilterIds(tracecmd_filter_id *filter)
+/**
+ * @brief Retrieve the unique Id of the event.
+ *
+ * @param sd: Data stream identifier.
+ * @param eventName: The name of the event.
+ *
+ * @returns Event Id on success or a negative errno code on failure.
+ */
+int getEventId(int sd, const QString &eventName)
 {
+	const std::string buff = eventName.toStdString();
 	kshark_context *kshark_ctx(nullptr);
-	int *cpuFilter, n;
-	QVector<int> v;
+	kshark_data_stream *stream;
 
 	if (!kshark_instance(&kshark_ctx))
-		return v;
+		return -EFAULT;
+
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!stream)
+		return -ENODEV;
+
+	return kshark_find_event_id(stream, buff.c_str());
+}
+
+static kshark_entry probeEntry(int sd, int eventId)
+{
+	kshark_entry e;
 
-	cpuFilter = tracecmd_filter_ids(filter);
-	n = filter->count;
+	e.stream_id = sd;
+	e.event_id = eventId;
+	e.visible = 0xff;
+
+	return e;
+}
+
+/**
+ * @brief Retrieve the name of the event.
+ *
+ * @param sd: Data stream identifier.
+ * @param eventId: The unique Id of the event.
+ *
+ * @returns Event name on success or "Unknown" on failure.
+ */
+QString getEventName(int sd, int eventId)
+{
+	kshark_entry entry = probeEntry(sd, eventId);
+	QString ret("Unknown");
+	char *event;
+
+	event = kshark_get_event_name(&entry);
+	if (event) {
+		 ret = QString(event);
+		 free(event);
+	}
+
+	return QString(ret);
+}
+
+/**
+ * @brief Get the namse of all data fields associated with a given trace event.
+ *
+ * @param sd: Data stream identifier.
+ * @param eventId: The unique Id of the event.
+ *
+ * @returns List of fieldsnames on success or an empty list on failure.
+ */
+QStringList getEventFieldsList(int sd, int eventId)
+{
+	kshark_entry entry = probeEntry(sd, eventId);
+	QStringList fieldList;
+	char **eventFields;
+	int nFields;
+
+	nFields = kshark_get_all_event_field_names(&entry, &eventFields);
+	if (nFields <= 0)
+		return {};
+
+	for (int i = 0; i < nFields; ++i) {
+		fieldList << eventFields[i];
+		free(eventFields[i]);
+	}
+
+	free(eventFields);
+
+	return fieldList;
+}
+
+/**
+ * @brief Retrieve the type of a given data field associatedwith a given trace
+ *	  event.
+ *
+ * @param sd: Data stream identifier.
+ * @param eventId: The unique Id of the event.
+ * @param fieldName: The name of the data field.
+ *
+ * @returns Field format identifier.
+ */
+kshark_event_field_format getEventFieldType(int sd, int eventId,
+					    const QString &fieldName)
+{
+	const std::string buff = fieldName.toStdString();
+	kshark_entry entry = probeEntry(sd, eventId);
+
+	return kshark_get_event_field_type(&entry, buff.c_str());
+}
+
+/**
+ * @brief Get all Data stream Ids.
+ *
+ * @param kshark_ctx: Input location for context pointer.
+ *
+ * @returns Vector of Data stream Ids.
+ */
+QVector<int> getStreamIdList(kshark_context *kshark_ctx)
+{
+	int *ids = kshark_all_streams(kshark_ctx);
+	QVector<int> streamIds(kshark_ctx->n_streams);
+
+	for (int i = 0; i < kshark_ctx->n_streams; ++i)
+		streamIds[i] = ids[i];
+
+	free(ids);
+
+	return streamIds;
+}
+
+/**
+ * @brief Get a sorted vector of Id values of a filter.
+ *
+ * @param filter: Input location for the filter object.
+ */
+QVector<int> getFilterIds(kshark_hash_id *filter)
+{
+	kshark_context *kshark_ctx(nullptr);
+	int *ids, n = filter->count;
+
+	if (!kshark_instance(&kshark_ctx))
+		return {};
+
+	ids = kshark_hash_ids(filter);
+	QVector<int> filterIds(n);
 	for (int i = 0; i < n; ++i)
-		v.append(cpuFilter[i]);
+		filterIds[i] = ids[i];
 
-	std::sort(v.begin(), v.end());
+	free(ids);
 
-	free(cpuFilter);
-	return v;
+	return filterIds;
 }
 
 /**
@@ -134,7 +288,6 @@ void graphFilterSync(bool state)
 	}
 }
 
-
 /**
  * @brief Add a checkbox to a menu.
  *
@@ -164,15 +317,46 @@ QCheckBox *addCheckBoxToMenu(QMenu *menu, QString name)
  *
  * @param kshark_ctx: Input location for the session context pointer.
  * @param e: kshark_entry to be checked.
+ * @param sd: Data stream identifier.
  * @param cpu: Matching condition value.
  *
  * @returns True if the CPU of the entry matches the value of "cpu" and
  * 	    the entry is visibility in Graph. Otherwise false.
  */
 bool matchCPUVisible(struct kshark_context *kshark_ctx,
-		     struct kshark_entry *e, int cpu)
+		     struct kshark_entry *e, int sd, int *cpu)
 {
-	return (e->cpu == cpu && (e->visible & KS_GRAPH_VIEW_FILTER_MASK));
+	return (e->cpu == *cpu &&
+		e->stream_id == sd &&
+		(e->visible & KS_GRAPH_VIEW_FILTER_MASK));
+}
+
+/**
+ * @brief Get an elided version of the string that will fit within a label.
+ *
+ * @param label: Pointer to the label object.
+ * @param text: The text to be elided.
+ * @param mode: Parameter specifies whether the text is elided on the left,
+ *		in the middle, or on the right.
+ * @param labelWidth: The desired width of the label.
+ */
+void setElidedText(QLabel* label, QString text,
+		   enum Qt::TextElideMode mode,
+		   int labelWidth)
+{
+	QFontMetrics metrix(label->font());
+	QString elidedText;
+	int textWidth;
+
+	textWidth = labelWidth - FONT_WIDTH * 3;
+	elidedText = metrix.elidedText(text, Qt::ElideRight, textWidth);
+
+	while(labelWidth < STRING_WIDTH(elidedText) + FONT_WIDTH * 5) {
+		textWidth -= FONT_WIDTH * 3;
+		elidedText = metrix.elidedText(text, mode, textWidth);
+	}
+
+	label->setText(elidedText);
 }
 
 /**
@@ -268,36 +452,8 @@ QStringList getFiles(QWidget *parent,
 }
 
 /**
- * @brief Open a standard Qt getFileName dialog and return the name of the
- *	  selected file. Only one file can be selected.
- */
-QString getSaveFile(QWidget *parent,
-		    const QString &windowName,
-		    const QString &filter,
-		    const QString &extension,
-		    QString &lastFilePath)
-{
-	QString fileName = getFileDialog(parent,
-					 windowName,
-					 filter,
-					 lastFilePath,
-					 true);
-
-	if (!fileName.isEmpty() && !fileName.endsWith(extension)) {
-		fileName += extension;
-
-		if (QFileInfo(fileName).exists()) {
-			if (!KsWidgetsLib::fileExistsDialog(fileName))
-				fileName.clear();
-		}
-	}
-
-	return fileName;
-}
-
-/**
- * Separate the command line arguments inside the string taking into account
- * possible shell quoting and new lines.
+ * @brief Separate the command line arguments inside the string taking into
+ *	  account possible shell quoting and new lines.
  */
 QStringList splitArguments(QString cmd)
 {
@@ -336,7 +492,10 @@ QStringList splitArguments(QString cmd)
 	return argv;
 }
 
-/** Parse a string containing Ids. The string can be of the form "1 4-7 9". */
+/**
+ * @brief Parse a string containing Ids. The string can be of the form
+ *	  "1,4-7,9".
+ */
 QVector<int> parseIdList(QString v_str)
 {
 	QStringList list = v_str.split(",", QString::SkipEmptyParts);
@@ -360,6 +519,63 @@ QVector<int> parseIdList(QString v_str)
 	return v;
 }
 
+/**
+ * @brief Split the ststem name from the actual name of the event itself.
+ *
+ * @param sd: Data stream identifier.
+ * @param eventId: Identifier of the Event.
+ */
+QStringList getTepEvtName(int sd, int eventId)
+{
+	QString name(kshark_event_from_id(sd, eventId));
+
+	return name.split('/');
+}
+
+/**
+ * @brief Get a string to be used as a standard name of a task graph.
+ *
+ * @param sd: Graph's Data stream identifier.
+ * @param pid: Graph's progress Id.
+ */
+QString taskPlotName(int sd, int pid)
+{
+	kshark_context *kshark_ctx(nullptr);
+	kshark_data_stream *stream;
+	QString name;
+
+	if (!kshark_instance(&kshark_ctx))
+		return {};
+
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!stream)
+		return {};
+
+	name = kshark_comm_from_pid(sd, pid);
+	name += "-";
+	name += QString("%1").arg(pid);
+
+	return name;
+}
+
+/**
+ * @brief Get a description of the stream showing its data file and buffer
+ *	  name.
+ *
+ * @param stream: Input location for a Trace data stream pointer.
+ */
+QString streamDescription(kshark_data_stream *stream)
+{
+	QString descr(stream->file);
+	QString buffName(stream->name);
+	if (!buffName.isEmpty() && !kshark_tep_is_top_stream(stream)) {
+		descr += ":";
+		descr += stream->name;
+	}
+
+	return descr;
+}
+
 }; // KsUtils
 
 /** A stream operator for converting QColor into KsPlot::Color. */
@@ -370,10 +586,17 @@ KsPlot::Color& operator <<(KsPlot::Color &thisColor, const QColor &c)
 	return thisColor;
 }
 
+/** A stream operator for converting KsPlot::Color into QColor. */
+QColor& operator <<(QColor &thisColor, const KsPlot::Color &c)
+{
+	thisColor.setRgb(c.r(), c.g(), c.b());
+
+	return thisColor;
+}
+
 /** Create a default (empty) KsDataStore. */
 KsDataStore::KsDataStore(QWidget *parent)
 : QObject(parent),
-  _tep(nullptr),
   _rows(nullptr),
   _dataSize(0)
 {}
@@ -382,29 +605,127 @@ KsDataStore::KsDataStore(QWidget *parent)
 KsDataStore::~KsDataStore()
 {}
 
+int KsDataStore::_openDataFile(kshark_context *kshark_ctx,
+				const QString &file)
+{
+	int sd = kshark_open(kshark_ctx, file.toStdString().c_str());
+	if (sd < 0) {
+		qCritical() << "ERROR:" << sd << "while opening file " << file;
+		return sd;
+	}
+
+	if (kshark_is_tep(kshark_ctx->stream[sd])) {
+		kshark_tep_init_all_buffers(kshark_ctx, sd);
+		for (int i = 0; i < kshark_ctx->n_streams; ++i)
+			kshark_tep_handle_plugins(kshark_ctx, i);
+	}
+
+	return sd;
+}
+
+void KsDataStore::_addPluginsToStream(kshark_context *kshark_ctx, int sd,
+				      QVector<kshark_dpi *> plugins)
+{
+	kshark_data_stream *stream;
+
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!stream)
+		return;
+
+	for (auto const &p: plugins) {
+		struct kshark_dpi_list *plugin;
+
+		plugin = kshark_register_plugin_to_stream(stream, p, true);
+		kshark_handle_dpi(stream, plugin, KSHARK_PLUGIN_INIT);
+	}
+}
+
 /** Load trace data for file. */
-void KsDataStore::loadDataFile(const QString &file)
+int KsDataStore::loadDataFile(const QString &file,
+			       QVector<kshark_dpi *> plugins)
 {
 	kshark_context *kshark_ctx(nullptr);
+	int i, sd, n_streams;
 
 	if (!kshark_instance(&kshark_ctx))
-		return;
+		return -EFAULT;
 
 	clear();
 
-	if (!kshark_open(kshark_ctx, file.toStdString().c_str())) {
-		qCritical() << "ERROR Loading file " << file;
-		return;
+	sd = _openDataFile(kshark_ctx, file);
+	if (sd != 0)
+		return sd;
+
+	/*
+	 * The file may contain multiple buffers so we can have multiple
+	 * streams loaded.
+	 */
+	n_streams = kshark_ctx->n_streams;
+	for (i = 0; i < n_streams; ++i)
+		_addPluginsToStream(kshark_ctx, i, plugins);
+
+	_dataSize = kshark_load_all_entries(kshark_ctx, &_rows);
+	if (_dataSize <= 0) {
+		kshark_close_all(kshark_ctx);
+		return _dataSize;
 	}
 
-	_tep = kshark_ctx->pevent;
+	registerCPUCollections();
 
-	if (kshark_ctx->event_handlers == nullptr)
-		kshark_handle_plugins(kshark_ctx, KSHARK_PLUGIN_INIT);
-	else
-		kshark_handle_plugins(kshark_ctx, KSHARK_PLUGIN_UPDATE);
+	return sd;
+}
+
+/**
+ * @brief Append a trace data file to the data-set that is already loaded.
+ *	  The clock of the new data will be calibrated in order to be
+ *	  compatible with the clock of the prior data.
+ *
+ * @param file: Trace data file, to be append to the already loaded data.
+ * @param offset: The offset in time of the Data stream to be appended.
+ */
+int KsDataStore::appendDataFile(const QString &file, int64_t offset)
+{
+	kshark_context *kshark_ctx(nullptr);
+	struct kshark_entry **mergedRows;
+	ssize_t nLoaded = _dataSize;
+	int i, sd;
+
+	if (!kshark_instance(&kshark_ctx))
+		return -EFAULT;
+
+	unregisterCPUCollections();
+
+	sd = _openDataFile(kshark_ctx, file);
+	if (sd < 0)
+		return sd;
+
+	for (i = sd; i < kshark_ctx->n_streams; ++i) {
+		kshark_ctx->stream[sd]->calib = kshark_offset_calib;
+		kshark_ctx->stream[sd]->calib_array =
+			(int64_t *) calloc(1, sizeof(int64_t));
+		kshark_ctx->stream[sd]->calib_array[0] = offset;
+		kshark_ctx->stream[sd]->calib_array_size = 1;
+	}
+
+	_dataSize = kshark_append_all_entries(kshark_ctx, _rows, nLoaded, sd,
+					      &mergedRows);
+
+	if (_dataSize <= 0 || _dataSize == nLoaded) {
+		QErrorMessage *em = new QErrorMessage();
+		em->showMessage(QString("File %1 contains no data.").arg(file));
+		em->exec();
+
+		for (i = sd; i < kshark_ctx->n_streams; ++i)
+			kshark_close(kshark_ctx, i);
+
+		return _dataSize;
+	}
+
+	_rows = mergedRows;
+
+	registerCPUCollections();
 
-	_dataSize = kshark_load_data_entries(kshark_ctx, &_rows);
+	return sd;
 }
 
 void KsDataStore::_freeData()
@@ -430,8 +751,14 @@ void KsDataStore::reload()
 
 	_freeData();
 
-	_dataSize = kshark_load_data_entries(kshark_ctx, &_rows);
-	_tep = kshark_ctx->pevent;
+	if (kshark_ctx->n_streams == 0)
+		return;
+
+	unregisterCPUCollections();
+
+	_dataSize = kshark_load_all_entries(kshark_ctx, &_rows);
+
+	registerCPUCollections();
 
 	emit updateWidgets(this);
 }
@@ -441,11 +768,12 @@ void KsDataStore::clear()
 {
 	kshark_context *kshark_ctx(nullptr);
 
-	_freeData();
-	_tep = nullptr;
+	if (!kshark_instance(&kshark_ctx))
+		return;
 
-	if (kshark_instance(&kshark_ctx) && kshark_ctx->handle)
-		kshark_close(kshark_ctx);
+	_freeData();
+	unregisterCPUCollections();
+	kshark_close_all(kshark_ctx);
 }
 
 /** Update the visibility of the entries (filter). */
@@ -456,93 +784,113 @@ void KsDataStore::update()
 	if (!kshark_instance(&kshark_ctx))
 		return;
 
-	_unregisterCPUCollections();
+	unregisterCPUCollections();
 
-	if (kshark_filter_is_set(kshark_ctx)) {
-		kshark_filter_entries(kshark_ctx, _rows, _dataSize);
-		emit updateWidgets(this);
-	}
+	kshark_filter_all_entries(kshark_ctx, _rows, _dataSize);
 
 	registerCPUCollections();
+
+	emit updateWidgets(this);
 }
 
 /** Register a collection of visible entries for each CPU. */
 void KsDataStore::registerCPUCollections()
 {
 	kshark_context *kshark_ctx(nullptr);
+	int *streamIds, nCPUs, sd;
 
-	if (!kshark_instance(&kshark_ctx) ||
-	    !kshark_filter_is_set(kshark_ctx))
+	if (!kshark_instance(&kshark_ctx))
 		return;
 
-	int nCPUs = tep_get_cpus(_tep);
-	for (int cpu = 0; cpu < nCPUs; ++cpu) {
-		kshark_register_data_collection(kshark_ctx,
-						_rows, _dataSize,
-						KsUtils::matchCPUVisible,
-						cpu,
-						0);
+	streamIds = kshark_all_streams(kshark_ctx);
+	for (int i = 0; i < kshark_ctx->n_streams; ++i) {
+		sd = streamIds[i];
+
+		nCPUs = kshark_ctx->stream[sd]->n_cpus;
+		for (int cpu = 0; cpu < nCPUs; ++cpu) {
+			kshark_register_data_collection(kshark_ctx,
+							_rows, _dataSize,
+							KsUtils::matchCPUVisible,
+							sd, &cpu, 1,
+							0);
+		}
 	}
+
+	free(streamIds);
 }
 
-void KsDataStore::_unregisterCPUCollections()
+/** Unregister all CPU collections. */
+void KsDataStore::unregisterCPUCollections()
 {
 	kshark_context *kshark_ctx(nullptr);
+	int *streamIds, nCPUs, sd;
 
 	if (!kshark_instance(&kshark_ctx))
 		return;
 
-	int nCPUs = tep_get_cpus(_tep);
-	for (int cpu = 0; cpu < nCPUs; ++cpu) {
-		kshark_unregister_data_collection(&kshark_ctx->collections,
-						  KsUtils::matchCPUVisible,
-						  cpu);
+	streamIds = kshark_all_streams(kshark_ctx);
+	for (int i = 0; i < kshark_ctx->n_streams; ++i) {
+		sd = streamIds[i];
+
+		nCPUs = kshark_ctx->stream[sd]->n_cpus;
+		for (int cpu = 0; cpu < nCPUs; ++cpu) {
+			kshark_unregister_data_collection(&kshark_ctx->collections,
+							  KsUtils::matchCPUVisible,
+							  sd, &cpu, 1);
+		}
 	}
+
+	free(streamIds);
 }
 
-void KsDataStore::_applyIdFilter(int filterId, QVector<int> vec)
+void KsDataStore::_applyIdFilter(int filterId, QVector<int> vec, int sd)
 {
 	kshark_context *kshark_ctx(nullptr);
+	kshark_data_stream *stream;
 
 	if (!kshark_instance(&kshark_ctx))
 		return;
 
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!stream)
+		return;
+
 	switch (filterId) {
 		case KS_SHOW_EVENT_FILTER:
 		case KS_HIDE_EVENT_FILTER:
-			kshark_filter_clear(kshark_ctx, KS_SHOW_EVENT_FILTER);
-			kshark_filter_clear(kshark_ctx, KS_HIDE_EVENT_FILTER);
+			kshark_filter_clear(kshark_ctx, sd, KS_SHOW_EVENT_FILTER);
+			kshark_filter_clear(kshark_ctx, sd, KS_HIDE_EVENT_FILTER);
 			break;
 		case KS_SHOW_TASK_FILTER:
 		case KS_HIDE_TASK_FILTER:
-			kshark_filter_clear(kshark_ctx, KS_SHOW_TASK_FILTER);
-			kshark_filter_clear(kshark_ctx, KS_HIDE_TASK_FILTER);
+			kshark_filter_clear(kshark_ctx, sd, KS_SHOW_TASK_FILTER);
+			kshark_filter_clear(kshark_ctx, sd, KS_HIDE_TASK_FILTER);
 			break;
 		case KS_SHOW_CPU_FILTER:
 		case KS_HIDE_CPU_FILTER:
-			kshark_filter_clear(kshark_ctx, KS_SHOW_CPU_FILTER);
-			kshark_filter_clear(kshark_ctx, KS_HIDE_CPU_FILTER);
+			kshark_filter_clear(kshark_ctx, sd, KS_SHOW_CPU_FILTER);
+			kshark_filter_clear(kshark_ctx, sd, KS_HIDE_CPU_FILTER);
 			break;
 		default:
 			return;
 	}
 
 	for (auto &&val: vec)
-		kshark_filter_add_id(kshark_ctx, filterId, val);
+		kshark_filter_add_id(kshark_ctx, sd, filterId, val);
 
-	if (!_tep)
+	if (!kshark_ctx->n_streams)
 		return;
 
-	_unregisterCPUCollections();
+	unregisterCPUCollections();
 
 	/*
-	 * If the advanced event filter is set, the data has to be reloaded,
+	 * If the advanced event filter is set the data has to be reloaded,
 	 * because the advanced filter uses tep_records.
 	 */
-	if (kshark_ctx->advanced_event_filter->filters)
+	if (kshark_is_tep(stream) && kshark_tep_filter_is_set(stream))
 		reload();
 	else
-		kshark_filter_entries(kshark_ctx, _rows, _dataSize);
+		kshark_filter_stream_entries(kshark_ctx, sd, _rows, _dataSize);
 
 	registerCPUCollections();
 
@@ -550,381 +898,475 @@ void KsDataStore::_applyIdFilter(int filterId, QVector<int> vec)
 }
 
 /** Apply Show Task filter. */
-void KsDataStore::applyPosTaskFilter(QVector<int> vec)
+void KsDataStore::applyPosTaskFilter(int sd, QVector<int> vec)
 {
-	_applyIdFilter(KS_SHOW_TASK_FILTER, vec);
+	_applyIdFilter(KS_SHOW_TASK_FILTER, vec, sd);
 }
 
 /** Apply Hide Task filter. */
-void KsDataStore::applyNegTaskFilter(QVector<int> vec)
+void KsDataStore::applyNegTaskFilter(int sd, QVector<int> vec)
 {
-	_applyIdFilter(KS_HIDE_TASK_FILTER, vec);
+	_applyIdFilter(KS_HIDE_TASK_FILTER, vec, sd);
 }
 
 /** Apply Show Event filter. */
-void KsDataStore::applyPosEventFilter(QVector<int> vec)
+void KsDataStore::applyPosEventFilter(int sd, QVector<int> vec)
 {
-	_applyIdFilter(KS_SHOW_EVENT_FILTER, vec);
+	_applyIdFilter(KS_SHOW_EVENT_FILTER, vec, sd);
 }
 
 /** Apply Hide Event filter. */
-void KsDataStore::applyNegEventFilter(QVector<int> vec)
+void KsDataStore::applyNegEventFilter(int sd, QVector<int> vec)
 {
-	_applyIdFilter(KS_HIDE_EVENT_FILTER, vec);
+	_applyIdFilter(KS_HIDE_EVENT_FILTER, vec, sd);
 }
 
 /** Apply Show CPU filter. */
-void KsDataStore::applyPosCPUFilter(QVector<int> vec)
+void KsDataStore::applyPosCPUFilter(int sd, QVector<int> vec)
 {
-	_applyIdFilter(KS_SHOW_CPU_FILTER, vec);
+	_applyIdFilter(KS_SHOW_CPU_FILTER, vec, sd);
 }
 
 /** Apply Hide CPU filter. */
-void KsDataStore::applyNegCPUFilter(QVector<int> vec)
+void KsDataStore::applyNegCPUFilter(int sd, QVector<int> vec)
 {
-	_applyIdFilter(KS_HIDE_CPU_FILTER, vec);
+	_applyIdFilter(KS_HIDE_CPU_FILTER, vec, sd);
 }
 
 /** Disable all filters. */
 void KsDataStore::clearAllFilters()
 {
 	kshark_context *kshark_ctx(nullptr);
+	int *streamIds, sd;
 
-	if (!kshark_instance(&kshark_ctx) || !_tep)
+	if (!kshark_instance(&kshark_ctx) || !kshark_ctx->n_streams)
 		return;
 
-	_unregisterCPUCollections();
+	unregisterCPUCollections();
+
+	streamIds = kshark_all_streams(kshark_ctx);
+	for (int i = 0; i < kshark_ctx->n_streams; ++i) {
+		sd = streamIds[i];
+
+		kshark_filter_clear(kshark_ctx, sd, KS_SHOW_TASK_FILTER);
+		kshark_filter_clear(kshark_ctx, sd, KS_HIDE_TASK_FILTER);
+		kshark_filter_clear(kshark_ctx, sd, KS_SHOW_EVENT_FILTER);
+		kshark_filter_clear(kshark_ctx, sd, KS_HIDE_EVENT_FILTER);
+		kshark_filter_clear(kshark_ctx, sd, KS_SHOW_CPU_FILTER);
+		kshark_filter_clear(kshark_ctx, sd, KS_HIDE_CPU_FILTER);
+
+		if (kshark_is_tep(kshark_ctx->stream[sd]))
+			kshark_tep_filter_reset(kshark_ctx->stream[sd]);
+	}
 
-	kshark_filter_clear(kshark_ctx, KS_SHOW_TASK_FILTER);
-	kshark_filter_clear(kshark_ctx, KS_HIDE_TASK_FILTER);
-	kshark_filter_clear(kshark_ctx, KS_SHOW_EVENT_FILTER);
-	kshark_filter_clear(kshark_ctx, KS_HIDE_EVENT_FILTER);
-	kshark_filter_clear(kshark_ctx, KS_SHOW_CPU_FILTER);
-	kshark_filter_clear(kshark_ctx, KS_HIDE_CPU_FILTER);
+	free(streamIds);
 
-	tep_filter_reset(kshark_ctx->advanced_event_filter);
 	kshark_clear_all_filters(kshark_ctx, _rows, _dataSize);
+	registerCPUCollections();
 
 	emit updateWidgets(this);
 }
 
 /**
- * @brief Create Plugin Manager. Use list of plugins declared in the
- *	  CMake-generated header file.
+ * @brief Apply constant offset to the timestamps of all entries from a given
+ *	  Data stream.
+ *
+ * @param sd: Data stream identifier.
+ * @param offset: The constant offset to be added (in nanosecond).
  */
-KsPluginManager::KsPluginManager(QWidget *parent)
-: QObject(parent)
+void KsDataStore::setClockOffset(int sd, int64_t offset)
 {
 	kshark_context *kshark_ctx(nullptr);
-	_parsePluginList();
 
 	if (!kshark_instance(&kshark_ctx))
 		return;
 
-	registerFromList(kshark_ctx);
+	if (!kshark_get_data_stream(kshark_ctx, sd))
+		return;
+
+	unregisterCPUCollections();
+	kshark_set_clock_offset(kshark_ctx, _rows, _dataSize, sd, offset);
+	registerCPUCollections();
 }
 
-/** Parse the plugin list declared in the CMake-generated header file. */
-void KsPluginManager::_parsePluginList()
+/**
+ * @brief Create Plugin Manager. Use the list of plugins declared in the
+ *	  CMake-generated header file.
+ */
+KsPluginManager::KsPluginManager(QWidget *parent)
+: QObject(parent)
 {
-	_ksPluginList = KsUtils::getPluginList();
-	int nPlugins = _ksPluginList.count();
+	_loadPluginList(KsUtils::getPluginList());
+}
 
-	_registeredKsPlugins.resize(nPlugins);
+QVector<kshark_plugin_list *>
+KsPluginManager::_loadPluginList(const QStringList &plugins)
+{
+	kshark_context *kshark_ctx(nullptr);
+	QVector<kshark_plugin_list *> vec;
+	kshark_plugin_list *plugin;
+	std::string name, lib;
+	int nPlugins;
+
+	if (!kshark_instance(&kshark_ctx))
+		return vec;
+
+	nPlugins = plugins.count();
 	for (int i = 0; i < nPlugins; ++i) {
-		if (_ksPluginList[i].contains(" default", Qt::CaseInsensitive)) {
-			_ksPluginList[i].remove(" default", Qt::CaseInsensitive);
-			_registeredKsPlugins[i] = true;
+		if (plugins[i].endsWith(".so")) {
+			lib = plugins[i].toStdString();
+			name = _pluginNameFromLib(plugins[i]);
 		} else {
-			_registeredKsPlugins[i] = false;
+			lib = _pluginLibFromName(plugins[i]);
+			name = plugins[i].toStdString();
+		}
+
+		plugin = kshark_find_plugin(kshark_ctx->plugins,
+					    lib.c_str());
+
+		if (!plugin) {
+			plugin = kshark_register_plugin(kshark_ctx,
+							name.c_str(),
+							lib.c_str());
+
+			if (plugin)
+				vec.append(plugin);
 		}
 	}
+
+	return vec;
 }
 
 /**
- * Register the plugins by using the information in "_ksPluginList" and
- * "_registeredKsPlugins".
+ * @brief Get a list of all plugins registered to a given Data stream.
+ *
+ * @param sd: Data stream identifier.
+ * @return List of plugin names.
  */
-void KsPluginManager::registerFromList(kshark_context *kshark_ctx)
+QStringList KsPluginManager::getStreamPluginList(int sd) const
 {
-	auto lamRegBuiltIn = [&kshark_ctx, this](const QString &plugin)
-	{
-		char *lib;
-		int n;
-
-		lib = _pluginLibFromName(plugin, n);
-		if (n <= 0)
-			return;
+	kshark_context *kshark_ctx(nullptr);
+	kshark_data_stream *stream;
+	kshark_dpi_list *plugin;
+	QStringList list;
 
-		kshark_register_plugin(kshark_ctx, lib);
-		free(lib);
-	};
+	if (!kshark_instance(&kshark_ctx))
+		return {};
 
-	auto lamRegUser = [&kshark_ctx](const QString &plugin)
-	{
-		std::string lib = plugin.toStdString();
-		kshark_register_plugin(kshark_ctx, lib.c_str());
-	};
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!stream)
+		return {};
 
-	_forEachInList(_ksPluginList,
-		       _registeredKsPlugins,
-		       lamRegBuiltIn);
+	plugin = stream->plugins;
+	while (plugin) {
+		list.append(plugin->interface->name);
+		plugin = plugin->next;
+	}
 
-	_forEachInList(_userPluginList,
-		       _registeredUserPlugins,
-		       lamRegUser);
+	return list;
 }
 
 /**
- * Unegister the plugins by using the information in "_ksPluginList" and
- * "_registeredKsPlugins".
+ * @brief Get a list of all plugins registered to a given Data stream.
+ *
+ * @param sd: Data stream identifier.
  */
-void KsPluginManager::unregisterFromList(kshark_context *kshark_ctx)
+QVector<int> KsPluginManager::getActivePlugins(int sd) const
 {
-	auto lamUregBuiltIn = [&kshark_ctx, this](const QString &plugin)
-	{
-		char *lib;
-		int n;
+	kshark_context *kshark_ctx(nullptr);
+	kshark_data_stream *stream;
+	kshark_dpi_list *plugin;
+	QVector<int> vec;
+	int i(0);
 
-		lib = _pluginLibFromName(plugin, n);
-		if (n <= 0)
-			return;
+	if (!kshark_instance(&kshark_ctx))
+		return {};
 
-		kshark_unregister_plugin(kshark_ctx, lib);
-		free(lib);
-	};
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!stream)
+		return {};
 
-	auto lamUregUser = [&kshark_ctx](const QString &plugin)
-	{
-		std::string lib = plugin.toStdString();
-		kshark_unregister_plugin(kshark_ctx, lib.c_str());
-	};
+	plugin = stream->plugins;
 
-	_forEachInList(_ksPluginList,
-		       _registeredKsPlugins,
-			lamUregBuiltIn);
+	while (plugin) {
+		vec.append(plugin->status & KSHARK_PLUGIN_ENABLED);
+		plugin = plugin->next;
+		i++;
+	}
 
-	_forEachInList(_userPluginList,
-		       _registeredUserPlugins,
-			lamUregUser);
+	return vec;
 }
 
-char *KsPluginManager::_pluginLibFromName(const QString &plugin, int &n)
+/**
+ * @brief Get the indexes of all plugins registered to a given stream and
+ *	  having given status.
+ */
+QVector<int> KsPluginManager::getPluginsByStatus(int sd, int status) const
 {
-	QString appPath = QCoreApplication::applicationDirPath();
-	QString libPath = appPath + "/../../kernel-shark/lib";
-	std::string pluginStr = plugin.toStdString();
-	char *lib;
+	kshark_context *kshark_ctx(nullptr);
+	kshark_data_stream *stream;
+	kshark_dpi_list *plugin;
+	QVector<int> vec;
+	int i(0);
 
-	libPath = QDir::cleanPath(libPath);
-	if (!KsUtils::isInstalled() && QDir(libPath).exists()) {
-		std::string pathStr = libPath.toStdString();
-		n = asprintf(&lib, "%s/plugin-%s.so",
-			     pathStr.c_str(), pluginStr.c_str());
-	} else {
-		n = asprintf(&lib, "%s/plugin-%s.so",
-			     KS_PLUGIN_INSTALL_PREFIX, pluginStr.c_str());
+	if (!kshark_instance(&kshark_ctx))
+		return {};
+
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!stream)
+		return {};
+
+	plugin = stream->plugins;
+
+	while (plugin) {
+		if (plugin->status & status)
+			vec.append(i);
+
+		plugin = plugin->next;
+		i++;
 	}
 
-	return lib;
+	return vec;
 }
 
 /**
- * @brief Register a Plugin.
- *
- * @param plugin: provide here the name of the plugin (as in the CMake-generated
- *		  header file) of a name of the plugin's library file (.so).
+ * @brief Loop over the registered plugins and register all plugin-defined
+ *	  menus (if any).
  */
-void KsPluginManager::registerPlugin(const QString &plugin)
+void KsPluginManager::registerPluginMenues()
 {
 	kshark_context *kshark_ctx(nullptr);
-	char *lib;
-	int n;
+	kshark_plugin_list *plugin;
 
 	if (!kshark_instance(&kshark_ctx))
 		return;
 
-	for (int i = 0; i < _ksPluginList.count(); ++i) {
-		if (_ksPluginList[i] == plugin) {
-			/*
-			 * The argument is the name of the plugin. From the
-			 * name get the library .so file.
-			 */
-			lib = _pluginLibFromName(plugin, n);
-			if (n > 0) {
-				kshark_register_plugin(kshark_ctx, lib);
-				_registeredKsPlugins[i] = true;
-				free(lib);
+	for (plugin = kshark_ctx->plugins; plugin; plugin = plugin->next)
+		if (plugin->handle && plugin->ctrl_interface) {
+			void *dialogPtr = plugin->ctrl_interface(parent());
+			if (dialogPtr) {
+				QWidget *dialog =
+					static_cast<QWidget *>(dialogPtr);
+				_pluginDialogs.append(dialog);
 			}
+		}
+}
 
-			return;
+std::string KsPluginManager::_pluginLibFromName(const QString &plugin)
+{
+	QString appPath = QCoreApplication::applicationDirPath();
+	QString libPath = appPath + "/../lib";
+	std::string lib;
 
-		} else if (plugin.contains("/lib/plugin-" + _ksPluginList[i],
-					   Qt::CaseInsensitive)) {
-			/*
-			 * The argument is the name of the library .so file.
-			 */
-			n = asprintf(&lib, "%s", plugin.toStdString().c_str());
-			if (n > 0) {
-				kshark_register_plugin(kshark_ctx, lib);
-				_registeredKsPlugins[i] = true;
-				free(lib);
-			}
+	auto lamFileName = [&] () {
+		return std::string("/plugin-" + plugin.toStdString() + ".so");
+	};
 
-			return;
-		}
-	}
+	libPath = QDir::cleanPath(libPath);
+	if (!KsUtils::isInstalled() && QDir(libPath).exists())
+		lib = libPath.toStdString() + lamFileName();
+	else
+		lib = std::string(KS_PLUGIN_INSTALL_PREFIX) + lamFileName();
 
-	/* No plugin with this name in the list. Try to add it anyway. */
-	if (plugin.endsWith(".so") && QFileInfo::exists(plugin)) {
-		kshark_register_plugin(kshark_ctx,
-				       plugin.toStdString().c_str());
+	return lib;
+}
 
-		_userPluginList.append(plugin);
-		_registeredUserPlugins.append(true);
-	} else {
-		qCritical() << "ERROR: " << plugin << "cannot be registered!";
-	}
+std::string KsPluginManager::_pluginNameFromLib(const QString &plugin)
+{
+	QString name = plugin.section('/', -1);
+	name.remove("plugin-");
+	name.remove(".so");
+
+	return name.toStdString();
 }
 
-/** @brief Unregister a Built in KernelShark plugin.
- *<br>
- * WARNING: Do not use this function to unregister User plugins.
- * Instead use directly kshark_unregister_plugin().
+/**
+ * @brief Register a list pf plugins
  *
- * @param plugin: provide here the name of the plugin (as in the CMake-generated
- *		  header file) or a name of the plugin's library file (.so).
+ * @param pluginNames: Provide here the names of the plugin (as in the
+ *		       CMake-generated header file) or the names of the
+ *		       plugin's library files (.so including path).
+ * 		       The names must be comma separated.
+ */
+void KsPluginManager::registerPlugins(const QString &pluginNames)
+{
+	_userPlugins.append(_loadPluginList(pluginNames.split(',')));
+}
+
+/**
+ * @brief Unregister a list pf plugins.
  *
+ * @param pluginNames: Provide here a comma separated list of plugin names (as
+ *		       in the CMake-generated header file).
  */
-void KsPluginManager::unregisterPlugin(const QString &plugin)
+void KsPluginManager::unregisterPlugins(const QString &pluginNames)
 {
 	kshark_context *kshark_ctx(nullptr);
-	char *lib;
-	int n;
+	kshark_plugin_list *plugin;
+	kshark_data_stream *stream;
+	int *streamArray;
 
 	if (!kshark_instance(&kshark_ctx))
 		return;
 
-	for (int i = 0; i < _ksPluginList.count(); ++i) {
-		if (_ksPluginList[i] == plugin) {
-			/*
-			 * The argument is the name of the plugin. From the
-			 * name get the library .so file.
-			 */
-			lib = _pluginLibFromName(plugin, n);
-			if (n > 0) {
-				kshark_unregister_plugin(kshark_ctx, lib);
-				_registeredKsPlugins[i] = false;
-				free(lib);
-			}
-
-			return;
-		} else if (plugin.contains("/lib/plugin-" +
-			                   _ksPluginList[i], Qt::CaseInsensitive)) {
-			/*
-			 * The argument is the name of the library .so file.
-			 */
-			n = asprintf(&lib, "%s", plugin.toStdString().c_str());
-			if (n > 0) {
-				kshark_unregister_plugin(kshark_ctx, lib);
-				_registeredKsPlugins[i] = false;
-				free(lib);
-			}
+	for (auto const &name: pluginNames.split(',')) {
+		plugin = kshark_find_plugin_by_name(kshark_ctx->plugins,
+						    name.toStdString().c_str());
 
-			return;
+		streamArray = kshark_all_streams(kshark_ctx);
+		for  (int i = 0; i < kshark_ctx->n_streams; ++i) {
+			stream = kshark_get_data_stream(kshark_ctx,
+							streamArray[i]);
+			kshark_unregister_plugin_from_stream(stream,
+							     plugin->process_interface);
 		}
+
+		kshark_unregister_plugin(kshark_ctx,
+					 name.toStdString().c_str(),
+					 plugin->file);
 	}
 }
 
-/** @brief Add to the list and initialize user-provided plugins. All other
- *	   previously loaded plugins will be reinitialized and the data will be
- *	   reloaded.
- *
- * @param fileNames: the library files (.so) of the plugins.
-*/
-void KsPluginManager::addPlugins(const QStringList &fileNames)
+void KsPluginManager::_pluginToStream(const QString &pluginName,
+				      QVector<int> streamIds,
+				      bool reg)
 {
 	kshark_context *kshark_ctx(nullptr);
+	kshark_plugin_list *plugin;
+	kshark_data_stream *stream;
 
 	if (!kshark_instance(&kshark_ctx))
 		return;
 
-	kshark_handle_plugins(kshark_ctx, KSHARK_PLUGIN_CLOSE);
+	plugin = kshark_find_plugin_by_name(kshark_ctx->plugins,
+					    pluginName.toStdString().c_str());
 
-	for (auto const &p: fileNames)
-		registerPlugin(p);
+	if (!plugin || !plugin->process_interface)
+		return;
 
-	kshark_handle_plugins(kshark_ctx, KSHARK_PLUGIN_INIT);
+	for (auto const &sd: streamIds) {
+		stream = kshark_get_data_stream(kshark_ctx, sd);
+		if (!stream)
+			continue;
+
+		if (reg)
+			kshark_register_plugin_to_stream(stream,
+							 plugin->process_interface,
+							 true);
+		else
+			kshark_unregister_plugin_from_stream(stream,
+							     plugin->process_interface);
+
+		kshark_handle_all_dpis(stream, KSHARK_PLUGIN_UPDATE);
+	}
 
 	emit dataReload();
 }
 
-/** Unload all plugins. */
-void KsPluginManager::unloadAll()
+/**
+ * @brief Register a given plugin to given Data streams.
+ *
+ * @param pluginName: The name of the plugin to register.
+ * @param streamIds: Vector of Data stream identifiers.
+ */
+void KsPluginManager::registerPluginToStream(const QString &pluginName,
+					     QVector<int> streamIds)
+{
+	_pluginToStream(pluginName, streamIds, true);
+}
+
+/**
+ * @brief Unregister a given plugin from given Data streams.
+ *
+ * @param pluginName: The name of the plugin to unregister.
+ * @param streamIds: Vector of Data stream identifiers.
+ */
+void KsPluginManager::unregisterPluginFromStream(const QString &pluginName,
+						 QVector<int> streamIds)
+{
+	_pluginToStream(pluginName, streamIds, false);
+}
+
+/** @brief Add to the list and initialize user-provided plugins. All other
+ *	   previously loaded plugins will be reinitialized and the data will be
+ *	   reloaded.
+ *
+ * @param fileNames: The library files (.so) of the plugins.
+ * @param streamIds: Vector of Data stream identifiers. If the vector is empty
+ * 		     the plugins will be registered to all Data streams.
+ * 		     Otherwise the plugins will be registered to the listed
+ * 		     streams.
+*/
+void KsPluginManager::addPlugins(const QStringList &fileNames,
+				 QVector<int> streamIds)
 {
+	QVector<kshark_plugin_list *> plugins;
 	kshark_context *kshark_ctx(nullptr);
+	kshark_data_stream *stream;
 
 	if (!kshark_instance(&kshark_ctx))
 		return;
 
-	kshark_handle_plugins(kshark_ctx, KSHARK_PLUGIN_CLOSE);
-	kshark_free_plugin_list(kshark_ctx->plugins);
-	kshark_ctx->plugins = nullptr;
-	kshark_free_event_handler_list(kshark_ctx->event_handlers);
+	plugins = _loadPluginList(fileNames);
+	_userPlugins.append(plugins);
 
-	unregisterFromList(kshark_ctx);
+	if (streamIds.isEmpty())
+		streamIds = KsUtils::getStreamIdList(kshark_ctx);
+
+	for (auto const &sd: streamIds) {
+		stream = kshark_get_data_stream(kshark_ctx, sd);
+
+		for (auto const &p: plugins) {
+			if (p->process_interface)
+				kshark_register_plugin_to_stream(stream,
+								 p->process_interface,
+								 true);
+		}
+
+		kshark_handle_all_dpis(stream, KSHARK_PLUGIN_UPDATE);
+	}
 }
 
-/** @brief Update (change) the Plugins.
+/** @brief Update (change) the plugins for a given Data stream.
  *
- * @param pluginIds: The indexes of the plugins to be loaded.
+ * @param sd: Data stream identifier.
+ * @param pluginStates: A vector of plugin's states (0 or 1) telling which
+ *			plugins to be loaded.
  */
-void KsPluginManager::updatePlugins(QVector<int> pluginIds)
+void KsPluginManager::updatePlugins(int sd, QVector<int> pluginStates)
 {
 	kshark_context *kshark_ctx(nullptr);
+	kshark_data_stream *stream;
+	kshark_dpi_list *plugin;
+	QVector<int> vec;
+	int i(0);
 
 	if (!kshark_instance(&kshark_ctx))
 		return;
 
-	auto register_plugins = [&] (QVector<int> ids)
-	{
-		int nKsPlugins = _registeredKsPlugins.count();
-
-		/* First clear all registered plugins. */
-		for (auto &p: _registeredKsPlugins)
-			p = false;
-		for (auto &p: _registeredUserPlugins)
-			p = false;
-
-		/* The vector contains the indexes of those to register. */
-		for (auto const &p: ids) {
-			if (p < nKsPlugins)
-				_registeredKsPlugins[p] = true;
-			else
-				_registeredUserPlugins[p - nKsPlugins] = true;
-		}
-		registerFromList(kshark_ctx);
-	};
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!stream)
+		return;
 
-	if (!kshark_ctx->pevent) {
-		kshark_free_plugin_list(kshark_ctx->plugins);
-		kshark_ctx->plugins = nullptr;
+	plugin = stream->plugins;
+	while (plugin) {
+		if (pluginStates[i++])
+			plugin->status |= KSHARK_PLUGIN_ENABLED;
+		else
+			plugin->status &= ~KSHARK_PLUGIN_ENABLED;
 
-		/*
-		 * No data is loaded. For the moment, just register the
-		 * plugins. Handling of the plugins will be done after
-		 * we load a data file.
-		 */
-		register_plugins(pluginIds);
-		return;
+		plugin = plugin->next;
 	}
 
-	/* Clean up all old plugins first. */
-	unloadAll();
-
-	/* Now load. */
-	register_plugins(pluginIds);
-	kshark_handle_plugins(kshark_ctx, KSHARK_PLUGIN_INIT);
+	kshark_handle_all_dpis(stream, KSHARK_PLUGIN_UPDATE);
+}
 
-	emit dataReload();
+/**
+ * @brief Destroy all Plugin dialogs.
+ */
+void KsPluginManager::deletePluginDialogs()
+{
+	/** Delete all register plugin dialogs. */
+	for (auto &pd: _pluginDialogs)
+		delete pd;
 }
diff --git a/src/KsUtils.hpp b/src/KsUtils.hpp
index 2772b84..0d2c9c3 100644
--- a/src/KsUtils.hpp
+++ b/src/KsUtils.hpp
@@ -45,7 +45,15 @@ static auto stringWidth = [](QString s)
 	QFont font;
 	QFontMetrics fm(font);
 
+#ifdef QT_VERSION_LESS_5_11
+
+	return fm.width(s);
+
+#else
+
 	return fm.horizontalAdvance(s);
+
+#endif // QT_VERSION_LESS_5_11
 };
 
 //! @endcond
@@ -54,13 +62,13 @@ static auto stringWidth = [](QString s)
 #define FONT_HEIGHT		fontHeight()
 
 /** Macro providing the width of the font in pixels. */
-#define FONT_WIDTH 		stringWidth("4")
+#define FONT_WIDTH 		(stringWidth("KernelShark") / 11)
 
 /** Macro providing the width of a string in pixels. */
 #define STRING_WIDTH(s)		stringWidth(s)
 
 /** Macro providing the height of the KernelShark graphs in pixels. */
-#define KS_GRAPH_HEIGHT	(FONT_HEIGHT*2)
+#define KS_GRAPH_HEIGHT		(FONT_HEIGHT * 2)
 
 //! @cond Doxygen_Suppress
 
@@ -82,16 +90,27 @@ std::chrono::high_resolution_clock::now() - t0).count()
 
 namespace KsUtils {
 
-QVector<int> getCPUList();
+QVector<int> getCPUList(int sd);
+
+QVector<int> getPidList(int sd);
+
+QVector<int> getEventIdList(int sd);
+
+int getEventId(int sd, const QString &eventName);
+
+QString getEventName(int sd, int eventId);
+
+QStringList getEventFieldsList(int sd, int eventId);
 
-QVector<int> getPidList();
+kshark_event_field_format getEventFieldType(int sd, int eventId,
+					    const QString &fieldName);
 
-QVector<int> getEventIdList(tep_event_sort_type sortType=TEP_EVENT_SORT_ID);
+QVector<int> getStreamIdList(kshark_context *kshark_ctx);
 
-QVector<int> getFilterIds(tracecmd_filter_id *filter);
+QVector<int> getFilterIds(kshark_hash_id *filter);
 
-/** @brief Geat the list of plugins. */
-inline QStringList getPluginList() {return plugins.split(";");}
+/** @brief Geat the list of plugins provided by the package. */
+inline QStringList getPluginList() {return QString(KS_BUILTIN_PLUGINS).split(";");}
 
 void listFilterSync(bool state);
 
@@ -113,8 +132,8 @@ inline QString Ts2String(int64_t ts, int prec)
 	return QString::number(ts * 1e-9, 'f', prec);
 }
 
-bool matchCPUVisible(struct kshark_context *kshark_ctx,
-			      struct kshark_entry *e, int cpu);
+bool matchCPUVisible(kshark_context *kshark_ctx,
+		     kshark_entry *e, int sd, int *cpu);
 
 bool isInstalled();
 
@@ -134,10 +153,33 @@ QString getSaveFile(QWidget *parent,
 		    const QString &extension,
 		    QString &lastFilePath);
 
+void setElidedText(QLabel* label, QString text,
+		   enum Qt::TextElideMode mode,
+		   int labelWidth);
+
 QStringList splitArguments(QString cmd);
 
 QVector<int> parseIdList(QString v_str);
 
+QStringList getTepEvtName(int sd, int eventId);
+
+/** Get a string to be used as a standard name of a CPU graph. */
+inline QString cpuPlotName(int cpu) {return QString("CPU %1").arg(cpu);}
+
+QString taskPlotName(int sd, int pid);
+
+/** Get the total number of Data streams. */
+inline int getNStreams()
+{
+	kshark_context *kshark_ctx(nullptr);
+
+	if (!kshark_instance(&kshark_ctx))
+		return -1;
+	return kshark_ctx->n_streams;
+}
+
+QString streamDescription(kshark_data_stream *stream);
+
 }; // KsUtils
 
 /** Identifier of the Dual Marker active state. */
@@ -158,39 +200,49 @@ public:
 
 	~KsDataStore();
 
-	void loadDataFile(const QString &file);
+	int loadDataFile(const QString &file,
+			 QVector<kshark_dpi *> plugins);
+
+	int appendDataFile(const QString &file, int64_t shift);
 
 	void clear();
 
-	/** Get the trace event parser. */
-	tep_handle *tep() const {return _tep;}
+	/** Get the trace data array. */
+	kshark_entry **rows() const {return _rows;}
 
-	/** Get the trace data array.. */
-	struct kshark_entry **rows() const {return _rows;}
+	/** Get a reference of the trace data array. */
+	kshark_entry ***rows_r() {return &_rows;}
 
 	/** Get the size of the data array. */
 	ssize_t size() const {return _dataSize;}
 
+	/** Set the size of the data (number of entries). */
+	void setSize(ssize_t s) {_dataSize = s;}
+
 	void reload();
 
 	void update();
 
 	void registerCPUCollections();
 
-	void applyPosTaskFilter(QVector<int>);
+	void unregisterCPUCollections();
+
+	void applyPosTaskFilter(int sd, QVector<int> vec);
 
-	void applyNegTaskFilter(QVector<int>);
+	void applyNegTaskFilter(int sd, QVector<int> vec);
 
-	void applyPosEventFilter(QVector<int>);
+	void applyPosEventFilter(int sd, QVector<int> vec);
 
-	void applyNegEventFilter(QVector<int>);
+	void applyNegEventFilter(int sd, QVector<int> vec);
 
-	void applyPosCPUFilter(QVector<int>);
+	void applyPosCPUFilter(int sd, QVector<int> vec);
 
-	void applyNegCPUFilter(QVector<int>);
+	void applyNegCPUFilter(int sd, QVector<int> vec);
 
 	void clearAllFilters();
 
+	void setClockOffset(int sd, int64_t offset);
+
 signals:
 	/**
 	 * This signal is emitted when the data has changed and the View
@@ -199,75 +251,84 @@ signals:
 	void updateWidgets(KsDataStore *);
 
 private:
-	/** Page event used to parse the page. */
-	tep_handle		*_tep;
-
 	/** Trace data array. */
-	struct kshark_entry	**_rows;
+	kshark_entry		**_rows;
 
 	/** The size of the data array. */
 	ssize_t			_dataSize;
 
+	int _openDataFile(kshark_context *kshark_ctx, const QString &file);
+
 	void _freeData();
-	void _unregisterCPUCollections();
-	void _applyIdFilter(int filterId, QVector<int> vec);
+
+	void _applyIdFilter(int filterId, QVector<int> vec, int sd);
+
+	void _addPluginsToStream(kshark_context *kshark_ctx, int sd,
+				 QVector<kshark_dpi *> plugins);
 };
 
-/** A Plugin Manage class. */
+/** A Plugin Manager class. */
 class KsPluginManager : public QObject
 {
 	Q_OBJECT
 public:
 	explicit KsPluginManager(QWidget *parent = nullptr);
 
-	/** A list of available built-in plugins. */
-	QStringList	_ksPluginList;
+	QStringList getStreamPluginList(int sd) const;
+
+	QVector<int> getActivePlugins(int sd) const;
 
-	/** A list of registered built-in plugins. */
-	QVector<bool>	_registeredKsPlugins;
+	QVector<int> getPluginsByStatus(int sd, int status) const;
 
-	/** A list of available user plugins. */
-	QStringList	_userPluginList;
+	/** Get a list of all plugins added by the user. */
+	const QVector<kshark_plugin_list *>
+	getUserPlugins() const {return _userPlugins;}
 
-	/** A list of registered user plugins. */
-	QVector<bool>	_registeredUserPlugins;
+	void registerPluginMenues();
 
-	void registerFromList(kshark_context *kshark_ctx);
-	void unregisterFromList(kshark_context *kshark_ctx);
+	void updatePlugins(int sd, QVector<int> pluginStates);
 
-	void registerPlugin(const QString &plugin);
-	void unregisterPlugin(const QString &plugin);
+	void addPlugins(const QStringList &fileNames, QVector<int> streams);
 
-	void addPlugins(const QStringList &fileNames);
+	void registerPlugins(const QString &pluginNames);
 
-	void unloadAll();
+	void unregisterPlugins(const QString &pluginNames);
 
-	void updatePlugins(QVector<int> pluginId);
+	void registerPluginToStream(const QString &pluginName,
+				    QVector<int> streamId);
+
+	void unregisterPluginFromStream(const QString &pluginName,
+					QVector<int> streamId);
+
+	void deletePluginDialogs();
+
+	/** Append to the list of User plugin. */
+	void addUserPluginToList(kshark_plugin_list *p) {_userPlugins.append(p);}
 
 signals:
 	/** This signal is emitted when a plugin is loaded or unloaded. */
 	void dataReload();
 
 private:
-	void _parsePluginList();
-
-	char *_pluginLibFromName(const QString &plugin, int &n);
-
-	template <class T>
-	void _forEachInList(const QStringList &pl,
-			    const QVector<bool> &reg,
-			    T action)
-	{
-		int nPlugins;
-		nPlugins = pl.count();
-		for (int i = 0; i < nPlugins; ++i) {
-			if (reg[i]) {
-				action(pl[i]);
-			}
-		}
-	}
+	QVector<kshark_plugin_list *>	_userPlugins;
+
+	/** Plugin dialogs. */
+	QVector<QWidget *>		_pluginDialogs;
+
+	QVector<kshark_plugin_list *>
+	_loadPluginList(const QStringList &plugins);
+
+	std::string _pluginLibFromName(const QString &plugin);
+
+	std::string _pluginNameFromLib(const QString &plugin);
+
+	void _pluginToStream(const QString &pluginName,
+			     QVector<int> streamId,
+			     bool reg);
 };
 
 KsPlot::Color& operator <<(KsPlot::Color &thisColor, const QColor &c);
 
+QColor& operator <<(QColor &thisColor, const KsPlot::Color &c);
+
 #endif
diff --git a/tests/CMakeLists.txt b/tests/CMakeLists.txt
index a1e3085..17b586e 100644
--- a/tests/CMakeLists.txt
+++ b/tests/CMakeLists.txt
@@ -6,7 +6,7 @@ set(EXECUTABLE_OUTPUT_PATH           ${KS_TEST_DIR})
 add_executable(kshark-tests          libkshark-tests.cpp)
 target_include_directories(kshark-tests PRIVATE ${Boost_INCLUDE_DIRS})
 target_compile_definitions(kshark-tests PRIVATE "BOOST_TEST_DYN_LINK=1")
-target_link_libraries(kshark-tests   kshark
+target_link_libraries(kshark-tests   kshark-gui
                                      ${Boost_UNIT_TEST_FRAMEWORK_LIBRARY})
 
 add_test(NAME              "libkshark_tests"
diff --git a/tests/libkshark-tests.cpp b/tests/libkshark-tests.cpp
index 780a3fa..eb5cb1f 100644
--- a/tests/libkshark-tests.cpp
+++ b/tests/libkshark-tests.cpp
@@ -46,6 +46,7 @@ BOOST_AUTO_TEST_CASE(add_remove_streams)
 	BOOST_CHECK_EQUAL(sd, -ENODEV);
 
 	kshark_close_all(kshark_ctx);
+	kshark_free(kshark_ctx);
 }
 
 #define ARRAY_DEFAULT_SIZE	1000
-- 
2.25.1


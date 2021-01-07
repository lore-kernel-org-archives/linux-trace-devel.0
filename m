Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77A7FC433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Jan 2021 16:17:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D93C23428
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Jan 2021 16:17:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbhAGQRZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Jan 2021 11:17:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727753AbhAGQRY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Jan 2021 11:17:24 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB619C0612FA
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Jan 2021 08:16:09 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id r5so8211366eda.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Jan 2021 08:16:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xGd/Y7DJSDuSVCgPE4Mf12P9D9WMnhPsjFd8eKdwpe4=;
        b=OifyYe2pijcNLbKLeo8v+/dNDJ8w4lCowbT8ayZHvY1ooC/sPdD3t8BC51U85rqZrP
         OZV9LZ4QR1feXxHq5BQFtcrAsDf5Kx2eeUl9mV6sRjJOZIeCN70z7NyDKMOFWasLXjP8
         fuP4a33tstQUkVRhDpPOn6J5mkM/y5bTvPwDPWLiFVtoHXMElIVS1zFmiDlocVIyQWj0
         lD2Z/Pkb+FVKZ0JNX3dwsTUxIVf09rdBoKX0G3CflyYe8A+rlPQHIteuF+HrPRYe4ZHA
         T6UcApA0gVb8YnIt8XhT6ABxHduyXbmc5FDWnqSVGH2a8BMgh5RoZ1MlaENKe2aMRK6P
         E7Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xGd/Y7DJSDuSVCgPE4Mf12P9D9WMnhPsjFd8eKdwpe4=;
        b=tw0fUnd0/6nog7H1y7sFvIfmTLAXq/hgdPzSdY9i74K988NxPIFZhv+9zsk2CQeDyy
         Nl5awiT2jKEkCWrc+m7u6cynWBk+XWT41FeYz1mJFj8I86LO2Ypt5tOo0XRS6sE6AgpG
         swUHXqflFx94d9dzKRUw6xrwnrQ1BpIY8AuiMFb37Qwr1nFq2YBWYPuEASaGGu1tl49h
         OuPvEUTbaUt1HuZ0xqHPbZSmSquuSIeq50JYtlA3f4CqL8yAB7kOv3B5MfvsReZ+gH+A
         Fk3J6uZvc9QOo5/s0KyPrBDWsrIgKkaTwUgXuSdZwM2rcEEjn7cjLaTlzOpquYAJKl6o
         aNkQ==
X-Gm-Message-State: AOAM531NQ/ur4o5KmR+VHwD80EzEt97OIJlEegTxsaMpp+eIac+tnD0I
        0MPKHHF7G6axXUYdkEIgp2NSCN4udnZRxA==
X-Google-Smtp-Source: ABdhPJz7rDBR9pG63AIcbx3Seaqh6x4DBi6WQTKEdI95j2BzIIUgOEBxwxUNoFhGQot62Xhr85cSVg==
X-Received: by 2002:a50:d888:: with SMTP id p8mr2228563edj.147.1610036168534;
        Thu, 07 Jan 2021 08:16:08 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id j23sm2846212edv.45.2021.01.07.08.16.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 08:16:08 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 5/6] kernel-shark: Add plotting methods to KsPlugins
Date:   Thu,  7 Jan 2021 18:15:46 +0200
Message-Id: <20210107161547.207270-6-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210107161547.207270-1-y.karadz@gmail.com>
References: <20210107161547.207270-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

We add generic methods for visualizing the value of a given trace
event field or the relation between two given trace event field.
Those methods are taking advantage of the stored values of the event
fields in kshark_data_container objects and allow the visualization
plugin to process the data orders of magnitude faster.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/CMakeLists.txt |   3 +-
 src/KsPlugins.cpp  | 416 +++++++++++++++++++++++++++++++++++++++++++++
 src/KsPlugins.hpp  |  48 ++++++
 3 files changed, 466 insertions(+), 1 deletion(-)
 create mode 100644 src/KsPlugins.cpp

diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index e35b436..588cccd 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -41,7 +41,8 @@ if (OPENGL_FOUND)
 
     message(STATUS "libkshark-plot")
     add_library(kshark-plot  SHARED  libkshark-plot.c
-                                     KsPlotTools.cpp)
+                                     KsPlotTools.cpp
+                                     KsPlugins.cpp)
 
     target_link_libraries(kshark-plot  kshark
                                        ${GLUT_LIBRARY}
diff --git a/src/KsPlugins.cpp b/src/KsPlugins.cpp
new file mode 100644
index 0000000..ad9f478
--- /dev/null
+++ b/src/KsPlugins.cpp
@@ -0,0 +1,416 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2019 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+ */
+
+/**
+  *  @file    KsPlugins.cpp
+  *  @brief   KernelShark C++ plugin declarations.
+  */
+
+// C++
+#include<iostream>
+
+// KernelShark
+#include "KsPlugins.hpp"
+
+using namespace KsPlot;
+
+/**
+ * A pair of Bin Id and a trace event data field in this bin, that needs to be
+ * plotted.
+ */
+typedef std::forward_list<std::pair<int, kshark_data_field_int64 *>> PlotPointList;
+
+//! @cond Doxygen_Suppress
+
+typedef std::function<void(int, kshark_data_container *, ssize_t,
+			   PlotPointList *)> pushFunc;
+
+typedef std::function<void(kshark_data_container *, ssize_t,
+			   PlotPointList *)> resolveFunc;
+
+//! @endcond
+
+static void pointPlot(KsCppArgV *argvCpp, IsApplicableFunc isApplicable,
+		      pluginShapeFunc makeShape, Color col, float size)
+{
+	int nBins = argvCpp->_graph->size();
+
+	for (int bin = 0; bin < nBins; ++bin)
+		if (isApplicable(nullptr, bin))
+			argvCpp->_shapes->push_front(makeShape({argvCpp->_graph},
+							       {bin}, {},
+							       col, size));
+}
+
+static std::pair<ssize_t, ssize_t>
+getRange(kshark_trace_histo *histo, kshark_data_container *data)
+{
+	ssize_t firstEntry, lastEntry;
+	std::pair<ssize_t, ssize_t> err(-1, -2);
+
+	firstEntry = kshark_find_entry_field_by_time(histo->min,
+						     data->data,
+						     0,
+						     data->size - 1);
+
+	if (firstEntry == BSEARCH_ALL_SMALLER)
+		return err;
+
+	if (firstEntry == BSEARCH_ALL_GREATER)
+		firstEntry = 0;
+
+	lastEntry = kshark_find_entry_field_by_time(histo->max,
+						    data->data,
+						    firstEntry,
+						    data->size - 1);
+
+	if (lastEntry == BSEARCH_ALL_GREATER)
+		return err;
+
+	if (lastEntry == BSEARCH_ALL_SMALLER)
+		lastEntry = data->size - 1;
+
+	return {firstEntry, lastEntry};
+}
+
+static PlotPointList
+getInBinEvents(kshark_trace_histo *histo,
+	       kshark_data_container *data,
+	       IsApplicableFunc isApplicable,
+	       pushFunc push,
+	       resolveFunc resolve)
+{
+	int bin, lastBin(-1);
+	PlotPointList buffer;
+
+	auto lamIsOverflow = [] (int bin) {
+		return (bin == UPPER_OVERFLOW_BIN ||
+			bin == LOWER_OVERFLOW_BIN) ? true : false;
+	};
+
+	auto range = getRange(histo, data);
+
+	for (ssize_t i = range.second; i >= range.first; --i) {
+		if (isApplicable(data, i)) {
+			bin = ksmodel_get_bin(histo, data->data[i]->entry);
+			if (lamIsOverflow(bin))
+				continue;
+
+			if (bin != lastBin) {
+				push(bin, data, i, &buffer);
+				lastBin = bin;
+			} else {
+				resolve(data, i, &buffer);
+			}
+		}
+	}
+
+	return buffer;
+}
+
+static PlotPointList
+getLastInBinEvents(kshark_trace_histo *histo, kshark_data_container *data,
+		   IsApplicableFunc isApplicable)
+{
+	pushFunc push = [] (int bin, kshark_data_container *data, ssize_t i,
+			    PlotPointList *list) {
+		list->push_front({bin, data->data[i]});
+	};
+
+	/*
+	 * Do not resolve. This means that only the very last (in time)
+	 * appearance of the event in the bin will be visualized.
+	 */
+	resolveFunc resolve = [] (kshark_data_container *data, ssize_t i,
+				  PlotPointList *list) {};
+
+	return getInBinEvents(histo, data, isApplicable, push, resolve);
+}
+
+static PlotPointList
+getMaxInBinEvents(kshark_trace_histo *histo, kshark_data_container *data,
+		 IsApplicableFunc isApplicable)
+{
+	pushFunc push = [] (int bin, kshark_data_container *data, ssize_t i,
+			    PlotPointList *list) {
+		list->push_front({bin, data->data[i]});
+	};
+
+	/* Overwrite if bigger. */
+	resolveFunc resolve = [] (kshark_data_container *data, ssize_t i,
+				  PlotPointList *list) {
+		if (list->front().second < data->data[i])
+			list->front().second = data->data[i];
+	};
+
+	return getInBinEvents(histo, data, isApplicable, push, resolve);
+}
+
+
+static PlotPointList
+getMinInBinEvents(kshark_trace_histo *histo, kshark_data_container *data,
+		 IsApplicableFunc isApplicable)
+{
+	pushFunc push = [] (int bin, kshark_data_container *data, ssize_t i,
+			    PlotPointList *list) {
+		list->push_front({bin, data->data[i]});
+	};
+
+	/* Overwrite if smaller. */
+	resolveFunc resolve = [] (kshark_data_container *data, ssize_t i,
+				  PlotPointList *list) {
+		if (list->front().second > data->data[i])
+			list->front().second = data->data[i];
+	};
+
+	return getInBinEvents(histo, data, isApplicable, push, resolve);
+}
+
+//! @cond Doxygen_Suppress
+
+#define PLUGIN_MIN_BOX_SIZE 4
+
+//! @endcond
+
+static void intervalPlot(kshark_trace_histo *histo,
+			 kshark_data_container *dataEvtA,
+			 IsApplicableFunc checkFieldA,
+			 kshark_data_container *dataEvtB,
+			 IsApplicableFunc checkFieldB,
+			 Graph *graph,
+			 PlotObjList *shapes,
+			 pluginShapeFunc makeShape,
+			 Color col,
+			 float size)
+{
+	kshark_data_field_int64 *dataA, *dataB;
+	PlotPointList bufferA, bufferB;
+	int binA, binB;
+	int64_t tsB;
+
+	auto lamGetBin = [] (auto it) {return (*it).first;};
+
+	auto lamGetTime = [] (auto it) {return (*it).second->entry->ts;};
+
+	auto lamGetData = [] (auto it) {return (*it).second;};
+
+	bufferA = getLastInBinEvents(histo,
+				     dataEvtA,
+				     checkFieldA);
+
+	bufferB = getLastInBinEvents(histo,
+				     dataEvtB,
+				     checkFieldB);
+
+	if (bufferA.empty() || bufferB.empty())
+		return;
+
+	auto itA = bufferA.cbegin();
+	auto itB = bufferB.cbegin();
+	while (itA != bufferA.cend() && itB != bufferB.cend()) {
+		binA = lamGetBin(itA);
+		dataA = lamGetData(itA);
+
+		/*
+		 * We will draw a shape between "Event A" and "Event B".
+		 * Because the shape starts with "Event A", we will skip all
+		 * "Event B" entries before the "Event A" entry.
+		 */
+		do {
+			dataB = lamGetData(itB);
+			tsB = lamGetTime(itB);
+			binB = lamGetBin(itB);
+			itB++;
+		} while (itB != bufferB.cend() && tsB < lamGetTime(itA));
+
+		/*
+		 * The shape ends with "Event B" and we already have this
+		 * event. However, we have to make sure that we will start the
+		 * shape from the very last "Event A" entry, which is rigth
+		 * before the "Event B" entry, which we already selected.
+		 */
+		while (itA != bufferA.cend() && lamGetTime(itA) < tsB) {
+			dataA = lamGetData(itA);
+			binA = lamGetBin(itA);
+			itA++;
+		}
+
+		if (binB - binA >= PLUGIN_MIN_BOX_SIZE)
+			shapes->push_front(makeShape({graph},
+						     {binA, binB},
+						     {dataA, dataB},
+						     col, size));
+	}
+}
+
+/**
+ * @brief Generic plotting method for plugins. To be used for visualizing
+ *	  a trace events.
+ *
+ * @param argvCpp: The C++ arguments of the drawing function of the plugin.
+ * @param isApplicable: Check function used to select events from data
+ *		       container A.
+ * @param makeShape: Input location for a function pointer used to generate
+ *		     the shape to be plotted.
+ * @param col: The color of the shape to be plotted.
+ * @param size: The size of the shape to be plotted.
+ */
+void eventPlot(KsCppArgV *argvCpp,
+	       IsApplicableFunc isApplicable,
+	       pluginShapeFunc makeShape,
+	       Color col,
+	       float size)
+{
+	try {
+		pointPlot(argvCpp, isApplicable, makeShape, col, size);
+	} catch (const std::exception &exc) {
+		std::cerr << "Exception in eventPlot\n"
+			  << exc.what() << std::endl;
+	}
+}
+
+//! @cond Doxygen_Suppress
+
+enum class PlotWath {
+	Maximum,
+	Minimum,
+};
+
+//! @endcond
+
+static void eventFieldPlot(KsCppArgV *argvCpp,
+		    kshark_data_container *dataEvt,
+		    IsApplicableFunc checkField,
+		    PlotWath s,
+		    pluginShapeFunc makeShape,
+		    KsPlot::Color col,
+		    float size)
+{
+	PlotPointList buffer;
+
+	if (dataEvt->size == 0)
+		return;
+
+	if (!dataEvt->sorted)
+		kshark_data_container_sort(dataEvt);
+
+	try {
+		if (s == PlotWath::Maximum)
+			buffer = getMaxInBinEvents(argvCpp->_histo,
+						   dataEvt, checkField);
+
+		if  (s == PlotWath::Minimum)
+			buffer = getMinInBinEvents(argvCpp->_histo,
+						   dataEvt, checkField);
+
+		for (auto const &i: buffer) {
+			argvCpp->_shapes->push_front(makeShape({argvCpp->_graph},
+							       {i.first},
+							       {i.second},
+							       col, size));
+		}
+	} catch (const std::exception &exc) {
+		std::cerr << "Exception in eventFieldPlot\n"
+			  << exc.what() << std::endl;
+	}
+}
+
+/**
+ * @brief Generic plotting method for plugins. To be used for visualizing
+ *	  the value of a data fiels trace events.
+ *
+ * @param argvCpp: The C++ arguments of the drawing function of the plugin.
+ * @param dataEvt: Input location for the container of the Evant's data.
+ * @param checkField: Check function used to select events from data
+ *		       container.
+ * @param makeShape: Input location for a function pointer used to generate
+ *		     the shape to be plotted.
+ * @param col: The color of the shape to be plotted.
+ * @param size: The size of the shape to be plotted.
+ */
+void eventFieldPlotMax(KsCppArgV *argvCpp,
+		       kshark_data_container *dataEvt,
+		       IsApplicableFunc checkField,
+		       pluginShapeFunc makeShape,
+		       KsPlot::Color col,
+		       float size)
+{
+	eventFieldPlot(argvCpp, dataEvt, checkField,
+		       PlotWath::Maximum,
+		       makeShape, col, size);
+}
+
+/**
+ * @brief Generic plotting method for plugins. To be used for visualizing
+ *	  the value of a data fiels trace events.
+ *
+ * @param argvCpp: The C++ arguments of the drawing function of the plugin.
+ * @param dataEvt: Input location for the container of the Evant's data.
+ * @param checkField: check function used to select events from data
+ *		       container.
+ * @param makeShape: Input location for a function pointer used to generate
+ *		     the shape to be plotted.
+ * @param col: The color of the shape to be plotted.
+ * @param size: The size of the shape to be plotted.
+ */
+void eventFieldPlotMin(KsCppArgV *argvCpp,
+		       kshark_data_container *dataEvt,
+		       IsApplicableFunc checkField,
+		       pluginShapeFunc makeShape,
+		       KsPlot::Color col,
+		       float size)
+{
+	eventFieldPlot(argvCpp, dataEvt, checkField,
+		       PlotWath::Minimum,
+		       makeShape, col, size);
+}
+
+/**
+ * @brief Generic plotting method for plugins. To be used for visualizing
+ *	  the correlation between two trace events.
+ *
+ * @param argvCpp: The C++ arguments of the drawing function of the plugin.
+ * @param dataEvtA: Input location for the container of the Evant A data.
+ * @param checkFieldA: Check function used to select events from data
+ *		       container A.
+ * @param dataEvtB: Input location for the container of the Evant B data.
+ * @param checkFieldB: Check function used to select events from data
+ *		       container B.
+ * @param makeShape: Input location for a function pointer used to generate
+ *		     the shape to be plotted.
+ * @param col: The color of the shape to be plotted.
+ * @param size: The size of the shape to be plotted.
+ */
+void eventFieldIntervalPlot(KsCppArgV *argvCpp,
+			    kshark_data_container *dataEvtA,
+			    IsApplicableFunc checkFieldA,
+			    kshark_data_container *dataEvtB,
+			    IsApplicableFunc checkFieldB,
+			    pluginShapeFunc makeShape,
+			    KsPlot::Color col,
+			    float size)
+{
+	if (dataEvtA->size == 0 || dataEvtB->size == 0)
+		return;
+
+	if (!dataEvtA->sorted)
+		kshark_data_container_sort(dataEvtA);
+
+	if (!dataEvtB->sorted)
+		kshark_data_container_sort(dataEvtB);
+
+	try {
+		intervalPlot(argvCpp->_histo,
+			     dataEvtA, checkFieldA,
+			     dataEvtB, checkFieldB,
+			     argvCpp->_graph,
+			     argvCpp->_shapes,
+			     makeShape, col, size);
+	} catch (const std::exception &exc) {
+		std::cerr << "Exception in eventFieldIntervalPlot\n"
+			  << exc.what() << std::endl;
+	}
+}
diff --git a/src/KsPlugins.hpp b/src/KsPlugins.hpp
index 3955cdf..a19bb9d 100644
--- a/src/KsPlugins.hpp
+++ b/src/KsPlugins.hpp
@@ -12,6 +12,9 @@
 #ifndef _KS_PLUGINS_H
 #define _KS_PLUGINS_H
 
+// C++
+#include <functional>
+
 // KernelShark
 #include "libkshark-model.h"
 #include "KsPlotTools.hpp"
@@ -48,4 +51,49 @@ struct KsCppArgV {
  */
 #define KS_ARGV_TO_CPP(a) (reinterpret_cast<KsCppArgV *>(a))
 
+/**
+ * Function of this type has to be implemented by the user in order to use
+ * some of the Generic plotting method. The returned shape will be plotted
+ * by KernelShark on top of the existing Graph generated by the model.
+ */
+typedef std::function<KsPlot::PlotObject *(std::vector<const KsPlot::Graph *> graph,
+					   std::vector<int> bin,
+					   std::vector<kshark_data_field_int64 *> data,
+					   KsPlot::Color col,
+					   float size)> pluginShapeFunc;
+
+/**
+ * Function of this type has to be implemented by the user in order to use
+ * some of the Generic plotting method. The user must implement a logic
+ * deciding if the record, having a given index inside the data container has
+ * to be visualized.
+ */
+typedef std::function<bool(kshark_data_container *, ssize_t)> IsApplicableFunc;
+
+void eventPlot(KsCppArgV *argvCpp, IsApplicableFunc isApplicable,
+	       pluginShapeFunc makeShape, KsPlot::Color col, float size);
+
+void eventFieldPlotMax(KsCppArgV *argvCpp,
+		       kshark_data_container *dataEvt,
+		       IsApplicableFunc checkField,
+		       pluginShapeFunc makeShape,
+		       KsPlot::Color col,
+		       float size);
+
+void eventFieldPlotMin(KsCppArgV *argvCpp,
+		       kshark_data_container *dataEvt,
+		       IsApplicableFunc checkField,
+		       pluginShapeFunc makeShape,
+		       KsPlot::Color col,
+		       float size);
+
+void eventFieldIntervalPlot(KsCppArgV *argvCpp,
+			    kshark_data_container *dataEvtA,
+			    IsApplicableFunc checkFieldA,
+			    kshark_data_container *dataEvtB,
+			    IsApplicableFunc checkFieldB,
+			    pluginShapeFunc makeShape,
+			    KsPlot::Color col,
+			    float size);
+
 #endif
-- 
2.25.1


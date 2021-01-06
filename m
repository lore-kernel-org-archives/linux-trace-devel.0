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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 161A5C433DB
	for <linux-trace-devel@archiver.kernel.org>; Wed,  6 Jan 2021 16:12:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8C4F2251F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  6 Jan 2021 16:12:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727269AbhAFQM4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 6 Jan 2021 11:12:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726768AbhAFQM4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 6 Jan 2021 11:12:56 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10643C06135C
        for <linux-trace-devel@vger.kernel.org>; Wed,  6 Jan 2021 08:11:41 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id ga15so5772752ejb.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 06 Jan 2021 08:11:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NG2mRAXtUBlAi8ykl78rrf26sxKUhOMMWmLTIp4Nn04=;
        b=LjpEPJhnGBjfNJivcx1t/neYz+ajOR7OkPfZqkmxK91iaxHF9WIimvBSouGAnEVcD/
         XhIKwOSDA1qW8oCwdnPl/wUq23Vyfz0IJ0Hf4u/tPgn0L4JEDsgtUAKKTM6uLvKmKjIO
         ODZQZIO86jL+naKK+qCc4QdRArZEMZdndRqUULD0DCsj1/ewg5tJM8S4Jojx5tG0cLsi
         wH5yhVVkh8CAo5R31yw8rHA/U2r80qHCP0k49xe8kLJJrvXUgMZOyZQonkXeDKzM3cYk
         6MY5JcaKZQ7veIvp6rj+jSRpOOQgFgz1ovfZJFwJlkNmxPky9gkjiQJgKb8V51jF9N8+
         oSYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NG2mRAXtUBlAi8ykl78rrf26sxKUhOMMWmLTIp4Nn04=;
        b=KF1VFHYaZABPnnH06IzCM4OyF+mTDQFX73KTFN505LKPG1ZKoRrm/YnjuPnmguTq0/
         cRexBKhNz7z2boY3AUkKI5NFo5ZDnuIv1db/lMLQAHRzmx8JF/GvdiCLjE5f97pl07M1
         144xK8Pj7f+07fd6Dr/gloNju8zAPtkNc+i2Rj2MiqRWs1E2850efxxWwaWa4ILwCa/f
         EEevCbuXZ8FvTltaR9xMItTLrSNpCyAputQ2uDpiG2qFpeMCTAzvOUQ2cWWI4x5uk5sA
         irABwKSUgDPNADN2dUr6ytT2AaoHmSe038nzJPis8yQ206D9vEqlXHb25jIIEqxU8oDf
         FTjA==
X-Gm-Message-State: AOAM532DbFAfTPeEQANJ37ZZZIceac8B0gPUW+sF93ZWoZt8trsMadOx
        PI+087HmcnptvYKtZYb4sPM=
X-Google-Smtp-Source: ABdhPJw7OUe7Mpj7FvTJnslbSAnWtGIJGqebNvVpm+LgvMF3Fe1JYtlaoxzpSes/PWUTnbXFN5KBQg==
X-Received: by 2002:a17:907:4126:: with SMTP id mx6mr3334081ejb.91.1609949499466;
        Wed, 06 Jan 2021 08:11:39 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id q25sm1570041eds.85.2021.01.06.08.11.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 08:11:39 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 6/6] kernel-shark: Speed-up the sched_events plugin
Date:   Wed,  6 Jan 2021 18:11:20 +0200
Message-Id: <20210106161120.119085-7-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210106161120.119085-1-y.karadz@gmail.com>
References: <20210106161120.119085-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

General revision of the sched_events plugin that achieves much faster
processing of the wake-up latency, by using the new generic methods
for visualization of event's data field.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/CMakeLists.txt          |   2 +-
 src/libkshark-plugin.h      |   1 +
 src/libkshark-tepdata.c     |  34 ++++
 src/libkshark-tepdata.h     |   7 +
 src/plugins/CMakeLists.txt  |  11 +-
 src/plugins/SchedEvents.cpp | 310 +++++++---------------------
 src/plugins/sched_events.c  | 393 +++++++++++-------------------------
 src/plugins/sched_events.h  |  50 ++---
 8 files changed, 260 insertions(+), 548 deletions(-)

diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 588cccd..980e802 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -135,7 +135,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
 
 endif (Qt5Widgets_FOUND AND Qt5Network_FOUND)
 
-# add_subdirectory(plugins)
+add_subdirectory(plugins)
 
 find_program(DO_AS_ROOT pkexec)
 
diff --git a/src/libkshark-plugin.h b/src/libkshark-plugin.h
index e58d658..77887e5 100644
--- a/src/libkshark-plugin.h
+++ b/src/libkshark-plugin.h
@@ -19,6 +19,7 @@ extern "C" {
 // C
 #include <stdint.h>
 #include <stdbool.h>
+#include <assert.h>
 
 /* Quiet warnings over documenting simple structures */
 //! @cond Doxygen_Suppress
diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
index 724cff2..d4be052 100644
--- a/src/libkshark-tepdata.c
+++ b/src/libkshark-tepdata.c
@@ -1912,3 +1912,37 @@ int kshark_tep_find_top_stream(struct kshark_context *kshark_ctx,
 
 	return top_stream->stream_id;
 }
+
+static bool find_wakeup_event(struct tep_handle *tep, const char *wakeup_name,
+			      struct tep_event **waking_event_ptr)
+{
+	*waking_event_ptr = tep_find_event_by_name(tep, "sched", wakeup_name);
+
+	return (*waking_event_ptr)? true : false;
+}
+
+/**
+ * @brief Search the available trace events and retrieve a definition of
+ *	  a waking_event.
+ *
+ * @param tep: Input location for the the Page event object.
+ * @param waking_event_ptr: Output location for the the waking_event object.
+ *
+ * @returns True on success, otherwise False.
+ */
+bool define_wakeup_event(struct tep_handle *tep,
+			 struct tep_event **waking_event_ptr)
+{
+	bool wakeup_found;
+
+	wakeup_found = find_wakeup_event(tep, "sched_wakeup",
+					 waking_event_ptr);
+
+	wakeup_found |= find_wakeup_event(tep, "sched_wakeup_new",
+					  waking_event_ptr);
+
+	wakeup_found |= find_wakeup_event(tep, "sched_waking",
+					  waking_event_ptr);
+
+	return wakeup_found;
+}
diff --git a/src/libkshark-tepdata.h b/src/libkshark-tepdata.h
index 46b18c8..1b955be 100644
--- a/src/libkshark-tepdata.h
+++ b/src/libkshark-tepdata.h
@@ -105,6 +105,13 @@ int kshark_tep_find_top_stream(struct kshark_context *kshark_ctx,
 
 bool kshark_tep_is_top_stream(struct kshark_data_stream *stream);
 
+struct tep_event;
+
+struct tep_format_field;
+
+bool define_wakeup_event(struct tep_handle *tep,
+			 struct tep_event **wakeup_event);
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/src/plugins/CMakeLists.txt b/src/plugins/CMakeLists.txt
index 2da73f8..108bc5f 100644
--- a/src/plugins/CMakeLists.txt
+++ b/src/plugins/CMakeLists.txt
@@ -20,14 +20,13 @@ endfunction()
 set(PLUGIN_LIST "")
 BUILD_PLUGIN(NAME sched_events
              SOURCE sched_events.c SchedEvents.cpp)
-list(APPEND PLUGIN_LIST "sched_events default") # This plugin will be loaded by default
-# list(APPEND PLUGIN_LIST "sched_events") # This plugin isn't loaded by default
+list(APPEND PLUGIN_LIST "sched_events")
 
-BUILD_PLUGIN(NAME missed_events
-             SOURCE missed_events.c MissedEvents.cpp)
-list(APPEND PLUGIN_LIST "missed_events default") # This plugin will be loaded by default
+# BUILD_PLUGIN(NAME missed_events
+#              SOURCE missed_events.c MissedEvents.cpp)
+# list(APPEND PLUGIN_LIST "missed_events")
 
-install(TARGETS sched_events missed_events
+install(TARGETS ${PLUGIN_LIST}
         LIBRARY DESTINATION ${KS_PLUGIN_INSTALL_PREFIX}
         COMPONENT kernelshark)
 
diff --git a/src/plugins/SchedEvents.cpp b/src/plugins/SchedEvents.cpp
index 8408657..c85a059 100644
--- a/src/plugins/SchedEvents.cpp
+++ b/src/plugins/SchedEvents.cpp
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: LGPL-2.1
 
 /*
- * Copyright (C) 2018 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
+ * Copyright (C) 2018 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
  */
 
 /**
@@ -12,180 +12,39 @@
  */
 
 // C++
-#include<iostream>
-
-// C++ 11
-#include<functional>
-#include<unordered_set>
+#include <vector>
 
 // KernelShark
 #include "libkshark.h"
+#include "libkshark-plugin.h"
 #include "plugins/sched_events.h"
 #include "KsPlotTools.hpp"
 #include "KsPlugins.hpp"
 
-//! @cond Doxygen_Suppress
-
-#define PLUGIN_MIN_BOX_SIZE 4
-
-#define KS_TASK_COLLECTION_MARGIN 25
-
-//! @endcond
-
-extern struct plugin_sched_context *plugin_sched_context_handler;
-
-/** Sched Event identifier. */
-enum class SchedEvent {
-	/** Sched Switch Event. */
-	Switch,
+using namespace KsPlot;
 
-	/** Sched Wakeup Event. */
-	Wakeup,
-};
-
-static void pluginDraw(plugin_sched_context *plugin_ctx,
-		       kshark_context *kshark_ctx,
-		       kshark_trace_histo *histo,
-		       kshark_entry_collection *col,
-		       SchedEvent e,
-		       int pid,
-		       KsPlot::Graph *graph,
-		       KsPlot::PlotObjList *shapes)
+static PlotObject *makeShape(std::vector<const Graph *> graph,
+			     std::vector<int> bins,
+			     std::vector<kshark_data_field_int64 *>,
+			     Color col, float size)
 {
-	const kshark_entry *entryClose, *entryOpen, *entryME;
-	ssize_t indexClose(0), indexOpen(0), indexME(0);
-	std::function<void(int)> ifSchedBack;
-	KsPlot::Rectangle *rec = nullptr;
-	int height = graph->getHeight() * .3;
-
-	auto openBox = [&] (const KsPlot::Point &p)
-	{
-		/*
-		 * First check if we already have an open box. If we don't
-		 * have, open a new one.
-		 */
-		if (!rec)
-			rec = new KsPlot::Rectangle;
-
-		if (e == SchedEvent::Switch) {
-			/* Red box. */
-			rec->_color = KsPlot::Color(255, 0, 0);
-		} else {
-			/* Green box. */
-			rec->_color = KsPlot::Color(0, 255, 0);
-		}
-
-		rec->setFill(false);
-
-		rec->setPoint(0, p.x() - 1, p.y() - height);
-		rec->setPoint(1, p.x() - 1, p.y() - 1);
-	};
-
-	auto closeBox = [&] (const KsPlot::Point &p)
-	{
-		if (rec == nullptr)
-			return;
-
-		int boxSize = p.x() - rec->getPoint(0)->x;
-		if (boxSize < PLUGIN_MIN_BOX_SIZE) {
-			/* This box is too small. Don't try to plot it. */
-			delete rec;
-			rec = nullptr;
-			return;
-		}
-
-		rec->setPoint(3, p.x() - 1, p.y() - height);
-		rec->setPoint(2, p.x() - 1, p.y() - 1);
-
-		shapes->push_front(rec);
-		rec = nullptr;
-	};
-
-	for (int bin = 0; bin < graph->size(); ++bin) {
-		/*
-		 * Starting from the first element in this bin, go forward
-		 * in time until you find a trace entry that satisfies the
-		 * condition defined by kshark_match_pid.
-		 */
-		entryClose = ksmodel_get_entry_back(histo, bin, false,
-						 plugin_switch_match_entry_pid,
-						 pid, col, &indexClose);
-
-		entryME = ksmodel_get_task_missed_events(histo,
-							 bin, pid,
-							 col,
-							 &indexME);
-
-		if (e == SchedEvent::Switch) {
-			/*
-			 * Starting from the last element in this bin, go backward
-			 * in time until you find a trace entry that satisfies the
-			 * condition defined by plugin_switch_match_rec_pid.
-			 */
-			entryOpen =
-				ksmodel_get_entry_back(histo, bin, false,
-						       plugin_switch_match_rec_pid,
-						       pid, col, &indexOpen);
+	Rectangle *rec = new KsPlot::Rectangle;
+	Point p0 = graph[0]->bin(bins[0])._base;
+	Point p1 = graph[0]->bin(bins[1])._base;
+	int height = graph[0]->height() * .3;
 
-		} else {
-			/*
-			 * Starting from the last element in this bin, go backward
-			 * in time until you find a trace entry that satisfies the
-			 * condition defined by plugin_wakeup_match_rec_pid.
-			 */
-			entryOpen =
-				ksmodel_get_entry_back(histo, bin, false,
-						       plugin_wakeup_match_rec_pid,
-						       pid,
-						       col,
-						       &indexOpen);
+	rec->setFill(false);
+	rec->setPoint(0, p0.x() - 1, p0.y() - height);
+	rec->setPoint(1, p0.x() - 1, p0.y() - 1);
 
-			if (entryOpen) {
-				int cpu = ksmodel_get_cpu_back(histo, bin,
-								      pid,
-								      false,
-								      col,
-								      nullptr);
-				if (cpu >= 0) {
-					/*
-					 * The task is already running. Ignore
-					 * this wakeup event.
-					 */
-					entryOpen = nullptr;
-				}
-			}
-		}
-
-		if (rec) {
-			if (entryME || entryClose) {
-				/* Close the box in this bin. */
-				closeBox(graph->getBin(bin)._base);
-				if (entryOpen &&
-				    indexME < indexOpen &&
-				    indexClose < indexOpen) {
-					/*
-					 * We have a Sched switch entry that
-					 * comes after (in time) the closure of
-					 * the previous box. We have to open a
-					 * new box in this bin.
-					 */
-					openBox(graph->getBin(bin)._base);
-				}
-			}
-		} else {
-			if (entryOpen &&
-			    (!entryClose || indexClose < indexOpen)) {
-				/* Open a new box in this bin. */
-				openBox(graph->getBin(bin)._base);
-			}
-		}
-	}
+	rec->setPoint(3, p1.x() - 1, p1.y() - height);
+	rec->setPoint(2, p1.x() - 1, p1.y() - 1);
 
-	if (rec)
-		delete rec;
+	rec->_size = size;
+	rec->_color = col;
 
-	return;
-}
+	return rec;
+};
 
 /*
  * Ideally, the sched_switch has to be the last trace event recorded before the
@@ -199,49 +58,32 @@ static void pluginDraw(plugin_sched_context *plugin_ctx,
  * of the entry (this field is set during the first pass) to search for trailing
  * events after the "sched_switch".
  */
-static void secondPass(kshark_entry **data,
-		       kshark_entry_collection *col,
-		       int pid)
+static void secondPass(plugin_sched_context *plugin_ctx)
 {
-	if (!col)
-		return;
-
-	const kshark_entry *e;
-	kshark_entry *last;
-	int first, n;
-	ssize_t index;
-
-	/* Loop over the intervals of the data collection. */
-	for (size_t i = 0; i < col->size; ++i) {
-		first = col->break_points[i];
-		n = first - col->resume_points[i];
-
-		kshark_entry_request *req =
-			kshark_entry_request_alloc(first, n,
-						   plugin_switch_match_rec_pid,
-						   pid,
-						   false,
-						   KS_GRAPH_VIEW_FILTER_MASK);
-
-		e = kshark_get_entry_back(req, data, &index);
-		free(req);
-
-		if (!e || index < 0) {
-			/* No sched_switch event in this interval. */
+	kshark_data_container *cSS;
+	kshark_entry *e;
+	int pid_rec;
+
+	cSS = plugin_ctx->ss_data;
+	for (ssize_t i = 0; i < cSS->size; ++i) {
+		pid_rec = plugin_sched_get_pid(cSS->data[i]->field);
+		e = cSS->data[i]->entry;
+		if (!e->next || e->pid == 0 ||
+		    e->event_id == e->next->event_id ||
+		    pid_rec != e->next->pid)
 			continue;
-		}
 
 		/* Find the very last trailing event. */
-		for (last = data[index]; last->next; last = last->next) {
-			if (last->next->pid != pid) {
+		for (; e->next; e = e->next) {
+			if (e->next->pid != plugin_sched_get_pid(cSS->data[i]->field)) {
 				/*
 				 * This is the last trailing event. Change the
 				 * "pid" to be equal to the "next pid" of the
 				 * sched_switch event and leave a sign that you
 				 * edited this entry.
 				 */
-				last->pid = data[index]->pid;
-				last->visible &= ~KS_PLUGIN_UNTOUCHED_MASK;
+				e->pid = cSS->data[i]->entry->pid;
+				e->visible &= ~KS_PLUGIN_UNTOUCHED_MASK;
 				break;
 			}
 		}
@@ -252,62 +94,56 @@ static void secondPass(kshark_entry **data,
  * @brief Plugin's draw function.
  *
  * @param argv_c: A C pointer to be converted to KsCppArgV (C++ struct).
+ * @param sd: Data stream identifier.
  * @param pid: Process Id.
  * @param draw_action: Draw action identifier.
  */
-void plugin_draw(kshark_cpp_argv *argv_c, int pid, int draw_action)
+void plugin_draw(kshark_cpp_argv *argv_c, int sd, int pid, int draw_action)
 {
 	plugin_sched_context *plugin_ctx;
-	kshark_context *kshark_ctx(NULL);
-	kshark_entry_collection *col;
 
-	if (draw_action != KSHARK_PLUGIN_TASK_DRAW || pid == 0)
+	if (!(draw_action & KSHARK_TASK_DRAW) || pid == 0)
 		return;
 
-	plugin_ctx = plugin_sched_context_handler;
-	if (!plugin_ctx || !kshark_instance(&kshark_ctx))
+	plugin_ctx = __get_context(sd);
+	if (!plugin_ctx)
 		return;
 
 	KsCppArgV *argvCpp = KS_ARGV_TO_CPP(argv_c);
 
-	/*
-	 * Try to find a collections for this task. It is OK if
-	 * coll = NULL.
-	 */
-	col = kshark_find_data_collection(plugin_ctx->collections,
-					  plugin_match_pid, pid);
-	if (!col) {
-		/*
-		 * If a data collection for this task does not exist,
-		 * register a new one.
-		 */
-		kshark_entry **data = argvCpp->_histo->data;
-		int size = argvCpp->_histo->data_size;
-
-		col = kshark_add_collection_to_list(kshark_ctx,
-						    &plugin_ctx->collections,
-						    data, size,
-						    plugin_match_pid, pid,
-						    KS_TASK_COLLECTION_MARGIN);
+	if (!plugin_ctx->second_pass_done) {
+		/* The second pass is not done yet. */
+		secondPass(plugin_ctx);
+		plugin_ctx->second_pass_done = true;
 	}
 
-	if (!tracecmd_filter_id_find(plugin_ctx->second_pass_hash, pid)) {
-		/* The second pass for this task is not done yet. */
-		secondPass(argvCpp->_histo->data, col, pid);
-		tracecmd_filter_id_add(plugin_ctx->second_pass_hash, pid);
-	}
+	IsApplicableFunc checkFieldSW = [=] (kshark_data_container *d,
+					     ssize_t i) {
+		return d->data[i]->field == pid;
+	};
 
-	try {
-		pluginDraw(plugin_ctx, kshark_ctx,
-			   argvCpp->_histo, col,
-			   SchedEvent::Wakeup, pid,
-			   argvCpp->_graph, argvCpp->_shapes);
+	IsApplicableFunc checkFieldSS = [=] (kshark_data_container *d,
+					     ssize_t i) {
+		return !(plugin_sched_get_prev_state(d->data[i]->field) & 0x7f) &&
+		       plugin_sched_get_pid(d->data[i]->field) == pid;
+	};
 
-		pluginDraw(plugin_ctx, kshark_ctx,
-			   argvCpp->_histo, col,
-			   SchedEvent::Switch, pid,
-			   argvCpp->_graph, argvCpp->_shapes);
-	} catch (const std::exception &exc) {
-		std::cerr << "Exception in SchedEvents\n" << exc.what();
-	}
+	IsApplicableFunc checkEntryPid = [=] (kshark_data_container *d,
+					      ssize_t i) {
+		return d->data[i]->entry->pid == pid;
+	};
+
+	eventFieldIntervalPlot(argvCpp,
+			       plugin_ctx->sw_data, checkFieldSW,
+			       plugin_ctx->ss_data, checkEntryPid,
+			       makeShape,
+			       {0, 255, 0}, // Green
+			       -1);         // Default size
+
+	eventFieldIntervalPlot(argvCpp,
+			       plugin_ctx->ss_data, checkFieldSS,
+			       plugin_ctx->ss_data, checkEntryPid,
+			       makeShape,
+			       {255, 0, 0}, // Red
+			       -1);         // Default size
 }
diff --git a/src/plugins/sched_events.c b/src/plugins/sched_events.c
index d0fd15e..1596880 100644
--- a/src/plugins/sched_events.c
+++ b/src/plugins/sched_events.c
@@ -1,85 +1,92 @@
 // SPDX-License-Identifier: LGPL-2.1
 
 /*
- * Copyright (C) 2018 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
+ * Copyright (C) 2018 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
  */
 
 /**
  *  @file    sched_events.c
- *  @brief   Defines a callback function for Sched events used to registers the
- *	     "next" task (if not registered already) and to changes the value
- *	     of the "pid" field of the "sched_switch" entries such that, it
- *	     will be ploted as part of the "next" task.
+ *  @brief
  */
 
 // C
 #include <stdlib.h>
 #include <stdio.h>
-#include <assert.h>
+
+// trace-cmd
+#include "trace-cmd/trace-cmd.h"
 
 // KernelShark
 #include "plugins/sched_events.h"
+#include "libkshark-tepdata.h"
 
 /** Plugin context instance. */
-struct plugin_sched_context *plugin_sched_context_handler = NULL;
 
-static bool define_wakeup_event(struct tep_handle *tep, const char *wakeup_name,
-				struct tep_event **wakeup_event,
-				struct tep_format_field **pid_field)
-{
-	struct tep_event *event;
+//! @cond Doxygen_Suppress
 
-	event = tep_find_event_by_name(tep, "sched", wakeup_name);
-	if (!event)
-		return false;
+typedef unsigned long long tep_num_field_t;
 
-	*wakeup_event = event;
-	*pid_field = tep_find_any_field(event, "pid");
+#define PREV_STATE_SHIFT	((int) ((sizeof(ks_num_field_t) - 1) * 8))
 
-	return true;
+#define PREV_STATE_MASK		(((ks_num_field_t) 1 << 8) - 1)
+
+#define PID_MASK		(((ks_num_field_t) 1 << PREV_STATE_SHIFT) - 1)
+
+//! @endcond
+
+static void plugin_sched_set_pid(ks_num_field_t *field,
+				 tep_num_field_t pid)
+{
+	*field &= ~PID_MASK;
+	*field = pid & PID_MASK;
 }
 
-static void plugin_free_context(struct plugin_sched_context *plugin_ctx)
+/**
+ * @brief Retrieve the PID value from the data field stored in the
+ *	  kshark_data_container object.
+ *
+ * @param field: Input location for the data field.
+ */
+int plugin_sched_get_pid(ks_num_field_t field)
 {
-	if (!plugin_ctx)
-		return;
+	return field & PID_MASK;
+}
 
-	tracecmd_filter_id_hash_free(plugin_ctx->second_pass_hash);
-	kshark_free_collection_list(plugin_ctx->collections);
+/* Use the most significant byte to store the value of "prev_state". */
+static void plugin_sched_set_prev_state(ks_num_field_t *field,
+					tep_num_field_t prev_state)
+{
+	tep_num_field_t mask = PREV_STATE_MASK << PREV_STATE_SHIFT;
+	*field &= ~mask;
+	*field |= (prev_state & PREV_STATE_MASK) << PREV_STATE_SHIFT;
+}
 
-	free(plugin_ctx);
+/**
+ * @brief Retrieve the "prev_state" value from the data field stored in the
+ *	  kshark_data_container object.
+ *
+ * @param field: Input location for the data field.
+ */
+int plugin_sched_get_prev_state(ks_num_field_t field)
+{
+	tep_num_field_t mask = PREV_STATE_MASK << PREV_STATE_SHIFT;
+	return (field & mask) >> PREV_STATE_SHIFT;
 }
 
-static bool plugin_sched_init_context(struct kshark_context *kshark_ctx)
+static bool plugin_sched_init_context(struct kshark_data_stream *stream,
+				      struct plugin_sched_context *plugin_ctx)
 {
-	struct plugin_sched_context *plugin_ctx;
 	struct tep_event *event;
 	bool wakeup_found;
 
-	/* No context should exist when we initialize the plugin. */
-	assert(plugin_sched_context_handler == NULL);
-
-	plugin_sched_context_handler =
-		calloc(1, sizeof(*plugin_sched_context_handler));
-	if (!plugin_sched_context_handler) {
-		fprintf(stderr,
-			"Failed to allocate memory for plugin_sched_context.\n");
+	if (!kshark_is_tep(stream))
 		return false;
-	}
 
-	plugin_ctx = plugin_sched_context_handler;
-	plugin_ctx->handle = kshark_ctx->handle;
-	plugin_ctx->pevent = kshark_ctx->pevent;
-	plugin_ctx->collections = NULL;
-
-	event = tep_find_event_by_name(plugin_ctx->pevent,
+	plugin_ctx->tep = kshark_get_tep(stream);
+	event = tep_find_event_by_name(plugin_ctx->tep,
 				       "sched", "sched_switch");
-	if (!event) {
-		plugin_free_context(plugin_ctx);
-		plugin_sched_context_handler = NULL;
-
+	if (!event)
 		return false;
-	}
 
 	plugin_ctx->sched_switch_event = event;
 	plugin_ctx->sched_switch_next_field =
@@ -91,277 +98,121 @@ static bool plugin_sched_init_context(struct kshark_context *kshark_ctx)
 	plugin_ctx->sched_switch_prev_state_field =
 		tep_find_field(event, "prev_state");
 
+	wakeup_found = define_wakeup_event(plugin_ctx->tep,
+					   &plugin_ctx->sched_waking_event);
 
-	wakeup_found = define_wakeup_event(kshark_ctx->pevent, "sched_wakeup",
-					   &plugin_ctx->sched_wakeup_event,
-					   &plugin_ctx->sched_wakeup_pid_field);
-
-	wakeup_found |= define_wakeup_event(kshark_ctx->pevent, "sched_wakeup_new",
-					   &plugin_ctx->sched_wakeup_new_event,
-					   &plugin_ctx->sched_wakeup_new_pid_field);
+	if (wakeup_found) {
+		plugin_ctx->sched_waking_pid_field =
+			tep_find_any_field(plugin_ctx->sched_waking_event, "pid");
+	}
 
-	wakeup_found |= define_wakeup_event(kshark_ctx->pevent, "sched_waking",
-					   &plugin_ctx->sched_waking_event,
-					   &plugin_ctx->sched_waking_pid_field);
+	plugin_ctx->second_pass_done = false;
 
-	plugin_ctx->second_pass_hash = tracecmd_filter_id_hash_alloc();
+	plugin_ctx->ss_data = kshark_init_data_container();
+	plugin_ctx->sw_data = kshark_init_data_container();
+	if (!plugin_ctx->ss_data ||
+	    !plugin_ctx->sw_data)
+		return false;
 
 	return true;
 }
 
-/**
- * @brief Get the Process Id of the next scheduled task.
- *
- * @param record: Input location for a sched_switch record.
- */
-int plugin_get_next_pid(struct tep_record *record)
+static void plugin_sched_swith_action(struct kshark_data_stream *stream,
+				      void *rec, struct kshark_entry *entry)
 {
-	struct plugin_sched_context *plugin_ctx =
-		plugin_sched_context_handler;
-	unsigned long long val;
+	struct tep_record *record = (struct tep_record *) rec;
+	struct plugin_sched_context *plugin_ctx;
+	unsigned long long next_pid, prev_state;
+	ks_num_field_t ks_field;
 	int ret;
 
-	ret = tep_read_number_field(plugin_ctx->sched_switch_next_field,
-				    record->data, &val);
-
-	return ret ? : val;
-}
-
-static void plugin_register_command(struct kshark_context *kshark_ctx,
-				    struct tep_record *record,
-				    int pid)
-{
-	struct plugin_sched_context *plugin_ctx =
-		plugin_sched_context_handler;
-	const char *comm;
-
-	if (!plugin_ctx->sched_switch_comm_field)
+	plugin_ctx = __get_context(stream->stream_id);
+	if (!plugin_ctx)
 		return;
 
-	comm = record->data + plugin_ctx->sched_switch_comm_field->offset;
-	/*
-	 * TODO: The retrieve of the name of the command above needs to be
-	 * implemented as a wrapper function in libtracevent.
-	 */
-
-	if (!tep_is_pid_registered(kshark_ctx->pevent, pid))
-			tep_register_comm(kshark_ctx->pevent, comm, pid);
-}
-
-static int find_wakeup_pid(struct kshark_context *kshark_ctx, struct kshark_entry *e,
-		    struct tep_event *wakeup_event, struct tep_format_field *pid_field)
-{
-	struct tep_record *record;
-	unsigned long long val;
-	int ret;
-
-	if (!wakeup_event || e->event_id != wakeup_event->id)
-		return -1;
+	ret = tep_read_number_field(plugin_ctx->sched_switch_next_field,
+				    record->data, &next_pid);
 
-	record = tracecmd_read_at(kshark_ctx->handle, e->offset, NULL);
-	ret = tep_read_number_field(pid_field, record->data, &val);
-	free_record(record);
+	if (ret == 0 && next_pid >= 0) {
+		plugin_sched_set_pid(&ks_field, entry->pid);
 
-	if (ret)
-		return -1;
+		ret = tep_read_number_field(plugin_ctx->sched_switch_prev_state_field,
+					    record->data, &prev_state);
 
-	return val;
-}
+		if (ret == 0)
+			plugin_sched_set_prev_state(&ks_field, prev_state);
 
-static bool wakeup_match_rec_pid(struct plugin_sched_context *plugin_ctx,
-				 struct kshark_context *kshark_ctx,
-				 struct kshark_entry *e,
-				 int pid)
-{
-	struct tep_event *wakeup_events[] = {
-		plugin_ctx->sched_waking_event,
-		plugin_ctx->sched_wakeup_event,
-		plugin_ctx->sched_wakeup_new_event,
-	};
-	struct tep_format_field *wakeup_fields[] = {
-		plugin_ctx->sched_waking_pid_field,
-		plugin_ctx->sched_wakeup_pid_field,
-		plugin_ctx->sched_wakeup_new_pid_field,
-	};
-	int i, wakeup_pid = -1;
-
-	for (i = 0; i < sizeof(wakeup_events) / sizeof(wakeup_events[0]); i++) {
-		wakeup_pid = find_wakeup_pid(kshark_ctx, e, wakeup_events[i], wakeup_fields[i]);
-		if (wakeup_pid >= 0)
-			break;
+		kshark_data_container_append(plugin_ctx->ss_data, entry, ks_field);
+		entry->pid = next_pid;
 	}
-
-	if (wakeup_pid >= 0 && wakeup_pid == pid)
-		return true;
-
-	return false;
-}
-
-/**
- * @brief Process Id matching function adapted for sched_wakeup and
- *	  sched_wakeup_new events.
- *
- * @param kshark_ctx: Input location for the session context pointer.
- * @param e: kshark_entry to be checked.
- * @param pid: Matching condition value.
- *
- * @returns True if the Pid of the record matches the value of "pid".
- *	    Otherwise false.
- */
-bool plugin_wakeup_match_rec_pid(struct kshark_context *kshark_ctx,
-				 struct kshark_entry *e,
-				 int pid)
-{
-	struct plugin_sched_context *plugin_ctx;
-
-	plugin_ctx = plugin_sched_context_handler;
-	if (!plugin_ctx)
-		return false;
-
-	return wakeup_match_rec_pid(plugin_ctx, kshark_ctx, e, pid);
 }
 
-/**
- * @brief Process Id matching function adapted for sched_switch events.
- *
- * @param kshark_ctx: Input location for the session context pointer.
- * @param e: kshark_entry to be checked.
- * @param pid: Matching condition value.
- *
- * @returns True if the Pid of the record matches the value of "pid".
- *	    Otherwise false.
- */
-bool plugin_switch_match_rec_pid(struct kshark_context *kshark_ctx,
-				 struct kshark_entry *e,
-				 int pid)
+static void plugin_sched_wakeup_action(struct kshark_data_stream *stream,
+				       void *rec, struct kshark_entry *entry)
 {
+	struct tep_record *record = (struct tep_record *) rec;
 	struct plugin_sched_context *plugin_ctx;
 	unsigned long long val;
-	int ret, switch_pid = -1;
-
-	plugin_ctx = plugin_sched_context_handler;
-
-	if (plugin_ctx->sched_switch_event &&
-	    e->event_id == plugin_ctx->sched_switch_event->id) {
-		struct tep_record *record;
-
-		record = tracecmd_read_at(kshark_ctx->handle, e->offset, NULL);
-		ret = tep_read_number_field(plugin_ctx->sched_switch_prev_state_field,
-					    record->data, &val);
-
-		if (ret == 0 && !(val & 0x7f))
-			switch_pid = tep_data_pid(plugin_ctx->pevent, record);
+	int ret;
 
-		free_record(record);
-	}
+	plugin_ctx = __get_context(stream->stream_id);
+	if (!plugin_ctx)
+		return;
 
-	if (switch_pid >= 0 && switch_pid == pid)
-		return true;
+	ret = tep_read_number_field(plugin_ctx->sched_waking_pid_field,
+				    record->data, &val);
 
-	return false;
+	if (ret == 0)
+		kshark_data_container_append(plugin_ctx->sw_data, entry, val);
 }
 
-/**
- * @brief Process Id matching function adapted for sched_switch events.
- *
- * @param kshark_ctx: Input location for the session context pointer.
- * @param e: kshark_entry to be checked.
- * @param pid: Matching condition value.
- *
- * @returns True if the Pid of the entry matches the value of "pid".
- *	    Otherwise false.
- */
-bool plugin_switch_match_entry_pid(struct kshark_context *kshark_ctx,
-				   struct kshark_entry *e,
-				   int pid)
+/** Load this plugin. */
+int KSHARK_PLOT_PLUGIN_INITIALIZER(struct kshark_data_stream *stream)
 {
+	printf("--> sched init %i\n", stream->stream_id);
 	struct plugin_sched_context *plugin_ctx;
 
-	plugin_ctx = plugin_sched_context_handler;
-
-	if (plugin_ctx->sched_switch_event &&
-	    e->event_id == plugin_ctx->sched_switch_event->id &&
-	    e->pid == pid)
-		return true;
-
-	return false;
-}
-
-/**
- * @brief A match function to be used to process a data collections for
- *	  the Sched events plugin.
- *
- * @param kshark_ctx: Input location for the session context pointer.
- * @param e: kshark_entry to be checked.
- * @param pid: Matching condition value.
- *
- * @returns True if the entry is relevant for the Sched events plugin.
- *	    Otherwise false.
- */
-bool plugin_match_pid(struct kshark_context *kshark_ctx,
-		      struct kshark_entry *e, int pid)
-{
-	return plugin_switch_match_entry_pid(kshark_ctx, e, pid) ||
-	       plugin_switch_match_rec_pid(kshark_ctx, e, pid) ||
-	       plugin_wakeup_match_rec_pid(kshark_ctx, e, pid);
-}
-
-static void plugin_sched_action(struct kshark_context *kshark_ctx,
-				struct tep_record *rec,
-				struct kshark_entry *entry)
-{
-	int pid = plugin_get_next_pid(rec);
-	if (pid >= 0) {
-		entry->pid = pid;
-		plugin_register_command(kshark_ctx, rec, entry->pid);
+	plugin_ctx = __init(stream->stream_id);
+	if (!plugin_ctx || !plugin_sched_init_context(stream, plugin_ctx)) {
+		__close(stream->stream_id);
+		return 0;
 	}
-}
-
-static int plugin_sched_init(struct kshark_context *kshark_ctx)
-{
-	struct plugin_sched_context *plugin_ctx;
 
-	if (!plugin_sched_init_context(kshark_ctx))
-		return 0;
+	kshark_register_event_handler(stream,
+				      plugin_ctx->sched_switch_event->id,
+				      plugin_sched_swith_action);
 
-	plugin_ctx = plugin_sched_context_handler;
+	kshark_register_event_handler(stream,
+				      plugin_ctx->sched_waking_event->id,
+				      plugin_sched_wakeup_action);
 
-	kshark_register_event_handler(&kshark_ctx->event_handlers,
-				      plugin_ctx->sched_switch_event->id,
-				      plugin_sched_action,
-				      plugin_draw);
+	kshark_register_draw_handler(stream, plugin_draw);
 
 	return 1;
 }
 
-static int plugin_sched_close(struct kshark_context *kshark_ctx)
+/** Unload this plugin. */
+int KSHARK_PLOT_PLUGIN_DEINITIALIZER(struct kshark_data_stream *stream)
 {
+	printf("<-- sched close %i\n", stream->stream_id);
 	struct plugin_sched_context *plugin_ctx;
+	int sd = stream->stream_id;
 
-	if (!plugin_sched_context_handler)
+	plugin_ctx = __get_context(sd);
+	if (!plugin_ctx)
 		return 0;
 
-	plugin_ctx = plugin_sched_context_handler;
-
-	kshark_unregister_event_handler(&kshark_ctx->event_handlers,
+	kshark_unregister_event_handler(stream,
 					plugin_ctx->sched_switch_event->id,
-					plugin_sched_action,
-					plugin_draw);
+					plugin_sched_swith_action);
 
-	plugin_free_context(plugin_ctx);
-	plugin_sched_context_handler = NULL;
+	kshark_unregister_event_handler(stream,
+					plugin_ctx->sched_waking_event->id,
+					plugin_sched_wakeup_action);
 
-	return 1;
-}
+	kshark_unregister_draw_handler(stream, plugin_draw);
 
-/** Load this plugin. */
-int KSHARK_PLUGIN_INITIALIZER(struct kshark_context *kshark_ctx)
-{
-	return plugin_sched_init(kshark_ctx);
-}
+	__close(sd);
 
-/** Unload this plugin. */
-int KSHARK_PLUGIN_DEINITIALIZER(struct kshark_context *kshark_ctx)
-{
-	return plugin_sched_close(kshark_ctx);
+	return 1;
 }
diff --git a/src/plugins/sched_events.h b/src/plugins/sched_events.h
index dbc9963..4c57606 100644
--- a/src/plugins/sched_events.h
+++ b/src/plugins/sched_events.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: LGPL-2.1 */
 
 /*
- * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
+ * Copyright (C) 2017 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
  */
 
 /**
@@ -14,6 +14,7 @@
 
 // KernelShark
 #include "libkshark.h"
+#include "libkshark-plugin.h"
 
 #ifdef __cplusplus
 extern "C" {
@@ -21,11 +22,8 @@ extern "C" {
 
 /** Structure representing a plugin-specific context. */
 struct plugin_sched_context {
-	/** Input handle for the trace data file. */
-	struct tracecmd_input	*handle;
-
 	/** Page event used to parse the page. */
-	struct tep_handle	*pevent;
+	struct tep_handle	*tep;
 
 	/** Pointer to the sched_switch_event object. */
 	struct tep_event	*sched_switch_event;
@@ -39,47 +37,33 @@ struct plugin_sched_context {
 	/** Pointer to the sched_switch_prev_state_field format descriptor. */
 	struct tep_format_field	*sched_switch_prev_state_field;
 
-	/** Pointer to the sched_wakeup_event object. */
-	struct tep_event	*sched_wakeup_event;
-
-	/** Pointer to the sched_wakeup_pid_field format descriptor. */
-	struct tep_format_field	*sched_wakeup_pid_field;
-
-	/** Pointer to the sched_wakeup_new_event object. */
-	struct tep_event	*sched_wakeup_new_event;
-
-	/** Pointer to the sched_wakeup_new_pid_field format descriptor. */
-	struct tep_format_field	*sched_wakeup_new_pid_field;
-
 	/** Pointer to the sched_waking_event object. */
 	struct tep_event        *sched_waking_event;
 
 	/** Pointer to the sched_waking_pid_field format descriptor. */
 	struct tep_format_field *sched_waking_pid_field;
 
-	/** List of Data collections used by this plugin. */
-	struct kshark_entry_collection	*collections;
+	/** True if the second pass is already done. */
+	bool	second_pass_done;
 
-	/** Hash of the tasks for which the second pass is already done. */
-	struct tracecmd_filter_id	*second_pass_hash;
-};
+	/** Data container for sched_switch data. */
+	struct kshark_data_container	*ss_data;
 
-int plugin_get_next_pid(struct tep_record *record);
+	/** Data container for sched_waking data. */
+	struct kshark_data_container	*sw_data;
+};
 
-bool plugin_wakeup_match_rec_pid(struct kshark_context *kshark_ctx,
-				 struct kshark_entry *e, int pid);
+KS_DEFINE_PLUGIN_CONTEXT(struct plugin_sched_context);
 
-bool plugin_switch_match_rec_pid(struct kshark_context *kshark_ctx,
-				 struct kshark_entry *e, int pid);
+/** The type of the data field stored in the kshark_data_container object. */
+typedef int64_t ks_num_field_t;
 
-bool plugin_switch_match_entry_pid(struct kshark_context *kshark_ctx,
-				   struct kshark_entry *e,
-				   int pid);
+int plugin_sched_get_pid(ks_num_field_t field);
 
-bool plugin_match_pid(struct kshark_context *kshark_ctx,
-		      struct kshark_entry *e, int pid);
+int plugin_sched_get_prev_state(ks_num_field_t field);
 
-void plugin_draw(struct kshark_cpp_argv *argv, int pid, int draw_action);
+void plugin_draw(struct kshark_cpp_argv *argv, int sd, int pid,
+		 int draw_action);
 
 #ifdef __cplusplus
 }
-- 
2.25.1


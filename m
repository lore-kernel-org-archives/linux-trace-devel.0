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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2C61C43381
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Feb 2021 17:26:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 947CB64EAA
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Feb 2021 17:26:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbhBARZ7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Feb 2021 12:25:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbhBARZ6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Feb 2021 12:25:58 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EAA1C061355
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 Feb 2021 09:24:35 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id c6so19819046ede.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Feb 2021 09:24:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UjZajoxQn2imqdEFUY/RNy6CMLza2kPjVs4uI9lZQCI=;
        b=Lhq9Roe4cckoXI5mIl7rQXZxyN7HPdBE32tsrOYiGjwhOS71gk49OfoLLLUFiWBcrG
         MMsUA97Hw+qaJeG2qmMkOvIO3SXb/duy2xOJIGq49iv/UxVcp2H5XLrZwdi+QnBJkWlt
         +HlOa35n63vDRZT601AHwSDX2ryUqPeB/aW/aU4+oXECij9p6ShZFew/5sdy+tAA8e2s
         YHRsnux0q0zD4oTW/Uj5G1meOwPVGI3Bq63IViwGmSIMmXJ4OwrGuTbCriy8QchOD1kK
         loZFmstQnXkVGjfO4OPEcQB3nk5sn8vhamAeluuEg7UYV8y6zHHMHM/uvcEEe+6UmQkZ
         2NZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UjZajoxQn2imqdEFUY/RNy6CMLza2kPjVs4uI9lZQCI=;
        b=GhWtxJ/lxBhcUht0fn3/1xt21x7GYkhEipn9pyp5OBt58wXfER+Fe6rarLNk3+7IRz
         xzE7TXVj1rOuvao49aZPf0xo/Nw0TudeCD9jnE4mtxI7SkT2/Z+wUNeju78pfAvX9zt5
         DdpDGpsO8f07jm4PZnBvP6Z5limn887WUSMNnrJ56noAboAHs6Zy7YBJZRQ9yh94pfMm
         wM3WXu1O4Mo4sxO/dMriD76qrgV2lLWirtjHlwS8PqI/RaBlNS+k29BY1D6Bpy08kEvd
         yCFdxo97AUDVkPIGKl8WbVM3RsVCAxd3o4ezjup0eB+LcppR9E5v8uewrhtkv0D4LV/U
         nPLg==
X-Gm-Message-State: AOAM5331AzwmlcmLf+Ew04fFXIsmHvm7zH/+C3h6QBaO/dmu1KPW91RH
        3QlHkH0CV5Q6p8vYtety0TA=
X-Google-Smtp-Source: ABdhPJxl4syA7F6dLNCFTIq1vmCgh9e+qmjg8Ol+LUkfKRHJMkAe5wV737W+B4FO4rWjfN58u3vZ+g==
X-Received: by 2002:a05:6402:b6f:: with SMTP id cb15mr19610469edb.277.1612200273942;
        Mon, 01 Feb 2021 09:24:33 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.218])
        by smtp.gmail.com with ESMTPSA id bm9sm8312446ejb.14.2021.02.01.09.24.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 09:24:33 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 21/24] kernel-shark: Update MissedEvents plugin
Date:   Mon,  1 Feb 2021 19:23:55 +0200
Message-Id: <20210201172358.175407-22-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210201172358.175407-1-y.karadz@gmail.com>
References: <20210201172358.175407-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

General revision of the MissedEvents plugin that uses
the new generic methods for visualization of trace event.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/plugins/CMakeLists.txt    |   6 +-
 src/plugins/MissedEvents.cpp  | 105 ++++++++++++++--------------------
 src/plugins/missed_events.c   |  25 ++++----
 src/plugins/missed_events.h   |   4 +-
 tests/libkshark-gui-tests.cpp |   4 +-
 5 files changed, 62 insertions(+), 82 deletions(-)

diff --git a/src/plugins/CMakeLists.txt b/src/plugins/CMakeLists.txt
index 108bc5f..dc0c320 100644
--- a/src/plugins/CMakeLists.txt
+++ b/src/plugins/CMakeLists.txt
@@ -22,9 +22,9 @@ BUILD_PLUGIN(NAME sched_events
              SOURCE sched_events.c SchedEvents.cpp)
 list(APPEND PLUGIN_LIST "sched_events")
 
-# BUILD_PLUGIN(NAME missed_events
-#              SOURCE missed_events.c MissedEvents.cpp)
-# list(APPEND PLUGIN_LIST "missed_events")
+BUILD_PLUGIN(NAME missed_events
+             SOURCE missed_events.c MissedEvents.cpp)
+list(APPEND PLUGIN_LIST "missed_events")
 
 install(TARGETS ${PLUGIN_LIST}
         LIBRARY DESTINATION ${KS_PLUGIN_INSTALL_PREFIX}
diff --git a/src/plugins/MissedEvents.cpp b/src/plugins/MissedEvents.cpp
index 05dfcb5..cf0ed34 100644
--- a/src/plugins/MissedEvents.cpp
+++ b/src/plugins/MissedEvents.cpp
@@ -26,12 +26,8 @@ using namespace KsPlot;
  */
 class MissedEventsMark : public PlotObject {
 public:
-	/** Create a default Missed events marker. */
-	MissedEventsMark() : _base(0, 0), _height(0)
-	{
-		_color = {0, 0, 255};
-		_size = 2;
-	}
+	/** No default constructor. */
+	MissedEventsMark() = delete;
 
 	/**
 	 * @brief Create and position a Missed events marker.
@@ -40,17 +36,7 @@ public:
 	 * @param h: vertical size (height) of the marker.
 	 */
 	MissedEventsMark(const Point &p, int h)
-	: _base(p.x(), p.y()), _height(h)
-	{
-		_color = {0, 0, 255};
-		_size = 2;
-	}
-
-	/** Set the Base point of the marker. */
-	void setBase(const Point &p) {_base.set(p.x(), p.y());}
-
-	/** Set the vertical size (height) point of the marker. */
-	void setHeight(int h) {_height = h;}
+	: _base(p.x(), p.y()), _height(h) {}
 
 private:
 	/** Base point of the Mark's line. */
@@ -76,61 +62,38 @@ void MissedEventsMark::_draw(const Color &col, float size) const
 	rec.draw();
 }
 
+static PlotObject *makeShape(std::vector<const Graph *> graph,
+			     std::vector<int> bin,
+			     std::vector<kshark_data_field_int64 *>,
+			     Color col, float size)
+{
+	MissedEventsMark *mark = new MissedEventsMark(graph[0]->bin(bin[0])._base,
+						      graph[0]->height());
+	mark->_size = size;
+	mark->_color = col;
+
+	return mark;
+}
+
 //! @cond Doxygen_Suppress
 
 #define PLUGIN_MAX_ENTRIES		10000
 
-#define KS_TASK_COLLECTION_MARGIN	25
-
 //! @endcond
 
-static void pluginDraw(kshark_context *kshark_ctx,
-		       KsCppArgV *argvCpp,
-		       int val, int draw_action)
-{
-	int height = argvCpp->_graph->getHeight();
-	const kshark_entry *entry(nullptr);
-	MissedEventsMark *mark;
-	ssize_t index;
-
-	int nBins = argvCpp->_graph->size();
-	for (int bin = 0; bin < nBins; ++bin) {
-		if (draw_action == KSHARK_PLUGIN_TASK_DRAW)
-			entry = ksmodel_get_task_missed_events(argvCpp->_histo,
-							       bin, val,
-							       nullptr,
-							       &index);
-		if (draw_action == KSHARK_PLUGIN_CPU_DRAW)
-			entry = ksmodel_get_cpu_missed_events(argvCpp->_histo,
-							      bin, val,
-							      nullptr,
-							      &index);
-
-		if (entry) {
-			mark = new MissedEventsMark(argvCpp->_graph->getBin(bin)._base,
-						    height);
-
-			argvCpp->_shapes->push_front(mark);
-		}
-	}
-}
-
 /**
  * @brief Plugin's draw function.
  *
  * @param argv_c: A C pointer to be converted to KsCppArgV (C++ struct).
+ * @param sd: Data stream identifier.
  * @param val: Process or CPU Id value.
  * @param draw_action: Draw action identifier.
  */
 void draw_missed_events(kshark_cpp_argv *argv_c,
-			int val, int draw_action)
+			int sd, int val, int draw_action)
 {
-	kshark_context *kshark_ctx(NULL);
-
-	if (!kshark_instance(&kshark_ctx))
-		return;
-
 	KsCppArgV *argvCpp = KS_ARGV_TO_CPP(argv_c);
+	IsApplicableFunc checkEntry;
 
 	/*
 	 * Plotting the "Missed events" makes sense only in the case of a deep
@@ -141,9 +104,29 @@ void draw_missed_events(kshark_cpp_argv *argv_c,
 	if (argvCpp->_histo->tot_count > PLUGIN_MAX_ENTRIES)
 		return;
 
-	try {
-		pluginDraw(kshark_ctx, argvCpp, val, draw_action);
-	} catch (const std::exception &exc) {
-		std::cerr << "Exception in MissedEvents\n" << exc.what();
-	}
+	if (!(draw_action & KSHARK_CPU_DRAW) &&
+	    !(draw_action & KSHARK_TASK_DRAW))
+		return;
+
+	if (draw_action & KSHARK_CPU_DRAW)
+		checkEntry = [=] (kshark_data_container *, ssize_t bin) {
+			return !!ksmodel_get_cpu_missed_events(argvCpp->_histo,
+							       bin, sd, val,
+							       nullptr,
+							       nullptr);
+		};
+
+	else if (draw_action & KSHARK_TASK_DRAW)
+		checkEntry = [=] (kshark_data_container *, ssize_t bin) {
+			return !!ksmodel_get_task_missed_events(argvCpp->_histo,
+								bin, sd, val,
+								nullptr,
+								nullptr);
+		};
+
+	eventPlot(argvCpp,
+		  checkEntry,
+		  makeShape,
+		  {0, 0, 255}, // Blue
+		  -1);         // Default size
 }
diff --git a/src/plugins/missed_events.c b/src/plugins/missed_events.c
index cf652bf..8fe9780 100644
--- a/src/plugins/missed_events.c
+++ b/src/plugins/missed_events.c
@@ -10,32 +10,27 @@
  *	     ring buffer.
  */
 
+// C
+#include <stdio.h>
+
 // KernelShark
+#include "libkshark.h"
 #include "plugins/missed_events.h"
 
-static void nop_action(struct kshark_context *kshark_ctx,
-				struct tep_record *record,
-				struct kshark_entry *entry)
-{}
-
 /** Load this plugin. */
-int KSHARK_PLUGIN_INITIALIZER(struct kshark_context *kshark_ctx)
+int KSHARK_PLOT_PLUGIN_INITIALIZER(struct kshark_data_stream *stream)
 {
-	kshark_register_event_handler(&kshark_ctx->event_handlers,
-				      KS_EVENT_OVERFLOW,
-				      nop_action,
-				      draw_missed_events);
+	printf("--> missed_events init %i\n", stream->stream_id);
+	kshark_register_draw_handler(stream, draw_missed_events);
 
 	return 1;
 }
 
 /** Unload this plugin. */
-int KSHARK_PLUGIN_DEINITIALIZER(struct kshark_context *kshark_ctx)
+int KSHARK_PLOT_PLUGIN_DEINITIALIZER(struct kshark_data_stream *stream)
 {
-	kshark_unregister_event_handler(&kshark_ctx->event_handlers,
-					KS_EVENT_OVERFLOW,
-					nop_action,
-					draw_missed_events);
+	printf("<-- missed_events close %i\n", stream->stream_id);
+	kshark_unregister_draw_handler(stream, draw_missed_events);
 
 	return 1;
 }
diff --git a/src/plugins/missed_events.h b/src/plugins/missed_events.h
index e05d79a..10bc549 100644
--- a/src/plugins/missed_events.h
+++ b/src/plugins/missed_events.h
@@ -14,14 +14,14 @@
 #define _KS_PLUGIN_M_EVTS_H
 
 // KernelShark
-#include "libkshark.h"
+#include "libkshark-plugin.h"
 
 #ifdef __cplusplus
 extern "C" {
 #endif
 
 void draw_missed_events(struct kshark_cpp_argv *argv,
-			int pid, int draw_action);
+			int sd, int pid, int draw_action);
 
 #ifdef __cplusplus
 }
diff --git a/tests/libkshark-gui-tests.cpp b/tests/libkshark-gui-tests.cpp
index dedd69f..5a0ca01 100644
--- a/tests/libkshark-gui-tests.cpp
+++ b/tests/libkshark-gui-tests.cpp
@@ -146,7 +146,9 @@ BOOST_AUTO_TEST_CASE(KsUtils_KsDataStore)
 
 BOOST_AUTO_TEST_CASE(KsUtils_getPluginList)
 {
-	QStringList plugins{"sched_events"};
+	QStringList plugins{"sched_events",
+			    "missed_events"
+	};
 
 	BOOST_CHECK(getPluginList() == plugins);
 }
-- 
2.25.1


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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80D68C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:39:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BE0364E95
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:39:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbhBKKjL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Feb 2021 05:39:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbhBKKfv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Feb 2021 05:35:51 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD57C061224
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:44 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id f14so9257634ejc.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UjZajoxQn2imqdEFUY/RNy6CMLza2kPjVs4uI9lZQCI=;
        b=TWOnNW3N9oAmFpmL36B49jskFI+X0mLRp9nmsSf6uwKxMcA1Oa/sp4Pc2+hywupI9P
         3esDBabqWsgfYwoClIS/3J7hnlr1VPXMn9oE4YpfrP8yYoiRE3UepIJCg5WXIQiIqRxD
         a+xAvSfNGSSRwLuBUf8OXba48P6XXegVxVaLuNg4tm4AH0Lu+F3IhBf2u2SKS1YKy2V/
         kFAyEv/ypCAinvOe7VHIPdJpCG5kuLLgjDDQRUKEAiFQENrDse5v2t66jzmqz5gB0kFT
         xA7+nrP3sB9JM9HLjj/oPTbssNWU0yuNtCXZHDGZeiZZJ1OoT9UTj9m0G8ldGmdk/VDX
         J90w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UjZajoxQn2imqdEFUY/RNy6CMLza2kPjVs4uI9lZQCI=;
        b=gkmkfG89w6ddtT9HxvkQrdjx03+Qv84RchubMNz7RiL6Du/TQnepm6FaOGoNLMDPEY
         9PGg65BEk0T2g8ees+5Tn4GHJir+OSXtgCnIE6+uIwqUiaWhuZb2/qqZQGHzHliSP2/F
         rxRqck08NfygLvES6z8QeKIJvg4Ozv5zx4+HSUjn6D01uJAHGGRW7abaMLsm3YzFz8ve
         nsQJiFxeXqTUbB8qSPSGHNG6zUyO/RNAx37nE7N8DHPHZmL1B2+ktoLg3WvcOv2PcCWP
         n2uuLHXPaLN2i6ipBVUG9fgUyDAHgxoWn6bGuaUVqBd+8xhwUkYnoj7peoayKA1hQpas
         r9iA==
X-Gm-Message-State: AOAM533qye8IQR8ArCPY4hqNB7+bEjyqkmQ0ZPKVV4EldNyeDFygXfGD
        XhX8F3DAuQrxuIay+tU5mlI=
X-Google-Smtp-Source: ABdhPJyLC2OWUc4KnpJe1EznKCiwRMrZ4RruSp5Uiq4RjmezaxH9f0gsDckZLlM29ayelAXGC8Ac4g==
X-Received: by 2002:a17:906:3603:: with SMTP id q3mr7440299ejb.201.1613039562816;
        Thu, 11 Feb 2021 02:32:42 -0800 (PST)
Received: from localhost.localdomain (212-39-89-223.ip.btc-net.bg. [212.39.89.223])
        by smtp.gmail.com with ESMTPSA id bd27sm3514031edb.37.2021.02.11.02.32.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 02:32:42 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 22/27] kernel-shark: Update MissedEvents plugin
Date:   Thu, 11 Feb 2021 12:32:00 +0200
Message-Id: <20210211103205.418588-23-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211103205.418588-1-y.karadz@gmail.com>
References: <20210211103205.418588-1-y.karadz@gmail.com>
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


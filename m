Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F5B0C433E0
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Feb 2021 17:26:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F76B64EB8
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Feb 2021 17:26:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbhBAR0C (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Feb 2021 12:26:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbhBAR0A (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Feb 2021 12:26:00 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69594C0612F2
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 Feb 2021 09:24:37 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id f1so19765075edr.12
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Feb 2021 09:24:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xLf3Fl+xWuftd2VYf59QnU3QGZ3YTVp1f0ELakLs+/c=;
        b=nOQehYBOS+SYlG30x9lUiOnqabPtEvrDxprifGf9w361xAqUxeLL0pNkuoKVa7nJxj
         6nCrJYAxDd7APeDCQJYThSDBmRcA2O8p9vfRk2Is91Ke6Kyp7LK1SSx3yfZlKz83DsJ3
         zS1O/VcXyf+M/06NNEQhUz6Tbq0hvGNB12jdAKkjuSDuMlANgbuBxz7QSpYWj66ynat3
         EqV8j4aMgvqhTQ6SspWUFmPEb2XLOl5DR9zORQ5XM/UmtEXdsXuC/F8LRsKUI6ES+VNN
         RxsdQIkSy7mlvYgmZH0VLjOdtUMIeZUtkngJtJvKdcyRhzma2lEkExz73EWAOUpHVhWL
         pNXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xLf3Fl+xWuftd2VYf59QnU3QGZ3YTVp1f0ELakLs+/c=;
        b=DOwkd7erMLDR+mMMqAcS8X08V2Ux9CZAmsT+UthM+H3pT6tPvaqXVyILd/YETVQxqQ
         GThE9xfqjOXS1nv9QumKUmT2oNtSk7Yl2viZMvU0pJVeur+jSjAdlOPnh2an5/GqZDZt
         YR+eqd12gJc5ak++ajvO/EYXRJ5lFEfplFGm7UL/1ZMP5INQqUTcGiYobN/2w2w2xNyI
         aqCRkeNed7X8HmUA5TJLBMbhWtmE0BO/jOoL3cMl67t3Awdd4h4f1PuBVAm6Dh6nkSWI
         1oRc8uRNfEcA+Lij2UWm0s9a0ImhTxOQqqcII2oZCUU6N61jnieofjf48AhM1C8PWgkC
         XJCQ==
X-Gm-Message-State: AOAM531pw+LftQwRzR4MfCNH3emDQJt+djgGKPlhg9XsESQdQ5BSRS8Q
        LoV0iyUt4+LpGT5JuwmpTZk=
X-Google-Smtp-Source: ABdhPJw/x8nAv0IB1v39Q/nHZxAeQCKb/XzPJXF8ZkLrQF8PxQc9tQShw0Pq2wjuMPTeSz1c3FJjcg==
X-Received: by 2002:aa7:c64a:: with SMTP id z10mr6776667edr.61.1612200276180;
        Mon, 01 Feb 2021 09:24:36 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.218])
        by smtp.gmail.com with ESMTPSA id bm9sm8312446ejb.14.2021.02.01.09.24.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 09:24:35 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 23/24] kernel-shark: Clickable sched_event plugin shapes
Date:   Mon,  1 Feb 2021 19:23:57 +0200
Message-Id: <20210201172358.175407-24-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210201172358.175407-1-y.karadz@gmail.com>
References: <20210201172358.175407-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Here we make the latency boxes plotted by the sched_event plugin
clickable. When the box is clicked, the two events determining
the latency (sched_waking and sched_switch) are selected with the
markers. This is achieved by providing an implementation of the
corresponding interface of virtual functions in the definition
of the LatencyBox class. We also need to provide the plugin with
a pointer to the KsMainWindow object (the GUI itself) such that
the plugin can manipulate the markers.
---
 src/plugins/CMakeLists.txt  | 25 ++++++++++++++--
 src/plugins/SchedEvents.cpp | 58 +++++++++++++++++++++++++++++++++++--
 src/plugins/sched_events.c  |  7 +++++
 src/plugins/sched_events.h  |  3 ++
 4 files changed, 89 insertions(+), 4 deletions(-)

diff --git a/src/plugins/CMakeLists.txt b/src/plugins/CMakeLists.txt
index dc0c320..f8ecba6 100644
--- a/src/plugins/CMakeLists.txt
+++ b/src/plugins/CMakeLists.txt
@@ -17,9 +17,30 @@ function(BUILD_PLUGIN)
 
 endfunction()
 
+function(BUILD_GUI_PLUGIN)
+    set(options)
+    set(oneValueArgs NAME MOC)
+    set(multiValueArgs SOURCE)
+    cmake_parse_arguments(ADD_PLUGIN "${options}"
+                                     "${oneValueArgs}"
+                                     "${multiValueArgs}"
+                                     ${ARGN})
+
+    message(STATUS ${ADD_PLUGIN_NAME})
+
+    QT5_WRAP_CPP(plugin_moc ${ADD_PLUGIN_MOC})
+
+    add_library(${ADD_PLUGIN_NAME} SHARED ${plugin_moc} ${ADD_PLUGIN_SOURCE})
+    set_target_properties(${ADD_PLUGIN_NAME} PROPERTIES PREFIX "plugin-")
+    target_link_libraries(${ADD_PLUGIN_NAME} kshark kshark-gui)
+
+endfunction()
+
 set(PLUGIN_LIST "")
-BUILD_PLUGIN(NAME sched_events
-             SOURCE sched_events.c SchedEvents.cpp)
+
+BUILD_GUI_PLUGIN(NAME sched_events
+                 SOURCE sched_events.c SchedEvents.cpp)
+
 list(APPEND PLUGIN_LIST "sched_events")
 
 BUILD_PLUGIN(NAME missed_events
diff --git a/src/plugins/SchedEvents.cpp b/src/plugins/SchedEvents.cpp
index c85a059..a81182e 100644
--- a/src/plugins/SchedEvents.cpp
+++ b/src/plugins/SchedEvents.cpp
@@ -20,15 +20,69 @@
 #include "plugins/sched_events.h"
 #include "KsPlotTools.hpp"
 #include "KsPlugins.hpp"
+#include "KsMainWindow.hpp"
 
 using namespace KsPlot;
 
+static KsMainWindow *ks_ptr;
+
+/**
+ * @brief Provide the plugin with a pointer to the KsMainWindow object (the GUI
+ * itself) such that the plugin can manipulate the GUI.
+ */
+void *plugin_set_gui_ptr(void *gui_ptr)
+{
+	ks_ptr = static_cast<KsMainWindow *>(gui_ptr);
+	return nullptr;
+}
+
+/**
+ * This class represents the graphical element visualizing the latency between
+ *  sched_waking and sched_switch events.
+ */
+class LatencyBox : public Rectangle
+{
+	/** On double click do. */
+	void _doubleClick() const override
+	{
+		ks_ptr->markEntry(_data[1]->entry, DualMarkerState::B);
+		ks_ptr->markEntry(_data[0]->entry, DualMarkerState::A);
+	}
+
+public:
+	/** The trace record data that corresponds to this LatencyBox. */
+	std::vector<kshark_data_field_int64 *>	_data;
+
+	/**
+	 * @brief Distance between the click and the shape. Used to decide if
+	 *	  the double click action must be executed.
+	 *
+	 * @param x: X coordinate of the click.
+	 * @param y: Y coordinate of the click.
+	 *
+	 * @returns If the click is inside the box, the distance is zero.
+	 *	    Otherwise infinity.
+	 */
+	double distance(int x, int y) const override
+	{
+		if (x < pointX(0) || x > pointX(2))
+			return std::numeric_limits<double>::max();
+
+		if (y < pointY(0) || y > pointY(1))
+			return std::numeric_limits<double>::max();
+
+		return 0;
+	}
+};
+
 static PlotObject *makeShape(std::vector<const Graph *> graph,
 			     std::vector<int> bins,
-			     std::vector<kshark_data_field_int64 *>,
+			     std::vector<kshark_data_field_int64 *> data,
 			     Color col, float size)
 {
-	Rectangle *rec = new KsPlot::Rectangle;
+	LatencyBox *rec = new LatencyBox;
+	rec->_data = data;
+
 	Point p0 = graph[0]->bin(bins[0])._base;
 	Point p1 = graph[0]->bin(bins[1])._base;
 	int height = graph[0]->height() * .3;
diff --git a/src/plugins/sched_events.c b/src/plugins/sched_events.c
index 1596880..ac4a7bf 100644
--- a/src/plugins/sched_events.c
+++ b/src/plugins/sched_events.c
@@ -216,3 +216,10 @@ int KSHARK_PLOT_PLUGIN_DEINITIALIZER(struct kshark_data_stream *stream)
 
 	return 1;
 }
+
+/** Initialize the control interface of the plugin. */
+void *KSHARK_MENU_PLUGIN_INITIALIZER(void *gui_ptr)
+{
+	printf("--> sched init menu\n");
+	return plugin_set_gui_ptr(gui_ptr);
+}
diff --git a/src/plugins/sched_events.h b/src/plugins/sched_events.h
index 4c57606..78cfda0 100644
--- a/src/plugins/sched_events.h
+++ b/src/plugins/sched_events.h
@@ -53,6 +53,7 @@ struct plugin_sched_context {
 	struct kshark_data_container	*sw_data;
 };
 
+/** A general purpose macro is used to define plugin context. */
 KS_DEFINE_PLUGIN_CONTEXT(struct plugin_sched_context);
 
 /** The type of the data field stored in the kshark_data_container object. */
@@ -65,6 +66,8 @@ int plugin_sched_get_prev_state(ks_num_field_t field);
 void plugin_draw(struct kshark_cpp_argv *argv, int sd, int pid,
 		 int draw_action);
 
+void *plugin_set_gui_ptr(void *gui_ptr);
+
 #ifdef __cplusplus
 }
 #endif
-- 
2.25.1


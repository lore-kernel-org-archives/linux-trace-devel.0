Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C07EC433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:39:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 286D164E9A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:39:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhBKKjb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Feb 2021 05:39:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbhBKKf4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Feb 2021 05:35:56 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4963BC061226
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:46 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id w2so9208803ejk.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kkLjfQ6M3bLvsQcENjzj/wcN9hwZ8/IhXzWlIK3/UrE=;
        b=vgUAhZdGEoGKxhwnQKNEkPCOhxapydlK7fZZMGtLJnu5fCRJ38O1dP4v5CDGmUkYUB
         5JzV7C8EdKxmm7vzvgtLQO/V1giVETFlh0jxw6s7yWccb2mmI2SMK+LpRJ8RHtreta31
         v6N3ZMTbRSlVI8BMWTIW7GR+xfj3Xls9F/1GJAQeIz8tx2++yJvGbRjPaLmI9ku9Kkq2
         UwPe/6IT3lmLvQ++3ceMy81gD2MIXPeOrGt65xebxmo35bZGrrs795auDqrVPwjyQ5yl
         WAvsa353VvQ2q8uvXwDlHPOuh/RadmkyjddagT6PeZt66iIYxDiQKJGFqEK/ilKcE+Rt
         roJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kkLjfQ6M3bLvsQcENjzj/wcN9hwZ8/IhXzWlIK3/UrE=;
        b=g9mlkITvdcJ6JHIxj+N9h6ge+r/cySOHCEBOw8qMuV898/5nZTItR89xISnpgU5Gt8
         vTocP1dc/xkjpNa0Ag/ngNUEM+poVlA3DbTn3MuoiAvFOVW4x6kJkf2CcooEUNeEp0pI
         UBoiPORgGnjV2ZN/P5V6GFwb5qoE4Qzvljjm33Tx//far4xcpF0PzoD4zsn6g/A/M0/1
         jK8Nl8CKTNlidNgGHISsdQ4+h/p2XE+8TECXvGHmV3DWtBabPABGIbGlbN7+eyhGg/E8
         qI6VlFg0qEJfmhytj5CeIeGwbt/NLpaJAYANo0alvmEMAMEj7/OMBmIO1fczjiCiI6MH
         QSVg==
X-Gm-Message-State: AOAM532XI+/XT0aQUHBl0nqt5aktHPpCWnqPknDlgm8WtDFwc5IfR0be
        S3Kh/foJ7VuUf+X3LgqklV2YtvmEuk0=
X-Google-Smtp-Source: ABdhPJw2CnlEAPWcl3NKPsK+eYHadKwTaywOBGwychzBSR1gya64//3MXEe4PRbHoXG/Lhjl55C2tg==
X-Received: by 2002:a17:906:1bf2:: with SMTP id t18mr8136677ejg.166.1613039565069;
        Thu, 11 Feb 2021 02:32:45 -0800 (PST)
Received: from localhost.localdomain (212-39-89-223.ip.btc-net.bg. [212.39.89.223])
        by smtp.gmail.com with ESMTPSA id bd27sm3514031edb.37.2021.02.11.02.32.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 02:32:44 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 24/27] kernel-shark: Clickable sched_event plugin shapes
Date:   Thu, 11 Feb 2021 12:32:02 +0200
Message-Id: <20210211103205.418588-25-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211103205.418588-1-y.karadz@gmail.com>
References: <20210211103205.418588-1-y.karadz@gmail.com>
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
 src/plugins/CMakeLists.txt  | 30 +++++++++++++++++--
 src/plugins/SchedEvents.cpp | 58 +++++++++++++++++++++++++++++++++++--
 src/plugins/sched_events.c  |  7 +++++
 src/plugins/sched_events.h  |  3 ++
 4 files changed, 93 insertions(+), 5 deletions(-)

diff --git a/src/plugins/CMakeLists.txt b/src/plugins/CMakeLists.txt
index dc0c320..5e28368 100644
--- a/src/plugins/CMakeLists.txt
+++ b/src/plugins/CMakeLists.txt
@@ -17,10 +17,34 @@ function(BUILD_PLUGIN)
 
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
-list(APPEND PLUGIN_LIST "sched_events")
+
+if (Qt5Widgets_FOUND AND TT_FONT_FILE)
+
+    BUILD_GUI_PLUGIN(NAME sched_events
+                     SOURCE sched_events.c SchedEvents.cpp)
+    list(APPEND PLUGIN_LIST "sched_events")
+
+endif (Qt5Widgets_FOUND AND TT_FONT_FILE)
 
 BUILD_PLUGIN(NAME missed_events
              SOURCE missed_events.c MissedEvents.cpp)
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


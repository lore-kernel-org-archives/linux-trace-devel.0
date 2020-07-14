Return-Path: <SRS0=mFmS=AZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C357CC433E0
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Jul 2020 21:23:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D31920739
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Jul 2020 21:23:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728092AbgGNVXV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Jul 2020 17:23:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:60658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727935AbgGNVXV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Jul 2020 17:23:21 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE02F20672;
        Tue, 14 Jul 2020 21:23:20 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jvSOW-004vXW-0e; Tue, 14 Jul 2020 17:23:20 -0400
Message-ID: <20200714212319.903321346@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 14 Jul 2020 17:19:30 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Namhyung Kim <namhyung@kernel.org>,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 1/8] libtraceevent: Document tep_load_plugins_hook()
References: <20200714211929.828530560@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

Add description of tep_load_plugins_hook() traceevent API.

Link: https://lore.kernel.org/r/CAM9d7cgLBWCrEHwz+Lhv5x5EXGcNWB0QQoeGh3OKh2JfR=dV9Q@mail.gmail.com
Link: https://lore.kernel.org/linux-trace-devel/20200714103027.2477584-2-tz.stoyanov@gmail.com

Suggested-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 lib/traceevent/event-plugin.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/lib/traceevent/event-plugin.c b/lib/traceevent/event-plugin.c
index 30c1526d3d06..c11636cea380 100644
--- a/lib/traceevent/event-plugin.c
+++ b/lib/traceevent/event-plugin.c
@@ -544,6 +544,22 @@ load_plugins_dir(struct tep_handle *tep, const char *suffix,
 	closedir(dir);
 }
 
+/**
+ * tep_load_plugins_hook - call a user specified callback to load a plugin
+ * @tep: handler to traceevent context
+ * @suffix: filter only plugin files with given suffix
+ * @load_plugin: user specified callback, called for each plugin file
+ * @data: custom context, passed to @load_plugin
+ *
+ * Searches for traceevent plugin files and calls @load_plugin for each
+ * The order of plugins search is:
+ *  - Directories, specified in @tep->plugins_dir and priority TEP_PLUGIN_FIRST
+ *  - Directory, specified at compile time with PLUGIN_TRACEEVENT_DIR
+ *  - Directory, specified by environment variable TRACEEVENT_PLUGIN_DIR
+ *  - In user's home: ~/.local/lib/traceevent/plugins/
+ *  - Directories, specified in @tep->plugins_dir and priority TEP_PLUGIN_LAST
+ *
+ */
 void tep_load_plugins_hook(struct tep_handle *tep, const char *suffix,
 			   void (*load_plugin)(struct tep_handle *tep,
 					       const char *path,
-- 
2.26.2



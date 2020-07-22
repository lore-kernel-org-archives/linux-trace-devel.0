Return-Path: <SRS0=XgcI=BB=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A56E0C43458
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jul 2020 01:18:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C97022D6E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jul 2020 01:18:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731774AbgGVBS3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 21 Jul 2020 21:18:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:36994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731654AbgGVBR4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 21 Jul 2020 21:17:56 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D409522CF6;
        Wed, 22 Jul 2020 01:17:55 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jy3OM-005sFa-R8; Tue, 21 Jul 2020 21:17:54 -0400
Message-ID: <20200722011754.720060785@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 21 Jul 2020 21:16:44 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 16/23 v3] tools lib traceevent: Document tep_load_plugins_hook()
References: <20200722011628.925541477@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

Add description of tep_load_plugins_hook() traceevent API. Updated
library man pages with description of the tep_load_plugins_hook() API.

Link: https://lore.kernel.org/r/CAM9d7cgLBWCrEHwz+Lhv5x5EXGcNWB0QQoeGh3OKh2JfR=dV9Q@mail.gmail.com
Link: https://lore.kernel.org/linux-trace-devel/20200714103027.2477584-2-tz.stoyanov@gmail.com
Link: https://lore.kernel.org/linux-trace-devel/20200716092014.2613403-2-tz.stoyanov@gmail.com

Suggested-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 .../Documentation/libtraceevent-plugins.txt   | 25 ++++++++++++++++++-
 tools/lib/traceevent/event-plugin.c           | 16 ++++++++++++
 2 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-plugins.txt b/tools/lib/traceevent/Documentation/libtraceevent-plugins.txt
index 596032ade31f..4d6394397d92 100644
--- a/tools/lib/traceevent/Documentation/libtraceevent-plugins.txt
+++ b/tools/lib/traceevent/Documentation/libtraceevent-plugins.txt
@@ -3,7 +3,7 @@ libtraceevent(3)
 
 NAME
 ----
-tep_load_plugins, tep_unload_plugins - Load / unload traceevent plugins.
+tep_load_plugins, tep_unload_plugins, tep_load_plugins_hook - Load / unload traceevent plugins.
 
 SYNOPSIS
 --------
@@ -13,6 +13,12 @@ SYNOPSIS
 
 struct tep_plugin_list pass:[*]*tep_load_plugins*(struct tep_handle pass:[*]_tep_);
 void *tep_unload_plugins*(struct tep_plugin_list pass:[*]_plugin_list_, struct tep_handle pass:[*]_tep_);
+void *tep_load_plugins_hook*(struct tep_handle pass:[*]_tep_, const char pass:[*]_suffix_,
+			   void (pass:[*]_load_plugin_)(struct tep_handle pass:[*]tep,
+					       const char pass:[*]path,
+					       const char pass:[*]name,
+					       void pass:[*]data),
+			   void pass:[*]_data_);
 --
 
 DESCRIPTION
@@ -22,11 +28,13 @@ directories. The _tep_ argument is trace event parser context.
 The plugin directories are :
 [verse]
 --
+	- Directories, specified in _tep_->plugins_dir with priority TEP_PLUGIN_FIRST
 	- System's plugin directory, defined at the library compile time. It
 	  depends on the library installation prefix and usually is
 	  _(install_preffix)/lib/traceevent/plugins_
 	- Directory, defined by the environment variable _TRACEEVENT_PLUGIN_DIR_
 	- User's plugin directory, located at _~/.local/lib/traceevent/plugins_
+	- Directories, specified in _tep_->plugins_dir with priority TEP_PLUGIN_LAST
 --
 Loading of plugins can be controlled by the _tep_flags_, using the
 _tep_set_flag()_ API:
@@ -44,6 +52,12 @@ _tep_load_plugins()_. The _tep_ argument is trace event parser context. The
 _plugin_list_ is the list of loaded plugins, returned by
 the _tep_load_plugins()_ function.
 
+The _tep_load_plugins_hook_ function walks through all directories with plugins
+and calls user specified _load_plugin()_ hook for each plugin file. Only files
+with given _suffix_ are considered to be plugins. The _data_ is a user specified
+context, passed to _load_plugin()_. Directories and the walk order are the same
+as in _tep_load_plugins()_ API.
+
 RETURN VALUE
 ------------
 The _tep_load_plugins()_ function returns a list of successfully loaded plugins,
@@ -63,6 +77,15 @@ if (plugins == NULL) {
 }
 ...
 tep_unload_plugins(plugins, tep);
+...
+void print_plugin(struct tep_handle *tep, const char *path,
+		  const char *name, void *data)
+{
+	pritnf("Found libtraceevent plugin %s/%s\n", path, name);
+}
+...
+tep_load_plugins_hook(tep, ".so", print_plugin, NULL);
+...
 --
 
 FILES
diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
index 1d4f1809cf17..aa6f43290cd3 100644
--- a/tools/lib/traceevent/event-plugin.c
+++ b/tools/lib/traceevent/event-plugin.c
@@ -543,6 +543,22 @@ load_plugins_dir(struct tep_handle *tep, const char *suffix,
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



Return-Path: <SRS0=hXpH=AN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED9ABC433DF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Jul 2020 17:12:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D022C21534
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Jul 2020 17:12:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727870AbgGBRMH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Jul 2020 13:12:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727123AbgGBRMC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Jul 2020 13:12:02 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3B6B2145D;
        Thu,  2 Jul 2020 17:12:00 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jr2kf-004App-Bj; Thu, 02 Jul 2020 13:11:57 -0400
Message-ID: <20200702171157.225957944@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 02 Jul 2020 13:10:19 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 3/9] tools lib traceevent: Add tep_load_plugins_hook() API
References: <20200702171016.178196716@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

Add the API function tep_load_plugins_hook() to the traceevent API to allow
tools a common method to load in the plugins that are part of the lib
traceevent library.

Link: http://lore.kernel.org/linux-trace-devel/20190802110101.14759-4-tz.stoyanov@gmail.com
Link: http://lore.kernel.org/linux-trace-devel/20200625100516.365338-4-tz.stoyanov@gmail.com

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-parse.h  |  6 ++++++
 tools/lib/traceevent/event-plugin.c | 19 +++++++++----------
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index b77837f75a0d..776c7c24ee79 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -396,6 +396,12 @@ struct tep_plugin_list;
 struct tep_plugin_list *tep_load_plugins(struct tep_handle *tep);
 void tep_unload_plugins(struct tep_plugin_list *plugin_list,
 			struct tep_handle *tep);
+void tep_load_plugins_hook(struct tep_handle *tep, const char *suffix,
+			   void (*load_plugin)(struct tep_handle *tep,
+					       const char *path,
+					       const char *name,
+					       void *data),
+			   void *data);
 char **tep_plugin_list_options(void);
 void tep_plugin_free_options_list(char **list);
 int tep_plugin_add_options(const char *name,
diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
index e1f7ddd5a6cf..b53d9a53bcf9 100644
--- a/tools/lib/traceevent/event-plugin.c
+++ b/tools/lib/traceevent/event-plugin.c
@@ -365,20 +365,19 @@ load_plugins_dir(struct tep_handle *tep, const char *suffix,
 	closedir(dir);
 }
 
-static void
-load_plugins(struct tep_handle *tep, const char *suffix,
-	     void (*load_plugin)(struct tep_handle *tep,
-				 const char *path,
-				 const char *name,
-				 void *data),
-	     void *data)
+void tep_load_plugins_hook(struct tep_handle *tep, const char *suffix,
+			   void (*load_plugin)(struct tep_handle *tep,
+					       const char *path,
+					       const char *name,
+					       void *data),
+			   void *data)
 {
 	char *home;
 	char *path;
 	char *envdir;
 	int ret;
 
-	if (tep->flags & TEP_DISABLE_PLUGINS)
+	if (tep && tep->flags & TEP_DISABLE_PLUGINS)
 		return;
 
 	/*
@@ -386,7 +385,7 @@ load_plugins(struct tep_handle *tep, const char *suffix,
 	 * check that first.
 	 */
 #ifdef PLUGIN_DIR
-	if (!(tep->flags & TEP_DISABLE_SYS_PLUGINS))
+	if (!tep || !(tep->flags & TEP_DISABLE_SYS_PLUGINS))
 		load_plugins_dir(tep, suffix, PLUGIN_DIR,
 				 load_plugin, data);
 #endif
@@ -423,7 +422,7 @@ tep_load_plugins(struct tep_handle *tep)
 {
 	struct tep_plugin_list *list = NULL;
 
-	load_plugins(tep, ".so", load_plugin, &list);
+	tep_load_plugins_hook(tep, ".so", load_plugin, &list);
 	return list;
 }
 
-- 
2.26.2



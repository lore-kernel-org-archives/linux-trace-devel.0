Return-Path: <SRS0=KH1A=YA=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92659C352AA
	for <linux-trace-devel@archiver.kernel.org>; Mon,  7 Oct 2019 11:49:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64F862190F
	for <linux-trace-devel@archiver.kernel.org>; Mon,  7 Oct 2019 11:49:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mictb2N5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbfJGLty (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 7 Oct 2019 07:49:54 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42986 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727496AbfJGLtx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 7 Oct 2019 07:49:53 -0400
Received: by mail-wr1-f68.google.com with SMTP id n14so14868367wrw.9
        for <linux-trace-devel@vger.kernel.org>; Mon, 07 Oct 2019 04:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tOACvFcJA2eCXoootLKpMeCtmUdCKinOsSx+unALFog=;
        b=Mictb2N5Vtwxw7/muT7HCAZov4RzOitXsB4rPovU0GuM15dWdXJddi/Sf00hVSc+Jj
         uxPIOjakKJn5oUTE7WWERrG11B8M1MU1x4Al8A8Bd83P/pcJBvEhZhlbhImht01v70ZV
         O3MTOsGrPX8iKwkNd/mlgMOZkAC61oaiWXuphHqFaWomZzy1B5BTUVzCg1gPDLKxoAJe
         fnhcFVLm/RWfQH9QGCiqxxzMZ1LRZHqYiYOXD0xKTK8cNFNQkBEsxxa83wyojvapEJtd
         ac6cWnmGB6TE8k1YE6cWn0I7NsfS+a2FMzRtMR6Tgy8LDiR2pajDlutvgrcyH6dXnGf1
         oM4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tOACvFcJA2eCXoootLKpMeCtmUdCKinOsSx+unALFog=;
        b=XfCedvObeBh3R6oVzQNsEE8qUzBEmSnkmc85fCqahMKML7rHnY9r/ipDFvtIyhiNJ/
         y1g06/tgpElm2aeImVhHqtv9kN3Trj9HLEa+6c8tmv4cBxS89cmy/lsaMlXSVVQbPIzZ
         hMKPedelKzkrHvmwvwXU7t37T2aumJC9JriWns3L0sfY7PcFGNJYiryoGBDbkNsmag0l
         AX6Y614sl22xxtTRE+v92RZnZZ3mL80FGAx0WlKGBWA5uGb/xWQ5BePG5vccPvxzoZuI
         cqThJSa7BACbzQEIx1CukXfqhs5bjbfBN2cFAumFfTo0sue+K5M1V4zo5woV4Q74r+75
         LSTQ==
X-Gm-Message-State: APjAAAV8+Utta4niwhS7SyY4YgqPR410LvEN6gstsResy26978KWJzyk
        P7oVk9Jg+6nx+iJYyxFmXMrWHTWh
X-Google-Smtp-Source: APXvYqzGMKTzWmM4SMudTC7QJTUcwRQFtfW9ulA4SE9+K94vFmYFadUiqPFKZh26Cgb4A89GOOpDbQ==
X-Received: by 2002:a5d:4d05:: with SMTP id z5mr13593604wrt.76.1570448990791;
        Mon, 07 Oct 2019 04:49:50 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t13sm39350773wra.70.2019.10.07.04.49.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 04:49:50 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 1/3] trace-cmd: Introduced new traceevent API, for adding new plugins directories.
Date:   Mon,  7 Oct 2019 14:49:45 +0300
Message-Id: <20191007114947.17104-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191007114947.17104-1-tz.stoyanov@gmail.com>
References: <20191007114947.17104-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Implement new traceevent plugin API, which can be used to add new plugins
directories:
enum tep_plugin_load_priority {
	TEP_PLUGIN_FIRST,
	TEP_PLUGIN_LAST,
};
int tep_add_plugin_path(struct tep_handle *tep, char *path,
			enum tep_plugin_load_priority prio);

It adds the "path" as new plugin directory, in the context of
the handler "tep". The tep_load_plugins() API searches for plugins
in this new location. Depending of the priority "prio", the plugins
from this directory are loaded before (TEP_PLUGIN_FIRST) or after
(TEP_PLUGIN_LAST) the ordinary libtraceevent plugin locations.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/traceevent/event-parse.h   |  7 +++
 lib/traceevent/event-parse-local.h |  5 ++-
 lib/traceevent/event-parse.c       |  1 +
 lib/traceevent/event-plugin.c      | 70 ++++++++++++++++++++++++++++++
 4 files changed, 82 insertions(+), 1 deletion(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 5dff952..d66647b 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -379,6 +379,13 @@ struct tep_plugin_list;
 
 #define INVALID_PLUGIN_LIST_OPTION	((char **)((unsigned long)-1))
 
+enum tep_plugin_load_priority {
+	TEP_PLUGIN_FIRST,
+	TEP_PLUGIN_LAST,
+};
+
+int tep_add_plugin_path(struct tep_handle *tep, char *path,
+			enum tep_plugin_load_priority prio);
 struct tep_plugin_list *tep_load_plugins(struct tep_handle *tep);
 void tep_unload_plugins(struct tep_plugin_list *plugin_list,
 			struct tep_handle *tep);
diff --git a/lib/traceevent/event-parse-local.h b/lib/traceevent/event-parse-local.h
index 6e58ee1..abaeadf 100644
--- a/lib/traceevent/event-parse-local.h
+++ b/lib/traceevent/event-parse-local.h
@@ -13,6 +13,7 @@ struct func_map;
 struct func_list;
 struct event_handler;
 struct func_resolver;
+struct tep_plugins_dir;
 
 struct tep_handle {
 	int ref_count;
@@ -47,7 +48,6 @@ struct tep_handle {
 	struct printk_list *printklist;
 	unsigned int printk_count;
 
-
 	struct tep_event **events;
 	int nr_events;
 	struct tep_event **sort_events;
@@ -83,10 +83,13 @@ struct tep_handle {
 	struct tep_event *last_event;
 
 	char *trace_clock;
+
+	struct tep_plugins_dir *plugins_dir;
 };
 
 void tep_free_event(struct tep_event *event);
 void tep_free_format_field(struct tep_format_field *field);
+void tep_free_plugin_paths(struct tep_handle *tep);
 
 unsigned short tep_data2host2(struct tep_handle *tep, unsigned short data);
 unsigned int tep_data2host4(struct tep_handle *tep, unsigned int data);
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 7fbbbcc..b92e52c 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -7063,6 +7063,7 @@ void tep_free(struct tep_handle *tep)
 	free(tep->events);
 	free(tep->sort_events);
 	free(tep->func_resolver);
+	tep_free_plugin_paths(tep);
 
 	free(tep);
 }
diff --git a/lib/traceevent/event-plugin.c b/lib/traceevent/event-plugin.c
index 6ea4ac0..30c1526 100644
--- a/lib/traceevent/event-plugin.c
+++ b/lib/traceevent/event-plugin.c
@@ -39,6 +39,12 @@ struct tep_plugin_list {
 	void			*handle;
 };
 
+struct tep_plugins_dir {
+	struct tep_plugins_dir		*next;
+	char				*path;
+	enum tep_plugin_load_priority	prio;
+};
+
 static void lower_case(char *str)
 {
 	if (!str)
@@ -545,6 +551,7 @@ void tep_load_plugins_hook(struct tep_handle *tep, const char *suffix,
 					       void *data),
 			   void *data)
 {
+	struct tep_plugins_dir *dir = NULL;
 	char *home;
 	char *path;
 	char *envdir;
@@ -553,6 +560,15 @@ void tep_load_plugins_hook(struct tep_handle *tep, const char *suffix,
 	if (tep && tep->flags & TEP_DISABLE_PLUGINS)
 		return;
 
+	if (tep)
+		dir = tep->plugins_dir;
+	while (dir) {
+		if (dir->prio == TEP_PLUGIN_FIRST)
+			load_plugins_dir(tep, suffix, dir->path,
+					 load_plugin, data);
+		dir = dir->next;
+	}
+
 	/*
 	 * If a system plugin directory was defined,
 	 * check that first.
@@ -587,6 +603,15 @@ void tep_load_plugins_hook(struct tep_handle *tep, const char *suffix,
 
 	load_plugins_dir(tep, suffix, path, load_plugin, data);
 
+	if (tep)
+		dir = tep->plugins_dir;
+	while (dir) {
+		if (dir->prio == TEP_PLUGIN_LAST)
+			load_plugins_dir(tep, suffix, dir->path,
+					 load_plugin, data);
+		dir = dir->next;
+	}
+
 	free(path);
 }
 
@@ -599,6 +624,51 @@ tep_load_plugins(struct tep_handle *tep)
 	return list;
 }
 
+/**
+ * tep_add_plugin_path - Add a new plugin directory.
+ * @tep: Trace event handler.
+ * @path: Path to a directory. All files with extension .so in that
+ *	  directory will be loaded as plugins.
+ *@prio: Load priority of the plugins in that directory.
+ *
+ * Returns -1 in case of an error, 0 otherwise.
+ */
+int tep_add_plugin_path(struct tep_handle *tep, char *path,
+			enum tep_plugin_load_priority prio)
+{
+	struct tep_plugins_dir *dir;
+
+	if (!tep || !path)
+		return -1;
+
+	dir = calloc(1, sizeof(*dir));
+	if (!dir)
+		return -1;
+
+	dir->path = strdup(path);
+	dir->prio = prio;
+	dir->next = tep->plugins_dir;
+	tep->plugins_dir = dir;
+
+	return 0;
+}
+
+void tep_free_plugin_paths(struct tep_handle *tep)
+{
+	struct tep_plugins_dir *dir;
+
+	if (!tep)
+		return;
+
+	dir = tep->plugins_dir;
+	while (dir) {
+		tep->plugins_dir = tep->plugins_dir->next;
+		free(dir->path);
+		free(dir);
+		dir = tep->plugins_dir;
+	}
+}
+
 void
 tep_unload_plugins(struct tep_plugin_list *plugin_list, struct tep_handle *tep)
 {
-- 
2.21.0


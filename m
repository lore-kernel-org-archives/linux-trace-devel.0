Return-Path: <SRS0=vwyE=AG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A855C433E1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jun 2020 10:05:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBBD8206B7
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jun 2020 10:05:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oFlmrQvA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403848AbgFYKFZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Jun 2020 06:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403816AbgFYKFZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Jun 2020 06:05:25 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB47DC061573
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Jun 2020 03:05:24 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id b6so5179051wrs.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Jun 2020 03:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2MPAu3gIzg74EbBDlq1M+6oYD2te6Goog1VuhGLa3iQ=;
        b=oFlmrQvAzVz2ZP6cLnpMtp945nqHF0Nmb59bGWnK3/gi2RJa8vp5IJC8GB0cxMPCnb
         wgRqU9g7tG5HCCtUJJjJMNECBn0lyGKNmwhEVKFZCRIa3eaeiVCAlYk0E9D0gvF2IybF
         MuV3SzZOOgsYXqTR8uDrhMQzRceROEPnmmdKs7FDV/tEexVA0Jg7CAWTdIfR0/fCC3+P
         erwgl3gRt9B/QY1/oBy8jhbUSWug+HqKc08SSbjpFxrxBpTUPvQ+GSaDhuOIjSt6dPrL
         wchrDYdYpfpG9sdt58bCT6ayfPvUSk6OcNruD2xXc7sVK8/2am1eaACj8su07inALMT8
         q01w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2MPAu3gIzg74EbBDlq1M+6oYD2te6Goog1VuhGLa3iQ=;
        b=cYdxvxENDO41tvRyHLVlmoVLypLiCNrf/ZpbYPThkqfLjdN9d3Zfu1qWWYOoxaXP0p
         05OIppo611HnG27DmG0s3jLJBdFlz7mQzSjtKoQh2Rj8I+ptAdGSKi2iBQxIHd/siDC0
         nJ7cjopxX29O2ksMZkHQAGSxBWvvecO5FAcJ9LZnhYx7yUqmZ9uhgWAFPXC34/RTMUJ6
         9tIW39bL4qvTYAFMBoULGtMZNlPOrm2hJiQhNHedlZ3jWfpR0wloSwsV/5HrgRauPCvq
         ysF3qGFFUEDjcnl3mLNoWTaCQhfKX8fnhK63UWjkHaAfCKpjmP6F86X0mYBapYLcIDki
         dK7g==
X-Gm-Message-State: AOAM533Nhn28w3x0roE+qJTZgbvg67tpu9aCeqKdt3G/FOj/4o8TG6Vx
        jvtegd3ltIu6Kwe6Kjp4To7teh+cGvM=
X-Google-Smtp-Source: ABdhPJyLZLDQTHLRgA3n4+B20TXUMElCbv61PDYeQO+3P0akjM3b/HQHmg3NswaHTPe7zZZnke5/Yg==
X-Received: by 2002:adf:cf0c:: with SMTP id o12mr35795967wrj.265.1593079523688;
        Thu, 25 Jun 2020 03:05:23 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v7sm31268204wrp.45.2020.06.25.03.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 03:05:23 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 05/15] tools lib traceevent: Introduced new traceevent API, for adding new plugins directories.
Date:   Thu, 25 Jun 2020 13:05:12 +0300
Message-Id: <20200625100516.365338-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200625100516.365338-1-tz.stoyanov@gmail.com>
References: <20200625100516.365338-1-tz.stoyanov@gmail.com>
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

Link: http://lore.kernel.org/linux-trace-devel/20191007114947.17104-2-tz.stoyanov@gmail.com

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-parse-local.h |  5 +-
 tools/lib/traceevent/event-parse.c       |  1 +
 tools/lib/traceevent/event-parse.h       |  7 +++
 tools/lib/traceevent/event-plugin.c      | 70 ++++++++++++++++++++++++
 4 files changed, 82 insertions(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/event-parse-local.h b/tools/lib/traceevent/event-parse-local.h
index cee469803a34..96a0b0ca0675 100644
--- a/tools/lib/traceevent/event-parse-local.h
+++ b/tools/lib/traceevent/event-parse-local.h
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
@@ -81,10 +81,13 @@ struct tep_handle {
 
 	/* cache */
 	struct tep_event *last_event;
+
+	struct tep_plugins_dir *plugins_dir;
 };
 
 void tep_free_event(struct tep_event *event);
 void tep_free_format_field(struct tep_format_field *field);
+void tep_free_plugin_paths(struct tep_handle *tep);
 
 unsigned short tep_data2host2(struct tep_handle *tep, unsigned short data);
 unsigned int tep_data2host4(struct tep_handle *tep, unsigned int data);
diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 5b36c589a029..629437d4c816 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -7119,6 +7119,7 @@ void tep_free(struct tep_handle *tep)
 	free(tep->events);
 	free(tep->sort_events);
 	free(tep->func_resolver);
+	tep_free_plugin_paths(tep);
 
 	free(tep);
 }
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 02c0438527de..91f462f5a606 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -393,6 +393,13 @@ struct tep_plugin_list;
 
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
diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
index e8f4329ba8e0..1d4f1809cf17 100644
--- a/tools/lib/traceevent/event-plugin.c
+++ b/tools/lib/traceevent/event-plugin.c
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
@@ -544,6 +550,7 @@ void tep_load_plugins_hook(struct tep_handle *tep, const char *suffix,
 					       void *data),
 			   void *data)
 {
+	struct tep_plugins_dir *dir = NULL;
 	char *home;
 	char *path;
 	char *envdir;
@@ -552,6 +559,15 @@ void tep_load_plugins_hook(struct tep_handle *tep, const char *suffix,
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
@@ -586,6 +602,15 @@ void tep_load_plugins_hook(struct tep_handle *tep, const char *suffix,
 
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
 
@@ -598,6 +623,51 @@ tep_load_plugins(struct tep_handle *tep)
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
2.26.2


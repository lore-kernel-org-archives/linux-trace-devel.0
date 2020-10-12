Return-Path: <SRS0=H9Ya=DT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 044B4C433DF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 13:37:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80DC522266
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 13:37:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AXZogNDf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388334AbgJLNhm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Oct 2020 09:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730993AbgJLNhO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Oct 2020 09:37:14 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A11DC0613DD
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Oct 2020 06:36:45 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id n15so19248768wrq.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Oct 2020 06:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jdb/VhyzyRx6iWReDW+upLSi83hm6pmUpZkAMAixMf8=;
        b=AXZogNDfZqd6RLpJ9fGFJvSXCp4g9eFRFHQUnfFbadXCczJVAslrFwdGwfo9HskLNc
         uQp9Pa0VsMv8LeurcXxBYTRQlkQJVhB6iW6cQ0w6M0GKw34i30vUNbn/rK/mcGZhM/P2
         63p1qKft0X2jspyjGPc7/rPw8AWUFNE+lZ8HjVpEK3UcJMaVyjhmBxOIxc+xno6nFoh/
         700PUBTB8ic2diEhzI0uZvB2ydYA4hLwL1ACfhtefD+9pFjwl2XDU/Exy5l7CVBAawB+
         g7zdJMAPZARKk7a9PW711W0eBb/DQJWOLGRBKi1f6gM+Qj4188OK+XylHFjR2UlHqYGB
         xSTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jdb/VhyzyRx6iWReDW+upLSi83hm6pmUpZkAMAixMf8=;
        b=hIfyC3zm3FwNNQebnRHmOntc0MCgncgGaEV3ChHhhn9kYTtFHd4WhSkxLXaEl22xDK
         UuHe0eKuL2ELaI7Vjy1VyLNWRKDzRkfzHzkM26Ik1GxiYZ4NbHk7absAJAA5Mm9bViGB
         rFQ1ulC9jp639Mh9S6EM3/5Pc9K4p/T+LGEVDjYPL8YfIzuJJSyaEFgA9cJaM5cZDocO
         PFBun0BQqVmS4PxmE2JBzpGI5+9uIV0Wd93nBZe7PpY44878eTMRkzj/lHfQDwozudD2
         vAoqWVFdQWIM4l9hDC8H85k+mt5gNOV8UouwdDB9CR9bJosZHWThm/r7py8i6BVwM20K
         c3Fw==
X-Gm-Message-State: AOAM531hOCRDdlUOvCnDtcDD0rZdQyEWLha4C/gK+7olETE3g4YzEdT+
        tALxcol3gtW9vq2XXo9MkiY=
X-Google-Smtp-Source: ABdhPJw4yVklUNYMA8rWR12qIxBC6A5bZwzFHe5DqO9Wlj5t2NzizP1rFH1TwSGSHolp4aTub9qdWQ==
X-Received: by 2002:a5d:640d:: with SMTP id z13mr28896231wru.28.1602509803475;
        Mon, 12 Oct 2020 06:36:43 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.41])
        by smtp.gmail.com with ESMTPSA id k5sm23145388wmb.19.2020.10.12.06.36.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 06:36:42 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 20/20] kernel-shark: Integrate streams with libkshark-configio
Date:   Mon, 12 Oct 2020 16:35:23 +0300
Message-Id: <20201012133523.469040-21-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201012133523.469040-1-y.karadz@gmail.com>
References: <20201012133523.469040-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The configuration input/output is adapted in order to be able to
work with the new version of the C API. Now it can handle multiple
Data streams. We are re-enabling the corresponding example as well.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 examples/CMakeLists.txt  |    8 +-
 examples/configio.c      |   20 +-
 src/CMakeLists.txt       |    2 +-
 src/libkshark-configio.c | 1173 ++++++++++++++++++++++++++++++++------
 src/libkshark.h          |   73 ++-
 5 files changed, 1060 insertions(+), 216 deletions(-)

diff --git a/examples/CMakeLists.txt b/examples/CMakeLists.txt
index 2f6acea2..b8bc79a4 100644
--- a/examples/CMakeLists.txt
+++ b/examples/CMakeLists.txt
@@ -16,10 +16,10 @@ message(STATUS "datahisto")
 add_executable(dhisto          datahisto.c)
 target_link_libraries(dhisto   kshark)
 
-# message(STATUS "confogio")
-# add_executable(confio          configio.c)
-# target_link_libraries(confio   kshark)
-#
+message(STATUS "confogio")
+add_executable(confio          configio.c)
+target_link_libraries(confio   kshark)
+
 # message(STATUS "dataplot")
 # add_executable(dplot          dataplot.cpp)
 # target_link_libraries(dplot   kshark-plot)
diff --git a/examples/configio.c b/examples/configio.c
index faa116a1..9710d533 100644
--- a/examples/configio.c
+++ b/examples/configio.c
@@ -7,22 +7,26 @@ int main(int argc, char **argv)
 {
 	struct kshark_config_doc *conf, *filter, *hello;
 	struct kshark_context *kshark_ctx;
-	int *ids = NULL, i;
+	struct kshark_data_stream *stream;
+	int sd, *ids = NULL, i;
 
 	/* Create a new kshark session. */
 	kshark_ctx = NULL;
 	if (!kshark_instance(&kshark_ctx))
 		return 1;
 
+	sd = kshark_add_stream(kshark_ctx);
+	stream = kshark_ctx->stream[sd];
+
 	if (argc == 1) {
-		tracecmd_filter_id_add(kshark_ctx->show_task_filter, 314);
-		tracecmd_filter_id_add(kshark_ctx->show_task_filter, 42);
+		kshark_hash_id_add(stream->show_task_filter, 314);
+		kshark_hash_id_add(stream->show_task_filter, 42);
 
 		/* Create a new Confog. doc. */
 		conf = kshark_config_new("foo.bar.config", KS_CONFIG_JSON);
 
 		/* Add filter's info. */
-		filter = kshark_export_all_filters(kshark_ctx, KS_CONFIG_JSON);
+		filter = kshark_export_all_filters(kshark_ctx, sd, KS_CONFIG_JSON);
 		kshark_config_doc_add(conf, "Filters" ,filter);
 
 		/* Add "Hello Kernel" message. */
@@ -39,11 +43,11 @@ int main(int argc, char **argv)
 		/* Retrieve the filter's info. */
 		filter = kshark_config_alloc(KS_CONFIG_JSON);
 		if (kshark_config_doc_get(conf, "Filters" ,filter)) {
-			kshark_import_all_filters(kshark_ctx, filter);
+			kshark_import_all_filters(kshark_ctx, sd, filter);
 
 			/* Get the array of Ids to be fitered. */
-			ids = tracecmd_filter_ids(kshark_ctx->show_task_filter);
-			for (i = 0; i < kshark_ctx->show_task_filter->count; ++i)
+			ids = kshark_hash_ids(stream->show_task_filter);
+			for (i = 0; i < stream->show_task_filter->count; ++i)
 				printf("pid: %i\n", ids[i]);
 		}
 
@@ -58,7 +62,7 @@ int main(int argc, char **argv)
 	}
 
 	kshark_free_config_doc(conf);
-
+	kshark_close(kshark_ctx, sd);
 	kshark_free(kshark_ctx);
 
 	return 0;
diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 72eb8fd2..14a6ab69 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -6,7 +6,7 @@ add_library(kshark SHARED libkshark.c
                           libkshark-model.c
                           libkshark-plugin.c
                           libkshark-tepdata.c
-#                           libkshark-configio.c
+                          libkshark-configio.c
                           libkshark-collection.c
                           libkshark-tepdata.c)
 
diff --git a/src/libkshark-configio.c b/src/libkshark-configio.c
index cb7ca54b..0528e5ec 100644
--- a/src/libkshark-configio.c
+++ b/src/libkshark-configio.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: LGPL-2.1
 
 /*
- * Copyright (C) 2018 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
+ * Copyright (C) 2018 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
  */
 
  /**
@@ -13,15 +13,17 @@
 #ifndef _GNU_SOURCE
 /** Use GNU C Library. */
 #define _GNU_SOURCE
-
-#endif
+#endif // _GNU_SOURCE
 
 #include <stdio.h>
+#include <string.h>
 #include <sys/stat.h>
 
 // KernelShark
 #include "libkshark.h"
 #include "libkshark-model.h"
+#include "libkshark-plugin.h"
+#include "libkshark-tepdata.h"
 
 static struct json_object *kshark_json_config_alloc(const char *type)
 {
@@ -331,7 +333,7 @@ bool kshark_config_doc_get(struct kshark_config_doc *conf,
 	return true;
 
  fail:
-	fprintf(stderr, "Failed to get config. document.\n");
+	fprintf(stderr, "Failed to get config. document <%s>.\n", key);
 	return false;
 }
 
@@ -348,6 +350,19 @@ kshark_record_config_new(enum kshark_config_formats format)
 	return kshark_config_new("kshark.config.record", format);
 }
 
+/**
+ * @brief Create an empty Data Stream Configuration document. The type
+ * 	  description is set to "kshark.config.stream".
+ *
+ * @returns kshark_config_doc instance on success, otherwise NULL. Use
+ *	    kshark_free_config_doc() to free the object.
+ */
+struct kshark_config_doc *
+kshark_stream_config_new(enum kshark_config_formats format)
+{
+	return kshark_config_new("kshark.config.stream", format);
+}
+
 /**
  * @brief Create an empty Filter Configuration document. The type description
  *	  is set to "kshark.config.filter".
@@ -361,6 +376,19 @@ kshark_filter_config_new(enum kshark_config_formats format)
 	return kshark_config_new("kshark.config.filter", format);
 }
 
+/**
+ * @brief Create an empty Session Configuration document. The type description
+ *	  is set to "kshark.config.filter".
+ *
+ * @returns kshark_config_doc instance on success, otherwise NULL. Use
+ *	    kshark_free_config_doc() to free the object.
+ */
+struct kshark_config_doc *
+kshark_session_config_new(enum kshark_config_formats format)
+{
+	return kshark_config_new("kshark.config.session", format);
+}
+
 /**
  * @brief Create an empty Text Configuration document. The Text Configuration
  *	  documents do not use type descriptions.
@@ -419,10 +447,11 @@ bool kshark_type_check(struct kshark_config_doc *conf, const char *type)
 	}
 }
 
-static bool kshark_trace_file_to_json(const char *file,
+static bool kshark_trace_file_to_json(const char *file, const char *name,
 				      struct json_object *jobj)
 {
-	struct json_object *jfile_name, *jtime;
+	struct json_object *jfile_name, *jbuffer_name, *jtime;
+	char abs_path[FILENAME_MAX];
 	struct stat st;
 
 	if (!file || !jobj)
@@ -433,13 +462,21 @@ static bool kshark_trace_file_to_json(const char *file,
 		return false;
 	}
 
-	jfile_name = json_object_new_string(file);
+	if (!realpath(file, abs_path)) {
+		fprintf(stderr, "Unable to get absolute pathname for %s\n",
+			file);
+		return false;
+	}
+
+	jfile_name = json_object_new_string(abs_path);
+	jbuffer_name = json_object_new_string(name);
 	jtime = json_object_new_int64(st.st_mtime);
 
 	if (!jfile_name || !jtime)
 		goto fail;
 
 	json_object_object_add(jobj, "file", jfile_name);
+	json_object_object_add(jobj, "name", jbuffer_name);
 	json_object_object_add(jobj, "time", jtime);
 
 	return true;
@@ -458,13 +495,15 @@ static bool kshark_trace_file_to_json(const char *file,
  *	  Configuration document.
  *
  * @param file: The name of the file.
+ * @param name: The name of the data buffer.
  * @param format: Input location for the Configuration format identifier.
  *		  Currently only Json format is supported.
  *
- * @returns True on success, otherwise False.
+ * @returns kshark_config_doc instance on success, otherwise NULL. Use
+ *	    kshark_free_config_doc() to free the object.
  */
 struct kshark_config_doc *
-kshark_export_trace_file(const char *file,
+kshark_export_trace_file(const char *file, const char *name,
 			 enum kshark_config_formats format)
 {
 	/*  Create a new Configuration document. */
@@ -476,7 +515,7 @@ kshark_export_trace_file(const char *file,
 
 	switch (format) {
 	case KS_CONFIG_JSON:
-		kshark_trace_file_to_json(file, conf->conf_doc);
+		kshark_trace_file_to_json(file, name, conf->conf_doc);
 		return conf;
 
 	default:
@@ -486,19 +525,30 @@ kshark_export_trace_file(const char *file,
 	}
 }
 
-static bool kshark_trace_file_from_json(const char **file,
+static bool kshark_trace_file_from_json(const char **file, const char **name,
+					const char *type,
 					struct json_object *jobj)
 {
-	struct json_object *jfile_name, *jtime;
-	const char *file_str;
+	struct json_object *jfile_name, *jbuffer_name, *jtime;
+	const char *file_str, *name_str;
 	struct stat st;
+	char *header;
 	int64_t time;
+	bool type_OK = true;
 
 	if (!jobj)
 		return false;
 
-	if (!kshark_json_type_check(jobj, "kshark.config.data") ||
+	if (type) {
+		/* Make sure that the condition document has a correct type. */
+		type_OK = false;
+		if (asprintf(&header, "kshark.config.%s", type) >= 0)
+			type_OK = kshark_json_type_check(jobj, header);
+	}
+
+	if (!type_OK ||
 	    !json_object_object_get_ex(jobj, "file", &jfile_name) ||
+	    !json_object_object_get_ex(jobj, "name", &jbuffer_name) ||
 	    !json_object_object_get_ex(jobj, "time", &jtime)) {
 		fprintf(stderr,
 			"Failed to retrieve data file from json_object.\n");
@@ -506,6 +556,7 @@ static bool kshark_trace_file_from_json(const char **file,
 	}
 
 	file_str = json_object_get_string(jfile_name);
+	name_str = json_object_get_string(jbuffer_name);
 	time = json_object_get_int64(jtime);
 
 	if (stat(file_str, &st) != 0) {
@@ -514,11 +565,13 @@ static bool kshark_trace_file_from_json(const char **file,
 	}
 
 	if (st.st_mtime != time) {
-		fprintf(stderr,"Timestamp mismatch!\nFile %s", file_str);
+		fprintf(stderr, "Timestamp mismatch! (%li!=%li)\nFile %s\n",
+				time, st.st_mtime, file_str);
 		return false;
 	}
 
 	*file = file_str;
+	*name = name_str;
 
 	return true;
 }
@@ -532,27 +585,378 @@ static bool kshark_trace_file_from_json(const char **file,
  * @param conf: Input location for the kshark_config_doc instance. Currently
  *		only Json format is supported.
  *
- * @returns The name of the file on success, otherwise NULL. "conf" has
- *	    the ownership over the returned string.
+ * @returns The Id number of the data stream associated with the loaded file on
+ *	    success, otherwise -1. "conf" has the ownership over the returned
+ *	    string.
  */
-const char* kshark_import_trace_file(struct kshark_context *kshark_ctx,
-				     struct kshark_config_doc *conf)
+int kshark_import_trace_file(struct kshark_context *kshark_ctx,
+			     struct kshark_config_doc *conf)
 {
-	const char *file = NULL;
+	const char *file = NULL, *name = NULL;
+	int sd = -1;
+
 	switch (conf->format) {
 	case KS_CONFIG_JSON:
-		if (kshark_trace_file_from_json(&file, conf->conf_doc))
-			kshark_open(kshark_ctx, file);
+		if (kshark_trace_file_from_json(&file, &name, "data",
+						conf->conf_doc)) {
+			if (strcmp(name, "top") == 0) {
+				sd = kshark_open(kshark_ctx, file);
+			} else {
+				int sd_top;
+
+				sd_top = kshark_tep_find_top_stream(kshark_ctx,
+								    file);
+				if (sd_top < 0) {
+					/*
+					 * The "top" steam (buffer) has to be
+					 * initialized first.
+					 */
+					sd_top = kshark_open(kshark_ctx, file);
+				}
+
+				if (sd_top >= 0)
+					sd = kshark_tep_open_buffer(kshark_ctx,
+								    sd_top,
+								    name);
+
+				if (sd >= 0)
+				kshark_tep_handle_plugins(kshark_ctx, sd);
+			}
+		}
+
+		break;
 
+	default:
+		fprintf(stderr, "Document format %d not supported\n",
+			conf->format);
 		break;
+	}
+
+	return sd;
+}
+
+static bool kshark_plugin_to_json(struct kshark_plugin_list *plugin,
+				  struct json_object *jobj)
+{
+	struct json_object *jname = json_object_new_string(plugin->name);
+
+	if (!kshark_trace_file_to_json(plugin->file, plugin->name, jobj) ||
+	    !jname) {
+		json_object_put(jname);
+		return false;
+	}
+
+	json_object_object_add(jobj, "name", jname);
+	return true;
+}
+
+/**
+ * @brief Record the name of a plugin's obj file and its timestamp into a
+ *	  Configuration document.
+ *
+ * @param plugin: The plugin to be expected.
+ * @param format: Input location for the Configuration format identifier.
+ *		  Currently only Json format is supported.
+ *
+ * @returns kshark_config_doc instance on success, otherwise NULL. Use
+ *	    kshark_free_config_doc() to free the object.
+ */
+struct kshark_config_doc *
+kshark_export_plugin_file(struct kshark_plugin_list *plugin,
+			  enum kshark_config_formats format)
+{
+	/*  Create a new Configuration document. */
+	struct kshark_config_doc *conf =
+		kshark_config_new("kshark.config.library", format);
+
+	if (!conf)
+		return NULL;
+
+	switch (format) {
+	case KS_CONFIG_JSON:
+		kshark_plugin_to_json(plugin, conf->conf_doc);
+		return conf;
+
+	default:
+		fprintf(stderr, "Document format %d not supported\n",
+			conf->format);
+		return NULL;
+	}
+}
+
+static bool kshark_all_plugins_to_json(struct kshark_context *kshark_ctx,
+				       struct json_object *jobj)
+{
+	struct kshark_plugin_list *plugin = kshark_ctx->plugins;
+	struct json_object *jfile, *jlist;
+
+	jlist = json_object_new_array();
+	if (!jlist)
+		return false;
+
+	while (plugin) {
+		jfile = json_object_new_object();
+		if (!kshark_trace_file_to_json(plugin->file, plugin->name, jfile))
+			goto fail;
+
+		json_object_array_add(jlist, jfile);
+		plugin = plugin->next;
+	}
+
+	json_object_object_add(jobj, "obj. files", jlist);
+
+	return true;
+
+ fail:
+	fprintf(stderr, "Failed to allocate memory for json_object.\n");
+	json_object_put(jobj);
+	json_object_put(jlist);
+	return false;
+}
+
+/**
+ * @brief Record the current list of registered plugins into a
+ *	  Configuration document.
+ *
+ * @param kshark_ctx: Input location for session context pointer.
+ * @param format: Input location for the Configuration format identifier.
+ *		  Currently only Json format is supported.
+ *
+ * @returns kshark_config_doc instance on success, otherwise NULL. Use
+ *	    kshark_free_config_doc() to free the object.
+ */
+struct kshark_config_doc *
+kshark_export_all_plugins(struct kshark_context *kshark_ctx,
+			  enum kshark_config_formats format)
+{
+	struct kshark_config_doc *conf =
+		kshark_config_new("kshark.config.plugins", KS_CONFIG_JSON);
+
+	if (!conf)
+		return NULL;
+
+	switch (format) {
+	case KS_CONFIG_JSON:
+		kshark_all_plugins_to_json(kshark_ctx, conf->conf_doc);
+		return conf;
+
+	default:
+		fprintf(stderr, "Document format %d not supported\n",
+			conf->format);
+		return NULL;
+	}
+}
+
+static bool kshark_plugin_from_json(struct kshark_context *kshark_ctx,
+				    struct json_object *jobj)
+{
+	const char *file, *name;
+
+	if (!kshark_trace_file_from_json(&file, &name, NULL, jobj)) {
+		fprintf(stderr, "Failed to import plugin!\n");
+		return false;
+	}
+
+	return !!(long) kshark_register_plugin(kshark_ctx, name, file);
+}
+
+static bool kshark_all_plugins_from_json(struct kshark_context *kshark_ctx,
+					 struct json_object *jobj)
+{
+	struct json_object *jlist, *jfile;
+	int i, n_plugins;
+
+	if (!kshark_ctx || !jobj)
+		return false;
+
+	if (!kshark_json_type_check(jobj, "kshark.config.plugins") ||
+	    !json_object_object_get_ex(jobj, "obj. files", &jlist) ||
+	    json_object_get_type(jlist) != json_type_array)
+		goto fail;
+
+	n_plugins = json_object_array_length(jlist);
+	for (i = 0; i < n_plugins; ++i) {
+		jfile = json_object_array_get_idx(jlist, i);
+		if (!jfile)
+			goto fail;
+
+		kshark_plugin_from_json(kshark_ctx, jfile);
+	}
+
+	return true;
+
+ fail:
+	json_object_put(jfile);
+	json_object_put(jlist);
+	return false;
+}
+
+/**
+ * @brief Load the list of registered plugins from a Configuration
+ *	  document.
+ *
+ * @param kshark_ctx: Input location for session context pointer.
+ * @param conf: Input location for the kshark_config_doc instance. Currently
+ *		only Json format is supported.
+ *
+ * @returns True, if plugins have been loaded. If the configuration
+ *	    document contains no data or in a case of an error, the function
+ *	    returns False.
+ */
+bool kshark_import_all_plugins(struct kshark_context *kshark_ctx,
+			       struct kshark_config_doc *conf)
+{
+	switch (conf->format) {
+	case KS_CONFIG_JSON:
+		return kshark_all_plugins_from_json(kshark_ctx,
+						    conf->conf_doc);
+
+	default:
+		fprintf(stderr, "Document format %d not supported\n",
+			conf->format);
+		return false;
+	}
+}
+
+static void kshark_stream_plugins_to_json(struct kshark_data_stream *stream,
+				          struct json_object *jobj)
+{
+	struct kshark_dpi_list *plugin = stream->plugins;
+	struct json_object *jlist, *jplg;
+	bool active;
+
+	jlist = json_object_new_array();
+	while (plugin) {
+		jplg = json_object_new_array();
+		json_object_array_add(jplg,
+				      json_object_new_string(plugin->interface->name));
+
+		active = plugin->status & KSHARK_PLUGIN_ENABLED;
+		json_object_array_add(jplg, json_object_new_boolean(active));
+
+		json_object_array_add(jlist, jplg);
+
+		plugin = plugin->next;
+	}
+
+	json_object_object_add(jobj, "registered", jlist);
+}
+
+/**
+ * @brief Record the current list of plugins registered for a given Data
+ *	  stream into a Configuration document.
+ *
+ * @param stream: Input location for a Trace data stream pointer.
+ * @param format: Input location for the Configuration format identifier.
+ *		  Currently only Json format is supported.
+ *
+ * @returns kshark_config_doc instance on success, otherwise NULL. Use
+ *	    kshark_free_config_doc() to free the object.
+ */
+struct kshark_config_doc *
+kshark_export_stream_plugins(struct kshark_data_stream *stream,
+			     enum kshark_config_formats format)
+{
+	struct kshark_config_doc *conf =
+		kshark_config_new("kshark.config.plugins", KS_CONFIG_JSON);
+
+	if (!conf)
+		return NULL;
+
+	switch (format) {
+	case KS_CONFIG_JSON:
+		kshark_stream_plugins_to_json(stream, conf->conf_doc);
+		return conf;
 
 	default:
 		fprintf(stderr, "Document format %d not supported\n",
 			conf->format);
 		return NULL;
 	}
+}
+
+static bool kshark_stream_plugins_from_json(struct kshark_context *kshark_ctx,
+					    struct kshark_data_stream *stream,
+					    struct json_object *jobj)
+{
+	struct json_object *jlist, *jplg, *jname, *jstatus;
+	struct kshark_plugin_list *plugin;
+	struct kshark_dpi_list *dpi_list;
+	struct kshark_dpi *dpi;
+	int i, n_plugins;
+	bool active;
+
+	jplg = jname = jstatus = NULL;
+
+	if (!kshark_ctx || !stream || !jobj)
+		return false;
+
+	if (!kshark_json_type_check(jobj, "kshark.config.plugins") ||
+	    !json_object_object_get_ex(jobj, "registered", &jlist) ||
+	    json_object_get_type(jlist) != json_type_array)
+		goto fail;
+
+	n_plugins = json_object_array_length(jlist);
+	for (i = 0; i < n_plugins; ++i) {
+		jplg = json_object_array_get_idx(jlist, i);
+		if (!jplg ||
+		    json_object_get_type(jplg) != json_type_array ||
+		    json_object_array_length(jplg) != 2)
+			goto fail;
+
+		jname = json_object_array_get_idx(jplg, 0);
+		jstatus = json_object_array_get_idx(jplg, 1);
+		if (!jname || !jstatus)
+			goto fail;
+
+		plugin = kshark_find_plugin_by_name(kshark_ctx->plugins,
+						    json_object_get_string(jname));
+
+		if (plugin) {
+			active = json_object_get_boolean(jstatus);
+			dpi = plugin->process_interface;
+			dpi_list = kshark_register_plugin_to_stream(stream, dpi,
+								    active);
+
+			kshark_handle_dpi(stream, dpi_list, KSHARK_PLUGIN_INIT);
+		}
+	}
+
+	return true;
 
-	return file;
+ fail:
+	json_object_put(jplg);
+	json_object_put(jlist);
+	return false;
+}
+
+/**
+ * @brief Load the list of registered plugins for a given Data
+ *	  stream from a Configuration document.
+ *
+ * @param kshark_ctx: Input location for session context pointer.
+ * @param stream: Input location for a Trace data stream pointer.
+ * @param conf: Input location for the kshark_config_doc instance. Currently
+ *		only Json format is supported.
+ *
+ * @returns True, if plugins have been loaded. If the configuration
+ *	    document contains no data or in a case of an error, the function
+ *	    returns False.
+ */
+bool kshark_import_stream_plugins(struct kshark_context *kshark_ctx,
+				  struct kshark_data_stream *stream,
+				  struct kshark_config_doc *conf)
+{
+	switch (conf->format) {
+	case KS_CONFIG_JSON:
+		return kshark_stream_plugins_from_json(kshark_ctx, stream,
+						       conf->conf_doc);
+
+	default:
+		fprintf(stderr, "Document format %d not supported\n",
+			conf->format);
+		return false;
+	}
 }
 
 static bool kshark_model_to_json(struct kshark_trace_histo *histo,
@@ -593,14 +997,13 @@ static bool kshark_model_to_json(struct kshark_trace_histo *histo,
 /**
  * @brief Record the current configuration of the Vis. model into a
  *	  Configuration document.
- * Load the configuration of the Vis. model from a Configuration
- *	  document.
  *
  * @param histo: Input location for the Vis. model descriptor.
  * @param format: Input location for the kshark_config_doc instance. Currently
  *		  only Json format is supported.
  *
- * @returns True on success, otherwise False.
+ * @returns kshark_config_doc instance on success, otherwise NULL. Use
+ *	    free() to free the object.
  */
 struct kshark_config_doc *
 kshark_export_model(struct kshark_trace_histo *histo,
@@ -688,17 +1091,21 @@ bool kshark_import_model(struct kshark_trace_histo *histo,
 	}
 }
 
-static bool kshark_event_filter_to_json(struct tep_handle *pevent,
-					struct tracecmd_filter_id *filter,
+static bool kshark_event_filter_to_json(struct kshark_data_stream *stream,
+					enum kshark_filter_type filter_type,
 					const char *filter_name,
 					struct json_object *jobj)
 {
-	json_object *jfilter_data, *jevent, *jsystem, *jname;
-	struct tep_event *event;
-	int i, evt, *ids, nr_events;
-	char *temp;
+	json_object *jfilter_data, *jname;
+	struct kshark_hash_id *filter;
+	char *name_str;
+	int i, *ids;
 
-	jevent = jsystem = jname = NULL;
+	filter = kshark_get_filter(stream, filter_type);
+	if (!filter)
+		return false;
+
+	jname = NULL;
 
 	/*
 	 * If this Json document already contains a description of the filter,
@@ -707,7 +1114,7 @@ static bool kshark_event_filter_to_json(struct tep_handle *pevent,
 	json_del_if_exist(jobj, filter_name);
 
 	/* Get the array of Ids to be fitered. */
-	ids = tracecmd_filter_ids(filter);
+	ids = kshark_hash_ids(filter);
 	if (!ids)
 		return true;
 
@@ -716,32 +1123,15 @@ static bool kshark_event_filter_to_json(struct tep_handle *pevent,
 	if (!jfilter_data)
 		goto fail;
 
-	nr_events = tep_get_events_count(pevent);
 	for (i = 0; i < filter->count; ++i) {
-		for (evt = 0; evt < nr_events; ++evt) {
-			event = tep_get_event(pevent, evt);
-			if (event->id == ids[i]) {
-				jevent = json_object_new_object();
-
-				temp = event->system;
-				jsystem = json_object_new_string(temp);
-
-				temp = event->name;
-				jname = json_object_new_string(temp);
-
-				if (!jevent || !jsystem || !jname)
-					goto fail;
-
-				json_object_object_add(jevent, "system",
-							       jsystem);
-
-				json_object_object_add(jevent, "name",
-							       jname);
-
-				json_object_array_add(jfilter_data, jevent);
+		name_str = kshark_event_from_id(stream->stream_id,
+						ids[i]);
+		if (name_str) {
+			jname = json_object_new_string(name_str);
+			if (!jname)
+				goto fail;
 
-				break;
-			}
+			json_object_array_add(jfilter_data, jname);
 		}
 	}
 
@@ -755,8 +1145,6 @@ static bool kshark_event_filter_to_json(struct tep_handle *pevent,
  fail:
 	fprintf(stderr, "Failed to allocate memory for json_object.\n");
 	json_object_put(jfilter_data);
-	json_object_put(jevent);
-	json_object_put(jsystem);
 	json_object_put(jname);
 	free(ids);
 
@@ -767,22 +1155,22 @@ static bool kshark_event_filter_to_json(struct tep_handle *pevent,
  * @brief Record the current configuration of an Event Id filter into a
  *	  Configuration document.
  *
- * @param pevent: Input location for the Page event.
- * @param filter: Input location for an Id filter.
+ * @param stream: Input location for a Trace data stream pointer.
+ * @param filter_type: Identifier of the filter.
  * @param filter_name: The name of the filter to show up in the Json document.
  * @param conf: Input location for the kshark_config_doc instance. Currently
  *		only Json format is supported.
  *
  * @returns True on success, otherwise False.
  */
-bool kshark_export_event_filter(struct tep_handle *pevent,
-				struct tracecmd_filter_id *filter,
+bool kshark_export_event_filter(struct kshark_data_stream *stream,
+				enum kshark_filter_type filter_type,
 				const char *filter_name,
 				struct kshark_config_doc *conf)
 {
 	switch (conf->format) {
 	case KS_CONFIG_JSON:
-		return kshark_event_filter_to_json(pevent, filter,
+		return kshark_event_filter_to_json(stream, filter_type,
 						   filter_name,
 						   conf->conf_doc);
 
@@ -793,15 +1181,19 @@ bool kshark_export_event_filter(struct tep_handle *pevent,
 	}
 }
 
-static int kshark_event_filter_from_json(struct tep_handle *pevent,
-					  struct tracecmd_filter_id *filter,
-					  const char *filter_name,
-					  struct json_object *jobj)
+static int kshark_event_filter_from_json(struct kshark_data_stream *stream,
+					 enum kshark_filter_type filter_type,
+					 const char *filter_name,
+					 struct json_object *jobj)
 {
-	json_object *jfilter, *jevent, *jsystem, *jname;
-	const char *system_str, *name_str;
-	struct tep_event *event;
-	int i, length, count = 0;
+	int i, length, event_id, count = 0;
+	struct kshark_hash_id *filter;
+	json_object *jfilter, *jevent;
+	const char *name_str;
+
+	filter = kshark_get_filter(stream, filter_type);
+	if (!filter)
+		return 0;
 
 	/*
 	 * Use the name of the filter to find the array of events associated
@@ -819,20 +1211,13 @@ static int kshark_event_filter_from_json(struct tep_handle *pevent,
 	length = json_object_array_length(jfilter);
 	for (i = 0; i < length; ++i) {
 		jevent = json_object_array_get_idx(jfilter, i);
-
-		if (!json_object_object_get_ex(jevent, "system", &jsystem) ||
-		    !json_object_object_get_ex(jevent, "name", &jname))
-			goto fail;
-
-		system_str = json_object_get_string(jsystem);
-		name_str = json_object_get_string(jname);
-
-		event = tep_find_event_by_name(pevent, system_str, name_str);
-		if (!event)
+		name_str = json_object_get_string(jevent);
+		event_id = stream->interface.find_event_id(stream, name_str);
+		if (event_id < 0)
 			continue;
 
-		tracecmd_filter_id_add(filter, event->id);
-		++count;
+		kshark_hash_id_add(filter, event_id);
+		count++;
 	}
 
 	if (count != length)
@@ -842,32 +1227,32 @@ static int kshark_event_filter_from_json(struct tep_handle *pevent,
 
  fail:
 	fprintf(stderr, "Failed to load event filter from json_object.\n");
-	tracecmd_filter_id_clear(filter);
+	kshark_hash_id_clear(filter);
 	return 0;
 }
 
 /**
  * @brief Load from Configuration document the configuration of an Event Id filter.
  *
- * @param pevent: Input location for the Page event.
- * @param filter: Input location for an Id filter.
+ * @param stream: Input location for a Trace data stream pointer.
+ * @param filter_type: Identifier of the filter.
  * @param filter_name: The name of the filter as showing up in the Config.
  *	               document.
  * @param conf: Input location for the kshark_config_doc instance. Currently
  *		only Json format is supported.
  *
  * @returns The total number of events added to the filter. If not all events
- *	    listed in the input configuration have been added successfully,
- *	    the returned number is negative.
+ *         listed in the input configuration have been added successfully,
+ *         the returned number is negative.
  */
-int kshark_import_event_filter(struct tep_handle *pevent,
-			       struct tracecmd_filter_id *filter,
+int kshark_import_event_filter(struct kshark_data_stream *stream,
+			       enum kshark_filter_type filter_type,
 			       const char *filter_name,
 			       struct kshark_config_doc *conf)
 {
 	switch (conf->format) {
 	case KS_CONFIG_JSON:
-		return kshark_event_filter_from_json(pevent, filter,
+		return kshark_event_filter_from_json(stream, filter_type,
 						     filter_name,
 						     conf->conf_doc);
 
@@ -878,7 +1263,7 @@ int kshark_import_event_filter(struct tep_handle *pevent,
 	}
 }
 
-static bool kshark_filter_array_to_json(struct tracecmd_filter_id *filter,
+static bool kshark_filter_array_to_json(struct kshark_hash_id *filter,
 					const char *filter_name,
 					struct json_object *jobj)
 {
@@ -892,7 +1277,7 @@ static bool kshark_filter_array_to_json(struct tracecmd_filter_id *filter,
 	json_del_if_exist(jobj, filter_name);
 
 	/* Get the array of Ids to be filtered. */
-	ids = tracecmd_filter_ids(filter);
+	ids = kshark_hash_ids(filter);
 	if (!ids)
 		return true;
 
@@ -936,7 +1321,7 @@ static bool kshark_filter_array_to_json(struct tracecmd_filter_id *filter,
  *
  * @returns True on success, otherwise False.
  */
-bool kshark_export_filter_array(struct tracecmd_filter_id *filter,
+bool kshark_export_filter_array(struct kshark_hash_id *filter,
 				const char *filter_name,
 				struct kshark_config_doc *conf)
 {
@@ -952,7 +1337,7 @@ bool kshark_export_filter_array(struct tracecmd_filter_id *filter,
 	}
 }
 
-static bool kshark_filter_array_from_json(struct tracecmd_filter_id *filter,
+static bool kshark_filter_array_from_json(struct kshark_hash_id *filter,
 					  const char *filter_name,
 					  struct json_object *jobj)
 {
@@ -978,7 +1363,7 @@ static bool kshark_filter_array_from_json(struct tracecmd_filter_id *filter,
 		if (!jpid)
 			goto fail;
 
-		tracecmd_filter_id_add(filter, json_object_get_int(jpid));
+		kshark_hash_id_add(filter, json_object_get_int(jpid));
 	}
 
 	return true;
@@ -1002,7 +1387,7 @@ static bool kshark_filter_array_from_json(struct tracecmd_filter_id *filter,
  *	    document contains no data for this particular filter or in a case
  *	    of an error, the function returns False.
  */
-bool kshark_import_filter_array(struct tracecmd_filter_id *filter,
+bool kshark_import_filter_array(struct kshark_hash_id *filter,
 				const char *filter_name,
 				struct kshark_config_doc *conf)
 {
@@ -1018,16 +1403,14 @@ bool kshark_import_filter_array(struct tracecmd_filter_id *filter,
 	}
 }
 
-static bool kshark_adv_filters_to_json(struct kshark_context *kshark_ctx,
+static bool kshark_adv_filters_to_json(struct kshark_data_stream *stream,
 				       struct json_object *jobj)
 {
-	struct tep_event_filter *adv_filter = kshark_ctx->advanced_event_filter;
-	json_object *jfilter_data, *jevent, *jsystem, *jname, *jfilter;
-	struct tep_event **events;
-	char *str;
-	int i;
+	json_object *jfilter_data, *jevent, *jname, *jfilter;
+	char *filter_str;
+	int *events, i;
 
-	jevent = jsystem = jname = jfilter = NULL;
+	jevent = jname = jfilter = NULL;
 
 	/*
 	 * If this Json document already contains a description of the model,
@@ -1035,8 +1418,7 @@ static bool kshark_adv_filters_to_json(struct kshark_context *kshark_ctx,
 	 */
 	json_del_if_exist(jobj, KS_ADV_EVENT_FILTER_NAME);
 
-	if (!kshark_ctx->advanced_event_filter ||
-	    !kshark_ctx->advanced_event_filter->filters)
+	if (!kshark_tep_filter_is_set(stream))
 		return true;
 
 	/* Create a Json array and fill the Id values into it. */
@@ -1044,24 +1426,23 @@ static bool kshark_adv_filters_to_json(struct kshark_context *kshark_ctx,
 	if (!jfilter_data)
 		goto fail;
 
-	events = tep_list_events(kshark_ctx->pevent, TEP_EVENT_SORT_SYSTEM);
+	events = kshark_get_all_event_ids(stream);
 	if (!events)
 		return false;
 
-	for (i = 0; events[i]; i++) {
-		str = tep_filter_make_string(adv_filter,
-					     events[i]->id);
-		if (!str)
+	for (i = 0; i < stream->n_events; ++i) {
+		filter_str = kshark_tep_filter_make_string(stream, events[i]);
+		if (!filter_str)
 			continue;
 
 		jevent = json_object_new_object();
-		jsystem = json_object_new_string(events[i]->system);
-		jname = json_object_new_string(events[i]->name);
-		jfilter = json_object_new_string(str);
-		if (!jevent || !jsystem || !jname || !jfilter)
+		jname = json_object_new_string(kshark_event_from_id(stream->stream_id,
+								    events[i]));
+
+		jfilter = json_object_new_string(filter_str);
+		if (!jevent || !jname || !jfilter)
 			goto fail;
 
-		json_object_object_add(jevent, "system", jsystem);
 		json_object_object_add(jevent, "name", jname);
 		json_object_object_add(jevent, "condition", jfilter);
 
@@ -1077,7 +1458,6 @@ static bool kshark_adv_filters_to_json(struct kshark_context *kshark_ctx,
 	fprintf(stderr, "Failed to allocate memory for json_object.\n");
 	json_object_put(jfilter_data);
 	json_object_put(jevent);
-	json_object_put(jsystem);
 	json_object_put(jname);
 	json_object_put(jfilter);
 
@@ -1089,15 +1469,22 @@ static bool kshark_adv_filters_to_json(struct kshark_context *kshark_ctx,
  *	  Configuration document.
  *
  * @param kshark_ctx: Input location for session context pointer.
+ * @param sd: Data stream identifier.
  * @param conf: Input location for the kshark_config_doc instance. Currently
  *		only Json format is supported. If NULL, a new Adv. Filter
  *		Configuration document will be created.
  *
  * @returns True on success, otherwise False.
  */
-bool kshark_export_adv_filters(struct kshark_context *kshark_ctx,
+bool kshark_export_adv_filters(struct kshark_context *kshark_ctx, int sd,
 			       struct kshark_config_doc **conf)
 {
+	struct kshark_data_stream *stream =
+		kshark_get_data_stream(kshark_ctx, sd);
+
+	if (!stream)
+		return false;
+
 	if (!*conf)
 		*conf = kshark_filter_config_new(KS_CONFIG_JSON);
 
@@ -1106,7 +1493,7 @@ bool kshark_export_adv_filters(struct kshark_context *kshark_ctx,
 
 	switch ((*conf)->format) {
 	case KS_CONFIG_JSON:
-		return kshark_adv_filters_to_json(kshark_ctx,
+		return kshark_adv_filters_to_json(stream,
 						  (*conf)->conf_doc);
 
 	default:
@@ -1116,11 +1503,10 @@ bool kshark_export_adv_filters(struct kshark_context *kshark_ctx,
 	}
 }
 
-static bool kshark_adv_filters_from_json(struct kshark_context *kshark_ctx,
+static bool kshark_adv_filters_from_json(struct kshark_data_stream *stream,
 					 struct json_object *jobj)
 {
-	struct tep_event_filter *adv_filter = kshark_ctx->advanced_event_filter;
-	json_object *jfilter, *jsystem, *jname, *jcond;
+	json_object *jfilter, *jname, *jcond;
 	int i, length, n, ret = 0;
 	char *filter_str = NULL;
 
@@ -1142,13 +1528,11 @@ static bool kshark_adv_filters_from_json(struct kshark_context *kshark_ctx,
 	for (i = 0; i < length; ++i) {
 		jfilter = json_object_array_get_idx(jfilter, i);
 
-		if (!json_object_object_get_ex(jfilter, "system", &jsystem) ||
-		    !json_object_object_get_ex(jfilter, "name", &jname) ||
+		if (!json_object_object_get_ex(jfilter, "name", &jname) ||
 		    !json_object_object_get_ex(jfilter, "condition", &jcond))
 			goto fail;
 
-		n = asprintf(&filter_str, "%s/%s:%s",
-			     json_object_get_string(jsystem),
+		n = asprintf(&filter_str, "%s:%s",
 			     json_object_get_string(jname),
 			     json_object_get_string(jcond));
 
@@ -1157,8 +1541,7 @@ static bool kshark_adv_filters_from_json(struct kshark_context *kshark_ctx,
 			goto fail;
 		}
 
-		ret = tep_filter_add_filter_str(adv_filter,
-						filter_str);
+		ret = kshark_tep_add_filter_str(stream, filter_str);
 		if (ret < 0)
 			goto fail;
 	}
@@ -1167,16 +1550,6 @@ static bool kshark_adv_filters_from_json(struct kshark_context *kshark_ctx,
 
  fail:
 	fprintf(stderr, "Failed to laod Advanced filters.\n");
-	if (ret < 0) {
-		char error_str[200];
-		int error_status =
-			tep_strerror(kshark_ctx->pevent, ret, error_str,
-				     sizeof(error_str));
-
-		if (error_status == 0)
-			fprintf(stderr, "filter failed due to: %s\n",
-					error_str);
-	}
 
 	free(filter_str);
 	return false;
@@ -1187,6 +1560,7 @@ static bool kshark_adv_filters_from_json(struct kshark_context *kshark_ctx,
  *	  filter.
  *
  * @param kshark_ctx: Input location for session context pointer.
+ * @param sd: Data stream identifier.
  * @param conf: Input location for the kshark_config_doc instance. Currently
  *		only Json format is supported.
  *
@@ -1194,12 +1568,18 @@ static bool kshark_adv_filters_from_json(struct kshark_context *kshark_ctx,
  *	    document contains no data for the Adv. filter or in a case of
  *	    an error, the function returns False.
  */
-bool kshark_import_adv_filters(struct kshark_context *kshark_ctx,
+bool kshark_import_adv_filters(struct kshark_context *kshark_ctx, int sd,
 			       struct kshark_config_doc *conf)
 {
+	struct kshark_data_stream *stream =
+		kshark_get_data_stream(kshark_ctx, sd);
+
+	if (!stream)
+		return false;
+
 	switch (conf->format) {
 	case KS_CONFIG_JSON:
-		return kshark_adv_filters_from_json(kshark_ctx,
+		return kshark_adv_filters_from_json(stream,
 						    conf->conf_doc);
 
 	default:
@@ -1212,8 +1592,10 @@ bool kshark_import_adv_filters(struct kshark_context *kshark_ctx,
 static bool kshark_user_mask_to_json(struct kshark_context *kshark_ctx,
 				     struct json_object *jobj)
 {
-	uint8_t mask = kshark_ctx->filter_mask;
 	json_object *jmask;
+	uint8_t mask;
+
+	mask = kshark_ctx->filter_mask;
 
 	jmask = json_object_new_int((int) mask);
 	if (!jmask)
@@ -1246,8 +1628,7 @@ bool kshark_export_user_mask(struct kshark_context *kshark_ctx,
 
 	switch ((*conf)->format) {
 	case KS_CONFIG_JSON:
-		return kshark_user_mask_to_json(kshark_ctx,
-						(*conf)->conf_doc);
+		return kshark_user_mask_to_json(kshark_ctx, (*conf)->conf_doc);
 
 	default:
 		fprintf(stderr, "Document format %d not supported\n",
@@ -1296,8 +1677,61 @@ bool kshark_import_user_mask(struct kshark_context *kshark_ctx,
 {
 	switch (conf->format) {
 	case KS_CONFIG_JSON:
-		return kshark_user_mask_from_json(kshark_ctx,
-						  conf->conf_doc);
+		return kshark_user_mask_from_json(kshark_ctx, conf->conf_doc);
+
+	default:
+		fprintf(stderr, "Document format %d not supported\n",
+			conf->format);
+		return false;
+	}
+}
+
+static bool kshark_calib_array_from_json(struct kshark_context *kshark_ctx,
+					 int sd, struct json_object *jobj)
+{
+	json_object *jcalib_argv, *jcalib;
+	int64_t *calib_argv = NULL;
+	int i, calib_length;
+
+	if (!json_object_object_get_ex(jobj, "calib. array", &jcalib_argv) ||
+	    json_object_get_type(jcalib_argv) != json_type_array)
+		return false;
+
+	calib_length = json_object_array_length(jcalib_argv);
+	if (!calib_length)
+		return false;
+
+	calib_argv = calloc(calib_length, sizeof(*calib_argv));
+	for (i = 0; i < calib_length; ++i) {
+		jcalib = json_object_array_get_idx(jcalib_argv, i);
+		calib_argv[i] = json_object_get_int64(jcalib);
+	}
+
+	kshark_ctx->stream[sd]->calib = kshark_offset_calib;
+	kshark_ctx->stream[sd]->calib_array = calib_argv;
+	kshark_ctx->stream[sd]->calib_array_size = calib_length;
+
+	return true;
+}
+
+/**
+ * @brief Load from Configuration document the value of the time calibration
+ *	  constants into a Configuration document.
+ *
+ * @param kshark_ctx: Input location for session context pointer.
+ * @param sd: Data stream identifier.
+ * @param conf: Input location for the kshark_config_doc instance. Currently
+ *		only Json format is supported. If NULL, a new Configuration
+ *		document will be created.
+ *
+ * @returns True on success, otherwise False.
+ */
+bool kshark_import_calib_array(struct kshark_context *kshark_ctx, int sd,
+			       struct kshark_config_doc *conf)
+{
+	switch (conf->format) {
+	case KS_CONFIG_JSON:
+		return kshark_calib_array_from_json(kshark_ctx, sd, conf->conf_doc);
 
 	default:
 		fprintf(stderr, "Document format %d not supported\n",
@@ -1306,11 +1740,79 @@ bool kshark_import_user_mask(struct kshark_context *kshark_ctx,
 	}
 }
 
+static bool kshark_calib_array_to_json(struct kshark_context *kshark_ctx,
+				       int sd, struct json_object *jobj)
+{
+	json_object *jval = NULL, *jcalib = NULL;
+	struct kshark_data_stream *stream;
+
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!stream || !stream->calib_array_size)
+		goto fail;
+
+	jcalib = json_object_new_array();
+	if (!jcalib)
+		goto fail;
+
+	for (size_t i = 0; i < stream->calib_array_size; ++i) {
+		jval = json_object_new_int64(stream->calib_array[i]);
+		if (!jval)
+			goto fail;
+
+		json_object_array_add(jcalib, jval);
+	}
+
+	/* Add the mask to the filter config document. */
+	json_object_object_add(jobj, "calib. array", jcalib);
+
+	return true;
+
+ fail:
+	json_object_put(jval);
+	json_object_put(jcalib);
+
+	return false;
+}
+
+/**
+ * @brief Record the current values of the time calibration constants into
+ *	  a Configuration document.
+ *
+ * @param kshark_ctx: Input location for session context pointer.
+ * @param sd: Data stream identifier.
+ * @param conf: Input location for the kshark_config_doc instance. Currently
+ *		only Json format is supported. If NULL, a new Configuration
+ *		document will be created.
+ *
+ * @returns True on success, otherwise False.
+ */
+bool kshark_export_calib_array(struct kshark_context *kshark_ctx, int sd,
+			       struct kshark_config_doc **conf)
+{
+	if (!*conf)
+		*conf = kshark_stream_config_new(KS_CONFIG_JSON);
+
+	if (!*conf)
+		return false;
+
+	switch ((*conf)->format) {
+	case KS_CONFIG_JSON:
+		return kshark_calib_array_to_json(kshark_ctx, sd,
+						  (*conf)->conf_doc);
+
+	default:
+		fprintf(stderr, "Document format %d not supported\n",
+			(*conf)->format);
+		return false;
+	}
+}
+
 /**
  * @brief Record the current configuration of "show task" and "hide task"
  *	  filters into a Json document.
  *
  * @param kshark_ctx: Input location for session context pointer.
+ * @param sd: Data stream identifier.
  * @param conf: Input location for the kshark_config_doc instance. Currently
  *		only Json format is supported. If NULL, a new Filter
  *		Configuration document will be created.
@@ -1318,10 +1820,15 @@ bool kshark_import_user_mask(struct kshark_context *kshark_ctx,
  * @returns True, if a filter has been recorded. If both filters contain
  *	    no Id values or in a case of an error, the function returns False.
  */
-bool kshark_export_all_event_filters(struct kshark_context *kshark_ctx,
+bool kshark_export_all_event_filters(struct kshark_context *kshark_ctx, int sd,
 				     struct kshark_config_doc **conf)
 {
-	bool ret = true;
+	struct kshark_data_stream *stream =
+		kshark_get_data_stream(kshark_ctx, sd);
+	bool ret;
+
+	if (!stream)
+		return false;
 
 	if (!*conf)
 		*conf = kshark_filter_config_new(KS_CONFIG_JSON);
@@ -1330,15 +1837,16 @@ bool kshark_export_all_event_filters(struct kshark_context *kshark_ctx,
 		return false;
 
 	/* Save a filter only if it contains Id values. */
-	if (kshark_this_filter_is_set(kshark_ctx->show_event_filter))
-		ret &= kshark_export_event_filter(kshark_ctx->pevent,
-						  kshark_ctx->show_event_filter,
+	ret = true;
+	if (kshark_this_filter_is_set(stream->show_event_filter))
+		ret &= kshark_export_event_filter(stream,
+						  KS_SHOW_EVENT_FILTER,
 						  KS_SHOW_EVENT_FILTER_NAME,
 						  *conf);
 
-	if (kshark_this_filter_is_set(kshark_ctx->hide_event_filter))
-		ret &= kshark_export_event_filter(kshark_ctx->pevent,
-						  kshark_ctx->hide_event_filter,
+	if (kshark_this_filter_is_set(stream->hide_event_filter))
+		ret &= kshark_export_event_filter(stream,
+						  KS_HIDE_EVENT_FILTER,
 						  KS_HIDE_EVENT_FILTER_NAME,
 						  *conf);
 
@@ -1350,6 +1858,7 @@ bool kshark_export_all_event_filters(struct kshark_context *kshark_ctx,
  *	  filters into a Configuration document.
  *
  * @param kshark_ctx: Input location for session context pointer.
+ * @param sd: Data stream identifier.
  * @param conf: Input location for the kshark_config_doc instance. Currently
  *		only Json format is supported. If NULL, a new Filter
  *		Configuration document will be created.
@@ -1357,10 +1866,15 @@ bool kshark_export_all_event_filters(struct kshark_context *kshark_ctx,
  * @returns True, if a filter has been recorded. If both filters contain
  *	    no Id values or in a case of an error, the function returns False.
  */
-bool kshark_export_all_task_filters(struct kshark_context *kshark_ctx,
+bool kshark_export_all_task_filters(struct kshark_context *kshark_ctx, int sd,
 				    struct kshark_config_doc **conf)
 {
-	bool ret = true;
+	struct kshark_data_stream *stream =
+		kshark_get_data_stream(kshark_ctx, sd);
+	bool ret;
+
+	if (!stream)
+		return false;
 
 	if (!*conf)
 		*conf = kshark_filter_config_new(KS_CONFIG_JSON);
@@ -1369,25 +1883,26 @@ bool kshark_export_all_task_filters(struct kshark_context *kshark_ctx,
 		return false;
 
 	/* Save a filter only if it contains Id values. */
-	if (kshark_this_filter_is_set(kshark_ctx->show_task_filter))
-		ret &= kshark_export_filter_array(kshark_ctx->show_task_filter,
+	ret = true;
+	if (kshark_this_filter_is_set(stream->show_task_filter))
+		ret &= kshark_export_filter_array(stream->show_task_filter,
 						  KS_SHOW_TASK_FILTER_NAME,
 						  *conf);
 
-	if (kshark_this_filter_is_set(kshark_ctx->hide_task_filter))
-		ret &= kshark_export_filter_array(kshark_ctx->hide_task_filter,
+	if (kshark_this_filter_is_set(stream->hide_task_filter))
+		ret &= kshark_export_filter_array(stream->hide_task_filter,
 						  KS_HIDE_TASK_FILTER_NAME,
 						  *conf);
 
 	return ret;
 }
 
-
 /**
  * @brief Record the current configuration of "show cpu" and "hide cpu"
  *	  filters into a Configuration document.
  *
  * @param kshark_ctx: Input location for session context pointer.
+ * @param sd: Data stream identifier.
  * @param conf: Input location for the kshark_config_doc instance. Currently
  *		only Json format is supported. If NULL, a new Filter
  *		Configuration document will be created.
@@ -1395,10 +1910,15 @@ bool kshark_export_all_task_filters(struct kshark_context *kshark_ctx,
  * @returns True, if a filter has been recorded. If both filters contain
  *	    no Id values or in a case of an error, the function returns False.
  */
-bool kshark_export_all_cpu_filters(struct kshark_context *kshark_ctx,
+bool kshark_export_all_cpu_filters(struct kshark_context *kshark_ctx, int sd,
 				   struct kshark_config_doc **conf)
 {
-	bool ret = true;
+	struct kshark_data_stream *stream =
+		kshark_get_data_stream(kshark_ctx, sd);
+	bool ret;
+
+	if (!stream)
+		return false;
 
 	if (!*conf)
 		*conf = kshark_filter_config_new(KS_CONFIG_JSON);
@@ -1407,13 +1927,14 @@ bool kshark_export_all_cpu_filters(struct kshark_context *kshark_ctx,
 		return false;
 
 	/* Save a filter only if it contains Id values. */
-	if (kshark_this_filter_is_set(kshark_ctx->show_cpu_filter))
-		ret &= kshark_export_filter_array(kshark_ctx->show_cpu_filter,
+	ret = true;
+	if (kshark_this_filter_is_set(stream->show_cpu_filter))
+		ret &= kshark_export_filter_array(stream->show_cpu_filter,
 						  KS_SHOW_CPU_FILTER_NAME,
 						  *conf);
 
-	if (kshark_this_filter_is_set(kshark_ctx->hide_cpu_filter))
-		ret &= kshark_export_filter_array(kshark_ctx->hide_cpu_filter,
+	if (kshark_this_filter_is_set(stream->hide_cpu_filter))
+		ret &= kshark_export_filter_array(stream->hide_cpu_filter,
 						  KS_HIDE_CPU_FILTER_NAME,
 						  *conf);
 
@@ -1425,6 +1946,7 @@ bool kshark_export_all_cpu_filters(struct kshark_context *kshark_ctx,
  *	  and "hide event" filters.
  *
  * @param kshark_ctx: Input location for session context pointer.
+ * @param sd: Data stream identifier.
  * @param conf: Input location for the kshark_config_doc instance. Currently
  *		only Json format is supported.
  *
@@ -1432,18 +1954,23 @@ bool kshark_export_all_cpu_filters(struct kshark_context *kshark_ctx,
  *	    document contains no data for any event filter or in a case
  *	    of an error, the function returns False.
  */
-bool kshark_import_all_event_filters(struct kshark_context *kshark_ctx,
+bool kshark_import_all_event_filters(struct kshark_context *kshark_ctx, int sd,
 				     struct kshark_config_doc *conf)
 {
+	struct kshark_data_stream *stream =
+		kshark_get_data_stream(kshark_ctx, sd);
 	bool ret = false;
 
-	ret |= kshark_import_event_filter(kshark_ctx->pevent,
-					  kshark_ctx->hide_event_filter,
+	if (!stream)
+		return false;
+
+	ret |= kshark_import_event_filter(stream,
+					  KS_HIDE_EVENT_FILTER,
 					  KS_HIDE_EVENT_FILTER_NAME,
 					  conf);
 
-	ret |= kshark_import_event_filter(kshark_ctx->pevent,
-					  kshark_ctx->show_event_filter,
+	ret |= kshark_import_event_filter(stream,
+					  KS_SHOW_EVENT_FILTER,
 					  KS_SHOW_EVENT_FILTER_NAME,
 					  conf);
 
@@ -1455,6 +1982,7 @@ bool kshark_import_all_event_filters(struct kshark_context *kshark_ctx,
  *	  and "hide task" filters.
  *
  * @param kshark_ctx: Input location for session context pointer.
+ * @param sd: Data stream identifier.
  * @param conf: Input location for the kshark_config_doc instance. Currently
  *		only Json format is supported.
  *
@@ -1462,16 +1990,21 @@ bool kshark_import_all_event_filters(struct kshark_context *kshark_ctx,
  *	    document contains no data for any task filter or in a case of an
  *	    error, the function returns False.
  */
-bool kshark_import_all_task_filters(struct kshark_context *kshark_ctx,
+bool kshark_import_all_task_filters(struct kshark_context *kshark_ctx, int sd,
 				    struct kshark_config_doc *conf)
 {
+	struct kshark_data_stream *stream =
+		kshark_get_data_stream(kshark_ctx, sd);
 	bool ret = false;
 
-	ret |= kshark_import_filter_array(kshark_ctx->hide_task_filter,
+	if (!stream)
+		return false;
+
+	ret |= kshark_import_filter_array(stream->hide_task_filter,
 					  KS_HIDE_TASK_FILTER_NAME,
 					  conf);
 
-	ret |= kshark_import_filter_array(kshark_ctx->show_task_filter,
+	ret |= kshark_import_filter_array(stream->show_task_filter,
 					  KS_SHOW_TASK_FILTER_NAME,
 					  conf);
 
@@ -1483,6 +2016,7 @@ bool kshark_import_all_task_filters(struct kshark_context *kshark_ctx,
  *	  and "hide cpu" filters.
  *
  * @param kshark_ctx: Input location for session context pointer.
+ * @param sd: Data stream identifier.
  * @param conf: Input location for the kshark_config_doc instance. Currently
  *		only Json format is supported.
  *
@@ -1490,16 +2024,21 @@ bool kshark_import_all_task_filters(struct kshark_context *kshark_ctx,
  *	    document contains no data for any cpu filter or in a case of an
  *	    error, the function returns False.
  */
-bool kshark_import_all_cpu_filters(struct kshark_context *kshark_ctx,
+bool kshark_import_all_cpu_filters(struct kshark_context *kshark_ctx, int sd,
 				    struct kshark_config_doc *conf)
 {
+	struct kshark_data_stream *stream =
+		kshark_get_data_stream(kshark_ctx, sd);
 	bool ret = false;
 
-	ret |= kshark_import_filter_array(kshark_ctx->hide_cpu_filter,
+	if (!stream)
+		return false;
+
+	ret |= kshark_import_filter_array(stream->hide_cpu_filter,
 					  KS_HIDE_CPU_FILTER_NAME,
 					  conf);
 
-	ret |= kshark_import_filter_array(kshark_ctx->show_cpu_filter,
+	ret |= kshark_import_filter_array(stream->show_cpu_filter,
 					  KS_SHOW_CPU_FILTER_NAME,
 					  conf);
 
@@ -1511,6 +2050,7 @@ bool kshark_import_all_cpu_filters(struct kshark_context *kshark_ctx,
  *	  configuration of all filters.
  *
  * @param kshark_ctx: Input location for session context pointer.
+ * @param sd: Data stream identifier.
  * @param format: Input location for the kshark_config_doc instance. Currently
  *		  only Json format is supported.
  *
@@ -1518,7 +2058,7 @@ bool kshark_import_all_cpu_filters(struct kshark_context *kshark_ctx,
  *	    kshark_free_config_doc() to free the object.
  */
 struct kshark_config_doc *
-kshark_export_all_filters(struct kshark_context *kshark_ctx,
+kshark_export_all_filters(struct kshark_context *kshark_ctx, int sd,
 			  enum kshark_config_formats format)
 {
 	/*  Create a new Configuration document. */
@@ -1527,11 +2067,11 @@ kshark_export_all_filters(struct kshark_context *kshark_ctx,
 
 	/* Save a filter only if it contains Id values. */
 	if (!conf ||
-	    !kshark_export_all_event_filters(kshark_ctx, &conf) ||
-	    !kshark_export_all_task_filters(kshark_ctx, &conf) ||
-	    !kshark_export_all_cpu_filters(kshark_ctx, &conf) ||
+	    !kshark_export_all_event_filters(kshark_ctx, sd, &conf) ||
+	    !kshark_export_all_task_filters(kshark_ctx, sd, &conf) ||
+	    !kshark_export_all_cpu_filters(kshark_ctx, sd, &conf) ||
 	    !kshark_export_user_mask(kshark_ctx, &conf) ||
-	    !kshark_export_adv_filters(kshark_ctx, &conf)) {
+	    !kshark_export_adv_filters(kshark_ctx, sd, &conf)) {
 		kshark_free_config_doc(conf);
 		return NULL;
 	}
@@ -1543,6 +2083,7 @@ kshark_export_all_filters(struct kshark_context *kshark_ctx,
  * @brief Load from a Configuration document the configuration of all filters.
  *
  * @param kshark_ctx: Input location for session context pointer.
+ * @param sd: Data stream identifier.
  * @param conf: Input location for the kshark_config_doc instance. Currently
  *		only Json format is supported.
  *
@@ -1550,19 +2091,273 @@ kshark_export_all_filters(struct kshark_context *kshark_ctx,
  *	    document contains no data for any filter or in a case of an error,
  *	    the function returns False.
  */
-bool kshark_import_all_filters(struct kshark_context *kshark_ctx,
+bool kshark_import_all_filters(struct kshark_context *kshark_ctx, int sd,
 			       struct kshark_config_doc *conf)
 {
 	bool ret;
-	ret = kshark_import_all_task_filters(kshark_ctx, conf);
-	ret |= kshark_import_all_cpu_filters(kshark_ctx, conf);
-	ret |= kshark_import_all_event_filters(kshark_ctx, conf);
+
+	ret = kshark_import_all_task_filters(kshark_ctx, sd, conf);
+	ret |= kshark_import_all_cpu_filters(kshark_ctx, sd, conf);
+	ret |= kshark_import_all_event_filters(kshark_ctx, sd, conf);
 	ret |= kshark_import_user_mask(kshark_ctx, conf);
-	ret |= kshark_import_adv_filters(kshark_ctx, conf);
+	ret |= kshark_import_adv_filters(kshark_ctx, sd, conf);
 
 	return ret;
 }
 
+/**
+ * @brief Create a Data Stream Configuration document.
+ *
+ * @param kshark_ctx: Input location for session context pointer.
+ * @param sd: Data stream identifier.
+ * @param format: Input location for the kshark_config_doc instance. Currently
+ *		  only Json format is supported.
+ *
+ * @returns kshark_config_doc instance on success, otherwise NULL. Use
+ *	    kshark_free_config_doc() to free the object.
+ */
+struct kshark_config_doc *
+kshark_export_dstream(struct kshark_context *kshark_ctx, int sd,
+		      enum kshark_config_formats format)
+{
+	struct kshark_data_stream *stream =
+		kshark_get_data_stream(kshark_ctx, sd);
+	struct kshark_config_doc *file_conf, *filter_conf, *sd_conf, *plg_conf;
+	struct kshark_config_doc *dstream_conf;
+
+	/*  Create new Configuration documents. */
+	dstream_conf = kshark_stream_config_new(format);
+	sd_conf = kshark_config_alloc(KS_CONFIG_JSON);
+
+	sd_conf->conf_doc = json_object_new_int(sd);
+
+	filter_conf = kshark_export_all_filters(kshark_ctx, sd, format);
+	file_conf = kshark_export_trace_file(stream->file, stream->name, format);
+	plg_conf = kshark_export_stream_plugins(stream, format);
+
+	if (!sd_conf || !dstream_conf || !filter_conf || !file_conf)
+		goto fail;
+
+	kshark_config_doc_add(dstream_conf, "stream id", sd_conf);
+	kshark_config_doc_add(dstream_conf, "data", file_conf);
+	kshark_config_doc_add(dstream_conf, "filters", filter_conf);
+	kshark_config_doc_add(dstream_conf, "plugins", plg_conf);
+
+	if (stream->calib_array_size)
+		kshark_export_calib_array(kshark_ctx, sd, &dstream_conf);
+
+	return dstream_conf;
+
+ fail:
+	kshark_free_config_doc(dstream_conf);
+	kshark_free_config_doc(filter_conf);
+	kshark_free_config_doc(file_conf);
+	kshark_free_config_doc(plg_conf);
+	kshark_free_config_doc(sd_conf);
+
+	return NULL;
+}
+
+/**
+ * @brief Load Data Stream from a Configuration document.
+ *
+ * @param kshark_ctx: Input location for session context pointer.
+ * @param conf: Input location for the kshark_config_doc instance. Currently
+ *		only Json format is supported.
+ *
+ * @returns The Stream Id on the loaded Data Stream on success, otherwise a
+ *	    negative error code.
+ */
+int kshark_import_dstream(struct kshark_context *kshark_ctx,
+			  struct kshark_config_doc *conf)
+{
+	struct kshark_config_doc *file_conf, *filter_conf, *plg_conf;
+	struct kshark_data_stream *stream;
+	bool ret = false;
+	int sd = -EFAULT;
+
+	if (!kshark_type_check(conf, "kshark.config.stream"))
+		return sd;
+
+	file_conf = kshark_config_alloc(KS_CONFIG_JSON);
+	filter_conf = kshark_config_alloc(KS_CONFIG_JSON);
+	plg_conf = kshark_config_alloc(KS_CONFIG_JSON);
+	if (!file_conf || !filter_conf || !plg_conf) {
+		fprintf(stderr,
+			"Failed to allocate memory for Json document.\n");
+		goto free;
+	}
+
+	if (kshark_config_doc_get(conf, "data", file_conf) &&
+	    kshark_config_doc_get(conf, "filters", filter_conf) &&
+	    kshark_config_doc_get(conf, "plugins", plg_conf)) {
+		sd = kshark_import_trace_file(kshark_ctx, file_conf);
+		if (sd < 0) {
+			fprintf(stderr,
+				"Failed to import data file form Json document.\n");
+			goto free;
+		}
+
+		stream = kshark_ctx->stream[sd];
+		kshark_import_calib_array(kshark_ctx, sd, conf);
+		ret = kshark_import_all_filters(kshark_ctx, sd,
+						filter_conf);
+		if (!ret) {
+			fprintf(stderr,
+				"Failed to import filters form Json document.\n");
+			kshark_close(kshark_ctx, sd);
+			sd = -EFAULT;
+			goto free;
+		}
+
+		ret = kshark_import_stream_plugins(kshark_ctx, stream, plg_conf);
+
+		if (!ret) {
+			fprintf(stderr,
+				"Failed to import stream plugins form Json document.\n");
+			kshark_close(kshark_ctx, sd);
+			sd = -EFAULT;
+			goto free;
+		}
+	}
+
+ free:
+	/* Free only the kshark_config_doc objects. */
+	free(file_conf);
+	free(filter_conf);
+	free(plg_conf);
+
+	return sd;
+}
+
+static bool
+kshark_export_all_dstreams_to_json(struct kshark_context *kshark_ctx,
+				   struct json_object *jobj)
+{
+	int *stream_ids = kshark_all_streams(kshark_ctx);
+	struct kshark_config_doc *dstream_conf;
+	struct json_object *jall_streams;
+
+	json_del_if_exist(jobj, KS_DSTREAMS_NAME);
+	jall_streams = json_object_new_array();
+
+	for (int i = 0; i < kshark_ctx->n_streams; ++i) {
+		dstream_conf = kshark_export_dstream(kshark_ctx, stream_ids[i],
+						     KS_CONFIG_JSON);
+		if (!dstream_conf)
+			goto fail;
+
+		json_object_array_put_idx(jall_streams, i, dstream_conf->conf_doc);
+
+		/* Free only the kshark_config_doc object. */
+		free(dstream_conf);
+	}
+
+	free(stream_ids);
+
+	json_object_object_add(jobj, KS_DSTREAMS_NAME, jall_streams);
+
+	return true;
+
+ fail:
+	json_object_put(jall_streams);
+	free(stream_ids);
+
+	return false;
+}
+
+/**
+ * @brief Record the current configuration for all Data Streams into a Json
+ *	  document.
+ *
+ * @param kshark_ctx: Input location for session context pointer.
+ * @param conf: Input location for the kshark_config_doc instance. Currently
+ *		only Json format is supported. If NULL, a new Configuration
+ *		document will be created.
+ *
+ * @returns True on success, otherwise False.
+ */
+bool kshark_export_all_dstreams(struct kshark_context *kshark_ctx,
+				struct kshark_config_doc **conf)
+{
+	if (!*conf)
+		*conf = kshark_session_config_new(KS_CONFIG_JSON);
+
+	if (!*conf)
+		return false;
+
+	switch ((*conf)->format) {
+	case KS_CONFIG_JSON:
+		return kshark_export_all_dstreams_to_json(kshark_ctx,
+							  (*conf)->conf_doc);
+
+	default:
+		fprintf(stderr, "Document format %d not supported\n",
+			(*conf)->format);
+		return false;
+	}
+}
+
+static ssize_t
+kshark_import_all_dstreams_from_json(struct kshark_context *kshark_ctx,
+				     struct json_object *jobj,
+				     struct kshark_entry ***data_rows)
+{
+	struct kshark_config_doc dstream_conf;
+	json_object *jall_streams, *jstream;
+	int sd, i, length;
+
+	if (!json_object_object_get_ex(jobj, KS_DSTREAMS_NAME, &jall_streams) ||
+	    json_object_get_type(jall_streams) != json_type_array)
+		return -EFAULT;
+
+	length = json_object_array_length(jall_streams);
+	if (!length)
+		return -EFAULT;
+
+	dstream_conf.format = KS_CONFIG_JSON;
+	for (i = 0; i < length; ++i) {
+		jstream = json_object_array_get_idx(jall_streams, i);
+		dstream_conf.conf_doc = jstream;
+		sd = kshark_import_dstream(kshark_ctx, &dstream_conf);
+
+		if (sd < 0)
+			return -EFAULT;
+	}
+
+	return kshark_load_all_entries(kshark_ctx, data_rows);
+}
+
+/**
+ * @brief Load all Data Streams from a Configuration document.
+ *
+ * @param kshark_ctx: Input location for session context pointer.
+ * @param conf: Input location for the kshark_config_doc instance. Currently
+ *		only Json format is supported.
+ * @param data_rows: Output location for the trace data. The user is
+ *		     responsible for freeing the elements of the outputted
+ *		     array.
+ *
+ * @returns The size of the outputted data in the case of success, or a
+ *	    negative error code on failure.
+ */
+ssize_t kshark_import_all_dstreams(struct kshark_context *kshark_ctx,
+				   struct kshark_config_doc *conf,
+				   struct kshark_entry ***data_rows)
+{
+	switch (conf->format) {
+	case KS_CONFIG_JSON:
+		return kshark_import_all_dstreams_from_json(kshark_ctx,
+							    conf->conf_doc,
+							    data_rows);
+
+	default:
+		fprintf(stderr, "Document format %d not supported\n",
+			conf->format);
+		return -EFAULT;
+	}
+}
+
 static bool kshark_save_json_file(const char *file_name,
 				  struct json_object *jobj)
 {
diff --git a/src/libkshark.h b/src/libkshark.h
index dc30665b..8800bf26 100644
--- a/src/libkshark.h
+++ b/src/libkshark.h
@@ -974,6 +974,12 @@ enum kshark_config_formats {
  */
 #define KS_DATA_SOURCE_NAME		"trace data"
 
+/**
+ * Field name for the Configuration document describing all currently loaded
+ * data streams.
+ */
+#define KS_DSTREAMS_NAME		"data streams"
+
 struct kshark_config_doc *
 kshark_config_alloc(enum kshark_config_formats);
 
@@ -985,9 +991,15 @@ void kshark_free_config_doc(struct kshark_config_doc *conf);
 struct kshark_config_doc *
 kshark_record_config_new(enum kshark_config_formats);
 
+struct kshark_config_doc *
+kshark_stream_config_new(enum kshark_config_formats);
+
 struct kshark_config_doc *
 kshark_filter_config_new(enum kshark_config_formats);
 
+struct kshark_config_doc *
+kshark_session_config_new(enum kshark_config_formats format);
+
 struct kshark_config_doc *kshark_string_config_alloc(void);
 
 bool kshark_type_check(struct kshark_config_doc *conf, const char *type);
@@ -1003,24 +1015,42 @@ bool kshark_config_doc_get(struct kshark_config_doc *conf,
 struct kshark_trace_histo;
 
 struct kshark_config_doc *
-kshark_export_trace_file(const char *file,
+kshark_export_trace_file(const char *file, const char *name,
 			 enum kshark_config_formats format);
 
-const char *kshark_import_trace_file(struct kshark_context *kshark_ctx,
-				     struct kshark_config_doc *conf);
+int kshark_import_trace_file(struct kshark_context *kshark_ctx,
+			     struct kshark_config_doc *conf);
+
+struct kshark_config_doc *
+kshark_export_plugin_file(struct kshark_plugin_list *plugin,
+			  enum kshark_config_formats format);
+
+struct kshark_config_doc *
+kshark_export_all_plugins(struct kshark_context *kshark_ctx,
+			  enum kshark_config_formats format);
+
+bool kshark_import_all_plugins(struct kshark_context *kshark_ctx,
+			       struct kshark_config_doc *conf);
+
+struct kshark_config_doc *
+kshark_export_stream_plugins(struct kshark_data_stream *stream,
+			     enum kshark_config_formats format);
+
+bool kshark_import_stream_plugins(struct kshark_context *kshark_ctx,
+				  struct kshark_data_stream *stream,
+				  struct kshark_config_doc *conf);
 
 struct kshark_config_doc *
 kshark_export_model(struct kshark_trace_histo *histo,
 		     enum kshark_config_formats format);
 
-
 bool kshark_import_model(struct kshark_trace_histo *histo,
 			 struct kshark_config_doc *conf);
 
-bool kshark_export_adv_filters(struct kshark_context *kshark_ctx,
+bool kshark_export_adv_filters(struct kshark_context *kshark_ctx, int sd,
 			       struct kshark_config_doc **conf);
 
-bool kshark_import_adv_filters(struct kshark_context *kshark_ctx,
+bool kshark_import_adv_filters(struct kshark_context *kshark_ctx, int sd,
 			       struct kshark_config_doc *conf);
 
 bool kshark_export_event_filter(struct kshark_data_stream *stream,
@@ -1047,31 +1077,46 @@ bool kshark_import_filter_array(struct kshark_hash_id *filter,
 				const char *filter_name,
 				struct kshark_config_doc *conf);
 
-bool kshark_export_all_event_filters(struct kshark_context *kshark_ctx,
+bool kshark_export_all_event_filters(struct kshark_context *kshark_ctx, int sd,
 				     struct kshark_config_doc **conf);
 
-bool kshark_export_all_task_filters(struct kshark_context *kshark_ctx,
+bool kshark_export_all_task_filters(struct kshark_context *kshark_ctx, int sd,
 				    struct kshark_config_doc **conf);
 
-bool kshark_export_all_cpu_filters(struct kshark_context *kshark_ctx,
+bool kshark_export_all_cpu_filters(struct kshark_context *kshark_ctx, int sd,
 				   struct kshark_config_doc **conf);
 
 struct kshark_config_doc *
-kshark_export_all_filters(struct kshark_context *kshark_ctx,
+kshark_export_all_filters(struct kshark_context *kshark_ctx, int sd,
 			  enum kshark_config_formats format);
 
-bool kshark_import_all_event_filters(struct kshark_context *kshark_ctx,
+bool kshark_import_all_event_filters(struct kshark_context *kshark_ctx, int sd,
 				     struct kshark_config_doc *conf);
 
-bool kshark_import_all_task_filters(struct kshark_context *kshark_ctx,
+bool kshark_import_all_task_filters(struct kshark_context *kshark_ctx, int sd,
 				    struct kshark_config_doc *conf);
 
-bool kshark_import_all_cpu_filters(struct kshark_context *kshark_ctx,
+bool kshark_import_all_cpu_filters(struct kshark_context *kshark_ctx, int sd,
 				   struct kshark_config_doc *conf);
 
-bool kshark_import_all_filters(struct kshark_context *kshark_ctx,
+bool kshark_import_all_filters(struct kshark_context *kshark_ctx, int sd,
 			       struct kshark_config_doc *conf);
 
+struct kshark_config_doc *
+kshark_export_dstream(struct kshark_context *kshark_ctx, int sd,
+		      enum kshark_config_formats format);
+
+int kshark_import_dstream(struct kshark_context *kshark_ctx,
+			  struct kshark_config_doc *conf);
+
+bool kshark_export_all_dstreams(struct kshark_context *kshark_ctx,
+				struct kshark_config_doc **conf);
+
+ssize_t kshark_import_all_dstreams(struct kshark_context *kshark_ctx,
+				   struct kshark_config_doc *conf,
+				   struct kshark_entry ***data_rows);
+
+
 bool kshark_save_config_file(const char *file_name,
 			     struct kshark_config_doc *conf);
 
-- 
2.25.1


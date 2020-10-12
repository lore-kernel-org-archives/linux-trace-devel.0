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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11F66C433DF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 14:03:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9298206F4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 14:03:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B97Srs23"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390529AbgJLODr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Oct 2020 10:03:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730073AbgJLNgb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Oct 2020 09:36:31 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7969AC0613D5
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Oct 2020 06:36:30 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id s9so7133471wro.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Oct 2020 06:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Fw/4Sl1YAcEgbLMsbXfizIaxLHyVjzD93gaTl8TYCrU=;
        b=B97Srs23E8nFUsYg+KkcOFyLfG3azab28F2iCnBsKlnjrqE1ejP9sTHaWGU+7DO8Qf
         PafV4JC1K1NS7l1ZC4iHspFyYVgNORXQXCrdRRjgEkWA1ONR0iTbXovfWdRvlPK5n57g
         7vD+QmctxVrNBKvjM4F8dKt1yQfSJrhYPA/8h1SUIEMQHSJddy4Oqx+jvTrTp413Gxo9
         XxWGTGBd78vWX8THop6Fk8hIr6DQ/YOWGQCwA+LGCqKdLl4O5C7adWQh43McZamNf+Lk
         aZr80sQYo8RUMdIzXVNjeLmPXJcSYw/O+cB2XEt3RCUqQScDd8ETCboDPkhn+4+//xOb
         zZug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fw/4Sl1YAcEgbLMsbXfizIaxLHyVjzD93gaTl8TYCrU=;
        b=fedxrjKAzwuR7NeljV28q4SZPZkIj/16xUdfyknWyqgCpEoOC/ZvO1ON8gzA8LssLV
         8Drphd+I9LOtCvCOgj29QQUUtwj71lb6IXC0GxidCf5GtTTgX9Sz246wfHiM073Jz8zF
         xc8Mx/XKOlYVmptTRq6pezcEBYKJ+eeOaQQwlwxhak6/H5HXrSxTC40wkQI1KYtAJBxa
         LXS2PxnLpSkZ6gG6n06OvJoXwaoBqUNJneDayD3kStlY3uv48lWCatfNfC3picKfXn6N
         SwNEAqMF1Snu3T/01aPHlMHTmrnzT+rCUozYpz2OlGuy/9v4m/w0D9vlPEER72TSF4OW
         /hMg==
X-Gm-Message-State: AOAM5308M3zhvNRH6CLvmlSj3WRZQiD4ER8sMtASpv79eMpZrEKlxQf5
        eLeiJiBLC+KH4PDVVHmUKgZnWr7625g=
X-Google-Smtp-Source: ABdhPJwhRXZA9xvcKZQHmnadOx5xIY248r0D0BCwVhFnuleRuI0hsb9ZgHtPpH41c0guEdZxYkDxzQ==
X-Received: by 2002:a5d:4cd1:: with SMTP id c17mr17927683wrt.109.1602509788720;
        Mon, 12 Oct 2020 06:36:28 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.41])
        by smtp.gmail.com with ESMTPSA id k5sm23145388wmb.19.2020.10.12.06.36.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 06:36:28 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 12/20] kernel-shark: Redesign the plugin interface
Date:   Mon, 12 Oct 2020 16:35:15 +0300
Message-Id: <20201012133523.469040-13-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201012133523.469040-1-y.karadz@gmail.com>
References: <20201012133523.469040-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patch can be treated as an almost complete rewrite of the way
the C API of KernelShark deals with plugins. First of all, the two
pluggable user actions (one executed during data loading and another
executed during plotting) have separate handlers. This way the user
can register only one of the two callback functions, if this is what
is needed.

The second substantial change is that instead of having a single
interface for loading the plugin, we now have 3 different interfaces.
The one that exists in version 1 of KernelShark is now renamed to
Data Processing Interface (dpi).

The first new interface for loading can be used to register user
provided implementation of the Data stream readout and is called Data
Readout Interface (dri). Via this  plugin loading interface the user
can open trace data having an arbitrary format. In order to make this
possible the user has to provide a plugin that contains an implementation
of the data readout methods defined by the kshark_data_stream_interface
and to register all those methods.

The second new plugin loading interface is called Control interface
and can be used to provide the plugin with an access to the GUI's Main
window object. Via this interface the plugin can became capable to
modify the GUI. Such a modification for example can be to add new
dialog to the menus or to change the state of the GUI (to select entry
1with the marker, to zoom, ...).

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark-plugin.c | 597 ++++++++++++++++++++++++++++++++++-------
 src/libkshark-plugin.h | 279 ++++++++++++++-----
 src/libkshark.c        |  56 +++-
 src/libkshark.h        |  25 +-
 4 files changed, 791 insertions(+), 166 deletions(-)

diff --git a/src/libkshark-plugin.c b/src/libkshark-plugin.c
index 4b21392a..8e5299cf 100644
--- a/src/libkshark-plugin.c
+++ b/src/libkshark-plugin.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: LGPL-2.1
 
 /*
- * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
+ * Copyright (C) 2017 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
  */
 
  /**
@@ -13,8 +13,7 @@
 #ifndef _GNU_SOURCE
 /** Use GNU C Library. */
 #define _GNU_SOURCE
-
-#endif
+#endif // _GNU_SOURCE
 
 #include <stdio.h>
 #include <stdlib.h>
@@ -27,23 +26,36 @@
 #include "libkshark-plugin.h"
 #include "libkshark.h"
 
-static struct kshark_event_handler *
-gui_event_handler_alloc(int event_id,
-			kshark_plugin_event_handler_func evt_func,
-			kshark_plugin_draw_handler_func dw_func)
+static struct kshark_event_proc_handler *
+data_event_handler_alloc(int event_id,
+			 kshark_plugin_event_handler_func evt_func)
 {
-	struct kshark_event_handler *handler = malloc(sizeof(*handler));
+	struct kshark_event_proc_handler *handler = malloc(sizeof(*handler));
 
 	if (!handler) {
-		fprintf(stderr,
-			"failed to allocate memory for gui eventhandler");
+		fputs("failed to allocate memory for event handler\n", stderr);
 		return NULL;
 	}
 
 	handler->next = NULL;
 	handler->id = event_id;
 	handler->event_func = evt_func;
-	handler->draw_func = dw_func;
+
+	return handler;
+}
+
+static struct kshark_draw_handler *
+data_draw_handler_alloc(kshark_plugin_draw_handler_func draw_func)
+{
+	struct kshark_draw_handler *handler = malloc(sizeof(*handler));
+
+	if (!handler) {
+		fputs("failed to allocate memory for draw handler\n", stderr);
+		return NULL;
+	}
+
+	handler->next = NULL;
+	handler->draw_func = draw_func;
 
 	return handler;
 }
@@ -55,8 +67,8 @@ gui_event_handler_alloc(int event_id,
  * @param handlers: Input location for the Event handler list.
  * @param event_id: Event Id to search for.
  */
-struct kshark_event_handler *
-kshark_find_event_handler(struct kshark_event_handler *handlers, int event_id)
+struct kshark_event_proc_handler *
+kshark_find_event_handler(struct kshark_event_proc_handler *handlers, int event_id)
 {
 	for (; handlers; handlers = handlers->next)
 		if (handlers->id == event_id)
@@ -68,26 +80,25 @@ kshark_find_event_handler(struct kshark_event_handler *handlers, int event_id)
 /**
  * @brief Add new event handler to an existing list of handlers.
  *
- * @param handlers: Input location for the Event handler list.
+ * @param stream: Input location for a Trace data stream pointer.
  * @param event_id: Event Id.
  * @param evt_func: Input location for an Event action provided by the plugin.
- * @param dw_func: Input location for a Draw action provided by the plugin.
  *
  * @returns Zero on success, or a negative error code on failure.
  */
-int kshark_register_event_handler(struct kshark_event_handler **handlers,
+int kshark_register_event_handler(struct kshark_data_stream *stream,
 				  int event_id,
-				  kshark_plugin_event_handler_func evt_func,
-				  kshark_plugin_draw_handler_func dw_func)
+				  kshark_plugin_event_handler_func evt_func)
 {
-	struct kshark_event_handler *handler =
-		gui_event_handler_alloc(event_id, evt_func, dw_func);
+	struct kshark_event_proc_handler *handler =
+		data_event_handler_alloc(event_id, evt_func);
 
 	if(!handler)
 		return -ENOMEM;
 
-	handler->next = *handlers;
-	*handlers = handler;
+	handler->next = stream->event_handlers;
+	stream->event_handlers = handler;
+
 	return 0;
 }
 
@@ -95,23 +106,20 @@ int kshark_register_event_handler(struct kshark_event_handler **handlers,
  * @brief Search the list for a specific plugin handle. If such a plugin handle
  *	  exists, unregister (remove and free) this handle from the list.
  *
- * @param handlers: Input location for the Event handler list.
+ * @param stream: Input location for a Trace data stream pointer.
  * @param event_id: Event Id of the plugin handler to be unregistered.
- * @param evt_func: Event action function of the handler to be unregistered.
- * @param dw_func: Draw action function of the handler to be unregistered.
+ * @param evt_func: Event action function to be unregistered.
  */
-void kshark_unregister_event_handler(struct kshark_event_handler **handlers,
+void kshark_unregister_event_handler(struct kshark_data_stream *stream,
 				     int event_id,
-				     kshark_plugin_event_handler_func evt_func,
-				     kshark_plugin_draw_handler_func dw_func)
+				     kshark_plugin_event_handler_func evt_func)
 {
-	struct kshark_event_handler **last;
+	struct kshark_event_proc_handler **last;
 
-	for (last = handlers; *last; last = &(*last)->next) {
+	for (last = &stream->event_handlers; *last; last = &(*last)->next) {
 		if ((*last)->id == event_id &&
-		    (*last)->event_func == evt_func &&
-		    (*last)->draw_func == dw_func) {
-			struct kshark_event_handler *this_handler;
+		    (*last)->event_func == evt_func) {
+			struct kshark_event_proc_handler *this_handler;
 			this_handler = *last;
 			*last = this_handler->next;
 			free(this_handler);
@@ -126,9 +134,71 @@ void kshark_unregister_event_handler(struct kshark_event_handler **handlers,
  *
  * @param handlers: Input location for the Event handler list.
  */
-void kshark_free_event_handler_list(struct kshark_event_handler *handlers)
+void kshark_free_event_handler_list(struct kshark_event_proc_handler *handlers)
+{
+	struct kshark_event_proc_handler *last;
+
+	while (handlers) {
+		last = handlers;
+		handlers = handlers->next;
+		free(last);
+	}
+}
+
+/**
+ * @brief Add new event handler to an existing list of handlers.
+ *
+ * @param stream: Input location for a Trace data stream pointer.
+ * @param draw_func: Input location for a Draw action provided by the plugin.
+ *
+ * @returns Zero on success, or a negative error code on failure.
+ */
+int kshark_register_draw_handler(struct kshark_data_stream *stream,
+				 kshark_plugin_draw_handler_func draw_func)
+{
+	struct kshark_draw_handler *handler = data_draw_handler_alloc(draw_func);
+
+	if(!handler)
+		return -ENOMEM;
+
+	handler->next = stream->draw_handlers;
+	stream->draw_handlers = handler;
+
+	return 0;
+}
+
+/**
+ * @brief Search the list for a specific plugin handle. If such a plugin handle
+ *	  exists, unregister (remove and free) this handle from the list.
+ *
+ * @param stream: Input location for a Trace data stream pointer.
+ * @param draw_func: Draw action function to be unregistered.
+ */
+void kshark_unregister_draw_handler(struct kshark_data_stream *stream,
+				    kshark_plugin_draw_handler_func draw_func)
+{
+	struct kshark_draw_handler **last;
+
+	for (last = &stream->draw_handlers; *last; last = &(*last)->next) {
+		if ((*last)->draw_func == draw_func) {
+			struct kshark_draw_handler *this_handler;
+			this_handler = *last;
+			*last = this_handler->next;
+			free(this_handler);
+
+			return;
+		}
+	}
+}
+
+/**
+ * @brief Free all DRaw handlers in a given list.
+ *
+ * @param handlers: Input location for the Draw handler list.
+ */
+void kshark_free_draw_handler_list(struct kshark_draw_handler *handlers)
 {
-	struct kshark_event_handler *last;
+	struct kshark_draw_handler *last;
 
 	while (handlers) {
 		last = handlers;
@@ -139,96 +209,182 @@ void kshark_free_event_handler_list(struct kshark_event_handler *handlers)
 
 /**
  * @brief Allocate memory for a new plugin. Add this plugin to the list of
- *	  plugins used by the session.
+ *	  plugins.
  *
  * @param kshark_ctx: Input location for the session context pointer.
+ * @param name: The name of the plugin to register.
  * @param file: The plugin object file to load.
  *
- * @returns Zero on success, or a negative error code on failure.
+ * @returns The plugin object on success, or NULL on failure.
  */
-int kshark_register_plugin(struct kshark_context *kshark_ctx,
-			   const char *file)
+struct kshark_plugin_list *
+kshark_register_plugin(struct kshark_context *kshark_ctx,
+		       const char *name,
+		       const char *file)
 {
-	struct kshark_plugin_list *plugin = kshark_ctx->plugins;
+	kshark_plugin_load_func init_func, close_func;
+	kshark_check_data_func check_func;
+	struct kshark_plugin_list *plugin;
 	struct stat st;
 	int ret;
 
-	while (plugin) {
-		if (strcmp(plugin->file, file) == 0)
-			return -EEXIST;
+	printf("loading plugin \"%s\" from %s\n", name, file);
 
-		plugin = plugin->next;
+	plugin = kshark_find_plugin(kshark_ctx->plugins, file);
+	if(plugin) {
+		fputs("the plugin is already loaded.\n", stderr);
+		return NULL;
 	}
 
 	ret = stat(file, &st);
 	if (ret < 0) {
-		fprintf(stderr, "plugin %s not found\n", file);
-		return -ENODEV;
+		fprintf(stderr, "plugin %s not found.\n", file);
+		return NULL;
 	}
 
-	plugin = calloc(sizeof(struct kshark_plugin_list), 1);
+	plugin = calloc(1, sizeof(struct kshark_plugin_list));
 	if (!plugin) {
-		fprintf(stderr, "failed to allocate memory for plugin\n");
-		return -ENOMEM;
+		fputs("failed to allocate memory for plugin.\n", stderr);
+		return NULL;
 	}
 
-	if (asprintf(&plugin->file, "%s", file) <= 0) {
+	plugin->handle = dlopen(file, RTLD_NOW | RTLD_GLOBAL);
+	if (!plugin->handle) {
 		fprintf(stderr,
-			"failed to allocate memory for plugin file name");
-		return -ENOMEM;
+			"failed to open plugin file.\n%s\n",
+			dlerror());
+		goto fail;
 	}
 
-	plugin->handle = dlopen(plugin->file, RTLD_NOW | RTLD_GLOBAL);
-	if (!plugin->handle)
+	plugin->file = strdup(file);
+	plugin->name = strdup(name);
+	if (!plugin->file|| !plugin->name)
 		goto fail;
 
-	plugin->init = dlsym(plugin->handle,
-			     KSHARK_PLUGIN_INITIALIZER_NAME);
+	plugin->ctrl_interface =
+		dlsym(plugin->handle, KSHARK_MENU_PLUGIN_INITIALIZER_NAME);
+
+	init_func = dlsym(plugin->handle,
+			  KSHARK_PLOT_PLUGIN_INITIALIZER_NAME);
 
-	plugin->close = dlsym(plugin->handle,
-			      KSHARK_PLUGIN_DEINITIALIZER_NAME);
+	close_func = dlsym(plugin->handle,
+			   KSHARK_PLOT_PLUGIN_DEINITIALIZER_NAME);
 
-	if (!plugin->init || !plugin->close)
+	if (!!(long)init_func && !!(long)close_func) {
+		plugin->process_interface =
+			calloc(1, sizeof(*plugin->process_interface));
+
+		if (!plugin->process_interface)
+			goto fail;
+
+		plugin->process_interface->name = strdup(plugin->name);
+		plugin->process_interface->init = init_func;
+		plugin->process_interface->close = close_func;
+	} else if (!!(long)init_func || !!(long)close_func) {
+		fprintf(stderr,
+			"incomplete draw interface found (will be ignored).\n%s\n",
+			dlerror());
+	}
+
+	init_func = dlsym(plugin->handle,
+			  KSHARK_INPUT_INITIALIZER_NAME);
+
+	close_func = dlsym(plugin->handle,
+			   KSHARK_INPUT_DEINITIALIZER_NAME);
+
+	check_func = dlsym(plugin->handle,
+			   KSHARK_INPUT_CHECK_NAME);
+
+	if (!!(long)init_func &&
+	    !!(long)close_func &&
+	    !!(long)check_func) {
+		plugin->readout_interface =
+			calloc(1, sizeof(*plugin->readout_interface));
+
+		if (!plugin->readout_interface)
+			goto fail;
+
+		plugin->readout_interface->name = strdup(plugin->name);
+		plugin->readout_interface->init = init_func;
+		plugin->readout_interface->close = close_func;
+		plugin->readout_interface->check_data = check_func;
+
+		kshark_register_input(kshark_ctx, plugin->readout_interface);
+	} else if (!!(long)init_func ||
+		   !!(long)close_func ||
+		   !!(long)check_func) {
+		fprintf(stderr,
+			"incomplete input interface found (will be ignored).\n%s\n",
+			dlerror());
+	}
+
+	if (!plugin->process_interface &&
+	    !plugin->readout_interface &&
+	    !plugin->ctrl_interface) {
+		fputs("no interfaces found in this plugin.\n", stderr);
 		goto fail;
+	}
 
 	plugin->next = kshark_ctx->plugins;
 	kshark_ctx->plugins = plugin;
+	kshark_ctx->n_plugins++;
 
-	return 0;
+	return plugin;
 
  fail:
-	fprintf(stderr, "cannot load plugin '%s'\n%s\n",
-		plugin->file, dlerror());
+	fprintf(stderr, "cannot load plugin '%s'\n", file);
 
-	if (plugin->handle) {
+	if (plugin->handle)
 		dlclose(plugin->handle);
-		plugin->handle = NULL;
-	}
 
 	free(plugin);
 
-	return EFAULT;
+	return NULL;
+}
+
+/** Close and free this plugin. */
+static void free_plugin(struct kshark_plugin_list *plugin)
+{
+	dlclose(plugin->handle);
+
+	if (plugin->process_interface){
+		free(plugin->process_interface->name);
+		free(plugin->process_interface);
+	}
+
+	if (plugin->readout_interface) {
+		free(plugin->readout_interface->name);
+		free(plugin->readout_interface);
+	}
+
+	free(plugin->name);
+	free(plugin->file);
+	free(plugin);
 }
 
 /**
  * @brief Unrgister a plugin.
  *
- * @param kshark_ctx: Input location for context pointer.
+ * @param kshark_ctx: Input location for the session context pointer.
+ * @param name: The name of the plugin to unregister.
  * @param file: The plugin object file to unregister.
  */
 void kshark_unregister_plugin(struct kshark_context *kshark_ctx,
+			      const char *name,
 			      const char *file)
 {
 	struct kshark_plugin_list **last;
 
 	for (last = &kshark_ctx->plugins; *last; last = &(*last)->next) {
-		if (strcmp((*last)->file, file) == 0) {
+		if (strcmp((*last)->process_interface->name, name) == 0 &&
+		    strcmp((*last)->file, file) == 0) {
 			struct kshark_plugin_list *this_plugin;
+
 			this_plugin = *last;
 			*last = this_plugin->next;
+			free_plugin(this_plugin);
 
-			dlclose(this_plugin->handle);
-			free(this_plugin);
+			kshark_ctx->n_plugins--;
 
 			return;
 		}
@@ -248,48 +404,303 @@ void kshark_free_plugin_list(struct kshark_plugin_list *plugins)
 		last = plugins;
 		plugins = plugins->next;
 
-		free(last->file);
-		dlclose(last->handle);
+		free_plugin(last);
+	}
+}
+
+/**
+ * @brief Register a data readout interface (input).
+ *
+ * @param kshark_ctx: Input location for the context pointer.
+ * @param plugin: Input location for the data readout interface (input).
+ */
+struct kshark_dri_list *
+kshark_register_input(struct kshark_context *kshark_ctx,
+		      struct kshark_dri *plugin)
+{
+	struct kshark_dri_list *input;
+
+	input = calloc(1, sizeof(*input));
+	if (!input) {
+		fputs("failed to allocate memory for readout plugin.\n", stderr);
+		return NULL;
+	}
 
+	input->interface = plugin;
+	input->next = kshark_ctx->inputs;
+	kshark_ctx->inputs = input;
+
+	return input;
+}
+
+/**
+ * @brief Unrgister a data readout interface (input).
+ *
+ * @param kshark_ctx: Input location for the context pointer.
+ * @param name: The data readout's name.
+ */
+void kshark_unregister_input(struct kshark_context *kshark_ctx,
+			     const char *name)
+{
+	struct kshark_dri_list **last;
+
+	for (last = &kshark_ctx->inputs; *last; last = &(*last)->next) {
+		if (strcmp((*last)->interface->name, name) == 0) {
+			struct kshark_dri_list *this_input;
+			this_input = *last;
+			*last = this_input->next;
+
+			free(this_input);
+
+			return;
+		}
+	}
+}
+
+/**
+ * @brief Free a list of plugin interfaces.
+ *
+ * @param plugins: Input location for the plugins list.
+ */
+void
+kshark_free_dpi_list(struct kshark_dpi_list *plugins)
+{
+	struct kshark_dpi_list *last;
+
+	while (plugins) {
+		last = plugins;
+		plugins = plugins->next;
 		free(last);
 	}
 }
 
 /**
- * @brief Use this function to initialize/update/deinitialize all registered
- *	  plugins.
+ * @brief Find a plugin by its library file.
+ *
+ * @param plugins: A list of plugins to search in.
+ * @param lib: The plugin object file to load.
  *
- * @param kshark_ctx: Input location for context pointer.
+ * @returns The plugin object on success, or NULL on failure.
+ */
+struct kshark_plugin_list *
+kshark_find_plugin(struct kshark_plugin_list *plugins, const char *lib)
+{
+	for (; plugins; plugins = plugins->next)
+		if (strcmp(plugins->file, lib) == 0)
+			return plugins;
+
+	return NULL;
+}
+
+/**
+ * @brief Find a plugin by its name.
+ *
+ * @param plugins: A list of plugins to search in.
+ * @param name: The plugin object file to load.
+ *
+ * @returns The plugin object on success, or NULL on failure.
+ */
+struct kshark_plugin_list *
+kshark_find_plugin_by_name(struct kshark_plugin_list *plugins,
+			   const char *name)
+{
+	for (; plugins; plugins = plugins->next)
+		if (strcmp(plugins->name, name) == 0)
+			return plugins;
+
+	return NULL;
+}
+
+/**
+ * @brief Register plugin to a given data stream.
+ *
+ * @param stream: Input location for a Trace data stream pointer.
+ * @param plugin: Input location for the data processing interface.
+ * @param active: If false, the plugin will be registered but disables.
+ *		  Otherwise the plugin will be active.
+ *
+ * @returns The plugin object on success, or NULL on failure.
+ */
+struct kshark_dpi_list *
+kshark_register_plugin_to_stream(struct kshark_data_stream *stream,
+				 struct kshark_dpi *plugin,
+				 bool active)
+{
+	struct kshark_dpi_list *plugin_list = stream->plugins;
+
+	/* Check if the plugin is already registered to this stream. */
+	while (plugin_list) {
+		if (strcmp(plugin_list->interface->name, plugin->name) == 0 &&
+		    plugin_list->interface->init == plugin->init &&
+		    plugin_list->interface->close == plugin->close) {
+			kshark_handle_dpi(stream, plugin_list,
+					  KSHARK_PLUGIN_CLOSE);
+
+			plugin_list->status =
+				(active)? KSHARK_PLUGIN_ENABLED : 0;
+
+			return plugin_list;
+		}
+
+		plugin_list = plugin_list->next;
+	}
+
+	plugin_list = calloc(1, sizeof(*plugin_list));
+	plugin_list->interface = plugin;
+
+	if (active)
+		plugin_list->status = KSHARK_PLUGIN_ENABLED;
+
+	plugin_list->next = stream->plugins;
+	stream->plugins = plugin_list;
+	stream->n_plugins++;
+
+	return plugin_list;
+}
+
+/**
+ * @brief Unregister plugin to a given data stream.
+ *
+ * @param stream: Input location for a Trace data stream pointer.
+ * @param plugin: Input location for the data processing interface.
+ */
+void kshark_unregister_plugin_from_stream(struct kshark_data_stream *stream,
+				          struct kshark_dpi *plugin)
+{
+	struct kshark_dpi_list **last;
+
+	for (last = &stream->plugins; *last; last = &(*last)->next) {
+		if ((*last)->interface->init == plugin->init &&
+		    (*last)->interface->close == plugin->close &&
+		    strcmp((*last)->interface->name, plugin->name) == 0) {
+			struct kshark_dpi_list *this_plugin;
+
+			this_plugin = *last;
+			*last = this_plugin->next;
+			this_plugin->interface->close(stream);
+			free(this_plugin);
+
+			stream->n_plugins--;
+
+			return;
+		}
+	}
+}
+
+static void plugin_init(struct kshark_data_stream *stream,
+			struct kshark_dpi_list *plugin)
+{
+	int handler_count = plugin->interface->init(stream);
+
+	if (handler_count > 0) {
+		plugin->status &= ~KSHARK_PLUGIN_FAILED;
+		plugin->status |= KSHARK_PLUGIN_LOADED;
+	} else {
+		fprintf(stderr,
+			"plugin \"%s\" failed to initialize on stream %s:%s\n",
+			plugin->interface->name,
+			stream->file,
+			stream->name);
+
+		plugin->status |= KSHARK_PLUGIN_FAILED;
+		plugin->status &= ~KSHARK_PLUGIN_LOADED;
+	}
+}
+
+static void plugin_close(struct kshark_data_stream *stream,
+			 struct kshark_dpi_list *plugin)
+{
+	plugin->interface->close(stream);
+	plugin->status &= ~KSHARK_PLUGIN_LOADED;
+}
+
+/**
+ * @brief Use this function to initialize/update/deinitialize a plugin for
+ *	  a given Data stream.
+ *
+ * @param stream: Input location for a Trace data stream pointer.
+ * @param plugin: The plugin to be handled.
  * @param task_id: Action identifier specifying the action to be executed.
  *
  * @returns The number of successful added/removed plugin handlers on success,
  *	    or a negative error code on failure.
  */
-int kshark_handle_plugins(struct kshark_context *kshark_ctx,
-			  enum kshark_plugin_actions task_id)
+int kshark_handle_dpi(struct kshark_data_stream *stream,
+		      struct kshark_dpi_list *plugin,
+		      enum kshark_plugin_actions task_id)
 {
-	struct kshark_plugin_list *plugin;
 	int handler_count = 0;
 
-	for (plugin = kshark_ctx->plugins; plugin; plugin = plugin->next) {
-		switch (task_id) {
-		case KSHARK_PLUGIN_INIT:
-			handler_count += plugin->init(kshark_ctx);
-			break;
+	switch (task_id) {
+	case KSHARK_PLUGIN_INIT:
+		if (plugin->status & KSHARK_PLUGIN_ENABLED)
+			plugin_init(stream, plugin);
 
-		case KSHARK_PLUGIN_UPDATE:
-			plugin->close(kshark_ctx);
-			handler_count += plugin->init(kshark_ctx);
-			break;
+		break;
 
-		case KSHARK_PLUGIN_CLOSE:
-			handler_count += plugin->close(kshark_ctx);
-			break;
+	case KSHARK_PLUGIN_UPDATE:
+		if (plugin->status & KSHARK_PLUGIN_LOADED)
+			plugin_close(stream, plugin);
 
-		default:
-			return -EINVAL;
-		}
+		plugin->status &= ~KSHARK_PLUGIN_FAILED;
+
+		if (plugin->status & KSHARK_PLUGIN_ENABLED)
+			plugin_init(stream, plugin);
+
+		break;
+
+	case KSHARK_PLUGIN_CLOSE:
+		if (plugin->status & KSHARK_PLUGIN_LOADED)
+			plugin_close(stream, plugin);
+
+		plugin->status &= ~KSHARK_PLUGIN_FAILED;
+		break;
+
+	default:
+		return -EINVAL;
 	}
 
 	return handler_count;
 }
+
+/**
+ * @brief Use this function to initialize/update/deinitialize all registered
+ *	  data processing plugins for a given Data stream.
+ *
+ * @param stream: Input location for a Trace data stream pointer.
+ * @param task_id: Action identifier specifying the action to be executed. Can
+ *		   be KSHARK_PLUGIN_INIT, KSHARK_PLUGIN_UPDATE or
+ *		   KSHARK_PLUGIN_CLOSE.
+ *
+ * @returns The number of successful added/removed plugin handlers on success,
+ *	    or a negative error code on failure.
+ */
+int kshark_handle_all_dpis(struct kshark_data_stream *stream,
+			   enum kshark_plugin_actions task_id)
+{
+	struct kshark_dpi_list *plugin;
+	int handler_count = 0;
+
+	for (plugin = stream->plugins; plugin; plugin = plugin->next)
+		handler_count +=
+			kshark_handle_dpi(stream, plugin, task_id);
+
+	return handler_count;
+}
+
+/**
+ * @brief Free all readout interfaces in a given list.
+ *
+ * @param inputs: Input location for the inputs list.
+ */
+void kshark_free_dri_list(struct kshark_dri_list *inputs)
+{
+	struct kshark_dri_list *last;
+
+	while (inputs) {
+		last = inputs;
+		inputs = inputs->next;
+
+		free(last);
+	}
+}
diff --git a/src/libkshark-plugin.h b/src/libkshark-plugin.h
index b3cf1c62..3143b018 100644
--- a/src/libkshark-plugin.h
+++ b/src/libkshark-plugin.h
@@ -4,10 +4,10 @@
  * Copyright (C) 2016 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
  */
 
- /**
-  *  @file    libkshark-plugin.h
-  *  @brief   KernelShark plugins.
-  */
+/**
+ *  @file    libkshark-plugin.h
+ *  @brief   KernelShark plugins.
+ */
 
 #ifndef _KSHARK_PLUGIN_H
 #define _KSHARK_PLUGIN_H
@@ -16,35 +16,47 @@
 extern "C" {
 #endif // __cplusplus
 
-// trace-cmd
-#include "traceevent/event-parse.h"
+// C
+#include <stdint.h>
+#include <stdbool.h>
 
 /* Quiet warnings over documenting simple structures */
 //! @cond Doxygen_Suppress
 
-#define KSHARK_PLUGIN_INITIALIZER kshark_plugin_initializer
-
-#define KSHARK_PLUGIN_DEINITIALIZER kshark_plugin_deinitializer
-
 #define _MAKE_STR(x)	#x
+
 #define MAKE_STR(x)	_MAKE_STR(x)
 
-#define KSHARK_PLUGIN_INITIALIZER_NAME MAKE_STR(KSHARK_PLUGIN_INITIALIZER)
+#define KSHARK_PLOT_PLUGIN_INITIALIZER kshark_data_plugin_initializer
 
-#define KSHARK_PLUGIN_DEINITIALIZER_NAME MAKE_STR(KSHARK_PLUGIN_DEINITIALIZER)
+#define KSHARK_PLOT_PLUGIN_DEINITIALIZER kshark_data_plugin_deinitializer
 
-struct kshark_context;
+#define KSHARK_PLOT_PLUGIN_INITIALIZER_NAME MAKE_STR(KSHARK_PLOT_PLUGIN_INITIALIZER)
+
+#define KSHARK_PLOT_PLUGIN_DEINITIALIZER_NAME MAKE_STR(KSHARK_PLOT_PLUGIN_DEINITIALIZER)
+
+#define KSHARK_MENU_PLUGIN_INITIALIZER kshark_plugin_menu_initializer
+
+#define KSHARK_MENU_PLUGIN_INITIALIZER_NAME MAKE_STR(KSHARK_MENU_PLUGIN_INITIALIZER)
+
+#define KSHARK_INPUT_INITIALIZER kshark_input_initializer
+
+#define KSHARK_INPUT_DEINITIALIZER kshark_input_deinitializer
+
+#define KSHARK_INPUT_CHECK kshark_input_check
+
+#define KSHARK_INPUT_INITIALIZER_NAME MAKE_STR(KSHARK_INPUT_INITIALIZER)
 
+#define KSHARK_INPUT_DEINITIALIZER_NAME MAKE_STR(KSHARK_INPUT_DEINITIALIZER)
+
+#define KSHARK_INPUT_CHECK_NAME MAKE_STR(KSHARK_INPUT_CHECK)
+
+struct kshark_data_stream;
+struct kshark_context;
 struct kshark_entry;
 
 //! @endcond
 
-/**
- * A function type to be used when defining load/reload/unload plugin
- * functions.
- */
-typedef int (*kshark_plugin_load_func)(struct kshark_context *);
-
 struct kshark_trace_histo;
 
 /**
@@ -57,18 +69,17 @@ struct kshark_cpp_argv {
 };
 
 /** A function type to be used when defining plugin functions for drawing. */
-typedef void
-(*kshark_plugin_draw_handler_func)(struct kshark_cpp_argv *argv,
-				   int val, int draw_action);
+typedef void (*kshark_plugin_draw_handler_func)(struct kshark_cpp_argv *argv,
+						int sd,
+						int val,
+						int draw_action);
 
 /**
  * A function type to be used when defining plugin functions for data
  * manipulation.
  */
-typedef void
-(*kshark_plugin_event_handler_func)(struct kshark_context *kshark_ctx,
-				    struct tep_record *rec,
-				    struct kshark_entry *e);
+typedef void (*kshark_plugin_event_handler_func)(struct kshark_data_stream *stream,
+						 void *rec, struct kshark_entry *e);
 
 /** Plugin action identifier. */
 enum kshark_plugin_actions {
@@ -89,30 +100,15 @@ enum kshark_plugin_actions {
 	 * plugins.
 	 */
 	KSHARK_PLUGIN_CLOSE,
-
-	/**
-	 * Task draw action. This action identifier is used by the plugin draw
-	 * function.
-	 */
-	KSHARK_PLUGIN_TASK_DRAW,
-
-	/**
-	 * CPU draw action. This action identifier is used by the plugin draw
-	 * function.
-	 */
-	KSHARK_PLUGIN_CPU_DRAW,
 };
 
-/**
- * Plugin Event handler structure, defining the properties of the required
- * kshark_entry.
- */
-struct kshark_event_handler {
-	/** Pointer to the next Plugin Event handler. */
-	struct kshark_event_handler		*next;
+/** No event identifier associated with the plugin. */
+#define KS_PLUGIN_NO_EVENT (-ENODEV)
 
-	/** Unique Id ot the trace event type. */
-	int					id;
+/** Plugin's Trace event processing handler structure. */
+struct kshark_event_proc_handler {
+	/** Pointer to the next Plugin Event handler. */
+	struct kshark_event_proc_handler		*next;
 
 	/**
 	 * Event action function. This action can be used to modify the content
@@ -120,6 +116,28 @@ struct kshark_event_handler {
 	 */
 	kshark_plugin_event_handler_func	event_func;
 
+	/** Unique Id ot the trace event type. */
+	int id;
+};
+
+struct kshark_event_proc_handler *
+kshark_find_event_handler(struct kshark_event_proc_handler *handlers, int event_id);
+
+int kshark_register_event_handler(struct kshark_data_stream *stream,
+				  int event_id,
+				  kshark_plugin_event_handler_func evt_func);
+
+void kshark_unregister_event_handler(struct kshark_data_stream *stream,
+				     int event_id,
+				     kshark_plugin_event_handler_func evt_func);
+
+void kshark_free_event_handler_list(struct kshark_event_proc_handler *handlers);
+
+/** Plugin's drawing handler structure. */
+struct kshark_draw_handler {
+	/** Pointer to the next Plugin Event handler. */
+	struct kshark_draw_handler		*next;
+
 	/**
 	 * Draw action function. This action can be used to draw additional
 	 * graphical elements (shapes) for all kshark_entries having Event Ids
@@ -128,31 +146,66 @@ struct kshark_event_handler {
 	kshark_plugin_draw_handler_func		draw_func;
 };
 
-struct kshark_event_handler *
-kshark_find_event_handler(struct kshark_event_handler *handlers, int event_id);
+int kshark_register_draw_handler(struct kshark_data_stream *stream,
+				 kshark_plugin_draw_handler_func draw_func);
 
-int kshark_register_event_handler(struct kshark_event_handler **handlers,
-				  int event_id,
-				  kshark_plugin_event_handler_func evt_func,
-				  kshark_plugin_draw_handler_func dw_func);
+void kshark_unregister_draw_handler(struct kshark_data_stream *stream,
+				    kshark_plugin_draw_handler_func draw_func);
 
-void kshark_unregister_event_handler(struct kshark_event_handler **handlers,
-				     int event_id,
-				     kshark_plugin_event_handler_func evt_func,
-				     kshark_plugin_draw_handler_func dw_func);
+void kshark_free_draw_handler_list(struct kshark_draw_handler *handlers);
 
-void kshark_free_event_handler_list(struct kshark_event_handler *handlers);
+/**
+ * A function type to be used when defining load/reload/unload plugin
+ * functions.
+ */
+typedef int (*kshark_plugin_load_func)(struct kshark_data_stream *);
 
-/** Linked list of plugins. */
-struct kshark_plugin_list {
-	/** Pointer to the next Plugin. */
-	struct kshark_plugin_list	*next;
+/**
+ * A function type to be used when data check function for the plugin.
+ */
+typedef int (*kshark_check_data_func)(const char *filename);
 
-	/** The plugin object file to load. */
-	char				*file;
+/**
+ * A function type to be used when defining plugin's configuration/control
+ * function.
+ */
+typedef void *(*kshark_plugin_ctrl_func)(void *);
+
+
+/** Plugable Data Readout Interface (dri). */
+struct kshark_dri {
+	/** A short name for this data input. */
+	char				*name;
+
+	/** Data format identifier. */
+	int				format;
+
+	/** Callback function for initialization of the data input. */
+	kshark_plugin_load_func		init;
+
+	/** Callback function for deinitialization of the data input. */
+	kshark_plugin_load_func		close;
+
+	/**
+	 * Callback function for checking if the data input is applicable for
+	 * a given data file.
+	 */
+	kshark_check_data_func		check_data;
+};
 
-	/** Plugin Event handler. */
-	void				*handle;
+/** Linked list of Data Readout Interfaces (dri). */
+struct kshark_dri_list {
+	/** Pointer to the next input interface. */
+	struct kshark_dri_list		*next;
+
+	/** Pointer to the interface of methods used by the input. */
+	struct kshark_dri		*interface;
+};
+
+/** Plugable Data Processing Interface (dpi). */
+struct kshark_dpi {
+	/** The plugin's short name. */
+	char				*name;
 
 	/** Callback function for initialization of the plugin. */
 	kshark_plugin_load_func		init;
@@ -161,16 +214,102 @@ struct kshark_plugin_list {
 	kshark_plugin_load_func		close;
 };
 
-int kshark_register_plugin(struct kshark_context *kshark_ctx,
-			   const char *file);
+/** Linked list of data processing interfaces (dpi). */
+struct kshark_dpi_list {
+	/** Pointer to the next plugin interface. */
+	struct kshark_dpi_list		*next;
+
+	/** Pointer to the interface of methods used by the plugin. */
+	struct kshark_dpi		*interface;
+
+	/**
+	 * The status of the interface.
+	 */
+	int				status;
+};
+
+struct kshark_dri_list *
+kshark_register_input(struct kshark_context *kshark_ctx,
+		      struct kshark_dri *plugin);
+
+void kshark_unregister_input(struct kshark_context *kshark_ctx,
+			     const char *file);
+
+void kshark_free_dri_list(struct kshark_dri_list *inputs);
+
+/** Linked list of plugins. */
+struct kshark_plugin_list {
+	/** Pointer to the next plugin. */
+	struct kshark_plugin_list	*next;
+
+	/** The plugin's short name. */
+	char	*name;
+
+	/** The plugin object file to load. */
+	char	*file;
+
+	/** Plugin's object file handler. */
+	void	*handle;
+
+	/**
+	 * Control interface of the plugin. Can be used to configure
+	 * the plugin.
+	 */
+	kshark_plugin_ctrl_func		ctrl_interface;
+
+	/** The interface of methods used by a data processing plugin. */
+	struct kshark_dpi		*process_interface;
+
+	/** The interface of methods used by a data readout plugin. */
+	struct kshark_dri		*readout_interface;
+};
+
+/** Plugin status identifiers. */
+enum kshark_plugin_status {
+	/** The plugin is enabled. */
+	KSHARK_PLUGIN_ENABLED	= 1 << 0,
+
+	/** The plugin is successfully loaded. */
+	KSHARK_PLUGIN_LOADED	= 1 << 1,
+
+	/** The plugin failed to initialization. */
+	KSHARK_PLUGIN_FAILED	= 1 << 2,
+};
+
+struct kshark_plugin_list *
+kshark_register_plugin(struct kshark_context *kshark_ctx,
+		       const char *name,
+		       const char *file);
 
 void kshark_unregister_plugin(struct kshark_context *kshark_ctx,
+			      const char *name,
 			      const char *file);
 
 void kshark_free_plugin_list(struct kshark_plugin_list *plugins);
 
-int kshark_handle_plugins(struct kshark_context *kshark_ctx,
-			  enum kshark_plugin_actions  task_id);
+void kshark_free_dpi_list(struct kshark_dpi_list *plugins);
+
+struct kshark_plugin_list *
+kshark_find_plugin(struct kshark_plugin_list *plugins, const char *file);
+
+struct kshark_plugin_list *
+kshark_find_plugin_by_name(struct kshark_plugin_list *plugins,
+			   const char *name);
+
+struct kshark_dpi_list *
+kshark_register_plugin_to_stream(struct kshark_data_stream *stream,
+				 struct kshark_dpi *plugin,
+				 bool active);
+
+void kshark_unregister_plugin_from_stream(struct kshark_data_stream *stream,
+					  struct kshark_dpi *plugin);
+
+int kshark_handle_dpi(struct kshark_data_stream *stream,
+		      struct kshark_dpi_list *plugin,
+		      enum kshark_plugin_actions task_id);
+
+int kshark_handle_all_dpis(struct kshark_data_stream *stream,
+			   enum kshark_plugin_actions  task_id);
 
 #ifdef __cplusplus
 }
diff --git a/src/libkshark.c b/src/libkshark.c
index e363395a..bd2e4cc0 100644
--- a/src/libkshark.c
+++ b/src/libkshark.c
@@ -16,6 +16,7 @@
 #include <stdlib.h>
 #include <stdio.h>
 #include <assert.h>
+#include <string.h>
 
 // KernelShark
 #include "libkshark.h"
@@ -34,7 +35,6 @@ static bool kshark_default_context(struct kshark_context **context)
 	kshark_ctx->stream = calloc(KS_MAX_NUM_STREAMS,
 				    sizeof(*kshark_ctx->stream));
 
-	kshark_ctx->event_handlers = NULL;
 	kshark_ctx->collections = NULL;
 	kshark_ctx->plugins = NULL;
 
@@ -224,12 +224,22 @@ static void set_format(struct kshark_context *kshark_ctx,
 		       struct kshark_data_stream *stream,
 		       const char *filename)
 {
+	struct kshark_dri_list *input;
+
 	stream->format = KS_INVALIDE_DATA;
 
 	if (is_tep(filename)) {
 		stream->format = KS_TEP_DATA;
 		return;
 	}
+
+	for (input = kshark_ctx->inputs; input; input = input->next) {
+		stream->format = input->interface->check_data(filename);
+		if (stream->format != KS_INVALIDE_DATA) {
+			input->interface->format = stream->format;
+			return;
+		}
+	}
 }
 
 /**
@@ -244,6 +254,7 @@ static void set_format(struct kshark_context *kshark_ctx,
 int kshark_stream_open(struct kshark_data_stream *stream, const char *file)
 {
 	struct kshark_context *kshark_ctx = NULL;
+	struct kshark_dri_list *input;
 
 	if (!stream || !kshark_instance(&kshark_ctx))
 		return -EFAULT;
@@ -256,6 +267,11 @@ int kshark_stream_open(struct kshark_data_stream *stream, const char *file)
 		return kshark_tep_init_input(stream, file);
 
 	default:
+		for (input = kshark_ctx->inputs; input; input = input->next) {
+			if (stream->format == input->interface->format)
+				return input->interface->init(stream);
+		}
+
 		return -ENODATA;
 	}
 }
@@ -323,6 +339,7 @@ int *kshark_all_streams(struct kshark_context *kshark_ctx)
 static void kshark_stream_close(struct kshark_data_stream *stream)
 {
 	struct kshark_context *kshark_ctx = NULL;
+	struct kshark_dri_list *input;
 
 	if (!stream || !kshark_instance(&kshark_ctx))
 		return;
@@ -344,6 +361,11 @@ static void kshark_stream_close(struct kshark_data_stream *stream)
 		break;
 
 	default:
+		for (input = kshark_ctx->inputs; input; input = input->next) {
+			if (stream->format == input->interface->format)
+				input->interface->close(stream);
+		}
+
 		break;
 	}
 
@@ -364,6 +386,13 @@ void kshark_close(struct kshark_context *kshark_ctx, int sd)
 	if (!stream)
 		return;
 
+	/* Close all active plugins for this stream. */
+	if (stream->plugins) {
+		kshark_handle_all_dpis(stream, KSHARK_PLUGIN_CLOSE);
+		kshark_free_event_handler_list(stream->event_handlers);
+		kshark_free_dpi_list(stream->plugins);
+	}
+
 	kshark_stream_close(stream);
 	kshark_stream_free(stream);
 	kshark_ctx->stream[sd] = NULL;
@@ -418,6 +447,8 @@ void kshark_free(struct kshark_context *kshark_ctx)
 	if (kshark_ctx->plugins)
 		kshark_free_plugin_list(kshark_ctx->plugins);
 
+	kshark_free_dri_list(kshark_ctx->inputs);
+
 	if (kshark_ctx == kshark_context_handler)
 		kshark_context_handler = NULL;
 
@@ -702,6 +733,29 @@ void kshark_clear_all_filters(struct kshark_context *kshark_ctx,
 		set_all_visible(&data[i]->visible);
 }
 
+/**
+ * @brief Process all registered event-specific plugin actions.
+ *
+ * @param stream: Input location for a Trace data stream pointer.
+ * @param record: Input location for the trace record.
+ * @param entry: Output location for entry.
+ */
+void kshark_plugin_actions(struct kshark_data_stream *stream,
+			   void *record, struct kshark_entry *entry)
+{
+	if (stream->event_handlers) {
+		/* Execute all plugin-provided actions for this event (if any). */
+		struct kshark_event_proc_handler *evt_handler = stream->event_handlers;
+
+		while ((evt_handler = kshark_find_event_handler(evt_handler,
+								entry->event_id))) {
+			evt_handler->event_func(stream, record, entry);
+			evt_handler = evt_handler->next;
+			entry->visible &= ~KS_PLUGIN_UNTOUCHED_MASK;
+		}
+	}
+}
+
 static inline void free_ptr(void *ptr)
 {
 	if (ptr)
diff --git a/src/libkshark.h b/src/libkshark.h
index 54c71a77..a73539f4 100644
--- a/src/libkshark.h
+++ b/src/libkshark.h
@@ -313,6 +313,18 @@ struct kshark_data_stream {
 	/** The type of the data. */
 	enum kshark_data_format		format;
 
+	/** List of Plugin interfaces. */
+	struct kshark_dpi_list	*plugins;
+
+	/** The number of plugins registered for this stream.*/
+	int			n_plugins;
+
+	/** List of Plugin's Event handlers. */
+	struct kshark_event_proc_handler	*event_handlers;
+
+	/** List of Plugin's Draw handlers. */
+	struct kshark_draw_handler		*draw_handlers;
+
 	/**
 	 * The interface of methods used to operate over the data from a given
 	 * stream.
@@ -368,11 +380,17 @@ struct kshark_context {
 	/** List of Data collections. */
 	struct kshark_entry_collection *collections;
 
+	/** List of data readout interfaces. */
+	struct kshark_dri_list		*inputs;
+
+	/** The number of readout interfaces. */
+	int				n_inputs;
+
 	/** List of Plugins. */
 	struct kshark_plugin_list	*plugins;
 
-	/** List of Plugin Event handlers. */
-	struct kshark_event_handler	*event_handlers;
+	/** The number of plugins. */
+	int				n_plugins;
 };
 
 bool kshark_instance(struct kshark_context **kshark_ctx);
@@ -665,6 +683,9 @@ void kshark_clear_all_filters(struct kshark_context *kshark_ctx,
 			      struct kshark_entry **data,
 			      size_t n_entries);
 
+void kshark_plugin_actions(struct kshark_data_stream *stream,
+			   void *record, struct kshark_entry *entry);
+
 /** Search failed identifiers. */
 enum kshark_search_failed {
 	/** All entries have timestamps greater timestamps. */
-- 
2.25.1


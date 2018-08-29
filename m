Return-Path: <SRS0=cHGG=LM=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:42252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727444AbeH3Ab3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 29 Aug 2018 20:31:29 -0400
Date: Wed, 29 Aug 2018 16:32:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/7] kernel-shark-qt: Add plugin infrastructure to be
 used by the Qt-baset KS.
Message-ID: <20180829163253.7ba150f5@gandalf.local.home>
In-Reply-To: <20180829164224.20677-2-y.karadz@gmail.com>
References: <20180829164224.20677-1-y.karadz@gmail.com>
        <20180829164224.20677-2-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 29 Aug 2018 19:42:18 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> diff --git a/kernel-shark-qt/src/libkshark-plugin.c b/kernel-shark-qt/src/libkshark-plugin.c
> new file mode 100644
> index 0000000..7d9c5a0
> --- /dev/null
> +++ b/kernel-shark-qt/src/libkshark-plugin.c
> @@ -0,0 +1,292 @@
> +// SPDX-License-Identifier: LGPL-2.1
> +
> +/*
> + * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
> + */
> +
> + /**
> +  *  @file    libkshark-plugin.c
> +  *  @brief   KernelShark plugins.
> +  */
> +
> +// C
> +#define _GNU_SOURCE
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <sys/stat.h>
> +#include <dlfcn.h>
> +
> +// KernelShark
> +#include "libkshark-plugin.h"
> +#include "libkshark.h"
> +
> +static struct kshark_event_handler *
> +gui_event_handler_alloc(int event_id,
> +			kshark_plugin_event_handler_func evt_func,
> +			kshark_plugin_draw_handler_func dw_func)
> +{
> +	struct kshark_event_handler *handler = malloc(sizeof(*handler));
> +
> +	if (!handler) {
> +		fprintf(stderr,
> +			"failed to allocate memory for gui eventhandler");
> +		return NULL;
> +	}
> +
> +	handler->next = NULL;
> +	handler->id = event_id;
> +	handler->event_func = evt_func;
> +	handler->draw_func = dw_func;
> +
> +	return handler;
> +}
> +
> +/**
> + * @brief Search the list of event handlers for a handle associated with a given event type.
> + *
> + * @param handlers: Input location for the Event handler list.
> + * @param event_id: Event Id to search for.
> + */
> +struct kshark_event_handler *
> +find_event_handler(struct kshark_event_handler *handlers, int event_id)
> +{
> +	while (handlers) {

Note, I prefer these to be for loops. Whenever there's a simple
iteration, a for loop is best to use (note this is what is expected in
the kernel too).

	for (; handlers; handles = handles->next) {

> +		if (handlers->id == event_id)
> +			return handlers;

	}

	return NULL;

> +
> +		handlers = handlers->next;
> +	}
> +
> +	return NULL;
> +}
> +
> +/**
> + * @brief Add new event handler to an existing list of handlers.
> + *
> + * @param handlers: Input location for the Event handler list.
> + * @param event_id: Event Id.
> + * @param evt_func: Input location for an Event action provided by the plugin.
> + * @param dw_func: Input location for a Draw action provided by the plugin.
> + */
> +void kshark_register_event_handler(struct kshark_event_handler **handlers,

This should return 0 on success and negative on error (failed malloc).


> +				   int event_id,
> +				   kshark_plugin_event_handler_func evt_func,
> +				   kshark_plugin_draw_handler_func dw_func)
> +{
> +	struct kshark_event_handler *handler =
> +		gui_event_handler_alloc(event_id, evt_func, dw_func);
> +
> +	if(!handler)
> +		return;
> +
> +	handler->next = *handlers;
> +	*handlers = handler;
> +}
> +
> +/**
> + * @brief Search the list for a specific plugin handle. If such a plugin handle
> + *	  exists, unregister (remove and free) this handle from the list.
> + *
> + * @param handlers: Input location for the Event handler list.
> + * @param event_id: Event Id of the plugin handler to be unregistered.
> + * @param evt_func: Event action function of the handler to be unregistered.
> + * @param dw_func: Draw action function of the handler to be unregistered.
> + */
> +void
> +kshark_unregister_event_handler(struct kshark_event_handler **handlers,
> +				int event_id,
> +				kshark_plugin_event_handler_func evt_func,
> +				kshark_plugin_draw_handler_func dw_func)
> +{
> +	struct kshark_event_handler **last = handlers;
> +	struct kshark_event_handler *list;
> +
> +	for (list = *handlers; list; list = list->next) {

You can simplify this to:

	for (last = handlers; *last; last = &(*last)->next) {
		list = *last;

> +		if (list->id == event_id &&
> +		    list->event_func == evt_func &&
> +		    list->draw_func == dw_func) {
> +			*last = list->next;
> +			free(list);
> +			return;
> +		}
> +


> +		last = &list->next;

Then you can remove the above line.

> +	}
> +}
> +
> +/**
> + * @brief Free all Event handlers in a given list.
> + *
> + * @param handlers: Input location for the Event handler list.
> + */
> +void kshark_free_event_handler_list(struct kshark_event_handler *handlers)
> +{
> +	struct kshark_event_handler *last;
> +
> +	while (handlers) {
> +		last = handlers;
> +		handlers = handlers->next;
> +		free(last);
> +	}
> +}
> +
> +/**
> + * @brief Allocate memory for a new plugin. Add this plugin to the list of
> + *	  plugins used by the session.
> + *
> + * @param kshark_ctx: Input location for the session context pointer.
> + * @param file: The plugin object file to load.
> + */
> +void kshark_register_plugin(struct kshark_context *kshark_ctx,
> +			    const char *file)

Should return zero on success, and a negative on failure to add.

> +{
> +	struct kshark_plugin_list *plugin = kshark_ctx->plugins;
> +	struct stat st;
> +	int ret;
> +
> +	while (plugin) {
> +		if (strcmp(plugin->file, file) == 0)
> +			return;

			return -EEXIST;

> +
> +		plugin = plugin->next;
> +	}
> +
> +	ret = stat(file, &st);
> +	if (ret < 0) {
> +		fprintf(stderr, "plugin %s not found\n", file);
> +		return;

		return -ENODEV;

> +	}
> +
> +	plugin = calloc(sizeof(struct kshark_plugin_list), 1);
> +	if (!plugin) {
> +		fprintf(stderr, "failed to allocate memory for plugin\n");
> +		return;

		return -ENOMEM;

> +	}
> +
> +	asprintf(&plugin->file, "%s", file);
> +	plugin->handle = NULL;
> +
> +	plugin->next = kshark_ctx->plugins;
> +	kshark_ctx->plugins = plugin;

	return 0;

> +}
> +
> +/**
> + * @brief Register a new plugin..
> + *
> + * @param kshark_ctx: Input location for context pointer.
> + * @param file: The plugin object file to load.
> + */
> +void kshark_unregister_plugin(struct kshark_context *kshark_ctx,
> +			      const char *file)
> +{
> +	struct kshark_plugin_list **last = &kshark_ctx->plugins;
> +	struct kshark_plugin_list *list;
> +
> +	for (list = kshark_ctx->plugins; list; list = list->next) {

Same simplification can be done here.

> +		if (strcmp(list->file, file) == 0) {
> +			*last = list->next;
> +			free(list->file);
> +			free(list);
> +			return;
> +		}
> +
> +		last = &list->next;
> +	}
> +}
> +
> +/**
> + * @brief Free all plugins in a given list.
> + *
> + * @param plugins: Input location for the plugins list.
> + */
> +void kshark_free_plugin_list(struct kshark_plugin_list *plugins)
> +{
> +	struct kshark_plugin_list *last;
> +
> +	while (plugins) {
> +		last = plugins;
> +		plugins = plugins->next;
> +		free(last->file);
> +		free(last);
> +	}
> +}
> +
> +/**
> + * @brief Use this function to load/reload/unload all registered plugins.
> + *
> + * @param kshark_ctx: Input location for context pointer.
> + * @param task_id: Action identifier specifying the action to be executed.
> + */
> +void kshark_handle_plugins(struct kshark_context *kshark_ctx,

Should return 0 on success, negative on error.

> +			   int task_id)
> +{
> +	kshark_plugin_load_func func;
> +	struct kshark_plugin_list *plugin;
> +	char* func_name;
> +	int fn_size = 0;
> +
> +	switch (task_id) {
> +		case KSHARK_PLUGIN_LOAD:
> +			fn_size = asprintf(&func_name,
> +					   KSHARK_PLUGIN_LOADER_NAME);
> +			break;
> +
> +		case KSHARK_PLUGIN_RELOAD:
> +			fn_size = asprintf(&func_name,
> +					   KSHARK_PLUGIN_RELOADER_NAME);
> +			break;
> +
> +		case KSHARK_PLUGIN_UNLOAD:
> +			fn_size = asprintf(&func_name,
> +					   KSHARK_PLUGIN_UNLOADER_NAME);
> +			break;
> +
> +		default:
> +			return;

			return -EINVAL;

> +	}
> +
> +	if (fn_size <= 0) {
> +		fprintf(stderr,
> +			"failed to allocate memory for plugin function name");
> +		return;

		return -ENOMEM;

> +	}
> +
> +	for (plugin = kshark_ctx->plugins; plugin; plugin = plugin->next) {
> +		if (task_id == KSHARK_PLUGIN_LOAD) {
> +			plugin->handle =
> +				dlopen(plugin->file, RTLD_NOW | RTLD_GLOBAL);
> +
> +			if (!plugin->handle) {
> +				fprintf(stderr,
> +					"cannot load plugin '%s'\n%s\n",
> +					plugin->file,
> +					dlerror());
> +
> +				continue;
> +			}
> +		}
> +
> +		func = dlsym(plugin->handle, func_name);
> +		if (!func) {
> +			fprintf(stderr,
> +				"cannot find func '%s' in plugin '%s'\n%s\n",
> +				func_name,
> +				plugin->file,
> +				dlerror());
> +
> +			dlclose(plugin->handle);
> +			plugin->handle = NULL;
> +			continue;
> +		}
> +
> +		func();
> +
> +		if (task_id == KSHARK_PLUGIN_UNLOAD && plugin->handle) {
> +			dlclose(plugin->handle);
> +			plugin->handle = NULL;
> +		}
> +	}
> +
> +	free(func_name);

Hmm, perhaps we should return the number of successful operations?

-- Steve

> +}
> diff --git a/kernel-shark-qt/src/libkshark-plugin.h b/kernel-shark-qt/src/libkshark-plugin.h
> new file mode 100644
> index 0000000..7328197

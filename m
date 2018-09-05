Return-Path: <SRS0=O6SV=LT=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:51772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725853AbeIEGhJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 5 Sep 2018 02:37:09 -0400
Date: Tue, 4 Sep 2018 22:09:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/7] kernel-shark-qt: Add plugin infrastructure to be
 used by the Qt-baset KS.
Message-ID: <20180904220917.5f14f899@vmware.local.home>
In-Reply-To: <20180904155218.32518-2-y.karadz@gmail.com>
References: <20180904155218.32518-1-y.karadz@gmail.com>
        <20180904155218.32518-2-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Tue,  4 Sep 2018 18:52:12 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> +/**
> + * @brief Use this function to load/reload/unload all registered plugins.
> + *
> + * @param kshark_ctx: Input location for context pointer.
> + * @param task_id: Action identifier specifying the action to be executed.
> + *
> + * @returns The number of successful operations on success, or a negative error
> + *	    code on failure.
> + */
> +int kshark_handle_plugins(struct kshark_context *kshark_ctx,
> +			  int task_id)

task_id should be of type enum kshark_plugin_actions.

> +{
> +	kshark_plugin_load_func func;
> +	struct kshark_plugin_list *plugin;
> +	int fn_size = 0, plugin_count = 0;
> +	char* func_name;
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

Why are you allocating the func_name?

			func_name = KSHARK_PLUGIN_UNLOADER_NAME;

should work.

> +
> +		default:
> +			return -EINVAL;
> +	}
> +
> +	if (fn_size <= 0) {
> +		fprintf(stderr,
> +			"failed to allocate memory for plugin function name");
> +		return -ENOMEM;
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
> +		if (plugin->handle) {
> +			func = dlsym(plugin->handle, func_name);
> +			if (!func) {
> +				fprintf(stderr,
> +					"cannot find func '%s' in plugin '%s'\n%s\n",
> +					func_name,
> +					plugin->file,
> +					dlerror());
> +
> +				dlclose(plugin->handle);
> +				plugin->handle = NULL;
> +				continue;
> +			}
> +
> +			func();

These functions need to take in two parameters and also return a value;

			ret = func(&plugin->private_data, kshark_ctx);

Otherwise the plugins will only be initializing global data and wont be
able to initialize per file. If we load two files, how are the plugins
going to know what event is for which file?

The plugin structure should have a "private_data" field that the plugin
can allocate to (that's why we pass in the address), and it should be
of type void *, that way the plugin can make any data structure it
wants to be associated to this kshark_ctx, and create its own data
scope per the file.

A plugin can also simply ignore that field if it doesn't need to
save any kind of state.

The function should also return a value to let the this context know if
it succeeded or simply should be ignored.

 < 0 return value is an error,
 = 0 return value is "ignore this plugin for this kshark_ctx"
 > 0 return value means, everything is good.

This is what I was trying to say in our meeting.

-- Steve


> +			++plugin_count;
> +
> +			if (task_id == KSHARK_PLUGIN_UNLOAD) {
> +				dlclose(plugin->handle);
> +				plugin->handle = NULL;
> +			}
> +		}
> +	}
> +
> +	free(func_name);
> +
> +	return plugin_count;
> +}
> diff --git a/kernel-shark-qt/src/libkshark-plugin.h b/kernel-shark-qt/src/libkshark-plugin.h
> new file mode 100644
> index 00000000..34143204
> --- /dev/null
> +++ b/kernel-shark-qt/src/libkshark-plugin.h
> @@ -0,0 +1,171 @@
> +/* SPDX-License-Identifier: LGPL-2.1 */
> +
> +/*
> + * Copyright (C) 2016 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
> + */
> +
> + /**
> +  *  @file    libkshark-plugin.h
> +  *  @brief   KernelShark plugins.
> +  */
> +
> +#ifndef _KSHARK_PLUGIN_H
> +#define _KSHARK_PLUGIN_H
> +
> +#ifdef __cplusplus
> +extern "C" {
> +#endif // __cplusplus
> +
> +// trace-cmd
> +#include "event-parse.h"
> +
> +/* Quiet warnings over documenting simple structures */
> +//! @cond Doxygen_Suppress
> +
> +#define KSHARK_PLUGIN_LOADER kshark_plugin_loader
> +#define KSHARK_PLUGIN_RELOADER kshark_plugin_reloader
> +#define KSHARK_PLUGIN_UNLOADER kshark_plugin_unloader
> +
> +#define _MAKE_STR(x)	#x
> +#define MAKE_STR(x)	_MAKE_STR(x)
> +#define KSHARK_PLUGIN_LOADER_NAME MAKE_STR(KSHARK_PLUGIN_LOADER)
> +#define KSHARK_PLUGIN_RELOADER_NAME MAKE_STR(KSHARK_PLUGIN_RELOADER)
> +#define KSHARK_PLUGIN_UNLOADER_NAME MAKE_STR(KSHARK_PLUGIN_UNLOADER)
> +
> +struct kshark_context;
> +struct kshark_entry;
> +
> +//! @endcond
> +
> +/**
> + * A function type to be used when defining load/reload/unload plugin
> + * functions.
> + */
> +typedef int (*kshark_plugin_load_func)(void);
> +
> +struct kshark_trace_histo;
> +
> +/**
> + * Structure representing the C arguments of the drawing function of
> + * a plugin.
> + */
> +struct kshark_cpp_argv {
> +	/** Pointer to the model descriptor object. */
> +	struct kshark_trace_histo	*histo;
> +};
> +
> +/** A function type to be used when defining plugin functions for drawing. */
> +typedef void
> +(*kshark_plugin_draw_handler_func)(struct kshark_cpp_argv *argv,
> +				   int val, int draw_action);
> +
> +/**
> + * A function type to be used when defining plugin functions for data
> + * manipulation.
> + */
> +typedef void
> +(*kshark_plugin_event_handler_func)(struct kshark_context *kshark_ctx,
> +				    struct tep_record *rec,
> +				    struct kshark_entry *e);
> +
> +/** Plugin action identifier. */
> +enum kshark_plugin_actions {
> +	/**
> +	 * Load plugins action. This action identifier is used when handling
> +	 * plugins.
> +	 */
> +	KSHARK_PLUGIN_LOAD,
> +
> +	/**
> +	 * Reload plugins action. This action identifier is used when handling
> +	 * plugins.
> +	 */
> +	KSHARK_PLUGIN_RELOAD,
> +
> +	/**
> +	 * Unload plugins action. This action identifier is used when handling
> +	 * plugins.
> +	 */
> +	KSHARK_PLUGIN_UNLOAD,
> +
> +	/**
> +	 * Task draw action. This action identifier is used by the plugin draw
> +	 * function.
> +	 */
> +	KSHARK_PLUGIN_TASK_DRAW,
> +
> +	/**
> +	 * CPU draw action. This action identifier is used by the plugin draw
> +	 * function.
> +	 */
> +	KSHARK_PLUGIN_CPU_DRAW,
> +};
> +
> +/**
> + * Plugin Event handler structure, defining the properties of the required
> + * kshark_entry.
> + */
> +struct kshark_event_handler {
> +	/** Pointer to the next Plugin Event handler. */
> +	struct kshark_event_handler		*next;
> +
> +	/** Unique Id ot the trace event type. */
> +	int					id;
> +
> +	/**
> +	 * Event action function. This action can be used to modify the content
> +	 * of all kshark_entries having Event Ids equal to "id".
> +	 */
> +	kshark_plugin_event_handler_func	event_func;
> +
> +	/**
> +	 * Draw action function. This action can be used to draw additional
> +	 * graphical elements (shapes) for all kshark_entries having Event Ids
> +	 * equal to "id".
> +	 */
> +	kshark_plugin_draw_handler_func		draw_func;
> +};
> +
> +struct kshark_event_handler *
> +find_event_handler(struct kshark_event_handler *handlers,
> +						int event_id);
> +
> +int kshark_register_event_handler(struct kshark_event_handler **handlers,
> +				  int event_id,
> +				  kshark_plugin_event_handler_func evt_func,
> +				  kshark_plugin_draw_handler_func dw_func);
> +
> +void kshark_unregister_event_handler(struct kshark_event_handler **handlers,
> +				     int event_id,
> +				     kshark_plugin_event_handler_func evt_func,
> +				     kshark_plugin_draw_handler_func dw_func);
> +
> +void kshark_free_event_handler_list(struct kshark_event_handler *handlers);
> +
> +/** Linked list of plugins. */
> +struct kshark_plugin_list {
> +	/** Pointer to the next Plugin. */
> +	struct kshark_plugin_list	*next;
> +
> +	/** The plugin object file to load. */
> +	char			*file;
> +
> +	/** Plugin Event handler. */
> +	void			*handle;
> +};
> +
> +int kshark_register_plugin(struct kshark_context *kshark_ctx,
> +			   const char *file);
> +
> +void kshark_unregister_plugin(struct kshark_context *kshark_ctx,
> +			      const char *file);
> +
> +void kshark_free_plugin_list(struct kshark_plugin_list *plugins);
> +
> +int kshark_handle_plugins(struct kshark_context *kshark_ctx, int task_id);
> +
> +#ifdef __cplusplus
> +}
> +#endif // __cplusplus
> +
> +#endif // _KSHARK_PLUGIN_H
> diff --git a/kernel-shark-qt/src/libkshark.h b/kernel-shark-qt/src/libkshark.h
> index 2580449a..fda133c8 100644
> --- a/kernel-shark-qt/src/libkshark.h
> +++ b/kernel-shark-qt/src/libkshark.h
> @@ -121,6 +121,9 @@ struct kshark_context {
>  
>  	/** List of Data collections. */
>  	struct kshark_entry_collection *collections;
> +
> +	/** List of Plugins. */
> +	struct kshark_plugin_list	*plugins;
>  };
>  
>  bool kshark_instance(struct kshark_context **kshark_ctx);

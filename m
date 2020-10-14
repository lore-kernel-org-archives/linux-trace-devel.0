Return-Path: <SRS0=7UrD=DV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ECE2C433E7
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Oct 2020 21:09:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACD07206B2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Oct 2020 21:09:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgJNVJe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:09:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:57802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726575AbgJNVJe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 14 Oct 2020 17:09:34 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F76F2068E;
        Wed, 14 Oct 2020 21:09:32 +0000 (UTC)
Date:   Wed, 14 Oct 2020 17:09:30 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 12/20] kernel-shark: Redesign the plugin interface
Message-ID: <20201014170930.57425b0a@gandalf.local.home>
In-Reply-To: <20201012133523.469040-13-y.karadz@gmail.com>
References: <20201012133523.469040-1-y.karadz@gmail.com>
        <20201012133523.469040-13-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 12 Oct 2020 16:35:15 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> This patch can be treated as an almost complete rewrite of the way
> the C API of KernelShark deals with plugins. First of all, the two
> pluggable user actions (one executed during data loading and another
> executed during plotting) have separate handlers. This way the user
> can register only one of the two callback functions, if this is what
> is needed.
> 
> The second substantial change is that instead of having a single
> interface for loading the plugin, we now have 3 different interfaces.
> The one that exists in version 1 of KernelShark is now renamed to
> Data Processing Interface (dpi).

Gotta love TLAs and their collisions. Note, DPI also means "Dots per inch"
which is used for visualization. https://en.wikipedia.org/wiki/Dots_per_inch

Not saying that we need to change it. But just need to be aware when
mentioning "dpi" to clarify what you mean, to not confuse an audience.

> 
> The first new interface for loading can be used to register user
> provided implementation of the Data stream readout and is called Data
> Readout Interface (dri). Via this  plugin loading interface the user

DRI can also mean "Dietary Reference Intakes", but I guess we can safely
assume that nobody will confuse our DRI with that one ;-)

> can open trace data having an arbitrary format. In order to make this
> possible the user has to provide a plugin that contains an implementation
> of the data readout methods defined by the kshark_data_stream_interface
> and to register all those methods.
> 
> The second new plugin loading interface is called Control interface
> and can be used to provide the plugin with an access to the GUI's Main
> window object. Via this interface the plugin can became capable to
> modify the GUI. Such a modification for example can be to add new
> dialog to the menus or to change the state of the GUI (to select entry
> 1with the marker, to zoom, ...).
> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  src/libkshark-plugin.c | 597 ++++++++++++++++++++++++++++++++++-------
>  src/libkshark-plugin.h | 279 ++++++++++++++-----
>  src/libkshark.c        |  56 +++-
>  src/libkshark.h        |  25 +-
>  4 files changed, 791 insertions(+), 166 deletions(-)
> 
> diff --git a/src/libkshark-plugin.c b/src/libkshark-plugin.c
> index 4b21392a..8e5299cf 100644
> --- a/src/libkshark-plugin.c
> +++ b/src/libkshark-plugin.c
> @@ -1,7 +1,7 @@
>  // SPDX-License-Identifier: LGPL-2.1
>  
>  /*
> - * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
> + * Copyright (C) 2017 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
>   */
>  
>   /**
> @@ -13,8 +13,7 @@
>  #ifndef _GNU_SOURCE
>  /** Use GNU C Library. */
>  #define _GNU_SOURCE
> -
> -#endif
> +#endif // _GNU_SOURCE
>  
>  #include <stdio.h>
>  #include <stdlib.h>
> @@ -27,23 +26,36 @@
>  #include "libkshark-plugin.h"
>  #include "libkshark.h"
>  
> -static struct kshark_event_handler *
> -gui_event_handler_alloc(int event_id,
> -			kshark_plugin_event_handler_func evt_func,
> -			kshark_plugin_draw_handler_func dw_func)
> +static struct kshark_event_proc_handler *
> +data_event_handler_alloc(int event_id,
> +			 kshark_plugin_event_handler_func evt_func)
>  {
> -	struct kshark_event_handler *handler = malloc(sizeof(*handler));
> +	struct kshark_event_proc_handler *handler = malloc(sizeof(*handler));
>  
>  	if (!handler) {
> -		fprintf(stderr,
> -			"failed to allocate memory for gui eventhandler");
> +		fputs("failed to allocate memory for event handler\n", stderr);
>  		return NULL;
>  	}
>  
>  	handler->next = NULL;
>  	handler->id = event_id;
>  	handler->event_func = evt_func;
> -	handler->draw_func = dw_func;
> +
> +	return handler;
> +}
> +
> +static struct kshark_draw_handler *
> +data_draw_handler_alloc(kshark_plugin_draw_handler_func draw_func)
> +{
> +	struct kshark_draw_handler *handler = malloc(sizeof(*handler));
> +
> +	if (!handler) {
> +		fputs("failed to allocate memory for draw handler\n", stderr);
> +		return NULL;
> +	}
> +
> +	handler->next = NULL;
> +	handler->draw_func = draw_func;
>  
>  	return handler;
>  }
> @@ -55,8 +67,8 @@ gui_event_handler_alloc(int event_id,
>   * @param handlers: Input location for the Event handler list.
>   * @param event_id: Event Id to search for.
>   */
> -struct kshark_event_handler *
> -kshark_find_event_handler(struct kshark_event_handler *handlers, int event_id)
> +struct kshark_event_proc_handler *
> +kshark_find_event_handler(struct kshark_event_proc_handler *handlers, int event_id)
>  {
>  	for (; handlers; handlers = handlers->next)
>  		if (handlers->id == event_id)
> @@ -68,26 +80,25 @@ kshark_find_event_handler(struct kshark_event_handler *handlers, int event_id)
>  /**
>   * @brief Add new event handler to an existing list of handlers.
>   *
> - * @param handlers: Input location for the Event handler list.
> + * @param stream: Input location for a Trace data stream pointer.
>   * @param event_id: Event Id.
>   * @param evt_func: Input location for an Event action provided by the plugin.
> - * @param dw_func: Input location for a Draw action provided by the plugin.
>   *
>   * @returns Zero on success, or a negative error code on failure.
>   */
> -int kshark_register_event_handler(struct kshark_event_handler **handlers,
> +int kshark_register_event_handler(struct kshark_data_stream *stream,
>  				  int event_id,
> -				  kshark_plugin_event_handler_func evt_func,
> -				  kshark_plugin_draw_handler_func dw_func)
> +				  kshark_plugin_event_handler_func evt_func)
>  {
> -	struct kshark_event_handler *handler =
> -		gui_event_handler_alloc(event_id, evt_func, dw_func);
> +	struct kshark_event_proc_handler *handler =
> +		data_event_handler_alloc(event_id, evt_func);
>  
>  	if(!handler)
>  		return -ENOMEM;
>  
> -	handler->next = *handlers;
> -	*handlers = handler;
> +	handler->next = stream->event_handlers;
> +	stream->event_handlers = handler;
> +
>  	return 0;
>  }
>  
> @@ -95,23 +106,20 @@ int kshark_register_event_handler(struct kshark_event_handler **handlers,
>   * @brief Search the list for a specific plugin handle. If such a plugin handle
>   *	  exists, unregister (remove and free) this handle from the list.
>   *
> - * @param handlers: Input location for the Event handler list.
> + * @param stream: Input location for a Trace data stream pointer.
>   * @param event_id: Event Id of the plugin handler to be unregistered.
> - * @param evt_func: Event action function of the handler to be unregistered.
> - * @param dw_func: Draw action function of the handler to be unregistered.
> + * @param evt_func: Event action function to be unregistered.
>   */
> -void kshark_unregister_event_handler(struct kshark_event_handler **handlers,
> +void kshark_unregister_event_handler(struct kshark_data_stream *stream,
>  				     int event_id,
> -				     kshark_plugin_event_handler_func evt_func,
> -				     kshark_plugin_draw_handler_func dw_func)
> +				     kshark_plugin_event_handler_func evt_func)

May be useful to have a return code just to see if one was found that
needed to be unregistered. Not a hard requirement, but perhaps something
that may be nice to have.

>  {
> -	struct kshark_event_handler **last;
> +	struct kshark_event_proc_handler **last;
>  
> -	for (last = handlers; *last; last = &(*last)->next) {
> +	for (last = &stream->event_handlers; *last; last = &(*last)->next) {
>  		if ((*last)->id == event_id &&
> -		    (*last)->event_func == evt_func &&
> -		    (*last)->draw_func == dw_func) {
> -			struct kshark_event_handler *this_handler;
> +		    (*last)->event_func == evt_func) {
> +			struct kshark_event_proc_handler *this_handler;
>  			this_handler = *last;
>  			*last = this_handler->next;
>  			free(this_handler);
> @@ -126,9 +134,71 @@ void kshark_unregister_event_handler(struct kshark_event_handler **handlers,
>   *
>   * @param handlers: Input location for the Event handler list.
>   */
> -void kshark_free_event_handler_list(struct kshark_event_handler *handlers)
> +void kshark_free_event_handler_list(struct kshark_event_proc_handler *handlers)
> +{
> +	struct kshark_event_proc_handler *last;
> +
> +	while (handlers) {
> +		last = handlers;
> +		handlers = handlers->next;
> +		free(last);
> +	}
> +}

I'm looking at the KsUtils.cpp that calls this, and I think it would be
safer to pass in the kshark_ctx instead. Make the above function static,
and then make two helper functions (for later).

void kshark_ctx_free_event_handlers(struct kshark_ctx *ctx)
{
	free_event_handler_list(ctx->event_handlers);
	ctx->event_handlers = NULL;
}

and

kshark_stream_free_event_handlers(struct kshark_data_stream *stream)
{
	free_event_handler_list(stream->event_handlers);
	stream->event_handers = NULL;
}

That way, we do not need to worry that the event_handlers will be left
pointing to freed data if the code changes in the future.

> +
> +/**
> + * @brief Add new event handler to an existing list of handlers.
> + *
> + * @param stream: Input location for a Trace data stream pointer.
> + * @param draw_func: Input location for a Draw action provided by the plugin.
> + *
> + * @returns Zero on success, or a negative error code on failure.
> + */
> +int kshark_register_draw_handler(struct kshark_data_stream *stream,
> +				 kshark_plugin_draw_handler_func draw_func)
> +{
> +	struct kshark_draw_handler *handler = data_draw_handler_alloc(draw_func);
> +
> +	if(!handler)
> +		return -ENOMEM;
> +
> +	handler->next = stream->draw_handlers;
> +	stream->draw_handlers = handler;
> +
> +	return 0;
> +}
> +
> +/**
> + * @brief Search the list for a specific plugin handle. If such a plugin handle
> + *	  exists, unregister (remove and free) this handle from the list.
> + *
> + * @param stream: Input location for a Trace data stream pointer.
> + * @param draw_func: Draw action function to be unregistered.
> + */
> +void kshark_unregister_draw_handler(struct kshark_data_stream *stream,
> +				    kshark_plugin_draw_handler_func draw_func)
> +{
> +	struct kshark_draw_handler **last;
> +
> +	for (last = &stream->draw_handlers; *last; last = &(*last)->next) {
> +		if ((*last)->draw_func == draw_func) {
> +			struct kshark_draw_handler *this_handler;
> +			this_handler = *last;
> +			*last = this_handler->next;
> +			free(this_handler);
> +
> +			return;
> +		}
> +	}
> +}
> +
> +/**
> + * @brief Free all DRaw handlers in a given list.
> + *
> + * @param handlers: Input location for the Draw handler list.
> + */
> +void kshark_free_draw_handler_list(struct kshark_draw_handler *handlers)
>  {
> -	struct kshark_event_handler *last;
> +	struct kshark_draw_handler *last;
>  
>  	while (handlers) {
>  		last = handlers;
> @@ -139,96 +209,182 @@ void kshark_free_event_handler_list(struct kshark_event_handler *handlers)
>  
>  /**
>   * @brief Allocate memory for a new plugin. Add this plugin to the list of
> - *	  plugins used by the session.
> + *	  plugins.
>   *
>   * @param kshark_ctx: Input location for the session context pointer.
> + * @param name: The name of the plugin to register.
>   * @param file: The plugin object file to load.
>   *
> - * @returns Zero on success, or a negative error code on failure.
> + * @returns The plugin object on success, or NULL on failure.
>   */
> -int kshark_register_plugin(struct kshark_context *kshark_ctx,
> -			   const char *file)
> +struct kshark_plugin_list *
> +kshark_register_plugin(struct kshark_context *kshark_ctx,
> +		       const char *name,
> +		       const char *file)
>  {
> -	struct kshark_plugin_list *plugin = kshark_ctx->plugins;
> +	kshark_plugin_load_func init_func, close_func;
> +	kshark_check_data_func check_func;
> +	struct kshark_plugin_list *plugin;
>  	struct stat st;
>  	int ret;
>  
> -	while (plugin) {
> -		if (strcmp(plugin->file, file) == 0)
> -			return -EEXIST;
> +	printf("loading plugin \"%s\" from %s\n", name, file);
>  
> -		plugin = plugin->next;
> +	plugin = kshark_find_plugin(kshark_ctx->plugins, file);
> +	if(plugin) {
> +		fputs("the plugin is already loaded.\n", stderr);
> +		return NULL;
>  	}
>  
>  	ret = stat(file, &st);
>  	if (ret < 0) {
> -		fprintf(stderr, "plugin %s not found\n", file);
> -		return -ENODEV;
> +		fprintf(stderr, "plugin %s not found.\n", file);
> +		return NULL;
>  	}
>  
> -	plugin = calloc(sizeof(struct kshark_plugin_list), 1);
> +	plugin = calloc(1, sizeof(struct kshark_plugin_list));
>  	if (!plugin) {
> -		fprintf(stderr, "failed to allocate memory for plugin\n");
> -		return -ENOMEM;
> +		fputs("failed to allocate memory for plugin.\n", stderr);
> +		return NULL;
>  	}
>  
> -	if (asprintf(&plugin->file, "%s", file) <= 0) {
> +	plugin->handle = dlopen(file, RTLD_NOW | RTLD_GLOBAL);
> +	if (!plugin->handle) {
>  		fprintf(stderr,
> -			"failed to allocate memory for plugin file name");
> -		return -ENOMEM;
> +			"failed to open plugin file.\n%s\n",
> +			dlerror());
> +		goto fail;
>  	}
>  
> -	plugin->handle = dlopen(plugin->file, RTLD_NOW | RTLD_GLOBAL);
> -	if (!plugin->handle)
> +	plugin->file = strdup(file);
> +	plugin->name = strdup(name);
> +	if (!plugin->file|| !plugin->name)
>  		goto fail;
>  
> -	plugin->init = dlsym(plugin->handle,
> -			     KSHARK_PLUGIN_INITIALIZER_NAME);
> +	plugin->ctrl_interface =
> +		dlsym(plugin->handle, KSHARK_MENU_PLUGIN_INITIALIZER_NAME);
> +
> +	init_func = dlsym(plugin->handle,
> +			  KSHARK_PLOT_PLUGIN_INITIALIZER_NAME);
>  
> -	plugin->close = dlsym(plugin->handle,
> -			      KSHARK_PLUGIN_DEINITIALIZER_NAME);
> +	close_func = dlsym(plugin->handle,
> +			   KSHARK_PLOT_PLUGIN_DEINITIALIZER_NAME);
>  
> -	if (!plugin->init || !plugin->close)
> +	if (!!(long)init_func && !!(long)close_func) {

You shouldn't need the !! here. It should just work with:

	if (init_func && close_func)



> +		plugin->process_interface =
> +			calloc(1, sizeof(*plugin->process_interface));
> +
> +		if (!plugin->process_interface)
> +			goto fail;
> +
> +		plugin->process_interface->name = strdup(plugin->name);

You should check the return value of name.

> +		plugin->process_interface->init = init_func;
> +		plugin->process_interface->close = close_func;
> +	} else if (!!(long)init_func || !!(long)close_func) {
> +		fprintf(stderr,
> +			"incomplete draw interface found (will be ignored).\n%s\n",
> +			dlerror());
> +	}
> +
> +	init_func = dlsym(plugin->handle,
> +			  KSHARK_INPUT_INITIALIZER_NAME);
> +
> +	close_func = dlsym(plugin->handle,
> +			   KSHARK_INPUT_DEINITIALIZER_NAME);
> +
> +	check_func = dlsym(plugin->handle,
> +			   KSHARK_INPUT_CHECK_NAME);
> +
> +	if (!!(long)init_func &&
> +	    !!(long)close_func &&
> +	    !!(long)check_func) {
> +		plugin->readout_interface =
> +			calloc(1, sizeof(*plugin->readout_interface));
> +
> +		if (!plugin->readout_interface)
> +			goto fail;
> +
> +		plugin->readout_interface->name = strdup(plugin->name);
> +		plugin->readout_interface->init = init_func;
> +		plugin->readout_interface->close = close_func;
> +		plugin->readout_interface->check_data = check_func;
> +
> +		kshark_register_input(kshark_ctx, plugin->readout_interface);
> +	} else if (!!(long)init_func ||
> +		   !!(long)close_func ||
> +		   !!(long)check_func) {
> +		fprintf(stderr,
> +			"incomplete input interface found (will be ignored).\n%s\n",
> +			dlerror());
> +	}
> +
> +	if (!plugin->process_interface &&
> +	    !plugin->readout_interface &&
> +	    !plugin->ctrl_interface) {
> +		fputs("no interfaces found in this plugin.\n", stderr);
>  		goto fail;
> +	}
>  
>  	plugin->next = kshark_ctx->plugins;
>  	kshark_ctx->plugins = plugin;
> +	kshark_ctx->n_plugins++;
>  
> -	return 0;
> +	return plugin;
>  
>   fail:
> -	fprintf(stderr, "cannot load plugin '%s'\n%s\n",
> -		plugin->file, dlerror());
> +	fprintf(stderr, "cannot load plugin '%s'\n", file);
>  
> -	if (plugin->handle) {
> +	if (plugin->handle)
>  		dlclose(plugin->handle);
> -		plugin->handle = NULL;
> -	}
>  
>  	free(plugin);
>  
> -	return EFAULT;
> +	return NULL;
> +}
> +
> +/** Close and free this plugin. */
> +static void free_plugin(struct kshark_plugin_list *plugin)
> +{
> +	dlclose(plugin->handle);
> +
> +	if (plugin->process_interface){
> +		free(plugin->process_interface->name);
> +		free(plugin->process_interface);
> +	}
> +
> +	if (plugin->readout_interface) {
> +		free(plugin->readout_interface->name);
> +		free(plugin->readout_interface);
> +	}
> +
> +	free(plugin->name);
> +	free(plugin->file);
> +	free(plugin);
>  }
>  
>  /**
>   * @brief Unrgister a plugin.
>   *
> - * @param kshark_ctx: Input location for context pointer.
> + * @param kshark_ctx: Input location for the session context pointer.
> + * @param name: The name of the plugin to unregister.
>   * @param file: The plugin object file to unregister.
>   */
>  void kshark_unregister_plugin(struct kshark_context *kshark_ctx,
> +			      const char *name,
>  			      const char *file)
>  {
>  	struct kshark_plugin_list **last;
>  
>  	for (last = &kshark_ctx->plugins; *last; last = &(*last)->next) {
> -		if (strcmp((*last)->file, file) == 0) {
> +		if (strcmp((*last)->process_interface->name, name) == 0 &&
> +		    strcmp((*last)->file, file) == 0) {
>  			struct kshark_plugin_list *this_plugin;
> +
>  			this_plugin = *last;
>  			*last = this_plugin->next;
> +			free_plugin(this_plugin);
>  
> -			dlclose(this_plugin->handle);
> -			free(this_plugin);
> +			kshark_ctx->n_plugins--;
>  
>  			return;
>  		}
> @@ -248,48 +404,303 @@ void kshark_free_plugin_list(struct kshark_plugin_list *plugins)
>  		last = plugins;
>  		plugins = plugins->next;
>  
> -		free(last->file);
> -		dlclose(last->handle);
> +		free_plugin(last);
> +	}
> +}
> +
> +/**
> + * @brief Register a data readout interface (input).
> + *
> + * @param kshark_ctx: Input location for the context pointer.
> + * @param plugin: Input location for the data readout interface (input).
> + */
> +struct kshark_dri_list *
> +kshark_register_input(struct kshark_context *kshark_ctx,
> +		      struct kshark_dri *plugin)
> +{
> +	struct kshark_dri_list *input;
> +
> +	input = calloc(1, sizeof(*input));
> +	if (!input) {
> +		fputs("failed to allocate memory for readout plugin.\n", stderr);
> +		return NULL;
> +	}
>  
> +	input->interface = plugin;
> +	input->next = kshark_ctx->inputs;
> +	kshark_ctx->inputs = input;
> +
> +	return input;
> +}
> +
> +/**
> + * @brief Unrgister a data readout interface (input).
> + *
> + * @param kshark_ctx: Input location for the context pointer.
> + * @param name: The data readout's name.
> + */
> +void kshark_unregister_input(struct kshark_context *kshark_ctx,
> +			     const char *name)
> +{
> +	struct kshark_dri_list **last;
> +
> +	for (last = &kshark_ctx->inputs; *last; last = &(*last)->next) {
> +		if (strcmp((*last)->interface->name, name) == 0) {
> +			struct kshark_dri_list *this_input;
> +			this_input = *last;
> +			*last = this_input->next;
> +
> +			free(this_input);
> +
> +			return;
> +		}
> +	}
> +}
> +
> +/**
> + * @brief Free a list of plugin interfaces.
> + *
> + * @param plugins: Input location for the plugins list.
> + */
> +void
> +kshark_free_dpi_list(struct kshark_dpi_list *plugins)
> +{
> +	struct kshark_dpi_list *last;
> +
> +	while (plugins) {
> +		last = plugins;
> +		plugins = plugins->next;
>  		free(last);
>  	}
>  }
>  
>  /**
> - * @brief Use this function to initialize/update/deinitialize all registered
> - *	  plugins.
> + * @brief Find a plugin by its library file.
> + *
> + * @param plugins: A list of plugins to search in.
> + * @param lib: The plugin object file to load.
>   *
> - * @param kshark_ctx: Input location for context pointer.
> + * @returns The plugin object on success, or NULL on failure.
> + */
> +struct kshark_plugin_list *
> +kshark_find_plugin(struct kshark_plugin_list *plugins, const char *lib)
> +{
> +	for (; plugins; plugins = plugins->next)
> +		if (strcmp(plugins->file, lib) == 0)
> +			return plugins;
> +
> +	return NULL;
> +}
> +
> +/**
> + * @brief Find a plugin by its name.
> + *
> + * @param plugins: A list of plugins to search in.
> + * @param name: The plugin object file to load.
> + *
> + * @returns The plugin object on success, or NULL on failure.
> + */
> +struct kshark_plugin_list *
> +kshark_find_plugin_by_name(struct kshark_plugin_list *plugins,
> +			   const char *name)
> +{
> +	for (; plugins; plugins = plugins->next)
> +		if (strcmp(plugins->name, name) == 0)
> +			return plugins;
> +
> +	return NULL;
> +}
> +
> +/**
> + * @brief Register plugin to a given data stream.
> + *
> + * @param stream: Input location for a Trace data stream pointer.
> + * @param plugin: Input location for the data processing interface.
> + * @param active: If false, the plugin will be registered but disables.
> + *		  Otherwise the plugin will be active.
> + *
> + * @returns The plugin object on success, or NULL on failure.
> + */
> +struct kshark_dpi_list *
> +kshark_register_plugin_to_stream(struct kshark_data_stream *stream,
> +				 struct kshark_dpi *plugin,
> +				 bool active)
> +{
> +	struct kshark_dpi_list *plugin_list = stream->plugins;
> +
> +	/* Check if the plugin is already registered to this stream. */
> +	while (plugin_list) {
> +		if (strcmp(plugin_list->interface->name, plugin->name) == 0 &&
> +		    plugin_list->interface->init == plugin->init &&
> +		    plugin_list->interface->close == plugin->close) {
> +			kshark_handle_dpi(stream, plugin_list,
> +					  KSHARK_PLUGIN_CLOSE);

Why are we closing the plugin here?

> +
> +			plugin_list->status =
> +				(active)? KSHARK_PLUGIN_ENABLED : 0;

No need for the parenthesis around "active".

		active ? KSHARK_PLUGIN_ENABLED : 0;


-- Steve

> +
> +			return plugin_list;
> +		}
> +
> +		plugin_list = plugin_list->next;
> +	}
> +
> +	plugin_list = calloc(1, sizeof(*plugin_list));
> +	plugin_list->interface = plugin;
> +
> +	if (active)
> +		plugin_list->status = KSHARK_PLUGIN_ENABLED;
> +
> +	plugin_list->next = stream->plugins;
> +	stream->plugins = plugin_list;
> +	stream->n_plugins++;
> +
> +	return plugin_list;
> +}
> +
> +/**

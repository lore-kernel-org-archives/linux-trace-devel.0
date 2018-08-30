Return-Path: <SRS0=WdLK=LN=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:59464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727129AbeH3Vlt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 30 Aug 2018 17:41:49 -0400
Date: Thu, 30 Aug 2018 13:38:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 7/7] kernel-shark-qt: Add a plugin for sched events.
Message-ID: <20180830133832.657a8eab@gandalf.local.home>
In-Reply-To: <20180829164224.20677-8-y.karadz@gmail.com>
References: <20180829164224.20677-1-y.karadz@gmail.com>
        <20180829164224.20677-8-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 29 Aug 2018 19:42:24 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> --- /dev/null
> +++ b/kernel-shark-qt/src/plugins/SchedEvents.cpp
> @@ -0,0 +1,258 @@
> +// SPDX-License-Identifier: LGPL-2.1
> +
> +/*
> + * Copyright (C) 2018 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
> + */
> +
> +/**
> + *  @file    SchedEvents.cpp
> + *  @brief   Plugin for Sched events.
> + */
> +
> +// KernelShark
> +#include "libkshark.h"
> +#include "plugins/sched_events.h"
> +#include "KsPlotTools.hpp"
> +#include "KsPlugins.hpp"
> +
> +extern struct plugin_sched_context *plugin_sched_context_handler;
> +
> +static int plugin_get_wakeup_pid_lazy(struct kshark_context *kshark_ctx,
> +				      const struct kshark_entry *e)
> +{
> +	struct plugin_sched_context *plugin_ctx;
> +	struct tep_record *record;
> +	unsigned long long val;
> +
> +	plugin_ctx = plugin_sched_context_handler;
> +	record = kshark_read_at(kshark_ctx, e->offset);
> +
> +	tep_read_number_field(plugin_ctx->sched_wakeup_pid_field,
> +				 record->data, &val);
> +	free(record);
> +
> +	return val;
> +}
> +
> +static void openBox(KsPlot::Rectangle **rec,
> +		    const KsPlot::Bin &bin,
> +		    int height)
> +{
> +	if (!*rec)
> +		*rec = new KsPlot::Rectangle;

BTW, for exception handling here (if new fails), should there be some
sort of comments somewhere, about what types of exceptions should be
caught. This is more a general question and not specific to this code
here.

With C, one needs to always check for the return. Now, with C++ we can
do try { } catch, but then we need to be able to clean everything up.

I honestly think that try/catch can end up being sloppier than the C
way, but C is a bit more work to get right.

> +
> +	(**rec).setFill(false);
> +	(**rec).setPoint(0, bin._base.x() - 1,
> +			    bin._base.y() - height);
> +
> +	(**rec).setPoint(1, bin._base.x() - 1,
> +			    bin._base.y() - 1);
> +}
> +
> +static void closeBox(KsPlot::Rectangle **rec,
> +		     const KsPlot::Bin &bin,
> +		     int height,
> +		     KsPlot::PlotObjList *list)
> +{
> +	if (*rec == nullptr)
> +		return;
> +
> +	if (bin._base.x() - (**rec).getPoint(0)->x < 4) {

Let's keep from using hard coded numbers. Why 4? We should make this at
least a macro that can be changed. Or perhaps a variable in some class?


> +		/* This box is too small.
> +		 * Don't try to plot it. */
> +		delete *rec;
> +		*rec = nullptr;
> +		return;
> +	}
> +
> +	(**rec).setPoint(3, bin._base.x() - 1,
> +			    bin._base.y() - height);
> +
> +	(**rec).setPoint(2, bin._base.x() - 1,
> +			    bin._base.y() - 1);
> +
> +	list->push_front(*rec);
> +	*rec = nullptr;
> +}
> +
> +static void schedWakeupPluginDraw(struct plugin_sched_context *plugin_ctx,
> +				  kshark_trace_histo *histo,
> +				  KsPlot::Graph *graph,
> +				  int pid,
> +				  KsPlot::PlotObjList *shapes)
> +{
> +	const kshark_entry *entryF, *entryB;
> +	KsPlot::Rectangle *rec = nullptr;
> +	kshark_context *kshark_ctx(NULL);
> +	kshark_entry_collection *col;
> +	kshark_instance(&kshark_ctx);
> +	int wakeup_pid;
> +
> +	col = kshark_find_data_collection(kshark_ctx->collections,
> +					  kshark_match_pid, pid);

If col is NULL, should we just return right away? Or is col OK to be
NULL?

> +
> +	size_t nBins = graph->size();
> +	for (size_t bin = 0; bin < nBins; ++bin) {
> +		if (ksmodel_bin_count(histo, bin) > 500)

Why 500?

> +			continue;
> +
> +		/*
> +		 * Starting from the first element in this bin, go forward
> +		 * in time until you find a trace entry that satisfies the
> +		 * condition defined by plugin_check_pid.
> +		 */
> +		entryF = ksmodel_get_entry_front(histo, bin, false,
> +						 kshark_match_pid, pid,
> +						 col, nullptr);
> +
> +		/*
> +		 * Starting from the last element in this bin, go backward
> +		 * in time until you find a trace entry that satisfies the
> +		 * condition defined by plugin_wakeup_check_pid.
> +		 */
> +		entryB = ksmodel_get_entry_back(histo, bin, false,
> +						plugin_wakeup_match_pid, pid,
> +						col, nullptr);
> +
> +		if (entryB &&
> +		    plugin_ctx->sched_wakeup_event &&
> +		    entryB->event_id == plugin_ctx->sched_wakeup_event->id) {
> +			wakeup_pid =
> +				plugin_get_wakeup_pid_lazy(kshark_ctx, entryB);
> +			if (wakeup_pid == pid) {
> +				/*
> +				 * entryB is a sched_wakeup_event. Open a
> +				 * green box here.
> +				 */
> +				openBox(&rec, graph->getBin(bin),
> +					      graph->getHeight() * .3);
> +
> +				 /* Green */
> +				rec->_color = KsPlot::Color(0, 255, 0);
> +			}
> +		}
> +
> +		if (entryF &&
> +		    plugin_ctx->sched_switch_event &&
> +		    entryF->event_id == plugin_ctx->sched_switch_event->id &&
> +		    entryF->pid == pid) {
> +			/*
> +			 * entryF is sched_switch_event. Close the box and add
> +			 * it to the list of shapes to be ploted.
> +			 */
> +			closeBox(&rec, graph->getBin(bin),
> +				       graph->getHeight() * .3,
> +				       shapes);
> +		}
> +	}
> +
> +	if (rec)
> +		delete rec;
> +
> +	return;
> +}
> +
> +static void schedSwitchPluginDraw(struct plugin_sched_context *plugin_ctx,
> +				  kshark_trace_histo *histo,
> +				  KsPlot::Graph *graph,
> +				  int pid,
> +				  KsPlot::PlotObjList *shapes)

This is quite similar to the function above, is there a way to combine
the two? This is C++ ;-)

-- Steve

> +{
> +	const kshark_entry *entryF, *entryB;
> +	KsPlot::Rectangle *rec = nullptr;
> +	kshark_context *kshark_ctx(NULL);
> +	kshark_entry_collection *col;
> +
> +	kshark_instance(&kshark_ctx);
> +	col = kshark_find_data_collection(kshark_ctx->collections,
> +					  kshark_match_pid, pid);
> +
> +	size_t nBins = graph->size();
> +	for (size_t bin = 0; bin < nBins; ++bin) {
> +		
> +		if (ksmodel_bin_count(histo, bin) > 500)
> +			continue;
> +
> +		/*
> +		 * Starting from the first element in this bin, go forward
> +		 * in time until you find a trace entry that satisfies the
> +		 * condition defined by kshark_match_pid.
> +		 */
> +		entryF = ksmodel_get_entry_front(histo, bin, false,
> +						 kshark_match_pid, pid,
> +						 col, nullptr);
> +
> +		/*
> +		 * Starting from the last element in this bin, go backward
> +		 * in time until you find a trace entry that satisfies the
> +		 * condition defined by plugin_switch_check_pid.
> +		 */
> +		entryB = ksmodel_get_entry_back(histo, bin, false,
> +						plugin_switch_match_pid, pid,
> +						col, nullptr);
> +
> +		if (entryB && entryB->pid != pid &&
> +		    entryB->event_id == plugin_ctx->sched_switch_event->id) {
> +			/*
> +			 * entryB is a sched_switch_event.
> +			 * Open a red box here.
> +			 */
> +			openBox(&rec, graph->getBin(bin),
> +				      graph->getHeight() * .3);
> +
> +			/* Red */
> +			rec->_color = KsPlot::Color(255, 0, 0);
> +		}
> +
> +		if (entryF && entryF->pid == pid &&
> +		    entryF->event_id == plugin_ctx->sched_switch_event->id) {
> +			/*
> +			 * entryF is sched_switch_event.
> +			 * Close the box and add it to the list
> +			 * of shapes to be ploted.
> +			 */
> +			closeBox(&rec, graph->getBin(bin),
> +				       graph->getHeight() * .3,
> +				       shapes);
> +		}
> +	}
> +
> +	if (rec)
> +		delete rec;
> +
> +	return;
> +}
> +
> +/**
> + * @brief Plugin's draw function.
> + *
> + * @param argv_c: A C pointer to be converted to KsCppArgV (C++ struct).
> + * @param pid: Process Id.
> + * @param draw_action: Draw action identifier.
> + *
> + * @returns True if the Pid of the entry matches the value of "pid".
> + *	    Otherwise false.
> + */
> +void plugin_draw(struct kshark_cpp_argv *argv_c, int pid, int draw_action)
> +{
> +	if (draw_action != KSHARK_PLUGIN_TASK_DRAW || pid == 0)
> +		return;
> +
> +	struct plugin_sched_context *plugin_ctx =
> +		plugin_sched_context_handler;
> +
> +	if (!plugin_ctx)
> +		return;
> +
> +	KsCppArgV *argvCpp = KS_ARGV_TO_CPP(argv_c);
> +
> +	schedWakeupPluginDraw(plugin_ctx, argvCpp->_histo,
> +					  argvCpp->_graph,
> +					  pid,
> +					  argvCpp->_shapes);
> +
> +	schedSwitchPluginDraw(plugin_ctx, argvCpp->_histo,
> +					  argvCpp->_graph,
> +					  pid,
> +					  argvCpp->_shapes);
> +}
> diff --git a/kernel-shark-qt/src/plugins/sched_events.c b/kernel-shark-qt/src/plugins/sched_events.c
> new file mode 100644
> index 0000000..2885a22
> --- /dev/null
> +++ b/kernel-shark-qt/src/plugins/sched_events.c
> @@ -0,0 +1,302 @@
> +// SPDX-License-Identifier: LGPL-2.1
> +
> +/*
> + * Copyright (C) 2018 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
> + */
> +
> +/**
> + *  @file    sched_events.c
> + *  @brief   Plugin for Sched events.
> + */
> +
> +// C
> +#include <stdlib.h>
> +#include <stdio.h>
> +
> +// KernelShark
> +#include "plugins/sched_events.h"
> +
> +/** Plugin context instance. */
> +struct plugin_sched_context *plugin_sched_context_handler = NULL;
> +
> +static bool plugin_sched_update_context(struct kshark_context *kshark_ctx)
> +{
> +	struct plugin_sched_context *plugin_ctx;
> +	struct event_format *event;
> +
> +	if (!plugin_sched_context_handler) {
> +		plugin_sched_context_handler =
> +		 malloc(sizeof(*plugin_sched_context_handler));
> +	}
> +
> +	plugin_ctx = plugin_sched_context_handler;
> +	plugin_ctx->handle = kshark_ctx->handle;
> +	plugin_ctx->pevent = kshark_ctx->pevent;
> +
> +	event = tep_find_event_by_name(plugin_ctx->pevent,
> +					  "sched", "sched_switch");
> +	if (!event)
> +		return false;
> +
> +	plugin_ctx->sched_switch_event = event;
> +	plugin_ctx->sched_switch_next_field =
> +		tep_find_any_field(event, "next_pid");
> +
> +	plugin_ctx->sched_switch_comm_field =
> +		tep_find_field(event, "next_comm");
> +
> +	event = tep_find_event_by_name(plugin_ctx->pevent,
> +					  "sched", "sched_wakeup");
> +	if (!event)
> +		return false;
> +
> +	plugin_ctx->sched_wakeup_event = event;
> +	plugin_ctx->sched_wakeup_pid_field =
> +		tep_find_any_field(event, "pid");
> +
> +	plugin_ctx->sched_wakeup_success_field =
> +		tep_find_field(event, "success");
> +
> +	event = tep_find_event_by_name(plugin_ctx->pevent,
> +					  "sched", "sched_wakeup_new");
> +	if (!event)
> +		return false;
> +
> +	plugin_ctx->sched_wakeup_new_event = event;
> +	plugin_ctx->sched_wakeup_new_pid_field =
> +		tep_find_any_field(event, "pid");
> +
> +	plugin_ctx->sched_wakeup_new_success_field =
> +		tep_find_field(event, "success");
> +
> +	return true;
> +}
> +
> +/**
> + * @brief Get the Process Id of the next scheduled task.
> + *
> + * @param record: Input location for a sched_switch record.
> + */
> +int plugin_get_next_pid(struct tep_record *record)
> +{
> +	struct plugin_sched_context *plugin_ctx =
> +		plugin_sched_context_handler;
> +	unsigned long long val;
> +
> +	tep_read_number_field(plugin_ctx->sched_switch_next_field,
> +				 record->data, &val);
> +	return val;
> +}
> +
> +/**
> + * @brief Get the Process Id of the task being woke up.
> + *
> + * @param record: Input location for a sched_wakeup record.
> + */
> +int plugin_get_wakeup_pid(struct tep_record *record)
> +{
> +	struct plugin_sched_context *plugin_ctx =
> +		plugin_sched_context_handler;
> +	unsigned long long val;
> +
> +	tep_read_number_field(plugin_ctx->sched_wakeup_pid_field,
> +				 record->data, &val);
> +	return val;
> +}
> +
> +static void plugin_register_command(struct kshark_context *kshark_ctx,
> +				    struct tep_record *record,
> +				    int pid)
> +{
> +	struct plugin_sched_context *plugin_ctx =
> +		plugin_sched_context_handler;
> +	const char *comm;
> +
> +	if (plugin_ctx->sched_switch_comm_field) {
> +			comm = record->data +
> +			       plugin_ctx->sched_switch_comm_field->offset;
> +	}
> +
> +	if (!tep_pid_is_registered(kshark_ctx->pevent, pid))
> +			tep_register_comm(kshark_ctx->pevent,
> +					     comm, pid);
> +}
> +
> +static int plugin_get_wakeup_new_pid(struct tep_record *record)
> +{
> +	struct plugin_sched_context *plugin_ctx =
> +		plugin_sched_context_handler;
> +	unsigned long long val;
> +
> +	tep_read_number_field(plugin_ctx->sched_wakeup_new_pid_field,
> +				 record->data, &val);
> +
> +	return val;
> +}
> +
> +/**
> + * @brief Process Id matching function adapted for sched_wakeup and
> + *	  sched_wakeup_new events.
> + *
> + * @param kshark_ctx: Input location for the session context pointer.
> + * @param e: kshark_entry to be checked.
> + * @param pid: Matching condition value.
> + *
> + * @returns True if the Pid of the entry matches the value of "pid".
> + *	    Otherwise false.
> + */
> +bool plugin_wakeup_match_pid(struct kshark_context *kshark_ctx,
> +			     struct kshark_entry *e,
> +			     int pid)
> +{
> +	struct plugin_sched_context *plugin_ctx;
> +	struct tep_record *record = NULL;
> +	unsigned long long val;
> +	int wakeup_pid = -1;
> +
> +	if (e->pid == pid)
> +		return true;
> +
> +	plugin_ctx = plugin_sched_context_handler;
> +	if (!plugin_ctx)
> +		return false;
> +
> +	if (plugin_ctx->sched_wakeup_event &&
> +	    e->event_id == plugin_ctx->sched_wakeup_event->id) {
> +		record = kshark_read_at(kshark_ctx, e->offset);
> +
> +		/* We only want those that actually woke up the task. */
> +		tep_read_number_field(plugin_ctx->sched_wakeup_success_field,
> +					 record->data, &val);
> +
> +		if (val)
> +			wakeup_pid = plugin_get_wakeup_pid(record);
> +	}
> +
> +	if (plugin_ctx->sched_wakeup_new_event &&
> +	    e->event_id == plugin_ctx->sched_wakeup_new_event->id) {
> +		record = kshark_read_at(kshark_ctx, e->offset);
> +
> +		/* We only want those that actually woke up the task. */
> +		tep_read_number_field(plugin_ctx->sched_wakeup_new_success_field,
> +					 record->data, &val);
> +
> +		if (val)
> +			wakeup_pid = plugin_get_wakeup_new_pid(record);
> +	}
> +
> +	free(record);
> +
> +	if (wakeup_pid >= 0 && wakeup_pid == pid)
> +		return true;
> +
> +	return false;
> +}
> +
> +/**
> + * @brief Process Id matching function adapted for sched_switch events.
> + *
> + * @param kshark_ctx: Input location for the session context pointer.
> + * @param e: kshark_entry to be checked.
> + * @param pid: Matching condition value.
> + *
> + * @returns True if the Pid of the entry matches the value of "pid".
> + *	    Otherwise false.
> + */
> +bool plugin_switch_match_pid(struct kshark_context *kshark_ctx,
> +			     struct kshark_entry *e,
> +			     int pid)
> +{
> +	struct plugin_sched_context *plugin_ctx;
> +	struct tep_record *record = NULL;
> +	int switch_pid = -1;
> +
> +	if (e->pid == pid)
> +		return true;
> +
> +	plugin_ctx = plugin_sched_context_handler;
> +
> +	if (plugin_ctx->sched_switch_event &&
> +	    e->event_id == plugin_ctx->sched_switch_event->id) {
> +		record = kshark_read_at(kshark_ctx, e->offset);
> +
> +		switch_pid = tep_data_pid(plugin_ctx->pevent, record);
> +	}
> +
> +	free(record);
> +
> +	if (switch_pid >= 0 && switch_pid == pid)
> +		return true;
> +
> +	return false;
> +}
> +
> +static void plugin_sched_action(struct kshark_context *kshark_ctx,
> +				struct tep_record *rec,
> +				struct kshark_entry *entry)
> +{
> +	entry->pid = plugin_get_next_pid(rec);
> +	plugin_register_command(kshark_ctx, rec, entry->pid);
> +}
> +
> +static void plugin_sched_load()
> +{
> +	struct kshark_context *kshark_ctx = NULL;
> +	struct plugin_sched_context *plugin_ctx;
> +
> +	kshark_instance(&kshark_ctx);
> +
> +	if (!plugin_sched_update_context(kshark_ctx)) {
> +		free(plugin_sched_context_handler);
> +		plugin_sched_context_handler = NULL;
> +		return;
> +	}
> +
> +	plugin_ctx = plugin_sched_context_handler;
> +
> +	kshark_register_event_handler(&kshark_ctx->event_handlers,
> +				      plugin_ctx->sched_switch_event->id,
> +				      plugin_sched_action,
> +				      plugin_draw);
> +}
> +
> +static void plugin_sched_unload()
> +{
> +	struct kshark_context *kshark_ctx = NULL;
> +	struct plugin_sched_context *plugin_ctx;
> +
> +	if (!plugin_sched_context_handler)
> +		return;
> +
> +	plugin_ctx = plugin_sched_context_handler;
> +	kshark_instance(&kshark_ctx);
> +
> +	if (kshark_ctx) {
> +		kshark_unregister_event_handler(&kshark_ctx->event_handlers,
> +						plugin_ctx->sched_switch_event->id,
> +						plugin_sched_action,
> +						plugin_draw);
> +	}
> +
> +	free(plugin_ctx);
> +	plugin_sched_context_handler = NULL;
> +}
> +
> +/** Load this plugin. */
> +void KSHARK_PLUGIN_LOADER()
> +{
> +	plugin_sched_load();
> +}
> +
> +/** Reload this plugin. */
> +void KSHARK_PLUGIN_RELOADER()
> +{
> +	plugin_sched_unload();
> +	plugin_sched_load();
> +}
> +
> +/** Unload this plugin. */
> +void KSHARK_PLUGIN_UNLOADER()
> +{
> +	plugin_sched_unload();
> +}
> diff --git a/kernel-shark-qt/src/plugins/sched_events.h b/kernel-shark-qt/src/plugins/sched_events.h
> new file mode 100644
> index 0000000..d0c125a
> --- /dev/null
> +++ b/kernel-shark-qt/src/plugins/sched_events.h
> @@ -0,0 +1,79 @@
> +/* SPDX-License-Identifier: LGPL-2.1 */
> +
> +/*
> + * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
> + */
> +
> +/**
> + *  @file    sched_events.h
> + *  @brief   Plugin for Sched events.
> + */
> +
> +#ifndef _KS_PLUGIN_SHED_H
> +#define _KS_PLUGIN_SHED_H
> +
> +// trace-cmd
> +#include "event-parse.h"
> +
> +// KernelShark
> +#include "libkshark.h"
> +
> +#ifdef __cplusplus
> +extern "C" {
> +#endif
> +
> +/** Structure representing a plugin-specific context. */
> +struct plugin_sched_context {
> +	/** Input handle for the trace data file. */
> +	struct tracecmd_input	*handle;
> +
> +	/** Page event used to parse the page. */
> +	struct tep_handle	*pevent;
> +
> +	/** Pointer to the sched_switch_event object. */
> +	struct event_format	*sched_switch_event;
> +
> +	/** Pointer to the sched_switch_next_field format descriptor. */
> +	struct format_field	*sched_switch_next_field;
> +
> +	/** Pointer to the sched_switch_comm_field format descriptor. */
> +	struct format_field	*sched_switch_comm_field;
> +
> +	/** Pointer to the sched_wakeup_event object. */
> +	struct event_format	*sched_wakeup_event;
> +
> +	/** Pointer to the sched_wakeup_pid_field format descriptor. */
> +	struct format_field	*sched_wakeup_pid_field;
> +
> +	/** Pointer to the sched_wakeup_success_field format descriptor. */
> +	struct format_field	*sched_wakeup_success_field;
> +
> +	/** Pointer to the sched_wakeup_new_event object. */
> +	struct event_format	*sched_wakeup_new_event;
> +
> +	/** Pointer to the sched_wakeup_new_pid_field format descriptor. */
> +	struct format_field	*sched_wakeup_new_pid_field;
> +
> +	/**
> +	 * Pointer to the sched_wakeup_new_success_field format descriptor.
> +	 */
> +	struct format_field	*sched_wakeup_new_success_field;
> +};
> +
> +int plugin_get_next_pid(struct tep_record *record);
> +
> +int plugin_get_wakeup_pid(struct tep_record *record);
> +
> +bool plugin_wakeup_match_pid(struct kshark_context *kshark_ctx,
> +			     struct kshark_entry *e, int pid);
> +
> +bool plugin_switch_match_pid(struct kshark_context *kshark_ctx,
> +			     struct kshark_entry *e, int pid);
> +
> +void plugin_draw(struct kshark_cpp_argv *argv, int pid, int draw_action);
> +
> +#ifdef __cplusplus
> +}
> +#endif
> +
> +#endif

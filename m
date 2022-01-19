Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A107C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 12:24:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347444AbiASMYE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 07:24:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345736AbiASMYE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 07:24:04 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECBA4C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 04:24:03 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id 30so10429586edv.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 04:24:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=N4Jb+dXeAb1yjUtJkDClTZODRNb3Tihnkm00w/Z22pc=;
        b=GF79p4EgJBtZcE9PwYeHv3um7jf3HpK0W65n42y6Fo506RMr6LBxZ4RhEgrG6h8pSS
         6zzf+NlRMU7BethpWSsNKIysovvaE3nB0nvd0tfyZCW4tO8Gqhsnl/LGmcfsGpFXcRTL
         M5TzVbhLDH3oBdIky52wRCqZc3gKWPgj5WDl6wdTR41y5ZcxdFoi3oT6WZDy3RDeAhDh
         GXF3TLRp+bnWy9RVZ19ssDfmVLXTZ4crFi5LYfiPmAoRWzT7BZ9hjEnjrOi/4yPRD12S
         XlgZ7CihW769p7tiFMFVw6dGOyAiDU7YzLfIcF/FLOFrfyKQmfVnPP7S+U3fxv3gnSb6
         EsmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=N4Jb+dXeAb1yjUtJkDClTZODRNb3Tihnkm00w/Z22pc=;
        b=oZ1kibtMWYwoHtS0eP28+DWkkc66vcDezRLBLokyvK99vmY+QhEKnPuy7tR2yx8mj7
         z+Dfu7HKrFuAco3MXlNTUfqhmibXU68VtK/q/20htUMUzogDpMYmVJgqFK4h/hfW+kSt
         UQJyLakIKK+9ji3nFHAvk4mILtZU54RznisH5S6bSjT0BomL5nAXk8Vu7DUdtoLHh/f5
         gjpnPGnlYNyBhVqd5p/7Y1m3KJ+8QHJrzm6UvZhuAnLI6gsUN7gDLxmEG+T9By1Yvk/7
         r4Zt63prCaHKJpZ8XqA+S0z4XsP0VN9JHXUDVXX/qQAFQ7bkiKpJHUdJV5DX2HaHAMBD
         aD4g==
X-Gm-Message-State: AOAM531qWem/yuCFHtq51/HN+Pi7A/5EVDN4M5SriIbWG5NbXIY1Agsv
        oewFBYe2i4zZDw/sHtJqPRzmi4p1JcU=
X-Google-Smtp-Source: ABdhPJw67juhPietFLSmuCikPyny8LdBemaKhpJXOE1UKleIlzhthJITI76r7GlhijssthErAnu3qQ==
X-Received: by 2002:a05:6402:292f:: with SMTP id ee47mr23559948edb.262.1642595042495;
        Wed, 19 Jan 2022 04:24:02 -0800 (PST)
Received: from [192.168.1.9] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id c12sm1232538edx.80.2022.01.19.04.24.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jan 2022 04:24:01 -0800 (PST)
Message-ID: <d1cbc59b-32da-85da-2533-d7f193bc4999@gmail.com>
Date:   Wed, 19 Jan 2022 14:24:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH] kernel-shark: Add plugin for handling Xenomai
 cobalt_context_switch
Content-Language: en-US
To:     "Chen, Hongzhan" <hongzhan.chen@intel.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
References: <20220118033342.25119-1-hongzhan.chen@intel.com>
 <MN2PR11MB4285F116FD02668420B10E8CF2589@MN2PR11MB4285.namprd11.prod.outlook.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <MN2PR11MB4285F116FD02668420B10E8CF2589@MN2PR11MB4285.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org




On 18.01.22 г. 5:59 ч., Chen, Hongzhan wrote:
> Sorry, Please ignore it. Email wrong address.
> 
Hi Hongzhan,

I think it may be a good idea to have the mailing list CC-ed in the patches of the plugin.
I will be happy to keep an eye on your development.

And I have some comments in the patch below.


> Regards
> 
> Hongzhan Chen
> 
> -----Original Message-----
> From: Hongzhan Chen <hongzhan.chen@intel.com>
> Sent: Tuesday, January 18, 2022 11:34 AM
> To: linux-trace-devel@vger.kernel.org; y.karadz@gmail.com
> Subject: [PATCH] kernel-shark: Add plugin for handling Xenomai cobalt_context_switch
> 
> For Xenomai-cobalt enabled system, cobalt_switch_context means
> that there is schedule and context switch in companion core(realtime
> core), which we may need to do special treatment and take correct
> action as main kernel sched_switch to visualize out-of-band state
> of realtime tasks running in cobalt core. To achive our target,
> we implement following:
> 
>    1. store corresponding cobalt_switch_context events into
>       container data.
>    2. modify pid stored in entry to be equal to next_pid to
>       show correct color in cpu bar when cobalt_switch_context
>       event happen.
>    3. show cobalt blue hollow box to mark out-of-band state according
>       to cobalt_switch_context events.
>    4. clickable cobalt_switch_context plugin shapes.
> 
> Signed-off-by: Hongzhan Chen <hongzhan.chen@intel.com>
> 
> diff --git a/src/plugins/CMakeLists.txt b/src/plugins/CMakeLists.txt
> index 3e170fa..16f080b 100644
> --- a/src/plugins/CMakeLists.txt
> +++ b/src/plugins/CMakeLists.txt
> @@ -44,6 +44,10 @@ if (Qt5Widgets_FOUND AND TT_FONT_FILE)
>                        SOURCE sched_events.c SchedEvents.cpp)
>       list(APPEND PLUGIN_LIST "sched_events")
>   
> +    BUILD_GUI_PLUGIN(NAME xenomai_cobalt_switch_events
> +                     SOURCE xenomai_cobalt_switch_events.c CobaltSwitchEvents.cpp)
> +    list(APPEND PLUGIN_LIST "xenomai_cobalt_switch_events")
> +
>       BUILD_GUI_PLUGIN(NAME event_field_plot
>                        MOC EventFieldDialog.hpp
>                        SOURCE event_field_plot.c EventFieldDialog.cpp EventFieldPlot.cpp)

Ideally, you do not need the above.
My original idea was that the external plugins will build standalone, so that you do not need to carry the burden of the 
complicated build of the entire KernelShark GUI. However this was never tested so far. Please have a look in the 
patch-set "Allow GUI plugins to build standalone" and tell me if this can be useful for you.

thanks!
Yordan


> diff --git a/src/plugins/CobaltSwitchEvents.cpp b/src/plugins/CobaltSwitchEvents.cpp
> new file mode 100644
> index 0000000..269de95
> --- /dev/null
> +++ b/src/plugins/CobaltSwitchEvents.cpp
> @@ -0,0 +1,157 @@
> +// SPDX-License-Identifier: LGPL-2.1
> +
> +/*
> + * Copyright (C) 2021 Intel Inc, Hongzhan Chen <hongzhan.chen@intel.com>
> + */
> +
> +/**
> + *  @file    CobaltSwitchEvents.cpp
> + *  @brief   Defines a callback function for Xenomai Cobalt context switch
> + *           events used to plot in cobalt blue the out-of-band state of
> + *           the task
> + */
> +
> +// KernelShark
> +#include "libkshark.h"
> +#include "libkshark-plugin.h"
> +#include "plugins/xenomai_cobalt_switch_events.h"
> +#include "KsPlotTools.hpp"
> +#include "KsPlugins.hpp"
> +#include "KsMainWindow.hpp"
> +
> +static KsMainWindow *ks4xenomai_ptr;
> +
> +/**
> + * @brief Provide the plugin with a pointer to the KsMainWindow object (the GUI
> + * itself) such that the plugin can manipulate the GUI.
> + */
> +__hidden void *plugin_set_gui_ptr(void *gui_ptr)
> +{
> +	ks4xenomai_ptr = static_cast<KsMainWindow *>(gui_ptr);
> +	return nullptr;
> +}
> +
> +/**
> + * This class represents the graphical element visualizing OOB state between
> + *  two cobalt_switch_context events.
> + */
> +class XenomaiSwitchBox : public LatencyBox
> +{
> +	/** On double click do. */
> +	void _doubleClick() const override
> +	{
> +		ks4xenomai_ptr->markEntry(_data[1]->entry, DualMarkerState::B);
> +		ks4xenomai_ptr->markEntry(_data[0]->entry, DualMarkerState::A);
> +	}
> +
> +};
> +
> +/*
> + * Ideally, the cobalt_switch_context has to be the last trace event recorded before
> + * the task is preempted. Because of this, when the data is loaded (the first pass),
> + * the "pid" field of the cobalt_switch_context entries gets edited by this plugin
> + * to be equal to the "next pid" of the cobalt_switch_context event. However, in
> + * reality the cobalt_switch_context event may be followed by some trailing events
> + * from the same task (printk events for example). This has the effect of extending
> + * the graph of the task outside of the actual duration of the task. The "second
> + * pass" over the data is used to fix this problem. It takes advantage of the
> + * "next" field of the entry (this field is set during the first pass) to search
> + * for trailing events after the "cobalt_switch_context". In addition, when
> + * we find that it try to switch in-band because next-pid is zero, we prefer to
> + * skip this event because it try to leave oob not enterring.
> + */
> +static void secondPass(plugin_cobalt_context *plugin_ctx)
> +{
> +	kshark_data_container *cSS;
> +	kshark_entry *e;
> +	int pid_rec, switch_inband;
> +
> +	cSS = plugin_ctx->cs_data;
> +	for (ssize_t i = 0; i < cSS->size; ++i) {
> +		switch_inband = plugin_cobalt_check_switch_inband(
> +				cSS->data[i]->field);
> +
> +		/* we skip cobalt_switch_context that try to
> +		 * switch into in-band state because we just handle
> +		 * out-of-band
> +		 */
> +		if (switch_inband)
> +			continue;
> +		pid_rec = plugin_sched_get_pid(cSS->data[i]->field);
> +		e = cSS->data[i]->entry;
> +		if (!e->next || e->pid == 0 ||
> +		    e->event_id == e->next->event_id ||
> +		    pid_rec != e->next->pid)
> +			continue;
> +
> +		e = e->next;
> +		/* Find all trailing events. */
> +		for (; e->next; e = e->next) {
> +			if (e->pid == plugin_sched_get_pid(
> +						cSS->data[i]->field)) {
> +				/*
> +				 * Change the "pid" to be equal to the "next
> +				 * pid" of the cobalt_switch_context event
> +				 * and leave a sign that you edited this
> +				 * entry.
> +				 */
> +				e->pid = cSS->data[i]->entry->pid;
> +				e->visible &= ~KS_PLUGIN_UNTOUCHED_MASK;
> +
> +				/*  This is the last trailing event, we finish
> +				 *  this round.
> +				 */
> +				if (e->next->pid != plugin_sched_get_pid(
> +						cSS->data[i]->field))
> +					break;
> +			}
> +		}
> +	}
> +}
> +
> +/**
> + * @brief Plugin's draw function.
> + *
> + * @param argv_c: A C pointer to be converted to KsCppArgV (C++ struct).
> + * @param sd: Data stream identifier.
> + * @param pid: Process Id.
> + * @param draw_action: Draw action identifier.
> + */
> +__hidden void plugin_cobalt_draw(kshark_cpp_argv *argv_c,
> +			  int sd, int pid, int draw_action)
> +{
> +	plugin_cobalt_context *plugin_ctx;
> +
> +	if (!(draw_action & KSHARK_TASK_DRAW) || pid == 0)
> +		return;
> +
> +	plugin_ctx = __get_context(sd);
> +	if (!plugin_ctx)
> +		return;
> +
> +	KsCppArgV *argvCpp = KS_ARGV_TO_CPP(argv_c);
> +
> +	if (!plugin_ctx->second_pass_done) {
> +		/* The second pass is not done yet. */
> +		secondPass(plugin_ctx);
> +		plugin_ctx->second_pass_done = true;
> +	}
> +
> +	IsApplicableFunc checkFieldCS = [=] (kshark_data_container *d,
> +					     ssize_t i) {
> +		return !(plugin_cobalt_check_switch_inband(d->data[i]->field)) &&
> +			d->data[i]->entry->pid == pid;
> +	};
> +
> +	IsApplicableFunc checkEntryPid = [=] (kshark_data_container *d,
> +					      ssize_t i) {
> +		return plugin_sched_get_pid(d->data[i]->field) == pid;
> +	};
> +
> +	eventFieldIntervalPlot(argvCpp,
> +			       plugin_ctx->cs_data, checkFieldCS,
> +			       plugin_ctx->cs_data, checkEntryPid,
> +			       makeLatencyBox<XenomaiSwitchBox>,
> +			       {0, 71, 171}, // Cobalt Blue
> +			       -1);         // Default size
> +}
> diff --git a/src/plugins/xenomai_cobalt_switch_events.c b/src/plugins/xenomai_cobalt_switch_events.c
> new file mode 100644
> index 0000000..7a8317c
> --- /dev/null
> +++ b/src/plugins/xenomai_cobalt_switch_events.c
> @@ -0,0 +1,174 @@
> +// SPDX-License-Identifier: LGPL-2.1
> +
> +/*
> + * Copyright (C) 2021 Intel Inc, Hongzhan Chen <hongzhan.chen@intel.com>
> + */
> +
> +/**
> + *  @file    xenomai_cobalt_switch_events.c
> + *  @brief   handle xenomai cobalt switch context event
> + */
> +
> +// C
> +#include <stdlib.h>
> +#include <stdio.h>
> +
> +// trace-cmd
> +#include <trace-cmd.h>
> +
> +// KernelShark
> +#include "plugins/xenomai_cobalt_switch_events.h"
> +#include "libkshark-tepdata.h"
> +
> +/** Plugin context instance. */
> +
> +//! @cond Doxygen_Suppress
> +
> +#define SWITCH_INBAND_SHIFT	PREV_STATE_SHIFT
> +
> +#define SWITCH_INBAND_MASK	PREV_STATE_MASK
> +
> +//! @endcond
> +
> +static void cobalt_free_context(struct plugin_cobalt_context *plugin_ctx)
> +{
> +	if (!plugin_ctx)
> +		return;
> +
> +	kshark_free_data_container(plugin_ctx->cs_data);
> +}
> +
> +/* Use the most significant byte to store state marking switch in-band. */
> +static void plugin_cobalt_set_switch_inband_state(ks_num_field_t *field,
> +					ks_num_field_t inband_state)
> +{
> +	unsigned long long mask = SWITCH_INBAND_MASK << SWITCH_INBAND_SHIFT;
> +	*field &= ~mask;
> +	*field |= (inband_state & SWITCH_INBAND_MASK) << SWITCH_INBAND_SHIFT;
> +}
> +
> +/**
> + * @brief Retrieve the state of switch-in-band from the data field stored in
> + *        the kshark_data_container object.
> + *
> + * @param field: Input location for the data field.
> + */
> +__hidden int plugin_cobalt_check_switch_inband(ks_num_field_t field)
> +{
> +	unsigned long long mask = SWITCH_INBAND_MASK << SWITCH_INBAND_SHIFT;
> +
> +	return (field & mask) >> SWITCH_INBAND_SHIFT;
> +}
> +
> +/** A general purpose macro is used to define plugin context. */
> +KS_DEFINE_PLUGIN_CONTEXT(struct plugin_cobalt_context, cobalt_free_context);
> +
> +static bool plugin_cobalt_init_context(struct kshark_data_stream *stream,
> +				      struct plugin_cobalt_context *plugin_ctx)
> +{
> +	struct tep_event *event;
> +
> +	if (!kshark_is_tep(stream))
> +		return false;
> +
> +	plugin_ctx->tep = kshark_get_tep(stream);
> +
> +	event = tep_find_event_by_name(plugin_ctx->tep,
> +					"cobalt_core", "cobalt_switch_context");
> +	if (!event)
> +		return false;
> +
> +	plugin_ctx->cobalt_switch_event = event;
> +	plugin_ctx->cobalt_switch_next_field =
> +		tep_find_any_field(event, "next_pid");
> +
> +	plugin_ctx->second_pass_done = false;
> +
> +	plugin_ctx->cs_data = kshark_init_data_container();
> +	if (!plugin_ctx->cs_data)
> +		return false;
> +
> +	return true;
> +}
> +
> +static void plugin_cobalt_switch_action(struct kshark_data_stream *stream,
> +				      void *rec, struct kshark_entry *entry)
> +{
> +	struct tep_record *record = (struct tep_record *) rec;
> +	struct plugin_cobalt_context *plugin_ctx;
> +	unsigned long long next_pid;
> +	ks_num_field_t ks_field = 0;
> +	int ret;
> +
> +	plugin_ctx = __get_context(stream->stream_id);
> +	if (!plugin_ctx)
> +		return;
> +
> +	ret = tep_read_number_field(plugin_ctx->cobalt_switch_next_field,
> +				    record->data, &next_pid);
> +
> +	if (ret == 0 && next_pid >= 0) {
> +		plugin_sched_set_pid(&ks_field, entry->pid);
> +		if (next_pid == 0) {
> +			plugin_cobalt_set_switch_inband_state(&ks_field,
> +					SWITCH_INBAND_STATE);
> +		}
> +
> +		kshark_data_container_append(plugin_ctx->cs_data,
> +				entry, ks_field);
> +
> +		if (next_pid > 0)
> +			entry->pid = next_pid;
> +	}
> +}
> +
> +/** Load this plugin. */
> +int KSHARK_PLOT_PLUGIN_INITIALIZER(struct kshark_data_stream *stream)
> +{
> +	struct plugin_cobalt_context *plugin_ctx;
> +
> +	plugin_ctx = __init(stream->stream_id);
> +	if (!plugin_ctx || !plugin_cobalt_init_context(stream, plugin_ctx)) {
> +		__close(stream->stream_id);
> +		return 0;
> +	}
> +
> +	if (plugin_ctx->cobalt_switch_event) {
> +		kshark_register_event_handler(stream,
> +						plugin_ctx->cobalt_switch_event->id,
> +						plugin_cobalt_switch_action);
> +	}
> +
> +	kshark_register_draw_handler(stream, plugin_cobalt_draw);
> +
> +	return 1;
> +}
> +
> +/** Unload this plugin. */
> +int KSHARK_PLOT_PLUGIN_DEINITIALIZER(struct kshark_data_stream *stream)
> +{
> +	struct plugin_cobalt_context *plugin_ctx = __get_context(stream->stream_id);
> +	int ret = 0;
> +
> +	if (plugin_ctx) {
> +		if (plugin_ctx->cobalt_switch_event) {
> +			kshark_unregister_event_handler(stream,
> +							plugin_ctx->cobalt_switch_event->id,
> +							plugin_cobalt_switch_action);
> +		}
> +
> +		kshark_unregister_draw_handler(stream, plugin_cobalt_draw);
> +
> +		ret = 1;
> +	}
> +
> +	__close(stream->stream_id);
> +
> +	return ret;
> +}
> +
> +/** Initialize the control interface of the plugin. */
> +void *KSHARK_MENU_PLUGIN_INITIALIZER(void *gui_ptr)
> +{
> +	return plugin_set_gui_ptr(gui_ptr);
> +}
> diff --git a/src/plugins/xenomai_cobalt_switch_events.h b/src/plugins/xenomai_cobalt_switch_events.h
> new file mode 100644
> index 0000000..f7f4593
> --- /dev/null
> +++ b/src/plugins/xenomai_cobalt_switch_events.h
> @@ -0,0 +1,58 @@
> +/* SPDX-License-Identifier: LGPL-2.1 */
> +
> +/*
> + * Copyright (C) 2021 Intel Inc, Hongzhan Chen<hongzhan.chen@intel.com>
> + */
> +
> +/**
> + *  @file    xenomai_cobalt_switch_events.h
> + *  @brief   Plugin for xenomai cobalt switch context event
> + */
> +
> +#ifndef _KS_PLUGIN_COBALT_SWITCH_H
> +#define _KS_PLUGIN_COBALT_SWITCH_H
> +
> +// KernelShark
> +#include "libkshark.h"
> +#include "plugins/common_sched.h"
> +
> +#ifdef __cplusplus
> +extern "C" {
> +#endif
> +
> +/** cobalt_switch_context is trying to switch in-band. */
> +#define SWITCH_INBAND_STATE	1
> +
> +/** Structure representing a plugin-specific context. */
> +struct plugin_cobalt_context {
> +	/** Page event used to parse the page. */
> +	struct tep_handle	*tep;
> +
> +	/** Pointer to the cobalt_switch_event object. */
> +	struct tep_event	*cobalt_switch_event;
> +
> +	 /** Pointer to the cobalt_switch_next_field format descriptor. */
> +	struct tep_format_field *cobalt_switch_next_field;
> +
> +	/** True if the second pass is already done. */
> +	bool	second_pass_done;
> +
> +	/** Data container for cobalt_switch_context data. */
> +	struct kshark_data_container	*cs_data;
> +
> +};
> +
> +KS_DECLARE_PLUGIN_CONTEXT_METHODS(struct plugin_cobalt_context)
> +
> +int plugin_cobalt_check_switch_inband(ks_num_field_t field);
> +
> +void plugin_cobalt_draw(struct kshark_cpp_argv *argv, int sd, int pid,
> +		 int draw_action);
> +
> +void *plugin_set_gui_ptr(void *gui_ptr);
> +
> +#ifdef __cplusplus
> +}
> +#endif
> +
> +#endif
> 

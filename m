Return-Path: <SRS0=WdLK=LN=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:39314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725788AbeH3GnH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 30 Aug 2018 02:43:07 -0400
Date: Wed, 29 Aug 2018 22:43:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH 7/7] kernel-shark-qt: Add a plugin for sched events.
Message-ID: <20180829224312.25c7a16e@vmware.local.home>
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

> The plugin is responsible for the following actions, specific for
> "sched" events:
> 
> 1. Changes the value of the "pid" field of the "sched_switch" entries.
>    This alows the sched_switch entrie to be ploted as part of the "next"

				entry		plotted

>    task.
> 
> 2. On "sched_switch" event, the plugin registers the "next" task (if not
>    registered already).
> 
> 3. Plots in green the wake up latency of the task and in red the time
>    the task was preempted by another task.
> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  kernel-shark-qt/src/plugins/CMakeLists.txt  |   9 +
>  kernel-shark-qt/src/plugins/SchedEvents.cpp | 258 +++++++++++++++++
>  kernel-shark-qt/src/plugins/sched_events.c  | 302 ++++++++++++++++++++
>  kernel-shark-qt/src/plugins/sched_events.h  |  79 +++++
>  4 files changed, 648 insertions(+)
>  create mode 100644 kernel-shark-qt/src/plugins/SchedEvents.cpp
>  create mode 100644 kernel-shark-qt/src/plugins/sched_events.c
>  create mode 100644 kernel-shark-qt/src/plugins/sched_events.h
> 
> diff --git a/kernel-shark-qt/src/plugins/CMakeLists.txt b/kernel-shark-qt/src/plugins/CMakeLists.txt
> index d791f00..fb7a798 100644
> --- a/kernel-shark-qt/src/plugins/CMakeLists.txt
> +++ b/kernel-shark-qt/src/plugins/CMakeLists.txt
> @@ -19,4 +19,13 @@ endfunction()
>  
>  set(PLUGIN_LIST "")
>  
> +ADD_PLUGIN(NAME sched_events
> +           SOURCE sched_events.c SchedEvents.cpp)

Do all plugins need to be added like this? Is there a way to make a
default rule for a "plugin" directory, that we add source files of this
type and have them created automatically just by adding in the source
files?

> +
> +# list(APPEND PLUGIN_LIST "sched_events default") # This plugin will be loaded by default
> +list(APPEND PLUGIN_LIST "sched_events") # This plugin isn't loaded by default
> +
> +install(TARGETS sched_events
> +        LIBRARY DESTINATION /usr/local/lib/kshark/)
> +
>  set(PLUGINS ${PLUGIN_LIST} PARENT_SCOPE)
> diff --git a/kernel-shark-qt/src/plugins/SchedEvents.cpp b/kernel-shark-qt/src/plugins/SchedEvents.cpp
> new file mode 100644
> index 0000000..8559df8
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

Probably need a bit more detail in that description.

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

I thought we would use "_simple" ?

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

Records must be freed with:

	free_record(record);

Which also looks like we missed a function that needs to be converted.
tep_free_record()?

or should we have it be free_tep_record(), although, I'm not sure I
like this breaking from the prefix way.

I'll look at the rest of this patch tomorrow.

-- Steve

> +
> +	return val;
> +}
> +

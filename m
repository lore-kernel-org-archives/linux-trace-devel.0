Return-Path: <SRS0=pqkA=MY=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:58724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728537AbeJMAMS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Oct 2018 20:12:18 -0400
Date: Fri, 12 Oct 2018 12:38:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <ykaradzhov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2] kernel-shark-qt: Fix the glitches in the preemption
 time visualization
Message-ID: <20181012123856.79e20596@gandalf.local.home>
In-Reply-To: <20181011165852.15325-1-ykaradzhov@vmware.com>
References: <20181011165852.15325-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Thu, 11 Oct 2018 16:59:14 +0000
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> This problem was reported by Steven Rostedt. The reason for having
> the problem was my wrong assumption that for a given task the
> sched_switch event is always the last record before the task is
> preempted.
> 
> The patch changes two things:
>    It modifies the "match" functions used to search for sched events,
>    making these functions to trigger only on sched_switch/_wakeup events.
>    This eliminates the flakiness due to the fact that sometimes the
>    sched_switch can happend to be in the same bin with some of the trailing
>    events from the same task. This also has the side effect of simplifying
>    the code.
> 
>    It introduces a second pass over the data, which is task-specific and
>    gets executed only the first time the task is plotted. This second pass
>    edits the "pid" field of the last trailing event making it equal to the
>    "next pid" field of the sched_switch event.
> 
> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> ---
>  kernel-shark-qt/src/plugins/SchedEvents.cpp | 122 ++++++++++++++------
>  kernel-shark-qt/src/plugins/sched_events.c  |  13 +--
>  2 files changed, 90 insertions(+), 45 deletions(-)
> 
> diff --git a/kernel-shark-qt/src/plugins/SchedEvents.cpp b/kernel-shark-qt/src/plugins/SchedEvents.cpp
> index 713feb4..b88ec6d 100644
> --- a/kernel-shark-qt/src/plugins/SchedEvents.cpp
> +++ b/kernel-shark-qt/src/plugins/SchedEvents.cpp
> @@ -16,6 +16,7 @@
>  
>  // C++ 11
>  #include<functional>
> +#include<unordered_set>
>  
>  // KernelShark
>  #include "libkshark.h"
> @@ -29,25 +30,12 @@
>  
>  #define PLUGIN_MAX_ENTRIES_PER_BIN 500
>  
> +#define KS_TASK_COLLECTION_MARGIN 25
> +
>  //! @endcond
>  
>  extern struct plugin_sched_context *plugin_sched_context_handler;
>  
> -static int plugin_get_wakeup_pid(kshark_context *kshark_ctx,
> -				 plugin_sched_context *plugin_ctx,
> -				 const struct kshark_entry *e)
> -{
> -	struct tep_record *record;
> -	unsigned long long val;
> -
> -	record = kshark_read_at(kshark_ctx, e->offset);
> -	tep_read_number_field(plugin_ctx->sched_wakeup_pid_field,
> -			      record->data, &val);
> -	free_record(record);
> -
> -	return val;
> -}
> -
>  /** Sched Event identifier. */
>  enum class SchedEvent {
>  	/** Sched Switch Event. */
> @@ -139,23 +127,16 @@ static void pluginDraw(plugin_sched_context *plugin_ctx,
>  			ksmodel_get_entry_back(histo, bin, false,
>  					       plugin_wakeup_match_pid, pid,
>  					       col, nullptr);
> -		int wakeup_pid;
> -
> -		if (entryB &&
> -		    plugin_ctx->sched_wakeup_event &&
> -		    entryB->event_id == plugin_ctx->sched_wakeup_event->id) {
> -			wakeup_pid =
> -				plugin_get_wakeup_pid(kshark_ctx, plugin_ctx, entryB);
> -			if (wakeup_pid == pid) {
> -				/*
> -				 * entryB is a sched_wakeup_event. Open a
> -				 * green box here.
> -				 */
> -				openBox(graph->getBin(bin)._base);
>  
> -				 /* Green */
> -				rec->_color = KsPlot::Color(0, 255, 0);
> -			}
> +		if (entryB) {
> +			/*
> +			 * entryB is a sched_wakeup_event. Open a
> +			 * green box here.
> +			 */
> +			openBox(graph->getBin(bin)._base);
> +
> +			/* Green */
> +			rec->_color = KsPlot::Color(0, 255, 0);
>  		}
>  	};
>  
> @@ -171,10 +152,7 @@ static void pluginDraw(plugin_sched_context *plugin_ctx,
>  					       plugin_switch_match_pid, pid,
>  					       col, nullptr);
>  
> -		if (entryB &&
> -		    entryB->pid != pid &&
> -		    plugin_ctx->sched_switch_event &&
> -		    entryB->event_id == plugin_ctx->sched_switch_event->id) {
> +		if (entryB && entryB->pid != pid) {
>  			/*
>  			 * entryB is a sched_switch_event. Open a
>  			 * red box here.
> @@ -215,6 +193,63 @@ static void pluginDraw(plugin_sched_context *plugin_ctx,
>  	return;
>  }
>  
> +static std::unordered_set<int> secondPassDone;
> +
> +/*
> + * Ideally, the sched_switch has to be the last trace event recorded before the
> + * task is preempted. Because of this, when the data is loaded (the first pass),
> + * the "pid" field of the sched_switch entries gets edited by this plugin to be
> + * equal to the "next pid" of the sched_switch event. However, in reality the
> + * sched_switch event may be followed by some trailing events from the same task
> + * (printk events for example). This has the effect of extending the graph of
> + * the task outside of the actual duration of the task. The "second pass" over
> + * the data is used to fix this problem. It takes advantage of the "next" field
> + * of the entry (this field is set during the first pass) to search for trailing
> + * events after the "sched_switch".
> + */
> +static void secondPass(kshark_entry **data,
> +		       kshark_entry_collection *col,
> +		       int pid)
> +{
> +	kshark_entry *last;
> +	int first, n;
> +	ssize_t index;
> +
> +	/* Loop over the intervals of the data collection. */
> +	for (size_t i = 0; i < col->size; ++i) {
> +		first = col->break_points[i];
> +		n = first - col->resume_points[i];
> +
> +		kshark_entry_request *req =
> +			kshark_entry_request_alloc(first, n,
> +						   plugin_switch_match_pid, pid,
> +						   true,
> +						   KS_GRAPH_VIEW_FILTER_MASK);
> +
> +		if (!kshark_get_entry_back(req, data, &index)) {

Don't we need to free req?

> +			/* No sched_switch event in this interval. */
> +			continue;
> +		}
> +

Here too.

-- Steve

> +		/* Find the very last trailing event. */
> +		for (last = data[index]; last->next; last = last->next) {
> +			if (last->next->pid != pid) {
> +				/*
> +				 * This is the last trailing event. Change the
> +				 * "pid" to be equal to the "next pid" of the
> +				 * sched_switch event and leave a sign that you
> +				 * edited this entry.
> +				 */
> +				last->pid = data[index]->pid;
> +				last->visible &= ~KS_PLUGIN_UNTOUCHED_MASK;
> +				break;
> +			}
> +		}
> +	}
> +
> +	secondPassDone.insert(pid);
> +}
> +
>

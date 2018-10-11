Return-Path: <SRS0=tdNt=MX=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:40122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725971AbeJKJGV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Oct 2018 05:06:21 -0400
Date: Wed, 10 Oct 2018 21:41:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <ykaradzhov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] kernel-shark-qt: Fix the glitches in the preemption
 time visualization
Message-ID: <20181010214124.47bed5cc@vmware.local.home>
In-Reply-To: <20181010201154.23881-1-ykaradzhov@vmware.com>
References: <20181010201154.23881-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 10 Oct 2018 20:12:21 +0000
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> This problem was reported by Steven Rostedt. The reason for having
> the problem was my wrong assumption that for a given task the
> sched_switch event is always the last record.
> 
> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> ---
>  kernel-shark-qt/src/plugins/SchedEvents.cpp | 52 +++++++++++++++++++++
>  kernel-shark-qt/src/plugins/sched_events.c  |  3 --
>  2 files changed, 52 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel-shark-qt/src/plugins/SchedEvents.cpp b/kernel-shark-qt/src/plugins/SchedEvents.cpp
> index 713feb4..7e5c4ad 100644
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
> @@ -29,6 +30,8 @@
>  
>  #define PLUGIN_MAX_ENTRIES_PER_BIN 500
>  
> +#define KS_TASK_COLLECTION_MARGIN 25
> +
>  //! @endcond
>  
>  extern struct plugin_sched_context *plugin_sched_context_handler;
> @@ -215,6 +218,41 @@ static void pluginDraw(plugin_sched_context *plugin_ctx,
>  	return;
>  }
>  
> +static std::unordered_set<int> singlePassDone;
> +

Can you add some comments to how this works.

> +static void singlePass(kshark_entry **data,
> +		       kshark_entry_collection *col,
> +		       int pid)
> +{
> +	kshark_entry *last;
> +	int first, n;
> +	ssize_t index;
> +
> +	for (size_t i = 0; i < col->size; ++i) {

What's the purpose of looping to col->size?

> +		first = col->break_points[i];
> +		n = first - col->resume_points[i];

How are we using break_points and resume_points here?

> +
> +		kshark_entry_request *req =
> +			kshark_entry_request_alloc(first, n,
> +						   plugin_switch_match_pid, pid,
> +						   true,
> +						   KS_GRAPH_VIEW_FILTER_MASK);
> +
> +		if (!kshark_get_entry_back(req, data, &index))

Why do we continue when this returns zero?

> +			continue;
> +
> +		for (last = data[index]; last->next; last = last->next) {
> +			if (last->next->pid != pid) {
> +				last->pid = data[index]->pid;

Why do we do the above assignment? Which also brings up the question,
what if data[index]->pid doesn't equal pid?


> +				last->visible &= ~KS_PLUGIN_UNTOUCHED_MASK;
> +				break;
> +			}
> +		}
> +	}
> +
> +	singlePassDone.insert(pid);
> +}
> +
>  /**
>   * @brief Plugin's draw function.
>   *
> @@ -246,8 +284,22 @@ void plugin_draw(kshark_cpp_argv *argv_c, int pid, int draw_action)
>  	 */
>  	col = kshark_find_data_collection(kshark_ctx->collections,
>  					  kshark_match_pid, pid);
> +	if (!col) {
> +		/*
> +		 * If a data collection for this task does not exist,
> +		 * register a new one.
> +		 */
> +		col = kshark_register_data_collection(kshark_ctx,
> +						      _data->rows(),
> +						      _data->size(),
> +						      kshark_match_pid, pid,
> +						      KS_TASK_COLLECTION_MARGIN);
> +	}
>  
>  	try {
> +		if (singlePassDone.find(pid) == singlePassDone.end())

What's the significance of .find(pid) == end()?

There's an awful lot of abstraction and "assumed knowledge" here, that
makes this pretty impossible to understand if one were to just jump
right into this code without much background. We need comments to
remove that abstraction.

-- Steve

> +			singlePass(argvCpp->_histo->data, col, pid);
> +
>  		pluginDraw(plugin_ctx, kshark_ctx,
>  			   argvCpp->_histo, col,
>  			   SchedEvent::Switch, pid,
> diff --git a/kernel-shark-qt/src/plugins/sched_events.c b/kernel-shark-qt/src/plugins/sched_events.c
> index 13f3c4a..4bcaa48 100644
> --- a/kernel-shark-qt/src/plugins/sched_events.c
> +++ b/kernel-shark-qt/src/plugins/sched_events.c
> @@ -224,9 +224,6 @@ bool plugin_switch_match_pid(struct kshark_context *kshark_ctx,
>  	struct tep_record *record = NULL;
>  	int switch_pid = -1;
>  
> -	if (e->pid == pid)
> -		return true;
> -
>  	plugin_ctx = plugin_sched_context_handler;
>  
>  	if (plugin_ctx->sched_switch_event &&

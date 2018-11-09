Return-Path: <SRS0=pNTI=NU=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:32786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727157AbeKILyi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Nov 2018 06:54:38 -0500
Date: Thu, 8 Nov 2018 21:16:09 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <ykaradzhov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 8/8] kernel-shark-qt: Update Sched Events plugin
Message-ID: <20181108211504.4abc3b2d@vmware.local.home>
In-Reply-To: <20181107161410.22507-9-ykaradzhov@vmware.com>
References: <20181107161410.22507-1-ykaradzhov@vmware.com>
        <20181107161410.22507-9-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 7 Nov 2018 16:14:40 +0000
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> This patch updates the Sched Events plugin to use the recently
> introduced "Missed events" entries and tot_count field of the
> Visualization model descriptor in its plotting logic.

Again, we are missing the "why". A description here should explain why
this was done. Something like "The sched plugin would get confused
because of missed events, where we could have missed events hiding
wakeups, and only have the sched switch, or a wakeup with a missing
sched switch would break the plotting of the latency".


> 
> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> ---
>  kernel-shark-qt/src/plugins/SchedEvents.cpp | 46 +++++++++------------
>  1 file changed, 20 insertions(+), 26 deletions(-)
> 
> diff --git a/kernel-shark-qt/src/plugins/SchedEvents.cpp b/kernel-shark-qt/src/plugins/SchedEvents.cpp
> index 1e872aa..42737e9 100644
> --- a/kernel-shark-qt/src/plugins/SchedEvents.cpp
> +++ b/kernel-shark-qt/src/plugins/SchedEvents.cpp
> @@ -28,7 +28,7 @@
>  
>  #define PLUGIN_MIN_BOX_SIZE 4
>  
> -#define PLUGIN_MAX_ENTRIES_PER_BIN 500
> +#define PLUGIN_MAX_ENTRIES 10000
>  
>  #define KS_TASK_COLLECTION_MARGIN 25
>  
> @@ -54,11 +54,11 @@ static void pluginDraw(plugin_sched_context *plugin_ctx,
>  		       KsPlot::Graph *graph,
>  		       KsPlot::PlotObjList *shapes)
>  {
> -	const kshark_entry *entryClose, *entryOpen;
> +	const kshark_entry *entryClose, *entryOpen, *entryME;
> +	ssize_t indexClose(0), indexOpen(0), indexME(0);
>  	std::function<void(int)> ifSchedBack;
>  	KsPlot::Rectangle *rec = nullptr;
>  	int height = graph->getHeight() * .3;
> -	ssize_t indexClose(0), indexOpen(0);
>  
>  	auto openBox = [&] (const KsPlot::Point &p)
>  	{
> @@ -101,24 +101,6 @@ static void pluginDraw(plugin_sched_context *plugin_ctx,
>  	};
>  
>  	for (int bin = 0; bin < graph->size(); ++bin) {
> -		/**
> -		 * Plotting the latencies makes sense only in the case of a
> -		 * deep zoom. Here we set a naive threshold based on the number
> -		 * of entries inside the current bin. This cut seems to work
> -		 * well in all cases I tested so far, but it may result in
> -		 * unexpected behavior with some unusual trace data-sets.
> -		 * TODO: find a better criteria for deciding when to start
> -		 * plotting latencies.
> -		 */
> -		if (ksmodel_bin_count(histo, bin) > PLUGIN_MAX_ENTRIES_PER_BIN) {
> -			if (rec) {
> -				delete rec;
> -				rec = nullptr;
> -			}
> -
> -			continue;
> -		}
> -
>  		/*
>  		 * Starting from the first element in this bin, go forward
>  		 * in time until you find a trace entry that satisfies the
> @@ -128,6 +110,11 @@ static void pluginDraw(plugin_sched_context *plugin_ctx,
>  						 plugin_switch_match_entry_pid,
>  						 pid, col, &indexClose);
>  
> +		entryME = ksmodel_get_task_missed_events(histo,
> +							 bin, pid,
> +							 col,
> +							 &indexME);
> +
>  		if (e == SchedEvent::Switch) {
>  			/*
>  			 * Starting from the last element in this bin, go backward
> @@ -152,10 +139,12 @@ static void pluginDraw(plugin_sched_context *plugin_ctx,
>  		}
>  
>  		if (rec) {
> -			if (entryClose) {
> +			if (entryME || entryClose) {
>  				/* Close the box in this bin. */
>  				closeBox(graph->getBin(bin)._base);
> -				if (entryOpen && indexClose < indexOpen) {
> +				if (entryOpen &&
> +				    indexME < indexOpen &&
> +				    indexClose < indexOpen) {
>  					/*
>  					 * We have a Sched switch entry that
>  					 * comes after (in time) the closure of
> @@ -244,9 +233,6 @@ static void secondPass(kshark_entry **data,
>   * @param argv_c: A C pointer to be converted to KsCppArgV (C++ struct).
>   * @param pid: Process Id.
>   * @param draw_action: Draw action identifier.
> - *
> - * @returns True if the Pid of the entry matches the value of "pid".
> - *	    Otherwise false.
>   */
>  void plugin_draw(kshark_cpp_argv *argv_c, int pid, int draw_action)
>  {
> @@ -288,6 +274,14 @@ void plugin_draw(kshark_cpp_argv *argv_c, int pid, int draw_action)
>  		tracecmd_filter_id_add(plugin_ctx->second_pass_hash, pid);
>  	}
>  
> +	/*
> +	 * Plotting the latencies makes sense only in the case of a deep zoom.
> +	 * Here we set a threshold based on the total number of entries being
> +	 * visualized by the model.
> +	 * Don't be afraid to play with different values for this threshold.

Is this a comment to me?

I guess we need a way to save config options, and this could be a
variable. Or we can experiment with different numbers.

-- Steve


> +	 */
> +	if (argvCpp->_histo->tot_count > PLUGIN_MAX_ENTRIES)
> +		return;
>  	try {
>  		pluginDraw(plugin_ctx, kshark_ctx,
>  			   argvCpp->_histo, col,

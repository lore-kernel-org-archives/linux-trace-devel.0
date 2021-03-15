Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75254C433DB
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Mar 2021 18:33:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4564764F3F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Mar 2021 18:33:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbhCOSc6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Mar 2021 14:32:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:53614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231521AbhCOScq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Mar 2021 14:32:46 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 443EB64E4D;
        Mon, 15 Mar 2021 18:32:46 +0000 (UTC)
Date:   Mon, 15 Mar 2021 14:32:44 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/2] trace-cmd: Wait for first time sync before the
 trace
Message-ID: <20210315143244.51bb87c0@gandalf.local.home>
In-Reply-To: <20210315061819.168426-3-tz.stoyanov@gmail.com>
References: <20210315061819.168426-1-tz.stoyanov@gmail.com>
        <20210315061819.168426-3-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 15 Mar 2021 08:18:19 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Added a barrier in time synchronization threads to ensure the first time
> synchronization passed before to start the trace.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  lib/trace-cmd/trace-timesync.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
> index 06853f9d..5995551e 100644
> --- a/lib/trace-cmd/trace-timesync.c
> +++ b/lib/trace-cmd/trace-timesync.c
> @@ -537,6 +537,7 @@ void tracecmd_tsync_free(struct tracecmd_time_sync *tsync)
>  	tsync_context->sync_size = 0;
>  	pthread_mutex_destroy(&tsync->lock);
>  	pthread_cond_destroy(&tsync->cond);
> +	pthread_barrier_destroy(&tsync->first_sync);
>  	free(tsync->clock_str);
>  	free(tsync->proto_name);
>  	free(tsync);
> @@ -648,6 +649,7 @@ static int tsync_with_guest(struct tracecmd_time_sync *tsync)
>  	int ts_array_size = CLOCK_TS_ARRAY;
>  	struct tsync_proto *proto;
>  	struct timespec timeout;
> +	bool first = true;
>  	bool end = false;
>  	int ret;
>  

This function should always release the barrier, and not depend on the
caller to do so on error. That is, have this:

	clock_context_init(tsync, &proto, false);
-	if (!tsync->context)
+	if (!tsync->context) {
+		pthread_barrier_wait(&tsync->first_sync);
		return -1;
+	}



> @@ -666,6 +668,10 @@ static int tsync_with_guest(struct tracecmd_time_sync *tsync)
>  						  TRACECMD_TIME_SYNC_CMD_PROBE,
>  						  0, NULL);
>  		ret = tsync_get_sample(tsync, proto, ts_array_size);
> +		if (first) {
> +			first = false;
> +			pthread_barrier_wait(&tsync->first_sync);
> +		}
>  		if (ret || end)
>  			break;

On error here, you will cause the caller to incorrectly call
pthread_barrier_wait() again and get stuck. That's why I stated above that
it this function must be responsible to release the barrier.

This is why barriers can be dangerous.

>  		if (tsync->loop_interval > 0) {
> @@ -693,12 +699,17 @@ static int tsync_with_guest(struct tracecmd_time_sync *tsync)
>  static void *tsync_host_thread(void *data)
>  {
>  	struct tracecmd_time_sync *tsync = NULL;
> +	int ret;
>  
>  	tsync = (struct tracecmd_time_sync *)data;
> -	tsync_with_guest(tsync);
> +	ret = tsync_with_guest(tsync);
>  	tracecmd_msg_handle_close(tsync->msg_handle);
>  	tsync->msg_handle = NULL;
>  
> +	/* tsync with guest failed, release the barrier */
> +	if (ret)
> +		pthread_barrier_wait(&tsync->first_sync);
> +

As stated above, do not do this here.

-- Steve

>  	pthread_exit(0);
>  }
>  
> @@ -757,6 +768,7 @@ tracecmd_tsync_with_guest(unsigned long long trace_id, int loop_interval,
>  		tsync->clock_str = strdup(clock);
>  	pthread_mutex_init(&tsync->lock, NULL);
>  	pthread_cond_init(&tsync->cond, NULL);
> +	pthread_barrier_init(&tsync->first_sync, NULL, 2);
>  	pthread_attr_init(&attrib);
>  	pthread_attr_setdetachstate(&attrib, PTHREAD_CREATE_JOINABLE);
>  
> @@ -767,6 +779,7 @@ tracecmd_tsync_with_guest(unsigned long long trace_id, int loop_interval,
>  
>  	if (!get_first_cpu(&pin_mask, &mask_size))
>  		pthread_setaffinity_np(tsync->thread, mask_size, pin_mask);
> +	pthread_barrier_wait(&tsync->first_sync);
>  
>  	if (pin_mask)
>  		CPU_FREE(pin_mask);


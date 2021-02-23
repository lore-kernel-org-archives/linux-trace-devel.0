Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A42DC433DB
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Feb 2021 21:37:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 535A964E3F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Feb 2021 21:37:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbhBWVhP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Feb 2021 16:37:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:39014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231837AbhBWVhP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Feb 2021 16:37:15 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BE0A64E83;
        Tue, 23 Feb 2021 21:36:33 +0000 (UTC)
Date:   Tue, 23 Feb 2021 16:36:32 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v29 5/5] trace-cmd [POC]: Add KVM timestamp
 synchronization plugin
Message-ID: <20210223163632.438071c7@gandalf.local.home>
In-Reply-To: <20210219101457.2345089-6-tz.stoyanov@gmail.com>
References: <20210219101457.2345089-1-tz.stoyanov@gmail.com>
        <20210219101457.2345089-6-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 19 Feb 2021 12:14:57 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
> index fb18075b..aa3e3fc1 100644
> --- a/lib/trace-cmd/trace-timesync.c
> +++ b/lib/trace-cmd/trace-timesync.c
> @@ -63,6 +63,7 @@ static struct tsync_proto *tsync_proto_find(const char *proto_name)
>  void tracecmd_tsync_init(void)
>  {
>  	ptp_clock_sync_register();
> +	kvm_clock_sync_register();
>  }
>  
>  int tracecmd_tsync_proto_register(const char *proto_name, int accuracy, int roles,
> @@ -433,6 +434,7 @@ void tracecmd_tsync_free(struct tracecmd_time_sync *tsync)
>  	}
>  	pthread_mutex_destroy(&tsync->lock);
>  	pthread_cond_destroy(&tsync->cond);
> +	pthread_barrier_destroy(&tsync->first_sync);

I'm guessing that this was suppose to be added as a separate patch? If not,
it should be.


>  	free(tsync->clock_str);
>  }
>  
> @@ -630,23 +632,24 @@ static inline void get_ts_loop_delay(struct timespec *timeout, int delay_ms)
>   * It loops infinite, until the timesync semaphore is released
>   *
>   */
> -void tracecmd_tsync_with_guest(struct tracecmd_time_sync *tsync)
> +int tracecmd_tsync_with_guest(struct tracecmd_time_sync *tsync)
>  {
>  	struct tsync_probe_request_msg probe;
>  	int ts_array_size = CLOCK_TS_ARRAY;
>  	struct tsync_proto *proto;
>  	struct timespec timeout;
> +	bool first = true;
>  	bool end = false;
>  	int ret;
>  	int i;
>  
>  	proto = tsync_proto_find(tsync->proto_name);
>  	if (!proto || !proto->clock_sync_calc)
> -		return;
> +		return -1;
>  
>  	clock_context_init(tsync, false);
>  	if (!tsync->context)
> -		return;
> +		return -1;
>  
>  	if (tsync->loop_interval > 0 &&
>  	    tsync->loop_interval < (CLOCK_TS_ARRAY * 1000))
> @@ -664,6 +667,10 @@ void tracecmd_tsync_with_guest(struct tracecmd_time_sync *tsync)
>  			if (ret)
>  				break;
>  		}
> +		if (first) {
> +			first = false;
> +			pthread_barrier_wait(&tsync->first_sync);

As pthread_barrier_wait() and pthread_barrier_destroy() are used here, this
should not be in the library code. It should be in the trace-cmd code, or
the trace-cmd code should be in the library.

A pthread_barrier_wait() is dangerous and needs to be tightly coupled with
all use cases. Otherwise, you could end with a thread stuck in the barrier
and nothing wakes it up.

> +		}
>  		if (end || i < tsync->vcpu_count)
>  			break;
>  		if (tsync->loop_interval > 0) {
> @@ -685,4 +692,5 @@ void tracecmd_tsync_with_guest(struct tracecmd_time_sync *tsync)
>  				    TRACECMD_TSYNC_PROTO_NONE,
>  				    TRACECMD_TIME_SYNC_CMD_STOP,
>  				    0, NULL);
> +	return 0;
>  }
> diff --git a/tracecmd/trace-tsync.c b/tracecmd/trace-tsync.c
> index d7de8298..ec4b2d86 100644
> --- a/tracecmd/trace-tsync.c
> +++ b/tracecmd/trace-tsync.c
> @@ -61,14 +61,19 @@ error:
>  static void *tsync_host_thread(void *data)
>  {
>  	struct tracecmd_time_sync *tsync = NULL;
> +	int ret;
>  
>  	tsync = (struct tracecmd_time_sync *)data;
>  
> -	tracecmd_tsync_with_guest(tsync);
> +	ret = tracecmd_tsync_with_guest(tsync);
>  
>  	tracecmd_msg_handle_close(tsync->msg_handle);
>  	tsync->msg_handle = NULL;
>  
> +	/* tsync with guest failed, release the barrier */
> +	if (ret)
> +		pthread_barrier_wait(&tsync->first_sync);

This being needed here shows that the barrier logic needs to be separated
out. As this is in the trace-cmd proper, and its releasing the guest, and
this is exposing the internal logic of the lib/trace-cmd code, which is not
acceptable.

We probably want the guest logic moved here?

Either way, we need to make sure there's no path that could cause the guest
(or host) to get stuck in the barrier.

-- Steve


> +
>  	pthread_exit(0);
>  }
>  
> @@ -106,6 +111,7 @@ int tracecmd_host_tsync(struct buffer_instance *instance,
>  		instance->tsync.clock_str = strdup(top_instance.clock);
>  	pthread_mutex_init(&instance->tsync.lock, NULL);
>  	pthread_cond_init(&instance->tsync.cond, NULL);
> +	pthread_barrier_init(&instance->tsync.first_sync, NULL, 2);
>  
>  	pthread_attr_init(&attrib);
>  	pthread_attr_setdetachstate(&attrib, PTHREAD_CREATE_JOINABLE);
> @@ -117,6 +123,7 @@ int tracecmd_host_tsync(struct buffer_instance *instance,
>  		if (!get_first_cpu(&pin_mask, &mask_size))
>  			pthread_setaffinity_np(instance->tsync_thread, mask_size, pin_mask);
>  		instance->tsync_thread_running = true;
> +		pthread_barrier_wait(&instance->tsync.first_sync);
>  	}
>  
>  	if (pin_mask)


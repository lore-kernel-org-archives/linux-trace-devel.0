Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EE23C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Oct 2021 02:09:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57F576103B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Oct 2021 02:09:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232745AbhJZCLW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 25 Oct 2021 22:11:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:43356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230216AbhJZCLW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 25 Oct 2021 22:11:22 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0272560C49;
        Tue, 26 Oct 2021 02:08:57 +0000 (UTC)
Date:   Mon, 25 Oct 2021 22:08:56 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>
Cc:     Ingo Molnar <mingo@redhat.com>, Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        John Kacur <jkacur@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V5 06/20] trace/osnoise: Allow multiple instances of the
 same tracer
Message-ID: <20211025220856.7fef7581@rorschach.local.home>
In-Reply-To: <69cbbd98cce2515c84127c8827d733dc87b04823.1635181938.git.bristot@kernel.org>
References: <cover.1635181938.git.bristot@kernel.org>
        <69cbbd98cce2515c84127c8827d733dc87b04823.1635181938.git.bristot@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 25 Oct 2021 19:40:31 +0200
Daniel Bristot de Oliveira <bristot@kernel.org> wrote:

>  kernel/trace/trace_osnoise.c | 101 +++++++++++++++++++++++++++--------
>  1 file changed, 78 insertions(+), 23 deletions(-)
> 
> diff --git a/kernel/trace/trace_osnoise.c b/kernel/trace/trace_osnoise.c
> index 3db506f49a90..8681ffc3817b 100644
> --- a/kernel/trace/trace_osnoise.c
> +++ b/kernel/trace/trace_osnoise.c
> @@ -64,6 +64,24 @@ static bool osnoise_has_registered_instances(void)
>  					list);
>  }
>  
> +/*
> + * osnoise_instance_registered - check if a tr is already registered
> + */
> +static int osnoise_instance_registered(struct trace_array *tr)
> +{
> +	struct osnoise_instance *inst;
> +	int found = 0;
> +
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(inst, &osnoise_instances, list) {
> +		if (inst->tr == tr)
> +			found = 1;
> +	}
> +	rcu_read_unlock();
> +
> +	return found;
> +}
> +
>  /*
>   * osnoise_register_instance - register a new trace instance
>   *
> @@ -2048,6 +2066,16 @@ static int osnoise_workload_start(void)
>  {
>  	int retval;
>  
> +	/*
> +	 * Instances need to be registered after calling workload
> +	 * start. Hence, if there is already an instance, the
> +	 * workload was already registered. Otherwise, this
> +	 * code is on the way to register the first instance,
> +	 * and the workload will start.
> +	 */
> +	if (osnoise_has_registered_instances())
> +		return 0;

Looking at how this is checked before being called, it really should
return -1, as it is an error if this is called with instances active.

-- Steve

> +
>  	osn_var_reset_all();
>  
>  	retval = osnoise_hook_events();
> @@ -2075,6 +2103,13 @@ static int osnoise_workload_start(void)
>   */
>  static void osnoise_workload_stop(void)
>  {
> +	/*
> +	 * Instances need to be unregistered before calling
> +	 * stop. Hence, if there is a registered instance, more
> +	 * than one instance is running, and the workload will not
> +	 * yet stop. Otherwise, this code is on the way to disable
> +	 * the last instance, and the workload can stop.
> +	 */
>  	if (osnoise_has_registered_instances())
>  		return;
>  
> @@ -2096,7 +2131,11 @@ static void osnoise_tracer_start(struct trace_array *tr)
>  {
>  	int retval;
>  
> -	if (osnoise_has_registered_instances())
> +	/*
> +	 * If the instance is already registered, there is no need to
> +	 * register it again.
> +	 */
> +	if (osnoise_instance_registered(tr))
>  		return;
>  
>  	retval = osnoise_workload_start();

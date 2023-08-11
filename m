Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CF5CEB64DD
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Aug 2023 05:30:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbjHKFaQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Aug 2023 01:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjHKFaQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Aug 2023 01:30:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE04272D
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Aug 2023 22:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26BE360EF8
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Aug 2023 05:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C978C433C8;
        Fri, 11 Aug 2023 05:30:13 +0000 (UTC)
Date:   Fri, 11 Aug 2023 01:30:12 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ross Zwisler <zwisler@google.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH 6/6] libtraceeval samples: Update task-eval to use the
 histogram logic
Message-ID: <20230811013012.2528a864@gandalf.local.home>
In-Reply-To: <20230810202838.GB1961992@google.com>
References: <20230809031313.1298605-1-rostedt@goodmis.org>
        <20230809031313.1298605-7-rostedt@goodmis.org>
        <20230810202838.GB1961992@google.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 10 Aug 2023 14:28:38 -0600
Ross Zwisler <zwisler@google.com> wrote:

> On Tue, Aug 08, 2023 at 11:13:13PM -0400, Steven Rostedt wrote:
> > From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> > 
> > Convert task-eval over to the new API.
> > 
> > Note, it still requires some functions for displaying the output, but
> > those were added just as stubs to get an idea on how to use it.
> > 
> > Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> > ---
> >  include/traceeval-hist.h |   1 +
> >  samples/Makefile         |   2 +-
> >  samples/task-eval.c      | 683 ++++++++++++++++++++++-----------------
> >  3 files changed, 388 insertions(+), 298 deletions(-)
> > 
> > diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
> > index b3427c662d99..c363444f7fae 100644
> > --- a/include/traceeval-hist.h
> > +++ b/include/traceeval-hist.h  
> <>
> > @@ -111,28 +192,45 @@ static void update_process(struct task_data *tdata, const char *comm,
> >  			   enum sched_state state, enum command cmd,
> >  			   unsigned long long ts)  
> 
> update_process(), update_cpu() and update_thread() are all pretty much the
> same, and I think you could combine them if you wanted.  Just create a generic
> 'update' that takes keys & vals & a pair of 'struct traceval' pointers, one
> for start data and one for delta data.  That also relies on the fact that the
> TS always comes first in 'vals'.  Up to you if that's cleaner or not.

I did actually create a struct teval_pair because I was getting confused ;-)

But I do agree, some of this can be consolidated a bit more. Right now,
this is just a bare minimum switch from the old logic to the new so that I
can make sure they produce the same output.

> 
> >  {
> > -	struct traceeval_key keys[] = {
> > +	union traceeval_data keys[] = {
> >  		{
> > -			.type = TRACEEVAL_TYPE_STRING,
> > -			.string = comm,
> > +			.cstring	= comm,
> >  		},
> >  		{
> > -			.type = TRACEEVAL_TYPE_NUMBER,
> > -			.number = state,
> > +			.number		= state,
> > +		},
> > +	};
> > +	union traceeval_data vals[] = {
> > +		{
> > +			.number_64	= ts,
> > +		},
> > +		{
> > +			.number		= (long)NULL, /* data */
> >  		}
> >  	};
> > +	union traceeval_data *results;
> > +	unsigned long long delta;
> >  	int ret;
> >  
> >  	switch (cmd) {
> >  	case START:
> > -		ret = traceeval_n_start(tdata->teval_processes, keys, ts);
> > +		ret = traceeval_insert(tdata->teval_processes_start, keys, vals);
> >  		if (ret < 0)
> >  			pdie("Could not start process");
> >  		return;
> >  	case STOP:
> > -		ret = traceeval_n_stop(tdata->teval_processes, keys, ts);
> > +		ret = traceeval_query(tdata->teval_processes_start, keys, &results);
> > +		if (ret < 0)
> > +			return;
> > +
> > +		delta = ts - results[0].number_64;
> > +		results[0].number_64 = delta;
> > +
> > +		ret = traceeval_insert(tdata->teval_processes, keys, results);
> >  		if (ret < 0)
> >  			pdie("Could not stop process");
> > +
> > +		traceeval_results_release(tdata->teval_processes_start, results);
> >  		return;
> >  	}
> >  }  
> <>
> > @@ -283,32 +421,15 @@ static struct tep_format_field *get_field(struct tep_event *event, const char *n
> >  
> >  static void init_process_data(struct process_data *pdata)
> >  {
> > -	struct traceeval_key_info cpu_info[] = {
> > -		{
> > -			.type = TRACEEVAL_TYPE_NUMBER,
> > -			.name = "CPU",
> > -		},
> > -		{
> > -			.type = TRACEEVAL_TYPE_NUMBER,
> > -			.name = "Schedule state",
> > -		}
> > -	};
> > -	struct traceeval_key_info thread_info[] = {
> > -		{
> > -			.type = TRACEEVAL_TYPE_NUMBER,
> > -			.name = "TID",
> > -		},
> > -		{
> > -			.type = TRACEEVAL_TYPE_NUMBER,
> > -			.name = "Schedule state",
> > -		}
> > -	};
> >  
> > -	pdata->teval_cpus = traceeval_2_alloc("CPUs", cpu_info);
> > +	pdata->teval_cpus = traceeval_init(cpu_keys, timestamp_vals);
> > +	if (!pdata->teval_cpus)
> > +		pdie("Creating trace eval");
> > +	pdata->teval_cpus = traceeval_init(cpu_keys, timestamp_vals);
> >  	if (!pdata->teval_cpus)
> >  		pdie("Creating trace eval");  
> 
> We're initializing pdata->teval_cpus twice - I'm guessing one of these wants to
> be pdata->teval_cpus_start?

Good catch. I also caught it when I started working back on it.

> 
> >  
> > -	pdata->teval_threads = traceeval_2_alloc("Threads", thread_info);
> > +	pdata->teval_threads = traceeval_init(thread_keys, timestamp_vals);
> >  	if (!pdata->teval_threads)
> >  		pdie("Creating trace eval");  
> 
> Missing init of pdata->teval_threads_start?

Yep.

new patches in a bit. (now I can go to bed!)

-- Steve

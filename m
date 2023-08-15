Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BEC6C001E0
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Aug 2023 20:56:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233939AbjHOU4O (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Aug 2023 16:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236478AbjHOUzr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Aug 2023 16:55:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2025FE3
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Aug 2023 13:55:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A34E6623B5
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Aug 2023 20:55:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 996E6C433C8;
        Tue, 15 Aug 2023 20:55:44 +0000 (UTC)
Date:   Tue, 15 Aug 2023 16:55:45 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ross Zwisler <zwisler@google.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH v2 10/17] libtraceeval histogram: Add updating of stats
Message-ID: <20230815165545.1d713ba8@gandalf.local.home>
In-Reply-To: <20230815202554.GF780024@google.com>
References: <20230811053940.1408424-1-rostedt@goodmis.org>
        <20230811053940.1408424-11-rostedt@goodmis.org>
        <20230815202554.GF780024@google.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 15 Aug 2023 14:25:54 -0600
Ross Zwisler <zwisler@google.com> wrote:

> On Fri, Aug 11, 2023 at 01:39:33AM -0400, Steven Rostedt wrote:
> > From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> > 
> > Whenever an entry is added that already exists (overwriting the values)
> > keep track of the stats for the number values (max, min, total, count).
> > 
> > Also move the stat structure out of the public view. We may want to modify
> > this structure in the future, and so it should not become an API.
> > 
> > Add accessor functions to get to the stat values.
> > 
> > Add traceeval_stat() to acquire a stat handle from a specific key for a
> > specific value.
> > 
> > Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> > ---
> >  include/traceeval-hist.h |  17 ++--
> >  src/eval-local.h         |   9 ++
> >  src/histograms.c         | 182 +++++++++++++++++++++++++++++++++++----
> >  3 files changed, 183 insertions(+), 25 deletions(-)
> > 
> > diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
> > index 1c02f3039809..d061a4532b06 100644
> > --- a/include/traceeval-hist.h
> > +++ b/include/traceeval-hist.h
> > @@ -130,13 +130,7 @@ struct traceeval_type {
> >  };
> >  
> >  /* Statistics about a given entry element */
> > -struct traceeval_stat {
> > -	unsigned long long	max;
> > -	unsigned long long	min;
> > -	unsigned long long	total;
> > -	unsigned long long	avg;
> > -	unsigned long long	std;
> > -};
> > +struct traceeval_stat;
> >  
> >  /* Iterator over aggregated data */
> >  struct traceeval_iterator;
> > @@ -160,4 +154,13 @@ int traceeval_query(struct traceeval *teval, const union traceeval_data *keys,
> >  void traceeval_results_release(struct traceeval *teval,
> >  			       union traceeval_data *results);
> >  
> > +struct traceeval_stat *traceeval_stat(struct traceeval *teval,
> > +				      const union traceeval_data *keys,
> > +				      struct traceeval_type *type);
> > +
> > +unsigned long long traceeval_stat_max(struct traceeval_stat *stat);
> > +unsigned long long traceeval_stat_min(struct traceeval_stat *stat);
> > +unsigned long long traceeval_stat_total(struct traceeval_stat *stat);
> > +unsigned long long traceeval_stat_count(struct traceeval_stat *stat);
> > +
> >  #endif /* __LIBTRACEEVAL_HIST_H__ */
> > diff --git a/src/eval-local.h b/src/eval-local.h
> > index 820d7ad096e8..190b19db14d2 100644
> > --- a/src/eval-local.h
> > +++ b/src/eval-local.h
> > @@ -45,11 +45,20 @@ struct hash_table {
> >  	struct hash_iter	iter;
> >  };
> >  
> > +struct traceeval_stat {
> > +	unsigned long long	max;
> > +	unsigned long long	min;
> > +	unsigned long long	total;
> > +	unsigned long long	std;
> > +	size_t			count;
> > +};
> > +
> >  /* A key-value pair */
> >  struct entry {
> >  	struct hash_item	hash;
> >  	union traceeval_data	*keys;
> >  	union traceeval_data	*vals;
> > +	struct traceeval_stat	*val_stats;  
> 
> I'm confused about why 'val_stats' is in 'struct entry', instead of in
> 'struct traceeval'?
> 
> I would think that we'd want to keep our stats on a per-histogram basis, where
> we have an array of 'struct traceeval_stat' structs with the same size as our
> 'val_types' array, so that for a given compound value, say 
> 
> { TRACEVAL_TYPE_NUMBER_64, TRACEEVAL_TYPE_NUMBER_16, TRACEEVAL_NUMBER_8}
> 
> we'd have stats for each of these entries, like min, max, average, etc.?
> 
> With the stats associated with each entry, I don't see how we keep all the
> stats for all the entries up to date as we do insertions & removals.

Because the stats are for each key, not the total of the traceeval. If you
look at the code in task-eval, I want to know the max,min,total,count,avg
of the sleep time for a task when it is blocked, when it is sleeping, when
it is running, etc:

Task: migrate
      Total run time (us):       4645364
      Total blocked time (us):         0
      Total preempt time (us):     98540
      Total sleep time (us):      115559

    thread id: 1884
      Total run time (us):           808

    thread id: 1885
      Total run time (us):       2920763
      Total preempt time (us):    245570
      Total sleep time (us):   224289277

    thread id: 1886
      Total run time (us):       3601375
      Total preempt time (us):   1308185
      Total sleep time (us):    12692630

    thread id: 1887
      Total run time (us):       3740300
      Total preempt time (us):   2620102
      Total sleep time (us):     4806722

That "Task: migrate" is just one entry in the traceeval, the threads are
entries in the nested traceeval that is saved per task.

Actually, task-eval is only looking at the total time, but I could easily
add the max/min/avg times too. If I were to write a latency program, and
was tracing the wake up latency of a task, you probably want these stats
for each key, so I can see the max latency per task, and not just the total
for all tasks.

-- Steve

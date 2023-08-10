Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F032C001DE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Aug 2023 20:28:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235122AbjHJU2n (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Aug 2023 16:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234901AbjHJU2n (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Aug 2023 16:28:43 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D0D2735
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Aug 2023 13:28:43 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id ca18e2360f4ac-7910620f45dso47131539f.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Aug 2023 13:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691699322; x=1692304122;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2n3mUxQxxwyCVQd+Hd4xG3TBKblnI8N/OL5cdK/BABc=;
        b=hdhsaTm2X6/a5fSzlImMsMBU7gV3Nkb7GnDMC3lruWn0avCXKFpTzs/uttv3RroYhR
         ejpi4C3cmij2sBPimiKAJJ6afUaQwJOwKqoWAty5ggauTS1bjoLc7ebHtjU5kkcQhx5R
         LUb35OFYkoqOzimSkDbrJ1xuoCEsXfRUBge0msmaYNgDxTKPYFAvW6Q8jwunSVB7+87x
         0OqDCaGfsuWcp03yKaRP8ccL/MFb1vaG1/1hGIJRJHNJ+zUPo+BTc9nT1+K0w29rmv0V
         QSajs58nMR1e+mlxjNUoMrMwHw6Yf+xAz2ZahmL9IeEflJwlA16JJl4U9a3iJtsQu5c7
         Stfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691699322; x=1692304122;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2n3mUxQxxwyCVQd+Hd4xG3TBKblnI8N/OL5cdK/BABc=;
        b=WC/w74xw1J012O+vj2JCLHaqesDe5VLnc3877nrstquQXREI+AgNtWsiWyFrt0+cHh
         aXs5dShAAeUHEmixHgBlxscDkOqPfwKU1CQvx74YdFpZ7aw6T8+XpfSi0zAXozOKatEV
         2SFzJqJXQEXcPl3dXBPvtRgoFFSobqNDg5S31//NDp1jKCwfD/GsRMQpIfBVWs06/D/w
         paLSwjqjzxK0WMY9npUTvV7tCqV5XBtW0djKh62nXIFbfC/X/nPHKMzWSB9156ymq0jr
         gvRh1jq06Z5si44ralUPQZoNUlvZItVRClRrDZx4NwBl/kou5jshcgKru3SPGM4SDWeN
         lvqA==
X-Gm-Message-State: AOJu0YxINOjb+oyQhKq2H7G4NBmfRvqC/AvcUnEVNLqMobenhOyP0Zbm
        4eBJLBzZSLGUMmWi6yMYMr5IuA==
X-Google-Smtp-Source: AGHT+IG4fB8k4F4NsE8M5PzQEy2sUdTX0erbplVZwZu3KwXJtRi+dm0rZO2k4jrZpgMtzOT8/agziA==
X-Received: by 2002:a05:6e02:1d9a:b0:348:9e12:13f8 with SMTP id h26-20020a056e021d9a00b003489e1213f8mr4917746ila.27.1691699322203;
        Thu, 10 Aug 2023 13:28:42 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:b3b8:373d:6e9f:f058])
        by smtp.gmail.com with ESMTPSA id q13-20020a02a30d000000b00430979b6aa5sm618316jai.0.2023.08.10.13.28.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Aug 2023 13:28:41 -0700 (PDT)
Date:   Thu, 10 Aug 2023 14:28:38 -0600
From:   Ross Zwisler <zwisler@google.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH 6/6] libtraceeval samples: Update task-eval to use the
 histogram logic
Message-ID: <20230810202838.GB1961992@google.com>
References: <20230809031313.1298605-1-rostedt@goodmis.org>
 <20230809031313.1298605-7-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230809031313.1298605-7-rostedt@goodmis.org>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Aug 08, 2023 at 11:13:13PM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Convert task-eval over to the new API.
> 
> Note, it still requires some functions for displaying the output, but
> those were added just as stubs to get an idea on how to use it.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  include/traceeval-hist.h |   1 +
>  samples/Makefile         |   2 +-
>  samples/task-eval.c      | 683 ++++++++++++++++++++++-----------------
>  3 files changed, 388 insertions(+), 298 deletions(-)
> 
> diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
> index b3427c662d99..c363444f7fae 100644
> --- a/include/traceeval-hist.h
> +++ b/include/traceeval-hist.h
<>
> @@ -111,28 +192,45 @@ static void update_process(struct task_data *tdata, const char *comm,
>  			   enum sched_state state, enum command cmd,
>  			   unsigned long long ts)

update_process(), update_cpu() and update_thread() are all pretty much the
same, and I think you could combine them if you wanted.  Just create a generic
'update' that takes keys & vals & a pair of 'struct traceval' pointers, one
for start data and one for delta data.  That also relies on the fact that the
TS always comes first in 'vals'.  Up to you if that's cleaner or not.

>  {
> -	struct traceeval_key keys[] = {
> +	union traceeval_data keys[] = {
>  		{
> -			.type = TRACEEVAL_TYPE_STRING,
> -			.string = comm,
> +			.cstring	= comm,
>  		},
>  		{
> -			.type = TRACEEVAL_TYPE_NUMBER,
> -			.number = state,
> +			.number		= state,
> +		},
> +	};
> +	union traceeval_data vals[] = {
> +		{
> +			.number_64	= ts,
> +		},
> +		{
> +			.number		= (long)NULL, /* data */
>  		}
>  	};
> +	union traceeval_data *results;
> +	unsigned long long delta;
>  	int ret;
>  
>  	switch (cmd) {
>  	case START:
> -		ret = traceeval_n_start(tdata->teval_processes, keys, ts);
> +		ret = traceeval_insert(tdata->teval_processes_start, keys, vals);
>  		if (ret < 0)
>  			pdie("Could not start process");
>  		return;
>  	case STOP:
> -		ret = traceeval_n_stop(tdata->teval_processes, keys, ts);
> +		ret = traceeval_query(tdata->teval_processes_start, keys, &results);
> +		if (ret < 0)
> +			return;
> +
> +		delta = ts - results[0].number_64;
> +		results[0].number_64 = delta;
> +
> +		ret = traceeval_insert(tdata->teval_processes, keys, results);
>  		if (ret < 0)
>  			pdie("Could not stop process");
> +
> +		traceeval_results_release(tdata->teval_processes_start, results);
>  		return;
>  	}
>  }
<>
> @@ -283,32 +421,15 @@ static struct tep_format_field *get_field(struct tep_event *event, const char *n
>  
>  static void init_process_data(struct process_data *pdata)
>  {
> -	struct traceeval_key_info cpu_info[] = {
> -		{
> -			.type = TRACEEVAL_TYPE_NUMBER,
> -			.name = "CPU",
> -		},
> -		{
> -			.type = TRACEEVAL_TYPE_NUMBER,
> -			.name = "Schedule state",
> -		}
> -	};
> -	struct traceeval_key_info thread_info[] = {
> -		{
> -			.type = TRACEEVAL_TYPE_NUMBER,
> -			.name = "TID",
> -		},
> -		{
> -			.type = TRACEEVAL_TYPE_NUMBER,
> -			.name = "Schedule state",
> -		}
> -	};
>  
> -	pdata->teval_cpus = traceeval_2_alloc("CPUs", cpu_info);
> +	pdata->teval_cpus = traceeval_init(cpu_keys, timestamp_vals);
> +	if (!pdata->teval_cpus)
> +		pdie("Creating trace eval");
> +	pdata->teval_cpus = traceeval_init(cpu_keys, timestamp_vals);
>  	if (!pdata->teval_cpus)
>  		pdie("Creating trace eval");

We're initializing pdata->teval_cpus twice - I'm guessing one of these wants to
be pdata->teval_cpus_start?

>  
> -	pdata->teval_threads = traceeval_2_alloc("Threads", thread_info);
> +	pdata->teval_threads = traceeval_init(thread_keys, timestamp_vals);
>  	if (!pdata->teval_threads)
>  		pdie("Creating trace eval");

Missing init of pdata->teval_threads_start?

>  }

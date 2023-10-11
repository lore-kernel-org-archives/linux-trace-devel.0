Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B8D249FE
	for <linux-trace-devel@vger.kernel.org>; Wed, 11 Oct 2023 23:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4C1C433C8;
	Wed, 11 Oct 2023 23:07:55 +0000 (UTC)
Date: Wed, 11 Oct 2023 19:09:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ross Zwisler <zwisler@google.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtraceeval: Add traceeval_stat_max/min_timestamp()
 API
Message-ID: <20231011190917.1d57a7e9@gandalf.local.home>
In-Reply-To: <20231011222100.GA94116@google.com>
References: <20231005181448.176e9563@gandalf.local.home>
	<20231011222100.GA94116@google.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 11 Oct 2023 16:21:00 -0600
Ross Zwisler <zwisler@google.com> wrote:

> On Thu, Oct 05, 2023 at 06:14:48PM -0400, Steven Rostedt wrote:
> > From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> > 
> > If a value field is flagged as a TIMESTAMP, and another field is flagged
> > as a STAT, have the statistics for the STAT field automatically keep track
> > of when the max and min happened (what the TIMESTAMP field was at those
> > instances).  
> 
> I'm confused as to why we have TRACEEVAL_FL_TIMESTAMP and a separate data
> entry with that flag, instead of only storing the timestamp in the entry
> metadata, as we do with the other STATs?

Actually, I may remove this part entirely, as it's pretty much superseded
by the TRACEEVAL_TYPE_DELTA, which I moved to, and haven't needed the
separate val marked for the timestamp.

> 
> >From the description above where we have one TIMESTAMP and one STAT, I would  
> expect to see structures defined like this
> (from [PATCH v2] libtraceeval: Add wake-lat sample code):
> 
> +struct traceeval_type sched_vals[] = {
> +       {
> +               .name           = "timestamp",
> +               .flags          = TRACEEVAL_FL_TIMESTAMP,
> +               .type           = TRACEEVAL_TYPE_NUMBER_64,
> +       },
> +       {
> +               .name           = "delta",
> +               .flags          = TRACEEVAL_FL_STAT,
> +               .type           = TRACEEVAL_TYPE_NUMBER_64,
> +       }
> 
> where the timestamp is sync'd with the STAT min and max, right?

The new type is done like:

	{
		.name		= "delta",
		.type		= TRACEEVAL_TYPE_DELTA,
	}

Which will automatically be marked as STAT flag, and is set with:

	TRACEEVAL_SET_DELTA(vals, delta, timestamp);

Is that what you are thinking about?

-- Steve



> 
> But we also have this:
> 
> +struct traceeval_type wakeup_vals[] = {
> +       {
> +               .name           = "timestamp",
> +               .flags          = TRACEEVAL_FL_TIMESTAMP,
> +               .type           = TRACEEVAL_TYPE_NUMBER_64,
> +       }
> +};
> 
> in a structure that doesn't have a corresponding STAT field?  This is also
> confusing to me because we need to keep 2 values (min and max TS), but this
> only holds one?
> 
> The timestamp is already stored independently in the stat metadata in
> struct traceeval_stat:
> 
> >  struct traceeval_stat {
> >  	unsigned long long	max;
> > +	unsigned long long	max_ts;
> >  	unsigned long long	min;
> > +	unsigned long long	min_ts;
> >  	unsigned long long	total;
> >  	unsigned long long	std;
> >  	size_t			count;  
> 
> which I think is enough?
> 
> It seems like instead we really want our two flags to be:
> 
> TRACEEVAL_FL_STAT
> and
> TRACEEVAL_FL_STAT_TS
> 
> where the first just keeps the normal stats (min, max, average, std. dev, etc)
> and the second does all that plus timestamps for min and max?
> 
> This would also allow you to keep min and max stats independently for multiple
> entries in a single structure, i.e.:
> 
> struct traceeval_type task_vals[] = {
>        {
>                .name           = "wake_delay",
>                .flags          = TRACEEVAL_FL_STAT_TS,
>                .type           = TRACEEVAL_TYPE_NUMBER_64,
>        },
>        {
>                .name           = "runtime",
>                .flags          = TRACEEVAL_FL_STAT_TS,
>                .type           = TRACEEVAL_TYPE_NUMBER_64,
>        }
> };
> 
> which I don't think is possible under the current scheme?
> 
> What am I missing?


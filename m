Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613BCBA25
	for <linux-trace-devel@vger.kernel.org>; Fri,  2 Feb 2024 02:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706840244; cv=none; b=qsmxAdnszvrrRM/TdglupsfM+nYQlBOMgGxxoB0WfHXyjIWPMs2skSUoYKhbf0172FsrdEDnm8mqkNGM9eupWRnbnvBxaZvzGZFZLdztUlEwlxPg09csahfwcvv8kl6j/Si5xYQ6P5R/N+qCmXhKivFTQt5vyWdqRTcen1+An5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706840244; c=relaxed/simple;
	bh=R5GLYWhzxhM6KrnwSc9ZSbLFC6+d8d3wCu6QIQL8ROs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UemYpvV6plDG9dm3qmOHwrxjKaGkpN38/pSYCtOpIm3FrRehlf0GhoBp7pGTiwdMmTxPISCQWwu+yaqryqQ34Artu5airMcEWZnV6sB2wnM4ajQkOpFPdZpZUOCNHB9b/nYVbBmEKz7VZ+EpQlw1mEFs9pQbP4BcmCMfjhL5s5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A077C433C7;
	Fri,  2 Feb 2024 02:17:23 +0000 (UTC)
Date: Thu, 1 Feb 2024 21:17:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Pierre Gondois <pierre.gondois@arm.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v3 4/5] trace-cmd split: Enable support for buffer
 selection
Message-ID: <20240201211740.33b43bcd@gandalf.local.home>
In-Reply-To: <eb976812-06e9-4a0a-93d1-1868ee9d19e1@arm.com>
References: <20240123134215.385415-1-pierre.gondois@arm.com>
	<20240123134215.385415-5-pierre.gondois@arm.com>
	<20240124173740.6d9e2287@gandalf.local.home>
	<1122630e-838e-49fc-9210-55834129088c@arm.com>
	<20240125112834.2de4eedb@gandalf.local.home>
	<20240125115147.51bcce2a@gandalf.local.home>
	<20240125121025.208a7012@gandalf.local.home>
	<eb976812-06e9-4a0a-93d1-1868ee9d19e1@arm.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 26 Jan 2024 09:54:53 +0100
Pierre Gondois <pierre.gondois@arm.com> wrote:

> Hello Steven,
> 

Hi Pierre,

Sorry for the late reply. I've been putting out fires (you can read LWN or
The Register to see what exactly I was doing).

> On 1/25/24 18:10, Steven Rostedt wrote:
> > On Thu, 25 Jan 2024 11:51:47 -0500
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> >   
> >> Now if I had had:
> >>
> >>    trace-cmd split -i /work/traces/trace-tast.dat --top  -B tast -o /tmp/trace-tast2.dat
> >>
> >> Then because there was a command "--top" before the -B but it had no -o
> >> assigned for it, then the input_file would be considered the output file
> >> and that should act like you described.  
> > 
> > Of course then things get confusing if we were to have:
> > 
> > trace-cmd split -i /work/traces/trace-tast.dat  -B foo -o /tmp/trace-foo.dat -B bar
> > 
> > We could specify that each -B will just use the top level by default. So
> > the above would create:
> > 
> >   /tmp/trace-foo.dat
> > 
> > With the instance "foo"
> > 
> > But the "bar" would be in:
> > 
> >   /work/traces/trace-tast.dat.bar
> > 
> > because the top level didn't specify a -o.
> > 
> > So to make it more specific. Each -B will default to the toplevel output
> > with ".<instance>" appended to it.
> > 
> > That is:
> > 
> >    split <top-level-commands> -B instance1 <instance1-commands> -B <instance2-commands>
> > 
> > If a -o is specified in the <top-level-commands> it becomes the default top
> > level output file.  If a -o is not specified in any of the
> > <instance*-commands> then, it will default to the top level output file
> > with ".<instance-name>" attached to it unless it has its own -o specified.  
> 
> I also wanted to handle the case where multiple instances could be placed
> in an output file. Meaning that with the patches:
> - -B/--top options are parsed to select the instances to keep,
> - a -o option ends the parsing of instances and place them in the given output
>    file. If no -o option is parsed, then the default output file or the input
>    file is used as a base name for the last generated output file (i.e. trace.dat.1
>    if no input file is specified)

OK, I see what you want. You want to be able to have multiple buffers in a
single file.

> 
> ---
> 
> For example, with a trace recorded with:
> 	$ trace-cmd record -e sched_wakeup -B switch_instance -e sched_switch -B timer_instance -e timer
> 
> Creating a test.dat file containing the top instance and
> the switch_instance:
> 	$ trace-cmd split --top -B switch_instance -o test.dat
> 
> Creating a test.dat file containing the switch_instance as
> the top instance, and the initial top instance as an instance
> named 'old_top':
> 	$ trace-cmd split -B switch_instance --top=old_top -o test.dat
> 
> Splitting all instances in different .dat files:
> 	$ trace-cmd split --top -o top.dat -B switch_instance -o switch.dat -B timer_instance -o timer.dat
> 
> And by default, if no -B/--top is specified for an output file,
> keep all the instances (but of course all the other options provided
> to the split command are applied, i.e. start/end timings):
> Keep all the instances and place them in test.dat:
> 	$ trace-cmd split -o test.dat
> Keep all the instances and place them in the default file trace.dat.1:
> 	$ trace-cmd split
> 
> ---
> 
> Maybe the list of generated files should be printed to avoid what happened
> to you, i.e. generating files that were not expected.
> I think that having a default name with a suffix being the top instance
> is a good idea, but I don't think it would be possible to parse the command
> line to have 2 instances in one file in such case.
> 
> > 
> > For multi-file splits, it will append ".0001", ".0002", etc to that file.

So what I'm thinking is that the -B buffers default to the same buffer as
the top buffer unless specified differently.

Here's what I think would work. We add four new options.

 --top
 -B <instance>
 -t
 -b

Where --top represents the "top" instance.

-B represents the <instance>

-t can be used after -B to make it a top instance.

-b can be used before any -B to make the top instance into its own instance.

Rules:

  --top can not come after -B.
  -t must come after -B
  -b must come before -B

There can only be one top instance, and all named instances must be unique.
That is, you can't have two instances called "foo". 

We have: trace-cmd split <TOP_COMMANDS> <INSTANCE_COMMANDS>

  TOP_COMMANDS :: nil | TOP_PARAMS

  INSTANCE_COMMANDS :: nil | -B name INSTANCE_PARAMS INSTANCE_COMMANDS

  TOP_PARAMS :: nil | TOP_OPTIONS TOP_PARAMS

  TOP_OPTIONS :: --top | -b name | -o file

  INSTANCE_PARAMS :: nil | INSTANCE_OPTIONS INSTANCE_PARAMS

  INSTANCE_OPTIONS :: nil | -t | -o file

Examples:

 trace-cmd split --top -B foo

Will make a trace.dat.1 that has top and foo in it.

 trace-cmd split --top

Will make a trace.dat.1 that only has the top instance

 trace-cmd split -B foo

Will make a trace.dat.1 that only has foo in it.

 trace-cmd split -B foo -t

Will make a trace.dat.1 that only has foo in it. It will also promote the
instance foo to the top instance (it will lose its "foo" name).

 trace-cmd split --top -o buba.dat -B foo

Will create a buba.dat that has both top and foo in it

 trace-cmd split --top -B foo -o buba.dat

Will create a trace-dat.1 with just top in it, and buba.dat with just foo
in it.

 trace-cmd split --top -B foo -o buba.dat -t

Will create a trace-dat.1 with just top in it, and buba.dat with just foo
in it (promoting foo to top instance)

 trace-cmd split --top -b foo -B foo -t

Will make a trace.dat.1 file where the top instance becomes "foo" and the
foo instance becomes the top instance.

  trace-cmd split -o buba.dat -B foo -t

Will create just a buba.dat file with only foo in it, promoting it as the
top instance.

  trace-cmd split -o buba.dat --top -B foo -o fooba.dat

Will create a buba.dat with just the top instance in it (note --top can
come before or after -o and that does not make any difference, but the
order of -B and -o does matter). It will also create a fooba.dat file with
just foo in it.

  trace-cmd split --top -B foo -t -o fooba.dat -B bar

This will create a trace.dat.1 with the top instance and the bar instance,
but also make a fooba.dat file with just "foo", and promoting it as the top
instance.

  trace-cmd split --top -o buba.dat -B foo -o foobar.dat -B bar -o foobar.dat

This will make two files. One with buba.dat that holds the top instance,
and foobar.dat that holds both the foo and bar instances.

  trace-cmd split --top -o buba.dat -B foo -o foobar.dat -B bar -t -o foobar.dat

This will make two files. One with buba.dat that holds just the top
instance and a foobar.dat file that has both foo and bar, but bar gets
promoted to the top instance.

Does that make sense?

-- Steve

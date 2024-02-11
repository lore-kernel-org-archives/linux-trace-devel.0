Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83DA4171A0
	for <linux-trace-devel@vger.kernel.org>; Sun, 11 Feb 2024 23:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707694561; cv=none; b=KvGB2nTMIKWXeCSDHDaZW7dyM0ovFjHdOropnPdUTiuvDVATn+mq6lfUW13o3guxJH4kgQBsh1ThrlQ/ODF58sLUP4uPKuLvN0UD1yXVlcENe7UCavrNYOJTPDMsTWjh51rkgRqK0ZKvyCAXjexSkwOTYmisUOwDAygzENcvG0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707694561; c=relaxed/simple;
	bh=hm3EgsMQ8u2/UNXsTIIlbDqde7LAoByr+b1iVUtyJW4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Of0glIs4N0ZjIMyGtjTiHiGOs7Dudbg4DhWavqEyl3ywAEJsVPlV1CtjJV9ZfB3EQJnEMSVzAFcHYUpChHG6cmy06dAy6AtxQA5pW7D7GuEBJzxnwIVM1QpjnMUbutaAA9N+5uGP95b6kjIoUBTzktchMLPxUw5ErwaXuTTF6YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F85C433F1;
	Sun, 11 Feb 2024 23:36:00 +0000 (UTC)
Date: Sun, 11 Feb 2024 18:35:53 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Pierre Gondois <pierre.gondois@arm.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v3 4/5] trace-cmd split: Enable support for buffer
 selection
Message-ID: <20240211183553.6976670f@rorschach.local.home>
In-Reply-To: <13355fbc-7592-4a54-8e92-e3d78afa83ae@arm.com>
References: <20240123134215.385415-1-pierre.gondois@arm.com>
	<20240123134215.385415-5-pierre.gondois@arm.com>
	<20240124173740.6d9e2287@gandalf.local.home>
	<1122630e-838e-49fc-9210-55834129088c@arm.com>
	<20240125112834.2de4eedb@gandalf.local.home>
	<20240125115147.51bcce2a@gandalf.local.home>
	<20240125121025.208a7012@gandalf.local.home>
	<eb976812-06e9-4a0a-93d1-1868ee9d19e1@arm.com>
	<20240201211740.33b43bcd@gandalf.local.home>
	<13355fbc-7592-4a54-8e92-e3d78afa83ae@arm.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 5 Feb 2024 14:38:38 +0100
Pierre Gondois <pierre.gondois@arm.com> wrote:
 > 
> > So what I'm thinking is that the -B buffers default to the same buffer as
> > the top buffer unless specified differently.
> > 
> > Here's what I think would work. We add four new options.
> > 
> >   --top
> >   -B <instance>
> >   -t
> >   -b
> > 
> > Where --top represents the "top" instance.
> > 
> > -B represents the <instance>
> > 
> > -t can be used after -B to make it a top instance.
> > 
> > -b can be used before any -B to make the top instance into its own instance.  
> 
> This set of parameters sounds good to me.
> 
> > 
> > Rules:
> > 
> >    --top can not come after -B.
> >    -t must come after -B
> >    -b must come before -B  
> 
> IIUC, these rules are described in the syntax below.
> 
> > 
> > There can only be one top instance, and all named instances must be unique.
> > That is, you can't have two instances called "foo".
> > 
> > We have: trace-cmd split <TOP_COMMANDS> <INSTANCE_COMMANDS>
> > 
> >    TOP_COMMANDS :: nil | TOP_PARAMS
> > 
> >    INSTANCE_COMMANDS :: nil | -B name INSTANCE_PARAMS INSTANCE_COMMANDS
> > 
> >    TOP_PARAMS :: nil | TOP_OPTIONS TOP_PARAMS
> > 
> >    TOP_OPTIONS :: --top | -b name | -o file
> > 
> >    INSTANCE_PARAMS :: nil | INSTANCE_OPTIONS INSTANCE_PARAMS
> > 
> >    INSTANCE_OPTIONS :: nil | -t | -o file  
> 
> I think it might also be difficult to place the top instance in multiple output
> files (or the intention was to do it in multiple steps ?). For instance, from a
> trace containing a top instance and foo/bar instances, what would be the command
> to obtain:
> - a foo.dat file containing the top + foo instances
> - a bar.dat file containing the top + bar instances

Does that need to be done in a single command, or two commands?

  trace-cmd split --top -B foo
  trace-cmd split --top -B bar

?

> 
> If this was:
>    trace-cmd split --top -o foo.dat --top -o bar.dat -B foo -o foo.dat -B bar -o bar.dat
> I think it would be clearer to revolve around the output file:
>    trace-cmd split --top -B foo -o foo.dat --top -B bar -o bar.dat
> but this is open to debate.

My concern is that if we want to do that in one command it can cause
the code and parameters to become too complex. But I'm not against the
idea. I personally think that if we allow too much it may become too
confusing.

> 
> ---
> 
> Also, if one wants to place all the instance in one output.dat file, IIUC all the
> instances will have to be nominatively selected right ?
> 
> > 
> > Examples:
> > 
> >   trace-cmd split --top -B foo
> > 
> > Will make a trace.dat.1 that has top and foo in it.
> > 
> >   trace-cmd split --top
> > 
> > Will make a trace.dat.1 that only has the top instance
> > 
> >   trace-cmd split -B foo
> > 
> > Will make a trace.dat.1 that only has foo in it.
> > 
> >   trace-cmd split -B foo -t
> > 
> > Will make a trace.dat.1 that only has foo in it. It will also promote the
> > instance foo to the top instance (it will lose its "foo" name).
> > 
> >   trace-cmd split --top -o buba.dat -B foo
> > 
> > Will create a buba.dat that has both top and foo in it  
> 
>  From the syntax above, I would have thought that this would be parsed as:
> - <TOP_COMMANDS>: '--top -o buba.dat'
> - <INSTANCE_COMMANDS>: '-B foo'
> 
> and so that the 'foo' instance would end up in the default trace.dat.1
> as there is no output file specified.

No, I was saying that -B will default to the top file, not the default
file. If the top file is specified, then the -B will also be in that file.

> 
> > 
> >   trace-cmd split --top -B foo -o buba.dat
> > 
> > Will create a trace-dat.1 with just top in it, and buba.dat with just foo
> > in it.
> > 
> >   trace-cmd split --top -B foo -o buba.dat -t
> > 
> > Will create a trace-dat.1 with just top in it, and buba.dat with just foo
> > in it (promoting foo to top instance)
> > 
> >   trace-cmd split --top -b foo -B foo -t
> > 
> > Will make a trace.dat.1 file where the top instance becomes "foo" and the
> > foo instance becomes the top instance.
> > 
> >    trace-cmd split -o buba.dat -B foo -t  
> 
> I think this would be parsed (cf. the syntax above) as:
> - <TOP_COMMANDS>: '-o buba.dat'
> - <INSTANCE_COMMANDS>: '-B foo -t'
> 
> So there would be
> - a buba.dat file containing all the possible instances and the
>    top instance
> - a default trace.data.1 containing the foo instance as the top instance

Again, -o of the top file becomes the default for all the rest, unless
they specify their own output file.

-- Steve

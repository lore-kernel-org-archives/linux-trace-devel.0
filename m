Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359AC73177
	for <linux-trace-devel@vger.kernel.org>; Thu, 25 Jan 2024 16:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706200115; cv=none; b=hvvhAwmPRTgTzJmYmb54zWjP+SPp8rEzLF7yvdG5vBx/GgUxWje9hjHVOz34vmrZem4a0RBB4M1ubENTJ3WXmBTECxQQsS8G/ylzYe0TTx2gPCFPSlUF/pTniAmvnepGYCksmzlMHacJeP4wEuc4kDEYtoG1JNrQGu/t+Bmc/ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706200115; c=relaxed/simple;
	bh=k0+GVFodbaLxV3VTo6IM0XGjLu4XB0wcmMTZ8s8EAoo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cAF601UW9vYUhH+TsEWsSF00NxmfC92R0gyJVUn9CEn0Nt0tru+crhZxJtw/wF+R4BxEQ0UwdM++TMZEYBUriHioZO4TEXauwQqa4iFOeTpZ1nqtMg1mEbKypQ1Cf3ZaMcOlhMZgfc9kO/UsKIoVdSA7Pb5FRhJBk6Ff8upzMSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395EBC433C7;
	Thu, 25 Jan 2024 16:28:34 +0000 (UTC)
Date: Thu, 25 Jan 2024 11:28:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Pierre Gondois <pierre.gondois@arm.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v3 4/5] trace-cmd split: Enable support for buffer
 selection
Message-ID: <20240125112834.2de4eedb@gandalf.local.home>
In-Reply-To: <1122630e-838e-49fc-9210-55834129088c@arm.com>
References: <20240123134215.385415-1-pierre.gondois@arm.com>
	<20240123134215.385415-5-pierre.gondois@arm.com>
	<20240124173740.6d9e2287@gandalf.local.home>
	<1122630e-838e-49fc-9210-55834129088c@arm.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 25 Jan 2024 16:16:42 +0100
Pierre Gondois <pierre.gondois@arm.com> wrote:

> >> For example, with a trace recorded with:
> >>    $ trace-cmd record -e sched_wakeup -B switch_instance \
> >>      -e sched_switch -B timer_instance -e timer =20
> >=20
> > I tried this with a trace.dat file that has a instance called "tast" an=
d it
> > didn't work. Note, the top instance had no data.
> >=20
> >    $ trace-cmd split -i /work/traces/trace-tast.dat -o /tmp/trace-tast2=
.dat -B tast =20
>=20
> With this command, the expected behaviour should be:
> trace-tast2.dat:
> - Contains all the instances of the input trace-tast.dat file

Wait what? -i should *not* be used for output if -o is specified!

Now looking at it, I have a bunch of unwanted files in the /work/traces/
directory. That directory is only for traces that I took from test boxes
that I was debugging. All "split" output was suppose to go into /tmp!

> trace-tast.dat.1:
> - Contains the tast instance only, as the top instance

No, that makes no sense to me. The above is me saying:

 "I want to split out the 'tast' instance and make it the top level
 instance in trace-tast2.dat."

-i just mean "input source", and is only used if -o is not specified.

=46rom the man page of 'trace-cmd split'

 -i file
       If this option is not specified, then the split command will look
       for the file named trace.dat. This options will allow the reading of
       another file other than trace.dat.

  -o file
       By default, the split command will use the input file name as a
       basis of where to write the split files. The output file will be the
       input file with an attached '.#\' to the end: trace.dat.1,
       trace.dat.2, etc.

           This option will change the name of the base file used.

           -o file  will create file.1, file.2, etc.


>=20
> If the 2 files don't match the above description, there is an issue.

No, it shouldn't do that. It did match your description, but I never
noticed because it was writing files into my "input" directory, which I was
never looking at. :-(

Using your method means we can't use -i for just an input source.

>=20
> ---
>=20
> Otherwise, I believe the command line should be parsed as:
> 1-
> Select all the desired instances with -B or --top,
> the first instance is placed as the top instance.
> 2-
> When parsing a '-o', select all the previously selected instances and
> put them in the output file.



> 3-
> Start all over again from 1-. If there is no output file described
> at the end of the command line, place the result in [input_file].dat.X

No. input_file should only be used if no output file is specified. If it
had done that before your patches, it was a bug and needs to be fixed.

>=20
> So placing the output file at the end of the command line is important
> here. If you think the command line should be parsed another way, please
> let me know,

Now, placement can be important, and perhaps we can use the input_file as
default as if the output file is specified later. I was thinking of doing
this as a separate patch, but if we do allow for multiple output files,
then we can have the commands to do for those files after that.

That is if we have:

  trace-cmd split -i trace.dat --top -o trace-foo.dat -B foo -o trace-bar.d=
at -B bar

It could then split out the top instance by itself in trace.dat.1, have
trace-foo.dat have the 'foo' instance as its main instance, and
trace-bar.dat have 'bar' instance as its main instance. So order would matt=
er then.

But if nothing is between -i and -o, then nothing should be done against
-i. That is, if the above was:

  trace-cmd split -i trace.dat -o trace-foo.dat -B foo -o trace-bar.dat -B =
bar

(removed --top) then it would not create the trace.dat.1 file.

And we need to update the man pages and possibly the usage to explicitly
state how order matters.

-- Steve

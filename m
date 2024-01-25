Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B2E13B791
	for <linux-trace-devel@vger.kernel.org>; Thu, 25 Jan 2024 16:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706201508; cv=none; b=YFLyuAgyj4V4cW4AkWZzU9YQNsnkEXH3a9OJzCnFNbyoBP8c74IknppZTL5HVXdiM6WKC0uI5oTt7rKiyxnN0QiPiKd81cwTvWa5J2L9wD1rnM2A7w3jvTX2X585Xbwt4uVynFSi9CvbxItp/YL3mkdBQJambu2nDCIhAtZ7g00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706201508; c=relaxed/simple;
	bh=uNmky2iaqvMtIogRNTXZVbQX+VHJ0vUj7URSBWmMqZA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R7Qy1NNtC5uM9LgxBMLoXGZGefWuARvtCa62rfDYR6ZKoXlXsUztGyg7d+e2I1GXHl/YM/6yCuFL8MU4Fr2ERoU3uQTXBhrwUWJZ7zGINA11X0oQ0ZwELwCS0CQxwST393SrVj/C71rj5B1WE5zYmY4OWq+p2PSrE0hwC9f281Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2117EC433C7;
	Thu, 25 Jan 2024 16:51:47 +0000 (UTC)
Date: Thu, 25 Jan 2024 11:51:47 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Pierre Gondois <pierre.gondois@arm.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v3 4/5] trace-cmd split: Enable support for buffer
 selection
Message-ID: <20240125115147.51bcce2a@gandalf.local.home>
In-Reply-To: <20240125112834.2de4eedb@gandalf.local.home>
References: <20240123134215.385415-1-pierre.gondois@arm.com>
	<20240123134215.385415-5-pierre.gondois@arm.com>
	<20240124173740.6d9e2287@gandalf.local.home>
	<1122630e-838e-49fc-9210-55834129088c@arm.com>
	<20240125112834.2de4eedb@gandalf.local.home>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 25 Jan 2024 11:28:34 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 25 Jan 2024 16:16:42 +0100
> Pierre Gondois <pierre.gondois@arm.com> wrote:
> 
> > >> For example, with a trace recorded with:
> > >>    $ trace-cmd record -e sched_wakeup -B switch_instance \
> > >>      -e sched_switch -B timer_instance -e timer    
> > > 
> > > I tried this with a trace.dat file that has a instance called "tast" and it
> > > didn't work. Note, the top instance had no data.
> > > 
> > >    $ trace-cmd split -i /work/traces/trace-tast.dat -o /tmp/trace-tast2.dat -B tast    
> > 
> > With this command, the expected behaviour should be:
> > trace-tast2.dat:
> > - Contains all the instances of the input trace-tast.dat file  
> 
> Wait what? -i should *not* be used for output if -o is specified!

OK, I see what you did.

As if I wrote:

trace-cmd split -i /work/traces/trace-tast.dat  -B tast -o /tmp/trace-tast2.dat

I got what I want.

But once -o is used, it should repeat for the -B. the -B should *not* use
the input file unless -o is not specified.

  trace-cmd split -i /work/traces/trace-tast.dat -o /tmp/trace-tast2.dat -B tast

What the above should have done the same. But if we added:

  trace-cmd split -i /work/traces/trace-tast.dat --top -o /tmp/trace-tast2.dat -B tast

Then /tmp/trace-tast2.dat would just have the top instance, and it should create:

 /tmp/trace-tast2.dat.tast

to hold the tast image.

Now if I had had:

  trace-cmd split -i /work/traces/trace-tast.dat --top  -B tast -o /tmp/trace-tast2.dat

Then because there was a command "--top" before the -B but it had no -o
assigned for it, then the input_file would be considered the output file
and that should act like you described.

-- Steve



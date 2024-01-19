Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73ECA54BEE
	for <linux-trace-devel@vger.kernel.org>; Fri, 19 Jan 2024 17:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705685033; cv=none; b=LxVILT4mmV+wopV9xIrxbkEvfM8XJJP4vw7PvEg8SgLqBCXoAsshfLdV7306HD7IyfzMaBbGnpj7b+c+/FU+sW/ZOF7LKVllMK3WnYLFj9sOBa3wgZYwhi92bu+FYD53Rnsn0zq68wugLz2PZe5cYHrk7ffSlsQLAfWh2E1SDNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705685033; c=relaxed/simple;
	bh=2qwzWgIk7pt0+erX5+vPqtjzycuEWBc4m8WNWqApXAI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B6HKgH3i43nppPz3q0KehcY/x4zMl5PLSD6/XBTP7/S1RCU8nZlZHOQyQ8yvAK8F7WONR9gX5J5eYnlc+vWopUav6DfI7EDWiO7q0dQF319VeP9sBz7yvxDqulROoeORW8IXu+pI5rRuIavIxiliHPqFzCOJRCRxJhxpbq5aGX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A4D8C433C7;
	Fri, 19 Jan 2024 17:23:50 +0000 (UTC)
Date: Fri, 19 Jan 2024 12:25:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Pierre Gondois <pierre.gondois@arm.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 5/5] trace-cmd: split: Handle splitting files with
 multiple instances
Message-ID: <20240119122511.440d8f0a@gandalf.local.home>
In-Reply-To: <fecd93bd-28fd-4695-9d68-0bf79953346b@arm.com>
References: <20240112083945.1361293-1-pierre.gondois@arm.com>
	<20240112083945.1361293-6-pierre.gondois@arm.com>
	<20240112111816.26f2cd6b@gandalf.local.home>
	<84eac549-1099-46d2-9f8e-bfb1f31c2d1e@arm.com>
	<fecd93bd-28fd-4695-9d68-0bf79953346b@arm.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 19 Jan 2024 18:06:43 +0100
Pierre Gondois <pierre.gondois@arm.com> wrote:

> > 	$ trace-cmd split -B switch_instance -o switch.dat -b -o main.dat -B timer_instance -o timer.dat
> > switch.dat:
> > - switch_instance as the main instance
> > main.dat:
> > - main instance as the main instance
> > timer.dat:
> > - timer_instance as the main instance
> > 
> > [1]
> > As the main buffer doesn't have a default name, it might be necessary
> > to hardcode the name, as 'main', or as 'main.X' (X being an increasing number)
> > if there is already a main instance in the trace  
> 
> 
> It would also mean that:
> 	$ trace-cmd split -B switch_instance -b -o switch.dat -B timer_instance -b -o timer.dat
> switch.dat:
> - switch_instance as the main instance
> - main instance as a side instance, named 'main'
> timer.dat:
> - timer_instance as the main instance
> - main instance as a side instance, named 'main'
> 
> And the usage of the function would be:
> 	$ trace-cmd split [-i file] [options] [[-b -B instance] -o file] [start [end]]
> I.e. the options and start/end parameters would be common to all instances/output files.

I usually use the term "top" not "main" for the top instance. But I
wouldn't want to have a default name anyway.

I would just add "--top" instead of '-b' an the main instance. I say "top"
as that's the common terminology I have used in man pages. Although, I have
used "main" too, I usually append "(top level)" when I do so.

We could call it "--main" too, if it sounds better, but should definitely
document that it means the "top level instance". Hmm, maybe even '-M' could
work.

As for naming, if someone wants to make the main instance an instance, then
they must also supply a name.

  $ trace-cmd split -B switch_instance -M --name 'old_main' -o trace-spit.dat

And that would switch the main and switch_instance in trace-split.dat.

Doesn't mean we can't have both "-M" and "--main" mean the same thing. I
want to keep instance single options capitalized.

Thanks,

-- Steve

Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01FB257AF9
	for <linux-trace-devel@vger.kernel.org>; Mon,  4 Aug 2025 12:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754310740; cv=none; b=g7TEgzFJgzzhmWgTdArt0imnIu+UV6SAyY6Bkkahm7k9NuSfYj56DSxsx/clTedY0gf+iHdxQtNlgGu2k6ocvA5c8tX+djBpQX0+bN2UPc4W0LgXubQ605j1F0U3PiNQQivnzCWFwicoeVEwG9zNwDSwF7KX4Xz34dWKBMsyIqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754310740; c=relaxed/simple;
	bh=P7AUHkNaZZmlQHUqJZiNhhYTEAkvIlKAg4A4zJJBjY8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V6h7DO7NFX8pCnaoNxeCnxvkoksz4jtlZGGD5v74VMj+jTsCkJN22p3KFYMpU0zaH/kPZqVUaZdXHC6wxbhErRE0gek2KuclctHLoeyyHIfOQglrk2FWi5uM2qtomFxIrIUjOe7urPKUncQC15fpR/Tvur1ofOsLcyHtvzohviM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EC55CB79E7;
	Mon,  4 Aug 2025 12:32:10 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf17.hostedemail.com (Postfix) with ESMTPA id 1243B19;
	Mon,  4 Aug 2025 12:32:08 +0000 (UTC)
Date: Mon, 4 Aug 2025 08:32:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Douglas Raillard <douglas.raillard@arm.com>
Cc: linux-trace-devel@vger.kernel.org, Masami Hiramatsu
 <mhiramat@kernel.org>, Namhyung Kim <namhyung@kernel.org>, Takaya Saeki
 <takayas@google.com>, Ian Rogers <irogers@google.com>, aahringo@redhat.com
Subject: Re: [PATCH 2/2] libtraceevent: Add man page for the new BTF
 functions
Message-ID: <20250804083236.7d7099b6@gandalf.local.home>
In-Reply-To: <ce2ded58-79d5-4cdd-87ef-e6aa6613425b@arm.com>
References: <20250731185559.1644753-1-rostedt@goodmis.org>
	<20250731185559.1644753-3-rostedt@goodmis.org>
	<ce2ded58-79d5-4cdd-87ef-e6aa6613425b@arm.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 1243B19
X-Stat-Signature: hnueiaurmbp3h3pknokor4hh3o6zx3gf
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18xbmZFk/hEY4sZqhoZvYsWvszhEPN77GE=
X-HE-Tag: 1754310728-493705
X-HE-Meta: U2FsdGVkX197ESeykrftRm4oZPJ0o6PHpRcTgFh2+Hj6oiJeHVwONLeR9uqPaYGQXyrpSPfan+/PzQ/P6Pd02VpF7wOxGn+64QVD/RE26wG4Fw81nXyHGvLmebnkRjTv3TYXVakRzWjHx8A9qlPtf+ERtxRIcx2EnAfjMkdneARzENtsatpcILPzp0jA0l86uphmOr7xIDRwmO5fqKcZen66k4OGdiah3PcM1Vz633aZUXOL4TQ8AVRKXcUBaOhehXZLP/Q9Ixdh2kLLXs97bmHjakLlxgQO/nHlNJKFNVn5HBB9mJFd/bDfjTx5uYy+0+05B9j3zvDFdS1VNamHWelDvez8pSS6xKmE5hCN23FfEoB4HD5VtrPvwMgYkAa+

On Mon, 4 Aug 2025 12:09:09 +0100
Douglas Raillard <douglas.raillard@arm.com> wrote:

> > +The *tep_btf_print_args()* takes a _tep_ handle, a trace_seq _s_ pointer
> > +(that was initialized by *trace_seq_init(3)*), an _args_ array that holds either
> > +4 byte or 8 byte values, the _nmem_ that is the number of values in the _args_
> > +parameter, a _size_ that is either 4 or 8 to denote the size of each value in _args_,
> > +and a _func_ string that is the name of the function to find the BTF information
> > +to use for parsing. If BTF is not loaded or the _func_ name is not found it
> > +will just print a hex value of all the _args_ into the _s_ descriptor.  
> 
> For clarity, it may be best to not call those things "args", as they may well not be args.
> Before BTF is used to decode, this is merely the values of a bunch of registers assumed to
> hold arguments value, with an unknown mapping of register value to actual args. For example,
> both square() and square_struct() map the exact same assembly on arm64, clang 20 (tested with godbolt):
> 

I can update the description but I still want to keep "args" as they are
the arg elements that were recorded from the function tracer.

They may not be registers, even though they are now. For instance, on i386,
only the first three word size arguments are in registers. The rest comes
from the stack.

But I agree that the description should point out that the _args_ are the
function argument elements that were passed to the function call and are
used to build the function parameters that the program may see.

> 
> If "int" is used instead of "unsigned long", you get an even more interesting non-1-1 mapping
> where a single register is used to hold both 32 bit values, but only when the struct parameter
> is used:
> 
>    square_struct:
>            lsr     x8, x0, #32
>            mul     w0, w8, w0
>            ret
> 
> So there can be more arguments than register used, and also less arguments than register used.

Correct. But still, I would not call them registers as they may be from the
stack. I'll stick to calling them _args_ but refer to them in the
documentation as "argument elements" as they are the building blocks of the
parameters that are used.

Thanks for the review.

-- Steve


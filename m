Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECB0925B66A
	for <linux-trace-devel@vger.kernel.org>; Mon,  4 Aug 2025 13:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754313581; cv=none; b=pFgLH7iAaCSUqEbQqFNE4WV5H9+gMXE1vPrQ3xzccW6M+RfAuNw6+3PzFAx/lqinWAdxPFtnQx0Omq28q45DfUtNSJO2Hdj1u+xtdVa7HPJZYq8beb/3sJ7Gxu7jkLpg2hzAXSLS8tqRxV1waS2ud4A/wwxznb9y8kddV5lJ9mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754313581; c=relaxed/simple;
	bh=F+xZPWXQFgS55WHzrRhWlxbLYrZHTWSzsN4aceUtT/o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZI4EQy2Ouo+R5a9ivZA/6bNKzk1qR5/SOAUMdkFZF+wKYSad+0mBnzL0Haz0IWJwdgZmG2ew2oEE098x9S0FyKR0b9zUTWoCKmlamx3xwSJczg7YGypyRTVeanxbgsAVu2tGWgXqn3QVEFyb9YOx3Iki7dInKlejfVWFLM6CBs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 446F4150C;
	Mon,  4 Aug 2025 06:19:31 -0700 (PDT)
Received: from [192.168.1.127] (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CFECD3F673;
	Mon,  4 Aug 2025 06:19:37 -0700 (PDT)
Message-ID: <3a5b1cb7-8341-474c-b973-a624f5d0c791@arm.com>
Date: Mon, 4 Aug 2025 14:19:41 +0100
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] libtraceevent: Add man page for the new BTF functions
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org, Masami Hiramatsu
 <mhiramat@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
 Takaya Saeki <takayas@google.com>, Ian Rogers <irogers@google.com>,
 aahringo@redhat.com
References: <20250731185559.1644753-1-rostedt@goodmis.org>
 <20250731185559.1644753-3-rostedt@goodmis.org>
 <ce2ded58-79d5-4cdd-87ef-e6aa6613425b@arm.com>
 <20250804083236.7d7099b6@gandalf.local.home>
Content-Language: en-US
From: Douglas Raillard <douglas.raillard@arm.com>
In-Reply-To: <20250804083236.7d7099b6@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04-08-2025 13:32, Steven Rostedt wrote:
> On Mon, 4 Aug 2025 12:09:09 +0100
> Douglas Raillard <douglas.raillard@arm.com> wrote:
> 
>>> +The *tep_btf_print_args()* takes a _tep_ handle, a trace_seq _s_ pointer
>>> +(that was initialized by *trace_seq_init(3)*), an _args_ array that holds either
>>> +4 byte or 8 byte values, the _nmem_ that is the number of values in the _args_
>>> +parameter, a _size_ that is either 4 or 8 to denote the size of each value in _args_,
>>> +and a _func_ string that is the name of the function to find the BTF information
>>> +to use for parsing. If BTF is not loaded or the _func_ name is not found it
>>> +will just print a hex value of all the _args_ into the _s_ descriptor.
>>
>> For clarity, it may be best to not call those things "args", as they may well not be args.
>> Before BTF is used to decode, this is merely the values of a bunch of registers assumed to
>> hold arguments value, with an unknown mapping of register value to actual args. For example,
>> both square() and square_struct() map the exact same assembly on arm64, clang 20 (tested with godbolt):
>>
> 
> I can update the description but I still want to keep "args" as they are
> the arg elements that were recorded from the function tracer.
> 
> They may not be registers, even though they are now. For instance, on i386,
> only the first three word size arguments are in registers. The rest comes
> from the stack.
> 
> But I agree that the description should point out that the _args_ are the
> function argument elements that were passed to the function call and are
> used to build the function parameters that the program may see.
> 
>>
>> If "int" is used instead of "unsigned long", you get an even more interesting non-1-1 mapping
>> where a single register is used to hold both 32 bit values, but only when the struct parameter
>> is used:
>>
>>     square_struct:
>>             lsr     x8, x0, #32
>>             mul     w0, w8, w0
>>             ret
>>
>> So there can be more arguments than register used, and also less arguments than register used.
> 
> Correct. But still, I would not call them registers as they may be from the
> stack. I'll stick to calling them _args_ but refer to them in the
> documentation as "argument elements" as they are the building blocks of the
> parameters that are used.

That makes sense. Encoding and decoding of that data will then evolve in fairly arch-specific
and lang-specific ways. Maybe this format should be versioned somewhere to allow future expansion
without breaking change ?

> 
> Thanks for the review.
> 
> -- Steve
> 


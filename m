Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F8572C183
	for <linux-trace-devel@vger.kernel.org>; Mon,  5 Feb 2024 13:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707140328; cv=none; b=NDcnfba3Ohsfm0V2dJqpySiXrcugS7UjjSSApzFtTOeoHh+SDqwaHBASMYs8PB+VNYEoZHNVGzGNZxgki9LVF7wKC6RaN4SPU1lq+y2PXjth+IPcfJkKiNo4Nl+E8cvLrcbzudnExIbee8jETaStk2cTTzd+65mhQFHoLptPM5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707140328; c=relaxed/simple;
	bh=V1bSWWwGozPDZDROMt1v97bhvROuMt9e699A8FCHqAk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nvBKxMndJWitory7T/KW001DIgtpRk15JGUe/I3Y+/ZGE3ObMpXjVMqG02x5TqG0GKxODPKQvDfD1Mn0MSdHhr+dT2eIXIWeHnpGtsYKApxA5PzQH9k/x+alCxTSLYdJNLldr7l0YeC8DAlAC5fZtF7TCNyKjsyjizkpOieYskM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EA8901FB;
	Mon,  5 Feb 2024 05:39:26 -0800 (PST)
Received: from [10.34.100.129] (e126645.nice.arm.com [10.34.100.129])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 93BAA3F641;
	Mon,  5 Feb 2024 05:38:43 -0800 (PST)
Message-ID: <13355fbc-7592-4a54-8e92-e3d78afa83ae@arm.com>
Date: Mon, 5 Feb 2024 14:38:38 +0100
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/5] trace-cmd split: Enable support for buffer
 selection
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20240123134215.385415-1-pierre.gondois@arm.com>
 <20240123134215.385415-5-pierre.gondois@arm.com>
 <20240124173740.6d9e2287@gandalf.local.home>
 <1122630e-838e-49fc-9210-55834129088c@arm.com>
 <20240125112834.2de4eedb@gandalf.local.home>
 <20240125115147.51bcce2a@gandalf.local.home>
 <20240125121025.208a7012@gandalf.local.home>
 <eb976812-06e9-4a0a-93d1-1868ee9d19e1@arm.com>
 <20240201211740.33b43bcd@gandalf.local.home>
Content-Language: en-US
From: Pierre Gondois <pierre.gondois@arm.com>
In-Reply-To: <20240201211740.33b43bcd@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello Steven,

On 2/2/24 03:17, Steven Rostedt wrote:
> On Fri, 26 Jan 2024 09:54:53 +0100
> Pierre Gondois <pierre.gondois@arm.com> wrote:
> 
>> Hello Steven,
>>
> 
> Hi Pierre,
> 
> Sorry for the late reply. I've been putting out fires (you can read LWN or
> The Register to see what exactly I was doing).

Ok yes, no worries

> 
>> On 1/25/24 18:10, Steven Rostedt wrote:
>>> On Thu, 25 Jan 2024 11:51:47 -0500
>>> Steven Rostedt <rostedt@goodmis.org> wrote:
>>>    
>>>> Now if I had had:
>>>>
>>>>     trace-cmd split -i /work/traces/trace-tast.dat --top  -B tast -o /tmp/trace-tast2.dat
>>>>
>>>> Then because there was a command "--top" before the -B but it had no -o
>>>> assigned for it, then the input_file would be considered the output file
>>>> and that should act like you described.
>>>
>>> Of course then things get confusing if we were to have:
>>>
>>> trace-cmd split -i /work/traces/trace-tast.dat  -B foo -o /tmp/trace-foo.dat -B bar
>>>
>>> We could specify that each -B will just use the top level by default. So
>>> the above would create:
>>>
>>>    /tmp/trace-foo.dat
>>>
>>> With the instance "foo"
>>>
>>> But the "bar" would be in:
>>>
>>>    /work/traces/trace-tast.dat.bar
>>>
>>> because the top level didn't specify a -o.
>>>
>>> So to make it more specific. Each -B will default to the toplevel output
>>> with ".<instance>" appended to it.
>>>
>>> That is:
>>>
>>>     split <top-level-commands> -B instance1 <instance1-commands> -B <instance2-commands>
>>>
>>> If a -o is specified in the <top-level-commands> it becomes the default top
>>> level output file.  If a -o is not specified in any of the
>>> <instance*-commands> then, it will default to the top level output file
>>> with ".<instance-name>" attached to it unless it has its own -o specified.
>>
>> I also wanted to handle the case where multiple instances could be placed
>> in an output file. Meaning that with the patches:
>> - -B/--top options are parsed to select the instances to keep,
>> - a -o option ends the parsing of instances and place them in the given output
>>     file. If no -o option is parsed, then the default output file or the input
>>     file is used as a base name for the last generated output file (i.e. trace.dat.1
>>     if no input file is specified)
> 
> OK, I see what you want. You want to be able to have multiple buffers in a
> single file.
> 
>>
>> ---
>>
>> For example, with a trace recorded with:
>> 	$ trace-cmd record -e sched_wakeup -B switch_instance -e sched_switch -B timer_instance -e timer
>>
>> Creating a test.dat file containing the top instance and
>> the switch_instance:
>> 	$ trace-cmd split --top -B switch_instance -o test.dat
>>
>> Creating a test.dat file containing the switch_instance as
>> the top instance, and the initial top instance as an instance
>> named 'old_top':
>> 	$ trace-cmd split -B switch_instance --top=old_top -o test.dat
>>
>> Splitting all instances in different .dat files:
>> 	$ trace-cmd split --top -o top.dat -B switch_instance -o switch.dat -B timer_instance -o timer.dat
>>
>> And by default, if no -B/--top is specified for an output file,
>> keep all the instances (but of course all the other options provided
>> to the split command are applied, i.e. start/end timings):
>> Keep all the instances and place them in test.dat:
>> 	$ trace-cmd split -o test.dat
>> Keep all the instances and place them in the default file trace.dat.1:
>> 	$ trace-cmd split
>>
>> ---
>>
>> Maybe the list of generated files should be printed to avoid what happened
>> to you, i.e. generating files that were not expected.
>> I think that having a default name with a suffix being the top instance
>> is a good idea, but I don't think it would be possible to parse the command
>> line to have 2 instances in one file in such case.
>>
>>>
>>> For multi-file splits, it will append ".0001", ".0002", etc to that file.
> 
> So what I'm thinking is that the -B buffers default to the same buffer as
> the top buffer unless specified differently.
> 
> Here's what I think would work. We add four new options.
> 
>   --top
>   -B <instance>
>   -t
>   -b
> 
> Where --top represents the "top" instance.
> 
> -B represents the <instance>
> 
> -t can be used after -B to make it a top instance.
> 
> -b can be used before any -B to make the top instance into its own instance.

This set of parameters sounds good to me.

> 
> Rules:
> 
>    --top can not come after -B.
>    -t must come after -B
>    -b must come before -B

IIUC, these rules are described in the syntax below.

> 
> There can only be one top instance, and all named instances must be unique.
> That is, you can't have two instances called "foo".
> 
> We have: trace-cmd split <TOP_COMMANDS> <INSTANCE_COMMANDS>
> 
>    TOP_COMMANDS :: nil | TOP_PARAMS
> 
>    INSTANCE_COMMANDS :: nil | -B name INSTANCE_PARAMS INSTANCE_COMMANDS
> 
>    TOP_PARAMS :: nil | TOP_OPTIONS TOP_PARAMS
> 
>    TOP_OPTIONS :: --top | -b name | -o file
> 
>    INSTANCE_PARAMS :: nil | INSTANCE_OPTIONS INSTANCE_PARAMS
> 
>    INSTANCE_OPTIONS :: nil | -t | -o file

I think it might also be difficult to place the top instance in multiple output
files (or the intention was to do it in multiple steps ?). For instance, from a
trace containing a top instance and foo/bar instances, what would be the command
to obtain:
- a foo.dat file containing the top + foo instances
- a bar.dat file containing the top + bar instances

If this was:
   trace-cmd split --top -o foo.dat --top -o bar.dat -B foo -o foo.dat -B bar -o bar.dat
I think it would be clearer to revolve around the output file:
   trace-cmd split --top -B foo -o foo.dat --top -B bar -o bar.dat
but this is open to debate.

---

Also, if one wants to place all the instance in one output.dat file, IIUC all the
instances will have to be nominatively selected right ?

> 
> Examples:
> 
>   trace-cmd split --top -B foo
> 
> Will make a trace.dat.1 that has top and foo in it.
> 
>   trace-cmd split --top
> 
> Will make a trace.dat.1 that only has the top instance
> 
>   trace-cmd split -B foo
> 
> Will make a trace.dat.1 that only has foo in it.
> 
>   trace-cmd split -B foo -t
> 
> Will make a trace.dat.1 that only has foo in it. It will also promote the
> instance foo to the top instance (it will lose its "foo" name).
> 
>   trace-cmd split --top -o buba.dat -B foo
> 
> Will create a buba.dat that has both top and foo in it

 From the syntax above, I would have thought that this would be parsed as:
- <TOP_COMMANDS>: '--top -o buba.dat'
- <INSTANCE_COMMANDS>: '-B foo'

and so that the 'foo' instance would end up in the default trace.dat.1
as there is no output file specified.

> 
>   trace-cmd split --top -B foo -o buba.dat
> 
> Will create a trace-dat.1 with just top in it, and buba.dat with just foo
> in it.
> 
>   trace-cmd split --top -B foo -o buba.dat -t
> 
> Will create a trace-dat.1 with just top in it, and buba.dat with just foo
> in it (promoting foo to top instance)
> 
>   trace-cmd split --top -b foo -B foo -t
> 
> Will make a trace.dat.1 file where the top instance becomes "foo" and the
> foo instance becomes the top instance.
> 
>    trace-cmd split -o buba.dat -B foo -t

I think this would be parsed (cf. the syntax above) as:
- <TOP_COMMANDS>: '-o buba.dat'
- <INSTANCE_COMMANDS>: '-B foo -t'

So there would be
- a buba.dat file containing all the possible instances and the
   top instance
- a default trace.data.1 containing the foo instance as the top instance

> 
> Will create just a buba.dat file with only foo in it, promoting it as the
> top instance.
> 
>    trace-cmd split -o buba.dat --top -B foo -o fooba.dat
> 
> Will create a buba.dat with just the top instance in it (note --top can
> come before or after -o and that does not make any difference, but the
> order of -B and -o does matter). It will also create a fooba.dat file with
> just foo in it.
> 
>    trace-cmd split --top -B foo -t -o fooba.dat -B bar
> 
> This will create a trace.dat.1 with the top instance and the bar instance,
> but also make a fooba.dat file with just "foo", and promoting it as the top
> instance.
> 
>    trace-cmd split --top -o buba.dat -B foo -o foobar.dat -B bar -o foobar.dat
> 
> This will make two files. One with buba.dat that holds the top instance,
> and foobar.dat that holds both the foo and bar instances.
> 
>    trace-cmd split --top -o buba.dat -B foo -o foobar.dat -B bar -t -o foobar.dat
> 
> This will make two files. One with buba.dat that holds just the top
> instance and a foobar.dat file that has both foo and bar, but bar gets
> promoted to the top instance.
> 
> Does that make sense?
> 
> -- Steve

Regards,
Pierre

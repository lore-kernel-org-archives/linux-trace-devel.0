Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 216F0FBFC
	for <linux-trace-devel@vger.kernel.org>; Mon, 12 Feb 2024 09:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707729119; cv=none; b=J6WoMkkm/0ZOZrOhswgOhX3ceDBNaNlyswimlbLQz9EmiPLYLnjYMa6K7S+xGVtlNONg2N0U1D/e4ryjYDBm4wKBPK6upK3Y5Xlu/ZTdcuYHPCUt+gIWGIQNIY+TAexDN+nFeoiEeI8BQ2BT7zocW2ibSOWvgtYY6Y/MOhdAImY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707729119; c=relaxed/simple;
	bh=kHvDqAhsEc4hhd/TzGVPeWAswuP+MwAeNC4UpmDMwvI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l5zskW8DBQbA5D5tLw0TpNq3iCcvFxESzV68/Yw3KmkNNSZ88GMx99BSK4DvmEcLeWIANYAK3jeynY89/CNYUk3BJuwX1zGRqw7MzwiiSk3m+M86l3OhWv1JirNjo3MvnMhEoMWOQXoTbSW2HOLNUpt0+F7sQj8MLSlSBSPGjhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 24768DA7;
	Mon, 12 Feb 2024 01:12:38 -0800 (PST)
Received: from [10.34.100.133] (e126645.nice.arm.com [10.34.100.133])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 31A053F762;
	Mon, 12 Feb 2024 01:11:56 -0800 (PST)
Message-ID: <5f983dc2-2aa2-4f4e-a1c4-ce72007e4f52@arm.com>
Date: Mon, 12 Feb 2024 10:11:52 +0100
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
 <13355fbc-7592-4a54-8e92-e3d78afa83ae@arm.com>
 <20240211183553.6976670f@rorschach.local.home>
Content-Language: en-US
From: Pierre Gondois <pierre.gondois@arm.com>
In-Reply-To: <20240211183553.6976670f@rorschach.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/12/24 00:35, Steven Rostedt wrote:
> On Mon, 5 Feb 2024 14:38:38 +0100
> Pierre Gondois <pierre.gondois@arm.com> wrote:
>   >
>>> So what I'm thinking is that the -B buffers default to the same buffer as
>>> the top buffer unless specified differently.
>>>
>>> Here's what I think would work. We add four new options.
>>>
>>>    --top
>>>    -B <instance>
>>>    -t
>>>    -b
>>>
>>> Where --top represents the "top" instance.
>>>
>>> -B represents the <instance>
>>>
>>> -t can be used after -B to make it a top instance.
>>>
>>> -b can be used before any -B to make the top instance into its own instance.
>>
>> This set of parameters sounds good to me.
>>
>>>
>>> Rules:
>>>
>>>     --top can not come after -B.
>>>     -t must come after -B
>>>     -b must come before -B
>>
>> IIUC, these rules are described in the syntax below.
>>
>>>
>>> There can only be one top instance, and all named instances must be unique.
>>> That is, you can't have two instances called "foo".
>>>
>>> We have: trace-cmd split <TOP_COMMANDS> <INSTANCE_COMMANDS>
>>>
>>>     TOP_COMMANDS :: nil | TOP_PARAMS
>>>
>>>     INSTANCE_COMMANDS :: nil | -B name INSTANCE_PARAMS INSTANCE_COMMANDS
>>>
>>>     TOP_PARAMS :: nil | TOP_OPTIONS TOP_PARAMS
>>>
>>>     TOP_OPTIONS :: --top | -b name | -o file
>>>
>>>     INSTANCE_PARAMS :: nil | INSTANCE_OPTIONS INSTANCE_PARAMS
>>>
>>>     INSTANCE_OPTIONS :: nil | -t | -o file
>>
>> I think it might also be difficult to place the top instance in multiple output
>> files (or the intention was to do it in multiple steps ?). For instance, from a
>> trace containing a top instance and foo/bar instances, what would be the command
>> to obtain:
>> - a foo.dat file containing the top + foo instances
>> - a bar.dat file containing the top + bar instances
> 
> Does that need to be done in a single command, or two commands?
> 
>    trace-cmd split --top -B foo
>    trace-cmd split --top -B bar
> 
> ?

Yes ok, we can do that.

> 
>>
>> If this was:
>>     trace-cmd split --top -o foo.dat --top -o bar.dat -B foo -o foo.dat -B bar -o bar.dat
>> I think it would be clearer to revolve around the output file:
>>     trace-cmd split --top -B foo -o foo.dat --top -B bar -o bar.dat
>> but this is open to debate.
> 
> My concern is that if we want to do that in one command it can cause
> the code and parameters to become too complex. But I'm not against the
> idea. I personally think that if we allow too much it may become too
> confusing.

Ok ok, we can limit the command to one output file.

> 
>>
>> ---
>>
>> Also, if one wants to place all the instance in one output.dat file, IIUC all the
>> instances will have to be nominatively selected right ?
>>
>>>
>>> Examples:
>>>
>>>    trace-cmd split --top -B foo
>>>
>>> Will make a trace.dat.1 that has top and foo in it.
>>>
>>>    trace-cmd split --top
>>>
>>> Will make a trace.dat.1 that only has the top instance
>>>
>>>    trace-cmd split -B foo
>>>
>>> Will make a trace.dat.1 that only has foo in it.
>>>
>>>    trace-cmd split -B foo -t
>>>
>>> Will make a trace.dat.1 that only has foo in it. It will also promote the
>>> instance foo to the top instance (it will lose its "foo" name).
>>>
>>>    trace-cmd split --top -o buba.dat -B foo
>>>
>>> Will create a buba.dat that has both top and foo in it
>>
>>   From the syntax above, I would have thought that this would be parsed as:
>> - <TOP_COMMANDS>: '--top -o buba.dat'
>> - <INSTANCE_COMMANDS>: '-B foo'
>>
>> and so that the 'foo' instance would end up in the default trace.dat.1
>> as there is no output file specified.
> 
> No, I was saying that -B will default to the top file, not the default
> file. If the top file is specified, then the -B will also be in that file.

Ok right. I think I got confused due to the possibility to have multiple
output files when expanding 'trace-cmd split <TOP_COMMANDS> <INSTANCE_COMMANDS>'

I think the description should match this then:
   trace-cmd split [OTHER_OPTIONS] [--top [-b name]] [-o output_file] [-B instance_name [-t]]*
     [start-time [end-time]]
# The '-t' option can only be used once per command line

or:
   trace-cmd split <TOP_COMMANDS> <OUTPUT_COMMAND> <INSTANCE_COMMANDS>

   TOP_COMMANDS :: nil | --top TOP_PARAMS
   TOP_PARAMS :: nil | -b name

   OUTPUT_COMMAND :: nil | -o output_file

   INSTANCE_COMMANDS :: nil | -B name INSTANCE_PARAMS INSTANCE_COMMANDS
   INSTANCE_PARAMS :: nil | -t
# INSTANCE_PARAMS can only expand to '-t' once.

I'm also not sure it is necessary to have a specific order for the
--top/-o/-B parameters. I should also work when they are unordered
if we limit the command to one output file:
- trace-cmd split -B foo -t --top -b old_top -o output.dat
- trace-cmd split -o output.dat -B foo -t --top -b old_top
- trace-cmd split -o output.dat --top -b old_top -B foo -t
should all be equivalent.

Regards,
Pierre

> 
>>
>>>
>>>    trace-cmd split --top -B foo -o buba.dat
>>>
>>> Will create a trace-dat.1 with just top in it, and buba.dat with just foo
>>> in it.
>>>
>>>    trace-cmd split --top -B foo -o buba.dat -t
>>>
>>> Will create a trace-dat.1 with just top in it, and buba.dat with just foo
>>> in it (promoting foo to top instance)
>>>
>>>    trace-cmd split --top -b foo -B foo -t
>>>
>>> Will make a trace.dat.1 file where the top instance becomes "foo" and the
>>> foo instance becomes the top instance.
>>>
>>>     trace-cmd split -o buba.dat -B foo -t
>>
>> I think this would be parsed (cf. the syntax above) as:
>> - <TOP_COMMANDS>: '-o buba.dat'
>> - <INSTANCE_COMMANDS>: '-B foo -t'
>>
>> So there would be
>> - a buba.dat file containing all the possible instances and the
>>     top instance
>> - a default trace.data.1 containing the foo instance as the top instance
> 
> Again, -o of the top file becomes the default for all the rest, unless
> they specify their own output file.
> 
> -- Steve

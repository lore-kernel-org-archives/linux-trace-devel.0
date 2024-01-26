Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 602852260A
	for <linux-trace-devel@vger.kernel.org>; Fri, 26 Jan 2024 08:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259303; cv=none; b=EWX5NAsruwby+s6OnOc7jz4SlY3zUKHN/0H8xmHkJtGZfek5mbrsyu858AGEv/Wa7zgKtIV0tPlFGpm/fpAkEVlsXQDIW0VZ3V8P/ePkIwmbPG3RfNo9Q7kfFIF+Ffas4BfWm9fIN4HqFuUbtT5R9FJaMNz7rEaAfWv+eMqE8Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259303; c=relaxed/simple;
	bh=BxTsUl0VQEo1e3B0LUhnLGM65MqTgeAEiw5uJdpwA4g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cga4DQREVQDl7Qh8zP9xVxfTlFuYQV3l/OGxJGExCzAwY3s+GsTizp9BKmQIbcL+xREhXI2y4MiBzL8/dpqeJXmj8Rymnb6xQ/0Xce1sLKnNPsmFlCH05FTNraHqMBVE0EmYY0rkYXgtEDn4WF4ugygjByqOSA3cM+BBnG0407M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A42741FB;
	Fri, 26 Jan 2024 00:55:43 -0800 (PST)
Received: from [192.168.1.25] (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BD75F3F762;
	Fri, 26 Jan 2024 00:54:58 -0800 (PST)
Message-ID: <eb976812-06e9-4a0a-93d1-1868ee9d19e1@arm.com>
Date: Fri, 26 Jan 2024 09:54:53 +0100
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
Content-Language: en-US
From: Pierre Gondois <pierre.gondois@arm.com>
In-Reply-To: <20240125121025.208a7012@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello Steven,

On 1/25/24 18:10, Steven Rostedt wrote:
> On Thu, 25 Jan 2024 11:51:47 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
>> Now if I had had:
>>
>>    trace-cmd split -i /work/traces/trace-tast.dat --top  -B tast -o /tmp/trace-tast2.dat
>>
>> Then because there was a command "--top" before the -B but it had no -o
>> assigned for it, then the input_file would be considered the output file
>> and that should act like you described.
> 
> Of course then things get confusing if we were to have:
> 
> trace-cmd split -i /work/traces/trace-tast.dat  -B foo -o /tmp/trace-foo.dat -B bar
> 
> We could specify that each -B will just use the top level by default. So
> the above would create:
> 
>   /tmp/trace-foo.dat
> 
> With the instance "foo"
> 
> But the "bar" would be in:
> 
>   /work/traces/trace-tast.dat.bar
> 
> because the top level didn't specify a -o.
> 
> So to make it more specific. Each -B will default to the toplevel output
> with ".<instance>" appended to it.
> 
> That is:
> 
>    split <top-level-commands> -B instance1 <instance1-commands> -B <instance2-commands>
> 
> If a -o is specified in the <top-level-commands> it becomes the default top
> level output file.  If a -o is not specified in any of the
> <instance*-commands> then, it will default to the top level output file
> with ".<instance-name>" attached to it unless it has its own -o specified.

I also wanted to handle the case where multiple instances could be placed
in an output file. Meaning that with the patches:
- -B/--top options are parsed to select the instances to keep,
- a -o option ends the parsing of instances and place them in the given output
   file. If no -o option is parsed, then the default output file or the input
   file is used as a base name for the last generated output file (i.e. trace.dat.1
   if no input file is specified)

---

For example, with a trace recorded with:
	$ trace-cmd record -e sched_wakeup -B switch_instance -e sched_switch -B timer_instance -e timer

Creating a test.dat file containing the top instance and
the switch_instance:
	$ trace-cmd split --top -B switch_instance -o test.dat

Creating a test.dat file containing the switch_instance as
the top instance, and the initial top instance as an instance
named 'old_top':
	$ trace-cmd split -B switch_instance --top=old_top -o test.dat

Splitting all instances in different .dat files:
	$ trace-cmd split --top -o top.dat -B switch_instance -o switch.dat -B timer_instance -o timer.dat

And by default, if no -B/--top is specified for an output file,
keep all the instances (but of course all the other options provided
to the split command are applied, i.e. start/end timings):
Keep all the instances and place them in test.dat:
	$ trace-cmd split -o test.dat
Keep all the instances and place them in the default file trace.dat.1:
	$ trace-cmd split

---

Maybe the list of generated files should be printed to avoid what happened
to you, i.e. generating files that were not expected.
I think that having a default name with a suffix being the top instance
is a good idea, but I don't think it would be possible to parse the command
line to have 2 instances in one file in such case.

> 
> For multi-file splits, it will append ".0001", ".0002", etc to that file.
> 

Regards,
Pierre

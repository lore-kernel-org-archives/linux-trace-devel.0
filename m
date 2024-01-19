Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C3661C15
	for <linux-trace-devel@vger.kernel.org>; Fri, 19 Jan 2024 17:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705684011; cv=none; b=i0CiLus/gaxznMPZk8Qfd25BXarIyFwGEua0B68lvyUPM0ghWBU4Q2EUKFHRBzhDlLtlOqnr9NY5lBLr4pduH5lRQao2EyKuAfjL1ySavXzADZ37zSOkFSJ5c3Qk9nCiRjY+NwKXdMKxHiCfB0+kNwSFDHOSZyT+d32kQPHQdn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705684011; c=relaxed/simple;
	bh=ekOeLxlX4FVn7e70eXXlGvseQvM7CJbeLQOrd2QRdYA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=DgDv9wGWEhaEreBzrg9iRCkx/DMpFWxtOEUSsdxSulp6lr//KrqtOtqRgdoYJHlnUGruBoz66mrXojBXZV2+ylgYTpgOj6XWrYzELHie4BlvgtiiQ7BYo4NFW1Sdsyl3clpYgbagqyJucIYGrbmrCIlbE3m+s42w6zDwklp0ANQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 037E61042;
	Fri, 19 Jan 2024 09:07:33 -0800 (PST)
Received: from [192.168.1.13] (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 676193F5A1;
	Fri, 19 Jan 2024 09:06:46 -0800 (PST)
Message-ID: <fecd93bd-28fd-4695-9d68-0bf79953346b@arm.com>
Date: Fri, 19 Jan 2024 18:06:43 +0100
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] trace-cmd: split: Handle splitting files with
 multiple instances
Content-Language: en-US
From: Pierre Gondois <pierre.gondois@arm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20240112083945.1361293-1-pierre.gondois@arm.com>
 <20240112083945.1361293-6-pierre.gondois@arm.com>
 <20240112111816.26f2cd6b@gandalf.local.home>
 <84eac549-1099-46d2-9f8e-bfb1f31c2d1e@arm.com>
In-Reply-To: <84eac549-1099-46d2-9f8e-bfb1f31c2d1e@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/19/24 17:41, Pierre Gondois wrote:
> Hello Steven,
> 
> On 1/12/24 17:18, Steven Rostedt wrote:
>> On Fri, 12 Jan 2024 09:39:45 +0100
>> Pierre Gondois <pierre.gondois@arm.com> wrote:
>>
>>> trace-cmd can record events in multiple instances:
>>>     $ trace-cmd record -e sched_wakeup -B test_instance -e sched_switch
>>>
>>> When trying to split a trace.dat file recorded with the above command,
>>> only the events located in the main buffer seems to be split. The
>>> events recorded in the test_instance buffer seem to be discarded:
>>>     $ trace-cmd split -i trace.dat -o trace_2.dat 284443 284444
>>>     $ trace-cmd report trace_2.dat
>>>       cpus=8
>>>              <...>-525991 [004] 284443.173879: sched_wakeup: [...]
>>>              <...>-525991 [004] 284443.173879: sched_wakeup: [...]
>>>              <...>-525990 [007] 284443.173885: sched_wakeup: [...]
>>>              <...>-525990 [007] 284443.173885: sched_wakeup: [...]
>>> (no sign of sched_switch events)
>>>
>>
>>
>>> Make use of the previous patches to split all the instances of
>>> a trace.
>>
>> This shouldn't be in the change log. As the change log is for history.
>> Think about reading this 5 years from now. Would it make sense about
>> "previous patches"?
>>
>> Thanks for doing this, I'll try to set some time next week to review them.
>> I want to release 3.3 soon.
>>
>> Would you be able to add a way to split out an instance into its own
>> trace.dat file?  Or to choose what you want.
>>
>>    $ trace-cmd record -e sched_wakeup -B test_instance -e sched_switch
>>
>>    $ trace-cmd split -B test_instance -o test.dat
>>
>> Would make test_instance the main buffer in test.dat.
>>
>> If you add more than one instance:
>>
>>    $ trace-cmd record -e sched_wakeup -B test_instance -e sched_switch -B timer_instance -e timer
>>
>>    $ trace-cmd split -B test_instance -o test.dat -B timer_instance
>>
>> This would make "test_instance" the main buffer, and keep "timer_instance"
>> as an instance.
>>
>> The "-o file" placement is important. It will make whatever came before it
>> the main buffer. And perhaps even split out more than one!
>>
>>    $ trace-cmd split -B test_instance -o test.dat -B timer_instance -o timer.dat
>>
>> Would place the "test_instance" as the main instance in test.dat, and the
>> "timer_instance" as the main instance in timer.dat.
> 
> I think it might be difficult to select the main instance and name it in
> the output file this way. As it has no specific name. I suggest to also add a '-b' parameter to designate
> the main buffer. So with the following record command:
> 
> 	$ trace-cmd record -e sched_wakeup -B switch_instance -e sched_switch -B timer_instance -e timer
> 
> 	$ trace-cmd split -B switch_instance -B timer_instance -o test.dat
> test.dat:
> - switch_instance as the main instance
> - timer_instance as a side instance (still named 'timer_instance')
> 
> 	$ trace-cmd split -b -B switch_instance -o test.dat
> test.dat:
> - main instance as the main instance
> - switch_instance as a side instance (still named 'switch_instance')
> 
> 	$ trace-cmd split -B switch_instance -b -o test.dat
> test.dat:
> - switch_instance as the main instance
> - main instance as a side instance (named 'main' [1])
> 
> 	$ trace-cmd split -B switch_instance -o test.dat -B timer_instance
> test.dat:
> - switch_instance as the main instance
> trace.dat.1
> - timer_instance as the main instance.
>     No output file is specified, so the default name is used as the output name.
> 
> 	$ trace-cmd split -B switch_instance -o test.dat -b
> test.dat:
> - switch_instance as the main instance
> trace.dat.1:
> - main instance as the main instance.
>     No output file is specified, so the default name is used as the output name.
> 
> 	$ trace-cmd split -B switch_instance -o switch.dat -b -o main.dat -B timer_instance -o timer.dat
> switch.dat:
> - switch_instance as the main instance
> main.dat:
> - main instance as the main instance
> timer.dat:
> - timer_instance as the main instance
> 
> [1]
> As the main buffer doesn't have a default name, it might be necessary
> to hardcode the name, as 'main', or as 'main.X' (X being an increasing number)
> if there is already a main instance in the trace


It would also mean that:
	$ trace-cmd split -B switch_instance -b -o switch.dat -B timer_instance -b -o timer.dat
switch.dat:
- switch_instance as the main instance
- main instance as a side instance, named 'main'
timer.dat:
- timer_instance as the main instance
- main instance as a side instance, named 'main'

And the usage of the function would be:
	$ trace-cmd split [-i file] [options] [[-b -B instance] -o file] [start [end]]
I.e. the options and start/end parameters would be common to all instances/output files.

> 
> Does it seems ok to you ?
> 
> Regards,
> Pierre
> 
>>
>> Thoughts?
>>
>> -- Steve
>>
>>
>>
>>>
>>> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=218357
>>> Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
>>> ---
>>>

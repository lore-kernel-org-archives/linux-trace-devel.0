Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 366C917C70
	for <linux-trace-devel@vger.kernel.org>; Mon, 15 Jan 2024 17:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 443B72F4;
	Mon, 15 Jan 2024 09:26:35 -0800 (PST)
Received: from [10.34.100.129] (e126645.nice.arm.com [10.34.100.129])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 48EC73F5A1;
	Mon, 15 Jan 2024 09:25:48 -0800 (PST)
Message-ID: <7f3739f5-4e68-4cf4-81f2-99f342a884d7@arm.com>
Date: Mon, 15 Jan 2024 18:25:46 +0100
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
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20240112083945.1361293-1-pierre.gondois@arm.com>
 <20240112083945.1361293-6-pierre.gondois@arm.com>
 <20240112111816.26f2cd6b@gandalf.local.home>
From: Pierre Gondois <pierre.gondois@arm.com>
In-Reply-To: <20240112111816.26f2cd6b@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello Steven,

On 1/12/24 17:18, Steven Rostedt wrote:
> On Fri, 12 Jan 2024 09:39:45 +0100
> Pierre Gondois <pierre.gondois@arm.com> wrote:
> 
>> trace-cmd can record events in multiple instances:
>>    $ trace-cmd record -e sched_wakeup -B test_instance -e sched_switch
>>
>> When trying to split a trace.dat file recorded with the above command,
>> only the events located in the main buffer seems to be split. The
>> events recorded in the test_instance buffer seem to be discarded:
>>    $ trace-cmd split -i trace.dat -o trace_2.dat 284443 284444
>>    $ trace-cmd report trace_2.dat
>>      cpus=8
>>             <...>-525991 [004] 284443.173879: sched_wakeup: [...]
>>             <...>-525991 [004] 284443.173879: sched_wakeup: [...]
>>             <...>-525990 [007] 284443.173885: sched_wakeup: [...]
>>             <...>-525990 [007] 284443.173885: sched_wakeup: [...]
>> (no sign of sched_switch events)
>>
> 
> 
>> Make use of the previous patches to split all the instances of
>> a trace.
> 
> This shouldn't be in the change log. As the change log is for history.
> Think about reading this 5 years from now. Would it make sense about
> "previous patches"?

I thought it was acceptable to do so as the previous patches would
be just before in the git log, but ok I will write something better.

> 
> Thanks for doing this, I'll try to set some time next week to review them.
> I want to release 3.3 soon.
> 
> Would you be able to add a way to split out an instance into its own
> trace.dat file?  Or to choose what you want.
> 
>   $ trace-cmd record -e sched_wakeup -B test_instance -e sched_switch
> 
>   $ trace-cmd split -B test_instance -o test.dat
> 
> Would make test_instance the main buffer in test.dat.
> 
> If you add more than one instance:
> 
>   $ trace-cmd record -e sched_wakeup -B test_instance -e sched_switch -B timer_instance -e timer
> 
>   $ trace-cmd split -B test_instance -o test.dat -B timer_instance
> 
> This would make "test_instance" the main buffer, and keep "timer_instance"
> as an instance.
> 
> The "-o file" placement is important. It will make whatever came before it
> the main buffer. And perhaps even split out more than one!
> 
>   $ trace-cmd split -B test_instance -o test.dat -B timer_instance -o timer.dat
> 
> Would place the "test_instance" as the main instance in test.dat, and the
> "timer_instance" as the main instance in timer.dat.
> 
> Thoughts?

This should be possible, I will try to make an update in this direction,

Regards,
Pierre

> 
> -- Steve
> 
> 
> 
>>
>> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=218357
>> Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
>> ---
>>

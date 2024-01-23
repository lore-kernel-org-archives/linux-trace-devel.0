Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD5965EE9E
	for <linux-trace-devel@vger.kernel.org>; Tue, 23 Jan 2024 13:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706017449; cv=none; b=pL0DA5p7vsFU3ZA71DAtjIUpsgfjTlbJ9VLBtV1Y9WI9djUnY7k941UyjJM7A/45LVLaahjvd8ETYuFHyPaVACQD4GFMbXs4fHuZqiJU8DJcECS93HGbqdLlcB8VO09gmTA5g30ODnsA3Z+KaVyMQp3F986+Kvqzi1OmVtFWBck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706017449; c=relaxed/simple;
	bh=Kx3+tiI+kFe5kNVYSi2BSdGq2pUCYLOkepYMEUUO3oo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C7bicX+YKP9wTqmpJOkJZvNYQvo/lxugmUlxxttUm8ljm0OjeGhELjLdaCiU6tPh3oXT6OAx7xjTSuN+5TeWxAAsJqmyWXTErwmYex/RJqA0aYV72/3KAjucnu31Z7Md+zxT3qohg4VQWJpOR14fPZjLA9hySnBjeACSWo9Nh/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7EC571FB;
	Tue, 23 Jan 2024 05:44:52 -0800 (PST)
Received: from [192.168.1.13] (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 871683F762;
	Tue, 23 Jan 2024 05:44:06 -0800 (PST)
Message-ID: <ce664743-fedb-46c0-b058-839e07e840b9@arm.com>
Date: Tue, 23 Jan 2024 14:44:04 +0100
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/7] trace-cmd split: Handle splitting files with
 multiple instances
Content-Language: en-US
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20240122164336.167256-1-pierre.gondois@arm.com>
 <20240122164336.167256-6-pierre.gondois@arm.com>
 <20240122192346.5a9035e2@gandalf.local.home>
From: Pierre Gondois <pierre.gondois@arm.com>
In-Reply-To: <20240122192346.5a9035e2@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello Steven,

On 1/23/24 01:23, Steven Rostedt wrote:
> On Mon, 22 Jan 2024 17:43:34 +0100
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
>> Keep all instances/buffers of a trace when it is split.
>> Also add a 'get_handle()' function.
>>
>> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=218357
>> Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
>> ---
>>
> 
> I had two trace.dat files I was checking on. One that just had the top
> level instance being traced, and the other that only had an instance.
> 
> Until now, my instance trace.dat file did not have any output when doing a
> split. Now it does. BUT! I tried the command you had shown in a previous patch:
> 
>    ./tracecmd/trace-cmd split -i trace.dat -o /tmp/trace2.dat -r -m 100 3122478 3122479
> 
> and it it kept going!
> 
> That is, this change broke the fix of the previous change.

Yes indeed,
The problem should be fixed in the v3. Thanks for the tests,

Regards,
Pierre

> 
> -- Steve

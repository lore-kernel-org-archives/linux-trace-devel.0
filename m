Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C31C16EB4A
	for <linux-trace-devel@vger.kernel.org>; Thu, 25 Jan 2024 15:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706195808; cv=none; b=jAhZGMjppGxaWyLqz6tXWsM3/JiHfWOIHT/kgUdLiY2pVozxGOxifYANLWCy6aCafgUXT7MKJfLb5aVNe0yrRagGK8TWMe2fuII1LVrP23E60Rg/L/75KQ70+SAT2S80Aw5cZ5cO6Q+w71hBN7fdYr6hjwg5998OqRVhxTmvR04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706195808; c=relaxed/simple;
	bh=qHf7D3NHihuyRAYiNhdxvQ6tnnvI9ozyFTjDPYeu7oc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E7Qd5XGb0wa1XZnT3G/yf1jYujcN7aAxCOKI9OzXeqWwh636gET9YdKhb3dJQnf+jeVDwqZzbl66uULDh1d2+itnxa8ibGsQUHllK8TTZSU5IbIsYrwthFh2KXiofs/c47h9aPnwyGVJpBMg2TQoQCLl2za96jqQy/6v73FIQro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6CDBF1FB;
	Thu, 25 Jan 2024 07:17:29 -0800 (PST)
Received: from [192.168.1.13] (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 54DFF3F5A1;
	Thu, 25 Jan 2024 07:16:44 -0800 (PST)
Message-ID: <1122630e-838e-49fc-9210-55834129088c@arm.com>
Date: Thu, 25 Jan 2024 16:16:42 +0100
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/5] trace-cmd split: Enable support for buffer
 selection
Content-Language: en-US
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20240123134215.385415-1-pierre.gondois@arm.com>
 <20240123134215.385415-5-pierre.gondois@arm.com>
 <20240124173740.6d9e2287@gandalf.local.home>
From: Pierre Gondois <pierre.gondois@arm.com>
In-Reply-To: <20240124173740.6d9e2287@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello Steven,

On 1/24/24 23:37, Steven Rostedt wrote:
> 
> [ Replying to the correct version of the patch I tested ]
> 
> On Tue, 23 Jan 2024 14:42:14 +0100
> Pierre Gondois <pierre.gondois@arm.com> wrote:
> 
>> The 'trace-cmd split' command conserves all buffers/instances
>> of the input .dat file. Add support to select the instances to
>> keep and to place as the top instance in an output .dat file.
>>
>> Multiple .dat files can be generated with different combinations
>> of the instances to keep. The first instance in the command line
>> is selected as the top instance in an output .dat file.
>>
>> For example, with a trace recorded with:
>>    $ trace-cmd record -e sched_wakeup -B switch_instance \
>>      -e sched_switch -B timer_instance -e timer
> 
> I tried this with a trace.dat file that has a instance called "tast" and it
> didn't work. Note, the top instance had no data.
> 
>    $ trace-cmd split -i /work/traces/trace-tast.dat -o /tmp/trace-tast2.dat -B tast

With this command, the expected behaviour should be:
trace-tast2.dat:
- Contains all the instances of the input trace-tast.dat file
trace-tast.dat.1:
- Contains the tast instance only, as the top instance

If the 2 files don't match the above description, there is an issue.

---

Otherwise, I believe the command line should be parsed as:
1-
Select all the desired instances with -B or --top,
the first instance is placed as the top instance.
2-
When parsing a '-o', select all the previously selected instances and
put them in the output file.
3-
Start all over again from 1-. If there is no output file described
at the end of the command line, place the result in [input_file].dat.X

So placing the output file at the end of the command line is important
here. If you think the command line should be parsed another way, please
let me know,

> 
>    $ trace-cmd report /tmp/trace-tast2.dat
> cpus=2
> tast:        trace-cmd-3559  [001] 59413.154884: sched_waking:         comm=kworker/u4:2 pid=1324 prio=120 target_cpu=000
> tast:        trace-cmd-3564  [000] 59413.154900: sched_switch:         trace-cmd:3564 [120] R ==> kworker/u4:2:1324 [120]
> tast:        trace-cmd-3559  [001] 59413.154907: sched_switch:         trace-cmd:3559 [120] S ==> trace-cmd:3565 [120]
> tast:     kworker/u4:2-1324  [000] 59413.154911: sched_waking:         comm=sshd pid=18725 prio=120 target_cpu=001
> tast:     kworker/u4:2-1324  [000] 59413.154929: sched_switch:         kworker/u4:2:1324 [120] I ==> sshd:18725 [120]
> tast:             sshd-18725 [000] 59413.155120: sched_waking:         comm=sslh-fork pid=18724 prio=120 target_cpu=001
> tast:             sshd-18725 [000] 59413.155178: sched_waking:         comm=kworker/0:1 pid=815 prio=120 target_cpu=000
> tast:             sshd-18725 [000] 59413.155189: sched_switch:         sshd:18725 [120] S ==> sslh-fork:18724 [120]
> tast:        sslh-fork-18724 [000] 59413.155303: sched_switch:         sslh-fork:18724 [120] S ==> kworker/0:1:815 [120]
> 
> Still has "tast" as an instance and not the top.> 
> -- Steve
> 
>>
>> Creating a test.dat file containing the top instance and
>> the switch_instance:
>>    $ trace-cmd split --top -B switch_instance -o test.dat
>>
>> Creating a test.dat file containing the switch_instance as
>> the top instance, and the initial top instance as an instance
>> named 'old_top':
>>    $ trace-cmd split -B switch_instance --top=old_top -o test.dat
>>
>> Splitting all instances in different .dat files:
>>    $ trace-cmd split --top -o top.dat -B switch_instance \
>>      -o switch.dat -B timer_instance -o timer.dat
>>
>> To achieve this, new 'struct name_list', 'struct output_file_list'
>> structures are created, with associated functions.
>>
>> Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
>> ---

Regards,
Pierre


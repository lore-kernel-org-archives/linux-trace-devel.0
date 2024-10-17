Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85AB31D0DF7
	for <linux-trace-devel@vger.kernel.org>; Thu, 17 Oct 2024 08:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729152406; cv=none; b=cBrp12KcD6vzxQhbR9TL9gWfWxBmuas0VBbqZV5yDM/Ir2cMPW5GUOaNoWjJzdSpGJrHS16CLVRCEBh+WNjAosDF4u+M49lXM7ikruk4Q6eNJbRBZFEDgPUEVhPSNhw5ZyCY0ztUG/R35OYoDFCtSWKwxtVu2xlp10u4s2flZxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729152406; c=relaxed/simple;
	bh=EgEJEgSy6Z0udhtKEGmKbSXkwvrJ9hc1YZdJfiBW2LU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rDcmPUbZqltU9NtVlwHk9EP+xGgqOUatCyItoLM2TIWhKbCdlbr0ri5ddPy0iCqgbt94SJ6aoVd8zKmr8Q38EORfv5RAQmHCdBkyohBTlZR6Sjx7EV93yfxvi+O1eDDt484PFkx90CdFTM5LzgoL+jfgcsfOSq8I/4Sp3fEcQJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 37FFAFEC;
	Thu, 17 Oct 2024 01:07:10 -0700 (PDT)
Received: from [10.57.21.119] (unknown [10.57.21.119])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 134FC3F71E;
	Thu, 17 Oct 2024 01:06:39 -0700 (PDT)
Message-ID: <9865d23b-1649-41d0-863c-4e227225e53e@arm.com>
Date: Thu, 17 Oct 2024 09:06:38 +0100
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] libtracefs: Have tracefs_dynevent_get_all() find kprobes
 and uprobes properly
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20241015151117.5562bd41@gandalf.local.home>
 <3c199734-5ece-4895-92b5-a15cc8b1edf1@arm.com>
 <6dbeb80b-03b2-4060-8737-3a08432590c6@arm.com>
 <20241016094609.42deb093@gandalf.local.home>
Content-Language: en-US
From: Metin Kaya <metin.kaya@arm.com>
In-Reply-To: <20241016094609.42deb093@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 16/10/2024 2:46 pm, Steven Rostedt wrote:
> On Wed, 16 Oct 2024 09:33:00 +0100
> Metin Kaya <metin.kaya@arm.com> wrote:
> 
> 
>>>
>>> I could successfully apply the patch on 4cbebed79b1f ("libtracefs:
>>> Documentation: Add missing documentation to meson.build").
>>> The unit tests at [1] passes with this patch.
>>>
>>> Just for the records, there are some unit test failures in libtracefs
>>> (they were there even before the patch):
>>>
>>> $ sudo ./utest/trace-utest
>>>        CUnit - A unit testing framework for C - Version 2.1-3
>>>        http://cunit.sourceforge.net/
>>>
>>> Memory mapped buffers not supported
>>>
>>> Suite: tracefs library
>>>     Test: Test tracefs/debugfs mounting ...FAILED
>>>       1. tracefs-utest.c:1806  - ret == 0
> 
> Note, if you have anything in the /sys/kernel/tracing directory (including
> gdb instances of trace-cmd), it will fail to unmount. I tripped over this
> too.

I ran "trace-cmd reset && umount /sys/kernel/tracing" before the unit 
test. And this error is gone.

> 
>>>     Test: trace cpu read ...passed
>>>     Test: trace cpu read_buf_percent ...passed
>>>     Test: trace cpu pipe ...passed
>>>     Test: trace pid events filter ...passed
>>>     Test: trace pid function filter ...passed
>>>     Test: trace sql ...passed
>>>     Test: trace sql trace onmax ...passed
>>>     Test: trace sql trace onchange ...passed
>>>     Test: trace sql snapshot onmax ...passed
>>>     Test: trace sql snapshot onchange ...passed
>>>     Test: trace sql save onmax ...passed
>>>     Test: trace sql save onchange ...passed
>>>     Test: trace sql trace and snapshot onmax ...passed
>>>     Test: trace sql trace and snapshot onchange ...passed
>>>     Test: tracing file / directory APIs ...passed
>>>     Test: instance file / directory APIs ...passed
>>>     Test: instance file descriptor ...passed
>>>     Test: instance reset ...passed
>>>     Test: systems and events APIs ...passed
>>>     Test: tracefs_iterate_snapshot_events API ...passed
>>>     Test: tracefs_iterate_raw_events API ...FAILED
>>>       1. tracefs-utest.c:235  - ret == sizeof(struct test_sample)
>>>       2. tracefs-utest.c:235  - ret == sizeof(struct test_sample)
> 
> Did you do a trace-cmd reset before running the tests?

Yes. And one of these failures still persists:
   Test: tracefs_iterate_snapshot_events API ...FAILED
     1. tracefs-utest.c:235  - ret == sizeof(struct test_sample)

> 
>>>     Test: Follow events ...passed
>>>     Test: Follow events clear ...passed
>>>     Test: tracefs_tracers API ...passed
>>>     Test: tracefs_local events API ...passed
>>>     Test: tracefs_instances_walk API ...passed
>>>     Test: tracefs_get_clock API ...passed
>>>     Test: tracing on / off ...passed
>>>     Test: tracing options ...passed
>>>     Test: custom system directory ...passed
>>>     Test: ftrace marker ...passed
>>>     Test: kprobes ...passed
>>>     Test: synthetic events ...passed
>>>     Test: eprobes ...passed
>>>     Test: uprobes ...FAILED
>>>       1. tracefs-utest.c:2222  - ret == 0
>>>       2. tracefs-utest.c:2222  - ret == 0
> 
> Did you have left over uprobes?

Nope. I ran "trace-cmd reset" before the test and confirmed no uprobes 
are left. But still getting these failures.

> 
>>>
>>> Run Summary:    Type    Total      Ran   Passed Failed Inactive
>>>                 suites        1        1      n/a      0        0
>>>                  tests       36       36       33      3        0
>>>                asserts 30341119 30341119 30341114      5      n/a
>>>
>>> Elapsed time =  124.937 seconds
>>>
>>> With that,
>>>
>>> Reviewed-by: Metin Kaya <metin.kaya@arm.com>
>>>
>>>
>>> Thanks a lot for fixing it promptly!
>>>
>>> [1]
>>> https://lore.kernel.org/all/20241015140840.4183007-1-metin.kaya@arm.com/
>>>
>>>    
>>
>> Sorry, I need to revoke my Reviewed-by. Because, "trace-cmd reset"
>> cannot destroy uretprobes after this patch.
>>
>> # cd /sys/kernel/tracing/
>> /sys/kernel/tracing # cat uprobe_events
>> /sys/kernel/tracing # echo 'r /bin/bash:0x4245c0' > uprobe_events
>> /sys/kernel/tracing # cat uprobe_events
>> r:uprobes/p_bash_0x4245c0 /bin/bash:0x00000000004245c0
>> /sys/kernel/tracing # trace-cmd reset
>> /sys/kernel/tracing # cat uprobe_events
>> r:uprobes/p_bash_0x4245c0 /bin/bash:0x00000000004245c0
>>
>> OTOH, "trace-cmd reset" is able to destroy uretprobes if there is also a
>> kprobe in addition to a uretprobe:
> 
> Oops, I know why. I had a bug in the code that collects all the probes and
> looks at different files. It assumed that if the return of
> tracefs_instance_file_read() returns NULL from kprobe_events, it is an
> error. But that function also returns NULL if the file is empty. I changed
> the code from:
> 
> 	content = tracefs_instance_file_read(NULL, desc->file, NULL);
> 	if (!content)
> 		return -1;
> 
> to:
> 
> 	if (!tracefs_file_exists(NULL, desc->file))
> 		return -1;
> 
> 	content = tracefs_instance_file_read(NULL, desc->file, NULL);
> 	/* File exists, but may be empty */
> 	if (!content)
> 		return 0;
> 
> I'll send out a v2. Thanks for testing.
> 
> I'll also add more tests to the libtracefs utest to check for this too.
> 
> -- Steve
> 
> 
>>
>> /sys/kernel/tracing # cat dynamic_events
>> /sys/kernel/tracing # cat uprobe_events
>> /sys/kernel/tracing # echo 'p do_sys_open' > kprobe_events
>> /sys/kernel/tracing # echo 'r /bin/bash:0x4245c0' > uprobe_events
>> /sys/kernel/tracing # cat dynamic_events
>> p:kprobes/p_do_sys_open_0 do_sys_open
>> r:uprobes/p_bash_0x4245c0 /bin/bash:0x00000000004245c0
>> /sys/kernel/tracing # cat uprobe_events
>> r:uprobes/p_bash_0x4245c0 /bin/bash:0x00000000004245c0
>> /sys/kernel/tracing # trace-cmd reset
>> /sys/kernel/tracing # cat dynamic_events
>> /sys/kernel/tracing # cat uprobe_events
>> /sys/kernel/tracing #
> 


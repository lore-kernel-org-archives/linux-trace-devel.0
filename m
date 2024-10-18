Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 335AA18FDB2
	for <linux-trace-devel@vger.kernel.org>; Fri, 18 Oct 2024 09:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729242797; cv=none; b=tKG5A2FGVk9hW4nJQuxa8ybLBVJd7/fwZhSsUBIcvW8k4WhqKs5OmtNsQ20m7eQi0NV9mnwQaOXRlBM3fCNkisv1WgyacGKRlqZCj1Hi+6/CazyGHeR3838WJ03+oW1Ea7+f/PygaY9HgSdGsuoxGfvkqOBgdy0VTxpQLwi5HIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729242797; c=relaxed/simple;
	bh=0X0ZSV3wE5BkS+HGaaZUly22TJZW3YbjqkbigzlPuE0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NKFX7rEgJ90xcuQ03n2mNpOX7ZpkynoPiWnWfyApeJyUJSY5Ep3Rbgj5CEEfO9PZqCsdJj2Nff1OIz1rYUE8//LBqWQu+R3Xpae0aqw+pjBiHup73y8S/vNNEDc4SQ3pcs7o9OrfV+m5o8LsLp1ha3lXhVbyToy+38Ty5x/jDOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 04FB3FEC;
	Fri, 18 Oct 2024 02:13:43 -0700 (PDT)
Received: from [10.57.23.165] (unknown [10.57.23.165])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D86883F58B;
	Fri, 18 Oct 2024 02:13:12 -0700 (PDT)
Message-ID: <6c67124d-a806-42d6-a2c5-a74cccb4fce3@arm.com>
Date: Fri, 18 Oct 2024 10:13:11 +0100
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] libtracefs: Destroy synthetic and eprobes before other
 events
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20241016123552.55efa78f@gandalf.local.home>
 <e6ddd9b6-ce83-451e-8344-24ff620245cc@arm.com>
 <20241017160108.4f99c917@gandalf.local.home>
Content-Language: en-US
From: Metin Kaya <metin.kaya@arm.com>
In-Reply-To: <20241017160108.4f99c917@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 17/10/2024 9:01 pm, Steven Rostedt wrote:
> On Thu, 17 Oct 2024 09:38:35 +0100
> Metin Kaya <metin.kaya@arm.com> wrote:
> 
>> I see one more failure in this section of unit tests:
>>
>>     Test: tracefs_iterate_snapshot_events API ...FAILED
>>       1. tracefs-utest.c:235  - ret == sizeof(struct test_sample)
>>       2. tracefs-utest.c:235  - ret == sizeof(struct test_sample)
>>       3. tracefs-utest.c:235  - ret == sizeof(struct test_sample)
>>
> 
> Does this occur without this patch? IOW, is this caused by this patch?

I thought there were 2 "tracefs-utest.c:235  - ret == sizeof(struct 
test_sample)" failures before this patch and this patch increased the 
number of failures by 1. However, this does not seem to be 100% correct. 
I sometimes see only 1 failure, but then there are 2-3 of them.

I do trace-cmd reset && unmount before running the unit tests.

> 
>> I did run trace-cmd reset and unmounted my tracefs before running the
>> unit tests.
>> Please feel free to ignore if something is weirdly wrong in my setup.
>>
>> Other than that -kind of existing- failure, the patch looks good to me
>> (e.g., trace-cmd unit tests are working fine).
> 
> 
> Can you add a printf("ret = %d\n", ret) to find out what "ret" is?

Here is the output with printf's:

   ...
   Test: tracefs_iterate_snapshot_events API ...
line=237 i=87 path=n~_ cpu=55 value=2046397138 ret=-1
FAILED
     1. tracefs-utest.c:240  - ret == sizeof(struct test_sample)
   Test: tracefs_iterate_raw_events API ...
line=237 i=1444 path=~_ cpu=50 value=1150454427 ret=-1
FAILED
     1. tracefs-utest.c:240  - ret == sizeof(struct test_sample)
   Test: Follow events ...passed
   ...
   Test: uprobes ...
line=2229 ename=utest_u 
address=/libtracefs/utest/trace-utest:0x00000000000003e8 event=utest_u 
system=utest format=arg1=$stack2 prefix=p type=0x000004 ret=-1

line=2229 ename=utest_r 
address=/libtracefs/utest/trace-utest:0x00000000000003e8 event=utest_r 
system=utest format=arg1=$retval prefix=r type=0x000008 ret=-1
FAILED
     1. tracefs-utest.c:2232  - ret == 0
     2. tracefs-utest.c:2232  - ret == 0


And this is the output with your "libtracefs utest: Fixes and new tests" 
patch series [1]:

   Test: tracefs_iterate_raw_events API ...
line=237 i=2532 path=Db cpu=0 value=1144606227 ret=-1

line=237 i=1285 path=ו3b cpu=6 value=1157898007 ret=-1
FAILED
     1. tracefs-utest.c:240  - ret == sizeof(struct test_sample)
     2. tracefs-utest.c:240  - ret == sizeof(struct test_sample)
   Test: Follow events ...passed
   Test: Follow events clear ...passed
   Test: tracefs_tracers API ...passed
   Test: tracefs_local events API ...passed
   Test: tracefs_instances_walk API ...passed
   Test: tracefs_get_clock API ...passed
   Test: tracing on / off ...passed
   Test: tracing options ...passed
   Test: custom system directory ...passed
   Test: ftrace marker ...passed
   Test: kprobes ...passed
   Test: synthetic events ...passed
   Test: eprobes ...passed
   Test: uprobes ...
line=2249 ename=utest_u 
address=/ssd/tracecmd-work/libtracefs/utest/trace-utest:0x00000000000003e8 
event=utest_u system=utest format=arg1=$stack2 prefix=p type=0x000004 ret=-1

line=2249 ename=utest_r 
address=/ssd/tracecmd-work/libtracefs/utest/trace-utest:0x00000000000003e8 
event=utest_r system=utest format=arg1=$retval prefix=r type=0x000008 ret=-1
FAILED
     1. tracefs-utest.c:2252  - ret == 0
     2. tracefs-utest.c:2252  - ret == 0
   Test: multi probe test ...
line=2249 ename=utest_u 
address=/ssd/tracecmd-work/libtracefs/utest/trace-utest:0x00000000000003e8 
event=utest_u system=utest format=arg1=$stack2 prefix=p type=0x000004 ret=-1

line=2249 ename=utest_r 
address=/ssd/tracecmd-work/libtracefs/utest/trace-utest:0x00000000000003e8 
event=utest_r system=utest format=arg1=$retval prefix=r type=0x000008 ret=-1
FAILED
     1. tracefs-utest.c:2252  - ret == 0
     2. tracefs-utest.c:2252  - ret == 0

Thanks,

[1] 
https://lore.kernel.org/linux-trace-devel/20241017200609.932728-1-rostedt@goodmis.org 


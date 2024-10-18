Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D384D1FF619
	for <linux-trace-devel@vger.kernel.org>; Fri, 18 Oct 2024 14:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729263085; cv=none; b=iV2yL1spvIOKdgmIsLhvhJZAMkKpuQ1aekqR8iapVTCNWPWCw1y4n4ZqOlrtdhurbVvye0zq3pdDqhY/bYKtzCHMWJ8cPRPJZDaQIw50e6CSprIcVZ437wf/jJo7TTZK4gTTMuC4JAo2o0aM/wD9Z59ld44RuBpb7TcufggjhUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729263085; c=relaxed/simple;
	bh=l8Akf/GldAG/8BBqpfnwPVpdwVmCH7Emmqjq3Bsc4Xo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iVGDfDJ8Yx8gfbpIResZZad5taeT6DKTx4UdGF3VYxQL/8Uwq9QoIaHcDtgFS1jbV0SpmjBtrCmTr3NBx+Ra6g3voucIafqSOcKAA9WKGci24wb+uxzIWNHTSnCBl/ayC5VjykPHt/LUtJoF/O4KO9pRMq5szmT1mIjt2U/juzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EDF26DA7;
	Fri, 18 Oct 2024 07:51:51 -0700 (PDT)
Received: from [10.57.23.165] (unknown [10.57.23.165])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ED2AF3F58B;
	Fri, 18 Oct 2024 07:51:21 -0700 (PDT)
Message-ID: <cf4686b0-5e1e-4839-9484-7611e288f4b7@arm.com>
Date: Fri, 18 Oct 2024 15:51:20 +0100
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
 <6c67124d-a806-42d6-a2c5-a74cccb4fce3@arm.com>
 <20241018101751.76f6886f@gandalf.local.home>
Content-Language: en-US
From: Metin Kaya <metin.kaya@arm.com>
In-Reply-To: <20241018101751.76f6886f@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 18/10/2024 3:17 pm, Steven Rostedt wrote:
> On Fri, 18 Oct 2024 10:13:11 +0100
> Metin Kaya <metin.kaya@arm.com> wrote:
> 
>> On 17/10/2024 9:01 pm, Steven Rostedt wrote:
>>> On Thu, 17 Oct 2024 09:38:35 +0100
>>> Metin Kaya <metin.kaya@arm.com> wrote:
>>>    
>>>> I see one more failure in this section of unit tests:
>>>>
>>>>      Test: tracefs_iterate_snapshot_events API ...FAILED
>>>>        1. tracefs-utest.c:235  - ret == sizeof(struct test_sample)
>>>>        2. tracefs-utest.c:235  - ret == sizeof(struct test_sample)
>>>>        3. tracefs-utest.c:235  - ret == sizeof(struct test_sample)
>>>>   
>>>
>>> Does this occur without this patch? IOW, is this caused by this patch?
>>
>> I thought there were 2 "tracefs-utest.c:235  - ret == sizeof(struct
>> test_sample)" failures before this patch and this patch increased the
>> number of failures by 1. However, this does not seem to be 100% correct.
>> I sometimes see only 1 failure, but then there are 2-3 of them.
>>
>> I do trace-cmd reset && unmount before running the unit tests.
> 
> Yeah, this is probably something different.
> 
>>
>>>    
>>>> I did run trace-cmd reset and unmounted my tracefs before running the
>>>> unit tests.
>>>> Please feel free to ignore if something is weirdly wrong in my setup.
>>>>
>>>> Other than that -kind of existing- failure, the patch looks good to me
>>>> (e.g., trace-cmd unit tests are working fine).
>>>
>>>
>>> Can you add a printf("ret = %d\n", ret) to find out what "ret" is?
>>
>> Here is the output with printf's:
>>
>>     ...
>>     Test: tracefs_iterate_snapshot_events API ...
>> line=237 i=87 path=n~_ cpu=55 value=2046397138 ret=-1
>> FAILED
>>       1. tracefs-utest.c:240  - ret == sizeof(struct test_sample)
>>     Test: tracefs_iterate_raw_events API ...
>> line=237 i=1444 path=~_ cpu=50 value=1150454427 ret=-1
>> FAILED
>>       1. tracefs-utest.c:240  - ret == sizeof(struct test_sample)
>>     Test: Follow events ...passed
>>     ...
> 
> Hmm, looking at the code, I think it should be using trace_marker_raw and
> not trace_marker. Although I don't believe that will fix this, it is still
> something that needs to be changed.
> 
> -	path = tracefs_instance_get_file(instance, "trace_marker");
> +	path = tracefs_instance_get_file(instance, "trace_marker_raw");

"tracefs-utest.c:285" failure ("CU_TEST(test_array[i].value == 0)" check 
in iter_raw_events_on_cpu()) is printed hundreds of times (did not count 
exact number, but there were too many):

     ...
     10058. tracefs-utest.c:285  - test_array[i].value == 0
     10059. tracefs-utest.c:285  - test_array[i].value == 0
     10060. tracefs-utest.c:285  - test_array[i].value == 0
     10061. tracefs-utest.c:285  - test_array[i].value == 0
     10062. tracefs-utest.c:285  - test_array[i].value == 0
     10063. tracefs-utest.c:285  - test_array[i].value == 0
     10064. tracefs-utest.c:290  - test_found == check

> 
> As trace_marker expects strings but trace_marker_raw takes binary data, and
> we are writing binary data here.
> 
> Could you also add a "perror()" when it fails. The ret=-1 means the write
> failed, so it would be good to know why it failed.
> 
>>     Test: uprobes ...
>> line=2229 ename=utest_u
>> address=/libtracefs/utest/trace-utest:0x00000000000003e8 event=utest_u
>> system=utest format=arg1=$stack2 prefix=p type=0x000004 ret=-1
>>
>> line=2229 ename=utest_r
>> address=/libtracefs/utest/trace-utest:0x00000000000003e8 event=utest_r
>> system=utest format=arg1=$retval prefix=r type=0x000008 ret=-1
>> FAILED
>>       1. tracefs-utest.c:2232  - ret == 0
>>       2. tracefs-utest.c:2232  - ret == 0
>>
>>
>> And this is the output with your "libtracefs utest: Fixes and new tests"
>> patch series [1]:
>>
>>     Test: tracefs_iterate_raw_events API ...
>> line=237 i=2532 path=Db cpu=0 value=1144606227 ret=-1
>>
>> line=237 i=1285 path=ו3b cpu=6 value=1157898007 ret=-1
>> FAILED
>>       1. tracefs-utest.c:240  - ret == sizeof(struct test_sample)
>>       2. tracefs-utest.c:240  - ret == sizeof(struct test_sample)
>>     Test: Follow events ...passed
>>     Test: Follow events clear ...passed
>>     Test: tracefs_tracers API ...passed
>>     Test: tracefs_local events API ...passed
>>     Test: tracefs_instances_walk API ...passed
>>     Test: tracefs_get_clock API ...passed
>>     Test: tracing on / off ...passed
>>     Test: tracing options ...passed
>>     Test: custom system directory ...passed
>>     Test: ftrace marker ...passed
>>     Test: kprobes ...passed
>>     Test: synthetic events ...passed
>>     Test: eprobes ...passed
>>     Test: uprobes ...
>> line=2249 ename=utest_u
>> address=/ssd/tracecmd-work/libtracefs/utest/trace-utest:0x00000000000003e8
>> event=utest_u system=utest format=arg1=$stack2 prefix=p type=0x000004 ret=-1
>>
>> line=2249 ename=utest_r
>> address=/ssd/tracecmd-work/libtracefs/utest/trace-utest:0x00000000000003e8
>> event=utest_r system=utest format=arg1=$retval prefix=r type=0x000008 ret=-1
>> FAILED
>>       1. tracefs-utest.c:2252  - ret == 0
>>       2. tracefs-utest.c:2252  - ret == 0
>>     Test: multi probe test ...
>> line=2249 ename=utest_u
>> address=/ssd/tracecmd-work/libtracefs/utest/trace-utest:0x00000000000003e8
>> event=utest_u system=utest format=arg1=$stack2 prefix=p type=0x000004 ret=-1
>>
>> line=2249 ename=utest_r
>> address=/ssd/tracecmd-work/libtracefs/utest/trace-utest:0x00000000000003e8
>> event=utest_r system=utest format=arg1=$retval prefix=r type=0x000008 ret=-1
>> FAILED
>>       1. tracefs-utest.c:2252  - ret == 0
>>       2. tracefs-utest.c:2252  - ret == 0
> 
> Can you tell me what is at line 2252 because I don't know what patches you
> have applied, and 2252 in my code doesn't mean anything.

Added perror() and reran the unit tests:

   Test: tracefs_iterate_snapshot_events API ...
write(): Bad address
line=238 i=1854 path=C cpu=48 value=204815716 ret=-1
FAILED
     1. tracefs-utest.c:242  - ret == sizeof(struct test_sample)
   Test: tracefs_iterate_raw_events API ...
write(): Bad address
line=238 i=3387 path=VCȿX cpu=47 value=1880503296 ret=-1
write(): Bad address
line=238 i=1452 path=ZȿX cpu=10 value=1748578433 ret=-1
write(): Bad address
line=238 i=1257 path=:SX cpu=14 value=289785431 ret=-1
write(): Bad address
line=238 i=3373 pathC cpu=39 value=178899675 ret=-1
FAILED
     1. tracefs-utest.c:242  - ret == sizeof(struct test_sample)
     2. tracefs-utest.c:242  - ret == sizeof(struct test_sample)
     3. tracefs-utest.c:242  - ret == sizeof(struct test_sample)
     4. tracefs-utest.c:242  - ret == sizeof(struct test_sample)
   Test: Follow events ...passed
   ...
   Test: eprobes ...passed
   Test: uprobes ...
line=2251 ename=utest_u 
address=/ssd/tracecmd-work/libtracefs/utest/trace-utest:0x00000000000003e8 
event=utest_u system=utest format=arg1=$stack2 prefix=p type=0x000004 ret=-1
line=2251 ename=utest_r 
address=/ssd/tracecmd-work/libtracefs/utest/trace-utest:0x00000000000003e8 
event=utest_r system=utest format=arg1=$retval prefix=r type=0x000008 ret=-1
FAILED
     1. tracefs-utest.c:2255  - ret == 0
     2. tracefs-utest.c:2255  - ret == 0
   Test: multi probe test ...
line=2251 ename=utest_u 
address=/ssd/tracecmd-work/libtracefs/utest/trace-utest:0x00000000000003e8 
event=utest_u system=utest format=arg1=$stack2 prefix=p type=0x000004 ret=-1
line=2251 ename=utest_r 
address=/ssd/tracecmd-work/libtracefs/utest/trace-utest:0x00000000000003e8 
event=utest_r system=utest format=arg1=$retval prefix=r type=0x000008 ret=-1
FAILED
     1. tracefs-utest.c:2255  - ret == 0
     2. tracefs-utest.c:2255  - ret == 0


Snippet regarding "tracefs-utest.c:242" failure:

  227         for (i = 0; i < TEST_ARRAY_SIZE; i++) {
  228                 test_array[i].cpu = rand() % cpus;
  229                 test_array[i].value = random(); 

  230                 if (!test_array[i].value)
  231                         test_array[i].value++; 

  232                 CU_TEST(test_array[i].cpu < cpus);
  233                 set_affinity(test_array[i].cpu);
  234                 ret = write(fd, test_array + i, sizeof(struct 
test_sample));
  235                 if (ret != sizeof(struct test_sample)) {
  236                         perror("\nwrite()"); 

  237                         printf("\nline=%d i=%d path=%s cpu=%d 
value=%d ret=%d\n",
  238                                __LINE__,
  239                                i, path, test_array[i].cpu, 
test_array[i].value,
  240                                ret);
  241                 }
  242                 CU_TEST(ret == sizeof(struct test_sample));


Snippet regarding "tracefs-utest.c:2255" failure:

2244                         if (probes[j].prefix) {
2245                                 CU_TEST(strcmp(probes[j].prefix, 
prefix) == 0);
2246                         }
2247                         ret = tracefs_event_enable(instance, 
system, event);
2248                         if (in_system) {
2249                                 if (ret != 0) {
2250                                         printf("\nline=%d ename=%s 
address=%s event=%s system=%s format=%s prefix=%s type=%#08x ret=%d\n",
2251                                                __LINE__,
2252                                                ename, address, 
event, system, format, prefix, type,
2253                                                ret);
2254                                 }
2255                                 CU_TEST(ret == 0);
2256                         } else {
2257                                 if (ret == 0) {
2258                                         printf("\nline=%d ename=%s 
address=%s event=%s system=%s format=%s prefix=%s type=%#08x ret=%d\n",
2259                                                __LINE__,
2260                                                ename, address, 
event, system, format, prefix, type,
2261                                                ret);
2262                                 }
2263                                 CU_TEST(ret != 0);
2264                         }


I've these patches in my stash:

* 8468f2e - (HEAD -> libtracefs) libtracefs utest: Add debug logs <Metin 
Kaya>
* cee05c1 - libtracefs utest: Do not test more events than what the ring 
buffer can hold <Steven Rostedt (Google)>
* 385650c - libtracefs utest: Fix min percent test <Steven Rostedt (Google)>
* c0810b9 - libtracefs utest: Add test to check handling multiple 
dynamic events <Steven Rostedt (Google)>
* d8fcfff - libtracefs: Destroy synthetic and eprobes before other 
events <Steven Rostedt (Google)>
* 78d8d2e - (origin/libtracefs, origin/HEAD) libtracefs: Have 
tracefs_dynevent_get_all() find kprobes and uprobes properly <Steven 
Rostedt (Google)>

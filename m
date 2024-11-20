Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29A5E158D79
	for <linux-trace-devel@vger.kernel.org>; Wed, 20 Nov 2024 07:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732088539; cv=none; b=lroRe3f+pkGH2RWdxNwDJYonNGj13Lu/lIXKxsdZepn/3voDjwzUI9bDbt3mPDZLMBOSYSBJQOL+iIEdPyYCgz3dLvL7amrTDOc2gN+0ar9uBc1oAqolMOW4Gx6mc/Q2wFWt0eAMEG3ly/FYqwxZ/RMEJw9iZLGShgzemgNBW04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732088539; c=relaxed/simple;
	bh=o9kHG8LH/f5u3zLKzRaTgygTz339p/1JMw7kC8SpW+4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ghYMu7i/o+X93bOY/j9wK1rzZxky8L/jAAjtDnH7b59e0/lUxEa6YUlk7sYa05T+7TlKcWFB9Ve8XdXVDJelPOLDjjN3atvKahfiYy+/3+iL8FAmx0cLS1R2+noZig9T/xUdziysE0RXEIf+4q+EaSTl15jQs3dJZszVRWcUVY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 12E961480;
	Tue, 19 Nov 2024 23:42:46 -0800 (PST)
Received: from [10.57.60.72] (unknown [10.57.60.72])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 774743F66E;
	Tue, 19 Nov 2024 23:42:15 -0800 (PST)
Message-ID: <3f49972a-d011-45f9-a173-8959d1c5de0d@arm.com>
Date: Wed, 20 Nov 2024 07:42:13 +0000
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
 <cf4686b0-5e1e-4839-9484-7611e288f4b7@arm.com>
 <20241119225737.1a19a573@rorschach.local.home>
Content-Language: en-US
From: Metin Kaya <metin.kaya@arm.com>
In-Reply-To: <20241119225737.1a19a573@rorschach.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20/11/2024 3:57 am, Steven Rostedt wrote:
> On Fri, 18 Oct 2024 15:51:20 +0100
> Metin Kaya <metin.kaya@arm.com> wrote:
> 
>> I've these patches in my stash:
>>
>> * 8468f2e - (HEAD -> libtracefs) libtracefs utest: Add debug logs <Metin
>> Kaya>
>> * cee05c1 - libtracefs utest: Do not test more events than what the ring
>> buffer can hold <Steven Rostedt (Google)>
>> * 385650c - libtracefs utest: Fix min percent test <Steven Rostedt (Google)>
>> * c0810b9 - libtracefs utest: Add test to check handling multiple
>> dynamic events <Steven Rostedt (Google)>
>> * d8fcfff - libtracefs: Destroy synthetic and eprobes before other
>> events <Steven Rostedt (Google)>
>> * 78d8d2e - (origin/libtracefs, origin/HEAD) libtracefs: Have
>> tracefs_dynevent_get_all() find kprobes and uprobes properly <Steven
>> Rostedt (Google)>
> 
> I haven't applied this patch yet (but plan to). Is this still an issue
> for you?
> 
> -- Steve

I've some unit test failures (shown below) regardless of this patch. 
Tried to debug, but could not find the root cause.
This patch at least does not increase number of failures, but please 
ignore my setup for verifying it.

...
   Test: tracefs_iterate_snapshot_events API ...FAILED
     1. tracefs-utest.c:235  - ret == sizeof(struct test_sample)
     2. tracefs-utest.c:235  - ret == sizeof(struct test_sample)
     3. tracefs-utest.c:235  - ret == sizeof(struct test_sample)
   Test: tracefs_iterate_raw_events API ...FAILED
     1. tracefs-utest.c:235  - ret == sizeof(struct test_sample)
     2. tracefs-utest.c:235  - ret == sizeof(struct test_sample)
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
   Test: uprobes ...FAILED
     1. tracefs-utest.c:2222  - ret == 0
     2. tracefs-utest.c:2222  - ret == 0

Run Summary:    Type    Total      Ran   Passed Failed Inactive
               suites        1        1      n/a      0        0
                tests       36       36       33      3        0
              asserts 26933635 26933635 26933628      7      n/a

Thanks,

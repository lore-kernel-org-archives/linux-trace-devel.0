Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6354C399018
	for <linux-trace-devel@vger.kernel.org>; Mon, 27 Apr 2026 08:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777278829; cv=none; b=FkG/bpWc7AaybDL0CaUpRsarjrwWNB6G1oeHZDEgf0zxtLXIsXWKuAZMas8YnfS68ubpDFmgiWb6+tVGDyNkiWouyWhE9NHW4fkz+mOHNTrKxaLBOxQCn3toW463G1VDz5Q2ZLDt0vKjBTnoPRrZa/TLKxts4rNLNGNPURZrt5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777278829; c=relaxed/simple;
	bh=byTX0vQjlIcl1G3hSAGkto6OEps5qpzyQtYiOHy5Kkg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=KkrcjB2Uq28ENaY+Z4FHBPdOPykxqouUc91XVKEgHEe8GrgLyiUy3hYc67F8ot9AVroOqcM0QQOC2hr3/erYevJr77xp3aBS4JQhX96u4NEMQoy2H1WqZpWp5LpRcjVa0apnztzDHY9mxRYKdRFNDkLsUSCuahcVkmOepYfOags=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=vqTFUsH0; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="vqTFUsH0"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C6C4B1684;
	Mon, 27 Apr 2026 01:33:40 -0700 (PDT)
Received: from [10.57.20.119] (unknown [10.57.20.119])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 838293F62B;
	Mon, 27 Apr 2026 01:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777278825; bh=byTX0vQjlIcl1G3hSAGkto6OEps5qpzyQtYiOHy5Kkg=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=vqTFUsH0SnO4tZCDVeXnB22srNtnCO2NUtN4o073oxghpeUhGCZy3+RPelXM0HOkt
	 2MbkcLNkJOY1vfikqUGo4YIVXUCQ8Q2Ve8zDP6mpHaNWYfz6HIyeg8JLf6E/YiGI1E
	 cC/Dp/g8wAofusli5yVw3YI5rDXkVyuU2Ur2YWfI=
Message-ID: <b4b1bc5e-f983-4940-acdf-edda98996f23@arm.com>
Date: Mon, 27 Apr 2026 09:33:44 +0100
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] tracefs: Add tests for clearing kprobes with
 tracefs_dynevent_destroy_all()
To: Steven Rostedt <rostedt@goodmis.org>,
 Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20260424144839.36b51d90@gandalf.local.home>
Content-Language: en-US
From: Metin Kaya <metin.kaya@arm.com>
In-Reply-To: <20260424144839.36b51d90@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24/04/2026 7:48 pm, Steven Rostedt wrote:
> From: Steven Rostedt <rostedt@goodmis.org>
> 
> There was a regression with the use of tracefs_dynevent_destroy_all() where
> it wasn't resetting kprobe events. Add testing of that function in the utest
> for kprobe events.
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=221395
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
> Changes since v1: https://lore.kernel.org/20260423162207.5a888de0@gandalf.local.home
> 
> - Remove leftover debugging (had kprobe test first followed by a return).
>     (Metin Kaya)
> 
>   utest/tracefs-utest.c | 23 +++++++++++++++++++++++
>   1 file changed, 23 insertions(+)
> 
> diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
> index 97a91dfcdb2c..e3ff2151796b 100644
> --- a/utest/tracefs-utest.c
> +++ b/utest/tracefs-utest.c
> @@ -2330,6 +2330,7 @@ static void test_kprobes_instance(struct tracefs_instance *instance)
>   	/* kprobes APIs */
>   	destroy_dynevents(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE);
>   
> +	/* Allocate first */
>   	for (i = 0; i < kprobe_count; i++) {
>   		dkprobe[i] = tracefs_kprobe_alloc(ktests[i].system, ktests[i].event,
>   						  ktests[i].address, ktests[i].format);
> @@ -2348,6 +2349,7 @@ static void test_kprobes_instance(struct tracefs_instance *instance)
>   	get_dynevents_check(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE, 0);
>   	CU_TEST(check_probes(kretests, kretprobe_count, dkretprobe, false, instance, tep));
>   
> +	/* Create the kprobes */
>   	for (i = 0; i < kprobe_count; i++) {
>   		CU_TEST(tracefs_dynevent_create(dkprobe[i]) == 0);
>   	}
> @@ -2387,6 +2389,27 @@ static void test_kprobes_instance(struct tracefs_instance *instance)
>   	tracefs_dynevent_list_free(devents);
>   	devents = NULL;
>   
> +	/* Recreate both types, and destroy with tracefs_dynevent_destroy_all() */
> +	for (i = 0; i < kretprobe_count; i++) {
> +		CU_TEST(tracefs_dynevent_create(dkretprobe[i]) == 0);
> +	}
> +	for (i = 0; i < kprobe_count; i++) {
> +		CU_TEST(tracefs_dynevent_create(dkprobe[i]) == 0);
> +	}
> +	devents = get_dynevents_check(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE,
> +				    kprobe_count + kretprobe_count);
> +	CU_TEST(check_probes(ktests, kprobe_count, devents, true, instance, tep));
> +	CU_TEST(check_probes(kretests, kretprobe_count, dkretprobe, true, instance, tep));
> +	tracefs_dynevent_list_free(devents);
> +	devents = NULL;
> +
> +	CU_TEST(tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_ALL, true) == 0);
> +
> +	get_dynevents_check(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE, 0);
> +	CU_TEST(check_probes(ktests, kprobe_count, dkprobe, false, instance, tep));
> +	CU_TEST(check_probes(kretests, kretprobe_count, dkretprobe, false, instance, tep))
> +
> +	/* Free the dynamic events */
>   	for (i = 0; i < kprobe_count; i++)
>   		tracefs_dynevent_free(dkprobe[i]);
>   	for (i = 0; i < kretprobe_count; i++)

`utest/trace-utest` output looks good to me:

```
Suite: tracefs library
   Test: Test tracefs/debugfs mounting ...passed
   Test: trace cpu read ...passed
   ...
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
   Test: uprobes ...passed
   Test: multi probe test ...passed

Run Summary:    Type    Total      Ran   Passed Failed Inactive
               suites        1        1      n/a      0        0
                tests       37       37       37      0        0
              asserts 29270699 29270699 29270699      0      n/a

Elapsed time =  158.795 seconds
```

Tested-by: Metin Kaya <metin.kaya@arm.com>

Thanks,


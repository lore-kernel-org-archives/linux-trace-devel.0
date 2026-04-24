Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E20CF30E853
	for <linux-trace-devel@vger.kernel.org>; Fri, 24 Apr 2026 08:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777017857; cv=none; b=RHN8Dk7ZArwF14+YU+8y28HgidFbn7UYiADEGU5GRSrGlBoxYMMnfPQQ/qAW3wTE4qvu8m48aOPq7STBANagbVIx869jh+gsCkA14ofdZj8rdH7XoiOHAk1RC8h4Y35cOI5sx0G+ef49/uzdgATbEUk679D46PLdFUhT/IJHDn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777017857; c=relaxed/simple;
	bh=p1tX26TYYCJZeM3maatpElUbaFjodlIGFvux+zZ2Kg4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=kMQosD3iM1OZRr8ioGrwGSN/cnD9dzlwNT4laJTNxwOKmE5lxStgTarcVEmgyj3IB4A5H5/4s7sncASK20wRGGl36gCP9wVFuGs8zIY+TLsDZMfKni6Vm2iwOt0SX3kWj2AWxVtauaOwdyb19IaS93DkgzS3pdUlSNZboHlpFE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Ybxj8IzY; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Ybxj8IzY"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6CADD1BC0;
	Fri, 24 Apr 2026 01:04:08 -0700 (PDT)
Received: from [10.57.22.222] (unknown [10.57.22.222])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 704C23F641;
	Fri, 24 Apr 2026 01:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777017853; bh=p1tX26TYYCJZeM3maatpElUbaFjodlIGFvux+zZ2Kg4=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=Ybxj8IzYET6lyLd7vn7o60y1EZeTE0T1e4C4gFyVUqj9l31KFHdjrYbaWQ/fsd/N4
	 cHQ4VIJipHOWUobv6UqEnmx2rxhYS3FbI9wjqLt5GcBNCCbxesING+1DSfEKqw9La3
	 GQ4i0ynX8plSg1CbKtbEYveggG15poJTcFmBaEFw=
Message-ID: <4aacf951-c96d-47e5-a4ca-9e0eee8d3928@arm.com>
Date: Fri, 24 Apr 2026 09:04:10 +0100
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] tracefs: Add tests for clearing kprobes with
 tracefs_dynevent_destroy_all()
To: Steven Rostedt <rostedt@goodmis.org>,
 Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20260423162207.5a888de0@gandalf.local.home>
Content-Language: en-US
From: Metin Kaya <metin.kaya@arm.com>
In-Reply-To: <20260423162207.5a888de0@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 23/04/2026 9:22 pm, Steven Rostedt wrote:
> From: Steven Rostedt <rostedt@goodmis.org>
> 
> There was a regression with the use of tracefs_dynevent_destroy_all() where
> it wasn't resetting kprobe events. Add testing of that function in the utest
> for kprobe events.
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=221395
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>   utest/tracefs-utest.c | 27 +++++++++++++++++++++++++--
>   1 file changed, 25 insertions(+), 2 deletions(-)
> 
> diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
> index 353b3cbee199..7ec7b42eebb0 100644
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
> @@ -3966,7 +3989,8 @@ void test_tracefs_lib(void)
>   		fprintf(stderr, "Suite \"%s\" cannot be ceated\n", TRACEFS_SUITE);
>   		return;
>   	}
> -
> +	CU_add_test(suite, "kprobes", test_kprobes);

I think we can keep `kprobes` in its old location to make the patch simpler.

> +	return;

This line should be left-over from testing I guess :)

Thanks,

>   	CU_add_test(suite, "Test tracefs/debugfs mounting", test_mounting);
>   	CU_add_test(suite, "trace cpu read",
>   		    test_trace_cpu_read);
> @@ -4032,7 +4056,6 @@ void test_tracefs_lib(void)
>   		    test_custom_trace_dir);
>   	CU_add_test(suite, "ftrace marker",
>   		    test_ftrace_marker);
> -	CU_add_test(suite, "kprobes", test_kprobes);
>   	CU_add_test(suite, "synthetic events", test_synthetic);
>   	CU_add_test(suite, "eprobes", test_eprobes);
>   	CU_add_test(suite, "uprobes", test_uprobes);


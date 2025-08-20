Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2774218AB4
	for <linux-trace-devel@vger.kernel.org>; Wed, 20 Aug 2025 07:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755675053; cv=none; b=K/lsx+e78SrK9OqBWYK/BKlTAsyLD3mPCUf83/iapLlECH03G34b4mjp3//UkY45CGhMMh9NZspoNq6EFSl0BEYrtj2bi52eYV1cQOAXtCupyAFfrUd8qknTjXSQSD1HYO/J/b5D5wjOBlbgXN0b0Xt9itWsGna+pVwlO2TXxls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755675053; c=relaxed/simple;
	bh=lrFwCOa2TsxxiZU20RUkCCYc0+NZbx6OFjC+9sNYhnA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=puYH1/sgjrFiH8NUNvf8slim6S0mzB8zxYcetV5XwvLdWOUrR28s2n2d0W5Ge2+KJExO1HFezEIh97zPZgalIfZu4n53IB2nO7ec3CibCu9yoXy5M75/9cwla0mpFXJstyb9qH4FpSKoFgTLjthtmnWytrt+V8FhKalmb6JuQ20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E017A1515;
	Wed, 20 Aug 2025 00:30:42 -0700 (PDT)
Received: from [10.57.5.131] (unknown [10.57.5.131])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 773653F58B;
	Wed, 20 Aug 2025 00:30:50 -0700 (PDT)
Message-ID: <24223bf6-bd00-43a3-b7ac-f4b8ef97307c@arm.com>
Date: Wed, 20 Aug 2025 08:30:48 +0100
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCH] libtraceevent: Fix static library to hide hidden
 functions
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
 Douglas Raillard <douglas.raillard@arm.com>
References: <20250814144710.6c3458d4@gandalf.local.home>
 <c0d09a7e-c3a2-468d-a81d-cdef37f4c575@arm.com>
 <20250815132603.6b347952@gandalf.local.home>
 <b6a51783-7867-46a7-90ab-7be69c7112a0@arm.com>
 <20250819155617.73f91fd6@gandalf.local.home>
Content-Language: en-US
From: Metin Kaya <metin.kaya@arm.com>
In-Reply-To: <20250819155617.73f91fd6@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 19/08/2025 8:56 PM, Steven Rostedt wrote:
> On Tue, 19 Aug 2025 15:04:32 +0100
> Metin Kaya <metin.kaya@arm.com> wrote:
> 
>> Now this is what I get when I try to build trace-cmd:
>>
>>     BUILD                  trace-cmd
>> /usr/bin/ld: /out/lib64/libtraceevent.a(libtraceevent.o): in function
>> `load_plugin':
>> /libtraceevent/src/event-plugin.c:459:(.text+0x1458c): warning: Using
>> 'dlopen' in statically linked applications requires at runtime the
>> shared libraries from the glibc version used for linking
>> /usr/bin/ld: /trace-cmd/tracecmd/trace-setup-guest.o: in function
>> `trace_setup_guest':
>> trace-setup-guest.c:(.text+0x5c8): warning: Using 'getgrnam' in
>> statically linked applications requires at runtime the shared libraries
>> from the glibc version used for linking
>> /usr/bin/ld: /trace-cmd/tracecmd/trace-record.o: in function
>> `record_trace.isra.0':
>> trace-record.c:(.text+0xe705): warning: Using 'initgroups' in statically
>> linked applications requires at runtime the shared libraries from the
>> glibc version used for linking
>> /usr/bin/ld: /trace-cmd/tracecmd/trace-record.o: in function
>> `do_getaddrinfo':
>> trace-record.c:(.text+0x865): warning: Using 'getaddrinfo' in statically
>> linked applications requires at runtime the shared libraries from the
>> glibc version used for linking
>> /usr/bin/ld: /trace-cmd/tracecmd/trace-record.o: in function
>> `record_trace.isra.0':
>> trace-record.c:(.text+0xe6ee): warning: Using 'getpwnam' in statically
>> linked applications requires at runtime the shared libraries from the
>> glibc version used for linking
> 
> Do you get the above warnings regardless?

Yes.

> 
> 
>> /usr/bin/ld: /trace-cmd/tracecmd/trace-record.o: in function
>> `tracecmd_stat_cpu_instance':
>> trace-record.c:(.text+0x12ec): undefined reference to `trace_seq_printf'
>> /usr/bin/ld: /trace-cmd/tracecmd/trace-record.o: in function `record_stats':
>> trace-record.c:(.text+0x1419): undefined reference to `trace_seq_init'
> 
> 
>> /usr/bin/ld: /trace-cmd/lib/trace-cmd/libtracecmd.a(trace-input.o): in
>> function `update_page_info':
>> trace-input.c:(.text+0x15d7): undefined reference to
>> `kbuffer_load_subbuffer'
>> /usr/bin/ld: trace-input.c:(.text+0x15df): undefined reference to
>> `kbuffer_subbuffer_size'
> 
> Oops, I forgot that trace_seq* and kbuffer_* are also supplied. I made
> everything that didn't start with 'tep_*' "static". I could add kbuffer_*
> and trace_seq_* to that list (the easy way out), or I can parse
> `nm libtraceevent.so` and convert everything that's static in it to static
> in the static library.
> 
> -- Steve


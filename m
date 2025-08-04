Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D9982C190
	for <linux-trace-devel@vger.kernel.org>; Mon,  4 Aug 2025 15:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754319674; cv=none; b=Ja/6y+Zu4quM1Z9FzYAC9sFsVv2LV9IHJFKqgPfVSpKugsSOeywAVHLtB4j9a9HoLEQ3nX5ZcjSW9TD09lE1/+iG7U+orqL67W+u2GWWV0rajT2YwxDTkOTnL/jQq7f8/k9xI9IwGHac/agvCF53pO/UT/p/xuJugRjCQG7Ine4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754319674; c=relaxed/simple;
	bh=RVRnoMvadhvWePaP2ESG3+RWRbjb09cLQg8Smtn5uHs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j2Srdkgi+SzuQVzvu8ntlEtkWagRtULFn4Q7aSo/aepp8NzCzV3IvBM9eBQua7NRlOwJ6ieQT8h1xCfxuUUB2OkwrSWL5Ch56YpU2ejXtFsMHwQ8F2a5KZA99kIIg6r7nWQPzCxIgMrghcj6Qj2pHKvlhMcFjZiO/Ls4BlC2Vgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 57C981E4D;
	Mon,  4 Aug 2025 08:01:04 -0700 (PDT)
Received: from [192.168.1.127] (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D20B43F673;
	Mon,  4 Aug 2025 08:01:10 -0700 (PDT)
Message-ID: <3a8b15b1-b3d7-456d-8ef0-b1dc2409b3d0@arm.com>
Date: Mon, 4 Aug 2025 16:01:15 +0100
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] libtraceevent: Add loading of BTF to the tep handle
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org, Masami Hiramatsu
 <mhiramat@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
 Takaya Saeki <takayas@google.com>, Ian Rogers <irogers@google.com>,
 aahringo@redhat.com
References: <20250731185559.1644753-1-rostedt@goodmis.org>
 <20250731185559.1644753-2-rostedt@goodmis.org>
 <e74be108-7ca5-466e-a89a-512a80a11beb@arm.com>
 <20250804084322.15b8c321@gandalf.local.home>
 <82376535-30a5-4602-aac7-1bd3abcd271a@arm.com>
 <20250804104104.001a9d65@gandalf.local.home>
Content-Language: en-US
From: Douglas Raillard <douglas.raillard@arm.com>
In-Reply-To: <20250804104104.001a9d65@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04-08-2025 15:41, Steven Rostedt wrote:
> On Mon, 4 Aug 2025 15:18:41 +0100
> Douglas Raillard <douglas.raillard@arm.com> wrote:
> 
>>>>> +		case BTF_KIND_INT:
>>>>> +			encode = *(int *)((void *)t + sizeof(*t));
>>>>> +			/* Print unsigned ints as hex */
>>>>> +			if (BTF_INT_ENCODING(encode) & BTF_INT_SIGNED)
>>>>
>>>> BTF_INT_OFFSET() and BTF_INT_VAL() values should also be used to shift and mask
>>>> appropriately.
>>>
>>> You meant to the "arg" passed in?
>>
>> Yes, something like that:
>>
>>     unsigned long long mask = (1 << BTF_INT_BITS(encode)) - 1;
>>     unsigned long long shift = BTF_INT_OFFSET(encode);
>>     arg = (arg >> shift) & mask;
>>
>> I suppose that how BTF_INT_OFFSET() is to be used depends on endianness, and I'm not
>> sure what is the endianness of the arg value. t->size would probably be involved as
>> well in the big endian case: https://docs.kernel.org/bpf/btf.html#btf-kind-int
> 
> Hmm, I guess I'll need to update that. The endianness is stored in the
> tep_handle descriptor and will need to be used. Note, this needs to handle
> big endian machine reading little endian machine data and vice versa. As
> well as little and big reading their own endianness.
> 
> Too bad my big endian machine died. I used that to test all the combinations.
> 
>>
>>>    
>>>>
>>>> I assume that regardless of BTF_INT_CHAR and BTF_INT_BOOL value, BTF_INT_SIGNED is
>>>> set appropriately.
>>>>   
>>>>> +				trace_seq_printf(s, "%lld", arg);
>>>>> +			else
>>>>> +				trace_seq_printf(s, "0x%llx", arg);
>>>>> +			break;
>>>>> +		case BTF_KIND_ENUM:
>>>>
>>>> Could add as well: case BTF_KIND_ENUM64:
>>>
>>> Of course then we would need to check if this is a 32 bit infrastructure.
>>> I'm assuming it would be treated differently. More like a struct?
>>
>> AFAIR the only point of BTF_KIND_ENUM64 is to represent enum with enumerator values that are
>> larger than 32 bits, since BTF_KIND_ENUM can only represent 32 bit values:
>>
>>     struct btf_enum {
>>         __u32   name_off;
>>         __s32   val;
>>     };
>>
>> In contrast, BTF_KIND_ENUM64 encodes the enumerators with this:
>>
>>     struct btf_enum64 {
>>         __u32   name_off;
>>         __u32   val_lo32;
>>         __u32   val_hi32;
>>     };
>>
>> So each value can have 64bits, split over 2 fields. I assume this quirk is
>> just to have alignof(struct btf_enum64) == 4 so that the BTF wire format
>> can be mapped on that C struct easily.
>>
>> AFAIR BTF_KIND_ENUM encoding was simply an oversight in the initial BTF spec, so they corrected it
>> by adding another BTF_KIND_*.
>>
>> Since you make no use of the enumerators array for now, I think the handling is identical.
>>
>>
>> Wrt to 32 vs 64 bits, in ISO C, the enum size does not depend on the ABI:
>> https://port70.net/~nsz/c/c11/n1570.html#6.7.2.2p4
> 
> When I brought up 64 bit, I meant with the parameters being passed in. As
> this is for parsing function parameters. On 32bit an enum64 would require
> two registers whereas on 64bit it would only require one.

Ah yes hadn't thought of that. From a godbolt experiment, both C and Rust seem
to just use 2 registers in the arm 32 bits case, like a struct.

> -- Steve


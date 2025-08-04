Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F674271441
	for <linux-trace-devel@vger.kernel.org>; Mon,  4 Aug 2025 14:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754317122; cv=none; b=HuiqWgp6j6iRu/0oV3hz7HVdTdwiTaqY6JfGMy7p8LdOnQgfiVaqwVm5WNmbmPROT/VEHOzPtbUoNCjHHUtNKAajeHAW/2w5hXHspsDLJ3KLr7v4hNVlZYs4htbJYLcf3AQQXsuCqddbiCx6q8MxYC252C/31OVsyv8icZCoC+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754317122; c=relaxed/simple;
	bh=mtRBXqD9Up6U0cfzu5V6Ss8rpgYBAt0GIr8dlxzRGdM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GPIv54gM//aHko04akF815ymYc5IFc6Lprv7YhjR5c06Jj6xDlLJ+BF4RrTEvsRtZol4+0Z4+bTqwWSDM23qzLON2+VHOlO8jkRKFBEVVz0DXArNc5kLzc1djGPM64MxNAQZ0RzDnEH3KSrKN6bQxo9C/Zv+KGFGErp48CUZbbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2CCE5150C;
	Mon,  4 Aug 2025 07:18:31 -0700 (PDT)
Received: from [192.168.1.127] (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8F1143F738;
	Mon,  4 Aug 2025 07:18:37 -0700 (PDT)
Message-ID: <82376535-30a5-4602-aac7-1bd3abcd271a@arm.com>
Date: Mon, 4 Aug 2025 15:18:41 +0100
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
Content-Language: en-US
From: Douglas Raillard <douglas.raillard@arm.com>
In-Reply-To: <20250804084322.15b8c321@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04-08-2025 13:43, Steven Rostedt wrote:
> On Mon, 4 Aug 2025 12:47:31 +0100
> Douglas Raillard <douglas.raillard@arm.com> wrote:
> 
>>> +int tep_btf_print_args(struct tep_handle *tep, struct trace_seq *s, void *args,
>>> +		       int nmem, int size, const char *func)
>>> +{
>>> +	struct tep_btf *btf = tep->btf;
>>> +	struct btf_type *type = tep_btf_find_func(btf, func);
>>> +	struct btf_param *param;
>>> +	unsigned long long arg;
>>> +	unsigned int encode;
>>> +	const char *param_name;
>>> +	int a, p, x, nr;
>>> +
>>> +	if (size != 4 && size != 8)
>>> +		return -1;
>>> +
>>> +	if (!type) {
>>> +		for (int i = 0; i < nmem; i++) {
>>> +			assign_arg(&arg, args, size, i);
>>> +			trace_seq_printf(s, "%llx", arg);
>>> +			if (i + 1 < nmem)
>>> +				trace_seq_puts(s, ", ");
>>> +		}
>>> +		return 0;
>>> +	}
>>> +
>>> +	if (BTF_INFO_KIND(type->info) != BTF_KIND_FUNC) {
>>> +		printf("Invalid func type %d %s\n", BTF_INFO_KIND(type->info),
>>> +		       btf_type_str(type));
>>> +		return -1;
>>> +	}
>>> +
>>> +	/* Get the function proto */
>>> +	type = btf_get_type(btf, type->type);
>>> +
>>> +	/* No proto means "()" ? */
>>> +	if (!type)
>>> +		return 0;
>>> +
>>> +	if (BTF_INFO_KIND(type->info) != BTF_KIND_FUNC_PROTO) {
>>> +		printf("Invalid func proto type %d %s\n", BTF_INFO_KIND(type->info),
>>> +		       btf_type_str(type));
>>> +		return -1;
>>> +	}
>>> +
>>> +	/* Get the number of parameters */
>>> +	nr = BTF_INFO_VLEN(type->info);
>>> +
>>> +	/* The parameters are right after the FUNC_PROTO type */
>>> +	param = ((void *)type) + sizeof(*type);
>>> +
>>> +	for (a = 0, p = 0; p < nr; a++, p++) {
>>> +		struct btf_type *t;
>>> +
>>> +		if (p)
>>> +			trace_seq_puts(s, ", ");
>>> +
>>> +		if (a == nmem) {
>>> +			trace_seq_puts(s, "...");
>>> +			break;
>>> +		}
>>> +
>>> +		assign_arg(&arg, args, size, a);
>>> +
>>> +		param_name = btf_name(btf, param[p].name_off);
>>> +		if (param_name)
>>> +			trace_seq_printf(s, "%s=", param_name);
>>> +
>>> +		t = btf_skip_modifiers(btf, param[p].type);
>>> +
>>> +		switch (t ? BTF_INFO_KIND(t->info) : BTF_KIND_UNKN) {
>>> +		case BTF_KIND_UNKN:
>>> +			trace_seq_putc(s, '?');
>>> +			/* Still print unknown type values */
>>> +			/* fallthough */
>>> +		case BTF_KIND_PTR:
>>> +			trace_seq_printf(s, "0x%llx", arg);
>>> +			break;
>>> +		case BTF_KIND_INT:
>>> +			encode = *(int *)((void *)t + sizeof(*t));
>>> +			/* Print unsigned ints as hex */
>>> +			if (BTF_INT_ENCODING(encode) & BTF_INT_SIGNED)
>>
>> BTF_INT_OFFSET() and BTF_INT_VAL() values should also be used to shift and mask
>> appropriately.
> 
> You meant to the "arg" passed in?

Yes, something like that:

   unsigned long long mask = (1 << BTF_INT_BITS(encode)) - 1;
   unsigned long long shift = BTF_INT_OFFSET(encode);
   arg = (arg >> shift) & mask;

I suppose that how BTF_INT_OFFSET() is to be used depends on endianness, and I'm not
sure what is the endianness of the arg value. t->size would probably be involved as
well in the big endian case: https://docs.kernel.org/bpf/btf.html#btf-kind-int

> 
>>
>> I assume that regardless of BTF_INT_CHAR and BTF_INT_BOOL value, BTF_INT_SIGNED is
>> set appropriately.
>>
>>> +				trace_seq_printf(s, "%lld", arg);
>>> +			else
>>> +				trace_seq_printf(s, "0x%llx", arg);
>>> +			break;
>>> +		case BTF_KIND_ENUM:
>>
>> Could add as well: case BTF_KIND_ENUM64:
> 
> Of course then we would need to check if this is a 32 bit infrastructure.
> I'm assuming it would be treated differently. More like a struct?

AFAIR the only point of BTF_KIND_ENUM64 is to represent enum with enumerator values that are
larger than 32 bits, since BTF_KIND_ENUM can only represent 32 bit values:

   struct btf_enum {
       __u32   name_off;
       __s32   val;
   };

In contrast, BTF_KIND_ENUM64 encodes the enumerators with this:

   struct btf_enum64 {
       __u32   name_off;
       __u32   val_lo32;
       __u32   val_hi32;
   };

So each value can have 64bits, split over 2 fields. I assume this quirk is
just to have alignof(struct btf_enum64) == 4 so that the BTF wire format
can be mapped on that C struct easily.

AFAIR BTF_KIND_ENUM encoding was simply an oversight in the initial BTF spec, so they corrected it
by adding another BTF_KIND_*.

Since you make no use of the enumerators array for now, I think the handling is identical.


Wrt to 32 vs 64 bits, in ISO C, the enum size does not depend on the ABI:
https://port70.net/~nsz/c/c11/n1570.html#6.7.2.2p4

In practice, GCC seems to pick "int" as the base type unless forced to use something else:
1. C23 feature that let us explicitly set the underlying type.
2. -fshort-enums that selects the smallest type possible (not used in the kernel)
3. An enumerator value that does not fit in an int. E.g. 4294967297

The last case happens in the kernel:

   enum kvm_pgtable_prot {
   	KVM_PGTABLE_PROT_X			= BIT(0),
   	KVM_PGTABLE_PROT_W			= BIT(1),
   	KVM_PGTABLE_PROT_R			= BIT(2),
   
   	KVM_PGTABLE_PROT_DEVICE			= BIT(3),
   	KVM_PGTABLE_PROT_NORMAL_NC		= BIT(4),
   
   	KVM_PGTABLE_PROT_SW0			= BIT(55),
   	KVM_PGTABLE_PROT_SW1			= BIT(56),
   	KVM_PGTABLE_PROT_SW2			= BIT(57),
   	KVM_PGTABLE_PROT_SW3			= BIT(58),
   };

https://elixir.bootlin.com/linux/v6.16/source/arch/arm64/include/asm/kvm_pgtable.h#L253

>>
>>> +			trace_seq_printf(s, "%lld", arg);
>>
>> This could probably be improved to display the enum variant name, with the caveats that:
> 
> If btf has it, sure! But that can come later.
> 
> Thanks,
> 
> -- Steve
> 
> 
>>
>> 1. C allows values that are not that of any enumerator AFAIR, so you'd need the
>>      raw int display fallback.
>> 2. GNU C allows enum forward declaration. This is not ISO C and BTF has no specific
>>      representation for that. As a result, last time I checked you end up with
>>      BTF_KIND_ENUM and info.vlen == 0. Another entry with info.vlen != 0 should
>>      also exist and give the actual enumerators list. Those forward decl provide an
>>      incomplete type though, so you should not encounter it directly in function
>>      parameters.
>>
>>> +			break;
>>
>>> +		default:
>>> +			/* This does not handle complex arguments */
>>> +			trace_seq_printf(s, "(%s)[0x%llx", btf_type_str(t), arg);
>>> +			for (x = sizeof(long); x < t->size; x += sizeof(long)) {
>>> +				trace_seq_putc(s, ':');
>>> +				if (++a == nmem) {
>>> +					trace_seq_puts(s, "...]");
>>> +					return 0;
>>> +				}
>>> +				assign_arg(&arg, args, size, a);
>>> +				trace_seq_printf(s, "0x%llx", arg);
>>> +			}
>>> +			trace_seq_putc(s, ']');
>>> +			break;
>>> +		}
>>> +	}
>>> +	return 0;
>>> +}
> 


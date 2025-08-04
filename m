Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE47125B2E1
	for <linux-trace-devel@vger.kernel.org>; Mon,  4 Aug 2025 12:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754311387; cv=none; b=kx5wRfP01S8Lj8oaQyZEN9YbbDmWp5vKX/S1DkhtB+2FpB2rPD9NXBdK+bZXyrVwFHQw/M1+yauBxZkayI3DM+o+9Zgrpd8nszXKT4YDzNO3CQDSff3rlZH6G+aprM2GTWfVgL7LI17MFA9zemgcjgtN0G2ur+vHqUigc9piKy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754311387; c=relaxed/simple;
	bh=e52ko/vmhSww0iPj315PEHWKxDe8pciOrK+W90VQfjg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O9d8JrAc+3fz8P6htWZj1x0ZNgeA4bGV+HE9RChOxGK9ykuw4AwFWdnRpG+Wkh6d5RbXOofhOwSVr5osoKN9gRPoWs6Zz9gcI4qgoLwlxvi+pRtDsUeF8QfSF58AJKhTBzUpqEHzJWbImiVk6Gmw1DkLD8vNMr0+AljIRekjUZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 81F271602B2;
	Mon,  4 Aug 2025 12:42:57 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf05.hostedemail.com (Postfix) with ESMTPA id 8DA0620018;
	Mon,  4 Aug 2025 12:42:55 +0000 (UTC)
Date: Mon, 4 Aug 2025 08:43:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Douglas Raillard <douglas.raillard@arm.com>
Cc: linux-trace-devel@vger.kernel.org, Masami Hiramatsu
 <mhiramat@kernel.org>, Namhyung Kim <namhyung@kernel.org>, Takaya Saeki
 <takayas@google.com>, Ian Rogers <irogers@google.com>, aahringo@redhat.com
Subject: Re: [PATCH 1/2] libtraceevent: Add loading of BTF to the tep handle
Message-ID: <20250804084322.15b8c321@gandalf.local.home>
In-Reply-To: <e74be108-7ca5-466e-a89a-512a80a11beb@arm.com>
References: <20250731185559.1644753-1-rostedt@goodmis.org>
	<20250731185559.1644753-2-rostedt@goodmis.org>
	<e74be108-7ca5-466e-a89a-512a80a11beb@arm.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8DA0620018
X-Stat-Signature: 8na7ywg1oiu78mkssppj7a4oo1dm7is5
X-Rspamd-Server: rspamout02
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/suz1uEiF+CZ2a2OahpkW+d9Vu3Nr+v7M=
X-HE-Tag: 1754311375-596234
X-HE-Meta: U2FsdGVkX19CyXORQHPkDO3ONAz30e9LNj0JG8Lq+AuBdSzsVXRtyhqSNUDupJQ4PSWwIYz+rsBfElSaEo04gr7nhYtwRjwMhABWi5s78rbYw6CElE4e9PXFfuoZfEbgE22eFjZKIDFb3KluT+EhguQAkkLTxejWM2AYVGekgA8/mvL2cy8HmZ4SI6w+EAIiUfPFuwm47zyG71ze6ob23SZVepjFpL481BUHuaTdyoREf/AiUmpG0IUm29xkGo2wwnmzSmqooilQNvv1BdTEATQHHZEpSaaYqOc+myfK/zB1PFOFLhp7OtzVkyfYApbypVKPkkp/kOoENDgg+W0yNVlSKaHpsD53dBb6kcanXvfoM3LQyGEz0+syM1zodqiV

On Mon, 4 Aug 2025 12:47:31 +0100
Douglas Raillard <douglas.raillard@arm.com> wrote:

> > +int tep_btf_print_args(struct tep_handle *tep, struct trace_seq *s, void *args,
> > +		       int nmem, int size, const char *func)
> > +{
> > +	struct tep_btf *btf = tep->btf;
> > +	struct btf_type *type = tep_btf_find_func(btf, func);
> > +	struct btf_param *param;
> > +	unsigned long long arg;
> > +	unsigned int encode;
> > +	const char *param_name;
> > +	int a, p, x, nr;
> > +
> > +	if (size != 4 && size != 8)
> > +		return -1;
> > +
> > +	if (!type) {
> > +		for (int i = 0; i < nmem; i++) {
> > +			assign_arg(&arg, args, size, i);
> > +			trace_seq_printf(s, "%llx", arg);
> > +			if (i + 1 < nmem)
> > +				trace_seq_puts(s, ", ");
> > +		}
> > +		return 0;
> > +	}
> > +
> > +	if (BTF_INFO_KIND(type->info) != BTF_KIND_FUNC) {
> > +		printf("Invalid func type %d %s\n", BTF_INFO_KIND(type->info),
> > +		       btf_type_str(type));
> > +		return -1;
> > +	}
> > +
> > +	/* Get the function proto */
> > +	type = btf_get_type(btf, type->type);
> > +
> > +	/* No proto means "()" ? */
> > +	if (!type)
> > +		return 0;
> > +
> > +	if (BTF_INFO_KIND(type->info) != BTF_KIND_FUNC_PROTO) {
> > +		printf("Invalid func proto type %d %s\n", BTF_INFO_KIND(type->info),
> > +		       btf_type_str(type));
> > +		return -1;
> > +	}
> > +
> > +	/* Get the number of parameters */
> > +	nr = BTF_INFO_VLEN(type->info);
> > +
> > +	/* The parameters are right after the FUNC_PROTO type */
> > +	param = ((void *)type) + sizeof(*type);
> > +
> > +	for (a = 0, p = 0; p < nr; a++, p++) {
> > +		struct btf_type *t;
> > +
> > +		if (p)
> > +			trace_seq_puts(s, ", ");
> > +
> > +		if (a == nmem) {
> > +			trace_seq_puts(s, "...");
> > +			break;
> > +		}
> > +
> > +		assign_arg(&arg, args, size, a);
> > +
> > +		param_name = btf_name(btf, param[p].name_off);
> > +		if (param_name)
> > +			trace_seq_printf(s, "%s=", param_name);
> > +
> > +		t = btf_skip_modifiers(btf, param[p].type);
> > +
> > +		switch (t ? BTF_INFO_KIND(t->info) : BTF_KIND_UNKN) {
> > +		case BTF_KIND_UNKN:
> > +			trace_seq_putc(s, '?');
> > +			/* Still print unknown type values */
> > +			/* fallthough */
> > +		case BTF_KIND_PTR:
> > +			trace_seq_printf(s, "0x%llx", arg);
> > +			break;
> > +		case BTF_KIND_INT:
> > +			encode = *(int *)((void *)t + sizeof(*t));
> > +			/* Print unsigned ints as hex */
> > +			if (BTF_INT_ENCODING(encode) & BTF_INT_SIGNED)  
> 
> BTF_INT_OFFSET() and BTF_INT_VAL() values should also be used to shift and mask
> appropriately.

You meant to the "arg" passed in?

> 
> I assume that regardless of BTF_INT_CHAR and BTF_INT_BOOL value, BTF_INT_SIGNED is
> set appropriately.
> 
> > +				trace_seq_printf(s, "%lld", arg);
> > +			else
> > +				trace_seq_printf(s, "0x%llx", arg);
> > +			break;
> > +		case BTF_KIND_ENUM:  
> 
> Could add as well: case BTF_KIND_ENUM64:

Of course then we would need to check if this is a 32 bit infrastructure.
I'm assuming it would be treated differently. More like a struct?

> 
> > +			trace_seq_printf(s, "%lld", arg);  
> 
> This could probably be improved to display the enum variant name, with the caveats that:

If btf has it, sure! But that can come later.

Thanks,

-- Steve


> 
> 1. C allows values that are not that of any enumerator AFAIR, so you'd need the
>     raw int display fallback.
> 2. GNU C allows enum forward declaration. This is not ISO C and BTF has no specific
>     representation for that. As a result, last time I checked you end up with
>     BTF_KIND_ENUM and info.vlen == 0. Another entry with info.vlen != 0 should
>     also exist and give the actual enumerators list. Those forward decl provide an
>     incomplete type though, so you should not encounter it directly in function
>     parameters.
> 
> > +			break;  
> 
> > +		default:
> > +			/* This does not handle complex arguments */
> > +			trace_seq_printf(s, "(%s)[0x%llx", btf_type_str(t), arg);
> > +			for (x = sizeof(long); x < t->size; x += sizeof(long)) {
> > +				trace_seq_putc(s, ':');
> > +				if (++a == nmem) {
> > +					trace_seq_puts(s, "...]");
> > +					return 0;
> > +				}
> > +				assign_arg(&arg, args, size, a);
> > +				trace_seq_printf(s, "0x%llx", arg);
> > +			}
> > +			trace_seq_putc(s, ']');
> > +			break;
> > +		}
> > +	}
> > +	return 0;
> > +}  


Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C1C86359
	for <linux-trace-devel@vger.kernel.org>; Mon,  4 Aug 2025 17:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754328862; cv=none; b=B2OuOEBt7S4K5O4CeOnmYz8ZoezPzGytrUvHMGn3zZgMxXZp810GLN9chpTfVLDbKhJs1rZcbp8YMaxAsDxeDvNQEYSJt1CxAa1OjjsgOxo2h72Et7ux4gndbou9CQn3eFFSAwmV353zFy4g+IbRyaNTXWUxj8lcwyOLKtZiK2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754328862; c=relaxed/simple;
	bh=riyiu7WQK0m3LKRa0YOBaMa7xJvlrK5gmAKKXFcoxIU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fJjauJtRdhEy5UmQuKQuXVOvR1SBQckaH0I3J9GkBpz+LwSvk2GJz9zjVR39G5fa8lGoBxLPAcogeZklD9qKbCc4zf3YYNg5eZdYlMfijpkTycRkf1ldJO7rbe6tHLmRRFkyA58Ll92t1UN++3ptxs06uhfBpBHfsv0qovc+VZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 66F20814DC;
	Mon,  4 Aug 2025 17:34:17 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf14.hostedemail.com (Postfix) with ESMTPA id 7FC652D;
	Mon,  4 Aug 2025 17:34:15 +0000 (UTC)
Date: Mon, 4 Aug 2025 13:34:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Douglas Raillard <douglas.raillard@arm.com>
Cc: linux-trace-devel@vger.kernel.org, Masami Hiramatsu
 <mhiramat@kernel.org>, Namhyung Kim <namhyung@kernel.org>, Takaya Saeki
 <takayas@google.com>, Ian Rogers <irogers@google.com>, aahringo@redhat.com
Subject: Re: [PATCH 1/2] libtraceevent: Add loading of BTF to the tep handle
Message-ID: <20250804133443.501b2187@gandalf.local.home>
In-Reply-To: <c5205c83-0d71-4b4b-a54e-ee9669a7b115@arm.com>
References: <20250731185559.1644753-1-rostedt@goodmis.org>
	<20250731185559.1644753-2-rostedt@goodmis.org>
	<c5205c83-0d71-4b4b-a54e-ee9669a7b115@arm.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hcd55d7rqmzdzgm38omegon5ypof7hxz
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: 7FC652D
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/LEYGYQMGNIUJEoAbn77hi/hcPWSwZQTY=
X-HE-Tag: 1754328855-504894
X-HE-Meta: U2FsdGVkX1+r7N8chHWdvOscchHDgbvC36pdXy5l4DLpDPTDeivfmZgFTqmMKZiKPc37CWLZfzWo4K93nG0HT0DnZNQm/1LHOMWQeI1sRz7/oQfjAfsc5XE3CrEX6KPBAesVKmRpEJU4g4F3RzpMejuNhJOt++FnWUqTC7swJfzvhYoEqc3VaPYLK/IW+31CbcrtC6M4WE60QL5tKJvdBq05bpMi8qKqpYOdqSYLKI9z9QSGG02+920hWUd9CtNFoDVVhrgHxiRlMUtkJIXOAJTYnC6UygM3bnou22nQahdLYt0LZz/tyiPtmfJyqBg4IKrf5Mos9rDvD5b93n6+UkEQYVCHejTsrMw/+pyxLxK5J3T6TPlc+k/v44ThHbGkiqexqepa3eBFDW6e/PlZUf9kmMEM2oEP5CLH3XPFNCDGLEWGIuAPLu90rZbMF3DgS7QcnLk8viUuuK78ZvIreJ6V+CgBDngB

On Mon, 4 Aug 2025 17:07:04 +0100
Douglas Raillard <douglas.raillard@arm.com> wrote:

> > +struct btf_header;
> > +struct btf_type;
> > +
> > +struct tep_btf {
> > +	struct btf_header	*hdr;
> > +	const char		*strings;
> > +	struct btf_type		**types;
> > +	unsigned long		nr_types;
> > +	struct btf_type		**funcs;
> > +	unsigned long		nr_funcs;
> > +	void			*data;
> > +	size_t			raw_size;
> > +	void			*raw_data;
> > +};
> > +
> > +#define REALLOC_SIZE (1 << 10)
> > +#define REALLOC_MASK (REALLOC_SIZE - 1)
> > +
> > +static const char *btf_name(struct tep_btf *btf, int off)
> > +{
> > +	if (off < btf->hdr->str_len)  
> 
> That assumes the input is well-behaved and str_len is set to the actual length of
> the strings data, but it could be anything. tep_btf_init() should check that
> btf->hdr->strings + btf->hdr->str_len point inside the provided data.

Heh! You know I thought about that and then said to myself "heck, it's user
space, we can let it crash!" ;-)

But yeah, it is a library an we should make it a bit more robust.

> 
> > +		return btf->strings + off;> +	return "";
> > +}
> > +
> > +/* List taken from the Linux kernel */
> > +static const char * const btf_kind_str[NR_BTF_KINDS] = {
> > +	[BTF_KIND_UNKN]		= "UNKNOWN",
> > +	[BTF_KIND_INT]		= "INT",
> > +	[BTF_KIND_PTR]		= "PTR",
> > +	[BTF_KIND_ARRAY]	= "ARRAY",
> > +	[BTF_KIND_STRUCT]	= "STRUCT",
> > +	[BTF_KIND_UNION]	= "UNION",
> > +	[BTF_KIND_ENUM]		= "ENUM",
> > +	[BTF_KIND_FWD]		= "FWD",
> > +	[BTF_KIND_TYPEDEF]	= "TYPEDEF",
> > +	[BTF_KIND_VOLATILE]	= "VOLATILE",
> > +	[BTF_KIND_CONST]	= "CONST",
> > +	[BTF_KIND_RESTRICT]	= "RESTRICT",
> > +	[BTF_KIND_FUNC]		= "FUNC",
> > +	[BTF_KIND_FUNC_PROTO]	= "FUNC_PROTO",
> > +	[BTF_KIND_VAR]		= "VAR",
> > +	[BTF_KIND_DATASEC]	= "DATASEC",
> > +	[BTF_KIND_FLOAT]	= "FLOAT",
> > +	[BTF_KIND_DECL_TAG]	= "DECL_TAG",
> > +	[BTF_KIND_TYPE_TAG]	= "TYPE_TAG",
> > +	[BTF_KIND_ENUM64]	= "ENUM64",
> > +};
> > +


> > +static int load_types(struct tep_btf *btf)
> > +{
> > +	struct btf_type *type;
> > +	void *start, *end;
> > +	int size;
> > +
> > +	start = btf->data + btf->hdr->type_off;
> > +	end = start + btf->hdr->type_len;  
> 
> Those should also be validated.

Yeah, probably.

> 
> > +
> > +	if (end > btf->raw_data + btf->raw_size)
> > +		return -1;
> > +
> > +	for (type = start; (void *)type < end;) {
> > +		if (add_type(btf, type))
> > +			return -1;
> > +		if (BTF_INFO_KIND(type->info) == BTF_KIND_FUNC) {
> > +			if (add_func(btf, type))
> > +				return -1;
> > +		}
> > +		size = btf_type_size(type);
> > +		if (size < 0) {
> > +			tep_warning("Invalid type %d\n", BTF_INFO_KIND(type->info));
> > +			return -1;
> > +		}
> > +		type = (void *)type + size;
> > +	}
> > +


> > +static struct tep_btf *tep_btf_init(void *raw_data, size_t data_size)
> > +{
> > +	struct tep_btf *btf;
> > +
> > +	btf = calloc(1, sizeof(*btf));
> > +	if (!btf)
> > +		return NULL;
> > +	
> > +	btf->raw_data = raw_data;
> > +	btf->raw_size = data_size;
> > +	btf->hdr = raw_data;
> > +	if (btf->hdr->hdr_len < sizeof(*btf->hdr)) {
> > +		tep_warning("Header (%d) smaller than expected header %zd",
> > +			    btf->hdr->hdr_len, sizeof(*btf->hdr));
> > +		goto fail;
> > +	}  
> 
> btf->hdr->magic and btf->hdr->version should be checked to catch any garbage input and
> breaking change to the format:
> 
>    The magic is 0xeB9F, which has different encoding for big and little endian systems,
>    and can be used to test whether BTF is generated for big- or little-endian target.
> 
>    https://docs.kernel.org/bpf/btf.html#btf-type-and-string-encoding
> 

Yep. As I stated above, the thought crossed my mind, and then my laziness
came across and said "nah".

I was more trying to get this code out to the public more than adding it.
But you are correct, it should have these validation checks.

-- Steve


> > +
> > +	btf->data = btf->raw_data + btf->hdr->hdr_len;
> > +
> > +	btf->strings = btf->data + btf->hdr->str_off;  
> 
> This pointer crafting without input validation looks like a CVE-in-waiting.
> Using libbpf would indeed add a dependency, but it seems those checks are taken care of:
> https://github.com/libbpf/libbpf/blob/58dd1f58b57294b2e59482245b29e46f1812b82d/src/btf.c#L258
> 
> This is not to say libbpf is perfect, but there also seem to be some people running fuzzers on it
> so issues of this kind have a higher chance of getting found, e.g.
> https://nvd.nist.gov/vuln/detail/CVE-2025-29481
> 
> I suppose there is no silver bullet here, as adding dependencies to a C program is a pain
> as it breaks downstream build recipes ...
> 
> Alternatively, the Rust parser has no BTF-related buffer issue, but that's because it does not
> implement anything BTF-related yet :)
> 
> > +	printf("str len = %d\n", btf->hdr->str_len);
> > +
> > +	if (load_types(btf) < 0)
> > +		goto fail;
> > +

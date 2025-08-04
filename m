Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840671F7586
	for <linux-trace-devel@vger.kernel.org>; Mon,  4 Aug 2025 14:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754318442; cv=none; b=W4DRS7BxTHeNuFqUwIgeiob+jUkXRZBWZH2ugsRKaMfHhTXB+4fqf+pud7YOVd4XfLJDotFWZku2wLiLE6ZqV0qPVn6YHStOqndcj73bW8M/ND6yJ/viaayQ/MSrimiR0OvyaPRCGK5s1N6D1dkxnBYxTNWzkcbs1hV7cFYdF7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754318442; c=relaxed/simple;
	bh=naIbXnzXijfkILbSBSW51c/pQFvN9MUC9kjTKMUUe04=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dZ+UqAo+RS6HKjD5ii30LVDiePx+gvsQRS8h39DHUOLDWMSH1HBga1h8YzOnvtce891DemlhKS7u4A4sRaUUwp2YpKHDRdubfWtjmaBsjM01oYjZcBM9TI9g15cMkVsd6Trnfy8wKIo+7K8g1R+BQMPiOl3cTw4yquBGI4/osCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 04FE2140644;
	Mon,  4 Aug 2025 14:40:38 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf06.hostedemail.com (Postfix) with ESMTPA id 114152000F;
	Mon,  4 Aug 2025 14:40:36 +0000 (UTC)
Date: Mon, 4 Aug 2025 10:41:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Douglas Raillard <douglas.raillard@arm.com>
Cc: linux-trace-devel@vger.kernel.org, Masami Hiramatsu
 <mhiramat@kernel.org>, Namhyung Kim <namhyung@kernel.org>, Takaya Saeki
 <takayas@google.com>, Ian Rogers <irogers@google.com>, aahringo@redhat.com
Subject: Re: [PATCH 1/2] libtraceevent: Add loading of BTF to the tep handle
Message-ID: <20250804104104.001a9d65@gandalf.local.home>
In-Reply-To: <82376535-30a5-4602-aac7-1bd3abcd271a@arm.com>
References: <20250731185559.1644753-1-rostedt@goodmis.org>
	<20250731185559.1644753-2-rostedt@goodmis.org>
	<e74be108-7ca5-466e-a89a-512a80a11beb@arm.com>
	<20250804084322.15b8c321@gandalf.local.home>
	<82376535-30a5-4602-aac7-1bd3abcd271a@arm.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: q8sepstrasur919mmdqj76dfbpgdz37q
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: 114152000F
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/D0m/w/OwGsy2Tx5rsmvG5CENEKZK+Khw=
X-HE-Tag: 1754318436-409820
X-HE-Meta: U2FsdGVkX1+HbAwngd+c11iQJfdlgLc85axNO+tf8ISH0ghZWgQ6Ukw3z6atuHTzX9fbiFzPoX8p4du4OH4aQ4vHXI51spOemeoSDhQVpR+zzWu9oBVLefHw5vanOBunKOPc6awHX1mYUsa3L6uuo60R5WbZrKIR1mjSJN45xHDqBsfSNKt4ofjaG8YnLl1GS+2lIlRvpnLG6PsV0Nk1WQDX0u7WGtdZYKHR4NQOF2GAPTqhf1lAhhvlaO0sCaCf5YXx2tR2PCLiBx34QT5O7FkzFuqHLadQ1PiiF7YBM9VAzWtBoov/RHtt5jWlIFgLh+vinP2J9aWQR7iUYvoMD0j++cxM5T6geElUZ6nXkfhtyPXi28qIKfaEgrWZ5XH5TX8Rizt6Zb3eafUtpbUEZFwt60OGeypgdrAHPPp7j1nNa9zQBqTM+jMH8EXmluUXKkZK4kdkdgvi3jz1s7kTipawyVJPWMY+1CmAGsp07anpU6WvgBLAz2+T00GuP46Y

On Mon, 4 Aug 2025 15:18:41 +0100
Douglas Raillard <douglas.raillard@arm.com> wrote:

> >>> +		case BTF_KIND_INT:
> >>> +			encode = *(int *)((void *)t + sizeof(*t));
> >>> +			/* Print unsigned ints as hex */
> >>> +			if (BTF_INT_ENCODING(encode) & BTF_INT_SIGNED)  
> >>
> >> BTF_INT_OFFSET() and BTF_INT_VAL() values should also be used to shift and mask
> >> appropriately.  
> > 
> > You meant to the "arg" passed in?  
> 
> Yes, something like that:
> 
>    unsigned long long mask = (1 << BTF_INT_BITS(encode)) - 1;
>    unsigned long long shift = BTF_INT_OFFSET(encode);
>    arg = (arg >> shift) & mask;
> 
> I suppose that how BTF_INT_OFFSET() is to be used depends on endianness, and I'm not
> sure what is the endianness of the arg value. t->size would probably be involved as
> well in the big endian case: https://docs.kernel.org/bpf/btf.html#btf-kind-int

Hmm, I guess I'll need to update that. The endianness is stored in the
tep_handle descriptor and will need to be used. Note, this needs to handle
big endian machine reading little endian machine data and vice versa. As
well as little and big reading their own endianness.

Too bad my big endian machine died. I used that to test all the combinations.

> 
> >   
> >>
> >> I assume that regardless of BTF_INT_CHAR and BTF_INT_BOOL value, BTF_INT_SIGNED is
> >> set appropriately.
> >>  
> >>> +				trace_seq_printf(s, "%lld", arg);
> >>> +			else
> >>> +				trace_seq_printf(s, "0x%llx", arg);
> >>> +			break;
> >>> +		case BTF_KIND_ENUM:  
> >>
> >> Could add as well: case BTF_KIND_ENUM64:  
> > 
> > Of course then we would need to check if this is a 32 bit infrastructure.
> > I'm assuming it would be treated differently. More like a struct?  
> 
> AFAIR the only point of BTF_KIND_ENUM64 is to represent enum with enumerator values that are
> larger than 32 bits, since BTF_KIND_ENUM can only represent 32 bit values:
> 
>    struct btf_enum {
>        __u32   name_off;
>        __s32   val;
>    };
> 
> In contrast, BTF_KIND_ENUM64 encodes the enumerators with this:
> 
>    struct btf_enum64 {
>        __u32   name_off;
>        __u32   val_lo32;
>        __u32   val_hi32;
>    };
> 
> So each value can have 64bits, split over 2 fields. I assume this quirk is
> just to have alignof(struct btf_enum64) == 4 so that the BTF wire format
> can be mapped on that C struct easily.
> 
> AFAIR BTF_KIND_ENUM encoding was simply an oversight in the initial BTF spec, so they corrected it
> by adding another BTF_KIND_*.
> 
> Since you make no use of the enumerators array for now, I think the handling is identical.
> 
> 
> Wrt to 32 vs 64 bits, in ISO C, the enum size does not depend on the ABI:
> https://port70.net/~nsz/c/c11/n1570.html#6.7.2.2p4

When I brought up 64 bit, I meant with the parameters being passed in. As
this is for parsing function parameters. On 32bit an enum64 would require
two registers whereas on 64bit it would only require one.

-- Steve

Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA72332ED8
	for <linux-trace-devel@vger.kernel.org>; Mon, 20 Oct 2025 17:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760981909; cv=none; b=L9ClJz5T97kfDU80dEzMQuM7j9lov5rqeGW8pCQNj5WnD68cKgJhwAkLdZ6+DFBc4vef2dtSRELgxQ8S0pStd4bKz9YObkeh2NF3AYGIcDztpouBNiRprpKzDdfgvxAm6JIuOL0HD2Nb5YMDXg10NDg05gUkWhjtX0Gcd4Us2p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760981909; c=relaxed/simple;
	bh=ixmysqdVmEbV5DBwnEKhGkjNKcW3rIP6F4uIZzKC9XE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cjqcdXjQkIWgaYBhNfcp/heWZrFkxV6fLJopnMQMVmSTCpoyDwECXek3NyMgRZFOgCMqW5JVpAwkb4PkOicSm+j/iXsEkofCQPDX2qIbUrwUTGp+SiWZ8whP3DXCvfryWQrBKyXZkcyd0q2yFgL7KduY0jJsdzqQeVtFO7eyRA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=w6Ba5gGr; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="w6Ba5gGr"
Message-ID: <5c01b127-686b-4890-aa79-810d159a6724@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760981903;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QEKOLLpoUGXUBoc/H6h7tVYc5qTfCkAVxmQneXu/4C4=;
	b=w6Ba5gGrgSPox5cSAcoFYe9NZRFk3QPTDskffz21UKzkjA+xrAChsI70k/RcLix+3f2Jnh
	7bdsk6D5+XGMz0hmGD3CJpKl85uWRjgcb4Vao0BMZSCtgv09XVCIbxaLCIbSiSYEtQRNqW
	g9FQifEiTf0osGczAvixM7Vzq7NosEk=
Date: Mon, 20 Oct 2025 13:38:18 -0400
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] Print arrays like Linux does
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
References: <20240826210022.2251838-1-sean.anderson@linux.dev>
 <b2c14f3a-b023-4688-9198-1f9b3e71320f@linux.dev>
 <20251020133505.48512dff@gandalf.local.home>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Sean Anderson <sean.anderson@linux.dev>
In-Reply-To: <20251020133505.48512dff@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 10/20/25 13:35, Steven Rostedt wrote:
> On Mon, 20 Oct 2025 12:17:05 -0400
> Sean Anderson <sean.anderson@linux.dev> wrote:
> 
>> On 8/26/24 17:00, Sean Anderson wrote:
>> > In Linux, trace_print_array_seq prints array elements as hexadecimal
>> > numbers, separates them with commas, and surrounds the whole thing with
>> > curly braces. Modify print_str_arg to use the same formatting.
>> > 
>> > Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
>> > ---
>> > 
>> >  src/event-parse.c | 12 +++++++-----
>> >  1 file changed, 7 insertions(+), 5 deletions(-)
>> > 
>> > diff --git a/src/event-parse.c b/src/event-parse.c
>> > index ba4a153..3c6f6f2 100644
>> > --- a/src/event-parse.c
>> > +++ b/src/event-parse.c
>> > @@ -4938,18 +4938,19 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
>> >  		len = eval_num_arg(data, size, event, arg->int_array.count);
>> >  		el_size = eval_num_arg(data, size, event,
>> >  				       arg->int_array.el_size);
>> > +		trace_seq_putc(s, '{');
>> >  		for (i = 0; i < len; i++) {
>> >  			if (i)
>> > -				trace_seq_putc(s, ' ');
>> > +				trace_seq_putc(s, ',');
>> >  
>> >  			if (el_size == 1) {
>> > -				trace_seq_printf(s, "%u", *(uint8_t *)num);
>> > +				trace_seq_printf(s, "0x%x", *(uint8_t *)num);
>> >  			} else if (el_size == 2) {
>> > -				trace_seq_printf(s, "%u", *(uint16_t *)num);
>> > +				trace_seq_printf(s, "0x%x", *(uint16_t *)num);
>> >  			} else if (el_size == 4) {
>> > -				trace_seq_printf(s, "%u", *(uint32_t *)num);
>> > +				trace_seq_printf(s, "0x%x", *(uint32_t *)num);
>> >  			} else if (el_size == 8) {
>> > -				trace_seq_printf(s, "%"PRIu64, *(uint64_t *)num);
>> > +				trace_seq_printf(s, "0x%"PRIx64, *(uint64_t *)num);
>> >  			} else {
>> >  				trace_seq_printf(s, "BAD SIZE:%d 0x%x",
>> >  						 el_size, *(uint8_t *)num);
>> > @@ -4958,6 +4959,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
>> >  
>> >  			num += el_size;
>> >  		}
>> > +		trace_seq_putc(s, '}');
>> >  		break;
>> >  	}
>> >  	case TEP_PRINT_TYPE:  
>> 
>> ping
> 
> It's been accepted:
> 
>   https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/commit/?id=5f570de85c6b6a391c5e7ffea0b9a54fd8c4b043
> 
> I just haven't had time to make a new official release.
> 
> -- Steve

Great thanks. Just wanted to make sure this didn't get lost.

--Sean

Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3437D1A76DE
	for <linux-trace-devel@vger.kernel.org>; Mon, 20 Oct 2025 17:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760981698; cv=none; b=FbaycBIuEHJTzme9UMw9nGVP6b4kROrAlik2Yxw+bMiW1fYxW5YTBW1IdphGtKPilD1WRRRcXOPf9mH9kv548m00oz5TUlbC4WW7H57Qid9nQ7TaD9cEob97ESw/SwOGFGauyMEem7str7q6OTf0p7w9llEBbJYvaUE5TksC7PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760981698; c=relaxed/simple;
	bh=Lbh+3eMwYFOl5bv8ImI86X6UZ/vIg3gBLw00weuK4nw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dH4AsZcA5MtZLke/JU5wq4VrkTMZjqpNu7uSV4wDZ4aqA1r1UBNlUWPvrA32K8+68g+jcdyYAKYKYfNhDn8cskFv78kBIQ9zlwQP2qqbEb9Mkz1flF70IzntuFX962xStZVNsYMDraCZnqpWrZrbpNpEqjjj2UX3XKluu5bS7kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F285557980;
	Mon, 20 Oct 2025 17:34:47 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf05.hostedemail.com (Postfix) with ESMTPA id 6CA882000D;
	Mon, 20 Oct 2025 17:34:46 +0000 (UTC)
Date: Mon, 20 Oct 2025 13:35:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Sean Anderson <sean.anderson@linux.dev>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] Print arrays like Linux does
Message-ID: <20251020133505.48512dff@gandalf.local.home>
In-Reply-To: <b2c14f3a-b023-4688-9198-1f9b3e71320f@linux.dev>
References: <20240826210022.2251838-1-sean.anderson@linux.dev>
	<b2c14f3a-b023-4688-9198-1f9b3e71320f@linux.dev>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: x5ii1yq94sq69yh5krw3sh5i8p9yd45f
X-Rspamd-Server: rspamout07
X-Rspamd-Queue-Id: 6CA882000D
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+S66BL+A40Tr7rr7uY0rfvv4Ri8sbuUx0=
X-HE-Tag: 1760981686-890715
X-HE-Meta: U2FsdGVkX1+yDft130l65GmuiZGh+XwqEuUu4D9Q7qmDDI1LJtWPEByk7L/DqtXfLqxPXS7xh2SawBQpBQ3kkO6S6+UlM+jK2VpZO9tRG3P6xjui2nY5JtYS3+bFc4lc6X3LbOCK7rVsBmTN8vNOQcZfca4ikxLi9PtrVe0B/7bU/62GW5iCx3Uhf+jKODXQGH90/yjDumGFVTXprZlFI5vLek5TcAYFD4u9imCUF/WZ862WqtiHWEPLJP65EbDcGESfK7/NvmqJql/XqMf+d4LF6GmS4f9AZ6CXGLRwzG0PFLpFn+BBSOUJexwKmVrR4ql9uD9Hb67yEobOTC+bTj6ZW4Vh5fMP

On Mon, 20 Oct 2025 12:17:05 -0400
Sean Anderson <sean.anderson@linux.dev> wrote:

> On 8/26/24 17:00, Sean Anderson wrote:
> > In Linux, trace_print_array_seq prints array elements as hexadecimal
> > numbers, separates them with commas, and surrounds the whole thing with
> > curly braces. Modify print_str_arg to use the same formatting.
> > 
> > Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
> > ---
> > 
> >  src/event-parse.c | 12 +++++++-----
> >  1 file changed, 7 insertions(+), 5 deletions(-)
> > 
> > diff --git a/src/event-parse.c b/src/event-parse.c
> > index ba4a153..3c6f6f2 100644
> > --- a/src/event-parse.c
> > +++ b/src/event-parse.c
> > @@ -4938,18 +4938,19 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
> >  		len = eval_num_arg(data, size, event, arg->int_array.count);
> >  		el_size = eval_num_arg(data, size, event,
> >  				       arg->int_array.el_size);
> > +		trace_seq_putc(s, '{');
> >  		for (i = 0; i < len; i++) {
> >  			if (i)
> > -				trace_seq_putc(s, ' ');
> > +				trace_seq_putc(s, ',');
> >  
> >  			if (el_size == 1) {
> > -				trace_seq_printf(s, "%u", *(uint8_t *)num);
> > +				trace_seq_printf(s, "0x%x", *(uint8_t *)num);
> >  			} else if (el_size == 2) {
> > -				trace_seq_printf(s, "%u", *(uint16_t *)num);
> > +				trace_seq_printf(s, "0x%x", *(uint16_t *)num);
> >  			} else if (el_size == 4) {
> > -				trace_seq_printf(s, "%u", *(uint32_t *)num);
> > +				trace_seq_printf(s, "0x%x", *(uint32_t *)num);
> >  			} else if (el_size == 8) {
> > -				trace_seq_printf(s, "%"PRIu64, *(uint64_t *)num);
> > +				trace_seq_printf(s, "0x%"PRIx64, *(uint64_t *)num);
> >  			} else {
> >  				trace_seq_printf(s, "BAD SIZE:%d 0x%x",
> >  						 el_size, *(uint8_t *)num);
> > @@ -4958,6 +4959,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
> >  
> >  			num += el_size;
> >  		}
> > +		trace_seq_putc(s, '}');
> >  		break;
> >  	}
> >  	case TEP_PRINT_TYPE:  
> 
> ping

It's been accepted:

  https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/commit/?id=5f570de85c6b6a391c5e7ffea0b9a54fd8c4b043

I just haven't had time to make a new official release.

-- Steve

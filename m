Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0FB19644B
	for <linux-trace-devel@vger.kernel.org>; Mon, 24 Nov 2025 16:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764002932; cv=none; b=mEL3+cDQiN5aPBm7clEfK4/pMjv2q8zkrj4d/Utpud8IYniNklyv/pvuU4zr9QNxihIKiat7h62rHAxGl7yBpFmcaK/7JMcLs5LKUQNAK8Gmx0X+zxJlgplgaxuoOt1RIxUqC44V9SBUl7Y/n2oe6rKkYSmtdBVAYTgoRI/LRdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764002932; c=relaxed/simple;
	bh=BaHsiZtUNF5tCB+1Oss6dqWxxPrtxjp3cf+3SNt+gdc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AeQa0yv4BQE3HAUfzRwLrtn1FqmVuutbEF7kTulc0diIja/YB0udqJjxSlUw/wgFZnL7N2TLEEOULTXHXOmWe33QNkN/oej3Zw1KRVrQxlCHqSZD+BrgjpuKijsOf5oEFGixMaFHZI+oTLExTmGBA/J6l98hI2htuuCQ47MpASM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1D300898FC;
	Mon, 24 Nov 2025 16:48:46 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf10.hostedemail.com (Postfix) with ESMTPA id 8DE7E35;
	Mon, 24 Nov 2025 16:48:44 +0000 (UTC)
Date: Mon, 24 Nov 2025 11:49:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "MOESSBAUER, Felix" <felix.moessbauer@siemens.com>
Cc: "linux-trace-devel@vger.kernel.org" <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtracecmd: Fix continuing in
 tracecmd_iterate_events_reverse()
Message-ID: <20251124114925.140f62b8@gandalf.local.home>
In-Reply-To: <6418211fd4d5673020b94a75b1ce8e7781b80d9d.camel@siemens.com>
References: <20251121120947.368ad1bd@gandalf.local.home>
	<6418211fd4d5673020b94a75b1ce8e7781b80d9d.camel@siemens.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qzt8cdpz757taiosgmbfzz79qxq8bttk
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: 8DE7E35
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18h34x7LH9zMdFxDquSug4RHaGSli8Sn4g=
X-HE-Tag: 1764002924-337962
X-HE-Meta: U2FsdGVkX1+snKjP2NAX3cQf4pxXvrLvKLL2GX3RiMaoSFEG0kQ22zPUFiTh0KS7WK8XfBxWITC/3FNitOgf0naquiV/hD6YXwEyKotylaW4IaXDKU6ObR1k+4xrYzq0GsreDHbUpzjQb4cY0t+HO1vhucalSSi5By4qJw27CV4x56jIHQybI2JOdzVvqdkSxeV5r4YBxg4ET5KCs0cTPaYw0StogIT/UIF4Ezjsu1WSRIXjAsIKx4lldsnYoCdfrDYOZtorR9ELtnDQGOR13Yp/ffPBhgdMUuqf4Xi7os5wenQ6kLyzIsfMx+vsg4I/8wR7f66VhVA5j1UDcEjAnNUAfEwYbtKr

On Mon, 24 Nov 2025 09:10:06 +0000
"MOESSBAUER, Felix" <felix.moessbauer@siemens.com> wrote:

> > +	/*
> > +	 * If the callback exited out early, then set the cursor back
> > +	 * to the location of that record so that if this gets called
> > +	 * again with cont = true, it will continue where it left off.
> > +	 */
> > +	if (page_offset) {
> > +		/* Set the record to the previous record that was read */
> > +		record = tracecmd_read_at(handle, page_offset - 4, NULL);  
> 
> Hi,
> 
> where does the magic "- 4" come from?

It's just to get to the previous record. - 1 would likely work, but as I
know all events are aligned by a minimum of 4 bytes I used that. I probably
should add a comment about that.

> 
> > +		tracecmd_free_record(record);  
> 
> I still don't get why this fixes the issue. Does tracecmd_read_at has a
> side-effect to set the the internal cursor? If so, it IMHO would help
> to document this side effect in tracecmd_read_at().

Hmm, I guess I should. Yes, that's one of the things I consider "obvious",
but "obvious" is seldom obvious ;-)

Pretty much all tracecmd_read*  functions set the internal cursor unless
stated otherwise.

-- Steve

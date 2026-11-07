Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=216.40.44.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794086445;
	b=h6eFYF8/bshcErK7Ai4IKRZx1c5uuwZR5qp3KcW90LxzdeWC/cIj1G0KxkbHnwoOnCEu
	 VgIkC4TR2NgrzZ3cbHPUwKfVWesNqb+BV973JJg3KyinHP6Zo0NVAgRUIlyyOWY6jZGbw
	 DsnCLBkfQtM2SUMDb0kWNUgiRAM2SKnwK5IIri+H0kPGgUVDcDZhgORbrpz7/KA/sOpzL
	 vJQYT0IBCnI4ILRHiwGnLKN2oj/SCtLCZs5hTMUNcwLtSVuESUT9b/XhxMNXUTondZYoj
	 JmqSv2t7myfadGSi9UZ3Ff+Kd8oxTSqPTueZpgF5HnESsxw7ZC6keiX5Av1hU9ak/jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794086445;
	h=DMARC-Filter:Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Rspamd-Server:X-Rspamd-Queue-Id:
	 X-Stat-Signature:X-Spam-Status:X-Session-Marker:X-Session-ID:
	 DKIM-Signature:X-HE-Tag:X-HE-Meta;
	bh=ceiIsG5iyS6gI40nVB8jTbDrcWZnF3MSRt8y4/R0OgU=;
	b=jNPSVmGXBvDEnHYUDD9rReRQZCB4XjmvfKkKkdJoIvOoI/OSxyUXc6j4EJ953Roz867e
	 w80G7/Ke/P8I1Plb6BcXg1RTwbmlM6NKCf15u1zEUbjs3YfsOoLYOBpXffHo3b8TKiAlT
	 arqqCmZ+5/uY0kct/CSuyLQ4+7CHYfGUnkxkyePSYlUztov/GhvpBlDQjS2hIJb5Y7n9x
	 xDwXOVvcnzOJR4ky5JMMhWjRf9Q9cOHaoEAHOke1gBqYHWnw1/0H8/x/MXFz6w8BBx/61
	 Xo0i4isFBalp1HjNK1mdSc6Sm9TIya4LxO4y9XwDqOs+dFxkadPEjNbNfRMBieG+V/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=goodmis.org;
	spf=pass smtp.mailfrom=goodmis.org;
	dkim=pass header.d=goodmis.org header.i=@goodmis.org header.a=rsa-sha256 header.s=dkim1 header.b=zq03zXOe;
	arc=none smtp.remote-ip=216.40.44.15
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6AB606A326
	for <linux-trace-devel@vger.kernel.org>; Sat,  7 Nov 2026 21:20:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AE6AB606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=goodmis.org header.i=@goodmis.org header.a=rsa-sha256 header.s=dkim1 header.b=zq03zXOe
Received: from omf01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2EBC980280;
	Sat,  7 Nov 2026 21:20:43 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf01.hostedemail.com (Postfix) with ESMTPA id 414D46000F;
	Sat,  7 Nov 2026 21:20:37 +0000 (UTC)
Date: Sat, 7 Nov 2026 16:20:22 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: linux-trace-devel@vger.kernel.org, Emil Thorsoe <ethorsoe@tuxera.com>
Subject: Re: [PATCH] libtraceevent utest: exit test if mmap fails
Message-ID: <20261107162022.65256a9d@fedora>
In-Reply-To: <au9QwCTKOwBCZ7f-@debian>
References: <20260526184219.408223-1-sudipm.mukherjee@gmail.com>
	<20260529144124.14954a5f@fedora>
	<CADVatmMUERxEkbURZuZfTw+UYB2YCMVxK9nvc-z-u5kKNHxM=g@mail.gmail.com>
	<20260616164812.5ecda840@fedora>
	<au9QwCTKOwBCZ7f-@debian>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Post: <mailto:linux-trace-devel@vger.kernel.org>
List-Help: <mailto:linux-trace-devel+help@vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-trace-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: 414D46000F
X-Stat-Signature: ukghteeedqk4yupb18se1wozcuckn7ho
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+fAkiOzNBBoVtKya9i6JsU0jEhX0y9mMk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=ceiIsG5iyS6gI40nVB8jTbDrcWZnF3MSRt8y4/R0OgU=; b=zq03zXOeEnJVIL4yRQXYeERcsWJyCRspqrfTx3hKP4czT9NvkNZxpqv6UzmC4mea0mH7gVDmnU64+ksiNJQZugCe3Z27+1Rr2k0ffZUpArNaYGbYGIJqMwWBAe1war4rXt0FiAYAywQJw5xLDpj+hqEQASAdKJmKksYiPezL5hs=
X-HE-Tag: 1794086437-356524
X-HE-Meta: U2FsdGVkX18gKZdj02tmflM655mHFwcR9cru0+L2/1Q0k5K6EmUWcwGUEvS9kO1Tib+62M2KPpvHtaxp/jPq1Rd3nY6xiugxtFceX37ON33TJJiIktEaZCK659BwvnaWuJZpOcv7NtNhZSEbsx0tNB9gyojfUNdyn0C37CS/5gud2BGE849oToz/e/aQQD/eBuTVe8UgQTP4rOsR7vAq2gTPVXaYvDNDy8OUHxlRoY1r3WLZ6A6QRVHPiVTCC1onBX5uBqmS9DyNZTRmp+soch5Cev4133mnggPCw1mPz2cCdqkTTf7TMKNU1N0btFEHLtfVX5MtHJRuFZXewK08DK2Q3+aWc1EIOo9xFJEWYHhUr6b/olwCfv7HmDqW54ZsZoSPDlNDnV6QMyQq9Qq8PHudSYdrY2Be29oQWSM+lzTA1p2CQEGcP+EdjxzPL5Y8+7arinw7/BSGHD7fawTZr5h3n2iuJZUD8mc5ERxseyU=

On Sat, 7 Nov 2026 16:24:32 +0000
Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:

> Hi Steve,
> 
> On Tue, Jun 16, 2026 at 04:48:12PM -0400, Steven Rostedt wrote:
> > On Mon, 15 Jun 2026 20:25:08 +0100
> > Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:
> >   
> > > Hi Steve,
> > > 
> > > On Fri, 29 May 2026 at 19:41, Steven Rostedt <rostedt@goodmis.org> wrote:  
> > > >
> > > > On Tue, 26 May 2026 19:42:19 +0100
> > > > Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:
> > > >    
> > > > > CU_TEST() continues execution even if the test fails. It just records
> > > > > that the test has failed and moves on.
> > > > > So, when libtraceevent is built in a chroot, it can open
> > > > > /sys/kernel/btf/vmlinux but fails in mmap stage and since CU_TEST()
> > > > > does not stop so we get a segfault when tep_load_btf() tries to use
> > > > > the mapped buffer.
> > > > >
> > > > > Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>    
> > > >
> > > > Thanks, but the real fix is here and I'm applying that one:
> > > >
> > > >   https://lore.kernel.org/all/d6e07cd6-cb78-4119-a048-920ca58b4830@tuxera.com/    
> > > 
> > > Tried it today, and the test still fails for me.  
> > 
> > Thanks for letting me know. I currently just started a new job and I'm
> > a bit overwhelmed. It may be a couple more weeks before I get to this.  
> 
> Not sure if you had a chance to look at it. I was looking at it now while
> updating the Debian package. It seems like btf_init() is failing when its
> doing if (btf->hdr->hdr_len < sizeof(*btf->hdr)). Adding a debug there shows,
> btf->hdr->hdr_len is 24 whereas sizeof(*btf->hdr) is 32.
> 
> Tried on a chroot and also on a VM, both shows the same problem in Debian.
> 

Bah, because I thought the fix was elsewhere I marked it as
"superseded" and forgot I did that. When you said it was different, I
was traveling and didn't bother to check patchwork to reset it back to
New.

   https://patchwork.kernel.org/project/linux-trace-devel/patch/20260526184219.408223-1-sudipm.mukherjee@gmail.com/

If it's not visible in patchwork, it's not visible to me :-/

I'll go and set it now to New. Thanks for keeping up on it.

-- Steve



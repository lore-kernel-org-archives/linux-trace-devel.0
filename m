Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=216.40.44.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795012817;
	b=NMvjK3rxFWsMQfSHJ4YgvFC8U1m/mSXACKGcApux3o1UHi2KwS9iPQ2moT64m2OJxFMS
	 3I5hvkdbtH/ODeB/fUHdNupipfbugWYIOIfJAW/W65Pag5+YZ3HjqMv1npTBaxvP/u717
	 +1scEAD5t7hIAKhonCnm5dVkU5IzKOKmVZfKAriNuPCXcUPhEsN99/C7pxBj5PT1Se7+/
	 AmnVnPWOxDu32reLVJvTRuqiv9kGa5Z8FfIaICL+oCKMi1T1UdVGVJNQB9xhGW3wqSHaI
	 6U9Jhrdl12qtY5tZ+jSpZc5kFoZpcp8wf8Ieunh6LBaJmWUeNWFPbCKWBkPApXlEQzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795012817;
	h=DMARC-Filter:Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Spam-Status:X-Rspamd-Server:
	 X-Stat-Signature:X-Rspamd-Queue-Id:X-Session-Marker:X-Session-ID:
	 DKIM-Signature:X-HE-Tag:X-HE-Meta;
	bh=T09EioJrFd2NRK2To4k5IhA1EKLAaEoxhAa0U/ywULM=;
	b=2c/OEHPiwlOWeJ72BdBL/wJ+SqYMOxrE4IgicD0XcExmSRxApRivvIBPSdJdLgci9+UA
	 AqRgGjZygFT3w8w/VcZmxOKgtn9bGI3Kan54FS5OK7WFeh8uCqmcbO8L/9YZMYXvGRYhi
	 FUulByKODvVneb+Mq/ff8INUKPc5LlrR2NcRkUdeG0DKutxp/hoET2rA/X9O7zNdZ8wWt
	 0FowcC3xraRRh8QD753bQvltxZuBvCjC+waJqY0SSUwYnVcqiThEFXKI0j+1wdTlHANF3
	 uXgrstHD1/aR9IzCwyVDLCP6L3QLearU7DyoNhff6tELzdU4L3ghqpbK1Vletq+LA3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=goodmis.org;
	spf=pass smtp.mailfrom=goodmis.org;
	dkim=pass header.d=goodmis.org header.i=@goodmis.org header.a=rsa-sha256 header.s=dkim1 header.b=BUEUpiR4;
	arc=none smtp.remote-ip=216.40.44.12
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B425606A31C
	for <linux-trace-devel@vger.kernel.org>; Wed, 18 Nov 2026 14:40:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3B425606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=goodmis.org header.i=@goodmis.org header.a=rsa-sha256 header.s=dkim1 header.b=BUEUpiR4
Received: from omf15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C0C6DA07AB;
	Wed, 18 Nov 2026 14:40:13 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf15.hostedemail.com (Postfix) with ESMTPA id 23AAC18;
	Wed, 18 Nov 2026 14:40:12 +0000 (UTC)
Date: Wed, 18 Nov 2026 09:40:10 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Frank Heimes <frank.heimes@canonical.com>
Cc: linux-trace-devel@vger.kernel.org, Benjamin Drung
 <benjamin.drung@canonical.com>, Jamie Dolan <jldolan@us.ibm.com>
Subject: Re: [PATCH 0/2] kbuffer: Fix out-of-bounds write in
 kbuffer_read_buffer()
Message-ID: <20261118094010.545fdb4b@gandalf.local.home>
In-Reply-To: <cover.1794988946.git.frank.heimes@canonical.com>
References: <cover.1794988946.git.frank.heimes@canonical.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
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
X-Rspamd-Server: rspamout06
X-Stat-Signature: y8gy13sieg3i1mnt8htdy3pb1gppndzx
X-Rspamd-Queue-Id: 23AAC18
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19J5h6xmJuiOKXtizJ1vmv9IRAsLeOWgcI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=T09EioJrFd2NRK2To4k5IhA1EKLAaEoxhAa0U/ywULM=; b=BUEUpiR4ES3cnWJxz7Gqf/ZEYaDLqcslBY94D2jGXrB6J+RbAaCfAr8Wxyblc64e64tIecnSRjRHoWOD/KWA3NRjXE3DZik4d3mSPX9WE6yzQ+abRHsTCOg2TPCAFRSkVil+PNaXH/lgsqM0XM8fZ5lPEg4Ci+kfa56jifsfhlk=
X-HE-Tag: 1795012812-309703
X-HE-Meta: U2FsdGVkX1+SnF/SOFOaxvwuZaPdmHrfkVWdhRnjeiXDMOKs5EioGeaKBOtfjRkyUiVMzZJLsulGtp8pvAKzGUwrFVrJ8cpBxFL/JErbFLlTGSexBiohA2eSFDPOdgZY45rHZUjWxYi/XyyEKXU2GwKg55NaxWnz3s8eAFk+WEhVloEKlgRCV06NLIkt+P4+hKNJWa7yxlXoBxaS0Td8CEu/tyarmMTg5Eytq8/m0S+BKQYzg3Tb/0xvddUMZZ4VD2pTcjNGDgeSC0d/mvtJhnVPsg/SkKmq2UAj3ST9atxojGqHkq0BZLLOgW9gFvpiwUjMmKvwvJ2cM5PxZ1AHXwCr4DMKnATeH3Y5Wtot16C32+aYS0KJXV5jn6gP5ErF9i/4uMLfEOCQu8niX9Nc5A==

On Wed, 18 Nov 2026 08:40:22 +0000
Frank Heimes <frank.heimes@canonical.com> wrote:

Hi Frank,

> kbuffer_read_buffer() stores the missed events count after the copied
> events, but the check whether there is room for it is wrong. If the
> events fill up the destination buffer (which is the normal case, as
> callers pass a buffer of the sub-buffer size), the count is written up
> to 8 bytes beyond the end of the buffer, and MISSING_STORED is set
> although there is no room for the count.
> 
> This was found while looking into the libtracefs unit test failures
> reported here:
> 
>   https://lore.kernel.org/linux-trace-devel/39efe87bec205b7f809b8aa49db635b6465ee530.camel@canonical.com/
> 
> libtracefs uses kbuffer_read_buffer() for memory mapped ring buffers
> (tracefs_cpu_read()/tracefs_cpu_write(), the latter with a buffer on
> the stack). That's what makes the "trace cpu pipe" test show an
> "Invalid read of size 8" in kbuffer_load_subbuffer() and random
> "missed events" values under valgrind ("make test_mem").
> 
> It can be reproduced without tracing by copying a full sub-buffer with
> missed events with kbuffer_read_buffer() into a malloc()ed buffer of
> the sub-buffer size. Under valgrind (amd64, libtraceevent 1.9.0):
> 
>   ==2504915== Invalid write of size 8
>   ==2504915==    at 0x48820FA: write_8 (kbuffer-parse.c:114)
>   ==2504915==    by 0x48834A0: kbuffer_read_buffer (kbuffer-parse.c:1030)
>   ==2504915==    by 0x40013F7: main (kbuf-repro.c:61)
>   ==2504915==  Address 0x4ac3120 is 0 bytes after a block of size 4,096 alloc'd
> 
> and the commit field of the copy is 0xffffffffc0000ff0. With the fix
> it is 0x80000ff0 and valgrind reports no errors.
> 
> Patch 1 fixes the check (and the sign extension of the flags into the
> upper 32 bits of the 8 byte commit field), patch 2 adds unit tests,
> which fail without patch 1:
> 
>   Test: kbuffer read buffer with missed events, full ...FAILED
>     1. traceevent-utest.c:786  - *(uint64_t *)(dst + KBUF_SUBBUF_SIZE) == KBUF_GUARD
>     2. traceevent-utest.c:791  - !!(commit & KBUF_MISSING_STORED) == expect_stored
>     3. traceevent-utest.c:793  - (commit & ~(KBUF_COMMIT_MASK | KBUF_MISSING_EVENTS | KBUF_MISSING_STORED)) == 0
>   Test: kbuffer read buffer with missed events, stored ...FAILED
>     1. traceevent-utest.c:793  - (commit & ~(KBUF_COMMIT_MASK | KBUF_MISSING_EVENTS | KBUF_MISSING_STORED)) == 0
> 
> Tested on amd64 and ppc64el with the reproducer and the unit tests, and
> on ppc64el with the libtracefs unit tests ("make test_mem" no longer
> shows the invalid read).
> 
> Frank Heimes (2):
>   kbuffer: Fix out-of-bounds write of missed events in
>     kbuffer_read_buffer()
>   libtraceevent utest: Add tests for kbuffer_read_buffer() with missed
>     events
> 
>  src/kbuffer-parse.c      |  14 ++++--
>  utest/traceevent-utest.c | 104 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 113 insertions(+), 5 deletions(-)

Thanks for doing all this. I'm currently way behind in my patch queue on
the kernel side so it may be a while before I get to the trace-cmd tooling.
I'm just letting you know so you do not think I'm ignoring your patches.

-- Steve

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.120
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794991230;
	b=roFJUWEfruo1q7vHypNOMZu+zDYNj59gHv6TlZrCyUKt8COeUGiiZnvvwqcFJx4yL5LV
	 BneWtlNL0p4RQcka/3tdU3LnuunGAqItn0J53hcYePgUdCV+qQHDviMnBzn/8Em20F981
	 Gle73s3f5fAAX6h6dSnxhgcinhZdR/Y6crBw/VITcrc1fRZS44k13pY+NWjvaCVuWkWmJ
	 sk6Bm6BTk9p/o3vpnXlIIMHccCWTVQPtSKYTWp+5Cj+lA28+AI6oMEh1AWeTzerCVRPbq
	 pApWXWKkZgD3LAja0VbcrVebCSOcuERv7fiNeiLOgdQm8aeZAWSGPE/ET2bbpmFQ4xQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794991230;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=waxPwfcRiJ6HHDrLqrLOycq45Qv8UB/2XJ6vzawZvD4=;
	b=F3dm3+0HIUw/MUnRctNwrow8rtN0zXs98yHk6NG2xZO0VdE+1ek79cwdpcIL2liP0wHd
	 MTvPwBU9I3NbQf54JkM29OzMLqpNbMwDwRWBFx71PEMMd7MUhIcyaZAMydCBJEP4yT6ur
	 snWO5HLxjcyKJQOgIKFF+bwAAyWd6z/k474llE1gZzIn4wqjJQWVcli6Kv1MYiFaMpYzU
	 6JYP5B0hfLi4MjL1yTRntVL3x5VzGemqeGa5QTWOygvkUSPaNku/RJpBmOtvdVNPT7y9c
	 9M20G9/sgH6Gncp9bAo7PY0LTrxrWZ4DIoijNGh1eQS5uxC8KKkdkx2VjRh7wxDogmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=canonical.com;
	spf=pass smtp.mailfrom=canonical.com;
	dkim=pass header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=bGI1C9JQ;
	arc=none smtp.remote-ip=185.125.188.120
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32555606A31C
	for <linux-trace-devel@vger.kernel.org>; Wed, 18 Nov 2026 08:40:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32555606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=bGI1C9JQ
Received: from openrouter-r.lxd (2.general.fheimes.us.vpn [10.172.66.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 4A2CC3F9E2;
	Wed, 18 Nov 2026 08:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1794991227;
	bh=waxPwfcRiJ6HHDrLqrLOycq45Qv8UB/2XJ6vzawZvD4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version;
	b=bGI1C9JQkMIgmXoR0nPwYK1MqDkwF3bKIhkos/t21nkJLhI8pwfg6HHipXvkvjI4y
	 s9R4X9qIFMxUtsOyE1bpEiI14wn99auKSKGHfb7lNSO70DObeijRQb0MG25n0rrsIw
	 tVWKXOqc+6K+ukFxpjkvOiRGaCW0IR+IsHTMM/JlO+o01u1xfsaDr07Ly2P5gtsRlq
	 X2fqmVMbeL1Q0ZiibM5bvpidOH89+GozQm7VDCZb3D1Q/BynF4rmLoJ08o58JQcvBr
	 K0hRmr9sZuC9uXtrvzEqMFU64Xq15SVb3CenxXTG7yFhqUftbaHm28PtZV2YLEgTIq
	 SaTWNbV7oYWIdlKHmSgJ6MZdd942tmM1Y/ScUHoL1Q/Al8czPMwJuxOhRvMbObezXN
	 l0n1K4zvIY8XFVL6D4S9XMpTU3H9H8FicxzZVQ2+UcrfuLR60RW256olaL2TYN6LKm
	 pePnZD3rt2J95Fj27wEPSVlgiLw8sLr1SPxx0fQt5uNcvxaCVkWBlbBvLbb4neof0V
	 56afKadEb+IewYEvn9m7snhVxJeEUf3shYyXje3SJ99l3WvRq4mJIhnd+/TnwxeVED
	 thdWYfkcuXxBgNua4CwxTycopF4dnXUYzhuUdakpbtw54sl34tnwB3J82kBiHAaB4q
	 Z+VRIDUiRnf21NQk9XUzJas4=
From: Frank Heimes <frank.heimes@canonical.com>
To: linux-trace-devel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Benjamin Drung <benjamin.drung@canonical.com>,
	Jamie Dolan <jldolan@us.ibm.com>
Subject: [PATCH 0/2] kbuffer: Fix out-of-bounds write in kbuffer_read_buffer()
Date: Wed, 18 Nov 2026 08:40:22 +0000
Message-ID: <cover.1794988946.git.frank.heimes@canonical.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Post: <mailto:linux-trace-devel@vger.kernel.org>
List-Help: <mailto:linux-trace-devel+help@vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-trace-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kbuffer_read_buffer() stores the missed events count after the copied
events, but the check whether there is room for it is wrong. If the
events fill up the destination buffer (which is the normal case, as
callers pass a buffer of the sub-buffer size), the count is written up
to 8 bytes beyond the end of the buffer, and MISSING_STORED is set
although there is no room for the count.

This was found while looking into the libtracefs unit test failures
reported here:

  https://lore.kernel.org/linux-trace-devel/39efe87bec205b7f809b8aa49db635b6465ee530.camel@canonical.com/

libtracefs uses kbuffer_read_buffer() for memory mapped ring buffers
(tracefs_cpu_read()/tracefs_cpu_write(), the latter with a buffer on
the stack). That's what makes the "trace cpu pipe" test show an
"Invalid read of size 8" in kbuffer_load_subbuffer() and random
"missed events" values under valgrind ("make test_mem").

It can be reproduced without tracing by copying a full sub-buffer with
missed events with kbuffer_read_buffer() into a malloc()ed buffer of
the sub-buffer size. Under valgrind (amd64, libtraceevent 1.9.0):

  ==2504915== Invalid write of size 8
  ==2504915==    at 0x48820FA: write_8 (kbuffer-parse.c:114)
  ==2504915==    by 0x48834A0: kbuffer_read_buffer (kbuffer-parse.c:1030)
  ==2504915==    by 0x40013F7: main (kbuf-repro.c:61)
  ==2504915==  Address 0x4ac3120 is 0 bytes after a block of size 4,096 alloc'd

and the commit field of the copy is 0xffffffffc0000ff0. With the fix
it is 0x80000ff0 and valgrind reports no errors.

Patch 1 fixes the check (and the sign extension of the flags into the
upper 32 bits of the 8 byte commit field), patch 2 adds unit tests,
which fail without patch 1:

  Test: kbuffer read buffer with missed events, full ...FAILED
    1. traceevent-utest.c:786  - *(uint64_t *)(dst + KBUF_SUBBUF_SIZE) == KBUF_GUARD
    2. traceevent-utest.c:791  - !!(commit & KBUF_MISSING_STORED) == expect_stored
    3. traceevent-utest.c:793  - (commit & ~(KBUF_COMMIT_MASK | KBUF_MISSING_EVENTS | KBUF_MISSING_STORED)) == 0
  Test: kbuffer read buffer with missed events, stored ...FAILED
    1. traceevent-utest.c:793  - (commit & ~(KBUF_COMMIT_MASK | KBUF_MISSING_EVENTS | KBUF_MISSING_STORED)) == 0

Tested on amd64 and ppc64el with the reproducer and the unit tests, and
on ppc64el with the libtracefs unit tests ("make test_mem" no longer
shows the invalid read).

Frank Heimes (2):
  kbuffer: Fix out-of-bounds write of missed events in
    kbuffer_read_buffer()
  libtraceevent utest: Add tests for kbuffer_read_buffer() with missed
    events

 src/kbuffer-parse.c      |  14 ++++--
 utest/traceevent-utest.c | 104 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 113 insertions(+), 5 deletions(-)

-- 
2.53.0


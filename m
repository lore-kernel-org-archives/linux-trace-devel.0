Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.120
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794991231;
	b=vhE41OM04UDT+tPCjzOUS06nGVf4fLDR5H7Q/tWW9YmQ2cXgN9gTwaEypzDjKg3YPglV
	 IRswkeCeTRtf2NnYFn8Ut6oiO32xd0ppq985UlajKoRdoWZmOyXoYR+fyFGv9jKKvRNE9
	 Oa2zWMgZanwSdFfioqzFQk5a9lCrqL++vGTZo35lo/wCChWHf+2KHpZr0hJL1wkHaxeLs
	 oHHDDSM5eqILaphPMlYY39HCSxUktyLWK4F+ZrV9hnlqxgDn4f+mPCy39cRi8sar2jumO
	 7MVJH0mbkP1/hjWpVjFPI4IrMXj467shtpZCIBHlykJEBYu8wk/CsNgNmlxKwMZmJ1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794991231;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=W/ou3KaESXVGvHX3LOzj8eece+EDQkorEz0rHXxOXpE=;
	b=5YJpg/QaO25BfK871yiqd/x1e8jb/8Tkrvqq7apkt98JfQuac1tuKXbIIX3l+3EGn5m/
	 ASJANCcfUXTiSHK59BVYUJlVoAV3gqwH8G4zEd6QaWmK76Nb2Bm2mt7V+60F5XoTCwdUI
	 BjrCL9F7GFU27j7SCxbcZMWgZjw41ce3rHaBWIw2BQIfYIQN75fQb4LpbvoIvBpURuaY2
	 LwzrizrGUkOwPgLCzFhbfKhyZQe0AN8Az8bo6B4a+/7d8fq+weu4NK1JiYvTiovygsDSk
	 tp6Xu2jNlzM2BUoxRPnS4Ou2ZVMU5EHO33gjmo8ulRkqFOyEbA6BzChm/i5v+7AkgfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=canonical.com;
	spf=pass smtp.mailfrom=canonical.com;
	dkim=pass header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b="MM7k/U7g";
	arc=none smtp.remote-ip=185.125.188.120
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612E8606A331
	for <linux-trace-devel@vger.kernel.org>; Wed, 18 Nov 2026 08:40:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 612E8606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=MM7k/U7g
Received: from openrouter-r.lxd (2.general.fheimes.us.vpn [10.172.66.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 1259142CD4;
	Wed, 18 Nov 2026 08:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1794991230;
	bh=W/ou3KaESXVGvHX3LOzj8eece+EDQkorEz0rHXxOXpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=MM7k/U7gxqJhaOO+WbXhyA++Mzj0VUinqVdE/GivUdyl9x06f7U003YeSPz3XyQQS
	 JizOMlqISjYeP7Obq5DXWb5eUGour+73Xf0OJfAE45lya4qnz8i7ccZ8FPF+lz1aQq
	 vPbILcq4yZn6B0hjGnx54EKNDaUsA52hsHC3Pk7ORC6uT7rNCtO8b+iLPl7r9WQCq2
	 227B2BXCQ/dvcyrP8PnzSN8U0PAnEsaVolp91BKaSdVv4m7UskU3Xdycp+ziJel9rD
	 D/4KNlgKbiSrlGZxzKTQ6e8ZKgJresoZ5UtI5k2b8Mn8L+HnjGfRH54zlo0U2dotyJ
	 hDyXVx+iqQOWnAVApo0idIgwktQw/0tcYfXuXtJodQB0PQ+riUsJf2YKdA8odn9PRX
	 l+i93MVEu3eImQ8BVB08DCYo9maYs/s4VO5Q3L58DN9ntWr6dgS55KlrF3OMJ710E9
	 L21FE5w8sAet2qIfHOo30Sq/JmLxyKfghXL2HYg3UbjZhOHXcMumVLcce7DAEVj4Mc
	 6eyC74SKyGNCLZDtUkaBxDIXzlrEtwCDvouDtblgbK+gBB8lZc+/PMJgMI/j1/3H0G
	 UD4I/kPJhgTkKOF9jU1UmMLCEhWdLzh44xCWuVu3o1k+aNf7Lmb/9oEM29nMpbfYD9
	 V4T0r6lKKy6C7b0QDlaNv55Q=
From: Frank Heimes <frank.heimes@canonical.com>
To: linux-trace-devel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Benjamin Drung <benjamin.drung@canonical.com>,
	Jamie Dolan <jldolan@us.ibm.com>
Subject: [PATCH 2/2] libtraceevent utest: Add tests for kbuffer_read_buffer() with missed events
Date: Wed, 18 Nov 2026 08:40:24 +0000
Message-ID: <f7eba80f155db02863a6fdd8814cd200b9155d2e.1794988946.git.frank.heimes@canonical.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1794988946.git.frank.heimes@canonical.com>
References: <cover.1794988946.git.frank.heimes@canonical.com>
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

Add tests that copy a sub-buffer with missed events with
kbuffer_read_buffer() into a buffer of the sub-buffer size:

 - for a full sub-buffer, where there is no room to store the missed
   events count, nothing must be written past the end of the buffer
   and MISSING_STORED must not be set.

 - for a sub-buffer with room left, the missed events count must be
   stored and be read back by kbuffer_load_subbuffer().

Signed-off-by: Frank Heimes <frank.heimes@canonical.com>
---
 utest/traceevent-utest.c | 104 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 104 insertions(+)

diff --git a/utest/traceevent-utest.c b/utest/traceevent-utest.c
index 25dceb5..f181ff9 100644
--- a/utest/traceevent-utest.c
+++ b/utest/traceevent-utest.c
@@ -26,6 +26,7 @@
 
 #include "event-parse.h"
 #include "trace-seq.h"
+#include "kbuffer.h"
 
 #define TRACEEVENT_SUITE	"traceevent library"
 
@@ -715,6 +716,105 @@ static void test_btf_read(void)
 	CU_TEST(strcmp(s->buffer, expected) == 0);
 }
 
+#define KBUF_SUBBUF_SIZE	4096
+#define KBUF_HDR_SIZE		16	/* 8 byte timestamp + 8 byte commit */
+#define KBUF_MISSING_EVENTS	(1ULL << 31)
+#define KBUF_MISSING_STORED	(1ULL << 30)
+#define KBUF_COMMIT_MASK	((1ULL << 27) - 1)
+#define KBUF_GUARD		0xdeadbeefdeadbeefULL
+
+/*
+ * Create a sub-buffer with @data_size bytes of 8 byte events, and the
+ * missed events flag set. If @lost is non-negative, it is stored after
+ * the events.
+ */
+static void kbuf_fill_subbuf(void *subbuf, unsigned int data_size, long long lost)
+{
+	uint64_t commit = data_size | KBUF_MISSING_EVENTS;
+	uint32_t one = 1;
+	bool big_endian = *(uint8_t *)&one == 0;
+	unsigned int i;
+
+	memset(subbuf, 0, KBUF_SUBBUF_SIZE);
+	*(uint64_t *)subbuf = 1000;
+
+	for (i = 0; i < data_size; i += 8) {
+		/* type_len = 1 (4 bytes of data), time delta = 1 */
+		uint32_t type_len_ts = big_endian ? (1 << 27) | 1 : (1 << 5) | 1;
+		uint32_t payload = i;
+
+		memcpy(subbuf + KBUF_HDR_SIZE + i, &type_len_ts, 4);
+		memcpy(subbuf + KBUF_HDR_SIZE + i + 4, &payload, 4);
+	}
+
+	if (lost >= 0) {
+		*(uint64_t *)(subbuf + KBUF_HDR_SIZE + data_size) = lost;
+		commit |= KBUF_MISSING_STORED;
+	}
+	*(uint64_t *)(subbuf + 8) = commit;
+}
+
+static void test_kbuffer_read_buffer_missed(unsigned int data_size, long long lost,
+					    bool expect_stored)
+{
+	struct kbuffer *kbuf;
+	uint64_t commit;
+	void *src, *dst;
+	int ret;
+
+	kbuf = kbuffer_alloc(KBUFFER_LSIZE_8, KBUFFER_ENDIAN_SAME_AS_HOST);
+	CU_TEST(kbuf != NULL);
+	src = malloc(KBUF_SUBBUF_SIZE);
+	/* Add a guard after the sub-buffer to detect writes beyond it */
+	dst = malloc(KBUF_SUBBUF_SIZE + sizeof(uint64_t));
+	CU_TEST(src != NULL && dst != NULL);
+	if (!kbuf || !src || !dst)
+		goto out;
+
+	kbuf_fill_subbuf(src, data_size, lost);
+	memset(dst, 0, KBUF_SUBBUF_SIZE);
+	*(uint64_t *)(dst + KBUF_SUBBUF_SIZE) = KBUF_GUARD;
+
+	ret = kbuffer_load_subbuffer(kbuf, src);
+	CU_TEST(ret == 0);
+	CU_TEST(kbuffer_missed_events(kbuf) == (lost >= 0 ? lost : -1));
+
+	ret = kbuffer_read_buffer(kbuf, dst, KBUF_SUBBUF_SIZE);
+	CU_TEST(ret == (int)data_size);
+
+	/* Nothing may be written past the end of the buffer */
+	CU_TEST(*(uint64_t *)(dst + KBUF_SUBBUF_SIZE) == KBUF_GUARD);
+
+	commit = *(uint64_t *)(dst + 8);
+	CU_TEST((commit & KBUF_COMMIT_MASK) == data_size);
+	CU_TEST((commit & KBUF_MISSING_EVENTS) != 0);
+	CU_TEST(!!(commit & KBUF_MISSING_STORED) == expect_stored);
+	/* Only the commit size and flags may be set */
+	CU_TEST((commit & ~(KBUF_COMMIT_MASK | KBUF_MISSING_EVENTS |
+			    KBUF_MISSING_STORED)) == 0);
+
+	/* The copy must be loadable and keep the missed events */
+	ret = kbuffer_load_subbuffer(kbuf, dst);
+	CU_TEST(ret == 0);
+	CU_TEST(kbuffer_missed_events(kbuf) == (expect_stored ? lost : -1));
+ out:
+	kbuffer_free(kbuf);
+	free(src);
+	free(dst);
+}
+
+static void test_kbuffer_read_buffer_missed_full(void)
+{
+	/* A full sub-buffer has no room to store the missed events count */
+	test_kbuffer_read_buffer_missed(KBUF_SUBBUF_SIZE - KBUF_HDR_SIZE, -1, false);
+}
+
+static void test_kbuffer_read_buffer_missed_stored(void)
+{
+	/* With enough room, the missed events count is stored */
+	test_kbuffer_read_buffer_missed(KBUF_SUBBUF_SIZE - KBUF_HDR_SIZE - 80, 42, true);
+}
+
 static int test_suite_destroy(void)
 {
 	tep_free(test_tep);
@@ -784,4 +884,8 @@ void test_traceevent_lib(void)
 		    test_parse_dma_addr);
 	CU_add_test(suite, "read BTF",
 		    test_btf_read);
+	CU_add_test(suite, "kbuffer read buffer with missed events, full",
+		    test_kbuffer_read_buffer_missed_full);
+	CU_add_test(suite, "kbuffer read buffer with missed events, stored",
+		    test_kbuffer_read_buffer_missed_stored);
 }
-- 
2.53.0


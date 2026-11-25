Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.121
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795588923;
	b=ZJAednfdKcdVfMPtBmmMw9mFh6bTedZCkw6f9K9IsSDFy0RBHvXhBJ/Z5goKzXxHp1sy
	 fgKy4n80UoL4VG7bA9iGg28DTGRxts4ldpNOvaatams7xJHRP8QIU2GFkBSBXI6JpUWs4
	 ohUxpxYkn/61ssnkaDyRZzFhiLPZtJeA1TkHs4Hj4LTC4b0xfUeEdfDLxwGKu5L/7Mcyu
	 AaErj6ShdIXPCdTpQ1wXi8AwD7/pc62JI4A2OjJj/zXRcCuc6PB3trp8X8faBFSTxNyS1
	 6/dQPd5PzxCjBgOU7C1KILNPOBmbIT3vyiouHONqUNb/jV4L7o6esCZuQh8EY8psbiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795588923;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=Rk6VtQina46+Iizjy4FNPNxLOiNAtsVPr/zYIOariyA=;
	b=e5SSKOM8jt55H2je7AUxLzH6aNnbQ8Fhe9QePlVq6wgmamA8yu/pmp2EqkP9o4MmbCDc
	 Ax5o4ZwGMdblsz9Cln8WMlwvsoUwnbiLOS5icjMRgreRTg4+pBPRVe+zNjnrrCcB7DURB
	 o904/OhmGSq2Jfjjm0FiX7E2ASXZfS7XnXyM048P63+NCpFDpkl8K64o2FqRg35dQaLpD
	 aEcb9uhKdmAiMclBqtIlbRPWUiVhaIPjQTdjEGBj6FD2ToGsvH8549prp8o+prHFHL+mD
	 /RU6jmXYh37p5irCVvYIe/1GNY3tg6iCNKqxxiqe5ilGEEhwc/dUw1R1Hug5LhLur4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=canonical.com;
	spf=pass smtp.mailfrom=canonical.com;
	dkim=pass header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=G1C6cjOq;
	arc=none smtp.remote-ip=185.125.188.121
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5B2606A330
	for <linux-trace-devel@vger.kernel.org>; Wed, 25 Nov 2026 06:42:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8C5B2606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=G1C6cjOq
Received: from openrouter-r.lxd (2.general.fheimes.us.vpn [10.172.66.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 14DD73F697;
	Wed, 25 Nov 2026 06:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1795588915;
	bh=Rk6VtQina46+Iizjy4FNPNxLOiNAtsVPr/zYIOariyA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version;
	b=G1C6cjOqp+H6n2Tyj7GC0t0nKw1ssO87DgCJ6b92jq/DhwN6sw4r34K65lHlhGM4Y
	 RPnLLifkgUErCB28KilYUCPBt+TtCjST10qp8mOF0xhDbODhiICKHFoiIfzYXIkQfO
	 lh8C4bsbqvx3RPQzx6dabU0Gs7yYzn6JbpJ4JvCHdAk2BPpm2aMdn6/mJsSmupGc4A
	 K+KLCAjBIOY9BCv+YKqEMX0yR0yThQPRpQNN+s7VNvX6cJ9uXeHgdEa2YQMRS2sZTT
	 mNiQPLGO02zwRWrV2ocVpEztfyq9qDnP+FZZ8pi0Kj5+Qda4HP0Ewrz/1noEgFdw6a
	 +07N4/h2BZmFfX8RCACYkCj84+e4d+tnV6GTfy+hAIznLhY1mLon4bTmSWGl6E9+eg
	 l1T7RjhSF+BVYGaTW4tmb8j9WHAdZPkF9/DmIuoIpCul6uhy9m7Z49LcqCVTIu90UT
	 kz8BlLUe3G4c7WaRU0RWOJcxBgv+kOOv5G8Jm2lLdWee/OlHYpUbhSqHhNNaZLe2R1
	 dctI/S9AvevM6mDyrWyRN9Q9IrUI6ySrsFdHuAuHFLWF+ZLAJEm5gC2MOo88fPqoF+
	 8qfIHYysZYiWk7DA9ePNorD57liH/wsLvopZGD6Y/mjTR+bwPWankkW143GPMbV4HE
	 Qi58TrMeM1eRj5yjOXKV581w=
From: Frank Heimes <frank.heimes@canonical.com>
To: linux-trace-devel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Benjamin Drung <benjamin.drung@canonical.com>,
	Jamie Dolan <jldolan@us.ibm.com>
Subject: [PATCH] libtraceevent: Accept BTF headers without the layout section
Date: Wed, 25 Nov 2026 06:41:51 +0000
Message-ID: <20261125064151.2219-1-frank.heimes@canonical.com>
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

tep_load_btf() rejects BTF if the header length is smaller than
sizeof(struct btf_header). But the size of that structure depends on the
version of the kernel headers libtraceevent is built with: newer headers
added the layout_off and layout_len fields (32 bytes in total), while the
BTF of kernels without a layout section has the 24 bytes header.

So if libtraceevent is built against newer kernel headers, it can not load
the BTF of such kernels at all:

  Header (24) smaller than expected header 32

This also makes the "read BTF" unit test fail, for example on amd64 with
linux-libc-dev 7.3 and a 6.17 kernel, or on ppc64el with a 7.3 kernel
whose BTF has no layout section:

  Test: read BTF ...FAILED
    1. traceevent-utest.c:692  - tep_load_btf(test_tep, buf, st.st_size) == 0
    2. traceevent-utest.c:715  - strcmp(s->buffer, expected) == 0

The check is there since the BTF support was added (first released in
1.9.0), but with 1.9.1 it also hits build environments where mmap() of the
BTF file fails, like chroots: since 5b44859765fc ("libtraceevent utest: Read
btf file in utest if mmap fails") the test no longer skips in that case, but
loads the file. In Ubuntu this made the build of libtraceevent 1.9.1 fail on
arm64, armhf, ppc64el and s390x, as the unit tests are run during the build.

Only the fields up to str_len are used, so only require these, no matter
how the kernel headers define struct btf_header.

Fixes: 87f30d98e3cd ("libtraceevent: Add loading of BTF to the tep handle")
Link: https://bugs.launchpad.net/bugs/2172071
Signed-off-by: Frank Heimes <frank.heimes@canonical.com>
---

Notes:
    Found while updating libtraceevent to 1.9.1 in Ubuntu 27.04 (tenacious,
    linux-libc-dev 7.3): the "read BTF" unit test failed on arm64, armhf,
    ppc64el and s390x (the build runs the unit tests), and also on amd64 when
    the build chroot can read /sys/kernel/btf/vmlinux.
    
    Tested on top of 1.9.1 (master) with linux-libc-dev 7.3, on amd64 (6.17
    kernel) and ppc64el (7.3 kernel, 64K pages), tep_load_btf() of
    /sys/kernel/btf/vmlinux:
    
      before:  Header (24) smaller than expected header 32
               tep_load_btf() = -1,  "read BTF" FAILED, 19/20 unit tests pass
      after:   tep_load_btf() = 0,   "read BTF" passed, 20/20 unit tests pass
    
    I can also send a unit test for this that does not depend on the BTF of
    the machine it runs on, if that is wanted.

 src/trace-btf.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/src/trace-btf.c b/src/trace-btf.c
index 2d66e01..333470c 100644
--- a/src/trace-btf.c
+++ b/src/trace-btf.c
@@ -6,6 +6,7 @@
  */
 #include <stdio.h>
 #include <stdlib.h>
+#include <stddef.h>
 #include <stdbool.h>
 
 #include <linux/btf.h>
@@ -17,6 +18,15 @@
 struct btf_header;
 struct btf_type;
 
+/*
+ * Minimum length of a BTF header: all the fields that are used here.
+ * More fields can be added at the end of struct btf_header (the kernel
+ * added layout_off and layout_len), and the BTF of kernels that do not have
+ * them has a smaller header. Do not use sizeof(struct btf_header), as it
+ * depends on the version of the kernel headers this is built with.
+ */
+#define BTF_HDR_MIN_LEN	(offsetof(struct btf_header, str_len) + sizeof(__u32))
+
 struct tep_btf {
 	struct btf_header	*hdr;
 	const char		*strings;
@@ -257,9 +267,9 @@ static struct tep_btf *btf_init(void *raw_data, size_t data_size)
 		goto fail;
 	}
 
-	if (btf->hdr->hdr_len < sizeof(*btf->hdr)) {
+	if (btf->hdr->hdr_len < BTF_HDR_MIN_LEN) {
 		tep_warning("Header (%d) smaller than expected header %zd",
-			    btf->hdr->hdr_len, sizeof(*btf->hdr));
+			    btf->hdr->hdr_len, BTF_HDR_MIN_LEN);
 		goto fail;
 	}
 
-- 
2.53.0


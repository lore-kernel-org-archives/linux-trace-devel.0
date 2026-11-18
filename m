Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.121
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795008666;
	b=t4h+G3vc2f/hul4dFfVAy4H2Atn/CeYJB/Tua7sqaOdpylIhjDmS4NsVO1p2O9oy8WGH
	 Tq16cTkzhlRoFFYqi7JbHl90fMDvqLrj4ztRHek9dGNOkJh3bUFCPNsbu9HRFD+KDm9b6
	 NjYXKx2yaj5GBsCVdakL2mcRBu2tuiMvwWJRg5dbEFjDOM0010dA4g9UcVzhKow9EXgTy
	 7mrXH8QW77CCTElSzuXP7eNYayaye0Ts3DEs3trTUyLLfKoJFyGL8Crf4D4zs1VkXilJD
	 D3Dq5U30GLunfJXIuUJQ8p8bGexej/I+pbqN7kewj/8RidI22k/Ol6H9HNOCGmIwccA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795008666;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=kU36FDTIWWAnMVxmMDmno6b/qPxwPeEpc+Ea/BLpqhQ=;
	b=Vmi6FBlqUmUKi0749Py0cL09NXFm5DZTNUQn/QnLcJIu2Cw7hwu+Jcsrg+zeeiYXeR9A
	 sEYEA5UECnKjVo1ZCpoWZ4R/zAJB0XSe4e8pstv8FEJuON6PklI7ewgltCt6JcyjI0m9Z
	 zoKomHzD6DrtdkRAOiAynhnwbKEfJBJhgpcQkizz5VDIaQX6Pnne2aWO0efSpv6Vo1wwd
	 kfzXM1yBn5KfZ55Immj3Ql3085d7pzEtn+jn3lCZV9iYJdFLcL7yibuDjqOtc8dJD6R9L
	 5L+bzoAQxvxrzPBUwnEACgr9HucgyhRq1mGP242bMPSlk/bQvwABTbMhyFLOA5G7yqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=canonical.com;
	spf=pass smtp.mailfrom=canonical.com;
	dkim=pass header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=K4sk+LPh;
	arc=none smtp.remote-ip=185.125.188.121
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566F2606A325
	for <linux-trace-devel@vger.kernel.org>; Wed, 18 Nov 2026 13:31:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 566F2606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=K4sk+LPh
Received: from openrouter-r.lxd (2.general.fheimes.us.vpn [10.172.66.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 45ABA3FC3A;
	Wed, 18 Nov 2026 13:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1795008659;
	bh=kU36FDTIWWAnMVxmMDmno6b/qPxwPeEpc+Ea/BLpqhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=K4sk+LPhIaIwKxXhYgvNhMZW8B6SsBkb3L1lrysXAH8OGq92o2QIEvxFip7vFsdEq
	 dGR2/JJ1/X9pzM5Go2itHC5G5XEHnu7hQicHGDwIm68XuRW483+xSADUFU7FzHAeDv
	 lx7Z7Z2f0aGCUlMkrkj8pWTdOPdIAQAIIILfwDFmsufyUPNw0eb0+JGPO6UZRsCgui
	 H0I/ZxbxNhRRnaNRtg5THm3zGn8fohYssUI5nkWyokfbjO/EgSJTJmyoGsqaTNaW39
	 0Hw5b1HlMKk8vIg+XoD+Qk2z8DpqGUnp9UtR+TYYF3JhLDacUZT4rAXs5afPEWfH5v
	 yMa7bAB7GL0tRjtcCto8VokTTCvvzfFy5LcqKsnQw/+CjH4XqjUq4pIsVd8kfNVZOh
	 NRQq8CGxXzy1rJcNaqRdSWibV46nLDf12LTC8VHMk/1xSzR0eHKtHxM7cIqIiJBrWX
	 uKiU7UOv1z0AUW4u85GuXi92MahTswlQT+6oOvS9YTmgSj58rSBlrOpSEpnLF0kfcj
	 9n3lNZvK9z2ALpJVqVyS7zld+0v9CZCo3XPouBTnOm2NGjzZlguEO/DqEqpt9Le0nZ
	 pfB3uJ9kdY0tK+18PB0KkXGbi8HpuGFR64p+Q/25eVMxJhqrOB+O2tWIddw8E7AajG
	 YApqTSf++UwsLkGaD4BObrwU=
From: Frank Heimes <frank.heimes@canonical.com>
To: linux-trace-devel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Benjamin Drung <benjamin.drung@canonical.com>,
	Jamie Dolan <jldolan@us.ibm.com>
Subject: [PATCH 2/3] libtracefs utest: Run valgrind memory test with fair scheduling
Date: Wed, 18 Nov 2026 13:30:52 +0000
Message-ID: <207efd3b5c79694da68e3418f2d84da8ee3fec1b.1795008447.git.frank.heimes@canonical.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1795008446.git.frank.heimes@canonical.com>
References: <cover.1795008446.git.frank.heimes@canonical.com>
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

valgrind serializes the threads of the program under test with a lock
that, by default, is not handed out fairly. A thread that never blocks
can therefore get the lock again and again, starving the other threads.

The "trace pid events filter" and "trace pid function filter" tests
start two threads that spin calling getppid() until the main thread
sets data->stop after msleep(100). Under valgrind the spinning threads
can starve the main thread, so data->stop is never set and the test
hangs until the test runner times out. This is reproducible on ppc64el
where make test_mem hangs in "trace pid events filter" for hours.

Run valgrind with --fair-sched=yes, which makes valgrind schedule the
threads in a round-robin fashion.

Link: https://bugs.launchpad.net/bugs/2172071
Signed-off-by: Frank Heimes <frank.heimes@canonical.com>
---
 Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile b/Makefile
index 20ae41f..b9f3853 100644
--- a/Makefile
+++ b/Makefile
@@ -217,6 +217,7 @@ ifneq ($(shell id -u), 0)
 	$(error "The unit test should be run as root, as it reuqires full access to tracefs")
 endif
 	CK_FORK=no LD_LIBRARY_PATH=$(bdir) $(VALGRIND) \
+		--fair-sched=yes \
 		--show-leak-kinds=all --leak-resolution=high \
 		--leak-check=full --show-possibly-lost=yes \
 		--track-origins=yes -s \
-- 
2.53.0

